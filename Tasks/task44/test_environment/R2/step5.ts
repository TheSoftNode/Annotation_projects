// productId can be a number OR a string
function printId(productId: number | string) {
    console.log(`Your ID is: ${productId}`);
}

printId(101);       // Works
printId("A-101");   // Works
printId(true);      // Error