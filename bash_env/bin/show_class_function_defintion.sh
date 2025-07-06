bash_script_i
# dumpcmdline
tmp_cmd=$1
tmp_file_path=$2
tmp_selected_text=$3

tmp_cur_dir=$(pwd -L)

[[ $tmp_file_path =~ "/_deps/cutlass3x-src/" ]] && tmp_file_path=$(echo ${tmp_file_path} | sed "s#.*/_deps/cutlass3x-src/#${cutlass_repo}/#")

if [[ -z $tmp_selected_text ]] ; then
    dumpcmdline
    dumperr "No selected text"
    return 1
fi

if [[ "${tmp_cmd}" == "listDefInCurFile" ]] ; then
    [[ ${disable_bash_script_io} != 1 ]] && dumppos
    list_all_function_defintion_x  "${tmp_file_path}"    
    list_cpp_all_class_defintion_x "${tmp_file_path}"
else
    source ${BASH_DIR}/nvidia/init/alias_nv_project.sh
    tmp_repo_dir=$(get_git_svn_file_root "${tmp_file_path}")
    [[ "${tmp_repo_dir}" == "" && -f "./cmds/_1_cmake.sh"  ]]     && tmp_repo_dir=$(get_repo_dir_from_build_dir)
    if [[ "${tmp_repo_dir}" == "" && $tmp_file_path == */build/*   ]] ; then
        tmp_build_dir=${tmp_file_path%/build/*}
        tmp_repo_dir="$( get_repo_dir_from_build_dir ${tmp_build_dir}/cmds/_1_cmake.sh )"
    fi
    # dumpkeyx tmp_repo_dir
    default_repo=${tmp_repo_dir}
    # [[ -d "${tmp_repo_dir}" ]] && repo_type=$(get_nvidia_repo_type "${tmp_repo_dir}")
    [[ -d "${tmp_repo_dir}/cutlass" ]] && cutlass_repo=${tmp_repo_dir}/cutlass
    [[ -d "${tmp_repo_dir}/cask" ]] && cask6_repo=${tmp_repo_dir}/cask
    
    search_root_dir=""
    tmp_file_dir=${tmp_file_path%/*}

    if [[ ${search_root_dir} == "" && ${lineNumber} != "" ]] ; then
        # cat ${tmp_file_path} | sed -n "${lineNumber} p"
        text_line=($(cat ${tmp_file_path} | sed -n "${lineNumber} p"))
        # dumpinfo "${text_line[@]}"
        selected_text_statement=""
        for cur in ${text_line[@]}; do
            [[ $cur =~ $tmp_selected_text ]] && selected_text_statement=$cur
        done
        # dumpkey selected_text_statement
        [[ $selected_text_statement =~ "cutlass::" ]] && search_root_dir=$cutlass_repo
        [[ $selected_text_statement =~ "(cask6|cutlass3x|CASK_ENHANCED_NAMESPACE)::" ]] && search_root_dir=$cask6_repo
        [[ ${tmp_file_path} =~ "/cutlass/" ]] && search_root_dir=$cutlass_repo
        [[ "${search_root_dir}" == "" ]] && search_root_dir=${default_repo}
        [[ ${disable_bash_script_io} != 1 ]] && dumppos
        # dumpkeyx search_root_dir
        [[ ${disable_bash_script_io} != 1 ]] && dumppos
    fi

    if [[ ${search_root_dir} == "" && -f "${tmp_file_dir}/_1_cmake.sh" ]] ; then
        # it is build/cmds/ folder, instead of expected repo folder
        # search_root_dir=`cat ${tmp_file_dir}/_1_cmake.sh | grep "/home/" | grep -v "#" | grep -v "=" | sed 's# .*##'`
        tmp_build_dir=${tmp_file_dir%/*}
        search_root_dir="${tmp_build_dir}/_deps/cutlass3x-src  ${tmp_build_dir}/tools/jit/public  ${tmp_build_dir}/cutlass3x/device"
        [[ ${disable_bash_script_io} != 1 ]] && dumppos
    fi

    if [[ ${search_root_dir} == "" && ! -d "${tmp_file_dir}/.git" ]] ; then
        # git -C only supported in git 1.8.5
        # else : Unknown option: -C
        search_root_dir=$(get_git_svn_file_root "${tmp_file_dir}" )
    fi

    [[ ${search_root_dir} == "" ]] && search_root_dir=${tmp_file_dir}    
    [[ "${tmp_cmd}" == "showFuncDef" ]]     &&  find_cpp_function_defintion   "${tmp_selected_text}"  "${search_root_dir}"
    # showClass
    [[ "${tmp_cmd}" == "showClassDef"  ]]   &&  find_defintion  "${tmp_selected_text}"  "${search_root_dir}"
fi

#echo -e "\n${green}ctrl+d :${brown} showClassDef   ;${green} ctrl+shift+d :${brown} showFuncDef    ;${green}  alt+shift+d   :${brown} listDefInCurFile ${end}"


echo
bash_script_o
