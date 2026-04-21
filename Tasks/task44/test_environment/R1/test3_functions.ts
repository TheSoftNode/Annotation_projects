// Test 3: R1's function examples (Step 3)

// Optional parameters
function buildName(firstName: string, lastName?: string): string {
    if (lastName) {
        return `${firstName} ${lastName}`;
    }
    return firstName;
}

console.log(buildName("John"));
console.log(buildName("John", "Doe"));

// Default parameters
function increment(num: number, step: number = 1): number {
    return num + step;
}

console.log(increment(5));
console.log(increment(5, 2));

// Rest parameters
function sum(...numbers: number[]): number {
    return numbers.reduce((total, n) => total + n, 0);
}

console.log(sum(1, 2, 3, 4));

// Function overloads
function format(value: string): string;
function format(value: number): string;
function format(value: string | number): string {
    if (typeof value === "string") {
        return value.toUpperCase();
    }
    return value.toFixed(2);
}

console.log(format("hello"));
console.log(format(3.14159));
