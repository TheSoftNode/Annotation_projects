#include <arm_neon.h>
#include <concepts>
#include <cstddef>
#include <bit>
#include <type_traits>
#include <array>
#include <cstring>
#include <iostream>
#include <climits>

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

// ============ RESPONSE 1 EXTENSION STARTS HERE ============

// ------ 4-bit integer type (represented as int8_t with 4-bit range) ------
struct int4_t {
    int8_t value;

    // Construct from int8_t, clamp to [-8, 7]
    constexpr explicit int4_t(int8_t v) : value{ v < -8 ? -8 : (v > 7 ? 7 : v) } {}

    constexpr operator int8_t() const { return value; }

    // Extract 4 bits from byte (packed format)
    static constexpr int4_t extract(int8_t byte, int index) {
        int offset = index * 4;
        int8_t nibble = (byte >> offset) & 0x0F;
        if (nibble >= 8) nibble -= 16; // sign extend
        return int4_t(nibble);
    }

    // Pack two int4 values into one byte
    static constexpr int8_t pack(int4_t a, int4_t b) {
        return static_cast<int8_t>((static_cast<uint8_t>(b.value & 0x0F) << 4) |
                                  (static_cast<uint8_t>(a.value & 0x0F)));
    }
};

// ------ 8-byte container for 16 int4 values ------
struct int4x8 {
    int8_t bytes[8];

    // Decode to bundle<int8_t, 16>
    static constexpr bundle<int8_t, 16> decode(int4x8 self) {
        alignas(16) int8_t lanes[16];

        // Unpack 16 values (each byte has 2 int4)
        for (int i = 0; i < 16; i++) {
            lanes[i] = int4_t::extract(self.bytes[i / 2], i % 2);
        }

        // Convert to float32x16? No: we want int8x16
        // Use NEON to build int8x16
        int8x16_t v = {{
            lanes[0], lanes[1], lanes[2], lanes[3],
            lanes[4], lanes[5], lanes[6], lanes[7],
            lanes[8], lanes[9], lanes[10], lanes[11],
            lanes[12], lanes[13], lanes[14], lanes[15]
        }};

        // Reinterpret as float32x4x4_t for bundle<int8_t,16>
        float32x4x4_t b;
        // But we need to use int8x16x1_t — wait: bundle<int8_t,16> expects int8x16x1_t

        int8x16x1_t result;
        result.val[0] = v;
        return bundle<int8_t, 16>(result);
    }

    // Encode from bundle<int8_t, 16>
    static constexpr void encode(int8_t& dst, const bundle<int8_t, 16>& src) {
        alignas(16) int8_t lanes[16];
        int8x16x1_t v = src;
        vst1q_s8(lanes, v.val[0]);

        int4x8 out{};
        for (int i = 0; i < 16; i++) {
            int4x8::extract_and_pack(out.bytes, lanes[i], i);
        }

        // Copy back
        std::memcpy(&dst, out.bytes, sizeof(int4x8));
    }

    // Helper: pack two int4 values into one byte
    static void extract_and_pack(int8_t* bytes, int8_t value, int index) {
        int byte_index = index / 2;
        int offset = (index % 2) * 4;
        int4_t v{value};

        int8_t high = (v.value >= 0) ? v.value : (16 + v.value);
        if (offset == 0) {
            bytes[byte_index] = (bytes[byte_index] & 0xF0) | high;
        } else {
            bytes[byte_index] = (bytes[byte_index] & 0x0F) | (high << 4);
        }
    }
};

// ============ RESPONSE 1 USAGE EXAMPLE ============

int main() {
    // Create a normal float vector
    auto f32 = float32x16::broadcast(1.5f);

    // Convert to int8 (truncate)
    auto i8 = int8x16::broadcast(1); // just an example

    // Pack into int4x8 (8 bytes)
    int4x8 packed{};
    int8x16::store<int4x8>(&packed, i8); // compress 16 int8 → 8 bytes

    // Unpack back
    auto unpacked = int8x16::load<int4x8>(&packed); // 16 int8

    // Print first few values
    std::cout << static_cast<int>(unpacked[0]) << ", "
              << static_cast<int>(unpacked[1]) << "\n";
    // Should show 1, 1 (if original was 1)

    return 0;
}
