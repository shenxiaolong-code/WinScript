@echo off

set cmds=%~nx0 %*
call :%~1 %2 %3 %4 %5 %6 %7 %8 %9
goto :END

:createFolder
if not  exist "%~f1" md "%~f1"
if not  exist "%~f1" echo Fails to create folder "%~f1"
goto :eof

:getDateString
set noEcho=1
::set dtFormat=yyyyMMdd_HHmmss
set dtFormat=yyyyMMdd
for /F "usebackq" %%i in ( ` powershell -Command "Get-Date -format %dtFormat%" ` ) do @echo %%i
goto :eof

:explorePath
explorer.exe /select, "%~f1"
goto :eof

:END
::if not defined noEcho echo %cmds%