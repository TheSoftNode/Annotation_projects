class Base {

public:

    virtual void foo() {}

    virtual ~Base() = default; // ✅ Critical! (Empty but virtual)

};
