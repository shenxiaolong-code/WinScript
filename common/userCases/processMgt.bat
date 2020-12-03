::@set _Echo=0
::set _Stack=%~nx0
@if {"%_Echo%"}=={"1"} ( @echo on ) else ( @echo off )
@if defined _Stack @for %%a in ( 1 "%~nx0" "%0" ) do @if {"%%~a"}=={"%_Stack%"} @echo. & @echo [+++++ %~nx0] commandLine: %0 %*
where "%~nx0" 1>nul 2>nul || set "path=%~dp0;%path%"

::
::******************************************************
::This script is used to change service by list file.
::Usage : processMgt.bat file.txt start
:: 		: processMgt.bat file.txt stop
::Author : shen xiaolong
::******************************************************

rem **********************user config******************************************
set ProcessList="%~s1"
echo Application list file : "%~f1"

rem **********************Script execute******************************************
set iRet=0
if not exist %ProcessList% @echo process list file doesn't exist. No process is changed. & set iRet=2 & goto ERR
if {"%~2"}=={"start"} ( for /f "usebackq eol=; tokens=*" %%i in ( %ProcessList% ) do call tools_process.bat startProcess %%i )	& goto End
if {"%~2"}=={"stop"} ( for /f "usebackq eol=; tokens=*" %%i in ( %ProcessList% ) do call tools_process.bat killProcess %%i )		& goto End
call tools_message.bat popMsg "Wrong 2nd parameter[%2],2nd parameter MUST be start or stop." & call tools_miscellaneous.bat SetErrorColor & goto Quit

:End
@echo.
@echo processMgt.bat Execute completed!
@echo. 
goto Quit

:Quit
@if defined _Stack @for %%a in ( 1 "%~nx0" "%0" ) do @if {"%%~a"}=={"%_Stack%"} @echo [----- %~nx0] commandLine: %0 %* & @echo.

