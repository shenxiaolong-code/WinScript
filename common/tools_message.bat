::Author    : Shen Xiaolong((xlshen@126.com))
::Copyright : free use,modify,spread, but MUST include this original two line information(Author and Copyright).

::@set _Echo=1
::set _Debug=1
::set _Stack=%~nx0
@if {"%_Echo%"}=={"1"} ( @echo on ) else ( @echo off )
@if defined _Stack @for %%a in ( 1 "%~nx0" "%0" ) do @if {"%%~a"}=={"%_Stack%"}  @echo. & @echo [+++++ %~nx0] commandLine: %0 %*
rem title length limited to 256 chars , else dos will report "Not enough memory resources are available to process this command"
rem @title %0 %*
where "%~nx0" 1>nul 2>nul || set "path=%~dp0;%path%"

if {"%~1"}=={""} call :Test NoOutput & goto End
call :%~1 %2 %3 %4 %5 %6 %7 %8 %9
goto :End

::******************************DOS API section**************************************************************************
:: use 'call "%~dp0bin\cecho.exe"' instead of 'call colorTxt.bat' because the color might be not set. 

::[DOS_API:warningMsg] show warning message and continue script session after press any key
::call e.g  : call :warningMsg "hello, I am warning msg"
:warningMsg
@if defined _Stack @for %%a in ( 1 "%~nx0" "%0" ) do @if {"%%~a"}=={"%_Stack%"} @echo [      %~nx0] commandLine: %0 %*
if not {"%~1"}=={""} (
call tools_error.bat checkCallerInfo 1 %*
call "%~dp0bin\cecho.exe" {0e}[ warning ]{01} %~1 {#}
) else (
call "%~dp0bin\cecho.exe" {0e}[ warning ]{01} empty warning message {#}
)
echo.
echo press any key to continue current script session.
pause > nul
goto :eof

::[DOS_API:errorMsg] show error message and exit script session after press any key
::call e.g  : call :errorMsg "hello, I am error msg"
:errorMsg
@if defined _Stack @for %%a in ( 1 "%~nx0" "%0" ) do @if {"%%~a"}=={"%_Stack%"} @echo [      %~nx0] commandLine: %0 %*
if      defined customized_exitHandler set errorMsg_exitHandler=%customized_exitHandler%
if not  defined customized_exitHandler if       defined _Debug set "errorMsg_exitHandler=echo don't exist in debug mode.(set _Debug=1)"
if not  defined customized_exitHandler if not   defined _Debug set "errorMsg_exitHandler=exit"
if {"%~1"}=={""} (
call :warningMsg "errorMsg shouldn't be empty."
) else (
call tools_error.bat checkCallerInfo 1 %*
echo.
call "%~dp0bin\cecho.exe" {04}[ Error ]{0e} %~1 {#}
if defined errorMsg_comment_msg1    echo %errorMsg_comment_msg1%
)
echo.
if not defined customized_exitHandler (
echo.
echo press any key to exit current script session -- or Press Ctrl_C to terminate current job when debuging ...
pause > nul
)
%errorMsg_exitHandler%
goto :eof

::[DOS_API:promptMsg] show prompt message, script will continue after press any key.
::call e.g  : call :promptMsg
::            call :promptMsg "hello , I am prompt message"
:promptMsg
@if defined _Stack @for %%a in ( 1 "%~nx0" "%0" ) do @if {"%%~a"}=={"%_Stack%"} @echo [      %~nx0] commandLine: %0 %*
call tools_error.bat checkCallerInfo 1 %*
echo.
call "%~dp0bin\cecho.exe" {0b}Need Action:{0d}{\n}%~1{#}
echo.
echo.
echo press any key to continue ...
pause 1>nul
goto :eof

::[DOS_API:NotifyMsg] show highlight prompt message without any delay or pause
::call e.g  : call :NotifyMsg
::            call :NotifyMsg "hello , I am prompt message"
:NotifyMsg
@if defined _Stack @for %%a in ( 1 "%~nx0" "%0" ) do @if {"%%~a"}=={"%_Stack%"} @echo [      %~nx0] commandLine: %0 %*
call tools_error.bat checkCallerInfo 1 %*
echo.
call "%~dp0bin\cecho.exe" {0b}Notification:{\n}{0a}%~1{#}
echo.
goto :eof

::[DOS_API:outOfDateAPIMsg] warning out-of-date dos API, suggest new api
::call e.g  : call :outOfDateAPIMsg oldAPI newAPI
::            check at least has 2 parameters  
:outOfDateAPIMsg
@if defined _Stack @for %%a in ( 1 "%~nx0" "%0" ) do @if {"%%~a"}=={"%_Stack%"} @echo [      %~nx0] commandLine: %0 %*
call :checkParamCount 2 %*
call "%~dp0bin\cecho.exe" {0e}%~1{04} is out-of-date dos API, suggest use new API :{02} %~2{#}{\n}
echo.
pause
goto :eof

::[DOS_API:noPauseMsg] show promot to defined specific variabe to disable pause
::call e.g  : call :noPauseMsg
::            call :noPauseMsg "pdbInfo"
:noPauseMsg
@if defined _Stack @for %%a in ( 1 "%~nx0" "%0" ) do @if {"%%~a"}=={"%_Stack%"} @echo [      %~nx0] commandLine: %0 %*
rem echo %~0
rem echo %~n0
rem call tools_message.bat noPauseMsg "%~0"
call set "_tmpLable=%~1"
if {"%_tmpLable:~0,1%"}=={":"} call set "_tmpLable=%_tmpLable:~1%"
call tools_error.bat checkCallerInfo 1 %*
if defined %_tmpLable%_NoPause goto :eof
if defined noPauseGlobal if not defined %_tmpLable%_pause goto :eof
call "%~dp0bin\cecho.exe" {02}Define variable {0d}%_tmpLable%_NoPause{02} or {04}noPauseGlobal {02}to disable this pause.{\n}Define variable {04}noPauseGlobal {02}and {0c}%_tmpLable%_pause {02}to only enable this pause  {\n}{06}Press any key to continue ...{\n}{#}
pause 1>nul
goto :eof

::[DOS_API:noSleepMsg] show promot to defined specific variabe to disable sleep
::call e.g  : call :noSleepMsg <label> <timeout> [timeoutPrompt] [msg]
::            call :noSleepMsg ":pdbInfo" 5 
:noSleepMsg
@if defined _Stack @for %%a in ( 1 "%~nx0" "%0" ) do @if {"%%~a"}=={"%_Stack%"} @echo [      %~nx0] commandLine: %0 %*
rem echo %~0
rem echo %~n0
rem call tools_message.bat noSleepMsg "%~0" 8
call set "_tmpLable=%~1"
if {"%_tmpLable:~0,1%"}=={":"} call set "_tmpLable=%_tmpLable:~1%"
call tools_error.bat checkCallerInfo 2 %*
if defined %_tmpLable%_noSleep goto :eof
if defined noSleepGlobal if not defined %_tmpLable%_sleep goto :eof
call "%~dp0bin\cecho.exe" {02}Define variable {0d}%_tmpLable%_noSleep{02} or {04}noSleepGlobal {02}to disable this pause.{\n}Define variable {04}noSleepGlobal {02}and {0c}%_tmpLable%_sleep {02}to only enable this sleep  {\n}{06}Press any key to continue ...{\n}{#}
if defined sleepMsg call "%~dp0bin\cecho.exe" {0d}%sleepMsg%{\n}{#}
if {"%~3"}=={"quiet"}       ping -n %~2 127.0.0.1 >nul
if not {"%~3"}=={"quiet"}   timeout /T %~2
goto :eof

::[DOS_API:enableDebugMsg] show specifiled debug info
::call e.g  : call :enableDebugMsg <label> <msg>
::            call :enableDebugMsg  ":pdbInfo" "I am debug info"
:enableDebugMsg
@if defined _Stack @for %%a in ( 1 "%~nx0" "%0" ) do @if {"%%~a"}=={"%_Stack%"} @echo [      %~nx0] commandLine: %0 %*
call set "_tmpLable=%~1"
if {"%_tmpLable:~0,1%"}=={":"} call set "_tmpLable=%_tmpLable:~1%"
::call tools_message.bat enableDebugMsg "%~0" cmdString
::call tools_error.bat checkCallerInfo 2 %*
:: set | find /i "%_tmpLable%"
if not defined  %_tmpLable%_debugMsg if not defined _Debug goto :eof
if defined _Debug if defined %_tmpLable%_noDebugMsg goto :eof
call "%~dp0bin\cecho.exe" {01}Debug info{\n}{06}%~2 %~3 %~4 %~5 %~6 %~7 %~8 %~9{\n}{02}Define variable {0d}%_tmpLable%_noDebugMsg{02} to disable this debug info -- if your opened global debug flag({06}set _Debug=1{02}).{\n}Or define variable {04}%_tmpLable%_debugMsg {02}to only enable this debug info.{#}{\n}
goto :eof

::[DOS_API:enableDebugCmd] execute specifiled debug cmd
::call e.g  : call :enableDebugCmd <label> <msg>
::            call :enableDebugCmd  ":pdbInfo" "I am debug info"
:enableDebugCmd
@if defined _Stack @for %%a in ( 1 "%~nx0" "%0" ) do @if {"%%~a"}=={"%_Stack%"} @echo [      %~nx0] commandLine: %0 %*
call set "_tmpLable=%~1"
if {"%_tmpLable:~0,1%"}=={":"} call set "_tmpLable=%_tmpLable:~1%"
::call tools_error.bat checkCallerInfo 2 %*
if not defined  %_tmpLable%_debugMsgCmd if not defined _Debug goto :eof
if defined _Debug if defined %_tmpLable%_noDebugMsgCmd goto :eof
call "%~dp0bin\cecho.exe" {01}Debug cmd:{06}%~2 %~3 %~4 %~5 %~6 %~7 %~8 %~9{#}{\n}
%2 %3 %4 %5 %6 %7 %8 %9
call "%~dp0bin\cecho.exe" {02}Define variable {0d}%_tmpLable%_noDebugMsgCmd{02} to disable this debug cmd -- if your opened global debug flag.{\n}Or define variable {04}%_tmpLable%_debugMsgCmd {02}to only enable this debug cmd.{\n}{#}
goto :eof

::[DOS_API:outputDebugVar] output environment variabe variabe in color
::call e.g  : call :outputDebugVar varName
::            call :outputDebugVar varName
:outputDebugVar
@if defined _Stack @for %%a in ( 1 "%~nx0" "%0" ) do @if {"%%~a"}=={"%_Stack%"} @echo [      %~nx0] commandLine: %0 %*
if not defined _Debug  goto :eof
call set "_tmpLable=%~1"
if {"%_tmpLable:~0,1%"}=={":"} call set "_tmpLable=%_tmpLable:~1%"
::call tools_message.bat outputDebugVar "%~0" cmdString
::call tools_error.bat checkCallerInfo 2 %*
:: set | find /i "%_tmpLable%"
if not defined  %_tmpLable%_debugMsg if not defined _Debug goto :eof
if defined _Debug if defined %_tmpLable%_noDebugMsg goto :eof
call "%~dp0bin\cecho.exe" variable : {0a}%~1{0e} = {0d}%%%~1%%{#}{\n}
goto :eof

::[DOS_API:popMsg]popup dialog to show some message
::usage         : call popMsg sMsg [bAsync]
::example       : call popMsg "hello, I am prompt message." 1
:popMsg
@if defined _Stack @for %%a in ( 1 "%~nx0" "%0" ) do @if {"%%~a"}=={"%_Stack%"} @echo [      %~nx0] commandLine: %0 %*
::default is synchronous , if any 2nd parameter exists, it will be asynchronous
if {"%~2"}=={""} (
call msg %username% /v /w /time:99999 "%~1" >nul
) else (
start /B msg %username% /v /w /time:99999 "%~1" >nul
)
goto :eof

::******************************inner implement  section**************************************************************************


::******************************help  and test  section**************************************************************

::[DOS_API:Help]Display help information
:Help
@if defined _Stack @for %%a in ( 1 "%~nx0" "%0" ) do @if {"%%~a"}=={"%_Stack%"}  @echo [      %~nx0] commandLine: %0 %*
call tools_miscellaneous.bat DisplayHelp "%~f0"
goto :eof

::[DOS_API:Test]Test DOS API in this script file
:Test
@if defined _Stack @for %%a in ( 1 "%~nx0" "%0" ) do @if {"%%~a"}=={"%_Stack%"}  @echo [      %~nx0] commandLine: %0 %*
echo.
@echo [%~nx0] Run test case [%0 %*]

echo.
echo test call :Help
call :Help

set customized_exitHandler=echo doesn't exit in self-testing [%~nx0] ....

echo.
echo test call :warningMsg "warningMsg interface test"
call :warningMsg "warningMsg interface test"

echo.
echo.
call :warningMsg "skipped test :errorMsg because it causes exit"
echo [skip]test call :errorMsg "warningMsg interface test"
echo call :errorMsg "errorMsg interface test"

set customized_exitHandler=

echo.
echo test call :promptMsg "promptMsg interface test"
call :promptMsg "promptMsg interface test"

echo.
echo test call :NotifyMsg "NotifyMsg interface test"
call :NotifyMsg "NotifyMsg interface test"

echo.
echo test done!
goto :eof

::*******************************************************************************************************************

:End
@if defined _Stack @for %%a in ( 1 "%~nx0" "%0" ) do @if {"%%~a"}=={"%_Stack%"}  @echo [----- %~nx0] commandLine: %0 %* & @echo.