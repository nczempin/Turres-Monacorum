function love.turris.newEnemy(img)
	local o = {}
	o.img = img
	o.x = {}
	o.y = {}
	o.xVel = 2.0
	o.yVel = 0.0
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
				love.changegamestate(4)
				gameOverEffect = 0
			end
		end
end