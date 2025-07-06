#!/bin/bash

bash_script_i
curFile=$1
[[ ! -r "${curFile}" ]] && dumperr "file '${curFile}' not exists." && return 1
[[ "${curFile}" == "${BASH_SOURCE[0]}"  ]] && return 1

tmp_file_name=$(basename "${curFile}")
tmp_file_ext_name="${tmp_file_name##*.}"

# dumpkey tmp_file_name
# dumpkey tmp_file_ext_name

function main_show_file_info()
{   
    if [[ $tmp_file_ext_name == "cpp" || $tmp_file_ext_name == "hpp" || $tmp_file_ext_name == "h" || $tmp_file_ext_name == "cu" ]]; then
        dumpinfox "processing cpp/h/hpp/cu file"
        source ${BASH_DIR}/bin/show_class_function_defintion.sh "listDefInCurFile" ${curFile}
    elif [[ $tmp_file_ext_name == "sh" || $tmp_file_ext_name == "csh"  ]]; then
        dumpinfox "processing sh/csh file"
        list_function_in_script_file "${curFile}"
    elif [[ "$tmp_file_ext_name" == "groovy" ]]; then
        dumpinfox "processing groovy file"
        grep -niHP --color=always "^\w+.*(?=\(.*{ *$)|class .*(?= { *$)" "${curFile}" | sed 's#:#  #2' | grep -E --color=always " +.*"    
    elif [[ "$tmp_file_ext_name" == "cmake" || "${tmp_file_name}" == "CMakeLists.txt" || "${tmp_file_name}" == *"cmake.in" ]]; then
        dumpinfox "processing cmake file"
        grep -niHP --color=always "^ *(function|include|find_package|find_program|find_library|find_path|find_file|execute_process)" "${curFile}" | sed 's#:#  #2' | grep -E --color=always " +.*"    
    elif [[ "$tmp_file_ext_name" == "py" ]]; then
        dumpinfox "processing python file"
        grep -niHP --color=always "^ *def [^\(]*|__main__" "${curFile}" # | sed 's#:#  #2' | grep -E --color=always " +.*"    
    elif [[ $tmp_file_ext_name == "mlir" ]]; then
        dumpinfox "processing mlir file"
        grep -niRHE --color=none ".func +(.* +)*@" "${curFile}" | grep -E -v ":// *" | grep -E --color=always "@[^(]+" | sed 's#:#  #2';
    elif [[ $tmp_file_name == *"consoleText"* || $tmp_file_ext_name == "log" ]]; then
        dumpinfox "processing consoleText file"
        if grep -qE -m 1 "artifactUrl|build number|Detecting CXX compiler" "${curFile}"; then
            source ${BASH_DIR}/nvidia/log_analysis/show_project_build_test_info.sh  ${curFile}
            # source ${BASH_DIR}/nvidia/log_analysis/filte_build_error_lines.sh ${curFile}
        fi
    elif [[ $tmp_file_ext_name == "txt" ||  $tmp_file_ext_name == "ini"  ]]; then
        dumpinfox "processing txt file"
        # grep -niRHE --color=none "^[0-9\.*]+ " "${curFile}" | sed 's#:#  #2' | grep -E --color=always " +.*"
        grep -niRHE --color=none "^[0-9\.*]+ |^[a-zA-Z_0-9]+ * : " "${curFile}" | sed 's#:#  #2' | grep -E --color=always " +.*"
    elif [[ $tmp_file_ext_name == "td" ]]; then
        dumpinfox "processing tabgen .td file"
        grep -niRHP --color=always "^(class|def) +\K\w+" "${curFile}" | sed 's#:#  #2'
    else
        dumpkey tmp_file_ext_name
        dumpinfox "no special pattern for file ${brown}${curFile}"        
    fi
    last_used_file=${curFile}
    dumpkey last_used_file
    export last_used_file
    dumpinfo "cmd '${brown} list_attributes_in_json_file ${blue}' is available now"
}

main_show_file_info "$@"

bash_script_o
