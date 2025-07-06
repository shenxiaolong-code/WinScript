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

if {"%~1"}=={""} call :Test NoOutput & goto End
call :%~1 %2 %3 %4 %5 %6 %7 %8 %9
goto :End

::[DOS_API:Help]Display help information
:Help
@if defined _Stack @for %%a in ( 1 "%~nx0" "%0" ) do @if {"%%~a"}=={"%_Stack%"}  @echo [      %~nx0] commandLine: %0 %*
call tools_miscellaneous.bat DisplayHelp "%~f0"
goto :eof

::[DOS_API:Test]Test DOS API in this script file
:Test
@if defined _Stack @for %%a in ( 1 "%~nx0" "%0" ) do @if {"%%~a"}=={"%_Stack%"}  @echo [      %~nx0] commandLine: %0 %*
echo.
@echo [%~nx0] Run test case [%0 %*]

echo.
echo test call :Help
call :Help

echo.
goto :eof

::[DOS_API:filterSpecficModules]only keep symbol files list in second file filtetr
::usage     : call :filterSpecficModules <symbolManifestFile> <filterFile>
::e.g.      : call :filterSpecficModules "d:\symbolList.txt" "d:\msFilter.txt"
:filterSpecficModules
@if defined _Stack @for %%a in ( 1 "%~nx0" "%0" ) do @if {"%%~a"}=={"%_Stack%"}  @echo [      %~nx0] commandLine: %0 %*
set "_tmpTargetFile=%~f1"
set "_tmpBackupFile=%~dpn1_backup%~x1"
if not exist "%_tmpBackupFile%" rename "%_tmpTargetFile%" "%~n1_backup%~x1"
if exist "%_tmpTargetFile%" del /f/q "%_tmpTargetFile%"
for /f "usebackq tokens=* " %%i in ( ` type "%~fs2" ` ) do call :filterSpecficModules.addOne "%%~nxi"
goto :eof

:filterSpecficModules.addOne
@if defined _Stack @for %%a in ( 1 "%~nx0" "%0" ) do @if {"%%~a"}=={"%_Stack%"}  @echo [      %~nx0] commandLine: %0 %*
type "%_tmpBackupFile%" | find /i "%~1" 2>nul >> "%_tmpTargetFile%"
goto :eof


::[DOS_API:keepMsBasic]only keep basic symbol files list
::usage     : call :keepMsBasic <symbolManifestFile>
::e.g.      : call :keepMsBasic "d:\symbolList.txt"
:keepMsBasic
@if defined _Stack @for %%a in ( 1 "%~nx0" "%0" ) do @if {"%%~a"}=={"%_Stack%"}  @echo [      %~nx0] commandLine: %0 %*
call :filterSpecficModules "%~f1" "%~dp0msBasicModule.txt"
goto :eof

:End
@if defined _Stack @for %%a in ( 1 "%~nx0" "%0" ) do @if {"%%~a"}=={"%_Stack%"}  @echo [----- %~nx0] commandLine: %0 %* & @echo.