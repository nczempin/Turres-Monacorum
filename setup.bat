@echo off

REM Ensure Microsoft Visual C++ compiler is available
where cl >nul 2>&1
if errorlevel 1 (
    echo The Microsoft C compiler 'cl.exe' was not found.
    echo Please install the Visual Studio Build Tools before continuing.
    echo https://visualstudio.microsoft.com/visual-cpp-build-tools/
    echo Skipping compilation steps and LuaRocks installation.
    goto :eof
)

REM Compilation and LuaRocks installation steps go here
REM Example:
REM luarocks install luafilesystem

