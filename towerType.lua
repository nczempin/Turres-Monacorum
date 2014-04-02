function love.turris.newTowerType(path)
	local o = {}
	o.path = path
	o.img = G.newImage(o.path .. "_diffuse.png")
	o.normal = G.newImage(o.path .. "_normal.png")
	o.glow = G.newImage(o.path .. "_glow.png")
	o.upper = nil


	--TODO: Of course these all have to differ depending on type
	o.maxHealth = 100.0
	o.buildCost = 10 --mass
	o.scrapValue = 5 --mass
	o.shotCost = 10 --energy per second
	
	o.damage = 100
	o.range = 2

	o.getMaxHealth = function(health)
		return o.maxHealth
	end

	o.setMaxHealth = function(health)
		o.maxHealth = health
	end

	o.setUpperImage = function(upper)
		if upper then
			o.upper = G.newImage(o.path .. "_upper.png")
		else
			o.upper = nil
		end
	end

	return o
end