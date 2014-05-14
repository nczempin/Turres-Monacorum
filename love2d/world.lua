love.turris = {}
love.turris.save = {}

-- create light world
lightWorld = love.light.newWorld()
lightWorld.setNormalInvert(true)
lightWorld.setAmbientColor(15, 15, 31)
lightWorld.setRefractionStrength(16)
lightWorld.setReflectionStrength(32)
lightWorld.setReflectionVisibility(0.5)
lightWorld.setGlowStrength(3.0)

------------
-- TODO: move all functions into gui or game object
------------

buttonDetected = 0
-- GameStates:0=MainMenu, 1=inGame, 2=Load, 3=Settings, 4=Game Over, 5 = Credits

function love.turris.checkleftclick(clickx,clicky)
	currentgstate = love.getgamestate()
	if currentgstate == 1 then --ingame
		if turGame.layerHud.guiGame.hover then
			local clickedfieldx, clickedfieldy = getclickedfield(clickx, clicky)
			turGame.addTower(clickedfieldx, clickedfieldy, love.turris.selectedtower)
		end
	elseif currentgstate == 4 or currentgstate == 13 then --game over
		love.turris.gameoverstate()
	elseif currentgstate == 5 then --credits
	end
end

function getclickedfield(clickx,clicky)
	local x = ((clickx-turGame.offsetX) - ((clickx-turGame.offsetX) % turMap.tileWidth))/turMap.tileWidth + 1
	local y = ((clicky-turGame.offsetY) - ((clicky-turGame.offsetY) % turMap.tileHeight))/turMap.tileHeight + 1
	print("clicked field " .. x .. ", " .. y)
	return x, y
end

function love.turris.checkrightclick(clickx,clicky)
	currentgstate = love.getgamestate()
	if currentgamestate == 1 then --ingame
		if turGame.layerHud.guiGame.hover then
			local clickedfieldx, clickedfieldy = getclickedfield(clickx, clicky)
			turGame.removeTower(clickedfieldx, clickedfieldy)
		end
	end
end