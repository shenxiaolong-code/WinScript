
bash_script_i

# github api tutorial
# https://docs.github.com/en/rest/commits/commits?apiVersion=2022-11-28#list-pull-requests-associated-with-a-commit
################################################ git API ############################################################################################
git_info_cache_dir=${TEMP_DIR}/cache/git_detail_info
[[ ! -d "${git_info_cache_dir}" ]] && { mkdir -p "${git_info_cache_dir}" ; }

# get_git_repo_remote_link_prefix .
function set_gitlab_host_and_project_id() {
    #  ssh://git@gitlab-master.nvidia.com:12051/dlarch-fastkernels/dynamic-kernel-generator.git
    local repo_link_prefix=$(get_git_repo_remote_link_prefix)         # gitlab-master.nvidia.com/dlarch-fastkernels/dynamic-kernel-generator
    [[ -z "${repo_link_prefix}" ]] && { dumperr "repo_link_prefix is empty" ; return 1 ; }    
    gitlab_host="https://${repo_link_prefix%%/*}"                     # https://gitlab-master.nvidia.com
    project_id="${repo_link_prefix#*/}"                               # dlarch-fastkernels/dynamic-kernel-generator
    project_id="$(echo ${project_id} | sed 's/\//%2F/g' )"            # dlarch-fastkernels/dynamic-kernel-generator  => dlarch-fastkernels%2Fdynamic-kernel-generator    
    
    [[ $# -gt 0 ]] && {
        echo \# curl --silent --header '"PRIVATE-TOKEN: $GITLAB_ACCESS_TOKEN"' "$gitlab_host/api/v4/projects/$project_id"
        dumpkey gitlab_host
        dumpkey project_id
    }
    return 0
}

function check_result_json_file() {
    local result_json_file=$1
    [[ ! -f "${result_json_file}" ]] && return 0
    # if empty json file, delete it.  only [] is empty json file
    local result_json_file_content=$(cat ${result_json_file})
    [[ "${result_json_file_content}" == "[]" ]] && { rm -f ${result_json_file} ; echo "delete empty json file: ${result_json_file}" 1>&2 ; }
    return 0
}

function get_commit_info_of_id() {
    get_branch_name_remote 1> /dev/null || { dumperr "branch_name is empty" ; return 1 ; }
    
    unset interactive_mode
    [[ $# -gt 0 ]] && { interactive_mode=1 ; }

    local commit_sha=$1    
    git_commit_id_file=${git_info_cache_dir}/commit_id_${commit_sha}.json
    check_result_json_file  ${git_commit_id_file}
    dumpinfo "git_commit_id_file: ${git_commit_id_file}" 1>&2
    [[ -f "${git_commit_id_file}" ]] && { 
        [[ -v interactive_mode ]] || { cat "${git_commit_id_file}" ; return 0 ; }
    }

    set_gitlab_host_and_project_id "$@" || return 1
    [[ -v interactive_mode ]] && {
        dumpkey commit_sha
        dumpinfo 'curl --silent --header "PRIVATE-TOKEN: $GITLAB_ACCESS_TOKEN" "$gitlab_host/api/v4/projects/$project_id/repository/commits/$commit_sha"'
        dumpcmd "curl --silent --header \"PRIVATE-TOKEN: $GITLAB_ACCESS_TOKEN\" \$gitlab_host/api/v4/projects/$project_id/repository/commits/$commit_sha"
    }

    [[ ! -f "${git_commit_id_file}" ]] && curl --silent --header "PRIVATE-TOKEN: $GITLAB_ACCESS_TOKEN" "$gitlab_host/api/v4/projects/$project_id/repository/commits/$commit_sha" | python -m json.tool >| ${git_commit_id_file}
    [[ -v interactive_mode ]] && { dumpinfo "${git_commit_id_file}" ; } || { cat "${git_commit_id_file}" ; }
    return 0
}


function get_mr_info_of_remote_branch() {
    local remote_branch_name=$1
    remote_branch_name=$(echo ${remote_branch_name} | sed "s#$(get_remote_repo_name)/##g" | sed 's#:.*##g')
    is_remote_branch_exist "${remote_branch_name}" || { dumperr "remote branch ${remote_branch_name} is not exist" ; return 1 ; }
    
    unset interactive_mode
    [[ $# -gt 1 ]] && { interactive_mode=1 ; }
    
    local mr_info_file=${git_info_cache_dir}/mr_remote_${remote_branch_name//\//_}_$(date "+%m").json
    check_result_json_file  ${mr_info_file}
    # dumpinfo "mr_info_file: ${mr_info_file}" 1>&2
    [[ -f "${mr_info_file}" ]] && { 
        dumpinfo "${mr_info_file}"
        vscode_open_link "$(cat "${mr_info_file}" | grep "web_url" | tail -n 1 | grep -oP "https[^\"]+")"
        return 0
    }

    set_gitlab_host_and_project_id "$@" || return 1
    [[ -v interactive_mode ]] && {
        dumpkey remote_branch_name
        dumpinfo 'curl --silent --header "PRIVATE-TOKEN: $GITLAB_ACCESS_TOKEN" "$gitlab_host/api/v4/projects/$project_id/merge_requests?source_branch=$remote_branch_name&state=opened"'
        dumpcmd "curl --silent --header \"PRIVATE-TOKEN: $GITLAB_ACCESS_TOKEN\" \$gitlab_host/api/v4/projects/$project_id/merge_requests?source_branch=$remote_branch_name&state=opened"
    }

    [[ ! -f "${mr_info_file}" ]] && curl --silent --header "PRIVATE-TOKEN: $GITLAB_ACCESS_TOKEN" "$gitlab_host/api/v4/projects/$project_id/merge_requests?source_branch=$remote_branch_name&state=opened" | python -m json.tool >| ${mr_info_file}
    dumpinfo "${mr_info_file}"
    vscode_open_link "$(cat "${mr_info_file}" | grep "web_url" | tail -n 1 | grep -oP "https[^\"]+")"
    return 0
}

function get_mr_info_of_current_branch() {
    get_branch_name_remote 1> /dev/null || { dumperr "branch_name is empty" ; return 1 ; }
    
    unset interactive_mode
    [[ $# -gt 0 ]] && { interactive_mode=1 ; }

    local mr_info_file=""
    local local_branch_name=$(get_branch_name_local)
    [[ -z "${local_branch_name}" ]] && { dumperr "local_branch_name is empty" ; return 1 ; }
    if [[ "${local_branch_name}" == "HEAD" ]] ; then
        git branch --color -vv | grep -P "^\*" >&2
        dumperr "Perhaps you are in a detached HEAD state, git rebase middle of the process, please check the branch name"
        return 1
    fi
    
    local remote_branch_name=$(get_branch_name_remote)
    mr_info_file=${git_info_cache_dir}/mr_${local_branch_name}_${remote_branch_name//\//_}_$(date "+%m").json
    check_result_json_file  ${mr_info_file}
    dumpinfo "mr_info_file: ${mr_info_file}" 1>&2
    [[ -f "${mr_info_file}" ]] && { 
        [[ -v interactive_mode ]] || { cat "${mr_info_file}" ; return 0 ; }
    }

    set_gitlab_host_and_project_id "$@" || return 1
    [[ -v interactive_mode ]] && {
        dumpkey remote_branch_name
        dumpinfo 'curl --silent --header "PRIVATE-TOKEN: $GITLAB_ACCESS_TOKEN" "$gitlab_host/api/v4/projects/$project_id/merge_requests?source_branch=$remote_branch_name&state=opened"'
        dumpcmd "curl --silent --header \"PRIVATE-TOKEN: $GITLAB_ACCESS_TOKEN\" \$gitlab_host/api/v4/projects/$project_id/merge_requests?source_branch=$remote_branch_name&state=opened"
    }

    [[ ! -f "${mr_info_file}" ]] && curl --silent --header "PRIVATE-TOKEN: $GITLAB_ACCESS_TOKEN" "$gitlab_host/api/v4/projects/$project_id/merge_requests?source_branch=$remote_branch_name&state=opened" | python -m json.tool >| ${mr_info_file}
    [[ -v interactive_mode ]] && { dumpinfo "${mr_info_file}" ; } || { cat "${mr_info_file}" ; }
    return 0
}

function get_mr_info_from_commit_id() {
    get_branch_name_remote 1> /dev/null || { dumperr "branch_name is empty" ; return 1 ; }
    
    local commit_sha=$1
    unset interactive_mode
    [[ $# -gt 1 ]] && { interactive_mode=1 ; }

    mr_info_of_id_file=${git_info_cache_dir}/mr_of_id_${commit_sha}.json
    check_result_json_file  ${mr_info_of_id_file}
    dumpinfo "${mr_info_of_id_file}" 1>&2
    [[ -f "${mr_info_of_id_file}" ]] && { 
        [[ -v interactive_mode ]] || { cat "${mr_info_of_id_file}" ; return 0 ; }
    }

    set_gitlab_host_and_project_id "$@" || return 1
    [[ -v interactive_mode ]] && {
        dumpkey commit_sha
        dumpinfo 'curl --silent --header "PRIVATE-TOKEN: $GITLAB_ACCESS_TOKEN" $gitlab_host/api/v4/projects/$project_id/repository/commits/${commit_sha}/merge_requests"'
        dumpcmd "curl --silent --header \"PRIVATE-TOKEN: $GITLAB_ACCESS_TOKEN\" \$gitlab_host/api/v4/projects/$project_id/repository/commits/${commit_sha}/merge_requests\""
    }

    [[ ! -f "${mr_info_of_id_file}" ]] && curl --silent --header "PRIVATE-TOKEN: $GITLAB_ACCESS_TOKEN" "$gitlab_host/api/v4/projects/$project_id/repository/commits/${commit_sha}/merge_requests" | python -m json.tool >| ${mr_info_of_id_file}
    [[ -v interactive_mode ]] && { dumpinfo "${mr_info_of_id_file}" ; } || { cat "${mr_info_of_id_file}" ; }
    return 0
}

function get_upstream_info_of_current_branch() {
    local remote_branch=$(get_branch_name_remote)
    [[ -z "${remote_branch}" ]] && { dumperr "remote_branch is empty" ; return 1 ; }
    
    unset interactive_mode
    [[ $# -gt 0 ]] && { interactive_mode=1 ; }
    # [[ -v interactive_mode ]] && echo "show mode : ${interactive_mode}" || echo "quiet mode: ${interactive_mode}"

    local local_branch_name=$(get_branch_name_local)
    [[ -z "${local_branch_name}" ]] && { dumperr "local_branch_name is empty" ; return 1 ; }
    if [[ "${local_branch_name}" == "HEAD" ]] ; then
        git branch --color -vv | grep -P "^\*" >&2
        dumperr "current branch is in a detached HEAD state, git rebase middle of the process, please check the branch name"
        return 1
    fi
    local upstream_info_file=${git_info_cache_dir}/upstream_${local_branch_name}_$(date "+%m").json
    check_result_json_file  ${upstream_info_file}
    dumpinfo "upstream_info_file: ${upstream_info_file}" 1>&2
    [[ -f "${upstream_info_file}" ]] && { 
        [[ -v interactive_mode ]] || { cat "${upstream_info_file}" ; return 0 ; }
    }

    set_gitlab_host_and_project_id "$@" || return 1
    [[ -v interactive_mode ]] && {
        dumpkey remote_branch
        dumpinfo 'curl --silent --header "PRIVATE-TOKEN: $GITLAB_ACCESS_TOKEN" "$gitlab_host/api/v4/projects/$project_id/repository/branches/$remote_branch"'
        dumpcmd "curl --silent --header \"PRIVATE-TOKEN: $GITLAB_ACCESS_TOKEN\" \$gitlab_host/api/v4/projects/$project_id/repository/branches/$remote_branch"
    }
    # dumpcmd curl --silent --header "PRIVATE-TOKEN: $GITLAB_ACCESS_TOKEN" "$gitlab_host/api/v4/projects/$project_id/repository/branches/$remote_branch"
    [[ ! -f "${upstream_info_file}" ]] && curl --silent --header "PRIVATE-TOKEN: $GITLAB_ACCESS_TOKEN" "$gitlab_host/api/v4/projects/$project_id/repository/branches/$remote_branch" | python -m json.tool >| ${upstream_info_file}
    [[ -v interactive_mode ]] && { dumpinfo "${upstream_info_file}" ; } || { cat "${upstream_info_file}" ; }
    return 0
}

################################################ get info based on git API ############################################################################################
function get_merge_target_branch() {
    local merge_target_branch=$(get_mr_info_of_current_branch | grep -m 1 "target_branch" | grep -oP 'target_branch":\s*"\K[^"]+' ${mr_info_file})
    [[ -z "${merge_target_branch}" ]] && return 1
    # keep same as get_master_name_remote with the prefix origin/
    echo "$(get_remote_repo_name)/${merge_target_branch}"
    return 0
}

function get_MR_link_of_current_branch() {
    get_mr_info_of_current_branch | grep "web_url" | tail -n 1 | grep -oP "https[^\"]+"
    return $?
}

function get_mr_link_of_commit_id() {
    get_mr_info_from_commit_id "$@" | grep "web_url" | tail -n 1 | grep -oP "https[^\"]+";
    return $?
}

function is_has_merge_request() {
    get_mr_info_of_current_branch 1> /dev/null 2> /dev/null && return 0 || return 1
}

################################################ vscode open link ############################################################################################
# open_MR_link_of_current_branch
function open_MR_link_of_current_branch() {
    local mr_link=$(get_MR_link_of_current_branch)
    [[ -n $mr_link ]] && {
        dumpinfo "open MR link : ${mr_link}"
        vscode_open_link $mr_link
    } || {
        dumpinfo "no MR link found for current branch"
        [[ ! -f ${mr_info_file} ]] && return
        dumpinfox "see : ${mr_info_file}"
        vscode_open_file ${mr_info_file}
    }
}

# open_MR_link_of_commit_id 1e4fb99ebb6
function open_MR_link_of_commit_id () 
{ 
    local commit_sha=$1
    local mr_link=$(get_mr_link_of_commit_id "$@");
    [[ -n $mr_link ]] && { 
        dumpinfo "${mr_info_of_id_file}"
        dumpinfo "commit_sha : ${commit_sha}"
        dumpinfo "open MR link : ${mr_link}";
        vscode_open_link $mr_link
    } || { 
        dumpinfo "no MR link found for commit id ${commit_sha}";
        [[ ! -f ${mr_info_of_id_file} ]] && return;
        dumpinfo "see : ${mr_info_of_id_file}";
        vscode_open_file ${mr_info_of_id_file}
    }
}

alias iremote='get_upstream_info_of_current_branch show'
alias imr='get_mr_info_of_current_branch show'
alias mr='open_MR_link_of_current_branch'
alias mrx='get_mr_info_of_remote_branch'
alias iidmr='get_mr_info_from_commit_id'

bash_script_o

################################################ DOC ############################################################################################
# GitLab API 常用示例
# 注意：所有命令都需要在前面加上 curl --header "PRIVATE-TOKEN: $GITLAB_ACCESS_TOKEN" 

# see get_mr_info_of_current_branch and get_upstream_info_of_current_branch

# ===== 查询类 API (Query) =====

# 1. 获取项目信息
# GET "$gitlab_host/api/v4/projects/$project_id"

# 2. 获取所有打开的合并请求
# GET "$gitlab_host/api/v4/projects/$project_id/merge_requests?state=opened"

# 3. 获取特定分支的合并请求
# GET "$gitlab_host/api/v4/projects/$project_id/merge_requests?source_branch=$branch_name&state=opened"

# 4. 获取项目所有分支
# GET "$gitlab_host/api/v4/projects/$project_id/repository/branches"

# 5. 获取特定分支信息
# GET "$gitlab_host/api/v4/projects/$project_id/repository/branches/$branch_name"

# 6. 获取提交历史
# GET "$gitlab_host/api/v4/projects/$project_id/repository/commits"

# 7. 获取特定提交详情
# GET "$gitlab_host/api/v4/projects/$project_id/repository/commits/$commit_sha"

# 8. 获取项目所有标签
# GET "$gitlab_host/api/v4/projects/$project_id/repository/tags"

# 9. 获取项目pipeline列表
# GET "$gitlab_host/api/v4/projects/$project_id/pipelines"

# 10. 获取项目issues列表
# GET "$gitlab_host/api/v4/projects/$project_id/issues"

# ===== 更新类 API (Update) =====

# 1. 创建新的合并请求
# POST "$gitlab_host/api/v4/projects/$project_id/merge_requests" \
#    --data "source_branch=$source_branch" \
#    --data "target_branch=$target_branch" \
#    --data "title=$mr_title" \
#    --data "description=$mr_description"

# 2. 接受合并请求
# PUT "$gitlab_host/api/v4/projects/$project_id/merge_requests/$mr_iid/merge"

# 3. 创建新分支
# POST "$gitlab_host/api/v4/projects/$project_id/repository/branches" \
#    --data "branch=$new_branch" \
#    --data "ref=$source_branch"

# 4. 删除分支
# DELETE "$gitlab_host/api/v4/projects/$project_id/repository/branches/$branch_name"

# 5. 创建新标签
# POST "$gitlab_host/api/v4/projects/$project_id/repository/tags" \
#    --data "tag_name=$tag_name" \
#    --data "ref=$ref" \
#    --data "message=$message"

# 6. 创建issue
# POST "$gitlab_host/api/v4/projects/$project_id/issues" \
#    --data "title=$issue_title" \
#    --data "description=$issue_description"

# 7. 更新issue状态
# PUT "$gitlab_host/api/v4/projects/$project_id/issues/$issue_id" \
#    --data "state_event=close"  # 或 "state_event=reopen"

# 8. 添加评论到合并请求
# POST "$gitlab_host/api/v4/projects/$project_id/merge_requests/$mr_iid/notes" \
#    --data "body=$comment"

# 9. 更新合并请求
# PUT "$gitlab_host/api/v4/projects/$project_id/merge_requests/$mr_iid" \
#    --data "title=$new_title" \
#    --data "description=$new_description"

# 10. 设置pipeline变量
# POST "$gitlab_host/api/v4/projects/$project_id/variables" \
#    --data "key=$variable_key" \
#    --data "value=$variable_value"

# 注意事项：
# 1. 所有的 $project_id 需要是URL编码后的值
# 2. 所有的 POST/PUT 请求数据都应该正确设置 Content-Type
# 3. 某些API可能需要特定的权限级别
# 4. 建议在使用更新类API时先在测试环境验证
# 5. 某些API可能需要额外的查询参数来过滤或限制结果 