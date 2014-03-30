function love.turris.newMap(width, height, tileWidth, tileHeight)
	local o = {}
	o.width = width or 16
	o.height = height or 16
	o.tileWidth = tileWidth or 64
	o.tileHeight = tileHeight or 48
	o.data = {}
	for i = 1, o.width do
		o.data[i] = {}
		for k = 1, o.height do
			o.data[i][k] = {}
			o.data[i][k].id = 0
			o.data[i][k].maxHealth = 100.0
			o.data[i][k].health = o.data[i][k].maxHealth
		end
    end
	o.shadow = {}
	local img = love.graphics.newImage("gfx/ground01.png")
	local normal = love.graphics.newImage("gfx/ground01_normal.png")
	local glow = love.graphics.newImage("gfx/ground01_glow.png")
	for i = 0, o.width - 1 do
		o.shadow[i + 1] = {}
		for k = 0, o.height - 1 do
			o.shadow[i + 1][k + 1] = lightWorld.newImage(img, i * tileWidth + tileWidth * 0.5, k * tileHeight + tileHeight * 0.5, tileWidth, tileHeight)
			o.shadow[i + 1][k + 1].setShadow(false)
			o.shadow[i + 1][k + 1].setNormalMap(normal)
			o.shadow[i + 1][k + 1].setGlowMap(glow)
		end
    end
	o.getState = function(x, y)
		return o.data[x][y].id
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
		o.data[x][y].id = n
		if n > 0 then
			o.shadow[x][y].setImage(turGame.towerType[n].img)
			o.shadow[x][y].setImageOffset(o.tileWidth * 0.5, o.tileHeight * 0.5 + (turGame.towerType[n].img:getHeight() - o.tileHeight))
			o.shadow[x][y].setNormalMap(turGame.towerType[n].normal)
			o.shadow[x][y].setNormalOffset(o.tileWidth * 0.5, o.tileHeight * 0.5 + (turGame.towerType[n].img:getHeight() - o.tileHeight))
			o.shadow[x][y].setGlowMap(turGame.towerType[n].glow)
			o.shadow[x][y].setShadow(true)
		else
			o.shadow[x][y].setNormalMap(normal)
			o.shadow[x][y].setGlowMap(glow)
			o.shadow[x][y].setShadow(false)
		end
	end

	return o
end