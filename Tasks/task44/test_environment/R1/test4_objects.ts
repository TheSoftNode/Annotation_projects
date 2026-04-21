// Test 4: R1's object examples (Step 4)

// Interface
interface User {
    id: number;
    name: string;
    email?: string;
    readonly createdAt: Date;
}

const user: User = {
    id: 1,
    name: "Alice",
    createdAt: new Date()
};

// user.createdAt = new Date(); // Should error - readonly

// Type alias
type Point = {
    x: number;
    y: number;
};

const point: Point = { x: 10, y: 20 };

// Union type
type ID = string | number;

function printId(id: ID): void {
    console.log(`ID: ${id}`);
}

printId(123);
printId("ABC123");
