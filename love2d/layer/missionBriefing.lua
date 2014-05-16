local o = {}

o.text = ""

o.guiMenu = love.gui.newGui()
o.init = function(mission)
	o.text = mission.briefingText or mission.description
	o.btnOkay = o.guiMenu.newButton(W.getWidth() * 0.5 - 16, 364, 66, 42, "OK")
	o.mission = mission
	turGame.map.editMode = false;
end

o.update = function(dt)
	o.guiMenu.update(dt)
	if o.btnOkay.isHit() then
		love.sounds.playSound("sounds/button_pressed.wav")
		love.setgamestate(14, o.mission)
		o.guiMenu.flushMouse()
	end
end

o.draw = function()
	love.postshader.addEffect("monochrom")
	G.setFont(FONT)
	G.setColor(0, 0, 0, 127)
	G.rectangle("fill", W.getWidth() * 0.125 - 16, 160 - 16, W.getWidth() * 0.75 + 32, 256 + 32);
	G.setColor(255, 127, 0)
	G.rectangle("line", W.getWidth() * 0.125 - 12, 160 - 12, W.getWidth() * 0.75 + 24, 256 + 24);
	G.setColor(255, 127, 0)
	local scale = 1---(o.countdown-o.oldcountdown)/2
	G.printf(o.text, W.getWidth() * 0.125, 160, W.getWidth() * 0.75, "center", 0, scale, scale)
	G.setColor(255, 255, 255, 127)
	o.guiMenu.draw()
end

return o