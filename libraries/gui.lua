--GUI class
love.gui = {}

require "libraries/button"
require "libraries/checkbox"

function love.gui.newGui()
	local o = {}

	--Attribute
	o.elements = {}
	o.hit = false
	o.down = true
	o.timer = 0

	--Update gui
	o.update = function(dt)
		local mx = love.mouse.getX()
		local my = love.mouse.getY()

		o.timer = o.timer + dt

		if love.mouse.isDown("l") then
			if o.down then
				o.hit = false
			else
				o.hit = true
				o.down = true
			end
		else
			o.hit = false
			o.down = false
		end

		--Check if Mouse is over an element
		for i = 1, #o.elements do
			o.elements[i].update(dt)

			if o.elements[i].enabled then
				if mx >= o.elements[i].x and mx <= o.elements[i].x + o.elements[i].width and my >= o.elements[i].y and my <= o.elements[i].y + o.elements[i].height then
					o.elements[i].hover = true
					if love.mouse.isDown("l") then
						if o.elements[i].down then
							o.elements[i].hit = false
						else
							o.elements[i].hit = true
							o.elements[i].down = true
							if o.elements[i].type == "checkbox" then
								o.elements[i].checked = not o.elements[i].checked
							end
						end
					else
						o.elements[i].hit = false
						o.elements[i].down = false
					end
				else
					o.elements[i].hover = false
					o.elements[i].hit = false
					o.elements[i].down = false
				end
			end
		end
	end

	--Draw gui
	o.draw = function(dt)
		for i = 1, #o.elements do
			o.elements[i].draw()
		end
	end

	--Return new button
	o.newButton = function(x, y, width, height, name, imagePath)
		o.elements[#o.elements + 1] = love.gui.newButton(x, y, width, height, name, imagePath)

		return o.elements[#o.elements]
	end

	--Return new checkbox
	o.newCheckbox = function(x, y, width, height, checked, text)
		o.elements[#o.elements + 1] = love.gui.newCheckbox(x, y, width, height, checked, text)

		return o.elements[#o.elements]
	end

	--Return true when hit
	o.isHit = function()
		return o.hit
	end

	--Return true when down
	o.isDown = function()
		return o.down
	end

	--Flush Mouse stats
	o.flushMouse = function()
		o.hit = false
		o.down = true

		for i = 1, #o.elements do
			o.elements[i].hit = false
			o.elements[i].down = true
		end
	end

	return o
end