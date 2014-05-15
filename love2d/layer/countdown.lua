local o = {}
local SECONDS = 4

o.init = function(dt)
	o.countdown = SECONDS
	o.oldcountdown = o.countdown -1
end

o.update = function(dt)
	o.countdown = o.countdown - dt
	if (o.countdown <= -1)then
		love.setgamestate(1)
		turGame.map.editMode = true;
	end
end

o.draw = function()
	G.setBlendMode("additive")
	G.setFont(FONT_LARGE)
	G.setColor(255, 127, 0, 127)
	local countdown = math.floor(o.countdown+0.5)
	local text = tostring(countdown)
	if countdown <= 0 then
		text = "Go!"
	elseif countdown >= 4 then
		text = ""
	else if countdown >= 1 then
		if (o.oldcountdown == countdown)then
			if countdown == 3 then
				love.sounds.playSound("sounds/super_phaser.mp3")
			end
			love.sounds.playSound("sounds/phaser_2.mp3")
			o.oldcountdown = countdown -1
		end
	end
	end
	local scale = 1-(o.countdown-o.oldcountdown)/2
	G.print(text, W.getWidth() * 0.5, W.getHeight() * 0.5, 0, scale, scale, string.len(text) * 16, 32)
	G.setBlendMode("alpha")
	G.setColor(255, 255, 255)
end

return o