#!/bin/bash

bash_script_i
echo
dumpinfox "${BASH_DIR}/app/vscode/bin/vscode_troubleshoot.txt"
dumpinfo  "resolve issue : ${red}-bash: fork: retry: Resource temporarily unavailable${end}"

[[ -z $1 ]] && do_kill=1 || do_kill=0
# do_kill=1

function kill_vscode_subprocess() {
    # local process_string="$(echo $2 ${@:11} | grep '/home/')"
    local process_string="$(echo $2 ${@:11} | grep '/home/' | grep -v 'shellIntegration-bash.sh')"
    [[ -z "${process_string}" ]] && return
    echo "process : ${process_string}"
    if [[ $do_kill -eq 1 ]]; then
        local process_id=$(echo $process_string | awk '{print $1}')
        echo "kill  -9  ${red}${process_id}${end}"
        kill -9 ${process_id}        
    fi
}

temp_process_file=${TEMP_DIR}/to_del/vscode_process_list.txt
# ps  | grep -v "shellIntegration-bash.sh" 
ps -f > ${temp_process_file}
cat ${temp_process_file} | sed '1d' | pipe_callback kill_vscode_subprocess

echo
dumpinfo "raw process file : ${temp_process_file}"
bash_script_o
