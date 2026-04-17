#include <arm_neon.h>
#include <concepts>
#include <cstddef>
#include <bit>
#include <type_traits>
#include <array>
#include <cstring>
#include <iostream>
#include <iomanip>

// Type aliases (ensure fixed-width types)
using float32_t = float;
using float16_t = __fp16;
using int16_t = short;
using int8_t = signed char;

// Forward declaration
template<typename ValueType, size_t Lanes = 16>
struct bundle;

// Helper trait to get NEON vector type for 16 lanes
template<typename T>
consteval auto get_vector_type() {
    if constexpr (std::is_same_v<T, float32_t>) {
        return float32x4x4_t{};  // 4x float32x4 = 16 floats
    } else if constexpr (std::is_same_v<T, float16_t>) {
        return float16x8x2_t{};  // 2x float16x8 = 16 halfs
    } else if constexpr (std::is_same_v<T, int16_t>) {
        return int16x8x2_t{};    // 2x int16x8 = 16 shorts
    } else if constexpr (std::is_same_v<T, int8_t>) {
        return int8x16x1_t{};    // 1x int8x16 = 16 bytes
    } else {
        static_assert(sizeof(T) == 0, "Unsupported ValueType for bundle");
    }
}

template<typename ValueType>
using vector_type_for = decltype(get_vector_type<ValueType>());

// Main bundle struct
template<typename ValueType>
struct bundle<ValueType, 16> {
    using value_type = ValueType;
    using vector_type = vector_type_for<ValueType>;
    static constexpr size_t lanes = 16;
    static constexpr size_t element_size = sizeof(ValueType);
    static constexpr size_t total_size = lanes * element_size;

private:
    vector_type vec;

public:
    // Default constructor (uninitialized)
    bundle() = default;

    // Allow implicit conversion from vector_type
    bundle(vector_type v) : vec(v) {}

    // Assignment from vector_type
    bundle& operator=(vector_type v) {
        vec = v;
        return *this;
    }

    // Conversion operator
    operator vector_type() const { return vec; }

    // Broadcast
    static bundle broadcast(value_type value) {
        if constexpr (std::is_same_v<ValueType, float32_t>) {
            auto v = vdupq_n_f32(value);
            return { { v, v, v, v } }; // float32x4x4_t
        } else if constexpr (std::is_same_v<ValueType, float16_t>) {
            auto v = vdupq_n_f16(value);
            return { { v, v } }; // float16x8x2_t
        } else if constexpr (std::is_same_v<ValueType, int16_t>) {
            auto v = vdupq_n_s16(static_cast<int16_t>(value));
            return { { v, v } }; // int16x8x2_t
        } else if constexpr (std::is_same_v<ValueType, int8_t>) {
            auto v = vdupq_n_s8(static_cast<int8_t>(value));
            return { { v } }; // int8x16x1_t
        }
    }

    // Load from aligned or unaligned memory (generic T encoding)
    template<typename T>
    static bundle load(void* src) {
        auto* ptr = static_cast<T*>(src);
        if consteval {
            // Custom encoding: let T define how to decode into bundle<ValueType>
            return T::template decode<ValueType>(*ptr);
        } else {
            // Default: raw bit copy from memory (T must be same size/layout)
            bundle b;
            std::memcpy(&b.vec, ptr, total_size);
            return b;
        }
    }

    // Store to memory (generic T encoding)
    template<typename T>
    void store(void* dst) const {
        auto* ptr = static_cast<T*>(dst);
        if consteval {
            // Custom encoding: let T define how to encode from bundle<ValueType>
            T::template encode<ValueType>(*ptr, *this);
        } else {
            // Default: raw bit copy
            std::memcpy(ptr, &vec, total_size);
        }
    }

    // Lane access (slow, for debugging only)
    value_type operator[](int lane) const {
        alignas(16) std::array<value_type, lanes> temp;
        if constexpr (std::is_same_v<ValueType, float32_t>) {
            auto& v = vec;
            vst1q_lane_f32(temp.data() + 0,  v.val[0], 0);
            vst1q_lane_f32(temp.data() + 1,  v.val[0], 1);
            vst1q_lane_f32(temp.data() + 2,  v.val[0], 2);
            vst1q_lane_f32(temp.data() + 3,  v.val[0], 3);
            vst1q_lane_f32(temp.data() + 4,  v.val[1], 0);
            // ... continue for all 16
            // Alternatively, use vst4q_f32 for float32x4x4_t
            vst4q_f32(temp.data(), vec);
        } else if constexpr (std::is_same_v<ValueType, float16_t>) {
            vst2q_f16(temp.data(), vec);
        } else if constexpr (std::is_same_v<ValueType, int16_t>) {
            vst2q_s16(reinterpret_cast<int16_t*>(temp.data()), vec);
        } else if constexpr (std::is_same_v<ValueType, int8_t>) {
            vst1q_s8(temp.data(), vec.val[0]);
        }
        return temp[lane];
    }
};

// Convenience aliases
using float32x16 = bundle<float32_t>;
using float16x16 = bundle<float16_t>;
using int16x16  = bundle<int16_t>;
using int8x16   = bundle<int8_t>;

// ============ RESPONSE 2 EXTENSION STARTS HERE ============

struct int4x8 {
    std::byte data[8];  // Each byte holds two 4-bit signed integers (low 4 bits, high 4 bits)

    // Helper: extract signed 4-bit value from a nibble (sign-extend)
    static constexpr int8_t load_nibble(uint8_t nibble) {
        int8_t val = static_cast<int8_t>(nibble & 0xF);
        return (val & 0x8) ? (val | 0xF0) : val;  // Sign extend 4-bit to 8-bit
    }

    // Helper: pack int8_t into 4-bit (clamp and truncate)
    static constexpr uint8_t store_nibble(int8_t val) {
        int8_t clamped = (val < -8) ? -8 : (val > 7 ? 7 : val);
        return static_cast<uint8_t>(clamped & 0xF);
    }

    // Decode into bundle<int8_t, 16>: unpack 16 int4 values into 16 int8_t
    template<typename ValueType>
    static bundle<ValueType> decode(const int4x8& src) {
        static_assert(std::is_same_v<ValueType, int8_t>, "int4x8 can only decode into bundle<int8_t>");

        alignas(16) int8_t unpacked[16];

        for (int i = 0; i < 8; ++i) {
            uint8_t byte = static_cast<uint8_t>(src.data[i]);
            unpacked[2*i + 0] = load_nibble(byte & 0x0F);       // low nibble
            unpacked[2*i + 1] = load_nibble((byte >> 4) & 0x0F); // high nibble
        }

        // Load into NEON vector: int8x16x1_t
        int8x16_t vec = vld1q_s8(unpacked);
        return { { vec } };
    }

    // Encode from bundle<int8_t, 16> into int4x8
    template<typename ValueType>
    static void encode(int4x8& dst, const bundle<ValueType>& src) {
        static_assert(std::is_same_v<ValueType, int8_t>, "int4x8 can only encode from bundle<int8_t>");

        alignas(16) int8_t temp[16];
        vst1q_s8(temp, src.vec.val[0]);  // Extract all 16 values

        for (int i = 0; i < 8; ++i) {
            int8_t lo = temp[2*i + 0];
            int8_t hi = temp[2*i + 1];
            uint8_t packed =
                (store_nibble(lo)) |
                (store_nibble(hi) << 4);
            dst.data[i] = std::byte{packed};
        }
    }
};

// ============ RESPONSE 2 USAGE EXAMPLE ============

int main() {
    // Create test data: 16 int4 values (in range [-8,7])
    int4x8 packed;
    std::array<int8_t, 16> expected = {
        1, -1, 2, -2, 3, -3, 4, -4,
        5, -5, 6, -6, 7, -7, -8, 0
    };

    // Pack into int4x8
    for (int i = 0; i < 8; ++i) {
        uint8_t lo = int4x8::store_nibble(expected[2*i + 0]);
        uint8_t hi = int4x8::store_nibble(expected[2*i + 1]);
        packed.data[i] = std::byte{(hi << 4) | lo};
    }

    // Decode into SIMD bundle
    auto vec = bundle<int8_t>::load<int4x8>(&packed);

    // Extract and verify
    for (int i = 0; i < 16; ++i) {
        int8_t val = vec[i];
        std::cout << std::setw(3) << (int)val << " ";
        if ((i+1) % 8 == 0) std::cout << "\n";
    }

    // Modify and re-pack
    for (int i = 0; i < 16; ++i) {
        vec[i] = static_cast<int8_t>(-vec[i]); // negate
    }

    int4x8 packed2;
    vec.store<int4x8>(&packed2);

    // Verify round-trip
    auto vec2 = bundle<int8_t>::load<int4x8>(&packed2);
    std::cout << "Negated:\n";
    for (int i = 0; i < 16; ++i) {
        std::cout << std::setw(3) << (int)vec2[i] << " ";
        if ((i+1) % 8 == 0) std::cout << "\n";
    }

    return 0;
}
