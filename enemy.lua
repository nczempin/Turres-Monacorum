require "ai/ai"

function love.turris.newEnemy(img, map)
	local o = {}
	o.img = img
	o.x = {}
	o.y = {}
	o.xVel = 2.0
	o.yVel = 0.0
	o.waypoints = {}
	local wp = {1,map.baseY}
	o.waypoints[1]= wp
	wp = {2,map.baseY+1}
	o.waypoints[2]= wp
	o.currentWaypoint = 1
	o.health = 100.0
	o.maxHealth = 100.0

	return o
end

function love.turris.updateEnemies(o,dt)
		for i = 1, o.enemyCount do
			o.enemies[i].x = o.enemies[i].x+o.enemies[i].xVel*dt
			o.enemies[i].y = o.enemies[i].y+o.enemies[i].yVel*dt

			local x = o.enemies[i].x
			local y = o.enemies[i].y
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