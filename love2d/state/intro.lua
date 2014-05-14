local o = {}

o.imgBackground0	= love.graphics.newImage("gfx/love_bg.png")
o.imgBackground0:setWrap("repeat", "repeat")
o.vertBackground0 = {
	{ 0, 0, 0, 0, 255, 255, 255, 63 },
	{ love.window.getWidth(), 0, love.window.getWidth() / o.imgBackground0:getWidth(), 0, 255, 255, 255, 63 },
	{ love.window.getWidth(), love.window.getHeight(), love.window.getWidth() / o.imgBackground0:getWidth(), love.window.getHeight() / o.imgBackground0:getHeight(), 255, 255, 255, 127 },
	{ 0, love.window.getHeight(), 0, love.window.getHeight() / o.imgBackground0:getHeight(), 255, 255, 255, 127 },
}
o.mshBackground0 	= love.graphics.newMesh(o.vertBackground0, o.imgBackground0, "fan")
o.imgBackground1	= love.graphics.newImage("gfx/love_logo.png")
o.imgBackground2	= love.graphics.newImage("gfx/world.png")
o.phase = 2

o.fontTitle = love.graphics.newFont(20)

o.effectTimer = 0
o.chromaticEffect = 0
o.showTimer = 0

o.gui = love.gui.newGui()

o.update = function(dt)
	o.gui.update(dt)

	o.showTimer = o.showTimer + dt
	o.effectTimer = o.effectTimer + dt
	o.chromaticEffect = o.chromaticEffect + dt
	if o.gui.isHit() or love.keyboard.isDown("escape") or(o.showTimer > 30) then
		o.gui.flushMouse()
		love.setgamestate(0)
	end
end

o.quote = "Commander! Can you hear me? This is Station Alpha Z-031 on Mining Colony Monaco XII. We are under siege. I repeat: We are under siege."
o.quote = o.quote.. " The colony is being attacked by a massive fleet of alien ships. Requesting immediate backup. Enter the planet's orbit and deploy defensive structures from the mother ship."
o.quote = o.quote .." We don't have much time. Other stations are sending out distress calls as well. Please save us."
o.source = ""

o.draw = function()
	love.graphics.setColor(95 + math.sin(o.effectTimer * 0.1) * 63, 191 + math.cos(o.effectTimer) * 31, 223 + math.sin(o.effectTimer) * 31, 63)
	love.graphics.draw(o.imgBackground2, love.window.getWidth() * 0.5 - o.imgBackground2:getWidth() * 0.5)

	love.graphics.setColor(95 + math.sin(o.effectTimer * 0.1) * 63, 191 + math.cos(o.effectTimer) * 31, 223 + math.sin(o.effectTimer) * 31, 127)
	love.graphics.setFont(o.fontTitle)
	love.graphics.printf(o.quote, love.window.getWidth() * 0.5 - 128, love.window.getHeight() * 0.5 - 16, love.window.getWidth() * 0.5, "left")
	love.graphics.printf(o.source, love.window.getWidth() * 0.5 + 64, love.window.getHeight() * 0.5 + 16, love.window.getWidth() * 0.5, "left")

	if math.random(0, love.timer.getFPS() * 8) == 0 then
		o.chromaticEffect = math.random(0, 5) * 0.1
	end

	if o.chromaticEffect < 1.0 then
		local colorAberration1 = math.sin(love.timer.getTime() * 10.0) * (1.0 - o.chromaticEffect) * 2.0
		local colorAberration2 = math.cos(love.timer.getTime() * 10.0) * (1.0 - o.chromaticEffect) * 2.0

		love.postshader.addEffect("chromatic", colorAberration1, colorAberration2, colorAberration2, -colorAberration1, colorAberration1, -colorAberration2)
	end
end

return o