require "towerType"

function love.turris.newTower(type, x, y, id)
	print ("new tower:", type, x, y)
	local o = {}
	o.id = id
	o.x = x
	o.y = y
	o.type = type
	o.shooting = false
	o.target = {}

	o.getRange = function()
		return type.range
	end

	o.determineTarget = function(enemies, distance_function)
		for i = 1, #enemies do
			local e = enemies[i]
			if not e.dead then
				local d = distance_function(o.x, o.y, e.ai.getX(), e.ai.getY())
				if (d <= o.type.range)then
					return e --TODO: for now we just pick the one existing enemy. Once we have more than one, we need to choose between the ones in range
				end
			end
		end
	end

	return o
end