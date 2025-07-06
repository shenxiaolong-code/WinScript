::Author    : Shen Xiaolong((xlshen@126.com))
::Copyright : free use,modify,spread, but MUST include this original two line information(Author and Copyright).

::@set _Echo=1
::set _Stack=%~nx0
@if {"%_Echo%"}=={"1"} ( @echo on ) else ( @echo off )
@if defined _Stack @for %%a in ( 1 "%~nx0" "%0" ) do @if {"%%~a"}=={"%_Stack%"} @echo. & @echo [+++++ %~nx0] commandLine: %0 %*
where "%~nx0" 1>nul 2>nul || set "path=%~dp0;%path%"

if {%1}=={} call :Test  & goto End
::if {%1}=={} call :Test NoOutput & goto End

call :%1 %2 %3 %4 %5 %6 %7 %8 %9
goto End

::[DOS_API:Help]display help information
:Help
@if defined _Stack @for %%a in ( 1 "%~nx0" "%0" ) do @if {"%%~a"}=={"%_Stack%"} @echo [      %~nx0] commandLine: %0 %*
call %~dp0.\tools_miscellaneous.bat DisplayHelp "%~f0"
goto :eof

::[DOS_API:Test]Test DOS API in this script file
:Test
@if defined _Stack @for %%a in ( 1 "%~nx0" "%0" ) do @if {"%%~a"}=={"%_Stack%"} @echo [      %~nx0] commandLine: %0 %*
setlocal EnableDelayedExpansion
@echo [%~nx0] Run test case [%0 %*]
echo.
echo test call :Help
call :Help
echo.
echo test call :ReverseString "ReadMe.txt"
call :ReverseString "ReadMe.txt"
echo.
echo test call :TrimString "   ReadMe.txt    "
call :TrimString "   ReadMe.txt    "
echo.
echo test call :toUpperVar my_tst_Case
call :toUpperVar my_tst_Case newStrVar
echo upper case string is "%newStrVar%"

echo.
echo [TC]test call :find 111222333444555  22 nPos
call :find 111222333444555  22 nPos
echo index of "22" in "111222333444555" is %nPos%
if not {"%nPos%"}=={"3"} call tools_message.bat warningMsg "test find fails" "%~f0" "findMark1"
echo.
echo [TC]test call :find teststringleng noExist nPos2
call :find teststringleng noExist nPos2
echo index of "noExist" in "teststringleng" is "%nPos2%"
if defined nPos2 call tools_message.bat warningMsg "test find fails" "%~f0" "findMark2"

echo.
echo [TC]test call :rfind 111222333444555  22 nPos
call :rfind 111222333444555  22 nPos
echo index of "22" in "111222333444555" is %nPos% by reversed search ordr
if not {"%nPos%"}=={"4"} call tools_message.bat warningMsg "test rfind fails" "%~f0" "rfindMark1"
echo.
echo [TC]test call :rfind teststringleng noExist nPos2
call :rfind teststringleng noExist nPos2
echo index of "noExist" in "teststringleng" is %nPos2% by reversed search ordr
if not {"%nPos2%"}=={"-1"} call tools_message.bat warningMsg "test rfind fails" "%~f0" "rfindMark2"

echo.
echo test call :stringLength 112233445566 iLen
call :stringLength 112233445566 iLen
echo string "112233445566" length is %iLen%
if not {"%iLen%"}=={"12"} call tools_message.bat warningMsg "test stringLength fails" "%~f0" "stringLengthMark"
echo.
echo test call :stringLength 1234567 iLen
call :stringLength 1234567 iLen
echo string "1234567" length is %iLen%
if not {"%iLen%"}=={"7"} call tools_message.bat warningMsg "test stringLength fails" "%~f0" "stringLengthMark"
echo.
echo test call :stringLength "" iLen
call :stringLength "" iLen
echo string "" length is %iLen%
if not {"%iLen%"}=={"0"} call tools_message.bat warningMsg "test stringLength fails" "%~f0" "stringLengthMark"

echo.
echo test call :replaceSubString "\b\\\c\\\d" "\\" "\" ret
call :replaceSubString "\b\\\c\\\d" "\\" "\" ret
echo result is %ret%
if not {"%ret%"}=={"\b\c\d"} call tools_message.bat warningMsg "test replaceSubString fails" "%~f0" "replaceSubStringMark"

echo.
echo test call :stringAlignL
call :stringAlignL "row1col1"   12
call :stringAlignL "row1col2ab" 18
call :stringAlignL "row1col3a"  15
echo row1tailColumn
call :stringAlignL "row2col1"   12
call :stringAlignL "row2col2a"  18
call :stringAlignL "row2col3ab" 15
echo row2tailColumn

echo.
echo test call :stringAlignR
call :stringAlignR "row1col1"   12
call :stringAlignR "row1col2ab" 18
call :stringAlignR "row1col3a"  15
echo    row1tailColumn
call :stringAlignR "row2col1"   12
call :stringAlignR "row2col2a"  18
call :stringAlignR "row2col3ab" 15
echo    row2tailColumn

echo.
echo test call :toLower
set myToLower=ToLowerString
echo [before]myToLower=%myToLower%
call :toLower myToLower
echo [after]myToLower=%myToLower%
echo.
echo test call :toUpper
set myToUpper=ToUpperString
echo [before]myToUpper=%myToUpper%
call :toUpper myToUpper
echo [after]myToUpper=%myToUpper%

echo.
echo test call :toCamelCase
set myToCamelCase=toCamelCaseString
echo [before]myToCamelCase=%myToCamelCase%
call :toCamelCase myToCamelCase
echo [after]myToCamelCase=%myToCamelCase%

echo.
echo test call :toFirstLowerCase
set myFirstLowerCase=FirstLowerCaseString
echo [before]myFirstLowerCase=%myFirstLowerCase%
call :toFirstLowerCase myFirstLowerCase
echo [after]myFirstLowerCase=%myFirstLowerCase%
goto :eof

:: ***********************************************get specified string ******************************************************************************
:getUninstallStr
::[DOS_API:getUninstallStr] get uninstall string for one registered application
::call e.g  : call :getUninstallStr "Cisco Jabber" unStr
::result e.g: set unStr=MsiExec.exe /I{0610DFB0-CCEA-6EC0-E3C3-A0160AD7FD98}
@if defined _Stack @for %%a in ( 1 "%~nx0" "%0" ) do @if {"%%~a"}=={"%_Stack%"} @echo [      %~nx0] commandLine: %0 %*
set %~2=
set _tmpProductID=
for /f "usebackq tokens=*" %%a in ( `wmic  product WHERE ^( name^="%~1" ^) get IdentifyingNumber ^| more +1 ` ) do if not defined _tmpProductID set "_tmpProductID=%%~a"
if not defined _tmpProductID goto :eof
:: reg query hklm\SOFTWARE\WOW6432Node\Microsoft\Windows\CurrentVersion\Uninstall\{0610DFB0-CCEA-6EC0-E3C3-A0160AD7FD98} /v UninstallString
set "_tmpProductKey=hklm\SOFTWARE\WOW6432Node\Microsoft\Windows\CurrentVersion\Uninstall\%_tmpProductID%"
for /f "usebackq tokens=1,2,*" %%a in (` reg query "%_tmpProductKey%" /v UninstallString 2^>nul `) do set "%~2=%%~c"
if defined _Debug if defined %~2 call echo %~2=%%%~2%%
goto :eof

::[DOS_API:getBackspaceString]get the back space char, it is used to erase printed string in console window.
::usage         : call tools_userInput.bat getBackspaceString outVar
::outVar        : output var
::example       : call tools_userInput.bat getBackspaceString bkChar
::                echo %myString%%bkChar%%bkChar%                                       //will not display last chars in %myString%.
::                set /p "=12345" <nul & <nul  set /p "=%bkChar%%bkChar%%bkChar%"      //will only show 1234
:getBackspaceString
@if defined _Stack @for %%a in ( 1 "%~nx0" "%0" ) do @if {"%%~a"}=={"%_Stack%"} @echo [      %~nx0] commandLine: %0 %*
for /F "tokens=1 delims=#" %%a in ('"prompt #$H# & echo on & for %%b in (1) do rem"') do set "%~1=%%~a"
goto :eof

::[DOS_API:getBackspaceStringN]base on getBackspaceString, get more than one char back space string.
::usage         : call tools_userInput.bat getBackspaceString outVar N
::outVar        : output var
::example       : call tools_userInput.bat getBackspaceString bkChar 5
::                echo %myString%%bkChar%%bkChar% will not display last chars in %myString%.
:getBackspaceStringN
@if defined _Stack @for %%a in ( 1 "%~nx0" "%0" ) do @if {"%%~a"}=={"%_Stack%"} @echo [      %~nx0] commandLine: %0 %*
set _tmpBkchar=
call :getBackspaceString _tmpBkchar
for /L %%i in ( 1 1 %~2 ) do call :getBackspaceStringN.addOne %~1
goto :eof


:: *********************************************manipulate string********************************************************************************

::[DOS_API:ReverseString]reverse one string and save result into possible output variable
::call e.g  : call :ReverseString "123  456" TestVar
::result e.g: set TestVar="654  321"
:ReverseString
@if defined _Stack @for %%a in ( 1 "%~nx0" "%0" ) do @if {"%%~a"}=={"%_Stack%"} @echo [      %~nx0] commandLine: %0 %*
if {"%~1"}=={""} call %~sdp0.\tools_message.bat popMsg "No input string,pls check" & goto :eof
call :ReverseString.impl %1
if {%~2}=={} (
echo "%tmpReverseString%"
) else (
set "%~2=%tmpReverseString%"
)
::clear temporary varible
set tmpReverseString=
goto :eof

::[DOS_API:TrimString]remove blank at head and tail of string
::call e.g  : call :TrimString "  123  456  " TestVar
::result e.g: set TestVar="654  321"
:TrimString
@if defined _Stack @for %%a in ( 1 "%~nx0" "%0" ) do @if {"%%~a"}=={"%_Stack%"} @echo [      %~nx0] commandLine: %0 %*
call :Private_TrimStringImpl tmpTrimString %~1
if {%~2}=={} (
	echo %tmpTrimString%
) else (
	set %~2=%tmpTrimString%
)
goto :eof

::[DOS_API:hasSubString] out-date DOS API, use find
::            if 3rd parameter exist, save the resut into it
::call e.g  : call :hasSubString abcdef  cde ret
::result e.g: set ret=1
:hasSubString
@if defined _Stack @for %%a in ( 1 "%~nx0" "%0" ) do @if {"%%~a"}=={"%_Stack%"} @echo [      %~nx0] commandLine: %0 %*
call tools_message.bat outOfDateAPIMsg  hasSubString  find
call :find %*
goto :eof

::[DOS_API:replaceSubString] replace all sub-string in first string, resut is saved into 3rd parameter
::call e.g  : call :replaceSubString abcdef  cde  ""  ret
::result e.g: set ret=abf
:replaceSubString
@if defined _Stack @for %%a in ( 1 "%~nx0" "%0" ) do @if {"%%~a"}=={"%_Stack%"} @echo [      %~nx0] commandLine: %0 %*
call :find "%~1" "%~2" bFind
if not defined bFind goto :eof
set "_tmpReplaceSubString=%~1"
call set "%~4=%%_tmpReplaceSubString:%~2=%~3%%"
call :replaceSubString "%%%~4%%" %2 %3 %4
goto :eof

::[DOS_API:find]check whether string1 include string2. 
::            if 3rd parameter exist, save the resut index into it , start is 0
::call e.g  : call :find 111222333444555  22 ret
::result e.g: set ret=3
:find
@if defined _Stack @for %%a in ( 1 "%~nx0" "%0" ) do @if {"%%~a"}=={"%_Stack%"} @echo [      %~nx0] commandLine: %0 %*
call tools_error.bat checkParamCount 2 %*
set %~3=
call set "_tmpFind1=%~1"
:: call set _tmpFind2=%%_tmpFind1:%~2=&rem.%%
call set _tmpFind2=%%_tmpFind1:%~2=&rem.%%
set _tmpFind2=%_tmpFind2%
if {"%_tmpFind2%"}=={"%_tmpFind1%"} goto :eof
call :stringLength "%_tmpFind2%" %~3
goto :eof

::[DOS_API:rfind]check whether string1 include string2 by reversed order. 
::            if 3rd parameter exist, save the resut index into it , start is 0
::call e.g  : call :rfind 111222333444555  22 ret
::result e.g: set ret=4
:rfind
@if defined _Stack @for %%a in ( 1 "%~nx0" "%0" ) do @if {"%%~a"}=={"%_Stack%"} @echo [      %~nx0] commandLine: %0 %*
call tools_error.bat checkParamCount 2 %*
call set "%~3=-1"
call :stringLength "%~1" iLenSrc
call :stringLength "%~2" iLenSub
if %iLenSrc% LSS %iLenSub% goto :eof
set "_tmpSrcStr=%~1"
set "_tmpSrcSub=%~2"
set _tmpRfind=
set /a idx=%iLenSrc%-%iLenSub%
for /L %%i in (%idx%,-1,0) do if not defined _tmpRfind call :rfind.setResult %%i
if defined _tmpRfind set "%~3=%_tmpRfind%"
goto :eof

:rfind.setResult
@if defined _Stack @for %%a in ( 1 "%~nx0" "%0" ) do @if {"%%~a"}=={"%_Stack%"} @echo [      %~nx0] commandLine: %0 %*
call set "_tmpCur=%%_tmpSrcStr:~%~1,%iLenSub%%%"
if {"%_tmpCur%"}=={"%_tmpSrcSub%"} set _tmpRfind=%~1
goto :eof

::[DOS_API:stringLength]calculate string length. 
::            if 2nd parameter exist, save the resut into it
::call e.g  : call :stringLength abcdef  iLen
::result e.g: set iLen=6
:stringLength
@if defined _Stack @for %%a in ( 1 "%~nx0" "%0" ) do @if {"%%~a"}=={"%_Stack%"} @echo [      %~nx0] commandLine: %0 %*
if {"%~1"}=={""} call set "%~2=0" & goto :eof
rem add char # to ensure _s is defined
set "_s=%~1#"
set "_len=0"
for %%i in (4096 2048 1024 512 256 128 64 32 16 8 4 2 1) do call :stringLength.calculate %%i
call set /a _len=%_len%-1
if {%~2}=={} (
	echo %_len%
) else (
	call set %~2=%_len%
)
goto :eof

::[DOS_API:stringAlignL]output left align string. 
::            used to align output string by echo
::            if string includes specail char, e.g =
::            string MUST be included by double quote sign ("")
::call e.g  : call :stringAlignL "abcdef"  12
::result e.g: output string "abcdef      " 
::            without double sign, without CR char
::            call multiple to align multiple columns
:stringAlignL
@if defined _Stack @for %%a in ( 1 "%~nx0" "%0" ) do @if {"%%~a"}=={"%_Stack%"} @echo [      %~nx0] commandLine: %0 %*
if {%~2}=={} goto :eof
set "_outStrL=%~1                                                       "
call set /p="%%_outStrL:~0,%~2%%%"<nul
set _outStrL=
goto :eof

::[DOS_API:stringAlignR]output right align string. 
::            used to align output string by echo
::            if string includes specail char, e.g =
::            string MUST be included by double quote sign ("")
::call e.g  : call :stringAlignR "abcdef"  12
::result e.g: output string "      abcdef" 
::            without double sign, without CR char
::            call multiple to align multiple columns
:stringAlignR
@if defined _Stack @for %%a in ( 1 "%~nx0" "%0" ) do @if {"%%~a"}=={"%_Stack%"} @echo [      %~nx0] commandLine: %0 %*
if {%~2}=={} goto :eof
set "_outStrR=                                                       %~1"
call set /p=".%%_outStrR:~-%~2%%%"<nul
set _outStrR=
goto :eof

::[DOS_API:toLower]toLower  str -- converts a string to all lower case
::call e.g  : set str=myTestCase
::            call :toLower str
::result e.g: set str=mytestcase
:toLower 
::URL:http://www.dostips.com/DtTipsStringOperations.php
@if defined _Stack @for %%a in ( 1 "%~nx0" "%0" ) do @if {"%%~a"}=={"%_Stack%"} @echo [      %~nx0] commandLine: %0 %*
call tools_error.bat checkParamCount 1 %*
for %%a in ("A=a" "B=b" "C=c" "D=d" "E=e" "F=f" "G=g" "H=h" "I=i"
            "J=j" "K=k" "L=l" "M=m" "N=n" "O=o" "P=p" "Q=q" "R=r"
            "S=s" "T=t" "U=u" "V=v" "W=w" "X=x" "Y=y" "Z=z" "?=?"
            "?=?" "จน=จน") do (
    call set %~1=%%%~1:%%~a%%
)
goto :eof

::[DOS_API:toLowerVar]toLowerVar   str outputVar -- converts a string to all upper case and store into outputVar
::call e.g  : call :toLowerVar  "myTestCase" lowVar
::result e.g: set lowVar=mytestcase
:toLowerVar  
::URL:http://www.dostips.com/DtTipsStringOperations.php
@if defined _Stack @for %%a in ( 1 "%~nx0" "%0" ) do @if {"%%~a"}=={"%_Stack%"} @echo [      %~nx0] commandLine: %0 %*
call tools_error.bat checkParamCount 2 %*
set "%~2=%~1"
call :toLower %~2
goto :eof

::[DOS_API:toUpper]toUpper   str -- converts a string to all upper case
::call e.g  : set str=myTestCase
::            call :toUpper  str
::result e.g: set str=MYTESTCASE
:toUpper  
::URL:http://www.dostips.com/DtTipsStringOperations.php
@if defined _Stack @for %%a in ( 1 "%~nx0" "%0" ) do @if {"%%~a"}=={"%_Stack%"} @echo [      %~nx0] commandLine: %0 %*
call tools_error.bat checkParamCount 1 %*
for %%a in ("a=A" "b=B" "c=C" "d=D" "e=E" "f=F" "g=G" "h=H" "i=I"
            "j=J" "k=K" "l=L" "m=M" "n=N" "o=O" "p=P" "q=Q" "r=R"
            "s=S" "t=T" "u=U" "v=V" "w=W" "x=X" "y=Y" "z=Z" "?=?"
            "?=?" "จน=จน") do (
    call set %~1=%%%~1:%%~a%%
)
goto :eof

::[DOS_API:toUpperVar]toUpperVar   str outputVar -- converts a string to all upper case and store into outputVar
::call e.g  : call :toUpperVar  "myTestCase" upVar
::result e.g: set upVar=MYTESTCASE
:toUpperVar  
::URL:http://www.dostips.com/DtTipsStringOperations.php
@if defined _Stack @for %%a in ( 1 "%~nx0" "%0" ) do @if {"%%~a"}=={"%_Stack%"} @echo [      %~nx0] commandLine: %0 %*
call tools_error.bat checkParamCount 2 %*
set %~2=%~1
call :toUpper %~2
goto :eof

::[DOS_API:toCamelCase]toCamelCase str -- converts a string to camel case , first char is upper case
::call e.g  : set str=myTestCase
::            call :toCamelCase str
::result e.g: set str=MyTestCase
:toCamelCase
::URL:http://www.dostips.com/DtTipsStringOperations.php
@if defined _Stack @for %%a in ( 1 "%~nx0" "%0" ) do @if {"%%~a"}=={"%_Stack%"} @echo [      %~nx0] commandLine: %0 %*
call set "%~1= %%%~1%%"
REM make first character upper case
for %%a in (" a=A" " b=B" " c=C" " d=D" " e=E" " f=F" " g=G" " h=H" " i=I"
            " j=J" " k=K" " l=L" " m=M" " n=N" " o=O" " p=P" " q=Q" " r=R"
            " s=S" " t=T" " u=U" " v=V" " w=W" " x=X" " y=Y" " z=Z"
            " ?=?" " ?=?" " จน=จน") do (
    call set "%~1=%%%~1:%%~a%%"
)
call set "%~1=%%%~1: =%%"
goto :eof

::[DOS_API:toFirstLowerCase]toFirstLowerCase str -- converts a string to first char is lower case
::call e.g  : set str=MyTestCase
::            call :toFirstLowerCase str
::result e.g: set str=myTestCase
:toFirstLowerCase
::URL:http://www.dostips.com/DtTipsStringOperations.php
@if defined _Stack @for %%a in ( 1 "%~nx0" "%0" ) do @if {"%%~a"}=={"%_Stack%"} @echo [      %~nx0] commandLine: %0 %*
call set "%~1= %%%~1%%"
REM make first character lower case
for %%a in ("A=a" "B=b" "C=c" "D=d" "E=e" "F=f" "G=g" "H=h" "I=i"
            "J=j" "K=k" "L=l" "M=m" "N=n" "O=o" "P=p" "Q=q" "R=r"
            "S=s" "T=t" "U=u" "V=v" "W=w" "X=x" "Y=y" "Z=z"
            "?=?" "?=?" "จน=จน") do (
    call set "%~1=%%%~1:%%~a%%"
)
call set "%~1=%%%~1: =%%"
goto :eof

:: *************************************************** inner implement**************************************************************************
:stringLength.calculate
@if defined _Stack @for %%a in ( 1 "%~nx0" "%0" ) do @if {"%%~a"}=={"%_Stack%"} @echo [      %~nx0] commandLine: %0 %*
set _tmpcalculateS=%_s%
call set /a _tmpTestLen=%_len%+%~1-1
call tools_message.bat enableDebugMsg "%~0" "_tmpTestLen=%_tmpTestLen%"
call set _tmpChar=%%_tmpcalculateS:~%_tmpTestLen%,1%%
call tools_message.bat enableDebugMsg "%~0" "_tmpChar=%_tmpChar%"
if "%_tmpChar%" NEQ "" call :stringLength.calculate.add %*
goto :eof

:stringLength.calculate.add
@if defined _Stack @for %%a in ( 1 "%~nx0" "%0" ) do @if {"%%~a"}=={"%_Stack%"} @echo [      %~nx0] commandLine: %0 %*
call set /a "_len+=%~1"
call tools_message.bat enableDebugMsg "%~0" "_len=%_len%"
goto :eof

:Private_TrimStringImpl
@if defined _Stack @for %%a in ( 1 "%~nx0" "%0" ) do @if {"%%~a"}=={"%_Stack%"} @echo [      %~nx0] commandLine: %0 %*
for /f "tokens=1*" %%i in ( "%*" ) do set "%1=%%j"
goto :eof

:ReverseString.impl
@if defined _Stack @for %%a in ( 1 "%~nx0" "%0" ) do @if {"%%~a"}=={"%_Stack%"} @echo [      %~nx0] commandLine: %0 %*
set "_tmpCurStr=%~1"
if not {"%~1"}=={""} call :ReverseString.addOneChar "%_tmpCurStr:~-1%" "%_tmpCurStr:~0,-1%"
goto :eof

:ReverseString.addOneChar 
@if defined _Stack @for %%a in ( 1 "%~nx0" "%0" ) do @if {"%%~a"}=={"%_Stack%"} @echo [      %~nx0] commandLine: %0 %*
call set "tmpReverseString=%tmpReverseString%%~1"
call :ReverseString.impl "%~2"
goto :eof

:End
@if defined _Stack @for %%a in ( 1 "%~nx0" "%0" ) do @if {"%%~a"}=={"%_Stack%"} @echo [----- %~nx0] commandLine: %0 %* & @echo.