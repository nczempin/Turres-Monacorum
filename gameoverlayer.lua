
function love.turris.newGameOverLayer()
	local o = {}
	
	o.draw = function()
		G.setColor(0, 255, 0, 255)
    G.print("Game Over.", 10, 200)
	G.print("Click to go to the main menu",10,230)
	love.setgamestate(4)
	end
	
	return o
end

