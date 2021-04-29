@if {"%_Echo%"}=={"1"} ( @echo on ) else ( @echo off )
@echo %~f0 %*
@where tools_vs.bat 1>nul 2>nul || @set path=%~dp0..\..;%path%
call tools_vs.bat vsInstallPath 2017 tmpVsSrc
for /f "usebackq tokens=*" %%i in ( ` dir/b "%tmpVsSrc%\VC\Tools\MSVC" ` ) do set "tmpVsSrc=%tmpVsSrc%\VC\Tools\MSVC\%%i"
echo local visual studio path : %tmpVsSrc%
>"%temp%\vsInstallDir.txt" set /p=aS ${/v:VsSrc} %tmpVsSrc%