@if {"%_Echo%"}=={"1"} ( @echo on ) else ( @echo off )
:Input
cls
@echo pls input directory or module(exe/lib/dll) path :
@echo use quotation mask ^("") to include path which has blank char.
@echo.
set /p sPath=
if not exist "%sPath%" (
@echo %sPath% doesn't exist.
@echo.
goto :Input
)
call "%~dp0takeowner.bat" "%sPath%"

pause
goto :Input