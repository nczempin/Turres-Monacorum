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
	local x1 = W.getWidth() * 0.125
	local x2 = W.getWidth() * 0.75
	local y1 = 160
	local rectX1 = x1 - 16
	local text = o.text
	local scale = 1
	local alignment = "left"
	G.setFont(FONT)
	G.setColor(255, 127, 0, 127)
	local scale = 1---(o.countdown-o.oldcountdown)/2
	love.turris.drawMessage(x1,x2,y1,rectX1,text,scale,alignment)
	G.setColor(255, 255, 255, 127)
	o.guiMenu.draw()
end

o.getCopy = function()
	return o
end

return o