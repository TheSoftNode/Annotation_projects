// Test 7: Verify that R2's operator* snippet is incomplete as written.
// The response shows this code as a "safe math library" example,
// but safe_multiply and SCALE are never defined.
// This should FAIL to compile.
//
// What this tests:
//   - Whether R2's snippet is complete enough to work standalone

#include <cstdint>

struct Price
{
    int64_t value;
};
struct Quantity
{
    int64_t value;
};

Price operator*(Price a, Quantity b)
{
    // Internally handles 128-bit cast and scaling
    return Price{safe_multiply(a.value, b.value, SCALE)};
}

int main()
{
    Price p{100};
    Quantity q{5};
    Price result = p * q;
    (void)result;
    return 0;
}
