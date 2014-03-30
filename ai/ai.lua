require "ai/a-star"

function aStar(start, goal, all_nodes)
	-- this function determines which neighbors are valid (e.g., within range)
	local valid_node_func = function ( node, neighbor )

		local MAX_DIST = 300

		-- helper function in the a-star module, returns distance between points
		if astar.distance ( node.x, node.y, neighbor.x, neighbor.y ) < MAX_DIST then
			return true
		end
		return false
	end

	local ignore = true -- ignore cached paths

	local path = astar.path ( start, goal, all_nodes, ignore, valid_node_func )

	if path then
	-- do something with path (a lua table of ordered nodes from start to end)
	end
end


--function aStar_attempt(start,goal)
--	print ("entering aStar. start = "..start.x..", "..start.y)
--	local closedset =set{}    -- The set of nodes already evaluated.
--	local openset = {start}    -- The set of tentative nodes to be evaluated, initially containing the start node
--	--	for _, l in ipairs(openset) do
--	--		print (_,l.x,l.y)
--	--	end
--	local came_from = {}    -- The map of navigated nodes.
--
--	local g_score=  {}
--	local f_score = {}
--	g_score[start] = 0   -- Cost from start along best known path.
--	-- Estimated total cost from start to goal through y.
--	f_score[start] = g_score[start] + distance(start.x,start.y, goal.x, goal.y)
--	--print (#openset)
--	while #openset>0 do
--		local current = getLowest(openset, f_score) -- the node in openset having the lowest f_score[] value
--		print (#openset,current.x,current.y)
--		if current.x == goal.x and current.y == goal.y then
--			return reconstruct_path(came_from, goal)
--		end
--		--
--		openset[current]=false
--		closedset[current]=true
--		local nn = neighbor_nodes(current)
--		--print ("nn: ",nn)
--		for i=1, #nn do
--			local neighbor = nn[i]
--			print ("neighbors: ",i,neighbor.x, neighbor.y)
--			if not neighbor or not neighbor.x or not neighbor.y or not current.x or not current.y or closedset[neighbor]then
--			--                continue
--			else
--
--				local tentative_g_score = g_score[current] + distance(current.x,current.y,neighbor.x,neighbor.y)
--				--
--				if not openset[neighbor] or tentative_g_score < g_score[neighbor]then
--					came_from[neighbor] = current
--					g_score[neighbor] = tentative_g_score
--					f_score[neighbor] = g_score[neighbor] + distance(neighbor.x,neighbor.y,goal.x,goal.y)
--					if not openset[neighbor] then
--						openset[neighbor] = true
--					end
--				end
--			end
--		end
--	end
--	return nil
--end
--function reconstruct_path(came_from, current_node)
--	if came_from[current_node] then
--		local p = reconstruct_path(came_from, came_from[current_node])
--		print ("hello")
--		return (p + current_node) --TODO find out lua way of adding a node to a list
--	else
--		return current_node
--	end
--end
--
--function set (list)
--	local set = {}
--	for _, l in ipairs(list) do set[l] = true end
--	return set
--end
--function getLowest(set, scores)
--	local lowestScore = 9999999 --TODO find out how to do MAXINT in Lua
--	local lowestNode = {x=-1,y=-1}
--	for i = 1, #set do
--		local node = set[i]
--		--print (node.x,node.y)
--		if scores[node] and scores[node] < lowestScore then
--			lowestScore = scores[node]
--			lowestNode = node
--			print ("new lowest score: "..lowestScore, node.x,node.y)
--		end
--	end
--	return lowestNode
--end
--
--function neighbor_nodes(node)
--	if  node.x and node.y then
--		local nn = {{node.x-1,node.y},{node.x+1,node.y},{node.x,node.y-1},{node.x,node.y-1}}
--		return nn
--	else
--		return {}
--	end
--end
