::Author    : Shen Xiaolong((xlshen@126.com))
::Copyright : free use,modify,spread, but MUST include this original two line information(Author and Copyright).

::@set _Echo=1
::set _Stack=%~nx0
::set _Debug=1
@if {"%_Echo%"}=={"1"} ( @echo on ) else ( @echo off )
@if defined _Stack @for %%a in ( 1 "%~nx0" "%0" ) do @if {"%%~a"}=={"%_Stack%"} @echo. & @echo [+++++ %~nx0] commandLine: %0 %*
where "%~nx0" 1>nul 2>nul || set "path=%~dp0;%path%"

if {%1}=={} call :Test NoOutput & goto End
call :%~1 %2 %3 %4 %5 %6 %7 %8 %9
goto End

::[DOS_API:Help]display help information
:Help
@if defined _Stack @for %%a in ( 1 "%~nx0" "%0" ) do @if {"%%~a"}=={"%_Stack%"} @echo [      %~nx0] commandLine: %0 %*
where tools_miscellaneous.bat 1>nul 2>nul || set path=%~dp0..\..\common;%path%;
call tools_miscellaneous.bat DisplayHelp "%~f0"
start "" "https://docs.microsoft.com/en-us/windows/win32/wer/wer-settings"
goto :eof

::[DOS_API:Test] Test DOS API in this script file
:Test
@if defined _Stack @for %%a in ( 1 "%~nx0" "%0" ) do @if {"%%~a"}=={"%_Stack%"} @echo [      %~nx0] commandLine: %0 %*
@echo [%~nx0] Run test case [%0 %*]
echo.
echo test call :Help
call :Help
echo.

echo.
set "regFile=%temp%\myApp.exe\DebugAppLaunch.reg"
echo test DebugAppLaunch.Generate myApp.exe "%regFile%" "C:\PROGRA~2\WI3CF2~1\10\DEBUGG~1\x86\windbg.exe"
call :DebugAppLaunch.Generate myApp.exe "%regFile%" "C:\PROGRA~2\WI3CF2~1\10\DEBUGG~1\x86\windbg.exe"
echo generated regFile : %regFile%
type "%regFile%"
echo.

echo.
echo test DebugAppLaunch.Cancel myApp.exe
call :DebugAppLaunch.Cancel myApp.exe
echo query "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\myApp.exe"
reg query "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\myApp.exe"
echo.

echo.
set "regFile=%temp%\myApp.exe\MonitorAppExit.reg"
echo test MonitorAppExit.Generate myApp.exe "%regFile%" "D:\shenxiaolong\core\WinScript\Test\test1.bat"
call :MonitorAppExit.Generate myApp.exe "%regFile%" "D:\shenxiaolong\core\WinScript\Test\test1.bat"
echo generated regFile : %regFile%
type "%regFile%"
echo.

echo.
echo test MonitorAppExit.Cancel myApp.exe
call :MonitorAppExit.Cancel myApp.exe
echo query "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\SilentProcessExit\myApp.exe"
reg query "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\SilentProcessExit\myApp.exe"
echo.

echo.
set "regFile=%temp%\myApp.exe\LocalExceptDump.reg"
echo test LocalExceptDump.Generate myApp.exe "%regFile%" D:\tempDir
call :LocalExceptDump.Generate myApp.exe "%regFile%" D:\tempDir
echo generated regFile : %regFile%
type "%regFile%"
echo.

echo.
echo test LocalExceptDump.Cancel myApp.exe
call :LocalExceptDump.Cancel myApp.exe
echo query "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\Windows Error Reporting\LocalDumps\myApp.exe"
reg query "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\Windows Error Reporting\LocalDumps\myApp.exe"
echo.

echo.
goto :eof

::************************************************************************************************

::[DOS_API:DebugAppLaunch.Generate] generate reg file which is used to debug application automatically when this application launchs.
::usage         : DebugAppLaunch.Generate appName.exe  regfile [debbuggerFullpath]
::e.g.          : DebugAppLaunch.Generate myApp.exe  outRegfile "C:\PROGRA~2\WI3CF2~1\10\DEBUGG~1\x86\windbg.exe"
:DebugAppLaunch.Generate
@if defined _Stack @for %%a in ( 1 "%~nx0" "%0" ) do @if {"%%~a"}=={"%_Stack%"} @echo [      %~nx0] commandLine: %0 %*
call :DebugAppLaunch.Generate.configPath %*
set "generateReg_in=%~dp0template\debugAppLaunch.reg"
call :getOutputRegFile DebugAppLaunch generateReg_out "%~1" "%~2"
call :generateReg "%~nx1" "%windbgPath%" "%windbgThemePath%" "%windbgScriptPath%"
call tools_error.bat checkFileExist "%generateReg_out%" "%~f0" AppLaunch.enable_mark1
call set "%~2=%generateReg_out%"
goto :eof

:DebugAppLaunch.Generate.configPath
@if defined _Stack @for %%a in ( 1 "%~nx0" "%0" ) do @if {"%%~a"}=={"%_Stack%"} @echo [      %~nx0] commandLine: %0 %*
rem config WinScript path
set "WinScriptPath=%~f0"
set WinScriptPath=%WinScriptPath:\Windbg\=&rem;%
where tools_userInput.bat 1>nul 2>nul || set "path=%WinScriptPath%\common;%path%"
call tools_message.bat enableDebugMsg "%~0" "WinScriptPath=%WinScriptPath%"
rem config windbg.exe path
call :DebugAppLaunch.Generate.configPath.windbg %*
call tools_message.bat enableDebugMsg "%~0" "windbgPath=%windbgPath%"
call tools_reg.bat makeRegPath "%windbgPath%"  windbgPath
rem config theme file path
if defined windbgThemePath%~n1 call set "windbgThemePath=%%windbgThemePath%~n1%%"
if not defined windbgThemePath set "windbgThemePath=%WinScriptPath%\Windbg\setup\layout_theme\dark_theme.wew"
call tools_error.bat checkFileExist "%windbgThemePath%" "%~f0" configPath_mark1
call tools_message.bat enableDebugMsg "%~0" "windbgThemePath=%windbgThemePath%"
call tools_reg.bat makeRegPath "%windbgThemePath%"  windbgThemePath
rem config start file path
if defined windbgScriptPath_%~n1 call set "windbgScriptPath=%%windbgScriptPath_%~n1%%"
if not defined windbgScriptPath set "windbgScriptPath=%WinScriptPath%\Windbg\script\startCmds.dbg"
call tools_error.bat checkFileExist "%windbgScriptPath%" "%~f0" configPath_mark2
call tools_message.bat enableDebugMsg "%~0" "windbgScriptPath=%windbgScriptPath%"
call tools_reg.bat makeRegPath "%windbgScriptPath%"  windbgScriptPath
goto :eof

:DebugAppLaunch.Generate.configPath.windbg
@if defined _Stack @for %%a in ( 1 "%~nx0" "%0" ) do @if {"%%~a"}=={"%_Stack%"} @echo [      %~nx0] commandLine: %0 %*
set "windbgPath=%~fs3"
if defined windbgPath if exist "%windbgPath%" goto :eof
rem config windbg.exe path
if not exist "%~fs1"    if not defined modType set  modType=x86
if      exist "%~fs1"   call tools_isX86X64.bat IsX86OrX64Mod "%~fs1" modType
where windbg.exe 1>nul 2>nul || call tools_appInstallPath.bat FindPathWindbg _dbgPath
if 		defined _dbgPath set "windbgPath=%_dbgPath%\%modType%\windbg.exe"
if not 	defined _dbgPath for /f "tokens=*" %%i in ( "windbg.exe" ) do set "windbgPath=%%~fs$path:i"
call tools_error.bat checkFileExist "%windbgPath%" "%~f0" configPath_mark0
goto :eof

::[DOS_API:DebugAppLaunch.Cancel] cancel registry setting which is generated by DOS API DebugAppLaunch.Generate
::usage         : DebugAppLaunch.Cancel appName.exe
::e.g.          : DebugAppLaunch.Cancel myApp.exe
:DebugAppLaunch.Cancel
@if defined _Stack @for %%a in ( 1 "%~nx0" "%0" ) do @if {"%%~a"}=={"%_Stack%"} @echo [      %~nx0] commandLine: %0 %*
call tools_reg.bat deleteRegDirectory "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\%~nx1"
goto :eof

::************************************************************************************************

::[DOS_API:MonitorAppExit.Generate] generate reg file which is used to monitor application exit automatically
::usage         : MonitorAppExit.Generate appName.exe regfile   [monitorProcessFullPath]
::e.g.          : MonitorAppExit.Generate myApp.exe  outRegfile "D:\shenxiaolong\core\WinScript\Test\test1.bat"
:MonitorAppExit.Generate
@if defined _Stack @for %%a in ( 1 "%~nx0" "%0" ) do @if {"%%~a"}=={"%_Stack%"} @echo [      %~nx0] commandLine: %0 %*
call tools_reg.bat makeRegPath "%temp%\AppExitDump\"  LocalDumpFolder
call tools_reg.bat makeRegPath "%~fs0" MonitorProcess
set "generateReg_in=%~dp0template\monitorAppExit.reg"
call :getOutputRegFile MonitorAppExit generateReg_out "%~1" "%~2"
call :generateReg "%~nx1" "%LocalDumpFolder%" "%MonitorProcess%"
call tools_error.bat checkFileExist "%generateReg_out%" "%~f0" AppExit.enable_mark1
call set "%~2=%generateReg_out%"
call :MonitorAppExit.Generate.setAppExitHandler "%~nx1" %3 %4 %5 %6 %7 %8 %9 
goto :eof

:MonitorAppExit.Generate.setAppExitHandler
@if defined _Stack @for %%a in ( 1 "%~nx0" "%0" ) do @if {"%%~a"}=={"%_Stack%"} @echo [      %~nx0] commandLine: %0 %*
set "_tmpCustomerExitHandler=%LOCALAPPDATA%\%~nx1"
set "_tmpCustomerExitHandlerFile=%_tmpCustomerExitHandler%\AppExitHandler.bat"
if exist "%_tmpCustomerExitHandlerFile%" del /f/q "%_tmpCustomerExitHandlerFile%"
if not exist "%~fs2" goto :eof
if not exist "%_tmpCustomerExitHandler%" md "%_tmpCustomerExitHandler%"
echo call "%~fs2" %3 %4 %5 %6 %7 %8 %9 > "%_tmpCustomerExitHandlerFile%"
goto :eof

::[DOS_API:MonitorAppExit.AppExitHandler] this function is callbacked when application exit automatically
::usage         : MonitorAppExit.AppExitHandler appName exitPID killerPID killerTID killStatusCode
::e.g.          : MonitorAppExit.AppExitHandler 
:MonitorAppExit.AppExitHandler
@if defined _Stack @for %%a in ( 1 "%~nx0" "%0" ) do @if {"%%~a"}=={"%_Stack%"} @echo [      %~nx0] commandLine: %0 %*
rem %e %i %t %c
echo.
echo "%~fs0" %*
echo.
set appName=%~1
set exitPID=%~2
set killerPID=%~3
set killerTID=%~4
set killStatusCode=%~5
set "_tmpCustomerExitHandlerFile=%LOCALAPPDATA%\%~nx1\AppExitHandler.bat"
if exist "%_tmpCustomerExitHandlerFile%" call "%_tmpCustomerExitHandlerFile%" %2 %3 %4 %5
echo appName=%appName%
echo exitPID=%exitPID%
echo killerPID=%killerPID%
echo killerTID=%killerTID%
echo killStatusCode=%killStatusCode%
echo you can run command to debug the exiting process now : windbg.exe -p %exitPID%
echo you can open eventvwr.msc and navigate to Windows Logs ^> Application to see the process exit detail report.
echo.
:: windbg.exe -p %exitPID%
:: eventvwr.msc
:: https://docs.microsoft.com/en-us/windows-hardware/drivers/debugger/registry-entries-for-silent-process-exit
pause
goto :eof

::************************************************************************************************

::[DOS_API:MonitorAppExit.Cancel] cancel registry setting which is generated by DOS API MonitorAppExit.Generate
::usage         : MonitorAppExit.Cancel appName.exe
::e.g.          : MonitorAppExit.Cancel myApp.exe
:MonitorAppExit.Cancel
@if defined _Stack @for %%a in ( 1 "%~nx0" "%0" ) do @if {"%%~a"}=={"%_Stack%"} @echo [      %~nx0] commandLine: %0 %*
call tools_reg.bat deleteRegDirectory "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\%~nx1"
call tools_reg.bat deleteRegDirectory "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\SilentProcessExit\%~nx1"
goto :eof

::[DOS_API:LocalExceptDump.Generate] generate reg file which is used to generate dump file when this application exception occurs.
::usage         : LocalExceptDump.Generate appName.exe regFile  [dumpOutputDir]
::e.g.          : LocalExceptDump.Generate myApp.exe  outputRegFile D:\temp\localDumps
:LocalExceptDump.Generate
@if defined _Stack @for %%a in ( 1 "%~nx0" "%0" ) do @if {"%%~a"}=={"%_Stack%"} @echo [      %~nx0] commandLine: %0 %*
set "LocalDumpFolder=%~3"
if not defined LocalDumpFolder set "LocalDumpFolder=%temp%\AppExceptDump\"
call tools_reg.bat makeRegPath "%LocalDumpFolder%"    LocalDumpFolder
set "generateReg_in=%~dp0template\genExceptionDump.reg"
call :getOutputRegFile LocalExceptDump generateReg_out "%~1" "%~2"
call :generateReg "%~nx1" "%LocalDumpFolder%"
call tools_error.bat checkFileExist "%generateReg_out%" "%~f0" AppExceptDump.enable_mark1
call set "%~2=%generateReg_out%"
goto :eof


::[DOS_API:LocalExceptDump.Cancel] cancel registry setting which is generated by DOS API LocalExceptDump.Generate
::usage         : LocalExceptDump.Cancel appName.exe
::e.g.          : LocalExceptDump.Cancel myApp.exe
:LocalExceptDump.Cancel
@if defined _Stack @for %%a in ( 1 "%~nx0" "%0" ) do @if {"%%~a"}=={"%_Stack%"} @echo [      %~nx0] commandLine: %0 %*
call tools_reg.bat deleteRegDirectory "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\Windows Error Reporting\LocalDumps\%~nx1"
goto :eof

::************************************************************************************************
:getOutputRegFile
@if defined _Stack @for %%a in ( 1 "%~nx0" "%0" ) do @if {"%%~a"}=={"%_Stack%"} @echo [      %~nx0] commandLine: %0 %*
set "%~2=%~4"
if not defined %~2 set "%~2=%temp%\flags_reg\%~nx3\%~1.reg"
for /f "usebackq tokens=*" %%i in ( ` call echo %%%~2%% ` ) do set "_tmpDir=%%~dpi"
if not exist "%_tmpDir%" md "%_tmpDir%"
goto :eof

rem :generateReg generateReg_in generateReg_out
:generateReg
@if defined _Stack @for %%a in ( 1 "%~nx0" "%0" ) do @if {"%%~a"}=={"%_Stack%"} @echo [      %~nx0] commandLine: %0 %*
call tools_message.bat enableDebugMsg "%~0" "template file : %generateReg_in%"
call tools_message.bat enableDebugCmd "%~0" type "%generateReg_in%"
if exist "%generateReg_out%" del /f/q "%generateReg_out%"
for /f "usebackq tokens=*" %%i in ( ` type "%generateReg_in%" ` ) do call echo %%i >> "%generateReg_out%"
goto :eof

::************************************************************************************************

:End
@if defined _Stack @for %%a in ( 1 "%~nx0" "%0" ) do @if {"%%~a"}=={"%_Stack%"} @echo [----- %~nx0] commandLine: %0 %* & @echo.