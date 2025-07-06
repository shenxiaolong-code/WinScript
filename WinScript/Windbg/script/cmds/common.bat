@if {"%_Echo%"}=={"1"} ( @echo on ) else ( @echo off )
:: set _Debug=1

set cmds=%~nx0 %*
if defined _Debug echo %cmds%
call :%~1 %2 %3 %4 %5 %6 %7 %8 %9
goto :END

:createFolder
if not  exist "%~f1" md "%~f1"
if not  exist "%~f1" echo Fails to create folder "%~f1"
goto :eof

:gitRepo
if not  exist "%~f1" goto :END
set NotAdmin=1
call %myWinScriptPath%\Windbg\tools_windbg.bat pdbInfo "%~f1" gitStream
set NotAdmin=
goto :eof

:gitBlame
:: gitBlame "E:\work\sourceCode\Jabber140" "j:\jabber\products\jabber-win\src\plugins\contactssearchplugin\contacttree.cpp(340)+0x2a"
set "srcInfo=%~2"
set "dummy=%srcInfo:\=" & set "srcInfo=%"
set "fileName=%srcInfo:(=" & set "lineInfo=%"
set "line=%lineInfo:)=" & set "dummy=%"
for /f "usebackq tokens=*" %%i in ( ` dir/s/b "%~1\%fileName%" ` ) do if not defined fileFullPath set "fileFullPath=%%~i"
if not defined fileFullPath goto :eof
:: start git-gui.exe blame -L %line% "%fileFullPath%"
::       git.exe -C "E:\work\sourceCode\Jabber140"     blame "E:\work\sourceCode\Jabber140\products\jabber-win\src\plugins\ContactsSearchPlugin\ContactTree.cpp" -n -L340,+4
:: start git.exe -C "E:\work\sourceCode\Jabber140" gui blame "E:\work\sourceCode\Jabber140\products\jabber-win\src\plugins\ContactsSearchPlugin\ContactTree.cpp"
set "_tmpBlameFile=%temp%\gitblame_%random%.txt"
git.exe -C "%~1" blame "%fileFullPath%" -n -L%line%,+4 > "%_tmpBlameFile%"
for /f "usebackq tokens=1" %%i in ( ` type "%_tmpBlameFile%" ` ) do if not defined commitID set "commitID=%%~i"
if defined commitID set commitID=%commitID:~1%
echo repo       : %~1
echo file path  : %fileFullPath%
echo line       : %line%
echo commitID   : %commitID%
set curCmd=start /B git.exe -C "%~1" gui blame "%fileFullPath%" -L%line%,+10
echo %curCmd%
%curCmd%
goto :eof

:getDateString
set noEcho=1
::set dtFormat=yyyyMMdd_HHmmss
set dtFormat=yyyyMMdd
for /F "usebackq" %%i in ( ` powershell -Command "Get-Date -format %dtFormat%" ` ) do @echo %%i
goto :eof

:gotoFile
echo open file : "%~f1"
start explorer.exe /select, "%~f1"
rem for /f "usebackq tokens=1,2,*" %%i in ( ` type "%~fs1" `) do start explorer.exe /select, "%%k"
goto :eof

:gotoFileFromClip
for /f "usebackq tokens=*" %%1 in (` powershell Get-Clipboard` ) do set "clipString=%%1"
if defined _Debug echo clipString=%clipString%
call set "filePath=%%clipString:%~1=%%"
call :gotoFile "%filePath%"
echo. | clip
goto :eof

:gotoFileFromVar
:: echo %0 %*
:: echo batVar=%batVar%
:: batVar=    Loaded symbol image file: C:\WINDOWS\SYSTEM32\ntdll.dll
for /f "tokens=*" %%1 in ( "%batVar%" ) do set "pathString=%%~1"
if defined _Debug echo pathString=%pathString%
call set "filePath=%%pathString:%~1=%%"
::echo Open module : "%filePath%"
call :gotoFile "%filePath%"
goto :eof

:gotoFolder
explorer.exe "%~f1"
goto :eof

:curFuncName
::echo "%addrSrc%"
for /f "tokens=1 delims=+" %%i in ( "%addrSrc%" ) do set "addrFunc=%%i"
for /f "tokens=1*" %%i in ( "%addrFunc%" ) do set "funcName=%%j"
::echo "%funcName: =%"
:: if it is template function, the error will occur.
:: e.g. set "addrSrc=(677b8b40)   WCLDll!AT::CSubClassMgr<AT::CWndMsgMap,HWND__ *>::SendProcMessage+0x5e   |  (677b8bd0)   WCLDll!AT::CWclScrollImpl<AT::CWclWin>::SendScrollRangeMessage"
:: if add "" to avoid error, the uf/x command will be invalid
:: here using the set /p to output possible template function name , and using @!"funcName" to represent the template function name in windbg script.
:: e.g. uf @!"${curFN}"
:: if here is special function , e.g. templateFunc<T1, T2> whose name has blank char, we remove the blank char because the windbg script might is using the .foreach command.
:: echo "%funcName: =%"
set /p "=%funcName: =%"<nul&echo.
goto :eof

:curFuncAddr
::echo "%addrSrc%"
for /f "tokens=1 delims=^|" %%i in ( "%addrSrc%" ) do set "addrFunc=%%i"
set fucAddr=0x%addrFunc:~1,8%
echo %fucAddr%
goto :eof

:debugNewSession
for /f "usebackq delims=' tokens=2" %%1 in (` powershell Get-Clipboard` ) do set "newCmds=%%1"
set "dummVar=%newCmds: -logo =" & call :debugNewSession.parseLog %
if defined _Debug echo %newCmds%
if not defined NoRunNewSession start "" %newCmds%
echo. | clip
goto :eof

:debugNewSession.parseLog
if {"%~1"}=={""} goto :eof
set dbgLog=%~nx1
set "dbgLogPrefix=%dbgLog:_windbg=" & set dummVar=%
for /F "usebackq" %%i in ( ` powershell -Command "Get-Date -format yyyyMMdd_HHmmss" ` ) do set newDbgLog=%dbgLogPrefix%_windbg_%%i.log
call set newCmds=%%newCmds:%dbgLog%=%newDbgLog%%%
goto :eof

:moduleListInCurThread
:: parse clip from : .shell -ci "?? @$tid;kc" clip
:: echo %0 %*
if not exist "%~dp1" md "%~dp1"
set "manifestFilter=%~f1"
if exist "%manifestFilter%"  del /f/q "%manifestFilter%"
for /f "delims=! tokens=1*" %%i in ('powershell Get-Clipboard ^| find /i "!"')   do call :moduleListInCurThread.oneModule %%i
goto :eof

:moduleListInCurThread.oneModule
if defined %~2 goto :eof
echo %~2 >> "%manifestFilter%"
set %~2=%~1
goto :eof

:queryVSVer
::echo %0 %*
for /f "eol=; tokens=*" %%i in ('powershell Get-Clipboard') do set "_windbgCLip=%%i"
::echo _windbgCLip=%_windbgCLip%
if not {"%_windbgCLip:Microsoft Visual Studio 14.0=%"}=={"%_windbgCLip%"} echo 2015
if not {"%_windbgCLip:Microsoft Visual Studio 9.0=%"}=={"%_windbgCLip%"} echo 2008
if not {"%_windbgCLip:2017=%"}=={"%_windbgCLip%"} echo 2017
goto :eof

:END
::if not defined noEcho echo %cmds%