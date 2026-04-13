#include <iostream>

class Base {
public:
    virtual void foo() {}
    virtual ~Base() = default;
};

class Derived : public Base {
public:
    ~Derived() {
        std::cout << "Derived::~Derived\n";
    }
};

int main() {
    Base* ptr = new Derived;
    delete ptr;
}
