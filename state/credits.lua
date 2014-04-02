local o = {}

o.imgScreen	= love.graphics.newImage("gfx/screen00.png")

o.mainContributorsFontSize = 32
o.mainContributorsFont = G.newFont(o.mainContributorsFontSize)
o.externalLibsFontSize = 16
o.externalLibsFont = G.newFont(o.externalLibsFontSize)

o.names = { "Aldo Brießmann", "Elena Reinertz", "Marcus Ihde", "Meral Leyla", "Michael Steidl", "Nicolai Czempin", "Robin Kocaurek" }

o.otherText = {
	"TESound lib: Ensayia & Taehl",
	"Light/Shadow lib: Marcus Ihde",
	"Postshader lib: Marcus Ihde",
	"Animation lib: Bart Bes",
	"A* Search lib: RapidFire Studio",

}

o.guiCredits = love.gui.newGui()

o.update = function(dt)
	o.guiCredits.update(dt)

	if o.guiCredits.isHit() or love.keyboard.isDown("escape") then
		o.guiCredits.flushMouse()
		love.setgamestate(0)
	end
end

o.draw = function()
	if lightWorld.optionGlow then
		lightWorld.glowMap:clear()
		lightWorld.setBuffer("glow")
	end

	G.setColor(255, 255, 255, 31)
	G.draw(o.imgScreen)

	--main contributors
	G.setFont(o.mainContributorsFont)
	for i = 1, #o.names do
		local r = 127 + math.sin(love.timer.getTime() * 5 - i + 90) * 127
		local g = 127 + math.sin(love.timer.getTime() * 5 - i + 180) * 127
		local b = 127 + math.sin(love.timer.getTime() * 5 - i + 270) * 127
		local x = 0
		local y = 72 + i * 32
		G.setColor(r, g, b, 255)
		G.printf(o.names[i], x, y, W.getWidth(), "center")
	end

	--external libraries and other
	G.setFont(o.externalLibsFont)
	for i = 1, #o.otherText do
		local x = W.getWidth() - 280
		local y = W.getHeight() - (i + 2) * o.externalLibsFontSize
		G.setColor(75, 75, 75, 255)
		G.print(o.otherText[i], x, y)
	end

	if lightWorld.optionGlow then
		lightWorld.setBuffer("render")
	end

	if lightWorld.optionGlow then
		lightWorld.drawGlow()
	end
end

return o