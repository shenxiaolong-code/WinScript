::Author    : Shen Xiaolong((xlshen@126.com))
::Copyright : free use,modify,spread, but MUST include this original two line information(Author and Copyright).

::@set _Echo=1
::set _Debug=1
::set _DebugQ=1
::set _Stack=%~nx0
@if {"%_Echo%"}=={"1"} ( @echo on ) else ( @echo off )
@if defined _Stack @for %%a in ( 1 "%~nx0" "%0" ) do @if {"%%~a"}=={"%_Stack%"}  @echo. & @echo [+++++ %~nx0] commandLine: %0 %*
rem title length limited to 256 chars , else dos will report "Not enough memory resources are available to process this command"
rem @title %0 %*
rem echo %0 %* & pause
where "%~nx0" 1>nul 2>nul || set "path=%~dp0;%path%"
@echo %~fs0 %*

set cmds_%~n0="%~fs0" %*
if {"%~1"}=={""} call :Test NoOutput & goto End
call :%~1 %2 %3 %4 %5 %6 %7 %8 %9
goto :End

::[DOS_API:Help]Display help information
:Help
@if defined _Stack @for %%a in ( 1 "%~nx0" "%0" ) do @if {"%%~a"}=={"%_Stack%"}  @echo [      %~nx0] commandLine: %0 %*
if exist "%myWinScriptPath%\common\tools_miscellaneous.bat" call "%myWinScriptPath%\common\tools_miscellaneous.bat" DisplayHelp "%~f0"
goto :eof

::[DOS_API:Test]Test DOS API in this script file
:Test
@if defined _Stack @for %%a in ( 1 "%~nx0" "%0" ) do @if {"%%~a"}=={"%_Stack%"}  @echo [      %~nx0] commandLine: %0 %*
@echo [%~nx0] Run test case [%0 %*]


echo test call :Help
call :Help

goto :eof

:: *********************************************************************************************************************
:symchk.findWindbgPath
@if defined _Stack @for %%a in ( 1 "%~nx0" "%0" ) do @if {"%%~a"}=={"%_Stack%"}  @echo [      %~nx0] commandLine: %0 %*
where symchk.exe 2>nul && goto :eof
where search.exe 1>nul 2>nul || set "path=%~dp0..\..\..\common\bin;%path%"
:: x86 is better than x64 because x86 can run on x64 , but vias cann't
for /f "usebackq tokens=*" %%i in ( ` search.exe x86\windbg.exe ` ) do set "_tmpWindbgFullPath=%%~fsi"
set "symchkPath=%_tmpWindbgFullPath:\windbg.exe=" & call echo. %
echo got windbg.exe install path : %symchkPath%
echo.
call :symchk.findWindbgPath.checkFail "%symchkPath%"
if exist "%symchkPath%\" set "path=%symchkPath%;%path%"
goto :eof

:symchk.findWindbgPath.checkFail
@if defined _Stack @for %%a in ( 1 "%~nx0" "%0" ) do @if {"%%~a"}=={"%_Stack%"}  @echo [      %~nx0] commandLine: %0 %*
if exist "%~1\" goto :eof
set "neededFileList=symchk.exe;SymbolCheck.dll;symsrv.dll;symsrv.yes;symstore.exe;dbghelp.dll;dbgeng.dll"
echo it seems that no windbg suite is installed in your current PC or everything service is not running.
echo search windbg install path needs everything service support. please start the everything application and run again.
echo collect the symbol list needs below files
echo %neededFileList:;= & echo %
pause
exit
goto :eof

:symchk.setAddiOpt
@if defined _Stack @for %%a in ( 1 "%~nx0" "%0" ) do @if {"%%~a"}=={"%_Stack%"}  @echo [      %~nx0] commandLine: %0 %*
set symchkAddiOpt=/v
if not defined NoCollectSymbolListMsg   set symchkAddiOpt=/oeptv
if defined _Debug                       set symchkAddiOpt=/odtbsv
set %~1=%symchkAddiOpt%
goto :eof

:symChk.run
@if defined _Stack @for %%a in ( 1 "%~nx0" "%0" ) do @if {"%%~a"}=={"%_Stack%"}  @echo [      %~nx0] commandLine: %0 %*
call :symchk.setAddiOpt  addOpt
where symchk.exe 2>nul || call :symchk.findWindbgPath
where symchk.exe 2>nul || set "path=%symchkPath%;%path%"
set cmds="%symchkPath%\symchk.exe" %* %addOpt%
:: avoid error "Not enough memory resources are available to process this command" because of title buffer limitation
rem title %cmds:~0,254% ...
if defined _Debug echo call %cmds%
if not defined _DebugQ call %cmds%
goto :eof

:: *********************************************************************************************************************

::[DOS_API:showManulSymbolFileListExample] symchk.exe supports one symbol manifest file as input file. here show its format example.
::usage     : call :showManulSymbolFileListExample
::e.g.      : call :showManulSymbolFileListExample
::            call :showManulSymbolFileListExample
:showManulSymbolFileListExample
@if defined _Stack @for %%a in ( 1 "%~nx0" "%0" ) do @if {"%%~a"}=={"%_Stack%"}  @echo [      %~nx0] commandLine: %0 %*
set _tmpManifestFile=%temp%\symchkManifestFile.txt
echo example file is : %_tmpManifestFile%
echo.
(
echo CiscoJabber.exe,5c6fd0402d000,2
echo Spokes.dll,5c06aab455f000,2
echo DiagnosticsToolService.dll,5c6fccad4a000,2
) > "%_tmpManifestFile%"
type "%_tmpManifestFile%"
goto :eof

::[DOS_API:downloadSymbolsFromList] collect symbol manifest file on one restricted computer.
::usage     : call :downloadSymbolsFromList possibleInputParam possibleOutputParam
::e.g.      : call :downloadSymbolsFromList "%~f0" bRet
::            call :downloadSymbolsFromList "%~f0" bRet "optParamer"
:downloadSymbolsFromList
@if defined _Stack @for %%a in ( 1 "%~nx0" "%0" ) do @if {"%%~a"}=={"%_Stack%"}  @echo [      %~nx0] commandLine: %0 %*
if not defined outFolder set "outFolder=%~dp1symbols"
if not exist "%outFolder%\" md "%outFolder%\"
call :downloadSymbolsFromList.setSymbolPath symOpt.symbolPaths
call :symChk.run /im "%~fs1" /s "%symOpt.symbolPaths%;"
goto :eof

:downloadSymbolsFromList.setSymbolPath
@if defined _Stack @for %%a in ( 1 "%~nx0" "%0" ) do @if {"%%~a"}=={"%_Stack%"}  @echo [      %~nx0] commandLine: %0 %*
if not defined symbolPathHander set symbolPathHander=:downloadSymbolsFromList.setSymbolPath.default
if not defined symbolsPaths call %symbolPathHander%  symbolsPaths
set "%~1=%symbolsPaths%"
goto :eof

:downloadSymbolsFromList.setSymbolPath.default
@if defined _Stack @for %%a in ( 1 "%~nx0" "%0" ) do @if {"%%~a"}=={"%_Stack%"}  @echo [      %~nx0] commandLine: %0 %*
set "%~1=srv*%outFolder%*http://msdl.microsoft.com/download/symbols"
goto :eof

:: *********************************************************************************************************************
::[DOS_API:collectSymbolOneModule] generate manifest file for specified single module. in general this API is called from windbg.
::usage     : call :collectSymbolOneModule md_name.dll md_Timestamp md_SizeOfImage md_age
::e.g.      : call :collectSymbolOneModule ntdll.dll 37FD3042 19A000 2
:collectSymbolOneModule
@if defined _Stack @for %%a in ( 1 "%~nx0" "%0" ) do @if {"%%~a"}=={"%_Stack%"}  @echo [      %~nx0] commandLine: %0 %*
echo %0 %*
set manifestFileName=%~n1_manifest.txt
call :collectSymbolList.setDefaultOutFolder "%temp%\symbol_manifest_Collect\%~n1_%~2
call :collectSymbolList.processOutFolder "%outFolder%"
echo %~1,%~2%~3,%~4 > "%manifestFile%"
if not defined NoCollectSymbolListMsg start "" "%outFolder%"
call :collectSymbolList.prepareDownloadToolSet
del /q "%outFolder%\keep*.bat"
goto :eof

::[DOS_API:collectSymbolList] collect symbol manifest file on one restricted computer.
::usage     : call :collectSymbolList possibleInputParam possibleOutputParam
::e.g.      : call :collectSymbolList "%~f0" bRet
::            call :collectSymbolList "%~f0" bRet "optParamer"
:collectSymbolList
@if defined _Stack @for %%a in ( 1 "%~nx0" "%0" ) do @if {"%%~a"}=={"%_Stack%"}  @echo [      %~nx0] commandLine: %0 %*
set "manifestFilter=%~f2"
if not {"%~x1"}=={""} call :collectSymbolList.File     %*
if     {"%~x1"}=={""} call :collectSymbolList.NotFile  %*
if exist "%manifestFilter%" call "%~dp0tools_symFilter.bat" filterSpecficModules "%manifestFile%" "%manifestFilter%"
goto :eof

:collectSymbolList.File
@if defined _Stack @for %%a in ( 1 "%~nx0" "%0" ) do @if {"%%~a"}=={"%_Stack%"}  @echo [      %~nx0] commandLine: %0 %*
set _extName=%~x1
call :toLowerString _extName
call :collectSymbolList.setDefaultOutFolder "%temp%\symbol_manifest_Collect\%~n1"
call :collectSymbolList.processOutFolder "%outFolder%"
if {"%_extName%"}=={".exe"} call :collectSymbolList.application     %*
if {"%_extName%"}=={".dmp"} call :collectSymbolList.dumpFile        %*
if {"%_extName%"}=={".cab"} call :collectSymbolList.hotFix          %*
if {"%_extName%"}=={".txt"} call :collectSymbolList.moduleFileList  %*
goto :eof

:collectSymbolList.NotFile
@if defined _Stack @for %%a in ( 1 "%~nx0" "%0" ) do @if {"%%~a"}=={"%_Stack%"}  @echo [      %~nx0] commandLine: %0 %*
if not exist "%~1\" call :collectSymbolList.folder  %*
if     exist "%~1\" call :collectSymbolList.process %*
goto :eof

:collectSymbolList.setDefaultOutFolder
@if defined _Stack @for %%a in ( 1 "%~nx0" "%0" ) do @if {"%%~a"}=={"%_Stack%"}  @echo [      %~nx0] commandLine: %0 %*
if defined outFolder goto :eof
call "%myWinScriptPath%\common\genNameByTime.bat" dtStr
set "outFolder=%~1_%dtStr%"
goto :eof

:collectSymbolList.processOutFolder
@if defined _Stack @for %%a in ( 1 "%~nx0" "%0" ) do @if {"%%~a"}=={"%_Stack%"}  @echo [      %~nx0] commandLine: %0 %*
if not exist "%~fs1\" md "%~fs1\"
if not defined manifestFileName set manifestFileName=symchk_manifest.txt
set "manifestFile=%~fs1\%manifestFileName%"
if exist "%manifestFile%" del /f/q "%manifestFile%"
goto :eof

:: *********************************************************************************************************************
:collectSymbolList.run
@if defined _Stack @for %%a in ( 1 "%~nx0" "%0" ) do @if {"%%~a"}=={"%_Stack%"}  @echo [      %~nx0] commandLine: %0 %*
if not defined NoCollectSymbolListMsg echo [%date% - %time%] collecting symbol list .....
::empty symbol path can avoid symchk to search unnecessary symbol service when collecting symbol manifest. it can improve symchk work performance greatly from 10+ minutes to 2 seconds.
set "emptySymFolder=%temp%\emptySymbols"
if not exist "%emptySymFolder%\" md "%emptySymFolder%\"
call :symChk.run /om "%manifestFile%" /s "%emptySymFolder%" %*
if not defined NoCollectSymbolListMsg echo [%date% - %time%] Done .....
if not defined _DebugQ if not exist "%manifestFile%" call :collectSymbolList.failure
if not defined NoCollectSymbolListMsg start "" "%outFolder%"
call :collectSymbolList.prepareDownloadToolSet
goto :eof

:collectSymbolList.failure
@if defined _Stack @for %%a in ( 1 "%~nx0" "%0" ) do @if {"%%~a"}=={"%_Stack%"}  @echo [      %~nx0] commandLine: %0 %*
set "_tmpFailFile=%temp%\cmds_%~n0.txt"
(
echo.
echo *****************************collect Symbol List failure********************************************************
echo Fails to collect manifest file : "%manifestFile%"
echo.
echo this script file command line :  cmds_%~n0
call echo %%cmds_%~n0%%
echo.
echo symChk command line:
echo %cmds%
echo.
echo prompt:
echo sometimes the symchk.exe can't works file with non-dump target. you can generate one dump file first, then collect the manifest file for the dump file. it is OK also.
echo.
echo this failure is recorded into file:
echo %_tmpFailFile%
) > "%_tmpFailFile%"
type "%_tmpFailFile%"
echo press any key to open this file.
pause 1>nul
start "" "%_tmpFailFile%"
echo press any key to exit current script.
pause 1>nul
exit /b
goto :eof

:collectSymbolList.folder
@if defined _Stack @for %%a in ( 1 "%~nx0" "%0" ) do @if {"%%~a"}=={"%_Stack%"}  @echo [      %~nx0] commandLine: %0 %*
call :collectSymbolList.setDefaultOutFolder "%~dp0..\symbol_manifest_Collect\Folder_%~n1"
call :collectSymbolList.processOutFolder "%outFolder%"
call :collectSymbolList.run /r /if "%~fs1"
goto :eof

:collectSymbolList.process
@if defined _Stack @for %%a in ( 1 "%~nx0" "%0" ) do @if {"%%~a"}=={"%_Stack%"}  @echo [      %~nx0] commandLine: %0 %*
call :collectSymbolList.setDefaultOutFolder "%~dp0..\symbol_manifest_Collect\process_%~1"
call :collectSymbolList.processOutFolder "%outFolder%"
call :collectSymbolList.run /ip "%~1"
goto :eof

:collectSymbolList.application
@if defined _Stack @for %%a in ( 1 "%~nx0" "%0" ) do @if {"%%~a"}=={"%_Stack%"}  @echo [      %~nx0] commandLine: %0 %*
call :collectSymbolList.run /ie "%~fs1"
goto :eof

:collectSymbolList.dumpFile
@if defined _Stack @for %%a in ( 1 "%~nx0" "%0" ) do @if {"%%~a"}=={"%_Stack%"}  @echo [      %~nx0] commandLine: %0 %*
call :collectSymbolList.dumpFile.generateModuleList "%~fs1"
call :collectSymbolList.run /id "%~fs1"
goto :eof

:collectSymbolList.moduleFileList
@if defined _Stack @for %%a in ( 1 "%~nx0" "%0" ) do @if {"%%~a"}=={"%_Stack%"}  @echo [      %~nx0] commandLine: %0 %*
call :collectSymbolList.run /it "%~fs1"
goto :eof

:collectSymbolList.hotFix
@if defined _Stack @for %%a in ( 1 "%~nx0" "%0" ) do @if {"%%~a"}=={"%_Stack%"}  @echo [      %~nx0] commandLine: %0 %*
call :collectSymbolList.run /ih "%~fs1"
goto :eof

:: *********************************************************************************************************************
:collectSymbolList.dumpFile.generateModuleList
@if defined _Stack @for %%a in ( 1 "%~nx0" "%0" ) do @if {"%%~a"}=={"%_Stack%"}  @echo [      %~nx0] commandLine: %0 %*
where symchk.exe 2>nul || call :symchk.findWindbgPath
where symchk.exe 2>nul || set "path=%symchkPath%;%path%"
:: cdb.exe -z "%~f1" -cf "cdbCmd.dbg"
:: cdb.exe -z deadLock.dmp -c ".shell -ci \"k\" find /i \"::\" > test.txt "
set "filterFolder=%outFolder%\filter"
if not exist "%filterFolder%" md "%filterFolder%\"
if exist "%manifestFilter%" copy "%manifestFilter%" "%filterFolder%\" & goto :eof
set "tmpModuleFile=%filterFolder%\module_all_%~n1.txt"
cdb.exe -z "%~fs1" -c " !for_each_module \".echo @#ImageName \"  ; qq " > "%tmpModuleFile%"
type "%tmpModuleFile%"  | find /i "C:\Windows\" > "%filterFolder%\module_ms.txt"
type "%tmpModuleFile%"  | find /v "C:\Windows\" | find /i ":\" | find /v "Loading Dump File" > "%filterFolder%\module_user.txt"
goto :eof

:collectSymbolList.prepareDownloadToolSet
@if defined _Stack @for %%a in ( 1 "%~nx0" "%0" ) do @if {"%%~a"}=={"%_Stack%"}  @echo [      %~nx0] commandLine: %0 %*
if not defined NoCollectSymbolListMsg echo. & echo create download tool set ...
call :collectSymbolList.prepareDownloadToolSet.generateDownloadScript
call :collectSymbolList.prepareDownloadToolSet.copyTools
if not defined NoCollectSymbolListMsg echo Done & echo.
goto :eof

:collectSymbolList.prepareDownloadToolSet.copyTools
@if defined _Stack @for %%a in ( 1 "%~nx0" "%0" ) do @if {"%%~a"}=={"%_Stack%"}  @echo [      %~nx0] commandLine: %0 %*
set "_tmpToolFolder=%outFolder%\tools"
if not exist "%_tmpToolFolder%\" md "%_tmpToolFolder%\"
copy "%~fs0" "%_tmpToolFolder%\"
if not exist "%_tmpToolFolder%\search.exe" copy "%~dp0..\..\..\common\bin\search.exe" "%_tmpToolFolder%\search.exe"
if not exist "%_tmpToolFolder%\search.exe" copy "%~dp0search.exe" "%_tmpToolFolder%\search.exe"
if not exist "%_tmpToolFolder%\search.exe" echo can't find necessary tool "search.exe", you can copy it into folder "%_tmpToolFolder%" manual & pause
goto :eof

:collectSymbolList.prepareDownloadToolSet.generateDownloadScript
@if defined _Stack @for %%a in ( 1 "%~nx0" "%0" ) do @if {"%%~a"}=={"%_Stack%"}  @echo [      %~nx0] commandLine: %0 %*
(
echo @echo off
echo ::set _Debug=1
echo echo [%%date%% - %%time%%]downloading symbol file listed in "%manifestFileName%" ....
echo call "%%~dp0tools\%~nx0" downloadSymbolsFromList "%%~dp0%manifestFileName%"
echo echo [%%date%% - %%time%%] Done
echo echo.
echo echo download symbol file:
echo if not defined outFolder echo outFolder is not defined, something are wrong. ^& pause
echo dir/s/b "%%outFolder%%\*.dll" "%%outFolder%%\*.pdb"
echo pause
) > "%outFolder%\runMe_onNetworkedPc.bat"
if exist "%manifestFilter%" goto :eof
echo call "%~dp0tools_symFilter.bat" keepMsBasic "%%~dp0%manifestFileName%" > "%outFolder%\keepModule_MsBasic.bat"
echo call "%~dp0tools_symFilter.bat" filterSpecficModules "%%~dp0%manifestFileName%" "%%~dp0filter\module_ms.txt"     > "%outFolder%\keepModule_MsAll.bat"
echo call "%~dp0tools_symFilter.bat" filterSpecficModules "%%~dp0%manifestFileName%" "%%~dp0filter\module_user.txt"   > "%outFolder%\keepModule_OnlyUser.bat"
goto :eof

:: *********************************************************************************************************************
:toLowerString
@if defined _Stack @for %%a in ( 1 "%~nx0" "%0" ) do @if {"%%~a"}=={"%_Stack%"}  @echo [      %~nx0] commandLine: %0 %*
for %%a in ("A=a" "B=b" "C=c" "D=d" "E=e" "F=f" "G=g" "H=h" "I=i"
            "J=j" "K=k" "L=l" "M=m" "N=n" "O=o" "P=p" "Q=q" "R=r"
            "S=s" "T=t" "U=u" "V=v" "W=w" "X=x" "Y=y" "Z=z" "?=?"
            "?=?" "จน=จน") do (
    call set %~1=%%%~1:%%~a%%
)
goto :eof
:: *********************************************************************************************************************

:End
@if defined _Stack @for %%a in ( 1 "%~nx0" "%0" ) do @if {"%%~a"}=={"%_Stack%"}  @echo [----- %~nx0] commandLine: %0 %* & @echo.