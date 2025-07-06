@where tools_windbg.bat 1>nul 2>nul || set "path=%myWinScriptPath%\Windbg;%path%"

echo.
echo config customized source code path for special application ....
:: call tools_windbg.bat config setWindbgEvnPath userRepo_<exeImageName>    <srcRepoPath>
call tools_windbg.bat config setWindbgEvnPath userRepo_CiscoCollabHost      "E:\dev\spark"
call tools_windbg.bat config setWindbgEvnPath userRepo_CiscoJabber          "E:\work\sourceCode\JabberGit"
call tools_windbg.bat config setWindbgEvnPath userRepo_wbxcOIEx             "E:\work\sourceCode\webex-jabbermeeting"

echo.
echo config customized windbg start script for special application ....
echo it will be called automatically by script framework after all general path and variables are set.
:: call tools_windbg.bat config setWindbgEvnPath startCmds_<exeImageName>   <customizedStartScriptPath>
call tools_windbg.bat config setWindbgEvnPath startCmds_CiscoCollabHost     "%~dp0startCmds_teams.dbg"
call tools_windbg.bat config setWindbgEvnPath startCmds_CiscoJabber         "%~dp0startCmds_jabber.dbg"
call tools_windbg.bat config setWindbgEvnPath startCmds_wbxcOIEx            "%~dp0startCmds_wbxcOIEx.dbg"

echo.
echo var file (config result) : %windbgEnvVarFile%
type "%windbgEnvVarFile%"

echo.
pause