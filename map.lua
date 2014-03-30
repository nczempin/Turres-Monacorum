function love.turris.newMap(width, height, tileWidth, tileHeight)
	local o = {}
	o.width = width or 16
	o.height = height or 16
	o.tileWidth = tileWidth or 64
	o.tileHeight = tileHeight or 48
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
	local glow = love.graphics.newImage("gfx/ground01_glow.png")
	for i = 0, o.width - 1 do
		o.shadow[i + 1] = {}
		for k = 0, o.height - 1 do
			o.shadow[i + 1][k + 1] = lightWorld.newImage(img, (i + 1) * tileWidth - tileWidth * 0.5, (k + 1) * tileHeight - tileHeight * 0.5, tileWidth, tileHeight)
			o.shadow[i + 1][k + 1].setShadow(false)
			o.shadow[i + 1][k + 1].setNormalMap(normal)
			o.shadow[i + 1][k + 1].setGlowMap(glow)
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
		if n > 0 then
			if n == 4 then
				o.shadow[x][y].setShadow(false)
			else
				o.shadow[x][y].setShadow(true)
			end
			o.shadow[x][y].setImage(turGame.tower[n].img)
			o.shadow[x][y].setImageOffset(o.tileWidth * 0.5, o.tileHeight * 0.5 + (turGame.tower[n].img:getHeight() - o.tileHeight))
			o.shadow[x][y].setNormalMap(turGame.tower[n].normal)
			o.shadow[x][y].setNormalOffset(o.tileWidth * 0.5, o.tileHeight * 0.5 + (turGame.tower[n].img:getHeight() - o.tileHeight))
			o.shadow[x][y].setGlowMap(turGame.tower[n].glow)
		else
			o.shadow[x][y].setShadow(false)
		end
	end

	return o
end