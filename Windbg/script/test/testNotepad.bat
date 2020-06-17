::set _Echo=1
::set _Stack=%~nx0
@if {%_Echo%}=={1} ( @echo on ) else ( @echo off )
@@if defined _Stack @for %%a in ( 1 "%~nx0" "%0" ) do @if {"%%~a"}=={"%_Stack%"} @echo [      %~nx0] commandLine: %0 %*

set ProjectDir="%~1"

if not defined DefAppDir 		set DefAppDir=C:\temp
if not defined My_UserDbgParam 	set My_UserDbgParam=%~dp0startCmds_notepad.txt

if {%ProjectDir%}=={""} 	set ProjectDir="%DefAppDir%"
set AppPath=C:\Windows
where notepad.exe 1>nul 2>nul || set path=%path%;%AppPath%

if not exist "%AppPath%\notepad.exe" echo can't find "%AppPath%\notepad.exe" & goto :END

call %~dp0..\tools_windbg.bat dbgNewInstance "%AppPath%\notepad.exe"

:END
exit /b 0