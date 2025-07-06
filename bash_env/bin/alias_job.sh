#!/bin/bash

bash_script_i

function get_job_folder_from_paramter(){
  local tmp_job_path=${1:-$(pwd -L)}
  if [[ -z $1 ]] ; then
    # no parameter, use default cur pwd folder
    [[ -d ${tmp_job_path}/cur_job ]] && tmp_job_path=${tmp_job_path}/cur_job
    [[ ! -f ${tmp_job_path}/alias_task.sh ]] && tmp_job_path="${job_path}"
  fi
  echo ${tmp_job_path}
}

function list_job_folder_info(){
  local tmp_job_path=$(get_job_folder_from_paramter $1)
  local tmp_job_path=$(realpath ${tmp_job_path} | update_symbol_path )
  lp ${tmp_job_path}
  show_cmd_in_job_folder "${tmp_job_path}"
  dumpkey cur_repo_dir
  dumpkey cur_build_dir
  dumpinfo "switch job :${green_256} ${EXT_DIR}/tmp/test/alias_temp.sh"
}
alias ljob='list_job_folder_info'
alias ljobs='lp ${EXT_DIR}/myTasks/curTask'
alias rjob='source $(get_job_folder_from_paramter)/alias_task.sh'

alias fjobs='ffa ${EXT_DIR}/myTasks/curTask'
alias fjob=' ffa ${job_path}'

alias gjobs='cd ${EXT_DIR}/myTasks/curTask ; ll ;'
alias gjob=' cd ${job_path}  ; ll ;'
alias oxjob='vscode_add_folder ${job_path}'
alias oxjobs='vscode_add_folder ${EXT_DIR}/myTasks'
alias cdjob=gjob
alias cdjobs=gjobs

alias ojobs='vscode_add_folder ${EXT_DIR}/myTasks/curTask'
alias ojob='code  -add ${job_path}'

alias bye='source ${EXT_DIR}/tmp/test/run_nightly_task.sh'

# search text in job folder
function find_text_in_job_folder    { 
  echo "\n#${black} find_text_in_dir : ${green}Searching text ${brown}$1${green} in ${red}${job_path}  ${end}"              ; 
  egrep -i --color=always  -snIRH --exclude-dir={ci_mr,.git,.vscode} "$1" $(readlink -f ${job_path})/*   | sed 's#:#  #2'   ; 
  
  echo "\n#${black} Done to find_text_in_dir : ${green}Searching text ${brown}$1${green} in ${red}${job_path}  ${end}"              ; 
  dumppos   ;
}
alias ftjob=find_text_in_job_folder

function relink_different_cmd_folder_to_current_build_folder(){
  local tmp_target_cmds_folder=$1
  [[ ! -f ${tmp_target_cmds_folder}/_1_cmake.sh ]] && {
    [[ -d ${job_path}/build_cmds ]] && command ls -1 -Artd ${job_path}/build_cmds/* | xargs -n 1 -I @ echo @/cmds
    dumperr "invalid cmds folder : ${tmp_target_cmds_folder}"
    return 1
  }
  [[ ! -f ./cmds/_1_cmake.sh ]] && {
    dumperr "invalid build folder : $(pwd -L)"
    return 1
  }
  [[ -f ./cmds ]] && rm     ./cmds
  [[ -d ./cmds ]] && rm -rf ./cmds

  dumpcmd "ln -s ${tmp_target_cmds_folder} ./cmds"
  ln -s ${tmp_target_cmds_folder} ./cmds
  return 0
}
alias lncmds=relink_different_cmd_folder_to_current_build_folder

function relink_different_job_folder_to_current_build_folder(){
  local tmp_target_job_path=$1
  [[ ! -f ${tmp_target_job_path}/alias_task.sh ]] && {
    ljobs
    dumperr "invalid job folder : ${tmp_target_job_path}"
    return 1
  }
  [[ -L ./cur_job ]] && rm ./cur_job
  [[ -d ./cur_job ]] && rm -rf ./cur_job

  dumpcmd "ln -s ${tmp_target_job_path} ./cur_job"
  ln -s ${tmp_target_job_path} ./cur_job
  return 0
}
alias lnjob=relink_different_job_folder_to_current_build_folder

function show_cmd_in_job_folder    {
  local tmp_job_path=$(get_job_folder_from_paramter $1)
  tmp_job_path=$(realpath ${tmp_job_path} | update_symbol_path )
  # [[ -f ${tmp_job_path}/logs/build_folder_info.txt ]] && dumpinfo "${tmp_job_path}/logs/build_folder_info.txt"
  if [[ -f ${tmp_job_path}/alias_task.sh ]] ; then
    grep --color=always -P "^ *job_log=\K.*" ${tmp_job_path}/alias_task.sh
    list_function_in_script_file ${tmp_job_path}/alias_task.sh | sed -E "s#^/home/[^ ]+ +##"
    # dumpinfo "cmds in ${tmp_job_path}/alias_task.sh"
    # grep --color=none -oP "^ *alias .*" ${tmp_job_path}/alias_task.sh | envsubst | sed -E "s#([^ ]+)=#${red}\1${end}=${green}#" | sed -E "s#^alias .*#${black}&${end}#"  
    # grep --color=none -nHoP "alias .*" ${tmp_job_path}/alias_task.sh | envsubst | sed 's#"# " #g' | sed "s#:# #2" | sed -r "s#([^ ]+) +(.*)#\# ${blue}task cmd : ${red}\2\t    ${black}\1${end}#g" | sed -E "s#([^ ]+)=#${green}\1${end}=${purple}#"
  fi
  grep --color=always -P "alias +\K(bd|tc|gen)7.*?(?==)" ${BASH_DIR}/nvidia/build/alias_build.sh
}

function switch_job_update_script(){
  # dumpcmdline
  new_job_path=$1
  [[ -n $debug_job_change ]] && {  
    dumpinfo "switch_job_update_script : $1" ;
    dumpkey job_path
    dumpkey new_job_path
    dumpstack ; 
    pause ; 
  }

  is_same_path "${EXT_DIR}/myTasks/curTask/job_dkg_debug" "${new_job_path}" && { 
    dumpinfo "switch job to debug dkg, not update the global job path in ${EXT_DIR}/tmp/test/alias_temp.sh" 
    return ; 
  }

  [[ -z $1 ]] && { dumperr "no job path provided" ; return ; }
  is_same_path "${job_path}" "${new_job_path}" && { dumpkey job_path ; dumpkey new_job_path ; dumperr "no change in job path" ; return ; }
  
  dumpinfo "switch job : ${job_path} => ${new_job_path}"
  export old_job_path=${job_path}
  # updateFile_comment_out_whole_line ${EXT_DIR}/tmp/test/alias_temp.sh "${job_path##*/}"  
  updateFile_comment_out_whole_line ${EXT_DIR}/tmp/test/alias_temp.sh "${EXT_DIR}"  # comment out all enabled job
  if grep -c "${new_job_path}" ${EXT_DIR}/tmp/test/alias_temp.sh > /dev/null ; then
    updateFile_uncomment_out_whole_line ${EXT_DIR}/tmp/test/alias_temp.sh "${new_job_path}"
  else
    updateFile_insert_line_before_Nth_line ${EXT_DIR}/tmp/test/alias_temp.sh  11  "source ${new_job_path}/alias_task.sh"
  fi
  export job_path=${new_job_path}
}

function switch_job(){
  if [[ -n $1 ]] ; then
    if [[ -d $1 ]] ; then
      local tmp_target_dir=${1}
    else
      dumpinfo "fetch job folder from job name : ${1}"
      local tmp_target_dir=$(grep -oP "source \K.*/${1}(?=/)" ${EXT_DIR}/tmp/test/alias_temp.sh)
      if [[ ! -d ${tmp_target_dir} ]] ; then
        dumpkey tmp_target_dir
        dumpinfo "available job folders :"
        command ls --color=always -1 -Artd ${EXT_DIR}/myTasks/curTask/*
        dumperr "no available job folder found for job name : ${1}"
        return 1
      fi
    fi
  else
    local tmp_target_dir=$(pwd -L)
  fi
  
  # it is a build folder
  if [[ -f ${tmp_target_dir}/cmds/_1_cmake.sh && -d ${job_path} ]]; then
    dumpinfo "link ${job_path} to ${tmp_target_dir}/cur_job"
    [[ -L ${tmp_target_dir}/cur_job ]] && rm ${tmp_target_dir}/cur_job
    dumpcmd "ln -s ${job_path}  ${tmp_target_dir}/cur_job"
    ln -s ${job_path}  ${tmp_target_dir}/cur_job
    vscode_add_folder ${job_path}
    # source ${BASH_DIR}/nvidia/build/buildkit/update_build_path.sh ${tmp_target_dir}
    return 0
  fi;

  # it is a job folder
  if [[ -f ${tmp_target_dir}/alias_task.sh ]]; then
    if [[ ${job_path} != ${tmp_target_dir} ]]; then
      dumpinfo "switch job to ${tmp_target_dir}" | sed "s#${tmp_target_dir##*/}#${s_red}${tmp_target_dir##*/}#"
      switch_job_update_script "${tmp_target_dir}"
      source ${job_path}/alias_task.sh
      vscode_add_folder ${job_path}
      vscode_open_file ${job_path}/_note.txt
      local build_folder_info_file=${job_path}/logs/build_folder_info.txt
      if [[ -f ${build_folder_info_file} ]] ; then
        build_worktree_path=
        source ${build_folder_info_file}
        [[ -d ${build_worktree_path} && "${cur_build_dir}" != "${build_worktree_path}" ]] && {
          source ${BASH_DIR}/nvidia/build/buildkit/update_build_path.sh  ${build_worktree_path} pernent
        }
      else
        dumpinfo "no build folder info file :${build_folder_info_file}"
        cur_repo_dir=
        cur_build_dir=
      fi
    else
      dumpinfo "current job is already ${tmp_target_dir}"
      command ls --color=always -1 -Artd ${EXT_DIR}/myTasks/curTask/*
    fi
    return 0
  fi;
}

function load_job_folder() {
  local tmp_job_dir=${1:-$(pwd -L)}
  [[ ! -f "${tmp_job_dir}/alias_task.sh" ]] && { dumperr "not a directory : ${tmp_job_dir}" ; return ; }

  tmp_job_dir=$(realpathx ${tmp_job_dir} | update_symbol_path )
  if [[ ! -d "${job_path}" ]] || ! is_same_path "${tmp_job_dir}" "${job_path}" ; then
    # enable the new job path
    switch_job_update_script "${tmp_job_dir}"
  else
    dumpinfo "same job path : ${job_path} | ${tmp_job_dir}"
  fi

  source ${tmp_job_dir}/alias_task.sh
  show_cmd_in_job_folder
}

function load_build_foler(){
  local tmp_build_dir=${1:-$(pwd -L)}
  # is_same_path "${cur_build_dir}" "${tmp_build_dir}" && { return ; }
  [[ ! -f ${tmp_build_dir}/cmds/_1_cmake.sh ]] && { dumperr "not a build folder : ${tmp_build_dir}" ; return ; }

  tmp_repo_dir=$(get_repo_dir_from_build_dir ${tmp_build_dir})
  [[ -f  ${tmp_build_dir}/cur_job/alias_task.sh ]] && load_job_folder  $(realpath ${tmp_build_dir}/cur_job)
  # overwrite the cur_repo_dir and cur_build_dir in alias_task.sh
  export cur_repo_dir="${tmp_repo_dir}"
  export cur_build_dir="${tmp_build_dir}"
  dumpkey cur_repo_dir
  dumpkey cur_build_dir
}

function link_current_build_folder_with_job_folder(){
  [[ ! -f ./cmds/_1_cmake.sh ]] && { dumperr "current folder is not a build folder" ; return 1; }
  local tmp_job_dir=${1}  
  [[ ! -f  ${tmp_job_dir}/alias_task.sh ]] && {
    dumpkey tmp_job_dir
    dumperr "Not a job folder: ${tmp_job_dir}"
    return 2
  }
  [[ -L ./cur_job ]] && rm ./cur_job
  [[ -d ./cur_job ]] && rm -rf ./cur_job
  dumpcmd "ln -s ${tmp_job_dir} ./cur_job"
  ln -s ${tmp_job_dir} ./cur_job
  return 0
}

function job_backup_repo_file() {
    # tmp_repo_dir=${EXT_DIR}/repo/dkg_root/integrate_mono_kernel_store
    # local tmp_repo_dir=$(get_repo_dir_from_build_dir)
    local tmp_repo_dir=$(pwd -L)
    [[ -f ${tmp_cur_dir}/file_rel_path.txt ]] && {
      local tmp_backup_dir=${tmp_cur_dir} ; 
      local tmp_repo_dir=$1 ;
    } || {
      local tmp_backup_dir=$1 ;
      local tmp_repo_dir=${tmp_cur_dir} ; 
    }    
    local file_rel_path_file=${tmp_backup_dir}/file_rel_path.txt
    ! is_inside_git_repo ${tmp_repo_dir} && { dumperr "not a repo folder : ${tmp_repo_dir}" ; return ; }
    [[ ! -f ${file_rel_path_file} ]] && { dumperr "no file_rel_path.txt in ${tmp_backup_dir}" ; return ; }
    dumpinfo ${file_rel_path_file}
    
    # get all the changed files and save to file
    {
        (cd ${tmp_repo_dir} && git  diff --name-only ) | while read -r per_line; do
            echo ${per_line}
        done
    } >| ${file_rel_path_file}
    
    # backup all the changed files
    cat ${file_rel_path_file} | while read -r per_line; do
        echo cp ${tmp_repo_dir}/${per_line}     ${tmp_backup_dir}/
        cp ${tmp_repo_dir}/${per_line}     ${tmp_backup_dir}/
    done
}
alias jbak='job_backup_repo_file'

function job_restore_repo_file() {
    # restore all the changed files
    local tmp_cur_dir=$(pwd -L)
    [[  -f ${tmp_cur_dir}/file_rel_path.txt ]] && {
      local tmp_backup_dir=${tmp_cur_dir} ; 
      local tmp_repo_dir=$1 ;
    } || {
      local tmp_backup_dir=$1 ; 
      local tmp_repo_dir=${tmp_cur_dir} ; 
    }
    local file_rel_path_file=${tmp_backup_dir}/file_rel_path.txt
    ! is_inside_git_repo ${tmp_repo_dir} && { dumperr "not a repo folder : ${tmp_repo_dir}" ; return ; }
    [[ ! -f ${file_rel_path_file} ]] && { dumperr "no file_rel_path.txt in ${tmp_backup_dir}" ; return ; }
    dumpinfo ${file_rel_path_file}

    cat ${file_rel_path_file} | grep -v "file_rel_path.txt" | while read -r per_line; do
        echo cp ${tmp_backup_dir}/${per_line##*/}   ${tmp_repo_dir}/${per_line}
        cp ${tmp_backup_dir}/${per_line##*/}   ${tmp_repo_dir}/${per_line}
    done

    ( cd ${tmp_repo_dir} && st )
}
alias jres='job_restore_repo_file'

function reset_job_to_debug_dkg() {
  switch_job ${EXT_DIR}/myTasks/job_list/job_dkg_debug
  source ${BASH_DIR}/nvidia/build/buildkit/update_build_path.sh ${EXT_DIR}/build/debug_dkg  pernent
}

alias   jobhere='switch_job'
alias   lnjob='link_current_build_folder_with_job_folder'
alias   jobreset='reset_job_to_debug_dkg'
alias   bdhere='source ${BASH_DIR}/nvidia/build/buildkit/update_build_path.sh'
alias   bdherep='source ${BASH_DIR}/nvidia/build/buildkit/update_build_path.sh  $(pwd -L) pernent'

function newjob()  {
                    local tmp_job_name=$(toLower job_${1:-"temp_folder_name"})
                    local tmp_job_path=${EXT_DIR}/myTasks/job_list/${tmp_job_name}
                    [[ -d $tmp_job_path ]] && { dumperr "job folder already exists : $tmp_job_path" ; return ; }
                    cp -rf ${EXT_DIR}/myTasks/new_job_template  $tmp_job_path  ;  
                    ln -s $tmp_job_path  ${EXT_DIR}/myTasks/working/${tmp_job_name}  ;   
                    ln -s $tmp_job_path  ${EXT_DIR}/myTasks/curTask/${tmp_job_name}  ;
                    updateFile_insert_line_before_Nth_line ${EXT_DIR}/tmp/test/alias_temp.sh  6  "source ${tmp_job_path}/alias_task.sh"
                    switch_job_update_script "${tmp_job_path}"

                    local test_repo_dir="${EXT_DIR}/repo/dkg_root/dkg_${tmp_job_name/job_/}"
                    [[ ! -d ${test_repo_dir} ]] && test_repo_dir=""
                    updateFile_replace_string ${tmp_job_path}/alias_task.sh "cur_repo_dir=.*" "cur_repo_dir=${test_repo_dir}"
                    local test_build_dir="${EXT_DIR}/build/${tmp_job_name/job_/}"
                    [[ -d ${test_build_dir} ]] && test_build_dir=""
                    updateFile_replace_string ${tmp_job_path}/alias_task.sh "cur_build_dir=.*" "cur_build_dir=${test_build_dir}"
                    
                    echo "# cur_repo_dir=${cur_repo_dir}"     >> ${tmp_job_path}/_note.txt
                    echo "# cur_build_dir=${cur_build_dir}"   >> ${tmp_job_path}/_note.txt
                    dumpinfo "new job folder : $tmp_job_path"                    
                    command ls --color=always -1 -Artd $tmp_job_path/* | sort
                    vscode_add_folder ${tmp_job_path}
                    }
function newjobhere() {
                       # create a new job folder from current build folder
                       newjob "${@}"
                       if [[ -d ./cur_job ]] ; then
                         dumpinfox "move ./cur_job to job_path : ${job_path}"
                         rm -rf ${job_path}/*
                         mv ./cur_job/* ${job_path}/
                         rm -rf ./cur_job
                         ln -s ${job_path}  ./cur_job
                       fi

                       if [[ -d ./cmds ]] ; then
                         dumpinfox "move ./cmds to job_path : ${job_path}/build_cmds"
                         [[ -d ${job_path}/build_cmds ]] && rm -rf ${job_path}/build_cmds
                         local tmp_build_cmds_dir=${job_path}/build_cmds/$(basename $(pwd -L))
                         mkdir -p ${tmp_build_cmds_dir}
                         mv $(realpath ./cmds) ${tmp_build_cmds_dir}/
                         [[ -d ./cmds ]] && rm -rf ./cmds
   
                         dumpcmd "ln -s ${tmp_build_cmds_dir}/cmds  ./cmds"
                         ln -s ${tmp_build_cmds_dir}/cmds  ./cmds
                       fi
                    }
function rmjob()  {
                    [[ "$1" == "" ]] && { dumpinfo "empty job name"  ; return ; }
                    local tmp_job_name=job_${1#job_}
                    local tmp_job_path=${EXT_DIR}/myTasks/job_list/${tmp_job_name}
                    [[ ! -d ${tmp_job_path} ]] && { dumpinfo "job folder not found : ${tmp_job_path}" ; return ; }

                    dumpinfox "remove job folder : ${tmp_job_name}"
                    dumpinfo  "job path : ${tmp_job_path}"
                    rd ${tmp_job_path} ; 
                    [[ -d ${EXT_DIR}/myTasks/working/${tmp_job_name} ]] && /usr/bin/rm ${EXT_DIR}/myTasks/working/${tmp_job_name} ; 
                    [[ -d ${EXT_DIR}/myTasks/curTask/${tmp_job_name} ]] && /usr/bin/rm ${EXT_DIR}/myTasks/curTask/${tmp_job_name} ;
                    [[ -n $old_job_path ]] && switch_job_update_script "${old_job_path}"
                  }
# now job_path is available, e.g
# job_path='${EXT_DIR}/myTasks/job_list/job_cfk_11569_imma_cutlass_2x_port'

bash_script_o
