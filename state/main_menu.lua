local o = {}

local startx = W.getWidth() * 0.5 - 176 * 0.5
local starty = 160

o.imgLogo			= love.graphics.newImage("resources/sprites/ui/logo.png")
o.imgBackground		= love.graphics.newImage("resources/sprites/ui/menu_background.png")
o.imgMiddleground	= love.graphics.newImage("resources/sprites/ui/menu_middleground.png")
o.imgOverlay		= love.graphics.newImage("resources/sprites/ui/overlay.png")
o.imgScreen			= love.graphics.newImage("gfx/screen00.png")

o.fontMenu = G.newFont(32)
o.fontVersion = G.newFont(16)

o.version = "0.0.0"
o.effectTimer = 0
o.chromaticEffect = 0

o.guiMenu		= love.gui.newGui()
o.btnStart		= o.guiMenu.newButton(startx, starty + 80 * 0, 176, 48, "Start")
o.btnConfigure	= o.guiMenu.newButton(startx, starty + 80 * 1, 176, 48, "Configure")
o.btnCredits	= o.guiMenu.newButton(startx, starty + 80 * 2, 176, 48, "Credits")
o.btnQuit		= o.guiMenu.newButton(startx, starty + 80 * 3, 176, 48, "Quit")

o.btnConfigure.disable()

o.reset = function()
	o.guiMenu.flushMouse()
end

o.update = function(dt)
	o.effectTimer = o.effectTimer + dt
	o.chromaticEffect = o.chromaticEffect + dt

	o.guiMenu.update(dt)

	if o.btnStart.isHit() then
		love.sounds.playSound("sounds/button_pressed.wav")
		love.setgamestate(1)
	end

	if o.btnConfigure.isHit() then
		love.sounds.playSound("sounds/button_deactivated.wav")
	end

	if o.btnCredits.isHit() then
		love.sounds.playSound("sounds/button_pressed.wav")
		love.setgamestate(5)
	end

	if o.btnQuit.isHit() then
		love.sounds.playSound("sounds/button_pressed.wav")
		love.event.quit()
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
	G.setColor(255, 255, 255)
	G.setBlendMode("alpha")
	G.draw(o.imgLogo, W.getWidth() * 0.5, o.imgLogo:getHeight() * 0.5, math.sin(o.effectTimer * 4) * 0.05 * math.max(0, 2 - o.effectTimer ^ 0.5), 1, 1, o.imgLogo:getWidth() * 0.5, o.imgLogo:getHeight() * 0.5)

	o.guiMenu.draw()

	G.setFont(o.fontVersion)
	G.setColor(95 + math.sin(o.effectTimer * 0.1) * 63, 191 + math.cos(o.effectTimer) * 31, 223 + math.sin(o.effectTimer) * 31, 255)
	G.print(o.version, W.getWidth() - 64, W.getHeight() - 32)

	if math.random(0, love.timer.getFPS() * 5) == 0 then
		o.chromaticEffect = math.random(0, 5) * 0.1
	end

	if o.chromaticEffect < 1.0 then
		local colorAberration1 = math.sin(love.timer.getTime() * 10.0) * (1.0 - o.chromaticEffect) * 2.0
		local colorAberration2 = math.cos(love.timer.getTime() * 10.0) * (1.0 - o.chromaticEffect) * 2.0

		love.postshader.addEffect("chromatic", colorAberration1, colorAberration2, colorAberration2, -colorAberration1, colorAberration1, -colorAberration2)
	end

	love.postshader.addEffect("scanlines", 4.0)
end

o.setVersion = function(version)
	o.version = version
end

return o