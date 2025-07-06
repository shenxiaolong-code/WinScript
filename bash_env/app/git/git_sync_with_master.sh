
bash_script_i
# https://www.cnblogs.com/xinmengwuheng/p/7115549.html
# git rebase origin/dev              // it might be OK ?
# local_master_branch_name=dev

#  git fetch <remote_repo_name> + git rebase <remote_br_name>       <==>  git pull --rebase <remote_repo_name> <remote_br_name>         # option --rebase cause : pull + merge => pull + rebase
#  git fetch origin + git rebase $(get_branch_name_remote_full)     <==>  git pull --rebase origin <remote_br_name>
#  git fetch origin + git rebase origin/main                        <==>  git pull --rebase origin main
#  git fetch origin + git rebase origin/fix/6.x/test_br_name        <==>  git pull --rebase origin <remote_br_name>

#  two steps control  or one simply step
#  suggest : use two steps control in script , and use one simply step in command line

repo_dir=
[[ -d ./cmds ]] && repo_dir=$(get_worktree_path_current);
[[ -d $repo_dir ]] && pushd $repo_dir
is_inside_git_svn_repo
if [[ $? -ne 0 ]] ; then
    echo "${brown}$(pwd -L) ${red}is not a git repository.${end}"
    bash_script_o
    return 1
fi

local_master_branch_name=$(get_master_name_local)
local_cur_branch_name=$(get_branch_name_local)
# dumpkey local_cur_branch_name

# revert change from :   ${HOME}/bash_env/nvidia/bin/reduce_device_debug_symbol.csh
repo_type=$(get_current_repo_type)
if [[ "${repo_type}" == "cask5" ]] ; then
    git checkout  cask_core/CMakeLists.txt
    git checkout  cask_core/cask-tester/CMakeLists.txt
    git checkout  cask_core/cask_plugin/CMakeLists.txt
fi

function update_local_main_branch() {
    # git fetch --all --prune
    # git pull origin main --rebase
    # merge with remote master branch using 'theirs' strategy without committing
    dumpcmd "git reset --hard HEAD    # discard all local changes"
    git reset --hard HEAD           # discard all local changes
    dumpcmd "git fetch --all --prune    # fetch all remote change"
    git fetch --all --prune
    # dumpcmd "git reset --hard $(get_branch_name_remote_full)    # discard all local changes and reset to remote master branch"
    # git reset --hard $(get_branch_name_remote_full)
    dumpcmd "git pull --rebase -X theirs    # rebase with remote master branch"    
    git pull --rebase -X theirs

    # git rebase --skip    
    echo
}

function is_rebase_work_fine() {
    local git_dir=$(git rev-parse --git-dir)
    if [[ "$(git rev-parse --abbrev-ref HEAD)" == "HEAD" ]] || \
       [[ -f "${git_dir}/rebase-merge/head-name" ]]         || \
       [[ -f "${git_dir}/rebase-apply/head-name" ]]         ; then
        # dumpinfo "${red}Currently in 'no branch' or rebase state${end}"
        # dumpinfo "Please run one of these commands to recover:"
        # dumpinfo "1. ${brown}git rebase --abort${end}"
        # dumpinfo "2. ${brown}git checkout <your-branch-name>${end}"
        # dumpinfo "3. ${brown}git reset --hard $(get_branch_name_remote_full)${end}"
        return 1
    fi
    return 0
}

alias grebase='export GIT_EDITOR=true git rebase --continue'
function update_local_branch_with_remote_main_branch() {
    # git fetch --all --prune
    # git pull origin main --rebase
    # merge with remote master branch using 'theirs' strategy without committing
    
    # rebase with remote master branch
    git_stash_current_change "temp : backup before sync with remote master branch"
    dumpcmd "git fetch --all --prune    # fetch all remote change"
    git fetch --all --prune
    local master_name_remote=$(get_master_name_remote)
    is_has_merge_request && { 
        master_name_remote=$(get_merge_target_branch) ;
        [[ "${master_name_remote}" == "" ]] && master_name_remote=$(get_branch_name_remote_full)   # perhaps the upstream is a release tag branch , instead of MR
        dumpinfo "this is a release tag branch, use merge target branch ${master_name_remote} to rebase" ; 
    }
    dumpcmd "git rebase ${master_name_remote}    # rebase with remote master branch"
    # git pull origin main --rebase     # option --rebase cause : pull + merge => pull + rebase
    # git pull --rebase origin/master -X theirs         # auto resolve conflict by remote change
    git rebase ${master_name_remote}
    # if [[  -n "$(git diff --name-only --diff-filter=U)"  ]]; then
    if ! is_rebase_work_fine ; then
        dumpinfo "${red}conflict found, try to resolve conflict manually${end}"
        dumpinfo "need to resolve below conflict files manually :"
        dumpcmd "git diff --name-only --diff-filter=U"
        git diff --name-only --diff-filter=U

        
        echo
        dumpinfo "${purple}possible used cmds :${end}"
        dumpinfo "git diff --name-only --diff-filter=U | xargs cursor       # auto open && edit conflict files with cursor"
        dumpinfo "git checkout --ours [file|.]                              # accept remote branch change"
        dumpinfo "git checkout --theirs [file|.]                            # accept local branch change"
        dumpinfo "git rebase -X theirs ${master_name_remote}                # accept remote branch change"
        dumpinfo "git rebase -X ours ${master_name_remote}                  # accept local branch change"
        dumpinfo "git add .                                                 # add resolved files after resolve all conflicts"
        dumpinfo "git rebase --abort                                        # abort the rebase process."
        dumpinfo "export GIT_EDITOR=true git rebase --continue              # continue the rebase process without edit message file."
        dumpinfo "git rebase --skip                                         # skip current commit confict and apply next commit, not suggested."
        dumpinfo "git reset --hard $(get_branch_name_remote_full)           # discard all local changes to avoid resolve conflict."
    else
        dumpinfo "no conflict, cmd '${brown} git rebase ${master_name_remote} ${green}' works well."
    fi
    echo
}

function fetch_remote_branch_change(){
    # merge with remote master branch using 'theirs' strategy without committing
    dumpinfox "${brown}try conflict sync with remote master branch${end}"
    dumpcmd "git fetch --all --prune      # featch all remote change${end}"
    git fetch --all --prune  
}

# check local modification
dumpinfo "updating branch ${red} ${local_cur_branch_name} ${green} , path :${purple} $(pwd -L) ${end} ..."
# ${BASH_DIR}/app/git/git_sync_with_master_impl.sh
if [[ "${local_cur_branch_name}" == "${local_master_branch_name}" ]] ; then
    update_local_main_branch
elif [[ "$1" == "" ]] ; then
    update_local_branch_with_remote_main_branch
    # see ${BASH_DIR}/app/git/git_common_features.sh
    # update_local_branch_with_remote_upstream_branch_without_conflict
else
    fetch_remote_branch_change     
fi

# \echo -e "\n${cyan}optimize your local repository:  ${brown} git gc ${end}"
# \echo -e "\n${cyan}resolve the possible sync conflicts by editing files. ${green}steps:${end}"
# # \echo -e "[optional] ${red}git merge --m \"Merge branch main into ${local_cur_branch_name}\" -X theirs --no-commit origin main ${end}"
# # echo git merge --m "Merge branch main into ${local_cur_branch_name}" -X theirs --no-commit origin main
# echo "${red}1.${green} resolve conflicted files in vscode source control panel.${end}"
# echo "${green}   if accept the remote change, run command '${brown} git rebase --skip ${green}' to skip the conflict."
# echo "${green}   or select the right version (current) in vscode source control panel, then run command '${brown} git rebase --continue ${green}' to continue the rebase process."
# echo "${green}   left windows is local change, right window is remote change in conflict merge editer"
# # echo "git add <resolved_files>"
# echo "${red}2.${green} git rebase --continue  ${end}"
# echo

# echo
# echo ${cyan}resolve the possible sync conflicts by editing files. ${green}steps:${end}
# echo "git add <resolved_files>"
# echo 'git commit -m "message"'
# echo

# [[ ${bModified} == 1 ]] && restore_git_modification
[[ ${bModified} == 1 ]] && dumpinfo "the local modification is restored. you need to '${brown}git stash pop it${green}' manual because the rebase process might hit confilct."

if [[ "${repo_type}" == "cask5" ]] ; then
    echo
    echo "${red}for nvidia cask_sdk local debug, run command '${brown} reduce ${red}' to remove the device code debug symbol...${end}"
    echo source ${BASH_DIR}/bin/reduce_device_debug_symbol.sh
fi

dumpinfo "for master/release tag branch, use reset --hard to discard all local changes"
dumpinfo 'git reset --hard $(get_branch_name_remote_full)'
dumpinfo "for other branch , use rebase to sync with remote master/releae tag branch"
dumpinfo 'git rebase $(get_master_name_remote)'

show_all_branches

[[ "$(git rev-parse --abbrev-ref HEAD)" =~ "no branch, rebasing"  ]]  && echo "${green}if hit '${brown} (no branch, rebasing main) ${green}' issue, run command '${brown} git rebase --abort ${green}' or '${brown} git rebase --skip ${green}' to abort the rebase process.${end}"
# git branch --contains f053976b2528e61e34e5f35423b162d204a89cb7
dumpinfox  "run cmd '${red} hgit ${blue}' to show git commit id related cmd"
# show_git_commit_id_related_cmd

[[ -d $repo_dir ]] && popd

echo
bash_script_o
