--Checkbox class
-- This Class is a Checkbox with all its Attributes
-- @param x
-- @param y
-- @param width
-- @param height
-- @param checked
-- @param text

function love.gui.newCheckbox(x, y, width, height, checked, text)
	local o = {}

	--Attribute
	o.type			= "checkbox"
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
	o.checked		= checked
	o.colorNormal	= {255, 127, 0, 255}
	o.colorHover	= {0, 127, 255, 255}
	o.colorDisabled	= {255, 255, 255, 63}

	--Update button
	o.update = function(dt)

	end

	--Draw button
	o.draw = function(dt)
		if o.visible then
			G.setBlendMode("alpha")
			G.setColor(0, 0, 0, 31)
			G.rectangle("fill", o.x + o.width - o.height, o.y, o.height, o.height)

			if o.enabled then
				G.setColor(0, 0, 0, 95)
				G.printf(o.text, o.x + 2, o.y + 6, o.width, "left")
				G.setLineWidth(4)
				G.rectangle("line", o.x + o.width - o.height, o.y, o.height, o.height)
				G.setBlendMode("additive")

				if o.hover then
					G.setColor(o.colorHover[1], o.colorHover[2], o.colorHover[3], o.colorHover[4])
				else
					G.setColor(o.colorNormal[1], o.colorNormal[2], o.colorNormal[3], o.colorHover[4])
				end
			else
				G.setBlendMode("alpha")
				G.setColor(0, 0, 0, 31)
				G.rectangle("fill", o.x + o.width - o.height, o.y, o.height, o.height)
				G.setColor(o.colorDisabled[1], o.colorDisabled[2], o.colorDisabled[3], o.colorDisabled[4])
			end

			G.printf(o.text, o.x, o.y + 4, o.width, "left")
			G.setLineWidth(2)
			G.rectangle("line", o.x + o.width - o.height, o.y, o.height, o.height)

			if o.checked then
				G.rectangle("fill", o.x + o.width - o.height + 4, o.y + 4, o.height - 8, o.height - 8)
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

	--Return true when checked
	o.isChecked = function()
		return o.checked
	end

	--Return type
	o.getType = function()
		return "checkbox"
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