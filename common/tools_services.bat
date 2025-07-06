::Author    : Shen Xiaolong((xlshen@126.com))
::Copyright : free use,modify,spread, but MUST include this original two line information(Author and Copyright).

::@set _Echo=1
::set _Stack=%~nx0
@if {"%_Echo%"}=={"1"} ( @echo on ) else ( @echo off )
@if defined _Stack @for %%a in ( 1 "%~nx0" "%0" ) do @if {"%%~a"}=={"%_Stack%"} @echo. & @echo [+++++ %~nx0] commandLine: %0 %*
where "%~nx0" 1>nul 2>nul || set "path=%~dp0;%path%"

set cmds_%~n0="%~fs0" %*
if {%1}=={} call :Test NoOutput & goto End
call :%~1 %2 %3 %4 %5 %6 %7 %8 %9
goto End

::******************************DOS API section**************************************************************************
::[DOS_API:drivers.start] start one driver and chane driver state to automatic , if %2 is 1, then set driver state to automatic, else don't change state.
::usage  	: call :drivers.start driverServiceName bAUtoFlag       	
::e.g.      : call :drivers.start "Themes"        					//start Themes service
::          : call :drivers.start "Themes" 1       				//start Themes driver and set automatic
:drivers.start
call :startImpl driver %*
set iRet=0
if {"%~1"}=={""} echo driver name is required. & set iRet=1 & goto End
call :drivers.isExist "%~1" bExist
if {%bExist%}=={0} echo driver "%~1" doesn't exist. & set iRet=2 & goto End

call :drivers.isRuning "%~1" bRuning
if %bRuning% EQU 1 echo drivers "%~1" is runing. & goto End

:: case : %bRuning% NEQ 1
call :drivers.getStartMode "%~1" tmpStartMode
if {"%tmpStartMode%"}=={"Disabled"} call :drivers.setAutoStart "%~1"
call :startImpl driver "%~1"
:: pnputil /enable-device "PCI/..."
goto :eof

::[DOS_API:drivers.stop] stop one driver and chane driver state to disabled , if %2 is disable, then set driver state to disable, else don't change state.
::usage  	: call :drivers.stop driverServiceName bDisableFlag       	
::e.g.      : call :drivers.stop "Themes"        					//stop Themes service
::          : call :drivers.stop "Themes" disable       				//stop Themes driver and disable it
:drivers.stop
set iRet=0
if {"%~1"}=={""} echo driver name is required. & set iRet=1 & goto End
::sc qc %1 > nul
wmic sysdriver where name="%~1" get state 2>nul | find /i "Running" > nul
if %errorlevel% NEQ 0 echo driver "%~1" doesn't exist. & set iRet=2 & goto End

::wmic sysdriver where name="%~1" get state | more +1 | find /i "Running"
sc query "%~1" | find  "STATE" | find /c "RUNNING" > nul
if %errorlevel% NEQ 0 echo drivers "%~1" is stopped. & set iRet=2 & goto End

::check whether need to change startMode
if {%~2}=={disable} wmic /output:null driver where ( name ="%~1" ^) call change StartMode = "disabled"

call :stopImpl driver "%~1"
:: pnputil /disable-device "PCI/..."
goto End

::[DOS_API:drivers.processListFile] batch start or stop many driver in one list file.
::usage  	: call :drivers.processListFile driverListFile 	action
::e.g.      : call :drivers.processListFile file.txt start        				//start all driver in file.txt
::          : call :drivers.processListFile file.txt stop       					//stop all driver in file.txt
:drivers.processListFile
call :processListFile drivers %*
goto :eof

::[DOS_API:drivers.showAll] Display all drivers.
::usage  	: call :drivers.showAll
:drivers.showAll
@if defined _Stack @for %%a in ( 1 "%~nx0" "%0" ) do @if {"%%~a"}=={"%_Stack%"} @echo [      %~nx0] commandLine: %0 %*
set "_tmpServiceFile=%~1"
if not defined _tmpServiceFile set "_tmpServiceFile=%temp%\alldrivers.txt"
:: wmic sysdriver get name,startmode,state > "%_tmpServiceFile%"
echo wmic sysdriver list full 	> "%_tmpServiceFile%"
wmic sysdriver list full 		>> "%_tmpServiceFile%"
type "%_tmpServiceFile%"
goto :eof

::[DOS_API:drivers.show] Display all drivers whose name includes specified string.
::usage  	: call :drivers.show abc
:drivers.show
@if defined _Stack @for %%a in ( 1 "%~nx0" "%0" ) do @if {"%%~a"}=={"%_Stack%"} @echo [      %~nx0] commandLine: %0 %*
:: wmic sysdriver where(name like "%%%~1%%")  get name,startmode,state | more +1
wmic sysdriver where(name like "%%%~1%%") list full
::wmic sysdriver where(name like "%%~1%" and startmode!="disabled"  )  get name,startmode,state | more +1
goto :eof

::[DOS_API:drivers.setAutoStart] set driver start mode.
::usage  	: call :drivers.setAutoStart
:drivers.setAutoStart
echo driver "%~1" is disabled, now change it to "Automatic", pls wait seconds...
call :setAutoStart driver %*
goto :eof

::[DOS_API:drivers.isRuning] check whether driver is running.
::usage  	: call :drivers.isRuning
:drivers.isRuning
@if defined _Stack @for %%a in ( 1 "%~nx0" "%0" ) do @if {"%%~a"}=={"%_Stack%"} @echo [      %~nx0] commandLine: %0 %*
call :isRuning driver %*
goto :eof

::[DOS_API:drivers.isExist] check whether driver exists by name.
::usage  	: call :drivers.isExist
:drivers.isExist
@if defined _Stack @for %%a in ( 1 "%~nx0" "%0" ) do @if {"%%~a"}=={"%_Stack%"} @echo [      %~nx0] commandLine: %0 %*
call :isExist driver %*
goto :eof

::[DOS_API:drivers.getStartMode] get driver start mode.
::usage  	: call :drivers.getStartMode
:drivers.getStartMode
@if defined _Stack @for %%a in ( 1 "%~nx0" "%0" ) do @if {"%%~a"}=={"%_Stack%"} @echo [      %~nx0] commandLine: %0 %*
call :getStartMode driver %*
goto :eof

::[DOS_API:services.start] start one service and chane service state to automatic , if %2 is 1, then set service state to automatic, else don't change state.
::usage  	: call :services.start driverServiceName bAUtoFlag       	
::e.g.      : call :services.start "Themes"        					//start Themes service
::          : call :services.start "Themes" 1       				//start Themes service and set automatic
:services.start
call :startImpl service %*
set iRet=0
if {"%~1"}=={""} echo service name is required. & set iRet=1 & goto End
call :services.isExist "%~1" bExist
if {%bExist%}=={0} echo service "%~1" doesn't exist. & set iRet=2 & goto End

call :services.isRuning "%~1" bRuning
if %bRuning% EQU 1 echo services "%~1" is runing. & goto End

:: case : %bRuning% NEQ 1
call :services.getStartMode "%~1" tmpStartMode
if {"%tmpStartMode%"}=={"Disabled"} call :services.setAutoStart "%~1"
call :startImpl service "%~1"
goto :eof

::[DOS_API:services.stop] stop one service and chane service state to disabled , if %2 is disable, then set service state to disable, else don't change state.
::usage  	: call :services.stop driverServiceName bDisableFlag       	
::e.g.      : call :services.stop "Themes"        					//stop Themes service
::          : call :services.stop "Themes" disable       				//stop Themes service and disable it
:services.stop
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

call :stopImpl service "%~1"
goto End

::[DOS_API:services.processListFile] batch start or stop many driver in one list file.
::usage  	: call :services.processListFile driverListFile 	action
::e.g.      : call :services.processListFile file.txt start        				//start all service in file.txt
::          : call :services.processListFile file.txt stop       					//stop all service in file.txt
:services.processListFile
call :processListFile services %*
goto :eof

::[DOS_API:services.showAll] Display all services.
::usage  	: call :services.showAll
:services.showAll
@if defined _Stack @for %%a in ( 1 "%~nx0" "%0" ) do @if {"%%~a"}=={"%_Stack%"} @echo [      %~nx0] commandLine: %0 %*
::wmic service get pathname,name,processid,startmode,state
set "_tmpServiceFile=%~1"
if not defined _tmpServiceFile set "_tmpServiceFile=%temp%\allServices.txt"
wmic service get name,processid,startmode,state > "%_tmpServiceFile%"
type "%_tmpServiceFile%"
goto :eof

::[DOS_API:services.show] Display all services whose name includes specified string.
::usage  	: call :services.show abc
:services.show
@if defined _Stack @for %%a in ( 1 "%~nx0" "%0" ) do @if {"%%~a"}=={"%_Stack%"} @echo [      %~nx0] commandLine: %0 %*
::wmic service where(name like "%%%~1%%")  get name,startmode,state | more +1
::wmic service where(name like "%%~1%" and startmode!="disabled"  )  get name,startmode,state | more +1
wmic service where(name like "%%%~1%%") list full
goto :eof

::[DOS_API:services.setAutoStart] set service start mode.
::usage  	: call :services.setAutoStart
:services.setAutoStart
echo service "%~1" is disabled, now change it to "Automatic", pls wait seconds...
call :setAutoStart service %*
goto :eof

::[DOS_API:services.isRuning] check whether service is running.
::usage  	: call :services.isRuning
:services.isRuning
@if defined _Stack @for %%a in ( 1 "%~nx0" "%0" ) do @if {"%%~a"}=={"%_Stack%"} @echo [      %~nx0] commandLine: %0 %*
call :isRuning service %*
goto :eof

::[DOS_API:services.isExist] check whether service exists by name.
::usage  	: call :services.isExist
:services.isExist
@if defined _Stack @for %%a in ( 1 "%~nx0" "%0" ) do @if {"%%~a"}=={"%_Stack%"} @echo [      %~nx0] commandLine: %0 %*
call :isExist service %*
goto :eof

::[DOS_API:services.getStartMode] get service start mode.
::usage  	: call :services.getStartMode
:services.getStartMode
@if defined _Stack @for %%a in ( 1 "%~nx0" "%0" ) do @if {"%%~a"}=={"%_Stack%"} @echo [      %~nx0] commandLine: %0 %*
call :getStartMode service %*
goto :eof

::******************************inner implement  section**************************************************************************
:processListFile  driversOrServices listFilePath startOrStop
if not exist "%~f2" @echo %~1 list file doesn't exist. No %~1 is changed. & set iRet=2 & goto ERR
set ListFile="%~fs2"
echo %~1 List file: "%ListFile%"
set iRet=0
if {%2}=={stop}		( for /f "usebackq eol=; tokens=*" %%i in ( %ListFile% ) do if not {"%%~i"}=={""} call :%~1.stop "%%~i"     )
if {%2}=={start} 	( for /f "usebackq eol=; tokens=*" %%i in ( %ListFile% ) do if not {"%%~i"}=={""} call :%~1.start "%%~i"    )
:: call tools_message.bat popMsg "Wrong 2nd parameter[%2],2nd parameter MUST be start or stop." & call tools_miscellaneous.bat SetErrorColor & goto Quit
@echo. 
@echo %~3 '%~2' completed!
@echo. 
goto :eof

:startImpl
set iRet=0
if {"%~2"}=={""} echo %~1 name is required. & set iRet=1 & goto End
call :isExist %~1 "%~2" bExist
if {%bExist%}=={0} echo %~1 "%~2" doesn't exist. & set iRet=2 & goto End
call :isRuning %~1 "%~2" bRuning
if %bRuning% EQU 1 echo %~1 "%~2" is runing. & goto End
:: case : %bRuning% NEQ 1
call :getStartMode "%~1" "%~2" tmpStartMode
if {"%tmpStartMode%"}=={"Disabled"} call :setAutoStart %~1 "%~2"
:: wmic /output:null service where ( name ="%~1" ^) call StartService
sc start "%~2" type=%~1
sc query "%~2" type=%~1
goto :eof

:stopImpl
:: wmic /output:null service where (name="%~1"^) call StopService
:: wmic service where (name="%~1"^) get name,state,startmode,pathname | more +1
sc stop "%~2" type= %~1
sc query "%~2" type= %~1
goto :eof

:isExist
@if defined _Stack @for %%a in ( 1 "%~nx0" "%0" ) do @if {"%%~a"}=={"%_Stack%"} @echo [      %~nx0] commandLine: %0 %*
if {"%~2"}=={""} call tools_message.bat popMsg "the %~1 name can't be empty -- first parameter".  & goto :eof
sc qc "%~2" type=%~1 1>nul 2>nul
if %errorlevel% NEQ 0  (
	set _tmpisExist=0
) else (
	set _tmpisExist=1
)
if {%3}=={} (
    if {%_tmpisExist%}=={1}    @echo %~1 "%~2" exists
    if {%_tmpisExist%}=={0}    @echo %~1 "%~2" doesn't exists
) else (
    set "%~3=%_tmpisExist%"
)
goto :eof

:isRuning
@if defined _Stack @for %%a in ( 1 "%~nx0" "%0" ) do @if {"%%~a"}=={"%_Stack%"} @echo [      %~nx0] commandLine: %0 %*
for /f "usebackq" %%i in ( ` sc query "%~2" type=%~1 ^| find  "STATE" ^| find /c "RUNNING" `) do set _tmpIsRuning=%%i
if {%3}=={} (
    if 		{%_tmpIsRuning%}=={0}    @echo %~1 "%~2" is NOT running
    if not 	{%_tmpIsRuning%}=={0}    @echo %~1 "%~2" is running
) else (
	if 		{%_tmpIsRuning%}=={0}    set %~3=0
    if not 	{%_tmpIsRuning%}=={0}    set %~3=1
)
goto :eof

:getStartMode
@if defined _Stack @for %%a in ( 1 "%~nx0" "%0" ) do @if {"%%~a"}=={"%_Stack%"} @echo [      %~nx0] commandLine: %0 %*
call :isExist "%~1" "%~2" bExist
if not {"%bExist%"}=={"1"} goto :eof
for /f "usebackq tokens=4" %%i in ( ` sc query "%~2" type=%~1 ^| find  "START_TYPE" `) do set _tmpStartMode=%%i
if {%3}=={} (
    if 		{%_tmpIsRuning%}=={0}    @echo %~1 "%~2" is NOT running
    if not 	{%_tmpIsRuning%}=={0}    @echo %~1 "%~2" is running
) else (
	if 		{%_tmpIsRuning%}=={0}    set %~3=0
    if not 	{%_tmpIsRuning%}=={0}    set %~3=1
)
goto :eof

:setAutoStart
@if defined _Stack @for %%a in ( 1 "%~nx0" "%0" ) do @if {"%%~a"}=={"%_Stack%"} @echo [      %~nx0] commandLine: %0 %*
call :isExist "%~1" "%~2" bExist
if not {"%bExist%"}=={"1"} goto :eof
:: wmic /output:null service where ( name ="%~1" ^) call change StartMode ^= "Automatic" 
sc config %~2 type=%~1 start=Automatic
call tools_message.bat noSleepMsg "%~0" 2
echo.
goto :eof

:disableStart
@if defined _Stack @for %%a in ( 1 "%~nx0" "%0" ) do @if {"%%~a"}=={"%_Stack%"} @echo [      %~nx0] commandLine: %0 %*
call :isExist "%~1" "%~2" bExist
if not {"%bExist%"}=={"1"} goto :eof
:: wmic /output:null service where ( name ="%~1" ^) call change StartMode ^= "disabled"
sc config %~2 type=%~1 start=disabled
call tools_message.bat noSleepMsg "%~0" 2
echo.
goto :eof

::******************************help  and test  section**************************************************************

::[DOS_API:Help]Display help information
:Help
@if defined _Stack @for %%a in ( 1 "%~nx0" "%0" ) do @if {"%%~a"}=={"%_Stack%"}  @echo [      %~nx0] commandLine: %0 %*
call tools_miscellaneous.bat DisplayHelp "%~f0"
goto :eof

::[DOS_API:Test]Test DOS API in this script file
:Test
@if defined _Stack @for %%a in ( 1 "%~nx0" "%0" ) do @if {"%%~a"}=={"%_Stack%"}  @echo [      %~nx0] commandLine: %0 %*
call :showFileCommandLine
echo.
@echo [%~nx0] Run test case [%0 %*]

echo.
echo test call :Help
call :Help

echo.
goto :eof

:showFileCommandLine
@if defined _Stack @for %%a in ( 1 "%~nx0" "%0" ) do @if {"%%~a"}=={"%_Stack%"}  @echo [      %~nx0] commandLine: %0 %*
echo this script file command line :  cmds_%~n0
call echo %%cmds_%~n0%%
goto :eof

::*******************************************************************************************************************

:End
@if defined _Stack @for %%a in ( 1 "%~nx0" "%0" ) do @if {"%%~a"}=={"%_Stack%"} @echo [----- %~nx0] commandLine: %0 %* & @echo.