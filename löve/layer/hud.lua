function love.turris.newHudLayer(player)
	local o = {}

	o.iconMass = G.newImage("gfx/hud/mass_icon.png")
	o.iconEnergy = G.newImage("gfx/hud/energy_icon.png")
	o.iconTower1 = G.newImage("gfx/hud/button_tower00.png")
	o.iconTower2 = G.newImage("gfx/hud/button_tower01.png")
	o.iconTower3 = G.newImage("gfx/hud/button_tower02.png")

	-- create gui elements
	o.guiGame = love.gui.newGui()
	o.btnTower1 = o.guiGame.newImageRadioButton(208 * 0 + 16, W.getHeight() - 75, 192, 57, o.iconTower1)
	o.btnTower2 = o.guiGame.newImageRadioButton(208 * 1 + 16, W.getHeight() - 75, 192, 57, o.iconTower2)
	o.btnTower3 = o.guiGame.newImageRadioButton(208 * 2 + 16, W.getHeight() - 75, 192, 57, o.iconTower3)

	-- config gui elements
	--o.btnTower1.setFontSize(16)
	--o.btnTower1.setText("Laser Tower (1)")
	o.btnTower1.setTextPosition(32, -32)
	o.btnTower1.setImagePosition(4, -11)
	o.btnTower1.setChecked(true)

	--o.btnTower2.setFontSize(16)
	--o.btnTower2.setText("Energy Tower (3)")
	o.btnTower2.setTextPosition(32, -32)
	o.btnTower2.setImagePosition(4, -13)

	--o.btnTower3.setFontSize(16)
	--o.btnTower3.setText("Mass Tower (4)")
	o.btnTower3.setTextPosition(32, -32)
	o.btnTower3.setImagePosition(4, -11)

	o.btnTower1.setColorNormal(0, 127, 255, 63)
	o.btnTower2.setColorNormal(255, 127, 0, 63)
	o.btnTower3.setColorNormal(0, 255, 127, 63)

	o.btnTower1.setColorHover(0, 127, 255, 255)
	o.btnTower2.setColorHover(255, 127, 0, 255)
	o.btnTower3.setColorHover(0, 255, 127, 255)

	-- set font
	o.fontTitle = G.newFont(24)
	o.fontDescription = G.newFont(16)

	o.player = player

	o.update = function(dt)
		o.guiGame.update(dt)

		if o.btnTower1.isHit() then
			love.turris.selectedtower = 1
		elseif o.btnTower2.isHit() then
			love.turris.selectedtower = 3
		elseif o.btnTower3.isHit() then
			love.turris.selectedtower = 4
		end

		if love.keyboard.isDown("escape") then
			love.setgamestate(0)
		elseif love.keyboard.isDown("1") then
			love.turris.selectedtower = 1
			o.btnTower1.setChecked(true)
		--elseif love.keyboard.isDown("2") then
			--love.turris.selectedtower = 2 --2 would be the main base which should not be available for manual building
			--o.guiGame.flushRadioButtons()
		elseif love.keyboard.isDown("2") then
			love.turris.selectedtower = 3
			o.btnTower2.setChecked(true)
		elseif love.keyboard.isDown("3") then
			love.turris.selectedtower = 4
			o.guiGame.flushRadioButtons()
			o.btnTower3.setChecked(true)
		--elseif love.keyboard.isDown("5") then
			--love.turris.selectedtower = 5
			--o.guiGame.flushRadioButtons()
		end
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
		end

		G.setFont(FONT)
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

		if o.btnTower1.isChecked() then
			G.setColor(0, 127, 255, 127)
		else
			G.setColor(0, 127, 255, 31)
		end
		G.rectangle("fill", 208 * 0 + 16, W.getHeight() - 108, 192, 28)
		if o.btnTower2.isChecked() then
			G.setColor(255, 127, 0, 127)
		else
			G.setColor(255, 127, 0, 31)
		end
		G.rectangle("fill", 208 * 1 + 16, W.getHeight() - 108, 192, 28)
		if o.btnTower3.isChecked() then
			G.setColor(0, 255, 127, 127)
		else
			G.setColor(0, 255, 127, 31)
		end
		G.rectangle("fill", 208 * 2 + 16, W.getHeight() - 108, 192, 28)

		G.setFont(o.fontTitle)
		G.setColor(0, 0, 0)
		G.printf("Laser Tower", 208 * 0 + 16, W.getHeight() - 108, 192, "center")
		G.printf("Energy Tower", 208 * 1 + 16, W.getHeight() - 108, 192, "center")
		G.printf("Mass Tower", 208 * 2 + 16, W.getHeight() - 108, 192, "center")

		o.guiGame.draw()

		G.setFont(o.fontDescription)
		if o.btnTower1.isChecked() then
			G.setColor(0, 127, 255, 255)
		else
			G.setColor(0, 127, 255, 127)
		end
		G.print("Cost: 10 Mass", 208 * 0 + 88, W.getHeight() - 68)
		G.print("Shoot laser!", 208 * 0 + 88, W.getHeight() - 44)

		if o.btnTower2.isChecked() then
			G.setColor(255, 127, 0, 255)
		else
			G.setColor(255, 127, 0, 127)
		end
		G.print("Cost: 10 Mass", 208 * 1 + 88, W.getHeight() - 68)
		G.print("Give energy", 208 * 1 + 88, W.getHeight() - 44)

		if o.btnTower3.isChecked() then
			G.setColor(0, 255, 127, 255)
		else
			G.setColor(0, 255, 127, 127)
		end
		G.print("Cost: 10 Mass", 208 * 2 + 88, W.getHeight() - 68)
		G.print("Extract Mass", 208 * 2 + 88, W.getHeight() - 44)

		G.setColor(127, 191, 255, 31)
		G.rectangle("fill", 16, 16, turGame.map.width * 4, turGame.map.height * 4)

		for i = 1, turGame.map.width do
			for k = 1, turGame.map.height do
				if turGame.map.data[i][k].id >= 1 then
					if turGame.map.data[i][k].id <= 4 then
						G.setColor(0, 255, 0, 127)
					elseif turGame.map.data[i][k].id >= 6 and turGame.map.data[i][k].id <= 7 then
						G.setColor(255, 127, 0, 127)
					else
						G.setColor(255, 255, 255, 63)
					end

					G.rectangle("fill", 16 + (i - 1) * 4, 16 + (k - 1) * 4, 4, 4)
				end
			end
		end

		for i = 1, #turGame.enemies do
			if not turGame.enemies[i].dead then
				G.setColor(255, 0, 0, 127)
				G.rectangle("fill", 16 + (turGame.enemies[i].ai.getX() - 1) * 4, 16 + (turGame.enemies[i].ai.getY() - 1) * 4, 4, 4)
			end
		end
	end

	return o
end