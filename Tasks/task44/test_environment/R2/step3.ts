// (a: number, b: number) -> arguments must be numbers
// : number -> the function must return a number
function add(a: number, b: number): number {
    return a + b;
}

add(5, 10); // Works
add(5, "10"); // Error: Argument of type 'string' is not assignable to parameter of type 'number'.