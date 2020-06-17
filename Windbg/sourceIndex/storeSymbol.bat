::@set _Echo=1
::set _Stack=%~nx0
::@det _Debug=1
@if {%_Echo%}=={1} ( @echo on ) else ( @echo off )
@@if defined _Stack @for %%a in ( 1 "%~nx0" "%0" ) do @if {"%%~a"}=={"%_Stack%"} @echo. & @echo [+++++ %~nx0] commandLine: %0 %*
where "%~nx0" 1>nul 2>nul || set "path=%~dp0;%path%"

call :storeSymbol %*
goto :eof

:storeSymbol
rem :storeSymbol "D:\myPoject\output\bin" "\\SymbolServer\Symbols"  "testProject"
@if defined _Stack @for %%a in ( 1 "%~nx0" "%0" ) do @if {"%%~a"}=={"%_Stack%"} @echo [      %~nx0] commandLine: %0 %*
rem publibSymUrl can be local path, network URL, UNC path , .... etc that other can access
rem .sympath+ %publibSymUrl%
rem set publibSymUrl=\\SymbolServer\Symbols
if not defined pdbBinDir        set pdbBinDir=%~1
if not defined publibSymUrl     set publibSymUrl=%~2
if not defined ProjectName      set projectName=%~3
set _cmd=symstore.exe add /f "%pdbBinDir%\*.pdb" /s %publibSymUrl% /compress /r  /t %projectName%
echo %_cmd%
call %_cmd%
@echo.
echo [OK] symbol path '%publibSymUrl%' is available in windbg command , e.g.: .sympath+ "%publibSymUrl%"
goto :eof


:End
@if defined _Stack @for %%a in ( 1 "%~nx0" "%0" ) do @if {"%%~a"}=={"%_Stack%"} @echo [----- %~nx0] commandLine: %0 %* & @echo.
cd /d "%~dp0"
rem pause