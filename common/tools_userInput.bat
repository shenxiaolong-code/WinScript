::Author    : Shen Xiaolong((xlshen@126.com))
::Copyright : free use,modify,spread, but MUST include this original two line information(Author and Copyright).

:: @set _Echo=1
:: set _Stack=%~nx0
@if {"%_Echo%"}=={"1"} ( @echo on ) else ( @echo off )
@if defined _Stack @for %%a in ( 1 "%~nx0" "%0" ) do @if {"%%~a"}=={"%_Stack%"} @echo. & @echo [+++++ %~nx0] commandLine: %0 %*
where "%~nx0" 1>nul 2>nul || set "path=%~dp0;%path%"

if {%1}=={} call :Test NoOutput & goto End
call :%~1 %2 %3 %4 %5 %6 %7 %8 %9
goto End

::******************************DOS API section**************************************************************************
::[DOS_API:waitString]wait user to input string
::usage         : call tools_userInput.bat waitString outVar bCanbeEmpty
::outVar        : output var
::bCanbeEmpty   : check input can be empty, non 1 mean cann't be empty -- return without any input (except \r\n)
::example       : call tools_userInput.bat waitString myDir1           //myDir1 can not be empty
::                call tools_userInput.bat waitString myDir2   1       //myDir2 can be empty
:waitString
@if defined _Stack @for %%a in ( 1 "%~nx0" "%0" ) do @if {"%%~a"}=={"%_Stack%"} @echo [      %~nx0] commandLine: %0 %*
call set %~1=
call :waitString.loop %~2
call set %~1=%_waitUserInput%
call tools_message.bat enableDebugMsg "%~0" "set %~1=%_waitUserInput%"
call set _waitUserInput=
goto :eof

::[DOS_API:waitNumber]wait user to input number, any non digital will be filtered
::usage         : call tools_userInput.bat waitNumber outVar bCanbeEmpty
::outVar        : output var
::bCanbeEmpty   : check input can be empty, non 1 mean cann't be empty -- return without any input (except \r\n)
::example       : call tools_userInput.bat waitNumber myDir1           //myDir1 can not be empty
::                call tools_userInput.bat waitNumber myDir2   1       //myDir2 can be empty
:waitNumber
@if defined _Stack @for %%a in ( 1 "%~nx0" "%0" ) do @if {"%%~a"}=={"%_Stack%"} @echo [      %~nx0] commandLine: %0 %*
call :waitString %*
if not defined %~1 goto :eof
call tools_isXXX.bat isNumber "%%%~1%%" _tmpIsNum
if not {"%_tmpIsNum%"}=={"1"} (
call tools_message.bat NotifyMsg "'%%%~1%%' is not one number, please only input number , range [0 -9 ]."
goto :waitNumber %*
)
goto :eof

::[DOS_API:waitPath] wait user to input one existed path.
::usage         : call waitPath outVar checkFolderExist
::example       : call waitPath outVar checkFileExist
:waitPath
@if defined _Stack @for %%a in ( 1 "%~nx0" "%0" ) do @if {"%%~a"}=={"%_Stack%"} @echo [      %~nx0] commandLine: %0 %*
if defined waitPathPrompt  echo %inputPathPrompt%
if defined waitPathPrompt2 echo %inputPathPrompt2%
call set %~1=
call :waitString %~1
set customized_exitHandler=echo retry...
call tools_error.bat %~2 "%%%~1%%"
if not {"%errorlevel%"}=={"1"} goto :waitPath %*
call tools_message.bat enableDebugMsg "%~0" "set %~1=%%%~1%%"
set customized_exitHandler=
goto :eof

::[DOS_API:waitPathFolder]wait user to input one file path, if non-current directory, MUST full path
::usage         : call tools_userInput.bat waitPathFolder outVar
::outVar        : output var
::example       : call tools_userInput.bat waitPathFolder filePath
:waitPathFolder
@if defined _Stack @for %%a in ( 1 "%~nx0" "%0" ) do @if {"%%~a"}=={"%_Stack%"} @echo [      %~nx0] commandLine: %0 %*
call tools_error.bat checkParamCount 1 %*
if defined waitPathFolderPrompt  set inputPathPrompt=%waitPathFolderPrompt%
if defined waitPathFolderPrompt2 set inputPathPrompt2=%waitPathFolderPrompt2%
call :waitPath %* checkFolderExist
goto :eof

::[DOS_API:waitPathFile]wait user to input any file path, if non-current directory, MUST full path
::usage         : call tools_userInput.bat waitPathFile outVar
::outVar        : output var
::example       : call tools_userInput.bat waitPathFile filePath
:waitPathFile
@if defined _Stack @for %%a in ( 1 "%~nx0" "%0" ) do @if {"%%~a"}=={"%_Stack%"} @echo [      %~nx0] commandLine: %0 %*
call tools_error.bat checkParamCount 1 %*
if defined inputFilePrompt  set inputPathPrompt=%inputFilePrompt%
if defined inputFilePrompt2 set inputPathPrompt2=%inputFilePrompt2%
call :waitPath %* checkFileExist
goto :eof

::[DOS_API:waitPathFileSpec]wait user to input specified(e.g.myApp.exe) file path, if non-current directory, MUST full path
::usage         : call tools_userInput.bat waitPathFileSpec outVar
::outVar        : output var
::example       : call tools_userInput.bat myApp.exe filePath
:waitPathFileSpec
@if defined _Stack @for %%a in ( 1 "%~nx0" "%0" ) do @if {"%%~a"}=={"%_Stack%"} @echo [      %~nx0] commandLine: %0 %*
call tools_error.bat checkParamCount 2 %*
if defined waitPathFileSpecPrompt      echo %waitPathFileSpecPrompt%
if defined waitPathFileSpecPrompt2     echo %waitPathFileSpecPrompt2%
call :waitPathFileSpec.execute %*
goto :eof

::[DOS_API:waitBackspace]get the back space char, it is used to erase printed string in console window.
::usage         : call tools_userInput.bat waitBackspace outVar
::outVar        : output var
::example       : call tools_userInput.bat waitBackspace bkChar
::                echo %myString%%bkChar%%bkChar%                                       //will not display last chars in %myString%.
::                set /p "=12345" <nul & <nul  set /p "=%bkChar%%bkChar%%bkChar%"      //will only show 1234
:waitBackspace
@if defined _Stack @for %%a in ( 1 "%~nx0" "%0" ) do @if {"%%~a"}=={"%_Stack%"} @echo [      %~nx0] commandLine: %0 %*
for /F "tokens=1 delims=#" %%a in ('"prompt #$H# & echo on & for %%b in (1) do rem"') do set "%~1=%%~a"
goto :eof

::[DOS_API:waitBackspaceN]base on waitBackspace, get more than one char back space string.
::usage         : call tools_userInput.bat waitBackspace outVar N
::outVar        : output var
::example       : call tools_userInput.bat waitBackspace bkChar 5
::                echo %myString%%bkChar%%bkChar% will not display last chars in %myString%.
:waitBackspaceN
@if defined _Stack @for %%a in ( 1 "%~nx0" "%0" ) do @if {"%%~a"}=={"%_Stack%"} @echo [      %~nx0] commandLine: %0 %*
set _tmpBkchar=
call :waitBackspace _tmpBkchar
for /L %%i in ( 1 1 %~2 ) do call :waitBackspaceN.addOne %~1
goto :eof

::[DOS_API:waitConfirm]wait user to input , and give one confirm.
::usage         : call tools_userInput.bat waitConfirm outVar bCanbeEmpty
::outVar        : output var
::bCanbeEmpty   : check input can be empty, non 1 mean cann't be empty -- return without any input (except \r\n)
::example       : call tools_userInput.bat waitConfirm waitNumber myDir1           //myDir1 can not be empty
::                call tools_userInput.bat waitConfirm waitString myDir2   1       //myDir2 can be empty
:waitConfirm
@if defined _Stack @for %%a in ( 1 "%~nx0" "%0" ) do @if {"%%~a"}=={"%_Stack%"} @echo [      %~nx0] commandLine: %0 %*
call :%*
call :waitConfirm.confirm %*
goto :eof

::[DOS_API:waitSelect]get user input char in choice command,used to limit user input range to avoid invald data
::usage         : call tools_userInput.bat waitSelect optSet selChar
::optSet        : option set, user can select only one in this set
::selChar       : output user select char
::example       : call tools_userInput.bat waitSelect abcdef selChar
::                user input d in console window
::result e.g    : set selChar=d
:waitSelect
@if defined _Stack @for %%a in ( 1 "%~nx0" "%0" ) do @if {"%%~a"}=={"%_Stack%"} @echo [      %~nx0] commandLine: %0 %*
call tools_error.bat checkParamCount 2 %*
set _tmpChoiceSet=%~1
choice /c %_tmpChoiceSet% /M "Please select one item "
set returnCode=%errorlevel%
if %returnCode% EQU 0 (
@echo user break this job.
goto :eof
)
if %returnCode% EQU 255 (
call tools_message.bat errorMsg "DOS inner error occurs."
echo.
goto :eof
)
set /a _tmpSelIdx=%returnCode%-1
call set %~2=%%_tmpChoiceSet:~%_tmpSelIdx%,1%%
goto :eof


::[DOS_API:waitSelectWithTimeout]get user input char in choice command,used to limit user input range to avoid invald data
::usage         : call tools_userInput.bat waitSelectWithTimeout "choiceText" selChar "promptText" defaultSelect timeout
::choiceText    : option set, devided by char ;
::selChar       : output user select char, the select option text saved in variabe choiceArray[%selChar%]
::example       : call tools_userInput.bat waitSelectWithTimeout "choice1;choice2;choiceX;choiceY;choiceZ" selChar "please make your selected:" 0 6
::                call tools_userInput.bat waitSelectWithTimeout "choice1;choice2;choiceX;choiceY;choiceZ" selChar
::                user input 2 in console window
::result e.g    : set selChar=2
:waitSelectWithTimeout
@if defined _Stack @for %%a in ( 1 "%~nx0" "%0" ) do @if {"%%~a"}=={"%_Stack%"} @echo [      %~nx0] commandLine: %0 %*
call :waitSelectWithTimeout.reset
set "_tmpChoiceListText=%~1"
call :waitSelectWithTimeout.addItem "%_tmpChoiceListText:;=" & call :waitSelectWithTimeout.addItem "%"
for /L %%i in (0 1 %_tmpChoiceN%)  do call :waitSelectWithTimeout.showItem %%i
if not {"%~3"}=={""} set "_tmpChoiceOpt=/M "%~3""
if not {"%~4"}=={""} set "_tmpChoiceOpt=/D %~4 /T 30 /M "%~3,%~4 will be selected automatically after 30 seconds:""
if not {"%~5"}=={""} set "_tmpChoiceOpt=/D %~4 /T %~5 /M "%~3,%~4 will be selected automatically after %~5 seconds:""
choice /c %_tmpChoiceListNum% %_tmpChoiceOpt%
set /a _tmpChoiceSel=%errorlevel%-1
set %~2=%_tmpChoiceSel%
call tools_message.bat enableDebugMsg "%~0" "your choice :  %%_tmpChoiceArray[%_tmpChoiceSel%]%%"
goto :eof

::[DOS_API:readClipboard] read string from system clip board.
::usage         : call readClipboard outVar
::example       : call readClipboard outVar
:readClipboard
@if defined _Stack @for %%a in ( 1 "%~nx0" "%0" ) do @if {"%%~a"}=={"%_Stack%"} @echo [      %~nx0] commandLine: %0 %*
set "_tmpReadClipboard=%~1"
for /f "eol=; tokens=*" %%i in ('powershell Get-Clipboard') do call :readClipboard.trim %%i
goto :eof

::[DOS_API:processClipboard] read clipboard data and verify / show some info
::usage     : call :processClipboard <outVar>
::e.g.      : call :processClipboard tmpParam
::            call set tmpParam="C:\myCaache\srdcws1087"   "findFile"
:processClipboard
:: call :task.processClipboard <subCmdName> [optParameter]
@if defined _Stack @for %%a in ( 1 "%~nx0" "%0" ) do @if {"%%~a"}=={"%_Stack%"} @echo [      %~nx0] commandLine: %0 %*
@where tools_userInput.bat 1>nul 2>nul || @set "path=%myWinScriptPath%\common;%path%"
call :readClipboard _tmpClipboardData
if not  defined _tmpClipboardData   call :processClipboard.noData
set _tmpClipboardDataShow=%_tmpClipboardData:"='%
if      defined _tmpClipboardData   call colorTxt.bat "clipboard data : {0d} %_tmpClipboardDataShow% {\n}{#}"
set %~1=%_tmpClipboardData%
goto :eof

::[DOS_API:writeClipboard] write string to system clip board
::usage         : call writeClipboard inVar
::example       : call writeClipboard inVar
:writeClipboard
@if defined _Stack @for %%a in ( 1 "%~nx0" "%0" ) do @if {"%%~a"}=={"%_Stack%"} @echo [      %~nx0] commandLine: %0 %*
echo %~1 | clip
rem if exist special chars
rem powershell Write-Output 'a^|b^|c' | clip
goto :eof

::[DOS_API:setFile2Var]check file should exist, if not, print error info and pause
::call e.g  : call :setFile2Var 1 myFile.txt VarName        //set VarName=C:\temp\myFile.txt permanent
::            call :setFile2Var 0 myFile.txt VarName        //set VarName=C:\temp\myFile.txt temporary (available in current session)
:setFile2Var
@if defined _Stack @for %%a in ( 1 "%~nx0" "%0" ) do @if {"%%~a"}=={"%_Stack%"} @echo [      %~nx0] commandLine: %0 %*
call tools_error.bat checkParamCount 3 %*
if defined setFile2VarPrompt    set waitPathFileSpecPrompt=%setFile2VarPrompt%
if defined setFile2VarPrompt2   set waitPathFileSpecPrompt2=%setFile2VarPrompt2%
call :waitPathFileSpec "%~2" %~3
if {%~1}=={1} call setx %~3 %%%~3%%
goto :eof

::[DOS_API:setFileDirectory2Var]check file should exist, if not, print error info and pause
::call e.g  : call :setFileDirectory2Var 1 myFile.txt  VarName      //add file path to %path% permanent
::            call :setFileDirectory2Var 0 myFile.txt  VarName      //add file path to %path% temporary (available in current session)
:setFileDirectory2Var
@if defined _Stack @for %%a in ( 1 "%~nx0" "%0" ) do @if {"%%~a"}=={"%_Stack%"} @echo [      %~nx0] commandLine: %0 %*
call tools_error.bat checkParamCount 3 %*
if defined %~3 call if exist "%%%~3%%\%~2" exit /b 1

if defined setFileDirectory2VarPrompt    set waitPathFileSpecPrompt=%setFileDirectory2VarPrompt%
if defined setFileDirectory2VarPrompt2   set waitPathFileSpecPrompt2=%setFileDirectory2VarPrompt2%
call :waitPathFileSpec "%~2" filePath
call :setFileDirectory2Var.execute %~1 %~3 %filePath%
goto :eof

::******************************implement  section**************************************************************************
:readClipboard.trim
@if defined _Stack @for %%a in ( 1 "%~nx0" "%0" ) do @if {"%%~a"}=={"%_Stack%"} @echo [      %~nx0] commandLine: %0 %*
if      {"%~2"}=={""} set "%_tmpReadClipboard%=%~1"
if not  {"%~2"}=={""} set %_tmpReadClipboard%=%*
goto :eof

:waitString.loop
if defined waitStringPrompt     echo %waitStringPrompt%
if defined waitStringPrompt2    echo %waitStringPrompt2%
set _waitUserInput=
set /p _waitUserInput=
if not {"%~1"}=={"1"} (
if not defined _waitUserInput (
if not defined emptyInputPrompt set "emptyInputPrompt=input can't be empty, please input again."
echo %emptyInputPrompt%
goto :waitString.loop %~1
)
)
goto :eof

:processClipboard.noData
@if defined _Stack @for %%a in ( 1 "%~nx0" "%0" ) do @if {"%%~a"}=={"%_Stack%"} @echo [      %~nx0] commandLine: %0 %*
if 		defined _noData_OK	set "noDataMsg=no data is in clipboard , and using default setting."
if not 	defined _noData_OK	set "noDataMsg=no data is in clipboard , error and press any key to exit."
call colorTxt.bat  "{02}%noDataMsg%{\n}{#}"
if not 	defined _noData_OK 	pause > nul
if not 	defined _noData_OK 	exit /b 1
goto :eof

:waitConfirm.confirm
@if defined _Stack @for %%a in ( 1 "%~nx0" "%0" ) do @if {"%%~a"}=={"%_Stack%"} @echo [      %~nx0] commandLine: %0 %*
call set _tmpInput=%%%~2%%
call colorTxt.bat purple_L "your input is '%_tmpInput%'"
echo.
if not defined waitStringPromptBakup set "waitStringPromptBakup=%waitStringPrompt%"
set waitStringPrompt=press any key to confirm current input. or input N/n to re-input.
call :waitString confirmQuery 1
set "waitStringPrompt=%waitStringPromptBakup%"
if {"%confirmQuery%"}=={"N"} goto :waitConfirm %*
if {"%confirmQuery%"}=={"n"} goto :waitConfirm %*
set waitStringPromptBakup=
goto :eof

:waitPathFileSpec.execute
@if defined _Stack @for %%a in ( 1 "%~nx0" "%0" ) do @if {"%%~a"}=={"%_Stack%"} @echo [      %~nx0] commandLine: %0 %*
call set %~2=
call :inputFile "%~2"
call :waitPathFileSpec.check "%~1" "%%%~2%%"
if not {"%errorlevel%"}=={"1"} call :waitPathFileSpec %*
goto :eof

:waitPathFileSpec.check
@if defined _Stack @for %%a in ( 1 "%~nx0" "%0" ) do @if {"%%~a"}=={"%_Stack%"} @echo [      %~nx0] commandLine: %0 %*
if not {"%~nx1"}=={"%~nx2"} (
call tools_message.bat warningMsg "wrong file path,the file extension name should be %~1"
exit /b 0
)
exit /b 1
goto :eof

:setFileDirectory2Var.execute
@if defined _Stack @for %%a in ( 1 "%~nx0" "%0" ) do @if {"%%~a"}=={"%_Stack%"} @echo [      %~nx0] commandLine: %0 %*
call :setPath2var %~1 %~3 "%~dp3"
goto :eof


:setFileDirectory2Var
call tools_userInput.bat waitPathFileSpec "jabber.natvis" filePath
set "path=%filePath%;%path%"
goto :eof

:waitSelectWithTimeout.addItem
@if defined _Stack @for %%a in ( 1 "%~nx0" "%0" ) do @if {"%%~a"}=={"%_Stack%"} @echo [      %~nx0] commandLine: %0 %*
if not defined _tmpChoiceN set _tmpChoiceN=-1
set /a _tmpChoiceN+=1
set "_tmpChoiceArray[%_tmpChoiceN%]=%~1"
set _tmpChoiceListNum=%_tmpChoiceListNum%%_tmpChoiceN%
goto :eof

:waitSelectWithTimeout.reset
@if defined _Stack @for %%a in ( 1 "%~nx0" "%0" ) do @if {"%%~a"}=={"%_Stack%"} @echo [      %~nx0] commandLine: %0 %*
if defined _tmpChoiceN for /L %%i in (0 1 %_tmpChoiceN%)  do call set _tmpChoiceArray[%%i]=
set _tmpChoiceListNum=
set _tmpChoiceOpt=
set _tmpChoiceN=
goto :eof

:waitSelectWithTimeout.showItem
@if defined _Stack @for %%a in ( 1 "%~nx0" "%0" ) do @if {"%%~a"}=={"%_Stack%"} @echo [      %~nx0] commandLine: %0 %*
call echo %~1.      %%_tmpChoiceArray[%~1]%%
goto :eof

:waitBackspaceN.addOne
@if defined _Stack @for %%a in ( 1 "%~nx0" "%0" ) do @if {"%%~a"}=={"%_Stack%"} @echo [      %~nx0] commandLine: %0 %*
call set "%~1=%%%~1%%%_tmpBkchar%"
goto :eof
::******************************help  and test  section**********************************************

::[DOS_API:Help]display help information
:Help
@if defined _Stack @for %%a in ( 1 "%~nx0" "%0" ) do @if {"%%~a"}=={"%_Stack%"} @echo [      %~nx0] commandLine: %0 %*
call tools_miscellaneous.bat DisplayHelp "%~f0"
goto :eof

::[DOS_API:Test] Test DOS API in this script file
:Test
@if defined _Stack @for %%a in ( 1 "%~nx0" "%0" ) do @if {"%%~a"}=={"%_Stack%"} @echo [      %~nx0] commandLine: %0 %*
@echo [%~nx0] Run test case [%0 %*]
echo.
echo test call :Help
call :Help
echo.

echo.
echo [skip] test call %~nx0 waitString myDir1
echo call %~nx0 waitString myDir1
echo [skip] test call %~nx0 waitString myDir2 1
echo call %~nx0 waitString myDir2 1

echo.
echo [skip] test call %~nx0 waitPathFile myFilePath
echo call %~nx0 waitPathFile myFilePath

echo.
echo [skip] test call %~nx0 waitSelect abcdef selChar
echo call %~nx0 waitSelect abcdef selChar

goto :eof

::******************************exit section**********************************************
:End
@if defined _Stack @for %%a in ( 1 "%~nx0" "%0" ) do @if {"%%~a"}=={"%_Stack%"} @echo [----- %~nx0] commandLine: %0 %* & @echo.