class Base {
public:
    virtual ~Base() = default; // Empty but virtual
};

class Derived : public Base {
public:
    ~Derived() { /* cleanup */ }
};

// Later:
Base* ptr = new Derived();
delete ptr; // ✅ Calls ~Derived() then ~Base()
