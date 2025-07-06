echo
# ? code 
# ${EXT_DIR}/vscode_space/vscode_server/cli/servers/Stable-fee1edb8d6d72a0ddff41e5f71a671c23ed924b9/server/bin/remote-cli/code
function clean_vscode_cache_on_linux() {
    dumpinfox "clean cache on linux"
    code_cache_folder=${EXT_DIR}/vscode_space/vscode_server/data/User/workspaceStorage
    dumpinfo "clean folder : ${code_cache_folder}"
    rd  ${code_cache_folder}
    mkdir ${code_cache_folder}   
}

function clean_vscode_cache_on_window(){
    echo
    dumpinfox "clean cache on windows"
    dumpinfo "'Reopen closed repository' path :"
    # echo 'C:\Users\xiaolongs\AppData\Roaming\Code\User\workspaceStorage'
    echo '%USERPROFILE%\AppData\Roaming\Code\User\workspaceStorage'         # vscode reopen closed repo records
    # echo '%USERPROFILE%\AppData\Roaming\Code\User\History'                # vscode search and edit history.  better to keep it
}

function remove_vscode_server_folder() {
    dumpcmd "rm -rf ~/.vscode-server"
    rm -rf ~/.local/share/code-server
    dumpcmd "rm -rf ~/.config/code-server"
    rm -rf ~/.config/code-server
}

clean_vscode_cache_on_linux
clean_vscode_cache_on_window


echo Done