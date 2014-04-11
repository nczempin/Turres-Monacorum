function love.turris.newPlayer()

	local o = {}

	o.mass = 20
	o.energy = 20

	o.addMass = function(mass)
		o.mass = o.mass + mass
	end

	o.addEnergy = function(energy)
		o.energy = o.energy + energy
	end

	o.setMass = function(mass)
		o.mass = mass
	end

	o.setEnergy = function(energy)
		o.energy = energy
	end

	return o

end