local o = {}

local startx = love.window.getWidth() * 0.5 - 191 * 0.5
local starty = 80

o.imgBackground		= love.graphics.newImage("gfx/menu/menu_background.png")
o.imgMiddleground	= love.graphics.newImage("gfx/menu/menu_middleground.png")
o.imgScreen			= love.graphics.newImage("gfx/menu/screen00.png")

o.fontMenu = love.graphics.newFont(32)
o.fontOption = love.graphics.newFont(24)

o.effectTimer = 0
o.chromaticEffect = 0

o.guiMenu		= love.gui.newGui()

o.chkFullscreen	= o.guiMenu.newCheckbox(startx, starty + 64 * 0, 191, 32, o.optionFullscreen, "Fullscreen")
o.resolutionStrings = {"1920x1080", "1280x720", "800x600", "640x480"}

local width, height, flags = love.window.getMode()
local tmp = width.."x"..height
local found = 0
for i = 1, #o.resolutionStrings do
	if o.resolutionStrings[i] == tmp then
		print ("found: "..i)
		found = i
	end
end
if found == 0 then
	table.insert(o.resolutionStrings,1,tmp)
	found = 1
end
o.comboLarge		= o.guiMenu.newComboBox(startx, starty + 64 * 1, 191, 32, o.resolutionStrings)
for i = 1, #o.resolutionStrings do
	print (o.resolutionStrings[i])
end
o.comboLarge.updateSelection(found)
o.optionLarge = o.resolutionStrings[found]

o.btnBack		= o.guiMenu.newButton(startx + 8, starty + 64 * 5 + 8, 176, 34, "Back")


o.holding = false

o.reset = function()
	o.guiMenu.flushMouse()
end
o.checkOptionsLarge = function()
	local option = o.optionLarge
	if not option then
		return --TODO log warning?
	end
	local iterator = option:gmatch('%d+')
	local numbers = {}
	local i = 1
	for number in iterator do
		numbers[i] = tonumber(number)
		i = i + 1
	end
	--TODO we are assuming that x will always have 2 elements. This is unsafe to assume.
	local width, height, flags = love.window.getMode()
	local isFullscreen = flags["fullscreen"]
	if (numbers[1] ~= width or numbers[2] ~= height or isFullscreen ~= o.optionFullscreen)then
		local success = love.window.setMode( numbers[1], numbers[2], {fullscreen=o.optionFullscreen,vsync=false})--TODO: make vsync an option
		if success then
			love.postshader.refreshScreenSize()
			lightWorld.refreshScreenSize()
			stateMainMenu.refreshScreenSize()
			stateWorldMenu.refreshScreenSize()
			stateSettings.refreshScreenSize()
			stateSettingsVideo.refreshScreenSize()
			stateSettingsVideoShaders.refreshScreenSize()
			stateSettingsVideoDisplay.refreshScreenSize()
			stateSettingsAudio.refreshScreenSize()
		end
	end
end
o.update = function(dt)
	o.effectTimer = o.effectTimer + dt
	o.chromaticEffect = o.chromaticEffect + dt

	o.guiMenu.update(dt)

	if o.chkFullscreen.isHit() then
		love.sounds.playSound("sounds/button_pressed.wav")
		o.optionFullscreen = o.chkFullscreen.isChecked()
		local success = love.window.setFullscreen( o.optionFullscreen )
	end

	if o.comboLarge.active then
		o.holding = true
	end

	if not o.comboLarge.active and o.holding then
		--print "releasing"
		o.optionLarge = o.comboLarge.getSelection()
		o.checkOptionsLarge()
		o.holding = false
	end


	if o.btnBack.isHit() or love.keyboard.isDown("escape") then
		love.sounds.playSound("sounds/button_pressed.wav")
		love.setgamestate(7)
		o.guiMenu.flushMouse()
	end
end

o.draw = function()
	love.graphics.setFont(o.fontMenu)
	love.graphics.setBlendMode("alpha")
	love.graphics.setColor(255, 255, 255)
	love.graphics.draw(o.imgScreen)
	love.graphics.setColor(255, 255, 255, 223)
	love.graphics.draw(o.imgBackground)
	love.graphics.setColor(95 + math.sin(o.effectTimer * 0.1) * 63, 191 + math.cos(o.effectTimer) * 31, 223 + math.sin(o.effectTimer) * 31, 255)
	love.graphics.setBlendMode("additive")
	love.graphics.draw(o.imgMiddleground,(love.window.getWidth()-o.imgMiddleground:getWidth())*0.5,0)

	love.graphics.setBlendMode("alpha")
	love.graphics.setColor(0, 0, 0, 95)
	love.graphics.printf("Display", 4, 24 + 4, love.window.getWidth(), "center")
	love.graphics.setColor(255, 127, 0)
	love.graphics.setBlendMode("additive")
	love.graphics.printf("Display", 0, 24, love.window.getWidth(), "center")

	love.graphics.setFont(o.fontOption)
	o.guiMenu.draw()

	if math.random(0, love.timer.getFPS() * 5) == 0 then
		o.chromaticEffect = math.random(0, 5) * 0.1
	end

	if o.chromaticEffect < 1.0 then
		local colorAberration1 = math.sin(love.timer.getTime() * 10.0) * (1.0 - o.chromaticEffect) * 2.0
		local colorAberration2 = math.cos(love.timer.getTime() * 10.0) * (1.0 - o.chromaticEffect) * 2.0

		love.postshader.addEffect("chromatic", colorAberration1, colorAberration2, colorAberration2, -colorAberration1, colorAberration1, -colorAberration2)
	end
end

o.refreshScreenSize = function()
	local startx = love.window.getWidth() * 0.5 - 191 * 0.5
	local starty = 80

	o.chkFullscreen.setPosition(startx, starty + 64 * 0)
	o.comboLarge.setPosition(startx, starty + 64 * 1)
	o.btnBack.setPosition(startx + 8, starty + 64 * 5)
end

return o