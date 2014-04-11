function love.turris.newEnemyType(sheet, maxHealth, baseSpeed)
	local o = {}
	o.sheet = sheet
	o.maxHealth = maxHealth
	o.baseSpeed = baseSpeed
	return o
end