bash_script_i
master_br_name=$(git symbolic-ref refs/remotes/origin/HEAD | sed 's#.*/##')
# default goto main
br_paramter=${1:-"${master_br_name}"}
# default goto reverse index 1
# br_paramter=${1:-1}
if [[ $br_paramter =~ ^[0-9]+$ ]]; then
    [[ $br_paramter -lt 1 ]] && br_paramter=1
    goto_br_name=$( git branch | tac | sed -n "$1 p" | cut -d' ' -f 2- ) 
else
    goto_br_name=${br_paramter}
fi

if [[ "${goto_br_name}" == "" ]] ; then
    dumperr "new branch name is empty. exit script"
    return
fi

dumpinfo "${green}goto branch ${brown}${goto_br_name}${end}"
curBrName=`git symbolic-ref --short HEAD`
# dumpkey curBrName
# dumpkey goto_br_name

if [[ "${curBrName}" != "${goto_br_name}" ]]  ; then
    goto_br_worktree=$(git worktree list | grep "${goto_br_name}" | awk '{print $1}')
    # dumpkey goto_br_worktree
    # dumpinfo "$(pwd -L)"
    [[ "${goto_br_worktree}" != "$(pwd -L)" ]] && cd ${goto_br_worktree}
    existed_in_local=$(git branch --list ${goto_br_name})
    if [[ "${existed_in_local}" != "" ]] ; then
        # check whether modified
        git_stash_current_change "backup_before_switch_br:${curBrName}"
        # switch to master branch
        [[ "${curBrName}" != "${goto_br_name}" ]] && git checkout -f  ${goto_br_name}
    else
        dumperr "new branch ${brown}${goto_br_name}${purple} doesn't exit. cmd fails"
    fi
else
    restore_git_modification
fi


bash_script_o
