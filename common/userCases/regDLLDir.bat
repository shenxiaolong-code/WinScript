::ths script is used register/unregister all DLLs in one directory
::[example] register all dLL in dir C:\temp with quiet mode : regDLLDir.bat C:\temp 1 s
::[example] unregister all dLL in dir C:\temp : regDLLDir.bat C:\temp 0
::paratere %1 %2 is necessary, parameter %3 is optional

::@set _Echo=0
::set _Stack=%~nx0
@if {"%_Echo%"}=={"1"} ( @echo on ) else ( @echo off )
@if defined _Stack @for %%a in ( 1 "%~nx0" "%0" ) do @if {"%%~a"}=={"%_Stack%"} @echo. & @echo [+++++ %~nx0] commandLine: %0 %*
where "%~nx0" 1>nul 2>nul || set "path=%~dp0;%path%"

title [regDLLDir.bat] command %0 %*

set ret=0
set RegDir="%~1"
if not exist %RegDir% call "tools_message.bat popMsg" "Directroy %RegDir% dones't exist or is not directory" & goto ERR
if not {%2}=={1} if not {%2}=={0} call "tools_message.bat popMsg" "No.2 parameter is not correct, it must be 1 or 0 " & goto ERR

@echo DLLs in directory "%~dp1" :
dir/s/b/w "%~dp1*.dll"

pushd %RegDir%
for /f "usebackq tokens=*" %%i in (`dir/s/b`) do call "regDLL.bat" "%%i" 1 %3
popd

@echo.
if {%2}=={1} (
	@echo register all DLLs in directory "%~dp1" completed.
) else (
	@echo un-register all DLLs in directory "%~dp1" completed.
)
goto End

:ERR
set ret=1
goto End


:End
@if defined _Stack @for %%a in ( 1 "%~nx0" "%0" ) do @if {"%%~a"}=={"%_Stack%"} @echo [----- %~nx0] commandLine: %0 %* & @echo.
exit /b %ret%


