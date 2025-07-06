::Author    : Shen Xiaolong((xlshen@126.com))
::Copyright : free use,modify,spread, but MUST include this original two line information(Author and Copyright).

::@set _Echo=1
::set _Debug=1
::set _Stack=%~nx0
@if {"%_Echo%"}=={"1"} ( @echo on ) else ( @echo off )
@if defined _Stack @for %%a in ( 1 "%~nx0" "%0" ) do @if {"%%~a"}=={"%_Stack%"}  @echo. & @echo [+++++ %~nx0] commandLine: %0 %*
rem title length limited to 256 chars , else dos will report "Not enough memory resources are available to process this command"
@title %0 %* 2>nul
@where "%~nx0" 1>nul 2>nul || @set "path=%~dp0;%path%"

set cmds_%~n0="%~fs0" %*
if {"%~1"}=={""} call :Test NoOutput & goto End
call :%~1 %2 %3 %4 %5 %6 %7 %8 %9
goto :End

::******************************DOS API section**************************************************************************
::[DOS_API:normalLinuxPath] check whether linux server path include ~ , if yes, convert it to /home/%usename% to avoid reversed key conflict with windows DOS
::usage     : call :normalLinuxPath <linuxPath> <outSrvPath>
::e.g.      : call :normalLinuxPath "~/" tmpSrvPath
::            call set "tmpSrvPath=/home/%usename%"
:normalLinuxPath
@if defined _Stack @for %%a in ( 1 "%~nx0" "%0" ) do @if {"%%~a"}=={"%_Stack%"} @echo [      %~nx0] commandLine: %0 %*
set "_tmplinuxPath=%~1"
if {"%_tmplinuxPath:~0,1%"}=={"~"} set "_tmplinuxPath=/home/%username%/%_tmplinuxPath:~1%"
if not  {"%_tmplinuxPath:~0,1%"}=={"/"} call :errorAndExit "no available linux file path in clipboard : %~1"
set "_tmplinuxPath=%_tmplinuxPath://=/%"
set "%~2=%_tmplinuxPath%"
goto :eof

::[DOS_API:dosAPIExample] copy linux folder from remote linux folder to local window.
::usage     : call :copyLinuxFolder2Local <remoteServerIP:remoteLinuxPath> [optionalLocalFolderPath]
::e.g.      : call :copyLinuxFolder2Local "computelab-303.nvidia.com:/home/xiaolongs/test"  "C:\tempFolder"         # test => tempFolder
::            call :copyLinuxFolder2Local "computelab-303.nvidia.com:/home/xiaolongs/test"  "C:\tempFolderRoot\"    # test => test
::            call :copyLinuxFolder2Local "computelab-303.nvidia.com:/home/xiaolongs/test"                          # test => %~n1_%random%
:copyLinuxFolder2Local
@if defined _Stack @for %%a in ( 1 "%~nx0" "%0" ) do @if {"%%~a"}=={"%_Stack%"}  @echo [      %~nx0] commandLine: %0 %*
:: scp -r user@your.server.example.com:/path/to/foo         /home/user/Desktop/
:: scp -r xiaolongs@computelab-303.nvidia.com:/home/xiaolongs/test              "C:/test/"
:: scp -r xiaolongs:pwd1234@computelab-303.nvidia.com:/home/xiaolongs/test      "C:/test/"
:: scp -i C:\Users\xiaoshen\.ssh\id_rsa  srdcws1087.amd.com:/home/xiaoshen/linuxScript/projectEnv.csh  C:\repo\srdcws1087_html\
set "dstLocalFolder=%~f2"
if not defined dstLocalFolder set "dstLocalFolder=%cd%\%~nx1"
if not {"%dstLocalFolder:~-1%"}=={"\"} if exist "%dstLocalFolder%\"  rd/s/q "%dstLocalFolder%"
:: option -q will Supress welcome banner message.
:: option -v will show transfer process.
set _cmds=scp -r %USERNAME%@%myLinuxServerName%:%~1 "%dstLocalFolder:\=/%"
set _cmds_show=%_cmds:"='%
call colorTxt.bat "{02}%_cmds_show%{#}{\n}"
%_cmds%
if not defined noExplorerOpen  start "" "%dstLocalFolder%"
call colorTxt.bat "{06}Done:{04}%_cmds_show%{#}{\n}"
:: other download ways
:: _curCredi style : xiaoshen:pwd@srdcws1087.amd.com
:: winscp.exe /console /command "option batch continue" "option confirm off" "open scp://%_curCredi%" "option transfer binary" "get //home/gggy/1.pdf D:\1.pdf" "exit" /log=D:\log_file.log 
:: winscp.exe /console /command "option batch continue" "option confirm off" "open scp://%_curCredi%" "option transfer binary" "get /home/xiaoshen/htmlTree C:\tmp\" "exit" /log=C:\tmp\log_file.log
:: winscp.exe /console /command "option batch continue" "option confirm off" "open scp://%_curCredi%" "option transfer binary" "get /%~2 C:\%~nx2" "exit" /log=D:\log_file.log

:: curl --insecure --user username:password -T /path/to/sourcefile sftp://desthost/path/

:: WinSCP.exe /console /command "option batch continue" "option confirm off" "open scp://%_curCredi%" "option transfer binary" "get /home/xiaoshen/htmlTree C:\tmp\" "exit" /log=C:\tmp\log_file.log
goto :eof

::[DOS_API:copyLocalFolder2Linux] copy folder from local to remote linux folder.
::usage     : call :copyLocalFolder2Linux <remoteServerIP:remoteLinuxPath> [optionalLocalFolderPath]
::e.g.      : call :copyLocalFolder2Linux "C:\tempFolder" "computelab-303.nvidia.com:/home/xiaolongs/test"    # test => tempFolder
::            call :copyLocalFolder2Linux "C:\tempFolder" "computelab-303.nvidia.com:/home/xiaolongs/test/"   # test => test
::            call :copyLocalFolder2Linux "C:\tempFolder"                                                     # test => myLinuxServerPathTmp/%~n1_%random%
:copyLocalFolder2Linux
@if defined _Stack @for %%a in ( 1 "%~nx0" "%0" ) do @if {"%%~a"}=={"%_Stack%"}  @echo [      %~nx0] commandLine: %0 %*
:: scp -r ~/local_dir user@host.com:/var/www/html/target_dir
:: scp -r C:/test  xiaolongs@computelab-303.nvidia.com:/home/xiaolongs/test
set "localFolder=%~f1"
set "dstRemoteFolder=%~2"
if not defined dstRemoteFolder set "dstRemoteFolder=%myLinuxServerPathTmp%/%~n1_%random%%~x1"
set _cmds=scp  -r  "%localFolder:\=/%"  %USERNAME%@%myLinuxServerName%:%dstRemoteFolder%
echo %_cmds%
%_cmds%
echo.
echo %dstRemoteFolder%
goto :eof

::[DOS_API:winscpOpenFolder] use winscp.exe to open remote linux folder
::usage     : call :winscpOpenFolder <linuxServerName> <linuxServerPath>
::e.g.      : call :winscpOpenFolder "computelab-303" "/home/xiaolongs/htmlTree/"
:winscpOpenFolder
@if defined _Stack @for %%a in ( 1 "%~nx0" "%0" ) do @if {"%%~a"}=={"%_Stack%"} @echo [      %~nx0] commandLine: %0 %*
set "tmp_linuxServer=%~1"
set "tmp_linuxPath=%~2"
@where WinSCP.exe 1>nul 2>nul || @set "path=C:\Program Files (x86)\WinSCP;%path%"
:: start "" WinSCP.exe "scp://%usename%@%tmp_linuxServer%:%tmp_linuxPath%" /rawsettings "LocalDirectory=%tmp_localFolder%"
goto :eof

::[DOS_API:vscodeOpen] vscode open remote linux folder or file via remote-ssh extension.
::usage     : call :vscodeOpen <linuxServerName> <linuxServerPath>
::e.g.      : call :vscodeOpen "computelab-303.nvidia.com" "/home/xiaolongs/htmlTree/"
:vscodeOpen
@if defined _Stack @for %%a in ( 1 "%~nx0" "%0" ) do @if {"%%~a"}=={"%_Stack%"} @echo [      %~nx0] commandLine: %0 %*
:: open remote example:
:: start code.cmd --remote ssh-remote+%tmp_linuxServer%.%USERDNSDOMAIN%    %tmp_linuxPath%
:: start code.cmd --folder-uri "vscode-remote://ssh-remote+srdcws1137.amd.com//home"
:: start code.cmd --remote ssh-remote+srdcws1087.AMD.COM /tool/pandora64/.package/gcc-6.3.0-a/include/c++/6.3.0/
:: start code.cmd --remote ssh-remote+computelab-303
:: open local example:
:: start code.cmd "C:/work/shenxiaolong/core/WinScript/"
:: start /B code.cmd -n --locale zh-cn "%~1"
:: start "" "vscode://file/C:\work\shenxiaolong\core\WinScript\Companys\AMD\tools_dailyWork.bat"

:: below way will cause this console window can't exit automaticall, use code.exe directly to workaround not-exit-auto issue
:: start /B Code.cmd  %*

:: ELECTRON_NO_ATTACH_CONSOLE : don't attach to current console window to avoid that the console window can't exit automatically.
:: https://www.electronjs.org/zh/docs/latest/api/environment-variables
set ELECTRON_NO_ATTACH_CONSOLE=1
set "tmp_linuxServer=%~1"
set "tmp_linuxPath=%~2"
:: command line needs .ssh id_rsa file, instead of id_ed25519
call :vscodeOpen.impl --folder-uri "vscode-remote://ssh-remote+%tmp_linuxServer%/%tmp_linuxPath%"
goto :eof

::******************************inner implement  section**************************************************************************

:vscodeOpen.impl
@if defined _Stack @for %%a in ( 1 "%~nx0" "%0" ) do @if {"%%~a"}=={"%_Stack%"} @echo [      %~nx0] commandLine: %0 %*
where Code.exe  1>nul 2>nul || @set "path=%LOCALAPPDATA%\Programs\Microsoft VS Code\;%path%"
echo start /B Code.exe -n --log off --sync off %*
if defined _Stack pause
start /B Code.exe -n --log off --sync off %*
goto :eof

::******************************help  and test  section**************************************************************

::[DOS_API:Help]Display help information
:Help
@if defined _Stack @for %%a in ( 1 "%~nx0" "%0" ) do @if {"%%~a"}=={"%_Stack%"}  @echo [      %~nx0] commandLine: %0 %*
call tools_miscellaneous.bat DisplayHelp "%~f0"
goto :eof

::[DOS_API:Test]Test DOS API in this script file
:Test
@if defined _Stack @for %%a in ( 1 "%~nx0" "%0" ) do @if {"%%~a"}=={"%_Stack%"}  @echo [      %~nx0] commandLine: %0 %*
call :showFileCommandLine
echo.
@echo [%~nx0] Run test case [%0 %*]

echo.
echo test call :Help
call :Help

echo.
goto :eof

:showFileCommandLine
@if defined _Stack @for %%a in ( 1 "%~nx0" "%0" ) do @if {"%%~a"}=={"%_Stack%"}  @echo [      %~nx0] commandLine: %0 %*
echo this script file command line :  cmds_%~n0
call echo %%cmds_%~n0%%
goto :eof

::*******************************************************************************************************************

:End
@if defined _Stack @for %%a in ( 1 "%~nx0" "%0" ) do @if {"%%~a"}=={"%_Stack%"}  @echo [----- %~nx0] commandLine: %0 %* & @echo.