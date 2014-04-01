function love.turris.newHudLayer(player)
	local o = {}

	o.iconMass = G.newImage("gfx/mass_icon.png")
	o.iconEnergy = G.newImage("gfx/energy_icon.png")
	o.iconTower1 = G.newImage("gfx/button_tower00.png")
	o.iconTower2 = G.newImage("gfx/button_tower01.png")
	o.iconTower3 = G.newImage("gfx/button_tower02.png")

	o.player = player

	o.draw = function()
		local mass = o.player.mass
		local energy = o.player.energy
		G.setBlendMode("additive")
		G.setColor(0, 127, 255, 255)
		--G.rectangle("fill", 0, G.getHeight() - 64, G.getWidth(), 64)

		G.printf(math.floor(mass), W.getWidth() - 352, 16, 128, "right")
		G.draw(o.iconMass, W.getWidth() - 208, 34, love.timer.getTime() * 0.5, 1, 1, 8, 8)
		G.setColor(255, 127, 0, 255)
		G.printf(math.floor(energy), W.getWidth() - 176, 16, 128, "right")
		G.setColor(255, 127, 0, 191 + math.sin(love.timer.getTime() * 5.0) * 63)
		G.draw(o.iconEnergy, W.getWidth() - 40, 16)

		--G.setBlendMode("alpha")
		--G.draw(o.iconTower1, W.getWidth() / 4 * 1 - o.iconTower1:getWidth() * 0.5, W.getHeight() - 96 - 16)
		--G.draw(o.iconTower2, W.getWidth() / 4 * 2 - o.iconTower2:getWidth() * 0.5, W.getHeight() - 96 - 16)
		--G.draw(o.iconTower3, W.getWidth() / 4 * 3 - o.iconTower3:getWidth() * 0.5, W.getHeight() - 96 - 16)
		G.setColor(255, 63, 0, 223 + math.sin(love.timer.getTime() * 5.0 + 1.0) * 31)
		G.draw(o.iconTower1, W.getWidth() - o.iconTower1:getWidth() * 1.85 - 16, W.getHeight() - o.iconTower1:getHeight() * 2.0 - 16)
		G.setColor(255, 127, 0, 223 + math.sin(love.timer.getTime() * 5.0 + 2.0) * 31)
		G.draw(o.iconTower2, W.getWidth() - o.iconTower2:getWidth() * 2.70 - 16, W.getHeight() - o.iconTower2:getHeight() * 1.5 - 16)
		G.setColor(0, 127, 255, 223 + math.sin(love.timer.getTime() * 5.0 + 3.0) * 31)
		G.draw(o.iconTower3, W.getWidth() - o.iconTower3:getWidth() * 1.85 - 16, W.getHeight() - o.iconTower3:getHeight() * 1.0 - 16)
		G.setColor(127, 255, 0, 223 + math.sin(love.timer.getTime() * 5.0 + 4.0) * 31)
		G.draw(o.iconTower1, W.getWidth() - o.iconTower1:getWidth() * 1.00 - 16, W.getHeight() - o.iconTower1:getHeight() * 1.5 - 16)
	end

	return o

end