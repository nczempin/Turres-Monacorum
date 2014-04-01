--Button class
-- This Class is a Button with all its Attributes
-- @param x
-- @param y
-- @param width
-- @param height
-- @param name The Name of the button
-- @param path for an Image

function love.gui.newButton(x, y, width, height, text, imagePath)
	local o = {}

	--Attribute
	o.x				= x or 0
	o.y				= y or 0
	o.width 		= width or 64
	o.height 		= height or 16
	o.text 			= text
	o.enabled 		= true
	o.visible 		= true
	o.hover 		= false
	o.hit			= false
	o.down			= true
	o.imagePath		= imagePath
	o.colorNormal	= {255, 127, 0, 255}
	o.colorHover	= {0, 127, 255, 255}
	o.colorDisabled	= {255, 255, 255, 63}

	--Update button
	o.update = function(dt)

	end

	--Draw button
	o.draw = function(dt)
		if o.visible then
			if o.enabled then
				if o.hover then
					G.setBlendMode("alpha")
					love.graphics.setColor(0, 0, 0, 31)
					love.graphics.rectangle("fill", o.x, o.y, o.width, o.height)
					love.graphics.setColor(0, 0, 0, 95)
					love.graphics.printf(o.text, o.x + 2, o.y + 6, o.width, "center")
					G.setBlendMode("additive")
					love.graphics.setColor(o.colorHover[1], o.colorHover[2], o.colorHover[3], o.colorHover[4])
					love.graphics.printf(o.text, o.x, o.y + 4, o.width, "center")
				else
					G.setBlendMode("alpha")
					love.graphics.setColor(0, 0, 0, 31)
					love.graphics.rectangle("fill", o.x, o.y, o.width, o.height)
					love.graphics.setColor(0, 0, 0, 95)
					love.graphics.printf(o.text, o.x + 2, o.y + 6, o.width, "center")
					G.setBlendMode("additive")
					love.graphics.setColor(o.colorNormal[1], o.colorNormal[2], o.colorNormal[3], o.colorHover[4])
					love.graphics.printf(o.text, o.x, o.y + 4, o.width, "center")
				end
			else
				G.setBlendMode("alpha")
				love.graphics.setColor(0, 0, 0, 31)
				love.graphics.rectangle("fill", o.x, o.y, o.width, o.height)
				love.graphics.setColor(o.colorDisabled[1], o.colorDisabled[2], o.colorDisabled[3], o.colorDisabled[4])
				love.graphics.printf(o.text, o.x, o.y + 4, o.width, "center")
			end
		end
	end

	--Return true when hit
	o.isHit = function()
		return o.hit
	end

	--Return true when down
	o.isDown = function()
		return o.down
	end

	--Return type
	o.getType = function()
		return "button"
	end

	--Return x position
	o.getX = function()
		return o.x
	end

	--Return y position
	o.getY = function()
		return o.y
	end

	--Return width
	o.getWidth = function()
		return o.width
	end

	--Return height
	o.getHeight = function()
		return o.height
	end

	--Set position
	-- @param x
	-- @param y
	o.setX = function(x, y)
		o.x = x
		o.y = y
	end

	--Set x position
	-- @param x
	o.setX = function(x)
		o.x = x
	end

	--Set y position
	-- @param y
	o.setY = function(y)
		o.y = y
	end

	--Set dimension
	-- @param width
	-- @param height
	o.setDimension = function(width, height)
		o.width = width
		o.height = height
	end

	--Set width
	-- @param width
	o.setWidth = function(width)
		o.width = width
	end

	--Set height
	-- @param height
	o.setHeight = function(height)
		o.height = height
	end

	--Enable
	o.enable = function()
		o.enabled = true
	end

	--Disable
	o.disable = function()
		o.enabled = false
	end

	--Show
	o.show = function()
		o.visible = true
	end

	--Hide
	o.hide = function()
		o.visible = false
	end

	return o
end