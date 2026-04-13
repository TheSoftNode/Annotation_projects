#include <iostream>
#include <type_traits>

class Base {
public:
    virtual void foo() {}
    virtual ~Base() = default;
};

int main() {
    std::cout << std::boolalpha;
    std::cout << "is_copy_constructible: " << std::is_copy_constructible_v<Base> << '\n';
    std::cout << "is_move_constructible: " << std::is_move_constructible_v<Base> << '\n';
    std::cout << "is_copy_assignable: " << std::is_copy_assignable_v<Base> << '\n';
    std::cout << "is_move_assignable: " << std::is_move_assignable_v<Base> << '\n';
}
