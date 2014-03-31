function love.turris.drawCredits()
	local names = {"Aldo Brießmann", "Elena Reinertz", "Marcus Ihde","Meral Leyla", "Nicolai Czempin","Robin Kocaurek",   "nonamedreamz"}
	for i= 1, #names do
		local r = math.random(0,255)
		local g = math.random(0,255)
		local b = math.random(0,255)
		local x = 200
		local y = 10+i*30
		love.graphics.setColor(r, g, b, 255)
		love.graphics.print(names[i], x, y)
	end
end