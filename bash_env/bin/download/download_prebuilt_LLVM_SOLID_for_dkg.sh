#!/bin/bash

bash_script_i

# prebuild llvm-solid of nv dkg project : the version MUST be matched with the llvm-solid version used to build the DKG project
# egrep --color=always -m 1 -niH "LLVM_BUILD_COMMIT_HASH" ${EXT_DIR}/repo/dkg_root/dynamic-kernel-generator/cmake/IncludeLLVM.cmake
# ${EXT_DIR}/repo/dkg_root/dynamic-kernel-generator/cmake/IncludeLLVM.cmake:132:  set(LLVM_BUILD_COMMIT_HASH fc1827b) # the artifact is built on 23-Oct-2024
# search the the artifact with fc1827b
# get :  https://urm.nvidia.com/artifactory/sw-fastkernels-generic/dkg/llvm/artifacts/llvm+mlir-x86_64-linux-gcc_9.4.0-assert-fc1827b.tar.gz
# LLVM_PATH_PRE_ROOT=${EXT_DIR}/myDepency/prebuilt_LLVM_SOLID_for_dkg
# LLVM_PATH_PRE=${LLVM_PATH_PRE_ROOT}/assert_20241112

function get_matched_llvm_solid_version() {
    local llvm_solid_version=$(egrep --color=none -m 1 "LLVM_BUILD_COMMIT_HASH" ${REPO_DIR_DKG}/cmake/LLVMBuildCommit.cmake | grep -oP "(?<=LLVM_BUILD_COMMIT_HASH )[^) ]+" | tail -n 1)
    [[ -z $llvm_solid_version ]] && return 1
    echo ${llvm_solid_version}
    return 0
}

# ${EXT_DIR}/tmp/to_del/download/llvm+mlir-x86_64-linux-gcc_9/llvm+mlir-x86_64-linux-gcc_9.4.0-release-c79e178.tar.gz
function get_downloaded_newest_llvm_solid_version() {    
    local download_links_file=${LLVM_PATH_PRE}/../_download_links.txt
    [[ ! -f ${download_links_file} ]] && return 1
    local download_file_name="$(cat ${download_links_file} | tail -n 1 | grep  "${llvm_solid_version}")"
    [[ -z $download_file_name ]] && return 2
    local llvm_solid_version=$(echo ${download_file_name} | grep -oP "[^-]+(?=.tar.gz)")
    [[ -z ${llvm_solid_version} ]] && return 3
    echo ${llvm_solid_version}
    return 0
}

function verify_LLVM_SOLID() {
    required_llvm_solid_version=$(get_matched_llvm_solid_version)
    downloaded_llvm_solid_version=$(get_downloaded_newest_llvm_solid_version)
    [[ $# != 0 ]] && {
        dumpkey downloaded_llvm_solid_version
        dumpkey required_llvm_solid_version
        dumpkey LLVM_PATH_PRE_ROOT
        dumpkey LLVM_PATH_PRE
    }
    [[ -z ${required_llvm_solid_version} || -z ${downloaded_llvm_solid_version} || ${required_llvm_solid_version} != ${downloaded_llvm_solid_version} ]] && {
        dumpkey downloaded_llvm_solid_version
        dumpkey required_llvm_solid_version
        dumperr "The downloaded_llvm_solid_version is not matched with version required_llvm_solid_version ,run cmd ${brown}download_prebuilt_LLVM_SOLID_for_dkg${red} to update the llvm solid version."
        return 1
    }
    return 0
}

function download_prebuilt_LLVM_SOLID_for_dkg() {
    verify_LLVM_SOLID && { dumpinfox "LLVM_SOLID version matched to the llvm-solid path :${red} ${LLVM_PATH_PRE}" ; return 0  ; }
    
    echo
    dumpinfox "download artifacts.html"
    total_artifacts_src=${LLVM_PATH_PRE_ROOT}/artifacts.html
    source ${BASH_DIR}/bin/download/download.sh  "https://urm.nvidia.com/artifactory/sw-fastkernels-generic/dkg/llvm/artifacts" "${total_artifacts_src}"
    [[ ! -f  $total_artifacts_src ]] && { dumperr "Fails to download the artifacts" ; return 1 ; }
    # ${EXT_DIR}/myDepency/prebuilt_LLVM_SOLID_for_dkg/artifacts.html
    
    echo
    fetch_keyword="x86_64-linux-gcc_8.5.0-assert-${required_llvm_solid_version}"
    dumpinfox "fetch llvm-solid url by keyword :${red} ${fetch_keyword}"
    grep --color=always -niRH "${fetch_keyword}"  ${total_artifacts_src}
    href_path=$(grep --color=none -niRH "${fetch_keyword}"  ${total_artifacts_src} | grep -oP '(?<=href=")[^"]+' )
    if [[ -z $href_path ]] ; then
        dumpkey fetch_keyword
        dumpkey total_artifacts_src
        dumperr "Fails to find the href path."
    fi
    artifacts_url="https://urm.nvidia.com/artifactory/sw-fastkernels-generic/dkg/llvm/artifacts/${href_path}"
    source ${BASH_DIR}/bin/download/download.sh ${artifacts_url}    ${LLVM_PATH_PRE_ROOT}/
    # outputFolderPath is defined in ${BASH_DIR}/bin/unpack.sh
    [[ ! -d ${outputFolderPath} ]] && { dumperr "Fails to download ${artifacts_url}" ; return 1 ;  }
    
    echo
    dumpinfox "move dir to final path"
    local bin_folder=$(find ${outputFolderPath} -maxdepth 3 -type d -name "bin")
    NEW_LLVM_PATH_PRE=${LLVM_PATH_PRE_ROOT}/assert_$(get_matched_llvm_solid_version)_$(date "+%Y%m%d_%H%M")
    local OLD_LLVM_PATH_PRE=${LLVM_PATH_PRE}
    mv ${bin_folder%/*} ${NEW_LLVM_PATH_PRE}
    dumpkey NEW_LLVM_PATH_PRE | sed "s#assert_#${s_red}assert_#"
    dumpinfox "update the env path"
    OLD_LLVM_PATH_PRE_FOLDER=${OLD_LLVM_PATH_PRE##*/}
    NEW_OLD_LLVM_PATH_PRE_FOLDER=${NEW_LLVM_PATH_PRE##*/}
    dumpinfo "before update : $(grep --color=always -m 1 -niH 'LLVM_PATH_PRE=' ${BASH_DIR}/nvidia/init/init_env_path.sh | sed 's#:#  #2')"
    updateFile_replace_string ${BASH_DIR}/nvidia/init/init_env_path.sh "${OLD_LLVM_PATH_PRE_FOLDER}" "${NEW_OLD_LLVM_PATH_PRE_FOLDER}"
    dumpinfo "after update : $(grep --color=always -m 1 -niH 'LLVM_PATH_PRE=' ${BASH_DIR}/nvidia/init/init_env_path.sh | sed 's#:#  #2')"
    rd ${outputFolderPath}
    rd ${OLD_LLVM_PATH_PRE}
    if [[ -d ${LLVM_PATH_PRE_ROOT}/lastest/llvm ]] ; then
        rm ${LLVM_PATH_PRE_ROOT}/lastest/llvm
        ln -s ${NEW_LLVM_PATH_PRE} ${LLVM_PATH_PRE_ROOT}/lastest/llvm
    fi
}

bash_script_o
