function love.turris.newHudLayer(player)
	local o = {}

	o.iconMass = G.newImage("gfx/hud/mass_icon.png")
	o.iconEnergy = G.newImage("gfx/hud/energy_icon.png")
	o.iconTower1 = G.newImage("gfx/hud/button_tower00.png")
	o.iconTower2 = G.newImage("gfx/hud/button_tower01.png")
	o.iconTower3 = G.newImage("gfx/hud/button_tower02.png")

	o.guiGame = love.gui.newGui()
	o.btnTower1 = o.guiGame.newImageRadioButton(208 * 0 + 16, W.getHeight() - 80, 192, 64, o.iconTower1)
	o.btnTower2 = o.guiGame.newImageRadioButton(208 * 1 + 16, W.getHeight() - 80, 192, 64, o.iconTower2)
	o.btnTower3 = o.guiGame.newImageRadioButton(208 * 2 + 16, W.getHeight() - 80, 192, 64, o.iconTower3)

	o.btnTower1.setFontSize(16)
	o.btnTower1.setText("Laser Tower [1]")
	o.btnTower1.setTextPosition(32, -32)
	o.btnTower1.setChecked(true)

	o.btnTower2.setFontSize(16)
	o.btnTower2.setText("Energy Tower [2]")
	o.btnTower2.setTextPosition(32, -32)

	o.btnTower3.setFontSize(16)
	o.btnTower3.setText("Mass Tower [4]")
	o.btnTower3.setTextPosition(32, -32)

	o.btnTower1.setColorNormal(0, 127, 255, 63)
	o.btnTower2.setColorNormal(255, 127, 0, 63)
	o.btnTower3.setColorNormal(0, 255, 127, 63)

	o.btnTower1.setColorHover(0, 127, 255, 255)
	o.btnTower2.setColorHover(255, 127, 0, 255)
	o.btnTower3.setColorHover(0, 255, 127, 255)

	o.player = player

	o.update = function(dt)
		o.guiGame.update(dt)
	end

	o.draw = function()
		local mass = o.player.mass
		local energy = o.player.energy

		G.setBlendMode("alpha")
		G.setLineWidth(4)
		if not lightWorld.optionGlow then
			G.setColor(0, 0, 0, 91)
			G.rectangle("line", W.getWidth() - 352, 16, 160, 36)
			G.printf(math.floor(mass), W.getWidth() - 352 + 2, 16 + 2, 128, "right")
			G.draw(o.iconMass, W.getWidth() - 208 + 2, 34 + 2, love.timer.getTime() * 0.5, 1, 1, 8, 8)

			G.rectangle("line", W.getWidth() - 176, 16, 160, 36)
			G.printf(math.floor(energy), W.getWidth() - 176 + 2, 16 + 2, 128, "right")
			G.setColor(0, 0, 0, 91 + math.sin(love.timer.getTime() * 5.0) * 63)
			G.draw(o.iconEnergy, W.getWidth() - 40 + 2, 16 + 2)

			--G.setColor(0, 0, 0, 91)
			--G.draw(o.iconTower1, W.getWidth() - o.iconTower1:getWidth() * 1.85 - 16 + 2, W.getHeight() - o.iconTower1:getHeight() * 2.0 - 16 + 2)
			--G.draw(o.iconTower2, W.getWidth() - o.iconTower2:getWidth() * 2.70 - 16 + 2, W.getHeight() - o.iconTower2:getHeight() * 1.5 - 16 + 2)
			--G.draw(o.iconTower3, W.getWidth() - o.iconTower3:getWidth() * 1.85 - 16 + 2, W.getHeight() - o.iconTower3:getHeight() * 1.0 - 16 + 2)
			--G.draw(o.iconTower1, W.getWidth() - o.iconTower1:getWidth() * 1.00 - 16 + 2, W.getHeight() - o.iconTower1:getHeight() * 1.5 - 16 + 2)
			--G.setBlendMode("additive")
		end

		G.setLineWidth(2)
		G.setColor(0, 127, 255)
		G.rectangle("line", W.getWidth() - 352, 16, 160, 36)
		G.setColor(0, 127, 255, 15)
		G.rectangle("fill", W.getWidth() - 352, 16, 160, 36)
		G.setColor(0, 127, 255, 255)
		G.printf(math.floor(mass), W.getWidth() - 352, 16, 128, "right")
		G.draw(o.iconMass, W.getWidth() - 208, 34, love.timer.getTime() * 0.5, 1, 1, 8, 8)

		G.setColor(255, 127, 0)
		G.rectangle("line", W.getWidth() - 176, 16, 160, 36)
		G.setColor(255, 127, 0, 15)
		G.rectangle("fill", W.getWidth() - 176, 16, 160, 36)
		G.setColor(255, 127, 0, 255)
		G.printf(math.floor(energy), W.getWidth() - 176, 16, 128, "right")
		G.setColor(255, 127, 0, 191 + math.sin(love.timer.getTime() * 5.0) * 63)
		G.draw(o.iconEnergy, W.getWidth() - 40, 16)

		--G.setBlendMode("alpha")
		--G.setColor(255, 63, 0, 223 + math.sin(love.timer.getTime() * 5.0 + 1.0) * 31)
		--G.draw(o.iconTower1, W.getWidth() - o.iconTower1:getWidth() * 1.85 - 16, W.getHeight() - o.iconTower1:getHeight() * 2.0 - 16)
		--G.setColor(255, 127, 0, 223 + math.sin(love.timer.getTime() * 5.0 + 2.0) * 31)
		--G.draw(o.iconTower2, W.getWidth() - o.iconTower2:getWidth() * 2.70 - 16, W.getHeight() - o.iconTower2:getHeight() * 1.5 - 16)
		--G.setColor(0, 127, 255, 223 + math.sin(love.timer.getTime() * 5.0 + 3.0) * 31)
		--G.draw(o.iconTower3, W.getWidth() - o.iconTower3:getWidth() * 1.85 - 16, W.getHeight() - o.iconTower3:getHeight() * 1.0 - 16)
		--G.setColor(127, 255, 0, 223 + math.sin(love.timer.getTime() * 5.0 + 4.0) * 31)
		--G.draw(o.iconTower1, W.getWidth() - o.iconTower1:getWidth() * 1.00 - 16, W.getHeight() - o.iconTower1:getHeight() * 1.5 - 16)

		o.guiGame.draw()

		G.setColor(0, 127, 255, 127)
		G.print("Cost: 10 Mass", 208 * 0 + 88, W.getHeight() - 68)
		G.print("Shoot laser!", 208 * 0 + 88, W.getHeight() - 44)

		G.setColor(255, 127, 0, 127)
		G.print("Cost: 20 Mass", 208 * 1 + 88, W.getHeight() - 68)
		G.print("Give energy", 208 * 1 + 88, W.getHeight() - 44)

		G.setColor(0, 255, 127, 127)
		G.print("Cost: 50 Mass", 208 * 2 + 88, W.getHeight() - 68)
		G.print("Extract Mass", 208 * 2 + 88, W.getHeight() - 44)
	end

	return o

end