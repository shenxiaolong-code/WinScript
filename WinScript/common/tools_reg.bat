::Author    : Shen Xiaolong((xlshen@126.com))
::Copyright : free use,modify,spread, but MUST include this original two line information(Author and Copyright).

::@set _Echo=1
::set _Stack=%~nx0
@if {"%_Echo%"}=={"1"} ( @echo on ) else ( @echo off )
@if defined _Stack @for %%a in ( 1 "%~nx0" "%0" ) do @if {"%%~a"}=={"%_Stack%"} @echo. & @echo [+++++ %~nx0] commandLine: %0 %*
where %~nx0 1>nul 2>nul || set "path=%~dp0;%path%"
where TortoiseProc.exe 1>nul 2>nul || set "path=C:\Program Files\TortoiseSVN\bin;%path%"

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
echo [TC] test call :deleteRegDirectory
set "tc_regPath=HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\wbxcOIEx.exe"
echo call :deleteRegDirectory "%tc_regPath%"
call :deleteRegDirectory "%tc_regPath%"

echo.
echo [TC] test call :deleteRegVariable
set "tc_regVar=\\ZODIAC\HKLM\Software\MyCo\MTU"
echo call :deleteRegVariable "%tc_regVar%"
call :deleteRegVariable "%tc_regVar%"

echo.
echo [TC] test call :importRegFile
set "tc_regFile=D:\work\shenxiaolong\core\WinScript\Windbg\contextMenu\template\appLaunch.reg"
echo call :importRegFile "%tc_regFile%"
call call :importRegFile "%tc_regFile%"

echo.
echo [TC] test call :makeRegPath
set "tc_filePath=%~f0"
echo call :makeRegPath "%tc_filePath%" tcOut_filePath
call :makeRegPath "%tc_filePath%" tcOut_filePath
echo [result] "%tc_filePath%" =^> "%tcOut_filePath%"

goto :eof

::[DOS_API:deleteRegDirectory] delete specified registry directory
::call e.g  : call :deleteRegDirectory registryDirectory
::result e.g: call :deleteRegDirectory "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\wbxcOIEx.exe"
:deleteRegDirectory
@if defined _Stack @for %%a in ( 1 "%~nx0" "%0" ) do @if {"%%~a"}=={"%_Stack%"} @echo [      %~nx0] commandLine: %0 %*
call set "_tmpdeleteRegDirectory=%~1"
if {"%_tmpdeleteRegDirectory:~0,2%"}=={"\\"}            set "_tmpdeleteRegDirectory=%_tmpdeleteRegDirectory:~2%"
if {"%_tmpdeleteRegDirectory:~0,1%"}=={"\"}             set "_tmpdeleteRegDirectory=%_tmpdeleteRegDirectory:~1%"
if {"%_tmpdeleteRegDirectory:~0,9%"}=={"Computer\"}     set "_tmpdeleteRegDirectory=%_tmpdeleteRegDirectory:~9%"
echo y | reg delete "%_tmpdeleteRegDirectory%"
goto :eof

::[DOS_API:deleteRegVariable] delete specified registry variable path
::call e.g  : call :deleteRegVariable registryVariablePath
::result e.g: call :deleteRegVariable "\\ZODIAC\HKLM\Software\MyCo\MTU"
:deleteRegVariable
@if defined _Stack @for %%a in ( 1 "%~nx0" "%0" ) do @if {"%%~a"}=={"%_Stack%"} @echo [      %~nx0] commandLine: %0 %*
call :makeRegKeyFromVarPath "%~1" _tmpDeleteRegVariableKey
echo y | reg delete "\\%_tmpDeleteRegVariableKey%" /v "%~nx1"
goto :eof

::[DOS_API:addRegVariable] add specified registry variable path
::call e.g  : call :addRegVariable registryVariablePath value
::result e.g: call :addRegVariable "\\ZODIAC\HKLM\Software\MyCo\MTU" value
:addRegVariable
@if defined _Stack @for %%a in ( 1 "%~nx0" "%0" ) do @if {"%%~a"}=={"%_Stack%"} @echo [      %~nx0] commandLine: %0 %*
call :makeRegKeyFromVarPath "%~1" _tmpaddRegVariable
if not defined regValType set regValType=REG_SZ 
rem other regValType vaue :
rem REG_BINARY      fe340ead
rem REG_DWORD	    0x111
rem REG_QWORD	    0x111
rem REG_MULTI_SZ    fax\0mail
rem REG_EXPAND_SZ   ^%systemroot^%      //use environment variable's value
echo y | reg add "%_tmpaddRegVariable%" /v "%~nx1" /t %regValType% /d "%~2"
goto :eof

::[DOS_API:queryRegVariable] query specified registry variable value
::call e.g  : call :queryRegVariable registryVariablePath outVar
::result e.g: call :queryRegVariable "\\ZODIAC\HKLM\Software\MyCo\MTU" outVar
:queryRegVariable
@if defined _Stack @for %%a in ( 1 "%~nx0" "%0" ) do @if {"%%~a"}=={"%_Stack%"} @echo [      %~nx0] commandLine: %0 %*
set %~2=
call :makeRegKeyFromVarPath "%~1" _tmpQueryRegVariable
::reg query HKEY_LOCAL_MACHINE\SOFTWARE\WOW6432Node\Microsoft\VisualStudio\SxS\VS7 /v 14.0
for /f "usebackq tokens=2*" %%i in ( `reg query "%_tmpQueryRegVariable%" /v "%~nx1" 2^>nul ` ) do set "%~2=%%~j"
goto :eof

::[DOS_API:importRegFile] import specified registry directory
::call e.g  : call :importRegFile registryFile
::result e.g: call :importRegFile "D:\work\shenxiaolong\core\WinScript\Windbg\contextMenu\template\appLaunch.reg"
:importRegFile
@if defined _Stack @for %%a in ( 1 "%~nx0" "%0" ) do @if {"%%~a"}=={"%_Stack%"} @echo [      %~nx0] commandLine: %0 %*
call tools_error.bat checkPathExist "%~fs1"  "%~f0" importRegFileMark
REG IMPORT "%~fs1"
goto :eof

::[DOS_API:makeRegPath] convert specified file path to registry path
::Note          : use double blash '\\' to represent one blash.
::call e.g  : call :makeRegPath filePath  regFilePath
::result e.g: call :makeRegPath "D:\work\shenxiaolong\core\WinScript\Windbg\contextMenu\template\deme.txt"  regOutPath
::            set "regOutPath=D:\\work\\shenxiaolong\\core\\WinScript\\Windbg\\contextMenu\\template\\deme.txt"
:makeRegPath
@if defined _Stack @for %%a in ( 1 "%~nx0" "%0" ) do @if {"%%~a"}=={"%_Stack%"} @echo [      %~nx0] commandLine: %0 %*
set "_tmpVar=%~1"
if not {"%_tmpVar%"}=={"%_tmpVar:\\=%"} call set "%~2=%_tmpVar%"
if {"%_tmpVar%"}=={"%_tmpVar:\\=\%"} call set "%~2=%_tmpVar:\=\\%"
goto :eof

:makeRegKeyFromVarPath
@if defined _Stack @for %%a in ( 1 "%~nx0" "%0" ) do @if {"%%~a"}=={"%_Stack%"} @echo [      %~nx0] commandLine: %0 %*
set "_tmpMakeRegKey=%~1"
if {"%_tmpMakeRegKey:~0,9%"}=={"Computer\"}      set "_tmpMakeRegKey=%_tmpMakeRegKey:~9%"
call tools_string.bat replaceSubString "\\%_tmpMakeRegKey%" "\\" "\" _tmpMakeRegKey
set "_tmpMakeRegKey=%_tmpMakeRegKey:~1%\\"
call set "%~2=%%_tmpMakeRegKey:\%~nx1\\=%%"
goto :eof

:End
@if defined _Stack @for %%a in ( 1 "%~nx0" "%0" ) do @if {"%%~a"}=={"%_Stack%"} @echo [----- %~nx0] commandLine: %0 %* & @echo.