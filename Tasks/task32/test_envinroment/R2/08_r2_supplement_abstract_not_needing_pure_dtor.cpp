class AbstractBase {
public:
    virtual void doSomething() = 0;  // Pure virtual function makes it abstract
    virtual ~AbstractBase() = default;  // Regular virtual destructor, not pure
};

class Concrete : public AbstractBase {
public:
    void doSomething() override {}
};

int main() {
    // AbstractBase ab;  // Would fail: cannot instantiate abstract class
    Concrete c;  // OK: Concrete is not abstract
}
