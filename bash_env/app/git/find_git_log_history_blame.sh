#!/bin/bash

bash_script_i

function blame_file_line_range(){
    local file_path=$1
    local line_number=$2
    [[ -z "$file_path" || ! -f "$file_path" ]] && {
        echo "Usage: blame_file_line <file_path> <line_number>"
        dumperr "empty file_path or file_path not exists"
        return 1
    }
    dumpcmd "git blame -L ${line_number},${line_number} \"${file_path}\""
    git blame -L ${line_number},${line_number} "${file_path}"
}

function blame_whole_file(){
    local file_path=$1
    [[ -z "$file_path" || ! -f "$file_path" ]] && {
        echo "Usage: blame_whole_file <file_path>"
        dumperr "empty file_path or file_path not exists"
        return 1
    }
    dumpcmd "git blame \"${file_path}\""
    git blame "${file_path}"
}

function find_which_commit_add_delete_the_line(){
    dumppos
    local file_path=$1
    local deleted_line_string=$2
    [[ -z "$deleted_line_string" || ! -f "$file_path" ]] && {
        echo "Usage: find_which_commit_delete_the_line <deleted_line_string> <file_path>"
        dumperr "empty deleted_line_string or file_path not exists"
        return 1
    }
    
    # git log -S "reference_gemm_bias_activation_aux_f16" --patch -- cask_api/CMakeLists.txt
    dumpcmd "git log -S \"${deleted_line_string}\" --patch -- \"${file_path}\""
    git log -S "${deleted_line_string}" --patch --color=always -- "${file_path}"
}

function find_file_change_history_after_commit(){
    local file_path=$1
    local commit_id=$2
    [[ -z "$commit_id" || ! -f "$file_path" ]] && {
        echo "Usage: find_file_change_history_after_commit <commit_id> <file_path>"
        dumperr "empty commit_id or file_path not exists"
        return 1
    }

    # Check if commit exists
    if ! git rev-parse --verify "${commit_id}^{commit}" >/dev/null 2>&1; then
        dumperr "commit ${commit_id} does not exist"
        return 1
    fi

    local output_file_path="${TEMP_DIR}/cache/git_id/${file_path##*/}.${commit_id}.log"
    [[ -f ${output_file_path} ]] && rm ${output_file_path}
    # Get all changes history after the specified commit
    # No need to check if file exists in the commit as it might be added later
    dumpcmd "git log ${commit_id}..HEAD -p --follow -- \"${file_path}\" > ${output_file_path}"
    git log "${commit_id}..HEAD" -p --follow -- "${file_path}" | grep -P "commit |^\+|^\-" | tee ${output_file_path}
    dumpinfo "${output_file_path}"
}

# find_deleted_file_commit <file_path>
# find_deleted_file_commit cutlass/gemm/collective/builders/sm100_sparse_config.inl
function find_deleted_file_commit() {
    local file_path=$1
    
    if [[ -f $file_path ]] ; then
        dumperr "file ${file_path} still exists.${brown} ${FUNCNAME[0]} ${red}is used to search which commit deletes single spec file."
        return 1
    fi
    
    dumpinfo "Searching for commits that deleted file containing:${brown} ${file_path}"
    commit_id=$(git log --all --full-history --format="%H" --diff-filter=D --max-count=1 -- "*${file_path}*")
    if [[ -n "$commit_id" ]]; then
        echo "#  $commit_id   D     ${file_path}"
        dumpinfo "show more detail : ${brown} show_git_commit_id_info  $commit_id"
    fi
}

function find_commit_id_of_delete_folder_or_file() {
    local deleted_git_stuff_path=${1:-"cask_api/include/cask_api/Provider/Resource"}
    dumpcmd "git log --diff-filter=D -- ${deleted_git_stuff_path}"
    git log --diff-filter=D -- ${deleted_git_stuff_path}
}

# alias glogx     'git  log --graph --pretty=format:"%C(red)%h%C(reset) %C(bold blue)%<(8)%an%C(reset) %C(yellow)%<(60,trunc)%s%C(reset)  %C(green)(%cr)%C(reset) %<(60,trunc)%d %C(reset) " $1'
# function gitlogx()  { git --no-pager log --grep="Merge branch" --invert-grep --pretty=format:"%C(red)%h%C(reset) %C(bold blue)%<(8)%an%C(reset) %C(yellow)%<(60,trunc)%s%C(reset)  %C(green)(%cr)%C(reset) %<(60,trunc)%d %C(reset)" $* ; echo  ;  }
function gitlogx()    {
    list_function_in_script_file ${BASH_SOURCE[0]}
    git --no-pager log --no-merges --invert-grep --pretty=format:"%C(red)%h%C(reset) %C(bold blue)%<(8)%an%C(reset) %C(yellow)%<(60,trunc)%s%C(reset)  %C(green)(%cr)%C(reset) %<(60,trunc)%d %C(reset)" $* ; 
    echo  ;  
    }
alias glog='echo gitlogx -10 ; gitlogx -10 ; echo -e \\n${green}cmd ${brown}glogmy ${red}glogmy2 ${purple}git reflog ${green}is also available ${end}'
alias glogmy='gitlogx -10 --author=xiaolongs '
alias glogmy2='git --no-pager log -10 --author=xiaolongs ; echo'

alias glogi="list_function_in_script_file ${BASH_SOURCE[0]}"

bash_script_o
