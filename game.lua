require "enemy"
require "tower"

function love.turris.newGame()
	local o = {}
	o.map = {}
	o.ground = {}
	o.towerType = {}
	o.towers = {} -- circular list
	o.towers.maxamount = 0
	o.towers.amount = 0
	o.towerCount = 0
	o.towers.next = 1
	o.enemies = {}
	o.enemyCount = 1
	o.dayTime = 90
	o.offsetX = 0.0
	o.offsetY = 0.0
	o.offsetChange = false
	o.timer = 0
	o.holdOffset = false
	o.holdOffsetX = 0
	o.holdOffsetY = 0
	o.init = function()
		o.setMap(turMap.getMap())
		o.baseX = math.floor(o.map.width / 2 + 0.5)
		o.baseY = math.floor(o.map.height / 2 + 0.5)
		o.towers.maxamount = o.map.width*o.map.height+2
		for i = 1, o.enemyCount do
			o.enemies[i]= love.turris.newEnemy(creepImg,o.map,0,o.baseY,o.baseX,o.baseY)
		end
		o.newGround("gfx/ground_diffuse001.png")
		o.newTowerType("gfx/tower00")
		o.newTowerType("gfx/tower01")
		o.newTowerType("gfx/tower02")
		o.newTowerType("gfx/tower03")


		print ("adding main base", o.baseX, o.baseY)
		o.addTower(o.baseX, o.baseY, 2) --main base


		o.addTower(2, 2,1)
		o.addTower(11, 2, 4)
		o.addTower(5, 3, 3)
		o.addTower(2,o.baseY-1,1) --TODO another debugging tower
		o.addTower(2,o.baseY+1,1) --TODO another debugging tower
		o.addTower(o.baseX-1,o.baseY,1) --TODO another debugging tower
		o.addTower(o.baseX-1,o.baseY-1,1) --TODO another debugging tower

		o.imgLaser = G.newImage("gfx/laserbeam_blue.png")
		o.imgLaser:setWrap("repeat", "repeat")
		local vertices = {
			{ 0, 0, 0, 0, 255, 0, 0,},
			{ o.imgLaser:getWidth(), 0, 1, 0, 0, 255, 0 },
			{ o.imgLaser:getWidth(), o.imgLaser:getHeight(), 1, 1, 0, 0, 255 },
			{ 0, o.imgLaser:getHeight(), 0, 1, 255, 255, 0 },
		}

		o.mshLaser = love.graphics.newMesh(vertices, o.imgLaser, "fan")

		o.creepImg = G.newImage("gfx/creep00_diffuse_sheet.png")
		o.creepAnim = newAnimation(o.creepImg, o.creepImg:getWidth(), o.creepImg:getHeight() / 8.0, 0, 0)
	end

	-- gameplay

	o.addTower = function(x,y,type)
		--print ("addTower:", x, y, type,o.map)
		if not x or x<1 or x>o.map.width or not y or y<1 or y>o.map.height or not type or not (o.towerCount<o.towers.maxamount) then return end
		local state = o.map.getState(x,y)
		if state and state ==0 then
			--print ("x, y:",x,y)
			local t = love.turris.newTower(type, x, y)
			--print ("tower: ",t, t.x, t.y)
			o.map.setState(t.x, t.y, type)
			if o.towers.next<o.towers.maxamount and not o.towers.next then
				o.towers[o.towers.next] = t --{next = towers, value =t}
			else
				for i=1,o.towers.maxamount do
					if(o.towers.next==o.towers.maxamount) then
						o.towers.next=0
					end
					if not o.towers.next then
						break
					end
				end
				o.towers[o.towers.next] = t --{next = towers, value =t}
				o.towers.next = o.towers.next+1
				o.towerCount = o.towerCount+1
				--Playing Sound When Tower is Placed
				if(currentgamestate == 1) then
					love.sounds.playSound("sounds/tower_1.mp3")
				end
				print(o.towerCount)
				print("Tower was placed at "..x..", "..y)


				--Recalculate paths. TODO: factor this out into its own function, then add it to the tower removal code
				--for i = 1, o.enemyCount do
				local e = o.enemies[1]
				e.waypoints = e.generateWaypoints(o.map,math.floor(e.x+0.5),math.floor(e.y+0.5),o.baseX,o.baseY)
				e.currentWaypoint = 1
				local wpNext = e.waypoints[e.currentWaypoint]
				local deltaX = wpNext[1]-e.x
				local deltaY = wpNext[2]-e.y
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
				--end

			end
		end
	end

	o.removeTower = function(x,y) --can remove from a position
		if true then return end --TODO temporarily deactivated this function, see issue #25
		if (not x or x<1 or x>o.map.width or not y or y<1 or y>o.map.height) then
			print ("nothing will be removed here!"..x.." "..o.map.width.." "..y.." "..o.map.height)
			return
		end

		print("something might be removed..."..x.." "..o.map.width.." "..y.." "..o.map.height)
		local state =o.map.getState(x,y)
		if state and not(state==0) then -- TODO: don't let main tower be deleted!!!
			--o.map.setState(x,y,0)
			for i=1,o.towers.maxamount do
				if o.towers[i] and o.towers[i].value and o.towers[i].value.x==x and o.towers[i].value.y==y then
					o.towers[i] = nil
				end
				turMap.setState(x,y,0)
				if(o.towerCount>0) then
					o.towerCount = o.towerCount-1
				end
				print("Tower was removed at "..x..", "..y)
				return
		end
		print("Could not delete tower at "..x..", "..y)
		end
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
		o.creepAnim:update(dt)

	end
	--------------------- drawing starts here

	o.drawMap = function()
		local dayTime = math.abs(math.sin(o.dayTime))
		lightWorld.setAmbientColor(dayTime * 239 + 15, dayTime * 191 + 31, dayTime * 143 + 63)

		lightMouse.setPosition(love.mouse.getX(), love.mouse.getY(), 63)
		lightWorld.update()

		if o.map and o.map.width and o.map.height then
			G.setColor(255, 255, 255)
			G.draw(o.mshGround, o.offsetX, o.offsetY)
			lightWorld.drawShadow()
			for i = 0, o.map.width - 1 do
				for k = 0, o.map.height - 1 do
					local tile = o.map.data[i + 1][k + 1]
					local id = tile.id
					if id > 0 then
						local img = o.towerType[id].img
						-- tile
						G.setColor(255, 255, 255)
						G.draw(img, i * o.map.tileWidth + o.offsetX, k * o.map.tileHeight - (img:getHeight() - o.map.tileHeight) + o.offsetY)
						-- health
						local health = tile.health
						local maxHealth = tile.maxHealth
						if health < maxHealth then
							--draw health bar
							G.setColor(0, 0, 0, 127)
							G.rectangle("fill", i * o.map.tileWidth + o.offsetX - 2, k * o.map.tileHeight + o.offsetY - 16 - 2 - (img:getHeight() - o.map.tileHeight), 64 + 4, 8 + 4)
							G.setColor(255 * math.min((1.0 - health / maxHealth) * 2.0, 1.0), 255 * math.min((health / maxHealth) * 1.5, 1.0), 0)
							G.rectangle("fill", i * o.map.tileWidth + o.offsetX + 2, k * o.map.tileHeight + o.offsetY - 16 + 2 - (img:getHeight() - o.map.tileHeight), (64 - 4) * health / maxHealth, 8 - 4)
							G.setLineWidth(1)
							G.setColor(63, 255, 0)
							G.rectangle("line", i * o.map.tileWidth + o.offsetX, k * o.map.tileHeight + o.offsetY - 16 - (img:getHeight() - o.map.tileHeight), 64, 8)
						end
						-- test
						--						if o.map.data[i + 1][k + 1].health > 0.0 then
						--							o.map.data[i + 1][k + 1].health = health - 0.1
						--						end
					end
				end
			end
			lightWorld.drawPixelShadow()
			lightWorld.drawGlow()
		end
	end
	o.draw = function()
		o.drawMap()
		o.drawShots()
		o.drawPaths()
		o.drawEnemies()
	end

	o.drawShots = function()
		local e = o.enemies[1]		-- TODO this is a hack because I know there's only one creep for now

		local x, y = e.x, e.y
		G.setColor(255, 0, 0)

		for i = 1, o.towerCount do
			-- TODO which tower shoots what should be determined in update(); here we should only draw what has already been determined
			local t = o.towers[i]
			local tx = (t.x - 0.5) * o.map.tileWidth + o.offsetX
			local ty = (t.y - 0.5) * o.map.tileHeight + o.offsetY
			local ex = (e.x - 0.5) * o.map.tileWidth + o.offsetX
			local ey = (e.y - 0.5) * o.map.tileHeight + o.offsetY
			local direction = math.atan2(tx - ex, ey - ty) + math.pi * 0.5
			local length = math.sqrt(math.pow(tx - ex, 2) + math.pow(ty - ey, 2))
			if (length < 150)then
				local timer = -math.mod(love.timer.getTime() * 2.0, 1.0)
				G.setBlendMode("additive")
				--local vertices = {
				--{ 0, 0, timer, 0, 255, 0, 0,},
				--{ o.imgLaser:getWidth(), 0, timer + 1, 0, 0, 255, 0 },
				--{ o.imgLaser:getWidth(), o.imgLaser:getHeight(), timer + 1, 1, 0, 0, 255 },
				--{ 0, o.imgLaser:getHeight(), timer, 1, 255, 255, 0 },
				--}
				local vertices = {
					{ 0, 0, timer, 0, 255, 127, 0 },
					{ o.imgLaser:getWidth(), 0, timer + 1, 0, 0, 127, 255 },
					{ o.imgLaser:getWidth(), o.imgLaser:getHeight(), timer + 1, 1, 0, 127, 255 },
					{ 0, o.imgLaser:getHeight(), timer, 1, 255, 127, 0 },
				}
				o.mshLaser:setVertices(vertices)
				G.draw(o.mshLaser, (t.x - 0.5) * o.map.tileWidth + o.offsetX, (t.y - 0.5) * o.map.tileHeight + o.offsetY, direction, length / o.imgLaser:getWidth(), 1, 0, 64)
			end
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
			for i=1, #e.waypoints-1 do
				local wpFrom = e.waypoints[i]
				local wpTo = e.waypoints[i+1]
				G.setColor(232, 118, 0)
				o.drawLine(wpFrom[1],wpFrom[2],wpTo[1],wpTo[2])
			end
		end
	end

	-- draw a line in world coordinates
	o.drawLine = function(x1,y1,x2,y2)
		if x1 and y1 and x2 and y2 then
			G.line((x1-0.5)*o.map.tileWidth + o.offsetX, (y1-0.5) * o.map.tileHeight + o.offsetY,(x2-0.5) * o.map.tileWidth + o.offsetX, (y2 - 0.5)*o.map.tileHeight + o.offsetY)
		end
	end

	o.drawEnemies = function()
		for i = 1, o.enemyCount do
			local e = o.enemies[i]
			local x = e.x
			local y = e.y
			local img = e.img
			G.setColor(15, 15, 31, 63 + math.sin(love.timer.getTime() * 2.0) * 31)
			love.graphics.ellipse("fill", x * o.map.tileWidth - o.offsetX - 32, y * o.map.tileHeight + o.offsetY - 16, 12 + math.sin(love.timer.getTime() * 2.0) * 3, 8 + math.sin(love.timer.getTime() * 2.0) * 2, 0, 16)
			G.setColor(255, 255, 255)
			local directionAnim = (e.getDirection() + math.pi) / (math.pi * 0.25) - 1
			if directionAnim == 0 then
				directionAnim = 8
			end

			o.creepAnim:seek(directionAnim)

			o.creepAnim:draw(x * o.map.tileWidth - (o.creepImg:getWidth() * 0.5) + o.offsetX - 32, (y - 1) * o.map.tileHeight - (o.creepImg:getHeight() / 8.0 * 0.5) + o.offsetY + 16 + math.sin(love.timer.getTime() * 2.0) * 4.0)
			--e.shadow.setPosition(x * o.map.tileWidth - (o.creepImg:getWidth() * 0.5) + o.offsetX - 32, (y - 1) * o.map.tileHeight - (o.creepImg:getHeight() / 8.0 * 0.5) + o.offsetY + 32)
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
			--print(e.getDirection())

			--debug: show travel direction
			local ox, oy = e.getOrientation()
			local wp = e.waypoints[e.currentWaypoint]
			G.setColor(255, 63, 123)
			o.drawLine(x,y,wp[1],wp[2])
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

function love.graphics.ellipse(mode, x, y, a, b, phi, points)
	phi = phi or 0
	points = points or 10
	if points <= 0 then points = 1 end

	local two_pi = math.pi*2
	local angle_shift = two_pi/points
	local theta = 0
	local sin_phi = math.sin(phi)
	local cos_phi = math.cos(phi)

	local coords = {}
	for i = 1, points do
		theta = theta + angle_shift
		coords[2*i-1] = x + a * math.cos(theta) * cos_phi
			- b * math.sin(theta) * sin_phi
		coords[2*i] = y + a * math.cos(theta) * sin_phi
			+ b * math.sin(theta) * cos_phi
	end

	coords[2*points+1] = coords[1]
	coords[2*points+2] = coords[2]

	love.graphics.polygon(mode, coords)
end