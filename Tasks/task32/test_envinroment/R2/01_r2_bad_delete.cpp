class Base {

public:

    virtual void foo() {} // Makes Base polymorphic

    // ❌ Missing virtual destructor!

};

class Derived : public Base {

    int* data = new int[100]; // Resource needing cleanup

public:

    ~Derived() { delete[] data; } // Correctly cleans up

};

int main() {

    Base* ptr = new Derived;

    delete ptr; // 🚨 UNDEFINED BEHAVIOR!

    // Only Base::~Base() runs → data leak!

}
