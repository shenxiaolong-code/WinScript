rem http://www.voidcn.com/blog/wince7/article/p-4506738.html
rem http://www.1ask2.com/Windows7/Native%20boot%20from%20VHD%20file.htm
rem http://lesca.me/archives/a-quick-introduction-to-winpe-imagex-and-dism.html
:: tools
:: diskpart.exe : create/delete/modify disk/partition/volume/vdisk
:: bcdboot.exe  : copy boot configuration data
:: bcdedit.exe  : edit boot configuration data
:: imagex.exe   : manage Windows images(.wim file): check,export,copy,append
:: dism.exe     : enumerates, installs, uninstalls, configures Windows images(.wim file).

::@set _Echo=1
::set _Stack=%~nx0
@if {"%_Echo%"}=={"1"} ( @echo on ) else ( @echo off )
@if defined _Stack @for %%a in ( 1 "%~nx0" "%0" ) do @if {"%%~a"}=={"%_Stack%"} @echo. & @echo [+++++ %~nx0] commandLine: %0 %*
where "%~nx0" 1>nul 2>nul || set "path=%~dp0;%path%"

set toolDir=%myWinScriptPath%\common
if not defined newVhd_driveLetter   set newVhd_driveLetter=G
if not defined newVhd_vhdFile       set newVhd_vhdFile=WinBootDisk.vhd

if exist %newVhd_driveLetter%:\  %toolDir%tools_message.bat popMsg "%newVhd_driveLetter%: exist, can't reload." & goto :End
if exist %newVhd_vhdFile%  %toolDir%tools_message.bat popMsg "%newVhd_vhdFile% exist, can't recreate." & goto :End

call :createVhd
echo drive(%newVhd_driveLetter%:) info:
fsutil fsinfo ntfsinfo %newVhd_driveLetter%:
call :CreateBoot
goto :End

:createVhd
@if defined _Stack @for %%a in ( 1 "%~nx0" "%0" ) do @if {"%%~a"}=={"%_Stack%"} @echo. & @echo [+++++ %~nx0] commandLine: %0 %*
if not defined newVhd_Size   set newVhd_Size=2500
call "%toolDir%vhdMgr.bat" %newVhd_vhdFile% :vhd_create
if not exist %newVhd_driveLetter%:\ %toolDir%tools_message.bat popMsg "create virtual disk fail" & goto :End
echo.
goto :eof

:CreateBoot
@if defined _Stack @for %%a in ( 1 "%~nx0" "%0" ) do @if {"%%~a"}=={"%_Stack%"} @echo. & @echo [+++++ %~nx0] commandLine: %0 %*
if not defined wimFile call :setWimFilePath "C:\Recovery"
call :copyWimFiles "C:\Program Files (x86)\Windows Kits\10\Tools\bin\i386\imagex.exe"
call :setBootConfig "%newVhd_vhdFile%" "%username%'s Windows 7 Enterprise 64bit"
goto :eof

:setWimFilePath
@if defined _Stack @for %%a in ( 1 "%~nx0" "%0" ) do @if {"%%~a"}=={"%_Stack%"} @echo. & @echo [+++++ %~nx0] commandLine: %0 %*
if not exist "%~1" %toolDir%tools_message.bat popMsg ".wim file directory %~1 doesn't exist." & goto :End
set wimFile=
pushd "%~1"
for /f "usebackq" %%i in ( `dir/s/a/b *.wim` ) do set wimFile=%%i
popd
if {"%wimFile%"}=={""}     %toolDir%tools_message.bat popMsg "can't find .wim file" & goto :End
if not exist "%wimFile%"  %toolDir%tools_message.bat popMsg "can't find .wim file" & goto :End
goto :eof

:copyWimFiles
@if defined _Stack @for %%a in ( 1 "%~nx0" "%0" ) do @if {"%%~a"}=={"%_Stack%"} @echo. & @echo [+++++ %~nx0] commandLine: %0 %*
if not exist "%~f1" %toolDir%tools_message.bat popMsg "%~f1 doesn't exist. handle fails" & goto :End
pushd "%~dp1"
echo wimFile=%wimFile%
echo imagex.exe /info %wimFile%
imagex.exe /info %wimFile% 
for /f "usebackq delims=^= tokens=1* " %%i in ( `imagex.exe /info %wimFile% ^| find "IMAGE INDEX"` ) do set indexItem="%%j"
rem echo indexItem=%indexItem%
set indexItem=%indexItem:~2,1%
echo imagex.exe /apply "%wimFile%" /check %indexItem% %newVhd_driveLetter%:\
imagex.exe /apply "%wimFile%" /check %indexItem% %newVhd_driveLetter%:\
rem imagex.exe /mountrw "%wimFile%" %indexItem% %newVhd_driveLetter%:\
rem echo indexItem=%indexItem%
rem IMAGE INDEX
popd
goto :eof

:setBootConfig
@if defined _Stack @for %%a in ( 1 "%~nx0" "%0" ) do @if {"%%~a"}=={"%_Stack%"} @echo. & @echo [+++++ %~nx0] commandLine: %0 %*
rem BCD : Boot Configuration Data
rem Bcdboot.exe %newVhd_driveLetter%:/windows /s c:
rem for {current}, check by bcdedit.exe /? id
for /f "usebackq tokens=*" %%i in ( ` bcdedit.exe /copy {current} /d "%~2" ` ) do set copyResult=%%i
echo copy Boot Configuration Data : %copyResult%
if /i {"%copyResult:successfully=%"}=={"%copyResult%"} %toolDir%tools_message.bat popMsg "%copyResult%" & goto :eof
for /f "delims=^{ tokens=1*" %%i in ( "%copyResult%" ) do set entryUuid=^{%%j
set entryUuid=%entryUuid:~0,-1%
echo boot entry is "%entryUuid%"
bcdedit.exe /enum %entryUuid%
echo.
echo bcdedit.exe /set %entryUuid% device vhd=[%~d1]%~pnx1
bcdedit.exe /set %entryUuid% device vhd=[%~d1]%~pnx1
echo bcdedit.exe /set %entryUuid% osdevice vhd=[%~d1]%~pnx1
bcdedit.exe /set %entryUuid% osdevice vhd=[%~d1]%~pnx1
echo bcdedit.exe /set %entryUuid% detecthal on
bcdedit.exe /set %entryUuid% detecthal on
echo bcdedit.exe /set %entryUuid% description "%~2"
bcdedit.exe /set %entryUuid% description "%~2"
bcdedit.exe /enum %entryUuid%

goto :eof

:End
@if defined _Stack @for %%a in ( 1 "%~nx0" "%0" ) do @if {"%%~a"}=={"%_Stack%"} @echo [----- %~nx0] commandLine: %0 %* & @echo.