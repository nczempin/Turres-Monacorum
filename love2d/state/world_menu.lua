local o = {}

o.imgBackground	= love.graphics.newImage("gfx/world.png")

o.startx = love.window.getWidth() * 0.5 - o.imgBackground:getWidth() * 0.5
o.starty = 128

o.fontTitle = love.graphics.newFont(24)
o.fontDescription = love.graphics.newFont(16)

o.effectTimer = 0
o.chromaticEffect = 0
o.selDescription = nil

o.guiMenu = love.gui.newGui()

love.filesystem.load("data/menu/missions1.lua")()

if love.filesystem.exists("save.ini") then
	love.turris.save = Tserial.unpack(love.filesystem.read("save.ini"))
else
	love.filesystem.write("save.ini", "{}")
	love.turris.save = {}
end

o.init = function()
	o.guiMenu.clear()
	
	o.btnStage = {}
	o.description = {}

	for i = 1, #missions do
		o.btnStage[i] = o.guiMenu.newButton(o.startx + missions[i].x, missions[i].y, 34, 34, missions[i].button or "")
		o.description[i] = {missions[i].title, missions[i].description}

		local locked = true

		if missions[i].needMission then
			if love.turris.save[missions[i].needMission] then
				locked = false
			end
		else
			locked = false
		end

		if locked then
			o.btnStage[i].disable()
		end
	end

	o.btnBack = o.guiMenu.newButton(love.window.getWidth() - 192, love.window.getHeight() - 48, 176, 34, "Back")
end

o.reset = function()
	o.guiMenu.flushMouse()
end

o.update = function(dt)
	o.effectTimer = o.effectTimer + dt
	o.chromaticEffect = o.chromaticEffect + dt

	o.guiMenu.update(dt)

	for i = 1, #o.btnStage do
		if o.btnStage[i].isHit() then
			love.sounds.playSound("sounds/button_pressed.wav")
			love.setgamestate(16, missions[i])
			o.guiMenu.flushMouse()
		end
	end

	for i = 1, #o.btnStage do
		if o.btnStage[i].onHover() then
			o.selDescription = i
		end
	end

	if o.btnBack.isHit() then
		love.sounds.playSound("sounds/button_pressed.wav")
		love.setgamestate(0)
		o.guiMenu.flushMouse()
	end
end

o.draw = function()
	love.graphics.setBlendMode("alpha")
	love.graphics.setColor(95 + math.sin(o.effectTimer * 0.1) * 63, 191 + math.cos(o.effectTimer) * 31, 223 + math.sin(o.effectTimer) * 31, 255)
	love.graphics.draw(o.imgBackground, love.window.getWidth() * 0.5 - o.imgBackground:getWidth() * 0.5)
	love.graphics.setColor(255, 127, 0)
	love.graphics.printf("Missions", 0, 24, love.window.getWidth(), "center")

	love.graphics.setColor(95 + math.sin(o.effectTimer * 0.1) * 63, 191 + math.cos(o.effectTimer) * 31, 223 + math.sin(o.effectTimer) * 31, 255)
	if o.selDescription then
		love.graphics.setFont(o.fontTitle)
		love.graphics.print(o.description[o.selDescription][1], love.window.getWidth() - 256, 72)
		love.graphics.line(love.window.getWidth() - 272, 112, love.window.getWidth() - 16, 112)
		love.graphics.setFont(o.fontDescription)
		for i = 2, #o.description[o.selDescription] do
			love.graphics.print(o.description[o.selDescription][i], love.window.getWidth() - 256, (i - 1) * 24 + 104)
		end
	end

	love.graphics.setFont(o.fontTitle)
	o.guiMenu.draw()

	if math.random(0, love.timer.getFPS() * 5) == 0 then
		o.chromaticEffect = math.random(0, 5) * 0.1
	end

	if o.chromaticEffect < 1.0 then
		local colorAberration1 = math.sin(love.timer.getTime() * 10.0) * (1.0 - o.chromaticEffect) * 2.0
		local colorAberration2 = math.cos(love.timer.getTime() * 10.0) * (1.0 - o.chromaticEffect) * 2.0

		love.postshader.addEffect("chromatic", colorAberration1, colorAberration2, colorAberration2, -colorAberration1, colorAberration1, -colorAberration2)
	end
end

o.setVersion = function(version)
	o.version = version
end

o.refreshScreenSize = function()
	o.startx = love.window.getWidth() * 0.5 - o.imgBackground:getWidth() * 0.5
	o.starty = 128
end

return o