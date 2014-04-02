local o = {}

local startx = W.getWidth() * 0.5 - 191 * 0.5
local starty = 80

o.imgBackground		= love.graphics.newImage("resources/sprites/ui/menu_background.png")
o.imgMiddleground	= love.graphics.newImage("resources/sprites/ui/menu_middleground.png")
o.imgScreen			= love.graphics.newImage("gfx/screen00.png")

o.fontMenu = G.newFont(32)
o.fontOption = G.newFont(24)

o.effectTimer = 0
o.chromaticEffect = 0

o.guiMenu			= love.gui.newGui()
o.chkBloom			= o.guiMenu.newCheckbox(startx, starty + 64 * 0, 191, 32, true, "Bloom")
o.chkScanlines		= o.guiMenu.newCheckbox(startx, starty + 64 * 1, 191, 32, true, "Scanlines")
o.chkShadow			= o.guiMenu.newCheckbox(startx, starty + 64 * 2, 191, 32, true, "Shadow")
o.chkSelfShadow		= o.guiMenu.newCheckbox(startx, starty + 64 * 3, 191, 32, true, "Self Shadow")
o.chkGlow			= o.guiMenu.newCheckbox(startx, starty + 64 * 4, 191, 32, true, "Glow")
o.btnBack			= o.guiMenu.newButton(startx + 8, starty + 64 * 5 + 8, 176, 32, "Back")

o.optionBloom = true
o.optionScanlines = true
o.optionShadow = true
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

	if o.chkGlow.isHit() then
		love.sounds.playSound("sounds/button_pressed.wav")
		lightWorld.optionGlow = o.chkGlow.isChecked()
--		if lightWorld.optionGlow then
--			love.window.setMode( 800, 600 )
--		else
--			love.window.setMode( 1280, 720)
--		end
	end

	if o.btnBack.isHit() or love.keyboard.isDown("escape") then
		love.sounds.playSound("sounds/button_pressed.wav")
		love.setgamestate(0)
		o.guiMenu.flushMouse()
	end
end

o.draw = function()
	G.setFont(o.fontMenu)
	G.setBlendMode("alpha")
	G.setColor(255, 255, 255)
	G.draw(o.imgScreen)
	G.setColor(255, 255, 255, 223)
	G.draw(o.imgBackground)
	G.setColor(95 + math.sin(o.effectTimer * 0.1) * 63, 191 + math.cos(o.effectTimer) * 31, 223 + math.sin(o.effectTimer) * 31, 255)
	G.setBlendMode("additive")
	G.draw(o.imgMiddleground,(W.getWidth()-o.imgMiddleground:getWidth())*0.5,0)

	G.setBlendMode("alpha")
	G.setColor(0, 0, 0, 95)
	G.printf("Settings", 4, 24 + 4, W.getWidth(), "center")
	G.setColor(255, 127, 0)
	G.setBlendMode("additive")
	G.printf("Settings", 0, 24, W.getWidth(), "center")

	G.setFont(o.fontOption)
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