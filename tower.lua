function love.turris.newTower(img)
	local o = {}
	o.img = G.newImage(img .. "_diffuse.png")
	o.normal = G.newImage(img .. "_normal.png")
	o.glow = G.newImage(img .. "_glow.png")

	return o
end