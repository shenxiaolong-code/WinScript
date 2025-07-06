@if {"%_Echo%"}=={"1"} ( @echo on ) else ( @echo off )
rem linux command : fallocate -l 1474560 myimage.vfd
rem Linux & other Unix-like systems: head -c 1474560 /dev/zero > myimage.vfd
if {%~1}=={} %~dp0tools_message.bat popMsg "empty parameter"  & goto :End
call :setDiskName "%~1"

if exist "%vfdName%.vfd" %~dp0tools_message.bat popMsg "%vfdName%.vfd is existing."  & goto :End

echo create empty 1.44M virtual floppy disk "%vfdName%.vfd"
echo format it in virtual machine
fsutil file createnew %vfdName%.vfd 1474560
goto :eof

:setDiskName
set vfdName=%~dpn1
goto :eof

:End