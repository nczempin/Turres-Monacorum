function love.turris.newEnemy(img)
	local o = {}
	o.img = img
	o.x = {}
	o.y = {}
	o.xVel = 2
	o.yVel = 0
	return o
end