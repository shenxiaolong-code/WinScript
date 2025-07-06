::@set _Echo=1
::set _Stack=%~nx0
@if {"%_Echo%"}=={"1"} ( @echo on ) else ( @echo off )
@@if defined _Stack @for %%a in ( 1 "%~nx0" "%0" ) do @if {"%%~a"}=={"%_Stack%"} @echo. & @echo [+++++ %~nx0] commandLine: %0 %*
where tools_error.bat 1>nul 2>nul || set "path=%~dps0;%path%"
if {"%~1"}=={""} call tools_error.bat checkEmptyParam

::gen current date time string, it is general used as file/directory name for unique reason
::1st param is output var name
::usage     : call genNameByTime.bat outPutVar
::call e.g. : call genNameByTime.bat outPutVar
::			: outPutVar format : 20130923_0856   //2013 year 09 month 23 day 08 hour 56 min

call set %~1=
::  for /F "delims=abcdefghijklmnopqrstuvwxyz.ABCDEFGHIJKLMNOPQRSTUVWXYZ  tokens=1"  %%i in ( "%date%_%time%" ) do call :processDT %%i
:: for /f "delims=" %# in ('powershell get-date -format "{yyyyMMdd_HHmmss}"') do echo set genNameByTimeVar=%#
if not defined dtFormat set dtFormat=yyyyMMdd_HHmmss
if not {"%~2"}=={""} set dtFormat=yyyyMMdd
for /F "usebackq" %%i in ( ` powershell -Command "Get-Date -format %dtFormat%" ` ) do call set "genNameByTimeVar=%%~i"
if not {"%~1"}=={""}    call set "%~1=%genNameByTimeVar%"
call tools_message.bat enableDebugMsg "%~n0" "%~1=%genNameByTimeVar%       [%~nx0]"
goto :End

:processDT 
set strDate=%*
rem fill 0 in blank char position
set strDate=%strDate: =0%
rem remove char in dd-mm-yyyy or yyyy-mm-dd format
set strDate=%strDate:-= %
rem remove char in dd/mm/yyyy or yyyy/mm/dd format
set strDate=%strDate:/=%
rem remove :
set strDate=%strDate::=%
set genNameByTimeVar=%strDate%
goto :eof


:End
@if defined _Stack @for %%a in ( 1 "%~nx0" "%0" ) do @if {"%%~a"}=={"%_Stack%"} @echo [----- %~nx0] commandLine: %0 %*