function love.turris.newEnemyType(img, maxHealth, baseSpeed)
	local o = {}
	o.img = img
	o.maxHealth = maxHealth
	o.baseSpeed = baseSpeed
	return o
end