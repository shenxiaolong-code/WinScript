::@set _Echo=0
::set _Stack=%~nx0
@if {"%_Echo%"}=={"1"} ( @echo on ) else ( @echo off )
@if defined _Stack @for %%a in ( 1 "%~nx0" "%0" ) do @if {"%%~a"}=={"%_Stack%"} @echo. & @echo [+++++ %~nx0] commandLine: %0 %*

::http://www.vistax64.com/tutorials/67717-take-ownership-file.html
if not exist "%*" @echo file or folder(%*) doesn't exist & goto END
set InFile="%~1"

@echo take ownership of %InFile%
takeown.exe /f %InFile%

@echo set current user(%USERNAME%) as the owner of file/folder(%InFile%)
ICACLS %InFile% /setowner %USERNAME% /T

@echo grant all access right
ICACLS %InFile% /grant %USERNAME%:F

:END
@if defined _Stack @for %%a in ( 1 "%~nx0" "%0" ) do @if {"%%~a"}=={"%_Stack%"} @echo [----- %~nx0] commandLine: %0 %* & @echo.