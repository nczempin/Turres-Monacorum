local o = {}

o.imgScreen	= love.graphics.newImage("gfx/menu/screen00.png")

o.mainContributorsFontSize = 32
o.mainContributorsFont = love.graphics.newFont(o.mainContributorsFontSize)
o.externalLibsFontSize = 16
o.externalLibsFont = love.graphics.newFont(o.externalLibsFontSize)

o.names = {
	"Aldo Brießmann (Code)",
	"Elena Reinertz (Graphics)",
	"Marcus Ihde (Code)",
	"Meral Leyla (Sound)",
	"Michael Steidl (Code, Sound)",
	"Nicolai Czempin (Code)",
	"Robin Kocaurek (Graphics)"
}

o.otherText = {
	"Animation lib: Bart Bes",
	"Jumper pathfinding lib: Roland Yonaba",
	"Light/Shadow lib: Marcus Ihde",
	"Postshader lib: Marcus Ihde",
	"TESound lib: Ensayia & Taehl",
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

	love.graphics.setColor(255, 255, 255, 31)
	love.graphics.draw(o.imgScreen)

	--main contributors
	love.graphics.setFont(o.mainContributorsFont)
	local f = 7
	for i = 1, #o.names do
		local r = 127 + math.sin(love.timer.getTime() * 5 - i * f + 90) * 127
		local g = 127 + math.sin(love.timer.getTime() * 5 - i * f + 180) * 127
		local b = 127 + math.sin(love.timer.getTime() * 5 - i * f + 270) * 127
		local x = 0
		local y = 48 + i * 48
		love.graphics.setColor(r, g, b, 255)
		love.graphics.printf(o.names[i], x, y, W.getWidth(), "center")
	end

	--external libraries and other
	love.graphics.setFont(o.externalLibsFont)
	for i = #o.otherText, 1, -1 do
		local x = W.getWidth()*.7
		local y = W.getHeight() - (#o.otherText -i + 2) * o.externalLibsFontSize
		love.graphics.setColor(75, 75, 75, 255)
		love.graphics.print(o.otherText[i], x, y)
	end

	if lightWorld.optionGlow then
		lightWorld.setBuffer("render")
	end

	if lightWorld.optionGlow then
		lightWorld.drawGlow()
	end
end

return o