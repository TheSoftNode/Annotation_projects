class Base {
public:
    virtual void foo() {}
protected:
    ~Base() = default;
};

class Derived : public Base {
public:
    ~Derived() = default;
};

int main() {
    Base* ptr = new Derived();
    delete ptr;
}
