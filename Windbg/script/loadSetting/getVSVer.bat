@if {"%_Echo%"}=={"1"} ( @echo on ) else ( @echo off )
::echo %0 %*
for /f "eol=; tokens=*" %%i in ('powershell Get-Clipboard') do set "_windbgCLip=%%i"
::echo _windbgCLip=%_windbgCLip%
if not {"%_windbgCLip:Microsoft Visual Studio 14.0=%"}=={"%_windbgCLip%"} echo 2015
if not {"%_windbgCLip:Microsoft Visual Studio 9.0=%"}=={"%_windbgCLip%"} echo 2008
if not {"%_windbgCLip:2017=%"}=={"%_windbgCLip%"} echo 2017