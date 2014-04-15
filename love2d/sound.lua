LOVE_SOUND_BGMUSICVOLUME 	= 0.5
LOVE_SOUND_SOUNDVOLUME		= 0.5

love.sounds = {}

soundNames = {};

soundNames.placingTower = "placingTower"


local startTime = 0
	
--Functions for playing sounds
-- Adds an BackgroundMusic
-- @param filepath to BackgroundMusicFile
function love.sounds.playBackground(backgroundFile,name)
	TEsound.stop(name,false) --Stopping old BackgroundMusic
	TEsound.playLooping(backgroundFile,name,nil,LOVE_SOUND_BGMUSICVOLUME)
end

--Stops the Backgroundmusic
function love.sounds.stopSound(name)
	TEsound.stop(name,false)
end

-- Plays an Sound Once
-- @param Filepath to the Soundfile
-- @param  Time to Wait to Play the Sound in Milliseconds
function love.sounds.playSound(soundPath, timeInMilliSeconds)
	if timeInMilliSeconds ~= nil then
		startTime = love.timer.getTime()
	else
		TEsound.play(soundPath,"sound",LOVE_SOUND_SOUNDVOLUME,nil,nil)
	end
end

--Sets the Background Volume
--@param volume from 0 to 1
function love.sounds.setBackgroundVolume(volume)
	LOVE_SOUND_BGMUSICVOLUME = volume
	TEsound.volume("background", volume)
end


--Sets the Volume for sounds
function love.sounds.setSoundVolume(volume)
	LOVE_SOUND_SOUNDVOLUME	= volume
	TEsound.volume("sound", volume)
end

--Sets the Backgroundmsuic Volume
function love.sounds.setBackgroundVolume(volume)
	LOVE_SOUND_BGMUSICVOLUME = volume
	TEsound.volume("background", volume)
end





