::Author  	: Shen Xiaolong((xlshen@126.com))
::Copyright	: free use,modify,spread, but MUST include this original two line information.

::@set _Echo=1
::set _Stack=%~nx0
::set _Debug=1
@if {"%_Echo%"}=={"1"} ( @echo on ) else ( @echo off )
@if defined _Stack @for %%a in ( 1 "%~nx0" "%0" ) do @if {"%%~a"}=={"%_Stack%"} @echo. & @echo [+++++ %~nx0] commandLine: %0 %*
rem title length limited to 256 chars , else dos will report "Not enough memory resources are available to process this command"
rem @title %0 %*
@echo %~fs0 %*

::config current debug parameters
if not defined bNoBreakInThread  set bNoBreakInThread=1
if not defined bNoInitBp         set bNoInitBp=1
if not defined bDbgChildProcess  set bDbgChildProcess=1
if not defined bNoExitBp         set bNoExitBp=1
if not defined bEnableLog        set bEnableLog=1

::*****************************************************************************************************************************
@echo.
title %~n0 %*
call :setPath "%~fs0"
call tools_error.bat checkAdmin %~fs0 %*

set supportedDbgCmds=;loadEnvWindbg;config;dbgPid;dbgAppName;dbgNewInstance;genDump;analysisDmp;dumpCheck;reduceCache;downloadPdb;readPdb;writePdb;pdbInfo;dbhCheck;
::call :checkParameter dbgPid 2734
::call :checkParameter dbgAppName 
::call :checkParameter dbgAppName "notepad.exe"
::call :checkParameter dbgNewInstance 
::call :checkParameter dbgNewInstance "C:\myapp\app.exe" -appStartParam
::call :checkParameter analysisDmp 
::call :checkParameter analysisDmp "D:\mydump\fulldump.dmp"
call :checkParameter %*
@rem usage : processInput dbgNewInstance ApplitionFullPath RunParameters
::call :processInput dbgNewInstance "C:\Program Files (x86)\Cisco Systems\Cisco Jabber\CiscoJabber.exe" disableSingleInstance
call :%*
goto :End

::*****************************************************************************************************************************
:checkParameter
@if defined _Stack @for %%a in ( 1 "%~nx0" "%0" ) do @if {"%%~a"}=={"%_Stack%"} @echo [      %~nx0] commandLine: %0 %*
call tools_error.bat checkParamCount 1 %*
call tools_error.bat checkSupportedCmd "%~1" "%supportedDbgCmds%"
goto :eof

::*****************************************************************************************************************************
:dbgPid
@if defined _Stack @for %%a in ( 1 "%~nx0" "%0" ) do @if {"%%~a"}=={"%_Stack%"} @echo [      %~nx0] commandLine: %0 %*
set curPid=%~1
if     defined curPid       call :dbgPid.checkPID curPid %curPid%
if not defined curPid       call :dbgPid.waitPID  curPid
if not defined dbgOption    call :config.dbgOption.live  attachPid %~1
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
if not defined windbgMode call tools_isX86X64.bat IsX86OrX64Process "%1" windbgMode
if not {%windbgMode%}=={""} call :config.applyWindbgMode "%windbgMode%"
call tools_process.bat getProcessCmdLine  %1 _tmpCmdLine
cd /d "%_tmpCmdLine%\.."
call :windbg.load -T "attach process:%1" %dbgOption% -p %1
goto :eof

::*****************************************************************************************************************************
:dbgAppName
@if defined _Stack @for %%a in ( 1 "%~nx0" "%0" ) do @if {"%%~a"}=={"%_Stack%"} @echo [      %~nx0] commandLine: %0 %*
set "_appName=%~n1"
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

set bNoInitBp=0
if not defined dbgOption call :config.dbgOption.live  newInstancePath "%~f1"
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
@echo debug option                  : %dbgOption%
@echo **************************************************************************************
@echo.
call tools_message.bat noSleepMsg "%~0" 2
goto :eof

:dbgNewInstance.load
@if defined _Stack @for %%a in ( 1 "%~nx0" "%0" ) do @if {"%%~a"}=={"%_Stack%"} @echo [      %~nx0] commandLine: %0 %*
if not defined windbgMode call tools_isX86X64.bat IsX86OrX64Mod "%~f1" windbgMode
if not {%windbgMode%}=={""} call :config.applyWindbgMode "%windbgMode%"
echo Disable BSTR Caching to prevent UMDH from uncorrectly determining the owner of a memory allocation
set OANOCACHE=1
@echo.
@echo startNewInstance : %~f1
cd /d "%~dp1"
call :windbg.load %dbgOption% "%~f1" %AppParam%
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
if     defined _dmpFile call :analysisDmp.verifyDmpFile "%~fs1"
if not defined _dmpFile call :analysisDmp.waitDmpFile   _dmpFile
call :dmpFile.checkSize "%~f1"
if not defined dbgOption call :config.dbgOption.dmp  "%~f1"
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
call tools_error.bat checkPathExist "%~fs1" "%~fs0" analysisDmp.verifyDmpFile_mark11
set extName=%~x1
call tools_string.bat toLower extName
if not {"%extName%"}=={".dmp"} call tools_message.bat errorMsg "%~nx2 is not a dump file -- .dmp"
goto :eof

:analysisDmp.info
@if defined _Stack @for %%a in ( 1 "%~nx0" "%0" ) do @if {"%%~a"}=={"%_Stack%"} @echo [      %~nx0] commandLine: %0 %*
@echo **************************************************************************************
@echo dump file path                : %~f1
@echo debug option                  : %dbgOption%
@echo **************************************************************************************
@echo.
call tools_message.bat noSleepMsg "%~0" 2
goto :eof

:analysisDmp.load
@if defined _Stack @for %%a in ( 1 "%~nx0" "%0" ) do @if {"%%~a"}=={"%_Stack%"} @echo [      %~nx0] commandLine: %0 %*
if not defined windbgMode call tools_isX86X64.bat IsX86OrX64Dump "%~fs1" windbgMode
if not {%windbgMode%}=={""} call :config.applyWindbgMode "%windbgMode%"
cd /d "%~dp1"
call :windbg.load %dbgOption% -z "%~f1"
goto :eof

::*****************************************************************************************************************************
:genDump
@if defined _Stack @for %%a in ( 1 "%~nx0" "%0" ) do @if {"%%~a"}=={"%_Stack%"} @echo [      %~nx0] commandLine: %0 %*
rem call tools_error.bat checkFileExist "%~fs1"
set "_tmpExtName=%~x1"
call tools_string.bat toLower _tmpExtName
if not {"%_tmpExtName%"}=={".exe"} call tools_message.bat errorMsg "only executable file is supported to generate dump file."
::below can improve performance greatly.
set "dummySymPath=%temp%\emptySymbols"
if not exist "%dummySymPath%" rd "%dummySymPath%"
call tools_appInstallPath.bat FindPathWindbg _tmpWindbgPath
set "_tmpCdbPath=%_tmpWindbgPath%\x64\cdb.exe"
call tools_error.bat checkFileExist "%_tmpCdbPath%"
set _tmpDmpFilePath=%dmpFilePath%
if not defined _tmpDmpFilePath set "_tmpDmpFilePath=%temp%\%~nx1\%~n1.dmp"
call tools_path.bat checkOutputPath "%_tmpDmpFilePath%"
set _cmds="%_tmpCdbPath%" -kqm -failinc -y "%dummySymPath%" -c ".dump /o /mapwd \"%_tmpDmpFilePath%\";q" -G "%~fs1"
echo %_cmds%
if not defined _DebugQ call %_cmds%
rem call "%_tmpCdbPath%" -kqm -failinc -y "%dummySymPath%" -cf "c:\myscript\startfile.dbg" -G "%~fs1"
if not defined _DebugQ call tools_error.bat checkFileExist "%_tmpDmpFilePath%"
if not defined _DebugQ call tools_path.bat showPathInExplorer "%_tmpDmpFilePath%"
call tools_message.bat noPauseMsg "%~0"
goto :eof

:dumpCheck
@if defined _Stack @for %%a in ( 1 "%~nx0" "%0" ) do @if {"%%~a"}=={"%_Stack%"} @echo [      %~nx0] commandLine: %0 %*
call :dumpCheck.verifyDmpFile %*
call :dmpFile.checkSize "%~f1"
set "_dumpCheckFile=%~dp1_dumpCheckResult.txt"
if not exist "%_dumpCheckFile%" call :dumpCheck.generate "%~f1" "%_dumpCheckFile%"
call tools_error.bat checkFileExist "%_dumpCheckFile%"
if {"%~2"}=={""} start "" "%_dumpCheckFile%"
goto :eof

:dumpCheck.verifyDmpFile
@if defined _Stack @for %%a in ( 1 "%~nx0" "%0" ) do @if {"%%~a"}=={"%_Stack%"} @echo [      %~nx0] commandLine: %0 %*
call tools_error.bat checkFileExist "%~f1"
set extName=%~x1
call tools_string.bat toLower extName
if not {"%extName%"}=={".dmp"} call tools_message.bat errorMsg "%~nx1 is not a dump file -- .dmp"
goto :eof

:dumpCheck.generate
@if defined _Stack @for %%a in ( 1 "%~nx0" "%0" ) do @if {"%%~a"}=={"%_Stack%"} @echo [      %~nx0] commandLine: %0 %*
if not defined dmpSymbol set dmpSymbol=SRV*http://msdl.microsoft.com/download/symbols
if not defined windbgMode call tools_isX86X64.bat IsX86OrX64Dump "%~fs1" windbgMode
if not {%windbgMode%}=={""} call :config.applyWindbgMode "%windbgMode%"
call :dumpCheck.info "%~f1"
"%windbgPath%\%windbgMode%\dumpchk.exe" -y %dmpSymbol% "%~fs1" >> "%~fs2"
timeout /t 2 >> nul
goto :eof

:dumpCheck.info
@if defined _Stack @for %%a in ( 1 "%~nx0" "%0" ) do @if {"%%~a"}=={"%_Stack%"} @echo [      %~nx0] commandLine: %0 %*
@echo **************************************************************************************
@echo dump file path                : %~f1
@echo symbol path                   : %dmpSymbol%
@echo **************************************************************************************
@echo.
call tools_message.bat noSleepMsg "%~0" 2
goto :eof

::*****************************************************************************************************************************
:downloadPdb
@if defined _Stack @for %%a in ( 1 "%~nx0" "%0" ) do @if {"%%~a"}=={"%_Stack%"} @echo [      %~nx0] commandLine: %0 %*
call tools_error.bat checkPathExist "%~fs1" "%~fs0" downloadPdb_mark
call :config %*
::symchk always use x64 bit
echo call "%WindbgPath%\x64\symchk.exe" /v /if "%~fs1"
call "%WindbgPath%\x64\symchk.exe" /v /if "%~fs1"
call tools_message.bat noSleepMsg "%~0" 10
goto :eof

:readPdb
@if defined _Stack @for %%a in ( 1 "%~nx0" "%0" ) do @if {"%%~a"}=={"%_Stack%"} @echo [      %~nx0] commandLine: %0 %*
call :pdbFile.verifyPdbFile %*
set "iniFile=%~f2"
if not defined iniFile call :pdbFile.srcsrvFilePath %* iniFile
call :readPdb.generateSrcsrv %* "%iniFile%"
if not defined NoCheckPdbIniExist call tools_error.bat checkFileExist "%iniFile%"
if not defined NoOpenPdbIni       call tools_txtFile.bat openTxtFile "%iniFile%"
goto :eof

:readPdb.generateSrcsrv
@if defined _Stack @for %%a in ( 1 "%~nx0" "%0" ) do @if {"%%~a"}=={"%_Stack%"} @echo [      %~nx0] commandLine: %0 %*
call :readPdb.backup %*
pdbstr.exe -r -p:"%~fs1" -s:srcsrv > "%~f2"
if {"%~z2"}=={"0"} (
@echo warning : size is 0 [%~fs2]
del /f/q "%~fs2"
)
goto :eof

:readPdb.backup
@if defined _Stack @for %%a in ( 1 "%~nx0" "%0" ) do @if {"%%~a"}=={"%_Stack%"} @echo [      %~nx0] commandLine: %0 %*
if {"%~z2"}=={"0"} goto :eof
if not exist "%~fs2" goto :eof
call genNameByTime.bat _tmpStr
copy "%~dpnx2" "%~dpn2_readBak_%_tmpStr%%~x2" 1>nul
goto :eof

:writePdb
@if defined _Stack @for %%a in ( 1 "%~nx0" "%0" ) do @if {"%%~a"}=={"%_Stack%"} @echo [      %~nx0] commandLine: %0 %*
call :pdbFile.verifyPdbFile %*
set "iniFile=%~f2"
if not defined iniFile call :pdbFile.srcsrvFilePath %* iniFile
call tools_error.bat checkFileExist "%iniFile%"
call :writePdb.writeSrcsrv "%~f1" "%iniFile%"
goto :eof

:writePdb.writeSrcsrv
@if defined _Stack @for %%a in ( 1 "%~nx0" "%0" ) do @if {"%%~a"}=={"%_Stack%"} @echo [      %~nx0] commandLine: %0 %*
call :writePdb.backup %*
pdbstr.exe -w -p:"%~fs1" -i:"%~fs2" -s:srcsrv
goto :eof

:writePdb.backup
@if defined _Stack @for %%a in ( 1 "%~nx0" "%0" ) do @if {"%%~a"}=={"%_Stack%"} @echo [      %~nx0] commandLine: %0 %*
if not exist "%~dpn1_backup.pdb" copy "%~dpnx1" "%~dpn1_backup.pdb" 1>nul
goto :eof

:dbhCheck
@if defined _Stack @for %%a in ( 1 "%~nx0" "%0" ) do @if {"%%~a"}=={"%_Stack%"} @echo [      %~nx0] commandLine: %0 %*
call :pdbFile.verifyPdbFile %*
where dbh.exe 1>nul 2>nul || set "path=%windbgPath%\x64;%path%"
dbh.exe -?? | find /v "<"
echo type ? to show more help
dbh.exe -v "%~fs1"
goto :eof

:pdbInfo
@if defined _Stack @for %%a in ( 1 "%~nx0" "%0" ) do @if {"%%~a"}=={"%_Stack%"} @echo [      %~nx0] commandLine: %0 %*
call :pdbFile.verifyPdbFile %*
call :pdbInfo.%~2 "%~f1" 
call tools_message.bat noPauseMsg "%~0"
goto :eof

:pdbInfo.gitStream
@if defined _Stack @for %%a in ( 1 "%~nx0" "%0" ) do @if {"%%~a"}=={"%_Stack%"} @echo [      %~nx0] commandLine: %0 %*
set "gitStreamFile=%~dpn1_srcsrvGit.txt"
call pdbstr.exe -r -p:"%~fs1" -s:srcsrvGit > "%gitStreamFile%"
type "%gitStreamFile%"
goto :eof

:pdbInfo.raw
@if defined _Stack @for %%a in ( 1 "%~nx0" "%0" ) do @if {"%%~a"}=={"%_Stack%"} @echo [      %~nx0] commandLine: %0 %*
set "rawFile=%~dpn1_raw.txt"
call srctool.exe -r "%~fs1" > "%rawFile%"
type "%rawFile%"
goto :eof

:pdbInfo.src
@if defined _Stack @for %%a in ( 1 "%~nx0" "%0" ) do @if {"%%~a"}=={"%_Stack%"} @echo [      %~nx0] commandLine: %0 %*
if not defined srcCache set "srcCache=%~dp1%~n1"
if {"%srcCache:~-1%"}=={"\"} set "srcCache=%srcCache:~0,-1%"
call tools_message.bat enableDebugMsg "%~0" srctool.exe -x "%~fs1" -d:"%srcCache%"
call srctool.exe -x "%~fs1" -d:"%srcCache%"
set "srcFile=%~dpn1_srcList.txt"
if exist "%srcCache%" dir/s/b "%srcCache%" > "%srcFile%"
goto :eof

:pdbFile.setToolPath
@if defined _Stack @for %%a in ( 1 "%~nx0" "%0" ) do @if {"%%~a"}=={"%_Stack%"} @echo [      %~nx0] commandLine: %0 %*
if not defined windbgMode set windbgMode=x86
@where pdbstr.exe 1>nul 2>nul || @set "path=%windbgPath%\%windbgMode%\srcsrv;%path%"
goto :eof

:pdbFile.verifyPdbFile
@if defined _Stack @for %%a in ( 1 "%~nx0" "%0" ) do @if {"%%~a"}=={"%_Stack%"} @echo [      %~nx0] commandLine: %0 %*
call :pdbFile.setToolPath %*
call tools_error.bat checkFileExist "%~f1"
set extName=%~x1
call tools_string.bat toLower extName
if not {"%extName%"}=={".pdb"} call tools_message.bat errorMsg "%~nx1 is not a pdb file -- .pdb"
goto :eof

:pdbFile.srcsrvFilePath
@if defined _Stack @for %%a in ( 1 "%~nx0" "%0" ) do @if {"%%~a"}=={"%_Stack%"} @echo [      %~nx0] commandLine: %0 %*
call set "%~2=%~dpn1_srcsrv.ini"
goto :eof

::*****************************************************************************************************************************
:reduceCache
@if defined _Stack @for %%a in ( 1 "%~nx0" "%0" ) do @if {"%%~a"}=={"%_Stack%"} @echo [      %~nx0] commandLine: %0 %*
::different symbol tool might save symbol into different directory.
set "fileListOrFolder=%~1"
call tools_error.bat checkPathExist "%fileListOrFolder%" "%~f0" :action.reduceCache_mark
set olderDays=%~2
if not defined olderDays set olderDays=7
call tools_message.bat NotifyMsg "only keep near %olderDays% days symbol."
set "waitStringPrompt=press any key to accept current setting(%olderDays% days), or input one new days (number):"
call tools_userInput.bat waitNumber newDays 1
if defined newDays set olderDays=%newDays%
call tools_path.bat isFileExist "%fileListOrFolder%" bExist
if      {"%bExist%"}=={"1"}     call :reduceCache.folderList    "%fileListOrFolder%"
if not  {"%bExist%"}=={"1"}     call :reduceCache.folder        "%fileListOrFolder%"
goto :eof

:reduceCache.folderList
@if defined _Stack @for %%a in ( 1 "%~nx0" "%0" ) do @if {"%%~a"}=={"%_Stack%"} @echo [      %~nx0] commandLine: %0 %*
echo process folder list file : "%~fs1"
for /f "usebackq tokens=*" %%i in ( ` type "%~fs1" ` ) do call :reduceCache.folder "%%i"
goto :eof

:reduceCache.folder
@if defined _Stack @for %%a in ( 1 "%~nx0" "%0" ) do @if {"%%~a"}=={"%_Stack%"} @echo [      %~nx0] commandLine: %0 %*
if not exist "%~f1" (
call tools_message.bat NotifyMsg "symbol cache path '%~f1' doesn't exist."
goto :eof
)

set "symCachePath=%~f1"
if {"%symCachePath:~-1%"}=={"\"} set "symCachePath=%symCachePath:~0,-1%"
set "realWindbgPath=%windbgPath%\x86"
if exist "%symCachePath%\..\agestore.exe" set "realWindbgPath=%symCachePath%\.."
call tools_path.bat ToNormalPath realWindbgPath
"%realWindbgPath%\agestore.exe" "%symCachePath%" -days=%olderDays% -s -y 2>nul
echo Done : "%realWindbgPath%\agestore.exe" "%symCachePath%" -days=%olderDays% -s -y 2>nul
echo.
echo --------------------------------------------------------------------------------------
goto :eof

::****************************************************************************************************************************
:windbg.load
@if defined _Stack @for %%a in ( 1 "%~nx0" "%0" ) do @if {"%%~a"}=={"%_Stack%"} @echo [      %~nx0] commandLine: %0 %*
set actCmd="%windbgPath%\%windbgMode%\windbg.exe" %*
@echo %actCmd%
call tools_message.bat noSleepMsg "%~0" 2
start "" %actCmd%
goto :eof

:windbg.setAsDefaultDebugger
@if defined _Stack @for %%a in ( 1 "%~nx0" "%0" ) do @if {"%%~a"}=={"%_Stack%"} @echo [      %~nx0] commandLine: %0 %*
@echo set windbg.exe as default JIT debugger with quiet mode.
call :windbg.load -IS
goto :eof

::*****************************************************************************************************************************
:loadEnvWindbg
@if defined _Stack @for %%a in ( 1 "%~nx0" "%0" ) do @if {"%%~a"}=={"%_Stack%"} @echo [      %~nx0] commandLine: %0 %*
if {"%~2"}=={""} start cmd.exe /k %~fs0 loadEnvWindbg %* "reentry"
if {"%~2"}=={""} goto :eof
call tools_error.bat checkPathExist "%~1" "%~fs0" loadEnvWindbg_mark
pushd "%~1"
call tools_isX86X64.bat IsX86OrX64Folder "%cd%" windbgMode x64
where windbg.exe 1>nul 2>nul || set "path=%windbgPath%\%windbgMode%;%path%"
cls
set ls=dir/w "%windbgPath%\%windbgMode%\*.exe"
%ls%
echo.
set ls
echo use %%ls%% to show windbg tool set .
goto :eof

:config
@if defined _Stack @for %%a in ( 1 "%~nx0" "%0" ) do @if {"%%~a"}=={"%_Stack%"} @echo [      %~nx0] commandLine: %0 %*
call :config.environmetnVariable.setCacheDir %*
call :config.environmetnVariable.setDebuggerExtSearchPath %*
call :config.environmetnVariable.setIniFile
call :config.environmetnVariable.set_NT_SYMBOL_PATH %*
goto :eof

::*****************************************************************************************************************************
:setPath
@if defined _Stack @for %%a in ( 1 "%~nx0" "%0" ) do @if {"%%~a"}=={"%_Stack%"} @echo [      %~nx0] commandLine: %0 %*
for /f "usebackq tokens=2,*" %%a in ( ` dir "%~dp0.." ^| find /i "Directory of" ` ) do set "WinScriptPath=%%b"
where tools_path.bat 1>nul 2>nul || set path=%path%;%~dp1;%WinScriptPath%\common;
if not defined windbgPath call tools_appInstallPath.bat FindPathWindbg windbgPath
rem don't set default value, wait for dynamic recongnize it.
::if not defined windbgMode set windbgMode=x86
if not exist "%windbgPath%\x86\windbg.exe" call tools_message.bat errorMsg "can NOT find windbg install path. please check. "
::set windbgPath=%windbgPath%\%windbgMode%
::where windbg.exe 1>nul 2>nul || set path=%path%;%windbgPath%;
goto :eof

:findExePath.FromDump
@if defined _Stack @for %%a in ( 1 "%~nx0" "%0" ) do @if {"%%~a"}=={"%_Stack%"} @echo [      %~nx0] commandLine: %0 %*
rem call :findExePath.FromDump "c:\...\my.dmp"  exePath
set %~2=
for /f "usebackq tokens=2* delims=:" %%i in ( ` call "%windbgPath%\x64\kd.exe" -z "%~fs1" -c "|;q" ^| find /i ".exe"  ` ) do set "%~2=%%~j"
goto :eof

:findExePath.FromPid
@if defined _Stack @for %%a in ( 1 "%~nx0" "%0" ) do @if {"%%~a"}=={"%_Stack%"} @echo [      %~nx0] commandLine: %0 %*
set ExecutablePath=
for /f "usebackq tokens=*" %%i in ( ` wmic process where "handle=%~1" get ExecutablePath /format:list ^| find /i ".exe" ` ) do set %%~i
set "%~2=%ExecutablePath%"
goto :eof

::*****************************************************************************************************************************

:config.checkStartScript
@if defined _Stack @for %%a in ( 1 "%~nx0" "%0" ) do @if {"%%~a"}=={"%_Stack%"} @echo [      %~nx0] commandLine: %0 %*
if not defined _appName call tools_message.bat errorMsg "_appName is not defined" "%~fs0" config.checkStartScript_mark
if defined windbgScriptPath_%_appName% call set "startCmds_user=%%windbgScriptPath_%_appName%%%"
goto :eof

:config.dbgOption.gengerate
@if defined _Stack @for %%a in ( 1 "%~nx0" "%0" ) do @if {"%%~a"}=={"%_Stack%"} @echo [      %~nx0] commandLine: %0 %*
if {%bNoBreakInThread%}=={1} set param_NoBreakInThread=-pb
if {%bNoInitBp%}=={1}        set param_NoInitBp=-g
if {%bNoExitBp%}=={1}        set param_NoExitBp=-G
if {%bEnableLog%}=={1}       set param_logFile=-logo "%logFile%"

set param_NoSaveWorkspace=-Q

set testedThemeFile=%WinScriptPath%\Windbg\setup\layout_theme\dark_theme.wew
if not defined themeFile    if exist "%testedThemeFile%"  set themeFile=%testedThemeFile%
if defined themeFile set param_themeFile=-WF "%themeFile%"
set dbgOption=%* %param_NoSaveWorkspace% %param_NoBreakInThread% %param_NoInitBp% %param_NoExitBp% %param_themeFile% %param_logFile% -c "$$>a<%WinScriptPath%\Windbg\script\startCmds.dbg;"
echo call tools_message.bat enableDebugMsg "%~0" "dbgOption=%dbgOption:"='%"
call tools_message.bat enableDebugMsg "%~0" "dbgOption=%dbgOption:"='%"
goto :eof

:config.dbgOption.live
@if defined _Stack @for %%a in ( 1 "%~nx0" "%0" ) do @if {"%%~a"}=={"%_Stack%"} @echo [      %~nx0] commandLine: %0 %*
if {%bDbgChildProcess%}=={1} set param_DbgChildProcess=-o
call :config.dbgOption.live.%*
call :config.checkStartScript
call :config.dbgOption.gengerate %param_DbgChildProcess%
goto :eof

:config.dbgOption.dmp
@if defined _Stack @for %%a in ( 1 "%~nx0" "%0" ) do @if {"%%~a"}=={"%_Stack%"} @echo [      %~nx0] commandLine: %0 %*
if not defined logFile call :config.dbgOption.logFile.appendDT "%~f1"
call :findExePath.FromDump "%~fs1" exePath
if not defined exePath (
call "%windbgPath%\x64\dumpchk.exe" "%~fs1"
call tools_message.bat errorMsg "dump file '%~nx1' is corrupted."
)
for /f "tokens=*" %%1 in ( "%exePath%" ) do set "_appName=%%~n1"
call :config.checkStartScript
call :config.dbgOption.gengerate
goto :eof

:config.dbgOption.live.attachPid
@if defined _Stack @for %%a in ( 1 "%~nx0" "%0" ) do @if {"%%~a"}=={"%_Stack%"} @echo [      %~nx0] commandLine: %0 %*
call :findExePath.FromPid %~1 exePath
call :config.dbgOption.live.attachPid.combine "%exePath%" %~1
goto :eof

:config.dbgOption.live.attachPid.combine
@if defined _Stack @for %%a in ( 1 "%~nx0" "%0" ) do @if {"%%~a"}=={"%_Stack%"} @echo [      %~nx0] commandLine: %0 %*
set "_appName=%~n1"
if not defined logFile set "logFile=%~dpn1_windbg_%~2.log"
goto :eof

:config.dbgOption.live.newInstancePath
@if defined _Stack @for %%a in ( 1 "%~nx0" "%0" ) do @if {"%%~a"}=={"%_Stack%"} @echo [      %~nx0] commandLine: %0 %*
set "_appName=%~n1"
if not defined logFile call :config.dbgOption.logFile.appendDT "%~f1"
goto :eof

:config.dbgOption.logFile.appendDT
@if defined _Stack @for %%a in ( 1 "%~nx0" "%0" ) do @if {"%%~a"}=={"%_Stack%"} @echo [      %~nx0] commandLine: %0 %*
call genNameByTime.bat _logDT
set "logFile=%~dpn1_windbg_%_logDT%.log"
goto :eof

:config.environmetnVariable.setCacheDir
@if defined _Stack @for %%a in ( 1 "%~nx0" "%0" ) do @if {"%%~a"}=={"%_Stack%"} @echo [      %~nx0] commandLine: %0 %*
if exist "%~fs1" set "_DBGHELP_HOMEDIR=%~fs1"
if defined _DBGHELP_HOMEDIR goto :eof
if not defined defWindbgCacheDir set defWindbgCacheDir=C:\symbols
if not exist "%defWindbgCacheDir%" md "%defWindbgCacheDir%"
if not defined _DBGHELP_HOMEDIR set "_DBGHELP_HOMEDIR=%defWindbgCacheDir%"
goto :eof

:config.environmetnVariable.setDebuggerExtSearchPath
@if defined _Stack @for %%a in ( 1 "%~nx0" "%0" ) do @if {"%%~a"}=={"%_Stack%"} @echo [      %~nx0] commandLine: %0 %*
::C:\PROGRA~2\WI3CF2~1\10\DEBUGG~1\x86\windbg.exe
rem set _NT_DEBUGGER_EXTENSION_PATH to path will cause that wrong path is put on front of debugger extension search path.
rem debugger loads wrong debugger extension will cause windbg crash and exit sliently.
rem debugger loads wrong debugger extension will cause windbg crash and exit sliently.
rem bad : set "_NT_DEBUGGER_EXTENSION_PATH=%path%"
rem OK  : set "_NT_DEBUGGER_EXTENSION_PATH=%windbgPath%\%windbgMode%"
goto :eof

:config.environmetnVariable.setIniFile
@if defined _Stack @for %%a in ( 1 "%~nx0" "%0" ) do @if {"%%~a"}=={"%_Stack%"} @echo [      %~nx0] commandLine: %0 %*
if not defined SRCSRV_INI_FILE  if exist "%WinScriptPath%\Windbg\setup\srcSrv.ini" set SRCSRV_INI_FILE=%WinScriptPath%\Windbg\setup\srcSrv.ini
@echo use source server config file : %SRCSRV_INI_FILE%
goto :eof

:config.environmetnVariable.set_NT_SYMBOL_PATH
@if defined _Stack @for %%a in ( 1 "%~nx0" "%0" ) do @if {"%%~a"}=={"%_Stack%"} @echo [      %~nx0] commandLine: %0 %*
if not defined _NT_SYMBOL_PATH_MY call tools_message.bat NotifyMsg "no user-defined symbol path variable _NT_SYMBOL_PATH_MY"
if not defined _NT_SYMBOL_PATH set "_NT_SYMBOL_PATH=srv*;cache*%_DBGHELP_HOMEDIR%;SRV*http://msdl.microsoft.com/download/symbols;SRV*http://referencesource.microsoft.com/symbols;%_NT_SYMBOL_PATH_MY%;"
goto :eof

:config.applyWindbgMode
@if defined _Stack @for %%a in ( 1 "%~nx0" "%0" ) do @if {"%%~a"}=={"%_Stack%"} @echo [      %~nx0] commandLine: %0 %*
for /f "usebackq tokens=*" %%i in ( ` where Python.exe ^| find /i "Python3" ` ) do call :config.applyWindbgMode.pykdPythonVer "%~1" "%%i"
goto :eof

:config.applyWindbgMode.pykdPythonVer
rem use python 3.0 for pykd extension.
@if defined _Stack @for %%a in ( 1 "%~nx0" "%0" ) do @if {"%%~a"}=={"%_Stack%"} @echo [      %~nx0] commandLine: %0 %*
if {"%~1"}=={"x86"} set _verFilter=/i "-32"
if {"%~1"}=={"x64"} set _verFilter=/v "-32"
if {"%_verFilter%"}=={""} (
echo unsupported windbg mode for pykd extension.
echo only x86 or x64 is supported.
goto :eof
)

for /f "usebackq tokens=*" %%i in ( ` echo %~dp2^| find %_verFilter% ` ) do if not {"%%i"}=={""} set _pythonVer=%%i
if defined _pythonVer set path="%_pythonVer%";%path%
@echo used python path : %_pythonVer% for windbgMode[%~1]
goto :eof

::*****************************************************************************************************************************

:END
@if defined _Stack @for %%a in ( 1 "%~nx0" "%0" ) do @if {"%%~a"}=={"%_Stack%"} @echo [----- %~nx0] commandLine: %0 %* & @echo.