::refer: https://www.codeproject.com/Articles/17033/Add-Colors-to-Batch-Files
::show color text , usage example see cecho test.bat
::string can't include char (need escape) : < >
::or use built-in findstr.exe option /a to print color string in console window and use back space char to erase unnecessary output char.
::e.g. findstr.exe /p /r /a:0c "call" "D:\work\shenxiaolong\core\WinScript\common\tools_userInput.bat" nul

@if {"%_Echo%"}=={"1"} ( @echo on ) else ( @echo off )
rem @echo [      %~nx0] commandLine: %0 %*
rem compatiabe old and new usage
if not  {"%~2"}=={""}   call :oldUsage %*
if not  {"%~1"}=={""}   if {"%~2"}=={""} call :newUsage "%~1"
if      {"%~1"}=={""}   call :showUsage
goto :eof


:showUsage
@echo.
@echo more detail usage, refer to :
echo call "%~dp0..\test\cecho_test.bat"
@echo.
@echo one simple rapid mixed usage:
@echo "%~f0" begin{02}text{0d}text2{0a}newLine{\n}{#}restoreDefault
@echo "%~f0" "begin{02}text{0d}text2{0a}newLine{\n}{#}restoreDefault"
call "%~dp0bin\cecho.exe" begin{02}text{0d}text2{0a}newLine{\n}{#}restoreDefault
@echo.
goto :eof

:oldUsage
@call "%~dp0bin\cecho.exe" {%~1}%~2{#}
goto :eof

:newUsage
@call "%~dp0bin\cecho.exe" %~1
goto :eof