::Author    : Shen Xiaolong((xlshen@126.com))
::Copyright : free use,modify,spread, but MUST include this original two line information(Author and Copyright).

::@set _Echo=1
::set _Stack=%~nx0
::set _Debug=1
@if {"%_Echo%"}=={"1"} ( @echo on ) else ( @echo off )
@if defined _Stack @for %%a in ( 1 "%~nx0" "%0" ) do @if {"%%~a"}=={"%_Stack%"} @echo. & @echo [+++++ %~nx0] commandLine: %0 %*
where "%~nx0" 1>nul 2>nul || set "path=%~dp0;%path%"

if {"%~1"}=={""} call :Test NoOutput & goto End
call :%~1 %2 %3 %4 %5 %6 %7 %8 %9
goto :End

::[DOS_API:Help]Display help information
:Help
@if defined _Stack @for %%a in ( 1 "%~nx0" "%0" ) do @if {"%%~a"}=={"%_Stack%"} @echo [      %~nx0] commandLine: %0 %*
call tools_miscellaneous.bat DisplayHelp "%~f0"
goto :eof

::[DOS_API:Test]Test DOS API in this script file
:Test
@if defined _Stack @for %%a in ( 1 "%~nx0" "%0" ) do @if {"%%~a"}=={"%_Stack%"} @echo [      %~nx0] commandLine: %0 %*
echo.
@echo [%~nx0] Run test case [%0 %*]

echo.
echo test call :Help
call :Help

echo.
goto :eof

::[DOS_API:import2Git]import current local foler to remote git repo -- the remote repo MUST be empty
::call e.g      : call :import2Git localFolder gitUrl [optComment]
::e.g.            call :import2Git d:\myRepo https://github.com/ShenXiaolong1976/MiniMPL.git   "import local repo"      //need to input userName and password when submit
::                call :import2Git d:\myRepo https://userName:userPwd@github.com/ShenXiaolong1976/MiniMPL.git           //has login userName and password without interaction
:import2Git
@if defined _Stack @for %%a in ( 1 "%~nx0" "%0" ) do @if {"%%~a"}=={"%_Stack%"} @echo [      %~nx0] commandLine: %0 %*
call tools_error.bat checkFolderExist "%~fs1"
call tools_error.bat checkParamCount 2 %*
cd /d "%~fs1"
call :ignoreList.checkIgnoreSetting %*
call :gitCmd git init
call :modifyRepo
set "gitCommitComment=%~3"
if not defined gitCommitComment set "gitCommitComment=import localFolder to remote empty git repo.[%date% - %time%]"
call :gitCmd git commit -m "%gitCommitComment%"
call :gitCmd git remote add origin "%~2"
call :gitCmd git push -u origin master
goto :eof

::[DOS_API:update2Git]update current local foler to remote git repo -- the remote should has similiar directory structure
::call e.g      : call :update2Git localFolder gitUrl
::e.g.            call :update2Git d:\myRepo https://github.com/ShenXiaolong1976/MiniMPL.git                          //need to input userName and password when submit
::                call :update2Git d:\myRepo https://userName:userPwd@github.com/ShenXiaolong1976/MiniMPL.git         //has login userName and password without interaction
:update2Git
@if defined _Stack @for %%a in ( 1 "%~nx0" "%0" ) do @if {"%%~a"}=={"%_Stack%"} @echo [      %~nx0] commandLine: %0 %*
call tools_error.bat checkParamCount 2 %*
cd /d "%~fs1"
set "gitCommitComment=%~3"
if not defined gitCommitComment set "gitCommitComment=update localFolder to remote empty git repo.[%date% - %time%]"

if exist ".\.git\"            call :update2Git.hasGitFolder %*
if not exist ".\.git\"        call :update2Git.noGitFolder %*
goto :eof

:update2Git.hasGitFolder
@if defined _Stack @for %%a in ( 1 "%~nx0" "%0" ) do @if {"%%~a"}=={"%_Stack%"} @echo [      %~nx0] commandLine: %0 %*
echo ***!!!*** current it is git repo, synchronize it with one existing remote git repo. 
echo save current any temporary modification to prevent lost
call :gitCmd git stash
echo synchronize local repo from remote repo and updating local work space.
call :gitCmd git pull --rebase
echo update possible referenced other sub modules
call :gitCmd git submodule update --init --recursive
echo git restore previous temporary modification stored by stash , discard the save block.
call :gitCmd git stash pop
echo update done.
goto :eof

:update2Git.noGitFolder
@if defined _Stack @for %%a in ( 1 "%~nx0" "%0" ) do @if {"%%~a"}=={"%_Stack%"} @echo [      %~nx0] commandLine: %0 %*
call tools_isXXX.bat isEmptyFolder "%~fs1"  bEmptyFolder 
if {"%bEmptyFolder%"}=={"1"}        call :update2Git.checkoutRepot %*
if not {"%bEmptyFolder%"}=={"1"}    call :update2Git.push2git %*
goto :eof

:update2Git.checkoutRepot
@if defined _Stack @for %%a in ( 1 "%~nx0" "%0" ) do @if {"%%~a"}=={"%_Stack%"} @echo [      %~nx0] commandLine: %0 %*
call tools_path getFolderName "%~fs1" foldNamer
cd ..
rd "%foldNamer%"
call :gitCmd git clone "%~2" "%foldNamer%"
goto :eof

:update2Git.push2git
@if defined _Stack @for %%a in ( 1 "%~nx0" "%0" ) do @if {"%%~a"}=={"%_Stack%"} @echo [      %~nx0] commandLine: %0 %*
echo ***!!!*** current it is not git repo, synchronize it with one existing remote git repo. (create git bind relation between local and remote)
echo clone remote git repo
call :update2Git.noGitFolder.prepareGit "%~2"
call :modifyRepo
echo current git cache status
call :gitCmd git stage
call :gitCmd git status
echo commit change
call :gitCmd git commit -m "%gitCommitComment%"
echo push to git server.
call :gitCmd git push
goto :eof

:update2Git.noGitFolder.prepareGit
set "repo_url=%~1"
call :gitName "%repo_url%" repoName
set tmpRepoName=repoName%random%
call :gitCmd git clone %repo_url% %tmpRepoName%
echo.
echo copy git config foler .git to current folder
xcopy/s "%tmpRepoName%\.git" .git\  >nul
if exist "%tmpRepoName%\.gitignore" copy "%tmpRepoName%\.gitignore" .gitignore >nul
rd /s/q "%tmpRepoName%"
goto :eof

::[DOS_API:gitLocalRootPath] get current git root directory path in any git path.
::call e.g  : call :gitLocalRootPath "." gitRoot
:gitLocalRootPath
@if defined _Stack @for %%a in ( 1 "%~nx0" "%0" ) do @if {"%%~a"}=={"%_Stack%"} @echo [      %~nx0] commandLine: %0 %*
set %~2=
call tools_error.bat checkParamCount 2 %*
call tools_error.bat checkPathExist "%~1" "%~f0" gitLocalRootPathMark
call tools_message.bat enableDebugMsg "%~0" "inputPath : %~f1"
call tools_path.bat getFolderPath "%~1" _tmp_gitStdFolder
:: _tmp_gitStdFolder style : "c:\myrepo\gitFolder"
set "lastErrorText="
git -C "%_tmp_gitStdFolder%" config --get remote.origin.url 1>nul 2>nul || call tools_error.bat setLastErrorText "%~1' is not a available git repo"
call tools_error.bat getLastErrorText err2Return && goto :eof
for /f "usebackq tokens=*" %%i in ( ` git -C "%_tmp_gitStdFolder%" rev-parse --show-toplevel ` ) do set _tmpLocalPath=%%i
if defined _tmpLocalPath set "%~2=%_tmpLocalPath:/=\%"
call tools_message.bat enableDebugMsg "%~0" "output result : set %~2=%%%~2%%"
goto :eof

::[DOS_API:gitCurBranchName] get current local branch name, e.g. 12.6 , master.
::call e.g  : call :gitCurBranchName "C:\mySvnProject\main.cpp" brName
::			  call :gitCurBranchName "C:\mySvnProject"          brName
:gitCurBranchName
@if defined _Stack @for %%a in ( 1 "%~nx0" "%0" ) do @if {"%%~a"}=={"%_Stack%"} @echo [      %~nx0] commandLine: %0 %*
set "tmpPath=%~fs1"
set "gitPath=%tmpPath:\=/%"
:: git rev-parse --abbrev-ref HEAD
for /f "usebackq tokens=*" %%1 in ( ` git -C "%gitPath%" name-rev --name-only HEAD ` ) do call set "%~2=%%1"
goto :eof

::[DOS_API:gitCurRemoteBranchName] get remote branch name of current local branch is tracking. e.g. origin/12.6 or upstream/12.6
::call e.g  : call :gitCurRemoteBranchName "C:\mySvnProject\main.cpp"       brName
::			  call :gitCurRemoteBranchName "C:\mySvnProject"                brName
:gitCurRemoteBranchName
@if defined _Stack @for %%a in ( 1 "%~nx0" "%0" ) do @if {"%%~a"}=={"%_Stack%"} @echo [      %~nx0] commandLine: %0 %*
set "tmpPath=%~fs1"
set "gitPath=%tmpPath:\=/%"
for /f "usebackq tokens=*" %%1 in ( ` git -C "%gitPath%" rev-parse --abbrev-ref --symbolic-full-name @{u} ` ) do call set "%~2=%%1"
goto :eof

::[DOS_API:gitCurRemoteRepoName] update git file or directory by specified file full path. e.g. upstream or origin
::call e.g  : call :gitCurRemoteRepoName "C:\mySvnProject\main.cpp"       repoName
::			  call :gitCurRemoteRepoName "C:\mySvnProject"                repoName
:gitCurRemoteRepoName
@if defined _Stack @for %%a in ( 1 "%~nx0" "%0" ) do @if {"%%~a"}=={"%_Stack%"} @echo [      %~nx0] commandLine: %0 %*
call :gitCurBranchName "%~fs1" _tmpLocalBrName
for /f "usebackq tokens=*" %%1 in ( ` git -C "%gitPath%" config branch.%_tmpLocalBrName%.remote ` ) do call set "%~2=%%1"
goto :eof

::[DOS_API:gitIsGitFolder] detect whether one path is git folder
::call e.g  : call :gitIsGitFolder "C:\myGitProject\main.cpp" isGitFolder
:gitIsGitFolder
@if defined _Stack @for %%a in ( 1 "%~nx0" "%0" ) do @if {"%%~a"}=={"%_Stack%"} @echo [      %~nx0] commandLine: %0 %*
set %~2=0
call tools_error.bat checkParamCount 2 %*
call tools_error.bat checkPathExist "%~1"
call tools_path.bat getFolderPath "%~fs1" _tmpFolderName
call :gitLocalRootPath "%_tmpFolderName%" _tmpGitRoot
if not {"%_tmpGitRoot%"}=={""} set "%~2=1"
:: current repo might have not remote repo or remote repo is broken
::git -C "%~fs1" config --get remote.origin.url 1>nul 2>nul && set "%~2=1" || set %~2=0
goto :eof

::[DOS_API:deleteUnversionedFiles]clean unversioned git file
::call e.g  : call :deleteUnversionedFiles "C:\D\TreasureFleet_L2\mt_tf" [optional]msg
::result e.g: set msg=delete 7 files and 1 directorys!
:deleteUnversionedFiles
@if defined _Stack @for %%a in ( 1 "%~nx0" "%0" ) do @if {"%%~a"}=={"%_Stack%"} @echo [      %~nx0] commandLine: %0 %*
call tools_error.bat checkPathExist "%~1"
git -C "%~fs1" clean -ffdx
git -C "%~fs1" reset --hard
git -C "%~fs1" clean -ffdx
goto :eof

::[DOS_API:gitUpdate] update git file or directory by specified file full path.
::call e.g  : call :gitUpdate "C:\mySvnProject\main.cpp" 1
::			  call :gitUpdate "C:\mySvnProject"
:gitUpdate
@if defined _Stack @for %%a in ( 1 "%~nx0" "%0" ) do @if {"%%~a"}=={"%_Stack%"} @echo [      %~nx0] commandLine: %0 %*
set "tmpPath=%~fs1"
set "gitPath=%tmpPath:\=/%"
git -C "%gitPath%" status -uno
git -C "%gitPath%"  stash save "%~nx0 - %date:~-10% %time%"
git -C "%gitPath%"  checkout .
@for /f "usebackq tokens=*" %%1 in ( ` git -C "%gitPath%"  rev-parse --abbrev-ref --symbolic-full-name @{u} ` ) do call set "brNameRemote=%%1"
@call set "brNameRemote=%brNameRemote:*/=%"
@echo git fetch --all --progress -v
git -C "%gitPath%"  fetch --all --progress
::process possible exception
git -C "%gitPath%"  am --abort
@echo git rebase upstream/%brNameRemote%
git -C "%gitPath%"  rebase upstream/%brNameRemote%
git -C "%gitPath%" reset --hard HEAD~3
git -C "%gitPath%" pull
::below is discarded
::git submodule update --init --recursive
git -C "%gitPath%" stash apply stash@{0}
git -C "%gitPath%" stash list
call tools_message.bat noPauseMsg "%~0"
goto :eof

::[DOS_API:gitCurCommitID] get newest commit id by specified file full path.
::call e.g  : call :gitCurCommitID "C:\mySvnProject" commitID
::result 	  set commitID=d92a8f8d9a
:gitCurCommitID
@if defined _Stack @for %%a in ( 1 "%~nx0" "%0" ) do @if {"%%~a"}=={"%_Stack%"} @echo [      %~nx0] commandLine: %0 %*
set "tmpPath=%~fs1"
set "gitPath=%tmpPath:\=/%"
:: for long commit id : git rev-parse HEAD
:: git log -1 --pretty^=format:%h "D:\sourceCode\jabberGit129\products\jabber-win\src\plugins\instant-message\IMWindow\IMRenderer.cpp"
rem for /F "usebackq tokens=*" %%i in ( ` git -C "%gitPath%" log --pretty^=format:%h -n 1 ` ) do set %~1=%%i
rem @for /F "usebackq tokens=*" %%i in ( ` git rev-parse --short HEAD ` )   do @echo actual ID(short)  : %%i
rem @for /F "usebackq tokens=*" %%i in ( ` git rev-parse HEAD ` )           do @echo current commit ID : %%i
@for /F "usebackq tokens=*" %%i in ( ` git rev-parse --short HEAD ` )   do set %~1=%%i
goto :eof

::[DOS_API:gitCurCommitIDLong] get newest commit long id by specified file full path.
::call e.g  : call :gitCurCommitIDLong "C:\mySvnProject" commitID
::result 	  set commitID=b0c6b4e63015e4038c77c60e47b3f7eb7ae89713
:gitCurCommitIDLong
@if defined _Stack @for %%a in ( 1 "%~nx0" "%0" ) do @if {"%%~a"}=={"%_Stack%"} @echo [      %~nx0] commandLine: %0 %*
set "tmpPath=%~fs1"
set "gitPath=%tmpPath:\=/%"
for /F "usebackq tokens=*" %%i in ( ` git -C "%gitPath%" rev-parse HEAD ` ) do set %~1=%%i
goto :eof

::[DOS_API:gitFileByCommitID] get single file in specified commit id and store to specified path
::call e.g  : call :gitFileByCommitID commitID "C:\mySvnProject\main.cpp" "d:\temp\main.cpp"
:gitFileByCommitID
@if defined _Stack @for %%a in ( 1 "%~nx0" "%0" ) do @if {"%%~a"}=={"%_Stack%"} @echo [      %~nx0] commandLine: %0 %*
set "tmpPath=%~fs1"
set "gitPath=%tmpPath:\=/%"
:: cmd : (verified)
:: git -C "D:\sourceCode\jabberGit129" show d92a8f8d9a:products/.../IMRenderer.cpp > D:\work\...\IMRenderer_1.cpp
goto :eof

::[DOS_API:gitLogUI] show git log in dialog.
::call e.g  : call :gitLogUI "C:\mySvnProject\main.cpp"
::			  call :gitLogUI "C:\mySvnProject"
:gitLogUI
@if defined _Stack @for %%a in ( 1 "%~nx0" "%0" ) do @if {"%%~a"}=={"%_Stack%"} @echo [      %~nx0] commandLine: %0 %*
call tools_path.bat getFolderPath "%~f1" _tmpDir
cd /d "%_tmpDir%"
set "tmpGitSrc=%~f1"
gitk "%tmpGitSrc:\=/%"
goto :eof

::[DOS_API:gitLogCmd] show git log in console windows.
::call e.g  : call :gitLogCmd "C:\mySvnProject\main.cpp"
::			  call :gitLogCmd "C:\mySvnProject"
:gitLogCmd
@if defined _Stack @for %%a in ( 1 "%~nx0" "%0" ) do @if {"%%~a"}=={"%_Stack%"} @echo [      %~nx0] commandLine: %0 %*
call tools_path.bat getFolderPath "%~f1" _tmpDir
cd /d "%_tmpDir%"
set "tmpGitSrc=%~f1"
git log "%tmpGitSrc:\=/%"
goto :eof

::[DOS_API:gitVerUI] show log with specified commit id
::call e.g  : call :gitVerUI commitID
::			  call :gitVerUI 278f3d48bfdccaaf62f7fea50e5d6a96da72803c
:gitVerUI
@if defined _Stack @for %%a in ( 1 "%~nx0" "%0" ) do @if {"%%~a"}=={"%_Stack%"} @echo [      %~nx0] commandLine: %0 %*
call tools_path.bat getFolderPath "%~f1" _tmpDir
cd /d "%_tmpDir%"
call set "gitCommitID=%~2"
if {"%gitCommitID%"}=={""} call :gitCommitId.waitInput  gitCommitID
:: start gitk %gitCommitID%
start TortoiseGitProc.exe /command:log /path:"%cd%" /rev:%gitCommitID%
goto :eof

::[DOS_API:gitVerCmd] show log with specified commit id
::call e.g  : call :gitVerCmd commitID
::			  call :gitVerCmd 278f3d48bfdccaaf62f7fea50e5d6a96da72803c
:gitVerCmd
@if defined _Stack @for %%a in ( 1 "%~nx0" "%0" ) do @if {"%%~a"}=={"%_Stack%"} @echo [      %~nx0] commandLine: %0 %*
call tools_path.bat getFolderPath "%~f1" _tmpDir
cd /d "%_tmpDir%"
call set "gitCommitID=%~2"
if {"%gitCommitID%"}=={""} call :gitCommitId.waitInput  gitCommitID
git show "%gitCommitID%" --no-patch
goto :eof

::[DOS_API:gitDiff] display git file modify with previous version by full item path.
::call e.g  : call :gitDiff "C:\mySvnProject\main.cpp"
:gitDiff
@if defined _Stack @for %%a in ( 1 "%~nx0" "%0" ) do @if {"%%~a"}=={"%_Stack%"} @echo [      %~nx0] commandLine: %0 %*
::TortoiseProc.exe /command:diff /path:"%~f1" /startrev:170 /endrev:190
TortoiseGitProc.exe /command:repostatus /path:"%~f1"
goto :eof

::[DOS_API:gitBackupCommit] backup modify source files which are only committed to remote. (part commit)
::syntax    :   call :gitBackupCommit projectPath  backupPath
::call e.g  :   call :gitBackupCommit "C:\jabber118\product\win\client"    "D:\backupSrc" 
::              call :gitBackupCommit "C:\jabber118\product\win\client"    //use default : C:\jabber118\product\win\client\jabber118_bak_%date%%time%
:gitBackupCommit
@if defined _Stack @for %%a in ( 1 "%~nx0" "%0" ) do @if {"%%~a"}=={"%_Stack%"} @echo [      %~nx0] commandLine: %0 %*
call :gitIsGitFolder "%~1" isGitProject
if not {"%isGitProject%"}=={"1"} call tools_message.bat errorMsg "%~1 is not git repo path."
call :gitLocalRootPath "%~1" gitProjectRoot
::call set "DefaultBackupPathRoot=%~f1\gitBackupSrc"
if not defined backupMode   set backupMode=gitBackupCommit
call :gitBackupSrc "%gitProjectRoot%" %2
goto :eof

::[DOS_API:gitBackupRootSrc] backup modify source files to specified path
::syntax    :   call :gitBackupRootSrc projectPath  backupPath
::call e.g  :   call :gitBackupRootSrc "C:\jabber118\product\win\client"    "D:\backupSrc" 
::              call :gitBackupRootSrc "C:\jabber118\product\win\client"    //use default : C:\jabber118\product\win\client\jabber118_bak_%date%%time%
:gitBackupRootSrc
@if defined _Stack @for %%a in ( 1 "%~nx0" "%0" ) do @if {"%%~a"}=={"%_Stack%"} @echo [      %~nx0] commandLine: %0 %*
call :gitIsGitFolder "%~1" isGitProject
if not {"%isGitProject%"}=={"1"} call tools_message.bat errorMsg "%~1 is not git repo path."
call :gitLocalRootPath "%~1" gitProjectRoot
::call set "DefaultBackupPathRoot=%~f1\gitBackupSrc"
call :gitBackupSrc "%gitProjectRoot%" %2
goto :eof

::[DOS_API:getCaseSensitiveePath] in some similiar linux system(e.g. git), the path is case sensitive, but window path is not case sensitive. here convert existed window path to similiar linux path
::syntax    :   call :getCaseSensitiveePath gitRepoFilePath  outputVar
::call e.g  :   call :getCaseSensitiveePath "E:\work\sourceCode\Jabber140\products\jabber-win\src\plugins\ContactsSearchPlugin\ContactTree.cpp" outputVar
::              call :getCaseSensitiveePath "E:\work\sourceCode\Jabber140\products\jabber-win\src\plugins\ContactsSearchPlugin\ContactTree.cpp"                   //use default : just show new value
:getCaseSensitiveePath
@for %%a in ( 1 "%~nx0" "%0" %EchoCmdList% ) do @if {"%%~a"}=={"%EchoCmd%"} @echo [%~nx0] commandLine: %0 %*
if not exist "%~fs1" goto :eof
for /f "usebackq tokens=4" %%i in ( ` fsutil file queryfileid "%~fs1" ` ) do set fileID=%%i
if defined _Debug echo fileID=%fileID%
for /f "usebackq tokens=*" %%i in ( ` fsutil file queryFileNameById %~d1\ %fileID% ` ) do set "filePath=%%i"
if defined _Debug echo filePath=%filePath%
if not  {"%~2"}=={""} set "%~2=%filePath:*\\?\=%"
if      {"%~2"}=={""} echo %filePath:*\\?\=%
goto :eof

::[DOS_API:gitBackupSrc] backup modify source files to specified path
::syntax    :   call :gitBackupSrc projectPath  backupPath
::call e.g  :   call :gitBackupSrc "C:\jabber118" "D:\backupSrc" 
::              call :gitBackupSrc "C:\jabber118"                   //use default : C:\jabber118\jabber118_bak_%date%%time%
:gitBackupSrc
@if defined _Stack @for %%a in ( 1 "%~nx0" "%0" ) do @if {"%%~a"}=={"%_Stack%"} @echo [      %~nx0] commandLine: %0 %*
call :BackupSrc.processInput %*
if exist %bk_dstPath% del/f/q %bk_dstPath%
if not exist %bk_dstPath% md %bk_dstPath%
call :gitCurBranchName          "%bk_SrcPath%"  _localBr
call :gitCurRemoteBranchName    "%bk_SrcPath%"  _remoteBr
if not defined backupMode       set backupMode=gitBackupSrc
echo.
set srcBakNote=%bk_dstPath%\bakupLog.txt
echo begin gitBackupSrc log > "%srcBakNote%"
(
@echo git local branch  : %_localBr%
@echo git remote branch : %_remoteBr%
@if defined backupMsg @echo "%backupMsg%"
@echo backup git modified files. [%date% - %time%]
call :BackupSrc.executeBackup
echo.
call :BackupSrc.createRestoreScript
@echo.
@echo [complete backup] %bk_SrcPath%  =^>  %bk_dstPath%
@echo.
) >> "%srcBakNote%"
type "%srcBakNote%"
if not defined NotOpenFolder start "" "%bk_dstPath%"
call tools_message.bat noPauseMsg "%~0"
goto :eof

:BackupSrc.processInput
@if defined _Stack @for %%a in ( 1 "%~nx0" "%0" ) do @if {"%%~a"}=={"%_Stack%"} @echo [      %~nx0] commandLine: %0 %*
call :gitIsGitFolder "%~1" isGitProject
if not {"%isGitProject%"}=={"1"} call tools_message.bat errorMsg "%~1 is not git repo path."

set "bk_SrcPath=%~f1"
call tools_message.bat enableDebugMsg "%~0" "bk_SrcPath=%bk_SrcPath%"

if not defined DefaultBackupPathRoot set "DefaultBackupPathRoot=%bk_SrcPath%\gitBackupSrc"
if {"%~2"}=={""} (
set "backupPathRoot=%DefaultBackupPathRoot%\gitBackup"
) else (
set "backupPathRoot=%~2"
)

if {"%backupPathRoot:~-1%"}=={"\"} call set "backupPathRoot=%backupPathRoot:~0,-1%"
call genNameByTime.bat dtInfo
::set bk_dstPath=%backupPathRoot%\%~n1_bak_%bk_SrcPath:*\=%\%dtInfo%
set "bk_dstDataFolder=\%~n1"
call set "bk_dstPath=%backupPathRoot%\%~n1_bak\%dtInfo%"
call tools_message.bat enableDebugMsg "%~0" "bk_dstPath=%bk_dstPath%"
goto :eof

:BackupSrc.createRestoreScript
@if defined _Stack @for %%a in ( 1 "%~nx0" "%0" ) do @if {"%%~a"}=={"%_Stack%"} @echo [      %~nx0] commandLine: %0 %*
::different PC use different script absolute path
call :gitLocalRootPath "%bk_SrcPath%" _curGitRoot
call set "innerPath=%%bk_SrcPath:%_curGitRoot%=%%"
(
echo if not defined repo set "repo=%_curGitRoot%"
echo %%myWinScriptPath%%\common\%~nx0 gitRestoreSrc "%%~dp0%bk_dstDataFolder%" "%%repo%%%innerPath%"
) > "%bk_dstPath%\restoreSrc.bat"
echo "%bk_dstPath%\restoreSrc.bat" is created.
echo.
goto :eof

:BackupSrc.executeBackup
@if defined _Stack @for %%a in ( 1 "%~nx0" "%0" ) do @if {"%%~a"}=={"%_Stack%"} @echo [      %~nx0] commandLine: %0 %*
if {"%backupMode%"}=={"gitBackupSrc"}       call :BackupSrc.executeBackup.all %*
if {"%backupMode%}=={"gitBackupCommit"}     call :BackupSrc.executeBackup.commitPart %*
set backupMode=
goto :eof

:BackupSrc.executeBackup.all
@if defined _Stack @for %%a in ( 1 "%~nx0" "%0" ) do @if {"%%~a"}=={"%_Stack%"} @echo [      %~nx0] commandLine: %0 %*
::generate update information from git commandline
set "fileList=%bk_dstPath%\bakFileList.txt"
git -C "%bk_SrcPath%" status -s | find /v "??" > %fileList%
echo. 

:: impl backup
title backup modify : %bk_SrcPath%  =^>  %bk_dstPath%
echo backup modify : %bk_SrcPath%  =^>  %bk_dstPath%
rem call :setReplacePath "%cd%" "%bk_SrcPath%"
for /f  "tokens=1,2 " %%i in ( %fileList% ) do (
if {%%i}=={M} call :BackupSrc.backupSingle "%%j"
if {%%i}=={A} call :BackupSrc.addSingle    "%%j"
if {%%i}=={D} call :BackupSrc.deleteSingle "%%j"
)
goto :eof

:BackupSrc.executeBackup.commitPart
@if defined _Stack @for %%a in ( 1 "%~nx0" "%0" ) do @if {"%%~a"}=={"%_Stack%"} @echo [      %~nx0] commandLine: %0 %*
::generate update information from git commandline
set "fileList=%bk_dstPath%\bakFileList.txt"
git -C "%bk_SrcPath%" status -uno | find /i "modified:" > %fileList%
echo. 

type %fileList%
call tools_message.bat warningMsg "only has modified part, has not add/delete part, need update script."

:: impl backup
title backup modify : %bk_SrcPath%  =^>  %bk_dstPath%
echo backup modify : %bk_SrcPath%  =^>  %bk_dstPath%
rem call :setReplacePath "%cd%" "%bk_SrcPath%"
for /f  "tokens=1,2 " %%i in ( %fileList% ) do (
if {"%%i"}=={"modified:"} call :BackupSrc.backupSingle "%%j"
::if {%%i}=={A} call :BackupSrc.addSingle    "%%j"
::if {%%i}=={D} call :BackupSrc.deleteSingle "%%j"
)
goto :eof

:BackupSrc.deleteSingle
@if defined _Stack @for %%a in ( 1 "%~nx0" "%0" ) do @if {"%%~a"}=={"%_Stack%"} @echo [      %~nx0] commandLine: %0 %*
if not defined deletedPath  set "deletedPath=%bk_dstPath%\deletedFiles.txt"
echo %~1     > "%deletedPath%"
echo delete : %~f1
goto :eof

:BackupSrc.addSingle
@if defined _Stack @for %%a in ( 1 "%~nx0" "%0" ) do @if {"%%~a"}=={"%_Stack%"} @echo [      %~nx0] commandLine: %0 %*
if not defined addedPath  set "addedPath=%bk_dstPath%\addedFiles.txt"
echo %~1     > "%addedPath%"
echo add : %~f1
call :BackupSrc.backupSingle "%~f1"
goto :eof

:BackupSrc.backupSingle
@if defined _Stack @for %%a in ( 1 "%~nx0" "%0" ) do @if {"%%~a"}=={"%_Stack%"} @echo [      %~nx0] commandLine: %0 %*
::generate update information from git commandline
set "srcFile=%~dpnx1"
call set "dstFile=%%srcFile:%bk_SrcPath%=%bk_dstPath%%bk_dstDataFolder%%%"
set "srcDir=%~dp1"
call set "dstDir=%%srcDir:%bk_SrcPath%=%bk_dstPath%%bk_dstDataFolder%%%"
if not exist "%dstDir%" md "%dstDir%"
set curCmd=copy "%srcFile%" "%dstFile%"
%curCmd% 1> nul
if {%errorlevel%}=={0} (
set/p=[  OK ] <nul
) else (
set/p=[Fails] <nul
)
echo %dstFile:~-127%
goto :eof

::[DOS_API:gitRestoreSrc] restore git file from backup folder
::syntax              call :gitRestoreSrc backupPath projectPath
::call e.g  : call :gitRestoreSrc "C:\test\jabber118\20180129_170432" "C:\jabber118"
:gitRestoreSrc
@if defined _Stack @for %%a in ( 1 "%~nx0" "%0" ) do @if {"%%~a"}=={"%_Stack%"} @echo [      %~nx0] commandLine: %0 %*
set _Debug=1
if not exist "%~f2" (
call colorTxt.bat cyan_L "%~f2 is not git path."
echo.
pause
goto :End
)
set rs_srcPath=%~f1
if {%rs_srcPath:~-1%}=={\} set rs_srcPath=%rs_srcPath:~0,-1%

if not exist "%~f1" (
call colorTxt.bat cyan_L "%~f1 is not git path."
echo.
pause
goto :End
)
set rs_dstPath=%~f2
echo restore : %rs_srcPath% =^> %rs_dstPath%
::for /f "usebackq tokens=* " %%a in ( ` dir/b/a:d "%rs_srcPath%" ` ) do call :RestoreSrc.processFolder "%%a"
call :RestoreSrc.processFolder "%rs_srcPath%"
echo.

echo.
set "deletedPath=%~dp1deletedFiles.txt"
if exist "%deletedPath%" call :gitRestoreSrc.deletePath "%~fs2" "%deletedPath%"
echo.

echo.
set "addedPath=%~dp1addedFiles.txt"
if exist "%addedPath%" call :gitRestoreSrc.addPath "%~fs2" "%addedPath%"
echo.

echo.
echo restore complete.
pause
explorer.exe "%rs_dstPath%"
goto :eof

:gitRestoreSrc.deletePath
@if defined _Stack @for %%a in ( 1 "%~nx0" "%0" ) do @if {"%%~a"}=={"%_Stack%"} @echo [      %~nx0] commandLine: %0 %*
echo deleting repo ... 
for /f "usebackq tokens=*" %%i in ( ` type "%~fs2" ` ) do call :gitRestoreSrc.deletePath.deleteOne "%~fs1\%%i"
goto :eof

:gitRestoreSrc.deletePath.deleteOne
@if defined _Stack @for %%a in ( 1 "%~nx0" "%0" ) do @if {"%%~a"}=={"%_Stack%"} @echo [      %~nx0] commandLine: %0 %*
if not exist "%~fs1" goto :eof
call tools_path.bat isFolderExist "%~fs1" bFolder
echo delete : %~fs1
set gitPath=%~dp1
git -C "%gitPath:~0,-1%" rm "%~fs1"
if {"%bFolder%"}=={"1"}         set pathType=directory
if not {"%bFolder%"}=={"1"}     set pathType=file
if not exist "%~fs1" echo [ OK   ] deleted %pathType%   "%~fs1" 
if exist "%~fs1"     echo [ fail ] deleted %pathType%   "%~fs1"
goto :eof

:gitRestoreSrc.addPath
@if defined _Stack @for %%a in ( 1 "%~nx0" "%0" ) do @if {"%%~a"}=={"%_Stack%"} @echo [      %~nx0] commandLine: %0 %*
echo adding repo ... 
for /f "usebackq tokens=*" %%i in ( ` type "%~fs2" ` ) do call :gitRestoreSrc.addPath.addOne "%~fs1\%%i"
goto :eof

:gitRestoreSrc.addPath.addOne
@if defined _Stack @for %%a in ( 1 "%~nx0" "%0" ) do @if {"%%~a"}=={"%_Stack%"} @echo [      %~nx0] commandLine: %0 %*
if not exist "%~fs1" goto :eof
echo add : %~fs1
set gitPath=%~dp1
git -C "%gitPath:~0,-1%" add "%~fs1"
goto :eof

::[DOS_API:configGit]configure general git to simply apply on windows platform
::call e.g      : call :configGit localFolder
:configGit
@if defined _Stack @for %%a in ( 1 "%~nx0" "%0" ) do @if {"%%~a"}=={"%_Stack%"} @echo [      %~nx0] commandLine: %0 %*
:: //[GitCfgLevel]1:--global 2:--system 3:current project
if not defined GitCfgLevel      set GitCfgLevel=2
if {"%GitCfgLevel%"}=={"3"}     call tools_error.bat checkFolderExist "%~fs1" & if not {"%cd%"}=={"%~f1"} cd /d "%~fs1"

if not defined bGitCfgSavePwd           set bGitCfgSavePwd=1
if not defined bGitCfgNoLFConvert       set bGitCfgNoLFConvert=1
if not defined bGitCfgNoLogInteraction  set bGitCfgNoLogInteraction=1

if not defined bGitCfgAutoRebaseWhenPull    set bGitCfgAutoRebaseWhenPull=1
if not defined bGitCfgAutoRebaseWhenPush    set bGitCfgAutoRebaseWhenPush=1
if not defined bGitCfgIgnoreFileModeChage   set bGitCfgIgnoreFileModeChage=1

call :configGit.configLevel configureLevel %GitCfgLevel%

if {"%bGitCfgSavePwd%"}=={"1"} (
echo save password for current git repo :%~1
call :gitCmd git config %configureLevel% credential.helper store
)

if {"%bGitCfgNoLFConvert%"}=={"1"} (
echo commit/pull repo without LF CR convert :%~1
call :gitCmd git config %configureLevel% core.autocrlf false
)

if {"%bGitCfgNoLogInteraction%"}=={"1"} (
echo disable user interaction to view all log:%~1
call :gitCmd git config %configureLevel%  pager.log false
)

if {"%bGitCfgAutoRebaseWhenPull%"}=={"1"} (
echo enable auto rebase when update local repo [pull] , instead of merge :%~1
call :gitCmd git config %configureLevel% pull.rebase true
)

if {"%bGitCfgAutoRebaseWhenPush%"}=={"1"} (
echo enable auto rebase when update remote repo [push] , instead of merge :%~1
call :gitCmd git config %configureLevel% branch.autoSetupRebase always
)

if {"%bGitCfgIgnoreFileModeChage%"}=={"1"} (
echo ignore file mode [privilege] change because of different OS platform difference :%~1
call :gitCmd git config %configureLevel% core.filemode false
)

goto :eof

::[DOS_API:gitName]resolve the git repo name from one git repo url
::usage         : call :gitName gitUrl outputName
::e.g           : call :gitName "https://github.com/ShenXiaolong1976/MiniMPL.git"  oName
::                set oName=MiniMPL
:gitName
@if defined _Stack @for %%a in ( 1 "%~nx0" "%0" ) do @if {"%%~a"}=={"%_Stack%"} @echo [      %~nx0] commandLine: %0 %*
set "%~2=%~n1"
goto :eof

::[DOS_API:getLocalBrName]get git local branch name in 
::usage         : call :getLocalBrName outputName
::e.g           : call :getLocalBrName oName
::                set oName=12.8
:getLocalBrName
@if defined _Stack @for %%a in ( 1 "%~nx0" "%0" ) do @if {"%%~a"}=={"%_Stack%"} @echo [      %~nx0] commandLine: %0 %*
rem for /f "usebackq tokens=*" %%1 in ( ` git name-rev --name-only HEAD ` ) do call set "localBrName=%%1"
for /f "usebackq tokens=*" %%i in ( ` git name-rev --name-only HEAD ` ) do call set "%~1=%%i"
goto :eof

::[DOS_API:getRemoteBrName]get remote origin branch name
::usage         : call :getRemoteBrName outputName
::e.g           : call :getRemoteBrName oName
::                set oName=origin/12.8
:getRemoteBrName
@if defined _Stack @for %%a in ( 1 "%~nx0" "%0" ) do @if {"%%~a"}=={"%_Stack%"} @echo [      %~nx0] commandLine: %0 %*
rem for /f "usebackq tokens=*" %%1 in ( ` git rev-parse --abbrev-ref --symbolic-full-name @{u} ` ) do call set "remoteBrName=%%1"
for /f "usebackq tokens=*" %%i in ( ` git rev-parse --abbrev-ref --symbolic-full-name @{u} ` ) do call set "%~1=%%i"
goto :eof

::[DOS_API:getRemoteBrNameShort]get remote origin branch name without origin name
::usage         : call :getRemoteBrNameShort outputName
::e.g           : call :getRemoteBrNameShort oName
::                set oName=12.8
:getRemoteBrNameShort
@if defined _Stack @for %%a in ( 1 "%~nx0" "%0" ) do @if {"%%~a"}=={"%_Stack%"} @echo [      %~nx0] commandLine: %0 %*
rem for /f "usebackq tokens=*" %%1 in ( ` git rev-parse --abbrev-ref --symbolic-full-name @{u} ` ) do call set "remoteBrName=%%1"
for /f "usebackq tokens=*" %%i in ( ` git rev-parse --abbrev-ref --symbolic-full-name @{u} ` ) do call set "_tmpRemoteBrName=%%i"
set "%~1=%_tmpRemoteBrName:origin/=%"
goto :eof

::[DOS_API:showModifiedFileList]get modified file list in current git repo
::usage         : call :showModifiedFileList
::e.g           : call :showModifiedFileList
::                set oName=MiniMPL
:showModifiedFileList
@if defined _Stack @for %%a in ( 1 "%~nx0" "%0" ) do @if {"%%~a"}=={"%_Stack%"} @echo [      %~nx0] commandLine: %0 %*
git ls-files --modified --others
goto :eof

::[DOS_API:createPatch] create one patch for last commit
::usage         : call :createPatch
::e.g           : call :createPatch
:createPatch
@if defined _Stack @for %%a in ( 1 "%~nx0" "%0" ) do @if {"%%~a"}=={"%_Stack%"} @echo [      %~nx0] commandLine: %0 %*
rem https://stackoverflow.com/questions/4126300/git-how-to-get-all-the-files-changed-and-new-files-in-a-folder-or-zip
rem git diff HEAD^ HEAD > a.patch
git diff HEAD^ HEAD > "%~dpn1.patch"
goto :eof

::[DOS_API:applyPatch]apply one patch in current git branch
::usage         : call :applyPatch
::e.g           : call :applyPatch
:applyPatch
@if defined _Stack @for %%a in ( 1 "%~nx0" "%0" ) do @if {"%%~a"}=={"%_Stack%"} @echo [      %~nx0] commandLine: %0 %*
rem patch -p1 < a.patch
patch -p1 < "%~f1"
goto :eof


::[DOS_API:ignoreList]ignore some folder and files which lists in one files when push to remote git server for some reason, e.g private/pwd files
::usage         : call :ignoreList
::e.g           : call :ignoreList                          //it will seek variable gitIgnoreListFile
::              : call :ignoreList d:\temp\FileList.txt
:ignoreList
@if defined _Stack @for %%a in ( 1 "%~nx0" "%0" ) do @if {"%%~a"}=={"%_Stack%"} @echo [      %~nx0] commandLine: %0 %*
set tmpListFile=%~fs1
if not defined tmpListFile call :ignoreList.checkIgnoreSetting %*
if not defined tmpListFile set "tmpListFile=%gitIgnoreListFile%"
if not exist "%tmpListFile%" goto :eof
set "gitIgnoreFile=%cd%\.gitignore"
if not exist "%gitIgnoreFile%" (
call :ignoreList.newAdd
) else (
call :ignoreList.append
)
call :ignoreList.commit
goto :eof

:ignoreList.checkIgnoreSetting
@if defined _Stack @for %%a in ( 1 "%~nx0" "%0" ) do @if {"%%~a"}=={"%_Stack%"} @echo [      %~nx0] commandLine: %0 %*
if defined noIgnoreFileList goto :eof
if not exist "%gitIgnoreListFile%" (
echo.
echo defined noIgnoreFileList variable to disable this warningMsg explictly.
echo or defined gitIgnoreListFile variable point to one ignore file list to filter private files.
call tools_message.bat warningMsg "no noIgnoreFileList or gitIgnoreListFile is defined, any private files will be push to remote server."
)
goto :eof

:ignoreList.commit
@if defined _Stack @for %%a in ( 1 "%~nx0" "%0" ) do @if {"%%~a"}=={"%_Stack%"} @echo [      %~nx0] commandLine: %0 %*
if not {"%ignoreListNeedCommit%"}=={"1"} goto :eof
echo.
call :gitCmd git stash
::call :gitCmd git rm --cached "*"
call :gitCmd git add "%gitIgnoreFile%"
call :gitCmd git commit -m "commit ignore list update."
call :gitCmd git stash pop
set ignoreListNeedCommit=
goto :eof

:ignoreList.newAdd
@if defined _Stack @for %%a in ( 1 "%~nx0" "%0" ) do @if {"%%~a"}=={"%_Stack%"} @echo [      %~nx0] commandLine: %0 %*
copy "%tmpListFile%" "%gitIgnoreFile%" > nul
echo new added ignore file/folder list : %gitIgnoreFile%
type %gitIgnoreFile%
set ignoreListNeedCommit=1
goto :eof

:ignoreList.append
@if defined _Stack @for %%a in ( 1 "%~nx0" "%0" ) do @if {"%%~a"}=={"%_Stack%"} @echo [      %~nx0] commandLine: %0 %*
if exist "%gitIgnoreFile%" call :ignoreList.findIncrement "%gitIgnoreFile%" "%tmpListFile%" tmpIncrement
if defined tmpIncrement set ignoreListNeedCommit=1
if defined tmpIncrement call :ignoreList.append.show
if defined tmpIncrement for /f "usebackq tokens=*" %%i in ( ` type "%tmpIncrement%" `  ) do @ @echo %%i  >> "%gitIgnoreFile%"
goto :eof

:ignoreList.append.show
@if defined _Stack @for %%a in ( 1 "%~nx0" "%0" ) do @if {"%%~a"}=={"%_Stack%"} @echo [      %~nx0] commandLine: %0 %*
echo new added ignore file/folder list : %gitIgnoreFile%
type %gitIgnoreFile%
goto :eof

:ignoreList.findIncrement
@if defined _Stack @for %%a in ( 1 "%~nx0" "%0" ) do @if {"%%~a"}=={"%_Stack%"} @echo [      %~nx0] commandLine: %0 %*
set %~3=
call tools_isXXX.bat isSameFile "%~fs1" "%~fs2" bSameFile
if {"%bSameFile%"}=={"1"} goto :eof
set "tmpfindIncrement=%temp%\%~n1_add%random%.txt"
call tools_txtFile.bat FindFileAddition "%~fs1" "%~fs2" "%tmpfindIncrement%"
call tools_isXXX.bat isEmptyFile "%tmpfindIncrement%" bEmpty
if not {"%bEmpty%"}=={"1"} set "%~3=%tmpfindIncrement%"
goto :eof

::[DOS_API:sshkey]generate ssh key in specific folder
::usage         : call :sshkey localFolder  outFileName [optComment]
::e.g           : call :sshkey d:\myTempFolder  outFileName
::                call :sshkey d:\myTempFolder  outFileName  "comment to generate ssh key"
:sshkey
@if defined _Stack @for %%a in ( 1 "%~nx0" "%0" ) do @if {"%%~a"}=={"%_Stack%"} @echo [      %~nx0] commandLine: %0 %*
call tools_error.bat checkParamCount 2 %*
call tools_error.bat checkFolderExist "%~fs1"
cd /d "%~fs1"
if exist "%~2" del /f/q  "%~2"
if exist "%~2.pub" del /f/q  "%~2.pub"

set "sshkeyComment=%~3"
if not defined sshkeyComment set "sshkeyComment=generate ssh key for %userName%. [%date%-%time%]"

echo create ssh key-pair (public key and private key)
::https://help.github.com/en/articles/generating-a-new-ssh-key-and-adding-it-to-the-ssh-agent
ssh-keygen -t rsa -b 4096 -C "%sshkeyComment%" -f %~2
echo %~2 and %~2.pub is generated.
echo %~2 is your private key , please save it to safe place
echo %~2.pub is your public key , you can publish it for access your files.
dir *.pub
echo transfer public key to github : Settings --  SSH and GPG keys
goto :eof

:: *********************************************inner implement *******************************************************************
:RestoreSrc.processFolder
@if defined _Stack @for %%a in ( 1 "%~nx0" "%0" ) do @if {"%%~a"}=={"%_Stack%"} @echo [      %~nx0] commandLine: %0 %*
for /f "usebackq tokens=* " %%a in ( ` dir/s/b/a:a "%rs_srcPath%" ` ) do call :RestoreSrc.processFile "%%a"
goto :eof

:RestoreSrc.processFile
@if defined _Stack @for %%a in ( 1 "%~nx0" "%0" ) do @if {"%%~a"}=={"%_Stack%"} @echo [      %~nx0] commandLine: %0 %*
set rs_srcFile=%~f1
call tools_message.bat enableDebugMsg "%~0" "rs_srcFile=%rs_srcFile%"
call set rs_dstFile=%%rs_srcFile:%rs_srcPath%=%rs_dstPath%%%
call tools_message.bat enableDebugMsg "%~0" "rs_dstFile=%rs_dstFile%"  & echo.
set curCmd= copy/y "%rs_srcFile%"   %rs_dstFile%
rem set curCmd= echo "%rs_srcFile%"   %rs_dstFile%
%curCmd% 1> nul
if {%errorlevel%}=={0} (
set/p=[  OK ] <nul
) else (
set/p=[Fails] <nul
pause
)
echo %rs_srcFile:~-100%
goto :eof

:gitCommitId.waitInput
@if defined _Stack @for %%a in ( 1 "%~nx0" "%0" ) do @if {"%%~a"}=={"%_Stack%"} @echo [      %~nx0] commandLine: %0 %*
set waitStringPrompt=please input query git commit ID.
call tools_userInput.bat waitConfirm waitString %~1
goto :eof

:: *********************************************private support tool *******************************************************************
:configGit.configLevel
@if defined _Stack @for %%a in ( 1 "%~nx0" "%0" ) do @if {"%%~a"}=={"%_Stack%"} @echo [      %~nx0] commandLine: %0 %*
if {"%~2"}=={"1"} set %~1=--global
if {"%~2"}=={"2"} set %~1=--system
if {"%~2"}=={"3"} set %~1=
goto :eof

:gitCmd
@if defined _Stack @for %%a in ( 1 "%~nx0" "%0" ) do @if {"%%~a"}=={"%_Stack%"} @echo [      %~nx0] commandLine: %0 %*
if {"%~2"}=={"push"} call :gitPushConfirm
@title %*
echo %*
%*
echo.
goto :eof

:modifyRepo
@if defined _Stack @for %%a in ( 1 "%~nx0" "%0" ) do @if {"%%~a"}=={"%_Stack%"} @echo [      %~nx0] commandLine: %0 %*
call :ignoreList
if not defined userAction.gitModify set "userAction.gitModify=:gitCmd git add ."
call %userAction.gitModify%
goto :eof

:gitPushConfirm
@if defined _Stack @for %%a in ( 1 "%~nx0" "%0" ) do @if {"%%~a"}=={"%_Stack%"} @echo [      %~nx0] commandLine: %0 %*
call :gitCmd git branch -a -vv
if defined noGitPushConfim goto :eof
echo ******************* !!! Confirm !!!************************************
call tools_message.bat promptMsg "press any key to confir pushing any change to remote git server!"
goto :eof

:End
@if defined _Stack @for %%a in ( 1 "%~nx0" "%0" ) do @if {"%%~a"}=={"%_Stack%"} @echo [----- %~nx0] commandLine: %0 %* & @echo.