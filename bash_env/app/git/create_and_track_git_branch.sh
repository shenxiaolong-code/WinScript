bash_script_i

# feature/6.x/cfk_12748_port_ffma_nhwc_fprop_update_design_metadata
repo_name=$(get_remote_repo_name)
# remote_br_name=${1#origin/}
remote_br_name=$(echo $1 | sed "s#${repo_name}/##")
# dumpkey remote_br_name
new_br_name=$(echo ${remote_br_name} | sed 's#.*/##g' | sed 's# #_#' )
if [[ "${new_br_name}" == "" ]] ; then
    dumpinfo "empty new branch name, exit script"
    return
fi

curBrName=`git symbolic-ref --short HEAD`
if [[ "${curBrName}" == "${new_br_name}" ]] ; then
    dumperr "current git branch is has the same name, reuse it or delete me first by cmd ${brown}rdbc${end}."
    return 1
fi

existed_in_local=$(git branch --list ${new_br_name})
debugkey existed_in_local

printf "${green}[current br]${brown} %s  ${end}=>${green} [new br]${brown} %s ${end}\n" ${curBrName}  ${new_br_name}
if [[ "${existed_in_local}" != "" ]] ; then
    git_stash_current_change "before_create_new_br_save:${remote_br_name}"
    if is_local_branch_exist ${new_br_name}; then
        # the branch name exists, add date time flag to the branch name.
        dumpinfo "the branch name exists, add date time flag to the branch name."
        new_br_name=${new_br_name}_$(date "+%Y%m%d_%H%M")
    fi
fi

dumpcmdx "git checkout -b ${new_br_name}"
git checkout -b ${new_br_name}

# set remote tracking
if [[ "$1" != "${remote_br_name}" ]] ; then
    dumpinfo "set remote tracking ${brown}${remote_br_name}${end}."
    dumpcmd "git branch --set-upstream-to=${repo_name}/${remote_br_name}"
    git branch --set-upstream-to=${repo_name}/${remote_br_name}
fi

bash_script_o
