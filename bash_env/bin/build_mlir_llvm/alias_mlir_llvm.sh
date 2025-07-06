#!/bin/bash

bash_script_i

function search_phase_pass_transform_name() {
    local tmp_dir=${1:-$(pwd -L)}
    dumpinfo "search phase name"
    dumpcmd 'grep -sniHrP  "(?<=add_mlir_tool.)[^ ]+" --include=CMakeLists.txt --include=*.cmake --include=*.cmake.in'
    grep -sniHrP  "(?<=add_mlir_tool.)[^ ]+" --include=CMakeLists.txt --include=*.cmake --include=*.cmake.in ${tmp_dir} | grep -v "#" | grep --color=always -P "add_mlir_tool.\K[^ ]+"
    echo
    dumpinfo "search pass name"
    dumpcmd 'grep -sniHrP  -A 1 -P "(?<=PassPipelineRegistration.)[^>]+" --include=*.cpp --include=*.h'
    grep -sniHrP  -A 1 -P "(?<=PassPipelineRegistration.)[^>]+" --include=*.cpp --include=*.h ${tmp_dir} | grep -P '".*"' | sed -E "s/-([0-9]+)-/:\1 /" | sed -E "s/  \"([^\"]*)\"/\"${red_L}\1${s_end}\"/" 
    echo
    dumpinfo "search transform name"
    dumpcmd 'grep -sniHrP "^ *Transform\w+::Transform" --include=*.cpp --include=*.h'
    grep -sniHrP "^ *Transform\w+::Transform" --include=*.cpp --include=*.h ${tmp_dir} | grep --color=always -P "::\K\w+"
    echo
    dumpinfo "more search cmd:"
    dumpinfo "search mlir .td base class and user .cpp derived class map :"
    dumpinfo 'grep --color=always -sniHrP "class +\w+ *: *public +\w+" $(pwd -L)'
}

# generate_cpp_source_from_td_file ${EXT_DIR}/repo/dkg_root/dkg_debug_dkg/collective_ir/include/collective_ir/Dialect/Collective/IR/CollectiveDialect.td
function generate_cpp_source_from_td_file() {
    [[ $# -lt 1 ]] && { dumperr "Usage: generate_cpp_source_from_td_file <td_file>" ; return 1 ; }
    local td_file=$1
    [[ ! -f $td_file ]] && { dumpkey td_file ; dumperr "file not exist" ; return 1 ; }
    dumpinfo "generate_cpp_source_from_td_file : $td_file"
    local file_name=$(basename $td_file)
    local file_dir=$(dirname $td_file)
    local output_dir=${TEMP_DIR}/to_del/${file_name}
    [[ -d $output_dir ]] && rm -rf $output_dir
    mkdir -p $output_dir
    local output_file_prefix=${output_dir}/${file_name}
    cp $td_file ${output_dir}/

    # local INCLUDE_PATH="include/collective_ir"
    local INCLUDE_PATH="${LLVM_PATH}/include -I ${EXT_DIR}/repo/dkg_root/dkg_debug_dkg/cutlass_ir/compiler/include"
    dumpinfo "generate dialect decls : "
    dumpcmd "mlir-tblgen -gen-dialect-decls -dialect collective $1 -I $INCLUDE_PATH > ${output_file_prefix}.h.inc"
    mlir-tblgen -gen-dialect-decls -dialect collective $1 -I $INCLUDE_PATH > ${output_file_prefix}.h.inc
    echo
    dumpinfo "generate op defs : "
    dumpcmd "mlir-tblgen -gen-op-defs -dialect collective $1 -I $INCLUDE_PATH > ${output_file_prefix}.cpp.inc"
    mlir-tblgen -gen-op-defs -dialect collective $1 -I $INCLUDE_PATH > ${output_file_prefix}.cpp.inc
    echo
    dumpinfo "generate op impls :"
    dumpcmd "mlir-tblgen --gen-op-decls -dialect collective $1 -I $INCLUDE_PATH > ${output_file_prefix}.impl.inc"
    mlir-tblgen --gen-op-decls -dialect collective $1 -I $INCLUDE_PATH > ${output_file_prefix}.impl.inc
    echo
    dumpinfo "generate pass decls : "
    # dumpcmd "mlir-tblgen -gen-pass-decls -dialect collective $1 -I $INCLUDE_PATH > ${output_file_prefix}.pass.inc"
    # mlir-tblgen -gen-pass-decls -dialect collective $1 -I $INCLUDE_PATH > ${output_file_prefix}.pass.inc
    echo
    dumpinfo "generate pass impls : "
    # dumpcmd "mlir-tblgen --gen-pass-decls $1 -I $INCLUDE_PATH > ${output_file_prefix}.pass.impl.inc"
    # mlir-tblgen --gen-pass-decls $1 -I $INCLUDE_PATH > ${output_file_prefix}.pass.impl.inc

    echo
    lp ${output_dir}
}

function show_llvm_mlir_reference() {
    dumpinfox "example : ${EXT_DIR}/repo/linux_pratice/third_source/mlir-tutorial"
    dumpinfo "$LLVM_PATH/include/llvm"
    dumpinfo "$LLVM_PATH/include/mlir"
    dumpinfo "$LLVM_PATH/lib/cmake"
    dumpinfo "tree \$LLVM_PATH  -d -L 2"
    echo
    lp ${EXT_DIR}/repo/linux_pratice/llvm_mlir
    lp /home/scratch.xiaolongs_gpu/sync_with_windows/dl_note/_general/dkg
    dumpinfo "lp /home/scratch.xiaolongs_gpu/sync_with_windows/dl_note/_general/mlir"
}

# td_dir_list="${REPO_DIR_DKG} ${REPO_DIR_LLVM_SOLID} ${LLVM_PATH}"
td_dir_list="${REPO_DIR_DKG} ${LLVM_PATH}"
# td_dir_list="${LLVM_PATH}"
# find_Dialect_folder $(pwd -L)
function find_Dialect_folder() {
    fdf_dir=${1:-${td_dir_list}}
    md5_val=$(md5_string "${fdf_dir}")
    md5_dir_list=${TEMP_DIR}/cache/mlir_search/dir_${md5_val}.log
    dumpkey fdf_dir
    dumpkey md5_dir_list
    # bug : if use td_dir_list , it only search the first path
    [[ ! -f ${md5_dir_list} ]] && find ${fdf_dir} -type d \( -name "Dialect" -o -name "IR" \) ! -path '*/.svn/*' ! -path '*/.git/*' ! -path '*/.vscode/*' ! -path '*/.snapshot/*' ! -path '*/.cpan/*' | tee ${md5_dir_list}
    cat ${md5_dir_list}
}

# find_Dialect_td_file $(pwd -L)
function find_Dialect_td_file() {
    fdtf_dir=${1:-${td_dir_list}}
    md5_val=$(md5_string "${fdtf_dir}")
    md5_file_list=${TEMP_DIR}/cache/mlir_search/td_${md5_val}.log
    dumpkey md5_file_list
    if [[ ! -f ${md5_file_list} ]]; then
        find_Dialect_folder "${fdtf_dir}" | grep -vP "^ *#" | while IFS= read -r dir; do
            find "$dir" -type f -name "*.td"
        done | tee ${md5_file_list}
    fi
    cat ${md5_file_list}  
}

# find_Dialect_sub_folder $(pwd -L)
function find_Dialect_sub_folder() {
    [[ $# -lt 1 ]] && dumperr "Usage: find_Dialect_sub_folder <txt> [dir]" && return 1
    fdtf_dir=${2:-${td_dir_list}}
    md5_val=$(md5_string "$1+${fdtf_dir}")
    md5_folder_list=${TEMP_DIR}/cache/mlir_search/dialect_${md5_val}.log
    dumpkey md5_folder_list
    if [[ ! -f ${md5_folder_list} ]]; then
        find_Dialect_folder "${fdtf_dir}" | grep -vP "^ *#" | while IFS= read -r dir; do
            find "$dir" -type d -iname "*$1*"
        done | tee ${md5_folder_list}
    fi
    cat ${md5_folder_list} | grep --color=always "$1"
}

# find_Dialect_txt_in_td_file CuteCopyAtomTypeBase . 
function find_Dialect_txt_in_td_file() {
    [[ $# -lt 1 ]] && dumperr "Usage: find_Dialect_txt_in_td_file <txt> [dir]" && return 1
    fdtidf_dir=${2:-${td_dir_list}}
    md5_val=$(md5_string "$1+${fdtidf_dir}")
    md5_search_txt_list=${TEMP_DIR}/cache/mlir_search/txt_${md5_val}.log
    dumpkey md5_search_txt_list
    if [[ ! -f ${md5_search_txt_list} ]]; then
        find_Dialect_td_file "${fdtidf_dir}"  | grep -vP "^ *#" | while IFS= read -r file; do
            grep -HniP "$1" "$file"
        done | tee ${md5_search_txt_list}
    fi
    cat ${md5_search_txt_list} | sed 's#:#  #2' | grep --color=always "$1"
    dumppos
}

# find_Dialect_def_in_td_file CuteCopyAtomTypeBase
function find_Dialect_def_in_td_file() {
    fdditf_dir=${2:-${td_dir_list}}
    md5_val=$(md5_string "$1+${fdditf_dir}")
    md5_search_txt_list=${TEMP_DIR}/cache/mlir_search/txt_${md5_val}.log
    dumpkey md5_search_txt_list
    [[ ! -f ${md5_search_txt_list} ]] && find_Dialect_txt_in_td_file "$1" "${fdditf_dir}"  > /dev/null
    grep -iP --color=always ":(class|def) +$1" ${md5_search_txt_list} | sed 's#:#  #2'
    dumpinfox "add blank or < to explict match"
}

alias llvm='search_phase_pass_transform_name'
alias illvm=show_llvm_mlir_reference

alias fdtd=find_Dialect_folder
alias fdtdx=find_Dialect_sub_folder
alias fftd=find_Dialect_td_file
alias fttd=find_Dialect_txt_in_td_file
alias fdeftd=find_Dialect_def_in_td_file
alias lltd="ffa ${TEMP_DIR}/cache/mlir_search | sort"

bash_script_o
