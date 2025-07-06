::Author    : Shen Xiaolong((xlshen@126.com))
::Copyright : free use,modify,spread, but MUST include this original two line information(Author and Copyright).

::@set _Echo=1
::set _Debug=1
::set _Stack=%~nx0
@if {"%_Echo%"}=={"1"} ( @echo on ) else ( @echo off )
@if defined _Stack @for %%a in ( 1 "%~nx0" "%0" ) do @if {"%%~a"}=={"%_Stack%"}  @echo. & @echo [+++++ %~nx0] commandLine: %0 %*
rem title length limited to 256 chars , else dos will report "Not enough memory resources are available to process this command"
rem @title %0 %*
where "%~nx0" 1>nul 2>nul || set "path=%~dp0;%path%"

set cmds_%~n0="%~fs0" %*
if {"%~1"}=={""} call :Test NoOutput & goto End
call :%~1 %2 %3 %4 %5 %6 %7 %8 %9
goto :End

::******************************DOS API section**************************************************************************

::[DOS_API:getuserSID] get current user SID
::usage     : call :getuserSID outputSid
::e.g.      : call :getuserSID outputSid
::            set outputSid=S-1-5-21-3509152278-4230339519-3976194755-1001
:getuserSID
@if defined _Stack @for %%a in ( 1 "%~nx0" "%0" ) do @if {"%%~a"}=={"%_Stack%"}  @echo [      %~nx0] commandLine: %0 %*
:: or use slower wmic
:: wmic useraccount where name='%username%' get sid
:: WHOAMI /ALL  to show all information
for /f "tokens=1*" %%i in ('whoami /user ^| find /i "%username%" ') do call set %~1=%%~j
goto :eof


::******************************inner implement  section**************************************************************************


::******************************help  and test  section**************************************************************

::[DOS_API:Help]Display help information
:Help
@if defined _Stack @for %%a in ( 1 "%~nx0" "%0" ) do @if {"%%~a"}=={"%_Stack%"}  @echo [      %~nx0] commandLine: %0 %*
call tools_miscellaneous.bat DisplayHelp "%~f0"
goto :eof

::[DOS_API:Test]Test DOS API in this script file
:Test
@if defined _Stack @for %%a in ( 1 "%~nx0" "%0" ) do @if {"%%~a"}=={"%_Stack%"}  @echo [      %~nx0] commandLine: %0 %*
call :showFileCommandLine
echo.
@echo [%~nx0] Run test case [%0 %*]

echo.
echo test call :Help
call :Help

echo.
echo test call :getuserSID
call :getuserSID mySID
echo mySID=%mySID%

echo.
goto :eof

:showFileCommandLine
@if defined _Stack @for %%a in ( 1 "%~nx0" "%0" ) do @if {"%%~a"}=={"%_Stack%"}  @echo [      %~nx0] commandLine: %0 %*
echo this script file command line :  cmds_%~n0
call echo %%cmds_%~n0%%
goto :eof

::*******************************************************************************************************************

:End
@if defined _Stack @for %%a in ( 1 "%~nx0" "%0" ) do @if {"%%~a"}=={"%_Stack%"}  @echo [----- %~nx0] commandLine: %0 %* & @echo.