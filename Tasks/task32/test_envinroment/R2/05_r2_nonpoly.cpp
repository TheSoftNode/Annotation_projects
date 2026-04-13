class NonPoly { // No virtual functions → no need for virtual dtor

public:

    ~NonPoly() {} // ✅ Non-virtual is correct

};
