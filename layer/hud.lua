local o = {}

o.iconMass = love.graphics.newImage("gfx/mass_icon.png")
o.iconEnergy = love.graphics.newImage("gfx/energy_icon.png")

o.draw = function(player)
	local mass = player.mass
	local energy = player.energy
	G.setBlendMode("additive")
	G.setColor(0, 127, 255, 255)
	G.printf(math.floor(mass), W.getWidth() - 176, 16, 128, "right")
	G.draw(o.iconMass, W.getWidth() - 32, 32, love.timer.getTime() * 0.5, 1, 1, 8, 8)
	G.setColor(255, 127, 0, 255)
	G.printf(math.floor(energy), W.getWidth() - 176, 48, 128, "right")
	G.setColor(255, 127, 0, 191 + math.sin(love.timer.getTime() * 5.0) * 63)
	G.draw(o.iconEnergy, W.getWidth() - 40, 48)
end

return o

