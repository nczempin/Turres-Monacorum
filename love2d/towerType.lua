function love.turris.newTowerType(path)
	local o = {}
	o.path = path
	o.img = G.newImage(o.path .. "_diffuse.png")
	o.normal = G.newImage(o.path .. "_normal.png")
	o.glow = G.newImage(o.path .. "_glow.png")
	o.upper = nil
	o.water = false

	--TODO: Of course these all have to differ depending on type
	o.collision = true
	o.maxHealth = 100.0
	o.buildCost = 10 --mass
	o.scrapValue = 5 --mass
	o.shotCost = 10 --energy per second
	o.breakable = true
	o.energyGeneration = 0
	o.massGeneration = 0

	o.damage = 100
	o.range = 1

	o.getMaxHealth = function(health)
		return o.maxHealth
	end

	o.setMaxHealth = function(health)
		o.maxHealth = health
	end

	o.isBreakable = function()
		return o.breakable
	end

	o.setBreakable = function(breakable)
		o.breakable = breakable
	end

	o.getCollision = function()
		return o.collision
	end

	o.setCollision = function(collision)
		o.collision = collision
	end

	o.setEnergyGeneration = function(energy)
		o.energyGeneration = energy
	end

	o.setMassGeneration = function(mass)
		o.massGeneration = mass
	end

	o.setRange = function(range)
		o.range = range
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