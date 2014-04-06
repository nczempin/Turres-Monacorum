--Button class
-- This Class is a Button with all its Attributes
-- @param x
-- @param y
-- @param width
-- @param height
-- @param name The Name of the button
-- @param path for an Image

function love.gui.newButton(x, y, width, height, text)
	local o = {}

	--Attribute
	o.type			= "button"
	o.x				= x or 0
	o.y				= y or 0
	o.width 		= width or 64
	o.height 		= height or 16
	o.text 			= text
	o.textX			= nil
	o.textY			= nil
	o.enabled 		= true
	o.visible 		= true
	o.hover 		= false
	o.hit			= false
	o.down			= true
	o.img			= nil
	o.colorNormal	= {255, 127, 0, 255}
	o.colorHover	= {0, 127, 255, 255}
	o.colorDisabled	= {255, 255, 255, 63}

	--Update button
	o.update = function(dt)

	end

	--Draw button
	o.draw = function(dt)
		if o.visible then
			local color

			if o.enabled then
				if o.hover then
					color = o.colorHover
				else
					color = o.colorNormal
				end
			else
				color = o.colorDisabled
			end

			G.setBlendMode("alpha")
			G.setColor(0, 0, 0, 31)
			G.rectangle("fill", o.x, o.y, o.width, o.height)
			G.setColor(0, 0, 0, 95)
			G.setLineWidth(4)
			G.rectangle("line", o.x, o.y, o.width, o.height)
			G.setBlendMode("additive")
			G.setColor(color[1], color[2], color[3], color[4])
			G.setLineWidth(2)
			G.rectangle("line", o.x, o.y, o.width, o.height)

			if o.img then
				G.setBlendMode("alpha")
				G.setColor(255, 255, 255)
				G.draw(o.img, o.x + o.imgX, o.y + o.imgY)
			end

			if o.text then
				if o.font then
					G.setFont(o.font)
				end

				if o.textX and o.textY then
					G.setColor(0, 0, 0, 95)
					G.printf(o.text, o.x + o.textX + 2, o.y + o.textY + 6, o.width, "left")
					G.setBlendMode("additive")
					G.setColor(color[1], color[2], color[3], color[4])
					G.printf(o.text, o.x + o.textX, o.y + o.textY + 4, o.width, "left")					
				else
					G.setColor(0, 0, 0, 95)
					G.printf(o.text, o.x + 2, o.y + 6, o.width, "center")
					G.setBlendMode("additive")
					G.setColor(color[1], color[2], color[3], color[4])
					G.printf(o.text, o.x, o.y + 4, o.width, "center")
				end

				G.setBlendMode("alpha")
			end
		end
	end

	--Return true when hover
	o.onHover = function()
		return o.hover
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
	o.setPosition = function(x, y)
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

	--Set text
	-- @param text
	o.setFontSize = function(size)
		o.font = G.newFont(size)
	end

	--Set text
	-- @param text
	o.setText = function(text)
		o.text = text
	end

	--Set text position
	-- @param x
	-- @param y
	o.setTextPosition = function(x, y)
		o.textX = x
		o.textY = y
	end

	--Set image
	-- @param height
	o.setImage = function(img)
		o.img = img
	end

	--Set normal color
	-- @param red
	-- @param green
	-- @param blue
	-- @param alpha
	o.setColorNormal = function(red, green, blue, alpha)
		if alpha then
			o.colorNormal = { red, green, blue, alpha }
		else
			o.colorNormal = { red, green, blue, 255 }
		end
	end

	--Set hover color
	-- @param red
	-- @param green
	-- @param blue
	-- @param alpha
	o.setColorHover = function(red, green, blue, alpha)
		if alpha then
			o.colorHover = { red, green, blue, alpha }
		else
			o.colorHover = { red, green, blue, 255 }
		end
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