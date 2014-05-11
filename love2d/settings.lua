
function loadOptions()
	local optionsIni = "options.ini"

	if (FS.exists(optionsIni))then
		local f1 = function(setting)
			local param = string.find(setting, "true")
			stateSettingsVideoDisplay.optionFullscreen = param
			stateSettingsVideoDisplay.chkFullscreen.checked = param --TODO: this should be done inside the settings page
		end
		local f2= function(setting)
			stateSettingsVideoDisplay.optionLarge=setting --TODO this needs to be sanitized
			local resolutionIndex = stateSettingsVideoDisplay.findResolution(setting)
			stateSettingsVideoDisplay.comboLarge.updateSelection(resolutionIndex)
		end
		local options = {{name="display.video.fullscreen", execute= f1},{name="display.video.resolution",execute = f2}}
		local optionLines = {}
		local lines = {}

		for line in love.filesystem.lines(optionsIni) do
			table.insert(lines, line)
		end

		for i,line in ipairs(lines)do
			for j,option in ipairs(options) do
				local m1, m2 = string.find(line, option.name.."=")
				print (i, m1,m2)
				if m2 then

					local setting = string.sub(line, m2+1)
					--TODO: can/should we change the options in conf.lua from here?
					option.execute(setting)
					--stateSettingsVideoDisplay.optionLarge = stateSettingsVideoDisplay.resolutionStrings[2] --TODO: this should really be handled inside the display settings module
					--	stateSettingsVideoDisplay.optionLarge =  stateSettingsVideoDisplay.resolutionStrings[3]--TODO: this should really be handled inside the display settings module
				end
			end
		end
	end
	print ("possibly changing resolution/fullscreen")
	stateSettingsVideoDisplay.checkOptionsLarge() --TODO: provide a function that changes the option and immediately switches
end
function saveOptions()
	local optionsIni = "options.ini"
	local data = ""
	local f1 = function(setting)
		local param =stateSettingsVideoDisplay.optionFullscreen or false
		data = data..setting.."="..tostring(param).."\n"
	end
	local f2= function(setting)
		local width, height, flags = love.window.getMode()
		local param = width.."x"..height

		data = data..setting.."="..tostring(param).."\n"
	end
	local options = {{name="display.video.fullscreen", execute= f1},{name="display.video.resolution",execute = f2}}
	for _, option in ipairs(options) do
		option.execute(option.name)
	end

	love.filesystem.rename(optionsIni,optionsIni.."_old")
	local success = love.filesystem.write( optionsIni, data )
	print ("success: ", success)
	print (love.filesystem.getSaveDirectory())
	print (love.filesystem.getUserDirectory())
	print (love.filesystem.getWorkingDirectory())
	--FIXME: this is just code copied from loadOptions()
	local option = "display.large"
	local optionLines = {}
	local lines = {}

	--	for line in love.filesystem.lines(optionsIni) do
	--		table.insert(lines, line)
	--	end
	--
	--	for i,line in ipairs(lines)do
	--		local m1, m2 = string.find(line, option.."=")
	--		print (i, m1,m2)
	--		if m2 then
	--
	--			local setting = string.sub(line, m2+1)
	--			--TODO: can/should we change the options in conf.lua from here?
	--			if string.find(setting, "true")then
	--				print "large"
	--				stateSettingsVideoDisplay.optionLarge = stateSettingsVideoDisplay.resolutionStrings[2] --TODO: this should really be handled inside the display settings module
	--			else
	--				print "not large"
	--				stateSettingsVideoDisplay.optionLarge =  stateSettingsVideoDisplay.resolutionStrings[3]--TODO: this should really be handled inside the display settings module
	--			end
	--			stateSettingsVideoDisplay.checkOptionsLarge() --TODO: provide a function that changes the option and immediately switches
	--		end
	--
	--	end
end