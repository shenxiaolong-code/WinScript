#!/bin/bash

bash_script_i
source ${BASH_DIR}/app/cmake/alias_cpp_std_path.sh

export CMAKE_EXPORT_COMPILE_COMMANDS=1        # see  ${BASH_DIR}/app/vscode/config/clang/vscode_install_extenstion_clang.sh

# cmake --help-variable-list
# https://nvidia.slack.com/archives/C0752R5M7C7/p1733982922925069?thread_ts=1733888253.367819&cid=C0752R5M7C7
export cmake_debug="--trace-expand --debug-output -DCMAKE_VERBOSE_MAKEFILE=ON "
# stdbuf -oL cmake ...  2>&1 |&  tee log.txt
alias  sync_cmd_output='stdbuf -oL '
alias gcmake='cd ${EXT_DIR}/repo/linux_pratice/mini_mpl/cmake/usage_example ; ll ;'

function show_cmake_reference() {
    dumpinfo "${BASH_DIR}/app/cmake/alias_cmake_build.sh"
    dumpinfo 'find include system cmake file example : find /usr/share/cmake* -name "FetchContent.cmake"'
    # find /usr/share/cmake* -name "FetchContent.cmake" | xargs cat | grep -A 20 "function(FetchContent_Declare"
    search_cmake_options_help
    echo
    dumpinfo "${EXT_DIR}/repo/linux_pratice/mini_mpl/cmake/doc/cmake_builtin_variables.txt"    
    dumpinfo "${EXT_DIR}/repo/linux_pratice/mini_mpl/cmake/usage_example/cmake_usage_example.cmake"
    dumpinfo "${EXT_DIR}/repo/linux_pratice/mini_mpl/cmake/usage_example/test_non_scriptable_cmds/demo_FetchContent_Declare.cmake"
    dumpinfo "${EXT_DIR}/repo/linux_pratice/linuxRepo/llvm_mlir/demo_dialect/doc/llvm_mlir/llvm_mlir_builtin_keyword_func.txt"
    dumpinfo "${EXT_DIR}/repo/linux_pratice/mini_mpl/cmake/doc/cmake_debug_tips.txt"
    dumpinfo "https://cmake.org/cmake/help/latest/manual/cmake-variables.7.html"
}

# run_cmake_file_direct ${EXT_DIR}/repo/linux_pratice/mini_mpl/cmake/usage_example/cmake_usage_example.cmake  verbose
# run_cmake_file_direct ${EXT_DIR}/repo/linux_pratice/mini_mpl/cmake/usage_example/fetch_git_folder_version.cmake
# run_cmake_file_direct ${EXT_DIR}/repo/linux_pratice/mini_mpl/cmake/usage_example/read_json_file.cmake
# source ${EXT_DIR}/repo/linux_pratice/mini_mpl/cmake/unit_test/tc_test.sh
# test a cmake file without build whole project system.  e.g. test cmake utility file
# ${EXT_DIR}/repo/linux_pratice/mini_mpl/cmake/doc/cmake_debug_tips.txt
function run_cmake_file_direct() {
    echo
    local cmake_file=${1:-"${EXT_DIR}/repo/linux_pratice/mini_mpl/cmake/usage_example/cmake_usage_example.cmake"}
    [[ ! -f "${cmake_file}" ]] && { dumperr "cmake file not exist : ${cmake_file}" ; return 1 ; }
    dumpinfo  run_cmake_file_direct "$@"
    local tmp_pwd_dir=$(pwd -L)
    cd $(dirname "$cmake_file")
    
    # only print trace info
    # local verbose_opt=${2:+"--trace"}         
    # print trace info | expand variable value | call stack if need | compile & link & run command
    local verbose_opt=${2:+"--trace-expand --debug-output -DCMAKE_VERBOSE_MAKEFILE=ON"}
    dumpcmd "cmake -P "${cmake_file}" ${verbose_opt}"
    cmake -P "${cmake_file}" ${verbose_opt}
    donecmd

    cd "${tmp_pwd_dir}"
    dumpinfo "for non-scriptable cmake file, please run : ${red} utcmake2 ${blue}or${red} utcmake3 ${end}"
}
alias colorcmake='run_cmake_file_direct ${EXT_DIR}/repo/linux_pratice/mini_mpl/cmake/usage_example/cmake_color_message.cmake'
# makex ${EXT_DIR}/repo/linux_pratice/mini_mpl/cmake/common.cmake
function cpcmake()  { cp_file_template $1 ${EXT_DIR}/repo/linux_pratice/mini_mpl/cmake/_template.cmake     ; }

# cmake_debugger  ${EXT_DIR}/repo/cask6_root/reduce_per_shader_host_code_size_CFK_19164/cask/tools/releases/CMakeLists.txt
function cmake_debugger() {
    local cmake_file="$1"
    local tmp_build_dir="./build"
    [[ ! -f "${cmake_file}" ]] && dumperr "cmake file not exist : ${cmake_file}" && return 1
    [[ ! -d "${tmp_build_dir}"  ]] && dumperr "build dir not exist : ${tmp_build_dir}" && return 2

    # load cmake debugger
    # MUST CMake 3.27 and later

    # cmake --version | grep -oP "\d+\.\d+\.\d+"
    local cmake_ver=$(cmake --version | grep -oP "\d+\.\d+" | sed 's#\.##')
    if [[ $cmake_ver -lt 327 ]]; then
        dumperr "cmake version is too low : ${cmake_ver}" 
        return 3
    else
        dumpinfo "cmake version is ok : $(cmake --version | grep -oP "\d+\.\d+\.\d+")"
    fi

    cmake -S "$(dirname "$cmake_file")" -B "$tmp_build_dir" --debugger
}

function search_cmake_options_help() {
    [[ -z $1 || -z $2 ]] && {
        dumpinfo "usage : ${red} ftcmakeopt [search_pattern] [search_repo]  ${green}# e.g."
        dumpinfo "${purple} ftcmakeopt 'MLIR_|DKG_|LLVM_|CUDA_' "
        dumpinfo "${purple} ftcmakeopt 'CASK_|CUDA_' "
        dumpinfo "${purple} ftcmakeopt 'CUTLASS_|CUDA_' "
        dumpcmd  "${brown} ftcmake 'execute_process|add_library' "
    }
    # search_pattern="${1:-"MLIR_|LLVM_"}"
    local search_pattern="${1:-"CMAKE_|BUILD_|ENABLE_|DISABLE_"}"
    search_pattern=$(toUpper "${search_pattern}")
    local search_repo="${2:-$(pwd -L)}"
    [[ -z $1 ]] && dumpinfo "cmake search option is empty, using default pattern :${cyan} ${search_pattern}"
    [[ -z $2 ]] && dumpinfo "search repo is empty, using default repo       :${cyan} ${search_repo}"
}

function search_cmake_options() {
    # dumpinfox "${EXT_DIR}/repo/linux_pratice/cmake_build/doc/search_cmake_options_tips.txt"
    # dumpinfo "https://cmake.org/cmake/help/latest/manual/cmake-variables.7.html"

    search_cmake_options_help "$@"
    [[ ! -d "${search_repo}" ]] && dumperr "search repo not exist : ${search_repo}"
    echo

    dumpinfox "search cmake options :${brown} ${search_pattern} ${green}in${red} ${search_repo} ${end}"
    dumpcmd "grep -nirHP  -r '(set|get_filename_component).*(${search_pattern})' --include='*.cmake' --include='CMakeLists.txt' ${search_repo}"
    # grep -nirHP  -r "(set|get_filename_component).*(${search_pattern})" --include="*.cmake" --include="CMakeLists.txt" ${search_repo} | grep --color=always -P -i "${search_pattern}"
    grep -nirHP  -r "(set|get_filename_component).*(${search_pattern})" --include="*.cmake" --include="CMakeLists.txt" ${search_repo} | sed -E "s#(${search_pattern} )#${s_red_L}\1${s_end} #Ig" | sed -E "s#(${search_pattern})\}#${s_green_256}\1${s_end}}#Ig"
    # dumpinfo "Done search cmake options :${brown} ${search_pattern} ${green}in${red} ${search_repo} ${end}"
    
    echo
    dumpinfox "list all cmake options and help on specific cmake option"
    dumpinfo "cmake --help-variable-list "
    dumpinfo "cmake --help-variable VARIABLE_NAME "
    # search_cmake_options_help "$@"
}

function find_text_in_cmake_files()  {  
                       [[ -z $1 ]] && { dumperr "cmake search text is empty" ; return 1 ; }
                       find_text_in_xxx_file "$1" 'CMakeLists.txt|*.cmake|*.cmake.in'  "${2:-$(pwd -L)}"  ;
                    }
function find_text_in_cmake_files_help()  {  
                       find_text_in_cmake_files "$1" "${EXT_DIR}/repo/linux_pratice/mini_mpl/cmake"  ;
                    }

function find_cmake_files()  {
                       [[ -n $1 ]] && local tmp_file_pattern="$1*.cmake" || local tmp_file_pattern="CMakeLists.txt|*.cmake|*.cmake.in"
                       find_file_in_dir "${tmp_file_pattern}" "${2:-$(pwd -L)}"  ;
                    }
function find_cmake_files_help()  {
                       find_cmake_files "$1" "${EXT_DIR}/repo/linux_pratice/mini_mpl/cmake"  ;
                    }

function find_cmds_in_cmake_files()  {  
                       find_text_in_xxx_file "execute_process"  "CMakeLists.txt|.cmake"  "${1:-$(pwd -L)}" ; 
                    }

# conflict with llvm tool ${EXT_DIR}/myDepency/llvm_mlir_for_dkg/assert_20241023/bin/opt
# list all cmake options and help on specific cmake option
# cmake --help-variable-list 
# cmake --help-variable VARIABLE_NAME
alias   hcmake=show_cmake_reference
alias   icmake=show_cmake_reference
alias   cdcmake='cd ${EXT_DIR}/repo/linux_pratice/mini_mpl/cmake ; hcmake ;'

alias   ftcmake=find_text_in_cmake_files
alias   ftcmakeh=find_text_in_cmake_files_help
alias   ffcmake=find_cmake_files
alias   ffcmakeh=find_cmake_files_help
alias   ftcmakecmd=find_cmds_in_cmake_files
alias   ftcmakeopt=search_cmake_options

alias   utcmake=run_cmake_file_direct
alias   utcmake2='source ${EXT_DIR}/repo/linux_pratice/mini_mpl/cmake/usage_example/test_non_scriptable_cmds/run_single_test.sh'
alias   utcmake3='source ${EXT_DIR}/repo/linux_pratice/mini_mpl/cmake/usage_example/test_non_scriptable_cmds/run_test.sh'
alias   utcmakea='source ${EXT_DIR}/repo/linux_pratice/mini_mpl/cmake/unit_test/tc_cmake_all.sh'
alias   makex=run_cmake_file_direct
alias   target='source ${BASH_DIR}/app/cmake/show_make_targes.sh'
alias   targets='source ${BASH_DIR}/app/cmake/show_makefile_all_bin_targets.sh'

function search_cmake_options_in_nv_repo()  {   search_cmake_options    "$2"    "$1" ;  }
alias opt7='search_cmake_options_in_nv_repo ${REPO_DIR_DKG}'
alias opt6='search_cmake_options_in_nv_repo ${REPO_DIR_CASK6}'
alias optcu='search_cmake_options_in_nv_repo ${REPO_DIR_CUTLASS}'

bash_script_o
