function love.turris.newEnemyType(id, sheet, maxHealth, baseSpeed)
	local o = {}
	o.id = id
	o.sheet = sheet
	o.maxHealth = maxHealth
	o.baseSpeed = baseSpeed
	o.playDeathSound = function()
		if o.id == 1 then
			love.sounds.playSound("sounds/phaser_rotating.mp3")
		elseif o.id == 2 then
			love.sounds.playSound("sounds/highpitch_boom.mp3")
		else
			print ("warning: unknown creep id: ", o.id)
		end
	end

	return o
end