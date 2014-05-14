local o = {}

o.text = ""

o.guiMenu = love.gui.newGui()
o.init = function(text, mission)
	o.text = text
	o.btnOkay = o.guiMenu.newButton(W.getWidth()/2, W.getHeight()*0.75, 66, 42, "OK")
	o.mission = mission
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
	G.setFont(FONT)
	G.setColor(255, 127, 0, 127)
	local scale = 1---(o.countdown-o.oldcountdown)/2
	G.printf(o.text, 0, 240, W.getWidth(), "center",0,scale,scale)
	G.setColor(255, 255, 255, 127)
	o.guiMenu.draw()
end

return o