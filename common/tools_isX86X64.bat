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
echo test call :IsX86OrX64Path "%~fs0" modType x86
call :IsX86OrX64Path "%~fs0" modType x86
echo modType=%modType%

echo.
echo test call :IsX86OrX64Folder "%~dp0" modType
call :IsX86OrX64Folder "%~dp0" modType
echo modType=%modType%

echo.
echo test call :IsX86OrX64Mod "%windir%\system32\notepad.exe" modType
call :IsX86OrX64Mod "%windir%\system32\notepad.exe" modType
echo modType=%modType%

echo.
echo test call :IsX86OrX64Mod "%~fs0" txtType
call :IsX86OrX64Mod "%~fs0" txtType
echo txtType=%txtType%

echo.
echo test call :IsX86OrX64OS "%windir%\system32\notepad.exe" modType
call :IsX86OrX64OS osType
echo osType=%osType%

goto :eof

::[DOS_API:IsX86OrX64Path]auto detect arch mode of one path.
::usage      : call :IsX86OrX64Path path osType [defMode]
::call e.g   : call :IsX86OrX64Path path osType
::             call :IsX86OrX64Path path osType  x64
::result e.g : set osType=x86
:IsX86OrX64Path
@if defined _Stack @for %%a in ( 1 "%~nx0" "%0" ) do @if {"%%~a"}=={"%_Stack%"} @echo [      %~nx0] commandLine: %0 %*
call tools_error.bat checkPathExist "%~f1"  "%~f0" checkPathExistMark
set %~2=%~3
call tools_path.bat getPathAttrib "%~f1"  _tmpAttrib
if {"%_tmpAttrib%"}=={"folder"} call :IsX86OrX64Folder      %*
if {"%_tmpAttrib%"}=={"file"}   call :IsX86OrX64.oneFile    %*
goto :eof

::[DOS_API:IsX86OrX64Folder]check the first file is x86/x64 arch in specified folder.
::usage      : call :IsX86OrX64Folder folderPath osType [defMode]
::call e.g   : call :IsX86OrX64Folder folderPath osType
::             call :IsX86OrX64Folder folderPath osType  x64
::result e.g : set osType=x86
:IsX86OrX64Folder
@if defined _Stack @for %%a in ( 1 "%~nx0" "%0" ) do @if {"%%~a"}=={"%_Stack%"} @echo [      %~nx0] commandLine: %0 %*
call tools_error.bat checkParamCount 2 %*
set %~2=%~3
pushd "%~1"
set _tmpFirstFile=
for /f "usebackq tokens=*" %%i in ( ` dir/s/b *.dmp,*.dll,*.exe ^| find /v "File Not Found" ` ) do if not defined _tmpFirstFile set "_tmpFirstFile=%%~fsi"
popd
if defined _tmpFirstFile call :IsX86OrX64.oneFile "%_tmpFirstFile%" %~2
if not defined %~2 set %~2=x64
goto :eof

:IsX86OrX64.oneFile
@if defined _Stack @for %%a in ( 1 "%~nx0" "%0" ) do @if {"%%~a"}=={"%_Stack%"} @echo [      %~nx0] commandLine: %0 %*
set %~2=%~3
set _tmpExt=%~x1
call tools_string.bat toLower _tmpExt
if {"%_tmpExt%"}=={".dll"} call :IsX86OrX64Mod "%~fs1" %~2
if {"%_tmpExt%"}=={".exe"} call :IsX86OrX64Mod "%~fs1" %~2
if {"%_tmpExt%"}=={".dmp"} call :IsX86OrX64Dump "%~fs1" %~2
rem if {"%_tmpExt%"}=={".pdb"} call :IsX86OrX64Mod "%~fs1" %~2
goto :eof

::[DOS_API:IsX86OrX64Mod]check one module is 32 bit or 64 bit, support .dll or .exe module
::usage      : call :IsX86OrX64Mod modPath outputVal
::call e.g   : call :IsX86OrX64Mod "C:\myApp\sym\gdi32.dll" modType
::result e.g : set modType=x86
:IsX86OrX64Mod
@if defined _Stack @for %%a in ( 1 "%~nx0" "%0" ) do @if {"%%~a"}=={"%_Stack%"} @echo [      %~nx0] commandLine: %0 %*
::https://www.raymond.cc/blog/determine-application-compiled-32-64-bit/
::7-zip or sigcheck.exe all can do this job, but 7-zip is better for check dll
call tools_error.bat checkParamCount 2 %*
call tools_error.bat checkFileExist "%~fs1"
set disablePathMsg_7z=1
if not defined _path7z call tools_appInstallPath.bat FindPath7Z _path7z
call tools_error.bat checkFileExist "%_path7z%\7z.exe"
set %~2=
for /f "usebackq tokens=1,2,3" %%i in ( ` call "%_path7z%\7z.exe" l "%~fs1" 2^>nul ^| find /i "CPU = " ` ) do call set %~2=%%k
if not defined %~2 set %~2=unknown
goto :eof

::[DOS_API:IsX86OrX64Process]check one process is 32 bit or 64 bit.
::usage      : call :IsX86OrX64Process PID outputVal
::call e.g   : call :IsX86OrX64Process 3352 procType
::result e.g : set procType=x86
:IsX86OrX64Process
@if defined _Stack @for %%a in ( 1 "%~nx0" "%0" ) do @if {"%%~a"}=={"%_Stack%"} @echo [      %~nx0] commandLine: %0 %*
call tools_process.bat ExecutablePath "%~1" _tmpProcessPath
call tools_message.bat enableDebugMsg "%~0" "_tmpProcessPath=%_tmpProcessPath%"
call :IsX86OrX64Process.parse %~2  "%_tmpProcessPath%"
goto :eof

:IsX86OrX64Process.parse
@if defined _Stack @for %%a in ( 1 "%~nx0" "%0" ) do @if {"%%~a"}=={"%_Stack%"} @echo [      %~nx0] commandLine: %0 %*
call :IsX86OrX64Mod "%~fs2" "%~1"
goto :eof

::[DOS_API:IsX86OrX64Dump]check one dump file is 32 bit or 64 bit.
::usage      : call :IsX86OrX64Dump dmpFilePath outputVal
::call e.g   : call :IsX86OrX64Dump "C;\temp\test.dmp" dmpType
::result e.g : set dmpType=x86
:IsX86OrX64Dump
@if defined _Stack @for %%a in ( 1 "%~nx0" "%0" ) do @if {"%%~a"}=={"%_Stack%"} @echo [      %~nx0] commandLine: %0 %*
if not defined windbgPath call tools_appInstallPath.bat FindPathWindbg windbgPath
set _tmpFile=%temp%\dumpType.txt
if exist "%_tmpFile%" del /f/q "%_tmpFile%"
::normal dumpchk.exe always outputs below similiar info, it will destroy some apply scenario , e.g. windbg .foreach command. here use 2>&1 to merge the output
::Loading dump file D:\...\fulldump.dmp
call "%windbgPath%\x64\dumpchk.exe" "%~fs1" > "%_tmpFile%"  2>&1 
echo _tmpFile=%_tmpFile%
set _tmpDmpX=
for /f "usebackq tokens=*" %%i in ( ` type "%_tmpFile%" ^| find /i "compatible" ^| find /i "x86" ` ) do if not defined _tmpDmpX call set _tmpDmpX=%%i
if     {"%_tmpDmpX%"}=={""} set %~2=x64
if not {"%_tmpDmpX%"}=={""} set %~2=x86
goto :eof

::[DOS_API:IsX86OrX64OS]check current OS is 32 bit or 64 bit.
::usage      : call :IsX86OrX64OS osType
::call e.g   : call :IsX86OrX64OS osType
::result e.g : set osType=x86
:IsX86OrX64OS
@if defined _Stack @for %%a in ( 1 "%~nx0" "%0" ) do @if {"%%~a"}=={"%_Stack%"} @echo [      %~nx0] commandLine: %0 %*
if     {"%PROCESSOR_ARCHITECTURE%"}=={"AMD64"} set %~1=x64
if not {"%PROCESSOR_ARCHITECTURE%"}=={"AMD64"} set %~1=x86
goto :eof

:End
@if defined _Stack @for %%a in ( 1 "%~nx0" "%0" ) do @if {"%%~a"}=={"%_Stack%"} @echo [----- %~nx0] commandLine: %0 %* & @echo.