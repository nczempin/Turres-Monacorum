
@ECHO OFF
md buildtmp
::copy localconfig.lua.dist "%~dp0\buildtmp\localconfig.lua"
copy readme.md "%~dp0\buildtmp\readme.txt"
"D:\Program Files\7-Zip\7z" -r a -tzip .\buildtmp\game.love .\love2d\*.*
copy "buildmaterial\lovewin64\*.*" "buildtmp\"
copy /b "buildtmp\love.exe"+"buildtmp\game.love" "buildtmp\tm.exe"
::del ".\buildtmp\game.love"
::del ".\buildtmp\love.exe"
"D:\Program Files\7-Zip\7z" -r a -tzip .\tm.zip .\buildtmp\*.*
::rd /s /q buildtmp
pause