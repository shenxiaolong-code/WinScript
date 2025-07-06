#!/bin/bash

bash_script_i

function show_different_revert_ways_and_purpose(){
    dumpinfo "<> means required parameter , [] means optional parameter"
    dumpcmd "git reset --hard HEAD  [templates/kernel.h.j2]                 # discard local uncommitted modification , staged or unstaged. cmd${red} greset ${green}to do"
    dumpcmd "git restore [templates/kernel.h.j2]                            # discard unstaged modification , but keep staged modification"
    dumpcmd "git restore --staged --worktree [templates/kernel.h.j2]        # discard staged modification ,   but keep unstaged modification"
    echo
    dumpcmd "git checkout [templates/kernel.h.j2]                           # discard unstaged file modification "
    dumpcmd "git checkout origin/master -- <templates/kernel.h.j2>          # restore single file from remote master branch. cmd${red} gres ${green}to do"
    dumpcmd "git checkout 2819bfe7e8  [templates/kernel.h.j2]               # restore single to specified version "    
    dumpcmd "git reset --hard HEAD~3  |  git reset --hard 78df488eef        # Roll back to the specified version, idx begin from 1 , later commits will be deleted all. delete last commit :${red} git reset --hard HEAD~ "
    echo
    dumpcmd "git restore --source origin/master -- [templates/kernel.h.j2]  # restore single file from remote or local by branch name "
    dumpcmd "git revert    -n HEAD~3  |  git revert -n 78df488eef           # use a new commit to replace specified commits. idx begin from 1 , need to push a new commit. -n not auto commit "
    # MR merge id MUST be a merge commit id, it have 2 parents : 1 comes from master newest update, 2 comes from my MR change.  only commit_on_master directly is a commit ID (it has only one parent), instead of merge commit id(it has 2 parents).
    dumpcmd "git revert -n 01385148 -m 1                                    # [needed] keep tot-sync , revert my code change.  -m : mainline (keep) .  1: tot change. 2: my change"
    dumpcmd "git revert -n 01385148 -m 2                                    # [never use] keep my code change, revert tot-sync"
    dumpcmd "git rebase    -i HEAD~3  |  git rebase -i 78df488eef^          # update a commit and adjust it and later commits order, cmd${red} git rebase --continue ${green}to confirm.  cmd${red} show_update_commit_sequence_steps ${green}to show steps "    
}

function show_update_commit_sequence_steps() {
    echo "Here are the steps to follow after modifying a commit:"
    echo "1. Modify your files."
    echo "2. Stage your changes with 'git add <file>'."
    echo "3. Amend the commit with 'git commit --amend'. This command will open an editor for you to modify the commit message. If you don't want to change the commit message, you can just save and close the editor."
    echo "3.1 you can change the commit order also by editing the commit sequence in the interactive rebase file."
    echo "4. Continue the rebase with 'git rebase --continue'."
    echo "${green}input ${red}yes${green} to confirm the yellow push command(${brown}git rebase -i <commit_id>${green}) immediately, else cancel.${end}"
}

function reorder_rebase_commit_sequence() {
    local commit_num=${1:-3}
    dumpinfo "cmd${red} git rebase --continue ${green}to confirm.  cmd${red} show_update_commit_sequence_steps ${green}to show steps"
    dumpcmd "git rebase -i HEAD~${commit_num}"
    git rebase -i HEAD~${commit_num}
    
}

function discard_all_local_not_committed_modification() {
    dumpinfo "reset all local modification to HEAD, including unstaged and staged modification"
    dumpcmd "git reset --hard HEAD"
    git reset --hard HEAD
    dumpcmd "git worktree prune"
    git worktree prune
    # same with ' git checkout . '
}
function discard_all_local_unstaged_modification() {
    dumpinfo "revert all unstaged local modification.(only versioned-controlled)"
    local restore_path=${1:-.}
    dumpcmd "git restore $restore_path"
    git restore $restore_path
    dumpcmd "git worktree prune"
    git worktree prune
    # same with ' git checkout . '
    dumpinfo "reset all cmd :${red} git reset --hard HEAD ${blue}or ${brown}greset2"
    dumpinfo "cleanup all cmd :${red} git reset --hard && git clean -fdx --force ${blue}or ${brown}gcleanup"
    dumpinfo "reset single cmd :${red} git checkout origin/master -- <file_path> ${blue}or ${red}gres"
}
function discard_all_modification() {
    dumpinfo "revert all local modification and not versioned-controlled modification"
    dumpcmd "git reset --hard && git clean -fdx --force"
    git reset --hard && git clean -fdx --force
}

function restore_single_file_from_remote_master_branch() {
    [[ ! -f $1 ]] && { dumperr "file $1 not found" ; return 1; }
    dumpcmd "git checkout origin/master -- $1"
    git checkout origin/master -- $1
}

alias greset=discard_all_local_unstaged_modification         # [local] revert all unstaged local modification.(only versioned-controlled)
alias greset2=discard_all_local_not_committed_modification   # [local] revert all unstaged/staged local modification.(only versioned-controlled)
alias gcleanup=discard_all_modification
alias gres=restore_single_file_from_remote_master_branch     # [local] restore single file from remote master branch
alias irevert=show_different_revert_ways_and_purpose
alias grevert=show_different_revert_ways_and_purpose

function show_different_update_ways_and_purpose(){
    dumpcmd "up     | git_sync_with_master.sh                                           # sync with remote master branch without conflict"
    dumpcmd "upr    | update_local_branch_with_remote_upstream_branch_without_conflict  # sync with remote upstream branch without conflict"
    dumpcmd "upid   | goback_to_commit_by_id                                            # go back to the specified commit id"
    dumpcmd "upi    | investigate_commit_id                                             # investigate the specified commit id"
}

function goback_to_commit_by_id() {
    dumpcmd "git reset --hard $1"
    git reset --hard $1
}

function investigate_commit_id() {
    # go back to the previous commit and merge the current commit
    [[ -z $1 ]] && { dumperr "please input the commit id to investigate" ; return 1; }
    local previous_commit_id=$(get_previous_id_by_commit_id $1)
    [[ -z $previous_commit_id ]] && { dumperr "can't find previous commit id $previous_commit_id by $1" ; show_related_commits_by_commit_id $1 ; return 1; }
    show_related_commits_by_commit_id   $1
    dumpinfo "${brown}git_stash_current_change        # backup possible local modification"
    git_stash_current_change "investigate_commit_id : backup local modification before investigate commit id $1"
    dumpinfo "${brown}goback_to_commit_by_id    $previous_commit_id  # go back to the previous commit"
    goback_to_commit_by_id  $previous_commit_id
    dumpinfo "${brown}mergeid $1                # merge the commit id $1"
    mergeid    $1
    dumpinfox  "run cmd '${red} hgit ${blue}' to show git commit id related cmd"
}

function update_repo() {
    if [[ -d "./.git" || -f "./.git" ]]; then
        source ${BASH_DIR}/app/git/git_sync_with_master.sh
    else
        if [[ -d "./.svn" || -f "./.svn" ]]; then
            svnup
        else
            dump_information "not a git or svn repo";
        fi
    fi
}

alias iup=show_different_update_ways_and_purpose
alias up=update_repo
alias upr=update_local_branch_with_remote_upstream_branch_without_conflict
alias upid=goback_to_commit_by_id
alias upi=investigate_commit_id


bash_script_o
