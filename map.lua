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
	o.shadow = {}
	local img = love.graphics.newImage("gfx/ground01.png")
	local normal = love.graphics.newImage("gfx/ground01_normal.png")
	for i = 1, o.width do
		o.shadow[i] = {}
		for k = 1, o.height do
			o.shadow[i][k] = lightWorld.newImage(img, i * 32 + 16, k * 24 + 12, 32, 24)
			o.shadow[i][k].setShadow(false)
			o.shadow[i][k].setNormalMap(normal)
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
		o.shadow[x][y].setShadow(n)
		if n == 1 then
			o.shadow[x][y].setImage(turGame.tower[1].img)
			o.shadow[x][y].setNormalMap(turGame.tower[1].normal)
			o.shadow[x][y].setNormalOffset(16, 20)
			o.shadow[x][y].setGlowMap(turGame.tower[1].glow)
		end
	end

	return o
end