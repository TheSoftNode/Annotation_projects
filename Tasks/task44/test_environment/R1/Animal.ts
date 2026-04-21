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
}

class Dog extends Animal {
  constructor(name: string, age: number) {
    super(name, "Dog", age);
  }

  public bark(): void {
    console.log(`${this.species} barks!`);
  }
}