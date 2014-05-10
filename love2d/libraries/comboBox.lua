--ComboBox class
-- This Class is a ComboBox with all its Attributes
-- @param x
-- @param y
-- @param width
-- @param height
-- @param name The Name of the button
-- @param path for an Image
local BOUNDING_HEIGHT = 32
function love.gui.newComboBox(x, y, width, height, list)
	local o = {}

	--Attribute
	o.parent = nil
	o.type			= "comboBox"
	o.x				= x or 0
	o.y				= y or 0
	o.width 		= width or 64
	o.height 		= height or BOUNDING_HEIGHT
	o.boundingHeight = o.height
	o.boundingWidth = o.width
	o.list = list
	o.selection = 1
	o.text 			= list[o.selection]
	o.textX			= nil
	o.textY			= nil
	o.enabled 		= true
	o.visible 		= true
	o.checked		= false
	o.active = false
	o.hover 		= false
	o.hit			= false
	o.down			= true
	o.img			= nil
	o.imgX			= 0
	o.imgY			= 0
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
				if o.hover or o.checked then
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
					--G.printf(o.text, o.x + 2, o.y + 6, o.width, "center")
					G.setBlendMode("additive")
					G.setColor(color[1], color[2], color[3], color[4])
					local text = o.list[o.selection] or "???"
					G.printf(text, o.x, o.y + 4, o.width, "center")
					if o.active then
						G.setLineWidth(2)
						local j = 0
						for i = 1, #o.list do
							if i ~= o.selection then
								j = j + 1
								G.printf(o.list[i], o.x, o.y + 4+BOUNDING_HEIGHT*(j), o.width, "center")
								G.rectangle("line", o.x, o.y+BOUNDING_HEIGHT*(j), o.width, o.height)
							end
						end
					else
					end
				end

				G.setBlendMode("alpha")
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
		return "comboBox"
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

	--set checked mode
	o.setChecked = function(checked)
		if o.parent then
			o.parent.flushRadioButtons()
		end
		o.checked = checked
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

	--Set image position
	-- @param x
	-- @param y
	o.setImagePosition = function(x, y)
		o.imgX = x
		o.imgY = y
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

	o.activate = function()
		o.active = true
		o.boundingHeight = o.height * #o.list
	end

	o.deactivate = function()
		o.active = false
		o.boundingHeight = o.height
	end
	o.updateSelection = function(i)
		--swap elements at 1 and at i
		local tmpSelection = o.list[i]
		o.list[i] = o.list[1]
		o.list[1] = tmpSelection
		--print ("sel", o.list[o.selection])

	end
	o.select = function(mx, my)
		local tmpSelectionIndex = 1+math.floor((my-o.y)/BOUNDING_HEIGHT)
		o.updateSelection(tmpSelectionIndex)

	end

	o.getSelection = function()
		return o.list[o.selection]
	end
	return o
end