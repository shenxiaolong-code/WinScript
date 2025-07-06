::this scrip is used to register or un-register one dll file.
::register dll example : regDLL.bat abc.dll 1
::un-register dll example : regDLL.bat abc.dll 0 s
::author : shen xiaolong

::@set _Echo=0
::set _Stack=%~nx0
@if {"%_Echo%"}=={"1"} ( @echo on ) else ( @echo off )
@if defined _Stack @for %%a in ( 1 "%~nx0" "%0" ) do @if {"%%~a"}=={"%_Stack%"} @echo. & @echo [+++++ %~nx0] commandLine: %0 %*
where "%~nx0" 1>nul 2>nul || set "path=%~dp0;%path%"

::*********************************Exe*********************************
set ret=1;
if not exist %1 call popMsgWithTimeout.bat 5 "File %1 doesn't exist" & goto Err

call :FindReger
if not exist %Reger% call popMsgWithTimeout.bat 5 "Can't find regsvr32.exe" & goto Err

if {%3}=={s} ( set regMode=/s ) else ( set regMode= )

if {%2}=={1} %Reger% %regMode% %1
if {%2}=={0} %Reger% /u %regMode% %1
set ret=0
goto End

:FindReger
call tools_miscellaneous.bat getCmdOutput "where regsvr32.exe" Reger
goto :eof

:ERR
set ret=1
goto End

:End
@if defined _Stack @for %%a in ( 1 "%~nx0" "%0" ) do @if {"%%~a"}=={"%_Stack%"} @echo [----- %~nx0] commandLine: %0 %* & @echo.
exit /b %ret%