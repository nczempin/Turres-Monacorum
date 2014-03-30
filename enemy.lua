require "ai/ai"

function getAllNodes(map)
	local w = map.width
	local h = map.height
	local nodes = {}

	local k = 1
	for i = 0, w do
		for j = 0, h do

			nodes[k]= {x=i,y=j,id=k}
			k = k + 1
		end
	end
	return nodes
end

function findNode(nodes, x, y)
	for i = 1, #nodes do
		if nodes[i].x == x and nodes[i].y == y then
			return nodes[i]
		end
	end
end

function love.turris.newEnemy(img, map, x,y,baseX, baseY)
	local o = {}
	o.generateWaypoints = function(map, startX, startY, goalX, goalY)
		local all_nodes = getAllNodes(map)
		local start = findNode(all_nodes, startX, startY)
		local goal = findNode(all_nodes, goalX, goalY)
		local path = aStar(start,goal,all_nodes)
	
		local wp = {{startX,startY},{goalX,goalY}}
		for i = 1, #path do
			wp[i] ={path[i].x,path[i].y}
		end
		return wp
	end
	o.img = img
	o.x = x
	o.y = y
	o.waypoints = o.generateWaypoints(map,x,y,baseX,baseY)

	o.currentWaypoint = 2
	o.health = 100.0

	-- TODO this depends on the type and not on the particular enemy
	o.maxHealth = 100.0
	o.speed = 1.0
	-- type end

	--o.shadow = {}
	--o.shadow = lightWorld.newImage(o.img)
	--o.shadow.setShadowType("image",32,32, 1.0)

	o.updateVelocity = function(dirX,dirY)
		o.xVel = dirX*o.speed
		o.yVel = dirY*o.speed
	end

	o.getDirection = function()
		return math.atan2(o.xVel, o.yVel)
	end

	o.updateVelocity(1,0) --TODO this should be determined from the current position to the next waypoint

	o.getOrientation = function()
		local x,y = love.turris.normalize(o.xVel, o.yVel)
		return x,y
	end

	return o
end

function distance(x1,y1,x2,y2) --TODO let's not leave this global
	-- manhattan is sufficient for now
	return math.abs(x1-x2)+math.abs(y1-y2)
end

function love.turris.normalize(x,y)
	local m = math.max(math.abs(x),math.abs(y))
	return x/m, y/m
end

function love.turris.updateEnemies(o,dt)
	for i = 1, o.enemyCount do
		local e = o.enemies[i]
		e.x = e.x+e.xVel*dt
		e.y = e.y+e.yVel*dt

		local x = e.x
		local y = e.y

		-- check if waypoint reached
		local wp = e.waypoints[e.currentWaypoint]
		if math.abs(wp[1]-x)<0.1 and math.abs(wp[2] -y)<0.1 then
			-- waypoint reached
			local nextWpIndex = e.currentWaypoint +1
			e.currentWaypoint = nextWpIndex
			local wpNext = e.waypoints[nextWpIndex]
			local dirX,dirY = love.turris.normalize( wpNext[1]-wp[1], wpNext[2]-wp[2])
			e.updateVelocity(dirX,dirY)
		end

		-- write back the changes
		o.enemies[i]= e
		-- check for and handle game over
		if math.abs(o.baseX - x) <1 and math.abs(y - o.baseY) < 1 then
			-- Game Over!!! (for now)
			-- TODO: destroy ship (explosion)
			-- TODO: destroy base (explosion!)
			-- TODO: after explosions have finished -> transition to game over state
			love.sounds.playSound("sounds/einschlag.mp3")
			love.setgamestate(4)
			gameOverEffect = 0
		end
	end
end