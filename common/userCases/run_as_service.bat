
@echo off
:: https://stackoverflow.com/questions/415409/run-batch-file-as-a-windows-service
:: note : below cmd can't work as expected.

where Tools_common.bat 1>nul 2>nul || set "path=%~dp0\..;%path%"
call %myWinScriptPath%\Companys\cisco\collectInfo\tools\Tools_common.bat checkAdmin "%~fs0"

@echo off
set SERVICE_NAME=syncthing
set DISPLAY_NAME=syncthing
set DESCRIPTION=syncthing is used to sync files between platform and hosts

REM 设置服务的执行程序路径和参数
set SERVICE_EXECUTABLE="C:\work\OneDrive\PC_tools\sync_file\syncthing\windows_1272\syncthing.exe"

REM 安装服务
"%SYSTEMROOT%\System32\sc.exe" create %SERVICE_NAME% binPath= "%SERVICE_EXECUTABLE%" start= auto DisplayName= "%DISPLAY_NAME%" obj= ".\LocalSystem" password= ""

REM 启动服务
"%SYSTEMROOT%\System32\sc.exe" start %SERVICE_NAME%

REM 输出服务安装结果
"%SYSTEMROOT%\System32\sc.exe" qc %SERVICE_NAME%

REM 删除.bat脚本自身，以防止重复安装
:: del %0

:: sc delete "%ServiceName%"
:: sc delete "syncthing"

:: edit below reg key to update info
:: Computer\HKEY_LOCAL_MACHINE\SYSTEM\ControlSet001\Services\syncthing
:: Computer\HKEY_LOCAL_MACHINE\SYSTEM\ControlSet001\Services\%ServiceName%