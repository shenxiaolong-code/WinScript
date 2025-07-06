
# install git client on linux
# sudo apt update && sudo apt install git -y

bash_script_i
# if the command name is general and might conflicted with other commnad, add prefix g to resolve it.  e.g. gmerge
# else use the command directly , e.g. to , up
source ${BASH_DIR}/app/git/git_get_info.sh
source ${BASH_DIR}/app/git/git_get_info_by_gitAPI.sh
source ${BASH_DIR}/app/git/git_common_features.sh
source ${BASH_DIR}/app/git/git_update_or_revert_rollback_reset.sh
source ${BASH_DIR}/app/git/git_backup_and_restore.sh
source ${BASH_DIR}/app/git/find_git_log_history_blame.sh

# should NOT set below env variable globally, use it only when local , e.g. export GIT_EDITOR=true git rebase --continue
# reject all editor scenario ,include :  git rebase --continue without edit message file
# export GIT_EDITOR=true
# reject edit message file only when git merge ...
# export GIT_MERGE_AUTOEDIT=no

# detect docker environment
if [[ "$(hostname)" == "computelab-303.nvidia.com" ]] ; then
    GIT_PATH=/home/utils/git-2.33.0-2
elif is_in_docker ; then
    GIT_PATH=/tmp/git
else
    # GIT_PATH=/home/utils/git-2.42.0
    GIT_PATH=/usr/bin
fi
if [[ -d ${GIT_PATH} ]] ; then
    # take effect in current shell
    [[ "$(which git 2> /dev/null )" != "${GIT_PATH}/bin/git" ]] && export PATH=${GIT_PATH}/bin:$PATH
else
    if ! is_in_docker ; then
        dumpkey GIT_PATH
        dumpkey envMode
        dumperr "git path not found: ${GIT_PATH}"
    fi
fi


function show_git_help_function() {    
    list_function_in_script_file  ${BASH_DIR}/app/git/git_alias.sh
    list_function_in_script_file  ${BASH_DIR}/app/git/git_common_features.sh
    list_function_in_script_file  ${BASH_DIR}/app/git/git_get_info.sh

    dumpinfo "git --git-dir '${cur_repo_dir}/.git' "
    show_git_commit_id_related_cmd
    dumpinfox "show git info cache : lp ${TEMP_DIR}/cache/git_detail_info"
}
alias hgit=show_git_help_function
alias mygit='list_function_in_script_file ${BASH_DIR}/app/git/git_alias.sh ; echo ${BASH_DIR}/app/git/git_common_features.sh ; echo ${BASH_DIR}/app/git/git_get_info.sh'
alias igit="source ${BASH_DIR}/app/git/show_git_info.sh"               # information for git 
export GIT_PAGER=

# 使用 --no-pager 选项
# 1. 设置环境变量全局禁止 git 命令分页显示：  export GIT_PAGER=
# 2. 对特定的 Git 命令禁用分页 4。例如:
#    git --no-pager stash show -p stash@{1}             // 单次对 stash 命令禁用分页。
#    git config --global pager.stash false              // 只对 stash 命令禁用分页。

# git symbolic-ref --short HEAD                         # current branch name , e.g. fix/CFK-6137

alias isGitRepo='git rev-parse --is-inside-work-tree > /dev/null 2>&1 '
# git -C "${EXT_DIR}/repo/cask6_2/frameworks/cutlass3x/gen"  rev-parse --show-toplevel 2>&1 | egrep -v "fatal:|GIT_DISCOVERY_ACROSS_FILESYSTEM"

# git log --graph --pretty=format:"%C(red)%h%C(reset) %C(bold blue)%<(8)%an%C(reset) %C(yellow)%<(60,trunc)%s%C(reset)  %C(green)(%cr)%C(reset) %d %C(reset) " -5
#'git log --graph --pretty="%C(yellow) Hash: %h %C(blue)Date: %ad %C(red) Message: %s "'

alias url=show_git_svn_repo_url
alias nvgit='cat ${HOME}/bash_env/nvidia/nvGitGuide.txt'
alias nvpush='source ${BASH_DIR}/nvidia/bin/nvGitPush.sh'

function check_tail_blank_char_in_file(){
    local file_path=$(realpathx $1)
    grep -Pq "^\t|[ \t]+$" $file_path || return

    dumpcmd grep -nHP '"^\\t|[ \\t]+$"' $file_path
    grep  --color=always -nHP "^ *\t|[ \t]+$" $file_path | sed -e 's#:#   #2' | sed -e 's#^#  #'
    if [[ $# -gt 1 ]]; then
        command echo -e "${green}  auto fix :${red} $file_path${end}"
        # sed -i -e 's#^\t#  #' -e 's#[ \t]\+$##' $file_path          # FIXME : can't fix the  \0\t\0 mixed case in line head
        # sed -i -e 's#[ \t]\+$##' $file_path                         # FIXME : can't fix the  \0\t\0 mixed case in line head
        sed -i -e 's/^\([ \t]*\)\t/\1  /g' -e 's/^\([ \t]*\)\t\+/\1  /g' -e 's/[ \t]*$//' $file_path
        grep  -Pq "^ *\t|[ \t]+$" $file_path && {
            check_file_ok=1
            command echo -e  "  ${brown}please remove the line head tab char manual${end}"
            grep  --color=always -nHP "^ *\t|[ \t]+$" $file_path | sed -e 's#:#   #2' | sed -e 's#^#  #'
        } || command echo -e  "  ${green}auto fix success${end}"
    fi

}
# check git change file : head tab char or tail blank char
function check_blank_char_in_git_change(){
    check_file_ok=0
    dumpinfo "check tab char in git file head or blank char in tail. ${red}add any paramter to auto fix"
    git  diff --name-only --diff-filter=ACMRTXUB | pipe_callback check_file "${@}"
    return $check_file_ok
}

function nv_git_commit_with_clang_format() {
        check_git_change auto_fix || return 1
        [[ -z $1 ]] && { dumperr "commit message is empty" ; return 1 ; }
        dumpcmd FORMAT_HOOK_VERBOSE=1 git commit -m "$1"
        FORMAT_HOOK_VERBOSE=1 git commit -m "$1" ;
        show_git_repo_status ; 
    }
alias nvchk=check_git_change
alias nvcommit=nv_git_commit_with_clang_format
# dkg clang_format check & reformat the C++ source code : https://clang.llvm.org/docs/ClangFormat.html
# python3 scripts/code-format-helper.py
# FORMAT_HOOK_VERBOSE=1  python3 ./scripts/code-format-helper.py
# FORMAT_HOOK_AUTO_REFORMAT=1 python3 ./scripts/code-format-helper.py
# append current change to the last commit
alias nvcommita='git commit --amend --no-edit --allow-empty-message '

function glist()    {   
                        dumpcmd "git branch --color -vv" 
                        show_all_branches | grep "*"
                        dumpcmd "git stash list"  
                        git stash list | sed "s#$(get_branch_name_local)#${s_red}&${s_end}#g"
                        echo
                        dumpinfo "use cmd${red} lbak ${blue}to show more git backup " 
                        dumpinfo "use cmd${brown} glistx ${blue}or${brown} glistxx ${blue}to show stash record detail \n" 
                    }
function glistx()   {
                        dumpcmd "git stash show -p stash@{$1} --name-only -u"
                        git stash show -p stash@{$1} --name-only -u
                        dumpinfo "show detail diff change : glistxx 0  or  git stash show -p stash@{$1} "
                        dumpinfo "${brown}use ${red} vscode Source Control panel ${brown}to show stash record detail "
                    }
function glistxx()  {
                        dumpcmd "git stash show -p stash@{$1}"
                        git stash show -p stash@{$1}
                    }
function show_git_repo_status() {
    echo -e "${green}use cmd${red} st ${green}to show branch and stash record.\nFor plain ourput , use ${red}git  diff --cached --name-only ${green}or ${red}git status --porcelain ${green}, more option :  --diff-filter=ACMRTXUB ${end}"
    # git status -uno -u --porcelain -s | grep -oP '(?<=  ).*'
    dumpinfo "${brown}git status -uno -u "
    is_inside_git_svn_repo && git status -uno -u | sed  -E "s#: +(.*)#: ${s_red}   $(pwd -L)/\1${s_end}#g" 
    [[ -d ./cmds ]] && ( cd $(get_repo_dir_from_build_dir) && git status -uno -u | sed  -E "s#: +(.*)#: ${s_red}   $(pwd -L)/\1${s_end}#g" )
}
alias gitst=show_git_repo_status
function st(){
    local tmp_repo_root=$(get_git_svn_dir_root)
    [[ -z ${tmp_repo_root} ]] && tmp_repo_root=$($(pwd -L))
    if [[ -d "${tmp_repo_root}/.svn" || -f "${tmp_repo_root}/.svn" ]] ; then
        show_svn_repo_status ${tmp_repo_root}
    elif [[ -d "${tmp_repo_root}/.git" || -f "${tmp_repo_root}/.git" ]] ; then
        show_git_repo_status ${tmp_repo_root}
    else
        dumpinfo "not a git or svn repo"
    fi
}

# branch cmds:
alias tob=goto_branch_in_current_worktree

alias tow=goto_worktree_by_branch_or_subfolder
# alias cdw=goto_worktree_by_branch_or_subfolder

alias cdg=goto_worktree_by_branch_or_subfolder

alias lb=show_all_branches
alias lbr='git branch --color -vv -r'
alias lb2=show_all_branches_with_sync_time
alias lbc=' git branch --color -vv --show-current    '

alias lmr=query_premerge_request_of_current_branch

function create_worktree_and_branch_and_track() { 
    source ${BASH_DIR}/app/git/create_branch_and_worktree_and_track.sh "$@"
    show_all_branches
}
function create_branch_and_track() { 
    source ${BASH_DIR}/app/git/create_and_track_git_branch.sh  "$@"
    show_all_branches
}

# function mdb54()    { git checkout -b $1  origin/release/5.4  ;       }   # check out cask_sdk release 5.4 branch.
alias    mdwt=create_worktree_and_branch_and_track
alias    mdb=create_branch_and_track                                            # feature/6.x/cfk_12748_port_ffma_nhwc_fprop_update_design_metadata      

alias    rdb=delete_git_local_branch_by_br_name                                                                 # delete git local branch
alias    rdbc=delete_current_git_local_branch                                                                   # delete current git local branch
alias    rdbr=delete_git_remote_branch_by_br_name                                                              # delete git remote branch , e.g. origin/feature/6.x/cfk_12966_port_ffma_nhwc_relu_bias
function rename_local_branch_name() { 
    if [[ "$1" == "$(get_master_name_local)" ]] ; then 
        dumperr "main branch can't be rename" ; 
        return 1 ; 
    fi
    dumpinfo "rename git branch name${brown} $1 ${green}==>${red} $2"
    git branch -m "$1" "$2" ; 
    show_all_branches
}
alias    mvb=rename_local_branch_name
alias    mvbc='rename_local_branch_name "$(get_branch_name_local)"'                                                      # rename current git branch
function rename_remote_branch_name() {
    local new_remote_branch_name=$1
    [[ -z $new_remote_branch_name ]] && { dumperr "remote branch name is empty" ; return 1 ; }
    old_remote_branch_name=$(get_branch_name_remote)
    dumpinfo "rename git remote branch name${brown} $1 ${green}==>${red} $2"
    dumpcmd "git push --set-upstream $(get_remote_repo_name) HEAD:${new_remote_branch_name}"
    git push --set-upstream $(get_remote_repo_name) HEAD:${new_remote_branch_name}
    dumpinfo "run cmd '${brown} bt ${new_remote_branch_name} ${blue}' to track new branch"
}
alias   mvbr=rename_remote_branch_name

function set_fetch_remote_url() { 
    # set remote url will resolve below warning when using git worktree
    # warning: redirecting to https://gitlab-master.nvidia.com/dlarch-fastkernels/kernel_store.git/
    # git remote set-url origin https://gitlab-master.nvidia.com/dlarch-fastkernels/kernel_store.git
    is_inside_git_repo || return 1
    # dumpinfo "before update remote url : "
    # git remote -v | grep "(fetch)"
    local remote_url=$(git remote -v 2>/dev/null  | grep "(fetch)" | awk '{print $2}')    
    echo git remote set-url origin $_repo
    # dumpinfo "after update remote url : "
    # git remote -v | grep "(fetch)"
    }
function set_branch_tracked_upstream()       { 
    [[ -z $1 ]] && { dumperr "branch name is empty" ; return 1 ; }
    local remote_repo_name=$(get_remote_repo_name)
    [[ -z $remote_repo_name ]] && { dumperr "remote repo name is empty" ; return 1 ; }
    dumpcmd "git branch --set-upstream-to=$remote_repo_name/${1##$remote_repo_name/}"
    git branch --set-upstream-to=$remote_repo_name/${1##$remote_repo_name/} ; 
    show_all_branches ;     
    }        # track branch, git branch --unset-upstream
alias    bt=set_branch_tracked_upstream
alias    btu='git branch --unset-upstream  ; show_all_branches ;'                                               # remove track info
alias    ubt=btu
# git branch -d b1                                                                                              # Deleted local branch b1.
# git push origin --delete b1                                                                                   # Deleted remote branch b1.
# git branch -m <new_name>                                                                                      # rename current branch
# git branch --contaiains f053976b252                                                                           # query which branchs include this commit

# alias rdwt=remove_git_worktree_and_branch_by_path
alias    rdwt=remove_git_worktree_and_branch_by_br_name
alias    rdwt2=remove_git_worktree_and_branch_by_path
alias    rdwtc=remove_git_current_worktree_and_branch
function show_all_worktrees()  { git worktree list | nl -n ln -w 1 -s " " | update_symbol_path ; }   # list   worktree           // git worktree list --porcelain
alias    lwt=show_all_worktrees
alias    clean_worktree='git worktree prune ;'
alias    wtc=clean_worktree

alias iid=show_git_commit_id_related_cmd
alias gid=show_git_commit_id_info
function gid2()     { git diff-tree --no-commit-id --name-only -r $1 ; echo   ; }   # list only file change in one commit id
# git diff --name-status <sha>^ <sha>
function gidx()     { git diff --name-only  HEAD..HEAD~$1 ; echo   ;            }   # list file change in HEAD index range
# try below every to check what is best for your scenario.
# git show --pretty="" --name-only b406ee5a2cd06843bb5af0eece17bdfc943f6cdd
# git diff-tree --no-commit-id --name-only -r b406ee5a2cd06843bb5af0eece17bdfc943f6cdd
alias 1has2=is_1st_commit_id_include_2nd_commit_id
                  
function gdiff_all()    { git difftool -y -t vscode $1 ;  }
alias gdiff=git_diff_a_file_local_modification_in_vscode
alias gdiff2=gdiff_1_file_in_commit
alias gdiff3=gdiff_all
# function gdiff()    { git -P diff $1  ;  }
# git diff --name-only  HEAD..HEAD~1
# git diff --name-only  HEAD..HEAD~2
# git diff --name-status HEAD..HEAD~2
# git show --stat b406ee5a2cd06843bb5af0eece17bdfc943f6cdd
# git show --stat --name-only b406ee5a2cd06843bb5af0eece17bdfc943f6cdd

function show_newest_commit_id_on_remote_master() {
    # local remote_repo_name=$(get_remote_repo_name)
    git fetch --all --prune
    local remote_master_name=$(get_master_name_remote)
    dumpinfo "remote master newest id:"
    # dumpcmd "git ls-remote origin refs/heads/master :"
    # git ls-remote origin refs/heads/master | awk '{print substr($1,1,10)}'
    dumpinfo "git ls-remote origin refs/heads/master : $(git ls-remote origin refs/heads/master | awk '{print substr($1,1,10)}') , ahead $(git rev-list --count master..origin/master)"
    
    # dumpinfo "local master newest id: behind $(git rev-list --count master..origin/master)"
    # dumpcmd "git rev-parse --short refs/heads/master"
    # git rev-parse --short refs/heads/master
    # dumpinfo "current branch newest id:"
    # dumpcmd "git rev-parse --short HEAD"
    # git rev-parse --short HEAD
    git branch --color -vv --sort=-creatordate | nl -n ln -w 1 -s " "
}
alias tot=show_newest_commit_id_on_remote_master
alias repo='open_current_repo_link_in_browser'

alias gclean='git clean -ffdx'                                  # [local] Remove all untracked files and directories (clean) , include worktree.
alias gfix=optimize_git_repo                                    # [local] optimize git repo, clean unavailable or verbose files, repack local loose files, clean invalid objects, clean out-of-date reference, check git repo integrity.
# alias gcleanr='git fetch --prune'                             # [local] get rid of local branches that no longer exist on the remote.
# alias gresize='git gc '                                       # compress local loose files and get rid of local branches that no longer exist on the remote.  it includes cmd ' git prune '

# run ' git reflog ' to view git command history and ' git reset --hard 9f506ec243 '  to restore to one git command history.

bash_script_o


# HEAD 和 ID 在使用 ^ 和 ~ 时的语法规则是完全一样的
#  ~ 和 ^ 都可以用来表示相对引用，但它们有细微的区别：
#  ^ 表示父提交：
#  01385148^1 表示第一个父提交
#  01385148^2 表示第二个父提交（如果是合并提交）
#  01385148^ 等同于 01385148^1
#  ~ 表示向上追溯：
#  01385148~1 表示第一个父提交（等同于 01385148^1）
#  01385148~2 表示第一个父提交的第一个父提交
#  01385148~3 表示第一个父提交的第一个父提交的第一个父提交
#  主要区别：
#  ^ 主要用于选择父提交（在合并提交时特别有用）
#  ~ 主要用于向上追溯多个提交
#  例如：
#  01385148~1 等同于 01385148^1
#  01385148~2 等同于 01385148^1^1
#  01385148~3 等同于 01385148^1^1^1
#  在线性提交中(直接在master上的提交, e.g. hotfix)，01385148~1 和 01385148^1 是等价的，都可以用来表示合并提交的第一个父提交。