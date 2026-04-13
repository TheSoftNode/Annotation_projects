#include <iostream>
#include <type_traits>

class Point {
public:
    double x, y;
    virtual ~Point() {}
};

class PlainPoint {
public:
    double x, y;
    ~PlainPoint() = default;
};

int main() {
    std::cout << std::boolalpha;
    std::cout << "std::is_polymorphic_v<Point>=" << std::is_polymorphic_v<Point> << '\n';
    std::cout << "std::has_virtual_destructor_v<Point>=" << std::has_virtual_destructor_v<Point> << '\n';
    std::cout << "std::is_polymorphic_v<PlainPoint>=" << std::is_polymorphic_v<PlainPoint> << '\n';
    std::cout << "std::has_virtual_destructor_v<PlainPoint>=" << std::has_virtual_destructor_v<PlainPoint> << '\n';
    std::cout << "sizeof(Point)=" << sizeof(Point) << '\n';
    std::cout << "sizeof(PlainPoint)=" << sizeof(PlainPoint) << '\n';
}
