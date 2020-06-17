::Author    : Shen Xiaolong((xlshen@126.com))
::Copyright : free use,modify,spread, but MUST include this original two line information(Author and Copyright).

::@set _Echo=1
::set _Stack=%~nx0
@if {%_Echo%}=={1} ( @echo on ) else ( @echo off )
@if defined _Stack @for %%a in ( 1 "%~nx0" "%0" ) do @if {"%%~a"}=={"%_Stack%"} @echo. & @echo [+++++ %~nx0] commandLine: %0 %*
where "%~nx0" 1>nul 2>nul || @set "path=%~dp0;%path%"

if {"%1"}=={""} call :Test NoOutput & goto End
call :%*
goto End

::[DOS_API:Help]display help information
:Help
@if defined _Stack @for %%a in ( 1 "%~nx0" "%0" ) do @if {"%%~a"}=={"%_Stack%"} @echo [      %~nx0] commandLine: %0 %*
call tools_miscellaneous.bat DisplayHelp "%~f0"
goto End

::[DOS_API:Test]Test DOS API in this script file
:Test
@if defined _Stack @for %%a in ( 1 "%~nx0" "%0" ) do @if {"%%~a"}=={"%_Stack%"} @echo [      %~nx0] commandLine: %0 %*
@echo [%~nx0] Run test case [%0 %*]
echo.
echo test call :Help
call :Help
echo.
::prepare temporary file
set testTmpFile=%temp%\%random%.txt
if exist %testTmpFile% del /q/f %testTmpFile%
dir/b "%~dp0*.*" >> %testTmpFile%
echo [test sample] temporary file "%testTmpFile%" context:
type "%testTmpFile%"
call tools_message.bat noSleepMsg "%~0" 5
echo.
echo.
set _t1=%time%
timeout 3
set _t2=%time%
echo test call :calculateElapsedTime "%_t1%" "%_t2%" dur
call :calculateElapsedTime "%_t1%" "%_t2%" dur
echo %_t2% - %_t1% = %dur%
echo.
echo test call :getCmdOutput "dir/s/b tools_miscellaneous.bat" outVar
call :getCmdOutput "dir/s/b tools_miscellaneous.bat" outVar
echo outVar=%outVar%
echo.
echo test call :ShowScrollBar
call :ShowScrollBar
echo.
echo test call :SetErrorColor 0d
call :SetErrorColor 0d
echo.
echo test call :ResetErrorColor
call tools_message.bat noSleepMsg "%~0" 3
call :ResetErrorColor
echo.
echo test call :FindFirstUSBDisk %1
call :FindFirstUSBDisk %1
echo.
echo test call :PaselScatteredPoint ":Private_OnlyShowParam" "1 2 6 9 0"
call :PaselScatteredPoint ":Private_OnlyShowParam" "1 2 6 9 0"
echo.
echo test call :PaselScatteredPoint "tools_path.bat FindFilePathNoExt" "cmd where tree find"
call :PaselScatteredPoint "tools_path.bat FindFilePathNoExt" "cmd where tree find"
echo.
echo.
echo test call :PaselScatteredPoint "tools_path.bat FindFilePathShort" "devenv.exe windbg.exe"
call :PaselScatteredPoint "tools_path.bat FindFilePathShort" "devenv.exe windbg.exe"
echo.
goto :eof

::[DOS_API:ShowScrollBar]show dynamic scroll bar
::No any parameter
:ShowScrollBar
@if defined _Stack @for %%a in ( 1 "%~nx0" "%0" ) do @if {"%%~a"}=={"%_Stack%"} @echo [      %~nx0] commandLine: %0 %*
echo ©°©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©´
for /L %%i in (1 1 34) do set /p a=¡ö<nul&ping -n 1 127.0.0.1 >nul
echo   100%
echo ©¸©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¼
goto :eof

::[DOS_API:FindFirstUSBDisk]find first removable USB disk in current system.
::usage     : call :FindFirstUSBDisk outputVar
::call e.g. : call :FindFirstUSBDisk driverName
:FindFirstUSBDisk
@if defined _Stack @for %%a in ( 1 "%~nx0" "%0" ) do @if {"%%~a"}=={"%_Stack%"} @echo [      %~nx0] commandLine: %0 %*
call :Clear_Environment_Variable tmpFindFirstUSBDisk
for /f "usebackq skip=1 tokens=1" %%i in ( `wmic LOGICALDISK where ( DriveType^=2 ^) get DeviceID` ) do (
if not defined tmpFindFirstUSBDisk set tmpFindFirstUSBDisk=%%i
)
if {%tmpFindFirstUSBDisk%}=={} echo No USB disk Found & goto :eof
if {%~1}=={} (
echo %tmpFindFirstUSBDisk%
) else (
set %~1=%tmpFindFirstUSBDisk%
)
goto :eof

::[DOS_API:calculateElapsedTime]calculate time duration 
::usage     : call :calculateElapsedTime startTime endTime outputDuration
::call e.g. : call :calculateElapsedTime "14:29:34.40" "14:29:34.75"  dur
:calculateElapsedTime
@if defined _Stack @for %%a in ( 1 "%~nx0" "%0" ) do @if {"%%~a"}=={"%_Stack%"} @echo [      %~nx0] commandLine: %0 %*
:: https://stackoverflow.com/questions/9922498/calculate-time-difference-in-windows-batch-file
rem The format of %TIME% is HH:MM:SS,CS for example 23:59:59,99
set STARTTIME=%~1
set ENDTIME=%~2
call tools_message.bat enableDebugMsg "%~0" "STARTTIME: %STARTTIME%"
call tools_message.bat enableDebugMsg "%~0" "ENDTIME: %ENDTIME%"

rem convert STARTTIME and ENDTIME to centiseconds
set /A STARTTIME=(1%STARTTIME:~0,2%-100)*360000 + (1%STARTTIME:~3,2%-100)*6000 + (1%STARTTIME:~6,2%-100)*100 + (1%STARTTIME:~9,2%-100)
set /A ENDTIME=(1%ENDTIME:~0,2%-100)*360000 + (1%ENDTIME:~3,2%-100)*6000 + (1%ENDTIME:~6,2%-100)*100 + (1%ENDTIME:~9,2%-100)

rem calculating the duratyion is easy
set /A DURATION=%ENDTIME%-%STARTTIME%

rem we might have measured the time inbetween days
if %ENDTIME% LSS %STARTTIME% set set /A DURATION=%STARTTIME%-%ENDTIME%

rem now break the centiseconds down to hors, minutes, seconds and the remaining centiseconds
set /A DURATIONH=%DURATION% / 360000
set /A DURATIONM=(%DURATION% - %DURATIONH%*360000) / 6000
set /A DURATIONS=(%DURATION% - %DURATIONH%*360000 - %DURATIONM%*6000) / 100
set /A DURATIONHS=(%DURATION% - %DURATIONH%*360000 - %DURATIONM%*6000 - %DURATIONS%*100)

rem some formatting
if %DURATIONH% LSS 10 set DURATIONH=0%DURATIONH%
if %DURATIONM% LSS 10 set DURATIONM=0%DURATIONM%
if %DURATIONS% LSS 10 set DURATIONS=0%DURATIONS%
if %DURATIONHS% LSS 10 set DURATIONHS=0%DURATIONHS%

call tools_message.bat enableDebugMsg "%~0" "STARTTIME: %STARTTIME% centiseconds"
call tools_message.bat enableDebugMsg "%~0" "ENDTIME: %ENDTIME% centiseconds"
call tools_message.bat enableDebugMsg "%~0" "DURATION: %DURATION% in centiseconds"

set dur=%DURATIONH%:%DURATIONM%:%DURATIONS%,%DURATIONHS%
goto :eof

::[DOS_API:getCmdOutput]get output of DOS cmd and store into varName
::usage     : call :getCmdOutput cmd varName
::call e.g. : call :getCmdOutput "dir/s/b tools_miscellaneous.bat" outVar
:getCmdOutput
@if defined _Stack @for %%a in ( 1 "%~nx0" "%0" ) do @if {"%%~a"}=={"%_Stack%"} @echo [      %~nx0] commandLine: %0 %*
call tools_error.bat checkParamCount 2 %*
for /F "usebackq tokens=*" %%i in ( ` %~1 ` ) do call set %~2=%%i
goto :eof

::[DOS_API:makePortalbe] collect necessary files for special feature.
::usage     : call :makePortalbe cmd_or_bat_file
::call e.g. : call :makePortalbe "D:\work\shenxiaolong\core\WinScript\common\tools_miscellaneous.bat"
:makePortalbe
@if defined _Stack @for %%a in ( 1 "%~nx0" "%0" ) do @if {"%%~a"}=={"%_Stack%"} @echo [      %~nx0] commandLine: %0 %*
call tools_error.bat checkFileExist "%~fs1"
set "relDir=%~dp1"
set "scanFileDir=%~2"
if not defined scanFileDir set "scanFileDir=%~dp1"
call tools_path.bat noBashPath scanFileDir
if not defined defOutputDir set "defOutputDir=%~dpn1_portable"
if     exist "%defOutputDir%" rd/s/q    "%defOutputDir%\"
if not exist "%defOutputDir%" md        "%defOutputDir%\"
call tools_string.bat toLower SystemRoot
call :makePortalbe.oneExistFile "%~fs1"
goto :eof

:makePortalbe.isCommentLine
@if defined _Stack @for %%a in ( 1 "%~nx0" "%0" ) do @if {"%%~a"}=={"%_Stack%"} @echo [      %~nx0] commandLine: %0 %*
set bCommentLine=1
set _tmpCmds=%*
if {"%_tmpCmds:~0,2%"}=={"::"} goto :eof
set _tmp_filter=%_tmpCmds:~0,3%
call tools_string.bat toLower _tmp_filter
if {"%_tmp_filter%"}=={"rem"} goto :eof
set bCommentLine=
goto :eof

:makePortalbe.findFilePath
@if defined _Stack @for %%a in ( 1 "%~nx0" "%0" ) do @if {"%%~a"}=={"%_Stack%"} @echo [      %~nx0] commandLine: %0 %*
set %~2=
for /f "usebackq tokens=*" %%i in ( ` dir/s/b %scanFileDir%\%~nx1 2^>nul ` ) do if not defined %~2 set "%~2=%%~i"
goto :eof

:makePortalbe.oneExistFile
@if defined _Stack @for %%a in ( 1 "%~nx0" "%0" ) do @if {"%%~a"}=={"%_Stack%"} @echo [      %~nx0] commandLine: %0 %*
if defined _File_%~n1 goto :eof
set _tmpTargetType=%~x1
call tools_string.bat toLower _tmpTargetType
if {"%_tmpTargetType%"}=={".cmd"} call :makePortalbe.oneExistFile.script    "%~f1"
if {"%_tmpTargetType%"}=={".bat"} call :makePortalbe.oneExistFile.script    "%~f1"
if {"%_tmpTargetType%"}=={".exe"} call :makePortalbe.oneExistFile.bin       "%~f1"
goto :eof

:makePortalbe.oneExistFile.script
@if defined _Stack @for %%a in ( 1 "%~nx0" "%0" ) do @if {"%%~a"}=={"%_Stack%"} @echo [      %~nx0] commandLine: %0 %*
if defined _File_%~n1 goto :eof
set "_File_%~n1=%~f1"
call :makePortalbe.copyFile "%~1"
for /f "usebackq tokens=*" %%i in ( ` type "%~fs1" ^| find /i ".exe " ` ) do call :makePortalbe.oneLine.bin %%i
for /f "usebackq tokens=*" %%i in ( ` type "%~fs1" ^| find /i "call " ` ) do call :makePortalbe.oneLine.Call %%i
for /f "usebackq tokens=*" %%i in ( ` type "%~fs1" ^| find /i "start " ` ) do call :makePortalbe.oneLine.start %%i
goto :eof

:makePortalbe.oneExistFile.bin
@if defined _Stack @for %%a in ( 1 "%~nx0" "%0" ) do @if {"%%~a"}=={"%_Stack%"} @echo [      %~nx0] commandLine: %0 %*
if defined _File_%~n1 goto :eof
set "_File_%~n1=%~f1"

set "_tmp_curFilePath=%~f1"
call tools_string.bat toLower _tmp_curFilePath
call tools_string.bat find "%_tmp_curFilePath%" "%SystemRoot%" bSysFile
if defined bSysFile goto :eof
call :makePortalbe.findFilePath "%~1" binTargetFilePath
if defined binTargetFilePath call :makePortalbe.copyFile "%binTargetFilePath%"
goto :eof

:makePortalbe.oneLine.bin
@if defined _Stack @for %%a in ( 1 "%~nx0" "%0" ) do @if {"%%~a"}=={"%_Stack%"} @echo [      %~nx0] commandLine: %0 %*
call :makePortalbe.isCommentLine %*
if defined bCommentLine goto :eof
set _tmpTargetType=%~x1
call tools_string.bat toLower _tmpTargetType
if {"%_tmpTargetType%"}=={".exe"} call :makePortalbe.findFilePath "%~nx1" binTargetFilePath
if defined binTargetFilePath call :makePortalbe.oneExistFile.bin "%binTargetFilePath%"
goto :eof

:makePortalbe.oneLine.Call
@if defined _Stack @for %%a in ( 1 "%~nx0" "%0" ) do @if {"%%~a"}=={"%_Stack%"} @echo [      %~nx0] commandLine: %0 %*
call :makePortalbe.isCommentLine %*
if defined bCommentLine goto :eof
set _tmpCmdLine=%*
call :makePortalbe.calParameter %_tmpCmdLine:*call =%
goto :eof

:makePortalbe.calParameter
@if defined _Stack @for %%a in ( 1 "%~nx0" "%0" ) do @if {"%%~a"}=={"%_Stack%"} @echo [      %~nx0] commandLine: %0 %*
set "_tmpTarget=%~1"
if {"%_tmpTarget:~0,1%"}=={":"} goto :eof
call :makePortalbe.findFilePath "%~1" calTargetFilePath
if defined calTargetFilePath call :makePortalbe.oneExistFile "%calTargetFilePath%"
goto :eof

:makePortalbe.oneLine.start
@if defined _Stack @for %%a in ( 1 "%~nx0" "%0" ) do @if {"%%~a"}=={"%_Stack%"} @echo [      %~nx0] commandLine: %0 %*
call :makePortalbe.isCommentLine %*
if defined bCommentLine goto :eof
set "_tmp_curFilePath=%~f1"
if not defined _tmp_curFilePath set "_tmp_curFilePath=%~f2"
call :makePortalbe.oneExistFile "%_tmp_curFilePath%"
goto :eof

:makePortalbe.copyFile
@if defined _Stack @for %%a in ( 1 "%~nx0" "%0" ) do @if {"%%~a"}=={"%_Stack%"} @echo [      %~nx0] commandLine: %0 %*
if not exist "%~f1" goto :eof
set _tmpCurFile=%~f1
call set relPath=%%_tmpCurFile:%relDir%=%%
call :makePortalbe.copyFile.impl "%~f1" "%defOutputDir%\%relPath%"
goto :eof

:makePortalbe.copyFile.impl
@if defined _Stack @for %%a in ( 1 "%~nx0" "%0" ) do @if {"%%~a"}=={"%_Stack%"} @echo [      %~nx0] commandLine: %0 %*
if not exist "%~dp2" md "%~dp2"
echo copy "%~nx1" ...
copy "%~f1" "%~f2"
goto :eof

::[DOS_API:Clear_Environment_Variable]clear local environment variable, its target is avoid to use delayed extenstion : setLocal enabledelayedexpansion
::usage     : call :Clear_Environment_Variable EnvVarName
::call e.g. : call :Clear_Environment_Variable abc
:Clear_Environment_Variable
@if defined _Stack @for %%a in ( 1 "%~nx0" "%0" ) do @if {"%%~a"}=={"%_Stack%"} @echo [      %~nx0] commandLine: %0 %*
if defined %~1 if not {%~1}=={} set %~1=
goto :eof

::[DOS_API:SetErrorColor] on error occur,change console color.
::usage     : call :SetErrorColor Color
::call e.g. : call :SetErrorColor 0c
::Note		: 2nd parameter can be empty, interface can provide default one
:SetErrorColor
if not {"%~1"}=={""} (
color %~1
) else (
::default error is 0E
color 0E
)
goto :eof

::[DOS_API:ResetErrorColor] reset console error color to default color
::usage     : call :ResetErrorColor
::call e.g. : call :ResetErrorColor
:ResetErrorColor
::restore default console color
color
goto :eof

::[DOS_API:PaselScatteredPoint]process every element in one scattered set by special command
::usage     : call :PaselScatteredPoint "CommandString" scatteredpoint
::Note      : CommandString inner can't include "" 
::call e.g. : call :PaselScatteredPoint "call :Private_OnlyShowParam" "1 2 6 9 0"
:PaselScatteredPoint
@if defined _Stack @for %%a in ( 1 "%~nx0" "%0" ) do @if {"%%~a"}=={"%_Stack%"} @echo [      %~nx0] commandLine: %0 %*
if {"%~1"}=={} goto :eof
if {"%~2"}=={} goto :eof
for /f "usebackq tokens=1*" %%a in ( '%~2' ) do (
call %~1 %%a
call :PaselScatteredPoint "%~1" "%%b"
)
goto :eof

::[DOS_API:DisplayHelp]display all DOS APIs in one dos script module
:DisplayHelp
@if defined _Stack @for %%a in ( 1 "%~nx0" "%0" ) do @if {"%%~a"}=={"%_Stack%"} @echo [      %~nx0] commandLine: %0 %*
if not exist "%~s1" call tools_message.bat popMsg "file[%~1] doesn't exist,pls check". & goto :eof
echo Script [%~nx1] provide below DOS_APIs:
echo.
for /f "usebackq tokens=*" %%i in ( ` findstr /n /r ^::\[DOS_API:.*\] %~s1 `  ) do (
call :Private_Display_DOSAPI_item "%%i" "%~dpnx1"
)
goto :eof

:Private_Display_DOSAPI_item
@if defined _Stack @for %%a in ( 1 "%~nx0" "%0" ) do @if {"%%~a"}=={"%_Stack%"} @echo [      %~nx0] commandLine: %0 %*
if {"%~1"}=={""} goto :eof
set p1=%~1
set p1=%p1:::[DOS_API:=%
set p1=%p1::=]%
for /f "delims=] tokens=1,2* " %%i in ( "%p1%" ) do (
if {%%j}=={} goto :eof
echo %%j
echo  descript : %%k 
echo  [file:line]%~dpnx2 : %%i 
echo  Example "%~dpnx2 %%j"
echo.
)
goto :eof

:Private_OnlyShowParam
@if defined _Stack @for %%a in ( 1 "%~nx0" "%0" ) do @if {"%%~a"}=={"%_Stack%"} @echo [      %~nx0] commandLine: %0 %*
echo Parameter is "%1"
goto :eof

:End
@if defined _Stack @for %%a in ( 1 "%~nx0" "%0" ) do @if {"%%~a"}=={"%_Stack%"} @echo [----- %~nx0] commandLine: %0 %* & @echo.