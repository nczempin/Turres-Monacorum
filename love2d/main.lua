require "libraries/gui"

require "external/TSerial"
require "external/postshader"
require "external/light"
require "external/ai"

require "external/anim"
require "external/TEsound"

require "world"
require "game"
require "map"
require "spawn"
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
		local f1 = function(setting)
			local param = string.find(setting, "true")
			stateSettingsVideoDisplay.optionFullscreen = param
			stateSettingsVideoDisplay.chkFullscreen.checked = param --TODO: this should be done inside the settings page
		end
		local f2= function(setting)
			stateSettingsVideoDisplay.optionLarge=setting --TODO this needs to be sanitized
			stateSettingsVideoDisplay.comboLarge.updateSelection(setting)
		end
		local options = {{name="display.video.fullscreen", execute= f1},{name="display.video.resolution",execute = f2}}
		local optionLines = {}
		local lines = {}

		for line in love.filesystem.lines(optionsIni) do
			table.insert(lines, line)
		end

		for i,line in ipairs(lines)do
			for j,option in ipairs(options) do
				local m1, m2 = string.find(line, option.name.."=")
				print (i, m1,m2)
				if m2 then

					local setting = string.sub(line, m2+1)
					--TODO: can/should we change the options in conf.lua from here?
					option.execute(setting)
					--stateSettingsVideoDisplay.optionLarge = stateSettingsVideoDisplay.resolutionStrings[2] --TODO: this should really be handled inside the display settings module
					--	stateSettingsVideoDisplay.optionLarge =  stateSettingsVideoDisplay.resolutionStrings[3]--TODO: this should really be handled inside the display settings module
				end
			end
		end
	end
	print ("possibly changing resolution/fullscreen")
	stateSettingsVideoDisplay.checkOptionsLarge() --TODO: provide a function that changes the option and immediately switches
end

function saveOptions()
	local optionsIni = "options.ini"

	local data = "Hello, world"

	local success = love.filesystem.write( optionsIni, data )
	print ("success: ", success)
	print (love.filesystem.getSaveDirectory())
	print (love.filesystem.getUserDirectory())
	print (love.filesystem.getWorkingDirectory())
	--FIXME: this is just code copied from loadOptions()
	local option = "display.large"
	local optionLines = {}
	local lines = {}

	--	for line in love.filesystem.lines(optionsIni) do
	--		table.insert(lines, line)
	--	end
	--
	--	for i,line in ipairs(lines)do
	--		local m1, m2 = string.find(line, option.."=")
	--		print (i, m1,m2)
	--		if m2 then
	--
	--			local setting = string.sub(line, m2+1)
	--			--TODO: can/should we change the options in conf.lua from here?
	--			if string.find(setting, "true")then
	--				print "large"
	--				stateSettingsVideoDisplay.optionLarge = stateSettingsVideoDisplay.resolutionStrings[2] --TODO: this should really be handled inside the display settings module
	--			else
	--				print "not large"
	--				stateSettingsVideoDisplay.optionLarge =  stateSettingsVideoDisplay.resolutionStrings[3]--TODO: this should really be handled inside the display settings module
	--			end
	--			stateSettingsVideoDisplay.checkOptionsLarge() --TODO: provide a function that changes the option and immediately switches
	--		end
	--
	--	end
end

function love.load()
	G = love.graphics
	W = love.window
	T = love.turris
	S = love.sounds
	FS = love.filesystem
	loadOptions()
	--saveOptions() --TODO temporarily added for testing
	FONT = G.newFont(32)
	FONT_SMALL = G.newFont(24)

	currentgamestate = 12 -- TODO: make "skip intro" an option

	stateMainMenu.setVersion("v0.6.2")
end

function love.getgamestate()
	return currentgamestate
end

function love.turris.reinit(map)
	-- create game world
	lightWorld.clearBodys()
	lightWorld.clearLights()

	-- create light
	lightMouse = lightWorld.newLight(0, 0, 31, 191, 63, 300)
	lightMouse.setRange(300)

	love.turris.selectedtower = 1
	turGame = love.turris.newGame()
	turMap = love.turris.newMap(map)
	turGame.init()
	turGame.mission = map
end

function love.setgamestate(newgamestate, option)
	love.sounds.stopSound("all")
	if newgamestate == 0 then
		stateMainMenu.effectTimer = 0
		love.sounds.playBackground("sounds/music/Chiptune_2step_mp3.mp3", "menu")
	elseif newgamestate == 1 then
		love.turris.reinit(option)
		turGame.layerGameOver.effectTimer = 0
		love.sounds.playBackground("sounds/music/turres_music_1.mp3", "menu")
	elseif newgamestate == 4 or newgamestate == 13 then
		turGame.layerGameOver.effectTimer = 0
		love.sounds.playBackground("sounds/music/game_over_music.mp3", "game")
	elseif newgamestate == 11 then
		stateWorldMenu.init()
	end

	if currentgamestate == 5 then
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
	elseif (currentgamestate == 13)then
		turGame.layerWin.update(dt)
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
	elseif currentgamestate == 13 then --intro
		turGame.draw()
		turGame.layerWin.draw()
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
	love.setgamestate(11)
	--stateMainMenu.reset()
end

function love.keypressed(key, code)
	if key == "escape" then
		if currentgamestate == 1 then
			love.sounds.playSound("sounds/button_pressed.wav")
			love.setgamestate(11)
		elseif currentgamestate == 11 then
			love.sounds.playSound("sounds/button_pressed.wav")
			love.setgamestate(0)
		end
	end
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