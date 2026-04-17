#include <arm_neon.h>
#include <concepts>
#include <cstddef>
#include <bit>
#include <type_traits>
#include <array>
#include <cstring>
#include <iostream>

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

int main() {
    // Broadcast
    auto a = float32x16::broadcast(3.14f);

    // Raw load/store
    alignas(16) float data[16];
    a.store<float>(data);
    std::cout << data[0] << "\n"; // 3.14

    return 0;
}
