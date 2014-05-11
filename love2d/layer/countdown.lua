local o = {}

o.effectTimer = 0

o.update = function(dt)
	o.effectTimer = o.effectTimer + dt
end

o.draw = function()
	G.setFont(FONT)
	G.setColor(255, 127, 0, 127)
	G.printf("Countdown", 0, 240, W.getWidth(), "center")
	G.setColor(255, 255, 255, 127)
end

return o