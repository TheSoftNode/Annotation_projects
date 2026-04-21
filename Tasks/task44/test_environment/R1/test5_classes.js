"use strict";
// Test 5: R1's class examples (Step 5)
class Animal {
    name;
    species;
    age;
    constructor(name, species, age) {
        this.name = name;
        this.species = species;
        this.age = age;
    }
    describe() {
        return `${this.name} is a ${this.species}, aged ${this.age}`;
    }
    secretMethod() {
        console.log("This is private");
    }
}
class Dog extends Animal {
    constructor(name, age) {
        super(name, "Dog", age);
    }
    bark() {
        console.log(`${this.species} barks!`); // Can access protected
        // console.log(this.name); // Should error - private
    }
}
const myDog = new Dog("Buddy", 3);
console.log(myDog.describe());
myDog.bark();
// myDog.secretMethod(); // Should error - private
