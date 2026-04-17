// Response 1 int4 extension - extracted verbatim
// This should be added to the base bundle code

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
