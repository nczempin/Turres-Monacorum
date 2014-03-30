require "postshader"
require "light"
require "world"
require "game"
require "map"
require "tower"
require "sound"
require "TESound"
require "gui"
require "gameoverlayer"

function love.load()
	G = love.graphics
	W = love.window
	T = love.turris
	S = love.sounds
	currentgamestate = 0
	-- create game world
	turGame = love.turris.newGame()
	turMap = love.turris.newMap(23,23)
	turGame.init()
	gameOverLayer = love.turris.newGameOverLayer()

	bloomOn = false
end
function love.getgamestate()
	return currentgamestate
end

function love.changegamestate(newgamestate)
	currentgamestate = newgamestate
end
function love.update(dt)
	if (currentgamestate==1)then
		turGame.update(dt)
	end
	TEsound.cleanup()  --Important, Clears all the channels in TEsound
end

function love.draw()
	W.setTitle("FPS: " .. love.timer.getFPS())
	love.postshader.setBuffer("render")
	if(currentgamestate==0) then --render main menu only
		gui.drawMainMenu()
	elseif(currentgamestate==1) then --render game only
		turGame.draw()
		elseif(currentgamestate == 4) then -- render game + "game over" message on top
		turGame.draw()
		gameOverLayer.draw()
	end
	--currentgamestate =1 -- quick workaround, will be removed once the mouse buttons work correctly
	if bloomOn then
		love.postshader.addEffect("bloom")
	end
	love.postshader.draw()
end

function love.keypressed(key, code)
	--Start Sound
	if key == "1" then
		love.sounds.playSound("sounds/Explosion.wav")
	end

	if key == "2" then
		love.sounds.background("sounds/Explosion.wav")
	end

	if key == "b" then
		bloomOn = not bloomOn
	end
end