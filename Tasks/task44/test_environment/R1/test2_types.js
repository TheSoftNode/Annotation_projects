"use strict";
// Test 2: R1's core types (Step 2)
let age = 25;
let username = "Alice";
let isActive = true;
// any type
let data = "hello";
data = 42;
// data.toUpperCase(); // TypeScript allows this but crashes at runtime
// unknown type
let value = "test";
// value.toUpperCase(); // Should error
if (typeof value === "string") {
    value.toUpperCase(); // OK
}
// void
function logMessage(msg) {
    console.log(msg);
}
// never
function throwError(message) {
    throw new Error(message);
}
// enum - R1 claims it starts at 0 by default, but shows Up = 1
var Direction;
(function (Direction) {
    Direction[Direction["Up"] = 1] = "Up";
    Direction[Direction["Down"] = 2] = "Down";
    Direction[Direction["Left"] = 3] = "Left";
    Direction[Direction["Right"] = 4] = "Right";
})(Direction || (Direction = {}));
console.log(Direction.Up); // Should be 1
console.log(Direction.Down); // Should be 2
console.log(Direction.Left); // Should be 3
console.log(Direction.Right); // Should be 4
// Test default enum (no explicit values)
var DefaultDirection;
(function (DefaultDirection) {
    DefaultDirection[DefaultDirection["Up"] = 0] = "Up";
    DefaultDirection[DefaultDirection["Down"] = 1] = "Down";
    DefaultDirection[DefaultDirection["Left"] = 2] = "Left";
    DefaultDirection[DefaultDirection["Right"] = 3] = "Right";
})(DefaultDirection || (DefaultDirection = {}));
console.log(DefaultDirection.Up); // Should be 0
console.log(DefaultDirection.Down); // Should be 1
