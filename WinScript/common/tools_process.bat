::Author    : Shen Xiaolong((xlshen@126.com))
::Copyright : free use,modify,spread, but MUST include this original two line information(Author and Copyright).

::@set _Echo=1
::set _Stack=%~nx0
@if {"%_Echo%"}=={"1"} ( @echo on ) else ( @echo off )
@if defined _Stack @for %%a in ( 1 "%~nx0" "%0" ) do @if {"%%~a"}=={"%_Stack%"} @echo. & @echo [+++++ %~nx0] commandLine: %0 %*
where %~nx0 1>nul 2>nul || set "path=%~dp0;%path%"

if {%1}=={} call :Test  & goto End
::if {%1}=={} call :Test NoOutput & goto End

call :%1 %2 %3 %4 %5 %6 %7 %8 %9
goto End

::[DOS_API:getProductID]get process name by process ID
::usage     : call :getProductID inProductName  outputProductID
::call e.g. : call :getProductID "Webex Teams"  outputProductID
::            set outputProductID=HKEY_USERS\S-1-5-21-3509152278-4230339519-3976194755-1001\Software\Microsoft\Installer\Products\85C074E92A6990D4483B2618251A7911
:getProductID
@if defined _Stack @for %%a in ( 1 "%~nx0" "%0" ) do @if {"%%~a"}=={"%_Stack%"} @echo [      %~nx0] commandLine: %0 %*
set "%~2="
call tools_userAccount.bat getuserSID _tmpUserSID
if not defined _tmpUserSID call tools_message.bat errorMsg "Fails to find current user ID." "%~fs0" "getProductID.mark1"
for /f "usebackq tokens=*" %%i in ( ` @reg query %regKey% ` ) do if not defined %~2 call :getProductID.test "%~1" %~2 %%~i 
goto :eof

:getProductID.test
@if defined _Stack @for %%a in ( 1 "%~nx0" "%0" ) do @if {"%%~a"}=={"%_Stack%"} @echo [      %~nx0] commandLine: %0 %*
for /f "usebackq tokens=1,2,*" %%a in (` @reg query "%~3" /v ProductName 2^>nul `) do if  {"%%~c"}=={"%~1"} set "%~2=%~3"
goto :eof

::[DOS_API:getNameByPID]get process name by process ID
::usage     : call :getNameByPID processName
::call e.g. : call :getNameByPID "notepad.exe"
:getNameByPID
@if defined _Stack @for %%a in ( 1 "%~nx0" "%0" ) do @if {"%%~a"}=={"%_Stack%"} @echo [      %~nx0] commandLine: %0 %*
if {"%~1"}=={""} call tools_message.bat errorMsg "process full ID or full name is reuired." "%~f0" "getName.mark"
call :imageNameProcess getName %*
goto :eof

::[DOS_API:findAppMainPid] find main process for one multiple process application
::call e.g  : call :findAppMainPid AppName outputPID
:findAppMainPid
@if defined _Stack @for %%a in ( 1 "%~nx0" "%0" ) do @if {"%%~a"}=={"%_Stack%"} @echo [      %~nx0] commandLine: %0 %*
set appProcessList=%temp%\%~n0_PIDs.txt
if exist "%appProcessList%" del /f/q "%appProcessList%"
WMIC /OUTPUT:"%appProcessList%" path win32_process where name="%~1" get Processid,Commandline /format:list
set ProcessId=
for /f "usebackq tokens=* delims==" %%i in  ( ` type "%appProcessList%" ` ) do if not defined ProcessId call set %%i
call tools_message.bat enableDebugMsg "%~0" "ProcessId=%ProcessId%"
call tools_message.bat enableDebugMsg "%~0" "CommandLine=%CommandLine%"
call tools_message.bat enableDebugCmd "%~0" type "%appProcessList%"
call set %~2=%Processid%
goto :eof

::[DOS_API:getFirstPID]get process ID by process name
::usage     : call :getFirstPID processName outVar
::call e.g. : call :getFirstPID "notepad.exe" 
::          : call :getFirstPID "notepad.exe" outVar
::          : call :getFirstPID 1254
::          : call :getFirstPID 1254 outVar
:getFirstPID
@if defined _Stack @for %%a in ( 1 "%~nx0" "%0" ) do @if {"%%~a"}=={"%_Stack%"} @echo [      %~nx0] commandLine: %0 %*
if {"%~1"}=={""} call tools_message.bat errorMsg "process full ID or full name is reuired." "%~f0" "getPID.mark"
call :imageNameProcess getPID %*
goto :eof

::[DOS_API:getPID]get process ID by process name
::usage     : call :getPID processName outVar
::call e.g. : call :getPID "notepad.exe" 
::          : call :getPID "notepad.exe" outVar
::          : call :getPID 1254
::          : call :getPID 1254 outVar
:getPID
@if defined _Stack @for %%a in ( 1 "%~nx0" "%0" ) do @if {"%%~a"}=={"%_Stack%"} @echo [      %~nx0] commandLine: %0 %*
call colorTxt.bat green_L "getPID is out-dated API, please use new API 'getFirstPID' ."
echo.
call :getFirstPID %*
goto :eof

::[DOS_API:getCurPID] get current console window process ID
::call e.g  : call :getCurPID outputProcessID
::          : set outputProcessID=4535
:getCurPID
@if defined _Stack @for %%a in ( 1 "%~nx0" "%0" ) do @if {"%%~a"}=={"%_Stack%"} @echo [      %~nx0] commandLine: %0 %*
::for /f "usebackq tokens=1" %%i in ( ` powershell ( Get-WmiObject Win32_Process -Filter ProcessId=$PID ).ParentProcessId ` ) do call set %~1=%%i
for /f "usebackq tokens=1,2,3" %%i in ( ` powershell  Get-WmiObject Win32_Process -Filter ProcessId^=$PID  ^| find /i "ParentProcessId" ` ) do call set %~1=%%k
goto :eof

::[DOS_API:getPIDByName]get process ID by process name
::usage     : call :getPIDByName processName
::call e.g. : call :getPIDByName "notepad.exe"
:getPIDByName
@if defined _Stack @for %%a in ( 1 "%~nx0" "%0" ) do @if {"%%~a"}=={"%_Stack%"} @echo [      %~nx0] commandLine: %0 %*
call colorTxt.bat green_L "getPIDByName is out-dated API, please use new API 'getFirstPID' ."
echo.
call :getFirstPID %*
goto :eof

::[DOS_API:isProcessExist]check processby process name, 2nd parameter is output result
::usage     : call :isProcessExist processName retVal
::call e.g. : call :isProcessExist "notepad.exe" retVal
::          : call :isProcessExist 2315 retVal
:isProcessExist
@if defined _Stack @for %%a in ( 1 "%~nx0" "%0" ) do @if {"%%~a"}=={"%_Stack%"} @echo [      %~nx0] commandLine: %0 %*
if {"%~1"}=={""} call tools_message.bat errorMsg "process full ID or full name is reuired." "%~f0" "isProcessExist.mark"
call :getProcessCount "%~1" _processCount
if {%_processCount%}=={0}       call set %~2=0
if not {%_processCount%}=={0}   call set %~2=1
goto :eof

::[DOS_API:getProcessCount]get process account by process name
::usage     : call :getProcessCount processName  oProcNumber
::call e.g. : call :getProcessCount "notepad.exe" oProcNumber
:getProcessCount
call tools_error.bat checkParamCount 2 %*
for /f "usebackq" %%i in ( ` tasklist ^| find /c "%~1" ` ) do call set %~2=%%i
goto :eof

::[DOS_API:getProcessCmdLine]check process startup command Line
::usage      : call :getProcessCmdLine PID cmdLine
::call e.g   : call :getProcessCmdLine 3352 cmdLine
::result e.g : set cmdLine=x86
:getProcessCmdLine
@if defined _Stack @for %%a in ( 1 "%~nx0" "%0" ) do @if {"%%~a"}=={"%_Stack%"} @echo [      %~nx0] commandLine: %0 %*
call tools_error.bat checkParamCount 2 %*
call :isProcessExist "%~1" _tmpPidExist
if not {"%_tmpPidExist%"}=={"1"} call tools_message.bat errorMsg "process '%~1' is NOT exist".
set %~2=
:: wmic  process WHERE ( Handle="1123" ) get commandline
:: wmic  process WHERE ( Name="Code.exe" ) get commandline
for /f "usebackq tokens=*" %%a in ( `wmic  process WHERE ^( Handle^="%~1" ^) get commandline ^| more +1 ` ) do if not defined %~2 call set %~2=%%a
goto :eof

::[DOS_API:ExecutablePath]check process executable Path
::usage      : call :ExecutablePath PID appPath
::call e.g   : call :ExecutablePath 3352 appPath
::result e.g : set appPath=D:\myPath\myApp.exe
:ExecutablePath
@if defined _Stack @for %%a in ( 1 "%~nx0" "%0" ) do @if {"%%~a"}=={"%_Stack%"} @echo [      %~nx0] commandLine: %0 %*
call tools_error.bat checkParamCount 2 %*
call :isProcessExist "%~1" _tmpPidExist
if not {"%_tmpPidExist%"}=={"1"} call tools_message.bat errorMsg "process '%~1' is NOT exist".
set %~2=
for /f "usebackq tokens=*" %%a in ( `wmic  process WHERE ^( Handle^="%~1" ^) get ExecutablePath ^| find /v "ExecutablePath" ` ) do if not defined %~2 call set %~2=%%~sa
goto :eof

::[DOS_API:uninstallApp]uninstall a application. the application name can be queried in Appwiz.cpl.
::usage      : call :uninstallApp <appProductName>
::call e.g   : call :uninstallApp "Cisco Jabber"
:uninstallApp
@if defined _Stack @for %%a in ( 1 "%~nx0" "%0" ) do @if {"%%~a"}=={"%_Stack%"} @echo [      %~nx0] commandLine: %0 %*
call tools_error.bat checkParamCount 1 %*
:: msiinv is faster
call :uninstallApp.msiinv %*
if not defined _productCode call :uninstallApp.wmic %*
goto :eof

:uninstallApp.wmic
@if defined _Stack @for %%a in ( 1 "%~nx0" "%0" ) do @if {"%%~a"}=={"%_Stack%"} @echo [      %~nx0] commandLine: %0 %*
:: https://medium.com/@andrew.perfiliev/how-to-uninstall-program-using-cmd-60911c0eee80
call wmic product where name="%~1" call uninstall /nointeractive
goto :eof

:uninstallApp.msiinv
@if defined _Stack @for %%a in ( 1 "%~nx0" "%0" ) do @if {"%%~a"}=={"%_Stack%"} @echo [      %~nx0] commandLine: %0 %*
set _productCode=
set _tmp_uninstallStr=
where msiinv.exe 1>nul 2>nul || @set "path=%myPcToolsPath%\installer_reg_fix;%path%"
for /f "usebackq tokens=3" %%i in ( ` msiinv.exe -p "%~1" ^| find /i "Product code" ` ) do call set _productCode=%%i
::product info in register : HKEY_LOCAL_MACHINE\SOFTWARE\WOW6432Node\Microsoft\Windows\CurrentVersion\Uninstall\%_productCode%
::e.g. :
::HKEY_LOCAL_MACHINE\SOFTWARE\WOW6432Node\Microsoft\Windows\CurrentVersion\Uninstall\{ACD11FE6-110C-417A-B87D-56E8DE2680D4}
::set _tmp_uninstallStr=MsiExec.exe /X{DBB5980F-1D69-4E00-BD12-FE24639BD102}
if defined _productCode call set _tmp_uninstallStr=MsiExec.exe /X%_productCode%
if defined _tmp_uninstallStr call %_tmp_uninstallStr%
goto :eof

::[DOS_API:queryApp] query a application information. the application name can be queried in Appwiz.cpl.
::usage      : call :queryApp <appProductName>
::call e.g   : call :queryApp "Cisco Jabber"
:queryApp
@if defined _Stack @for %%a in ( 1 "%~nx0" "%0" ) do @if {"%%~a"}=={"%_Stack%"} @echo [      %~nx0] commandLine: %0 %*
:: https://medium.com/@andrew.perfiliev/how-to-uninstall-program-using-cmd-60911c0eee80
call tools_error.bat checkParamCount 1 %*
call wmic product where name="%~1" list full
goto :eof

::[DOS_API:startProcess]start application, the AppName can be full path name or short name (but it MUST can be found in environment variable "Path")
::usage     : call :startProcess AppName
::call e.g. : call :startProcess "notepad.exe"
:startProcess
@if defined _Stack @for %%a in ( 1 "%~nx0" "%0" ) do @if {"%%~a"}=={"%_Stack%"} @echo [      %~nx0] commandLine: %0 %*
if {"%~1"}=={""} call tools_message.bat errorMsg "application full path is reuired." "%~f0" "startProcess.mark"
if not exist %~s$PATH:1 call tools_message.bat errorMsg "File [%~1] doesn't exist,function 'startProcess' fails." "%~f0" "startProcess.mark1"
echo ^>^>^>^>^>^>^>^>^>^>^>^>^>^>^>start %~$PATH:1 %~2 %~3 %~4 %~5
start %~s$PATH:1 %~2 %~3 %~4 %~5
goto :eof

::[DOS_API:killProcess]kill process by process name
::usage     : call :killProcess processName
::call e.g. : call :killProcess "notepad.exe"
:killProcess
@if defined _Stack @for %%a in ( 1 "%~nx0" "%0" ) do @if {"%%~a"}=={"%_Stack%"} @echo [      %~nx0] commandLine: %0 %*
if {"%~1"}=={""} call tools_message.bat errorMsg "process full ID or full name is reuired." "%~f0" "killProcess.mark"
tasklist | find /i "%~nx1" > nul
if %errorlevel% NEQ 0 echo process %~nx1 doesn't exist. & set iRet=2 & goto :eof

@echo process information :
tasklist | find /i "%~nx1"
@echo ^>^>^>^>^>^>^>^>^>^>^>^>^>^>^>kill process "%~nx1"
::ntsd -c "q" -pn %1
::wmic /node:"%COMPUTERNAME%" process where name="%~nx1" delete
echo taskkill /T /f /im "%~nx1"
taskkill /T /f /im "%~nx1" || call tools_message.bat errorMsg "fails to killProcess '%~nx1'."
timeout 1 1>nul
goto :eof

::[DOS_API:killProcess.processListFile]kill process by process name
::usage     : call :killProcess.processListFile processListFile
::call e.g. : call :killProcess.processListFile "D:\list.txt"
:killProcess.processListFile
@if defined _Stack @for %%a in ( 1 "%~nx0" "%0" ) do @if {"%%~a"}=={"%_Stack%"} @echo [      %~nx0] commandLine: %0 %*
if not exist "%~f1" goto :eof
for /f "usebackq eol=; tokens=*" %%i in ( %~fs1 ) do if not {%%i}=={} call :killProcess "%~nx1"
goto :eof

::[DOS_API:processinfo] Display process information by process ID
::usage     : call :processinfo ProcessID
::call e.g. : call :processinfo 5463
:processinfo
@if defined _Stack @for %%a in ( 1 "%~nx0" "%0" ) do @if {"%%~a"}=={"%_Stack%"} @echo [      %~nx0] commandLine: %0 %*
@echo process[%~1] info: 
tasklist /fi "PID eq %~1" 
wmic  process WHERE ( Handle="%~1" ) get handle,name,commandline,ThreadCount
goto :eof

::*************************************************************************************
:imageNameProcess  subfuncName  %*
@if defined _Stack @for %%a in ( 1 "%~nx0" "%0" ) do @if {"%%~a"}=={"%_Stack%"} @echo [      %~nx0] commandLine: %0 %*
set %~2=
for /f "usebackq tokens=*" %%a in ( ` tasklist ^| find /i "%~nx2" ` ) do (
call tools_message.bat enableDebugMsg "%~0" "%%a"
if not defined %~3 call :imageNameProcess.%~1 %~3 %%a
)
goto :eof

:imageNameProcess.getName
@if defined _Stack @for %%a in ( 1 "%~nx0" "%0" ) do @if {"%%~a"}=={"%_Stack%"} @echo [      %~nx0] commandLine: %0 %*
set %~1=%~2
goto :eof

:imageNameProcess.getPID
@if defined _Stack @for %%a in ( 1 "%~nx0" "%0" ) do @if {"%%~a"}=={"%_Stack%"} @echo [      %~nx0] commandLine: %0 %*
set %~1=%~3
goto :eof

::*************************************************************************************
::[DOS_API:Help]display help information
:Help
@if defined _Stack @for %%a in ( 1 "%~nx0" "%0" ) do @if {"%%~a"}=={"%_Stack%"} @echo [      %~nx0] commandLine: %0 %*
call %~dp0.\tools_miscellaneous.bat DisplayHelp "%~f0"
goto :eof

::[DOS_API:Test]Test DOS API in this script file
:Test
@if defined _Stack @for %%a in ( 1 "%~nx0" "%0" ) do @if {"%%~a"}=={"%_Stack%"} @echo [      %~nx0] commandLine: %0 %*
@echo [%~nx0] Run test case [%0 %*]
echo.
echo test call :Help
call :Help

echo.
echo test call :getProductID "Webex Teams"  outputProductID
call :getProductID "Webex Teams"  outputProductID
echo outputProductID=%outputProductID%

echo.
echo test call :queryApp "Cisco Jabber"
call :queryApp "Cisco Jabber"

echo.
echo test call :startProcess notepad.exe
call :startProcess notepad.exe

echo.
echo test call :killProcess notepad.exe
call :killProcess notepad.exe

echo.
echo test call :findAppMainPid chrome.exe mPid
call :findAppMainPid chrome.exe mPid
echo mPid=%mPid%

echo.
echo test call :getCurPID myPID
call :getCurPID myPID
echo current test console window process ID : %myPID%

echo.
echo test call :getPIDByName "explorer.exe" explorerPid
call :getPIDByName "explorer.exe" explorerPid
echo explorerPid=%explorerPid%

echo.
echo test call :isProcessExist "explorer.exe"
call :isProcessExist "explorer.exe"
if {%errorlevel%}=={1} ( echo explorer.exe exist ) else  echo explorer.exe doesn't exist.

echo.
echo test call :isProcessExist "notepad.exe"
call :isProcessExist "notepad.exe"
if {%errorlevel%}=={1} ( echo notepad.exe exist ) else  echo notepad.exe doesn't exist.

echo.
call :getPIDByName "explorer.exe" TmpPID
echo test call :getNameByPID %TmpPID%
call :getNameByPID %TmpPID% appName
echo appName=%appName%

echo.
echo test call :processinfo
call :processinfo %TmpPID%
goto :eof

:End
@if defined _Stack @for %%a in ( 1 "%~nx0" "%0" ) do @if {"%%~a"}=={"%_Stack%"} @echo [----- %~nx0] commandLine: %0 %* & @echo.
exit /b %iRet%