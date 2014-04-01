function love.turris.newHudLayer()
	local o = {}

	o.draw = function(energy) --TODO find better way to handle this than directly passing every little detail
		G.setColor(255, 0, 255, 127)
		G.print("Energy: "..energy, 10, 10)
	end

	return o
end

