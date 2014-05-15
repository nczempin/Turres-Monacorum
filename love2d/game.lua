require "enemy"
require "tower"
require "player"
require "layer/hud"
require "graphics"

function love.turris.newGame()
	local o = {}
	o.map = {}
	o.towerType = {}
	o.towers = {} -- circular list
	o.spawn = {}
	o.towers.maxamount = 0
	o.towerCount = 0
	o.towers.next = 1
	o.enemies = {}
	o.enemyCount = 0
	o.enemyTypes = {}
	o.dayTime = 90
	o.effectTimer = 99
	o.offsetX = 0.0
	o.offsetY = 0.0
	o.offsetChange = true
	o.timer = 0
	o.holdOffset = false
	o.holdOffsetX = 0
	o.holdOffsetY = 0
	o.calcAi = 0
	o.spawnTime = 0
	o.mission = nil

	o.init = function()
		o.player = love.turris.newPlayer()
		o.setMap(turMap.getMap())
		o.baseX = map.baseX
		o.baseY = map.baseX
		o.towers.maxamount = o.map.width * o.map.height

		for x = 1, o.map.height do
			for y = 1, o.map.width do
				o.towers[x*o.map.height+y]=nil
			end
		end

		o.mapCursorNormal = G.newImage("gfx/map_cursor_normal.png")
		o.mapCursorBlock = G.newImage("gfx/map_cursor_block.png")
		o.creepImg1 = G.newImage("gfx/creep00_diffuse_sheet.png")
		o.creepAnim1 = newAnimation(o.creepImg1, o.creepImg1:getWidth(), o.creepImg1:getHeight() / 8.0, 0, 0)
		o.creepImg2 = G.newImage("gfx/creep01_diffuse_sheet.png")
		o.creepAnim2 = newAnimation(o.creepImg2, o.creepImg2:getWidth(), o.creepImg2:getHeight() / 8.0, 0, 0)
		local img -- TODO

		o.enemyType = {}
		o.enemyType[1] = love.turris.newEnemyType(1, o.creepAnim1, 100, 1.0)
		o.enemyType[2] = love.turris.newEnemyType(2, o.creepAnim2, 2000, 0.5)

		o.enemyTypes = { o.enemyType[1], o.enemyType[2] }

		laserTower = o.newTowerType("gfx/tower00")
		generatorTower = o.newTowerType("gfx/tower01")
		energyTower = o.newTowerType("gfx/tower02")
		massTower = o.newTowerType("gfx/tower03")
		bombTower = o.newTowerType("gfx/tower04")
		spawnHole = o.newTowerType("gfx/obstacle00")
		spawnEggs = o.newTowerType("gfx/obstacle01")
		Rock1 = o.newTowerType("gfx/obstacle02")
		Rock2 = o.newTowerType("gfx/obstacle03")
		Water = o.newTowerType("gfx/obstacle04")

		laserTower.setRange(2.5)

		laserTower.setUpperImage(true)
		generatorTower.setUpperImage(true)
		energyTower.setUpperImage(true)
		massTower.setUpperImage(true)
		bombTower.setUpperImage(true)

		Water.water = true

		generatorTower.setBreakable(false)
		spawnHole.setBreakable(false)
		spawnEggs.setBreakable(false)
		Water.setBreakable(false)

		spawnHole.setCollision(false)
		spawnEggs.setCollision(false)
		Water.setCollision(false)

		energyTower.setEnergyGeneration(10)
		energyTower.buildCost = 50
		massTower.setMassGeneration(5)

		o.map.init()
		o.player.setEnergy(o.map.energy or 20)
		o.player.setMass(o.map.mass or 20)

		o.imgLaser = G.newImage("gfx/laserbeam_blue.png")
		o.imgLaser:setWrap("repeat", "repeat")
		local vertices = {
			{ 0, 0, 0, 0, 255, 0, 0 },
			{ o.imgLaser:getWidth(), 0, 1, 0, 0, 255, 0 },
			{ o.imgLaser:getWidth(), o.imgLaser:getHeight(), 1, 1, 0, 0, 255 },
			{ 0, o.imgLaser:getHeight(), 0, 1, 255, 255, 0 },
		}

		o.mshLaser = love.graphics.newMesh(vertices, o.imgLaser, "fan")

		o.imgPath = G.newImage("gfx/path_arrow.png")
		o.imgPath:setWrap("repeat", "repeat")
		o.imgPath:setFilter("nearest", "nearest")
		vertices = {
			{ 0, 0, 0, 0, 255, 0, 0,},
			{ o.imgPath:getWidth(), 0, 1, 0, 0, 255, 0 },
			{ o.imgPath:getWidth(), o.imgPath:getHeight(), 1, 1, 0, 0, 255 },
			{ 0, o.imgPath:getHeight(), 0, 1, 255, 255, 0 },
		}

		o.mshPath = love.graphics.newMesh(vertices, o.imgPath, "fan")

		o.layerHud = love.turris.newHudLayer(o.player)
		o.layerGameOver = require("layer/gameover")
		o.layerWin = require("layer/win")
		o.layerCountdown = require("layer/countdown")
		o.layerMissionBriefing = require("layer/missionBriefing")
		o.update(0.001)
	end

	-- gameplay

	o.addTower = function(x, y, id)
		if x >= 1 and x <= o.map.width and y >= 1 and y <= o.map.height and id and o.towerCount < o.towers.maxamount then
			local state = o.map.getState(x, y)

			if state and state == 0 then
				--print ("x, y:",x,y)
				local tt = o.towerType[id]
				if tt.buildCost > o.player.mass then return end
				local t = love.turris.newTower(tt, x, y, id)
				--print ("tower: ",t, t.x, t.y)
				o.map.setState(t.x, t.y, id)
				--Playing Sound When Tower is Placed
				if currentgamestate == 1 then --TODO we should make sure that towers can never be _placed_ in any other state
					love.sounds.playSound("sounds/tower_1.mp3")
				end
				o.towers[x * o.map.height + y] = t
				o.towerCount = o.towerCount + 1
				o.player.addMass(-tt.buildCost)
			end
		end
	end

	o.removeTower = function(x, y) --can remove from a position
		if x >= 1 and x <= o.map.width and y >= 1 and y <= o.map.height then
			print("will try to remove tower at " .. x .. ", " .. y)
			local state = o.map.getState(x, y)

			if state and state ~= 0 then
				if o.towerType[state].breakable then -- TODO: let towers other than type 1 be deleted
					local scrapValue = o.towerType[state].scrapValue
					o.player.addMass(scrapValue)

					o.towerCount = o.towerCount-1
					o.towers[x * o.map.height + y] = nil
					turMap.setState(x, y, 0)
				else
					print("Could not delete tower at " .. x .. ", " .. y)
				end
			end
	else
		print ("nothing will be removed here!" .. x .. " " .. o.map.width .. " " ..y.. " " .. o.map.height)
	end
	end

	-- returns tower at given coordinates or nil
	o.gettowerAt = function(x, y)
		return o.towers[x * o.map.height + y]
	end

	-- returns tower at given position or the next tower or nil
	o.getnextTower = function(arrayPos)
		for i = arrayPos, o.towers.maxamount do
			if o.towers[i] then
				--print("returning tower..."..o.towers[i].x..", "..o.towers[i].y.." "..arrayPos)
				return o.towers[i]
			end
		end
		return nil
	end

	o.updateCamera = function(dt)
		if love.mouse.isDown("m") then
			if holdOffset then
				o.offsetX = o.offsetX - (holdOffsetX - love.mouse.getX())
				o.offsetY = o.offsetY - (holdOffsetY - love.mouse.getY())
			else
				holdOffset = true
			end

			o.offsetChange = true
		else
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

			if o.layerHud.guiGame.hover then
				local border = 64

				if love.mouse.getX() < border then
					o.offsetX = o.offsetX + dt * (border - love.mouse.getX()) ^ 1.5
					o.offsetChange = true
				elseif love.mouse.getX() > W.getWidth() - border then
					o.offsetX = o.offsetX - dt * (border - (W.getWidth() - love.mouse.getX())) ^ 1.5
					o.offsetChange = true
				end

				if love.mouse.getY() < border then
					o.offsetY = o.offsetY + dt * (border - love.mouse.getY()) ^ 1.5
					o.offsetChange = true
				elseif love.mouse.getY() > W.getHeight() - border then
					o.offsetY = o.offsetY - dt * (border - (W.getHeight() - love.mouse.getY())) ^ 1.5
					o.offsetChange = true
				end
			end
		end

		if turMap.getWidth() * turMap.getTileWidth() > W.getWidth() then
			if o.offsetX > 0 then
				o.offsetX = 0
			elseif o.offsetX < W.getWidth() - turMap.getWidth() * turMap.getTileWidth() then
				o.offsetX = W.getWidth() - turMap.getWidth() * turMap.getTileWidth()
			end
		else
			o.offsetX = W.getWidth() * 0.5 - turMap.getWidth() * turMap.getTileWidth() * 0.5
		end

		if turMap.getHeight() * turMap.getTileHeight() > W.getHeight() then
			if o.offsetY > 0 then
				o.offsetY = 0
			elseif o.offsetY < W.getHeight() - turMap.getHeight() * turMap.getTileHeight() then
				o.offsetY = W.getHeight() - turMap.getHeight() * turMap.getTileHeight()
			end
		else
			o.offsetY = W.getHeight() * 0.5 - turMap.getHeight() * turMap.getTileHeight() * 0.5
		end

		holdOffsetX = love.mouse.getX()
		holdOffsetY = love.mouse.getY()
	end

	o.update = function(dt)
		o.layerHud.update(dt)

		o.effectTimer = o.effectTimer + dt
		o.dayTime = o.dayTime + dt * 0.01
		o.spawnTime = o.spawnTime + dt
		T.updateEnemies(o, dt)

		local win = true

		for i = 1, #o.enemies do
			if not o.enemies[i].dead then
				win = false
			end
		end

		for i = 1, #o.spawn do
			if o.spawn[i].count > 0 then
				win = false
			end
		end

		if win then
			love.setgamestate(13)
			love.turris.save[o.mission] = true
			love.filesystem.write("save.ini", Tserial.pack(love.turris.save))
		elseif o.map.data[o.baseX][o.baseY].health <= 0 then --TODO: Multiple bases? Or I guess this is the main base; we don't care if the other generators die
			love.setgamestate(4)
		end

		o.updateCamera(dt)

		for i = 1, #o.spawn do
			o.spawn[i].update(dt)
		end

		-- update shadows
		if o.offsetChange then
			o.map.shadowGround.setPosition(o.map.width * o.map.tileWidth * 0.5 + o.offsetX, o.map.height * o.map.tileHeight * 0.5 + o.offsetY)
			for i = 1, o.map.width do
				for k = 1, o.map.height do
					if o.map.shadow[i][k] then
						o.map.shadow[i][k].setPosition(i * o.map.tileWidth - o.map.tileWidth * 0.5 + o.offsetX, k * o.map.tileHeight - o.map.tileHeight * 0.5 + o.offsetY)
						if o.map.light[i][k] then
							o.map.light[i][k].setPosition(i * o.map.tileWidth - o.map.tileWidth * 0.5 + o.offsetX, k * o.map.tileHeight - o.map.tileHeight * 0.5 + o.offsetY)
						end
					end
				end
			end
			o.offsetChange = false
		end

		-- update light
		for i = 1, o.map.width do
			for k = 1, o.map.height do
				if o.map.data[i][k].id == 2 and o.map.light[i][k] then
					o.map.light[i][k].setRange(200 - math.sin(o.dayTime * 150.0) * 50)
				end
				if o.map.data[i][k].id > 0 and turGame.towerType[o.map.data[i][k].id].water then
					o.map.shadow[i][k].setNormalTileOffset(o.dayTime * -2000, o.dayTime * -1000)
				end
			end
		end

		-- update animations
		--o.creepAnim:update(dt)
		local laserVolume = 0
		local lastTowerPos = 0 -- has to be 0 so the first call can detect a tower at field 1
		for i = 1, o.towerCount do
			-- TODO which tower shoots what should be determined in update(); here we should only draw what has already been determined
			local t = o.getnextTower(lastTowerPos + 1) -- the next tower will always be after the first one. Do not ask for a tower after the last one, you will get nil

			if t then
				o.player.addEnergy(t.type.energyGeneration * dt)
				o.player.addMass(t.type.massGeneration * dt)
				if t.id == 1 then -- laser tower
					t.target = nil
					local energyCost = dt * t.type.shotCost
					if energyCost <= o.player.energy then
						local e = t.determineTarget(o.enemies, distance_euclid)
						t.target = e --TODO just do that inside tower module

						if e then
							laserVolume = laserVolume + 0.45
							o.player.addEnergy(-energyCost)
							if e.health > 0.0 then
								e.health = e.health - t.type.damage*dt
								if e.health <= 0 then
									e.dead = true
									e.enemyType.playDeathSound()
								end
							end
						else
						-- would like to shoot but can't. possibly play a "no energy" sound
						end
					end
				end
				lastTowerPos = t.x*o.map.height+t.y
			end
		end
		love.sounds.setSoundVolume(laserVolume,"sounds/weapons/laser_loop.ogg")

		-- test
		--TODO: -> player.update
		--		o.player.addMass(dt*2)
		--		o.player.addEnergy(dt*5)
	end
	--------------------- drawing starts here

	o.drawMap = function()
		local dayTime = math.abs(math.sin(o.dayTime))
		--lightWorld.setAmbientColor(dayTime * 223 + 31, dayTime * 159 + 63, dayTime * 63 + 127)
		lightWorld.setAmbientColor(dayTime * 240 + 15, dayTime * 223 + 15, dayTime * 191 + 31)

		lightMouse.setPosition(love.mouse.getX(), love.mouse.getY(), 63)

		G.setBlendMode("alpha")

		if o.map then
			G.setColor(255, 255, 255)
			o.map.drawGround(o.offsetX, o.offsetY)
			lightWorld.drawShadow()
			for i = 0, o.map.width - 1 do
				for k = 0, o.map.height - 1 do
					local tile = o.map.data[i + 1][k + 1]
					local id = tile.id
					if id > 0 then
						local tower = o.towerType[id]
						-- tile
						if not (lightWorld.optionShadows and lightWorld.optionPixelShadows) then
							G.setColor(0, 0, 0, 127)
							G.draw(tower.img, i * o.map.tileWidth + o.offsetX + o.map.tileWidth * 0.5, k * o.map.tileHeight - (tower.img:getHeight() - o.map.tileHeight) + o.offsetY + o.map.tileHeight * 0.5, 0, (o.map.tileWidth + 4.0) / o.map.tileWidth, (o.map.tileWidth + 4.0) / o.map.tileWidth, o.map.tileWidth * 0.5, o.map.tileHeight * 0.5)
						end

						G.setColor(255, 255, 255)
						G.draw(tower.img, i * o.map.tileWidth + o.offsetX, k * o.map.tileHeight - (tower.img:getHeight() - o.map.tileHeight) + o.offsetY)
					end
				end
			end
		end
	end

	o.drawTowerHealth = function()
		G.setBlendMode("alpha")

		if o.map and o.map.width and o.map.height then
			for i = 0, o.map.width - 1 do
				for k = 0, o.map.height - 1 do
					local tile = o.map.data[i + 1][k + 1]
					local id = tile.id
					if id > 0 then
						local tower = o.towerType[id]
						-- health
						local health = tile.health
						local maxHealth = tile.maxHealth
						if health < maxHealth then
							--draw health bar
							G.setColor(0, 0, 0, 127)
							G.rectangle("fill", i * o.map.tileWidth + o.offsetX - 2, k * o.map.tileHeight + o.offsetY - 16 - 2 - (tower.img:getHeight() - o.map.tileHeight), 64 + 4, 8 + 4)
							G.setColor(255 * math.min((1.0 - health / maxHealth) * 2.0, 1.0), 255 * math.min((health / maxHealth) * 1.5, 1.0), 0)
							G.rectangle("fill", i * o.map.tileWidth + o.offsetX + 2, k * o.map.tileHeight + o.offsetY - 16 + 2 - (tower.img:getHeight() - o.map.tileHeight), (64 - 4) * health / maxHealth, 8 - 4)
							G.setLineWidth(1)
							G.setColor(63, 255, 0)
							G.rectangle("line", i * o.map.tileWidth + o.offsetX, k * o.map.tileHeight + o.offsetY - 16 - (tower.img:getHeight() - o.map.tileHeight), 64, 8)
						end
					end
				end
			end
		end
	end

	o.draw = function()
		o.drawMap()
		--if lightWorld.optionShadows or lightWorld.optionGlow then
		lightWorld.update()
		--end
		lightWorld.drawPixelShadow()

		lightWorld.drawRefraction()
		lightWorld.drawReflection()

		o.drawTowerHealth()
		o.drawEnemiesHealth()

		if lightWorld.optionGlow then
			lightWorld.setBuffer("glow")
			o.drawMapCursor()
			o.drawPaths()
			o.drawShots()
			for i = 1, #o.spawn do
				o.spawn[i].draw()
			end
			o.layerHud.draw()
			lightWorld.setBuffer("last")
		else
			o.drawPaths()
			o.drawMapCursor()
			o.drawShots()
			for i = 1, #o.spawn do
				o.spawn[i].draw()
			end
		end

		o.drawEnemies()

		if lightWorld.optionGlow then
			lightWorld.drawGlow()
		else
			o.layerHud.draw()
		end

		if o.effectTimer < 0.75 then
			local colorAberration1 = math.sin(love.timer.getTime() * 20.0) * (0.75 - o.effectTimer) * 4.0
			local colorAberration2 = math.cos(love.timer.getTime() * 20.0) * (0.75 - o.effectTimer) * 4.0

			love.postshader.addEffect("blur", 2.0, 2.0)
			love.postshader.addEffect("chromatic", colorAberration1, colorAberration2, colorAberration2, -colorAberration1, colorAberration1, -colorAberration2)
		end
	end

	o.drawShots = function()
		local lastTowerPos = 0 -- has to be 0 so the first call can detect a tower at field 1

		G.setColor(255, 255, 255)
		G.setBlendMode("alpha")

		for i = 1, o.towerCount do
			-- TODO which tower shoots what should be determined in update(); here we should only draw what has already been determined
			local t = o.getnextTower(lastTowerPos+1) -- the next tower will always be after the first one. Do not ask for a tower after the last one, you will get nil
			if t then
				if t.id == 1 then
					local e = t.target
					if e and e.x and e.y then
						local x, y = e.x, e.y

						local tx = (t.x - 0.5) * o.map.tileWidth + o.offsetX
						local ty = (t.y - 0.5) * o.map.tileHeight + o.offsetY
						local ex = (e.ai.getX() - 0.5) * o.map.tileWidth + o.offsetX
						local ey = (e.ai.getY() - 0.5) * o.map.tileHeight + o.offsetY
						local direction = math.atan2(tx - ex, ey - ty) + math.pi * 0.5
						local length = math.sqrt(math.pow(tx - ex, 2) + math.pow((ty) - ey, 2))
						--			if (length < 150)then
						local timer = -math.mod(love.timer.getTime() * 5, 1.0)
						--local vertices = {
						--{ 0, 0, timer, 0, 255, 0, 0,},
						--{ o.imgLaser:getWidth(), 0, timer + 1, 0, 0, 255, 0 },
						--{ o.imgLaser:getWidth(), o.imgLaser:getHeight(), timer + 1, 1, 0, 0, 255 },
						--{ 0, o.imgLaser:getHeight(), timer, 1, 255, 255, 0 },
						--}
						local vertices = {
							{ 0, 0, timer, 0, 255, 127, 0 },
							{ o.imgLaser:getWidth(), 0, timer + length / o.imgLaser:getWidth(), 0, 0, 127, 255 },
							{ o.imgLaser:getWidth(), o.imgLaser:getHeight(), timer + length / o.imgLaser:getWidth(), 1, 0, 127, 255 },
							{ 0, o.imgLaser:getHeight(), timer, 1, 255, 127, 0 },
						}
						o.mshLaser:setVertices(vertices)
						G.draw(o.mshLaser, (t.x - 0.5) * o.map.tileWidth + o.offsetX, (t.y - 0.5) * o.map.tileHeight + o.offsetY - 8, direction, length / o.imgLaser:getWidth(), 1, 0, 64)
						--		end
					end
				end
				lastTowerPos = t.x * o.map.height + t.y
			end
		end

		-- hide shots under tower edges
		if o.map then
			for i = 0, o.map.width - 1 do
				for k = 0, o.map.height - 1 do
					local tile = o.map.data[i + 1][k + 1]
					local id = tile.id
					if id > 0 then
						local tower = o.towerType[id]

						if tower and tower.collision == true then
							-- tile
							if lightWorld.optionGlow then
								G.setColor(0, 0, 0)
							else
								G.setColor(255, 255, 255)
							end
							if tower.upper then
								G.draw(tower.upper, i * o.map.tileWidth + o.offsetX, k * o.map.tileHeight - (tower.img:getHeight() - o.map.tileHeight) + o.offsetY)
							end
						end
					end
				end
			end
		end
	end

	o.drawPathSegment = function(wpFrom, wpTo)
		local direction = math.atan2(wpFrom[1] - wpTo[1], wpTo[2] - wpFrom[2]) + math.pi * 0.5
		local length = math.sqrt(math.pow(wpFrom[1] * o.map.tileWidth - wpTo[1] * o.map.tileWidth, 2) + math.pow(wpFrom[2] * o.map.tileHeight - wpTo[2] * o.map.tileHeight, 2))
		local timer = -math.mod(love.timer.getTime() * 2.0, 1.0)
		local vertices = {
			{ 0, 0, timer, 0, 255, 0, 0 },
			{ o.imgPath:getWidth(), 0, timer + length / o.imgPath:getWidth(), 0, 255, 0, 0 },
			{ o.imgPath:getWidth(), o.imgPath:getHeight(), timer + length / o.imgPath:getWidth(), 1, 127, 127, 0 },
			{ 0, o.imgPath:getHeight(), timer, 1, 127, 127, 0 },
		}
		o.mshPath:setVertices(vertices)
		G.draw(o.mshPath, (wpFrom[1] - 0.5) * o.map.tileWidth + o.offsetX, (wpFrom[2] - 0.5) * o.map.tileHeight + o.offsetY, direction, (length) / o.imgPath:getWidth(), 1, 0, o.imgPath:getHeight() * 0.5)
	end

	o.drawPaths = function()
		G.setBlendMode("alpha")
		if o.enemyCount > 0 then
			for i = 1, o.enemyCount do
				local e = o.enemies[i]

				if not e.dead then
					if e.ai.path then
						for k = math.max(1, e.ai.getPathStep() - 1), e.ai.getPathCount() - 1 do
							o.drawPathSegment({e.ai.getPathX(k), e.ai.getPathY(k)}, {e.ai.getPathX(k + 1), e.ai.getPathY(k + 1)})
						end
					end
				end
			end
		end
		-- hide path under tower edges
		if o.map then
			for i = 0, o.map.width - 1 do
				for k = 0, o.map.height - 1 do
					local tile = o.map.data[i + 1][k + 1]
					local id = tile.id
					if id ~= 0 then
						local tower = o.towerType[id]

						if tower and tower.collision then
							-- tile
							if lightWorld.optionGlow then
								G.setColor(0, 0, 0)
							else
								G.setColor(255, 255, 255)
							end
							if tower.upper then
								G.draw(tower.upper, i * o.map.tileWidth + o.offsetX, k * o.map.tileHeight - (tower.img:getHeight() - o.map.tileHeight) + o.offsetY)
							else
								G.draw(tower.img, i * o.map.tileWidth + o.offsetX, k * o.map.tileHeight - (tower.img:getHeight() - o.map.tileHeight) + o.offsetY)
							end
						end
					end
				end
			end
		end

		if lightWorld.optionGlow then
			G.setColor(0, 0, 0)
			for i = 1, o.enemyCount do
				local e = o.enemies[i]
				if e and not e.dead then
					local x = e.x
					local y = e.y

					local dir = e.getDirection()
					local directionAnim = (dir + math.pi) / (math.pi * 0.25) - 1

					if directionAnim == 0 then
						directionAnim = 8
					end

					local ca = e.sheet
					if dir == 1 then
						ca:seek(1)
					elseif dir == 2 then
						ca:seek(5)
					elseif dir == 3 then
						ca:seek(7)
					elseif dir == 4 then
						ca:seek(3)
					else
						ca:seek(1)
					end
					ca:draw((e.ai.getX() - 1) * o.map.tileWidth + o.offsetX, (e.ai.getY() - 1) * o.map.tileHeight + math.sin(love.timer.getTime() * 2.0) * 4.0 + o.offsetY - 32)
				end
			end
		end
	end

	o.drawMapCursor = function()
		if o.layerHud.guiGame.hover then
			local mx = love.mouse.getX()
			local my = love.mouse.getY()
			local tileX = math.floor((mx - o.offsetX) / o.map.tileWidth)
			local tileY = math.floor((my - o.offsetY) / o.map.tileHeight)

			if tileX >= 0 and tileY >= 0 and tileX < o.map.width and tileY < o.map.height then
				if o.map.data[tileX + 1][tileY + 1].id == 0 then
					G.setColor(0, 127, 255)
					G.draw(o.mapCursorNormal, tileX * o.map.tileWidth + o.offsetX, tileY * o.map.tileHeight + o.offsetY)
				else
					G.setColor(255, 63, 0)
					G.setLineWidth(2)
					G.rectangle("line", tileX * o.map.tileWidth + o.offsetX, tileY * o.map.tileHeight + o.offsetY, o.map.tileWidth, o.map.tileHeight)

					if lightWorld.optionGlow then
						G.setBlendMode("alpha")
						G.setColor(0, 0, 0)
					else
						G.setColor(255, 255, 255)
					end

					local tower = o.towerType[o.map.data[tileX + 1][tileY + 1].id]
					if tower.upper then
						G.draw(tower.upper, tileX * o.map.tileWidth + o.offsetX, tileY * o.map.tileHeight - (tower.img:getHeight() - o.map.tileHeight) + o.offsetY)
					else
						G.draw(tower.img, tileX * o.map.tileWidth + o.offsetX, tileY * o.map.tileHeight - (tower.img:getHeight() - o.map.tileHeight) + o.offsetY)
					end

					G.setColor(255, 63, 0)
					G.draw(o.mapCursorBlock, tileX * o.map.tileWidth + o.offsetX + o.map.tileWidth * 0.5, tileY * o.map.tileHeight + o.offsetY + o.map.tileHeight * 0.5, 0, 0.95 - math.sin(o.effectTimer * 5.0) * 0.05, 0.95 - math.sin(o.effectTimer * 5.0) * 0.05, o.map.tileWidth * 0.5, o.map.tileHeight * 0.5)
				end
			end
		end
	end

	-- draw a line in world coordinates
	o.drawLine = function(x1,y1,x2,y2)
		if x1 and y1 and x2 and y2 then
			G.line((x1 - 0.5) * o.map.tileWidth + o.offsetX, (y1 - 0.5) * o.map.tileHeight + o.offsetY,(x2 - 0.5) * o.map.tileWidth + o.offsetX, (y2 - 0.5) * o.map.tileHeight + o.offsetY)
		end
	end

	o.drawEnemies = function()
		G.setBlendMode("alpha")
		for i = 1, o.enemyCount do
			local e = o.enemies[i]
			if e and not e.dead then

				G.setColor(255, 255, 255)
				--print ("vels: ",e.xVel,e.yVel)
				local dir = e.getDirection()
				--print ("dir: ",dir)
				--local directionAnim = (dir + math.pi) / (math.pi * 0.25) - 1
				if directionAnim == 0 then
					directionAnim = 8
				end

				local ca = e.sheet
				local dir = e.ai.getDirection()

				if dir == 1 then
					ca:seek(1)
				elseif dir == 2 then
					ca:seek(5)
				elseif dir == 3 then
					ca:seek(7)
				elseif dir == 4 then
					ca:seek(3)
				else
					ca:seek(1)
				end
				local x = e.ai.getX()
				local y = e.ai.getY()
				ca:draw((x - 1) * o.map.tileWidth + o.offsetX, (y - 1) * o.map.tileHeight + math.sin(love.timer.getTime() * 2.0) * 4.0 + o.offsetY  - 32)
			end
		end
	end

	o.drawEnemiesHealth = function()
		G.setBlendMode("alpha")
		for i = 1, o.enemyCount do
			local e = o.enemies[i]
			if e and not e.dead then
				local x = e.ai.getX()
				local y = e.ai.getY()
				G.setColor(15, 15, 31, 63 + math.sin(love.timer.getTime() * 2.0) * 31)
				love.graphics.ellipse("fill", x * o.map.tileWidth + o.offsetX - 32, y * o.map.tileHeight + o.offsetY - 16, 12 + math.sin(love.timer.getTime() * 2.0) * 3, 8 + math.sin(love.timer.getTime() * 2.0) * 2, 0, 16)
				-- health
				if e.health < e.maxHealth then
					G.setColor(0, 0, 0, 127)
					G.rectangle("fill", (x - 1) * o.map.tileWidth + o.offsetX - 2, (y - 1) * o.map.tileHeight + o.offsetY - 32 - 2, 64 + 4, 8 + 4)
					G.setColor(255 * math.min((1.0 - e.health / e.maxHealth) * 2.0, 1.0), 255 * math.min((e.health / e.maxHealth) * 1.5, 1.0), 0)
					G.rectangle("fill", (x - 1) * o.map.tileWidth + o.offsetX + 2, (y - 1) * o.map.tileHeight + o.offsetY - 32 + 2, (64 - 4) * e.health / e.maxHealth, 8 - 4)
					G.setLineWidth(1)
					G.setColor(255, 63, 0)
					G.rectangle("line", (x - 1) * o.map.tileWidth + o.offsetX, (y - 1) * o.map.tileHeight + o.offsetY - 32, 64, 8)
				end
			end
		end
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

	o.resetTimer = function()
		o.timer = 0
	end

	gameOverEffect = 0

	return o
end
