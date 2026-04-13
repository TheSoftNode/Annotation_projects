#include <iostream>

class Base {
public:
    virtual ~Base() { std::cout << "Base::~Base\n"; }
};

class Derived : public Base {
public:
    ~Derived() override { std::cout << "Derived::~Derived\n"; }
};

int main() {
    Base* ptr = new Derived();
    delete ptr;
}
