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

o.guiMenu		= love.gui.newGui()
o.chkFullscreen	= o.guiMenu.newCheckbox(startx, starty + 64 * 0, 191, 32, false, "Fullscreen")
o.chkLarge		= o.guiMenu.newCheckbox(startx, starty + 64 * 1, 191, 32, false, "Large")
o.btnBack		= o.guiMenu.newButton(startx + 8, starty + 64 * 5 + 8, 176, 34, "Back")

o.optionLarge = small

o.reset = function()
	o.guiMenu.flushMouse()
end

o.update = function(dt)
	o.effectTimer = o.effectTimer + dt
	o.chromaticEffect = o.chromaticEffect + dt

	o.guiMenu.update(dt)

	if o.chkFullscreen.isHit() then
		love.sounds.playSound("sounds/button_pressed.wav")
		o.optionFullscreen = o.chkFullscreen.isChecked()
		local success = love.window.setFullscreen( o.optionFullscreen )
	end

	if o.chkLarge.isHit() then
		love.sounds.playSound("sounds/button_pressed.wav")
		local success
		o.optionLarge = o.chkLarge.isChecked()
		o.optionFullscreen = o.chkFullscreen.isChecked()
		if o.optionLarge then
			success = love.window.setMode( 1280, 720, {fullscreen=o.optionFullscreen})
		else
			success = love.window.setMode( 800, 600 ,{fullscreen=o.optionFullscreen})
		end
		if not success then
		--do something
		end
	end


	if o.btnBack.isHit() or love.keyboard.isDown("escape") then
		love.sounds.playSound("sounds/button_pressed.wav")
		love.setgamestate(7)
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