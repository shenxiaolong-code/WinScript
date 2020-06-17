@echo off
::rem : for python3.0, x86 and x64 all need to do below config

echo.
echo install pykd python plugin.

echo.
echo installed python version in current system:
where python.exe

echo.
for /f "usebackq tokens=*" %%i in ( ` where python.exe ` ) do call :install.parsePythonPath  "%%i"

echo.
echo install pykd plugin in all python version complete!
goto :END

:install.parsePythonPath
if not {"%~1"}=={""} call :install.tryPythonPath "%~dp1"
goto :eof

:install.tryPythonPath
echo commandline : %*
if exist "%~f1" (
call :install.pykd "%~f1"
) else (
echo python path[%~1] doesn't exist.
)
goto :eof

:install.pykd
cd /d "%~f1Scripts"
echo install python pykd plugin in path : %~f1
pip.exe install pykd
echo install pykd in path[%~f1] complete.
echo.
goto :eof

:END
pause
