function love.turris.newMap(path)
	-- load map object
	love.filesystem.load("data/map/" .. path .. ".lua")()

	local o = {}
	o.width = map.width or 16
	o.height = map.height or 16
	o.tileWidth = map.tileWidth or 64
	o.tileHeight = map.tileHeight or 48
	o.baseX = map.baseX or math.floor(o.width * 0.5)
	o.baseY = map.baseY or math.floor(o.height * 0.5)
	o.waves = map.waves
	o.tower = map.tower
	o.random = map.random
	o.energy = map.energy
	o.mass = map.mass
	o.overlayIngameMessage = require("layer/notification") -- quick solution for now. should be moved somewhere else later
	o.currentWave = 0
	o.editMode = true;

	if map.ground then
		o.groundColor = map.ground.color
		o.groundImg = map.ground.img or "ground01"
	else
		o.groundColor = nil
		o.groundImg = "ground01"
	end
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

	o.ground = love.graphics.newImage("gfx/" .. o.groundImg .. "_diffuse.png")
	o.ground:setWrap("repeat", "repeat")

	local vertices

	if o.groundColor then
		vertices = {
			{ 0, 0, 0, 0, o.groundColor[1][1], o.groundColor[1][2], o.groundColor[1][3] },
			{ o.width * o.tileWidth, 0, (o.width * o.tileWidth) / o.ground:getWidth(), 0, o.groundColor[2][1], o.groundColor[2][2], o.groundColor[2][3] },
			{ o.width * o.tileWidth, o.height * o.tileHeight, (o.width * o.tileWidth) / o.ground:getWidth(), (o.height * o.tileHeight) / o.ground:getHeight(), o.groundColor[3][1], o.groundColor[3][2], o.groundColor[3][3] },
			{ 0, o.height * o.tileHeight, 0, (o.height * o.tileHeight) / o.ground:getHeight(), o.groundColor[4][1], o.groundColor[4][2], o.groundColor[4][3] },
		}
	else
		vertices = {
			{ 0, 0, 0, 0, 50, 80, 120 },
			{ o.width * o.tileWidth, 0, (o.width * o.tileWidth) / o.ground:getWidth(), 0, 50, 80, 120 },
			{ o.width * o.tileWidth, o.height * o.tileHeight, (o.width * o.tileWidth) / o.ground:getWidth(), (o.height * o.tileHeight) / o.ground:getHeight(), 100, 80, 120 },
			{ 0, o.height * o.tileHeight, 0, (o.height * o.tileHeight) / o.ground:getHeight(), 100, 80, 120 },
		}
	end

	o.mshGround = love.graphics.newMesh(vertices, o.ground, "fan")

	local normal = love.graphics.newImage("gfx/" .. o.groundImg .. "_normal.png")
	local glow = love.graphics.newImage("gfx/" .. o.groundImg .. "_glow.png")
	o.shadowGround = lightWorld.newImage(o.ground, o.width * o.tileWidth, o.height * o.tileHeight, o.width * o.tileWidth * 0.5, o.height * o.tileHeight * 0.5)
	o.shadowGround.setNormalMap(normal, o.width * o.tileWidth, o.height * o.tileHeight)
	o.shadowGround.setPosition(o.width * o.tileWidth * 0.5, o.height * o.tileHeight * 0.5)
	--o.shadowGround.setGlowMap(glow)
	o.shadowGround.setShadow(false)
	o.shadowGround.setReflective(false)
	o.shadowGround.setRefractive(true)

	for i = 0, o.width - 1 do
		o.shadow[i + 1] = {}
		o.light[i + 1] = {}
	end

	o.init = function()
		for i = -1, 1 do
			for k = -1, 1 do
				o.setState(o.baseX + i, o.baseY + k, 10)
			end
		end
		o.setState(o.baseX, o.baseY, 2)

		if o.waves then
			o.nextWave() --this will spawn the first wave
		end

		if o.tower then
			for i = 1, #o.tower do
				o.setState(o.tower[i].x, o.tower[i].y, o.tower[i].towerType)
			end
		end

		if o.random then
			for i = 1, #o.random do
				for k = 1, o.width do
					for l = 1, o.height do
						if o.getState(k, l) == 0 then
							if math.random(1, 100) <= o.random[i].frequency then
								o.setState(k, l, o.random[i].towerType)
							end
						end
					end
				end
			end
		end
	end

	o.drawGround = function(ox, oy)
		love.graphics.draw(o.mshGround, ox, oy)
	end

	o.isLastWave = function()
		return o.currentWave == #o.waves
	end
	
	o.nextWave = function()
			turGame.spawn = {} -- resets the spawn list
			o.currentWave = o.currentWave+1
			for i = 1, #o.waves[o.currentWave].waveCreeps do
				turGame.spawn[#turGame.spawn + 1] = love.turris.newSpawn(o, o.waves[o.currentWave].waveCreeps[i].x, o.waves[o.currentWave].waveCreeps[i].y, o.baseX, o.baseY)
				turGame.spawn[#turGame.spawn].addEnemyType(turGame.enemyType[o.waves[o.currentWave].waveCreeps[i].enemyType], o.waves[o.currentWave].waveCreeps[i].delay, o.waves[o.currentWave].waveCreeps[i].count)
				o.setState(o.waves[o.currentWave].waveCreeps[i].x, o.waves[o.currentWave].waveCreeps[i].y, o.waves[o.currentWave].waveCreeps[i].towerType)
			end
			if o.waves[o.currentWave].setEnergy then
				turGame.player.setEnergy(o.waves[o.currentWave].setEnergy)
				print("setting Wave Energy")
			end
			if o.waves[o.currentWave].setMass then
				turGame.player.setMass(o.waves[o.currentWave].setMass)
				print("setting Wave Mass")
			end
			if o.waves[o.currentWave].addEnergy then
				turGame.player.addEnergy(o.waves[o.currentWave].addEnergy)
				print("setting Wave Energy")
			end
			if o.waves[o.currentWave].addMass then
				turGame.player.addMass(o.waves[o.currentWave].addMass)
				print("setting Wave Mass")
			end
			if o.waves[o.currentWave].missionText then
				print("adding overlayMessage")
				o.overlayIngameMessage.init(o.waves[o.currentWave].missionText, true, false, true)
				local k = o.overlayIngameMessage.getCopy()
				love.addsecondaryoverlay(k)
			end
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
		if x > 0 and y > 0 and x <= o.width and y <= o.height then
			local d = o.data[x][y]
			d.id = n
			if n > 0 then
				if o.shadow[x][y] then
					o.shadow[x][y].clear()
				end

				if turGame.towerType[n].water then
					o.shadow[x][y] = lightWorld.newRefraction(turGame.towerType[n].normal, (x - 1) * o.tileWidth + o.tileWidth * 0.5 + turGame.offsetX, (y - 1) * o.tileHeight + o.tileHeight * 0.5 + turGame.offsetY)
					o.shadow[x][y].setReflection(true)
					o.shadow[x][y].setPixelShadow(true)
				else
					o.shadow[x][y] = lightWorld.newImage(o.ground, (x - 1) * o.tileWidth + o.tileWidth * 0.5 + turGame.offsetX, (y - 1) * o.tileHeight + o.tileHeight * 0.5 + turGame.offsetY, o.tileWidth, o.tileHeight)
					o.shadow[x][y].setReflective(true)
					o.shadow[x][y].setImage(turGame.towerType[n].img)
					o.shadow[x][y].setImageOffset(o.tileWidth * 0.5, o.tileHeight * 0.5 + (turGame.towerType[n].img:getHeight() - o.tileHeight))
					o.shadow[x][y].setNormalMap(turGame.towerType[n].normal)
					o.shadow[x][y].setNormalOffset(o.tileWidth * 0.5, o.tileHeight * 0.5 + (turGame.towerType[n].img:getHeight() - o.tileHeight))
					o.shadow[x][y].setGlowMap(turGame.towerType[n].glow)
					o.shadow[x][y].setShadow(true)
				end

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

				if turGame.towerType[n].collision and turGame.towerType[n].breakable then
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
	end

	return o
end