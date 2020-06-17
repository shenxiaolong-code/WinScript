::Author    : Shen Xiaolong((xlshen@126.com))
::Copyright : free use,modify,spread, but MUST include this original two line information(Author and Copyright).

::@set _Echo=1
::set _Stack=%~nx0
@if {%_Echo%}=={1} ( @echo on ) else ( @echo off )
@if defined _Stack @for %%a in ( 1 "%~nx0" "%0" ) do @if {"%%~a"}=={"%_Stack%"} @echo. & @echo [+++++ %~nx0] commandLine: %0 %*
where "%~nx0" 1>nul 2>nul || set "path=%~dp0;%path%"

if {%1}=={} call :Test  & goto End
::if {%1}=={} call :Test NoOutput & goto End

call :%1 %2 %3 %4 %5 %6 %7 %8 %9
goto End

::[DOS_API:Help]display help information
:Help
@if defined _Stack @for %%a in ( 1 "%~nx0" "%0" ) do @if {"%%~a"}=={"%_Stack%"} @echo [      %~nx0] commandLine: %0 %*
call tools_miscellaneous.bat DisplayHelp "%~f0"
goto :eof

::[DOS_API:Test]Test DOS API in this script file
:Test
@if defined _Stack @for %%a in ( 1 "%~nx0" "%0" ) do @if {"%%~a"}=={"%_Stack%"} @echo [      %~nx0] commandLine: %0 %*
@echo [%~nx0] Run test case [%0 %*]
echo.
echo test call :Help
call :Help

echo.
echo download with default downloader : powershell
set target_url=http://shanghai-nfs.cisco.com/archive/12.0/FCS/260976/280/JabberWin/CiscoJabberSetup.msi
set target_path=D:\CiscoJabberSetup.msi
if exist "%target_path%" del /f/q "%target_path%"
echo test call :download "%target_url%" "%target_path%"
call :download "%target_url%" "%target_path%"
if not exist "%target_path%" (
call :colorTxt.bat 0c "test case[%~f0:%~0] fails."
echo.
) else (
echo test download sucessfully.
)
del /f/q "%target_path%"

echo.
echo download with downloader : bitsadmin
set downloader=bitsadmin
echo test call :download "%target_url%" "%target_path%"
call :download "%target_url%" "%target_path%"
if not exist "%target_path%" (
call :colorTxt.bat 0c "test case[%~f0:%~0] fails."
echo.
) else (
echo test download sucessfully.
)
del /f/q "%target_path%"

goto :eof


::[DOS_API:download]download a file from one url
::call e.g  : call :download  'http://shanghai-nfs.cisco.com/builds/Trunk/BUILD_TRUNK_JABBERWIN-RELEASE/12667/archive/CiscoJabberSetup.msi' 'D:\CiscoJabberSetup.msi'"
:download
@if defined _Stack @for %%a in ( 1 "%~nx0" "%0" ) do @if {"%%~a"}=={"%_Stack%"} @echo [      %~nx0] commandLine: %0 %*
if {"%~2"}=={""} (
call colorTxt.bat 0c "parameter is not enough. usage example:"
echo.
call colorTxt.bat 0b "call %~f0 download 'http://shanghai-nfs.cisco.com/builds/Trunk/BUILD_TRUNK_JABBERWIN-RELEASE/12667/archive/CiscoJabberSetup.msi' 'D:\CiscoJabberSetup.msi'"
echo.
call tools_txtFile.bat ShowCurLineNo "%~f0" mark97
pause
goto :End
)
set "_targetUrl=%~1"
set "_targetPath=%~2"
if not defined downloader set downloader=curl
call :download.%downloader% "%_targetUrl%" "%_targetPath%"
goto :eof

:download.bitsadmin
@if defined _Stack @for %%a in ( 1 "%~nx0" "%0" ) do @if {"%%~a"}=={"%_Stack%"} @echo [      %~nx0] commandLine: %0 %*
::using bitsadmin.exe
::bitsadmin.exe is standard Windows component which is included XP and  2000 SP3 later, support many option, e.g. proxy
::if not defined optParam set optParam=/download  /priority normal
echo download command:
echo bitsadmin.exe /transfer "%~nx2" %optParam% "%~1" "%~2"
bitsadmin.exe /transfer "%~nx2" %optParam% "%~1" "%~2"
goto :eof

:download.powershell
@if defined _Stack @for %%a in ( 1 "%~nx0" "%0" ) do @if {"%%~a"}=={"%_Stack%"} @echo [      %~nx0] commandLine: %0 %*
::using powershell , powershell is very fast to download url but but without download rate and process
echo download command:
echo powershell -command "& { (New-Object Net.WebClient).DownloadFile('%~1', '%~2') }"
powershell -command "& { (New-Object Net.WebClient).DownloadFile('%~1', '%~2') }"
goto :eof

:download.curl
@if defined _Stack @for %%a in ( 1 "%~nx0" "%0" ) do @if {"%%~a"}=={"%_Stack%"} @echo [      %~nx0] commandLine: %0 %*
::using curl , curl is very fast to download url without download rate and process
echo download command:
echo curl "%~1" -o "%~2"
curl "%~1" -o "%~2"
goto :eof

:End
@if defined _Stack @for %%a in ( 1 "%~nx0" "%0" ) do @if {"%%~a"}=={"%_Stack%"} @echo [----- %~nx0] commandLine: %0 %* & @echo.