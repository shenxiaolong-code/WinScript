@if {"%_Echo%"}=={"1"} ( @echo on ) else ( @echo off )
echo checking es.exe
if not exist "%~dp0tools\es.exe" copy "%~dp0..\..\common\bin\search.exe" "%~dp0tools\es.exe"