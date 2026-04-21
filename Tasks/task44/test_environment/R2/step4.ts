// Define the shape of a User
interface User {
    id: number;
    name: string;
    email?: string; // The '?' means this property is optional
}

// Use the interface
function createUser(user: User) {
    console.log(`User created: ${user.name}`);
}

// This works
createUser({ id: 1, name: "John" });

// This fails (missing name)
createUser({ id: 2 }); // Error: Property 'name' is missing...