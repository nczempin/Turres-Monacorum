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
gui.imgOverlay = love.graphics.newImage("resources/sprites/ui/overlay.png")
gui.timer = 0


local activemenu = {
	start = false,
	load = false,
	settings = false,
	quit = false
}

function love.mousepressed(x, y, key)
	if(key=="l") then
		buttonDetected = 1
		love.turris.checkleftclick(x,y)
	end
	if(key=="m") then
		buttonDetected = 3
	end
	if(key=="r") then
		buttonDetected = 2
		love.turris.checkrightclick(x,y)
	end
end

function love.mousereleased(x, y, key)
	buttonDetected = 0
end

--Function to look if Mousbutton is over an button
function gui.mouseMove()
	local mouseXPos = love.mouse.getX()
	local mouseYPos = love.mouse.getX()
	
	--Check if Mouse is over an button
	for i = 1, #buttons do
		--Check if mouse is over Button
		if buttons[i].isOverButton(mouseXPos,mouseYPos) then
			buttons[i].hover = true
		else
			buttons[i].hover = false
		end
	end
end


--Updates Everything in the GUI --TODO--  PLZ ADD ALL OTHER METHODS 
function gui.update(dt)
	gui.mouseMove()
	gui.timer = gui.timer + dt
end



function gui.isinbutton(clickx,clicky)
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


function gui.button(xPos, yPos, width, height, name)
	local o = {}

	--Attribute
	o.xPos 		= xPos
	o.yPos 		= yPos
	o.width 	= width
	o.height 	= height
	o.name 		= name
	o.status 	= false
	o.hover 	= false
 
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


function gui.createButtons()
	local startx = screenWidth / 2 - (buttonsizeh / 2)
	local starty = 128
	local buttonDistance = screenHeight / 5 - (buttonsizev)

	--Creates the buttons and pushes it into the buttons array
	for i = 1, #buttonNames do		
		buttons[#buttons + 1] = gui.button(startx, starty, buttonsizeh, buttonsizev, buttonNames[i])
		starty = starty + 80
	end
end

function love.turris.checkleftclick(clickx,clicky)
	currentgstate=love.getgamestate()
	if currentgstate == 0 then--MainMenu
		gui.isinbutton(clickx,clicky)
		love.turris.mainmenubuttonpushed()
	elseif currentgstate == 1 then --ingame
		--love.setgamestate(0)
		local clickedfieldx,clickedfieldy=getclickedfield(clickx,clicky)
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
	if currentgamestate == 1 then --ingame
		local clickedfieldx,clickedfieldy=getclickedfield(clickx,clicky)
		turGame.removeTower(clickedfieldx,clickedfieldy)
		--turMap.setState(clickedfieldx,clickedfieldy,0)
		--turrets will be removed
	end
end

function gui.drawMainMenu()
	love.graphics.setColor(255, 255, 255, 223)
	G.setBlendMode("alpha")
	G.draw(gui.imgBackground)
	love.graphics.setColor(95 + math.sin(gui.timer * 0.1) * 63, 191 + math.cos(gui.timer) * 31, 223 + math.sin(gui.timer) * 31, 255)
	G.setBlendMode("additive")
	G.draw(gui.imgMiddleground)
	love.graphics.setColor(255, 255, 255)
	G.setBlendMode("alpha")
	G.draw(gui.imgLogo, gui.imgLogo:getWidth() * 0.5, gui.imgLogo:getHeight() * 0.5, math.sin(gui.timer * 4) * 0.05 * math.max(0, 2 - gui.timer ^ 0.5), 1, 1, gui.imgLogo:getWidth() * 0.5, gui.imgLogo:getHeight() * 0.5)

	for i = 1, #buttons do	
		G.setBlendMode("alpha")
		love.graphics.setColor(0, 0, 0, 91)
		love.graphics.printf(buttons[i].name, buttons[i].xPos + 2,buttons[i].yPos + buttons[i].height / 3 + 2, buttons[i].width, "center")
		G.setBlendMode("additive")
		love.graphics.setColor(255, 127, 0)
		love.graphics.printf(buttons[i].name, buttons[i].xPos,buttons[i].yPos + buttons[i].height / 3, buttons[i].width, "center")
	end
end

function gui.drawOverlay()
	G.setBlendMode("alpha")
	love.graphics.setColor(255, 255, 255, 255)
	G.draw(gui.imgOverlay)
end

function love.turris.mainmenubuttonpushed()

	if(activemenu.start == true) then
		love.sounds.playSound("sounds/button_pressed.wav")
		love.turris.startGame()
	elseif(activemenu.load == true) then
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
