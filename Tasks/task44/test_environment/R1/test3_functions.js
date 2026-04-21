"use strict";
// Test 3: R1's function examples (Step 3)
// Optional parameters
function buildName(firstName, lastName) {
    if (lastName) {
        return `${firstName} ${lastName}`;
    }
    return firstName;
}
console.log(buildName("John"));
console.log(buildName("John", "Doe"));
// Default parameters
function increment(num, step = 1) {
    return num + step;
}
console.log(increment(5));
console.log(increment(5, 2));
// Rest parameters
function sum(...numbers) {
    return numbers.reduce((total, n) => total + n, 0);
}
console.log(sum(1, 2, 3, 4));
function format(value) {
    if (typeof value === "string") {
        return value.toUpperCase();
    }
    return value.toFixed(2);
}
console.log(format("hello"));
console.log(format(3.14159));
