-- Luacheck configuration for Turres-Monacorum (Love2D tower defense game)

-- Standard Love2D globals
globals = {
    -- Love2D core modules and functions
    "love", "dt",
    
    -- Love2D modules (commonly used directly)
    "audio", "data", "event", "filesystem", "font", "graphics", 
    "image", "joystick", "keyboard", "math", "mouse", "physics", 
    "sound", "system", "timer", "window",
    
    -- Game-specific globals (from main.lua and game state management)
    "G", "W", "T", "S", "FS",  -- Love2D module shortcuts
    
    -- Game state globals
    "game", "world", "player", "map", "towers", "enemies", "spawn",
    "settings", "graphics_settings", "sound_settings",
    "states", "currentState", "stateStack",
    
    -- Tower defense specific
    "towerTypes", "enemyTypes", "weaponSounds", "explosionSounds",
    "towerCosts", "upgradeCosts", "damageTypes",
    
    -- Graphics and rendering
    "camera", "shader", "canvas", "lightWorld", "materialShader",
    "normalShader", "postShader", "reflection", "refraction",
    
    -- Color and styling constants
    "colors", "fonts", "themes", "ui_colors",
    
    -- Utility globals
    "util", "vector", "collision", "pathfinding", "ai",
    "serialize", "deserialize", "deepcopy",
    
    -- Audio system
    "soundEngine", "musicEngine", "TEsound",
    
    -- GUI system
    "gui", "button", "checkbox", "combobox", "radiobutton",
    
    -- Animation system
    "anim", "animations", "tweens",
    
    -- Mission and level system
    "missions", "levels", "difficulty", "progression",
    
    -- External libraries
    "TSerial", "Jumper", "grid", "pathfinder"
}

-- Read-only globals (should not be assigned to)
read_globals = {
    -- Love2D callbacks that we define but don't assign to
    "conf",
    
    -- External library exports
    "TEsound", "TSerial",
    
    -- Standard Lua libraries we might use
    "table", "string", "math", "io", "os", "debug", "coroutine", "package"
}

-- Files to ignore completely
exclude_files = {
    "buildmaterial/**",
    "resources/**", 
    "javascript/**",
    "**/node_modules/**",
    "love2d/external/**"  -- External libraries should not be linted
}

-- Per-file configurations
files = {
    -- External libraries should have relaxed rules
    ["love2d/external/*.lua"] = {
        ignore = {".*"}  -- Ignore all warnings for external libraries
    },
    
    -- Configuration files might have unusual patterns
    ["love2d/conf.lua"] = {
        globals = {"conf"}
    },
    
    -- Main entry point
    ["love2d/main.lua"] = {
        globals = {"love.load", "love.update", "love.draw", "love.keypressed", 
                  "love.keyreleased", "love.mousepressed", "love.mousereleased"}
    },
    
    -- Core game files that define major systems
    ["love2d/game.lua"] = {
        globals = {"game"}
    },
    ["love2d/world.lua"] = {
        globals = {"world"}
    },
    ["love2d/player.lua"] = {
        globals = {"player"}
    }
}

-- General settings
std = "lua51"  -- Love2D uses Lua 5.1
cache = true
codes = true

-- Warnings to ignore
ignore = {
    "212",  -- Unused argument (common in Love2D callbacks)
    "213",  -- Unused loop variable (common in game loops)
    "614",  -- Trailing whitespace in comments
}

-- Maximum line length (Love2D projects often have longer lines due to graphics code)
max_line_length = 120

-- Allow unused variables starting with underscore
unused_args = false
unused = false