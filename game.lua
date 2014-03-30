require "enemy"

function love.turris.newGame()
	local o = {}
	o.map = {}
	o.ground = {}
	o.tower = {}
	o.enemies = {}
	o.enemyCount = 1
	o.dayTime = 90
	o.offsetX = 0.0
	o.offsetY = 0.0
	o.offsetChange = false
	o.init = function()
		o.setMap(turMap.getMap())
		o.baseX = math.floor(o.map.width / 2 + 0.5)
		o.baseY = math.floor(o.map.height / 2 + 0.5)
		o.newGround("gfx/ground01.png")
		o.newTower("gfx/tower00")
		o.newTower("gfx/tower01")
		o.newTower("gfx/tower02")
		o.newTower("gfx/tower03")
		o.towers = {}
		o.towerCount = 0 -- TODO: get the correct number of towers (and fill the tower array)

		o.addTower(2,2,1)
		o.addTower(2,3,1)
		o.addTower(11, 9, 1)
		o.addTower(2, o.baseY, 1) --TODO debugging tower to block the path right away
		o.map.setState(2, 9, 4)
		o.map.setState(7, 3, 3)
		o.map.setState(o.baseX, o.baseY, 2)
		local creepImg = G.newImage("gfx/creep00_diffuse.png")
		for i = 1, o.enemyCount do
			o.enemies[i]= love.turris.newEnemy(creepImg,i-1,o.baseY)
		end
	end
	o.addTower = function(x,y,type)
		local t = {}
		t.x = x
		t.y = y
		o.map.setState(t.x, t.y, type)
		o.towers[o.towerCount] =t
		o.towerCount = o.towerCount +1 -- TODO this is unsafe

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

		if love.keyboard.isDown("left") then
			o.offsetX = o.offsetX + dt * 200.0
			o.offsetChange = true
		elseif love.keyboard.isDown("right") then
			o.offsetX = o.offsetX - dt * 200.0
			o.offsetChange = true
		end

		if love.keyboard.isDown("up") then
			o.offsetY = o.offsetY + dt * 200.0
			o.offsetChange = true
		elseif love.keyboard.isDown("down") then
			o.offsetY = o.offsetY - dt * 200.0
			o.offsetChange = true
		end

		if o.offsetChange then
			for i = 1, o.map.width do
				for k = 1, o.map.height do
					o.map.shadow[i][k].setPosition(i * o.map.tileWidth - o.map.tileWidth * 0.5 + o.offsetX, k * o.map.tileHeight - o.map.tileHeight * 0.5 + o.offsetY)
					--o.map.shadow[i][k].setImageOffset(i * o.map.tileWidth + o.offsetX, k * o.map.tileHeight + o.offsetY)
					--o.map.shadow[i][k].setImageOffset(i * o.map.tileWidth + o.map.tileWidth * 0.5 - o.offsetX, k * o.map.tileHeight * 0.5 + (o.tower[1].img:getHeight() - o.map.tileHeight) - o.offsetY)
					--o.map.shadow[i][k].setNormalOffset(i * o.map.tileWidth + o.map.tileWidth * 0.5 - o.offsetX, k * o.map.tileHeight * 0.5 + (o.tower[1].img:getHeight() - o.map.tileHeight) - o.offsetY)
				end
			end
			o.offsetChange = false
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
					G.draw(o.ground[1], i * o.map.tileWidth + o.offsetX, k * o.map.tileHeight + o.offsetY)
				end
			end
			lightWorld.drawShadow()
			for i = 0, o.map.width - 1 do
				for k = 0, o.map.height - 1 do
					if o.map.map[i + 1][k + 1] > 0 then
						local img = o.tower[o.map.map[i + 1][k + 1]].img
						G.setColor(255, 255, 255)
						G.draw(img, i * o.map.tileWidth + o.offsetX, k * o.map.tileHeight - (img:getHeight() - o.map.tileHeight) + o.offsetY)
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
		o.drawShots()
	end
	o.drawShots = function()
		local e = o.enemies[1]		-- TODO this is a hack because I know there's only one creep for now

		local x, y = e.x, e.y
		G.setColor(255, 0, 0)
		for i = 1, o.towerCount-1 do
			-- TODO which tower shoots what should be determined in update(); here we should only draw what has already been determined
			local t = o.towers[i]
			o.drawLine(t.x,t.y, x,y) -- TODO use tower coordinates

		end
	end
	o.drawPaths = function()
		--    for i = 1, o.entryCount do
		--      local entry = enemyEntrances[i]
		--    end
		--local mx, my = love.mouse.getPosition()  -- current position of the mouse
		--G.line(0,300, mx, my)
		for i = 1, o.enemyCount do
			local e = o.enemies[i]
			local x = e.x
			local y = e.y
			G.setColor(232, 118, 0)
			o.drawLine(x,y,o.baseX,o.baseY)
		end
	end
	-- draw a line in world coordinates
	o.drawLine = function(x1,y1,x2,y2)
		G.line((x1-0.5)*o.map.tileWidth, (y1-0.5)*o.map.tileHeight,(x2-0.5)*o.map.tileWidth, (y2-0.5)*o.map.tileHeight)

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