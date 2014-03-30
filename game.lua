require "enemy"

function love.turris.newGame()
	local o = {}
	o.map = {}
	o.ground = {}
	o.tower = {}
	o.enemies = {}
	o.enemyCount = 1
	o.dayTime = 90
	o.init = function()
		o.newGround("gfx/ground01.png")
		o.newTower("gfx/tower00")
		o.newTower("gfx/tower01")
		o.newTower("gfx/tower02")
		o.newTower("gfx/tower03")
		o.setMap(turMap.getMap())
		o.map.setState(2, 2, 1)
		o.map.setState(2, 3, 1)
		o.map.setState(11, 9, 1)
		o.map.setState(2, 9, 4)
		o.map.setState(7, 3, 3)
		o.baseX = math.floor(o.map.width / 2 + 0.5)
		o.baseY = math.floor(o.map.height / 2 + 0.5)
		o.map.setState(o.baseX, o.baseY, 2)
			o.map.setState(2, o.baseY, 1)
		local creepImg = G.newImage("gfx/creep00_diffuse.png")
	for i = 1, o.enemyCount do
		o.enemies[i]= love.turris.newEnemy(creepImg)
		o.enemies[i].x = i - 2
		o.enemies[i].y = o.baseY
	end
	end
	o.update = function(dt)
		o.dayTime = o.dayTime + dt * 0.1
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
				love.changegamestate(4)
			end
		end
	end
	o.drawMap = function()
		local dayTime = math.abs(math.sin(o.dayTime))
		lightWorld.setAmbientColor(dayTime * 239 + 15, dayTime * 191 + 31, dayTime * 143 + 63)

		lightMouse.setPosition(love.mouse.getX(), love.mouse.getY(), 63)
		lightWorld.update()

		if o.map and o.map.width and o.map.height then
			for i = 0, o.map.width - 1 do
				for k = 0, o.map.height - 1 do
					G.setColor(255, 255, 255)
					G.draw(o.ground[1], i * o.map.tileWidth, k * o.map.tileHeight)
				end
			end
			lightWorld.drawShadow()
			for i = 0, o.map.width - 1 do
				for k = 0, o.map.height - 1 do
					if o.map.map[i + 1][k + 1] > 0 then
						local img = o.tower[o.map.map[i + 1][k + 1]].img
						G.setColor(255, 255, 255)
						G.draw(img, i * o.map.tileWidth, k * o.map.tileHeight - (img:getHeight() - o.map.tileHeight))
					end
				end
			end
			lightWorld.drawPixelShadow()
			lightWorld.drawGlow()
		end
	end
	o.draw = function()
		o.drawMap()
		o.drawEnemies()
		o.drawPaths()
	end
	o.drawPaths = function()
	--    for i = 1, o.entryCount do
	--      local entry = enemyEntrances[i]
	--    end
	--local mx, my = love.mouse.getPosition()  -- current position of the mouse
	--G.line(0,300, mx, my)
	end
	o.drawEnemies = function()
		for i = 1, o.enemyCount do
			local e = o.enemies[i]
			local x = e.x
			local y = e.y
			local img = e.img
			G.setColor(255, 255, 255)
			G.draw(img, (x)*o.map.tileWidth, (y-1)*o.map.tileHeight, 0, -1.0 / img:getWidth() * o.map.tileWidth, 1.0 / img:getHeight() * o.map.tileHeight)
			-- draw path to nearest base
			G.setColor(255, 153, 0)
			G.line((x-0.5)*o.map.tileWidth, (y-0.5)*o.map.tileHeight,(o.baseX-0.5)*o.map.tileWidth, (o.baseY-0.5)*o.map.tileHeight)
		end
	end
	o.newGround = function(img)
		o.ground[#o.ground + 1] = G.newImage(img)
		return o.ground[#o.ground]
	end
	o.newTower = function(img)
		o.tower[#o.tower + 1] = love.turris.newTower(img)
		return o.tower[#o.tower]
	end
	o.getTower = function(n)
		return o.tower[n]
	end
	o.setMap = function(map)
		o.map = map
	end

	-- set font
	font = G.newImageFont("gfx/font.png", " abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789.,!?-+/():;%&`'*#=[]\"")
	font:setFilter("nearest", "nearest")
	G.setFont(font)
	
	-- create light world
	lightWorld = love.light.newWorld()
	lightWorld.setNormalInvert(true)
	lightWorld.setAmbientColor(15, 15, 31)
	lightWorld.setRefractionStrength(32.0)

	-- create light
	lightMouse = lightWorld.newLight(0, 0, 31, 191, 63, 300)
	--lightMouse.setGlowStrength(0.3)
	--lightMouse.setSmooth(0.01)
	lightMouse.setRange(300)

	return o
end