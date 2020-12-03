@if {"%_Echo%"}=={"1"} ( @echo on ) else ( @echo off )
:Begin
echo.
echo a : attach one existing .vhd(virtual harddisk) file 
echo d : detach one existing .vhd(virtual harddisk) file
echo r : clean  one existing .vhd(virtual harddisk) file
echo c : create one new .vhd(virtual harddisk) file
call %~dp0tools_string.bat getChoiceSelected adrc driverChar
if {%driverChar%}=={c} echo create new .vhd file        & set act=vhd_create
if {%driverChar%}=={d} echo detach existing .vhd file   & set act=vhd_detach
if {%driverChar%}=={a} echo attach existing .vhd file   & set act=vhd_attach
if {%driverChar%}=={r} (
echo clean existing .vhd file 
set act=vhd_clean
set vhdFile=%cd%\tmp.vhd
)

if not {%act%}=={vhd_clean} call :inputVhdFile
call %~dp0\vhdMgr.bat %vhdFile% :%act%
goto :End

:inputVhdFile
echo.
@echo pls input vhd file path:
set /p vhdFile=
call :checkVhdFile %vhdFile%
if {%act%}=={vhd_create} (
if exist %vhdFile% @echo %vhdFile% exist, can't create. & goto :Begin
) else (
if not exist %vhdFile% @echo %vhdFile% doesn't exist, can't attach/detach. & goto :Begin
)
goto :eof

:checkVhdFile
set vhdFile=%~dp1%~n1.vhd
goto :eof

:End