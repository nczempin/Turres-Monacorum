function love.turris.newEnemy(img,x,y)
	local o = {}
	o.img = img
	o.x = x
	o.y = y
	o.xVel = 0.5
	o.yVel = 0
	return o
end