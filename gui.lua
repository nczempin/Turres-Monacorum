--[[#########################################
-- GUI and main menu are in here
--#########################################
-- elements for the main menu:
-- *start new game
--- -> go to first mission
-- * continue/load game
--- -> choose save file
-- *settings
--- -> sound, resolution, ...
-- *Quit -> stops the game
--]]
gui={}
gui.current = nil
buttonDetected=0
font = love.graphics.newFont(64)
love.graphics.setFont(font)
guiScale = 2.0
-- GameStates:0=MainMenu, 1=inGame, 2=Load, 3=Settings, 4=Game Over

local width = love.window.getWidth()
local height = love.window.getHeight()
local buttonsizeh = 300
local buttonsizev = 100
local buttons = {}
buttonNames = {"Start", "Load", "Settings", "Quit"}



local activemenu = {
	start = false,
	load = false,
	settings = false,
	quit = false
}

function love.mousepressed(x, y, key)
	if(key=="l") then
		buttonDetected=1
		love.turris.checkleftclick(x,y)
	end
	if(key=="r") then
		buttonDetected=2
		love.turris.checkrightclick(x,y)
	end
end

function isinbutton(clickx,clicky)
	if (width / 2)-(buttonsizeh / 2) * guiScale < clickx and (width / 2)+(buttonsizeh / 2) * guiScale > clickx then -- half horizontal screen -menu button <x or x>half horizontal screen + menu button
		if clicky > (height / 5) - (buttonsizev / 2) * guiScale and (height / 5) + (buttonsizev / 2) * guiScale > clicky then
			activemenu.start = true
			return true
		elseif clicky >(height*2 / 5) - (buttonsizev / 2) * guiScale and (height * 2 / 5) + (buttonsizev /2) * guiScale > clicky then
			activemenu.load = true
			return true
		elseif clicky >(height*3 / 5) - (buttonsizev / 2) * guiScale and (height * 3 / 5) + (buttonsizev /2) * guiScale > clicky then
			activemenu.settings = true
			return true
		elseif clicky >(height*4 / 5) - (buttonsizev / 2) * guiScale and (height * 4 / 5) + (buttonsizev /2) * guiScale > clicky then
			activemenu.quit = true
			return true
		else
			print("click not within y range")
			return false
		end
	else
		print("click not within x range")
		return false
	end
end


--Button class
-- This Class is a Button with all its Attributes
-- @param xPos  
-- @param yPos 
-- @param width 
-- @param height 
-- @param name The Name of the button

function button(xPos, yPos, width, height, name)

	local o = {}

	--Attribute
	o.xPos 		= xPos
	o.yPos 		= yPos
	o.width 	= width
	o.height 	= height
	o.name 		= name
	o.status 	= false
 
	function o.isOverButton(mouseX, mousey)
		if mosueX > xPos and mouseX < xPos + width and mouseY > yPos and mouseY > yPos + height then
			return true
		else
			return false
		end
	end
	
	return o
end



--Function to Create Buttons
-- Usses The Array buttonNames to Crate The buttons
function createButtons()

	

	local startx = width / 2
	local starty = (height / 5) - (buttonsizev / 2)
	local buttonDistance = height / 5 - (buttonsizev)

	
	--Creates the buttons and pushes it into the buttons array
	for i = 1, #buttonNames do		
		buttons[#buttons +1] = button(startx,starty,buttonsizeh,buttonsizev,buttonNames[i])
		starty = starty + (buttonDistance + buttonsizev)
	end
	
	
	
end

function love.turris.checkleftclick(clickx,clicky)
	currentgstate=love.getgamestate()
	if currentgstate == 0 then--MainMenu
		isinbutton(clickx,clicky)
		love.turris.mainmenubuttonpushed()
	elseif currentgstate == 1 then --ingame
		--love.setgamestate(0)
		local clickedfieldx,clickedfieldy=getclickedfield(clickx,clicky)
		print(clickedfield)
		--if not(clickedfield.x<0 or clickedfield.x>=turMap.width or clickedfield.y<0 or clickedfield.y>=turMap.height) then
			--if turMap.getState(clickedfieldx,clickedfieldy)==0 then
				--turMap.setstate(clickedfieldx,clickedfieldy,1)
				turGame.addTower(clickedfieldx,clickedfieldy,1)
				--print("Turret would have been placed at "..clickedfieldx..", "..clickedfieldy)
			--elseif turMap.getstate(clickedfieldx,clickedfieldy) then
				--print("Turret would have been removed at "..clickedfieldx..", "..clickedfieldy)
			--end
		--end
	--love.setgamestate(0)
	--love.turris.reinit()
		--jumps back to the main menu at the moment

	elseif currentgstate == 4 then --game over
		love.turris.gameoverstate()
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
	if currentgamestate==1 then --ingame
		clickedfieldx,clickedfieldy=getclickedfield(clickx,clicky)
		turMap.setState(clickedfieldx,clickedfieldy,0)
		--turrets will be removed
	end
end




function gui.drawMainMenu()
	--love.graphics.setBackgroundColor(100,100,220)

	local allbuttonspositionh = width/2/guiScale -- all buttons are equal in their vertical position as of yet
	local startpositionv = height/5/guiScale
	local loadpositionv = height*2/5/guiScale
	local settingspositionv = height*3/5/guiScale
	local quitpositionv = height*4/5/guiScale
	
	
	local buttonDistance = 40


	love.graphics.setColor(255, 127, 0)
	--startButton

	
	for i = 1, #buttons do	
	
		font = love.graphics.newFont(32)
		love.graphics.setFont(font)
		
		G.setBlendMode("alpha")
		love.graphics.setColor(0, 0, 0, 63)
		love.graphics.setLineWidth(4)
		love.graphics.rectangle("line", buttons[i].xPos - (buttons[i].width / 2), buttons[i].yPos, buttons[i].width, buttons[i].height)
		G.setBlendMode("additive")
		love.graphics.setColor(0, 127, 255)
		love.graphics.setLineWidth(4)
		love.graphics.rectangle("line", buttons[i].xPos - (buttons[i].width / 2), buttons[i].yPos, buttons[i].width, buttons[i].height)
		--startText
		love.graphics.setColor(0, 127, 255)
		love.graphics.printf(buttons[i].name, buttons[i].xPos - (buttons[i].width / 2) ,buttons[i].yPos + buttons[i].height / 3 ,buttons[i].width,"center")		
	end
end

function love.turris.mainmenubuttonpushed()

	if(activemenu.start==true) then
		love.sounds.playSound("sounds/button_pressed.wav")
		love.turris.startGame()
	elseif(activemenu.load==true) then
		love.sounds.playSound("sounds/button_deactivated.wav")
		love.turris.showLoadWindow()
	elseif(activemenu.settings) then
		love.sounds.playSound("sounds/button_deactivated.wav")
		love.turris.openSettings()
	elseif(activemenu.quit) then
		love.sounds.playSound("sounds/button_pressed.wav")
		love.turris.quitGame()
	end
	activemenu.start = false
	activemenu.load = false
	activemenu.settings = false
	activemenu.quit = false
end

function love.turris.startGame()
	love.setgamestate(1)
end
function love.turris.showLoadWindow() -- show list with all savestates or save files
	print("Saving and loading the game is not yet implemented")
	local savestates = {
		save1 = "save 1",
		save2 = "save 2",
		save3 = "save 3"
	}
end

function love.turris.openSettings()
	print("settings are not yet implemented")
	--reload main screen, recalculate button positions!!
end

function love.turris.quitGame()
	love.event.quit()
end
