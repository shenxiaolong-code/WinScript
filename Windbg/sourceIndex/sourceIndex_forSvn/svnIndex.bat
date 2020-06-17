::@set _Echo=1
::set _Stack=%~nx0
::@det _Debug=1
@if {%_Echo%}=={1} ( @echo on ) else ( @echo off )
@@if defined _Stack @for %%a in ( 1 "%~nx0" "%0" ) do @if {"%%~a"}=={"%_Stack%"} @echo. & @echo [+++++ %~nx0] commandLine: %0 %*
where "%~nx0" 1>nul 2>nul || set "path=%~dp0;%path%"
@cls

if not defined runPerlDebugMode     set runPerlDebugMode=0
if not defined runInPerlDebugger    set runInPerlDebugger=0
if not defined enableVerboseOption  set enableVerboseOption=1

:: srcDir point to solution source directory
rem set srcDir=https://127.0.0.1/svn/shenxiaolong/core/Projects/Features/sources
rem set srcDir=%rootPath%\Projects\Features\sources
set "srcDir=%~s1"
:: pdbBinDir point to solution output directory with .exe/.dll/.pdb files
rem set pdbBinDir=%rootPath%\Projects\Features\output\Features_vs2015\Release\bin
set "pdbBinDir=%~s2"
:: publibSymUrl point to public symbol path, it can be network http url or directory path
set "publibSymUrl=%~3"

call :configPath
call :indexSource
goto :End
@echo.
call :dumpSourceInPdb
@echo.
call "%~dp0..\storeSymbol.bat"  "%pdbBinDir%" "%publibSymUrl%" "testProject"
goto :End

:indexSource
@if defined _Stack @for %%a in ( 1 "%~nx0" "%0" ) do @if {"%%~a"}=={"%_Stack%"} @echo [      %~nx0] commandLine: %0 %*
call :indexSource.setOption
call :checkPathExist "%srcDir%"
call :checkPathExist "%pdbBinDir%"
call :indexSource.svn
rem call :indexSource.custom
@echo.
echo [OK] pdb files in '%pdbBinDir%' is sourced indexed with source path '%srcDir%'.
goto :eof

:indexSource.custom
@if defined _Stack @for %%a in ( 1 "%~nx0" "%0" ) do @if {"%%~a"}=={"%_Stack%"} @echo [      %~nx0] commandLine: %0 %*
rem set pdbBinDir=%rootPath%\Projects\Features\output\Features_vs2015\Release\bin;%rootPath%\Projects\Core\output\Core_vs2015\Release\bin;
rem TODO : need to check semi-colon delimited list of pdb directory paths
set pdbTypes=%pdbBinDir%
for /f "usebackq tokens=*" %%i in ( ` dir/s/b "%pdbTypes%" ` ) do @call :indexSource.custom.onePdb %%i
goto :eof

:indexSource.custom.onePdb
srctool -r "%~fs1" | find /i "%srcDir%"
goto :eof

:indexSource.svn
@if defined _Stack @for %%a in ( 1 "%~nx0" "%0" ) do @if {"%%~a"}=={"%_Stack%"} @echo [      %~nx0] commandLine: %0 %*
rem if working directory is not source directory, "Zero Pdb Indexed" error occurs.
cd /d "%srcDir%"
echo working directory : %cd%
svn info "%cd%"
rem for help , run : svnindex -??
set _cmd=svnindex.cmd /source="%srcDir%" /symbols="%pdbBinDir%" %svnindexOpt%
rem set _cmd=svnindex.cmd /source="J:\BLD_Trunk" /symbols="J:\BLD_Trunk\products\jabber-win\src\jabber-client\jabber-build\Win32\bin\Release" /debug /save=out
echo index symbols .....
echo %_cmd%
call %_cmd%
goto :eof

:indexSource.setOption
@if defined _Stack @for %%a in ( 1 "%~nx0" "%0" ) do @if {"%%~a"}=={"%_Stack%"} @echo [      %~nx0] commandLine: %0 %*
if {"%runPerlDebugMode%"}=={"1"}        set SSDEBUGMODE=1
if {"%runInPerlDebugger%"}=={"1"}       set SRCSRV_PERL_DEBUG_FLAGS=-d
if {"%enableVerboseOption%"}=={"1"}     set svnindexOpt=-DEBUG:127 /save="%~dp0output_Cache" /ini="%SRCSRV_INI_FILE%" /debug /dieonerror
set SRCSRV_INI_FILE=%WinScriptPath%\Windbg\setup\srcSrv.ini
goto :eof

:configPath
@if defined _Stack @for %%a in ( 1 "%~nx0" "%0" ) do @if {"%%~a"}=={"%_Stack%"} @echo [      %~nx0] commandLine: %0 %*
echo used tool path:
where perl.exe      || set "path=C:\Perl64\bin;%path%"
where svnindex.cmd  || set "path=C:\PROGRA~2\WI3CF2~1\10\DEBUGG~1\x86\srcsrv;%path%"
where symstore.exe  || set "path=C:\PROGRA~2\WI3CF2~1\10\DEBUGG~1\x86;%path%"
set "rootPath=%~fs0"
set "rootPath=%rootPath:\WinScript=&;rem%"
echo rootPath=%rootPath%
rem D:\work\shenxiaolong\core
echo.
goto :eof

:dumpSourceInPdb
@if defined _Stack @for %%a in ( 1 "%~nx0" "%0" ) do @if {"%%~a"}=={"%_Stack%"} @echo [      %~nx0] commandLine: %0 %*
for /f "usebackq tokens=*" %%i in ( ` dir/s/b "%pdbBinDir%\*.pdb" ` ) do @call :dumpSourceInPdb.onePdb %%i
goto :eof

:dumpSourceInPdb.onePdb
@if defined _Stack @for %%a in ( 1 "%~nx0" "%0" ) do @if {"%%~a"}=={"%_Stack%"} @echo [      %~nx0] commandLine: %0 %*
@echo index source info in "%~1" : 
rem detail info:
rem pdbstr.exe -r -p:"%~fs1" -s:srcsrv
rem pdbstr.exe -r -P:D:\work\shenxiaolong\core\Projects\Features\output\Features_vs2015\Release\bin\UT_Excel.pdb -s:srcsrv
srctool.exe -c "%~fs1"
@echo.
@echo.
goto :eof

:checkPathExist
@if defined _Stack @for %%a in ( 1 "%~nx0" "%0" ) do @if {"%%~a"}=={"%_Stack%"} @echo [      %~nx0] commandLine: %0 %*
if not exist "%~1" (
echo path "%~1" doesn't exist.
echo press any key to exit
pause 1>nul
exit -1
)
goto :eof

:comments
@if defined _Stack @for %%a in ( 1 "%~nx0" "%0" ) do @if {"%%~a"}=={"%_Stack%"} @echo [      %~nx0] commandLine: %0 %*
https://www.codeproject.com/Articles/115125/Source-Indexing-and-Symbol-Servers-A-Guide-to-Easi
1. install environment:
//https://social.msdn.microsoft.com/Forums/en-US/2a1b4ed0-570f-4e18-806a-76f5c4df193d/source-server-srcsrv-hello-world-tutorial?forum=windbg
full steps:
1.1 Installed Debugging tools for Windows v.6.11.1.404 for Win x64
1.2 Installed Activestate Perl v5.14.2
1.3 Installed svn v1.7.3
1.4 Ensure %DEBUG_TOOLS%\srcsrv, svn.exe, perl.exe is on system PATH
1.5 Created a new console application in Visual Studio
1.6 Modified default class to print "Hello World" to console
1.7 Build Debug and Release configurations
1.8 Verified srctool.exe -r displays source file on built pdb
1.9 Created a local svn filesystem repository using TortoiseSVN
1.10 imported built application & source into local svn filesystem repository
1.11 modified srcsrv.ini setting MYSERVER to local svn filesystem repository url
1.12 Executed svnindex.cmd /source=%SRC_ROOT% /symbols=%SRC_ROOT%/bin /debug /save=d:\indexSym\cacheFolder

2.index source and store pdb to symbols server:
2.1  Note: indexing one pdb file will update pdb file content and update its modified date time (timestamp).
2.2  Best detail flow:
     http://gdi.plus/?cat=15
     
3.  windbg pdb related tools(source index)
3.1 pdbstr.exe , r/w pdb file to source index pdb file
3.2 srctool.exe , show source info from one pdb (source-indexed or not).
3.3 symstore.exe , add pdb (source-indexed or not) to public symbol path.

4. source index for git 
   https://gist.github.com/baldurk/c6feb31b0305125c6d1a
   
goto :eof

:End
@if defined _Stack @for %%a in ( 1 "%~nx0" "%0" ) do @if {"%%~a"}=={"%_Stack%"} @echo [----- %~nx0] commandLine: %0 %* & @echo.
cd /d "%~dp0"
rem pause