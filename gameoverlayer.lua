function love.turris.newGameOverLayer()
	local o = {}
	local gameOverMessageFont = G.newFont(32)

	o.draw = function()
		G.setFont(gameOverMessageFont)
		G.setColor(255, 0, 0, 127)
		G.printf("Game Over!", 0, 240, W.getWidth(), "center")
		G.setColor(255, 255, 255, 127)
		G.printf("Click to go to the main menu", 0, 320, W.getWidth(), "center")
		love.setgamestate(4)
	end

	return o
end