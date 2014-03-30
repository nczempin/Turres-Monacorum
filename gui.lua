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
--currentgamestate = 0

local width = love.window.getWidth()
local height = love.window.getHeight()
local buttonsizeh = 100
local buttonsizev = 40

local activemenu = {
	start = false,
	load = false,
	settings = false,
	quit = false
}

function love.mousepressed(x, y, key)
	if(key=="l") then
		buttonDetected=1
		--love.changegamestate(1)
		love.turris.checkButtonPosition(x,y)
	end
end

function love.turris.checkButtonPosition(clickx,clicky)
	--love.changegamestate(1)
	currentgstate=love.getgamestate()
	--print(love.window.getWidth())
	--print(clickx.." "..clicky)
	if(currentgstate==0) then--MainMenu
		if((width/2)-(buttonsizeh/2)<clickx and (width/2)+(buttonsizeh/2)>clickx) then -- half horizontal screen -menu button <x or x>half horizontal screen + menu button
			if(clicky>(height/5)-(buttonsizev/2) and (height/5)+(buttonsizev/2)>clicky) then
				activemenu.start = true
			elseif(true) then
				print("click not within y range")
			end
        love.turris.mainmenubuttonpushed()
		else
		print("click not within x range")
		end
	end
	if(currentgstate==1) then --ingame
		love.changegamestate(0)
	--NYI
	end
	
end

function gui.drawMainMenu()
	love.graphics.setBackgroundColor(100,100,220)

	local allbuttonspositionh = width/2 -- all buttons are equal in their vertical position as of yet
	local startpositionv = height/5
	local loadpositionv = height*2/5
	local settingspositionv = height*3/5
	local quitpositionv = height*4/5

	love.graphics.setColor(250,250,250)
	--startButton
	
	--print(allbuttonspositionh.." "..buttonsizev)
	love.graphics.rectangle("fill", (allbuttonspositionh-(buttonsizeh/2)), (startpositionv-(buttonsizev/2)), buttonsizeh, buttonsizev)
	--startText
	love.graphics.setColor(0,0,0)
	love.graphics.printf("Spiel starten", allbuttonspositionh-buttonsizeh/2,startpositionv-buttonsizev/2,buttonsizeh)
	--loadbutton
	love.graphics.setColor(250,250,250)
	love.graphics.rectangle("fill", (allbuttonspositionh-(buttonsizeh/2)), (loadpositionv-(buttonsizev/2)), (buttonsizeh), (buttonsizev))
	--loadText
	love.graphics.setColor(0,0,0)
	love.graphics.printf("Spiel laden", allbuttonspositionh-buttonsizeh/2,loadpositionv-buttonsizev/2,buttonsizeh/2)
	--settingsbutton
	love.graphics.setColor(250,250,250)
	love.graphics.rectangle("fill", (allbuttonspositionh-(buttonsizeh/2)), (settingspositionv-(buttonsizev/2)), (buttonsizeh), (buttonsizev))
	--settingsText
	love.graphics.setColor(0,0,0)
	love.graphics.printf("Einstellungen", allbuttonspositionh-buttonsizeh/2,settingspositionv-buttonsizev/2,buttonsizeh/2)
	--quitbutton
	love.graphics.setColor(250,250,250)
	love.graphics.rectangle("fill", (allbuttonspositionh-(buttonsizeh/2)), (quitpositionv-(buttonsizev/2)), (buttonsizeh), (buttonsizev))
	--quitText
	love.graphics.setColor(0,0,0)
	love.graphics.printf("Beenden", allbuttonspositionh-buttonsizeh/2,quitpositionv-buttonsizev/2,buttonsizeh/2)
end

function love.turris.mainmenubuttonpushed()
	if(activemenu.start==true) then
		love.turris.startGame()
	elseif(activemenu.load==true) then
		love.turris.showLoadWindow()
	elseif(activemenu.settings) then
		love.turris.openSettings()
	elseif(activemenu.quit) then
		love.turris.quitGame()
	end
	activemenu.start = false
	activemenu.load = false
	activemenu.settings = false
	activemenu.quit = false
end

function love.turris.startGame()
	love.changegamestate(1)
	--hier wird das eigentliche Spiel gestartet
end
function love.turris.showLoadWindow() -- hier wird eine Liste mit allen Spielstaenden angezeigt
	local savestates = {
		save1 = "save 1",
		save2 = "save 2",
		save3 = "save 3"
	}
end

function love.turris.openSettings()

--Startbildschirm am Ende neu laden und ggf. Button-Positionen neu berechnen !!
end

function love.turris.quitGame()
	love.quit()
end
