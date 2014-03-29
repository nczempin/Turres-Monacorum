require "postshader"
require "light"
require "world"
require "game"
require "map"
require "tower"

function love.load()
	G = love.graphics
	W = love.window
	T = love.turris

	turGame = love.turris.newGame()
	turMap = love.turris.newMap(20, 20)
	turGame.newGround("gfx/ground01.png")
	turGame.newTower("gfx/tower01.png")
end

function love.update(dt)
	turMap.setState(4, 3, 1)
	turMap.setState(9, 13, 1)
	turGame.setMap(turMap.getMap())
end

function love.draw()
	W.setTitle("FPS: " .. love.timer.getFPS())
	turGame.drawMap()
end

function love.mousepressed(x, y, key)

end

function love.keypressed(key, code)

end