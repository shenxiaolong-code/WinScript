::Author    : Shen Xiaolong((xlshen@126.com))
::Copyright : free use,modify,spread, but MUST include this original two line information(Author and Copyright).
::descript  : set required microsoft path and local cache for symbol storage.

rem note _NT_SYMBOL_PATH will cause debugger loads all required symbols from microsoft when startup for some debuggers, e.g. visual studio.
rem it will slown startup performance obviously.

::@set _Echo=1
::set _Stack=%~nx0
@if {%_Echo%}=={1} ( @echo on ) else ( @echo off )
@if defined _Stack @for %%a in ( 1 "%~nx0" "%0" ) do @if {"%%~a"}=={"%_Stack%"} @echo. & @echo [+++++ %~nx0] commandLine: %0 %*
where tools_path.bat 1>nul 2>nul || call "%~dp0setEvnVar.bat"

echo **************windbg and symbol path set ********************************
::copy symbol path in symbol setting
:: srv*;cache*C:\symbols;SRV*http://msdl.microsoft.com/download/symbols;SRV*http://referencesource.microsoft.com/symbols;SRV*http://shanghai-nfs.cisco.com/symstore/;SRV*http://cpve-symbol.cisco.com/CPVE-Symbols/Public/;SRV*http://cpve-symbol.cisco.com/CPVE-Symbols/Public-VS2015/;SRV*http://cpve-symbol.cisco.com/ECC-Symbols/JCC-Symbol/ecc_daily_symbols/;SRV*http://cpve-symbol.cisco.com/ECC-Symbols/JCC-Symbol/ecc_official_symbols/;

::see dbgEnvironmentVariables.txt
if not defined _NT_SYMBOL_PATH_SRV      set _NT_SYMBOL_PATH_SRV=srv*
if not defined _NT_SYMBOL_PATH_CACHE    set _NT_SYMBOL_PATH_CACHE=C:\symbols
if not defined _NT_SYMBOL_PATH_MS       set _NT_SYMBOL_PATH_MS=SRV*http://msdl.microsoft.com/download/symbols;SRV*http://referencesource.microsoft.com/symbols;
::define yourself _NT_SYMBOL_PATH_MY variable like _NT_SYMBOL_PATH_MS
::if not defined _NT_SYMBOL_PATH_MY       set _NT_SYMBOL_PATH_MY=SRV*{user_symbol_url_1};SRV*{user_symbol_url_2};SRV*{user_symbol_url_3};
set "MY_NT_SYMBOL_PATH=%_NT_SYMBOL_PATH_SRV%;cache*%_NT_SYMBOL_PATH_CACHE%;%_NT_SYMBOL_PATH_MS%;%_NT_SYMBOL_PATH_MY%;"

set "_DBGHELP_HOMEDIR=%_NT_SYMBOL_PATH_CACHE%"
set "_NT_SYMBOL_PATH=%MY_NT_SYMBOL_PATH%"
echo **************************************************************************
goto :End


:End
@if defined _Stack @for %%a in ( 1 "%~nx0" "%0" ) do @if {"%%~a"}=={"%_Stack%"} @echo [----- %~nx0] commandLine: %0 %* & @echo.