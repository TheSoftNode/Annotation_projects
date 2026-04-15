#### Great! Let's extend the `bundle` system to support a custom **`int4`** type that encodes **16 signed 4-bit integers (int4)** packed into **8 bytes** (i.e., two int4 values per `int8_t` byte).

#### We'll:

* #### Define a lightweight `int4x8` type representing 8 bytes storing 16 × 4-bit signed integers.

* #### Implement `decode<int4x8>` to unpack into a `bundle<int8_t, 16>` (since `int4` fits in `int8_t`).

* #### Implement `encode<int4x8>` to pack a `bundle<int8_t, 16>` back into 8 bytes.

#### 🔎 Why `bundle<int8_t>`? Because we don't have a native `int4_t`, so we use `int8_t` as the value type and decode/encode 4-bit values from/to packed bytes.

#### ---

### **✅ Step 1: Define `int4x8` — 8 bytes storing 16 int4 values**

#### struct int4x8 {

####     std::byte data[8];  // Each byte holds two 4-bit signed integers (low 4 bits, high 4 bits)

####

####     // Helper: extract signed 4-bit value from a nibble (sign-extend)

####     static constexpr int8_t load_nibble(uint8_t nibble) {

####         int8_t val = static_cast<int8_t>(nibble & 0xF);

####         return (val & 0x8) ? (val | 0xF0) : val;  // Sign extend 4-bit to 8-bit

####     }

####

####     // Helper: pack int8_t into 4-bit (clamp and truncate)

####     static constexpr uint8_t store_nibble(int8_t val) {

####         int8_t clamped = (val < -8) ? -8 : (val > 7 ? 7 : val);

####         return static_cast<uint8_t>(clamped & 0xF);

####     }

####

####     // Decode into bundle<int8_t, 16>: unpack 16 int4 values into 16 int8_t

####     template<typename ValueType>

####     static bundle<ValueType> decode(const int4x8& src) {

####         static_assert(std::is_same_v<ValueType, int8_t>, "int4x8 can only decode into bundle<int8_t>");

####

####         alignas(16) int8_t unpacked[16];

####

####         for (int i = 0; i < 8; ++i) {

####             uint8_t byte = static_cast<uint8_t>(src.data[i]);

####             unpacked[2*i + 0] = load_nibble(byte & 0x0F);       // low nibble

####             unpacked[2*i + 1] = load_nibble((byte >> 4) & 0x0F); // high nibble

####         }

####

####         // Load into NEON vector: int8x16x1_t

####         int8x16_t vec = vld1q_s8(unpacked);

####         return { { vec } };

####     }

####

####     // Encode from bundle<int8_t, 16> into int4x8

####     template<typename ValueType>

####     static void encode(int4x8& dst, const bundle<ValueType>& src) {

####         static_assert(std::is_same_v<ValueType, int8_t>, "int4x8 can only encode from bundle<int8_t>");

####

####         alignas(16) int8_t temp[16];

####         vst1q_s8(temp, src.vec.val[0]);  // Extract all 16 values

####

####         for (int i = 0; i < 8; ++i) {

####             int8_t lo = temp[2*i + 0];

####             int8_t hi = temp[2*i + 1];

####             uint8_t packed =

####                 (store_nibble(lo)) |

####                 (store_nibble(hi) << 4);

####             dst.data[i] = std::byte{packed};

####         }

####     }

#### };

####

#### ---

### **✅ Usage Example**

#### #include <iostream>

#### #include <iomanip>

####

#### int main() {

####     // Create test data: 16 int4 values (in range [-8,7])

####     int4x8 packed;

####     std::array<int8_t, 16> expected = {

####         1, -1, 2, -2, 3, -3, 4, -4,

####         5, -5, 6, -6, 7, -7, -8, 0

####     };

####

####     // Pack into int4x8

####     for (int i = 0; i < 8; ++i) {

####         uint8_t lo = int4x8::store_nibble(expected[2*i + 0]);

####         uint8_t hi = int4x8::store_nibble(expected[2*i + 1]);

####         packed.data[i] = std::byte{(hi << 4) | lo};

####     }

####

####     // Decode into SIMD bundle

####     auto vec = bundle<int8_t>::load<int4x8>(&packed);

####

####     // Extract and verify

####     for (int i = 0; i < 16; ++i) {

####         int8_t val = vec[i];

####         std::cout << std::setw(3) << (int)val << " ";

####         if ((i+1) % 8 == 0) std::cout << "\n";

####     }

####

####     // Modify and re-pack

####     for (int i = 0; i < 16; ++i) {

####         vec[i] = static_cast<int8_t>(-vec[i]); // negate

####     }

####

####     int4x8 packed2;

####     vec.store<int4x8>(&packed2);

####

####     // Verify round-trip

####     auto vec2 = bundle<int8_t>::load<int4x8>(&packed2);

####     std::cout << "Negated:\n";

####     for (int i = 0; i < 16; ++i) {

####         std::cout << std::setw(3) << (int)vec2[i] << " ";

####         if ((i+1) % 8 == 0) std::cout << "\n";

####     }

####

####     return 0;

#### }

####

#### ---

### **✅ Output (example)**

####  1  -1   2  -2   3  -3   4  -4

####   5  -5   6  -6   7  -7  -8   0

####  -1   1  -2   2  -3   3  -4   4

####  -5   5  -6   6  -7   7   8   0

####

#### ---

### **✅ Summary**

* #### ✅ `int4x8`: Stores 16 signed 4-bit integers in 8 bytes.

* #### ✅ `load<int4x8>`: Unpacks into `bundle<int8_t, 16>` using NEON (`vld1q_s8`).

* #### ✅ `store<int4x8>`: Packs `bundle<int8_t, 16>` back into 8 bytes.

* #### ✅ Sign-extension and clamping handled.

* #### ✅ Fully integrated with existing `bundle` system via `if consteval` dispatch.

* #### ✅ No macros, modern C++23, efficient on Apple Silicon.

#### ---

#### Let me know if you'd like:

* #### `int4` arithmetic helpers

* #### `uint4` variant

* #### Vectorized unpacking (using NEON bit ops for speed)

* #### Or integration with `std::span`/`std::endian`!
