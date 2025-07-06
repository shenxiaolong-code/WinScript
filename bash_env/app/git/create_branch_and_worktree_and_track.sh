bash_script_i
echo

# usage
# alias    mdb='source ${BASH_DIR}/app/git/create_branch_and_worktree_and_track.sh'
# source create_branch_and_worktree_and_track.sh    <upstream_path>
# source create_branch_and_worktree_and_track.sh    fix/6.x/CFK-15322_emulated_fp32_kernel_integration

# source create_branch_and_worktree_and_track.sh    <branch_name>  [upstream_path]
# source create_branch_and_worktree_and_track.sh    test_illegal_instruct_memory      fix/6.x/CFK-15322_emulated_fp32_kernel_integration

# create new branch simply
# git checkout -b $1

# about release tag : ${BASH_DIR}/app/git/git_release_tag.txt

function init_create_branch_and_worktree(){
    is_inside_git_repo || { dumpinfox "${red}working directory MUST be inside a git repo folder" ; return;}
    if [[ $# -lt 1 ]]; then
        dumpinfox "Usage: mdb <new_local_br_name> [remote_br] [worktree_path]"
        dumpinfo  "       mdb test_wt"
        dumpinfo  "       mdb fix/remote_test_br"
        dumpinfo  "       mdb test_wt  fix/remote_test_br"
        dumpinfo  "       mdb test_wt  fix/remote_test_br  ${EXT_DIR}/repo/test_wt"
        return 1
    fi

    tmp_local_br_name=$(toLower $1)
    remote_base_br=$2
    repo_type=$(get_current_repo_type)
}

function pre_create_branch_and_worktree(){
    if [[ $repo_type == "dsl" || $repo_type == "dsl_lib" ]]; then
        dumpinfo "for dsl repo, suggest to create the dsl_lib branch first. and the dsl remote branch name MUST be the same as dsl_lib remote branch name."
    fi
    return 0
}

function post_create_branch_and_worktree(){
    # check if the branch already exists
    if [[ $repo_type == "dsl" ]]; then
        dumpinfox "for dsl repo, the dsl remote branch name MUST be the same as dsl_lib remote branch name."
        dumpinfo  "pushed to the remote repo cmd : nvpush ${dlg_lib_remote_branch_name}"
    fi

    [[ "dkg" == "${repo_type}" ]] && writevar  REPO_DIR ${worktree_path}
    # vscode_add_folder       ${worktree_path}
}

function prepare_new_worktree_name_and_path() {
    tmp_local_br_name=$(echo ${tmp_local_br_name} | sed 's#:##g')
    new_local_br_name=$(echo ${tmp_local_br_name} | sed 's#.*/##g' | sed 's# #_#' )
    # worktree_name=$(echo ${new_local_br_name} | sed -E 's#.*[cC][fF][kK].[0-9]{3,}.([^$].*)##g' )         # cfkxxx- not in line tail 
    worktree_name=$(remove_invalid_char_in_path ${new_local_br_name} | sed 's#^[cC][fF][kK][-_]*[0-9]\+[-_]*##')

    # worktree_root=$(get_worktree_path_main)
    if [[ ${repo_type} == "dsl" || ${repo_type} == "dsl_lib" ]]; then
        worktree_root=$(realpathx $(get_git_svn_dir_root)/../..)/${worktree_name}
        worktree_folder_name=${repo_type}
    else
        worktree_root=$(realpathx $(get_git_svn_dir_root)/..)
        worktree_folder_name=${repo_type}_$(echo ${worktree_name} | sed "s#${repo_type}_##")
    fi
    
    worktree_path=${3:-${worktree_root}/${worktree_folder_name}}

    # Check if the worktree already exists
    if [[ -d ${worktree_path} ]]; then
        # dumperr "Worktree ${worktree_folder_name} already exists."
        # [[ "$(get_worktree_path_current)" != "${worktree_path}" ]] && cd "${worktree_path}"
        # return    

        # we might want a new branch in a clean new worktree space for the debug purpose
        date_time_flag=$(date "+%Y%m%d_%H%M")
        new_local_br_name=${new_local_br_name}_${date_time_flag}
        worktree_folder_name=${repo_type}_$(echo ${worktree_name} | sed "s#${repo_type}_##")_${date_time_flag}
        worktree_path_new=${worktree_root}/${worktree_folder_name}
        dumpinfox "${red}${worktree_path} ${blue}already exists, append date_time_flag to the worktree name.${brown}\n               ${worktree_path_new}"
        worktree_path=${worktree_path_new}
    fi

    # fix the worktree path issue : when create worktree outside of docker, it uses /scratch.xiaolongs_gpu_1/
    # in docker , the path "/scratch.xiaolongs_gpu_1/" is not accessable , it should be /xlshen/scratch/
    # verify : cat <worktree_path>/.git
    worktree_path=$(echo ${worktree_path} | update_symbol_path )
}

function verify_local_branch_exist() {
    # Check if the branch already exists
    if is_local_branch_exist ${new_local_br_name} ; then
        dumperr "Branch ${new_local_br_name} already exists."
        [[ "$(get_branch_name_local)" != "${new_local_br_name}" ]] && goto_branch_in_current_worktree "${new_local_br_name}"
        return 1
    fi
    return 0
}

function setup_remote_base_branch() {
    local remote_repo_name=$(get_remote_repo_name)
    # Determine the base branch
    # fmt :  origin/fix_dsl_pipeline_failure_MR173
    if [[ -n ${remote_base_br} ]] ; then
        remote_base_br=$(echo ${remote_base_br} | sed "s#.*${remote_repo_name}/###" )
    else
        if [[ ${tmp_local_br_name} =~ "/" ]]; then
            remote_base_br=origin/$(echo ${tmp_local_br_name} | sed "s#.*${remote_repo_name}/###" )
        else
            remote_base_br=$(get_master_name_local)
        fi
    fi
    remote_base_br=${remote_repo_name}/$(echo ${remote_base_br} | sed "s#.*${remote_repo_name}/###")
    # remote_base_br=$(echo ${remote_base_br} | sed 's#:##g')
}

function sync_with_tot_code(){
    dumpinfo "sync trunk branch ... "
    # git fetch --all --prune
    source ${BASH_DIR}/app/git/git_sync_with_master.sh
}

function do_create_branch_and_worktree(){
    pre_create_branch_and_worktree || return 1

    cd $(get_worktree_path_main)
    # sync_with_tot_code

    echo
    dumpkey new_local_br_name
    dumpkey remote_base_br
    dumpkey worktree_path
    dumpinfox "create branch ${red}${new_local_br_name}${green} from ${purple}${remote_base_br} ${green}in new worktree ${brown}${worktree_folder_name}${end}"
    # echo "Creating branch ${new_local_br_name} from ${remote_base_br} in new worktree ${worktree_folder_name}"
    # Create the new branch and worktree
    dumpcmd "git worktree add -b ${new_local_br_name} ${worktree_path} ${remote_base_br}"
    git worktree add -b ${new_local_br_name} ${worktree_path} ${remote_base_br}

    if [[ ! -d $worktree_path ]]; then    
        dumpkey worktree_path
        dumpkey new_local_br_name
        dumpkey remote_base_br
        dumpcmdline
        dumperr "Failed to create worktree ${worktree_folder_name}"
        return 1
    fi

    echo
    cd ${worktree_path}
    post_create_branch_and_worktree

    # Unset upstream if the base branch is origin/main or origin/master
    if [[ "${remote_base_br}" == "$(get_master_name_remote)" ]]; then
        git branch --unset-upstream
    fi
    return 0
}

# setup clangd config
# ln -s ${BASH_DIR}/app/vscode/config/clang/.clangd        ${worktree_path}/.clangd

# set_fetch_remote_url will resolve below warning when using git worktree
# warning: redirecting to https://gitlab-master.nvidia.com/dlarch-fastkernels/kernel_store.git/
# set_fetch_remote_url
# see git_git_clone_dkg_example
# [[ "$(get_current_repo_type)" != "dkg" ]] && git remote add -f ks ssh://git@gitlab-master.nvidia.com:12051/dlarch-fastkernels/kernel_store.git
# to ${new_local_br_name}

function create_build_folder_with_config_when_mdb() {
    if [[ "dkg" != "${repo_type}" ]]; then
        dumpkey repo_type
        dumpinfox "create build folder only for dkg repo. skiping to create build buld folder ..."
        return
    fi

    local build_folder_name=$(toLower ${new_local_br_name//-/_})
    local build_worktree_path=${EXT_DIR}/build/${build_folder_name}_${repo_type}
    if [[ ! -d ${build_worktree_path} ]]; then
        dumpinfox "Creating build folder : ${build_worktree_path}"
        mkdir -p ${build_worktree_path}

        echo
        dumpinfo "prepare the cmds folder for the build folder : ${build_worktree_path}"
        dumpcmd "cp -rf ${EXT_DIR}/build/_template_/dkg/cmds  ${build_worktree_path}/cmds"
        cp -rf ${EXT_DIR}/build/_template_/dkg/cmds  ${build_worktree_path}/cmds
        # ( cd ${build_worktree_path} && source ${BASH_DIR}/nvidia/build/create_build_folder_with_config.sh "${repo_type}" )
        if [[ -f ${build_worktree_path}/cmds/_1_cmake.sh ]]; then
            local tmp_repo_dir=$(get_repo_dir_from_build_dir ${build_worktree_path}/cmds/_1_cmake.sh)
            dumpinfo "update _1_cmake.sh : ${tmp_repo_dir} to ${worktree_path}"
            updateFile_replace_string ${build_worktree_path}/cmds/_1_cmake.sh  "${tmp_repo_dir}"  "${worktree_path}"
            dumpinfo "build folder${brown} ${build_worktree_path} ${green}is created."
            writevar  BUILD_DIR     ${build_worktree_path}
            writevar  REPO_DIR      ${worktree_path}
        else 
            dumpkey repo_type
            dumperr "Fails to build folder${brown} ${build_worktree_path} ${green} because unknown reason."
        fi
        
        echo
        dumpinfo "prepare the job folder for the build folder : ${build_worktree_path}"
        local new_job_path=${build_worktree_path}/cur_job
        dumpcmd "cp -rf ${EXT_DIR}/myTasks/new_job_template  ${new_job_path}"
        cp -rf ${EXT_DIR}/myTasks/new_job_template  ${new_job_path}

        writevar  job_repo_dir      ${worktree_path}            ${new_job_path}/bin/job_config.sh
        writevar  job_build_dir     ${build_worktree_path}      ${new_job_path}/bin/job_config.sh
        {
            echo "# $(date +"%Y/%m/%d %T")"
            echo worktree_path=${worktree_path}
            echo build_worktree_path=${build_worktree_path}
            echo
        } >> ${new_job_path}/logs/build_folder_info.txt
    else
        dumpinfo "build folder${red} ${build_worktree_path} ${blue}already exists." ; 
    fi
}

function fix_docker_worktree_symbol_link_issue(){
    # worktree needs git version >= 2.5
    dumpinfox "fix git worktree path issue : ${worktree_path}"
    master_repo_path=$(get_worktree_path_main)
    if [[ -d ${master_repo_path} && -n ${worktree_folder_name} ]]; then
        local root_git_file=${worktree_path}/.git
        dumpkey root_git_file    
        sed -i 's#/scratch.xiaolongs_gpu_1/#/xlshen/scratch/#g' ${root_git_file}
        # cat ${root_git_file}
    
        local wt_git_file=${master_repo_path}/.git/worktrees/${worktree_folder_name}/gitdir
        dumpkey wt_git_file    
        sed -i 's#/scratch.xiaolongs_gpu_1/#/xlshen/scratch/#g' ${wt_git_file}    
        # cat ${wt_git_file}
        return 0
    else
        dumpkey master_repo_path
        dumpkey worktree_folder_name
        dumpinfo "Fails to fix git worktree path issue."
        dumperr "master_repo_path or worktree_folder_name is empty."
        return 1
    fi
}

function main_create_branch_and_worktree(){
    init_create_branch_and_worktree "$@"    ||  return 1
    prepare_new_worktree_name_and_path "$@"
    verify_local_branch_exist "$@"          ||  return 2
    setup_remote_base_branch "$@"
    do_create_branch_and_worktree           ||  return 3
    [[ $repo_type == "dkg" ]] && fix_docker_worktree_symbol_link_issue && create_build_folder_with_config_when_mdb
}

function main_create_branch_and_worktree_tc(){
    main_create_branch_and_worktree  tc_create_branch_worktree_$(date "+%Y%m%d_%H%M")
}

main_create_branch_and_worktree "$@"

echo
bash_script_o

