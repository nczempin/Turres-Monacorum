LOVE_SOUND_BGMUSICVOLUME 	= 0.5
LOVE_SOUND_SOUNDVOLLUME		= 0.8

love.sounds = {}


	
--Functions for playing sounds

--Play a Sound from


-- Adds an BackgroundMusic
function love.sounds.background(backgroundFile)
	TEsound.playLooping(backgroundFile,"background",nil,LOVE_SOUND_BGMUSICVOLUME)
end

-- Plays an Sound Once
-- @param Filepath to the Soundfile
function love.sounds.playSound(soundPath)
	TEsound.play(soundPath,"sound",LOVE_SOUND_SOUNDVOLLUME,nil,nil)
end


--Sets the Background Volume
--@param volume from 0 to 1
function setBackgroundVolume(volume)
{
	TEsound.volume("background", volume)
}
