::Author    : Shen Xiaolong((xlshen@126.com))
::Copyright : free use,modify,spread, but MUST include this original two line information(Author and Copyright).

::@set _Echo=1
::set _Stack=%~nx0
@if {"%_Echo%"}=={"1"} ( @echo on ) else ( @echo off )
@if defined _Stack @for %%a in ( 1 "%~nx0" "%0" ) do @if {"%%~a"}=={"%_Stack%"} @echo. & @echo [+++++ %~nx0] commandLine: %0 %*
where "%~nx0" 1>nul 2>nul || set "path=%~dp0;%path%"

if {%1}=={} call :Test  & goto End
::if {%1}=={} call :Test NoOutput & goto End

call :%1 %2 %3 %4 %5 %6 %7 %8 %9
goto End

::[DOS_API:getFullName]get full path name by schedule task short name. the full path name is need in /TN option of schtasks
::usage     : call :getFullName schedulerShortName TestVar
::call e.g. : call :getFullName "RemoteAssistanceTask"
::result e.g: set TestVar="\Microsoft\Windows\RemoteAssistance\RemoteAssistanceTask"
:getFullName
@if defined _Stack @for %%a in ( 1 "%~nx0" "%0" ) do @if {"%%~a"}=={"%_Stack%"} @echo [      %~nx0] commandLine: %0 %*
if {"%~1"}=={""} call tools_message.bat popMsg  "process name is empty,function 'getPIDByName' fails " & goto :eof
goto :eof
schtasks /query /FO list | find "RemoteAssistanceTask"
call tools_miscellaneous.bat Clear_Environment_Variable tmpGetPIDByName
for /f "usebackq tokens=1,2" %%i in ( `wmic process where (name^="%~1"^)  get name^,handle ^| find  "%~1" ` ) do ( set tmpGetPIDByName=%%i )
if {"%~2"}=={""} (
echo %tmpGetPIDByName%
) else (
set %~2=%tmpGetPIDByName%
)
goto :eof

::[DOS_API:Help]display help information
:Help
@if defined _Stack @for %%a in ( 1 "%~nx0" "%0" ) do @if {"%%~a"}=={"%_Stack%"} @echo [      %~nx0] commandLine: %0 %*
call tools_miscellaneous.bat DisplayHelp "%~f0"
goto :eof

::[DOS_API:Test]Test DOS API in this script file
:Test
@if defined _Stack @for %%a in ( 1 "%~nx0" "%0" ) do @if {"%%~a"}=={"%_Stack%"} @echo [      %~nx0] commandLine: %0 %*
@echo [%~nx0] Run test case [%0 %*]
echo.
echo test call :Help
call :Help
echo.
goto :eof

:End
@if defined _Stack @for %%a in ( 1 "%~nx0" "%0" ) do @if {"%%~a"}=={"%_Stack%"} @echo [----- %~nx0] commandLine: %0 %* & @echo.
exit /b %iRet%