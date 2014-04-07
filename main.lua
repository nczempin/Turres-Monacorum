require "libraries/gui"

require "external/postshader"
require "external/light"
require "external/ai"

require "external/anim"
require "external/TEsound"

require "world"
require "game"
require "map"
require "towerType"
require "sound"

require "util"

-- states
stateMainMenu = require("state/main_menu")
stateIntro = require("state/intro")
stateWorldMenu = require("state/world_menu")
stateCredits = require("state/credits")
stateSettings = require("state/settings")
stateSettingsVideo = require("state/settings_video")
stateSettingsVideoShaders = require("state/settings_video_shaders")
stateSettingsVideoDisplay = require("state/settings_video_display")
stateSettingsAudio = require("state/settings_audio")

function loadOptions()
	local optionsIni = "options.ini"

	if (FS.exists(optionsIni))then
		local option = "display.large"
		local optionLines = {}
		local lines = {}

		for line in love.filesystem.lines(optionsIni) do
			table.insert(lines, line)
		end

		for i,line in ipairs(lines)do
			local m1, m2 = string.find(line, option.."=")
			print (i, m1,m2)
			if m2 then
				local setting = string.sub(line, m2+1)
				if string.find(setting, "true")then
					stateSettingsVideoDisplay.optionLarge = true --TODO: can/should we change the options in conf.lua from here?
				else
					stateSettingsVideoDisplay.optionLarge = false
				end
				stateSettingsVideoDisplay.checkOptionsLarge() --TODO: provide a function that changes the option and immediately switches
			end
		end
	end
end

function love.load()
	G = love.graphics
	W = love.window
	T = love.turris
	S = love.sounds
	FS = love.filesystem
	loadOptions()
	FONT = G.newFont(32)

	currentgamestate = 12  -- TODO: make "skip intro" an option
	love.turris.reinit()

	stateMainMenu.setVersion("v0.6.1")
end

function love.getgamestate()
	return currentgamestate
end

function love.turris.reinit()
	-- create game world
	lightWorld.clearBodys()
	lightWorld.clearLights()

	-- create light
	lightMouse = lightWorld.newLight(0, 0, 31, 191, 63, 300)
	lightMouse.setRange(300)

	love.turris.selectedtower = 1
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
	elseif (currentgamestate == 7)then
		stateSettingsVideo.update(dt)
	elseif (currentgamestate == 8)then
		stateSettingsVideoShaders.update(dt)
	elseif (currentgamestate == 9)then
		stateSettingsVideoDisplay.update(dt)
	elseif (currentgamestate == 10)then
		stateSettingsAudio.update(dt)
	elseif (currentgamestate == 11)then
		stateWorldMenu.update(dt)
	elseif (currentgamestate == 12)then
		stateIntro.update(dt)
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
	elseif currentgamestate == 7 then --settings screen
		stateSettingsVideo.draw()
	elseif currentgamestate == 8 then --settings screen
		stateSettingsVideoShaders.draw()
	elseif currentgamestate == 9 then --settings screen
		stateSettingsVideoDisplay.draw()
	elseif currentgamestate == 10 then --settings audio
		stateSettingsAudio.draw()
	elseif currentgamestate == 11 then --settings world
		stateWorldMenu.draw()
	elseif currentgamestate == 12 then --intro
		stateIntro.draw()
	end

	if stateSettingsVideoShaders.optionScanlines then
		love.postshader.addEffect("scanlines", scanlineStrength)
	end

	if stateSettingsVideoShaders.optionBloom then
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

end

function love.mousepressed(x, y, key)
	if(key == "l") then
		buttonDetected = 1
		love.turris.checkleftclick(x,y)
	end
	if(key == "m") then
		buttonDetected = 3
	end
	if(key == "r") then
		buttonDetected = 2
		love.turris.checkrightclick(x,y)
	end
end

function love.mousereleased(x, y, key)
	buttonDetected = 0
end