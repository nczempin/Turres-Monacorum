require "postshader"
require "light"
require "world"
require "game"
require "map"
require "tower"
require "sound"
require "TESound"
require "gui"

function love.load()
	G = love.graphics
	W = love.window
	T = love.turris
	S = love.sounds
	currentgamestate = 0
	-- create game world
	turGame = love.turris.newGame()
	turMap = love.turris.newMap(20, 20)
	turGame.init()
	S.init()
end

function love.changegamestate(newgamestate)
	currentgamestate = 1 --newgamestate
end

function love.getgamestate()
	return currentgamestate
end
function love.update(dt)
	turGame.update(dt)
	TEsound.cleanup()  --Important, Clears all the channels in TEsound
end

function love.draw()
	W.setTitle("FPS: " .. love.timer.getFPS())
	if(currentgamestate==0) then --render main menu only
		gui.drawMainMenu()
	elseif(currentgamestate==1) then --render game only
		turGame.draw()
	end
	--love.changegamestate(1)
	--currentgamestate =1 -- quick workaround, will be removed once the mouse buttons work correctly
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