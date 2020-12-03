::@set _Echo=0
::set _Stack=%~nx0
@if {"%_Echo%"}=={"1"} ( @echo on ) else ( @echo off )
@if defined _Stack @for %%a in ( 1 "%~nx0" "%0" ) do @if {"%%~a"}=={"%_Stack%"} @echo. & @echo [+++++ %~nx0] commandLine: %0 %*

@echo.
@echo ******************************************************
@echo This script is used to set default JIT (Just-In-Time) debuger windbg ^| ntsd ^| cdb ^| Drwatsn ^| Vs2008.
@echo This script is used to set default debug mode : auto attach debugger or manual.
@echo Note: need administrator privileges to run this script!
@echo Author : shen xiaolong
@echo ******************************************************
@echo.

set dbgKey="HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\AeDebug"
set querykey_dbger=%dbgKey% /v Debugger
set querykey_startMode=%dbgKey% /v Auto

setlocal enabledelayedexpansion
set toolDir=%~dp0
reg QUERY  %querykey_dbger% >nul 2>nul && set regQueryResult=0 || set regQueryResult=1
if {!regQueryResult!}=={1} (
echo No default debugger  
) else ( 
for /f "usebackq tokens=3" %%i in ( ` reg QUERY  %querykey_dbger% ` ) do echo current debugger : %%i 
)
:LOOP
if not {%1}=={} ( set select=%1) else (
@echo pls set debugger option or set default debugger:
@echo 0. Clean debugger
@echo 1. enable auto attach debugger
@echo 2. disable auto attach debugger
@echo --------------------------------
@echo 3. Windbg
@echo 4. ntsd
@echo 5. cdb
@echo 6. Dr.Watson
@echo 7. Vs2008
@echo 8. exit
@echo.
echo pls select action:
call "%toolDir%tools_string.bat" getChoiceSelected 012345678 select
)
if {!select!}=={0} reg  delete %querykey_dbger% /f
if {!select!}=={1} reg  add %querykey_startMode% /t reg_sz /d "1" /f
if {!select!}=={2} reg  add %querykey_startMode% /t reg_sz /d "0" /f
if {!select!}=={3} windbg -IS
if {!select!}=={4} ntsd -iae
if {!select!}=={5} cdb -iae
if {!select!}=={6} @echo current OS doesn't support command ( drwtsn32 ¨Ci ).
if {!select!}=={7} reg  add %querykey_dbger% /t reg_sz /d "%windir%\system32\vsjitdebugger.exe -p %ld" /f
if {!select!}=={8} @echo exit application. & exit /b 0

for /f "usebackq tokens=3" %%i in ( ` reg QUERY  %querykey_dbger% ` ) do echo current debugger : %%i
echo.
goto :LOOP

:End
@if defined _Stack @for %%a in ( 1 "%~nx0" "%0" ) do @if {"%%~a"}=={"%_Stack%"} @echo [----- %~nx0] commandLine: %0 %* & @echo.
call tools_message.bat noSleepMsg "%~0" 5
exit /b 0  