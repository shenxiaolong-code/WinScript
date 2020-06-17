::Author    : Shen Xiaolong((xlshen@126.com))
::Copyright : free use,modify,spread, but MUST include this original two line information(Author and Copyright).

::@set _Echo=1
::set _Stack=%~nx0
@if {%_Echo%}=={1} ( @echo on ) else ( @echo off )
@if defined _Stack @for %%a in ( 1 "%~nx0" "%0" ) do @if {"%%~a"}=={"%_Stack%"} @echo. & @echo [+++++ %~nx0] commandLine: %0 %*
where "%~nx0" 1>nul 2>nul || set "path=%~dp0;%path%"

set cmds_%~n0="%~fs0" %*
if {%1}=={} call :Test  & goto End
::if {%1}=={} call :Test NoOutput & goto End
call :%1 %2 %3 %4 %5 %6 %7 %8 %9
goto :End

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
echo test call :checkFileExist "%~f0"
call :checkFileExist "%~f0"

echo.
echo test call :checkFileExist "%~f0" "%~f0" mark22
call :checkFileExist "%~f0" "%~f0" mark22

echo.
echo test call :checkParamCount 2 "%~dp0" 2
call :checkParamCount 2 "%~dp0" 2

echo.
echo test call :checkCallerInfo 1 "hellon, one parameter"
call :checkCallerInfo 1 "hello, one parameter" "%~fs0" mark33

echo.
echo test call :checkCallerInfo 2 "hellon, two parameter"
call :checkCallerInfo 2 "hello, two parameter" abcdef "%~fs0" mark44

echo.
echo test call :checkCallerInfo 1 "hellon, one parameter"
call :checkCallerInfo 1 "hello, one parameter"

echo.
echo test call :checkSupportedCmd "both" ";debug;release;both;"
call :checkSupportedCmd "both"  ";debug;release;both;"
echo.
echo test call :checkSupportedCmd "debug"  ";debug;release;both;" "%~f0" "checkSupportedCmd111"
call :checkSupportedCmd "debug"  ";debug;release;both;" "%~f0" "checkSupportedCmd111"

echo.
echo test call :showLineInfo "%~f0" myUnique
call :showLineInfo "%~f0" myUnique

echo.
echo test call :checkEnvVarDefine WinScriptPath "%~f0" WinScriptPathmark
call :checkEnvVarDefine WinScriptPath "%~f0" WinScriptPathmark

goto :eof


::[DOS_API:checkCallerInfo] show caller information, first parameter is mini expected parameter number. last two parameters is possible file and line No info.
::call e.g  : call :checkCallerInfo totalParamNum  Variadic "%~f0" "uniqueMark"
::            call :checkCallerInfo 1  "hello,example"
::            call :checkCallerInfo 1  "hello,example" "%~f0" "uniqueMark"
::            call :checkCallerInfo 1  "hello,example" "D:\temp\tools_error.bat" "uniqueMark"
:checkCallerInfo
@if defined _Stack @for %%a in ( 1 "%~nx0" "%0" ) do @if {"%%~a"}=={"%_Stack%"} @echo [      %~nx0] commandLine: %0 %*
::min 3 parameter is required
if {"%~3"}=={""} goto :eof
call :ParamCount.get %*
set /a _tmpParamNumIncludeLineInfo=%~1+3
if {"%argC%"}=={"%_tmpParamNumIncludeLineInfo%"} call :checkCallerInfo.showLineInfo %*
goto :eof

:checkCallerInfo.showLineInfo
@if defined _Stack @for %%a in ( 1 "%~nx0" "%0" ) do @if {"%%~a"}=={"%_Stack%"} @echo [      %~nx0] commandLine: %0 %*
set /a _tmpFileIdx=%argC%-1
call set _tmpFile=%%~%_tmpFileIdx%
call set _tmpNo=%%~%argC%
call tools_message.bat enableDebugMsg "%~0" "%_tmpFile%" "%_tmpNo%"
call :showLineInfo "%_tmpFile%" "%_tmpNo%"
goto :eof

::[DOS_API:showLineInfo] show specific line info of specific file
::call e.g  : call :showLineInfo "%~f0" "uniqueMark"
:showLineInfo
@if defined _Stack @for %%a in ( 1 "%~nx0" "%0" ) do @if {"%%~a"}=={"%_Stack%"} @echo [      %~nx0] commandLine: %0 %*
call :checkParamCount 2 %*
call :checkFileExist "%~f1"
call tools_txtFile.bat ShowLineNo "%~f1" "%~2"
goto :eof


::[DOS_API:checkSupportedCmd] check whether the cmd is in supported cmd set.
::call e.g  : call :checkSupportedCmd curCmd  cmdSet
::          : call :checkSupportedCmd "debug"  ";debug;release;both;"
::          : call :checkSupportedCmd "debug"  ";debug;release;both;" "%~f0" "checkSupportedCmdMark"
:checkSupportedCmd
@if defined _Stack @for %%a in ( 1 "%~nx0" "%0" ) do @if {"%%~a"}=={"%_Stack%"} @echo [      %~nx0] commandLine: %0 %*
call :checkParamCount 2 %*
set _curCmd=;%~1;
set _cmdSet=%~2
call set testCmds=%%_cmdSet:%_curCmd%=%%
if {"%_cmdSet%"}=={"%testCmds%"} (
call :ParamCount.get %*
call :checkSupportedCmd.output %*
)
goto :eof

:checkSupportedCmd.output
@if defined _Stack @for %%a in ( 1 "%~nx0" "%0" ) do @if {"%%~a"}=={"%_Stack%"} @echo [      %~nx0] commandLine: %0 %*
if {"%argC%"}=={"4"} call :showLineInfo "%~f3" "%~4"
call tools_message.bat errorMsg "command '%_curCmd%' is not in supported cmdSet[%_cmdSet%] , pls check "
goto :eof

::[DOS_API:checkPathExist] show file doesn't exist error
::call e.g  : call :checkPathExist "C:\mySvnProject\main.cpp"
::          : call :checkPathExist "d:\temp.txt"  "%~f0" checkPathExistMark
:checkPathExist
@if defined _Stack @for %%a in ( 1 "%~nx0" "%0" ) do @if {"%%~a"}=={"%_Stack%"} @echo [      %~nx0] commandLine: %0 %*
if {"%~1"}=={""} call tools_message.bat errorMsg "file parameter is empty"
call tools_path.bat isPathExist "%~1"
if {"%errorlevel%"}=={"0"} (
call :ParamCount.get %*
call :checkPathExist.output %*
)
goto :eof

:checkPathExist.output
@if defined _Stack @for %%a in ( 1 "%~nx0" "%0" ) do @if {"%%~a"}=={"%_Stack%"} @echo [      %~nx0] commandLine: %0 %*
if {"%argC%"}=={"3"} call :showLineInfo "%~f2" "%~3"
call echo %%cmds_%~n0%%
call tools_message.bat errorMsg "file[%~1] doesn't exist. script exit."
goto :eof

::[DOS_API:checkFileExist] show file doesn't exist error
::call e.g  : call :checkFileExist "C:\mySvnProject\main.cpp"
::          : call :checkFileExist "C:\mySvnProject\main"
:checkFileExist
@if defined _Stack @for %%a in ( 1 "%~nx0" "%0" ) do @if {"%%~a"}=={"%_Stack%"} @echo [      %~nx0] commandLine: %0 %*
call :checkEmptyParam %*
set _tmpbExist=
call tools_path.bat isFileExist "%~f1" _tmpbExist
if not {"%_tmpbExist%"}=={"1"} (
call echo %%cmds_%~n0%%
call tools_message.bat errorMsg "file[%~f1] doesn't exist"
)
goto :eof

::[DOS_API:checkFolderExist] check parameter is existing folder
::call e.g  : call :checkFolderExist "C:\mySvnProject"
::          : call :checkFolderExist "C:\mySvnProject\"
:checkFolderExist
@if defined _Stack @for %%a in ( 1 "%~nx0" "%0" ) do @if {"%%~a"}=={"%_Stack%"} @echo [      %~nx0] commandLine: %0 %*
call :checkEmptyParam %*
set _tmpbExist=
call tools_path.bat isFolderExist "%~1" _tmpbExist
if {"%_tmpbExist%"}=={"0"} (
call echo %%cmds_%~n0%%
call tools_message.bat errorMsg "directory[%~f1] doesn't exist"
)
goto :eof

::[DOS_API:runAsAdmin] prompt must run with administrator
::call e.g  : call :runAsAdmin
::            call :runAsAdmin "%~f0" "uniqueMark2"
:checkAdmin
@if defined _Stack @for %%a in ( 1 "%~nx0" "%0" ) do @if {"%%~a"}=={"%_Stack%"} @echo [      %~nx0] commandLine: %0 %*
net session 1>nul 2>nul
if not %errorLevel%==0 (
call colorTxt.bat 0b "MUST run this script with administrator privilege"
echo.
::call tools_message.bat errorMsg "MUST run this script with administrator privilege"
call :runAsAdmin %*
)
goto :eof

:runAsAdmin
@if defined _Stack @for %%a in ( 1 "%~nx0" "%0" ) do @if {"%%~a"}=={"%_Stack%"} @echo [      %~nx0] commandLine: %0 %*
call colorTxt.bat 0c "re-run command with administrator privilege automatically:" & echo.
echo %*
call tools_string.bat toLowerVar "%~x1" _tmpLowerExt
call :checkSupportedCmd "%_tmpLowerExt%" ";.bat;.cmd;.exe;.com;" "%~f0" "runAsAdminMark"
where runAsAdmin.exe 1>nul 2>nul || set path=%~dp0bin;%path%;
if {"%_tmpLowerExt%"}=={".bat"} call :Elevate.shell %*
if {"%_tmpLowerExt%"}=={".cmd"} call :Elevate.shell %*
if {"%_tmpLowerExt%"}=={".exe"} call :Elevate.app %*
if {"%_tmpLowerExt%"}=={".com"} call :Elevate.app %*
set _tmpLowerExt=
call tools_message.bat noSleepMsg "%~0" 8
exit
goto :eof

:runAsAdmin2
rem use powershell to get administrator privilege
@if defined _Stack @for %%a in ( 1 "%~nx0" "%0" ) do @if {"%%~a"}=={"%_Stack%"} @echo [      %~nx0] commandLine: %0 %*
call colorTxt.bat 0c "re-run command with administrator privilege automatically:" & echo.
echo %*
powershell start -verb runas %*
exit
goto :eof

::[DOS_API:runAsAdminAlways]set app run with administrator Privilege
::usage     : call :runAsAdminAlways appPath allUser
::call e.g. : call :runAsAdminAlways "C:\myPath\myApp.exe"
::          : call :runAsAdminAlways "C:\myPath\myApp.exe" allUser
:runAsAdminAlways
@if defined _Stack @for %%a in ( 1 "%~nx0" "%0" ) do @if {"%%~a"}=={"%_Stack%"} @echo [      %~nx0] commandLine: %0 %*
::https://www.verboon.info/2011/03/running-an-application-as-administrator-or-in-compatibility-mode/
::https://social.technet.microsoft.com/Forums/en-US/9f3c34be-2d01-416a-8143-c7ff9e325a24/how-to-set-compatibility-mode-of-an-exe-file?forum=ITCG
call tools_error.bat checkFileExist "%~fs1"
if not defined DefaultMode set DefaultMode=HKEY_CURRENT_USER
if {"%~2"}=={""} (
set curUser=%DefaultMode%
) else (
set curUser=HKEY_LOCAL_MACHINE
)
set regKeyPath=%curUser%\Software\Microsoft\Windows NT\CurrentVersion\AppCompatFlags\Layers
REG.EXE ADD "%regKeyPath%" /v "%~fs1" /t REG_SZ /d "~ RUNASADMIN" /f 1>nul 2>nul && echo sucessfull to set %~nx1 run with administrator || echo fails to set %~nx1 run with administrator.
goto :eof

:Elevate.shell
@if defined _Stack @for %%a in ( 1 "%~nx0" "%0" ) do @if {"%%~a"}=={"%_Stack%"} @echo [      %~nx0] commandLine: %0 %*
call :Elevate.shell.checkScriptPath %1
runAsAdmin.exe cmd.exe /C call %*
goto :eof

:Elevate.shell.checkScriptPath
@if defined _Stack @for %%a in ( 1 "%~nx0" "%0" ) do @if {"%%~a"}=={"%_Stack%"} @echo [      %~nx0] commandLine: %0 %*
set scriptPath=%~1
if not {%scriptPath%}=={%scriptPath: =%} call tools_message.bat warningMsg "script path include blank, it might cause unexcepted result."
goto :eof

:Elevate.app
@if defined _Stack @for %%a in ( 1 "%~nx0" "%0" ) do @if {"%%~a"}=={"%_Stack%"} @echo [      %~nx0] commandLine: %0 %*
runAsAdmin.exe %*
goto :eof

::[DOS_API:checkEnvVarDefine] check whether environment is defined
::call e.g  : call :checkEnvVarDefine envVar
::e.g.        call :checkEnvVarDefine WinScriptPath
:checkEnvVarDefine
@if defined _Stack @for %%a in ( 1 "%~nx0" "%0" ) do @if {"%%~a"}=={"%_Stack%"} @echo [      %~nx0] commandLine: %0 %*
call :checkEmptyParam %*
if not defined %~1 call tools_message.bat errorMsg "environment variabe[%~1] is not defined, pls check." %2 %3
goto :eof

::[DOS_API:checkEmptyParam] empty parameter error message
::call e.g  : call tools_error.bat checkEmptyParam
::            call tools_error.bat checkEmptyParam %*
:checkEmptyParam
@if defined _Stack @for %%a in ( 1 "%~nx0" "%0" ) do @if {"%%~a"}=={"%_Stack%"} @echo [      %~nx0] commandLine: %0 %*
if {"%~1"}=={""} call tools_message.bat errorMsg "empty parameter is not allowned" %*
goto :eof

::[DOS_API:checkParamCount] check whether there is N parameters
::call e.g  : call :checkParamCount 5 %*
::            check at least has 5 parameters  
:checkParamCount
@if defined _Stack @for %%a in ( 1 "%~nx0" "%0" ) do @if {"%%~a"}=={"%_Stack%"} @echo [      %~nx0] commandLine: %0 %*
if {"%~1"}=={""} goto :eof
set /a _tmpMinParamNum=%~1+1
call :ParamCount.get %*
if %_tmpMinParamNum% GTR %argC% call tools_message.bat errorMsg "parameters is not enough.[%_tmpMinParamNum% is greater than %argC%]"
goto :eof

:: ***************************************************************************************************
:ParamCount.get
@if defined _Stack @for %%a in ( 1 "%~nx0" "%0" ) do @if {"%%~a"}=={"%_Stack%"} @echo [      %~nx0] commandLine: %0 %*
set /a argC=0
for %%x in (%*) do Set /a argC+=1
goto :eof

:End
@if defined _Stack @for %%a in ( 1 "%~nx0" "%0" ) do @if {"%%~a"}=={"%_Stack%"} @echo [----- %~nx0] commandLine: %0 %* & @echo.