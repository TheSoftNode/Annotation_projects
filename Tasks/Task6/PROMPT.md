# Task 6 - Prompt

Please solve to the best of your ability:
Sure! Here's a **creative and challenging computer science problem** suitable for undergraduate students, particularly those with some background in **algorithms**, **data structures**, and possibly **graph theory**. It blends problem-solving skills with a real-world flavor.
---

## **🔍 Problem Title: "Routing the RoboCourier"**

### **Problem Description:**

You have been hired to program a delivery robot, **RoboCourier**, that must deliver packages across a futuristic smart city. The city is modeled as a **directed weighted graph**, where:

* Each **node** represents an intersection.
* Each **edge** represents a street, and the weight of the edge represents the **time** it takes to traverse that street.
* Some streets are **one-way** (hence the graph is directed).
* RoboCourier **must** follow specific traffic rules:
  1. **Alternate Routes Rule**: After RoboCourier traverses a street from node A to node B, it **cannot immediately traverse a street that leads back to node A**.
  2. **Charging Rule**: Some nodes are **charging stations**. If the robot passes through more than `k` consecutive nodes without reaching a charging station, it will **shut down**.
  3. **Delivery Priority Rule**: RoboCourier must **prioritize** deliveries. It is given a **set of destinations**, each with a **priority level**. Higher priority deliveries must be completed before lower ones.

### **Input Format:**

* An integer `n` — number of intersections.
* An integer `m` — number of streets.
* A list of `m` edges: each edge is `(u, v, w)` meaning a directed edge from `u` to `v` with travel time `w`.
* An integer `c` — number of charging stations and a list of `c` integers indicating which nodes have charging stations.
* An integer `k` — maximum number of nodes RoboCourier can travel without reaching a charging station.
* A list of destinations, each a tuple `(node, priority)`. Multiple destinations can have the same priority.
* A starting node `s`.

### **Output:**

* A list of nodes representing the **valid path** RoboCourier takes that:
  * Visits all destinations (in order of priority).
  * Respects the **Alternate Routes Rule**.
  * Never goes `k` or more nodes without a charging station.

If no such path exists, output `"NO VALID PATH"`.

---

### **Example:**

Input:
n = 6
m = 7
edges = [(1,2,3),(2,3,2),(3,1,4),(3,4,1),(4,5,2),(5,6,1),(6,3,2)]
c = 2
charging_stations = [1, 4]
k = 3
destinations = [(5, 1), (2, 2)]
s = 1

Output:
[1,2,3,4,5,4,3,2]

---

### **Concepts Tested:**

* Graph traversal (modified Dijkstra or A* with constraints)
* Priority-based path planning
* Constraint satisfaction (charging and backtracking rules)
* State modeling with memory (track path history and charging)

---

### **Bonus Challenge:**

Can you implement this using **A*** search where the heuristic prioritizes reaching higher-priority destinations faster?

---

Let me know if you'd like this problem in PDF format, want test cases, or would like a Python solution as a reference.
