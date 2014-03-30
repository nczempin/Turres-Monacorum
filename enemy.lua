function love.turris.newEnemy(img)
	local o = {}
	o.img = img
	o.x = {}
	o.y = {}
	o.xVel = 0.5
	o.yVel = 0
	return o
end