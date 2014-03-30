function love.turris.newTowerType(img)
	local o = {}
	o.img = G.newImage(img .. "_diffuse.png")
	o.normal = G.newImage(img .. "_normal.png")
	o.glow = G.newImage(img .. "_glow.png")
	o.maxHealth = 100.0

	o.getMaxHealth = function(health)
		return o.maxHealth
	end
	o.setMaxHealth = function(health)
		o.maxHealth = health
	end

	return o
end