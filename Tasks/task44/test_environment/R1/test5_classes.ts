// Test 5: R1's class examples (Step 5)

class Animal {
    private name: string;
    protected species: string;
    public age: number;

    constructor(name: string, species: string, age: number) {
        this.name = name;
        this.species = species;
        this.age = age;
    }

    public describe(): string {
        return `${this.name} is a ${this.species}, aged ${this.age}`;
    }

    private secretMethod(): void {
        console.log("This is private");
    }
}

class Dog extends Animal {
    constructor(name: string, age: number) {
        super(name, "Dog", age);
    }

    public bark(): void {
        console.log(`${this.species} barks!`); // Can access protected
        // console.log(this.name); // Should error - private
    }
}

const myDog = new Dog("Buddy", 3);
console.log(myDog.describe());
myDog.bark();
// myDog.secretMethod(); // Should error - private
