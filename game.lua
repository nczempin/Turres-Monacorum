function love.turris.newGame()
	o = {}
	o.map = {}
	o.update = function()
		
	end
	o.drawMap = function()
		for i = 1, o.map.width do
			for k = 1, o.map.height do
				G.setColor(255, 255, 255 * (1.0 - o.map.map[i][k]))
				G.rectangle("fill", i * 32, k * 24, 32, 24)
			end
		end
	end
	o.setMap = function(map)
		o.map = map
	end

	return o
end