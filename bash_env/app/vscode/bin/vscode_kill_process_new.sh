#!/bin/bash

bash_script_i
echo
[[ $1 == "do" ]] && DRY_RUN=0 || DRY_RUN=1
dumpkey DRY_RUN
dumpkey ide_defined

dumpinfox "${BASH_DIR}/app/vscode/bin/vscode_troubleshoot.txt"
dumpinfo  "resolve issue : ${red}-bash: fork: retry: Resource temporarily unavailable${end}"

if [[ "${DRY_RUN}" == "0" && -n $ide_defined ]]; then
    dumpinfo "you are running in real mode."
    dumpinfo "suggest : "
    dumpinfo "1. exit current ide (cursor, vscode, etc)"
    dumpinfo "2. run the cmd :${red} killide do"
    return 1
fi

echo
dumpinfo "do dry run"
DRY_RUN=${DRY_RUN} source ${BASH_DIR}/bin/kill_process_group.sh "/.cursor-server/"

echo
dumpinfo "do real kill"
dumpinfo 'DRY_RUN=0 source ${BASH_DIR}/bin/kill_process_group.sh "/.cursor-server/"'
dumpinfo "${brown}killide do"

echo
dumpinfo "raw process file : ${temp_process_file}"
bash_script_o
