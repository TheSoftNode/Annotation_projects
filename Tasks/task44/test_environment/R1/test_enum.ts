// Test enum defaults
enum DefaultEnum {
    First,
    Second,
    Third
}

console.log(DefaultEnum.First); // Should be 0
console.log(DefaultEnum.Second); // Should be 1

// Test enum with explicit start
enum Direction {
    Up = 1,
    Down,
    Left,
    Right
}

console.log(Direction.Up); // Should be 1
console.log(Direction.Down); // Should be 2