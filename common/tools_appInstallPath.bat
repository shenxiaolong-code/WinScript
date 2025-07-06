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

echo.
echo test call :FindPath7Z _app7Z
call :FindPath7Z _app7Z
echo _app7Z=%_app7Z%

echo.
echo skip Cisco-specified :FindPathStig
:: echo test call :FindPathStig _appStig
:: call :FindPathStig _appStig
:: echo _appStig=%_appStig%

echo.
echo skip nivdia dev-env :FindPathWindbg
:: echo test call :FindPathWindbg _appWindbg
:: call :FindPathWindbg _appWindbg
:: echo _appWindbg=%_appWindbg%

echo.
echo test call :FindVisualStudio _appNewestVs
call :FindVisualStudio _appNewestVs
echo _appNewestVs=%_appNewestVs%

echo.
echo test call :FindPathNotepad _appNotepad
call :FindPathNotepad _appNotepad
echo _appNotepad=%_appNotepad%

echo.
echo test call :FindPathPython _appPython
call :FindPathPython _appPython
echo _appPython=%_appPython%

echo.
echo test call pythonModuleInstalled "Scrapy" bScrapyInstalled
call tools_appInstallPath.bat pythonModuleInstalled "Scrapy" bScrapyInstalled
if      defined bScrapyInstalled echo Scrapy is installed.
if not  defined bScrapyInstalled echo Scrapy is NOT installed.

echo.
echo test call pythonModuleInstalled "Scrapy11" bScrapyInstalled
call tools_appInstallPath.bat pythonModuleInstalled "Scrapy11" bScrapyInstalled
if      defined bScrapyInstalled echo Scrapy11 is installed.
if not  defined bScrapyInstalled echo Scrapy11 is NOT installed.

echo.
goto :eof

set "%~1=%~s2"
goto :eof

::[DOS_API:FindPath7Z]find 7-zip application install path
::usage      : call :FindPath7Z appPath
::result e.g : set appPath=C:\somepath
:FindPath7Z
@if defined _Stack @for %%a in ( 1 "%~nx0" "%0" ) do @if {"%%~a"}=={"%_Stack%"} @echo [      %~nx0] commandLine: %0 %*
call :pathVar.check "7z.exe" %~1
if not defined %~1 call :evnVar.check g_ZipDir   "%~1"
if not defined %~1 call tools_path.bat FindAppPathInReg "HKEY_CLASSES_ROOT\Applications\7z.exe\shell\open\command" "%~1"
if not defined %~1 call tools_path.bat FindAppPathinDisk "7z.exe" "%~1"
call :evnVar.set g_ZipDir   "%~1"
goto :eof

::[DOS_API:FindPathStig]find stig.exe application path
::usage      : call :FindPathStig appPath
::result e.g : set appPath=C:\somepath
:FindPathStig
@if defined _Stack @for %%a in ( 1 "%~nx0" "%0" ) do @if {"%%~a"}=={"%_Stack%"} @echo [      %~nx0] commandLine: %0 %*
call :pathVar.check "stig.exe" %~1
if not defined %~1 call :evnVar.check g_StigDir   "%~1"
if not defined %~1 call tools_path.bat FindAppPathinDisk "stig.exe" "%~1"
call :evnVar.set g_StigDir   "%~1"
goto :eof

::[DOS_API:FindPathWindbg]find windbg application install path
::usage      : call :FindPathWindbg appPath
::result e.g : set appPath=C:\somepath
:FindPathWindbg
@if defined _Stack @for %%a in ( 1 "%~nx0" "%0" ) do @if {"%%~a"}=={"%_Stack%"} @echo [      %~nx0] commandLine: %0 %*
:: set "defWindbgPath=C:\Program Files (x86)\Windows Kits\10\Debuggers"
call :pathVar.check "windbg.exe" %~1 ".."
if not defined %~1 call :evnVar.check g_windbgDir   "%~1"
if not defined %~1 call tools_path.bat FindAppPathInReg "HKEY_CURRENT_USER\Software\Classes\Applications\windbg.exe\shell\open\command" %~1 ".."
if not defined %~1 call tools_path.bat FindAppPathinDisk "windbg.exe" %~1 ".."
call :evnVar.set g_windbgDir   "%~1"
goto :eof

::[DOS_API:FindVisualStudio]find VisualStudio application install path
::usage      : call :FindVisualStudio appPath [optVsVer]
::result e.g : set appPath=C:\somepath
:FindVisualStudio
@if defined _Stack @for %%a in ( 1 "%~nx0" "%0" ) do @if {"%%~a"}=={"%_Stack%"} @echo [      %~nx0] commandLine: %0 %*
where tools_vs.bat 1>nul 2>nul || @set "path=%~dps0..\windbg;%path%"
if      {"%~2"}=={""} call tools_vs.bat vsInstallPath newest    "%~1"
if not  {"%~2"}=={""} call tools_vs.bat vsInstallPath "%~2"    	"%~1"
goto :eof

::[DOS_API:FindPathNotepad++]find notepad++ application install path
::usage      : call :FindPathNotepad++ appPath
::result e.g : set appPath=C:\somepath
:FindPathNotepad++
@if defined _Stack @for %%a in ( 1 "%~nx0" "%0" ) do @if {"%%~a"}=={"%_Stack%"} @echo [      %~nx0] commandLine: %0 %*
:: improve performance by checking the default install path first
:: if you have installed notepad++ in other path, you can define disablePathMsg_notepad++ to disable this warning.
:: e.g: set disablePathMsg_notepad++=1
if exist "C:\Program Files\Notepad++\notepad++.exe" (
    set "%~1=C:\Program Files\Notepad++" 
    goto :eof
)
call :pathVar.check "notepad++.exe" %~1
if not defined %~1 call :evnVar.check g_NppDir   "%~1"
if not defined %~1 call tools_path.bat FindAppPathInReg "HKEY_CURRENT_USER\Software\Classes\Applications\notepad++.exe\shell\open\command" %~1
if not defined %~1 call tools_path.bat FindAppPathinDisk "notepad++.exe" "%~1"
call :evnVar.set g_NppDir   "%~1"
goto :eof

::[DOS_API:FindPathPython]find python application install path
::usage      : call :FindPathPython appPath
::result e.g : set appPath=C:\somepath
:FindPathPython
@if defined _Stack @for %%a in ( 1 "%~nx0" "%0" ) do @if {"%%~a"}=={"%_Stack%"} @echo [      %~nx0] commandLine: %0 %*
call :pathVar.check "python.exe" %~1
call :evnVar.set g_pythonDir   "%~1"
goto :eof

::[DOS_API:pythonModuleInstalled]check whether python extension is installed.
::usage         : call tools_path.bat pythonModuleInstalled pythonAppName  bOutputValue
::outVar        : bOutputValue
::example       : set bOutputValue=1
::              : call tools_path.bat pythonModuleInstalled "Scrapy" bScrapyInstalled
::              : bScrapyInstalled=1
:pythonModuleInstalled
@if defined _Stack @for %%a in ( 1 "%~nx0" "%0" ) do @if {"%%~a"}=={"%_Stack%"} @echo [      %~nx0] commandLine: %0 %*
set %~2=
for /f "usebackq tokens=1" %%i in ( ` pip list 2^>^&1 ^| find /i "%~1" ` ) do set %~2=1
goto :eof

::************************************ inner implement begin **********************************************************************************************
:pathVar.check
:: call :pathVar.check "myApp.exe" appPath  
:: call :pathVar.check "myApp.exe" appPath  "..\..\otherFolder"
@if defined _Stack @for %%a in ( 1 "%~nx0" "%0" ) do @if {"%%~a"}=={"%_Stack%"} @echo [      %~nx0] commandLine: %0 %*
where "%~nx1" 1>nul 2>nul || goto :eof
if not defined disablePathMsg_%~n1 call tools_message.bat warningMsg "'%~nx1' is already in your path. needn't to find its path. define disablePathMsg_%~n1 to disable this warning. "
for /f "tokens=*" %%i in ( "%~nx1" ) do set "%~2=%%~dp$path:i%~3"
call tools_path.bat ToNormalPath "%~2"
goto :eof

:evnVar.check
@if defined _Stack @for %%a in ( 1 "%~nx0" "%0" ) do @if {"%%~a"}=={"%_Stack%"} @echo [      %~nx0] commandLine: %0 %*
if not defined %~1 goto :eof
call set "_tmpEnvPath=%%%~1%%"
if {"%~1"}=={"%~2"} if exist "%_tmpEnvPath%" goto :eof
if exist "%_tmpEnvPath%" set "%~2=%_tmpEnvPath%"
if not exist "%_tmpEnvPath%"  set "%~1=" >nul & start setx %~1 ""  >nul
goto :eof

:evnVar.set
@if defined _Stack @for %%a in ( 1 "%~nx0" "%0" ) do @if {"%%~a"}=={"%_Stack%"} @echo [      %~nx0] commandLine: %0 %*
if {"%~1"}=={"%~2"} goto :eof
if not 	defined %~2 goto :eof
if 		defined %~1 goto :eof
call tools_message.bat enableDebugMsg "%~0" "setx %~1 %%%~2%%"
call echo call setx %~1 "%%%~2%%"
call setx %~1 "%%%~2%%"
goto :eof

::************************************ inner implement end **********************************************************************************************

:End
@if defined _Stack @for %%a in ( 1 "%~nx0" "%0" ) do @if {"%%~a"}=={"%_Stack%"} @echo [----- %~nx0] commandLine: %0 %* & @echo.