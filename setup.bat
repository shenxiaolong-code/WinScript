@if {"%_Echo%"}=={"1"} ( @echo on ) else ( @echo off )
@where tools_appInstallPath.bat 1>nul 2>nul || set "path=%~dps0common;%path%"
cls

echo.
echo. check administrator privilege
call tools_error.bat checkAdmin "%~fs0"

echo.
echo config root path ...
call :config.WinScriptPath
echo set WinScriptPath=%WinScriptPath%
where tools_path.bat 1>nul 2>nul || set path=%WinScriptPath%\common;%path%;

@echo.
goto :End

:config.WinScriptPath
call set WinScriptPath=%~dps0
call set WinScriptPath=%WinScriptPath:~0,-1%
call setx WinScriptPath "%WinScriptPath%"
goto :eof

:End
@echo ********************************************
@echo.
@echo setup complete,please check any error output and fix it.
@echo press any key to exit setup script. 
pause 1>nul 2>nul