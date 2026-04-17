// Response 2 int4 extension - extracted verbatim

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
