import heapq
from collections import defaultdict

def solve_robocourier(n, m, edges, charging_stations, k, destinations, s):
    # 1. Build Graph
    adj = defaultdict(list)
    for u, v, w in edges:
        adj[u].append((v, w))

    chargers = set(charging_stations)

    # 2. Group Destinations by Priority
    # Sort by priority descending (based on example: 2 visited before 1)
    destinations.sort(key=lambda x: -x[1])

    # Group nodes into lists based on priority
    priority_groups = []
    current_p = None
    current_group = []

    for node, priority in destinations:
        if priority != current_p:
            if current_group:
                # Use set to remove duplicate destination nodes within same priority
                priority_groups.append(list(set(current_group)))
            current_group = [node]
            current_p = priority
        else:
            current_group.append(node)

    if current_group:
        priority_groups.append(list(set(current_group)))
    # 3. State Initialization
    # State format: (node, prev_node, charge_dist)
    # charge_dist: consecutive nodes passed through WITHOUT a charger.
    # If start is charger, dist=0. Else, dist=1 (we are currently 'passing through' it).

    current_node = s
    current_prev = -1  # Dummy value for "no previous node"
    current_charge_dist = 0 if s in chargers else 1

    if current_charge_dist > k:
        return "NO VALID PATH"

    full_path = [s]

    # 4. Process each priority group
    for group in priority_groups:
        if not group:
            continue

        # Map nodes to bit indices for the bitmask
        node_to_idx = {node: i for i, node in enumerate(group)}
        target_mask = (1 << len(group)) - 1

        # Check if start node is already in this group
        start_mask = 0
        if current_node in node_to_idx:
            start_mask |= (1 << node_to_idx[current_node])

        # Priority Queue: (total_cost, u, prev_u, charge_u, mask_u)
        pq = []
        # Visited map to store minimum cost for a specific state
        visited = {}
        # Parent map to reconstruct path: state -> (parent_state, node)
        parent = {}

        init_state = (current_node, current_prev, current_charge_dist, start_mask)
        heapq.heappush(pq, (0, *init_state))
        visited[init_state] = 0
        parent[init_state] = None

        found_final_state = None

        while pq:
            cost, u, prev_u, charge_u, mask_u = heapq.heappop(pq)

            # Skip if we found a better way to reach this state already
            if cost > visited.get((u, prev_u, charge_u, mask_u), float('inf')):
                continue

            # Goal Check: Have we visited all nodes in this priority group?
            if mask_u == target_mask:
                found_final_state = (u, prev_u, charge_u, mask_u)
                break

            # Explore neighbors
            for v, w in adj[u]:
                # Rule 1: Alternate Routes Rule
                if v == prev_u:
                    continue

                # Rule 2: Charging Rule
                # If v is charger, consecutive count resets to 0. Else increments.
                next_charge = 0 if v in chargers else charge_u + 1
                if next_charge > k:
                    continue

                # Update Mask
                next_mask = mask_u
                if v in node_to_idx:
                    next_mask |= (1 << node_to_idx[v])

                new_state = (v, u, next_charge, next_mask)
                new_cost = cost + w

                if new_cost < visited.get(new_state, float('inf')):
                    visited[new_state] = new_cost
                    parent[new_state] = (u, prev_u, charge_u, mask_u)
                    heapq.heappush(pq, (new_cost, *new_state))

        if found_final_state is None:
            return "NO VALID PATH"

        # Reconstruct path segment for this priority group
        path_segment = []
        curr = found_final_state
        while curr is not None:
            u, _, _, _ = curr
            path_segment.append(u)
            curr = parent[curr]

        path_segment.reverse()

        # Append to full path (excluding the first node to avoid duplication)
        full_path.extend(path_segment[1:])

        # Update state for next iteration
        current_node = found_final_state[0]
        current_prev = found_final_state[1]
        current_charge_dist = found_final_state[2]
    return full_path

# --- Example Usage ---
# Input Data
n = 6
m = 7
edges = [(1,2,3),(2,3,2),(3,1,4),(3,4,1),(4,5,2),(5,6,1),(6,3,2)]
charging_stations = [1, 4]
k = 3
destinations = [(5, 1), (2, 2)]
s = 1

# Run Solver
result = solve_robocourier(n, m, edges, charging_stations, k, destinations, s)

# Output
print(result)
