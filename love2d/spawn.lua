function love.turris.newSpawn(map, x, y, baseX, baseY)
	local o = {}

	o.x = x
	o.y = y
	o.baseX = baseX
	o.baseY = baseY
	o.map = map
	o.count = 0
	o.font = G.newFont(20)

	o.enemyType = {}

	o.update = function(dt)
		for i = 1, #o.enemyType do
			if o.enemyType[i].count >= 1 then
				o.enemyType[i].spawnTime = o.enemyType[i].spawnTime + dt
				if o.enemyType[i].spawnTime >= o.enemyType[i].delay then
					turGame.enemyCount = turGame.enemyCount + 1
					turGame.enemies[turGame.enemyCount] = love.turris.newEnemy(o.enemyType[i].enemyType, o.map, o.x, o.y, o.baseX, o.baseY)

					o.enemyType[i].spawnTime = 0
					o.enemyType[i].count = o.enemyType[i].count - 1
					o.count = o.count - 1
				end
			end
		end
	end

	o.draw = function()
		local x = math.floor(o.x * o.map.tileWidth - o.map.tileWidth * 0.5 + turGame.offsetX)
		local y = math.floor(o.y * o.map.tileHeight - o.map.tileHeight * 0.5 + turGame.offsetY - 16 - math.sin(love.timer.getTime() * 5) * 4)

		love.graphics.setColor(255, 127, 63)
		love.graphics.polygon("fill", x - 26, y - 41, x + 26, y - 41, x, y + 2)
		love.graphics.setColor(127, 0, 0)
		love.graphics.polygon("fill", x - 24, y - 40, x + 24, y - 40, x, y)
		love.graphics.setFont(o.font)
		love.graphics.setColor(255, 127, 0)
		love.graphics.printf(o.count, x - 32, y - 40, 64, "center")
	end

	o.addEnemyType = function(enemyType, delay, count)
		o.enemyType[#o.enemyType + 1] = {}
		o.enemyType[#o.enemyType].enemyType = enemyType
		o.enemyType[#o.enemyType].delay = delay
		o.enemyType[#o.enemyType].count = count
		o.enemyType[#o.enemyType].spawnTime = 0
		o.count = o.count + count

		return o.enemyType[#o.enemyType]
	end

	return o
end