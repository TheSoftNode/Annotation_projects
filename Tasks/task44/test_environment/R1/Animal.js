"use strict";
class Animal {
    constructor(name, species, age) {
        this.name = name;
        this.species = species;
        this.age = age;
    }
    describe() {
        return `${this.name} is a ${this.species}, aged ${this.age}`;
    }
}
class Dog extends Animal {
    constructor(name, age) {
        super(name, "Dog", age);
    }
    bark() {
        console.log(`${this.species} barks!`);
    }
}
