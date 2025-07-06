
@if {"%_Echo%"}=={"1"} ( @echo on ) else ( @echo off )
where tools_collectOfflineSymbols.bat 1>nul 2>nul || set "path=%~dp0tools;%path%"

set NoCollectSymbolListMsg=1
echo [%date% - %time%]collecting symbol file list for "fulldump_12.6.0.278420.dmp" ....
call tools_collectOfflineSymbols.bat collectSymbolList "fulldump_12.6.0.278420.dmp"
rem call tools_collectOfflineSymbols.bat "%~dp0fulldump_12.6.0.278420.dmp"
echo [%date% - %time%] Done. outfile is:
echo %manifestFile%

pause


