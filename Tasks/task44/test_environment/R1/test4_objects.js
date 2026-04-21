"use strict";
// Test 4: R1's object examples (Step 4)
const user = {
    id: 1,
    name: "Alice",
    createdAt: new Date()
};
const point = { x: 10, y: 20 };
function printId(id) {
    console.log(`ID: ${id}`);
}
printId(123);
printId("ABC123");
