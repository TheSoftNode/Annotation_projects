class Point {
public:
    double x, y;
    virtual ~Point() {} // ❌ Unnecessary if not polymorphic
};
