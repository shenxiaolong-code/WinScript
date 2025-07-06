bash_script_i
################################################ get info ############################################################################################

function is_release_tag_branch() {
    local tmp_remote_branch=$(get_branch_name_remote)
    dumpkey tmp_remote_branch
    [[ "${tmp_remote_branch}" == "release/"* ]] && echo "${tmp_remote_branch} is release tag branch"
    [[ "${tmp_remote_branch}" == "release/"* ]] && return 0
    if [[ "${tmp_remote_branch}" != "" ]]; then
        local merge_target_branch=$(get_merge_target_branch)
        local master_name_remote=$(get_master_name_remote)
        dumpkey merge_target_branch
        dumpkey master_name_remote
        [[ "${merge_target_branch}" != "${master_name_remote}" ]] && echo "${tmp_remote_branch} is release tag branch" || echo "${tmp_remote_branch} is not release tag branch"
        [[ "${merge_target_branch}" != "${master_name_remote}" ]] && return 0 || return 1
    else
        echo "get branch name remote failed"
        return 1
    fi
}

# some build is based on the repo sub-directory, instead of the repo root directory
function get_repo_dir_from_build_dir() {
    local tmp_build_dir=${1:-"$(pwd -L)"}
    is_inside_build_dir ${tmp_build_dir} || return 1

    local tmp_build_root=$(get_build_root_from_subfolder ${tmp_build_dir})
    local tmp_cmake_file=${tmp_build_root}/cmds/_1_cmake.sh
    if [[ -f $tmp_cmake_file ]] ; then
        local tmp_parse_string=$(cat $tmp_cmake_file | egrep -v "^ *#" | grep "/home/" | grep -v "source " | xargs | sed 's#.*/home/#/home/#' | awk '{print $1}' )
        [[ -z $tmp_parse_string ]] && return 1
        echo ${tmp_parse_string} | update_symbol_path
        return 0
    else
        return 1
    fi
}

# ' git config --list ' is fastest to fetch git info
function get_branch_name_local() {
    # git symbolic-ref --short HEAD
    local current_branch=$(git rev-parse --abbrev-ref HEAD 2>/dev/null)
    if [[ $? -eq 0 ]]; then
        echo $current_branch
        return 0
    else
        echo ""
        return 1
    fi
}

function get_branch_name_remote() {
    # fix/6.x/CFK-15337_splitK_perf_options_slices_and_buffer
    # local remote_branch_name=$(git config --get branch.$(get_branch_name_local).merge | cut -d '/' -f 3-   2>/dev/null)
    # git config --list | grep "$(get_branch_name_local).merge" | sed 's#.*refs/heads/##'
    local remote_branch_name=$(get_branch_name_remote_full | cut -d '/' -f 2-   2>/dev/null)
    if [[ $? -eq 0 ]]; then
        echo $remote_branch_name
        return 0
    else
        echo ""
        return 1
    fi
}

function get_branch_name_remote_full() {
    # <远程仓库名>/<分支名>
    # cask upstream name is origin
    # origin/fix/6.x/CFK-15337_splitK_perf_options_slices_and_buffer
    local remote_branch_full_name=$(git rev-parse --abbrev-ref --symbolic-full-name @{u} 2>/dev/null)
    if [[ $? -eq 0 ]]; then
        echo $remote_branch_full_name
        return 0
    else
        echo ""
        return 1
    fi
}

function get_branch_name_remote_by_local_branch_name() {
    local local_branch_name=$1
    
    if [ -z "$local_branch_name" ]; then
        return 1
    fi
    
    local remote_branch=$(git rev-parse --abbrev-ref --symbolic-full-name "$local_branch_name@{upstream}")
    
    if [ -z "$remote_branch" ]; then
        return 2
    fi
    
    echo "$remote_branch"
    return 0
}

function get_remote_repo_name() {
    get_remote_repo_name_all | tail -n 1
    return $?
}

function get_remote_repo_name_all() {
    # multiple remote repo name, added by
    # git remote add -f <2ndRepoAlias> <remoteRepoUrl>
    # git remote add -f ks ssh://git@gitlab-master.nvidia.com:12051/dlarch-fastkernels/kernel_store.git
    remote_name=$(git remote 2>/dev/null)
    if [[ $? -eq 0 ]]; then
        echo "$remote_name"
        return 0
    else
        echo ""
        return 1
    fi
}

function get_upstream_name() {
    get_branch_name_remote
    return $?
}

function get_upstream_name_full() {
    get_branch_name_remote_full
    return $?
}

function get_master_name_local() {
    # below cmd is too slow
    # git remote show origin | grep 'HEAD branch' | awk '{print $NF}'
    get_master_name_remote_full | sed "s#.*$(get_remote_repo_name)/##"
    return $?
}

function get_master_name_remote() {
    get_master_name_remote_full | sed 's#refs/remotes/##g'
    return $?
}

function get_master_name_remote_full() {
    # git symbolic-ref refs/remotes/origin/HEAD
    #  git remote get-url origin | xargs -I {} git ls-remote --symref {} HEAD
    git symbolic-ref refs/remotes/origin/HEAD   2>/dev/null
    return $?
}


function get_local_br_name_by_index() {
    local branch_index=${1:-1}
    local max_br_index=$(git branch | wc -l)
    [[ $branch_index -gt $max_br_index ]] && branch_index=${max_br_index}
    # git branch --sort=-creatordate -vv
    git branch --sort=-creatordate | nl -n ln -w 1 -s " " | grep -w "^${branch_index} " | cut -d' ' -f 3-
}

# get brach name by index or name
function get_branch_name_by_branch_parameter() {
    branch_paramter=${1:-"$(get_master_name_local)"}
    if is_number ${branch_paramter} ; then
        # it is number index
        [[ $branch_paramter -lt 1 ]] && branch_paramter=1
        tmp_br_name=$(get_local_br_name_by_index ${branch_paramter})

    else
        # it is branch name
        tmp_br_name=$(git branch | grep -w "${branch_paramter}" | cut -d' ' -f 2-)
    fi
    echo ${tmp_br_name}
}

# get worktree path by branch index or name
function get_worktree_path_by_branch_parameter() {    
    tmp_br_name=$(get_branch_name_by_branch_parameter $1)
    tmp_worktree_path=$( get_worktree_path_by_branch_name "${tmp_br_name}" )
    echo ${tmp_worktree_path}
}

function get_worktree_path_by_index_or_br_name() {
    local worktree_paramter=${1:-"1"}
    if is_number ${worktree_paramter} ; then
        # it is number index
        [[ $branch_paramter -lt 1 ]] && branch_paramter=1
        local max_lines=$(git worktree list | wc -l)
        [[ $worktree_paramter -gt $max_lines ]] && worktree_paramter=${max_lines}
        tmp_worktree_path=$(git branch --sort=-creatordate -vv | sed -n "${worktree_paramter} p" | grep -oP "(?<=\()[^\)]+" | update_symbol_path )
        echo "${tmp_worktree_path}"
    else
        # it is branch name
        get_worktree_path_by_branch_name "${worktree_paramter}"
    fi
}

function get_branch_name_local_by_worktree_path() {
    local worktree_path=$1
    [[ ! -d $worktree_path ]] && return 1
    local branch_name=$( git worktree list  | grep "/${worktree_path##*/} " | grep -oP "(?<=\[).*(?=\])" )
    if [[ -n $branch_name ]]; then
        # [branch_name]
        echo ${branch_name}
        return 0
    else
        echo ""
        return 2
    fi
}

function get_worktree_path_by_branch_name() {
    local branch_name=$1
    [[ "${branch_name}" == "" ]] && return 1
    # worktree_path can't resolve the [main]
    [[ "${branch_name}" == "$(get_master_name_local)" ]] && echo $(get_worktree_path_main) && return 0
    local worktree_path=$(git worktree list | egrep "\[${branch_name}\]" | awk '{print $1}' )
    if [[ -n $worktree_path ]]; then
        echo $worktree_path  | update_symbol_path
        return 0
    else
        echo ""
        return 2
    fi
}

function get_worktree_path_main() {
    # use rev-parse cmd to find .git folder path
    git_dir=$(git rev-parse --git-common-dir 2>/dev/null)

    [[ -d "$git_dir" ]] || return 1
    # find main worktree dir from .git folder
    main_worktree_path=$(dirname "$git_dir")
    # ${EXT_DIR}/repo/kernel_store
    echo "$(realpathx $main_worktree_path)"  | update_symbol_path
    return 0
}

# failure is possible
function get_worktree_path_current() {
    if get_git_dir_root; then
        return 0        # ok
    elif is_inside_build_dir ; then
        get_repo_dir_from_build_dir  "$(get_build_root_from_subfolder)"
        return $?       # return the last command status
    elif [[ -n $cur_repo_dir && -d $cur_repo_dir ]] ; then
        echo $cur_repo_dir | update_symbol_path
        return 0
    else
        return 1
    fi
}

# failure is not possible
function get_worktree_path_current_always() {
    # local worktree_path=$(git worktree list | awk '{print $1}' | head -n 1)
    local default_worktree_path=${1:-${cur_repo_dir}}
    get_worktree_path_current || { [[ -f $worktree_path ]] && echo $worktree_path || echo $(get_git_dir_root "${default_worktree_path}") ; }
    return 0
}

function get_git_repo_remote_link_prefix() {
    repo_root_path=$(get_git_dir_root ${1:-.} )
    [[ -z $repo_root_path ]] && return 1

    # ssh://git@gitlab-master.nvidia.com:12051/dlarch-fastkernels/dynamic-kernel-generator.git
    # =>
    # https://gitlab-master.nvidia.com/dlarch-fastkernels/dynamic-kernel-generator
    # local repo_link_prefix="$(cd $repo_root_path && git config --get remote.origin.url | grep -oP "(?<=@).*(?=\.git)" | sed 's/:[0-9]\+//')"
    local repo_link_prefix="$(cd $repo_root_path && git config --get remote.origin.url | sed 's#^.*gitlab#gitlab#' | sed 's#\.git.*$##'  | sed 's/:[0-9]\+//')"
    if [[ -n $repo_link_prefix ]]; then
        echo $repo_link_prefix
        return 0
    else
        return 1
    fi
}

function get_possible_cfk_num_of_commit_id() {
    git show --name-only "$@" | grep -ioP "(cfk|jira).\d+" | grep -oP -m 1 "\d+"
    return $?
}

function get_previous_id_by_commit_id() {
    # e.g. git rev-list -n 1 08bbda2a42^
    #  git log --oneline -n 3 08bbda2a42
    git rev-list -n 1 $1^   2>/dev/null
}

function get_commit_id_by_index() {
    local index=$1
    echo $(git rev-parse "HEAD~$index")
}

function get_commit_index_by_id() {
    # note : this function is only availabel on git liear history
    local commit_id=$1
    echo $(git rev-list --count $commit_id..HEAD)
}
############################################################################################################################################

function get_git_svn_dir_root() {
    local dir="${1:-$(pwd -L)}"
    [[ -z "$dir" || ! -d "$dir" ]] && return  1
    dir=$(cd "$dir" && pwd -P)      # resolve relative path , else while is dead loop
    
    while [[ "$dir" != "/" ]]; do
        if [[ -L "$dir/.git" || -d "$dir/.git" || -f "$dir/.git" ]]; then
            echo "$dir" | update_symbol_path
            return 0
        elif [[ -L "$dir/.svn" || -d "$dir/.svn" ]]; then
            echo "$dir" | update_symbol_path
            return 0
        fi
        dir=$(dirname "$dir")
    done

    return 1
}

function get_git_dir_root() {
    local dir="${1:-$(pwd -L)}"
    [[ -z "$dir" || ! -d "$dir" ]] && return  1
    dir=$(cd "$dir" && pwd -P)      # resolve relative path , else while is dead loop
    
    while [[ "$dir" != "/" ]]; do
        if [[ -L "$dir/.git" || -d "$dir/.git" || -f "$dir/.git" ]]; then
            echo "$dir" | update_symbol_path
            return 0
        fi
        dir=$(dirname "$dir")
    done
    return 1
}

function get_git_svn_file_root() {
    [[ -z "$1" || ! -e "$1" ]] && return  1
    get_git_svn_dir_root "$(dirname "$1")"
    return $?
}

function get_git_file_root() {
    [[ -z "$1" || ! -e "$1" ]] && return  1
    get_git_dir_root "$(dirname "$1")"
    return $?
}

############################################################################################################################################
function is_git_repo_file_path() {
    local file_path=$1
    [[ -z $file_path ]] && return 1
    git -C "$(dirname "$file_path")" rev-parse --show-toplevel 2> /dev/null 1> /dev/null && return 0 || return 2
}

function is_inside_git_repo() {
    get_git_dir_root 1>/dev/null 2>/dev/null
    return $?
    # local worktree_path=$(git worktree list | awk '{print $1}' | head -n 1)
    # git rev-parse --show-toplevel 2> /dev/null 1> /dev/null   && return 0 || return 1
    # git rev-parse --is-inside-work-tree &>/dev/null           && return 0 || return 1
}

function is_inside_git_svn_repo() {
    get_git_svn_dir_root $1 1>/dev/null 2>/dev/null
    return $?
    # local worktree_path=$(git worktree list | awk '{print $1}' | head -n 1)
    # git rev-parse --show-toplevel 2> /dev/null 1> /dev/null   && return 0 || return 1
    # git rev-parse --is-inside-work-tree &>/dev/null           && return 0 || return 1
}
function is_local_branch_exist() {
    # git rev-parse --verify $1 : can verify the branch name or commit id. 
    # if $1 is commit id, it will return the commit id.   $ git show $1
    # git rev-parse --verify $1 >/dev/null 2>&1   && return 0 || return 1
    git branch | grep -qcP " $1$" > /dev/null 2>&1 && return 0 || return 1
}

function is_exist_remote_branch_of_local_branch() {
    local current_branch=${1:-"$(get_branch_name_local)"}
    local local_branch_dir=$(get_worktree_path_by_index_or_br_name ${current_branch})
    local remote_branch=$( cd ${local_branch_dir} && git rev-parse --abbrev-ref --symbolic-full-name @{u} 2>/dev/null)
    if [ -n "$remote_branch" ]; then
        if git ls-remote --heads $(get_remote_repo_name) "${remote_branch##*/}" | grep -q "${remote_branch##*/}"; then
            return 0
        else
            dumpinfo "remote branch ${remote_branch##*/} is gone."
            return 2
        fi
    else
        return 1
    fi
}

function is_remote_branch_exist() {
    [[ -z $1 ]] && { dumperr "remote branch name is empty." ; return 1 ; }
    
    local remote_branch_name=$1
    local remote_repo=$(get_remote_repo_name)

    # git rev-parse --verify origin/$1 >/dev/null 2>&1   && return 0 || return 1
    if git ls-remote --heads "$remote_repo" "$remote_branch_name" | grep -q "$remote_branch_name"; then        
        return 0
    else
        return 1
    fi
}

function is_detached_head() {
    local detached_head=$(git symbolic-ref --short HEAD 2>/dev/null)
    if [[ $? -ne 0 ]]; then
        return 0
    else
        return 4
    fi
}

function is_1st_commit_id_include_2nd_commit_id() {
    # 获取参数
    local commit_id_1="$1"
    local commit_id_2="$2"

    # 找到两个commit id的最近公共祖先
    local common_ancestor=$(git merge-base "$commit_id_1" "$commit_id_2")

    commit_id_1_time=$(git show -s --format=%ci $commit_id_1)
    commit_id_2_time=$(git show -s --format=%ci $commit_id_2)
    dumpinfo "1st commit id ${red}${commit_id_1:0:8}${green} time: $commit_id_1_time"
    dumpinfo "2nd commit id ${red}${commit_id_2:0:8}${green} time: $commit_id_2_time"

    # 检查最近公共祖先是否是commit_id_2
    if [ "$common_ancestor" = "$commit_id_2" ]; then
        dumpinfo "${brown}[ include ] ${green}1st commit id $commit_id_1 includes 2nd commit id $commit_id_2."
    else
        dumpinfo "${brown}[ not include ] ${green}1st commit id $commit_id_1 does NOT include 2nd commit id $commit_id_2."
    fi
}

function is_conflict_with_remote_tracking_branch() {
    local remote_branch=$(git rev-parse --abbrev-ref --symbolic-full-name @{u} 2>/dev/null)
    if [[ -n $remote_branch ]]; then
        git merge-base --is-ancestor $remote_branch HEAD
        if [[ $? -ne 0 ]]; then
            return 0
        else
            return 5
        fi
    else
        return 6
    fi
}

function is_conflict_with_remote_main_branch() {
    local main_branch="$(get_master_name_remote)" # Replace with your remote main branch if different
    git merge-base --is-ancestor $main_branch HEAD
    if [[ $? -ne 0 ]]; then
        return 0
    else
        return 7
    fi
}

############################################################################################################################################
function test_all_functions() {
    echo "is_inside_git_svn_repo: $(is_inside_git_svn_repo)"
    echo "is_inside_git_svn_repo: $(is_inside_git_svn_repo)"
    echo "is_inside_git_svn_repo: $(is_inside_git_svn_repo)"
    echo "is_detached_head: $(is_detached_head)"
    echo "is_conflict_with_remote_tracking_branch: $(is_conflict_with_remote_tracking_branch)"
    echo "is_conflict_with_remote_main_branch: $(is_conflict_with_remote_main_branch)"
    echo "get_upstream_name: $(get_upstream_name)"
    echo "get_branch_name_local: $(get_branch_name_local)"
    echo "get_master_name_remote: $(get_master_name_remote)"
    echo "get_worktree_path_current: $(get_worktree_path_current)"
}

############################################################################################################################################
# test_all_functions

bash_script_o
