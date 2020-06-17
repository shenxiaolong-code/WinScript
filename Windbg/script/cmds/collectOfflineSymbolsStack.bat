@echo off
echo calling %~f0 %*
rem set _Debug=1
if defined _Debug (
cd /d "%~dp0"
rem type D:\work\shenxiaolong\core\WinScript\Windbg\script\test\tt.xt | clip
echo.
powershell Get-Clipboard
echo.
)

set "outFolder=%~dpn1"
if not exist "%outFolder%" md "%outFolder%\"
call :parseClip
type "%manifestFilter%"
call :generateManifestAll "%~fs1"
call :makeStackFilter
goto :END

:makeStackFilter
echo on
echo.
call "%~dp0..\..\collectOfflineSymbols\tools\tools_symFilter.bat" filterSpecficModules "%manifestFile%" "%manifestFilter%"
goto :eof

:generateManifestAll
::set NoCollectSymbolListMsg=disable
set manifestFileName=%~n1_manifest.txt
call "%~dp0..\..\collectOfflineSymbols\tools\tools_collectOfflineSymbols.bat" collectSymbolList "%~fs1"
if not exist "%manifestFile%" call :Err "fails to generate whole manifest file for %~nx1"
goto :eof

:Err
echo.
echo %~1
goto :END

:parseClip
for /f "tokens=*" %%i in ('powershell Get-Clipboard ^| find /i "unsigned int"')             do call :processLine.threadId %%i
for /f "delims=! tokens=1*" %%i in ('powershell Get-Clipboard ^| find /v "unsigned int"')   do call :processLine.oneLine %%i
goto :eof

:processLine.threadId
if defined _Debug echo %*
set manifestFilter=%outFolder%\symchk_stack_%~3.txt
if exist "%manifestFilter%" del /f/q "%manifestFilter%"
goto :eof

:processLine.oneLine
if defined _Debug echo %*
if not  {"%~3"}=={""} goto :eof
if      {"%~2"}=={""} goto :eof
if defined %~2 goto :eof
echo %~2 >> "%manifestFilter%"
set %~2=%~1
goto :eof


:END
echo leave %~f0