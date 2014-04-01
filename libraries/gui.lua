--GUI class
love.gui = {}

require "libraries/button"

function love.gui.newGui()
	local o = {}

	--Attribute
	o.elements = {}
	o.hit = false
	o.down = true
	o.timer = 0

	--Update gui
	o.update = function(dt)
		local mx = love.mouse.getX()
		local my = love.mouse.getY()

		o.timer = o.timer + dt

		if love.mouse.isDown("l") then
			if o.down then
				o.hit = false
			else
				o.hit = true
				o.down = true
			end
		else
			o.hit = false
			o.down = false
		end

		--Check if Mouse is over an element
		for i = 1, #o.elements do
			o.elements[i].update(dt)

			if mx >= o.elements[i].x and mx <= o.elements[i].x + o.elements[i].width and my >= o.elements[i].y and my <= o.elements[i].y + o.elements[i].height then
				o.elements[i].hover = true
				if love.mouse.isDown("l") then
					if o.elements[i].down then
						o.elements[i].hit = false
					else
						o.elements[i].hit = true
						o.elements[i].down = true
					end
				else
					o.elements[i].hit = false
					o.elements[i].down = false
				end
			else
				o.elements[i].hover = false
				o.elements[i].hit = false
				o.elements[i].down = false
			end
		end
	end

	--Draw gui
	o.draw = function(dt)
		for i = 1, #o.elements do
			o.elements[i].draw()
		end
	end

	--Return new button
	o.newButton = function(x, y, width, height, name, imagePath)
		o.elements[#o.elements + 1] = love.gui.newButton(x, y, width, height, name, imagePath)

		return o.elements[#o.elements]
	end

	--Return true when hit
	o.isHit = function()
		return o.hit
	end

	--Return true when down
	o.isDown = function()
		return o.down
	end

	--Flush Mouse stats
	o.flushMouse = function()
		o.hit = false
		o.down = true
		print("flush")
	end

	return o
end

------------
-- TODO: move all functions into gui or game object
------------

buttonDetected = 0
-- GameStates:0=MainMenu, 1=inGame, 2=Load, 3=Settings, 4=Game Over, 5 = Credits

function love.turris.checkleftclick(clickx,clicky)
	currentgstate=love.getgamestate()
	if currentgstate == 1 then --ingame
		--love.setgamestate(0)
		local clickedfieldx,clickedfieldy=getclickedfield(clickx,clicky)
		turGame.addTower(clickedfieldx,clickedfieldy,1)
	elseif currentgstate == 4 then --game over
		love.turris.gameoverstate()
	elseif currentgstate == 5 then --credits
		--love.setgamestate(0)
	end
end

function getclickedfield(clickx,clicky)
	local x=((clickx-turGame.offsetX)-((clickx-turGame.offsetX)%turMap.tileWidth))/turMap.tileWidth+1
	local y=((clicky-turGame.offsetY)-((clicky-turGame.offsetY)%turMap.tileHeight))/turMap.tileHeight+1
	print("clicked field "..x..", "..y)
	return x,y
end

function love.turris.checkrightclick(clickx,clicky)
	currentgstate=love.getgamestate()
	if currentgamestate == 1 then --ingame
		local clickedfieldx,clickedfieldy=getclickedfield(clickx,clicky)
		turGame.removeTower(clickedfieldx,clickedfieldy)
		--turMap.setState(clickedfieldx,clickedfieldy,0)
		--turrets will be removed
	end
end