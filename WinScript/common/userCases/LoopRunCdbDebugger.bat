::@set _Echo=0
::set _Stack=%~nx0
@if {"%_Echo%"}=={"1"} ( @echo on ) else ( @echo off )
@if defined _Stack @for %%a in ( 1 "%~nx0" "%0" ) do @if {"%%~a"}=={"%_Stack%"} @echo. & @echo [+++++ %~nx0] commandLine: %0 %*
where tools_path.bat 1>nul 2>nul || set "path=%~dp0;%path%"

set "Target=%~fs1"
if not exist "%Target%" (
@echo special application doesn't exist. 
pause
goto End
)

call tools_appInstallPath.bat FindPathWindbg _tmpWindbgPath
set "cdbCmdScript=%~sdp0..\..\Windbg\startCmds.dbg"
set "outDir=%~dp0Test\logs"
if not exist "%outDir%" md "%outDir%"

set LoopNum=%~2
if not defined LoopNum set LoopNum=3
@echo Debug target : %Target%
@echo Loop number  : %LoopNum%
for /L %%i in (1, 1, %LoopNum%) DO call "%_tmpWindbgPath%\cdb.exe" -kqm -failinc -cf "%cdbCmdScript%" -logo "%outDir%\debug_%%i.log" -G %Target%

:End
@if defined _Stack @for %%a in ( 1 "%~nx0" "%0" ) do @if {"%%~a"}=={"%_Stack%"} @echo [----- %~nx0] commandLine: %0 %* & @echo.

