::Author :  Shen Xiaolong((xlshen@126.com))
::          create / attach / detach virtual disk in window7 or later system
::e.g.      create virtual disk "C:\my vpc\abc.vhd" by default configuration.
::          vhdMgr.bat "C:\my vpc\abc.vhd" :vhd_create
::e.g.      attach virtual disk "C:\my vpc\abc.vhd"
::          vhdMgr.bat "C:\my vpc\abc.vhd" :vhd_attach
::e.g.      detach virtual disk "C:\my vpc\abc.vhd"
::          vhdMgr.bat "C:\my vpc\abc.vhd" :vhd_detach

::@set _Echo=1
::set _Stack=%~nx0
@if {"%_Echo%"}=={"1"} ( @echo on ) else ( @echo off )
@if defined _Stack @for %%a in ( 1 "%~nx0" "%0" ) do @if {"%%~a"}=={"%_Stack%"} @echo. & @echo [+++++ %~nx0] commandLine: %0 %*
rem http://www.utilizewindows.com/create-virtual-hard-disk-vhd-using-diskpart-in-windows-7/
rem https://msdn.microsoft.com/en-us/ff794606%28v=winembedded.60%29?f=255&MSPPError=-2147217396

rem *********************cfg begin***************************************
rem create new virtual disk parameter
rem new disk size, unit is MB(1024*1024 bytes)
if not defined newVhd_Size  set newVhd_Size=256
rem if create boot section, label should be empty
if not defined newVhd_label set newVhd_label=
rem type=<fixed|expandable>
if not defined newVhd_type      set newVhd_type=fixed
if not defined newVhd_format    set newVhd_format=quick
if not defined newVhd_fileSystem    set newVhd_fileSystem=ntfs
rem empty meas automatically select
rem echo newVhd_driveLetter=%newVhd_driveLetter%
if not defined newVhd_driveLetter   set newVhd_driveLetter=
rem set existing virtual disk max size, unit is MB(1024*1024 bytes)
if not defined existingVhd_maxSize  set existingVhd_maxSize=512
if not defined existingVhd_minSize  set existingVhd_minSize=64
rem
if not defined hidePartition_onoff  set hidePartition_onoff=show
rem if not defined hidePartition_disk   set hidePartition_disk=
rem if not defined hidePartition_num    set hidePartition_num=
rem 
rem *********************cfg end*****************************************
set vhdFile=%~dp1%~nx1
set vhdName=%~n1
set toolDir=%myWinScriptPath%\common
if not {%~x1}=={.vhd} %toolDir%tools_message.bat popMsg "require .vhd file" & goto :End

set vhdScripFile=%tmp%vhdScrip%random%.txt
if exist "%vhdScripFile%" del /q "%vhdScripFile%"
call :%2 %3 %4 %5 %6 %7 %8 %9
if exist "%vhdScripFile%" (
type "%vhdScripFile%"
diskpart /s "%vhdScripFile%"
)
goto :End

:vhd_attach
@if defined _Stack @for %%a in ( 1 "%~nx0" "%0" ) do @if {"%%~a"}=={"%_Stack%"} @echo. & @echo [+++++ %~nx0] commandLine: %0 %*
(
echo select vdisk file="%vhdFile%"
echo attach vdisk
)>> "%vhdScripFile%"
goto :eof

:vhd_detach
@if defined _Stack @for %%a in ( 1 "%~nx0" "%0" ) do @if {"%%~a"}=={"%_Stack%"} @echo. & @echo [+++++ %~nx0] commandLine: %0 %*
(
echo select vdisk file="%vhdFile%"
echo detach vdisk
)>> "%vhdScripFile%"
goto :eof

:vhd_create
@if defined _Stack @for %%a in ( 1 "%~nx0" "%0" ) do @if {"%%~a"}=={"%_Stack%"} @echo. & @echo [+++++ %~nx0] commandLine: %0 %*
if exist "%vhdFile%" %toolDir%tools_message.bat popMsg "%vhdFile% exist, can't create it" & goto :End
(
echo create vdisk file="%vhdFile%" maximum=%newVhd_Size% type=%newVhd_type%
rem initialize disk
echo select vdisk file="%vhdFile%"
echo attach vdisk
echo convert mbr
echo create partition primary
echo format fs=%newVhd_fileSystem% label="%newVhd_label%" %newVhd_format%
if {%newVhd_driveLetter%}=={} ( echo assign ) else echo assign letter=%newVhd_driveLetter:~0,1%
echo active
rem echo AUTOMOUNT ENABLE
echo detail vdisk
echo list volume
)>> "%vhdScripFile%"
goto :eof

:vhd_clean
set tmpClean=%tmp%\clean%random%.txt
if exist "%tmpClean%" del /y "%tmpClean%"
echo list disk > "%tmpClean%"
for /f "usebackq tokens=* skip=4" %%i in ( ` diskpart /s "%tmpClean%" ` ) do echo %%i
setLocal enabledelayedexpansion 
set disks=
for /f "usebackq tokens=1,2 skip=3" %%i in ( ` diskpart /s "%tmpClean%" ^| find /i "Disk" ` ) do set disks=!disks!%%j
call %toolDir%tools_string.bat getChoiceSelected !disks! diskNum
(
echo select disk %diskNum%
echo clean
echo create par pri
echo format fs=ntfs quick
if {%newVhd_driveLetter%}=={} ( echo assign ) else echo assign letter=%newVhd_driveLetter:~0,1%
echo active
echo detail disk
) >> "%vhdScripFile%"
if exist "%tmpClean%" del /y "%tmpClean%"
goto :eof

:vhd_info
(
echo list DISK
echo list PARTITION
echo list VOLUME
echo list VDISK
) >> "%vhdScripFile%"
goto :eof

:vhd_expand
@if defined _Stack @for %%a in ( 1 "%~nx0" "%0" ) do @if {"%%~a"}=={"%_Stack%"} @echo. & @echo [+++++ %~nx0] commandLine: %0 %*
(
echo select vdisk file="%vhdFile%"
echo EXPAND VDISK MAXIMUM=%existingVhd_maxSize%
)>> "%vhdScripFile%"
goto :eof

:vhd_shrink
@if defined _Stack @for %%a in ( 1 "%~nx0" "%0" ) do @if {"%%~a"}=={"%_Stack%"} @echo. & @echo [+++++ %~nx0] commandLine: %0 %*
(
echo select vdisk file="%vhdFile%"
echo SHRINK MINIMUM=%existingVhd_minSize%
)>> "%vhdScripFile%"
goto :eof

:vhd_compact
@if defined _Stack @for %%a in ( 1 "%~nx0" "%0" ) do @if {"%%~a"}=={"%_Stack%"} @echo. & @echo [+++++ %~nx0] commandLine: %0 %*
rem Can only be used on VHDs that are type expandable and are either detached, or attached as read only.
(
echo select vdisk file="%vhdFile%"
echo compact vdisk
)>> "%vhdScripFile%"
goto :eof

:vhd_hideShow
@if defined _Stack @for %%a in ( 1 "%~nx0" "%0" ) do @if {"%%~a"}=={"%_Stack%"} @echo. & @echo [+++++ %~nx0] commandLine: %0 %*
if not defined hidePartition_num %toolDir%tools_message.bat popMsg "No partition num" & goto :End
if {%hidePartition_num%}=={} %toolDir%tools_message.bat popMsg "empty partition num" & goto :End
if not defined hidePartition_disk %toolDir%tools_message.bat popMsg "No disk num" & goto :End
if {%hidePartition_disk%}=={} %toolDir%tools_message.bat popMsg "empty disk num" & goto :End
if {%hidePartition_onoff%}=={show}  set idVal=7
if {%hidePartition_onoff%}=={hide}  set idVal=12
if {%idVal%}=={} %toolDir%tools_message.bat popMsg "invalid parameter." & goto :End   
(
echo select disk %hidePartition_disk%
echo select partition %hidePartition_num%
echo set id=%idVal%
)>> "%vhdScripFile%"
goto :eof

:End
@if defined _Stack @for %%a in ( 1 "%~nx0" "%0" ) do @if {"%%~a"}=={"%_Stack%"} @echo [----- %~nx0] commandLine: %0 %* & @echo.
if exist "%vhdScripFile%" del /q "%vhdScripFile%"