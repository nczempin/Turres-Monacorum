local o = {}

o.text = ""

o.init = function()
	o.text = "lorem ipsum dolor sit amet" --TODO: this should be retrieved from the level/wave
end

o.update = function(dt)
end

o.draw = function()
	G.setFont(FONT_LARGE)
	G.setColor(255, 127, 0, 127)
	local scale = 1---(o.countdown-o.oldcountdown)/2
	G.printf(o.text, 0, 240, W.getWidth(), "center",0,scale,scale)
	G.setColor(255, 255, 255, 127)
end

return o