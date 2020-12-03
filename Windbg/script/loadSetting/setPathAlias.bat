@if {"%_Echo%"}=={"1"} ( @echo on ) else ( @echo off )
echo calling %~f0
rem set _Debug=1
if defined _Debug (
cd /d "%~dp0"
rem copy test context to below file to simple the test procedure.
rem type D:\work\shenxiaolong\core\WinScript\Windbg\script\test\tt.xt | clip
echo.
powershell Get-Clipboard
echo.
)

set dbgFile=%temp%\%~n0.dbg
call :parseClip
call :processNatvisPath
call :checkTargetPath

echo.
type "%dbgFile%" | find /i "aS "
echo.
goto :END

:checkTargetPath
rem for live-debug, there is not target path ourput for windbg command "||"
if defined targetFullPath   goto :eof
if defined exeFolderPath    call :processLine.target.add "%exeFolderPath%\%exeModuleName%.exe"
if defined targetFullPath   goto :eof
if defined dumpFolderPath   call :processLine.target.add "%dumpFolderPath%\%dumpModuleName%"

if defined _Debug echo targetFullPath=%targetFolderPath%
goto :eof

:processNatvisPath
call "%~dps0..\..\tools_vs.bat" vsInstallPath newest newestVsPath
if defined _Debug echo newestVsPath=%newestVsPath%
if defined newestVsPath     call :processNatvisPath.add  "%newestVsPath%\Common7\Packages\Debugger\Visualizers"
goto :eof

:processNatvisPath.add
if defined natvisPath goto :eof
set natvisPath=%~fs1
call :addWindbgVariable natvisPath
@goto :eof

:parseClip
echo .echo [%date% %time%] loading alais from '%dbgFile%' > "%dbgFile%"
for /f "tokens=*" %%i in ('powershell Get-Clipboard ^| find /i "examine	name:"')						do call :processLine.image "%%i"
for /f "tokens=*" %%i in ('powershell Get-Clipboard ^| find /i "attach	name:"')						do call :processLine.image "%%i"
for /f "tokens=*" %%i in ('powershell Get-Clipboard ^| find /i "dump: "') 								do call :processLine.target "%%i"
for /f "tokens=*" %%i in ('powershell Get-Clipboard ^| find /i "command line: "') 						do call :processLine.commandLine %%i
::for /f delims^=^"^ tokens^=^2^,^4^,^6 %%i in ('powershell Get-Clipboard ^| find /i "command line: "') 	do call :processLine.commandLine "%%~i" "%%~j" "%%~k"
goto :eof

:processLine.image
set "_line=%~1"
set "_line=%_line:*name: =%"
if defined _Debug echo %0 : _line="%_line%"
call :processLine.image.add  "%_line%"
goto :eof

:processLine.image.add
if defined exePathDefined goto :eof
@set "tmpDir=%~dps1"
set exeFolderPath=%tmpDir:~0,-1%
call :addWindbgVariable exeFolderPath
set exeModuleName=%~n1
call :addWindbgVariable exeModuleName
set "exePathDefined=%~f1"
@goto :eof

:processLine.target
if defined targetModuleName goto :eof
set "_line=%~1"
set "_line=%_line:*: =%"
if defined _Debug echo %0 : _line=%_line%
call :processLine.target.add  "%_line%"
goto :eof

:processLine.target.add
if defined targetFolderPath goto :eof
set "targetFullPath=%~f1"
call :addWindbgVariable targetFullPath
@set "tmpDir=%~dp1"
set targetFolderPath=%tmpDir:~0,-1%
call :addWindbgVariable targetFolderPath
set targetModuleName=%~nx1
call :addWindbgVariable targetModuleName
@goto :eof

:processLine.commandLine
if defined _Debug echo %0 : %*
set windbgCmdLine=%*
call :processLine.commandLine.onePath "%windbgCmdLine:"=" & call :processLine.commandLine.onePath "%"
goto :eof

:processLine.commandLine.onePath
if not exist "%~1" goto :eof
rem echo %0 : %*
set "lowerFileName=%~nx1"
set "lowerExtName=%~x1"
call :toLower  lowerFileName
call :toLower  lowerExtName
set "fileFolder=%~dp1"
set "fileFolder=%fileFolder:~0,-1%"
set "fileName=%~nx1"
if {"%lowerFileName%"}=={"windbg.exe"}   call :processLine.commandLine.add.windbgPath      "%fileFolder%"    "%fileName%"                                  
if {"%lowerExtName%"}=={".log"}          call :processLine.commandLine.add.logFullPath     "%fileFolder%"    "%fileName%"                                  
if {"%lowerExtName%"}=={".dmp"}          call :processLine.commandLine.add.dumpPath        "%fileFolder%"    "%fileName%"                                  
if {"%lowerExtName%"}=={".exe"} if not  {"%lowerFileName%"}=={"windbg.exe"}    call :processLine.image.add  "%fileFolder%\%fileName%"   
goto :eof

:processLine.commandLine.add.windbgPath
if defined windbgFolderPath goto :eof
set windbgFolderPath=%~s1
call :addWindbgVariable windbgFolderPath
set windbgExeMode=%~n1
call :addWindbgVariable windbgExeMode
@goto :eof

:processLine.commandLine.add.dumpPath
if defined dumpFolderPath   goto :eof
set dumpFolderPath=%~s1
call :addWindbgVariable dumpFolderPath
set dumpModuleName=%~n2
call :addWindbgVariable dumpModuleName
@goto :eof

:processLine.commandLine.add.logFullPath
if defined logFullPath   goto :eof
set logFullPath=%~sf1\%~2
call :addWindbgVariable logFullPath
@goto :eof

::*************************************************************************
:addWindbgVariable
call set varVal=%%%~1%%
(
@set /p =aS ${/v:%~1} %varVal%;<nul
@echo.
) >> "%dbgFile%"
@goto :eof

:toLower
for %%a in ("A=a" "B=b" "C=c" "D=d" "E=e" "F=f" "G=g" "H=h" "I=i"
            "J=j" "K=k" "L=l" "M=m" "N=n" "O=o" "P=p" "Q=q" "R=r"
            "S=s" "T=t" "U=u" "V=v" "W=w" "X=x" "Y=y" "Z=z" "?=?"
            "?=?" "จน=จน") do (
    call set %~1=%%%~1:%%~a%%
)
goto :eof

:END
echo leave %~f0