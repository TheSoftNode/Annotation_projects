// Test 5: Verify that the compiler prevents cross-type multiplication
// without an operator* overload.
// This should FAIL to compile.
//
// What this tests:
//   - R2 Claim 30: "Compiler prevents: Price p = qty * price; // Error!"

#include <cstdint>

struct Price
{
    int64_t value;
};
struct Quantity
{
    int64_t value;
};

int main()
{
    Quantity qty{1};
    Price price{2};
    Price p = qty * price; // Should fail: no operator* defined
    (void)p;
    return 0;
}
