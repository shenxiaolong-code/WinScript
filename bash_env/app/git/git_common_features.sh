bash_script_i

function optimize_git_repo() {
    is_now_time_after "11:01:01" # && echo "now time is after China time 19:01:01" || echo "now time is before China time 19:01:01"
    if [[ $? == 0 || $# != 0 ]] ; then
        dumpinfox "it is nightly time to run long time git optimization"
        dumpcmd "git worktree prune                             # clean unavailable worktree reference, avoid verbose objects"
        git worktree prune
        # don't use --expire=now, it will cause git stash lost
        dumpcmd "git reflog expire --all                        # mark out-of-date reference without remove"
        git reflog expire --all
        dumpcmd "git prune --expire=now --progress              # clean invalid objects, release storage space immediately"
        git prune --expire=now --progress
        dumpcmd "git fsck --full --unreachable --verbose        # check git repo integrity"
        git fsck --full --unreachable --verbose
        dumpcmd "git repack -a -d -f --depth=250 --window=250   # repack local loose files , optimize git performance"
        git repack -a -d -f --depth=250 --window=250
    else
        dumpinfox "it is work time to run short time git optimization"
        dumpcmd "git worktree prune   # clean unavailable worktree"
        time git worktree prune
        dumpcmd "git gc --auto        # auto optimize git performance"
        time git gc --auto
        # dumpcmd "git prune --expire=now --progress  # clean invalid objects"
        # time git prune --expire=now --progress
    fi
}

function adjust_multiple_git_commit_sequence() {
    local commit_numbers=${1:-"3"}
    dumpcmd "git rebase -i HEAD~${commit_numbers}"
    git rebase -i HEAD~${commit_numbers}
    # same with
    # pick <commit_id_2>
    # pick <commit_id_1>
    # pick <commit_id_3>
    # git rebase --continue
}

function merge_continus_multiple_git_commit() {
    local commit_numbers=${1:-"3"}
    dumpcmd "git rebase -i HEAD~${commit_numbers}"
    git rebase -i HEAD~${commit_numbers}

    # same with
    # pick    <commit_id_2>    # HEAD~2         # pick the keep commit
    # squash  <commit_id_1>    # HEAD~1
    # squash  <commit_id_3>    # HEAD  
    # git rebase --continue
}

function show_git_commit_id_related_cmd() {
    dumpinfox  "run cmd '${red} hgit ${blue}' to show git commit id related cmd"
    dumpinfo  "${brown}up       ${green}or${brown} git_sync_with_master                 # sync with master branch"
    dumpinfo  "${brown}upr      ${green}or${brown} update_local_branch_with_upstream    # sync with remote upstream branch"
    dumpinfo  "${brown}upidx    ${green}or${brown} goback_to_commit_by_index            # rollback to a commit by index"
    dumpinfo  "${brown}upid     ${green}or${brown} goback_to_commit_by_id               # rollback to a commit by id"
    dumpinfo  "${brown}upi      ${green}or${brown} investigate_commit_id                # investigate a commit file changes info"
    dumpinfo  "${brown}mergeid  ${green}                                        # merge a commit id"
    dumpinfo  "${brown}mergebr  ${green}                                        # merge a branch (or remote branch) "
    dumpinfo  "${brown}git checkout -- <file>                           # revert single file local change"
}

function query_premerge_request_of_current_branch() {
    dumpinfo "https://$(get_git_repo_remote_link_prefix)/-/merge_requests?source_branch=$(get_branch_name_remote)"
}

function git_clone_dkg_migrate_MR_example(){
    BRANCH_NAME=fix/3.x/kfactor8 # Change to your existing branch under kernel_store
    TARGET_BRANCH=mono # Should be `master` post-migration
    git clone ssh://git@gitlab-master.nvidia.com:12051/dlarch-fastkernels/dynamic-kernel-generator.git && cd ./dynamic-kernel-generator
    git checkout $TARGET_BRANCH
    git checkout -b $EXISTING_BRANCH
    git remote add -f ks ssh://git@gitlab-master.nvidia.com:12051/dlarch-fastkernels/kernel_store.git
    git merge --no-edit ks/$EXISTING_BRANCH
    git push --set-upstream origin $EXISTING_BRANCH
}

function check_git_change_line_tab_tail_blank() {
    local tmp_pwd=$(pwd -L)
    local auto_fix=$(( $# > 0 ))
    local add_auto_after_fix=$(( $# > 1 ))
    
    # 1. 保存检查结果到临时文件
    dumpinfox "check unstaged changes..."
    local unstaged_file=${TEMP_DIR}/to_del/unstaged.txt
    git diff --check > ${unstaged_file}
    dumpinfo "${unstaged_file}"
    dumpinfox "check staged changes..."
    local staged_file=${TEMP_DIR}/to_del/staged.txt
    git diff --cached --check > ${staged_file}
    dumpinfo "${staged_file}"

    [[ ! -s ${unstaged_file} && ! -s ${staged_file} ]] && {
      dumpinfo "${green}no issues found.${end}"
      return 0
    }
    
    # 2. 显示检查结果
    echo
    if [[ -s ${unstaged_file} ]]; then
        dumpinfo "${red}unstaged changes found the following issues:${end}"
        cat ${unstaged_file}
    fi
    if [[ -s ${staged_file} ]]; then
        dumpinfo "${red}staged changes found the following issues:${end}"
        cat ${staged_file}
    fi

    # 3. 如果需要修复
    echo
    if [[ "$auto_fix" == "1" ]]; then      # 3.1 解析并修复未暂存的问题
      function fix_git_check_file() {
        local git_check_file=$1
        [[ ! -s ${git_check_file} ]] && return 0
        dumpinfo "trailing whitespace"
        cat ${git_check_file} | grep ".*trailing whitespace.*" | sed -E 's/(.*):([0-9]+):.*/\1 \2/' |                         \
        while read file line; do                                                                                              \
          echo -e "$file:$line \t\t${green_256} $(sed -n ${line}p  $file)${end}" ;                                            \
          sed -i "${line}s/[[:space:]]*$//" "$file"                                                                           \
        ; done
        dumpinfo "space before tab in indent"
        cat ${git_check_file} | grep ".*space before tab in indent.*" | sed -E 's/(.*):([0-9]+):.*/\1 \2/' |                  \
        while read file line; do                                                                                              \
          echo -e "$file:$line \t\t${green_256} $(sed -n ${line}p  $file)${end}" ;                                            \
          sed -i "${line}s/\t/  /g" "$file"                                                                                   \
        ; done        

        local git_add_files=$(cat ${git_check_file} | grep -P "trailing whitespace|space before tab in indent" | sed "s#:.*##g" | uniq | xargs echo git add)
        if [[ "$add_auto_after_fix" == "1" ]]; then
          dumpcmd "${add_cmd}"
          eval ${add_cmd}
        else
          dumpinfo "${green}stage change cmd : ${purple_256} ${add_cmd}"
        fi
      }
      
      [[ -s ${unstaged_file} ]] && {  
        dumpinfo "fix unstaged changes..."
        fix_git_check_file ${unstaged_file}
      }
      [[ -s ${staged_file} ]] && {
        dumpinfo "fix staged changes..."
        fix_git_check_file ${staged_file}
      }
  else
    dumpinfo "${green}add any parameter to fix it automatically.${end}"
  fi
  if [[ ! "$add_auto_after_fix" == "1" ]]; then
    dumpinfo "${green}add more then one parameter to git stage the changes automatically.${end}"
  fi
  dumpinfo "${yellow}1. use 'git diff' to check unstaged changes${end} \t\t${unstaged_file}"
  dumpinfo "${yellow}2. use 'git diff --cached' to check staged changes${end} \t${staged_file}"
}

alias chkblank=check_git_change_line_tab_tail_blank

# see ${BASH_DIR}/app/git/git_sync_with_master.sh
function update_local_branch_with_remote_upstream_branch_without_conflict() {
    dumpinfox "try no conflict sync with remote upstream branch"
    dumpcmd "git fetch $(get_remote_repo_name) $(get_branch_name_remote)      # fetch upstream branch change"
    # e.g. git fetch  origin   fix/6.x/optimize_symbol_length
    git fetch $(get_remote_repo_name) $(get_branch_name_remote)
    dumpcmd "git rebase $(get_branch_name_remote_full)      # rebase with remote upstream branch"
    git rebase $(get_branch_name_remote_full)
}

function goto_branch_in_current_worktree() {
    goto_br_name=$(get_branch_name_by_branch_parameter $1)
    dumpinfo "goto branch ${red}${goto_br_name}${end}"
    dumpcmd "git checkout -f  ${goto_br_name}"
    git checkout -f  ${goto_br_name}
}

# git worktree operation by index or name
function goto_worktree_by_branch_or_subfolder() {
    if ! is_inside_git_repo ; then
        goto_sub_folder_by_index_or_name $1
        return
    fi
    local worktree_paramter=${1:-"1"}
    # git branch --color -vv | nl -n ln -w 1 -s " "
    [[ $2 ]] && dumpinfo "$(get_current_function_name) $*"
    # [[ -d ./_bd_template_cask6 ]] && { cdi $1 ; ll ; return 0 ;}
    # is_inside_git_repo || { dumperr "it is not git repo or build root folder , need cmd ${brown}cdi${red} to sub-foler or ${brown}cdc${red} / ${brown}cdt${red} / ${brown}go${red} switch to git repo folder / build root first" ; return 1; }

    curBrName=$(git symbolic-ref --short HEAD)
    # goto_br_name=$(get_branch_name_by_branch_parameter $1)
    # to_worktree_path=$(get_worktree_path_by_branch_parameter "${goto_br_name}")
    to_worktree_path=$(get_worktree_path_by_index_or_br_name ${worktree_paramter})
    if [[ ! -d "${to_worktree_path}" ]] ; then        
        dumpinfo "current worktree is${brown} ${worktree_paramter} ${blue}worktree " 
        return 1
    fi
    cur_worktree_path=$(get_worktree_path_current)
    # dumpkey to_worktree_path
    # dumpkey cur_worktree_path
    worktree_name=${to_worktree_path##*/}
    # dumpkey worktree_name
    if [[ "${cur_worktree_path}" == "${to_worktree_path}" ]] ; then
        dumpkey cur_worktree_path
        dumpkey to_worktree_path        
        dumpinfo "${red}current worktree is already in $(echo ${to_worktree_path} | sed "s#${worktree_name}#${s_brown}${worktree_name}${s_end}#")${end}" 
        return 0
    fi    
    cd ${to_worktree_path}
    dumpinfo "goto worktree ${red}${to_worktree_path}${end}"
    # git worktree list | sed "s#${worktree_name} #${s_brown}${worktree_name}${s_end}#g"
    # git branch --color -vv 
    show_all_branches
    # [[ "$(git symbolic-ref --short HEAD)" != "${curBrName}" ]] && git checkout -f  ${curBrName}
}

function remove_git_worktree_with_worktree_path_and_branch_name() {
    worktree_path=$1

    if [[ ! -d ${worktree_path} ]] ; then
      dumperr "${red}worktree ${brown}${worktree_path} ${red}is not exist.${end}"
      dumpkey worktree_path
      return 1
    fi
    local branch_name=$(get_branch_name_local_by_worktree_path "${worktree_path}")
    prompt_confirm "remove current git branch ${red}${branch_name}${blue} and worktree ${brown}${worktree_path}" || return

    if is_same_path "${worktree_path}"  "$(get_worktree_path_main)" ; then
      dumperr "can't remove main worktree."
      dumpkeyx worktree_path
      dumpinfo "$(get_worktree_path_main)"
      return 2
    fi
    is_same_path "$(get_worktree_path_current)" "${worktree_path}" && cd $(get_worktree_path_main)

    git worktree list | nl -n ln -w 1 -s " " | sed "s#\(.*${worktree_path}.*\)#${s_brown}\1${s_end}#"

    # dumpkeyx branch_name
    # dumpkey  worktree_path

    git_stash_current_change "backup_before_remove_worktree:${branch_name}"
    
    dumpinfo "remove git worktree${brown} ${branch_name}${end}"                      
    dumpcmd "git worktree remove --force ${worktree_path}      # [delete worktree] "
    git worktree remove --force ${worktree_path}
    if [[ -d "${worktree_path}" ]] ; then
        dumperr "worktree ${brown}${worktree_path}${red} is not removed.${end}"
        dumpkey worktree_path
        dumpkey branch_name
        show_all_branches
        return 3
    fi
    # [[ -d "${worktree_path}" ]] && rd ${worktree_path}
    dumpcmd "git branch -D ${branch_name} ${worktree_path}      # [delete branch] "
    git branch -D "${branch_name}"                  # remove worktree wouldn't remove branch
    show_all_branches
    # git worktree remove /path/to/worktree --force       # re-associate a branch with a worktree
    # git worktree add /path/to/worktree branch-name
    readvar   REPO_DIR  tmp_repo_dir  > /dev/null
    is_same_path "${tmp_repo_dir}" "${worktree_path}" && writevar  REPO_DIR $(get_worktree_path_main)
    dumpinfo "Done to delete git branch ${red}${branch_name}${green} and worktree ${brown}${worktree_path}"
}

# remove worktree
function remove_git_worktree_and_branch_by_path()  {
      dumpcmdline2
      # dumpinfo "remove_git_worktree_and_branch_by_path $1"
      branch_name=$(get_branch_name_local_by_worktree_path "$1")
      [[ "$branch_name" == "" ]] && ( dumperr "branch name of worktree path ${worktree_path} is not exist." ; return 1 )
      remove_git_worktree_with_worktree_path_and_branch_name "$1"  $branch_name
}
function remove_git_worktree_and_branch_by_br_name()  {
    dumpinfo "remove_git_worktree_and_branch_by_br_name $1"
    worktree_path=$(get_worktree_path_by_branch_name "${1}")
    [[ ! -d $worktree_path ]] && ( dumperr "worktree of branch name ${1} is not exist." ; return 1 )
    remove_git_worktree_with_worktree_path_and_branch_name  $worktree_path  $1
}

function remove_git_current_worktree_and_branch() {
    worktree_path=$(get_worktree_path_current)
    remove_git_worktree_and_branch_by_path  ${worktree_path}
}

function delete_git_local_branch_by_br_name() {
    # delete git local branch
    local tmp_br_name=${1}
    if [[ "${tmp_br_name}" == "$(get_master_name_local)" || "${tmp_br_name}" == ""  ]] ; then
        dumperr "branch name is empty or local master branch.${end}"
        return
    fi
    git_stash_current_change "backup_before_delete_branch:$1" ;
    # source ${BASH_DIR}/app/git/git_goto_branch.sh  main
    if [[ "$(get_branch_name_local)" == "${tmp_br_name}" ]] ; then
        dumpinfo "current branch is the branch to delete, switch to main branch first."
        if [[ "$(pwd -L)" =~ "$(get_worktree_path_main)" ]] ; then
            # different branch on the main worktree
            git checkout $(get_master_name_local)        
        else
            # go to different worktree to delete the branch on another worktree
            cd $(get_worktree_path_main)
        fi
    fi
    dumpcmd "git branch -D '${tmp_br_name}'      # [delete local branch]"
    git branch -D "${tmp_br_name}" ;
    # git branch --color -vv ;    
    show_all_branches
}

function delete_current_git_local_branch() {
    delete_git_local_branch_by_br_name      $(get_branch_name_local)
}

function delete_git_remote_branch_by_br_name()     { 
    [[ -z $1 ]] && { dumperr "branch name is empty" ; return 1 ; }
    local remote_repo_name=$(get_remote_repo_name)
    local remote_branch_name=$(echo $1 | sed "s#.*$remote_repo_name/##" )
    git push $remote_repo_name --delete "$remote_branch_name" ;        
} 

# the difference :
# delete : just delete the commit , needn't new commit.                                                     [ not change git history ]  cmd example : git rebase -i HEAD~3
# revert : delete the commit , and create a new commit to revert the change.                                [     change git history ]  cmd example : git revert -n c8ed91e
# reset  : move the HEAD pointer to a history commit and discard sequence commit. needn't new commit.       [ not change git history ]  cmd example : git reset --hard HEAD~3
#          git reset --soft <commit>        # all changes after <commit> will be staged    as local modification.
#          git reset --mixed <commit>       # all changes after <commit> will be unstaged  as local modification.
#          git reset --hard <commit>        # all changes after <commit> will be discarded and this modification will be lost.
# rebase : adjust the commit sequence , modify the commit message or content, reuse the same commit by 'git commit --amend'              [     change git history ]  

function blame_git_file_line() {
    curFile=$1
    lineNumber=$2
    [[ ! -f "${curFile}" ]] && { dumperr "${curFile} is not a file" ; dumpkey curFile  ; dumpkey lineNumber  ; return 1; }
    tmp_git_root=$(get_git_file_root "${curFile}")
    [[ ! -d "${tmp_git_root}" ]] && { dumperr "${curFile} is not a git file" ; dumpkey tmp_git_root  ; dumpkey curFile  ; dumpkey lineNumber  ; return ; }
    
    # show git blame detail
    dumpinfox "git blame :  ${curFile}:${lineNumber}"
    dumpcmd "git blame -L ${lineNumber},${lineNumber} ${curFile//${tmp_git_root}\//}"
    # git blame -L 52,52 cask/bloom/testing/helper/coverage_gen/testing_coverage_gen.py
    local tmp_blame_string=$(cd $tmp_git_root && git blame -L ${lineNumber},${lineNumber} ${curFile//${tmp_git_root}\//})
    local tmp_commit_id=$(echo "${tmp_blame_string}" | awk '{print $1}')
    dumpinfo "commit id : gid ${brown}${tmp_commit_id:0:8} ${blue}${tmp_git_root} "    
    # (cd $tmp_git_root && show_git_commit_id_info $tmp_commit_id  "${tmp_git_root}" )
    (cd $tmp_git_root && show_git_commit_id_info_new $tmp_commit_id  "${tmp_git_root}" )

    # dumppos
    dumpinfo "${tmp_blame_string}"
    local tmp_remote_url=$(generate_remote_git_file_line_link "$1" "$2")
    [[ ! -z $tmp_remote_url ]]      && {
        dumpinfo "blame         :${green} ${tmp_remote_url}"
        echo vscode_open_link "${tmp_remote_url}"
    }
    echo
}

function generate_remote_git_file_line_link() {
    curFile=$1
    lineNumber=$2
    [[ ! -f "${curFile}" ]] && { dumpkey curFile  ; dumpkey lineNumber  ;  dumperr "${curFile} is not a file" ; return 1; }
    tmp_git_root=$(get_git_svn_file_root "${curFile}")
    if [[ "${tmp_git_root}" == "" ]] ; then
        dumpkey tmp_git_root
        dumperr "${curFile} is not a git file"
        return 2
    fi    

    # https://<gitlab-domain>/<group>/<project>/-/blob/<commit-or-branch>/<file-path>#L<line-number>
    # https://gitlab-master.nvidia.com/dlarch-fastkernels/kernel_store/-/merge_requests/753/diffs#96b246b20bddddbba460b58c8fdf242c0f7b8558_402_408
    # https://gitlab-master.nvidia.com/dlarch-fastkernels/kernel_store/-/blob/main/cask/frameworks/cutlass3x/gen/shaders/conv/cutlass2x_ffma_nhwc_wgrad_shader.cpp#L211    
    # https://gitlab-master.nvidia.com/dlarch-fastkernels/dynamic-kernel-generator/-/blob/master/cask_api/lib/Provider/OpaqueInterfaces.cpp?ref_type=heads#L10    
    local tmp_worktree_name=${tmp_git_root##*/}
    local tmp_file_tail=${curFile##*${tmp_worktree_name}/}
    local repo_link_prefix=$(get_git_repo_remote_link_prefix ${tmp_git_root} )
    # local remote_master_name=$(cd ${tmp_git_root} && get_master_name_remote)
    local remote_master_name=$(cd ${tmp_git_root} && get_master_name_local)
    [[ -z $repo_link_prefix ]] || [[ -z $remote_master_name ]] && { dumperr "empty tmp_file_tail or remote_master_name"; return 1; }
    # repo_link_prefix="https://gitlab-master.nvidia.com/dlarch-fastkernels/kernel_store/-/blob/main"
    local tmp_url="https://${repo_link_prefix}/-/blob/${remote_master_name}/${tmp_file_tail}#L${lineNumber}"
    echo "${tmp_url}"
    return 0
}

# https://stackoverflow.com/questions/424071/how-do-i-list-all-of-the-files-in-a-commit
# git config --global alias.changed 'show --pretty="format:" --name-only'       =>  git changed b406ee5a2cd06843bb5af0eece17bdfc943f6cdd
# git config --global alias.id 'show --pretty="format:" --name-only'
# git config --global alias.range 'diff --name-only '                           => git range HEAD..HEAD2
# git config --global alias.range 'diff --name-only'
# function gid()      { git -P show --name-only $1 ; echo   ;                     }   # list file change and commit info in one commit id
function show_git_commit_id_info()      {
        # list file change and commit info in one commit id
        # show prvious commit id and file change info of a commit id
        # e.g. git show --summary --pretty=%P 08bbda2a42
        commit_id=$1
        local tmp_repo_dir=${2:-.}
        tmp_file=${TEMP_DIR}/cache/git_detail_info/git_id_$commit_id.log
        if [[ ! -f ${tmp_file} ]] ; then
            is_inside_git_repo ${tmp_repo_dir} || { dumperr "${tmp_repo_dir} is not a git repo and $tmp_file file not exist";  return 2; }
        fi
        
        tmp_repo_dir=$(get_git_svn_dir_root ${tmp_repo_dir})
        dumpcmdx "git -c color.ui=always show --name-only $commit_id"
        [[ ! -f ${tmp_file} ]] && (
            cd ${tmp_repo_dir} && git -c color.ui=always show --name-only $commit_id  >| ${tmp_file}
            # | awk 'BEGIN {p=0; line=0} /^$/ {if (p==0) {p=1} else if (p==1) {p=2} print; next} p==2 && !/^ / {line++; printf "%4d:  %s\n", line, $0; next} {print}' >| ${tmp_file}
            sed -i "s#^\(.*\)/#${tmp_repo_dir}/\1/#;s#/cask/cask/#/cask/#g;s#/cask/cutlass/#/cutlass/#g;" ${tmp_file}            
            # cd ${tmp_repo_dir} && git -c color.ui=always show --name-only $commit_id | sed "s#^\(.*\)/#${tmp_repo_dir}/\1/#" | sed 's#/cask/cask/#/cask/#g' | sed 's#/cask/cutlass/#/cutlass/#g' | awk 'BEGIN {p=0; line=0} /^$/ {if (p==0) {p=1} else if (p==1) {p=2} print; next} p==2 && !/^ / {line++; printf "%4d:  %s\n", line, $0; next} {print}' >| ${tmp_file}
        )
        [[ ! -f ${tmp_file} ]] && { dumpkey commit_id ; dumperr "fails with cmd : git -c color.ui=always show --name-only $commit_id"; return 1; }
        # [[ ! -f ${tmp_file} ]] &&  git -c color.ui=always show --name-only $commit_id | sed "s#^\(.*\)/#${tmp_repo_dir}/\1/#" > ${tmp_file}
        dumpinfo "${tmp_file}"
        cat ${tmp_file}
        remote_br_string=$( egrep "^ *Merge branch" ${tmp_file} )
        # dumpkey remote_br_string
        remote_br=$(echo $remote_br_string | cut -d"'" -f 2 )
        [[ "$remote_br" == "$(cd ${tmp_repo_dir} && get_master_name_local )" ]] && remote_br=$(echo $remote_br_string | cut -d"'" -f 4 )
        # dumpkey remote_br
        mr_string=$( egrep "^ *See merge request" ${tmp_file} )
        # dumpkey mr_string
        mr_num=$(echo $mr_string | cut -d"!" -f 2 )
        # dumpkey mr_num    
        cfk_string=$( grep -i -m 1 "CFK" ${tmp_file} )
        # dumpkey cfk_string
        cfk_num=$(toLower "$cfk_string" | sed -n -e 's/^.*cfk[^0-9]*\([0-9]\+\).*$/\1/p' )
        # dumpkey cfk_num
        echo
        dumpinfo "contain $commit_id branchs cmd: ${brown} git branch --contains $commit_id"
        # dumpcmd  "git branch --contains $commit_id"
        # it branch --contains $commit_id
        dumpinfo "use cmd${red}    git diff $commit_id^    ${blue}to show the file change info of commit id"
        dumpinfo "${cyan}${tmp_file}"        
        
        # https://gitlab-master.nvidia.com/dlarch-fastkernels/dynamic-kernel-generator/-/commit/f68ce4fe00f2bea8996719d9c687cbb4162b4413
        # https://gitlab-master.nvidia.com/dlarch-fastkernels/dynamic-kernel-generator/-/merge_requests/3939/diffs?commit_id=b045d358c154827c08c8e9272a20f95d7ded4459
        # ssh://git@gitlab-master.nvidia.com:12051/dlarch-fastkernels/dynamic-kernel-generator.git
        repo_link_prefix=$(get_git_repo_remote_link_prefix ${tmp_repo_dir} )
        long_commit_id=$( cd ${tmp_repo_dir} &&  git rev-parse "${commit_id}" 2>/dev/null)
        [[ -z $repo_link_prefix ]] || [[ -z $long_commit_id ]] && { dumperr "empty repo_link_prefix or long_commit_id"; return 1; }
        dumpinfo "commit link   :${red} https://${repo_link_prefix}/-/commit/${long_commit_id}"

        [[ ! -z $remote_br ]]  && dumpinfo "remote br     :${brown} $remote_br             # create local branch :${red} mdb $remote_br"
        [[ ! -z $mr_num ]]     && dumpinfo "merge request :${brown} https://${repo_link_prefix}/-/merge_requests/$mr_num"
        [[ ! -z $cfk_num ]]    && dumpinfo "JIRA          :${green} https://jirasw.nvidia.com/browse/CFK-$cfk_num"        
    }

function show_git_commit_id_info_new()      {
        # list file change and commit info in one commit id
        # show prvious commit id and file change info of a commit id
        # e.g. git show --summary --pretty=%P 08bbda2a42
        commit_id=$1
        local tmp_repo_dir=${2:-.}
        tmp_commit_id_file=${git_info_cache_dir}/commit_id_$commit_id.log
        if [[ ! -f ${tmp_commit_id_file} ]] ; then
            is_inside_git_repo ${tmp_repo_dir} || { dumperr "${tmp_repo_dir} is not a git repo and $tmp_commit_id_file file not exist";  return 2; }
        fi
        
        tmp_repo_dir=$(get_git_svn_dir_root ${tmp_repo_dir})
        dumpcmdx "git -c color.ui=always show --name-only $commit_id"
        [[ ! -f ${tmp_commit_id_file} ]] && (
            cd ${tmp_repo_dir} && git -c color.ui=always show --name-only $commit_id | sed "s#^\(.*\)/#${tmp_repo_dir}/\1/#" | sed 's#/cask/cask/#/cask/#g' | sed 's#/cask/cutlass/#/cutlass/#g' | awk 'BEGIN {p=0; line=0} /^$/ {if (p==0) {p=1} else if (p==1) {p=2} print; next} p==2 && !/^ / {line++; printf "%4d:  %s\n", line, $0; next} {print}' >| ${tmp_commit_id_file}
        )
        # [[ ! -f ${tmp_commit_id_file} ]] &&  git -c color.ui=always show --name-only $commit_id | sed "s#^\(.*\)/#${tmp_repo_dir}/\1/#" > ${tmp_commit_id_file}
        dumpinfo "${tmp_commit_id_file}"
        cat ${tmp_commit_id_file}
        
        local commit_link="https://$(get_git_repo_remote_link_prefix)/-/commit/$(git rev-parse $commit_id)"      # get long commit id
        local mr_link=$(get_mr_link_of_commit_id $commit_id)
        local cfk_num=$(get_possible_cfk_num_of_commit_id $commit_id)
        dumpinfo "${git_info_cache_dir}/mr_of_id_${commit_id}.json"        # get_mr_link_of_commit_id will generate this file
        
        # parse the commit info file
        dumpinfo "contain $commit_id branchs cmd: ${brown} git branch --contains $commit_id"
        # dumpcmd  "git branch --contains $commit_id"
        # it branch --contains $commit_id
        dumpinfo "use cmd${red}    git diff $commit_id^    ${blue}to show the file change info of commit id"
        echo
        dumpinfo "${cyan}${tmp_commit_id_file}"
        # dumppos

        [[ ! -z $cfk_num ]]      && dumpinfo "JIRA          :${green} https://jirasw.nvidia.com/browse/CFK-$cfk_num"
        [[ ! -z $mr_link ]]      && dumpinfo "MR            :${brown} ${mr_link}"
        [[ ! -z $commit_link ]]  && dumpinfo "commit link   :${brown} ${commit_link}"
    }

function show_git_svn_repo_url() {
    tmp_test_repo=${1:-$(pwd -L)}
    is_inside_git_svn_repo || { dumperr "Not in git repo :${brown} ${tmp_test_repo}";  return 2; }
    tmp_repo_root=$(get_git_svn_dir_root)
    if [[ -d ${tmp_repo_root}/.git || -f ${tmp_repo_root}/.git ]] ; then
        dumpinfox "url of git repo root : ${tmp_repo_root}"
        git remote -v ; 
        echo ; 
        echo use "git config --get  branch.dev.remote" to get single config value ; 
        git -P config --list
    else
        dumpinfox "url of svn repo root : ${tmp_repo_root}"
        svn info
    fi    
}

function show_related_commits_by_commit_id() {
    # e.g. git log --oneline -n 3 08bbda2a42
    git log --oneline -n 3 $1
}

# git merge --no-edit feature-branch
# need parameter cmd:
function mergeid()     { 
                            dumpcmd "git cherry-pick -n -m 1 $1 --strategy-option=resolve --no-commit"
                            git cherry-pick -n -m 1 $1 --strategy-option=resolve --no-commit  ;
                        } 
                        # merge commit id <commitID> without auto-commit. e.g. git git cherry-pick -n c8ed91e --strategy-option ours
                        # git checkout -b release/5.4 origin/release/5.4

function merge_single_local_branch_without_commit()     { 
    # https://www.atlassian.com/zh/git/tutorials/using-branches/merge-strategy
    # --squash without commit record on other branch
    local repo_name=$(get_remote_repo_name)
    local tmp_br_name=$(echo $1 | sed "s#${repo_name}/##g")
    if [[ "$1" == "${tmp_br_name}" ]] ; then
        # it is local branch
        local test_branch_exist=$(get_worktree_path_by_branch_name "${tmp_br_name}")
        [[ -z $test_branch_exist ]] && { dumperr "branch name is not exist : $1" ; return 1; }
    fi
    
    prompt_confirm "keep the commit history of branch $1 " && keep_commit_history="" || keep_commit_history="--squash"
    echo "merge branch name : ${tmp_br_name}"
    if [[ ${tmp_br_name} == */* ]] ; then
        dumpinfox "merge ${red}remote${green} branch :${brown} $1 ${end}"
        dumpcmd "git fetch ${repo_name} ${tmp_br_name}           # fetch remote branch"
        git fetch ${repo_name} ${tmp_br_name}
        dumpcmd "git merge ${repo_name}/${tmp_br_name} --no-commit -s resolve        # merge remote branch"
        git merge ${keep_commit_history} ${repo_name}/${tmp_br_name} --no-commit -s resolve
    else
        dumpinfox "merge ${red}local${green} branch :${brown} $1  ${end}"
        dumpcmd "git merge ${tmp_br_name} --no-commit -s resolve"
        git merge ${keep_commit_history} ${tmp_br_name} --no-commit -s resolve
    fi
}  # -s ours   | -s theirs
function merge_single_remote_branch_without_commit() {
    local repo_name=$(get_remote_repo_name)
    local tmp_remote_br_name=$(echo $1 | sed "s#${repo_name}/##g")
    dumpcmd "git fetch ${repo_name} ${tmp_remote_br_name}"
    git fetch ${repo_name} ${tmp_remote_br_name}
    prompt_confirm "keep the commit history of branch $1 " && keep_commit_history="" || keep_commit_history="--squash"
    dumpcmd "git merge ${repo_name}/${tmp_remote_br_name} --no-commit -s resolve        # merge remote branch"
    git merge ${keep_commit_history} ${repo_name}/${tmp_remote_br_name} --no-commit -s resolve
}

alias mergebr=merge_single_local_branch_without_commit
alias mergebrr=merge_single_remote_branch_without_commit
# append  current modification to specified commit id ( not the lastest commit id )
# e.g.  gappend bbc643cd
# e.g.  gappend HEAD~8
function append_current_modification_to_id()  {
    # https://stackoverflow.com/questions/1186535/how-do-i-modify-a-specific-commit
    # git rebase -i HEAD~3
    git rebase --interactive $1~
    git commit --all --amend --no-edit
    git rebase --continue
}                  

# usage : git_diff_a_file_local_modification_in_vscode <file_name>
function git_diff_a_file_local_modification_in_vscode() {
    local git_file=$1
    [[ ! -f $git_file ]] && { git status --porcelain ; dump_information "usage ${brown} : gdiff <file_path> " ; return 1 ;}
    
    # 获取git仓库根目录
    local git_root_dir=$(git rev-parse --show-toplevel)
    [[ ! -d $git_root_dir/.git && ! -f $git_root_dir/.git ]] && { dumperr "git_root_dir not exist: $git_root_dir" ; return 1 ;}

    git_root_dir=$(echo $git_root_dir | update_symbol_path )
    git_file=$(echo $git_file | update_symbol_path | sed "s#^${git_root_dir}/##")
    # dumpinfo "diff with TOT :${red} git diff master $git_file"
    
    # 获取文件的git对象ID
    # local blob_id=$(git ls-files -s "$git_file" | cut -d' ' -f2)
    # dumpkey blob_id
    # [[ -z "$blob_id" ]] && { dumperr "file not tracked by git: $git_file" ; return 1 ;}
    
    # 创建临时文件来存储git中的版本
    # local temp_file=${TEMP_DIR}/to_del/${git_file##*/}_${blob_id}.txt
    # dumpcmd git cat-file blob $blob_id 
    # git cat-file blob $blob_id >| "$temp_file"

    local temp_file=${TEMP_DIR}/to_del/${git_file##*/}_$(date "+%Y%m%d_%H%M%S").txt
    git show HEAD:"$git_file" > "$temp_file"
    
    # 构建完整的文件路径
    full_file_path=${git_root_dir}/${git_file}
    
    if [ -f "$temp_file" ]; then
        # e.g ide --diff '${EXT_DIR}/tmp/to_del/Download.cmake_20250227_094627.txt' '/home/scratch.xiaolongs_gpu_1/repo/dkg_root/dkg_integrate_mono_kernel_store/cmake/Download.cmake
        dumpcmd "ide --diff '$temp_file' '${full_file_path}'"
        eval "ide --diff '$temp_file' '${full_file_path}'"
        #cursor --diff "$temp_file" "$full_file_path"
        return 0
    else
        echo "# Base git file extraction failed"
        return 1
    fi
}

# usage : gdiff_1_file_in_commit <commit_id> <file_name>
function gdiff_1_file_in_commit()    {   # if empty parameter, diff all changed files.
        # git -P show --name-only $1
        git -c color.ui=always show --name-only $1 | awk 'BEGIN {p=0; line=0} /^$/ {if (p==0) {p=1} else if (p==1) {p=2} print; next} p==2 && !/^ / {line++; printf "%4d: %s\n", line, $0; next} {print}'
        gdiff_param=${2:-1}
        if [[ ${gdiff_param} =~ ^[0-9]+$ ]]; then
            diff_file=$(git diff-tree --no-commit-id --name-only -r $1 | sed -n "${gdiff_param} p")
        else
            diff_file=$(git diff-tree --no-commit-id --name-only -r $1 | grep "${gdiff_param}")
        fi                        
        if [[ "${diff_file}" != "" ]] ; then
            cd $(get_worktree_path_current)
            [[ "$2" == "" ]] && echo "\\r${blue_L}default diff the first file :${brown} ${diff_file} ${end}"
            echo "${green}git difftool -y -t vscode $1 -- ${diff_file} ${end}"
            git difftool -y -t vscode $1 -- ${diff_file} &
            cd -
        else
           dumperr "worng parameter : ${gdiff_param}, please check the parameter." ;
           echo "${green}direct cmd format example:${brown} git difftool -y -t vscode 78df488eef -- cask/tools/releases/cudnn/kernel_groups.json  ${end}"
        fi
        echo "'${brown} git blame -L 1,1 -- ${diff_file} ${green}' to check file change history.${end}"
        # git difftool -y -t vscode $1  ;                        
}  

# git branch operation
function show_all_branches() 
{   
    # --sort=- ： 降序, 最新的在最前面
    # --sort=  ： 升序, 最老的在最前面
    dumpinfo "${brown}lb2${blue} ： show the lastest sync time of each branch； ${brown}lmr${blue} ： query_premerge_request_of_current_branch"
    dumpinfo "${brown}git branch -a${blue} ： show all branch； ${brown}git branch -r${blue} ： show remote branch"
    dumpinfo "${brown}remote master newest id${blue} ： $(git ls-remote origin refs/heads/master | awk '{print substr($1,1,10)}')"
    repo_dir=
    [[ -d ./cmds ]] && repo_dir=$(get_repo_dir_from_build_dir)
    [[ -d $repo_dir ]] && pushd $repo_dir
    dumpcmd git branch --color -vv --sort=-creatordate
    git branch --color -vv --sort=-creatordate  | nl -n ln -w 1 -s " " | update_symbol_path | awk -v term_width="$(tput cols)" '{
    if (length($0) > term_width)
        print substr($0, 1, term_width-3) "...";
    else
        print;
    }'
    [[ -d $repo_dir ]] && popd    
}

function open_current_repo_link_in_browser() {
    # https://gitlab-master.nvidia.com/dlarch-fastkernels/dynamic-kernel-generator/-/tree/master
    # https://<gitlab_host>/<project_id>.git
    local repo_name=$(get_master_name_remote | sed -E "s#^.*/##g")
    local repo_link_prefix=$(get_git_repo_remote_link_prefix)
    local repo_link="https://${repo_link_prefix}/-/tree/${repo_name}"
    dumpinfo "https://${repo_link_prefix}"
    vscode_open_link ${repo_link}
}

function show_all_branches_with_sync_time() 
{   
    repo_dir=
    [[ -d ./cmds ]] && repo_dir=$(get_repo_dir_from_build_dir)
    [[ -d $repo_dir ]] && pushd $repo_dir
    git for-each-ref --sort=-creatordate --format='%(creatordate:iso8601) %(refname:short)' refs/heads/ | nl -n ln -w 1 -s " " update_symbol_path | awk -v term_width="$(tput cols)" '{
    if (length($0) > term_width)
        print substr($0, 1, term_width-3) "...";
    else
        print;
    }'
    [[ -d $repo_dir ]] && popd
}

bash_script_o
