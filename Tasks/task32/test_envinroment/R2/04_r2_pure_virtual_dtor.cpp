class Base {

public:

    virtual ~Base() = 0; // Pure virtual → abstract class

};

Base::~Base() {} // ✅ REQUIRED definition (can be empty)
