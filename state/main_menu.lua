local o = {}

local startx = W.getWidth() * 0.5 - 176 * 0.5
local starty = 160

o.imgLogo			= love.graphics.newImage("resources/sprites/ui/logo.png")
o.imgBackground	= love.graphics.newImage("resources/sprites/ui/menu_background.png")
o.imgMiddleground	= love.graphics.newImage("resources/sprites/ui/menu_middleground.png")
o.imgOverlay		= love.graphics.newImage("resources/sprites/ui/overlay.png")

o.effectTimer = 0

o.guiMenu		= love.gui.newGui()
o.btnStart		= o.guiMenu.newButton(startx, starty + 80 * 0, 176, 48, "Start")
o.btnConfigure	= o.guiMenu.newButton(startx, starty + 80 * 1, 176, 48, "Configure")
o.btnCredits	= o.guiMenu.newButton(startx, starty + 80 * 2, 176, 48, "Credits")
o.btnQuit		= o.guiMenu.newButton(startx, starty + 80 * 3, 176, 48, "Quit")

o.update = function(dt)
	o.effectTimer = o.effectTimer + dt

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
	love.graphics.setColor(255, 255, 255, 223)
	G.setBlendMode("alpha")
	G.draw(o.imgBackground)
	love.graphics.setColor(95 + math.sin(o.effectTimer * 0.1) * 63, 191 + math.cos(o.effectTimer) * 31, 223 + math.sin(o.effectTimer) * 31, 255)
	G.setBlendMode("additive")
	G.draw(o.imgMiddleground)
	love.graphics.setColor(255, 255, 255)
	G.setBlendMode("alpha")
	G.draw(o.imgLogo, o.imgLogo:getWidth() * 0.5, o.imgLogo:getHeight() * 0.5, math.sin(o.effectTimer * 4) * 0.05 * math.max(0, 2 - o.effectTimer ^ 0.5), 1, 1, o.imgLogo:getWidth() * 0.5, o.imgLogo:getHeight() * 0.5)

	o.guiMenu.draw()
end

return o