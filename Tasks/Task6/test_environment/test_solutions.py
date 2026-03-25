#!/usr/bin/env python3
"""
Test script for RoboCourier solutions
Validates constraint satisfaction and path correctness
"""

def validate_path(path, edges, charging_stations, k, destinations, s):
    """
    Validates if a path satisfies all constraints
    Returns (is_valid, error_messages)
    """
    errors = []

    # Build adjacency for validation
    adj = {}
    for u, v, w in edges:
        if u not in adj:
            adj[u] = []
        adj[u].append((v, w))

    chargers = set(charging_stations)

    # Check 1: Path starts at s
    if not path or path[0] != s:
        errors.append(f"Path must start at {s}, but starts at {path[0] if path else 'empty'}")

    # Check 2: Each edge exists in graph
    for i in range(len(path) - 1):
        u, v = path[i], path[i+1]
        if u not in adj:
            errors.append(f"Node {u} has no outgoing edges")
            continue
        valid_neighbors = [neighbor for neighbor, _ in adj[u]]
        if v not in valid_neighbors:
            errors.append(f"Edge ({u}, {v}) does not exist in graph")

    # Check 3: Alternate Routes Rule - cannot return to previous node
    for i in range(1, len(path) - 1):
        if path[i+1] == path[i-1]:
            errors.append(f"Alternate Routes Rule violated at position {i}: {path[i-1]} -> {path[i]} -> {path[i+1]}")

    # Check 4: Charging Rule - max k consecutive non-charging nodes
    charge_streak = 0
    for i, node in enumerate(path):
        if node in chargers:
            charge_streak = 0
        else:
            charge_streak += 1

        if charge_streak > k:
            errors.append(f"Charging Rule violated at position {i}: {charge_streak} consecutive non-charging nodes (max {k})")
            break

    # Check 5: Delivery Priority Rule - all destinations visited in priority order
    # Sort destinations by priority descending
    sorted_dests = sorted(destinations, key=lambda x: x[1], reverse=True)
    dest_nodes = [node for node, _ in sorted_dests]

    visited_order = []
    for node in path:
        if node in dest_nodes and node not in visited_order:
            visited_order.append(node)

    if visited_order != dest_nodes:
        errors.append(f"Delivery Priority violated: visited {visited_order}, expected {dest_nodes}")

    return len(errors) == 0, errors

def calculate_total_time(path, edges):
    """Calculate total time for a path"""
    edge_map = {}
    for u, v, w in edges:
        edge_map[(u, v)] = w

    total = 0
    for i in range(len(path) - 1):
        u, v = path[i], path[i+1]
        if (u, v) in edge_map:
            total += edge_map[(u, v)]
        else:
            return None  # Invalid edge
    return total

# Test data
n = 6
m = 7
edges = [(1,2,3),(2,3,2),(3,1,4),(3,4,1),(4,5,2),(5,6,1),(6,3,2)]
charging_stations = [1, 4]
k = 3
destinations = [(5, 1), (2, 2)]
s = 1

print("=" * 70)
print("ROBOCOURIER TEST VALIDATION")
print("=" * 70)

# Expected output from prompt
expected_path = [1,2,3,4,5,4,3,2]
print(f"\nExpected path from prompt: {expected_path}")
is_valid, errors = validate_path(expected_path, edges, charging_stations, k, destinations, s)
total_time = calculate_total_time(expected_path, edges)
print(f"Valid: {is_valid}")
if errors:
    for error in errors:
        print(f"  - {error}")
print(f"Total time: {total_time}")

# Test Response 1
print("\n" + "-" * 70)
print("RESPONSE 1 OUTPUT")
print("-" * 70)
from response1_solution import solve_robocourier
result1 = solve_robocourier(n, m, edges, charging_stations, k, destinations, s)
print(f"Path: {result1}")
if result1 != "NO VALID PATH":
    is_valid, errors = validate_path(result1, edges, charging_stations, k, destinations, s)
    total_time = calculate_total_time(result1, edges)
    print(f"Valid: {is_valid}")
    if errors:
        for error in errors:
            print(f"  - {error}")
    print(f"Total time: {total_time}")

# Test Response 2
print("\n" + "-" * 70)
print("RESPONSE 2 OUTPUT")
print("-" * 70)
from response2_solution import solve_robo_courier
result2 = solve_robo_courier(n, m, edges, charging_stations, k, destinations, s)
print(f"Path: {result2}")
if result2 != "NO VALID PATH":
    is_valid, errors = validate_path(result2, edges, charging_stations, k, destinations, s)
    total_time = calculate_total_time(result2, edges)
    print(f"Valid: {is_valid}")
    if errors:
        for error in errors:
            print(f"  - {error}")
    print(f"Total time: {total_time}")

# Compare results
print("\n" + "=" * 70)
print("COMPARISON")
print("=" * 70)
print(f"Expected:   {expected_path} (time: {calculate_total_time(expected_path, edges)})")
print(f"Response 1: {result1} (time: {calculate_total_time(result1, edges) if result1 != 'NO VALID PATH' else 'N/A'})")
print(f"Response 2: {result2} (time: {calculate_total_time(result2, edges) if result2 != 'NO VALID PATH' else 'N/A'})")

if result1 == expected_path:
    print("\n✅ Response 1 matches expected output")
else:
    print("\n❌ Response 1 does NOT match expected output")

if result2 == expected_path:
    print("✅ Response 2 matches expected output")
else:
    print("❌ Response 2 does NOT match expected output")
