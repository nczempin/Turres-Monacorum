require "postshader"
require "light"
require "world"
require "game"
require "map"
require "sound"
require "TESound"
require "world"
require "game"
require "map"
require "world"
require "game"
require "map"


function love.load()
	G = love.graphics
	W = love.windows
	T = love.turris
	S = love.sounds

	turGame = love.turris.newGame()
	turMap = love.turris.newMap(20, 20)
	print(turMap.getWidth())
end

function love.update(dt)
	TEsound.cleanup()  --Important, Clears all the channels in TEsound
	turMap.setState(4, 3, 1)
	turGame.setMap(turMap.getMap())
	turMap.setState(4, 3, 1)
	turGame.setMap(turMap.getMap())
end

function love.draw()
	turGame.drawMap()
end

function love.mousepressed(x, y, key)
	
end

function love.keypressed(key, code)
	
end