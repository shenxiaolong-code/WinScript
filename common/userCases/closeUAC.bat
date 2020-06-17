::@set _Echo=0
::set _Stack=%~nx0
@if {%_Echo%}=={1} ( @echo on ) else ( @echo off )
@if defined _Stack @for %%a in ( 1 "%~nx0" "%0" ) do @if {"%%~a"}=={"%_Stack%"} @echo. & @echo [+++++ %~nx0] commandLine: %0 %*

:: this script is used to close UAC (user access control)
call :generateUACReg.disable
call "%~dp0..\tools_reg.bat" importRegFile "%_tmpRegFile%"  bOK
if {"%bOK%"}=={"0"} call :openUACWindow
goto :End

:generateUACReg.disable
set "_tmpRegFile=%temp%\disableUAC.reg"
(
echo Windows Registry Editor Version 5.00
echo.
echo [HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System]
echo "ConsentPromptBehaviorAdmin"=dword:00000000
echo "EnableLUA"=dword:00000000
) > "%_tmpRegFile%"
goto :eof

:generateUACReg.enable
set "_tmpRegFile=%temp%\enableUAC.reg"
(
echo Windows Registry Editor Version 5.00
echo.
echo [HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System]
echo "ConsentPromptBehaviorAdmin"=dword:00000005
echo "EnableLUA"=dword:00000001
) > "%_tmpRegFile%"
goto :eof

:openUACWindow
call %windir%\System32\UserAccountControlSettings.exe
goto :eof

:End
@if defined _Stack @for %%a in ( 1 "%~nx0" "%0" ) do @if {"%%~a"}=={"%_Stack%"} @echo [----- %~nx0] commandLine: %0 %* & @echo.