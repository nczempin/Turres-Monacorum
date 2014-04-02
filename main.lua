require "libraries/gui"

require "external/postshader"
require "external/light"

require "external/anim"
require "external/TEsound"

require "world"
require "game"
require "map"
require "towerType"
require "sound"

require "util"

function love.load()
	G = love.graphics
	W = love.window
	T = love.turris
	S = love.sounds

	FONT = G.newFont(32)

	currentgamestate = 0  -- 0=Main Menu 1=gameonly 4= game+gameover message
	love.turris.reinit()

	stateMainMenu = require("state/main_menu")
	stateCredits = require("state/credits")
	stateSettings = require("state/settings")

	stateMainMenu.setVersion("0.4.1")
end

function love.getgamestate()
	return currentgamestate
end

function love.turris.reinit()
	-- create game world
	lightWorld.clearBodys()
	turGame = love.turris.newGame()
	turMap = love.turris.newMap(20, 20, 64, 48)
	turGame.init()
end

function love.setgamestate(newgamestate)
	if newgamestate == 0 then
		stateMainMenu.effectTimer = 0
	elseif newgamestate == 1 then
		turGame.layerGameOver.effectTimer = 0
	end

	if currentgamestate == 5 then
		love.sounds.stopSound("gameover")
	elseif newgamestate == 5 then
		love.sounds.playBackground("sounds/music/highscore.mp3", "gameover")
	end

	currentgamestate = newgamestate
end

function love.update(dt)
	if (currentgamestate == 0)then
		stateMainMenu.update(dt)
	elseif (currentgamestate == 1)then
		turGame.update(dt)
	elseif (currentgamestate == 4)then
		turGame.layerGameOver.update(dt)
	elseif (currentgamestate == 5)then
		stateCredits.update(dt)
	elseif (currentgamestate == 6)then
		stateSettings.update(dt)
	end
	TEsound.cleanup()  --Important, Clears all the channels in TEsound
end

function love.draw()
	local scanlineStrength = 4.0

	G.setFont(FONT) --TODO: this only needs to be done whenever the font changes, not every frame
	W.setTitle("FPS: " .. love.timer.getFPS())
	love.postshader.setBuffer("render")
	G.setColor(0, 0, 0)
	G.rectangle("fill", 0, 0, W.getWidth(), W.getHeight())

	if(currentgamestate == 0) then --render main menu only
		stateMainMenu.draw()
	elseif(currentgamestate == 1) then --render game only
		turGame.draw()
		scanlineStrength = 2.0
	elseif(currentgamestate == 4) then -- render game + "game over" message on top
		turGame.draw()
		turGame.layerGameOver.draw()
	elseif currentgamestate == 5 then --credits screen
		stateCredits.draw()
	elseif currentgamestate == 6 then --settings screen
		stateSettings.draw()
	end

	if stateSettings.optionScanlines then
		love.postshader.addEffect("scanlines", scanlineStrength)
	end

	if stateSettings.optionBloom then
		love.postshader.addEffect("bloom")
	end

	love.postshader.draw()
end

function love.turris.gameoverstate()
	love.setgamestate(0)
	love.turris.reinit()
	stateMainMenu.reset()
end

function love.keypressed(key, code)

	if key == "escape" then
		if love.getgamestate() == 1 then
			love.setgamestate(0)
			love.turris.reinit()
		end
	end
end

function love.mousepressed(x, y, key)
	if(key=="l") then
		buttonDetected = 1
		love.turris.checkleftclick(x,y)
	end
	if(key=="m") then
		buttonDetected = 3
	end
	if(key=="r") then
		buttonDetected = 2
		love.turris.checkrightclick(x,y)
	end
end

function love.mousereleased(x, y, key)
	buttonDetected = 0
end