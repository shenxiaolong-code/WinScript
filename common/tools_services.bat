::Author    : Shen Xiaolong((xlshen@126.com))
::Copyright : free use,modify,spread, but MUST include this original two line information(Author and Copyright).

::@set _Echo=1
::set _Stack=%~nx0
@if {%_Echo%}=={1} ( @echo on ) else ( @echo off )
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


::[DOS_API:serviceStart] start one service and chane service state to automatic , if %2 is 1, then set service state to automatic, else don't change state.
::usage  	: call :serviceStart driverServiceName bAUtoFlag       	
::e.g.      : call :serviceStart "Themes"        					//start Themes service
::          : call :serviceStart "Themes" 1       					//start Themes service and set automatic
:serviceStart
set iRet=0
if {"%~1"}=={""} echo service name is required. & set iRet=1 & goto End
call :isServiceExist "%~1" bExist
if {%bExist%}=={0} echo service "%~1" doesn't exist. & set iRet=2 & goto End

call :isServiceRuning "%~1" bRuning
if %bRuning% EQU 1 echo services "%~1" is runing. & goto End

:: case : %bRuning% NEQ 1
call :getStartMode "%~1" tmpStartMode
if {"%tmpStartMode%"}=={"Disabled"} call :checkFixStartMode "%~1"
call :serviceStart.impl "%~1"
goto :eof

::[DOS_API:serviceStop] stop one service and chane service state to disabled , if %2 is disable, then set service state to disable, else don't change state.
::usage  	: call :serviceStop driverServiceName bDisableFlag       	
::e.g.      : call :serviceStop "Themes"        					//stop Themes service
::          : call :serviceStop "Themes" disable       				//stop Themes service and disable it
:serviceStop
set iRet=0
if {"%~1"}=={""} echo service name is required. & set iRet=1 & goto End
::sc qc %1 > nul
wmic service where name="%~1" get state 2>nul | find /i "Running" > nul
if %errorlevel% NEQ 0 echo service "%~1" doesn't exist. & set iRet=2 & goto End

::wmic service where name="%~1" get state | more +1 | find /i "Running"
sc query "%~1" | find  "STATE" | find /c "RUNNING" > nul
if %errorlevel% NEQ 0 echo services "%~1" is stopped. & set iRet=2 & goto End

::check whether need to change startMode
if {%~2}=={disable} wmic /output:null service where ( name ="%~1" ^) call change StartMode = "disabled"

call :serviceStop.impl "%~1"
goto End

:serviceStop.impl
::@echo ^>^>^>^>^>^>^>^>^>^>^>^>^>^>^>Stoping "%~1" , now service "%~1" state:
wmic /output:null service where (name="%~1"^) call StopService
wmic service where (name="%~1"^) get name,state,startmode,pathname | more +1
goto :eof


::[DOS_API:processServiceList] batch start or stop many driver service in one list file.
::usage  	: call :processServiceList driverListFile 	action
::e.g.      : call :processServiceList file.txt start        				//start all service in file.txt
::          : call :processServiceList file.txt stop       					//stop all service in file.txt
:processServiceList
set ListFile="%~fs1"
echo Service List file: "%~f1"
set iRet=0
if not exist %ListFile% @echo Service list file doesn't exist. No service is changed. & set iRet=2 & goto ERR
if {%2}=={stop}		( for /f "usebackq eol=; tokens=*" %%i in ( %ListFile% ) do if not {%%i}=={} call ServiceStop %%i )   & goto End
if {%2}=={start} 	( for /f "usebackq eol=; tokens=*" %%i in ( %ListFile% ) do if not {%%i}=={} call ServiceStart %%i  ) & goto End
call tools_message.bat popMsg "Wrong 2nd parameter[%2],2nd parameter MUST be start or stop." & call tools_miscellaneous.bat SetErrorColor & goto Quit

@echo. 
@echo %~2 '%~1' completed!
@echo. 
goto :eof

::[DOS_API:showAllServices] Display all services.
::usage  	: call :showAllServices
:showAllServices
@if defined _Stack @for %%a in ( 1 "%~nx0" "%0" ) do @if {"%%~a"}=={"%_Stack%"} @echo [      %~nx0] commandLine: %0 %*
::wmic service get pathname,name,processid,startmode,state
set "_tmpServiceFile=%~1"
if not defined _tmpServiceFile set "_tmpServiceFile=%temp%\allServices.txt"
wmic service get name,processid,startmode,state > "%_tmpServiceFile%"
type "%_tmpServiceFile%"
goto :eof

::[DOS_API:showMatchedServides] Display all services whose name includes specified string.
::usage  	: call :showMatchedServides abc
:showMatchedServides
@if defined _Stack @for %%a in ( 1 "%~nx0" "%0" ) do @if {"%%~a"}=={"%_Stack%"} @echo [      %~nx0] commandLine: %0 %*
wmic service where(name like "%%%~1%%")  get name,startmode,state | more +1
::wmic service where(name like "%%~1%" and startmode!="disabled"  )  get name,startmode,state | more +1
goto :eof

:checkFixStartMode
echo service "%~1" is disabled, now change it to "Automatic", pls wait seconds...
wmic /output:null service where ( name ="%~1" ^) call change StartMode ^= "Automatic" 
call tools_message.bat noSleepMsg "%~0" 2
echo.
goto :eof

:serviceStart.impl
@echo ^>^>^>^>^>^>^>^>^>^>^>^>^>^>^>starting %1.....
wmic /output:null service where ( name ="%~1" ^) call StartService
@echo now service "%~1" state:
wmic service where (name="%~1"^) get name,state,startmode,pathname
goto :eof

:isServiceRuning
@if defined _Stack @for %%a in ( 1 "%~nx0" "%0" ) do @if {"%%~a"}=={"%_Stack%"} @echo [      %~nx0] commandLine: %0 %*
for /f "usebackq" %%i in ( ` sc query "%~1" ^| find  "STATE" ^| find /c "RUNNING" `) do set tmpIsServiceRuning=%%i
if {%2}=={} (
    if 		{%tmpIsServiceRuning%}=={0}    @echo service "%~1" is NOT running
    if not 	{%tmpIsServiceRuning%}=={0}    @echo service "%~1" is running
) else (
	if 		{%tmpIsServiceRuning%}=={0}    set %~2=0
    if not 	{%tmpIsServiceRuning%}=={0}    set %~2=1
)
goto :eof

:isServiceExist
@if defined _Stack @for %%a in ( 1 "%~nx0" "%0" ) do @if {"%%~a"}=={"%_Stack%"} @echo [      %~nx0] commandLine: %0 %*
if {"%~1"}=={""} call tools_message.bat popMsg "first parameter can't be empty".  & goto :eof
sc qc "%~1" > nul
if %errorlevel% NEQ 0  (
	set tmpIsServiceExist=0
) else (
	set tmpIsServiceExist=1
)
if {%2}=={} (
    if {%tmpIsServiceExist%}=={1}    @echo service "%~1" exists
    if {%tmpIsServiceExist%}=={0}    @echo service "%~1" doesn't exists
) else (
    set %~2=%tmpIsServiceExist%
)
goto :eof

:getStartMode
@if defined _Stack @for %%a in ( 1 "%~nx0" "%0" ) do @if {"%%~a"}=={"%_Stack%"} @echo [      %~nx0] commandLine: %0 %*
call :isServiceExist "%~1" bGetStartMode
if {%bGetStartMode%}=={0} call tools_message.bat popMsg "service[%1] doesn't exist ".  & goto :eof
for /f "usebackq tokens=*" %%i in ( ` wmic service where name^="%~1" get StartMode ^| find /v "Mode" ^| find /i "a" ` ) do ( if not {"%%~i"}=={""} set tmpGetStartMode=%%i )
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