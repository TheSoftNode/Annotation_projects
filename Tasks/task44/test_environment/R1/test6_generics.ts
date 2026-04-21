// Test 6: R1's generics examples (Step 6)

// Generic function
function identity<T>(arg: T): T {
    return arg;
}

console.log(identity<string>("hello"));
console.log(identity<number>(42));

// Generic array function
function getFirstElement<T>(arr: T[]): T | undefined {
    return arr[0];
}

console.log(getFirstElement([1, 2, 3]));
console.log(getFirstElement(["a", "b", "c"]));

// Utility types
interface Todo {
    title: string;
    description: string;
    completed: boolean;
}

// Partial
const partialTodo: Partial<Todo> = {
    title: "Learn TypeScript"
};

// Readonly
const readonlyTodo: Readonly<Todo> = {
    title: "Read docs",
    description: "TypeScript handbook",
    completed: false
};

// readonlyTodo.completed = true; // Should error

// Pick
type TodoPreview = Pick<Todo, "title" | "completed">;

const preview: TodoPreview = {
    title: "Test",
    completed: false
};

// Omit
type TodoInfo = Omit<Todo, "completed">;

const info: TodoInfo = {
    title: "Test",
    description: "Description"
};

console.log("All utility types work correctly");
