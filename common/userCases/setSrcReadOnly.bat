
::usage : call setSrcReadOnly.bat "c:\repo_root\some_dir\"

@if {"%_Echo%"}=={"1"} ( @echo on ) else ( @echo off )
set fileType=*.c,*.h,*.cpp,*.hpp,*.inl

rem ********************************************
call :setVar %*
if not exist "%srcPath%" (
call "%myCmd%" 0c "path '%srcPath%' doesn't exist."
echo.
call :showUsage
call :resetVar
goto :eof
)

rem ********************************************
call "%myCmd%" 0c "srcPath=%srcPath%"
ping -n 2 127.0.0.1 > nul

title set read only attrib[%OP%] for %fileType% in %srcPath%
pushd %srcPath%
for /f "usebackq" %%i in ( ` dir/s/b %fileType% ` ) do (
attrib %OP% %%i  && @echo [OK] attrib %OP% %%~nxi
)
popd
goto :eof
rem ********************************************

:setVar
where "%~nx0" 1>nul 2>nul || set "path=%~dp0;%path%"
where "%~nx0" > Nul 2>Nul && set myCmd=:colorShow
where "%~nx0" > Nul 2>Nul || set myCmd=:showMsg
if not {"%~1"}=={""} (
set srcPath=%~1
) else (
set srcPath=%cd%
)

if {"%~2"}=={"-"} (
set OP=-r
) else (
set OP=+r
)
goto :eof

:showUsage
call "%myCmd%" 0b usage:
call "%myCmd%" 0c "e.g. : setSrcReadOnly.bat . +"
call "%myCmd%" 0c "e.g. : setSrcReadOnly.bat C:\temp +"
call "%myCmd%" 0c "e.g. : setSrcReadOnly.bat . -"
call "%myCmd%" 0c "e.g. : setSrcReadOnly.bat C:\temp -"
goto :eof

:colorShow
call colorTxt.bat %~1 "%~2"
echo.
goto :eof

:showMsg
echo %~2
goto:eof

:resetVar
set srcPath=
set OP=
set myCmd=
ping -n 3 127.0.0.1 > nul
goto :eof