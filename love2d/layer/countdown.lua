local o = {}
local SECONDS = 3

o.init = function(dt)
	o.countdown = SECONDS
end

o.update = function(dt)
	o.countdown = o.countdown - dt
	if (o.countdown <= 0)then
		love.setgamestate(1)
	end
end

o.draw = function()
	G.setFont(FONT_LARGE)
	G.setColor(255, 127, 0, 127)
	local text = tostring(math.floor(o.countdown+0.5))
	if text == "0" then
		text = "Go!"
	end
	G.printf(text, 0, 240, W.getWidth(), "center")
	G.setColor(255, 255, 255, 127)
end

return o