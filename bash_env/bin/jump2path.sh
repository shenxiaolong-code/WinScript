bash_script_i
dumppos

curFile=$1
lineNumber=$2

if [[ ! -f "${curFile}" ]] ; then
    dumpinfo "${red}[Error]${green} ${curFile} ${brown}not exist. ${green}callstack : ${red}"
    print_call_stack
    return
fi

# [[ ${disable_bash_script_io} != 1 ]]  && echo -e "# ${brown}test key bind cmd.${end}"
[[ ${disable_bash_script_io} != 1 ]]  && echo -e "# ${green}file position : ${end}${curFile}:${lineNumber}"
[[ ${disable_bash_script_io} != 1 ]]  && echo -e -n "# ${green}raw string    : ${end}"
target_line_string_raw=$(cat ${curFile} | sed -n "${lineNumber} p")
[[ ${disable_bash_script_io} != 1 ]]  && cat ${curFile} | sed -n "${lineNumber} p"
# dumpinfo "${target_line_string_raw}"

# pre-process web link
# https://gitlab-master.nvidia.com/dlarch-fastkernels/cutlass/-/blob/dev/python/cutlass_library/conv2d_operation.py#L147
# https://gitlab-master.nvidia.com/dlarch-fastkernels/cask/-/blob/main/frameworks/cutlass3x/include/adapters/gemm/cutlass3x_gemm_2x_shader.hpp#L176
if [[ ${target_line_string_raw} =~ "gitlab-master.nvidia.com" ]] ; then
    # repo_dir_path="${EXT_DIR}/repo/cask_root/repo_dir_path"
    repo_dir_path=$(get_worktree_path_current_always)
    # [[ ${target_line_string_raw} =~ "/cutlass/" ]] && local_repo=${cutlass_repo}    
    # [[ ${target_line_string_raw} =~ "/cask/"    ]] && local_repo=${REPO_DIR_CASK6}
    target_line_string_raw=$(echo ${target_line_string_raw} | sed "s#.*/-/blob/##" )
    target_line_string_raw=${repo_dir_path}/${target_line_string_raw#*/}
    target_line_string_raw=${target_line_string_raw/"#L"/":"}
    # [[ "${target_line_string_raw##*/}" == "repo_dir_path" ]] && target_line_string_raw=${target_line_string_raw}/refer_to_debug_worktree
fi

# [[ ${disable_bash_script_io} != 1 ]]  && echo ${target_line_string_raw} | sed 's/^ */#                 /'
[[ ${disable_bash_script_io} != 1 ]]  && echo "${target_line_string_raw}" | xargs | sed "s/^ */#${s_brown} ==>${s_end}             /"  
# target_line_string=`echo ${target_line_string_raw} | sed 's#"# #g' | sed "s#'# #g" | envsubst | sed 's#.*/home/#/home/#g' | sed "s# .*##g" | sed 's#).*##g' | sed 's#(#:#g' `
target_line_string=(`echo ${target_line_string_raw} | sed 's#"# #g' | sed "s#'# #g" | envsubst`)
echo "${target_line_string_raw}" | grep -oP "(\[)?\K[^ ']+/[^ :']+:*[0-9]*"  | grep -vP '[\[\]<>"|?*]' | sed "s/^/#${s_brown} ==>${s_end}             /"
# expand variables in target_line_string if variable exists
[[ $target_line_string_raw =~ \$[A-Za-z_{] ]] && echo "${target_line_string_raw}" | grep -oP "(\[)?\K[^ ']+/[^ :']+:*[0-9]*"  | grep -vP '[\[\]<>"|?*]' | sed 's/^/#${s_brown} ==>${s_end}             /' | envsubst
echo
# dumpkey target_line_string
# echo

# test regular expression
# echo "[2024-11-13T11:06:06.048Z] I (11:06:05) [src/bloom/detect.py:83] stdout: cutlass_ir/compiler/include/cutlass_ir/Utils/Arch/Sm100.h:33:  E6M9 = 3,"  | grep -oP "[^ ]+/[^ ]+" | grep -vE "${invalid_char_in_path}"
# echo "${target_line_string_raw}" | grep -oP "(\[)?\K[^ ']+/[^ :']+:*[0-9]*"  | grep -vP '[\[\]<>"|?*]'
# echo "${target_line_string_raw}" | grep -oP "(\[)?\K[^ ']+/[^ :']+:*[0-9]*"  | grep -vP '[\[\]<>"|?*]' | sed "s#^\([^/]\+\)#$(get_worktree_path_current_always)/\1#"
# return 

# #include "cutlass/conv/kernel/default_conv2d_fprop.h"
if [[ "${target_line_string[0]}" == "#include" ]] ; then    
    dumpinfox "process c++ include header file ... "
    include_file=$(echo ${target_line_string[1]} | sed 's#<##'  | sed 's#>##' )
    [[ ${disable_bash_script_io} != 1 ]]  && echo -e "#${s_brown} ==>             ${s_end}${include_file} ${end}\n"        
    # [[ $include_file != "cutlass/"* ]] && git_root=$(get_git_svn_file_root "${curFile}")
    # [[ $include_file == "cutlass/"* ]] && git_root=${cutlass_repo}
    # ${EXT_DIR}/build/fprop_wgrad_dgrad/build/generated/release/initialize_all_resources.cpp
    source ${BASH_DIR}/nvidia/init/alias_nv_project.sh
    [[ "${curFile}" =~ /generated/ ]] && git_root=$(get_git_svn_dir_root $(get_repo_dir_from_build_dir))
    [[ ! -d $git_root ]] && git_root=$(get_git_svn_file_root "${curFile}")
    # dumpkey git_root
    [[ -d "${git_root}" ]] && {
        dumpinfo "find${brown} ${include_file} ${blue}in repo root :${red} ${git_root}"
        # method 1
        # include_file_path=$(find "${git_root}" -name "${include_file##*/}"  | grep  "${include_file}")
        # method 2
        # find dir -path '*/mlir/IR/BuiltinTypes.h' -print -quit
        # dumpcmd "find ${git_root} -path  \"*/${include_file}\""
        # include_file_path=$(find "${git_root}" -path  "*/${include_file}")
        # method 3
        # ls ${git_root}/**/mlir/IR/BuiltinTypes.h
        dumpcmd "ls ${git_root}/**/${include_file}"
        include_file_path=$(ls ${git_root}/**/${include_file})
        dumpkey include_file_path
    }
    if [[ -f ${include_file_path} ]] ; then
        codeopen  "${include_file_path}:48"
    else
        [[ $(echo "$include_file_path" | wc -l) -gt 1 ]] && dumperr "result includes multiple files, vscode can't open multiple files directly"
        dumpkeyx2   curFile "${curFile}:${lineNumber}"
        dumpkey     git_root
        dumpkey     include_file
        dumpkey     include_file_path
    fi
    dumppos
    return
fi


if [[ "${target_line_string[@]}" =~ "at line" ]] ; then    
    dumpinfox "process compile error format ... "
    # dumpinfox "find keyword : at line"
    source ${BASH_DIR}/init/alias_and_function.sh
    build_log_line=( $(echo "${target_line_string[@]}" | sed 's@.*at line @@') )
    # ' cutlass3x/device/ ' => ' ${EXT_DIR}/build/emulated_utchmma_f32_bf16_kernel/build/generated/release/cutlass3x/device/'
    # dumpkeyx build_log_line[0]
    # dumpkeyx build_log_line[2]

    declare -A associative_array=()
    tmp_build_dir=`grep -m 1 "\-B/" ${curFile} | sed 's#.*-B##' | sed 's# .*##' | sed 's#/generated/.*##'`
    associative_array[".*cutlass3x/device/"]="${tmp_build_dir}/generated/release/cutlass3x/device/"
    associative_array[".*cutlass3x/device/"]="${tmp_build_dir}/generated/release/cutlass3x/device/"
    array_string=$(declare -p associative_array)
    file_target_path=$(map_batch_replace_in_string "${build_log_line[2]}" "$array_string")

    # dumpinfo "${file_target_path}"
    target_line_string=( "${file_target_path}:${build_log_line[0]}" )
fi

dumpinfox "general process ... "
dumpkey repo_dir_path
source ${BASH_DIR}/init/is_test_function.sh
# envScriptFile=${BASH_DIR}/nvidia/loadEnv/loadEnv_build_farm.sh
target_line_string=($(echo "${target_line_string_raw}" | grep -oP "(\[)?\K[^ ']+/[^ :']+:*[0-9]*|(?<=\[)[^ ]+\.[a-z]+:\d+(?=\])"  | grep -vP '[\[\]<>"|?*]'))
# echo "[2024-11-13T11:06:06.048Z] I (11:06:05) [src/bloom/detect.py:83] stdout: cutlass_ir/compiler/include/cutlass_ir/Utils/Arch/Sm100.h:33:  E6M9 = 3,"  | grep -oP "[^ ]+/[^ ]+" | grep -vE "${invalid_char_in_path}"
# =>
# src/bloom/detect.py:83
# cutlass_ir/compiler/include/cutlass_ir/Utils/Arch/Sm100.h:33
# echo "${target_line_string_raw}" | grep -oP "(\[)?\K[^ ']+/[^ :']+:*[0-9]*"  | grep -vP '[\[\]<>"|?*]' # | sed "s#^\([^/]\+\)#$(get_worktree_path_current_always)/\1#"
for target_path in ${target_line_string[@]}; do
    # [[ ${target_path} == "/home/"* ]] && echo -e "${green}local file : ${brown}${target_path}${end}"        
    target_path="`echo ${target_path} | envsubst | sed 's#.*/home/#/home/#' `"    
    # /home/epilogue.h:179     or  /home/epilogue.h(179)    
    noLine_path=$(echo ${target_path} | sed 's#:.*##g' | sed 's#(.*##g')
    [[ -z ${noLine_path} ]] &&  continue
    # [[ ! ( $noLine_path =~ "/home/" ) ]] && continue
    # find /home/user/projects -type f -path "*/dir1/dir2/dir3/ddd.h"
    # process :  src/bloom/detect.py:83
    # dumpkey target_path
    [[ ! -e ${noLine_path} && ! -e ${repo_dir_path}/${noLine_path} ]] && noLine_path="$(find ${repo_dir_path} -type f -path "*/${noLine_path}" | head -n 1)"
    [[ ! -e ${noLine_path} ]] && dumpinfo find ${repo_dir_path} -type f -path "*/${noLine_path}"
    [[ ! -e ${noLine_path} ]] && { dumpinfo "skip missing file : ${red} ${target_path}" ; }  &&  continue
    is_binary_file ${noLine_path} && { dumpinfo "skip binary file :${red} ${target_path}" ; }  &&  continue
    # dumpkeyx target_file
    if [[ -f "${noLine_path}" ]] ; then
        # dumpinfox "available file : ${target_file}"
        if [[ "${noLine_path}" == "${curFile}" ]] ; then
            echo -e "# ${green}current file ${brown}${target_file} ${green} is already opened on `hostname` ${end} "
        else
            noLine_path=$(realpathx ${noLine_path})
            line_number=$(echo ${target_path} | grep -oP "(?<=[:\(\s])\d+")
            std_file_line_number_path="${noLine_path}${line_number:+":"}${line_number}"
            codeopen "${std_file_line_number_path}"              
        fi
    elif [[ -d "${noLine_path}" && "${noLine_path}" != "//" ]] ; then
        # dumpinfox "available dir : ${target_path}"
        # cd -
        echo -e "${green}cd ${noLine_path}${end}"
        # echo -e "'${target_path}'"
        # echo -e "1 : $(pwd -L)"
        cd ${noLine_path}
        /bin/ls --color=auto -1 -ArtdF ${noLine_path}/* | grep -v -m 1 '/$'
        # echo -e "2 : $(pwd -L)"
    else
        # dumpinfox "not available : '${target_file}'"
        # dumppos
        dumpkeyx target_path
    fi
done

bash_script_o
