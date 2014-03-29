function love.turris.newMap(width, height)
	local o = {}
	o.width = width or 16
	o.height = height or 16
	o.map = {}
	for i = 1, o.width do
		o.map[i] = {}
		for k = 1, o.height do
			o.map[i][k] = 0
		end
    end
	o.getState = function(x, y)
		return o.map[x][y]
	end
	o.getHeight = function()
		return o.height
	end
	o.getMap = function()
		return o
	end
	o.getWidth = function()
		return o.width
	end
	o.setState = function(x, y, n)
		o.map[x][y] = n
	end

	return o
end