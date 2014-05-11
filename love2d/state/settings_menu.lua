local o = {}

local startx = love.window.getWidth() * 0.5 - 191 * 0.5
local starty = 80

o.imgBackground		= love.graphics.newImage("gfx/menu/menu_background.png")
o.imgMiddleground	= love.graphics.newImage("gfx/menu/menu_middleground.png")
o.imgScreen			= love.graphics.newImage("gfx/menu/screen00.png")

o.fontMenu = love.graphics.newFont(32)
o.fontOption = love.graphics.newFont(24)

o.effectTimer = 0
o.chromaticEffect = 0

o.guiMenu			= love.gui.newGui()
o.btnVideo			= o.guiMenu.newButton(startx + 8, starty + 64 * 0 + 8, 176, 34, "Video")
o.btnAudio			= o.guiMenu.newButton(startx + 8, starty + 64 * 1 + 8, 176, 34, "Audio")
o.btnBack			= o.guiMenu.newButton(startx + 8, starty + 64 * 5 + 8, 176, 34, "Back")

o.reset = function()
	o.guiMenu.flushMouse()
end

o.update = function(dt)
	o.effectTimer = o.effectTimer + dt
	o.chromaticEffect = o.chromaticEffect + dt

	o.guiMenu.update(dt)

	if o.btnVideo.isHit() then
		love.sounds.playSound("sounds/button_pressed.wav")
		love.setgamestate(7)
		o.guiMenu.flushMouse()
	end

	if o.btnAudio.isHit() then
		love.sounds.playSound("sounds/button_pressed.wav")
		love.setgamestate(10)
		o.guiMenu.flushMouse()
	end

	if o.btnBack.isHit() or love.keyboard.isDown("escape") then
		love.sounds.playSound("sounds/button_pressed.wav")
		love.setgamestate(0)
		o.guiMenu.flushMouse()
	end
end

o.draw = function()
	love.graphics.setFont(o.fontMenu)
	love.graphics.setBlendMode("alpha")
	love.graphics.setColor(255, 255, 255)
	love.graphics.draw(o.imgScreen)
	love.graphics.setColor(255, 255, 255, 223)
	love.graphics.draw(o.imgBackground)
	love.graphics.setColor(95 + math.sin(o.effectTimer * 0.1) * 63, 191 + math.cos(o.effectTimer) * 31, 223 + math.sin(o.effectTimer) * 31, 255)
	love.graphics.setBlendMode("additive")
	love.graphics.draw(o.imgMiddleground,(love.window.getWidth()-o.imgMiddleground:getWidth())*0.5,0)

	love.graphics.setBlendMode("alpha")
	love.graphics.setColor(0, 0, 0, 95)
	love.graphics.printf("Settings", 4, 24 + 4, love.window.getWidth(), "center")
	love.graphics.setColor(255, 127, 0)
	love.graphics.setBlendMode("additive")
	love.graphics.printf("Settings", 0, 24, love.window.getWidth(), "center")

	love.graphics.setFont(o.fontOption)
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

o.refreshScreenSize = function()
	local startx = love.window.getWidth() * 0.5 - 191 * 0.5
	local starty = 80

	o.btnVideo.setPosition(startx + 8, starty + 64 * 0)
	o.btnAudio.setPosition(startx + 8, starty + 64 * 1)
	o.btnBack.setPosition(startx + 8, starty + 64 * 5)
end

return o