::Author    : Shen Xiaolong((xlshen@126.com))
::Copyright : free use,modify,spread, but MUST include this original two line information(Author and Copyright).
::            using built-in command to zip/unzip .zip file

::@set _Echo=1
::set _Debug=1
::set _Stack=%~nx0
@if {"%_Echo%"}=={"1"} ( @echo on ) else ( @echo off )
@if defined _Stack @for %%a in ( 1 "%~nx0" "%0" ) do @if {"%%~a"}=={"%_Stack%"}  @echo. & @echo [+++++ %~nx0] commandLine: %0 %*
rem title length limited to 256 chars , else dos will report "Not enough memory resources are available to process this command"
rem @title %0 %*
where "%~nx0" 1>nul 2>nul || set "path=%~dp0;%path%"

if {"%~1"}=={""} call :Test NoOutput & goto End
call :%~1 %2 %3 %4 %5 %6 %7 %8 %9
goto :End

::[DOS_API:Help]Display help information
:Help
@if defined _Stack @for %%a in ( 1 "%~nx0" "%0" ) do @if {"%%~a"}=={"%_Stack%"}  @echo [      %~nx0] commandLine: %0 %*
call tools_miscellaneous.bat DisplayHelp "%~f0"
goto :eof

::[DOS_API:Test]Test DOS API in this script file
:Test
@if defined _Stack @for %%a in ( 1 "%~nx0" "%0" ) do @if {"%%~a"}=={"%_Stack%"}  @echo [      %~nx0] commandLine: %0 %*
echo.
@echo [%~nx0] Run test case [%0 %*]

echo.
echo test call :Help
call :Help

echo.
goto :eof

::[DOS_API:unzip] extract all files from one compressed file
::usage     : call :unzip msiFileFullPath optionalTargetDirectory
::call e.g. : call :unzip "D:\tasks\CiscoJabberSetup.msi"
::            call :unzip "D:\tasks\CiscoJabberSetup.msi"   "D:\tasks\instalerFiles\"
:unzip
call tools_error.bat checkFileExist "%~fs1"
set "_tmpOutputDir=%~2"
if not defined _tmpOutputDir set "_tmpOutputDir=%~dp1"
if not exist "%_tmpOutputDir%\" md "%_tmpOutputDir%\"
if {"%~x1"}=={".zip"} call :unzip.zip %*
if {"%~x1"}=={".cab"} call :unzip.cab %*
if {"%~x1"}=={".msi"} call :unzip.msi %*
goto :eof

:unzip.zip
@where "%~nx0" || set "path=%~dp0;%path%"
tar.exe -C "%_tmpOutputDir%" -xvf "%~fs1"
goto :eof

:unzip.cab
::expand.exe <source>.cab <dest>
call expand.exe "%~fs1" "%_tmpOutputDir%"
goto :eof

:unzip.msi
if not {"%~x1"}=={".msi"} call tools_message.bat errorMsg "file MUST be .msi file"
start msiexec /a "%~fs1" /qb TARGETDIR="%_tmpOutputDir%"
goto :eof

::[DOS_API:zip]compress one zip or folder into one compressed file.
::usage     : call :zip <folerOrFile> <outfile>
::e.g.      : call :zip "d:\mytestFolder" d:\self_extracted.exe
:zip
if {"%~x2"}=={".zip"} call :zip.zip %*
if {"%~x2"}=={".cab"} call :zip.cab %*
if {"%~x2"}=={".exe"} call :zip.exe %*
goto :eof

:zip.cab
::makecab <source> <dest>.cab
call makecab.exe "%~f1" "%~f2"
goto :eof

:zip.zip
echo TODO
goto :eof

:zip.exe
if 		{"%~x1"}=={".cab"} call zip.exe.fromCab %*
if not 	{"%~x1"}=={".cab"} call zip.exe.fromFolder %*
goto :eof

:zip.exe.fromCab
copy /b extrac32.exe+"%~f1" "%~dpn2.exe"
goto :eof

:zip.exe.fromFolder
set "_tempCab=%temp%\%~n2.cab"
call makecab.exe "%~f1" "%_tempCab%"
call :zip.exe.fromCab "%_tempCab%" "%~f2"
del /q/f "%_tempCab%"
goto :eof


:End
@if defined _Stack @for %%a in ( 1 "%~nx0" "%0" ) do @if {"%%~a"}=={"%_Stack%"}  @echo [----- %~nx0] commandLine: %0 %* & @echo.