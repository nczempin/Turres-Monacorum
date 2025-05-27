LOVE_AI_GRID = require("external.jumper.grid")
LOVE_AI_PATH = require("external.jumper.pathfinder")

love.ai = {}

love.ai.newAI = function()
	local o = {}

	o.map = nil
	o.emptyMap = nil
	o.path = nil
	o.length = 0
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
	o.xVar = math.random()
	o.yVar = math.random()


	o.update = function(dt)
		if o.newPath then
			local myFinder = LOVE_AI_PATH(LOVE_AI_GRID(o.map), 'JPS', o.walkable)
			myFinder:setMode('ORTHOGONAL')
			local time = love.timer.getTime()
			o.path, o.length = myFinder:getPath(o.startY, o.startX, o.endY, o.endX)
			print(love.timer.getTime() - time)
			if not o.path then
				myFinder = LOVE_AI_PATH(LOVE_AI_GRID(o.emptyMap), 'JPS', o.walkable)
				myFinder:setMode('ORTHOGONAL')
				o.path, o.length = myFinder:getPath(o.startY, o.startX, o.endY, o.endX)
			end
			o.step = 1
			o.newPath = false
		end

		if o.speed > 0 then
			if o.direction == 0 and (o.currX ~= o.endX or o.currY ~= o.endY) and o.map[o.endX][o.endY] == 0 then
				if o.path and o.step < #o.path then
					o.step = o.step + 1

					o.nextX = o.path[o.step].y
					o.nextY = o.path[o.step].x

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
		return o.path[n].y
	end

	o.getPathY = function(n)
		return o.path[n].x
	end

	o.getCurrentLength = function()
		return (math.abs(o.currX - o.endX) ^ 2 + math.abs(o.currY - o.endY) ^ 2) ^ 0.5
	end

	o.getMapWidth = function()
		return #o.map
	end

	o.getMapHeight = function()
		return #o.map[1]
	end

	o.getX = function()
		return o.currX+o.xVar*0.5
	end

	o.getY = function()
		return o.currY+o.yVar*0.5
	end

	o.newMap = function(width, height)
		o.map = {}

		for i = 1, width do
			o.map[i] = {}
			for k = 1, height do
				o.map[i][k] = 0
			end
		end

		o.newEmptyMap(width, height)

		return o.map
	end

	o.newEmptyMap = function(width, height)
		o.emptyMap = {}

		for i = 1, width do
			o.emptyMap[i] = {}
			for k = 1, height do
				o.emptyMap[i][k] = 0
			end
		end
	end

	o.setMap = function(map)
		o.map = map
		o.newEmptyMap(#o.map, #o.map[1])
	end

	o.getMapData = function(x, y)
		if o.map and x >= 1 and x <= #o.map and y >= 1 and y <= #o.map[1] then
			return o.map[x][y]
		else
			return 1
		end
	end

	o.setMapData = function(x, y, s)
		if o.map and x >= 1 and x <= #o.map and y >= 1 and y <= #o.map[1] then
			o.map[x][y] = s
			o.newPath = true
		end
	end

	o.getDirection = function()
		return o.direction
	end

	o.setStartPosition = function(x, y)
		if o.map and x >= 1 and x <= #o.map and y >= 1 and y <= #o.map[1] then
			o.startX = x
			o.startY = y
			o.currX = x
			o.currY = y
			o.newPath = true
		end
	end

	o.setEndPosition = function(x, y)
		if o.map and x >= 1 and x <= #o.map and y >= 1 and y <= #o.map[1] then
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
		if x >= 1 and x <= #o.map and y >= 1 and y <= #o.map[1] and x2 >= 1 and x2 <= #o.map and y2 >= 1 and y2 <= #o.map[1] then
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