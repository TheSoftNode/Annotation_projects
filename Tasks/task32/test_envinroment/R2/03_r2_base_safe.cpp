class Base {

public:

    virtual void foo() {}

    virtual ~Base() = default; // ✅ Safe if no resources

    // Default copy/move are fine here

};
