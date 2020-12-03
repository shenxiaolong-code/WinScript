::@set _Echo=1
::set _Stack=%~nx0
@if {"%_Echo%"}=={"1"} ( @echo on ) else ( @echo off )
@@if defined _Stack @for %%a in ( 1 "%~nx0" "%0" ) do @if {"%%~a"}=={"%_Stack%"} @echo. & @echo [+++++ %~nx0] commandLine: %0 %*
where "%~nx0" 1>nul 2>nul || set "path=%~dp0;%path%" >nul
where "tools_path.bat" 1>nul 2>nul || set "path=%~dp0..\common;%path%" >nul
call tools_error.bat checkAdmin "%~fs0" %*

if {"%~1"}=={""} call :listFlagTable
rem set inputParam=query GlobalFlag
rem set inputParam=listFlagTable
set inputParam=%*

echo %0 %inputParam%
title %0 %inputParam%

call :setEnv
set "supportedCmds=;query;setFlag;listFlagTable;listHpa;listRegPath;"
::call :checkParameter "D:\work\tasks\PRT review\Jabber-Win-11.9.1.55360-20170915_091432-Windows_7_Enterprise.15-09-2017_15-15-06.zip" mergeLog
call :checkParameter %inputParam%
call :processInput %inputParam%
goto :eof

:://////////////////////////////////////////////////////////////////////////////////////////
:processInput
@if defined _Stack @for %%a in ( 1 "%~nx0" "%0" ) do @if {"%%~a"}=={"%_Stack%"} @echo [      %~nx0] commandLine: %0 %*
call :%*
goto :eof

:checkParameter
@if defined _Stack @for %%a in ( 1 "%~nx0" "%0" ) do @if {"%%~a"}=={"%_Stack%"} @echo [      %~nx0] commandLine: %0 %*
set _P4=%~1
if {"%_P4:~0,4%"}=={"list"} goto :eof
if {"%~2"}=={""} call tools_message.bat errorMsg "action can't be empty."
call tools_error.bat checkSupportedCmd "%~1" "%%supportedCmds%%" "%~f0" "checkParameterMark"
goto :eof

:://////////////////////////////////////////////////////////////////////////////////////////
:query
@if defined _Stack @for %%a in ( 1 "%~nx0" "%0" ) do @if {"%%~a"}=={"%_Stack%"} @echo [      %~nx0] commandLine: %0 %*
call tools_error.bat checkSupportedCmd "%~1" ";GlobalFlag;BootFlag;ImageFlag;" "%~f0" "checkParameterMark"
call :query.%*
goto :eof

:setFlag
@if defined _Stack @for %%a in ( 1 "%~nx0" "%0" ) do @if {"%%~a"}=={"%_Stack%"} @echo [      %~nx0] commandLine: %0 %*
rem call tools_error.bat checkSupportedCmd "%~1" ";LocalExceptDump;" "%~f0" "checkParameterMark"
where "tools_AppDbgRegGenerater.bat" 1>nul 2>nul || set "path=%~dp0contextMenu;%path%" >nul
call :setFlag.%*
call tools_message.bat noSleepMsg "%~0" 8 "task is Done"
goto :eof

:listFlagTable
@if defined _Stack @for %%a in ( 1 "%~nx0" "%0" ) do @if {"%%~a"}=={"%_Stack%"} @echo [      %~nx0] commandLine: %0 %*
::NOTE: must escape % to %%
::hh.exe mk:@MSITStore:C:\_temp\linking_example.chm::/Topic_Folder_1/KIT_title.htm
::mk:@MSITStore:C:\Program%20Files%20(x86)\Windows%20Kits\10\Debuggers\x86\debugger.chm::/debugger/gflags_flag_table.htm
start "" "mk:@MSITStore:C:\Program%%20Files%%20(x86)\Windows%%20Kits\10\Debuggers\x86\debugger.chm::/debugger/gflags_flag_table.htm"
goto :eof

:listRegPath
@if defined _Stack @for %%a in ( 1 "%~nx0" "%0" ) do @if {"%%~a"}=={"%_Stack%"} @echo [      %~nx0] commandLine: %0 %*
::NOTE: must escape % to %%
start "" "mk:@MSITStore:C:\Program%%20Files%%20(x86)\Windows%%20Kits\10\Debuggers\x86\debugger.chm::/debugger/gflags_details.htm"
goto :eof

:listHpa
@if defined _Stack @for %%a in ( 1 "%~nx0" "%0" ) do @if {"%%~a"}=={"%_Stack%"} @echo [      %~nx0] commandLine: %0 %*
::list application with page heap enabled, use -FFFFFFFF to clear them
gflags.exe -p
goto :eof

:://////////////////////////////////////////////////////////////////////////////////////////
:query.GlobalFlag
@if defined _Stack @for %%a in ( 1 "%~nx0" "%0" ) do @if {"%%~a"}=={"%_Stack%"} @echo [      %~nx0] commandLine: %0 %*
@echo query all customized debug option :
reg query "HKLM\Software\Microsoft\Windows NT\CurrentVersion\Image File Execution Options" /v GlobalFlag /s
goto :eof

:query.BootFlag
@if defined _Stack @for %%a in ( 1 "%~nx0" "%0" ) do @if {"%%~a"}=={"%_Stack%"} @echo [      %~nx0] commandLine: %0 %*
call tools_error.bat checkAdmin %~fs0 ":debug.BootFlag"
gflags.exe /r
echo.
goto :eof

:query.ImageFlag
@if defined _Stack @for %%a in ( 1 "%~nx0" "%0" ) do @if {"%%~a"}=={"%_Stack%"} @echo [      %~nx0] commandLine: %0 %*
call tools_error.bat checkParamCount 1 "%~f0" ":query.ImageFlag"
call tools_error.bat checkAdmin %~fs0 queryImageFlag %1
gflags.exe /i "%~nx1"
echo.
goto :eof

:://////////////////////////////////////////////////////////////////////////////////////////
:setFlag.LocalExceptDump
@if defined _Stack @for %%a in ( 1 "%~nx0" "%0" ) do @if {"%%~a"}=={"%_Stack%"} @echo [      %~nx0] commandLine: %0 %*
if {"%~2"}=={""} (
call :setFlag.LocalExceptDump.enable %*
) else (
call :setFlag.LocalExceptDump.disable %*
)
goto :eof

:setFlag.LocalExceptDump.enable
@if defined _Stack @for %%a in ( 1 "%~nx0" "%0" ) do @if {"%%~a"}=={"%_Stack%"} @echo [      %~nx0] commandLine: %0 %*
call :setFlag.regTempFile tmpRegFile LocalExceptDump %1
if not  exist "%~fs1" set "_tmpDumpDir=%_regTmpDir%"
if      exist "%~fs1" set "_tmpDumpDir=%~fs1"
if not exist "%_tmpDumpDir%\" md "%_tmpDumpDir%\"
call tools_AppDbgRegGenerater.bat LocalExceptDump.Generate "%~1" "%tmpRegFile%" "%_tmpDumpDir%"
call :setFlag.checkAndImportRegFile "%tmpRegFile%"
goto :eof

:setFlag.LocalExceptDump.disable
@if defined _Stack @for %%a in ( 1 "%~nx0" "%0" ) do @if {"%%~a"}=={"%_Stack%"} @echo [      %~nx0] commandLine: %0 %*
call tools_AppDbgRegGenerater.bat LocalExceptDump.Cancel "%~1" 
goto :eof

:://////////////////////////////////////////////////////////////////////////////////////////
:setFlag.DebugAppLaunch
@if defined _Stack @for %%a in ( 1 "%~nx0" "%0" ) do @if {"%%~a"}=={"%_Stack%"} @echo [      %~nx0] commandLine: %0 %*
if {"%~2"}=={""} (
call :setFlag.DebugAppLaunch.enable %*
) else (
call :setFlag.DebugAppLaunch.disable %*
)
goto :eof

:setFlag.DebugAppLaunch.enable
@if defined _Stack @for %%a in ( 1 "%~nx0" "%0" ) do @if {"%%~a"}=={"%_Stack%"} @echo [      %~nx0] commandLine: %0 %*
call :setFlag.regTempFile tmpRegFile DebugAppLaunch %1
call tools_AppDbgRegGenerater.bat DebugAppLaunch.Generate "%~1" "%tmpRegFile%"
call :setFlag.checkAndImportRegFile "%tmpRegFile%"
goto :eof

:setFlag.DebugAppLaunch.disable
@if defined _Stack @for %%a in ( 1 "%~nx0" "%0" ) do @if {"%%~a"}=={"%_Stack%"} @echo [      %~nx0] commandLine: %0 %*
call tools_AppDbgRegGenerater.bat DebugAppLaunch.Cancel "%~1" 
goto :eof

:://////////////////////////////////////////////////////////////////////////////////////////
:setFlag.MonitorAppExit
@if defined _Stack @for %%a in ( 1 "%~nx0" "%0" ) do @if {"%%~a"}=={"%_Stack%"} @echo [      %~nx0] commandLine: %0 %*
if {"%~2"}=={""} (
call :setFlag.MonitorAppExit.enable %*
) else (
call :setFlag.MonitorAppExit.disable %*
)
goto :eof

:setFlag.MonitorAppExit.enable
@if defined _Stack @for %%a in ( 1 "%~nx0" "%0" ) do @if {"%%~a"}=={"%_Stack%"} @echo [      %~nx0] commandLine: %0 %*
call :setFlag.regTempFile tmpRegFile MonitorAppExit %1
call tools_AppDbgRegGenerater.bat MonitorAppExit.Generate "%~1" "%tmpRegFile%"
call :setFlag.checkAndImportRegFile "%tmpRegFile%"
goto :eof

:setFlag.MonitorAppExit.disable
@if defined _Stack @for %%a in ( 1 "%~nx0" "%0" ) do @if {"%%~a"}=={"%_Stack%"} @echo [      %~nx0] commandLine: %0 %*
call tools_AppDbgRegGenerater.bat MonitorAppExit.Cancel "%~1" 
goto :eof

:://////////////////////////////////////////////////////////////////////////////////////////
:setFlag.checkAndImportRegFile
@if defined _Stack @for %%a in ( 1 "%~nx0" "%0" ) do @if {"%%~a"}=={"%_Stack%"} @echo [      %~nx0] commandLine: %0 %*
call tools_error.bat checkFileExist "%~fs1" "%~fs0" setFlag.checkAndImportRegFile.mark
call tools_reg.bat importRegFile "%~fs1"
start explorer.exe /select, "%~fs1"
goto :eof

:setFlag.regTempFile
@if defined _Stack @for %%a in ( 1 "%~nx0" "%0" ) do @if {"%%~a"}=={"%_Stack%"} @echo [      %~nx0] commandLine: %0 %*
set "_regTmpDir=%temp%\flags_reg\%~nx3"
if not exist "%_regTmpDir%\" md "%_regTmpDir%\"
set "_tmpRegFile=%_regTmpDir%\%~2.reg"
if exist "%_tmpRegFile%" del /f/q "%_tmpRegFile%"
set "%~1=%_tmpRegFile%"
echo registry file :
echo %_tmpRegFile%
goto :eof

:setFlag.clearAll
@if defined _Stack @for %%a in ( 1 "%~nx0" "%0" ) do @if {"%%~a"}=={"%_Stack%"} @echo [      %~nx0] commandLine: %0 %*
::https://docs.microsoft.com/en-us/windows-hardware/drivers/debugger/gflags-commands#parameters
gflags.exe /i %~nx1 -FFFFFFFF
goto :eof

:://////////////////////////////////////////////////////////////////////////////////////////
:setEnv
@if defined _Stack @for %%a in ( 1 "%~nx0" "%0" ) do @if {"%%~a"}=={"%_Stack%"} @echo [      %~nx0] commandLine: %0 %*
where "%~nx0" 1>nul 2>nul || set "path=%~dp0..\common;%path%"
where windbg.exe 1>nul 2>nul || call tools_appInstallPath.bat FindPathWindbg windbgPath
if not defined windbgPath call tools_message.bat errorMsg "Fails to find windbg.exe path. use environment variable g_windbgDir to specify windbg path and try again."
where gflags.exe 1>nul 2>nul || @set path=%path%;%windbgPath%\x86;
call tools_message.bat enableDebugMsg "%~0" "windbgPath=%windbgPath%"
goto :End
goto :eof

:://////////////////////////////////////////////////////////////////////////////////////////
:End
@if defined _Stack @for %%a in ( 1 "%~nx0" "%0" ) do @if {"%%~a"}=={"%_Stack%"} @echo [----- %~nx0] commandLine: %0 %* & @echo.