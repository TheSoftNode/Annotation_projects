"use strict";
// Test R2's basic examples
// Step 1: Types
let myName = "Alice";
let myAge = 30;
let isStudent = false;
console.log(`${myName}, ${myAge}, ${isStudent}`);
// Step 2: Type inference
let city = "New York"; // TypeScript infers string
// city = 100; // Should error
// Step 3: Functions
function add(a, b) {
    return a + b;
}
console.log(add(5, 3));
const user = {
    name: "Bob",
    age: 25
};
console.log(user);
// Step 5: Unions
function printId(id) {
    console.log(`Your ID is: ${id}`);
}
printId(42);
printId("ABC123");
// Step 6: Arrays
let numbers = [1, 2, 3, 4];
let names = ["Alice", "Bob", "Charlie"];
console.log(numbers);
console.log(names);
