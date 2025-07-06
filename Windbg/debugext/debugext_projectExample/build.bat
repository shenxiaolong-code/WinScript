::@set _Echo=1
cd /d "%~dp0"
rem call "%MS_VC_PATH%\VC\bin\vcvars32.bat"
if not defined VisualStudioVersion call %myWinScriptPath%\Windbg\tools_vs.bat loadEnvVs

nmake clean
nmake 


@echo.
pause