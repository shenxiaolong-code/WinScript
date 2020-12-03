::Author    : Shen Xiaolong((xlshen@126.com))
::Copyright : free use,modify,spread, but MUST include this original two line information(Author and Copyright).

::@set _Echo=1
::set _Stack=%~nx0
@if {"%_Echo%"}=={"1"} ( @echo on ) else ( @echo off )
@if defined _Stack @for %%a in ( 1 "%~nx0" "%0" ) do @if {"%%~a"}=={"%_Stack%"} @echo. & @echo [+++++ %~nx0] commandLine: %0 %*
where "%~nx0" 1>nul 2>nul || set "path=%~dp0;%path%"

if {%1}=={} call :Test NoOutput & goto End
call :%~1 %2 %3 %4 %5 %6 %7 %8 %9
goto End

::[DOS_API:Help]display help information
:Help
@if defined _Stack @for %%a in ( 1 "%~nx0" "%0" ) do @if {"%%~a"}=={"%_Stack%"} @echo [      %~nx0] commandLine: %0 %*
call tools_miscellaneous.bat DisplayHelp "%~f0"
goto :eof

::[DOS_API:Test] Test DOS API in this script file
:Test
@if defined _Stack @for %%a in ( 1 "%~nx0" "%0" ) do @if {"%%~a"}=={"%_Stack%"} @echo [      %~nx0] commandLine: %0 %*
@echo [%~nx0] Run test case [%0 %*]
echo.
echo test call :Help
call :Help
echo.
goto :eof

::[DOS_API:DriverStart] start one Driver and chane Driver state to Auto , if %2 is 1, then set Driver state to Auto, else don't change state. 
::usage  	: call :DriverStart driverServiceName bAUtoFlag       	
::e.g.      : call :DriverStart "CISMBIOS"        					//start CISMBIOS Driver
::          : call :DriverStart "CISMBIOS" 1       					//start CISMBIOS Driver and set Auto
:DriverStart
set iRet=0
if {"%~1"}=={""} echo Driver name is required. & set iRet=1 & goto End
call :isDriverExist "%~1" bExist
if {%bExist%}=={0} echo Driver "%~1" doesn't exist. & set iRet=2 & goto End

call :isDriverRuning "%~1" bRuning
if %bRuning% NEQ 1 (
@echo ^>^>^>^>^>^>^>^>^>^>^>^>^>^>^>starting %1.....
call :getStartMode "%~1" tmpStartMode
if {"%tmpStartMode%"}=={"Disabled"} (
echo Driver "%~1" is disabled, now change it to "Auto", pls wait seconds...
wmic /output:null path Win32_SystemDriver where ( name ="%~1" ^) call change StartMode ^= "Auto" 
call tools_message.bat noSleepMsg "%~0" 2
echo.
)
wmic /output:null path Win32_SystemDriver where ( name ="%~1" ^) call StartService
@echo now Driver "%~1" state:
wmic path Win32_SystemDriver where (name="%~1"^) get Name,AcceptPause,AcceptStop,Description,PathName,Started,StartMode,State
) else (
echo Drivers "%~1" is runing.
)
goto :eof

::[DOS_API:DriverStop] stop one Deriver and chane Deriver state to disabled , if %2 is 1, then set Deriver state to disable, else don't change state.
::usage  	: call :DriverStop driverServiceName bDisableFlag
::e.g.      : call :DriverStop "CISMBIOS"        						//stop CISMBIOS Driver
::          : call :DriverStop "CISMBIOS" 1       					//stop CISMBIOS Driver and disable it
:DriverStop
@if defined _Stack @for %%a in ( 1 "%~nx0" "%0" ) do @if {"%%~a"}=={"%_Stack%"} @echo [      %~nx0] commandLine: %0 %*
set iRet=0
if {"%~1"}=={""} echo Deriver name is required. & set iRet=1 & goto End
wmic path Win32_SystemDriver where (name="%~1") get name 2>nul | find /i "name" > nul
if %errorlevel% NEQ 0 echo Deriver "%~1" doesn't exist. & set iRet=2 & goto End

::wmic path Win32_SystemDriver where name="%~1" get state | more +1 | find /i "Running"
wmic path Win32_SystemDriver where (name="%~1") get STATE 2>nul | find /i "Running" > nul
if %errorlevel% EQU 0 (
@echo ^>^>^>^>^>^>^>^>^>^>^>^>^>^>^>Stoping "%~1".....
wmic /output:null path Win32_SystemDriver where (name="%~1"^) call StopService
if {%~2}=={1} wmic /output:null path Win32_SystemDriver where ( name ="%~1" ^) call change StartMode = "disabled"
@echo now Deriver "%~1" state:
wmic path Win32_SystemDriver where (name="%~1"^) get Name,AcceptPause,AcceptStop,Description,PathName,Started,StartMode,State
) else (
echo Derivers "%~1" is stopped.
)
goto :eof

::[DOS_API:processDriverList] batch start or stop many driver service in one list file.
::usage  	: call :processDriverList driverListFile 	action
::e.g.      : call :processDriverList file.txt start        				//start all driver service in file.txt
::          : call :processDriverList file.txt stop       					//stop all driver service in file.txt
:processDriverList
@if defined _Stack @for %%a in ( 1 "%~nx0" "%0" ) do @if {"%%~a"}=={"%_Stack%"} @echo [      %~nx0] commandLine: %0 %*
set ListFile="%~fs1"
echo Driver List file: "%~f1"
set iRet=0
if not exist %ListFile% @echo Driver list file doesn't exist. No Driver is changed. & set iRet=2 & goto ERR
if {%2}=={stop}		( for /f "usebackq eol=; tokens=*" %%i in ( %ListFile% ) do call :DriverStop %%i )   & goto End
if {%2}=={start} 	( for /f "usebackq eol=; tokens=*" %%i in ( %ListFile% ) do call :DriverStart %%i  ) & goto End
call tools_message.bat popMsg "Wrong 2nd parameter[%2],2nd parameter MUST be start or stop." & call tools_miscellaneous.bat SetErrorColor & goto Quit
@echo.
@echo %~2 '%~1' completed!
@echo. 
goto :eof

:isDriverRuning
@if defined _Stack @for %%a in ( 1 "%~nx0" "%0" ) do @if {"%%~a"}=={"%_Stack%"} @echo [      %~nx0] commandLine: %0 %*
for /f "usebackq" %%i in ( ` sc query "%~1" ^| find  "STATE" ^| find /c "RUNNING" `) do set tmpIsDriverRuning=%%i
if {%2}=={} (
    if 		{%tmpIsDriverRuning%}=={0}    @echo Driver "%~1" is NOT running
    if not 	{%tmpIsDriverRuning%}=={0}    @echo Driver "%~1" is running
) else (
	if 		{%tmpIsDriverRuning%}=={0}    set %~2=0
    if not 	{%tmpIsDriverRuning%}=={0}    set %~2=1
)
goto :eof

:isDriverExist
@if defined _Stack @for %%a in ( 1 "%~nx0" "%0" ) do @if {"%%~a"}=={"%_Stack%"} @echo [      %~nx0] commandLine: %0 %*
if {"%~1"}=={""} call tools_message.bat popMsg "first parameter can't be empty".  & goto :eof
wmic path Win32_SystemDriver where (name="%~1") get name 2>nul | find /i "name" > nul
if %errorlevel% NEQ 0  (
	set tmpIsDriverExist=0
) else (
	set tmpIsDriverExist=1
)
if {%2}=={} (
    if {%tmpIsDriverExist%}=={1}    @echo Driver "%~1" exists
    if {%tmpIsDriverExist%}=={0}    @echo Driver "%~1" doesn't exists
) else (
    set %~2=%tmpIsDriverExist%
)
goto :eof

:getStartMode
@if defined _Stack @for %%a in ( 1 "%~nx0" "%0" ) do @if {"%%~a"}=={"%_Stack%"} @echo [      %~nx0] commandLine: %0 %*
call :isDriverExist "%~1" bGetStartMode
if {%bGetStartMode%}=={0} call tools_message.bat popMsg "Driver[%1] doesn't exist ".  & goto :eof
for /f "usebackq tokens=*" %%i in ( ` wmic path Win32_SystemDriver where name^="%~1" get StartMode ^| find /v "Mode" ^| find /i "a" ` ) do ( if not {"%%~i"}=={""} set tmpGetStartMode=%%i )
call tools_string.bat TrimString %tmpGetStartMode% tmpGetStartMode
if {"%tmpGetStartMode%"}=={""} call tools_message.bat popMsg "getStartMode[%1] fails ".  & goto :eof 
if {"%~2"}=={""} (
    echo %tmpGetStartMode%
) else (
    set %~2=%tmpGetStartMode%
)
goto :eof

:End
@if defined _Stack @for %%a in ( 1 "%~nx0" "%0" ) do @if {"%%~a"}=={"%_Stack%"} @echo [----- %~nx0] commandLine: %0 %* & @echo.