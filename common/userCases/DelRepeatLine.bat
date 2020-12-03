::@set _Echo=0
::set _Stack=%~nx0
@if {"%_Echo%"}=={"1"} ( @echo on ) else ( @echo off )
@if defined _Stack @for %%a in ( 1 "%~nx0" "%0" ) do @if {"%%~a"}=={"%_Stack%"} @echo. & @echo [+++++ %~nx0] commandLine: %0 %*

if not exist %1 @echo file doesn't exist & goto END
set InFile=%1

set OutFile=%1.txt
if not {%2}=={} set OutFile=%2
@echo Execute command : %0 %1 %OutFile%

setlocal enabledelayedexpansion
rem for /F "eol=; delims= " %%i IN (%InFile%) do if not defined %%i set %%i=n && echo %%i >> %OutFile%
for /F "eol=; delims= " %%i IN (%InFile%) do if not defined %%~ni ( set %%~ni=n && echo %%i && echo %%i >> %OutFile% )

@echo Deleting repeated lines completed sucessfully

:END
@if defined _Stack @for %%a in ( 1 "%~nx0" "%0" ) do @if {"%%~a"}=={"%_Stack%"} @echo [----- %~nx0] commandLine: %0 %* & @echo.