require "postshader"
require "light"
require "world"
require "game"
require "map"
require "tower"
require "sound"
require "TESound"

function love.load()
	G = love.graphics
	W = love.window
	T = love.turris

	turGame = love.turris.newGame()
	turMap = love.turris.newMap(20, 20)
	turGame.init()
end

function love.update(dt)
	TEsound.cleanup()  --Important, Clears all the channels in TEsound
end

function love.draw()
	W.setTitle("FPS: " .. love.timer.getFPS())
	turGame.drawMap()
end

function love.mousepressed(x, y, key)
	
end

function love.keypressed(key, code)
	--Start Sound
	if key == "1" then
		love.sounds.playSound("sounds/Explosion.wav")
	end

	if key == "2" then
		love.sounds.background("sounds/Explosion.wav")
	end
end