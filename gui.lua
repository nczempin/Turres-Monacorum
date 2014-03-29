--[[#########################################
-- GUI und Hauptmenue sind hier drin
--#########################################
-- vorab: sorry, gelegentlich wird die Kommentarsprache gewechselt
-- Elemente fuer das Hauptmenue:
-- *neues Spiel starten
--- -> Start in der 1. Mission
-- *Spiel fortsetzen/laden
--- -> Auswahl von Datei
-- *Einstellungen
--- -> Ton/Musik, Aufloesung, ...
-- *Beenden ->beendet Spiel [evtl. nochmal nachfragen]
--]]
-- gui = require "Quickie" -- not yet
gui={}
gui.current = nil
buttonDetected=0
font = love.graphics.newFont(16)
-- GameStates:0=MainMenu, 1=inGame, 2=Load, 3=Settings
currentgamestate = 0

local width = love.window.getWidth()
local height = love.window.getHeight()
local buttonsizeh = 40
local buttonsizev = 20

function love.mousepressed(x, y, key)
	if(key=="l") then
		buttonDetected=1
		--love.changegamestate(1)
		checkButtonPosition(x,y)
	end
end

function checkButtonPosition(x,y)
	if(currentGameState==0) then--MainMenu
		if((gui.width/2)-(gui.ButtonSizeH/2)<x or (gui.width/2)+(gui.ButtonSizeH/2)<x) then -- half horizontal screen -menu button <x or x>half horizontal screen + menu button
			if(y>(gui.width/5)-(gui.ButtonSizeV/2) or (gui.width/5)+(gui.buttonSizeV/2)<y) then
				activeMenu.start = true
		elseif(false) then
		end
        gui.mainMenuButtonPushed()
	end
	end
	if(currentGameState==1) then --ingame
	--NYI
	end
	
end

local activeMenu = {
	start = false,
	load = false,
	settings = false,
	quit = false
}

function gui.drawMainMenu()
	love.graphics.setBackgroundColor(100,100,220)

	local allbuttonspositionv = width/2 -- all buttons are equal in their vertical position as of yet
	local startpositionh = height/5
	local loadpositionh = height*2/5
	local settingspositionh = height*3/5
	local quitpositionh = height*4/5

	love.graphics.setColor(250,250,250)
	--startButton
	love.graphics.rectangle("fill", (allbuttonspositionv-(buttonsizev/2)), (startpositionh-(buttonsizeh/2)), (buttonsizev), (buttonsizeh))
	--startText
	love.graphics.printf("Spiel starten", allbuttonspositionv,startpositionh-buttonsizeh/2,buttonsizeh/2)
	--loadbutton
	love.graphics.rectangle("fill", (allbuttonspositionv-(buttonsizev/2)), (loadpositionh-(buttonsizeh/2)), (buttonsizev), (buttonsizeh))
	--loadText
	love.graphics.printf("Spiel laden", allbuttonspositionv,loadpositionh-buttonsizeh/2,buttonsizeh/2)
	--settingsbutton
	love.graphics.rectangle("fill", (allbuttonspositionv-(buttonsizev/2)), (settingspositionh-(buttonsizeh/2)), (buttonsizev), (buttonsizeh))
	--settingsText
	love.graphics.printf("Einstellungen", allbuttonspositionv,settingspositionh-buttonsizeh/2,buttonsizeh/2)
	--quitbutton
	love.graphics.rectangle("fill", (allbuttonspositionv-(buttonsizev/2)), (quitpositionh-(buttonsizeh/2)), (buttonsizev), (buttonsizeh))
	--quitText
	love.graphics.printf("Beenden", allbuttonspositionv,quitpositionh-buttonsizeh/2,buttonsizeh/2)
end

function mainMenuButtonPushed()
	if(activeMenu.start) then
		gui.startGame()
	elseif(activeMenu.load) then
		gui.showLoadWindow()
	elseif(activeMenu.settings) then
		gui.openSettings()
	elseif(activeMenu.quit) then
		gui.quitGame()
	end
	activeMenu.start = false
	activeMenu.load = false
	activeMenu.settings = false
	activeMenu.quit = false
end

function gui.startGame()
	print("Not yet implemented")
	--hier wird das eigentliche Spiel gestartet
end
function gui.showLoadWindow() -- hier wird eine Liste mit allen Spielstaenden angezeigt
	local savestates = {
		save1 = "save 1",
		save2 = "save 2",
		save3 = "save 3"
	}
end

function gui.openSettings()

--Startbildschirm am Ende neu laden und ggf. Button-Positionen neu berechnen !!
end

function gui.quitGame()
	love.quit()
end
