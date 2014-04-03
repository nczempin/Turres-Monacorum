require "enemy"
require "tower"
require "player"
require "layer/hud"
require "graphics"

function love.turris.newGame()
	local o = {}
	o.map = {}
	o.ground = {}
	o.towerType = {}
	o.towers = {} -- circular list
	o.towers.maxamount = 0
	o.towerCount = 0
	o.towers.next = 1
	o.enemies = {}
	o.enemyCount = 1
	o.enemyTypes =  {}
	o.dayTime = 90
	o.effectTimer = 99
	o.offsetX = 0.0
	o.offsetY = 0.0
	o.offsetChange = false
	o.timer = 0
	o.holdOffset = false
	o.holdOffsetX = 0
	o.holdOffsetY = 0

	o.init = function()
		o.player = love.turris.newPlayer()
		o.setMap(turMap.getMap())
		o.baseX = math.floor(o.map.width / 2 + 0.5)
		o.baseY = math.floor(o.map.height / 2 + 0.5)
		o.towers.maxamount = o.map.width*o.map.height
		for x=1,o.map.height do
			for y=1,o.map.width do
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

		local et1 = love.turris.newEnemyType(o.creepAnim1, 100, 1.0)
		local et2 = love.turris.newEnemyType(o.creepAnim2, 2000, 0.5)

		o.enemyTypes = {et1, et2}
		o.enemyCount = 1
		o.enemies[o.enemyCount]= love.turris.newEnemy(o.enemyTypes[2], o.map, 1, o.baseY, o.baseX, o.baseY)
		o.enemyCount = o.enemyCount +1
		o.enemies[o.enemyCount]= love.turris.newEnemy(o.enemyTypes[1], o.map, o.baseX, 1, o.baseX, o.baseY)
		o.enemyCount = o.enemyCount +1
		o.enemies[o.enemyCount]= love.turris.newEnemy(o.enemyTypes[1], o.map, o.map.width, o.baseY, o.baseX, o.baseY)
		o.enemyCount = o.enemyCount +1
		o.enemies[o.enemyCount]= love.turris.newEnemy(o.enemyTypes[2], o.map, o.baseX, o.map.height, o.baseX, o.baseY)

		o.newGround("gfx/ground_diffuse001.png")
		laserTower = o.newTowerType("gfx/tower00")
		generatorTower = o.newTowerType("gfx/tower01")
		o.newTowerType("gfx/tower02")
		o.newTowerType("gfx/tower03")
		o.newTowerType("gfx/tower04")
		spawnHole = o.newTowerType("gfx/obstacle00")
		spawnEggs = o.newTowerType("gfx/obstacle01")

		laserTower.setUpperImage(true)
		generatorTower.setUpperImage(true)

		print ("adding main base", o.baseX, o.baseY)
		o.addTower(o.baseX, o.baseY, 2) --main base

		o.player.setMass(9999) -- enough to place the towers

		o.addTower(11, 2, 4)
		o.addTower(5, 3, 3)
		o.addTower(7, 5, 5)
		o.addTower(1, o.baseY, 6)
		o.addTower(o.baseX, 1, 7)
		o.addTower(o.map.width, o.baseY, 7)
		o.addTower(o.baseX, o.map.height, 6)

		o.player.setMass(20)

		o.imgLaser = G.newImage("gfx/laserbeam_blue.png")
		o.imgLaser:setWrap("repeat", "repeat")
		local vertices = {
			{ 0, 0, 0, 0, 255, 0, 0,},
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
	end

	o.recalculatePaths = function()
		for i = 1, o.enemyCount do
			local e = o.enemies[i]
			local wpCurrent = e.waypoints[e.currentWaypoint]
			print ("wp before: ",wpCurrent[1],wpCurrent[2])
			print ("REPATHING ",i)
			--e.waypoints = e.generateWaypoints(o.map, math.floor(e.x + 0.5), math.floor(e.y + 0.5), o.baseX, o.baseY,wpCurrent)
			e.waypoints = e.generateWaypoints(o.map, wpCurrent[1],wpCurrent[2], o.baseX, o.baseY,wpCurrent)
			--printWaypoints(e)
			e.currentWaypoint = 1
			wpCurrent =  e.waypoints[e.currentWaypoint]
			print ("wp after: ",wpCurrent[1],wpCurrent[2])
			local wpNext = e.waypoints[e.currentWaypoint]
			local deltaX = wpNext[1] - e.x
			local deltaY = wpNext[2] - e.y
			--print ("delta: ", deltaX, deltaY)
			local dirX,dirY = love.turris.normalize(deltaX , deltaY)

			if dirX ~= dirX or dirY ~= dirY then
			--print ("NaN")
			else
				dirX = math.floor(dirX)
				dirY= math.floor(dirY)
				--print ("dir: ",dirX, dirY)
				e.updateVelocity(dirX,dirY)
			end
		end
	end

	-- gameplay

	o.addTower = function(x,y,type)
		--print ("addTower:", x, y, type,o.map)
		if not x or x<1 or x>o.map.width or not y or y<1 or y>o.map.height or not type or not (o.towerCount<o.towers.maxamount) then return end
		local state = o.map.getState(x,y)
		if state and state ==0 then
			--print ("x, y:",x,y)
			local tt = o.towerType[type]
			if tt.buildCost > o.player.mass then return end
			local t = love.turris.newTower(tt, x, y, type)
			--print ("tower: ",t, t.x, t.y)
			o.map.setState(t.x, t.y, type)
			--Playing Sound When Tower is Placed
			if currentgamestate == 1 then --TODO we should make sure that towers can never be _placed_ in any other state
				love.sounds.playSound("sounds/tower_1.mp3")
			end
			o.towers[x*o.map.height+y] = t
			o.towerCount = o.towerCount+1
			o.player.addMass(-10)
			o.recalculatePaths()
		end
	end

	o.removeTower = function(x,y) --can remove from a position
		if (not x or x<1 or x>o.map.width or not y or y<1 or y>o.map.height) then
			print ("nothing will be removed here!"..x.." "..o.map.width.." "..y.." "..o.map.height)
			return
	end
	print("will try to remove tower at "..x..", "..y)
	local state =o.map.getState(x,y)

	if state then
		if state==1 then -- TODO: let towers other than type 1 be deleted
			local scrapValue = o.towerType[state].scrapValue
			o.player.addMass(scrapValue)

			o.towerCount = o.towerCount-1
			o.towers[x*o.map.height+y] = nil
			turMap.setState(x,y,0)
			--print(o.towers[x*o.map.height+y])
			o.recalculatePaths()
		else
			print("Could not delete tower at "..x..", "..y)
		end
	end
	end

	-- returns tower at given coordinates or nil
	o.gettowerAt = function(x,y)
		return o.towers[x*o.map.height+y]
	end

	-- returns tower at given position or the next tower or nil
	o.getnextTower = function(arrayPos)
		for i=arrayPos,o.towers.maxamount do
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
				if love.mouse.getX() < 128 then
					o.offsetX = o.offsetX + dt * (128 - love.mouse.getX()) ^ 1.25
					o.offsetChange = true
				elseif love.mouse.getX() > W.getWidth() - 128 then
					o.offsetX = o.offsetX - dt * (128 - (W.getWidth() - love.mouse.getX())) ^ 1.25
					o.offsetChange = true
				end

				if love.mouse.getY() < 128 then
					o.offsetY = o.offsetY + dt * (128 - love.mouse.getY()) ^ 1.25
					o.offsetChange = true
				elseif love.mouse.getY() > W.getHeight() - 128 then
					o.offsetY = o.offsetY - dt * (128 - (W.getHeight() - love.mouse.getY())) ^ 1.25
					o.offsetChange = true
				end
			end
		end


		if o.offsetX > 0 then
			o.offsetX = 0
		elseif o.offsetX < W.getWidth() - turMap.getWidth() * turMap.getTileWidth() then
			o.offsetX = W.getWidth() - turMap.getWidth() * turMap.getTileWidth()
		end

		if o.offsetY > 0 then
			o.offsetY = 0
		elseif o.offsetY < W.getHeight() - turMap.getHeight() * turMap.getTileHeight() then
			o.offsetY = W.getHeight() - turMap.getHeight() * turMap.getTileHeight()
		end

		holdOffsetX = love.mouse.getX()
		holdOffsetY = love.mouse.getY()
	end

	o.update = function(dt)
		o.layerHud.update(dt)

		if o.layerHud.btnTower1.isHit() then
			love.turris.selectedtower = 1
		elseif o.layerHud.btnTower2.isHit() then
			love.turris.selectedtower = 3
		elseif o.layerHud.btnTower3.isHit() then
			love.turris.selectedtower = 4
		end

		if love.keyboard.isDown("escape") then
			love.setgamestate(0)
			love.turris.reinit()
		elseif love.keyboard.isDown("1") then
			love.turris.selectedtower = 1
			o.layerHud.btnTower1.setChecked(true)
		elseif love.keyboard.isDown("2") then
			love.turris.selectedtower = 2 --2 would be the main base which should not be available for manual building
		elseif love.keyboard.isDown("3") then
			love.turris.selectedtower = 3
			o.layerHud.btnTower2.setChecked(true)
		elseif love.keyboard.isDown("4") then
			love.turris.selectedtower = 4
			o.layerHud.btnTower3.setChecked(true)
		elseif love.keyboard.isDown("5") then
			love.turris.selectedtower = 5
		end

		o.effectTimer = o.effectTimer + dt
		o.dayTime = o.dayTime + dt * 0.1
		T.updateEnemies(o,dt)

		o.updateCamera(dt)

		-- update shadows
		if o.offsetChange then
			o.map.shadowGround.setPosition(o.map.width * o.map.tileWidth * 0.5 + o.offsetX, o.map.height * o.map.tileHeight * 0.5 + o.offsetY)
			for i = 1, o.map.width do
				for k = 1, o.map.height do
					o.map.shadow[i][k].setPosition(i * o.map.tileWidth - o.map.tileWidth * 0.5 + o.offsetX, k * o.map.tileHeight - o.map.tileHeight * 0.5 + o.offsetY)
				end
			end
			o.offsetChange = false
		end

		-- update animations
		--o.creepAnim:update(dt)
		local lastTowerPos = 0 -- has to be 0 so the first call can detect a tower at field 1
		for i = 1, o.towerCount do
			-- TODO which tower shoots what should be determined in update(); here we should only draw what has already been determined
			local t = o.getnextTower(lastTowerPos+1) -- the next tower will always be after the first one. Do not ask for a tower after the last one, you will get nil

			if t then
				if t.id == 1 then -- laser tower
					t.target = nil
					local energyCost = dt*t.type.shotCost
					if energyCost <= o.player.energy then
						local e = t.determineTarget(o.enemies,distance_euclid)
						t.target = e --TODO just do that inside tower module

						if e then
							local x, y = e.x, e.y

							local tx = (t.x - 0.5) * o.map.tileWidth + o.offsetX
							local ty = (t.y - 0.5) * o.map.tileHeight + o.offsetY
							local ex = (e.x - 0.5) * o.map.tileWidth + o.offsetX
							local ey = (e.y - 0.5) * o.map.tileHeight + o.offsetY
							local direction = math.atan2(tx - ex, ey - ty) + math.pi * 0.5
							local length = math.sqrt(math.pow(tx - ex, 2) + math.pow((ty) - ey, 2))
							local timer = -math.mod(love.timer.getTime() * 2.0, 1.0)
							--local vertices = {
							--{ 0, 0, timer, 0, 255, 0, 0,},
							--{ o.imgLaser:getWidth(), 0, timer + 1, 0, 0, 255, 0 },
							--{ o.imgLaser:getWidth(), o.imgLaser:getHeight(), timer + 1, 1, 0, 0, 255 },
							--{ 0, o.imgLaser:getHeight(), timer, 1, 255, 255, 0 },
							--}
							o.player.addEnergy(-energyCost)
							if e.health > 0.0 then
								e.health = e.health - t.type.damage*dt
								if e.health <= 0 then
									e.dead = true
								end
							end
						end
					end
				end
				lastTowerPos = t.x*o.map.height+t.y
			end
		end

		-- test
		--TODO: -> player.update
		o.player.addMass(dt*2)
		o.player.addEnergy(dt*5)
	end
	--------------------- drawing starts here

	o.drawMap = function()
		local dayTime = math.abs(math.sin(o.dayTime))
		lightWorld.setAmbientColor(dayTime * 223 + 31, dayTime * 159 + 63, dayTime * 63 + 127)

		lightMouse.setPosition(love.mouse.getX(), love.mouse.getY(), 63)

		G.setBlendMode("alpha")

		if o.map and o.map.width and o.map.height then
			G.setColor(255, 255, 255)
			G.draw(o.mshGround, o.offsetX, o.offsetY)
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
							G.draw(tower.img, i * o.map.tileWidth + o.offsetX - 2, k * o.map.tileHeight - (tower.img:getHeight() - o.map.tileHeight) + o.offsetY - 2, 0, (o.map.tileWidth + 4) / o.map.tileWidth)
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

		o.drawTowerHealth()
		o.drawEnemiesHealth()

		if lightWorld.optionGlow then
			lightWorld.setBuffer("glow")
			o.drawMapCursor()
			o.drawPaths()
			o.drawShots()
			o.layerHud.draw()
			lightWorld.setBuffer("render")
		else
			o.drawPaths()
			o.drawMapCursor()
			o.drawShots()
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
						local ex = (e.x - 0.5) * o.map.tileWidth + o.offsetX
						local ey = (e.y - 0.5) * o.map.tileHeight + o.offsetY
						local direction = math.atan2(tx - ex, ey - ty) + math.pi * 0.5
						local length = math.sqrt(math.pow(tx - ex, 2) + math.pow((ty) - ey, 2))
						--			if (length < 150)then
						local timer = -math.mod(love.timer.getTime() * 2.0, 1.0)
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

	o.drawPaths = function()
		G.setBlendMode("alpha")
		for i = 1, o.enemyCount do
			local e = o.enemies[i]
			local x = e.x
			local y = e.y
			for i=1, #e.waypoints-1 do
				local wpFrom = e.waypoints[i]
				local wpTo = e.waypoints[i+1]
				G.setColor(232, 118, 0)
				--o.drawLine(wpFrom[1],wpFrom[2],wpTo[1],wpTo[2])

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
		end

		-- hide path under tower edges
		if o.map then
			for i = 0, o.map.width - 1 do
				for k = 0, o.map.height - 1 do
					local tile = o.map.data[i + 1][k + 1]
					local id = tile.id
					if id ~= 0 then
						local tower = o.towerType[id]
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
					ca:seek(directionAnim)
					local tileOffsetX = (ca.fw * 0.5)
					if not tileOffsetX then print (tileOffsetX) end
					local xPos = x * o.map.tileWidth - tileOffsetX + o.offsetX - 32
					ca:draw(xPos, (y - 1) * o.map.tileHeight - (ca.fh / 8.0 * 0.5) + o.offsetY - 24 + math.sin(love.timer.getTime() * 2.0) * 4.0)
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
				local x = e.x
				local y = e.y

				G.setColor(255, 255, 255)
				--print ("vels: ",e.xVel,e.yVel)
				local dir = e.getDirection()
				--print ("dir: ",dir)
				local directionAnim = (dir + math.pi) / (math.pi * 0.25) - 1
				if directionAnim == 0 then
					directionAnim = 8
				end
				local ca = e.sheet
				ca:seek(directionAnim)
				local tileOffsetX = (ca.fw * 0.5)
				if not tileOffsetX then print (tileOffsetX) end
				local xPos = x * o.map.tileWidth - tileOffsetX + o.offsetX - 32
				ca:draw(xPos, (y - 1) * o.map.tileHeight - (ca.fh / 8.0 * 0.5) + o.offsetY - 24 + math.sin(love.timer.getTime() * 2.0) * 4.0)
				--e.shadow.setPosition(x * o.map.tileWidth - (o.creepImg:getWidth() * 0.5) + o.offsetX - 32, (y - 1) * o.map.tileHeight - (o.creepImg:getHeight() / 8.0 * 0.5) + o.offsetY + 32)

				--print(e.getDirection())

				--				--debug: show travel direction
				--				local ox, oy = e.getOrientation()
				--				local wp = e.waypoints[e.currentWaypoint]
				--				G.setColor(255, 63, 123)
				--				o.drawLine(x,y,wp[1],wp[2])
			end
		end
	end

	o.drawEnemiesHealth = function()
		G.setBlendMode("alpha")
		for i = 1, o.enemyCount do
			local e = o.enemies[i]
			if e and not e.dead then
				local x = e.x
				local y = e.y
				G.setColor(15, 15, 31, 63 + math.sin(love.timer.getTime() * 2.0) * 31)
				love.graphics.ellipse("fill", x * o.map.tileWidth + o.offsetX - 32, y * o.map.tileHeight + o.offsetY - 16, 12 + math.sin(love.timer.getTime() * 2.0) * 3, 8 + math.sin(love.timer.getTime() * 2.0) * 2, 0, 16)
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
			end
		end
	end

	o.newGround = function(img)
		img = G.newImage(img)
		img:setWrap("repeat", "repeat")
		o.ground[#o.ground + 1] = img

		local vertices = {
			{ 0, 0, 0, 0, 50, 80, 120 },
			{ o.map.getWidth() * o.map.getTileWidth(), 0, (o.map.getWidth() * o.map.getTileWidth()) / img:getWidth(), 0, 50, 80, 120 },
			{ o.map.getWidth() * o.map.getTileWidth(), o.map.getHeight() * o.map.getTileHeight(), (o.map.getWidth() * o.map.getTileWidth()) / img:getWidth(), (o.map.getHeight() * o.map.getTileHeight()) / img:getHeight(), 100, 80, 120 },
			{ 0, o.map.getHeight() * o.map.getTileHeight(), 0, (o.map.getHeight() * o.map.getTileHeight()) / img:getHeight(), 100, 80, 120 },
		}

		o.mshGround = love.graphics.newMesh(vertices, img, "fan")
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

	o.resetTimer = function()
		o.timer = 0
	end

	gameOverEffect = 0

	return o
end
