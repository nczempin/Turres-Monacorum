
function aStar(start,goal)
	local closedset =set{}    -- The set of nodes already evaluated.
	local openset = set{start}    -- The set of tentative nodes to be evaluated, initially containing the start node
	local came_from = {}    -- The map of navigated nodes.

	local g_score=  {}
	local f_score = {}
	g_score[start] = 0   -- Cost from start along best known path.
	-- Estimated total cost from start to goal through y.
	f_score[start] = g_score[start] + distance(start.x,start.y, goal.x, goal.y)

	while #openset>0 do
		local current = getLowest(openset) -- the node in openset having the lowest f_score[] value
		if current == goal then
			return reconstruct_path(came_from, goal)
		end
		--
		openset[current]=false
		closedset[current]=true
		local nn = neighbor_nodes(current)
		for  neighbor in nn do

			if closedset[neighbor]then
			--                continue
			else
				local tentative_g_score = g_score[current] + distance(current.x,current.y,neighbor.x,neighbor.y)
				--
				if not openset[neighbor] or tentative_g_score < g_score[neighbor]then
					came_from[neighbor] = current
					g_score[neighbor] = tentative_g_score
					f_score[neighbor] = g_score[neighbor] + distance(neighbor.x,neighbor.y,goal.x,goal.y)
					if not openset[neighbor] then
						openset[neighbor] = true
					end
				end
			end
		end
	end
	return nil
end
function reconstruct_path(came_from, current_node)
	if came_from[current_node] then
		local p = reconstruct_path(came_from, came_from[current_node])
		return (p + current_node) --TODO find out lua way of adding a node to a list
	else
		return current_node
	end
end

function set (list)
	local set = {}
	for _, l in ipairs(list) do set[l] = true end
	return set
end
