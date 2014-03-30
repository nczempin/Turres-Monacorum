require "enemy"

function love.turris.newGame()
	local o = {}
	o.map = {}
	o.ground = {}
	o.towerType = {}
	o.towers = {} -- circular list
	o.towers.maxamount = 0
	o.towers.amount = 0
	o.towers.next = 1
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
		o.towers.maxamount = o.map.width*o.map.height+2
		o.newGround("gfx/ground01.png")
		o.newTowerType("gfx/tower00")
		o.newTowerType("gfx/tower01")
		o.newTowerType("gfx/tower02")
		o.newTowerType("gfx/tower03")
		--o.towerCount = 0 -- NOT TO DO: get the correct number of towers (and fill the tower array)
		o.addTower(2, 2,1)
		o.addTower(11, 9, 1)
		o.addTower(2, o.baseY, 1) --TODO debugging tower to block the path right away
		o.addTower(2,o.baseY-1,1) --TODO another debugging tower
		o.map.setState(2, 9, 4)
		o.map.setState(7, 3, 3)
		o.map.setState(o.baseX, o.baseY, 2)

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
		for i = 1, o.enemyCount do
			o.enemies[i]= love.turris.newEnemy(creepImg,o.map,1,o.baseY,o.baseX,o.baseY)
		end
	end
	o.addTower = function(x,y,type)
		if not x or x<1 or x>o.map.width or not y or y<1 or y>o.map.height or not type or not (o.towers.amount<o.towers.maxamount) then return end
		local state = o.map.getState(x,y)
		if state and state ==0 then
			--o.towerCount = o.towerCount +1 -- NOT TO DO this is unsafe
			local t = {}
			t.x = x
			t.y = y
			t.type = type
			o.map.setState(t.x, t.y, type)
			--o.towers[o.towerCount] =t

			--Playing Sound When Tower is Placed
			if(currentgamestate ~= 0) then
				love.sounds.playSound("sounds/tower_1.mp3")
			end


			if o.towers.next<o.towers.maxamount then
				o.towers[o.towers.next] = {next = towers, value =t}
			else
				while (o.towers) do
					if(o.towers.next==o.towers.maxamount) then
						o.towers.next=0
					end
					o.towers.next = o.towers.next+1
				end
				o.towers.amount = o.towers.amount+1
				print("Tower was placed at "..x..", "..y)
			end
		end
	end
	o.removeTower = function(x,y) --can remove from a position
		if (not x or x<1 or x>o.map.width or not y or y<1 or y>o.map.height) then
			print ("nothing will be removed here!"..x.." "..o.map.width.." "..y.." "..o.map.height)
			return end
	print("something might be removed..."..x.." "..o.map.width.." "..y.." "..o.map.height)
	local state =o.map.getState(x,y)
	if state and not(state==0) then -- TODO: don't let main tower be deleted!!!
		--o.map.setState(x,y,0)
		for i=1,o.towers.maxamount do
			if o.towers[i] and o.towers[i].value and o.towers[i].value.x==x and o.towers[i].value.y==y then
				turMap.setState(x,y,0)
				o.towers[i] = nil
			end
			o.towers.amount = o.towers.amount-1
			print("Tower was removed at "..x..", "..y)
			return
	end
	print("Could not delete tower at "..x..", "..y)
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
		o.creepAnim:update(dt)
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
		o.drawShots()
		o.drawPaths()
		o.drawEnemies()
	end
	o.drawShots = function()
		local e = o.enemies[1]		-- TODO this is a hack because I know there's only one creep for now

		local x, y = e.x, e.y
		G.setColor(255, 0, 0)

		for i = 1, o.towers.amount do
			-- TODO which tower shoots what should be determined in update(); here we should only draw what has already been determined
			local t = o.towers[i]
			--o.drawLine(t.x,t.y, x,y) -- TODO use tower coordinates
			local tx = (t.x - 0.5) * o.map.tileWidth + o.offsetX
			local ty = (t.y - 0.5) * o.map.tileHeight + o.offsetY
			local ex = (e.x - 0.5) * o.map.tileWidth + o.offsetX
			local ey = (e.y - 0.5) * o.map.tileHeight + o.offsetY
			local direction = math.atan2(tx - ex, ey - ty) + math.pi * 0.5
			local length = math.sqrt(math.pow(tx - ex, 2) + math.pow(ty - ey, 2))
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
			G.setColor(0, 63, 123)
			o.drawLine(x,y,x+ox,y+oy)
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
	--font = G.newImageFont("gfx/font.png", " abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789.,!?-+/():;%&`'*#=[]\"")
	--font:setFilter("nearest", "nearest")
	--G.setFont(font)

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