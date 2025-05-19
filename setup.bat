@echo off
REM Install system packages using Chocolatey if available
where choco >NUL 2>&1
if %ERRORLEVEL%==0 (
    choco install -y love luarocks
)

REM Install Lua modules using LuaRocks
where luarocks >NUL 2>&1
if %ERRORLEVEL%==0 (
    for /F "tokens=1,2" %%A in (luarocks-requirements.txt) do (
        luarocks install %%A %%B
    )
) else (
    echo LuaRocks not found; please install it first.
)
