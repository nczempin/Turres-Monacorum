function love.turris.newMap(path)
	-- load map object
	love.filesystem.load("map/" .. path .. ".ini")()

	local o = {}
	o.width = map.width or 16
	o.height = map.height or 16
	o.tileWidth = map.tileWidth or 64
	o.tileHeight = map.tileHeight or 48
	o.baseX = map.baseX or math.floor(o.width * 0.5)
	o.baseY = map.baseY or math.floor(o.height * 0.5)
	o.spawn = map.spawn
	o.data = {}
	for i = 1, o.width do
		o.data[i] = {}
		for k = 1, o.height do
			o.data[i][k] = {}
			o.data[i][k].id = 0
			o.data[i][k].maxHealth = 100.0
			o.data[i][k].health = o.data[i][k].maxHealth
			o.data[i][k].addHealth = function(health)
				o.data[i][k].health = o.data[i][k].health + health
				if o.data[i][k].health < 0 then
					o.data[i][k].health = 0
				end
			end
		end
	end
	o.collision = {}
	for i = 1, o.width do
		o.collision[i] = {}
		for k = 1, o.height do
			o.collision[i][k] = 0
		end
	end
	o.shadow = {}
	o.light = {}

	o.ground = love.graphics.newImage("gfx/ground01_diffuse.png")
	o.ground:setWrap("repeat", "repeat")

	local vertices = {
		{ 0, 0, 0, 0, 50, 80, 120 },
		{ o.width * o.tileWidth, 0, (o.width * o.tileWidth) / o.ground:getWidth(), 0, 50, 80, 120 },
		{ o.width * o.tileWidth, o.height * o.tileHeight, (o.width * o.tileWidth) / o.ground:getWidth(), (o.height * o.tileHeight) / o.ground:getHeight(), 100, 80, 120 },
		{ 0, o.height * o.tileHeight, 0, (o.height * o.tileHeight) / o.ground:getHeight(), 100, 80, 120 },
	}

	o.mshGround = love.graphics.newMesh(vertices, o.ground, "fan")

	local normal = love.graphics.newImage("gfx/ground01_normal.png")
	local glow = love.graphics.newImage("gfx/ground01_glow.png")
	o.shadowGround = lightWorld.newImage(o.ground, o.width * o.tileWidth, o.height * o.tileHeight, o.width * o.tileWidth * 0.5, o.height * o.tileHeight * 0.5)
	o.shadowGround.setNormalMap(normal, o.width * o.tileWidth, o.height * o.tileHeight)
	o.shadowGround.setPosition(o.width * o.tileWidth * 0.5, o.height * o.tileHeight * 0.5)
	--o.shadowGround.setGlowMap(glow)
	o.shadowGround.setShadow(false)
	for i = 0, o.width - 1 do
		o.shadow[i + 1] = {}
		o.light[i + 1] = {}
		for k = 0, o.height - 1 do
			--o.shadow[i + 1][k + 1] = lightWorld.newImage(img, i * o.tileWidth + o.tileWidth * 0.5, k * o.tileHeight + o.tileHeight * 0.5, o.tileWidth, o.tileHeight)
			--o.shadow[i + 1][k + 1].setShadow(false)
		end
	end

	o.drawGround = function(ox, oy)
		love.graphics.draw(o.mshGround, ox, oy)
	end

	o.getState = function(x, y)
		if x > 0 and y > 0 and x <= o.width and y <= o.height then
			return o.data[x][y].id
		else
			return nil
		end
	end

	o.getHeight = function()
		return o.height
	end

	o.getMap = function()
		return o
	end

	o.getTileHeight = function()
		return o.tileHeight
	end

	o.getTileWidth = function()
		return o.tileWidth
	end

	o.getWidth = function()
		return o.width
	end

	o.setState = function(x, y, n)
		local d = o.data[x][y]
		d.id = n
		if n > 0 then
			if not o.shadow[x][y] then
				o.shadow[x][y] = lightWorld.newImage(o.ground, (x - 1) * o.tileWidth + o.tileWidth * 0.5 + turGame.offsetX, (y - 1) * o.tileHeight + o.tileHeight * 0.5 + turGame.offsetY, o.tileWidth, o.tileHeight)
			end
			o.shadow[x][y].setImage(turGame.towerType[n].img)
			o.shadow[x][y].setImageOffset(o.tileWidth * 0.5, o.tileHeight * 0.5 + (turGame.towerType[n].img:getHeight() - o.tileHeight))
			o.shadow[x][y].setNormalMap(turGame.towerType[n].normal)
			o.shadow[x][y].setNormalOffset(o.tileWidth * 0.5, o.tileHeight * 0.5 + (turGame.towerType[n].img:getHeight() - o.tileHeight))
			o.shadow[x][y].setGlowMap(turGame.towerType[n].glow)
			o.shadow[x][y].setShadow(true)

			if stateSettingsVideoShaders.optionLights then
				if n == 1 then
					o.light[x][y] = lightWorld.newLight(x * o.tileWidth - o.tileWidth * 0.5 + turGame.offsetX, y * o.tileHeight - o.tileHeight * 0.5 + turGame.offsetY, 255, 191, 63, 150)
				elseif n == 2 then
					o.light[x][y] = lightWorld.newLight(x * o.tileWidth - o.tileWidth * 0.5 + turGame.offsetX, y * o.tileHeight - o.tileHeight * 0.5 + turGame.offsetY, 127, 191, 255, 150)
				elseif n == 3 then
					o.light[x][y] = lightWorld.newLight(x * o.tileWidth - o.tileWidth * 0.5 + turGame.offsetX, y * o.tileHeight - o.tileHeight * 0.5 + turGame.offsetY, 63, 127, 255, 150)
				elseif n == 4 then
					o.light[x][y] = lightWorld.newLight(x * o.tileWidth - o.tileWidth * 0.5 + turGame.offsetX, y * o.tileHeight - o.tileHeight * 0.5 + turGame.offsetY, 63, 255, 127, 150)
				end
			end

			if n == 8 or n == 9 then
				o.shadow[x][y].setShadowType("circle", 16, 0, 0)
			end

			if turGame.towerType[n].collision and n ~= 2 then
				o.collision[x][y] = 1
			else
				o.collision[x][y] = 0
			end
		elseif n == 0 then
			if o.shadow[x][y] then
				o.shadow[x][y].clear()
				o.shadow[x][y] = nil
			end
			if o.light[x][y] then
				o.light[x][y].clear()
				o.light[x][y] = nil
			end

			o.collision[x][y] = 0
		end

		for i = 1, #turGame.enemies do
			local e = turGame.enemies[i]
			e.ai.syncStart()
			e.ai.refresh()
		end
	end

	return o
end