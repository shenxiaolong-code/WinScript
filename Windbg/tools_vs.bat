::Author  	: Shen Xiaolong((xlshen@126.com))
::Copyright	: free use,modify,spread, but MUST include this original two line information.

::@set _Echo=1
::set _Stack=%~nx0
::set _Debug=1
@if {"%_Echo%"}=={"1"} ( @echo on ) else ( @echo off )
@if defined _Stack @for %%a in ( 1 "%~nx0" "%0" ) do @if {"%%~a"}=={"%_Stack%"} @echo. & @echo [+++++ %~nx0] commandLine: %0 %*
@title %0 %* 2>nul
@echo %~fs0 %*

::*****************************************************************************************************************************
@echo.
title %~n0 %*
call :setPath "%~fs0"
rem call tools_error.bat checkAdmin %~fs0 %*

set supportedDbgCmds=;dbgPid;dbgAppName;dbgNewInstance;analysisDmp;vsInstallPath;findVSPath;loadEnvVs;openVs;loadEnvVsMenu;CMakeGen;
::call :checkParameter dbgPid 2734
::call :checkParameter dbgAppName 
::call :checkParameter dbgAppName "notepad.exe"
::call :checkParameter dbgNewInstance 
::call :checkParameter dbgNewInstance "C:\myapp\app.exe" -appStartParam
::call :checkParameter analysisDmp 
::call :checkParameter analysisDmp "D:\mydump\fulldump.dmp"
::call :checkParameter vsInstallPath outVar 2015
::call :checkParameter vsInstallPath outVar 2017

call :checkParameter %*
@rem usage : processInput dbgNewInstance ApplitionFullPath RunParameters
::call :processInput dbgNewInstance "C:\Program Files (x86)\Cisco Systems\Cisco Jabber\CiscoJabber.exe" disableSingleInstance
call :%*
goto :End

::*****************************************************************************************************************************
:checkParameter
@if defined _Stack @for %%a in ( 1 "%~nx0" "%0" ) do @if {"%%~a"}=={"%_Stack%"} @echo [      %~nx0] commandLine: %0 %*
if {"%~1"}=={""} (
call tools_message.bat warningMsg "parameter is not enough." "%~f0" mark11
echo.
call tools_message.bat errorMsg "e.g. %~nx0 dbgPid 2734 " "%~f0" mark22
echo.
goto :End
)

call tools_error.bat checkSupportedCmd "%~1" "%supportedDbgCmds%"
goto :eof

::*****************************************************************************************************************************
:dbgPid
@if defined _Stack @for %%a in ( 1 "%~nx0" "%0" ) do @if {"%%~a"}=={"%_Stack%"} @echo [      %~nx0] commandLine: %0 %*
set curPid=%~1
if     defined curPid       call :dbgPid.checkPID curPid %curPid%
if not defined curPid       call :dbgPid.waitPID  curPid
call :dbgPid.info %~1
call :dbgPid.attachPid %~1
goto :eof

:dbgPid.waitPID
@if defined _Stack @for %%a in ( 1 "%~nx0" "%0" ) do @if {"%%~a"}=={"%_Stack%"} @echo [      %~nx0] commandLine: %0 %*
set waitStringPrompt=please input existingg process ID to debug :
call tools_userInput.bat waitNumber %~1
call :dbgPid.checkPID %~1 %%%~1%%
if not defined %~1 call :dbgPid.waitPID %*
goto :eof

:dbgPid.checkPID
@if defined _Stack @for %%a in ( 1 "%~nx0" "%0" ) do @if {"%%~a"}=={"%_Stack%"} @echo [      %~nx0] commandLine: %0 %*
call tools_process.bat isProcessExist "%~2" pidExist
if not {"%pidExist%"}=={"1"}  call tools_message.bat NotifyMsg "process[pid:%~2] doesn't exist."
if not {"%pidExist%"}=={"1"}  call set %~1=
goto :eof

:dbgPid.info
@if defined _Stack @for %%a in ( 1 "%~nx0" "%0" ) do @if {"%%~a"}=={"%_Stack%"} @echo [      %~nx0] commandLine: %0 %*
@echo **************************************************************************************
call tools_process.bat processinfo %1
@echo.
@echo debug start option : %dbgOption%
@echo **************************************************************************************
@echo.
goto :eof

:dbgPid.attachPid
@if defined _Stack @for %%a in ( 1 "%~nx0" "%0" ) do @if {"%%~a"}=={"%_Stack%"} @echo [      %~nx0] commandLine: %0 %*
call tools_process.bat getProcessCmdLine  %1 _tmpCmdLine
cd /d "%_tmpCmdLine%\.."
@echo using visual debugger to debug process : %~1
start VsJITDebugger.exe -p %~1
goto :eof

::*****************************************************************************************************************************
:dbgAppName
@if defined _Stack @for %%a in ( 1 "%~nx0" "%0" ) do @if {"%%~a"}=={"%_Stack%"} @echo [      %~nx0] commandLine: %0 %*
set "_appName=%~1"
if not defined _appName call :dbgAppName.waitAppName _appName
call :dbgAppName.dbgScenario "%_appName%"
goto :eof

:dbgAppName.dbgScenario
@if defined _Stack @for %%a in ( 1 "%~nx0" "%0" ) do @if {"%%~a"}=={"%_Stack%"} @echo [      %~nx0] commandLine: %0 %*
call tools_process.bat getProcessCount "%~nx1"  ProcessNum
call tools_message.bat enableDebugMsg "%~0" "ProcessNum=%ProcessNum%"
if {%ProcessNum%}=={0} call :dbgAppName.processNameNotExist "%~nx1"
if {%ProcessNum%}=={1} call :dbgAppName.sigleProcess "%~nx1"
if  %ProcessNum% GTR 1 call :dbgAppName.multipleProcess "%~nx1"
goto :eof

:dbgAppName.waitAppName
@if defined _Stack @for %%a in ( 1 "%~nx0" "%0" ) do @if {"%%~a"}=={"%_Stack%"} @echo [      %~nx0] commandLine: %0 %*
set "waitStringPrompt=please input application name of existingg process (include extension, e.g. myApp.exe):"
call tools_userInput.bat waitString _appName
call :dbgAppName "%_appName%"
goto :eof

:dbgAppName.processNameNotExist
@if defined _Stack @for %%a in ( 1 "%~nx0" "%0" ) do @if {"%%~a"}=={"%_Stack%"} @echo [      %~nx0] commandLine: %0 %*
call tools_message.bat NotifyMsg "app name "%~1" doesn't exit."
call :dbgAppName
goto :eof

:dbgAppName.sigleProcess
@if defined _Stack @for %%a in ( 1 "%~nx0" "%0" ) do @if {"%%~a"}=={"%_Stack%"} @echo [      %~nx0] commandLine: %0 %*
call tools_process.bat getPIDByName "%~1"  appPID
call :dbgPid %appPID%
goto :eof

:dbgAppName.multipleProcess
@if defined _Stack @for %%a in ( 1 "%~nx0" "%0" ) do @if {"%%~a"}=={"%_Stack%"} @echo [      %~nx0] commandLine: %0 %*
call :dbgAppName.multipleProcess.list "%~1"
call :dbgAppName.multipleProcess.selectProcess %DefAppProcIdx%
if defined DefAppProcIdx echo debug No.%DefAppProcIdx% process of "%~1"
@echo.
@echo you selected process:
@echo %processLine%
call :dbgAppName.multipleProcess.getPid %processLine%
echo appPID=%appPID%
call :dbgPid %appPID%
goto :eof

:dbgAppName.multipleProcess.getPid
@if defined _Stack @for %%a in ( 1 "%~nx0" "%0" ) do @if {"%%~a"}=={"%_Stack%"} @echo [      %~nx0] commandLine: %0 %*
set appPID=%2
goto :eof

:dbgAppName.multipleProcess.selectProcess
@if defined _Stack @for %%a in ( 1 "%~nx0" "%0" ) do @if {"%%~a"}=={"%_Stack%"} @echo [      %~nx0] commandLine: %0 %*
set waitStringPrompt=there are %ProcessNum% instances^(%~1^) are runing,pls select the process ID: 
type %displayTmpFile%
if {"%~1"}=={""} (
for /f "usebackq delims=: tokens=1" %%i in ( ` type "%displayTmpFile%" ` ) do call :dbgAppName.multipleProcess.selectProcess.genSelOpt %%i
call tools_userInput.bat waitSelect %selOpt% selChar
) else (
call set selChar=%~1
)
for /f "usebackq delims=: tokens=1*" %%i in ( %displayTmpFile% ) do if {%%i}=={%selChar%} (
set processLine=%%j
)
goto :eof

:dbgAppName.multipleProcess.selectProcess.genSelOpt
@if defined _Stack @for %%a in ( 1 "%~nx0" "%0" ) do @if {"%%~a"}=={"%_Stack%"} @echo [      %~nx0] commandLine: %0 %*
if not defined selOpt (
set selOpt=%1
) else (
set selOpt=%selOpt%%1
)
goto :eof

:dbgAppName.multipleProcess.list
@if defined _Stack @for %%a in ( 1 "%~nx0" "%0" ) do @if {"%%~a"}=={"%_Stack%"} @echo [      %~nx0] commandLine: %0 %*
set displayTmpFile=%temp%\tmp%random%.txt
if exist %displayTmpFile% 	del /f %displayTmpFile%
@echo query process "%~nx1"
wmic  process WHERE ( name="%~nx1" ) get handle,name,commandline,ThreadCount | more +1 | findstr /n "%~nx1" > %displayTmpFile%
goto :eof

::*****************************************************************************************************************************
:dbgNewInstance
@if defined _Stack @for %%a in ( 1 "%~nx0" "%0" ) do @if {"%%~a"}=={"%_Stack%"} @echo [      %~nx0] commandLine: %0 %*
set "_instancePath=%~fs1"
if     defined _instancePath call :dbgNewInstance.verifyInstancePath _instancePath
if not defined _instancePath call :dbgNewInstance.waitInstancePath _instancePath
if not defined AppParam set AppParam=%2 %3 %4 %5 %6 %7 %8 %9
call :dbgNewInstance.info "%~f1"
call :dbgNewInstance.load "%~f1"
goto :eof

:dbgNewInstance.verifyInstancePath
@if defined _Stack @for %%a in ( 1 "%~nx0" "%0" ) do @if {"%%~a"}=={"%_Stack%"} @echo [      %~nx0] commandLine: %0 %*
call :dbgNewInstance.verifyInstancePath.checkFileExist %~1 "%%%~1%%"
if defined %~1 call :dbgNewInstance.verifyInstancePath.checkExe %~1 "%%%~1%%"
if not exist "%newInstancePath%" set newInstancePath=
goto :eof

:dbgNewInstance.verifyInstancePath.checkFileExist
@if defined _Stack @for %%a in ( 1 "%~nx0" "%0" ) do @if {"%%~a"}=={"%_Stack%"} @echo [      %~nx0] commandLine: %0 %*
if exist "%~fs2" goto :eof
call tools_message.bat NotifyMsg "%~2 is not a executable application."
set %~1=
goto :eof

:dbgNewInstance.verifyInstancePath.checkExe
@if defined _Stack @for %%a in ( 1 "%~nx0" "%0" ) do @if {"%%~a"}=={"%_Stack%"} @echo [      %~nx0] commandLine: %0 %*
if {"%~x2"}=={".exe"} goto :eof
set extName=%~x2
call tools_string.bat toLower extName
if {"%extName%"}=={".exe"} goto :eof
call tools_message.bat NotifyMsg "%~nx2 is not a executable application."
set %~1=
goto :eof

:dbgNewInstance.waitInstancePath
@if defined _Stack @for %%a in ( 1 "%~nx0" "%0" ) do @if {"%%~a"}=={"%_Stack%"} @echo [      %~nx0] commandLine: %0 %*
if defined newInstancePath  set "%~1=%newInstancePath%" & goto :eof
set inputSpecFilePrompt=plese input application full Path and run paramter. e.g:
set inputSpecFilePrompt2=d:\myAppDir\myApp.exe -noBox
call tools_userInput.bat inputSpecFile ".exe" %~1
goto :eof


:dbgNewInstance.info
@if defined _Stack @for %%a in ( 1 "%~nx0" "%0" ) do @if {"%%~a"}=={"%_Stack%"} @echo [      %~nx0] commandLine: %0 %*
@echo ready to start new instance: %~nx1. 
@echo **************************************************************************************
@echo instance path                 : %~f1
@echo application start parameter   : %appParam%
@echo **************************************************************************************
@echo.
call tools_message.bat noSleepMsg "%~0" 2
goto :eof

:dbgNewInstance.load
@if defined _Stack @for %%a in ( 1 "%~nx0" "%0" ) do @if {"%%~a"}=={"%_Stack%"} @echo [      %~nx0] commandLine: %0 %*
@echo.
@echo startNewInstance : %~f1
cd /d "%~dp1"
call :vs.load /debugexe "%~fs1" %AppParam%
goto :eof

::*****************************************************************************************************************************
:dmpFile.checkSize
@if defined _Stack @for %%a in ( 1 "%~nx0" "%0" ) do @if {"%%~a"}=={"%_Stack%"} @echo [      %~nx0] commandLine: %0 %*
if not defined minDmpFileSize set minDmpFileSize=100
if %~z1 LSS %minDmpFileSize% (
call tools_message.bat warningMsg "%~fs1 might be not valid full dump file. its size is only %~z1"
explorer "%~dp1"
pause > nul
@echo.
@echo press any key to exit analysis dump file job.
exit
)
goto :eof

::*****************************************************************************************************************************
:analysisDmp
@if defined _Stack @for %%a in ( 1 "%~nx0" "%0" ) do @if {"%%~a"}=={"%_Stack%"} @echo [      %~nx0] commandLine: %0 %*
set "_dmpFile=%~fs1"
if     defined _dmpFile call :analysisDmp.verifyDmpFile _dmpFile
if not defined _dmpFile call :analysisDmp.waitDmpFile   _dmpFile
call :dmpFile.checkSize "%~f1"
call :analysisDmp.info "%~f1"
call :analysisDmp.load "%~f1"
goto :eof

:analysisDmp.waitDmpFile
@if defined _Stack @for %%a in ( 1 "%~nx0" "%0" ) do @if {"%%~a"}=={"%_Stack%"} @echo [      %~nx0] commandLine: %0 %*
set inputSpecFilePrompt=plese input dump file full Path. e.g:
set inputSpecFilePrompt2=d:\myAppDir\myApp.dmp
call tools_userInput.bat inputSpecFile ".dmp" %~1
goto :eof

:analysisDmp.verifyDmpFile
@if defined _Stack @for %%a in ( 1 "%~nx0" "%0" ) do @if {"%%~a"}=={"%_Stack%"} @echo [      %~nx0] commandLine: %0 %*
call :analysisDmp.verifyDmpFile.checkFileExist %~1 "%%%~1%%"
if defined %~1  call :analysisDmp.verifyDmpFile.checkFileExist %~1 "%%%~1%%"
goto :eof

:analysisDmp.verifyDmpFile.checkFileExist
@if defined _Stack @for %%a in ( 1 "%~nx0" "%0" ) do @if {"%%~a"}=={"%_Stack%"} @echo [      %~nx0] commandLine: %0 %*
if exist "%~f2" goto :eof
call tools_message.bat NotifyMsg "file '%~2' doesn't exist"
call set %~1=
goto :eof

:analysisDmp.verifyDmpFile.dmpCheck
@if defined _Stack @for %%a in ( 1 "%~nx0" "%0" ) do @if {"%%~a"}=={"%_Stack%"} @echo [      %~nx0] commandLine: %0 %*
set extName=%~x2
call tools_string.bat toLower extName
if not {"%extName%"}=={".dmp"} call tools_message.bat errorMsg "%~nx2 is not a dump file -- .dmp"
call set %~1=
goto :eof

:analysisDmp.info
@if defined _Stack @for %%a in ( 1 "%~nx0" "%0" ) do @if {"%%~a"}=={"%_Stack%"} @echo [      %~nx0] commandLine: %0 %*
@echo **************************************************************************************
@echo dump file path                : %~f1
@echo **************************************************************************************
@echo.
call tools_message.bat noSleepMsg "%~0" 2
goto :eof

:analysisDmp.load
@if defined _Stack @for %%a in ( 1 "%~nx0" "%0" ) do @if {"%%~a"}=={"%_Stack%"} @echo [      %~nx0] commandLine: %0 %*
cd /d "%~dp1"
::below path can't include blank
::call :vs.load /command "File.OpenFile %~fs1"
call :vs.load "%~fs1"
goto :eof

::https://docs.microsoft.com/en-us/visualstudio/ide/reference/devenv-command-line-switches?view=vs-2019
:vs.openFile
@if defined _Stack @for %%a in ( 1 "%~nx0" "%0" ) do @if {"%%~a"}=={"%_Stack%"} @echo [      %~nx0] commandLine: %0 %*
call :vs.load /edit "%~fs1" "%~fs2" "%~fs3"
goto :eof

:vsInstallPath
@if defined _Stack @for %%a in ( 1 "%~nx0" "%0" ) do @if {"%%~a"}=={"%_Stack%"} @echo [      %~nx0] commandLine: %0 %*
:: call :vs.vsInstallPath.%~1   %2
if     {"%~2"}=={""}            call :vs.vsInstallPath.newest %~1
if not {"%~2"}=={""}            set %~2=
if not {"%~2"}=={""}    if      {"%~1"}=={"newest"}     call :vs.vsInstallPath.newest %~2
if not {"%~2"}=={""}    if not  {"%~1"}=={"newest"}     call :vs.vsInstallPath.specified %*
goto :eof

:vs.vsInstallPath.newest
@if defined _Stack @for %%a in ( 1 "%~nx0" "%0" ) do @if {"%%~a"}=={"%_Stack%"} @echo [      %~nx0] commandLine: %0 %*
set "vswherePath=%ProgramFiles(x86)%\Microsoft Visual Studio\Installer\vswhere.exe"
if not  exist "%vswherePath%"  call :vs.vsInstallPath.newest.before2017 %*
if      exist "%vswherePath%"  call :vs.vsInstallPath.newest.after2017  %*
goto :eof

:vs.vsInstallPath.newest.before2017
@if defined _Stack @for %%a in ( 1 "%~nx0" "%0" ) do @if {"%%~a"}=={"%_Stack%"} @echo [      %~nx0] commandLine: %0 %*
for /f "usebackq tokens=1 delims==" %%i in ( ` set vs ^| find /i "Tools" ` ) do call :vs.vsInstallPath.newest.before2017.oneVer "%%i"
if defined highestVsVer call set "highestVsVer=%%VS%highestVsVer%COMNTOOLS%%"
if defined highestVsVer for /f "tokens=*"  %i in ( "%highestVsVer%..\.." ) do set "%~1=%~fsi"
goto :eof

:vs.vsInstallPath.newest.before2017.oneVer
@if defined _Stack @for %%a in ( 1 "%~nx0" "%0" ) do @if {"%%~a"}=={"%_Stack%"} @echo [      %~nx0] commandLine: %0 %*
call set _tmpCurVS=%~1
call set _tmpCurVS=%_tmpCurVS:~2%
call set _tmpCurVS=%_tmpCurVS:COMNTOOLS=%
if not defined highestVsVer call set "highestVsVer=%_tmpCurVS%"& goto :eof
if %_tmpCurVS% GTR %highestVsVer% call set highestVsVer=%_tmpCurVS%
goto :eof

:vs.vsInstallPath.newest.after2017
@if defined _Stack @for %%a in ( 1 "%~nx0" "%0" ) do @if {"%%~a"}=={"%_Stack%"} @echo [      %~nx0] commandLine: %0 %*
for /f "usebackq tokens=*" %%i in (`"%vswherePath%" -latest -products * -requires Microsoft.Component.MSBuild -property installationPath`) do set "%~1=%%~si"
:: "C:\Program Files (x86)\Microsoft Visual Studio\Installer\vswhere.exe" -latest -requires Microsoft.VisualStudio.Workload.NativeDesktop
:: "C:\Program Files (x86)\Microsoft Visual Studio\Installer\vswhere.exe" -latest -products * -requires Microsoft.Component.MSBuild -property installationPath
goto :eof

:vs.vsInstallPath.specified
@if defined _Stack @for %%a in ( 1 "%~nx0" "%0" ) do @if {"%%~a"}=={"%_Stack%"} @echo [      %~nx0] commandLine: %0 %*
for %%a in ("vs2017=15.0" "vs2015=14.0" "vs2008=9.0") do if not defined vs%~1 set "%%~a"
if defined vs%~1 call :vs.vsInstallPath.specified.queryReg "HKEY_LOCAL_MACHINE\SOFTWARE\WOW6432Node\Microsoft\VisualStudio\SxS\VS7\%%vs%~1%%" "%~2"
if not defined %~2 call :vs.vsInstallPath.specified.%~1  %2
goto :eof

:vs.vsInstallPath.specified.2019
@if defined _Stack @for %%a in ( 1 "%~nx0" "%0" ) do @if {"%%~a"}=={"%_Stack%"} @echo [      %~nx0] commandLine: %0 %*
set "vswherePath=%ProgramFiles(x86)%\Microsoft Visual Studio\Installer\vswhere.exe"
for /f "usebackq tokens=*" %%i in (  ` call "%vswherePath%" -latest -products * -requires Microsoft.Component.MSBuild -property installationPath ^| find /i "2019"  ` ) do set "%~1=%%~fsi"
goto :eof

:vs.vsInstallPath.specified.queryReg
@if defined _Stack @for %%a in ( 1 "%~nx0" "%0" ) do @if {"%%~a"}=={"%_Stack%"} @echo [      %~nx0] commandLine: %0 %*
call tools_reg.bat queryRegVariable "%~1" "%~2"
if defined %~2 call set "%~2=%%%~2:~0,-1%%"
rem echo vsInstallDir=%vsInstallDir%
goto :eof

:findVSPath
@if defined _Stack @for %%a in ( 1 "%~nx0" "%0" ) do @if {"%%~a"}=={"%_Stack%"} @echo [      %~nx0] commandLine: %0 %*
call :vs.vsInstallPath.newest _tmpVsInstallPath
if not defined _tmpVsInstallPath tools_message.bat errorMsg "vs install path is not found." "%~fs0"  vs.findVSPath_mark
set "path=%_tmpVsInstallPath%\Common7\IDE;%path%"
if not {"%~1"}=={""} set "%~1=%_tmpVsInstallPath%"
goto :eof

:vs.load
@if defined _Stack @for %%a in ( 1 "%~nx0" "%0" ) do @if {"%%~a"}=={"%_Stack%"} @echo [      %~nx0] commandLine: %0 %*
where devenv.exe 1>nul 2>nul || call :findVSPath
call tools_message.bat enableDebugCmd "%~0" where devenv.exe
call tools_message.bat enableDebugMsg "%~0" "cd=%cd%"
set actCmd=start devenv.exe %*
@echo %actCmd%
call tools_message.bat noSleepMsg "%~0" 2
call %actCmd%
goto :eof

::*****************************************************************************************************************************
:setPath
@if defined _Stack @for %%a in ( 1 "%~nx0" "%0" ) do @if {"%%~a"}=={"%_Stack%"} @echo [      %~nx0] commandLine: %0 %*
for /f "usebackq tokens=2,*" %%a in ( ` dir "%~dp0.." ^| find /i "Directory of" ` ) do set "myWinScriptPath=%%b"
where tools_path.bat 1>nul 2>nul || set path=%path%;%~dp1;%myWinScriptPath%\common;
goto :eof


:CMakeGen
@if defined _Stack @for %%a in ( 1 "%~nx0" "%0" ) do @if {"%%~a"}=={"%_Stack%"} @echo [      %~nx0] commandLine: %0 %*
if exist "%~fs1" pushd "%~fs1"
call tools_error.bat checkFileExist "%cd%\CMakeLists.txt"
set VSVer=%~2
if not defined VSVerDef set VSVerDef=vs2017
if not defined VSVer echo if use different vs version, usage e.g : $~fs0 CMakeGen "%~1" vs2019
if not defined VSVer set VSVer=%VSVerDef%
if not exist "build\"  md "build"
cd build
if {"%VSVer%"}=={"vs2019"} cmake -G "Visual Studio 16" -A Win32 ..
:: for vs2017
:: cmake -G "Visual Studio 15" -A Win32 ..
:: cmake -G "Visual Studio 15" -A Win64 ..
if {"%VSVer%"}=={"vs2017"} cmake -G "Visual Studio 15" -A Win32 ..
:: for vs2015
:: cmake -G "Visual Studio 14" -A Win32 ..
if {"%VSVer%"}=={"vs2015"} cmake -G "Visual Studio 14" -A Win32 ..

popd
goto :eof

:loadEnvVsMenu
@if defined _Stack @for %%a in ( 1 "%~nx0" "%0" ) do @if {"%%~a"}=={"%_Stack%"} @echo [      %~nx0] commandLine: %0 %*
if {"%~2"}=={""} call tools_error.bat checkAdmin cmd.exe /k %~fs0 loadEnvVsMenu %* "newCmdWindow"
if {"%~2"}=={""} goto :eof
if exist "%~fs1" cd /d "%~fs1"
call :loadEnvVs
dir/w "%_vsInstallPath%\Common7\IDE\*.exe"
goto :eof

rem :loadEnvVs  [archMode]
:loadEnvVs
@if defined _Stack @for %%a in ( 1 "%~nx0" "%0" ) do @if {"%%~a"}=={"%_Stack%"} @echo [      %~nx0] commandLine: %0 %*
rem important vs env script file : vcvarsall.bat / vcvars32.bat  / VsDevCmd.bat
call :vs.vsInstallPath.newest _vsInstallPath
call tools_error.bat checkFolderExist "%_vsInstallPath%"
echo vc path : %_vsInstallPath%
if      {"%~1"}=={""}    call :loadEnvVs.default
if not  {"%~1"}=={""}    call :loadEnvVs.specified "%~1"
where devenv.exe 1>nul 2>nul || set "path=%_vsInstallPath%\Common7\IDE;%path%"
goto :eof

:loadEnvVs.default
@if defined _Stack @for %%a in ( 1 "%~nx0" "%0" ) do @if {"%%~a"}=={"%_Stack%"} @echo [      %~nx0] commandLine: %0 %*
where nmake.exe 1>nul 2>nul && goto :eof
set vcvars32Path=
for /f "usebackq tokens=*" %%i in ( `dir/s/b "%_vsInstallPath%\vcvars32.bat" ` ) do if not defined vcvars32Path set "vcvars32Path=%%~dpi"
:: echo runing %vcvars32Path%vcvars32.bat
call :loadEnvVs.impl "%vcvars32Path%vcvars32.bat"
goto :eof

:loadEnvVs.specified
@if defined _Stack @for %%a in ( 1 "%~nx0" "%0" ) do @if {"%%~a"}=={"%_Stack%"} @echo [      %~nx0] commandLine: %0 %*
set "supportedVsArch=;x86;amd64;x64;arm;x86_arm;x86_amd64;amd64_x86;amd64_arm;"
call tools_error.bat checkSupportedCmd "%~1" "%supportedVsArch%"
set vcvarsallPath=
for /f "usebackq tokens=*" %%i in ( `dir/s/b "%_vsInstallPath%\vcvarsall.bat" ` ) do if not defined vcvarsallPath set "vcvarsallPath=%%~dpi"
:: echo runing %vcvarsallPath%vcvarsall.bat %~1
call :loadEnvVs.impl "%vcvarsallPath%vcvarsall.bat" %~1

rem select C++ development enviroment automatically
rem select certica by reg store, x86 first , then x64 , check VsDevCmd.bat
rem call "C:\Program Files (x86)\Microsoft Visual Studio 14.0\Common7\Tools\VsDevCmd.bat"

rem set compile & link environment 
rem echo generate X64(64bit) application
rem call "%vcvarsallPath%\vcvarsall.bat" x64

rem echo generate x86 (32bit) application
rem call "%vcvarsallPath%\vcvarsall.bat" x86

rem echo generate arm application
rem call "%vcvarsallPath%\vcvarsall.bat" arm
goto :eof

:loadEnvVs.impl
@if defined _Stack @for %%a in ( 1 "%~nx0" "%0" ) do @if {"%%~a"}=={"%_Stack%"} @echo [      %~nx0] commandLine: %0 %*
echo runing %*
call %*
goto :eof

:dumpEnvVs
@if defined _Stack @for %%a in ( 1 "%~nx0" "%0" ) do @if {"%%~a"}=={"%_Stack%"} @echo [      %~nx0] commandLine: %0 %*
echo.
echo Visual C++ development info:
echo VisualStudioVersion=%VisualStudioVersion%
echo FrameworkDir=%FrameworkDir%
echo FrameworkVersion=%FrameworkVersion%
echo VS140COMNTOOLS=%VS140COMNTOOLS%
echo VS IDE root : DevEnvDir=%DevEnvDir%
echo INCLUDE=%INCLUDE%
echo LIB=%LIB%
echo LIBPATH=%LIBPATH%

echo.
echo compiler info , type cl /? to check all compiler options 
rem cl.exe
goto :eof

:: ***************************************************************************************************************************
:openVs  "slnFilePath"  "srcFilePath"  "LineNo"
if      {"%~1"}=={""}   call tools_process.bat isProcessExist "devenv.exe" bVsExist
::alway open new vs
if not  {"%~1"}=={""}   set bVsExist=0
echo.
set "slnFile=%~f1"
set "localSrc=%~2"
set "_srcLine=%~3"
if {"%bVsExist%"}=={"0"} call :openVs.newVs
if {"%bVsExist%"}=={"1"} call :openVs.runningVs

rem "C:\Program Files (x86)\Microsoft Visual Studio\2017\Professional\Common7\IDE\devenv.exe" "D:\sourceCode\jabberGit126\products\jabber-win\src\jabber-client\JabberClient.sln" /Command "Edit.Goto 140" "D:\shared_desktop-500eiav\temp\boost_1_70_0\libs\iostreams\src\zstd.cpp"
rem "C:\Program Files (x86)\Common Files\Microsoft Shared\MSEnv\VSLauncher.exe" "D:\sourceCode\jabberGit126\products\jabber-win\src\jabber-client\JabberClient.sln" /Command "Edit.Goto 140" "D:\shared_desktop-500eiav\temp\boost_1_70_0\libs\iostreams\src\zstd.cpp"
rem start "" "D:\sourceCode\jabberGit128\products\jabber-win\src\jabber-client\JabberClient.sln" /Command "Edit.Goto 140" "D:\shared_desktop-500eiav\temp\boost_1_70_0\libs\iostreams\src\zstd.cpp"
goto :eof

:openVs.newVs
:: echo open file in new visual studio ...
if 		defined _srcLine call :openVs.impl "%slnFile%" /Command "Edit.Goto %_srcLine%" "%localSrc%"
if not 	defined _srcLine call :openVs.impl "%slnFile%"
goto :eof

:openVs.runningVs
rem vs bug : vs2017 can't goto the line correctly : devenv.exe /Edit "theCpp.cpp" /Command "Edit.Goto 25"
:: echo open file in current running visual studio ...
if 		defined _srcLine call :openVs.impl /Edit "%localSrc%" /Command "Edit.Goto %_srcLine%"
if not 	defined _srcLine call :openVs.impl "%slnFile%"
goto :eof

:openVs.impl
call tools_path.bat FindAppPathByExt ".sln" devenvPath
rem where devenv.exe 1>nul 2>nul || set "path=C:\Program Files (x86)\Microsoft Visual Studio\2017\Professional\Common7\IDE;%path%"
if not exist "%devenvPath%" echo can't find "%devenvPath%" & pause & exit /b 1
if defined _Debug echo devenvPath : %devenvPath%
echo "%devenvPath%" %*
start "" "%devenvPath%" %*
if not defined NoTimeOut call timeout /t 20
goto :eof
::*****************************************************************************************************************************

:END
@echo.
@if defined _Stack @for %%a in ( 1 "%~nx0" "%0" ) do @if {"%%~a"}=={"%_Stack%"} @echo [----- %~nx0] commandLine: %0 %* & @echo.
