bash_script_i
# cask6 : https://blossom.nvidia.com/hw-compute-cask-jenkins/job/cask/job/helpers/job/main/job/Merge_Request_Generic/job/build/27302/consoleText
# cask5 : https://blossom.nvidia.com/hw-compute-cask-jenkins/job/cask_sdk/job/helpers/job/dev/job/Nightly_Generic/job/build/24946/consoleText


# dl_url="https://prod.blsm.nvidia.com/hw-compute-cask-jenkins/blue/organizations/jenkins/cask%2Fhelpers%2Fmain%2FMerge_Request_Generic%2Ftest/detail/test/212891/tests"
# dl_url="https://prod.blsm.nvidia.com/hw-compute-cask-jenkins/job/cask/job/helpers/job/main/job/Merge_Request_Generic/job/test/212891/consoleText"

dl_url="$1"
out_file_path="$2"
# dumpkey dl_url
[[ -z $dl_url ]] && dumperr "Error: download url is empty" && return 1
dumpkeyx    dl_url
dumpkey     out_file_path

# from test web
# https://prod.blsm.nvidia.com/hw-compute-cask-jenkins/blue/organizations/jenkins/cask%2Fhelpers%2Fmain%2FMerge_Request_Generic%2Ftest/detail/test/212891/tests
# https://prod.blsm.nvidia.com/hw-compute-cask-jenkins/job/cask/job/helpers/job/main/job/Merge_Request_Generic/job/test/212891/consoleText
# https://prod.blsm.nvidia.com/hw-compute-cask-dkg/job/dkg/job/helpers/job/master/job/Merge_Request_Generic/job/build/292063/consoleText
# https://prod.blsm.nvidia.com/hw-compute-cask-dkg/job/dkg/job/helpers/job/master/job/Merge_Request_Generic/job/testSubPipeline/217553/consoleText 
if [[ $dl_url != *consoleText ]]; then
    number=$(echo $dl_url | grep -oP '(?<=test\/)\d+')
    if [[ -n $number ]]; then
        dl_url="https://prod.blsm.nvidia.com/hw-compute-cask-jenkins/job/cask/job/helpers/job/main/job/Merge_Request_Generic/job/test/${number}/consoleText"
    fi
    # dumpkey dl_url
fi

log_file_name=`echo ${out_file_path} | sed 's#.*/##g'`
log_out_dir=`echo ${out_file_path} | sed 's#\(.*\)/.*#\1#g'`
[[ "${log_file_name}" == "${log_out_dir}" ]] && log_out_dir=
debugkey log_file_name
debugkey log_out_dir

if [[ "${log_file_name}" == "" ]] ; then
    local repo_type=""
    # below style is not supported in bash, but it works well in tcsh
    # [ ${dl_url} =~ "/main/" ]          && repo_type=cask6
    if [[ ${dl_url} =~ "/main/" || ${dl_url} =~ "/cask/" || ${dl_url} =~ "/mono_cask/" ]]; then
        repo_type=cask6  
    elif [[ ${dl_url} =~ "/dkg/" ]]; then
        repo_type=dkg
    elif [[ ${dl_url} =~ "/cask_sdk/" ]]; then
        repo_type=cask5  
    elif [[ ${dl_url} =~ "/cutlass/" || ${dl_url} =~ "/mono_cutlass/" ]]; then
        repo_type=cutlass  
    else
      dumpinfox "can't find repo_type from url"
      dumpkey dl_url
      repo_type=unknown
    fi

    debugkey repo_type
    local log_type=""
    if [[ ${dl_url} =~ "/build/" ]]; then
        log_type=build  
    elif [[ ${dl_url} =~ "/testSubPipeline/" || ${dl_url} =~ "/test/" ]]; then
        log_type=test
    else
      dumpinfox "can't find log_type from url"
      dumpkey dl_url
      log_type=unknown
    fi

    # local pipeline_number=$(echo "$dl_url" | grep -oP "\d++(?=\/consoleText)")
    log_file_name=${repo_type}_${log_type}${pipeline_number:+_}${pipeline_number}_consoleText_$(date "+%Y%m%d_%H%M").txt
fi

if [[ "${log_out_dir}" == "" ]] ; then
    # ${EXT_DIR}/myReference/log_example/ci/cutlass_build_88911_consoleText.txt
    # ${EXT_DIR}/myReference/log_example/ci/_download_links.txt
    # log_out_dir=${EXT_DIR}/myReference/log_example/ci
    [[ -d "${job_path}" ]] && log_out_dir=${job_path}/logs || log_out_dir=${TEMP_DIR}/cache/ci_log_download
fi
[[ ! -d ${log_out_dir} ]] && mkdir -p ${log_out_dir}
out_file_path="${log_out_dir}/${log_file_name}"
dumpkeyx out_file_path

source ${BASH_DIR}/bin/download/download.sh  "${dl_url}" "${out_file_path}"
[[ -f $download_history ]] && echo "raw_url : $1 " >> ${download_history}

function backup_ci_log() {
    dumpinfo "backup_ci_log : $1"
    local ci_log_file=$1
    # out_file_path="${log_out_dir}/${log_file_name}"

    # backup in ${EXT_DIR}/myReference/log_example
    # buildSuffix=$(grep -oP -m 1 --color=none '(?<="buildSuffix":")[^"]+' ${ci_log_file} | xargs | sed 's# #_#g' )
    local buildSuffix=$(getbuildSuffixFromLogFile ${ci_log_file})
    dumpkey buildSuffix
    if [[ -n $buildSuffix && ${#buildSuffix} < 64 ]] ; then
        dumpinfo "backup to ${ci_log_dir}"
        ci_log_dir=${EXT_DIR}/myReference/log_example/${buildSuffix}
        [[ ! -d ${ci_log_dir} ]] && mkdir -p    ${ci_log_dir}
        cp -f $ci_log_file                      ${ci_log_dir}/${log_file_name}
        cat $download_history | tail -n 5   >>  ${ci_log_dir}/_download_links.txt
        out_file_path=${ci_log_dir}/${log_file_name}
        dumpinfo "${brown}${ci_log_dir}/${log_file_name}"
        writevar last_ci_log  "${ci_log_dir}/${log_file_name}" > /dev/null
    fi

    # backup in current build folder
    if [[ -d ./cmds/ && ! "$buildSuffix" =~ _vs ]] ; then
        dumpinfo "backup to $(pwd -L)/ci_logs/"
        [[ ! -d ./ci_logs ]] && mkdir -p   ./ci_logs
        cp -f $ci_log_file                      ./ci_logs/${log_file_name}
        cat $download_history | tail -n 5 >>    ./ci_logs/${download_history##*/}
        dumpinfo "${brown}$(pwd -L)/ci_logs/${log_file_name}"
    fi

    # backup in job folder
    tmp_job_path=${job_path}
    [[ -d "./cur_job/logs" ]]  && tmp_job_path="$(pwd -L)/cur_job"
    [[ -d "./cur_job/logs" ]]  && ! is_same_path ${job_path}/logs  "./cur_job/logs" && {  dumpkey job_path ; dumperr "job_path and ./cur_job is not matched foler, need to fix to avoid mistake." ; }
    if [[ -d ${tmp_job_path}/logs/ && ! "${log_out_dir}" == "${job_path}/logs" ]] ; then
        dumpinfo "backup to ${tmp_job_path}/logs/"
        cp -f $ci_log_file                      ${tmp_job_path}/logs/${log_file_name}
        cat $download_history | tail -n 5   >>  ${tmp_job_path}/logs/_download_links.txt
        [[ $log_type == "build" ]] && writevar job_build_log_file ${tmp_job_path}/logs/${log_file_name}  ${tmp_job_path}/bin/job_config.sh
        [[ $log_type == "test"  ]] && writevar job_test_log_file  ${tmp_job_path}/logs/${log_file_name}  ${tmp_job_path}/bin/job_config.sh
        dumpinfo "${brown}${tmp_job_path}/logs/${log_file_name}"
    fi

    if [[ -d "${tmp_job_path}" && ! "$buildSuffix" =~ _vs ]] ; then
        dumpinfo "update the ${tmp_job_path}/alias_task.sh"
        local job_task_file=${tmp_job_path}/alias_task.sh
        local insert_line=$(grep -nP "job_log=" ${job_task_file} | tail -n 1 | grep -oP "^[^:]+" )
        dumpinfo "update : ${job_task_file}:${insert_line}"
        updateFile_comment_out_whole_line  ${job_task_file}  "job_log="        
        updateFile_insert_line_after_Nth_line  ${job_task_file}  ${insert_line}  "job_log=${ci_log_file}"
    fi
}

[[ -f $out_file_path ]] && backup_ci_log $out_file_path && codeopen ${out_file_path}

bash_script_o