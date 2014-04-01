function love.turris.newHudLayer()
	local o = {}
	local energyDisplayFont= G.newFont(16)

	o.draw = function(energy) --TODO find better way to handle this than directly passing every little detail
		G.setColor(255, 0, 255, 127)
		G.setFont(energyDisplayFont)
		G.print("Energy: "..energy, 10, 10)
	end

	return o
end

