::Author    : Shen Xiaolong((xlshen@126.com))
::Copyright : free use,modify,spread, but MUST include this original two line information(Author and Copyright).

::@set _Echo=1
::set _Debug=1
::set _Stack=%~nx0
@echo off
where "%~nx0" 1>nul 2>nul || set "path=%~dp0;%path%"

echo %~fs0 %*
call :%~1 %2 %3 %4 %5 %6 %7 %8 %9
goto :End

::******************************visual studio external tool bar command interface**************************************************************************
:debugRelease
if {"%~1"}=={""} echo no 'ProjectPath' is set. & goto :eof
:: TODO
set "ProjectPath=%~f1"
goto :eof

:openFolder
set "ItemPath=%~1"
if not defined ItemPath set "ItemPath=%cd%"
if not defined ItemPath set "ItemPath=%~2"
if      defined ItemPath    call :impl start explorer.exe /select,"%ItemPath%"
if not  defined ItemPath    echo failed command : %~fs0 %*
goto :eof

:OpenExe
set "TargetPath=%~1"
if not exist "%TargetPath%"  echo 'TargetPath' doesn't exist. & goto :eof
call :impl start explorer.exe /select, "%TargetPath:\\=\%"
goto :eof

:DOS
set "ProjectDir=%~1"
if not defined ProjectDir set "ProjectDir=%cd%"
call :setLabelPrefix "%cd%"
call %~0.%labelPrefix% "%ProjectDir%"
goto :eof

:log
call :setLabelPrefix "%~fs1"
set "ItemPath=%~1"
if not defined ItemPath set "ItemPath=%cd%"
call %~0.%labelPrefix%   "%ItemPath%"
goto :eof

:diff
call :setLabelPrefix "%cd%"
set "ItemPath=%~1"
if not defined ItemPath set "ItemPath=%cd%"
call %~0.%labelPrefix%    "%ItemPath%"
goto :eof

:blame
if {"%~1"}=={""} echo no 'ItemPath' is set. & goto :eof
call :setLabelPrefix "%~fs1"
call %~0.%labelPrefix%    %*
goto :eof

:revert
if {"%~1"}=={""} echo no 'ItemPath' is set. & goto :eof
call :setLabelPrefix "%~fs1"
call %~0.%labelPrefix%    %*
goto :eof

::******************************inner section**************************************************************************
:setLabelPrefix
call tools_git.bat gitIsGitFolder "%~dp1" isGit
:: echo isGit=%isGit%
if {"%isGit%"}=={"1"}   set labelPrefix=git
if {"%isGit%"}=={"0"}   set labelPrefix=svn
:: call tools_svn.bat svnIsSvnFolder "%~1" isSvn
:: echo isSvn=%isSvn%
goto :eof

:impl
echo %*
%*
goto :eof

::******************************git section**************************************************************************

:log.git
call :impl call %myWinScriptPath%\..\..\setupEnvironment\gitCmdWrapper\logUI.cmd %*
goto :eof

:diff.git
set "ItemPath=%~1"
call :impl start TortoiseGitProc.exe /command:repostatus /path:"%ItemPath%"
:: TortoiseGitProc.exe /command:repostatus /path:"E:\work\sourceCode\JabberGit140\products\jabber-win\src\jabber-client\src\JabberApp.cpp"
goto :eof

:blame.git
call :impl call %myWinScriptPath%\..\..\setupEnvironment\gitCmdWrapper\blame.cmd %*
goto :eof

:revert.git
set "ItemPath=%~1"
call :impl start git.exe restore "%ItemPath%"
goto :eof

:DOS.git
for /f "usebackq tokens=*" %%i in ( ` git -C "%~1" rev-parse --show-toplevel  ` ) do set "gitRootPath=%%~i"
if defined gitRootPath call :impl start cmd.exe /k cd "%gitRootPath%"
goto :eof

::******************************svn section**************************************************************************
:log.svn
call :impl call %myWinScriptPath%\..\..\setupEnvironment\gitCmdWrapper\logUI.cmd
goto :eof

:diff.svn
set "ItemPath=%~1"
start TortoiseGitProc.exe /command:repostatus /path:"%ItemPath%"
goto :eof

:blame.svn
call %myWinScriptPath%\..\..\setupEnvironment\gitCmdWrapper\blame.cmd %*
goto :eof

:revert.svn
set "ItemPath=%~1"
call git.exe restore "%ItemPath%"
goto :eof


::******************************end**************************************************************************

:: *****************************************debugRelease section*****************************************************
:debugRelease.impl
call :debugRelease.backup 	%*
call :debugRelease.process 	%*

goto :eof

:debugRelease.backup
if exist "%~f1.backup" goto :eof
copy  "%~f1"  "%~f1.backup"
goto :eof

:debugRelease.process


goto :eof

:debugRelease.process.oneLine


goto :eof


::******************************end**************************************************************************

:End
