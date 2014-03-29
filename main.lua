require "postshader"
require "light"
require "sound"
require "TESound"

function love.load()

end

function love.update(dt)
	TEsound.cleanup()  --Important, Clears all the channels in TEsound
end

function love.draw()

end

function love.mousepressed(x, y, key)
	
end

function love.keypressed(key, code)
	
	--Start Sound
	if key == "1" then
		love.sounds.addSound("sounds/Explosion.wav")
	end
	
	if key == "2" then
		love.sounds.background("sounds/Explosion.wav")
	end
end