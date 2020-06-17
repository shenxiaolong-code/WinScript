@echo off
@where tools_appInstallPath.bat 1>nul 2>nul || set "path=%~dps0common;%path%"
cls

call :config.default

echo.
echo config root path ...
call :config.WinScriptPath
echo set WinScriptPath=%WinScriptPath%
where tools_path.bat 1>nul 2>nul || set path=%WinScriptPath%\common;%path%;

echo.
echo. check administrator privilege
call tools_error.bat checkAdmin "%~fs0"

echo.
echo @echo setup jabber prt analysis tool and context menu.
call :config.stig
echo found stig.exe : %stigPath%\stig.exe

echo.
echo @echo setup all backup root directory.
call :config.backupDir
echo set DefaultBackupPathRoot=%DefaultBackupPathRoot%

@echo.
goto :End

:config.default
::set default path
set "g_NppDir=D:\UserApps\Notepad++"
set "g_StigDir=D:\shared_desktop-500eiav\Cisco\jabber\tools\log_in_dmp"
set "g_windbgDir=C:\Program Files (x86)\Windows Kits\10\Debuggers"
set "g_ZipDir=D:\UserApps\7-Zip"
goto :eof

:config.WinScriptPath
call set WinScriptPath=%~dps0
call set WinScriptPath=%WinScriptPath:~0,-1%
call setx WinScriptPath "%WinScriptPath%"
goto :eof

:config.stig
call tools_appInstallPath.bat FindPathStig stigPath
if not exist "%stigPath%" call tools_message.bat warningMsg "can't find stig.exe in current PC."
goto :eof

:config.backupDir
if defined DefaultBackupPathRoot goto :eof
set "localPath=D:"
if not exist "%localPath%" set "localPath=%LOCALAPPDATA%"
set "remotePath=\\DESKTOP-500EIAV\shared_desktop-500eiav"
set backupFolderName=BackupRoot
set "DefaultBackupPathRoot_remote=%remotePath%\%backupFolderName%"
set "DefaultBackupPathRoot=%localPath%\%backupFolderName%"
setx DefaultBackupPathRoot 	"%DefaultBackupPathRoot%"
if exist "%DefaultBackupPathRoot_remote%" setx DefaultBackupPathRoot_remote "%DefaultBackupPathRoot_remote%"
if not exist "%DefaultBackupPathRoot%" mkdir "%DefaultBackupPathRoot%"
goto :eof

:End
@echo ********************************************
@echo.
@echo setup complete,please check any error output and fix it.
@echo press any key to exit setup script. 
pause 1>nul 2>nul