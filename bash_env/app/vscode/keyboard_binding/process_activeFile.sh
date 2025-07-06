
#!/bin/tcsh (tcsh instead of csh!!!)
# http://parallel.vub.ac.be/documentation/linux/#Scripts
# https://www.ibm.com/docs/en/aix/7.2?topic=shell-c-built-in-commands-list
# alias show_shortcut_cmd='echo -e "# ${blue}$1${end}:${green} ${BASH_SOURCE[0]}${end}:${red}$LINENO  ${end}"'
[[ ${disable_bash_script_io} != 1 ]] && echo -e "#${black} source ${BASH_SOURCE[0]} $* ${end}"
# alias show_shortcut_cmd='[[ ${disable_bash_script_io} != 1 ]] && echo -e "# ${black}$1: ${BASH_SOURCE[0]}:$LINENO  ${end}"'

curFile=$2
lineNumber=$3
# echo -e  "# ${red}curFile${end} : ${blue_L}${curFile} ${end}  ${red}lineNumber${end} : ${blue_L}${lineNumber} ${end}"
echo -e "# ${green}${curFile}:${lineNumber} ${@:3}${end}"
[[ -n $lineNumber ]] && { echo -e "# ${purple}`cat ${curFile} | sed -n "${lineNumber} p"` ${end}" ; }
# grep --color=always -nHP "(?<=function )$1" "${BASH_SOURCE[0]}" | sed  -e 's#:#  #2' -e 's#{##' -e "s#\$# ${s_green}$2:$3${s_brown} $4${s_end}#"

echo
bash_script_i
fileDir=`echo ${curFile} | sed 's#\(.*\)/.*#\1#g'`
fileName=`echo ${curFile} | sed 's#.*/##g'`
# fileNameBase=`echo ${curFile} | sed 's#.*/\([^\.]*\)\.*.*#\1#g'`
fileExt=`echo ${curFile} | sed 's#.*\.\(.*\)#.\1#g'`

# built-in cmd: to open a new terminal
# ctrl+t ctrl+t   : workbench.action.terminal.newInActiveWorkspace

function temp_test(){
    selected_text="${@:3}"
    source ${EXT_DIR}/tmp/test/_test_bash.sh  "showClassDef"  ${curFile}  "${selected_text}"
}

function showClassDef(){
    [[ "${fileName}" == "process_activeFile.sh" ]] && return   # avoid loopless
    dumpinfo "param num : $#"
    selected_text="${@:3}"
    source ${BASH_DIR}/bin/show_class_function_defintion.sh  "showClassDef"  ${curFile}  "${selected_text}"
}

function showFuncDef(){
    [[ "${fileName}" == "process_activeFile.sh" ]] && return   # avoid loopless
    selected_text="${@:3}"
    source ${BASH_DIR}/bin/show_class_function_defintion.sh "showFuncDef" ${curFile}  "${selected_text}"
}

function listDefInCurFile(){
    [[ "${fileName}" == "process_activeFile.sh" ]] && return   # avoid loopless
    source ${BASH_DIR}/bin/show_class_function_defintion.sh "listDefInCurFile" ${curFile}
}

function gitBlame(){
    blame_git_file_line ${curFile} ${lineNumber}
}

function openFileOnRemote(){
    open_remote_git_file_line ${curFile} ${lineNumber}
}

function showError(){
    echo -e "# ${green}show log error in file ${blue}${curFile}  ${end}"
    source ${BASH_DIR}/nvidia/log_analysis/filte_build_error_lines.sh  ${curFile}
}
function splitCiLog(){
    echo -e "# ${green}show log error in file ${blue}${curFile}  ${end}"
    source ${BASH_DIR}/nvidia/log_analysis/split_cask6_test_log_threads.sh  ${curFile}
}

function showInfo(){
    echo -e "# ${green}show file info in file ${blue}${curFile}  ${end}"
    source ${BASH_DIR}/bin/show_file_info.sh ${curFile}
}

function Jump2Path(){
    source ${BASH_DIR}/bin/jump2path.sh  "${curFile}"  "${lineNumber}"
    echo
}

function build(){
    dumpinfox "build ${curFile} ..."
    source ${EXT_DIR}/repo/linux_pratice/syntax_test_cpp/scripts/buildApp.sh
}
function run_test_app(){
    dumpinfox "run ${curFile} ..."
    ${this_repo_output_path}/myApp &
}
function updateLogPath(){
    # egrep --color=auto  -nIR --exclude-dir={.svn,.git,.vscode} "$3" "$1"
    source ${BASH_DIR}/nvidia/log_analysis/update_path_in_build_log.sh  "${curFile}"
    echo
}

function RunMeNoArg(){
    [[ "${curFile}" == "${BASH_SOURCE[0]}" ]] && return     # avoid loopless
    [[ "${target_file}" == "${BASH_DIR}/app/vscode/keyboard_binding/on_filePath_received.sh" ]] && return   # avoid loopless
    file_ext_name=${curFile##*.}
    echo -e "# ${blue}working directory ${green}$(pwd -L)  ${end}"
    echo -e "# ${blue}run script file ${green}${curFile}  ${red} file_ext_name : ${file_ext_name} ${end}"
    [[ "${file_ext_name}" == 'sh' ]]  && ( echo -e "# ${blue}source${green} ${curFile} ${end}" ; shift $#;  source ${curFile} ; )
    [[ "${file_ext_name}" == 'py' ]]  && ( echo -e "# ${blue}python${green} ${curFile} ${end}" ; shift $#;  python ${curFile} ; )
    [[ "${file_ext_name}" == 'txt' ]] && ( echo -e "# ${blue}cat${green} ${curFile} ${end}"    ; shift $#;  cat    ${curFile} ; )
    [[ "${file_ext_name}" == 'log' ]] && ( echo -e "# ${blue}cat${green} ${curFile} ${end}"    ; shift $#;  cat    ${curFile} ; )
    [[ "${file_ext_name}" == 'ini' ]] && ( echo -e "# ${blue}cat${green} ${curFile} ${end}"    ; shift $#;  cat    ${curFile} ; )
    echo -e "# ${blue}run script file ${green}${curFile}  ${red} file_ext_name : ${file_ext_name} ${end}"
    echo
}

function RunPathNoArg(){
    target_line_string=`cat ${curFile} | sed -n "${lineNumber} p" | xargs | envsubst | sed 's#.*/home/#/home/#g' | sed 's# .*##g'`
    target_file=`echo ${target_line_string} | sed 's#:.*##g'`
    [[ "${target_file}" == "${BASH_SOURCE[0]}" ]] && return   # avoid loopless
    [[ "${target_file}" == "${BASH_DIR}/app/vscode/keyboard_binding/on_filePath_received.sh" ]] && return   # avoid loopless
    file_ext_name=${target_file##*.}
    # echo "file_ext_name:${file_ext_name}"
    echo -e "# ${green}run script file ${blue}${target_file}  ${end}"
    [[ "${file_ext_name}" == 'sh' ]] && ( echo -e "# ${blue}source${green} ${target_file} ${end}" ;    source ${target_file} ; )
    [[ "${file_ext_name}" == 'py' ]] && ( echo -e "# ${blue}python${green} ${target_file} ${end}" ;    python ${target_file} ; )
    echo
}

function ListFiles(){
    # cat "${curFile}" | grep -n 'PYTHONPATH:\|CMD:' | sed 's#\(/home/[^ ]*\) #${s_green_L}\1${s_end} #g' | grep '/home/' | sed 's#\(/home/[^:]*\):#${s_red}\1${s_end}  :  #g' | sed 's#\(--[^ ]*\) #${s_blue_L}\1${s_end} #g'
    echo -e "# ${green}show all files in folder ${blue}${fileDir}  ${end}"
    echo "cd ${fileDir}"
    cd ${fileDir}
    # find "${fileDir}" -maxdepth 1 -type f  -print  | xargs grep -rIl "" | sort -k1
    find -L ${fileDir}/ -maxdepth 1 -type f  -print  ! -path '*/.svn/*' ! -path '*/.git/*' ! -path '*/.vscode/*' ! -path '*/.snapshot/*'  ! -path '*/.cpan/*' | sort -n | sed "s#${curFile}#${s_red}${curFile}${s_end}#g" | update_symbol_path
    echo
}

function ListPathFiles(){
    target_line_string=`cat ${curFile} | sed -n "${lineNumber} p" | xargs | envsubst | sed 's#.*/home/#/home/#g' | sed 's# .*##g'`
    # echo "target_line_string:${target_line_string}"
    target_file=`echo ${target_line_string} | sed 's#:.*##g'`
    target_dir="${target_file}"
    # echo "target_dir:${target_dir}"
    target_file_path="@@@dummy@@@"
    if [[ -f "${target_file}" ]] ; then
        target_dir=${target_file%/*}
        target_file_path=${target_file}
    fi
    if [[ -d "${target_dir}" ]] ; then
        # echo find "${target_dir}" -maxdepth 1 -type f  -print
        echo -e "# ${green}show all files in folder ${blue}${target_dir}  ${end}"
        find -L ${target_dir}/ -maxdepth 1 -type f  -print  ! -path '*/.svn/*' ! -path '*/.git/*' ! -path '*/.vscode/*' ! -path '*/.snapshot/*'  ! -path '*/.cpan/*' | sort -n | sed "s#${target_file_path}#${s_red}${target_file_path}${s_end}#g"
    fi
    echo
}

function helpShorcut() {
    echo -e -n "${red}ctrl+shift+o ${end}:${green} show all symbol in current source file"
    echo -e -n "  ${red}ctrl+b  ${end}:${green} git remote file link"
    echo -e -n "  ${red}alt+o  ${end}:${green} switch h/cpp file"
    echo -e -n "  ${red}ctrl+p  ${end}:${green} browe recent opened files"
    echo -e    "  ${red}ctrl+i  ${end}:${green} show file content info"
    echo -e -n "${red}ctrl+e  ${end}:${green} show log error info"
    echo -e -n "  ${red}ctrl+d  ${end}:${green} show class definition"
    echo -e -n "  ${red}ctrl+shift+d  ${end}:${green} show function definition"
    echo -e -n "  ${red}ctrl+l  ${end}:${green} list current file full path and goto the folder"
    echo
}

function show_cmd_in_this_file() {
    echo -e "${black}source ${BASH_SOURCE[0]} $* ${end}"
    # grep --color=always -niHP "(?<=function )$1" "${BASH_SOURCE[0]}" | sed  -e 's#:#  #2' -e 's#{##' -e "s#\$# ${s_green}$2:$3${s_brown} $4${s_end}#"
    grep --color=none -niHP "(?<=function )$1" "${BASH_SOURCE[0]}" | sed  -e 's#:#  #2' -e 's#{##' -e "s#\$# $2:$3${s_brown} $4${s_end}#" -e "s#^#${s_black}#"
}

function commentseltext(){
    local selected_text=$3
    echo -e "# ${green}comment selected text ${blue}${selected_text}  ${green} on position："
    sed -n "${lineNumber}p" ${curFile} | sed "s#${selected_text}#${s_magenta_24}${selected_text}${s_end}#"
    sed -i "${lineNumber}s#${selected_text}#/* ${selected_text} */#" ${curFile}
    codeopen ${curFile}:${lineNumber}
    touch ${curFile}
}

if [[ "$1" == "listSelText" || "$1" == "listSelTextDir" || "$1" == "listSelTextUpDir" || "$1" == "listSelTextInRoot" ]] ; then
    source ${BASH_DIR}/app/vscode/keyboard_binding/impl/search_text.sh  "$@"
else
    show_cmd_in_this_file "$@"
    "$@"
    helpShorcut
fi

# bash_script_o

