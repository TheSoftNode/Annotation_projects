#!/usr/bin/env python3
"""
Manual verification of the example path from the prompt.
This script will verify step-by-step whether [1,2,3,4,5,4,3,2] is valid.
"""

# Given graph
edges = [(1,2,3),(2,3,2),(3,1,4),(3,4,1),(4,5,2),(5,6,1),(6,3,2)]
charging_stations = [1, 4]
k = 3
destinations = [(5, 1), (2, 2)]
s = 1

# Path to verify
path = [1,2,3,4,5,4,3,2]

print("=" * 80)
print("MANUAL VERIFICATION OF PATH: [1,2,3,4,5,4,3,2]")
print("=" * 80)

# Build adjacency list
adj_list = {}
edge_dict = {}
for u, v, w in edges:
    if u not in adj_list:
        adj_list[u] = []
    adj_list[u].append(v)
    edge_dict[(u, v)] = w

print("\n1. GRAPH STRUCTURE")
print("-" * 80)
print("Edges (directed):")
for u, v, w in edges:
    print(f"  {u} -> {v} (weight {w})")

print("\nAdjacency List:")
for node in sorted(adj_list.keys()):
    print(f"  {node}: {adj_list[node]}")

print("\n2. EDGE EXISTENCE CHECK")
print("-" * 80)
print("Checking if each edge in the path exists in the graph:\n")

all_edges_exist = True
for i in range(len(path) - 1):
    u, v = path[i], path[i+1]
    exists = (u, v) in edge_dict
    status = "✓ EXISTS" if exists else "✗ DOES NOT EXIST"
    weight = edge_dict.get((u, v), "N/A")
    print(f"  Step {i+1}: {u} -> {v}  |  Weight: {weight}  |  {status}")
    if not exists:
        all_edges_exist = False

print(f"\nResult: {'All edges exist ✓' if all_edges_exist else 'Some edges missing ✗'}")

print("\n3. ALTERNATE ROUTES RULE CHECK")
print("-" * 80)
print("Rule: After going A -> B, cannot immediately go B -> A\n")

alternate_routes_ok = True
for i in range(1, len(path) - 1):
    prev_node = path[i-1]
    curr_node = path[i]
    next_node = path[i+1]

    # Check if next_node == prev_node
    violates = (next_node == prev_node)
    status = "✗ VIOLATION" if violates else "✓ OK"

    print(f"  Position {i}: {prev_node} -> {curr_node} -> {next_node}  |  {status}")

    if violates:
        alternate_routes_ok = False
        print(f"    └─ Returns to node {prev_node} immediately!")

print(f"\nResult: {'No violations ✓' if alternate_routes_ok else 'Rule violated ✗'}")

print("\n4. CHARGING RULE CHECK")
print("-" * 80)
print(f"Rule: Cannot pass through more than k={k} consecutive nodes without a charger\n")

chargers = set(charging_stations)
print(f"Charging stations: {sorted(chargers)}\n")

charging_ok = True
max_streak = 0
current_streak = 0

for i, node in enumerate(path):
    is_charger = node in chargers

    if is_charger:
        current_streak = 0
        print(f"  Position {i}: Node {node}  |  CHARGER - streak reset to 0")
    else:
        current_streak += 1
        print(f"  Position {i}: Node {node}  |  Non-charger - streak = {current_streak}")

        if current_streak > k:
            print(f"    └─ ✗ VIOLATION: streak {current_streak} > k={k}")
            charging_ok = False

    max_streak = max(max_streak, current_streak)

print(f"\nMax streak: {max_streak}")
print(f"Result: {'Within limit ✓' if charging_ok else 'Limit exceeded ✗'}")

print("\n5. DELIVERY PRIORITY CHECK")
print("-" * 80)
print("Destinations (sorted by priority descending):")

# Sort by priority descending (higher priority = visit first)
sorted_dests = sorted(destinations, key=lambda x: x[1], reverse=True)
for node, priority in sorted_dests:
    print(f"  Node {node} (priority {priority})")

print("\nOrder visited in path:")
visited_order = []
for i, node in enumerate(path):
    dest_info = [d for d in destinations if d[0] == node]
    if dest_info and node not in [v for v, _ in visited_order]:
        priority = dest_info[0][1]
        visited_order.append((node, priority))
        print(f"  Position {i}: Node {node} (priority {priority})")

print("\nExpected order:")
for node, priority in sorted_dests:
    print(f"  Node {node} (priority {priority})")

print("\nActual order:")
for node, priority in visited_order:
    print(f"  Node {node} (priority {priority})")

expected_nodes = [n for n, p in sorted_dests]
actual_nodes = [n for n, p in visited_order]
priority_ok = (expected_nodes == actual_nodes)

print(f"\nResult: {'Correct order ✓' if priority_ok else 'Wrong order ✗'}")

print("\n6. TOTAL TIME CALCULATION")
print("-" * 80)
total_time = 0
for i in range(len(path) - 1):
    u, v = path[i], path[i+1]
    weight = edge_dict.get((u, v), None)
    if weight is not None:
        total_time += weight
        print(f"  {u} -> {v}: +{weight} (total: {total_time})")
    else:
        print(f"  {u} -> {v}: N/A (edge doesn't exist)")
        total_time = None
        break

if total_time is not None:
    print(f"\nTotal time: {total_time}")
else:
    print(f"\nTotal time: Cannot calculate (missing edges)")

print("\n" + "=" * 80)
print("FINAL VERDICT")
print("=" * 80)

all_valid = all_edges_exist and alternate_routes_ok and charging_ok and priority_ok

print(f"Edge existence:        {'✓ PASS' if all_edges_exist else '✗ FAIL'}")
print(f"Alternate Routes Rule: {'✓ PASS' if alternate_routes_ok else '✗ FAIL'}")
print(f"Charging Rule:         {'✓ PASS' if charging_ok else '✗ FAIL'}")
print(f"Delivery Priority:     {'✓ PASS' if priority_ok else '✗ FAIL'}")

print(f"\nPath [1,2,3,4,5,4,3,2] is: {'VALID ✓' if all_valid else 'INVALID ✗'}")
