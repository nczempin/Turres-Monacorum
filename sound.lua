LOVE_SOUND_BGMUSICVOLUME 	= 0.5
LOVE_SOUND_SOUNDVOLLUME		= 0.1

love.sounds = {}


	
--Functions for playing sounds


-- Adds an BackgroundMusic
-- @param filepath to BackgroundMusicFile
function love.sounds.playBackground(backgroundFile)
	TEsound.stop("background",false) --Stopping old BackgroundMusic
	TEsound.playLooping(backgroundFile,"background",nil,LOVE_SOUND_BGMUSICVOLUME)
end

--Stops the Backgroundmusic
function love.sounds.stopBackground()
	TEsound.stop("background",false)
end

-- Plays an Sound Once
-- @param Filepath to the Soundfile
function love.sounds.playSound(soundPath)
	TEsound.play(soundPath,"sound",LOVE_SOUND_SOUNDVOLLUME,nil,nil)
end

--Sets the Background Volume
--@param volume from 0 to 1
function love.sounds.setBackgroundVolume(volume)
	LOVE_SOUND_BGMUSICVOLUME = volume
	TEsound.volume("background", volume)
end


--Sets the Volume for sounds
function love.sounds.setSoundVolume(volume)
	LOVE_SOUND_SOUNDVOLLUME	= volume
	TEsound.volume("sound", volume)
end

--Sets the Backgroundmsuic Volume
function love.sounds.setBackgroundVolume(volume)
	LOVE_SOUND_BGMUSICVOLUME = volume
	TEsound.volume("background", volume)
end





