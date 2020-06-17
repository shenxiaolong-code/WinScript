@echo off
cls
cd /d "%~dp0"

call :msbuild.debug
goto :End

:msbuild.debug
call :config.enableDebug
call :config.path
call :msbuild.debugProject
goto :eof

:config.enableDebug
::https://www.cnblogs.com/rickerliang/p/4775341.html
@echo.
@echo enable MsBuild Debug feature in registry or environemt varaible
call :config.enableDebug.evnVar
goto :eof

:config.enableDebug.registry
@echo.
@echo enable msbuild debug capiability in registry "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\MSBuild\4.0"
@echo y | reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\MSBuild\4.0" /v DebuggerEnabled /d true
start "" "%~fs0" msbuild.debug
goto :eof

:config.enableDebug.evnVar
@echo.
set MSBUILDDEBUGONSTART=1
set MSBUILDDEBUGGING=1
goto :eof

:config.path
@echo.
@echo check msbuild capiability
::cd /d "C:\Windows\Microsoft.NET\Framework"
for /f "usebackq tokens=*" %%a in ( ` dir/b/s C:\Windows\Microsoft.NET\Framework\v4* ` ) do cd /d "%%a"
set msbuildPath=%cd%
@echo msbuild directory :  %msbuildPath%
::msbuild.exe /?
goto :eof

:msbuild.debugProject
@echo.
@echo prepare to debug project
cd /d "D:\jabberTrunk\products\jabber-win\src\wclDll\build\windows"
where msbuild.exe 1>nul 2>nul || set path=%msbuildPath%;%path%;
where msbuild.exe
::cd /d "%~dp0"
msbuild.exe /t:build /debug WCLDll.vcxproj
goto :eof

:End

