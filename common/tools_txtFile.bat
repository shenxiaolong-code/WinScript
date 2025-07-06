::Author    : Shen Xiaolong((xlshen@126.com))
::Copyright : free use,modify,spread, but MUST include this original two line information(Author and Copyright).

::@set _Echo=1
::set _Stack=%~nx0
@if {"%_Echo%"}=={"1"} ( @echo on ) else ( @echo off )
@if defined _Stack @for %%a in ( 1 "%~nx0" "%0" ) do @if {"%%~a"}=={"%_Stack%"} @echo. & @echo [+++++ %~nx0] commandLine: %0 %*
where "%~nx0" 1>nul 2>nul || set "path=%~dp0;%path%"

if {%1}=={} call :Test NoOutput & goto End
call :%*
goto End

::[DOS_API:Help]display help information
:Help
@if defined _Stack @for %%a in ( 1 "%~nx0" "%0" ) do @if {"%%~a"}=={"%_Stack%"} @echo [      %~nx0] commandLine: %0 %*
call %~dp0.\tools_miscellaneous.bat DisplayHelp "%~f0"
goto End

::[DOS_API:Test]Test DOS API in this script file
:Test
@if defined _Stack @for %%a in ( 1 "%~nx0" "%0" ) do @if {"%%~a"}=={"%_Stack%"} @echo [      %~nx0] commandLine: %0 %*
@echo [%~nx0] Run test case [%0 %*]
echo.
echo test call :Help
call :Help
echo.



echo.
echo test call :openTxtFile "%~f0"
call :openTxtFile "%~f0"
echo "%~f0" is opened

echo.
echo test call :GetFileLineAccount "%~f0" LineAccount
call :GetFileLineAccount "%~f0" LineAccount
echo there is %LineAccount% in file '%~f0'

echo.
echo test call :FindLineXOfFile 3 "%~f0" LineXTxt
call :FindLineXOfFile 3 "%~f0" LineXTxt
echo No.3 line text : %LineXTxt%
echo.
echo test call :FindLineXOfFile 3 "%~f0"
call :FindLineXOfFile 3 "%~f0"
echo.

echo.
echo test call tools_txtFile.bat GetCurLineNo "%~f0" lineNo1 lineTxt1 mar1
call tools_txtFile.bat GetCurLineNo "%~f0" lineNo1 lineTxt1 mar1
echo lineNo1=%lineNo1%
echo lineTxt1=%lineTxt1%
echo.
echo test call tools_txtFile.bat GetCurLineNo "%~f0" lineNo2 lineTxt2 mar2
call tools_txtFile.bat GetCurLineNo "%~f0" lineNo2 lineTxt2 mar2
echo lineNo2=%lineNo2%
echo lineTxt2=%lineTxt2%

echo.
echo test call tools_txtFile.bat ShowCurLineNo "%~f0" mark3
call tools_txtFile.bat ShowCurLineNo "%~f0" mark3
echo.
echo test call tools_txtFile.bat ShowCurLineNo "%~f0" mark4
call tools_txtFile.bat ShowCurLineNo "%~f0" mark4

echo.
echo test call tools_txtFile.bat ShowLineNo "%~dp0.\tools_string.bat" testhasSubString1
call tools_txtFile.bat ShowLineNo "%~dp0.\tools_string.bat" testhasSubString1
echo.
echo test call tools_txtFile.bat ShowLineNo "%~dp0.\tools_string.bat" testhasSubString2
call tools_txtFile.bat ShowLineNo "%~dp0.\tools_string.bat" testhasSubString2

goto :eof

::[DOS_API:FindLineXOfFile]find No.x line in one file and save it into specified variable name
::usage     : call :FindLineXOfFile LineNo FileFullPath VarName
::call e.g. : call :FindLineXOfFile 3 "C:\tmp\myfile.txt" VarName
:FindLineXOfFile
@if defined _Stack @for %%a in ( 1 "%~nx0" "%0" ) do @if {"%%~a"}=={"%_Stack%"} @echo [      %~nx0] commandLine: %0 %*
if not exist %~s2 call %~sdp0.\tools_message.bat popMsg "%~2 doesn't exist,pls check". & goto :eof
call :GetFileLineAccount "%~s2" Lines
if %~1 GTR %Lines% call %~sdp0.\tools_message.bat popMsg "index[%~1] is greater than total lines[%Lines%],pls check cmd[:FindLineXOfFile]". & goto :eof
set /a varFindLineXOfFile=%~1-1
call tools_miscellaneous.bat Clear_Environment_Variable tmpFindLineXOfFile
if %varFindLineXOfFile% GTR 0 (
for /f "usebackq tokens=* skip=%varFindLineXOfFile% " %%k in ( `type %~s2` ) do ( if not defined tmpFindLineXOfFile set tmpFindLineXOfFile=%%k )
) else (
for /f "usebackq tokens=*" %%k in ( `type %~s2` ) do ( if not defined tmpFindLineXOfFile set tmpFindLineXOfFile=%%k )
)
if {%~3}=={} (
echo %tmpFindLineXOfFile%
) else (
set %~3=%tmpFindLineXOfFile%
)
goto :eof

::[DOS_API:DumpHexChar] show the hex char of file, used to check illegel chars
::usage     : call :DumpHexChar FileFullPat
::call e.g. : call :DumpHexChar "C:\tmp\myfile.txt"
:DumpHexChar
@if defined _Stack @for %%a in ( 1 "%~nx0" "%0" ) do @if {"%%~a"}=={"%_Stack%"} @echo [      %~nx0] commandLine: %0 %*
if not exist %~fs1 call %~sdp0.\tools_message.bat popMsg "%~f1 doesn't exist,pls check". & goto :eof
type "%~fs1" | format-hex
goto :eof


::[DOS_API:searchAndReplace] in txt file. search specified string and replace it with new string
::                      if third parameter is empty, only erase second string from the file. regulare is supported
::usage     : call :searchAndReplace file1 oldString newString
::e.g.      : call :searchAndReplace d:\1.txt "hello,Tom" "hello,Jerry"
::            call :searchAndReplace d:\1.txt "hello,Tom"  
:searchAndReplace
@if defined _Stack @for %%a in ( 1 "%~nx0" "%0" ) do @if {"%%~a"}=={"%_Stack%"} @echo [      %~nx0] commandLine: %0 %*
::https://askubuntu.com/questions/20414/find-and-replace-text-within-a-file-using-commands
call tools_error.bat checkParamCount 2 %*
call tools_error.bat checkFileExist "%~fs1" "%~fs0" mark_searchAndReplace_1
call tools_path.bat FindAppPathinDisk "sed.exe" _sedPath
rem if not defined _sedPath call tools_message.bat errorMsg "no sed.exe is found in your PC"
call "C:\Program Files\Git\usr\bin\sed.exe" -i 's/%~2/%~3/g' "%~f1"
goto :eof

::[DOS_API:MergeTwoFile]merge two txt file and remove the duplicated lines. known limitation : the max line is lesser than 512 chars.(127 for XP)
::                      include LF/CR char : if it is different in one line, it is treated to two different line.
::usage     : call :MergeTwoFile file1 file2 outfile
::e.g.      : call :MergeTwoFile d:\1.txt c:\2.txt "d:\tmp\3.txt"
:MergeTwoFile
@if defined _Stack @for %%a in ( 1 "%~nx0" "%0" ) do @if {"%%~a"}=={"%_Stack%"} @echo [      %~nx0] commandLine: %0 %*
::https://stackoverflow.com/questions/19816914/how-to-join-two-text-files-removing-duplicates-in-windows
call tools_error.bat checkParamCount 3 %*
call tools_error.bat checkFileExist "%~fs1" "%~fs0" mark_MergeTwoFile_1
call tools_error.bat checkFileExist "%~fs2" "%~fs0" mark_MergeTwoFile_2
copy "%~fs1" "%~fs3" >nul
call findstr /lvxig:"%~fs1" "%~fs2" >> "%~fs3"
goto :eof

::[DOS_API:FindFileAddition]compare two txt file and find addition in second file. known limitation : the max line is lesser than 512 chars.(127 for XP)
::                      include LF/CR char : if it is different in one line, it is treated to two different line.
::usage     : call :FindFileAddition file1 file2 outfile
::e.g.      : call :FindFileAddition d:\1.txt c:\2.txt "d:\tmp\diff.txt"
:FindFileAddition
@if defined _Stack @for %%a in ( 1 "%~nx0" "%0" ) do @if {"%%~a"}=={"%_Stack%"} @echo [      %~nx0] commandLine: %0 %*
call tools_error.bat checkParamCount 3 %*
call tools_error.bat checkFileExist "%~fs1" "%~fs0" mark_MergeTwoFile_1
call tools_error.bat checkFileExist "%~fs2" "%~fs0" mark_MergeTwoFile_2
call findstr /lvxig:"%~fs1" "%~fs2" >> "%~fs3"
goto :eof

::[DOS_API:CompareTwoFiles]compare two txt file and show their difference. known limitation : the max line is lesser than 512 chars.(127 for XP)
::                      include LF/CR char : if it is different in one line, it is treated to two different line.
::usage     : call :CompareTwoFiles file1 file2 outfile
::e.g.      : call :CompareTwoFiles d:\1.txt c:\2.txt "d:\tmp\diff.txt"
:CompareTwoFiles
@if defined _Stack @for %%a in ( 1 "%~nx0" "%0" ) do @if {"%%~a"}=={"%_Stack%"} @echo [      %~nx0] commandLine: %0 %*
call tools_error.bat checkParamCount 3 %*
call tools_error.bat checkFileExist "%~fs1" "%~fs0" mark_MergeTwoFile_1
call tools_error.bat checkFileExist "%~fs2" "%~fs0" mark_MergeTwoFile_2
set tmpFile=%temp%\%~n1%random%
call findstr /lvxig:"%~fs1" "%~fs2" >> "%tmpFile%_1.txt"
call findstr /lvxig:"%~fs2" "%~fs1" >> "%tmpFile%_2.txt"
copy "%tmpFile%_1.txt"+"%tmpFile%_2.txt" "%~fs3" > nul
goto :eof

::[DOS_API:GetFileLineAccount]get line account of one file and set it into varname
::usage     : call :GetFileLineAccount filefullpath varName
::call e.g. : call :GetFileLineAccount "C:\tmp\myfile.txt" LinesNum
:GetFileLineAccount
@if defined _Stack @for %%a in ( 1 "%~nx0" "%0" ) do @if {"%%~a"}=={"%_Stack%"} @echo [      %~nx0] commandLine: %0 %*
if not exist "%~1" call %~sdp0.\tools_message.bat popMsg "file[%1] doesn't exist,pls check". & goto :eof
for /f "usebackq tokens=*" %%i in ( ` findstr /n .* %~s1 ^| find /c ":" ` ) do set tmpGetFileLineAccount=%%i
if {"%~2"}=={""} (
echo %tmpGetFileLineAccount%
) else (
set %~2=%tmpGetFileLineAccount%
)
goto :eof

::[DOS_API:GetCurLineNo]get line account of one file and set it into varname
::usage     : call :GetCurLineNo filefullpath  lineNoVar lineTxtVar uniquePosId
::call e.g. : call :GetCurLineNo "%~f0"  lineNo lineTxt HIIamHere
::Note      : when multile call GetCurLineNo, the uniquePosId is unique mark
::            uniquePosId can't include quoate"" , and blank
:GetCurLineNo
@if defined _Stack @for %%a in ( 1 "%~nx0" "%0" ) do @if {"%%~a"}=={"%_Stack%"} @echo [      %~nx0] commandLine: %0 %*
if not exist "%~f1" call %~sdp0.\tools_message.bat popMsg "file[%1] doesn't exist,pls check". & goto :eof
call tools_message.bat enableDebugMsg "%~0" "findstr /n /B /R /C:'call  *%~nx0  *GetCurLineNo  *\'%%~f0\'  *%2  *%3  *%4' '%~s1'"
for /f "usebackq tokens=1,* delims=: " %%i in ( ` findstr /n /B /R /C:"call  *%~nx0  *GetCurLineNo  *\"%%~f0\"  *%2  *%3  *%4" "%~s1" ` ) do (
set _tmplineNo1=%%i
set _tmplineTxt1=%%j
)
if not {"%3"}=={""} set %3=%_tmplineTxt1%
if not {"%2"}=={""} set %2=%_tmplineNo1%
goto :eof

::[DOS_API:openTxtFile]async open txt file by default accociated application
::usage     : call :openTxtFile filefullpath
::call e.g. : call :openTxtFile "%~f0"
::Note      : if open txt file without application , it is opened sync.
:openTxtFile
@if defined _Stack @for %%a in ( 1 "%~nx0" "%0" ) do @if {"%%~a"}=={"%_Stack%"} @echo [      %~nx0] commandLine: %0 %*
call tools_error.bat checkFileExist "%~fs1"
call tools_appInstallPath.bat FindPathNotepad++  _appPath
if not defined _appPath call tools_message.bat errorMsg "can't find notepad++ install path."
start /b/i "" "%_appPath%\notepad++.exe" "%~fs1"
goto :eof

::[DOS_API:unicode2ascii]convert file from unicode to ascii format
::usage     : call :unicode2ascii srcfilefullpath dstfilefullpath
::call e.g. : call :unicode2ascii "%~f0" "%~f0.txt"
:unicode2ascii
@if defined _Stack @for %%a in ( 1 "%~nx0" "%0" ) do @if {"%%~a"}=={"%_Stack%"} @echo [      %~nx0] commandLine: %0 %*
rem https://www.robvanderwoude.com/type.php#Unicode
call tools_error.bat checkFileExist "%~fs1"
cmd.exe /A /C type  "%~fs1" > "%~fs2"
::CHCP 1252 
::type  "%~fs1" > "%~fs2"
goto :eof

::[DOS_API:ascii2unicode]convert file from ascii to unicode format
::usage     : call :ascii2unicode srcfilefullpath dstfilefullpath
::call e.g. : call :ascii2unicode "%~f0" "%~f0.txt"
:ascii2unicode
@if defined _Stack @for %%a in ( 1 "%~nx0" "%0" ) do @if {"%%~a"}=={"%_Stack%"} @echo [      %~nx0] commandLine: %0 %*
rem https://www.robvanderwoude.com/type.php#Unicode
call tools_error.bat checkFileExist "%~fs1"
cmd.exe /U /C type  "%~fs1" > "%~fs2"
goto :eof

::[DOS_API:ShowCurLineNo]show file path, line number which line begins with regular text : call tools_txtFile.bat ShowCurLineNo "%~f0" uniquePosId
::usage     : call :ShowCurLineNo "%~f0"  uniquePosId
::            the first parameter MUST be "%~f0" , it is different with ShowLineNo which can use specified path file.
::call e.g. : call :ShowCurLineNo "%~f0"  HIIamHere
::Note      : when multile call ShowCurLineNo, the uniquePosId is unique mark
::            uniquePosId can't include quoate"" , and blank
:ShowCurLineNo
@if defined _Stack @for %%a in ( 1 "%~nx0" "%0" ) do @if {"%%~a"}=={"%_Stack%"} @echo [      %~nx0] commandLine: %0 %*
if not exist "%~f1" call %~sdp0.\tools_message.bat popMsg "file[%1] doesn't exist,pls check". & goto :eof
for /f "usebackq tokens=1,* delims=: " %%i in ( ` findstr /n /B /R /C:"call  *%~nx0  *ShowCurLineNo  *\"%%~f0\"  *%2" "%~s1" ` ) do (
set _tmplineNo2=%%i
set _tmplineTxt2=%%j
)

call colorTxt.bat cyan_L "%~f1"
echo.
call colorTxt.bat cyan_L "lineNo : %_tmplineNo2%"
echo.
findstr /B /R /C:"call  *%~nx0  *ShowCurLineNo  *\"%%~f0\"  *%2" "%~s1"
echo.
goto :eof

::[DOS_API:ShowLineNo]show file path, line number and line text which line include uniquePosId text 
::usage     : call :ShowLineNo filepath  uniquePosId
::call e.g. : call :ShowLineNo "tools_error.bat"  checkSupportedCmd111
::Note      : when multile call ShowLineNo, the uniquePosId is unique mark
::            uniquePosId can't include quoate"" , and blank
:ShowLineNo
@if defined _Stack @for %%a in ( 1 "%~nx0" "%0" ) do @if {"%%~a"}=={"%_Stack%"} @echo [      %~nx0] commandLine: %0 %*
if not exist "%~f1" call %~sdp0.\tools_message.bat popMsg "file[%1] doesn't exist,pls check". & goto :eof
for /f "usebackq tokens=1,* delims=: " %%i in ( ` findstr /n /R /C:"%~2" "%~f1" ` ) do (
set _tmplineNo2=%%i
set _tmplineTxt2=%%j
)

call colorTxt.bat cyan_L "%~f1"
echo.
call colorTxt.bat cyan_L "lineNo : %_tmplineNo2%"
echo.
echo line Text : %_tmplineTxt2%
echo.
goto :eof

:End
@if defined _Stack @for %%a in ( 1 "%~nx0" "%0" ) do @if {"%%~a"}=={"%_Stack%"} @echo [----- %~nx0] commandLine: %0 %* & @echo.