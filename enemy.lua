require "ai/ai"
require "enemyType"

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
printWaypoints = function(e)
	print ("waypoints:")
	for i=1, #e.waypoints do
		print (i, e.waypoints[i][1], e.waypoints[i][2])
	end

end

function love.turris.newEnemy(enemyType, map, x, y, baseX, baseY)
	local o = {}


	o.generateWaypoints = function(map, startX, startY, goalX, goalY,wpCurrent)
		print ("generate:",startX,startY,goalX,goalY)
		local all_nodes = getAllNodes(map)
		local start = findNode(all_nodes, startX, startY)
		local goal = findNode(all_nodes, goalX, goalY)
		local path = aStar(start,goal,all_nodes)

		local wp = {{startX,startY},{goalX,goalY}}
		if path then
			print ("path: yes")

			if (wpCurrent and wpCurrent.x and wpCurrent.y) then
				print ("wpCurrent: ",wpCurrent.x, wpCurrent.y)
				wp ={wpCurrent}
			else
				wp = {}
			end
			local fudge = #wp
			print "copying path to waypoints"
			for i = 1, #path do
				--print ("path: ", i, path[i].x, path[i].y)
				wp[i+fudge] ={path[i].x,path[i].y}
				--print ("wp: ",wp[i+fudge][1], wp[i+fudge][2])
			end

		end
		return wp
	end
	o.x = x
	o.y = y
	o.dead = false
	o.waypoints = o.generateWaypoints(map,x,y,baseX,baseY,nil)

	o.currentWaypoint = 2

	-- TODO this depends on the type and not on the particular enemy
	o.enemyType = enemyType
	o.maxHealth = enemyType.maxHealth
	o.speed =  enemyType.baseSpeed
	o.sheet = enemyType.sheet
	-- type end

	o.health = o.maxHealth


	--o.shadow = {}
	--o.shadow = lightWorld.newImage(o.img)
	--o.shadow.setShadowType("image",32,32, 1.0)

	o.updateVelocity = function(dirX,dirY)
		o.xVel = dirX*o.speed
		o.yVel = dirY*o.speed
		if o.xVel ~=o.xVel then print ("dirX: ",dirX)end
		if o.yVel ~=o.yVel then print ("dirY: ",dirY)end
	end

	o.getDirection = function()
		return math.atan2(o.xVel, o.yVel)
	end

	o.updateVelocity(1,0) --TODO this should be determined from the current position to the next waypoint

	o.getOrientation = function()
		local x,y = love.turris.normalize(o.xVel, o.yVel)
		return x,y
	end

	o.addHealth = function(health)
		o.health = o.health + health
	end

	o.setPosition = function(x, y)
		o.x = x
		o.y = y
	end

	o.setMaxHealth = function(health)
		o.maxHealth = health
	end

	o.setHealth = function(health)
		o.health = health
	end

	o.setSpeed = function(speed)
		o.speed = speed
	end

	return o
end

function love.turris.normalize(x,y)
	local m = math.max(math.abs(x),math.abs(y))
	--print ("normalize: ", x, y, m)
	local xRet = x/m
	local yRet = y/m
	--	if (xRet ~= xRet) then
	--		print ("xRet NaN: ",xRet)
	--	end
	--	if (yRet ~= yRet) then
	--		print ("yRet NaN: ",yRet)
	--	end
	return xRet, yRet
end

function love.turris.updateEnemies(o, dt)
	for i = 1, o.enemyCount do
		local e = o.enemies[i]

		if not e.dead then
			e.x = e.x+e.xVel*dt
			e.y = e.y+e.yVel*dt

			local x = e.x
			local y = e.y

			-- check if waypoint reached
			local wp = e.waypoints[e.currentWaypoint]
			if math.abs(wp[1]-x)<0.1 and math.abs(wp[2] -y)<0.1 then --TODO use existing distance function
				-- waypoint reached
				--printWaypoints(e)
				print("wp: ",wp[1],wp[2])
				local nextWpIndex = e.currentWaypoint +1
				print("nextWpIndex: ",nextWpIndex)

				e.currentWaypoint = nextWpIndex
				local wpNext = e.waypoints[nextWpIndex]
				print("wpNext: ",wpNext[1],wpNext[2])
				local distX = wpNext[1]-wp[1]
				local distY = wpNext[2]-wp[2]
				print("dists: ",distX,distY)
				local dirX,dirY = 0,0
				--TODO: handle the case in which wpNext == currentWp => dist = (0,0) in WAYPOINT GENERATION rather than here
				if distX ~=0 or distY ~=0 then
					dirX, dirY= love.turris.normalize( distX, distY)
				end
				--TODO diagonal moves should not be allowed. See issue #31
				e.updateVelocity(dirX,dirY)
			end

			-- write back the changes
			o.enemies[i]= e
			-- check for and handle game over
			if distance_manhattan(o.baseX, o.baseY, x, y) < 0.5 then
				e.dead = true
				-- Game Over!!! (for now)
				-- TODO: destroy ship (explosion)
				-- TODO: destroy base (explosion!)
				-- TODO: after explosions have finished -> transition to game over state
				love.sounds.playSound("sounds/einschlag.mp3")
				turMap.data[o.baseX][o.baseY].addHealth(-40)
				if turMap.data[o.baseX][o.baseY].health <= 0 then
					love.setgamestate(4)
				else
					turGame.effectTimer = 0
				end
				gameOverEffect = 0
			end
		end
	end
end