local o = {}
local SECONDS = 3
o.countdown = SECONDS

o.update = function(dt)
	o.countdown = o.countdown - dt
end

o.draw = function()
	G.setFont(FONT)
	G.setColor(255, 127, 0, 127)
	local text = tostring(math.floor(o.countdown+0.5))
	G.printf(text, 0, 240, W.getWidth(), "center")
	G.setColor(255, 255, 255, 127)
end

return o