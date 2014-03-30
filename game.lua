require "enemy"

function love.turris.newGame()
	local o = {}
	o.map = {}
	o.ground = {}
	o.towerType = {}
	o.towers = {}
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
		o.newTowerType("gfx/tower00")
		o.newTowerType("gfx/tower01")
		o.newTowerType("gfx/tower02")
		o.newTowerType("gfx/tower03")
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
			o.enemies[i]= love.turris.newEnemy(creepImg,o)
			o.enemies[i].x = i - 2
			o.enemies[i].y = o.baseY
		end
	end
	o.addTower = function(x,y,type)
		if not x or not y or not type then return end
		local state = o.map.getState(x,y)
		if state and state ==0 then
			o.towerCount = o.towerCount +1 -- TODO this is unsafe
			local t = {}
			t.x = x
			t.y = y
			o.map.setState(t.x, t.y, type)
			o.towers[o.towerCount] =t
			print("Turret was placed at "..x..", "..y)
		end
	end
	o.update = function(dt)
		o.dayTime = o.dayTime + dt * 0.1
		T.updateEnemies(o,dt)

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
					if o.map.data[i + 1][k + 1].id > 0 then
						local img = o.towerType[o.map.data[i + 1][k + 1].id].img
						G.setColor(255, 255, 255)
						G.draw(img, i * o.map.tileWidth + o.offsetX, k * o.map.tileHeight - (img:getHeight() - o.map.tileHeight) + o.offsetY)
						-- health
						local health = o.map.data[i + 1][k + 1].health
						local maxHealth = o.towerType[o.map.data[i + 1][k + 1].id].maxHealth
						if health < maxHealth then
							G.setColor(0, 0, 0, 127)
							G.rectangle("fill", i * o.map.tileWidth + o.offsetX - 2, k * o.map.tileHeight + o.offsetY - 16 - 2 - (img:getHeight() - o.map.tileHeight), 64 + 4, 8 + 4)
							G.setColor(255 * math.min((1.0 - health / maxHealth) * 2.0, 1.0), 255 * math.min((health / maxHealth) * 1.5, 1.0), 0)
							G.rectangle("fill", i * o.map.tileWidth + o.offsetX + 2, k * o.map.tileHeight + o.offsetY - 16 + 2 - (img:getHeight() - o.map.tileHeight), (64 - 4) * health / maxHealth, 8 - 4)
							G.setLineWidth(1)
							G.setColor(63, 255, 0)
							G.rectangle("line", i * o.map.tileWidth + o.offsetX, k * o.map.tileHeight + o.offsetY - 16 - (img:getHeight() - o.map.tileHeight), 64, 8)
						end
						-- test
						if o.map.data[i + 1][k + 1].health > 0.0 then
							o.map.data[i + 1][k + 1].health = health - 0.1
						end
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
		for i = 1, o.towerCount do
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
		G.line((x1-0.5)*o.map.tileWidth + o.offsetX, (y1-0.5) * o.map.tileHeight + o.offsetY,(x2-0.5) * o.map.tileWidth + o.offsetX, (y2 - 0.5)*o.map.tileHeight + o.offsetY)
	end
	o.drawEnemies = function()
		for i = 1, o.enemyCount do
			local e = o.enemies[i]
			local x = e.x
			local y = e.y
			local img = e.img
			G.setColor(255, 255, 255)
			G.draw(img, x * o.map.tileWidth + o.offsetX, (y - 1) * o.map.tileHeight + o.offsetY, 0, -1.0 / img:getWidth() * o.map.tileWidth, 1.0 / img:getHeight() * o.map.tileHeight)
			-- health
			if e.health < e.maxHealth then
				G.setColor(0, 0, 0, 127)
				G.rectangle("fill", (x - 1) * o.map.tileWidth + o.offsetX - 2, (y - 1) * o.map.tileHeight + o.offsetY - 16 - 2, 64 + 4, 8 + 4)
				G.setColor(255 * math.min((1.0 - e.health / e.maxHealth) * 2.0, 1.0), 255 * math.min((e.health / e.maxHealth) * 1.5, 1.0), 0)
				G.rectangle("fill", (x - 1) * o.map.tileWidth + o.offsetX + 2, (y - 1) * o.map.tileHeight + o.offsetY - 16 + 2, (64 - 4) * e.health / e.maxHealth, 8 - 4)
				G.setLineWidth(1)
				G.setColor(255, 63, 0)
				G.rectangle("line", (x - 1) * o.map.tileWidth + o.offsetX, (y - 1) * o.map.tileHeight + o.offsetY - 16, 64, 8)
			end
			-- test
			if e.health > 0.0 then
				e.health = e.health - 0.1
			end
		end
	end
	o.newGround = function(img)
		o.ground[#o.ground + 1] = G.newImage(img)
		return o.ground[#o.ground]
	end
	o.newTowerType = function(img)
		o.towerType[#o.towerType + 1] = love.turris.newTowerType(img)
		return o.towerType[#o.towerType]
	end
	o.getTower = function(n)
		return o.towerType[n]
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
	gameOverEffect = 0

	return o
end