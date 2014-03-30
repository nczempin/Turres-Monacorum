require "ai/ai"

function love.turris.newEnemy(img, map)
	local o = {}
	o.img = img
	o.x = {}
	o.y = {}
	o.waypoints = {{0,map.baseY},{1,map.baseY},{1,map.baseY-1},{3,map.baseY-1},{3,map.baseY},{map.baseX,map.baseY}}
	o.currentWaypoint = 2
	o.health = 100.0
	
	-- TODO this depends on the type and not on the particular enemy
	o.maxHealth = 100.0
	o.speed = 2
	-- type end

	o.xVel = o.speed
	o.yVel = 0.0


	o.getOrientation = function()
		return o.xVel, o.yVel -- TODO normalize
	end
	return o
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
				e.currentWaypoint = e.currentWaypoint + 1
			e.xVel = 0
			e.yVel = -e.speed
		end

		-- write back the changes
		o.enemies[i]= e
		-- check for and handle game over
		if math.abs(o.baseX - x) <1 and math.abs(y - o.baseY) < 1 then
			-- Game Over!!! (for now)
			-- TODO: destroy ship (explosion)
			-- TODO: destroy base (explosion!)
			-- TODO: after explosions have finished -> transition to game over state
			love.sounds.playSound("sounds/main_base_explosion.wav")
			love.setgamestate(4)
			gameOverEffect = 0
		end
	end
end