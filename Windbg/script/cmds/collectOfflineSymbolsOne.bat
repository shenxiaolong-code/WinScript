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
set manifestFile=%outFolder%\symchk_manifest.txt
call :parseClip
call :writeOneLine
goto :END

:generateOneLine
if not defined dllName          call :err dllName
if not defined Timestamp        call :err Timestamp
if not defined SizeOfImage      call :err SizeOfImage
if not defined age              call :err age
set line=%dllName%,%Timestamp%%SizeOfImage%,%age%
goto :eof

:writeOneLine
call :generateOneLine
echo.
if exist "%manifestFile%" for /f "usebackq tokens=*" %%i in ( ` type "%manifestFile%" ^| find /i "%line%" ` ) do set "_bExisted=%%~i"
if defined _bExisted echo '%_bExisted%' is existed. & goto :eof
echo %line% >> "%manifestFile%"
call :showOK
goto :eof

:showOK
echo.
if defined line (
echo sucessfully!
echo %line%
echo is added into : 
echo %outFolder%\symchk_manifest.txt
)
echo.
goto :eof

:err
@echo fails to parse %~1 .
goto :END

:parseClip
for /f "tokens=*" %%i in ('powershell Get-Clipboard ^| find /v "MATCH:" ^| find /i ".dll"')			    do call :processLine.dllName "%%i"
for /f "tokens=*" %%i in ('powershell Get-Clipboard ^| find /i "Timestamp:"') 						    do call :processLine.Timestamp %%i
for /f "tokens=*" %%i in ('powershell Get-Clipboard ^| find /i "SizeOfImage:"') 				        do call :processLine.SizeOfImage %%i
for /f "tokens=*" %%i in ('powershell Get-Clipboard ^| find /i "age:"') 								do call :processLine.age %%i
goto :eof

:processLine.dllName
set dllName=%~1
goto :eof

:processLine.Timestamp
set Timestamp=%~2
goto :eof

:processLine.SizeOfImage
set SizeOfImage=%~2
goto :eof

:processLine.age
set age=%~2
goto :eof


:END
echo leave %~f0