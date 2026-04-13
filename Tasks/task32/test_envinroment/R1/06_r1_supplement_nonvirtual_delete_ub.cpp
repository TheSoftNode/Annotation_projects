#include <iostream>

class Base {
public:
    virtual void foo() {}
    ~Base() { std::cout << "Base::~Base\n"; }
};

class Derived : public Base {
    int* data = new int[100];
public:
    ~Derived() { 
        std::cout << "Derived::~Derived\n";
        delete[] data;
    }
};

int main() {
    Base* ptr = new Derived();
    delete ptr;
}
