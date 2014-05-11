local o = {}
local SECONDS = 4

o.init = function(dt)
	o.countdown = SECONDS
	o.oldcountdown = o.countdown -1
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
	local countdown = math.floor(o.countdown+0.5)
	local text = tostring(countdown)
	if countdown == 0 then
		text = "Go!"
	elseif countdown >= 4 then
		text = ""
	else if countdown >= 1 then
		if (o.oldcountdown == countdown)then
			love.sounds.playSound("sounds/phaser_2.mp3")
			o.oldcountdown = countdown -1
		end
	end
	end
	G.printf(text, 0, 240, W.getWidth(), "center")
	G.setColor(255, 255, 255, 127)
end

return o