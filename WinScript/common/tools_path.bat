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
echo test call :FindFirstFileInDir "ReadMe.txt" "C:\Users\shen-48" %1

echo.
echo test call :ToShortPath "%~f0" %1
call :ToShortPath "%~f0" %1

echo.
echo test call :ToNormalPath TestVar
set "TestVar=C:\Program Files (x86)\Windows Kits\10\Debuggers\x86\sym\..\src\..\.."
echo before : TestVar=%TestVar%
call :ToNormalPath TestVar
echo after  : TestVar=%TestVar%
if not {"%TestVar%"}=={"C:\Program Files (x86)\Windows Kits\10\Debuggers"} call tools_message.bat warningMsg "test ToNormalPath fails" "~f0" ToNormalPathMark1

echo.
echo test call :FindAppPathInReg "HKEY_CURRENT_USER\Software\Classes\Applications\windbg.exe\shell\open\command" appPath ".."
call :FindAppPathInReg "HKEY_CURRENT_USER\Software\Classes\Applications\windbg.exe\shell\open\command" appPath ".."
echo appPath=%appPath%

echo.
echo test call :FindAppPathInEnv cmd.exe _cmdPath ".."
call :FindAppPathInEnv cmd.exe _cmdPath ".."
echo _cmdPath=%_cmdPath%

echo.
echo test call :FindAppPathinDisk "Everything.exe" _EverythingPath ".."
call :FindAppPathinDisk "Everything.exe" _EverythingPath ".."
echo _EverythingPath=%_EverythingPath%

echo.
echo test call :FindAppPathByExt ".txt" _txtFile
call :FindAppPathByExt ".txt" _txtFile
echo _txtFile=%_txtFile%

echo.
echo test call :FindFileVersion "C:\Windows\System32\cmd.exe" cmdVer
call tools_path.bat FindFileVersion "C:\Windows\System32\cmd.exe" cmdVer
echo cmdVer=%cmdVer%

echo.
echo test call :isFileExist "%~f0" _bFExist
call :isFileExist "%~f0" _bFExist
if not {"%_bFExist%"}=={"1"} call tools_message.bat warningMsg "test isFileExist fails" "~f0" Test000

echo.
echo test call :isFolderExist "%~dp0" bExist
call :isFolderExist "%~dp0" bExist
if not {"%bExist%"}=={"1"} call tools_message.bat warningMsg "test isFolderExist fails" "~f0" Test001

echo.
echo test call :isPathExist "%~dp0"
call :isPathExist "%~dp0"
if not {"%errorlevel%"}=={"1"} call tools_message.bat warningMsg "test isPathExist fails" "~f0" Test001

echo.
set par="%cd%"
echo test call :getFolderName %par%
call :getFolderName %par%
echo.
set par="%cd%\"
echo test call :getFolderName %par%
call :getFolderName %par%
echo.
set par="%cd%\abc.exe"
echo test call :getFolderName %par%
call :getFolderName %par%

echo.
echo test call :getFolderPath "%~fs0" sDir1
call :getFolderPath "%~fs0" sDir1
echo test call :getFolderPath "%~dp0" sDir2
call :getFolderPath "%~fs0" sDir2
if not {"%sDir1%"}=={"%sDir2%"} call tools_message.bat warningMsg "test getFolderPath fails" "~f0" Test003


echo.
set "filePath_before=%~dpn0.BAT"
echo test call :getCaseSensitiveePath filePath_after "%filePath_before%"
echo [before getCaseSensitiveePath] %filePath_before%
call :getCaseSensitiveePath filePath_after "%filePath_before%"
echo [after getCaseSensitiveePath] %filePath_after%
if {"%filePath_before%"}=={"%filePath_after%"} call tools_message.bat warningMsg "test getCaseSensitiveePath fails" "~f0" Test004

echo.
set par="%cd%"
echo test call :getParentFolderPath %par%
call :getParentFolderPath %par%
echo.
set par="%cd%\"
echo test call :getParentFolderPath %par%
call :getParentFolderPath %par%
echo.
set par="%cd%\abc.exe"
echo test call :getParentFolderPath %par%
call :getParentFolderPath %par%

echo.
echo test call :CreateFolderShortcut "%tmp%\testCreateFolderShortcut" "%~dp0"
call :CreateFolderShortcut "%tmp%\testCreateFolderShortcut" "%~dp0"


goto :eof



::[DOS_API:checkOutputPath]check whether output directory exists. if not exist , just create it to simply general script code.
::call e.g  : call :checkOutputPath "C:\tem\myFile.dat"
:checkOutputPath
@if defined _Stack @for %%a in ( 1 "%~nx0" "%0" ) do @if {"%%~a"}=={"%_Stack%"} @echo [      %~nx0] commandLine: %0 %*
call :getFolderPath "%~f1" _tmpFolderPath
if not exist "%_tmpFolderPath%" md "%_tmpFolderPath%\"
if not exist "%_tmpFolderPath%\" call tools_message.bat errorMsg "fails to create folder[%~dp0]"
goto :eof

::[DOS_API:FindAppPathInReg]find application path in register by specified reg path
::usage      : call :FindAppPathInReg "regPath" appPath "optionalRelatePath"
::call e.g   : call :FindAppPathInReg "HKEY_CURRENT_USER\Software\Classes\Applications\windbg.exe\shell\open\command" appPath ".."
::result e.g : set appPath=C:\PROGRA~1\DEBUGG~1
:FindAppPathInReg
@if defined _Stack @for %%a in ( 1 "%~nx0" "%0" ) do @if {"%%~a"}=={"%_Stack%"} @echo [      %~nx0] commandLine: %0 %*
call tools_error.bat checkParamCount 2 %*
set rp=%~3
if not defined rp set rp=.
for /f "usebackq tokens=*" %%i in ( ` reg query "%~1" 2^>nul ^| find /i "(Default)" ` ) do call :FindAppPathInReg.parse "%~2" "%rp%" %%~i
goto :eof

::[DOS_API:FindAppPathInEnv]lookup one file's full path by file name in path environment variables.
::usage     : call :FindAppPathInEnv FileName VarName "optionalRelatePath"
::Note      : this cmd is not executed by where command, it searchs PATH environment and lookup this file, so it needs full name(with extension)
::call e.g  : call :FindAppPathInEnv windbg.exe TestVar "..\lib"
::FileName  : file name, if it include blank, it must be indluce with ""
::VarName   : if find this file full path, set this file full path to this VarName
::note      : file name include extension name,it doesn't like where command,where needn't extension name
::result e.g: set TestVar="C:\Program Files (x86)\Windows Kits\10\Debuggers"
:FindAppPathInEnv
@if defined _Stack @for %%a in ( 1 "%~nx0" "%0" ) do @if {"%%~a"}=={"%_Stack%"} @echo [      %~nx0] commandLine: %0 %*
call tools_error.bat checkParamCount 2 %*
call tools_message.bat enableDebugMsg "%~0" "[%~0]%~dp$PATH:1"
if {"%~dp$PATH:1"}=={""} call tools_message.bat errorMsg "can't find %~1 in environment variable 'path'."
call set "%~2=%~dp$PATH:1%~3"
call tools_path.bat ToShortPath "%~2"
goto :eof

::[DOS_API:FindAppPathinDisk]find first application path by tool search.exe
::usage      : call :FindAppPathinDisk "appName" appPath "optionalRelatePath"
::call e.g   : call :FindAppPathinDisk "stig.exe" appPath ".."
::result e.g : set appPath=C:\PROGRA~1\DEBUGG~1
:FindAppPathinDisk
@if defined _Stack @for %%a in ( 1 "%~nx0" "%0" ) do @if {"%%~a"}=={"%_Stack%"} @echo [      %~nx0] commandLine: %0 %*
call tools_error.bat checkParamCount 2 %*
where search.exe 1>nul 2>nul || set path=%~dp0bin;%path%;
set _tmpPath=
for /f "usebackq tokens=*" %%i in ( ` search.exe "%~1" ` ) do call :FindAppPathinDisk.parseSearchLine "%~1" "%%~i"
if not exist "%_tmpPath%" call tools_message.bat errorMsg "can't find %~1 by search.exe tool."
call :FindAppPathinDisk.appendRelPath "%~2" "%_tmpPath%" %~3
goto :eof

::[DOS_API:FindAppPathByExt]find the default execute file path by the file extension name. e.g. .sln file
::usage      : call :FindAppPathByExt extNameOrFileFullPath  openExePath
::             call :FindAppPathByExt ".sln"  openExePath
::             call :FindAppPathByExt "E:\work\sourceCode\JabberGit\products\jabber-win\src\jabber-client\JabberClient.sln"  openExePath
::result e.g : set "openExePath=C:\Program Files (x86)\Common Files\Microsoft Shared\MSEnv\VSLauncher.exe"
:FindAppPathByExt
@if defined _Stack @for %%a in ( 1 "%~nx0" "%0" ) do @if {"%%~a"}=={"%_Stack%"} @echo [      %~nx0] commandLine: %0 %*
call tools_error.bat checkParamCount 2 %*
set "%~2="
set "_tmpExtName=%~x1"
if not defined _tmpExtName call tools_message.bat errMsg "empty extension is not allowned"
call tools_message.bat enableDebugMsg "%~0" "echo _tmpExtName=%_tmpExtName%"
:: .sln=VisualStudio.Launcher.sln
for /f "usebackq tokens=*" %%i in ( ` assoc %_tmpExtName% ` ) do set "accoc%%i"
if not defined accoc%_tmpExtName%  goto :eof
call set "_tmpFileType=%%accoc%_tmpExtName%%%"
:: VisualStudio.Launcher.sln="C:\Program Files (x86)\Common Files\Microsoft Shared\MSEnv\VSLauncher.exe" "%1"
for /f usebackq^ tokens^=2^ delims^=^" %%a in ( ` ftype %_tmpFileType% ` ) do set "%~2=%%~fsa"
call tools_message.bat enableDebugMsg "%~0" "call echo %~2=%%%~2%%"
goto :eof

::[DOS_API:FindFileVersion]get one exe module version by wmic
::usage      : call :FindFileVersion modPath outputVal
::call e.g   : call :FindFileVersion "C:\myApp\sym\gdi32.dll" myVer
::result e.g : set myVer=12.5.0.22981
:FindFileVersion
@if defined _Stack @for %%a in ( 1 "%~nx0" "%0" ) do @if {"%%~a"}=={"%_Stack%"} @echo [      %~nx0] commandLine: %0 %*
call tools_error.bat checkFileExist "%~fs1"
set %~2=
set _tmpOriPath=%~fs1
for /f "usebackq tokens=*" %%a in ( ` wmic datafile where name^='%_tmpOriPath:\=\\%' get version ^| more +1 ` ) do if not defined %~2 call tools_string.bat TrimString "%%a" %~2
call tools_message.bat enableDebugMsg "%~0" "%~2="%%%~2%%"
goto :eof

::[DOS_API:getCaseSensitiveePath] get case sensitive path. in some similiar-linux application, the path is case sensitive.
::            if input is path insensitive, the application can't find path.  e.g. git.exe
::call e.g  : call :getCaseSensitiveePath outputVar pathWithoutCaseSensitive
::            call :getCaseSensitiveePath fPath "D:\sourcecode\jabbergit128\products\jabber-win\src\wcldll\src\wtwclatl.h"
::result e.g: set set fPath=D:\sourceCode\jabberGit128\products\jabber-win\src\wclDll\src\wtwclatl.h
:getCaseSensitiveePath
@if defined _Stack @for %%a in ( 1 "%~nx0" "%0" ) do @if {"%%~a"}=={"%_Stack%"} @echo [      %~nx0] commandLine: %0 %*
if not exist "%~fs2" goto :eof
for /f "usebackq tokens=4" %%i in ( ` fsutil file queryfileid "%~fs2" ` ) do set fileID=%%i
if defined _Debug echo fileID=%fileID%
for /f "usebackq tokens=*" %%i in ( ` fsutil file queryFileNameById %~d2 %fileID% ` ) do set "filePath=%%i"
if defined _Debug echo filePath=%filePath%
set "%~1=%filePath:*\\?\=%"
goto :eof

::[DOS_API:noBashPath]convert one path with bash char into path without bash. if input has not bash, keep original path
::usage         : call tools_path.bat noBashPath myPath
::outVar        : input/output var
::example       : set myPath=C:\temp dir\
::              : call tools_path.bat noBashPath "myPath"
::              : myPath=%myPath%   //myPath=C:\temp dir
::example2      : set myPath2=C:\temp dir2
::              : call tools_path.bat noBashPath "myPath2"
::              : myPath=%myPath%   //myPath2=C:\temp dir2
:noBashPath
@if defined _Stack @for %%a in ( 1 "%~nx0" "%0" ) do @if {"%%~a"}=={"%_Stack%"} @echo [      %~nx0] commandLine: %0 %*
call tools_error.bat checkEmptyParam %*
call set "_noBashPath=%%%~1%%"
if {"%_noBashPath:~-1%"}=={"\"} set "%~1=%_noBashPath:~,-1%"
goto :eof

::[DOS_API:ToShortPath]convert one possible long path to short path
::call e.g   : set TestVar=C:\Program Files (x86)\Windows Kits\10\Debuggers\windbg.exe
::            call :ToShortPath TestVar
::result e.g : set TestVar=C:\PROGRA~1\DEBUGG~1\windbg.exe
::Note       : Not all path has short path. but path of x86 folder always has short path.
:ToShortPath
@if defined _Stack @for %%a in ( 1 "%~nx0" "%0" ) do @if {"%%~a"}=={"%_Stack%"} @echo [      %~nx0] commandLine: %0 %*
if {"%~1"}=={""} goto :eof
call set "_tmpToShortPathVal=%%%~1%%"
if {"%_tmpToShortPathVal%"}=={""} goto :eof
:: for /f "tokens=*"  %i in ( "%VS140COMNTOOLS%..\.." ) do echo "%~fsi"
for /f "tokens=*" %%i in ( "%_tmpToShortPathVal%" ) do set "%~1=%%~fsi"
rem for /f %%i in ( "D:\work\shenxiaolong\core\WinScript\common\tools_path.bat " ) do set "%~1=%%~fsi"
goto :eof

::[DOS_API:ShowShortPath] show short path of one possible long path to 
::call e.g   : call :ShowShortPath "C:\Program Files (x86)\Windows Kits\10\Debuggers\windbg.exe"
::result e.g : C:\PROGRA~1\DEBUGG~1\windbg.exe
::Note       : Not all path has short path. but path of x86 folder always has short path.
:ShowShortPath
@if defined _Stack @for %%a in ( 1 "%~nx0" "%0" ) do @if {"%%~a"}=={"%_Stack%"} @echo [      %~nx0] commandLine: %0 %*
if {"%~1"}=={""} goto :eof
call set "_tmpShowShortPathVal=%~1"
if {"%_tmpShowShortPathVal%"}=={""} goto :eof
for /f "tokens=*" %%i in ( "%_tmpShowShortPathVal%" ) do echo "%%~fsi"
goto :eof


::[DOS_API:ToNormalPath]convert one path include relative path (..) to one path without relative path (..)
::call e.g   : set TestVar=C:\Program Files (x86)\Windows Kits\10\Debuggers\x86\sym\..\src\..\..
::            call :ToNormalPath TestVar
::result e.g : set TestVar=C:\Program Files (x86)\Windows Kits\10\Debuggers
:ToNormalPath
@if defined _Stack @for %%a in ( 1 "%~nx0" "%0" ) do @if {"%%~a"}=={"%_Stack%"} @echo [      %~nx0] commandLine: %0 %*
if {"%~1"}=={""} goto :eof
call set "_tmpToNormalPath=%%%~1%%"
for %%I in ("%_tmpToNormalPath%") do set "_tmpNewPath=%%~fI"
::the real path might not exist, so can't use cd /d "%~f1" & set %~1=%cd%
call set "%~1=%_tmpNewPath%"
goto :eof

::[DOS_API:removeEscapeCharInPath] remove the escape/special chars in a path
::call e.g   : call :removeEscapeCharInPath "C:\temp&fold\abd*ddd.txt" TestVar
::result e.g : set TestVar=C:\temp_fold\abd_ddd.txt
:removeEscapeCharInPath
@if defined _Stack @for %%a in ( 1 "%~nx0" "%0" ) do @if {"%%~a"}=={"%_Stack%"} @echo [      %~nx0] commandLine: %0 %*
for /f "delims=()[]{}^=;!'+,`~(&()* tokens=1*" %%a  in ("%~1") do if {"%%~b"}=={""} set "%~2=%%~a" && goto :eof
set %~2=
for /f "delims=()[]{}^=;!'+,`~(&()* tokens=1,2*" %%a  in ("%~1") do call :removeEscapeCharInPath.parse %~2 "%%~a" "%%~b" "%%~c"
goto :eof

::[DOS_API:getFolderPath]get dir by one path (folder or file)
::call e.g  : call :getFolderPath TestPath dir
::            call :getFolderPath D:\work\shenxiaolong\core\WinScript\common\tools_path.bat    dir
::            call :getFolderPath D:\work\shenxiaolong\core\WinScript\common\                  dir
::            call :getFolderPath D:\work\shenxiaolong\core\WinScript\common                   dir
::result e.g: set dir=D:\work\shenxiaolong\core\WinScript\common
:getFolderPath
@if defined _Stack @for %%a in ( 1 "%~nx0" "%0" ) do @if {"%%~a"}=={"%_Stack%"} @echo [      %~nx0] commandLine: %0 %*
if {"%~2"}=={""} call tools_message.bat errorMsg "parameter is not enough."
if      exist "%~1" call :getFolderPath.exist      "%~1" "%~2"
if not  exist "%~1" call :getFolderPath.NotExist   "%~1" "%~2"
call :ToNormalPath "%%%~2%%" _tmpNormalPath
call :noBashPath "%~2"
goto :eof

::[DOS_API:getFolderName]get folder name by one path
::call e.g  : set TestPath=C:\ProgramFiles\Xoreax\
::			  call :getFolderName TestPath foldName
::result e.g: set foldName=Xoreax
:getFolderName
@if defined _Stack @for %%a in ( 1 "%~nx0" "%0" ) do @if {"%%~a"}=={"%_Stack%"} @echo [      %~nx0] commandLine: %0 %*
if {"%~2"}=={""} goto :eof
call :getFolderPath "%~fs1" __tmpDir
for /f %%i in ( "%__tmpDir%" ) do set "%~2=%%~ni"
goto :eof

::[DOS_API:getParentFolderPath]get folder name by one path
::call e.g  : set TestPath=C:\ProgramFiles\Xoreax\
::			  call :getParentFolderPath TestPath upperPath
::result e.g: set upperPath=C:\ProgramFiles
:getParentFolderPath
@if defined _Stack @for %%a in ( 1 "%~nx0" "%0" ) do @if {"%%~a"}=={"%_Stack%"} @echo [      %~nx0] commandLine: %0 %*
if {"%~2"}=={""} goto :eof
call :getFolderPath "%~fs1" _tmpCurDir
call :getFolderPath "%_tmpCurDir%\.." "%~2"
goto :eof

::[DOS_API:FindFirstFileInDir]find first file in specified directory and its sub-directory
::usage     : call :FindFirstFileInDir FileFullName dir
::call e.g. : call :FindFirstFileInDir myFile.txt "C:\temp\"
:FindFirstFileInDir
@if defined _Stack @for %%a in ( 1 "%~nx0" "%0" ) do @if {"%%~a"}=={"%_Stack%"} @echo [      %~nx0] commandLine: %0 %*
set tmpFindFirstFileInDir=%temp%\%random%.txt
dir/s/b "%~dp2%~1" 1> %tmpFindFirstFileInDir% 2>nul
if not {"%errorlevel%"}=={"0"} (
echo Not found %~1 files in directory "%~2" and its subdirectory
del /f %tmpFindFirstFileInDir%
goto :eof
)
call tools_txtFile.bat GetFileLineAccount %tmpFindFirstFileInDir% FileNumFindFirstFileInDir
if %FileNumFindFirstFileInDir% GTR 1 (
echo Found %FileNumFindFirstFileInDir% files in directory "%~2". Use first one.
dir/s/b "%~dp2%~1"
echo.
)
call tools_txtFile.bat FindLineXOfFile 1 %tmpFindFirstFileInDir% FileLineFindFirstFileInDir
if {%~3}=={} (
echo first file[%~1] path in directory[%~2] : %FileLineFindFirstFileInDir%
) else (
set %~3=%FileLineFindFirstFileInDir%
)
del /f %tmpFindFirstFileInDir%
goto :eof

::[DOS_API:isFileExist]enter specified path, because cd , pushd can't change driver
::call e.g  : call :isFileExist E:\temp\mydir.txt   bRet      //file E:\temp\mydir.txt exists
::result e.g: %bRet%=1
:isFileExist
@if defined _Stack @for %%a in ( 1 "%~nx0" "%0" ) do @if {"%%~a"}=={"%_Stack%"} @echo [      %~nx0] commandLine: %0 %*
rem %~a1 can't work correctly in some DOS version
rem if the path length is bigger than 256 chars, below command result might be wrong, so always to return 1
rem TODO: use forfiles.exe to check
if not exist "%~fs1"  call set "%~2=0" & goto :eof
set "_tmpFilePath=%~fs1"
if {"%_tmpFilePath:~-1%"}=={"\"} call set "%~2=0" & goto :eof
if not {"%_tmpFilePath:~256%"}=={""} call set "%~2=1" & goto :eof

set "_tmpAttrib=%~a1"
call tools_message.bat enableDebugMsg "%~0" "attrib of '%~1' is %_tmpAttrib% in %0 , test char is '%_tmpAttrib:~0,1%'"
if {"%_tmpAttrib:~0,1%"}=={"d"} (
call tools_message.bat enableDebugMsg "%~0" "'%~1' is directory in %0 , return 0"
set _tmpisFileExist=0
) else (
call tools_message.bat enableDebugMsg "%~0" "'%~1' is file in %0 , return 1"
set _tmpisFileExist=1
)
if not {"%~2"}=={""} call set "%~2=%_tmpisFileExist%"
exit /b %_tmpisFileExist%
goto :eof

::[DOS_API:isFolderExist]enter specified path, because cd , pushd can't change driver
::call e.g  : call :isFolderExist E:\temp\mydir   bRet     //file E:\temp\mydir exists
::result e.g: %bRet%=0
:isFolderExist
@if defined _Stack @for %%a in ( 1 "%~nx0" "%0" ) do @if {"%%~a"}=={"%_Stack%"} @echo [      %~nx0] commandLine: %0 %*
rem %~a1 can't work correctly in some DOS version
if not exist "%~s1" set "%~2=0" & goto :eof
set "tmpFolderPath=%~1"
if not {"%tmpFolderPath:~-1%"}=={"\"} set "tmpFolderPath=%tmpFolderPath%\"
if exist "%tmpFolderPath%" (
call tools_message.bat enableDebugMsg "%~0" "'%~1' is directory in %0 , return 1"
set _tmpisFolderExist=1
) else (
call tools_message.bat enableDebugMsg "%~0" "'%~1' is file in %0 , return 0"
set _tmpisFolderExist=0
)
if not {"%~2"}=={""} call set "%~2=%_tmpisFolderExist%"
exit /b %_tmpisFolderExist%
goto :eof

::[DOS_API:isPathExist]enter specified path, because cd , pushd can't change driver
::call e.g  : call :isPathExist E:\temp\mydir       //file E:\temp\mydir exists
::result e.g: %errorlevel%=1
:isPathExist
@if defined _Stack @for %%a in ( 1 "%~nx0" "%0" ) do @if {"%%~a"}=={"%_Stack%"} @echo [      %~nx0] commandLine: %0 %*
if exist "%~fs1" (
call tools_message.bat enableDebugMsg "%~0" "'%~1' exist in %0 , return 1"
set _tmpisPathExist=1
) else (
call tools_message.bat enableDebugMsg "%~0" "'%~1' do NOT exist in %0 , return 0"
set _tmpisPathExist=0
)
if not {"%~2"}=={""} call set %~2=%_tmpisPathExist%
exit /b %_tmpisPathExist%
goto :eof

::[DOS_API:getPathAttrib]check one path attribute : NotExist , folder , file, error
::call e.g  : call :getPathAttrib path outputVal
::            call :getPathAttrib E:\temp\mydir\  enumAttrib
:getPathAttrib
@if defined _Stack @for %%a in ( 1 "%~nx0" "%0" ) do @if {"%%~a"}=={"%_Stack%"} @echo [      %~nx0] commandLine: %0 %*
set %~2=error
if not exist "%~1" set "%~2=NotExist" & goto :eof
set _tmpAttrib=
for /f "tokens=*" %%i in ( "work" ) do set "_tmpAttrib=%%~ai"
if not defined _tmpAttrib goto :eof
call tools_message.bat enableDebugMsg "%~0" "'%~1' attribute : %_tmpAttrib%"
if not {"%_tmpAttrib:~0,1%"}=={"d"}  set %~2=folder
if     {"%_tmpAttrib:~0,1%"}=={"d"}  set %~2=file
goto :eof

::[DOS_API:showPathInExplorer]open folder by explorer
::call e.g  : call :showPathInExplorer E:\temp\mydir
::            call :showPathInExplorer E:\temp\mydir\
:showPathInExplorer
@if defined _Stack @for %%a in ( 1 "%~nx0" "%0" ) do @if {"%%~a"}=={"%_Stack%"} @echo [      %~nx0] commandLine: %0 %*
start explorer.exe /select ,"%~f1"
goto :eof

::[DOS_API:CreateFolderShortcut] create a shortcut for one path
::call e.g  : call :CreateFolderShortcut "E:\temp\shortcutName" "D:\work\realTargetPath"
::result e.g: E:\temp\shortcutName <=> D:\work\realTargetPath
:CreateFolderShortcut
@if defined _Stack @for %%a in ( 1 "%~nx0" "%0" ) do @if {"%%~a"}=={"%_Stack%"} @echo [      %~nx0] commandLine: %0 %*
if {%2}=={}  call tools_message.bat popMsg "parameter(s) is(are) empty"
if not exist "%~2" (
call colorTxt.bat cyan_L "source path %~2 is not existing."
pause
goto :eof
)

if exist "%~1" (
call colorTxt.bat cyan_L "target %~1 is existing, please delete it and try again"
echo.
pause
goto :eof
)

mklink /d "%~f1" "%~f2"
if not exist "%~1" (
echo fails to create shortcut[%~1], please run script with administrator privilege.
pause
)

goto :eof

:: *************************************************** inner implement**************************************************************************
:removeEscapeCharInPath.parse
@if defined _Stack @for %%a in ( 1 "%~nx0" "%0" ) do @if {"%%~a"}=={"%_Stack%"} @echo [      %~nx0] commandLine: %0 %*
if     {"%~4"}=={""}   set "%~1=%~2_%~3" && goto :eof
if not {"%~4"}=={""}   for /f "delims=()[]{}^=;!'+,`~(&()* tokens=1*" %%a  in ("%~4") do call :removeEscapeCharInPath.parse %~1 "%~2_%~3" "%%~a" "%%~b"
goto :eof

:getFolderPath.exist
@if defined _Stack @for %%a in ( 1 "%~nx0" "%0" ) do @if {"%%~a"}=={"%_Stack%"} @echo [      %~nx0] commandLine: %0 %*
if {"%~2"}=={""} call tools_message.bat errorMsg "parameter is not enough."
call :isFileExist "%~fs1" _tmpisFile
if      {"%_tmpisFile%"}=={"1"} call set "%~2=%~dp1"
if not  {"%_tmpisFile%"}=={"1"} call set "%~2=%~1"
goto :eof

:getFolderPath.NotExist
@if defined _Stack @for %%a in ( 1 "%~nx0" "%0" ) do @if {"%%~a"}=={"%_Stack%"} @echo [      %~nx0] commandLine: %0 %*
if {"%~2"}=={""} call tools_message.bat errorMsg "parameter is not enough."
set "_tmpNotExistPath=%~1"
if      {"%_tmpNotExistPath:~-1%"}=={"\"} set "%~2=%~1"
if not  {"%_tmpNotExistPath:~-1%"}=={"\"} set "%~2=%~dp1"
goto :eof

:FindAppPathinDisk.parseSearchLine
@if defined _Stack @for %%a in ( 1 "%~nx0" "%0" ) do @if {"%%~a"}=={"%_Stack%"} @echo [      %~nx0] commandLine: %0 %*
if defined _tmpPath goto :eof
if {"%~nx2"}=={"%~1"} set "_tmpPath=%~fs2"
goto :eof

:FindAppPathinDisk.appendRelPath
@if defined _Stack @for %%a in ( 1 "%~nx0" "%0" ) do @if {"%%~a"}=={"%_Stack%"} @echo [      %~nx0] commandLine: %0 %*
set rp=%~3
if not defined rp set rp=.
call set "%~1=%~dp2%rp%"
call tools_path.bat ToShortPath "%~1"
goto :eof

:FindFileVersion.trim
@if defined _Stack @for %%a in ( 1 "%~nx0" "%0" ) do @if {"%%~a"}=={"%_Stack%"} @echo [      %~nx0] commandLine: %0 %*
set %~1=%~2
goto :eof

:FindAppPathInReg.parse
@if defined _Stack @for %%a in ( 1 "%~nx0" "%0" ) do @if {"%%~a"}=={"%_Stack%"} @echo [      %~nx0] commandLine: %0 %*
if {"%~5"}=={""} call tools_message.bat errorMsg "No path is defined in FindAppPath."
set %~1=%~dp5%~2
call tools_path.bat ToShortPath "%~1"
call tools_message.bat enableDebugMsg "%~0" "set %~1=%%%~1%%"
goto :eof

:End
@if defined _Stack @for %%a in ( 1 "%~nx0" "%0" ) do @if {"%%~a"}=={"%_Stack%"} @echo [----- %~nx0] commandLine: %0 %* & @echo.