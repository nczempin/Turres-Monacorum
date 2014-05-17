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
	local x1 = W.getWidth() * 0.125
	local x2 = W.getWidth() * 0.75
	local y1 = 160
	local rectX1 = x1 - 16
	local text = o.text
	local scale = 1
	local alignment = "left"
	o.drawMessage(x1,x2,y1,rectX1,text,scale,alignment)
	G.setColor(255, 255, 255, 127)
	G.setFont(FONT)
	o.guiMenu.draw()
end

o.drawMessage = function(x1,x2,y1,rectX1,text,scale,alignment)
	love.postshader.addEffect("monochrom")
	G.setFont(FONT_SMALLER)
	G.setColor(0, 0, 0, 127)
	G.rectangle("fill", rectX1, 160 - 16, x2 + 32, 256 + 32);
	G.setColor(255, 127, 0)
	G.rectangle("line", rectX1+4, 160 - 12, x2 + 24, 256 + 24);
	G.setColor(255, 127, 0)
	G.printf(text, x1, y1, x2, alignment, 0, scale, scale)
end
return o