
function aStar(start,goal)
	local closedset ={}    -- The set of nodes already evaluated.
	local openset = {start}    -- The set of tentative nodes to be evaluated, initially containing the start node
	local came_from = {}    -- The map of navigated nodes.

	g_score[start] = 0   -- Cost from start along best known path.
	-- Estimated total cost from start to goal through y.
	f_score[start] = g_score[start] + heuristic_cost_estimate(start, goal)

	--    while openset is not empty
	--        current := the node in openset having the lowest f_score[] value
	--        if current = goal
	--            return reconstruct_path(came_from, goal)
	--
	--        remove current from openset
	--        add current to closedset
	--        for each neighbor in neighbor_nodes(current)
	--            if neighbor in closedset
	--                continue
	--            tentative_g_score := g_score[current] + dist_between(current,neighbor)
	--
	--            if neighbor not in openset or tentative_g_score < g_score[neighbor]
	--                came_from[neighbor] := current
	--                g_score[neighbor] := tentative_g_score
	--                f_score[neighbor] := g_score[neighbor] + heuristic_cost_estimate(neighbor, goal)
	--                if neighbor not in openset
	--                    add neighbor to openset

	return failure
end
function reconstruct_path(came_from, current_node)
	if current_node_in_came_from then
		local p = reconstruct_path(came_from, came_from[current_node])
		return (p + current_node)
	else
		return current_node
	end
end