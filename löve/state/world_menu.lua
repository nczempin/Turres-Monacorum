local o = {}

local startx = love.window.getWidth() * 0.5 - 176 * 0.5
local starty = 128

o.imgBackground	= love.graphics.newImage("gfx/world.png")

o.fontTitle = love.graphics.newFont(24)
o.fontDescription = love.graphics.newFont(16)

o.effectTimer = 0
o.chromaticEffect = 0
o.selDescription = nil
o.description = {}
o.description[1] = {"Stage 1", "Defeat 4 Wave lines", "with 2 different enemies."}
o.description[2] = {"Stage 2", "Test1", "Test2"}

o.guiMenu		= love.gui.newGui()
o.btnStage1		= o.guiMenu.newButton(startx - 20, starty, 34, 34, "1")
o.btnStage2		= o.guiMenu.newButton(startx + 60, starty + 56, 34, 34, "2")
o.btnStage3		= o.guiMenu.newButton(startx + 112, starty + 144, 34, 34, "3")
o.btnBack		= o.guiMenu.newButton(love.window.getWidth() - 192, love.window.getHeight() - 48, 176, 34, "Back")

o.btnStage2.disable()
o.btnStage3.disable()

o.reset = function()
	o.guiMenu.flushMouse()
end

o.update = function(dt)
	o.effectTimer = o.effectTimer + dt
	o.chromaticEffect = o.chromaticEffect + dt

	o.guiMenu.update(dt)

	if o.btnStage1.isHit() then
		love.sounds.playSound("sounds/button_pressed.wav")
		love.setgamestate(1)
		o.guiMenu.flushMouse()
	end

	if o.btnStage1.onHover() then
		o.selDescription = 1
	end

	if o.btnStage2.onHover() then
		o.selDescription = 2
	end

	if o.btnBack.isHit() or love.keyboard.isDown("escape") then
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
	local startx = love.window.getWidth() * 0.5 - 176 * 0.5
	local starty = 128

	o.guiMenu		= love.gui.newGui()
	o.btnStage1		= o.guiMenu.newButton(startx - 20, starty, 34, 34, "1")
	o.btnStage2		= o.guiMenu.newButton(startx + 60, starty + 56, 34, 34, "2")
	o.btnStage3		= o.guiMenu.newButton(startx + 112, starty + 144, 34, 34, "3")
	o.btnBack		= o.guiMenu.newButton(love.window.getWidth() - 192, love.window.getHeight() - 48, 176, 34, "Back")

	o.btnStage2.disable()
	o.btnStage3.disable()
end

return o