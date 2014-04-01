local o = {}

o.iconMass = love.graphics.newImage("gfx/mass_icon.png")
o.iconEnergy = love.graphics.newImage("gfx/energy_icon.png")

o.mass = 20
o.energy = 100

o.draw = function() --TODO find better way to handle this than directly passing every little detail
	G.setBlendMode("additive")
	G.setColor(0, 127, 255, 255)
	G.printf(math.floor(o.mass), W.getWidth() - 176, 16, 128, "right")
	G.draw(o.iconMass, W.getWidth() - 32, 32, love.timer.getTime() * 0.5, 1, 1, 8, 8)
	G.setColor(255, 127, 0, 255)
	G.printf(math.floor(o.energy), W.getWidth() - 176, 48, 128, "right")
	G.setColor(255, 127, 0, 191 + math.sin(love.timer.getTime() * 5.0) * 63)
	G.draw(o.iconEnergy, W.getWidth() - 40, 48)
end

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

