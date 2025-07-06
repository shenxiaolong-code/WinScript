::refer: https://www.codeproject.com/Articles/17033/Add-Colors-to-Batch-Files
::show color text , usage example see cecho test.bat
::string can't include char (need escape) : < >
::or use built-in findstr.exe option /a to print color string in console window and use back space char to erase unnecessary output char.
::e.g. findstr.exe /p /r /a:0c "call" "D:\work\shenxiaolong\core\WinScript\common\tools_userInput.bat" nul

@if {"%_Echo%"}=={"1"} ( @echo on ) else ( @echo off )
rem @echo [      %~nx0] commandLine: %0 %*
rem compatiabe old and new usage
if not defined gray_L                call :configAlias

if not  {"%~2"}=={""}   				                                call :oldUsage %*
if      {"%~2"}=={""} if not {"%~1"}=={""} if not {"%~1"}=={"-init"}    call :newUsage "%~1"
if      {"%~1"}=={"-init"}  			                                call :configAlias
if      {"%~1"}=={""}   				                                call :showUsage
goto :eof

:: 0 = black	8 = gray
:: 1 = navy   	9 = blue
:: 2 = green	A = lime
:: 3 = teal	    B = aqua
:: 4 = maroon	C = red
:: 5 = purple	D = fuchsia
:: 6 = olive	E = yellow
:: 7 = silver	F = white

:configAlias
if defined gray_L goto :eof
set           br=\n
set           end=#

set         black=00
set          blue=01
set         green=02
set          cyan=03
set           red=04
set        purple=05
set         brown=06
set         white=07
set          gray=08
set        blue_L=09
set       green_L=0a
set        cyan_L=0b
set         red_L=0c
set      purple_L=0d
set       brown_L=0e
set       white_L=0f
goto :eof

:showUsage
call "%~dp0bin\cecho.exe" {%brown%}usage : {%end%}{%br%}
echo @where colorTxt.bat 1^>nul 2^>nul ^|^| @set "path=%%myWinScriptPath%%\common;%%path%%"
echo call colorTxt.bat -init
echo call %~nx0 "{%%blue%%}blue {%%green%%}green {%%cyan%%}cyan {%%red%%}red {%%purple%%}purple {%%brown%%}brown {%%end%%}{%%br%%}"
call echo %~nx0 "{%%blue%%}blue {%%green%%}green {%%cyan%%}cyan {%%red%%}red {%%purple%%}purple {%%brown%%}brown {%%end%%}{%%br%%}"
call "%~dp0bin\cecho.exe" {%%blue%%}blue {%%green%%}green {%%cyan%%}cyan {%%red%%}red {%%purple%%}purple {%%brown%%}brown {%%end%%}{%%br%%}

echo.
@echo call %~nx0 "{01}01{02}02{03}03{04}04{05}05{06}06{07}07{08}08{09}09{0a}0a{0b}0b{0c}0c{0d}0d{0e}0e{#}#"
call "%~dp0bin\cecho.exe" {01}01{02}02{03}03{04}04{05}05{06}06{07}07{08}08{09}09{0a}0a{0b}0b{0c}0c{0d}0d{0e}0e{#}#
@echo.

@echo.
:: don't change below format , it is show alignment when it shows on terminal window
call "%~dp0bin\cecho.exe"                    {%end%}end{%end%} : %end%                br : %br%{%br%}
call "%~dp0bin\cecho.exe"           (black){%black%}black{%end%} : %black%             {%gray%}gray{%end%} : %gray%{%br%}
call "%~dp0bin\cecho.exe"                   {%blue%}blue{%end%} : %blue%           {%blue_L%}blue_L{%end%} : %blue_L%{%br%}
call "%~dp0bin\cecho.exe"                  {%green%}green{%end%} : %green%          {%green_L%}green_L{%end%} : %green_L%{%br%}
call "%~dp0bin\cecho.exe"                   {%cyan%}cyan{%end%} : %cyan%           {%cyan_L%}cyan_L{%end%} : %cyan_L%{%br%}
call "%~dp0bin\cecho.exe"                    {%red%}red{%end%} : %red%            {%red_L%}red_L{%end%} : %red_L%{%br%}
call "%~dp0bin\cecho.exe"                 {%purple%}purple{%end%} : %purple%         {%purple_L%}purple_L{%end%} : %purple_L%{%br%}
call "%~dp0bin\cecho.exe"                  {%brown%}brown{%end%} : %brown%          {%brown_L%}brown_L{%end%} : %brown_L%{%br%}
call "%~dp0bin\cecho.exe"                  {%white%}white{%end%} : %white%          {%white_L%}white_L{%end%} : %white_L%{%br%}

@echo.
@echo rapid mixed usage:
@echo call %~nx0 begin{02}text{0d}text2{0a}newLine{\n}{#}restoreDefault
call "%~dp0bin\cecho.exe" begin{02}text{0d}text2{0a}newLine{\n}{#}restoreDefault

@echo.
@echo.
@echo more detail usage, refer to :
call %~fs0 "{%red_L%}call {%green%}%~dp0..\test\cecho_test.bat{%end%}"
@echo.
@echo.
goto :eof

:hardcode_color_for_portable_code
powershell -Command "Write-Host 'run cmd ''' -NoNewline; Write-Host 'bd7' -ForegroundColor Red -NoNewline; Write-Host ''' to build dkg in windows docker'"
goto :eof

:oldUsage
::example :  call colorTxt.bat  red_L "I am red_L text" 
call set curColor=%%%~1%%
@call "%~dp0bin\cecho.exe" {%curColor%}%~2{#}
goto :eof

:newUsage
::example :  call colorTxt.bat  "{%red_L%}I am red_L text{%end%}" 
@where "%~nx0" 1>nul 2>nul || @set "path=%~dp0;%path%"
if not defined gray_L  call :configAlias
@call "%~dp0bin\cecho.exe" %~1
goto :eof