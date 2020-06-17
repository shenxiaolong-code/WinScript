::Author    : Shen Xiaolong((xlshen@126.com))
::Copyright : free use,modify,spread, but MUST include this original two line information(Author and Copyright).

::@set _Echo=1
::set _Stack=%~nx0
::set _Debug=1
@if {%_Echo%}=={1} ( @echo on ) else ( @echo off )
@if defined _Stack @for %%a in ( 1 "%~nx0" "%0" ) do @if {"%%~a"}=={"%_Stack%"} @echo. & @echo [+++++ %~nx0] commandLine: %0 %*
where "%~nx0" 1>nul 2>nul || set "path=%~dp0;%path%"
if not defined ToolRootPath call :setToolRootPath
echo %~fs0 %*

if {%1}=={} call :Test NoOutput & goto End
call :%~1 %2 %3 %4 %5 %6 %7 %8 %9
goto End

::[DOS_API:Help]display help information
:Help
@if defined _Stack @for %%a in ( 1 "%~nx0" "%0" ) do @if {"%%~a"}=={"%_Stack%"} @echo [      %~nx0] commandLine: %0 %*
where tools_miscellaneous.bat 1>nul 2>nul || set "path=%~dp0;%path%"
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
echo test viewFunction "%~dp0bin\7z.exe"
call :viewFunction "%~dp0bin\7z.exe"
echo.

echo.
goto :eof

::[DOS_API:viewFunction] 
::usage         : viewFunction <bin_file_path>
::e.g.          : viewFunction d:\myPath\myApp.exe
:viewFunction
@if defined _Stack @for %%a in ( 1 "%~nx0" "%0" ) do @if {"%%~a"}=={"%_Stack%"} @echo [      %~nx0] commandLine: %0 %*
call tools_error.bat checkPathExist "%~fs1" "%~fs0" viewFunction_mark
call :implCmd "%ToolRootPath%\PC_tools\devTools\DLL Export Viewer\dllexp.exe" "%~fs1"
goto :eof

::[DOS_API:viewDependency] 
::usage         : viewDependency <bin_file_path>
::e.g.          : viewDependency d:\myPath\myApp.exe
:viewDependency
@if defined _Stack @for %%a in ( 1 "%~nx0" "%0" ) do @if {"%%~a"}=={"%_Stack%"} @echo [      %~nx0] commandLine: %0 %*

call tools_error.bat checkPathExist "%~fs1" "%~fs0" viewDependency_mark
call :implCmd "%ToolRootPath%\PC_tools\devTools\Dependency_win10_x86\DependenciesGui.exe" "%~fs1"
goto :eof

::[DOS_API:peView] 
::usage         : peView <bin_file_path>
::e.g.          : peView d:\myPath\myApp.exe
:peView
@if defined _Stack @for %%a in ( 1 "%~nx0" "%0" ) do @if {"%%~a"}=={"%_Stack%"} @echo [      %~nx0] commandLine: %0 %*
call tools_error.bat checkPathExist "%~fs1" "%~fs0" peView_mark
call :implCmd "%ToolRootPath%\PC_tools\devTools\PEview\PEview.exe" "%~fs1"
call :implCmd "%ToolRootPath%\PC_tools\devTools\process_tools\processhacker-2.39-bin\x64\peview.exe" "%~fs1"
goto :eof

::[DOS_API:listProcess] list all running process who include this module.
::usage         : listProcess <bin_file_path>
::e.g.          : listProcess d:\myPath\myApp.exe
:listProcess
@if defined _Stack @for %%a in ( 1 "%~nx0" "%0" ) do @if {"%%~a"}=={"%_Stack%"} @echo [      %~nx0] commandLine: %0 %*
set "listProcessFile=%temp%\dumpBin_%~n1.txt"
call tools_appInstallPath.bat FindPathWindbg _appWindbg
call tools_error.bat checkPathExist "%_appWindbg%\x64\tlist.exe"
call "%_appWindbg%\x64\tlist.exe" -m "%~nx1" > "%listProcessFile%"
call tools_txtFile.bat openTxtFile "%listProcessFile%"
goto :eof

::[DOS_API:dumpBin] 
::usage         : dumpBin <bin_file_path>
::e.g.          : dumpBin d:\myPath\myApp.exe
:dumpBin
@if defined _Stack @for %%a in ( 1 "%~nx0" "%0" ) do @if {"%%~a"}=={"%_Stack%"} @echo [      %~nx0] commandLine: %0 %*
call tools_error.bat checkPathExist "%~fs1" "%~fs0" dumpBin_mark
set "dumpbinFile=%temp%\dumpBin_%~n1.txt"
call "%ToolRootPath%\core\WinScript\Windbg\dumpbin_x86\dumpbin.exe" /all "%~fs1" > "%dumpbinFile%"
call tools_txtFile.bat openTxtFile "%dumpbinFile%"
goto :eof

::[DOS_API:hexEdit] 
::usage         : hexEdit <bin_file_path>
::e.g.          : hexEdit d:\myPath\myApp.exe
:hexEdit
@if defined _Stack @for %%a in ( 1 "%~nx0" "%0" ) do @if {"%%~a"}=={"%_Stack%"} @echo [      %~nx0] commandLine: %0 %*
call tools_error.bat checkPathExist "%~fs1" "%~fs0" hexEdit_mark
call :implCmd "%ToolRootPath%\PC_tools\HexEditor\XVI32.exe" "%~fs1"
goto :eof

::[DOS_API:downloadPdb] 
::usage         : downloadPdb <bin_file_path>
::e.g.          : downloadPdb d:\myPath\myApp.exe
:downloadPdb
@if defined _Stack @for %%a in ( 1 "%~nx0" "%0" ) do @if {"%%~a"}=={"%_Stack%"} @echo [      %~nx0] commandLine: %0 %*
call tools_error.bat checkPathExist "%~fs1" "%~fs0" downloadPdb_mark
call "%ToolRootPath%\core\WinScript\Windbg\tools_windbg.bat"  downloadPdb  %*
goto :eof

:setToolRootPath
@if defined _Stack @for %%a in ( 1 "%~nx0" "%0" ) do @if {"%%~a"}=={"%_Stack%"} @echo [      %~nx0] commandLine: %0 %*
call set "_tmpRoot=%~fs0"
set ToolRootPath=%_tmpRoot:\core=&rem.%
::echo ToolRootPath=%ToolRootPath%
call tools_error.bat checkPathExist "%ToolRootPath%\PC_tools" "%~fs0" setToolRootPath_mark
goto :eof

:implCmd
@if defined _Stack @for %%a in ( 1 "%~nx0" "%0" ) do @if {"%%~a"}=={"%_Stack%"} @echo [      %~nx0] commandLine: %0 %*
start "" %*
goto :eof

:End
@if defined _Stack @for %%a in ( 1 "%~nx0" "%0" ) do @if {"%%~a"}=={"%_Stack%"} @echo [----- %~nx0] commandLine: %0 %* & @echo.