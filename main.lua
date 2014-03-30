require "postshader"
require "light"
require "world"
require "game"
require "map"
require "towerType"
require "sound"
require "TESound"
require "gui"
require "gameoverlayer"
require "anim"

function love.load()
	G = love.graphics
	W = love.window
	T = love.turris
	S = love.sounds
	currentgamestate = 0
	-- create game world
	turGame = love.turris.newGame()
	turMap = love.turris.newMap(13, 13, 64, 48)
	turGame.init()
	gameOverLayer = love.turris.newGameOverLayer()
	createButtons()

	bloomOn = true
end
function love.getgamestate()
	return currentgamestate
end


function love.turris.reinit()
	turGame = love.turris.newGame()
	turMap = love.turris.newMap(13, 13, 64, 48)
	turGame.init()
end

function love.setgamestate(newgamestate)
	currentgamestate = newgamestate
end

function love.update(dt)
	if (currentgamestate == 1)then
		turGame.update(dt)
	elseif (currentgamestate == 4)then
		gameOverEffect = gameOverEffect + dt
	end
	TEsound.cleanup()  --Important, Clears all the channels in TEsound
end

function love.draw()
	W.setTitle("FPS: " .. love.timer.getFPS())
	love.postshader.setBuffer("render")
	G.setColor(0, 0, 0)
	G.rectangle("fill", 0, 0, W.getWidth(), W.getHeight())

	turGame.draw()

	if(currentgamestate == 0) then --render main menu only
		love.postshader.addEffect("blur", 2.0)
		gui.drawMainMenu()
		love.postshader.addEffect("scanlines")
	elseif(currentgamestate==1) then --render game only
		turGame.draw()
	elseif(currentgamestate == 4) then -- render game + "game over" message on top
		turGame.draw()
		gameOverLayer.draw()
		if gameOverEffect < 0.75 then
			local colorAberration1 = math.sin(love.timer.getTime() * 20.0) * (0.75 - gameOverEffect) * 4.0
			local colorAberration2 = math.cos(love.timer.getTime() * 20.0) * (0.75 - gameOverEffect) * 4.0

			love.postshader.addEffect("blur", 1.0, 1.0)
			love.postshader.addEffect("chromatic", colorAberration1, colorAberration2, colorAberration2, -colorAberration1, colorAberration1, -colorAberration2)
		end
	end
	--currentgamestate =1 -- quick workaround, will be removed once the mouse buttons work correctly
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
		buttonDetected = 1
		if not(love.getgamestate()==0) then
			love.setgamestate(0)
			love.turris.reinit()
		end
		love.turris.checkButtonPosition(320, 96)
	end
end