@if {"%_Echo%"}=={"1"} ( @echo on ) else ( @echo off )
echo %0 %*
set toolDir=%myWinScriptPath%\common

:InputVhdFile
echo.
@echo pls input vhd file path:
set /p vhdFile=
call :checkVhdFile "%vhdFile%"
if exist %vhdFile% @echo %vhdFile% exist, can't create. & goto :InputVhdFile

:InputDriverChar
echo below existing drive char is not available:
fsutil fsinfo drives | find /i "Drives"
@echo pls input drive char:
call "%toolDir%tools_string.bat" getChoiceSelected cdefghijklmnopqrstuvwxyz driverChar
if exist %driverChar%:\ echo %driverChar%: is existing, cann't recreate. & goto :InputDriverChar

set newVhd_driveLetter=%driverChar%
set newVhd_vhdFile=%vhdFile%
call "%toolDir%makeVirtualBootDisk.bat"
goto :End

:checkVhdFile
set vhdFile=%~dp1%~n1.vhd
goto :eof

:End
