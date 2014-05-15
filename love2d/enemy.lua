--require "ai/ai"
require "enemyType"

function getAllNodes(map)
	local w = map.width
	local h = map.height
	local nodes = {}

	local k = 1

	for i = 0, w do
		for j = 0, h do
			nodes[k]= { x = i, y = j, id = k }
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
	for i = 1, #e.waypoints do
		print (i, e.waypoints[i][1], e.waypoints[i][2])
	end

end

function love.turris.newEnemy(enemyType, map, x, y, baseX, baseY)
	local o = {}

	o.x = x
	o.y = y
	o.dead = false
	--o.waypoints = o.generateWaypoints(map, x, y, baseX, baseY, nil)
	o.ai = love.ai.newAI()
	o.ai.setMap(map.collision)
	o.ai.setStartPosition(x, y)
	o.ai.setEndPosition(baseX, baseY)
	o.ai.setSpeed(enemyType.baseSpeed)
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

	o.update = function(dt)
		o.ai.update(dt)
	end

	o.getBaseDamage = function()
		return o.enemyType.baseDamage
	end

	o.updateVelocity = function(dirX, dirY)
		o.xVel = dirX * o.speed
		o.yVel = dirY * o.speed
		if o.xVel ~= o.xVel then print ("dirX: ", dirX)end
		if o.yVel ~= o.yVel then print ("dirY: ", dirY)end
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

function love.turris.normalize(x, y)
	local m = math.max(math.abs(x), math.abs(y))
	--print ("normalize: ", x, y, m)
	local xRet = x / m
	local yRet = y / m
	--	if (xRet ~= xRet) then
	--		print ("xRet NaN: ",xRet)
	--	end
	--	if (yRet ~= yRet) then
	--		print ("yRet NaN: ",yRet)
	--	end
	return xRet, yRet
end

function love.turris.updateEnemies(o, dt)
	local won = true

	for i = 1, #o.enemies do
		local e = o.enemies[i]

		if not e.dead then
			e.update(dt)

			if e.ai.path and e.ai.getCurrentLength() < 0.5 then
				e.dead = true
				-- Game Over!!! (for now)
				-- TODO: destroy ship (explosion)
				-- TODO: destroy base (explosion!)
				-- TODO: after explosions have finished -> transition to game over state
				love.sounds.playSound("sounds/einschlag.mp3")
				local damage = e.getBaseDamage()
				print ("damage: ",damage)
				turMap.data[o.baseX][o.baseY].addHealth(-damage) --TODO: Each creep does different damage to the base, see issue #87
				turGame.effectTimer = 0

				gameOverEffect = 0
			end
		end
	end
end