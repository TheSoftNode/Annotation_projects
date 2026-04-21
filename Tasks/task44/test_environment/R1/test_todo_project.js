"use strict";
// R1's Practice Project: Todo List
let todos = [];
function addTodo(text) {
    const newTodo = {
        id: Date.now(),
        text,
        completed: false
    };
    todos.push(newTodo);
}
function toggleTodo(id) {
    const todo = todos.find(t => t.id === id);
    if (todo)
        todo.completed = !todo.completed;
}
function getActiveTodos() {
    return todos.filter(t => !t.completed);
}
// Test it
addTodo("Learn TypeScript");
addTodo("Build a project");
console.log("All todos:", todos);
if (todos[0]) {
    toggleTodo(todos[0].id);
}
console.log("Active todos:", getActiveTodos());
// Test type safety - these should error if uncommented:
// todos.push({ id: 1, text: "Buy milk" }); // Missing 'completed'
// addTodo(null); // Should error - expects string
