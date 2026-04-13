#include <iostream>

struct Base {
    int b = 1;
    virtual ~Base() = default;
};

struct Derived : Base {
    int d = 2;
};

void take_by_value(Base x) {
    std::cout << "take_by_value(Base): x.b=" << x.b << '\n';
}

int main() {
    Derived obj;
    Base sliced = obj;

    std::cout << "sizeof(Base)=" << sizeof(Base) << '\n';
    std::cout << "sizeof(Derived)=" << sizeof(Derived) << '\n';
    std::cout << "sliced.b=" << sliced.b << '\n';

    take_by_value(obj);
}
