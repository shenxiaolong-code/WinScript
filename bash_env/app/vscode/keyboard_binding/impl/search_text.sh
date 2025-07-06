#!/bin/bash

bash_script_i
echo

function help_on_search_text() {
    echo
    echo -e -n "${red}ctrl+k  ${end}:${green} search text in current file"
    echo -e -n "  ${red}ctrl+shift+k  ${end}:${green} search text in current folder"
    echo -e -n "  ${red}ctrl+alt+k  ${end}:${green} search text in root folder"
    echo -e -n "  ${red}ctrl+shift+alt+k  ${end}:${green} search text in up folder"
    echo -e    "  ${red}alt+k  ${end}:${green} search text in terminal work directory"
}

function listSelText() {
    # egrep --color=auto  -nIR --exclude-dir={.svn,.git,.vscode} "$3" "$1"
    # echo "# selected_text : ${selected_text}"
    # tem_file_log=${TEMP_DIR}/to_del/temp_${RANDOM}.log
    tem_file_log=${TEMP_DIR}/to_del/temp_$(date "+%Y%m%d_%H%M").log
    (
        echo -e "# ${green}search text ${brown}${selected_text}${green} in file ${red}${curFile}  ${end}"
        echo -e "#${black} reproduce filter:  ${end}"
        # --text will fix below issue :
        # Binary file ${EXT_DIR}/myReference/log_example/cutlass_ir_gcc_8.5.0/dkg_test_consoleText_20250211_1004.txt matches
        echo -e "#${black} grep --color=always -FniRH --text \"${selected_text}\" ${curFile}  ${end}"
        echo " "
        grep --color=always -FniRH --text "${selected_text}" "${curFile}" | sed 's#:#  #2'
        echo " "
    ) | tee >(sed $'s/\e[[][^A-Za-z]*m//g' | sed -E $'s/\x1B\[([0-9]{1,2}(;[0-9]{1,2})?)?[m|K]//g'  > "${tem_file_log}" )
    echo -e "# ${green}log file ${brown}${tem_file_log}${green}${end}  ."    
}

function listSelTextDir() {
    # egrep --color=auto  -nIR --exclude-dir={.svn,.git,.vscode} "$3" "$1"
    # echo "selected_text : ${selected_text}"
    echo -e "# ${green}search text ${brown}${selected_text}${green} in folder ${red}${fileDir}/  ${end}"
    dumpinfo "grep --color=always -FniRH "${selected_text}" "${fileDir}/""
    grep --color=always -FniRH "${selected_text}" "${fileDir}/" | sort | sed 's#:#  #2'
}

function listSelTextUpDir() {
    
    # egrep --color=auto  -nIR --exclude-dir={.svn,.git,.vscode} "$3" "$1"
    # echo "selected_text : ${selected_text}"
    fileUpDir=${fileDir%/*}
    find_text_in_dir "${selected_text}" "${fileUpDir}/"
    # echo -e "# ${green}search text ${brown}${selected_text}${green} in folder ${red}${fileUpDir}/  ${end}"
    # grep --color=always -FniRH "${selected_text}" "${fileUpDir}/"    
}

function listSelTextInRoot() {
    git_root=$(get_git_svn_file_root "${fileDir}")
    find_text_in_dir "${selected_text}" "${git_root:-${fileDir}}/"
    # dumpkey git_root
    # echo -e "# ${green}search text ${brown}${selected_text}${green} in folder ${red}${git_root:-${fileDir}}/  ${end}"
    # grep --color=always -FsniRH --exclude-dir={.svn,.git,.vscode} "${selected_text}" "${git_root:-${fileDir}}/"    
}

function main() {
    "$@"
}

function show_cmd_in_this_file() {
    echo -e "${black}source ${BASH_SOURCE[0]} $* ${end}"
    grep --color=always -niHP "(?<=function )$1(?= *\()" "${BASH_SOURCE[0]}" | sed  -e 's#:#  #2' -e 's#{##' -e "s#\$# ${s_green}$2:$3${s_brown} $4${s_end}#"
}

# source search_text.sh listSelTextInRoot ${file} ${lineNumber}
# selected_text="${@:4}"
show_cmd_in_this_file "$@"
selected_text="${4}"
main "$1" "$2:$3" "$4"
help_on_search_text

echo
bash_script_o
