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
guiScale = 2.0
-- GameStates:0=MainMenu, 1=inGame, 2=Load, 3=Settings, 4=Game Over

font = love.graphics.newFont(32)
love.graphics.setFont(font)

local screenWidth = love.window.getWidth()
local screenHeight = love.window.getHeight()
local buttonsizeh = 200
local buttonsizev = 100
local buttons = {}
buttonNames = {"Start", "Load", "Settings", "Quit"}
gui.imgLogo = love.graphics.newImage("resources/sprites/ui/logo.png")
gui.imgBackground = love.graphics.newImage("resources/sprites/ui/menu_background.png")
gui.imgMiddleground = love.graphics.newImage("resources/sprites/ui/menu_middleground.png")

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
	for i = 1, #buttons do
		if buttons[i].isOverButton(clickx, clicky) == true  then
			if buttons[i].name == "Start" then
				activemenu.start 	= true
			elseif buttons[i].name == "Load" then
				activemenu.load 	= true
			elseif buttons[i].name == "Settings" then
				activemenu.settings = true
			elseif buttons[i].name == "Quit" then
				activemenu.quit 	= true
			end
		end
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
 
	--Returns true if the Position is inside an Button
	function o.isOverButton(mouseX, mouseY)
		if mouseX > xPos and mouseX < xPos + width and mouseY > yPos and mouseY < yPos + height then			
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
	local startx = screenWidth / 2 - (buttonsizeh / 2)
	local starty = 128
	local buttonDistance = screenHeight / 5 - (buttonsizev)

	--Creates the buttons and pushes it into the buttons array
	for i = 1, #buttonNames do		
		buttons[#buttons +1] = button(startx, starty, buttonsizeh, buttonsizev, buttonNames[i])
		starty = starty + 80
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
				turGame.addTower(clickedfieldx,clickedfieldy,1)
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
		local clickedfieldx,clickedfieldy=getclickedfield(clickx,clicky)
		turGame.removeTower(clickedfieldx,clickedfieldy)
		--turMap.setState(clickedfieldx,clickedfieldy,0)
		--turrets will be removed
	end
end

function gui.drawMainMenu()	
	local buttonDistance = 30
	love.graphics.setColor(255, 255, 255)

	--love.graphics.setColor(0, 0, 0, 91)
	--love.graphics.rectangle("fill", buttons[1].xPos - 16, buttons[1].yPos - 16, buttons[1].width + 32, buttons[1].height * 4 + 92)
	local timer = math.sin(love.timer.getTime())
	G.draw(gui.imgBackground)
	G.draw(gui.imgMiddleground)
	G.draw(gui.imgLogo, gui.imgLogo:getWidth() * 0.5, gui.imgLogo:getHeight() * 0.5, timer * 0.1, 1, 1, gui.imgLogo:getWidth() * 0.5, gui.imgLogo:getHeight() * 0.5)
	
	for i = 1, #buttons do	
		--G.setBlendMode("alpha")
		--love.graphics.setColor(0, 0, 0, 91)
		--love.graphics.setLineWidth(8)
		--love.graphics.rectangle("line", buttons[i].xPos, buttons[i].yPos, buttons[i].width, buttons[i].height)
		--G.setBlendMode("additive")
		--love.graphics.setColor(0, 127, 255)
		--love.graphics.setLineWidth(4)
		--love.graphics.rectangle("line", buttons[i].xPos, buttons[i].yPos, buttons[i].width, buttons[i].height)
		--startText
		G.setBlendMode("alpha")
		love.graphics.setColor(0, 0, 0, 91)
		love.graphics.printf(buttons[i].name, buttons[i].xPos + 2,buttons[i].yPos + buttons[i].height / 3 + 2, buttons[i].width, "center")
		G.setBlendMode("additive")
		love.graphics.setColor(255, 127, 0)
		love.graphics.printf(buttons[i].name, buttons[i].xPos,buttons[i].yPos + buttons[i].height / 3, buttons[i].width, "center")
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
