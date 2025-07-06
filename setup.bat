:: set _Echo=1
@if {"%_Echo%"}=={"1"} ( @echo on ) else ( @echo off )
@where tools_appInstallPath.bat 1>nul 2>nul || set "path=%~dps0common;%path%"
cls


echo.
echo. check administrator privilege
call tools_error.bat checkAdmin "%~fs0"

echo.
echo config root path myWinScriptPath ...
call :config.myWinScriptPath
echo set myWinScriptPath=%myWinScriptPath%
where tools_path.bat 1>nul 2>nul || set "path=%myWinScriptPath%\common;%path%;"

echo.
echo config root path myRepoRoot ...
call :config.myRepoRoot
echo set myRepoRoot=%myRepoRoot%

echo.
echo config root path myPcToolsPath...
call :config.myPcToolsPath
echo set myPcToolsPath=%myPcToolsPath%
where regfind.exe 1>nul 2>nul || set "path=%myPcToolsPath%;%path%;"

echo.
echo config my environment backup path ...
call :config.myEnv
echo set myEnv=%myEnv%

echo.
echo setup auto-loaded cmds and alias ...
call %myWinScriptPath%\userSetting\win_alias\win_cmd_alias.install.bat

@echo.
goto :End

:config.myEnv
if not defined OneDriveConsumer call :Error "the oneDrive is not installed. fails to call :config.myEnv"
call set "myOneDrive=%OneDriveConsumer%"
call setx myOneDrive "%myOneDrive%"
call set "myEnv=%OneDriveConsumer%\softwares\win_setting"
call setx myEnv "%myEnv%"
set "myTempDir=C:\temp"
if not exist "%myTempDir%" mkdir %myTempDir%
call set "myTempDir=%myTempDir%"
call setx myTempDir "%myTempDir%"
goto :eof

:config.myWinScriptPath
call set "myWinScriptPath=%~dp0"
call set "myWinScriptPath=%myWinScriptPath:~0,-1%"
call setx myWinScriptPath "%myWinScriptPath%"
goto :eof

:config.myRepoRoot
call set "myRepoRoot=%~dp0"
call set myRepoRoot=%myRepoRoot:\shenxiaolong=&;rem%
call setx myRepoRoot "%myRepoRoot%"
goto :eof

:config.myPcToolsPath
if not defined OneDriveConsumer call :Error "the oneDrive is not installed. fails to call :config.myPcToolsPath"
call set "myPcToolsPath=%OneDriveConsumer%\softwares\pc_tools"
call tools_error.bat checkPathExist "%myPcToolsPath%"  "%~f0" checkPathExistMark
call setx myPcToolsPath "%myPcToolsPath%"
call setx Path "%myPcToolsPath%;%Path%"
:: @where regfind.exe 1>nul 2>nul || call setx "path=%myPcToolsPath%;%path%"
goto :eof

:Error
echo %*
echo press any key to exit.
pause > nul
exit
goto :eof

:End
@echo ********************************************
@echo.
@echo setup complete,please check any error output and fix it.
@echo press any key to exit setup script. 
pause 1>nul 2>nul