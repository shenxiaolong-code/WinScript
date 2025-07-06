@if {"%_Echo%"}=={"1"} ( @echo on ) else ( @echo off )
echo clear windbg configuration before loading one new theme
echo refer to : https://docs.microsoft.com/en-us/windows-hardware/drivers/debugger/loading-a-theme
reg delete HKCU\Software\Microsoft\Windbg
echo.
echo done.
pause