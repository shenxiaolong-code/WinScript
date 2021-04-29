::Author    : Shen Xiaolong((xlshen@126.com))
::Copyright : free use,modify,spread, but MUST include this original two line information(Author and Copyright).

::@set _Echo=1
::set _Debug=1
::set _Stack=%~nx0
@if {"%_Echo%"}=={"1"} ( @echo on ) else ( @echo off )
@if defined _Stack @for %%a in ( 1 "%~nx0" "%0" ) do @if {"%%~a"}=={"%_Stack%"}  @echo. & @echo [+++++ %~nx0] commandLine: %0 %*
rem title length limited to 256 chars , else dos will report "Not enough memory resources are available to process this command"
@title %0 %* 2>nul
@where "%~nx0" 1>nul 2>nul || @set "path=%~dp0;%path%"

set cmds_%~n0="%~fs0" %*
if {"%~1"}=={""} call :Test NoOutput & goto End
call :%~1 %2 %3 %4 %5 %6 %7 %8 %9
goto :End

::******************************DOS API section**************************************************************************

::[DOS_API:dosAPIExample]Show corrent dos api example which can be documented automaticall.
::usage     : call :dosAPIExample possibleInputParam possibleOutputParam
::e.g.      : call :dosAPIExample "%~f0" bRet
::            call :dosAPIExample "%~f0" bRet "optParamer"
:dosAPIExample
@if defined _Stack @for %%a in ( 1 "%~nx0" "%0" ) do @if {"%%~a"}=={"%_Stack%"}  @echo [      %~nx0] commandLine: %0 %*
echo show one dos api example.
echo it can be documented automaticall by tools_miscellaneous.bat
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
goto :eof

:showFileCommandLine
@if defined _Stack @for %%a in ( 1 "%~nx0" "%0" ) do @if {"%%~a"}=={"%_Stack%"}  @echo [      %~nx0] commandLine: %0 %*
echo this script file command line :  cmds_%~n0
call echo %%cmds_%~n0%%
goto :eof

::*******************************************************************************************************************

:End
@if defined _Stack @for %%a in ( 1 "%~nx0" "%0" ) do @if {"%%~a"}=={"%_Stack%"}  @echo [----- %~nx0] commandLine: %0 %* & @echo.