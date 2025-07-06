::Author    : Shen Xiaolong((xlshen@126.com))
::Copyright : free use,modify,spread, but MUST include this original two line information(Author and Copyright).

::@set _Echo=1
::set _Stack=%~nx0
@if {"%_Echo%"}=={"1"} ( @echo on ) else ( @echo off )
@if defined _Stack @for %%a in ( 1 "%~nx0" "%0" ) do @if {"%%~a"}=={"%_Stack%"} @echo. & @echo [+++++ %~nx0] commandLine: %0 %*
where "%~nx0" 1>nul 2>nul || set "path=%~dp0;%path%"

if {%1}=={} call :Test  & goto End
::if {%1}=={} call :Test NoOutput & goto End

call :%1 %2 %3 %4 %5 %6 %7 %8 %9
goto End

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
goto :eof

:build.options.default
if not defined maxcpucount      set maxcpucount=8
if not defined Configuration    set Configuration=release
if not defined platform         set platform=win32
if not defined target           set target=build
if not defined verbosity        set verbosity=detailed
if not defined outFolder        set outFolder=output
if not defined consoleloggerparameters  set consoleloggerparameters=PerformanceSummary

goto :eof


:build.options.set
rem format : xxx.sln optName=optVal optName=optVal
rem because shift doesn't effect %*
shift
if {"%~1"}=={""} goto :endSetOpt
call set %~1
goto :build.options.set
:endSetOpt
call :build.options.default
goto :eof

:build.file.exist
if not exist "%~1" (
call colorTxt.bat red_L "can not find file [%~1]."
echo.
pause
exit /b 1
) else (
exit /b 0
)
goto:eof

:MSBuild.options.dump
rem https://msdn.microsoft.com/en-us/library/ms164311.aspx
echo.
call tools_string.bat :stringLength "consoleloggerparameters=%consoleloggerparameters%" col1Width
set /a col1Width=%col1Width%+8
echo MSBuild.exe build parameters:
call tools_string.bat :stringAlignL "parameter name" %col1Width%

echo supported parameter value
echo maxcpucount=%maxcpucount%

call tools_string.bat :stringAlignL "Configuration=%Configuration%" %col1Width%
echo [release ^| debug]

call tools_string.bat :stringAlignL "target=%target%" %col1Width%
echo [build ^| rebuild ^| compile ^| clean]

call tools_string.bat :stringAlignL "consoleloggerparameters=%consoleloggerparameters%" %col1Width%
echo [ PerformanceSummary ^| Summary ^| NoSummary ^| ErrorsOnly ^| ShowCommandLine ]

call tools_string.bat :stringAlignL "verbosity=%verbosity%" %col1Width%
echo [quiet ^| minimal ^| normal ^| detailed ^| diagnostic]

goto :eof

:MSBuild.setPath
@if defined _Stack @for %%a in ( 1 "%~nx0" "%0" ) do @if {"%%~a"}=={"%_Stack%"} @echo [      %~nx0] commandLine: %0 %*
if not defined defaultMsBuildPath call :MSBuild.setPath.default     defaultMsBuildPath
where MSBuild.exe 1>nul 2>nul || set "path=%defaultMsBuildPath%;%path%"
where MSBuild.exe 1>nul 2>nul || (
call colorTxt.bat red_L "can not find MSBuild.exe."
echo.
call colorTxt.bat cyan_L "%defaultMsBuildPath% is invalid."
echo.
pause
)
goto :eof

:MSBuild.setPath.default
@if defined _Stack @for %%a in ( 1 "%~nx0" "%0" ) do @if {"%%~a"}=={"%_Stack%"} @echo [      %~nx0] commandLine: %0 %*
:: set =C:\Program Files (x86)\MSBuild\14.0\bin\;
for /f "usebackq tokens=*" %%a in ( ` dir/b/s C:\Windows\Microsoft.NET\Framework\v4* ` ) do call set "%~1=%%a"
goto :eof

:MSBuild.build.default
@if defined _Stack @for %%a in ( 1 "%~nx0" "%0" ) do @if {"%%~a"}=={"%_Stack%"} @echo [      %~nx0] commandLine: %0 %*
call :build.file.exist "%~1" || goto :End
call :MSBuild.build%~2.one "%~f1" "target=build" "Configuration=release"
call :MSBuild.build%~2.one "%~f1" "target=build" "Configuration=debug"
goto :eof

:MSBuild.build.log.one
@if defined _Stack @for %%a in ( 1 "%~nx0" "%0" ) do @if {"%%~a"}=={"%_Stack%"} @echo [      %~nx0] commandLine: %0 %*
call :build.options.set %*
set outFolderPath=%~dp1%outFolder%
if not exist "%outFolderPath%" mkdir "%outFolderPath%"
set logPath=%outFolderPath%\%~n1.%target%.%Configuration%.%platform%.log
echo build log : %logPath%
if exist "%logPath%" del/f/q "%logPath%"
(
@call :MSBuild.build.one %*
) >> "%logPath%"
goto :eof

::[DOS_API:MSBuild.build.one]build VC++ project with MSBuild.exe
::call e.g  : call :MSBuild.build.one "C:\myProjecy\mySolution.sln"
::            call :MSBuild.build.one "mySolution.sln" "Configuration=release" "target=rebuild"
::result e.g: build C:\myProjecy\mySolution.sln by options 
:MSBuild.build.one
@if defined _Stack @for %%a in ( 1 "%~nx0" "%0" ) do @if {"%%~a"}=={"%_Stack%"} @echo [      %~nx0] commandLine: %0 %*
call :build.file.exist "%~1" || goto :End

where MSBuild.exe 1>nul 2>nul || call :MSBuild.setPath
set /p="MSBuild.exe path : "<nul
where MSBuild.exe
call :build.options.set %*
call :MSBuild.options.dump

echo.
title MSBuild.exe "%~f1" /target:%target% /maxcpucount:%maxcpucount% /property:Configuration=%Configuration% /consoleloggerparameters:%consoleloggerparameters% /verbosity:%verbosity%
echo.
call colorTxt.bat cyan_L "building..."
echo .
echo MSBuild.exe "%~f1" /target:%target% /maxcpucount:%maxcpucount% /property:Configuration=%Configuration% /verbosity:%verbosity%
MSBuild.exe "%~f1" /target:%target% /maxcpucount:%maxcpucount% /property:Configuration=%Configuration% /verbosity:%verbosity%
goto :eof

:vsBuild.options.show
rem https://msdn.microsoft.com/en-us/library/ms164311.aspx
echo.
call tools_string.bat :stringLength "Configuration=%Configuration%" col1Width
set /a col1Width=%col1Width%+8

echo devenv.exe build parameters:
call tools_string.bat :stringAlignL "parameter name" %col1Width%
echo supported parameter value

echo outFolder=%outFolder%

call tools_string.bat :stringAlignL "target=%target%" %col1Width%
echo [build ^| rebuild ^| compile ^| clean]

call tools_string.bat :stringAlignL "Configuration=%Configuration%" %col1Width%
echo [release ^| debug]

call tools_string.bat :stringAlignL "platform=%platform%" %col1Width%
echo [ win32 ]

goto :eof

:vsBuild.build.default.log
@if defined _Stack @for %%a in ( 1 "%~nx0" "%0" ) do @if {"%%~a"}=={"%_Stack%"} @echo [      %~nx0] commandLine: %0 %*
call :vsBuild.build.default "%~f1" .log
goto :eof

:vsBuild.build.default
@if defined _Stack @for %%a in ( 1 "%~nx0" "%0" ) do @if {"%%~a"}=={"%_Stack%"} @echo [      %~nx0] commandLine: %0 %*
call :vsBuild.build%~2.one "%~f1" "target=rebuild" "Configuration=debug" "platform=win32"
call :vsBuild.build%~2.one "%~f1" "target=rebuild" "Configuration=release" "platform=win32"
goto :eof

:vsBuild.build.log.one
@if defined _Stack @for %%a in ( 1 "%~nx0" "%0" ) do @if {"%%~a"}=={"%_Stack%"} @echo [      %~nx0] commandLine: %0 %*
call :build.options.set %*
set outFolderPath=%~dp1%outFolder%
if not exist "%outFolderPath%" mkdir "%outFolderPath%"
set logPath=%outFolderPath%\%~n1.%target%.%Configuration%.%platform%.log
echo build log : %logPath%
if exist "%logPath%" del/f/q "%logPath%"
(
@call :vsBuild.build.one %*
) >> "%logPath%"
goto :eof

:vsBuild.build.one
::example call :vsBuild.build.one Name.sln rebuild debug win32
@if defined _Stack @for %%a in ( 1 "%~nx0" "%0" ) do @if {"%%~a"}=={"%_Stack%"} @echo [      %~nx0] commandLine: %0 %*
call :build.file.exist "%~1" || goto :End
call :build.options.set %*
call :vsBuild.options.show
echo.
where devenv.com 1>nul 2>nul || call :vsBuild.setPath
set /p="devenv.com path : "<nul
where devenv.com

@title devenv.com %~dpnx1 /%target% "%Configuration%|%platform%"
@set show=devenv.com %~dpnx1 /%target% \"%Configuration%|%platform%\"
@call colorTxt.bat purple_L "devenv.com %~dpnx1"
@echo.
@echo build option : %target% "%Configuration%|%platform%"
@echo %~dpnx1
@echo begin time : %date% %time%
@echo devenv.com %~fs1 /%target% "%Configuration%|%platform%"
@echo.
@devenv.com %~fs1 /%target% "%Configuration%|%platform%"
@echo.
@echo.
@echo complete time : %date% %time%
goto :eof

:vsBuild.setPath
if not defined defaultVsBuildPath set defaultVsBuildPath=%VS90COMNTOOLS%..\IDE
where devenv.com 1>nul 2>nul || set path=%path%;%defaultVsBuildPath%;
where devenv.com 1>nul 2>nul || (
call colorTxt.bat red_L "can not find devenv.com."
echo.
call colorTxt.bat cyan_L "%defaultVsBuildPath% is invalid."
echo.
pause
)
goto :eof

:End
@if defined _Stack @for %%a in ( 1 "%~nx0" "%0" ) do @if {"%%~a"}=={"%_Stack%"} @echo [----- %~nx0] commandLine: %0 %* & @echo.