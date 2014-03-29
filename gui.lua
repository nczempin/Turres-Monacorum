--[[#########################################
-- GUI und Hauptmenue sind hier drin
-- Aldo B.
--#########################################
-- vorab: sorry, gelegentlich wird die Kommentarsprache gewechselt
-- Elemente für das Hauptmenue:
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

font = love.graphics.newFont(16)
-- GameStates:0=MainMenu, 1=inGame, 2=Load, 3=Settings
currentgamestate = 0

local width = love.window.getWidth()
local height = love.window.getHeight()
local ButtonSizeH = 40
local ButtonSizeV = 20

function checkButtonPosition(x,y)
	if(currentGameState==0) then--MainMenu
		if((gui.width/2)-(gui.ButtonSizeH/2)<x or (gui.width/2)+(gui.ButtonSizeH/2)<x) then -- half horizontal screen -menu button <x or x>half horizontal screen + menu button
			if(y>(gui.width/5)-(gui.ButtonSizeV/2) or (gui.width/5)+(gui.buttonSizeV/2)<y) then
			activeMenu.start = true
			elseif(false) then
			end
		end
	end
	if(currentGameState==1) then --ingame
		--NYI
	end

	gui.mainMenuButtonPushed()
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
	local startpositionh = gui.height/5
	local loadpositionh = gui.height*2/5
	local settingspositionh = gui.height*3/5
	local quitpositionh = gui.height*4/5
	
	love.graphics.setColor(250,250,250)
	--startButton
	love.graphics.rectangle("fill", (gui.allbuttonspositionv-(gui.buttonsizev/2)), (gui.startpositionh-(gui.buttonsizeh/2)), (gui.buttonsizev), (gui.buttonsizeh))
	--startText
	love.graphics.printf("Spiel starten", gui.allbuttonspositionv,gui.startpositionh-gui.buttonsizeh/2,buttonsizeh/2)
	--loadbutton
	love.graphics.rectangle("fill", (gui.allbuttonspositionv-(gui.buttonsizev/2)), (gui.loadpositionh-(gui.buttonsizeh/2)), (gui.buttonsizev), (gui.buttonsizeh))
	--loadText
	love.graphics.printf("Spiel laden", gui.allbuttonspositionv,gui.loadpositionh-gui.buttonsizeh/2,buttonsizeh/2)
	--settingsbutton
	love.graphics.rectangle("fill", (gui.allbuttonspositionv-(gui.buttonsizev/2)), (gui.settingspositionh-(gui.buttonsizeh/2)), (gui.buttonsizev), (gui.buttonsizeh))
	--settingsText
	love.graphics.printf("Einstellungen", gui.allbuttonspositionv,gui.settingspositionh-gui.buttonsizeh/2,buttonsizeh/2)
	--quitbutton
	love.graphics.rectangle("fill", (gui.allbuttonspositionv-(gui.buttonsizev/2)), (gui.quitpositionh-(gui.buttonsizeh/2)), (gui.buttonsizev), (gui.buttonsizeh))
	--quitText
	love.graphics.printf("Beenden", gui.allbuttonspositionv,gui.quitpositionh-gui.buttonsizeh/2,buttonsizeh/2)
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