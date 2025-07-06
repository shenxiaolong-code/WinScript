::@set _Echo=1
::set _Stack=%~nx0
@if {"%_Echo%"}=={"1"} ( @echo on ) else ( @echo off )
@if defined _Stack @for %%a in ( 1 "%~nx0" "%0" ) do @if {"%%~a"}=={"%_Stack%"} @echo. & @echo [+++++ %~nx0] commandLine: %0 %*
@where colorTxt.bat 1>nul 2>nul || @set "path=%myWinScriptPath%\common;%path%"
:: @where %~nx0 1>nul 2>nul || @set "path=%cd%;%path%"
call colorTxt.bat -init

:: @echo %~nx0 %*
if     {"%~1"}=={""} call :usage
if not {"%~1"}=={""} call :impl
goto :END

:impl
@if defined _Stack @for %%a in ( 1 "%~nx0" "%0" ) do @if {"%%~a"}=={"%_Stack%"} @echo [      %~nx0] commandLine: %0 %*

goto :eof


:usage
@if defined _Stack @for %%a in ( 1 "%~nx0" "%0" ) do @if {"%%~a"}=={"%_Stack%"} @echo [      %~nx0] commandLine: %0 %*
echo.
call colorTxt.bat "{%green_L%}usage : {%red%}%~nx0 test file_path {%end%}{%br%}"
call colorTxt.bat "{%green_L%}e.g.    {%red%}%~nx0 10.79.36.57  xiaolongs@nvidia.com {%end%}{%br%}"
echo.
echo press any key to exit current script.
pause 1>nul
exit /b 1
goto :eof


:dumpInfo
@if defined _Stack @for %%a in ( 1 "%~nx0" "%0" ) do @if {"%%~a"}=={"%_Stack%"} @echo [      %~nx0] commandLine: %0 %*
set indent=
if defined _Stack set "indent=       "
call colorTxt.bat "{%green_L%}%indent%ip : {%red%}%ip% {%end%}{%br%}"
call colorTxt.bat "{%green_L%}%indent%name : {%red%}%username% {%end%}{%br%}"
goto :eof

:END
@if defined _Stack @for %%a in ( 1 "%~nx0" "%0" ) do @if {"%%~a"}=={"%_Stack%"} @echo [----- %~nx0] commandLine: %0 %* & @echo.
:: timeout /t 5