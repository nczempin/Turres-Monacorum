local o = {}

o.init = function(dt)
end

o.update = function(dt)
end

o.draw = function()
	G.setFont(FONT_LARGE)
	G.setColor(255, 127, 0, 127)
	local scale = 1---(o.countdown-o.oldcountdown)/2
	G.printf("hello", 0, 240, W.getWidth(), "center",0,scale,scale)
	G.setColor(255, 255, 255, 127)
end

return o