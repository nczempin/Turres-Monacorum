LOVE_SOUND_BGMUSICVOLUME 	= 0.5
LOVE_SOUND_SOUNDVOLUME		= 0.5

love.sounds = {}
love.sounds.files = {}

love.sounds.files.shootElectric = ""
love.sounds.files.shootRocket 	= ""
love.sounds.files.putTower		= "sounds.tower_2.mp3"
love.sounds.files.removeTower	= ""

love.sounds.files.spawnCreature = ""

love.sounds.files.buttonPressed = "sounds/button_Pressed.mp3"
love.sounds.files.buttonHover 	= ""

love.sounds.files.highscore 	= "sounds/music/highscore.mp3"
love.sounds.files.mainMenu 		= "sounds/music/mainMenu.mp3"
love.sounds.files.gameOver		= "sounds/music/game_over_music.mp3"
love.sounds.files.gameBackground= "sounds/music/gameBackground"

	
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





