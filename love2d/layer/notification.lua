local o = {}
--code shamelessly taken from missionBriefing.lua
o.text = ""

o.guiMenu = love.gui.newGui()
o.init = function(text, disableUpdate, disableDraw, disableMouse)
	o.text = text or "Somebody called for a notification without providing any text. This was surely unintentional"
	o.noUpdate = disableUpdate or false
	o.noDraw = disableDraw or false
	o.noMouse = disableMouse or false
	o.obsolete = false
	o.btnOkay = o.guiMenu.newButton(W.getWidth()/2, W.getHeight()*0.75, 66, 42, "OK")
end

o.update = function(dt)
	o.guiMenu.update(dt)
	if o.btnOkay.isHit() then
		love.sounds.playSound("sounds/button_pressed.wav")
		-- mark notification for removal
		o.obsolete = true
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

o.getCopy = function()
	return o
end

return o