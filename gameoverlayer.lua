
function love.turris.newGameOverLayer()
	local o = {}
	
	o.draw = function()
		G.setColor(0, 255, 0, 255)
    G.print("Game Over.", 10, 200)
	end
	
	return o
end

