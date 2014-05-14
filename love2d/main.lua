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

require "settings"

require "util"

-- states
stateMainMenu = require("state/main_menu")
stateIntro = require("state/intro")
stateOutro = require("state/outro")
stateWorldMenu = require("state/world_menu")
stateCredits = require("state/credits")
stateSettings = require("state/settings_menu")
stateSettingsVideo = require("state/settings_video")
stateSettingsVideoShaders = require("state/settings_video_shaders")
stateSettingsVideoDisplay = require("state/settings_video_display")
stateSettingsAudio = require("state/settings_audio")

function love.filesystem.rename(from, to)
	assert(type(from) == "string", "bad argument #1 to rename (string expected, got "..type(from)..")")
	assert(type(to) == "string", "bad argument #2 to rename (string expected, got "..type(to)..")")

	local writeDir = love.filesystem.getSaveDirectory().."/"

	if not os.rename(writeDir..from, writeDir..to) then
		return false
	end

	return true
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
	FONT_LARGE = G.newFont(64)
	FONT_SMALL = G.newFont(24)

	currentgamestate = 12 -- TODO: make "skip intro" an option

	stateMainMenu.setVersion("v0.6.4")
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
		turGame.layerGameOver.effectTimer = 0
		love.sounds.playBackground("sounds/music/turres_music_1.mp3", "menu")
		love.sounds.loopSound("sounds/weapons/laser_loop.ogg")
		love.sounds.setSoundVolume(0,"sounds/weapons/laser_loop.ogg")

	elseif newgamestate == 4 then
		turGame.layerGameOver.effectTimer = 0
		love.sounds.playBackground("sounds/music/game_over_music.mp3", "game")
	elseif  newgamestate == 13 then
		turGame.layerGameOver.effectTimer = 0
		love.sounds.playBackground("sounds/music/level_up.mp3", "game")
	elseif newgamestate == 11 then
		stateWorldMenu.init()
	elseif newgamestate == 14 then
		turGame.layerCountdown.init()
	elseif newgamestate == 16 then
		love.turris.reinit(option)
		turGame.layerMissionBriefing.init("lorem ipsum dolor sit amet") -- --TODO: this should be retrieved from the level/wave
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
	elseif (currentgamestate == 14)then
		turGame.layerCountdown.update(dt)
	elseif (currentgamestate == 15)then
		stateOutro.update(dt)
	elseif (currentgamestate == 16)then
		turGame.layerMissionBriefing.update(dt)
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
	elseif currentgamestate == 13 then --winning
		turGame.draw()
		turGame.layerWin.draw()
	elseif currentgamestate == 14 then --countdown
		turGame.draw()
		turGame.layerCountdown.draw()
	elseif currentgamestate == 15 then --outro
		stateOutro.draw()
	elseif (currentgamestate == 16)then
		turGame.draw()
		turGame.layerMissionBriefing.draw()
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
		--	elseif key == "f1" then
		--		saveOptions()
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