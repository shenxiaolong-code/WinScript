

bash_script_i
# https://code.visualstudio.com/docs/terminal/shell-integration
# it's recommended to set terminal.integrated.shellIntegration.enabled to false

# debuginfo   "`code --locate-shell-integration-path bash`"
# debugkey    VSCODE_SHELL_INTEGRATION

which code    > /dev/null  2>&1 && alias ide=code
which cursor  > /dev/null  2>&1 && alias ide=cursor
# type ide  > /dev/null   2>&1 && echo "ide is defined" || echo "ide is not defined"
type ide  > /dev/null   2>&1 && export ide_defined=true

# specify the vscode terminal to use bash shell
# [[ "$TERM_PROGRAM" == "vscode" ]] && . "$(code --locate-shell-integration-path bash)"
# [[ "$TERM_PROGRAM" == "vscode" ]] is only available for vscode, not useful for cursor

if [[ -n $ide_defined ]] ; then
    # alias diff='ide --diff '    
    function diff_in_vscode() {
      local tmp_repo_root=$(get_git_svn_file_root $1)
      [[ -z tmp_repo_root ]] && tmp_repo_root=$(pwd -L)

      if [[ $# -eq 2 ]]; then
        dumpcmd "ide --diff $1 $2"
        ide --diff "$1" "$2"
      elif [[ -d ${tmp_repo_root}/.svn ]]; then
        dumpcmd "svndiff $1"
        svn_diff_a_file_local_modification_in_vscode "$1"
      elif [[ -d ${tmp_repo_root}/.git || -f ${tmp_repo_root}/.git ]]; then
        dumpcmd "gdiff $1"
        git_diff_a_file_local_modification_in_vscode "$1"
      else
        dumpcmdline
        dumperr "wrong usage: diff <file1> <file2> [file3]"
      fi
    }
    alias diff='diff_in_vscode'

    # diffSVNFile svn://svn_repository_url/path_to_abc.txt path_to_local_copy/abc.txt
    alias note='ide ${TEMP_DIR}/note.txt'
    # alias cleancode=
    
    alias codetask='ide ${EXT_DIR}/tmp/empty  ${job_path}/task.code-workspace'
    alias codesh='ide ${BASH_DIR} ${EXT_DIR}/tmp/test/_test_bash.sh'
    alias codenew='ide ${EXT_DIR}/vscode_space/code_workspace/empty.code-workspace '
fi

function icode() {
    # list all vscode plugin in current platform
    echo "${red}${HOME}/.cursor-server/extensions/extensions.json  ${end}"
    [[ -n $ide_defined ]] && ide --list-extensions ;
    echo "${green}${BASH_DIR}/app/vscode/vscode_shell_integration.sh${end}"
    echo "${green}ref :${brown} ${BASH_DIR}/app/vscode/setup/vscode_install_extenstion_basic.sh ${end}"  ;                      
    echo "${purple}C:\\Users\\xiaolongs\\AppData\\Roaming\\Code\\User\\keybindings.json ${end}"
    echo "${purple}C:\\Users\\xiaolongs\\AppData\\Roaming\\Code\\User\\settings.json ${end}"
    echo
    echo "${green}backup path${end}"
    echo "${purple}C:/work/OneDrive/work_skills/svnRepo/shenxiaolong/setupEnvironment/VSCode_setting/config/settings_mini.json ${end}"
}

function cleanup_vscode_unnecessary_process() {
    dumpinfo "cleanup all vscode-server related process : gitlab|spell-checker|python"
    
    # 查找所有与 .vscode-server 相关的可杀掉的进程    
    local processes=$(ps | grep '.vscode-server' | grep -E 'gitlab|spell-checker|python' | grep -v grep | awk '{print $2}')    
    if [ -z "$processes" ]; then
        echo "没有找到可清理的 VS Code 不必要进程。"
        return
    fi
    
    echo "找到以下可清理的 VS Code 不必要进程："
    echo "$processes"
    
    # 杀掉找到的所有进程
    echo "$processes" | xargs -I {} kill -9 {}
    
    echo "已清理不必要的 VS Code 进程。"
}

function vscode_open_link() {
  [[ $1 =~ ^https?:// ]] || { dumpinfo "link '$1' is not valid" ; return ; }
  # python -m webbrowser https://gitlab-master.nvidia.com/dlarch-fastkernels/dynamic-kernel-generator/-/merge_requests/8035
  dumpcmd "python -m webbrowser $1"
  python -m webbrowser $1
}

function async_open_file_on_303(){
    local file_path=$1
    source ${BASH_DIR}/app/vscode/async_open_file/receive_remote_cmd/farm_client_send_cmd_to_303.sh  "$file_path"
    # ssh xiaolongs@computelab-303 "curl -s 'http://computelab-303.nvidia.com:8000/openfile?path=${file_path}'"
}

# cmd both supported with difference behavior
function vscode_open_file() {
  if [[ -n $ide_defined ]] ; then
    dumpinfo "# ${green}vscode open file ${brown}$1  ${green} on `hostname` ${end}."
    ide --goto "$1"
  else
    # echo -e "# ${brown}`hostname`${green} has not installed the vscode,below file can't be opened directly by ${red}ctrl+j${end} ."
    # echo -e "# ${green}need to switch to ${brown}303${green} and open the file under the cursor directly by ${red}ctrl+j${end} ."
    # echo -e "# ${brown}$1 ${end}"
    dumpinfox "# ${green}vscode open file ${brown}$1  ${green} by `hostname` transfer to computelab-303.nvidia.com ${end}."
    async_open_file_on_303 $1
  fi                
}

function vscode_add_folder() {
  # [[ "$TERM_PROGRAM" == "vscode" ]] && ide -add   ${1:-$(pwd -L)}  ; 
  if [[ -n $ide_defined ]] ; then
    ide -add   ${1:-$(pwd -L)}
  else
    dumpinfo "no vscode to open folder ${1:-$(pwd -L)}"
  fi
}

alias codeopen=vscode_open_file
alias ox=vscode_add_folder
alias killide='source /home/scratch.xiaolongs_gpu_1/bash_env/app/vscode/bin/vscode_kill_process_new.sh'

bash_script_o