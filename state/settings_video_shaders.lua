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

o.guiMenu		= love.gui.newGui()
o.chkBloom		= o.guiMenu.newCheckbox(startx, starty + 56 * 0, 191, 32, true, "Bloom")
o.chkScanlines	= o.guiMenu.newCheckbox(startx, starty + 56 * 1, 191, 32, true, "Scanlines")
o.chkShadow		= o.guiMenu.newCheckbox(startx, starty + 56 * 2, 191, 32, true, "Shadow")
o.chkSelfShadow	= o.guiMenu.newCheckbox(startx, starty + 56 * 3, 191, 32, true, "Self Shadow")
o.chkLights		= o.guiMenu.newCheckbox(startx, starty + 56 * 4, 191, 32, true, "Multi Lights")
o.chkGlow		= o.guiMenu.newCheckbox(startx, starty + 56 * 5, 191, 32, true, "Glow")
o.btnBack		= o.guiMenu.newButton(startx + 8, starty + 64 * 5 + 8, 176, 34, "Back")

o.optionBloom = true
o.optionScanlines = true
o.optionShadow = true
o.optionLights = true
o.optionGlow = true

o.reset = function()
	o.guiMenu.flushMouse()
end

o.update = function(dt)
	o.effectTimer = o.effectTimer + dt
	o.chromaticEffect = o.chromaticEffect + dt

	o.guiMenu.update(dt)

	if o.chkBloom.isHit() then
		love.sounds.playSound("sounds/button_pressed.wav")
		o.optionBloom = o.chkBloom.isChecked()
	end

	if o.chkScanlines.isHit() then
		love.sounds.playSound("sounds/button_pressed.wav")
		o.optionScanlines = o.chkScanlines.isChecked()
	end

	if o.chkShadow.isHit() then
		love.sounds.playSound("sounds/button_pressed.wav")
		lightWorld.optionShadows = o.chkShadow.isChecked()
	end

	if o.chkSelfShadow.isHit() then
		love.sounds.playSound("sounds/button_pressed.wav")
		lightWorld.optionPixelShadows = o.chkSelfShadow.isChecked()
	end

	if o.chkLights.isHit() then
		love.sounds.playSound("sounds/button_pressed.wav")
		o.optionLights = o.chkLights.isChecked()
		love.turris.reinit()
	end

	if o.chkGlow.isHit() then
		love.sounds.playSound("sounds/button_pressed.wav")
		lightWorld.optionGlow = o.chkGlow.isChecked()
	end

	if o.btnBack.isHit() or love.keyboard.isDown("escape") then
		love.sounds.playSound("sounds/button_pressed.wav")
		love.setgamestate(6)
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
	love.graphics.draw(o.imgMiddleground, (love.window.getWidth() - o.imgMiddleground:getWidth()) * 0.5, 0)

	love.graphics.setBlendMode("alpha")
	love.graphics.setColor(0, 0, 0, 95)
	love.graphics.printf("Shaders", 4, 24 + 4, love.window.getWidth(), "center")
	love.graphics.setColor(255, 127, 0)
	love.graphics.setBlendMode("additive")
	love.graphics.printf("Shaders", 0, 24, love.window.getWidth(), "center")

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

return o