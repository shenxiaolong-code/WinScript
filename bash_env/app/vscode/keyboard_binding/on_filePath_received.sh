
# source ${BASH_DIR}/init/alias_color.sh
# clear
# https://code.visualstudio.com/docs/terminal/shell-integration
# terminal.integrated.shellIntegration.enabled

# https://github.com/microsoft/vscode/issues/177722
# code runCommands [...]

reload_env=0
declare -f "debug_bash_script_i" &>/dev/null || reload_env=1
# reload_env=1

[[ ${reload_env} -eq 1 ]] && {
    # echo "function_name is not defined"
    disable_bash_script_io=1
    shopt -s expand_aliases
    source ${BASH_DIR}/init/alias_dump_debug.sh
    source ${BASH_DIR}/init/alias_color.sh
    source ${BASH_DIR}/init/init_color_variables.sh        "reload"
    source ${BASH_DIR}/init/init_color_variables_sed.sh    "reload"
    source ${BASH_DIR}/init/alias_and_function.sh
    source ${BASH_DIR}/init/is_test_function.sh
    source ${BASH_DIR}/app/vscode/vscode_shell_integration.sh
    source ${BASH_DIR}/init/alias_find_file_or_text.sh
    source ${BASH_DIR}/app/git/git_get_info.sh
    source ${BASH_DIR}/app/git/git_alias.sh
}

disable_bash_script_io=0
dumpkeyx disable_bash_script_io

bash_script_i

# open this vscode setting file : ctrl+shift+p : shortcuts : open keyboard shortcuts(JSON) 
dumpinfo ctrl+O :  'C:\Users\xiaolongs\AppData\Roaming\Cursor\User\keybindings.json'
dumpinfo ctrl+O :  'C:\Users\xiaolongs\AppData\Roaming\Cursor\User\settings.json'
dumpinfo ctrl+O :  'C:\work\OneDrive\work_skills\svnRepo\shenxiaolong\setupEnvironment\setup_vscode\config\settings_mini.json'

if [[ ! -d $PWD ]] ; then
    dumpinfo "not existed folder : $PWD"
    cd -   >/dev/null 2>&1  # fix : sh: 0: getcwd() failed: No such file or directory
fi
echo
dumpinfo "******************************** new command implement separate line  ********************************"
source ${BASH_DIR}/app/vscode/keyboard_binding/process_activeFile.sh  "$1" "$(echo $2 | update_symbol_path)" "${@:3}"

# echo -e --------------  byebye, ${red}leaving${end} ${BASH_SOURCE[0]}:$LINENO
# echo -e --------------  byebye, ${red}leaving${end} "C:/Users/xlshen/AppData/Roaming/Code/User/keybindings.json"
