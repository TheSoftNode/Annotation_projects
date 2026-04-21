"use strict";
// Test 6: R1's generics examples (Step 6)
// Generic function
function identity(arg) {
    return arg;
}
console.log(identity("hello"));
console.log(identity(42));
// Generic array function
function getFirstElement(arr) {
    return arr[0];
}
console.log(getFirstElement([1, 2, 3]));
console.log(getFirstElement(["a", "b", "c"]));
// Partial
const partialTodo = {
    title: "Learn TypeScript"
};
// Readonly
const readonlyTodo = {
    title: "Read docs",
    description: "TypeScript handbook",
    completed: false
};
const preview = {
    title: "Test",
    completed: false
};
const info = {
    title: "Test",
    description: "Description"
};
console.log("All utility types work correctly");
