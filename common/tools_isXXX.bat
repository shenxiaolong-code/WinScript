::Author    : Shen Xiaolong((xlshen@126.com))
::Copyright : free use,modify,spread, but MUST include this original two line information(Author and Copyright).

::@set _Echo=1
::set _Stack=%~nx0
@if {"%_Echo%"}=={"1"} ( @echo on ) else ( @echo off )
@if defined _Stack @for %%a in ( 1 "%~nx0" "%0" ) do @if {"%%~a"}=={"%_Stack%"} @echo. & @echo [+++++ %~nx0] commandLine: %0 %*
where "%~nx0" 1>nul 2>nul || set "path=%~dp0;%path%"

if {%1}=={} call :Test NoOutput & goto End
call :%~1 %2 %3 %4 %5 %6 %7 %8 %9
goto End

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
echo test call :isNumber 2345 bNumber
call :isNumber 2345 bNumber
if     {"%bNumber%"}=={"1"} echo test OK.  bNumber=%bNumber%
if not {"%bNumber%"}=={"1"} call tools_message.bat errorMsg "Fails to test isNumber 2345"
echo.
echo test call :isNumber 23gg45 bNumber
call :isNumber 23gg45 bNumber
if     {"%bNumber%"}=={"0"} echo test OK.  bNumber=%bNumber%
if not {"%bNumber%"}=={"0"} call tools_message.bat errorMsg "Fails to test isNumber 23gg45"
echo.
echo test call :isNumber 2345gn bNumber
call :isNumber 2345gn bNumber
if     {"%bNumber%"}=={"0"} echo test OK.  bNumber=%bNumber%
if not {"%bNumber%"}=={"0"} call tools_message.bat errorMsg "Fails to test isNumber 2345gn"
echo.
echo test call :isNumber abdf bNumber
call :isNumber abdf bNumber
if     {"%bNumber%"}=={"0"} echo test OK.  bNumber=%bNumber%
if not {"%bNumber%"}=={"0"} call tools_message.bat errorMsg "Fails to test isNumber abdf"

echo.
echo test call :isUnicodeFile "%~fs0" bUnicode
call :isUnicodeFile "%~fs0" bUnicode
if     {"%bUnicode%"}=={"0"} echo test OK.  bUnicode=%bUnicode%
if not {"%bUnicode%"}=={"0"} call tools_message.bat errorMsg "Fails to test isUnicodeFile '%~fs0'"

echo.
echo test call :isAsciiFile "%~fs0" bAscii
call :isAsciiFile "%~fs0" bAscii
if     {"%bAscii%"}=={"1"} echo test OK.  bAscii=%bAscii%
if not {"%bAscii%"}=={"1"} call tools_message.bat errorMsg "Fails to test isAsciiFile '%~fs0'"

echo.
echo test call :isEmptyFile "%~fs0" bEmptyFile
call :isEmptyFile "%~fs0" bEmptyFile
if     {"%bEmptyFile%"}=={"0"} echo test OK.  bEmptyFile=%bEmptyFile%
if not {"%bEmptyFile%"}=={"0"} call tools_message.bat errorMsg "Fails to test isEmptyFile '%~fs0'"

echo.
echo test call :isEmptyFile "%~fs0.txt" bEmptyFile
call :isEmptyFile "%~fs0.txt" bEmptyFile
if     {"%bEmptyFile%"}=={"1"} echo test OK.  bEmptyFile=%bEmptyFile%
if not {"%bEmptyFile%"}=={"1"} call tools_message.bat errorMsg "Fails to test isEmptyFile '%~fs0.txt'"

echo.
echo test call :isEmptyFolder "%~dp0" bEmptyFolder
call :isEmptyFolder "%~dp0" bEmptyFolder
if     {"%bEmptyFolder%"}=={"0"} echo test OK.  bEmptyFolder=%bEmptyFolder%
if not {"%bEmptyFolder%"}=={"0"} call tools_message.bat errorMsg "Fails to test isEmptyFolder '%~dp0'"

echo.
echo test call :isEmptyFolder "%~dp0tt" bEmptyFolder
call :isEmptyFolder "%~dp0tt" bEmptyFolder
if     {"%bEmptyFolder%"}=={"1"} echo test OK.  bEmptyFolder=%bEmptyFolder%
if not {"%bEmptyFolder%"}=={"1"} call tools_message.bat errorMsg "Fails to test isEmptyFolder '%~dp0tt'"

echo.
echo test call :isSameFile "%~fs0" "%~fs0"     bSameFile
call :isSameFile "%~fs0" "%~fs0" bSameFile
if     {"%bSameFile%"}=={"1"} echo test OK.  bSameFile=%bSameFile%
if not {"%bSameFile%"}=={"1"} call tools_message.bat errorMsg "Fails to test isSameFile '%~nx0' and '%~nx0'"

echo.
echo test call :isSameFile "%~fs0" "%~dp0tools_txtFile.bat"     bSameFile
call :isSameFile "%~fs0" "%~dp0tools_txtFile.bat" bSameFile
if     {"%bSameFile%"}=={"0"} echo test OK.  bSameFile=%bSameFile%
if not {"%bSameFile%"}=={"0"} call tools_message.bat errorMsg "Fails to test isSameFile '%~nx0' and 'tools_txtFile.bat'"

goto :eof

::[DOS_API:isNumber]test whether first parameter is number , result is stored in 2nd parameter
::call e.g  : call :isNumber 3454 bNumber               //set bNumber=1
::            call :isNumber 34gd bNumber               //set bNumber=0
:isNumber
@if defined _Stack @for %%a in ( 1 "%~nx0" "%0" ) do @if {"%%~a"}=={"%_Stack%"} @echo [      %~nx0] commandLine: %0 %*
set %~2=0
call SET "_tmpNumTest="
for /f "delims=0123456789" %%i in ("%~1") do set _tmpNumTest=%%i
if not defined _tmpNumTest set "%~2=1"
goto :eof

::[DOS_API:isEmptyFile]test whether file is empty , result is stored in 2nd parameter
::call e.g  : call :isEmptyFile filePath            bEMpty
::            call :isEmptyFile d:\temp\myFil.txt   bEMpty               //set bEMpty=0
:isEmptyFile
@if defined _Stack @for %%a in ( 1 "%~nx0" "%0" ) do @if {"%%~a"}=={"%_Stack%"} @echo [      %~nx0] commandLine: %0 %*
set %~2=1
if not exist "%~1" goto :eof
if not {" %~z1"}=={"0"} set %~2=0
goto :eof

::[DOS_API:isEmptyFolder]test whether folder is empty  , result is stored in 2nd parameter
::call e.g  : call :isEmptyFolder folderPath            bEMpty
::            call :isEmptyFolder d:\temp\              bEMpty               //set bEMpty=0
:isEmptyFolder
@if defined _Stack @for %%a in ( 1 "%~nx0" "%0" ) do @if {"%%~a"}=={"%_Stack%"} @echo [      %~nx0] commandLine: %0 %*
set %~2=1
if not exist "%~1" goto :eof
for /f "usebackq tokens=1" %%i in ( ` dir /b "%~fs1" ^| find /c /v "^^*" ` ) do  if not {"%%i"}=={"0"} set %~2=0
goto :eof

::[DOS_API:isSameFile]test whether folder is empty  , result is stored in 2nd parameter
::call e.g  : call :isSameFile file1  file2     bSame
::            call :isSameFile d:\temp\1.txt d:\dir\2.txt   bSame   //set bSame=0
:isSameFile
@if defined _Stack @for %%a in ( 1 "%~nx0" "%0" ) do @if {"%%~a"}=={"%_Stack%"} @echo [      %~nx0] commandLine: %0 %*
call tools_error.bat checkParamCount 3 %*
call tools_error.bat checkFileExist "%~fs1" "%~fs0" mark_MergeTwoFile_1
call tools_error.bat checkFileExist "%~fs2" "%~fs0" mark_MergeTwoFile_2
set %~3=0
call fc "%~fs1" "%~fs2" >nul
if {"%errorlevel%"}=={"0"} set %~3=1
goto :eof

::[DOS_API:isUnicodeFile]test whether file is unicode format
::usage     : call :isUnicodeFile srcfilefullpath bRet
::call e.g. : call :isUnicodeFile "%~f0" bRet
:isUnicodeFile
@if defined _Stack @for %%a in ( 1 "%~nx0" "%0" ) do @if {"%%~a"}=={"%_Stack%"} @echo [      %~nx0] commandLine: %0 %*
:: https://www.robvanderwoude.com/battech_fileencoding.php
call tools_error.bat checkFileExist "%~fs1"
for /f %%i in ( "%~fs1" ) do set "%~2=0" & goto :eof
set %~2=1
goto :eof

::[DOS_API:isAsciiFile]test whether file is ascii format
::usage     : call :isAsciiFile srcfilefullpath bRet
::call e.g. : call :isAsciiFile "%~f0" bRet
:isAsciiFile
@if defined _Stack @for %%a in ( 1 "%~nx0" "%0" ) do @if {"%%~a"}=={"%_Stack%"} @echo [      %~nx0] commandLine: %0 %*
:: https://www.robvanderwoude.com/battech_fileencoding.php
call tools_error.bat checkFileExist "%~fs1"
for /f %%i in ( "%~fs1" ) do set "%~2=1" & goto :eof
set %~2=0
goto :eof

:End
@if defined _Stack @for %%a in ( 1 "%~nx0" "%0" ) do @if {"%%~a"}=={"%_Stack%"} @echo [----- %~nx0] commandLine: %0 %* & @echo.