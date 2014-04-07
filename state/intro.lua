local o = {}

o.imgBackground1	= love.graphics.newImage("gfx/love.png")
o.imgBackground2	= love.graphics.newImage("gfx/world.png")
o.phase = 1

o.fontTitle = love.graphics.newFont(24)
o.fontDescription = love.graphics.newFont(16)

o.effectTimer = 0
o.chromaticEffect = 0
o.showTimer = 0


o.gui = love.gui.newGui()


o.update = function(dt)
	o.gui.update(dt)

	o.showTimer = o.showTimer +dt
	if (o.phase == 1)then
		if o.gui.isHit() or love.keyboard.isDown("escape") or (o.showTimer > 4) then
			o.showTimer = 0
			o.phase = 2
		end
	elseif o.phase == 2 then
		o.effectTimer = o.effectTimer + dt
		o.chromaticEffect = o.chromaticEffect + dt
		if o.gui.isHit() or love.keyboard.isDown("escape") or(o.showTimer > 4) then
			o.gui.flushMouse()
			love.setgamestate(0)
		end
	end
end
local loremIpsum = "Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat."
o.draw = function()
	if o.phase == 1 then
		love.graphics.setBlendMode("alpha")
		love.graphics.setColor(255, 255, 255,255)
		local sx = love.window.getWidth()/o.imgBackground1:getWidth()
		local sy = love.window.getHeight()/o.imgBackground1:getHeight()
		love.graphics.draw(o.imgBackground1, 0,0,0,sx,sy)
	elseif o.phase == 2 then
		love.graphics.setColor(127, 127, 127)
		love.graphics.draw(o.imgBackground2, love.window.getWidth() * 0.5 - o.imgBackground2:getWidth() * 0.5)


		love.graphics.printf(loremIpsum, love.window.getWidth()*0.25, 160, love.window.getWidth()*0.5, "left")

		if math.random(0, love.timer.getFPS() * 5) == 0 then
			o.chromaticEffect = math.random(0, 5) * 0.1
		end

		if o.chromaticEffect < 1.0 then
			local colorAberration1 = math.sin(love.timer.getTime() * 10.0) * (1.0 - o.chromaticEffect) * 2.0
			local colorAberration2 = math.cos(love.timer.getTime() * 10.0) * (1.0 - o.chromaticEffect) * 2.0

			love.postshader.addEffect("chromatic", colorAberration1, colorAberration2, colorAberration2, -colorAberration1, colorAberration1, -colorAberration2)
		end
	end
end


return o