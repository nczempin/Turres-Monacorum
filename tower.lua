function love.turris.newTower(type, x, y)
	print ("new tower:", type, x, y)
	local o = {}
	o.x = x
	o.y = y
	o.type = type

	return o
end