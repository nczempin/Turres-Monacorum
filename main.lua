require "world"
require "game"
require "map"
require "towerType"
require "sound"
require "util"

require "gameoverlayer"
require "hudLayer"

require "libraries/gui"

require "external/postshader"
require "external/light"
require "external/anim"
require "external/TESound"

function love.load()
	G = love.graphics
	W = love.window
	T = love.turris
	S = love.sounds

	currentgamestate = 0  -- 0=GameOver 1=gameonly 4= game+gameover message
	love.turris.reinit()
	gameOverLayer = love.turris.newGameOverLayer()
	hudLayer = love.turris.newHudLayer()

	stateMainMenu = require("state/main_menu")
	stateCredits = require("state/credits")

	bloomOn = true
end

function love.getgamestate()
	return currentgamestate
end

function love.turris.reinit()
	-- create game world
	turGame = love.turris.newGame()
	turMap = love.turris.newMap(20, 20, 64, 48)
	turGame.init()
end

function love.setgamestate(newgamestate)
	if newgamestate == 0 then
		stateMainMenu.effectTimer = 0
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
		gameOverEffect = gameOverEffect + dt
		stateMainMenu.update(dt)
	elseif (currentgamestate == 1)then
		turGame.update(dt)
	elseif (currentgamestate == 4)then
		gameOverEffect = gameOverEffect + dt
	elseif (currentgamestate == 5)then
		stateCredits.update(dt)
	end
	TEsound.cleanup()  --Important, Clears all the channels in TEsound
end

function love.draw()
	W.setTitle("FPS: " .. love.timer.getFPS())
	love.postshader.setBuffer("render")
	G.setColor(0, 0, 0)
	G.rectangle("fill", 0, 0, W.getWidth(), W.getHeight())

	if(currentgamestate == 0) then --render main menu only
		--turGame.draw()
		stateMainMenu.draw()

		if math.random(0, love.timer.getFPS() * 5) == 0 then
			gameOverEffect = 0
		end
		if gameOverEffect < 0.75 then
			local colorAberration1 = math.sin(love.timer.getTime() * 10.0) * (0.75 - gameOverEffect) * 2.0
			local colorAberration2 = math.cos(love.timer.getTime() * 10.0) * (0.75 - gameOverEffect) * 2.0

			love.postshader.addEffect("chromatic", colorAberration1, colorAberration2, colorAberration2, -colorAberration1, colorAberration1, -colorAberration2)
		end
		love.postshader.addEffect("scanlines", 4.0)
	elseif(currentgamestate == 1) then --render game only
		turGame.draw()
		--gui.drawOverlay()
		love.postshader.addEffect("scanlines")
		hudLayer.draw(turGame.energy)
	elseif(currentgamestate == 4) then -- render game + "game over" message on top
		turGame.draw()
		if gameOverEffect < 1.0 then
			local colorAberration1 = math.sin(love.timer.getTime() * 20.0) * (1.0 - gameOverEffect) * 4.0
			local colorAberration2 = math.cos(love.timer.getTime() * 20.0) * (1.0 - gameOverEffect) * 4.0

			love.postshader.addEffect("blur", 2.0, 2.0)
			love.postshader.addEffect("chromatic", colorAberration1, colorAberration2, colorAberration2, -colorAberration1, colorAberration1, -colorAberration2)
			love.postshader.addEffect("scanlines")
		else
			love.postshader.addEffect("monochrom", 127, 255, 191, 0.2)
			gameOverLayer.draw()
			love.postshader.addEffect("scanlines", 4.0)
		end
	elseif currentgamestate == 5 then --credits screen
		stateCredits.draw()
		love.postshader.addEffect("scanlines", 4.0)
	end
	if bloomOn then
		love.postshader.addEffect("bloom")
	end
	love.postshader.draw()
end

function love.turris.gameoverstate()
	love.setgamestate(0)
	love.turris.reinit()
end

function love.keypressed(key, code)
	if key == "b" then
		bloomOn = not bloomOn
	end

	if key == "escape" then
		if love.getgamestate()==1 then
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