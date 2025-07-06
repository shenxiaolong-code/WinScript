bash_script_i

# ------------------------------------------- config -------------------------------------------------------------------
# https://urm.nvidia.com/artifactory/sw-fastkernels-generic/cicd/kernel_store_cask/main/Nightly_Generic/66/cask_x86_64_linux_agnostic_cudagpgpu_internal_mini_release_gcc7.5.0_sm100_f7abaf39.tar.gz
function load_config_cask6() {
    # only suit for cask6
    # https://urm.nvidia.com/artifactory/sw-fastkernels-generic/cicd/kernel_store_cask/main/Nightly_Generic/66/
    url_all_cask6="https://urm.nvidia.com/artifactory/sw-fastkernels-generic/cicd/kernel_store_cask/main/Nightly_Generic/"
    run_on_amodel=1                     # amodel or silicon
    if [[ "${run_on_amodel}" == "1" ]] ; then
        # https://urm.nvidia.com/artifactory/sw-fastkernels-generic/cicd/kernel_store_cask/main/Nightly_Generic/67/cask_x86_64_linux_agnostic_cudagpgpu_internal_mini_release_gcc7.5.0_sm100_c8ee2e7b.tar.gz
        # cask_x86_64_linux_agnostic_cudagpgpu_internal_mini_release_gcc7.5.0_sm100_f7abaf39.tar.gz
        # bin_version="cask_x86_64_linux_agnostic_cudagpgpu_internal_mini_debug_gcc7.5.0_debug_sm100"
        bin_version="cask_x86_64_linux_agnostic_cudagpgpu_internal_mini_release_gcc.*sm100"        
        bin_folder_name="100"
    else
        # cask_x86_64_linux_agnostic_cuda12.0_internal_mini_release_premerge_a1a3b10ebc21131ddc040a66b83f24e6f7d4fc39.tar.gz
        bin_version="cask_x86_64_linux_agnostic_cuda12.0_internal_mini_release_premerge"
        bin_folder_name="90"
    fi

#   outdatecvpsh 
#   https://urm.nvidia.com/artifactory/sw-fastkernels-generic-local/cicd/cask/main/Nightly_Generic/413/
#   cask_x86_64_linux_agnostic_cudagpgpu_internal_mini_release_nightly_sm100_101_34b5a906.tar.gz
#   cask_x86_64_linux_agnostic_cuda12.2_internal_mini_release_nightly_sm80_86_89_90_da80afa8a586400fd085f2a75455f5045deb359d.tar.gz
    bin_folder="${EXT_DIR}/dbg_investigate/nightly_builds/6/${bin_folder_name}"
    url_all="${url_all_cask6}"
}

function load_config_cask5() {
    # cask5
    # https://urm.nvidia.com/artifactory/sw-fastkernels-generic-local/cicd/cask_sdk/dev/Nightly_Generic/1386/
    url_all_cask5="https://urm.nvidia.com/artifactory/sw-fastkernels-generic-local/cicd/cask_sdk/dev/Nightly_Generic/"

#   cask_sdk_x86_64_linux_agnostic_cuda12.2_internal_mini_release_mercury2sass_sm90_6cd9d8a3078e1a8ba96132ecae91a0ff52902120.tar.gz
    bin_version="x86_64_linux_.*cuda12.2.*90_"
    bin_folder_name="90"
    bin_folder="${EXT_DIR}/dbg_investigate/nightly_builds/5/${bin_folder_name}"
    url_all="${url_all_cask5}"
}

function load_config(){
    load_config_cask6
    [[ -d "${bin_folder}" ]] && source ${BASH_DIR}/bin/del_big_folder_async.sh "${bin_folder}"
    # download_folder="${bin_folder}/download_${build_index}_$(date "+%Y%m%d_%H%M")"
    download_folder="${bin_folder}/download"
    [[ ! -d "${download_folder}" ]]  && mkdir -p "${download_folder}"
}

# ------------------------------------------- implement -------------------------------------------------------------------
function fetch_build_index_auto() {
    # https://urm.nvidia.com/artifactory/sw-fastkernels-generic/cicd/kernel_store_cask/main/Nightly_Generic/67/
    # get the build_index  67

    url_all_html="${download_folder}/entry_all.html"
    # the newest build might be in building process ... so we need to fetch the second newest build
    reversed_build_index=${1:-2}
    
    if is_invalid_url "${url_all}" ; then
        dumperr "[${red}error${end}] ${green}url_all is invalid : ${brown}${url_all} ${end}."
        dumpkey url_all
        return 2
    fi
    source ${BASH_DIR}/bin/download/download.sh  "${url_all}"  "${url_all_html}"
    if [[ ! -f "${url_all_html}" ]] ; then
        dumperr "${green}Fails to fetch ${brown}${url_all_html} ${end}."
        dumpcmdline
        dumpkey url_all
        dumpkey url_all_html
        return 3
    fi

    build_index=`cat "${url_all_html}" | grep "    -" | sed 's#/</a>##g' | sed 's#.*>##g' | sort -n | tail -n ${reversed_build_index} | head -n 1 | cut -d' ' -f 1`
    if [[ "${build_index}" == "" ]] ; then
        dumperr "${green}Fails to parse build_index from ${brown}${url_all_html} ${end}."
        dumpinfo " reversed_build_index : ${reversed_build_index} "
        return 4
    else
        return 0    
    fi
}

function get_package_url() {
    # get below url
    # https://urm.nvidia.com/artifactory/sw-fastkernels-generic/cicd/kernel_store_cask/main/Nightly_Generic/67/cask_x86_64_linux_agnostic_cudagpgpu_internal_mini_release_gcc7.5.0_sm100_c8ee2e7b.tar.gz
    
    url_build_index="${url_all}${build_index}/"
    if is_invalid_url "${url_build_index}" ; then
        test_url "${url_build_index}"
        dumpinfo "[${red}error${end}] ${green}$1 is invalid : ${brown}${url_build_index} ${end}."
        return 5
    fi    

    bin_html="${download_folder_index}/entry_single.html"
    source ${BASH_DIR}/bin/download/download.sh  "${url_build_index}"  "${bin_html}"
    # cat ${bin_html} | egrep "${bin_version}"
    cask_package_name=`cat ${bin_html} | egrep "${bin_version}" | egrep -v "_mods_|_random_delay_" | head -n 1 | cut -d'"' -f 2`    

    if [[ "${cask_package_name}" == "" ]] ; then
        dumperr "fails to fetch cask_package_name '${green} ${bin_version} ${purple}' from${brown} ${bin_html} "
        dumpinfo "cat ${bin_html} | egrep '${bin_version}' | egrep -v '_mods_|_random_delay_'"
        dumpkey url_all
        dumpkey url_build_index
        dumpkey bin_version
        return 6
    fi
    package_url="${url_build_index}${cask_package_name}"
    # dumpkeyx url_build_index
    is_valid_url "${package_url}" && return 0 || return 6
}

function update_find_kernel_setting(){
    echo "${red}update ${green}${EXT_DIR}/dbg_investigate/nightly_builds/set_last_download_dir.sh ${end}"
    (
        echo "# $(date +"%Y/%m/%d %T")"
        echo "# generated by ${BASH_SOURCE[0]}:$LINENO"
        echo "# ${download_folder_index}"
        echo "# ${package_url}"

        echo " "
        echo "download_folder=${download_folder}"
        echo "last_download_dir=${bin_folder}"

    ) >| ${EXT_DIR}/dbg_investigate/nightly_builds/set_last_download_dir.sh
    # write_variable  last_download_dir "${bin_folder}"  ${EXT_DIR}/dbg_investigate/nightly_builds/set_last_download_dir.sh
}

function dump_download_bin_info(){
    dumpinfox "package_url           : ${package_url}"
    dumpinfo "download_folder_index : ${download_folder_index}"
    dumpinfo "url_all_html          : ${url_all_html}"
    dumpinfo "bin_html              : ${bin_html}"
    dumpinfo "download_history      : ${download_history}"
}

function main() {
    load_config
    is_number "$1" && build_index=$1 || fetch_build_index_auto  2 || return 5    
    download_folder_index="${download_folder}/${build_index}"
    [[ ! -d "${download_folder_index}" ]]  && mkdir -p "${download_folder_index}"

    if ! get_package_url $@ ; then
        dumperr "${green}Fails to get package_url from ${brown}${package_url} ${end}"
        dumpkey url_all
        dumpkey build_index
        find -L ${out_dir}/ -maxdepth 1 -type f -print | sort -n

        return 6
    fi
    
    dump_download_bin_info

    cd ${download_folder_index}
    source ${BASH_DIR}/bin/download/download.sh  "${package_url}"  "${download_folder_index}/"
    cd -

    # https://urm.nvidia.com/artifactory/sw-fastkernels-generic/cicd/kernel_store_cask/main/Nightly_Generic/239/testResults/cask_x86_64_linux_agnostic_cudagpgpu_internal_mini_release_nightly_mods_sm100_481b9b3c_SM100_tests_220_L0_functional_2.tgz
    # test_result_package="${url_build_index}/testResults/cask_x86_64_linux_agnostic_cudagpgpu_internal_mini_release_nightly_mods_sm100_481b9b3c_SM100_tests_220_L0_functional_2.tgz"
    # source ${BASH_DIR}/bin/download/download.sh  "${test_result_package}"  "${download_folder_index}/testResults/"

    echo
    # egrep -niRH --color=auto  "t[56]n" ${BASH_DIR}/nvidia/*

    update_find_kernel_setting

    dumpinfox "bin folder : ${bin_folder}"
    dump_download_bin_info
    dumpinfo "out_file_path         : ${out_file_path}"
    dumpinfo "outputFolderPath      : ${outputFolderPath}"
}

main "$@"

bash_script_o