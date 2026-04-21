"use strict";
// Test enum defaults
var DefaultEnum;
(function (DefaultEnum) {
    DefaultEnum[DefaultEnum["First"] = 0] = "First";
    DefaultEnum[DefaultEnum["Second"] = 1] = "Second";
    DefaultEnum[DefaultEnum["Third"] = 2] = "Third";
})(DefaultEnum || (DefaultEnum = {}));
console.log(DefaultEnum.First); // Should be 0
console.log(DefaultEnum.Second); // Should be 1
// Test enum with explicit start
var Direction;
(function (Direction) {
    Direction[Direction["Up"] = 1] = "Up";
    Direction[Direction["Down"] = 2] = "Down";
    Direction[Direction["Left"] = 3] = "Left";
    Direction[Direction["Right"] = 4] = "Right";
})(Direction || (Direction = {}));
console.log(Direction.Up); // Should be 1
console.log(Direction.Down); // Should be 2
