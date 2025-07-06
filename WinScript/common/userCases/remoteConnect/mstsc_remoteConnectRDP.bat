
::@set _Echo=1
::set _Stack=%~nx0
@if {"%_Echo%"}=={"1"} ( @echo on ) else ( @echo off )
@if defined _Stack @for %%a in ( 1 "%~nx0" "%0" ) do @if {"%%~a"}=={"%_Stack%"} @echo. & @echo [+++++ %~nx0] commandLine: %0 %*

call :connect_rdp_main %*
goto :END

:usage
@if defined _Stack @for %%a in ( 1 "%~nx0" "%0" ) do @if {"%%~a"}=={"%_Stack%"} @echo [      %~nx0] commandLine: %0 %*
echo.
echo usage : %~nx0 ip userName pwd
echo e.g.    %~nx0 10.79.36.57  xiaolosh abcdef
echo.
echo press any key to exit current script.
pause 1>nul    
goto :eof

:tc_usage
@if defined _Stack @for %%a in ( 1 "%~nx0" "%0" ) do @if {"%%~a"}=={"%_Stack%"} @echo [      %~nx0] commandLine: %0 %*
set "rdpPwdDef=%myLoginPwd%"
echo call %~fs0 do_connect 10.176.193.29 "%USERNAME%"
call %~fs0 do_connect 10.176.193.29 "%USERNAME%"
goto :eof

:: do_connect <rdp_ip> <userName> <password>
:do_connect
@if defined _Stack @for %%a in ( 1 "%~nx0" "%0" ) do @if {"%%~a"}=={"%_Stack%"} @echo [      %~nx0] commandLine: %0 %*
@echo %~nx0 %*
rem set rdp_ip=10.79.36.57
set "rdp_ip=%~1"
set "rdp_userName=%~2"
set "rdp_pwd=%~3"

if {"%rdp_userName%"} == {""}   set  "rdp_userName=%USERNAME%"
if {"%rdp_pwd%"}      == {""}   set  "rdp_pwd=%myLoginPwd%"

if {"%rdp_ip%"}       == {""}   call :error_handler "rdp_ip is missing."
if {"%rdp_userName%"} == {""}   call :error_handler "rdp_userName is missing."
if {"%rdp_pwd%"}      == {""}   call :error_handler "rdp_pwd is missing."

call :login_with_cmdkey
:: call :login_with_rdp_file
timeout /t 10
goto :eof

:: windows defender credential guard does not allow using saved credentials.
:: it will block the rdp file, need to enter credentials manually.
:login_with_rdp_file
@if defined _Stack @for %%a in ( 1 "%~nx0" "%0" ) do @if {"%%~a"}=={"%_Stack%"} @echo [      %~nx0] commandLine: %0 %*
set "rdp_file_path=%temp%\%rdp_ip%.rdp"
(
    echo full address:s:%rdp_ip%
    echo username:s:%rdp_userName%
    echo password:s:%rdp_pwd%
) > "%rdp_file_path%"
start /wait mstsc.exe "%rdp_file_path%"
rem if exist "%rdp_file_path%" del "%rdp_file_path%"
goto :eof

:dump_login_info
@if defined _Stack @for %%a in ( 1 "%~nx0" "%0" ) do @if {"%%~a"}=={"%_Stack%"} @echo [      %~nx0] commandLine: %0 %*
set indent=
if defined _Stack set "indent=       "
echo %indent%rdp_ip 	   : %rdp_ip%
echo %indent%rdp_userName  : %rdp_userName%
echo %indent%rdp_pwd       : ****
echo start cmdkey.exe /generic:%rdp_ip% /user:%rdp_userName% /pass:"****" ^&^& start /wait mstsc.exe /v %rdp_ip%
goto :eof

:cleanup_login_key
@if defined _Stack @for %%a in ( 1 "%~nx0" "%0" ) do @if {"%%~a"}=={"%_Stack%"} @echo [      %~nx0] commandLine: %0 %*
cmdkey /delete:%rdp_ip%
goto :eof

:login_with_cmdkey
@if defined _Stack @for %%a in ( 1 "%~nx0" "%0" ) do @if {"%%~a"}=={"%_Stack%"} @echo [      %~nx0] commandLine: %0 %*
:: if hello PIN is enabled, the default login mode is PIN. below command will fail. use login_with_rdp_file instead.
call :dump_login_info
start cmdkey.exe /generic:%rdp_ip% /user:%rdp_userName% /pass:"%rdp_pwd%" && start /wait mstsc.exe /v %rdp_ip%
call :cleanup_login_key
goto :eof

:error_handler
@if defined _Stack @for %%a in ( 1 "%~nx0" "%0" ) do @if {"%%~a"}=={"%_Stack%"} @echo [      %~nx0] commandLine: %0 %*
echo [Error] %*
pause
exit /b 1
goto :END

:connect_rdp_main
@if defined _Stack @for %%a in ( 1 "%~nx0" "%0" ) do @if {"%%~a"}=={"%_Stack%"} @echo [      %~nx0] commandLine: %0 %*
if {"%~1"}=={""} (
    call :usage
) else (
    call :%*
)

goto :eof


:END
@if defined _Stack @for %%a in ( 1 "%~nx0" "%0" ) do @if {"%%~a"}=={"%_Stack%"} @echo [----- %~nx0] commandLine: %0 %* & @echo.
:: timeout /t 5