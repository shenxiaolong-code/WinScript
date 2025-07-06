echo
# Remote-SSH: kill VS Code Server on Host...
# ps | grep node | awk '{print $2}' | xargs kill -9 
# killall node      -- maybe kill other's process

dumpinfox "try only unstall the vscode server, instead of all vscode to reduce the effort"
dumpinfo "Ctrl + shift + p : Remote-SSH : uninstall vscode server from host"
dumpinfo "exit vscode server and login 303 with windows terminal"
dumpinfo "rm ~/.vscode-server"
dumperr  "mv ${EXT_DIR}/vscode_space/vscode_server  ${EXT_DIR}/vscode_space/vscode_server_old"
dumpinfo "mkdir ${EXT_DIR}/vscode_space/vscode_server"
dumpinfo "ln -s ${EXT_DIR}/vscode_space/vscode_server ~/.vscode-server"
dumpinfo "login vscode again to reinstall vscode"
pause

dumpinfox "uninstall vscode server best pratice"
echo ".1 close any vscode application"
echo ".2 ssh login 303 twice to open two terminal, instead of vscode.  one is used to run uninstall script, another is used to process exception "
echo ".3 open a local window termianl to uninstall local vscode."
echo

dumpinfox "uninstall local local vscode"
echo "${brown}C:\\work\\OneDrive\\work_skills\\svnRepo\\shenxiaolong\\setupEnvironment\\setup_vscode\\reinstall\\_vscode_uninstall.bat ${end}"
echo "${green}it will call '${brown} C:\\work\\OneDrive\\work_skills\\svnRepo\\shenxiaolong\\setupEnvironment\\setup_vscode\\reinstall\\_vscode_uninstall_remote_server.bat ${green}' in windows platform ${end}"
echo 

dumpinfox "kill all vscode process in 303 linux terminal ( login by ${brown}ssh303 ${green})"
echo "before kill vscode process : "
ps -a | grep $USER | grep vscode_server
kill -9 $(ps -a | grep $USER | grep vscode_server | awk '{print $2}')
echo "after kill vscode process : "
ps -a | grep $USER | grep vscode_server
dumpinfo "confirm no vscode process and and press any key to continue"
echo
pause

dumpinfox "delete all vscode install directory and related symbol link"
echo "the vscode server directory : ${HOME}/.vscode-server"
lla ${HOME}/.vscode-server
echo "remove the vscode server folder : ${EXT_DIR}/vscode_space/vscode_server "
rm -rf "${EXT_DIR}/vscode_space/vscode_server"
if [[ -d ${EXT_DIR}/vscode_space/vscode_server ]] ; then
    dumperr "${EXT_DIR}/vscode_space/vscode_server is not deleted sucessfull"
    echo "please delete this folder manual in second 303 linux terminal first"
    dumpinfo "if you hit below similiar error when rm ${EXT_DIR}/vscode_space/vscode_server"
    echo "rm: cannot remove 'cli/servers/Stable-fee1edb8d6d72a0ddff41e5f71a671c23ed924b9/server/.nfs00000000cdd80e63000436f5': Device or resource busy"
    dumpinfo "run below commnad to find out who/which process has locked this file and kill it"
    dumpinfo "fuser <file_path>"
    echo "example : "
    echo " fuser vscode_server/bin/863d2581ecda6849923a2118d93a088b0745d9d6/.nfs00000000cdd8262c000436b8"
    echo "${EXT_DIR}/vscode_space/vscode_server/bin/863d2581ecda6849923a2118d93a088b0745d9d6/.nfs00000000cdd8262c000436b8: 2958847"
    dumpinfo "kill -9 2958847"
    dummy "delete the foler ${EXT_DIR}/vscode_space/vscode_server again"
    dumpinfo "confirm folder '${EXT_DIR}/vscode_space/vscode_server' not exist and press any key to continue."
    echo
    pause
fi
echo "remove '  ${HOME}/.vscode-server '"
rm ~/.vscode-server
echo


dumpinfox "re-create related folder and symbol link"
# mkdir -p "${EXT_DIR}/vscode_space/vscode_server_XXXX"               // this way is not recommended because the alive vscode server might is using some ports. 
# it cause the new vscode server can't work well.
echo "create foler : ${EXT_DIR}/vscode_space/vscode_server"
mkdir -p "${EXT_DIR}/vscode_space/vscode_server"
echo "create symbol link : ${EXT_DIR}/vscode_space/vscode_server  =>  ${HOME}/.vscode-server"
ln -s ${EXT_DIR}/vscode_space/vscode_server  ~/.vscode-server
ll ~/.vscode-server
if [[ ! -d ~/.vscode-server ]] ; then
    dumperr "ll ~/.vscode-server  not exist , check it manual"
    dumpinfo "after fix all and press any key to continue."
    echo
    pause
fi

dumpinfox "re-install vscode on windows platform"
echo "${brown}C:\\work\\OneDrive\\work_skills\\svnRepo\\shenxiaolong\\setupEnvironment\\setup_vscode\\reinstall\\_vscode_install.bat ${end}"
dumpinfo "WARNING:"
dumpinfo "use the : ${brown}G:\\My Drive\\work_software\\VSCodeUserSetup-x64-1.73.1.exe"
dumpinfo "instead of the newest vscode from MS web, becuase the newest vscode has below bugs."
echo "1. can't open big log file"
echo "2. open or run task in terminal , terminal hit error : fork: retry: Resource temporarily unavailable"
dumpinfo "after install complete and press any key to continue."
echo
pause

dumpinfox "re-connect linux sever"
dumpinfo "open a remote workspace in vscode. or run be cmd:"
dumpinfo "localloader://openFile:C:/work/nvidia/note/vscode_workspace/empty.code-workspace"
echo "wait for the vscode to install vscode server complete."
dumpinfo "after vscode server install complete and press any key to continue."
echo
pause

dumpinfox "install basic vscode plugin"
dumpinfo "below plugins is MUST"
dumpinfo "gitLens , Notepad++ key"
dumpinfo "in vscode terminal, run below command to install basic plugin -- below command MUST be run in vscode terminal"
dumpinfo "source ${BASH_DIR}/app/vscode/bin/vscode_install_extenstion_basic.sh"

dumpinfox "Done to uninstall & re-install vscode"
echo

