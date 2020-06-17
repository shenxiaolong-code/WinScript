::Author    : Shen Xiaolong((xlshen@126.com))
::Copyright : free use,modify,spread, but MUST include this original two line information(Author and Copyright).

::@set _Echo=1
::set _Stack=%~nx0
@if {%_Echo%}=={1} ( @echo on ) else ( @echo off )
@if defined _Stack @for %%a in ( 1 "%~nx0" "%0" ) do @if {"%%~a"}=={"%_Stack%"} @echo. & @echo [+++++ %~nx0] commandLine: %0 %*
where %~nx0 1>nul 2>nul || set "path=%~dp0;%path%"
where TortoiseProc.exe 1>nul 2>nul || set "path=C:\Program Files\TortoiseSVN\bin;%path%"

if {%1}=={} call :Test  & goto End
::if {%1}=={} call :Test NoOutput & goto End

call :%1 %2 %3 %4 %5 %6 %7 %8 %9
goto End

::[DOS_API:Help]display help information
:Help
@if defined _Stack @for %%a in ( 1 "%~nx0" "%0" ) do @if {"%%~a"}=={"%_Stack%"} @echo [      %~nx0] commandLine: %0 %*
call tools_miscellaneous.bat DisplayHelp "%~f0"
goto :eof

::[DOS_API:Test]Test DOS API in this script file
:Test
@if defined _Stack @for %%a in ( 1 "%~nx0" "%0" ) do @if {"%%~a"}=={"%_Stack%"} @echo [      %~nx0] commandLine: %0 %*
@echo [%~nx0] Run test case [%0 %*]

echo.
echo [TC] test call :GetSvnApp
set svnApp=
echo [before]svnApp=%svnApp%
call :GetSvnApp svnApp
echo [after]svnApp=%svnApp%

echo.
echo [TC] test call :svnUpdate "%~dp0"

echo.
echo [TC] test call :svnBackupSrc "%~dp0.."  "%temp%\tools_svn_sel_test"
call :svnBackupSrc "%~dp0.."  "%temp%\tools_svn_sel_test"
start "" "%bk_dstPath%"

echo.
echo [TC] test call :svnBackupRootSrc "%~dp0.."  "%temp%\tools_svn_root_test"
call :svnBackupSrc "%~dp0.."  "%temp%\tools_svn_root_test"
start "" "%bk_dstPath%"

echo.
echo [TC] test call :svnVerCmd "%~f0" 183
call :svnVerCmd "%~f0" 183

echo.
echo [TC] test call :svnLocalRootPath "%~f0" localRootPath
call :svnLocalRootPath "%~f0" localRootPath
echo localRootPath=%localRootPath%

echo.
echo [TC] test call :svnServerIP "%~f0" serverIP
call :svnServerIP "%~f0" serverIP
echo serverIP=%serverIP%

echo.
echo [TC] test call :svnIsSvnFolder "%~f0" isSvnFolder
call :svnIsSvnFolder "%~f0" isSvnFolder
echo isSvnFolder=%isSvnFolder%

echo.
echo [TC] test call :svnCurUserName "%~f0" curUsrName
call :svnCurUserName "%~f0" curUsrName
echo curUsrName=%curUsrName%

echo.
echo [TC] test call :svnRestoreSrc "%~dp0"
rem call "%bk_dstPath%\restoreSrc.bat"

echo.
echo [TC] test call :deleteUnversionedFiles
set msg=deleteUnversionedFiles
echo [before]msg=%msg%
call :deleteUnversionedFiles "%~dp0.." msg
echo [after]msg=%msg%

echo.
echo [TC] test call :getSrcWithVer "https://127.0.0.1/svn/shenxiaolong/core/WinScript/common/tools_svn.bat" 200 myCacheFile
call :getSrcWithVer "https://127.0.0.1/svn/shenxiaolong/core/WinScript/common/tools_svn.bat" 200 myCacheFile
echo myCacheFile=%myCacheFile%

echo.
echo [TC] test call :svnIsSvnFolder "C:\WINCE700\OSDesigns\TreasureFleet"
call :svnIsSvnFolder "C:\WINCE700\OSDesigns\TreasureFleet"

goto :eof

::[DOS_API:GetSvnApp]find svn GUI client full path and save result into possible output variable
::call e.g  : call :GetSvnApp TestVar
::result e.g: set TestVar=""C:\Program Files\TortoiseSVN\bin\TortoiseProc.exe""
:GetSvnApp
@if defined _Stack @for %%a in ( 1 "%~nx0" "%0" ) do @if {"%%~a"}=={"%_Stack%"} @echo [      %~nx0] commandLine: %0 %*
set var_GetSvnApp=
call tools_path.bat FindAppPathInEnv TortoiseProc.exe var_GetSvnApp
if {"%var_GetSvnApp%"}=={""}    tools_message.bat popMsg "Can't find SVN tool, pls check." & exit/b 1
if not exist "%var_GetSvnApp%"  tools_message.bat popMsg "Can't find SVN tool, pls check." & exit/b 2
if {%~1}=={} (
echo %var_GetSvnApp%
) else (
set %~1=%var_GetSvnApp%
)
exit/b 0
goto :eof

::[DOS_API:svnLog] display svn file log info in UI window by full item path.
::call e.g  : call :svnLog "C:\mySvnProject\main.cpp"
:svnLogUI
@if defined _Stack @for %%a in ( 1 "%~nx0" "%0" ) do @if {"%%~a"}=={"%_Stack%"} @echo [      %~nx0] commandLine: %0 %*
TortoiseProc.exe /command:log /path:"%~f1"
goto :eof

::[DOS_API:svnLogCmd] display svn file log info in console window by full item path.
::call e.g  : call :svnLogCmd "C:\mySvnProject\main.cpp" "myLog"
::          : call :svnLogCmd "C:\mySvnProject\main.cpp"
:svnLogCmd
@if defined _Stack @for %%a in ( 1 "%~nx0" "%0" ) do @if {"%%~a"}=={"%_Stack%"} @echo [      %~nx0] commandLine: %0 %*
rem if not defined queryOpt set queryOpt=-v
call tools_error.bat checkParamCount 1 %*
pushd "%~1"
call :svnLogCmd.Impl %*
popd
goto :eof

:svnLogCmd.Impl
@if defined _Stack @for %%a in ( 1 "%~nx0" "%0" ) do @if {"%%~a"}=={"%_Stack%"} @echo [      %~nx0] commandLine: %0 %*
set "logStr=%~2"
if {"%logStr%"}=={""} call :svnLogCmd.waitInput
echo svn log --search "%logStr%" %queryOpt%
svn log --search "%logStr%" %queryOpt%
echo.
if {"%~2"}=={""} (
call tools_message.bat promptMsg "press any key to start next query:"
goto :svnLogCmd.Impl %*
)
goto :eof

:svnLogCmd.waitInput
@if defined _Stack @for %%a in ( 1 "%~nx0" "%0" ) do @if {"%%~a"}=={"%_Stack%"} @echo [      %~nx0] commandLine: %0 %*
set waitStringPrompt=please input log query string, regular express is supported.
call tools_userInput.bat waitConfirm waitString logStr
goto :eof

::[DOS_API:svnLog] display svn file log info in UI window by full item path.
::call e.g  : call :svnLog "C:\mySvnProject\main.cpp"
:svnLog
@if defined _Stack @for %%a in ( 1 "%~nx0" "%0" ) do @if {"%%~a"}=={"%_Stack%"} @echo [      %~nx0] commandLine: %0 %*
call tools_message.bat outOfDateAPIMsg svnLog svnLogUI
call :svnLogUI %*
goto :eof

::[DOS_API:svnVerCmd] display svn version info in console window by full item path and version number.
::call e.g  : call :svnVerCmd "C:\mySvnProject\main.cpp" 183
:svnVerCmd
@if defined _Stack @for %%a in ( 1 "%~nx0" "%0" ) do @if {"%%~a"}=={"%_Stack%"} @echo [      %~nx0] commandLine: %0 %*
rem if not defined queryOpt set queryOpt=-v
call tools_error.bat checkParamCount 2 %*
echo version[%~2] for "%~f1"
svn info -r %~2 "%~f1"
echo.
echo log[%~2] for "%~f1"
svn log -v -r %~2 "%~f1"
echo.
exit/b 0
goto :eof

::[DOS_API:svnVerUI] display svn version info in UI window by full item path and version number.
::call e.g  : call :svnVerUI "C:\mySvnProject\main.cpp" 183
::          : call :svnVerUI "C:\mySvnProject\main.cpp"
:svnVerUI
@if defined _Stack @for %%a in ( 1 "%~nx0" "%0" ) do @if {"%%~a"}=={"%_Stack%"} @echo [      %~nx0] commandLine: %0 %*
call set "svnVerQueryNum=%~2"
if {"%svnVerQueryNum%"}=={""} call :svnVer.waitInput
call :svnVerRangeUI "%~f1" %svnVerQueryNum%  %svnVerQueryNum%
goto :eof

:svnVer.waitInput
@if defined _Stack @for %%a in ( 1 "%~nx0" "%0" ) do @if {"%%~a"}=={"%_Stack%"} @echo [      %~nx0] commandLine: %0 %*
set waitStringPrompt=please input query svn version, only number is supported.
call tools_userInput.bat waitConfirm waitNumber svnVerQueryNum
goto :eof

::[DOS_API:svnServerIP] get current svn server root path for current svn path.
::call e.g  : call :svnServerIP "C:\mySvnProject\main.cpp" 183
:svnServerIP
@if defined _Stack @for %%a in ( 1 "%~nx0" "%0" ) do @if {"%%~a"}=={"%_Stack%"} @echo [      %~nx0] commandLine: %0 %*
call tools_error.bat checkParamCount 2 %*
call tools_error.bat checkPathExist "%~1"
for /f "usebackq tokens=*" %%i in ( ` svn info "%~f1" --show-item repos-root-url ` ) do set _tmpSrvIp=%%i
call :svnServerIP.setOutput %~2 %_tmpSrvIp:/= %
goto :eof

::[DOS_API:svnLocalRootPath] get current svn root directory path in any svn path.
::call e.g  : call :svnLocalRootPath "." svnRoot
:svnLocalRootPath
@if defined _Stack @for %%a in ( 1 "%~nx0" "%0" ) do @if {"%%~a"}=={"%_Stack%"} @echo [      %~nx0] commandLine: %0 %*
call tools_error.bat checkParamCount 2 %*
call tools_error.bat checkPathExist "%~1"
call tools_message.bat enableDebugMsg "%~0" "inputPath : %~f1"
for /f "usebackq tokens=*" %%i in ( ` svn info "%~f1" --show-item wc-root ` ) do set _tmpLocalPath=%%i
set %~2=%_tmpLocalPath:/=\%
call tools_message.bat enableDebugMsg "%~0" "output result : set %~2=%%%~2%%"
goto :eof


::[DOS_API:svnCurUserName] get current svn logined user name.
::call e.g  : call :svnCurUserName "C:\mySvnProject\main.cpp" usrName
:svnCurUserName
@if defined _Stack @for %%a in ( 1 "%~nx0" "%0" ) do @if {"%%~a"}=={"%_Stack%"} @echo [      %~nx0] commandLine: %0 %*
call tools_error.bat checkParamCount 2 %*
call :svnServerIP "%~f1" _tmpSrvIp
for /f "usebackq tokens=*" %%i in ( ` svn auth %_tmpSrvIp% ^| find /i "UserName" ` ) do set _tmpUsrName=%%i
set %~2=%_tmpUsrName:Username: =%
goto :eof

::[DOS_API:svnIsSvnFolder] detect whether one path is svn folder
::call e.g  : call :svnIsSvnFolder "C:\mySvnProject\main.cpp" isSvnFolder
:svnIsSvnFolder
@if defined _Stack @for %%a in ( 1 "%~nx0" "%0" ) do @if {"%%~a"}=={"%_Stack%"} @echo [      %~nx0] commandLine: %0 %*
call tools_error.bat checkParamCount 2 %*
call tools_error.bat checkPathExist "%~1"
svn info "%~f1" 1>nul 2>nul && set "%~2=1" || set %~2=0
goto :eof

::[DOS_API:svnVerRangeUI] display svn version info in UI window by full item path and version number.
::call e.g  : call :svnVerRangeUI "C:\mySvnProject\main.cpp" 183 203
:svnVerRangeUI
@if defined _Stack @for %%a in ( 1 "%~nx0" "%0" ) do @if {"%%~a"}=={"%_Stack%"} @echo [      %~nx0] commandLine: %0 %*
rem if not defined queryOpt set queryOpt=-v
call tools_error.bat checkParamCount 3 %*
if %~3 LSS %~2 call tools_message.bat errorMsg "begin version[%~2] MUST less than end version[%!3]." "%~f0" svnVerRangeUIMark
TortoiseProc.exe /command:log /path:"%~1" /startrev:%~2 /endrev:%~3
exit/b 0
goto :eof

::[DOS_API:svnDiff] display svn file modify with previous version by full item path.
::call e.g  : call :svnDiff "C:\mySvnProject\main.cpp"
:svnDiff
@if defined _Stack @for %%a in ( 1 "%~nx0" "%0" ) do @if {"%%~a"}=={"%_Stack%"} @echo [      %~nx0] commandLine: %0 %*
::TortoiseProc.exe /command:diff /path:"%~f1" /startrev:170 /endrev:190
TortoiseProc.exe /command:diff /path:"%~f1"
exit/b 0
goto :eof

::[DOS_API:svnBlame] display svn file modify record by specified file and line number by full item path.
::call e.g  : call :svnBlame "C:\mySvnProject\main.cpp"  56
:svnBlame
@if defined _Stack @for %%a in ( 1 "%~nx0" "%0" ) do @if {"%%~a"}=={"%_Stack%"} @echo [      %~nx0] commandLine: %0 %*
TortoiseProc.exe /command:blame /path:"%~f1" /line:%~2
exit/b 0
goto :eof

::[DOS_API:svnRevert] revert modification by specified file full path.
::call e.g  : call :svnRevert "C:\mySvnProject\main.cpp"
:svnRevert
@if defined _Stack @for %%a in ( 1 "%~nx0" "%0" ) do @if {"%%~a"}=={"%_Stack%"} @echo [      %~nx0] commandLine: %0 %*
TortoiseProc.exe /command:revert /path:"%~f1"
exit/b 0
goto :eof

::[DOS_API:svnSearch] search specified string in author, date, log message
::                    supported search pattern : ? * [abc] , for help, type svn help log
::syntax              call :svnSearch filterString  [optionalLen] 
::call e.g  : call :svnSearch fixbug*contact 
::call e.g  : call :svnSearch fixbug*contact 50
:svnSearch
@if defined _Stack @for %%a in ( 1 "%~nx0" "%0" ) do @if {"%%~a"}=={"%_Stack%"} @echo [      %~nx0] commandLine: %0 %*
if not {"%~2"}=={""} set _maxSearch=-l %~2
if defined svnPath   set _svnPath=%svnPath%
svn log %_svnPath% --search "%~1" %_maxSearch%
::reset variable
set _maxSearch=
set _svnPath=
exit/b 0
goto :eof

::[DOS_API:svnAddIgnore] add ignore file or directory
::syntax    :   call :svnAddIgnore ignorePath
::call e.g  :   call :svnAddIgnore "C:\jabber118\product\win\client"                    //ignore directory
::              call :svnAddIgnore "C:\jabber118\product\win\client\ignoreMe.txt"       //ignore file
:svnAddIgnore
@if defined _Stack @for %%a in ( 1 "%~nx0" "%0" ) do @if {"%%~a"}=={"%_Stack%"} @echo [      %~nx0] commandLine: %0 %*
call :svnIsSvnFolder "%~dp1" isSvnProject
if not {"%isSvnProject%"}=={"1"} call tools_message.bat errorMsg "%~1 is not svn repo path."
svn propset svn:ignore "%~fs1" "%~dps1"
goto :eof

::[DOS_API:svnBackupRootSrc] backup modify source files to specified path
::syntax    :   call :svnBackupRootSrc projectPath  backupPath
::call e.g  :   call :svnBackupRootSrc "C:\jabber118\product\win\client"    "D:\backupSrc" 
::              call :svnBackupRootSrc "C:\jabber118\product\win\client"    //use default : C:\jabber118\product\win\client\jabber118_bak_%date%%time%
:svnBackupRootSrc
@if defined _Stack @for %%a in ( 1 "%~nx0" "%0" ) do @if {"%%~a"}=={"%_Stack%"} @echo [      %~nx0] commandLine: %0 %*
call :svnIsSvnFolder "%~1" isSvnProject
if not {"%isSvnProject%"}=={"1"} call tools_message.bat errorMsg "%~1 is not svn repo path."
call :svnLocalRootPath "%~1" svnProjectRoot
::call set "DefaultBackupPathRoot=%~f1\svnBackupSrc"
call :svnBackupSrc "%svnProjectRoot%" %2
goto :eof

::[DOS_API:svnBackupSrc] backup modify source files to specified path
::syntax    :   call :svnBackupSrc projectPath  backupPath
::call e.g  :   call :svnBackupSrc "C:\jabber118" "D:\backupSrc" 
::              call :svnBackupSrc "C:\jabber118"                   //use default : C:\jabber118\jabber118_bak_%date%%time%
:svnBackupSrc
@if defined _Stack @for %%a in ( 1 "%~nx0" "%0" ) do @if {"%%~a"}=={"%_Stack%"} @echo [      %~nx0] commandLine: %0 %*
call :BackupSrc.processInput %*
if exist "%bk_dstPath%" del/f/q "%bk_dstPath%"
if not exist "%bk_dstPath%" md "%bk_dstPath%"
echo.
set "srcBakNote=%bk_dstPath%\bakup.log"
(
@echo backup svn modified files. [%date% - %time%]
call :BackupSrc.executeBackup
echo.
call :BackupSrc.createRestoreScript
@echo.
@echo [complete backup] %bk_SrcPath%  =^>  %bk_dstPath%
@echo.
) > "%srcBakNote%"
type "%srcBakNote%"
if not defined NotOpenFolder start "" "%bk_dstPath%"
call tools_message.bat noPauseMsg "%~0"
goto :eof

:BackupSrc.processInput
@if defined _Stack @for %%a in ( 1 "%~nx0" "%0" ) do @if {"%%~a"}=={"%_Stack%"} @echo [      %~nx0] commandLine: %0 %*
call :svnIsSvnFolder "%~1" isSvnProject
if not {"%isSvnProject%"}=={"1"} call tools_message.bat errorMsg "%~1 is not svn repo path."

set "bk_SrcPath=%~f1"
call tools_message.bat enableDebugMsg "%~0" "bk_SrcPath=%bk_SrcPath%"

if not defined DefaultBackupPathRoot set "DefaultBackupPathRoot=%bk_SrcPath%\svnBackupSrc"
if {"%~2"}=={""} (
set "backupPathRoot=%DefaultBackupPathRoot%\svnBackup"
) else (
set "backupPathRoot=%~2"
)

if {"%backupPathRoot:~-1%"}=={"\"} call set "backupPathRoot=%backupPathRoot:~0,-1%"
call genNameByTime.bat dtInfo
::set bk_dstPath=%backupPathRoot%\%~n1_bak_%bk_SrcPath:*\=%\%dtInfo%
set "bk_dstDataFolder=\%~n1"
call set "bk_dstPath=%backupPathRoot%\%~n1_bak\%dtInfo%"
call tools_message.bat enableDebugMsg "%~0" "bk_dstPath=%bk_dstPath%"
goto :eof

:BackupSrc.createRestoreScript
@if defined _Stack @for %%a in ( 1 "%~nx0" "%0" ) do @if {"%%~a"}=={"%_Stack%"} @echo [      %~nx0] commandLine: %0 %*
::different PC use different script absolute path
echo %%WinScriptPath%%\common\%~nx0 svnRestoreSrc "%%~dp0.%bk_dstDataFolder%" "%bk_SrcPath%" > "%bk_dstPath%\restoreSrc.bat"
echo "%bk_dstPath%\restoreSrc.bat" is created.
echo.
goto :eof

:BackupSrc.executeBackup
@if defined _Stack @for %%a in ( 1 "%~nx0" "%0" ) do @if {"%%~a"}=={"%_Stack%"} @echo [      %~nx0] commandLine: %0 %*
::generate update information from SVN commandline
set "fileList=%bk_dstPath%\bakFileList.txt"
svn status "%bk_SrcPath%" | find /v "?" | find /v ">" > "%fileList%"
echo. 

:: impl backup
title backup modify : %bk_SrcPath%  =^>  %bk_dstPath%
echo backup modify : %bk_SrcPath%  =^>  %bk_dstPath%
rem call :setReplacePath "%cd%" "%bk_SrcPath%"
for /f  "usebackq tokens=1,* " %%i in ( ` type "%fileList%" ` ) do  call :BackupSrc.processOneLine "%%i" "%%j"
goto :eof

:BackupSrc.processOneLine
@if defined _Stack @for %%a in ( 1 "%~nx0" "%0" ) do @if {"%%~a"}=={"%_Stack%"} @echo [      %~nx0] commandLine: %0 %*
if {"%~1"}=={"M"} call :BackupSrc.backupSingle  "%~2"
if {"%~1"}=={"A"} call :BackupSrc.addSingle     "%~2"
if {"%~1"}=={"D"} call :BackupSrc.deleteSingle  "%~2"
goto :eof

:BackupSrc.deleteSingle
@if defined _Stack @for %%a in ( 1 "%~nx0" "%0" ) do @if {"%%~a"}=={"%_Stack%"} @echo [      %~nx0] commandLine: %0 %*
if not defined deletedPath  set "deletedPath=%bk_dstPath%\deletedFiles.txt"
echo %~1     > "%deletedPath%"
echo [ del ] %~f1
goto :eof

:BackupSrc.addSingle
@if defined _Stack @for %%a in ( 1 "%~nx0" "%0" ) do @if {"%%~a"}=={"%_Stack%"} @echo [      %~nx0] commandLine: %0 %*
set "_tmp=%~1"
rem A  +    D:\work\shenxiaolong_projects\CodePractice\RPC practice\createRPCFiles.bat
if {"%_tmp:~0,2%"}=={"+ "} call :BackupSrc.addSingle.removeAddChar %_tmp:~2%
rem A      D:\work\shenxiaolong_projects\CodePractice\RPC practice\createRPCFiles.bat
if not {"%_tmp:~0,2%"}=={"+ "} call :BackupSrc.addSingle.impl %*
goto :eof

:BackupSrc.addSingle.removeAddChar
@if defined _Stack @for %%a in ( 1 "%~nx0" "%0" ) do @if {"%%~a"}=={"%_Stack%"} @echo [      %~nx0] commandLine: %0 %*
call :BackupSrc.addSingle.impl "%*"
goto :eof

:BackupSrc.addSingle.impl
@if defined _Stack @for %%a in ( 1 "%~nx0" "%0" ) do @if {"%%~a"}=={"%_Stack%"} @echo [      %~nx0] commandLine: %0 %*
call tools_path.bat isFolderExist "%~1" _tmpbFolder
if {"%_tmpbFolder%"}=={"1"} goto :eof
if not defined addedPath  set "addedPath=%bk_dstPath%\addedFiles.txt"
echo %~1     > "%addedPath%"
echo [ add ] %~f1
call :BackupSrc.backupSingle "%~f1"
goto :eof

:BackupSrc.backupSingle
@if defined _Stack @for %%a in ( 1 "%~nx0" "%0" ) do @if {"%%~a"}=={"%_Stack%"} @echo [      %~nx0] commandLine: %0 %*
::generate update information from git commandline
set "srcFile=%~dpnx1"
call set "dstFile=%%srcFile:%bk_SrcPath%=%bk_dstPath%%bk_dstDataFolder%%%"
set "srcDir=%~dp1"
call set "dstDir=%%srcDir:%bk_SrcPath%=%bk_dstPath%%bk_dstDataFolder%%%"
if not exist "%dstDir%" md "%dstDir%"
set curCmd=copy "%srcFile%" "%dstFile%"
%curCmd% 1> nul
if {%errorlevel%}=={0} (
set/p=[  OK ] <nul
) else (
set/p=[Fails] <nul
)
echo %dstFile:~-127%
goto :eof

::[DOS_API:svnRestoreSrc] restore svn file from backup folder
::syntax              call :svnRestoreSrc backupPath projectPath
::call e.g  : call :svnRestoreSrc "C:\test\jabber118\20180129_170432" "C:\jabber118"
:svnRestoreSrc
@if defined _Stack @for %%a in ( 1 "%~nx0" "%0" ) do @if {"%%~a"}=={"%_Stack%"} @echo [      %~nx0] commandLine: %0 %*
set _Debug=1
if not exist "%~f2" (
call colorTxt.bat 0b "%~f2 is not svn path."
echo.
pause
goto :End
)
set "rs_srcPath=%~f1"
if {%rs_srcPath:~-1%}=={\} set "rs_srcPath=%rs_srcPath:~0,-1%"

if not exist "%~f1" (
call colorTxt.bat 0b "%~f1 is not svn path."
echo.
pause
goto :End
)
set "rs_dstPath=%~f2"
echo restore : %rs_srcPath% =^> %rs_dstPath%
echo.
::for /f "usebackq tokens=* " %%a in ( ` dir/b/a:d "%rs_srcPath%" ` ) do call :RestoreSrc.processFolder "%%a"
call :RestoreSrc.processFolder "%rs_srcPath%"
echo.

set "deletedPath=%~dp1deletedFiles.txt"
if exist "%deletedPath%" call :svnRestoreSrc.deletePath "%deletedPath%"
echo.

set "addedPath=%~dp1addedFiles.txt"
if exist "%addedPath%" call :svnRestoreSrc.addPath "%addedPath%"
echo.

echo.
echo restore complete.
pause
explorer.exe "%rs_dstPath%"
goto :eof

::[DOS_API:svnUpdate] update svn file or directory by specified file full path.
::call e.g  : call :svnUpdate "C:\mySvnProject\main.cpp" 1
::			  call :svnUpdate "C:\mySvnProject"
:svnUpdate  path  bIsCmdMode
@if defined _Stack @for %%a in ( 1 "%~nx0" "%0" ) do @if {"%%~a"}=={"%_Stack%"} @echo [      %~nx0] commandLine: %0 %*
@echo cleanup possible svn locks to ensure update svn sucessfully...
svn cleanup
@echo update svn source ...
where TortoiseProc.exe 1>nul 2>nul || call tools_message.bat errorMsg "Fails t find svn client , pls set path;"
if not exist "%~fs1" call tools_message.bat errorMsg "No valid path parameter."
if not defined usedConflictMode call :svnUpdate.conflictMod %~3
if {"%~2"}=={"1"} (
set _upCmd=svn update "%~fs1" --accept %usedConflictMode%
set usedConflictMode=
) else (
set _upCmd=TortoiseProc.exe /command:update /path:"%~fs1" /closeonend:1
)
echo %_upCmd%
%_upCmd%
exit /b %errorlevel%
goto :eof

:svnUpdate.conflictMod
@if defined _Stack @for %%a in ( 1 "%~nx0" "%0" ) do @if {"%%~a"}=={"%_Stack%"} @echo [      %~nx0] commandLine: %0 %*
if {"%~1"}=={""} (
if not defined DefConflictMode set DefConflictMode=2
call :svnUpdate.conflictMod.parse %DefConflictMode%
) else (
call :svnUpdate.conflictMod.parse %~1
)
goto :eof

:svnUpdate.conflictMod.parse
@if defined _Stack @for %%a in ( 1 "%~nx0" "%0" ) do @if {"%%~a"}=={"%_Stack%"} @echo [      %~nx0] commandLine: %0 %*
if %~1 LSS 0 if %~1 GTR 4 call tools_message.bat errorMsg "parameter[%~1] is out of range [0-4]."
set modeMap=0-postpone;1-mine-full;2-theirs-full;3-working;4-base
call set usedConflictMode=%%modeMap:*%~1-=%%
set usedConflictMode=%usedConflictMode:;=&rem. %
call tools_message.bat enableDebugMsg "%~0" "usedConflictMode='%usedConflictMode%'"
goto :eof

::[DOS_API:svnIsLocked] check whether svn path is locked. many operation will fail if svn is locked. e.g. update
::call e.g  : call :svnIsLocked "C:\mySvnProject" outVar
:svnIsLocked
@if defined _Stack @for %%a in ( 1 "%~nx0" "%0" ) do @if {"%%~a"}=={"%_Stack%"} @echo [      %~nx0] commandLine: %0 %*
for /f "usebackq tokens=1" %%i in ( ` svn st -q  "%~s1"  ^| find /c " L " ` ) do if %%i EQU 0 ( set %~2=0 ) else set %~2=1
call tools_message.bat enableDebugMsg "%~0" "[%~1] %~2=%%%~2%%"
goto :eof

::[DOS_API:svnClean] update svn file or directory by specified file full path.
::call e.g  : call :svnClean "C:\mySvnProject"
:svnClean
@if defined _Stack @for %%a in ( 1 "%~nx0" "%0" ) do @if {"%%~a"}=={"%_Stack%"} @echo [      %~nx0] commandLine: %0 %*
svn  cleanup "%~s1"
SVN  cleanup "%~s1" --remove-unversioned
rem call :deleteUnversionedFiles %*
goto :eof

::[DOS_API:getSrcWithVer] update svn file or directory by specified file full path.
::syntax    : call :getSrcWithVer svnFileUri   svnVersion  [outputVar]
::call e.g  : call :getSrcWithVer "https://wwwin-svn-sjc-3.cisco.com/jabber-all/jabber/trunk/services/voicemailservice/src/featuresets/adapters/VoicemailAdapter/VoicemailAdapter.cpp" 253936
::            call :getSrcWithVer "https://wwwin-svn-sjc-3.cisco.com/jabber-all/jabber/trunk/services/voicemailservice/src/featuresets/adapters/VoicemailAdapter/VoicemailAdapter.cpp" 253936 myOut
:getSrcWithVer
@if defined _Stack @for %%a in ( 1 "%~nx0" "%0" ) do @if {"%%~a"}=={"%_Stack%"} @echo [      %~nx0] commandLine: %0 %*
set svnFileUri=%~1
:: set buildServer=https://wwwin-svn-sjc-3.cisco.com/jabber-all/jabber/trunk
:: set svnFileUri=%buildServer%/products/jabber-win/src/jabber-client/src/MessageLoopChecker.h
set fileVer=%~2
:: set fileVer=252361
if not defined svnOpt set svnOpt=--non-interactive
if not defined SrcCachePath     set SrcCachePath=%CachePath%\src
set localSubPath=%svnFileUri:/=\%
set localSubPath=%localSubPath:*\\=%
::set localSubPath=%localSubPath:*\=%
::set localSubPath=%localSubPath:*\=%
set localCacheFilePath=%SrcCachePath%\%localSubPath%\%fileVer%
if not exist "%localCacheFilePath%" md "%localCacheFilePath%"
set localCacheFileFile=%localCacheFilePath%\%~nx1
if exist "%localCacheFileFile%" del /f/q "%localCacheFileFile%"
:: example:
:: :getSrcWithVer "https://wwwin-svn-sjc-3.cisco.com/jabber-all/jabber/trunk/services/voicemailservice/src/featuresets/adapters/VoicemailAdapter/VoicemailAdapter.cpp" 253936
:: the local cache file is : %SrcCachePath%\jabber-all\jabber\trunk\services\voicemailservice\src\featuresets\adapters\VoicemailAdapter\VoicemailAdapter.cpp\253936\voicemailadapter.cpp
title svn.exe cat "%svnFileUri%@%fileVer%" %svnOpt% > "%localCacheFileFile%"
svn.exe cat "%svnFileUri%@%fileVer%" %svnOpt% > "%localCacheFileFile%"
if not {"%~3"}=={""} (
set %~3=%localCacheFileFile%
) else (
type %localCacheFileFile%
)
goto :eof

::[DOS_API:deleteUnversionedFiles]clean unversioned svn file
::call e.g  : call :deleteUnversionedFiles "C:\D\TreasureFleet_L2\mt_tf" [optional]msg
::result e.g: set msg=delete 7 files and 1 directorys!
:deleteUnversionedFiles
@if defined _Stack @for %%a in ( 1 "%~nx0" "%0" ) do @if {"%%~a"}=={"%_Stack%"} @echo [      %~nx0] commandLine: %0 %*
::setlocal enabledelayedexpansion
if {"%~1"}=={""}    echo empty path parameter & exit/b 1
if not exist "%~1"  echo not existed path & exit/b 2
set /a files=0
set /a directorys=0
for /f "usebackq tokens=1,*" %%i in ( ` svn status "%~1" ^| find "?" ` ) do call :deleteUnversionedFilesImpl "%%j"
if not {"%~2"}=={""} (
set %~2=[summary] delete %files% files and %directorys% directorys!
) else (
echo [summary] delete !files! files and !directorys! directorys!
)
endlocal
goto :eof

::********************************************inner implement ***********************************************************************
:svnServerIP.setOutput
@if defined _Stack @for %%a in ( 1 "%~nx0" "%0" ) do @if {"%%~a"}=={"%_Stack%"} @echo [      %~nx0] commandLine: %0 %*
set %~1=%~3
goto :eof

:RestoreSrc.setDstPath
@if defined _Stack @for %%a in ( 1 "%~nx0" "%0" ) do @if {"%%~a"}=={"%_Stack%"} @echo [      %~nx0] commandLine: %0 %*
call tools_string.bat TrimString "%~1" _tmpFilePath
::echo "_tmpFilePath=%_tmpFilePath%"
call set "%~2=%%_tmpFilePath:%rs_srcPath%=%rs_dstPath%%%"
::call echo %~2=%%%~2%%
goto :eof

:RestoreSrc.processFolder
@if defined _Stack @for %%a in ( 1 "%~nx0" "%0" ) do @if {"%%~a"}=={"%_Stack%"} @echo [      %~nx0] commandLine: %0 %*
for /f "usebackq tokens=* " %%a in ( ` dir/s/b/a:a "%rs_srcPath%" ` ) do call :RestoreSrc.processFile "%%a"
goto :eof

:RestoreSrc.processFile
@if defined _Stack @for %%a in ( 1 "%~nx0" "%0" ) do @if {"%%~a"}=={"%_Stack%"} @echo [      %~nx0] commandLine: %0 %*
set "rs_srcFile=%~f1"
call tools_message.bat enableDebugMsg "%~0" "rs_srcFile=%rs_srcFile%"
call :RestoreSrc.setDstPath "%rs_srcFile%" rs_dstFile
::call set "rs_dstFile=%%rs_srcFile:%rs_srcPath%=%rs_dstPath%%%"
call tools_message.bat enableDebugMsg "%~0" "rs_dstFile=%rs_dstFile%"
set curCmd= copy/y "%rs_srcFile%"   "%rs_dstFile%"
rem set curCmd= echo "%rs_srcFile%"   %rs_dstFile%
%curCmd% 1> nul
if {%errorlevel%}=={0} (
set/p=[  OK ] <nul
) else (
set/p=[Fails] <nul
pause
)
echo %rs_srcFile:~-100%
echo.
goto :eof

:svnRestoreSrc.deletePath
@if defined _Stack @for %%a in ( 1 "%~nx0" "%0" ) do @if {"%%~a"}=={"%_Stack%"} @echo [      %~nx0] commandLine: %0 %*
echo delete below files from svn repo ...
for /f "usebackq tokens=*" %%i in ( ` type "%~fs1" ` ) do call :svnRestoreSrc.deletePath.processOne "%%i"
goto :eof

:svnRestoreSrc.deletePath.processOne
@if defined _Stack @for %%a in ( 1 "%~nx0" "%0" ) do @if {"%%~a"}=={"%_Stack%"} @echo [      %~nx0] commandLine: %0 %*
call :RestoreSrc.setDstPath "%~1" rs_dstFile 
call :svnRestoreSrc.deletePath.deleteOne "%rs_dstFile%"
goto :eof

:svnRestoreSrc.deletePath.deleteOne
@if defined _Stack @for %%a in ( 1 "%~nx0" "%0" ) do @if {"%%~a"}=={"%_Stack%"} @echo [      %~nx0] commandLine: %0 %*
if not exist "%~fs1" goto :eof
svn delete "%~fs1"
call tools_path.bat isFolderExist "%~fs1" bFolder
if {"%bFolder%"}=={"1"}         rd /s/q "%~fs1"     && echo [OK] deleted directory "%~fs1"  || echo [fail] deleted directory "%~fs1"
if not {"%bFolder%"}=={"1"}     del /q/f "%~fs1"    && echo [OK] deleted file "%~fs1"       || echo [fail] deleted file "%~fs1"
goto :eof

:svnRestoreSrc.addPath
@if defined _Stack @for %%a in ( 1 "%~nx0" "%0" ) do @if {"%%~a"}=={"%_Stack%"} @echo [      %~nx0] commandLine: %0 %*
echo add below files to svn repo ...
for /f "usebackq tokens=*" %%i in ( ` type "%~fs1" ` ) do call :svnRestoreSrc.addPath.processOne "%%i"
goto :eof

:svnRestoreSrc.addPath.processOne
@if defined _Stack @for %%a in ( 1 "%~nx0" "%0" ) do @if {"%%~a"}=={"%_Stack%"} @echo [      %~nx0] commandLine: %0 %*
call :RestoreSrc.setDstPath "%~1" rs_dstFile 
call :svnRestoreSrc.addPath.addOne "%rs_dstFile%"
goto :eof

:svnRestoreSrc.addPath.addOne
@if defined _Stack @for %%a in ( 1 "%~nx0" "%0" ) do @if {"%%~a"}=={"%_Stack%"} @echo [      %~nx0] commandLine: %0 %*
if not exist "%~fs1" goto :eof
svn add "%~fs1"
goto :eof

:deleteUnversionedFilesImpl
@if defined _Stack @for %%a in ( 1 "%~nx0" "%0" ) do @if {"%%~a"}=={"%_Stack%"} @echo [      %~nx0] commandLine: %0 %*
echo delete %~1.
if exist "%~1\" 	rd /S /Q 			"%~1" && set /a directorys=!directorys!+1
if exist "%~1\" echo.
if exist "%~1" 		del /F /Q /A:-S 	"%~1" && set /a files=!files!+1
if exist "%~1"  echo.
goto :eof

:End
@if defined _Stack @for %%a in ( 1 "%~nx0" "%0" ) do @if {"%%~a"}=={"%_Stack%"} @echo [----- %~nx0] commandLine: %0 %* & @echo.