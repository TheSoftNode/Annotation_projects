// Test 2: R1's core types (Step 2)
let age: number = 25;
let username: string = "Alice";
let isActive: boolean = true;

// any type
let data: any = "hello";
data = 42;
// data.toUpperCase(); // TypeScript allows this but crashes at runtime

// unknown type
let value: unknown = "test";
// value.toUpperCase(); // Should error
if (typeof value === "string") {
    value.toUpperCase(); // OK
}

// void
function logMessage(msg: string): void {
    console.log(msg);
}

// never
function throwError(message: string): never {
    throw new Error(message);
}

// enum - R1 claims it starts at 0 by default, but shows Up = 1
enum Direction {
    Up = 1,
    Down,
    Left,
    Right
}

console.log(Direction.Up);    // Should be 1
console.log(Direction.Down);  // Should be 2
console.log(Direction.Left);  // Should be 3
console.log(Direction.Right); // Should be 4

// Test default enum (no explicit values)
enum DefaultDirection {
    Up,
    Down,
    Left,
    Right
}

console.log(DefaultDirection.Up);   // Should be 0
console.log(DefaultDirection.Down); // Should be 1
