LOVE_AI_GRID = require("external.jumper.grid")
LOVE_AI_PATH = require("external.jumper.pathfinder")

love.ai = {}

love.ai.newAI = function()
	local o = {}

	o.map = nil
	o.path = nil
	o.newPath = true
	o.step = 0
	o.walkable = 0
	o.direction = 0
	o.startX = 1
	o.startY = 1
	o.endX = 1
	o.endY = 1
	o.currX = 1
	o.currY = 1
	o.nextX = 1
	o.nextY = 1
	o.speed = 0

	o.update = function(dt)
		if o.newPath then
			local path = LOVE_AI_PATH(LOVE_AI_GRID(o.map), 'JPS', o.walkable)
			path:setMode('ORTHOGONAL')
			local time = love.timer.getTime()
			o.path, o.length = path:getPath(o.startX, o.startY, o.endX, o.endY)
			print(love.timer.getTime() - time)
			o.step = 1
			o.newPath = false
		end

		if o.speed > 0 then
			if o.direction == 1 then
				o.currX = o.currX - dt * o.speed
				if o.currX < o.nextX then
					o.currX = o.nextX
					o.direction = 0
				end
			elseif o.direction == 2 then
				o.currX = o.currX + dt * o.speed
				if o.currX > o.nextX then
					o.currX = o.nextX
					o.direction = 0
				end
			elseif o.direction == 3 then
				o.currY = o.currY - dt * o.speed
				if o.currY < o.nextY then
					o.currY = o.nextY
					o.direction = 0
				end
			elseif o.direction == 4 then
				o.currY = o.currY + dt * o.speed
				if o.currY > o.nextY then
					o.currY = o.nextY
					o.direction = 0
				end
			end

			if o.direction == 0 and (o.currX ~= o.endX or o.currY ~= o.endY) and o.map[o.endY][o.endX] == 0 then
				if o.path and o.step <= #o.path then
					o.step = o.step + 1

					o.nextX = o.path[o.step].x
					o.nextY = o.path[o.step].y

					if o.currX > o.nextX then
						o.direction = 1
					elseif o.currX < o.nextX then
						o.direction = 2
					elseif o.currY > o.nextY then
						o.direction = 3
					elseif o.currY < o.nextY then
						o.direction = 4
					end
				end
			end
		end
	end

	o.refresh = function()
		o.newPath = true
	end

	o.isPath = function()
		return o.path ~= nil
	end

	o.getPathCount = function()
		return #o.path
	end

	o.getPathStep = function()
		return o.step
	end

	o.getPathLength = function()
		return o.length
	end

	o.getPathX = function(n)
		return o.path[n].x
	end

	o.getPathY = function(n)
		return o.path[n].y
	end

	o.getMapWidth = function()
		return #o.map[1]
	end

	o.getMapHeight = function()
		return #o.map
	end

	o.getX = function()
		return o.currX
	end

	o.getY = function()
		return o.currY
	end

	o.newMap = function(width, height)
		o.map = {}

		for i = 1, height do
			o.map[i] = {}
			for k = 1, width do
				o.map[i][k] = 0
			end
		end

		return o.map
	end

	o.setMap = function(map)
		o.map = map
	end

	o.getMapData = function(x, y)
		if x >= 1 and x <= #o.map[1] and y >= 1 and y <= #o.map then
			return o.map[y][x]
		else
			return 1
		end
	end

	o.setMapData = function(x, y, s)
		if x >= 1 and x <= #o.map[1] and y >= 1 and y <= #o.map then
			o.map[y][x] = s
			o.newPath = true
		end
	end

	o.getDirection = function()
		return o.direction
	end

	o.setStartPosition = function(x, y)
		if x >= 1 and x <= #o.map[1] and y >= 1 and y <= #o.map then
			o.startX = x
			o.startY = y
			o.currX = x
			o.currY = y
			o.newPath = true
		end
	end

	o.setEndPosition = function(x, y)
		if x >= 1 and x <= #o.map[1] and y >= 1 and y <= #o.map then
			o.endX = x
			o.endY = y
			o.newPath = true
		end
	end

	o.syncStart = function()
		o.startX = math.floor(o.currX)
		o.startY = math.floor(o.currY)
		o.newPath = true
	end

	o.setPath = function(x, y, x2, y2)
		if x >= 1 and x <= #o.map[1] and y >= 1 and y <= #o.map and x2 >= 1 and x2 <= #o.map[1] and y2 >= 1 and y2 <= #o.map then
			o.startX = x
			o.startY = y
			o.endX = x2
			o.endY = y2
			o.newPath = true
		end
	end

	o.setSpeed = function(speed)
		o.speed = speed
	end

	return o
end