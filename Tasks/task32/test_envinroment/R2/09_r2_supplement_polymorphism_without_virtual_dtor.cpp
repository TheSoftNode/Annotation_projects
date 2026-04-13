#include <iostream>

class Base {
public:
    virtual void show() { std::cout << "Base::show\n"; }
    ~Base() { std::cout << "Base::~Base\n"; }
};

class Derived : public Base {
public:
    void show() override { std::cout << "Derived::show\n"; }
    ~Derived() { std::cout << "Derived::~Derived\n"; }
};

int main() {
    Base* ptr = new Derived;
    ptr->show();  // Polymorphism works fine
    delete ptr;   // But this is UB
}
