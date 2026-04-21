// Test R2's basic examples

// Step 1: Types
let myName: string = "Alice";
let myAge: number = 30;
let isStudent: boolean = false;

console.log(`${myName}, ${myAge}, ${isStudent}`);

// Step 2: Type inference
let city = "New York"; // TypeScript infers string
// city = 100; // Should error

// Step 3: Functions
function add(a: number, b: number): number {
    return a + b;
}

console.log(add(5, 3));

// Step 4: Interfaces
interface Person {
    name: string;
    age: number;
}

const user: Person = {
    name: "Bob",
    age: 25
};

console.log(user);

// Step 5: Unions
function printId(id: number | string): void {
    console.log(`Your ID is: ${id}`);
}

printId(42);
printId("ABC123");

// Step 6: Arrays
let numbers: number[] = [1, 2, 3, 4];
let names: string[] = ["Alice", "Bob", "Charlie"];

console.log(numbers);
console.log(names);
