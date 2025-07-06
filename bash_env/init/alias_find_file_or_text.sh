bash_script_i
# ***************************************************************************************************************************************************************************************************************
# example
# egrep --color=auto "t[56]n"  ${BASH_DIR}/nvidia/run_test/alias_cask_tester.sh
# egrep -niRH --color=auto  "t[56]n" ${BASH_DIR}/nvidia/*

alias grepc='grep --color=always -P --exclude-dir={.svn,.git,.vscode}'                     # search in pipeline
alias grepcf='grep --color=always -niHP --exclude-dir={.svn,.git,.vscode}'                 # search in file , H show file full path

# bash function name legnth MUST be greater then 2 (from 3 ...)
# https://unix.stackexchange.com/questions/93857/find-does-not-work-on-symlinked-path
# use "${MySymlinkedPath}/" to replace "${MySymlinkedPath}" to avoid failure for symbol linked path -- it is file in system.
# use -L to resolve symbol link
# https://stackoverflow.com/questions/5905054/how-can-i-recursively-find-all-files-in-current-and-subfolders-based-on-wildcard

# below two variable can NOT be used in bash function
find_exclude_dir="! -path '*/.svn/*' ! -path '*/.git/*' ! -path '*/.vscode/*'"
grep_exclude_dir="--exclude-dir={.svn,.git,.vscode}"

# search text file   :  grepc -RIl .
# search binary file :  grepc -RIL .

# prefix : ff   - find file ;                  ft    - find text ;
#          ffxx - find aa file in bb folder ;  ftxx  - find aa text in bb folder
#  **************************************** find file *************************************************************
                              # example :  do_find_file_in_dir "*.hpp,*.h,readme" "./tools;./test"
# example :  do_find_file_in_dir "*.hpp|*.h|readme" "./tools|./test"
function do_find_file_in_dir()    {   
                                        local file_name="${1:-*}"
                                        local multi_folders="${@:2}"
                                        multi_folders=$(echo "${multi_folders:-$(pwd -L)}" | sed -E 's#[;,\|]+# #g' | xargs -n1 readlink -f | tr '\n' ' ' | update_symbol_path )                                        
                                        local addi_option=""
                                        [[ -z $1 ]] && addi_option="-maxdepth 1"
                                        
                                        # 处理特殊情况：当file_name就是"*"时，不需要构建复杂的pattern
                                        if [[ "$file_name" == "*" ]]; then
                                            dumpinfo "find -L ${multi_folders} ${addi_option} -type f"
                                            find -L ${multi_folders} ${addi_option} -type f ! -path '*/.svn/*' ! -path '*/.git/*' ! -path '*/.vscode/*' ! -path '*/.snapshot/*' ! -path '*/.cpan/*'
                                            [[ -z $1 ]] && dumpinfo "use ${brown}ff '*' ${blue}to search all files , include sub-folder ${end}"
                                            return
                                        else
                                            file_name=${file_name##*/}
                                        fi
                                        
                                        # 处理多个文件名，支持空格和;,|分隔
                                        # -iname 只能搜索文件名，不能搜索文件路径. e,g,  *guardwords_scanner.py*
                                        # -path  可以搜索文件路径，但不能忽略大小写. e.g. *helper/guardwords/guardwords_scanner.py*
                                        local name_patterns=()
                                        while IFS= read -r name; do
                                            name=$(echo "${name}" | sed 's/:.*//')
                                            name_patterns+=("-o" "-iname" "*${name}*")
                                        done < <(echo "$file_name" | sed -E 's#[;,\|]+#\n#g')
                                        # 删除第一个-o
                                        [[ ${#name_patterns[@]} -gt 0 ]] && unset 'name_patterns[0]'
                                        
                                        # find /home/.../dkg_llvm_rotation -type f \( -iname "revi*" -o -iname "rea*" -o -iname "mak*" \)
                                        dumpcmd find -L ${multi_folders} ${addi_option} -type f \\\( "${name_patterns[@]}" \\\)
                                        find -L ${multi_folders} ${addi_option} -type f \( "${name_patterns[@]}" \) ! -path '*/.svn/*' ! -path '*/.git/*' ! -path '*/.vscode/*' ! -path '*/.snapshot/*' ! -path '*/.cpan/*'
                                    }
# find_xxx_file_in_dir "test|ut|unit|test" "*.py,*.cmake,*.cmake.in"   dir1 dir2 dir3
# find_xxx_file_in_dir "test|ut|unit|test" "*.py,*.cmake,*.cmake.in"  "dir1,dir2,dir3"
function find_xxx_file_in_dir()    {
                                        dumpinfox "${black} ${FUNCNAME[0]} : ${green}Searching ${brown}$1${green} files in ${red}$2 ${green} file type, folder ${brown}${@:3} ${green} , include sub-folder ${end}" ;  
                                        if [[ -z $1 ]]; then
                                            do_find_file_in_dir "$2" "${@:3}"
                                        else
                                            do_find_file_in_dir "$2" "${@:3}" | grep --color=always -iP "$1"
                                        fi
                                        dumppos   ;
                                    }
# find_file_in_dir "test|ut|unit" "dir1,dir2,dir3"
function find_file_in_dir()         {
                                        dumpinfox "${black} ${FUNCNAME[0]} : ${green}Searching all files ${brown}${1:-*} ${green} in ${red}${2:-$(pwd -L)}" ;  
                                        #  /bin/ls --color=auto -1 -Artd ${1:-"$(pwd -L)"}/*$2*  ;
                                        # find /path/to/search -type f -path "*/dir1/dir2/dir3/ddd.h"
                                        local hightlight_pattern=$(echo "$1" | sed -E 's#[;,\| ]+#|#g')
                                        do_find_file_in_dir "$1"  "$2" | while read -r line; do
                                            if [[ -f "$line" ]]; then
                                                echo "$line" | egrep -i --color=always  "${hightlight_pattern}"
                                            else
                                                echo "$line"
                                            fi
                                        done
                                        # do_find_file_in_dir "$1"  "$2" | egrep -i --color=always  "${1%:*}" | sed "s#${1%:*}#$1#"  ;
                                        dumppos   ;
                                    }
function find_file_in_dir_cmd()     {   
                                        # use to xargs process the file , the color is not allowed
                                        do_find_file_in_dir "$1" "${2:-$(pwd -L)}" | grep -v "dumpcmd"
                                    }

function find_text_file_in_dir()    {   dumpinfox "#${black} ${FUNCNAME[0]} : ${green}Searching text file ${brown}$1${green} in ${red}$2  ${end}" ; 
                                        local hightlight_pattern=$(echo "$1" | sed -E 's#[;,\| ]+#|#g')
                                        do_find_file_in_dir "$1"  "$2" | while read -r line; do
                                            if [[ -f "$line" ]]; then
                                                grep -RIl "" "$line" | egrep -i --color=always  "${hightlight_pattern}"
                                            else
                                                echo "$line"
                                            fi
                                        done
                                        # do_find_file_in_dir "${1##*/}"  "$2" | grep -v "dumpcmd" | xargs grep -RIL "" | egrep -i --color=always  "$1"   ; 
                                        dumppos   ;
                                    }
function find_binary_file_in_dir()  {   dumpinfox "#${black} ${FUNCNAME[0]} : ${green}Searching binary file ${brown}$1${green} in ${red}$2  ${end}" ; 
                                        hightlight_pattern=$(echo "$1" | sed -E 's#[;,\| ]+#|#g')
                                        do_find_file_in_dir "$1"  "$2" | while read -r line; do
                                            if [[ -f "$line" ]]; then
                                                grep -RIl "" "$line" || egrep -i --color=always "${hightlight_pattern}"
                                            else
                                                echo "$line"
                                            fi
                                        done
                                        # do_find_file_in_dir "${1##*/}"  "$2" | grep -v "dumpcmd" | xargs grep -RIL "" | egrep -i --color=always  "$1"   ; 
                                        dumppos   ;
                                    }

#  **************************************** find text *************************************************************
# example :  find_text_in_dir  "hello|byebye"   "./tools;./test"
# example :  find_text_in_dir  "hello|byebye"   ./tools  ./test
function find_text_in_dir()         {   dumpinfox "#${black} ${FUNCNAME[0]} : ${green}Searching text ${brown}$1${green} in ${red}$2  ${end}"   ; 
                                        [[ -z   "$1" ]] && { dumperr "empty search text is not supported to avoid huge output" ; return 1 ; }
                                        local multi_folders=${@:2}
                                        multi_folders=$(echo "${multi_folders:-$(pwd -L)}" | xargs | sed -E 's#[;,\|]+# #g' | xargs -n1 readlink -f | tr '\n' ' ' | update_symbol_path )
                                        dumpcmd grep --color=always  -sniIRHP "$1" ${multi_folders}
                                        grep --color=always  -sniIRHP --exclude-dir={.svn,.git,.vscode} "$1" ${multi_folders}   | sed 's#:#  #2'
                                        dumppos   ;
                                    }
# # grep -sniHrP --include={*.txt,*.md} --exclude-dir={.svn,.git,.github} "abc|hello|find" /dir1 /dir2 /dir3
# find_text_in_xxx_file "URM_USER|FATAL_ERROR" "*.py,*.cmake,CMakeLists.txt,*.cmake.in" ${EXT_DIR}/repo/dkg_root/dkg_integrate_mono_kernel_store ${EXT_DIR}/tmp/test
function find_text_in_xxx_file()    {   dumpinfox "#${black} ${FUNCNAME[0]} : ${green}Searching text '${brown}$1${green}' in spec file ${red}$2 ${green} under dir ${brown} $3 ${end}"    ;
                                        [[ $# -lt 2 ]] && { dumpcmdline ; dumpinfo "param number : $#" ; dumperr "usage : ${FUNCNAME[0]} <text_wild_char> <dir_path> <file_wild_char>" ; return 1 ; }
                                        [[ -z "$1" ]] && { dumperr "empty search text is not supported to avoid huge output" ; return 1 ; }
                                        
                                        local multi_folders=${@:3}
                                        multi_folders=$(echo "${multi_folders:-$(pwd -L)}" | xargs | sed -E 's#[;,\|]+# #g' | xargs -n1 readlink -f | tr '\n' ' ' | update_symbol_path )
                                        # use eval to avoid shell wildcard expansion , e.g. *.py expand to all files in current folder
                                        local include_pattern="$(echo "$2" | sed -E 's#[,| ]+#,#g' | sed -E 's#^#,#' ) "
                                        include_pattern="${include_pattern//,/ --include=}"
                                        dumpcmd "grep --color=always -sniHrP $include_pattern --exclude-dir={.svn,.git,.github} \"$1\" ${multi_folders}"                                        
                                        eval "grep --color=always -sniHrP $include_pattern --exclude-dir={.svn,.git,.github} \"$1\" ${multi_folders}"
                                        donecmd
                                        dumppos   ;
                                    }
function find_folder_in_dir()       {
                                        local folder_name="${1:-*}"
                                        local multi_folders="${@:2}"
                                        multi_folders=$(echo "${multi_folders:-$(pwd -L)}" | xargs | sed -E 's#[;,\|]+# #g' | xargs -n1 readlink -f | tr '\n' ' ' | update_symbol_path )
                                        # find /path/to/search -type d -path "*/dir1/dir2/dir3"
                                        dumpinfox "#${black} ${FUNCNAME[0]} : ${green}Searching folder ${brown}${folder_name}${green} in ${red}${multi_folders}${end}" ;
                                        find -L ${multi_folders} -type d -iname "*${folder_name}*" ! -path '*/.svn/*' ! -path '*/.git/*' ! -path '*/.vscode/*' ! -path '*/.snapshot/*' ! -path '*/.cpan/*' | egrep -i --color=always  "${folder_name}"    ;      
                                        dumppos   ;                    
                                    }
function find_depth1_file_in_dir()                  {   /bin/ls --color=always -1 -Artd              ${1:-$(pwd -L)}/*            ; }

alias ff=find_file_in_dir
alias ffa='find_file_in_dir "*"'
alias ff1=find_depth1_file_in_dir
alias ffc=find_file_in_dir_cmd
alias fft=find_text_file_in_dir
alias ffb=find_binary_file_in_dir

alias ft=find_text_in_dir
alias ftx=find_text_in_xxx_file

alias fd=find_folder_in_dir

#  **************************************** find file by timestamp *************************************************************
function find_newest_file()         {
                                        # find_newest_file  "${EXT_DIR}/build/cfk_11472_port_ffma_nhwc_fprop_farm_cask6/cmds/*.log"    
                                        # find $(pwd -L)/cmds -name "*.log" -type f -printf '%T@ %p\n' | sort -n | tail -1 | cut -d' ' -f2
                                        # find -L `pwd -L`/cmds/ -maxdepth 1 -type f -print | sort -n
                                        # /bin/ls -t $1 | head -n 1
                                        tmp_find_newest_file=${1:-"$(pwd -L)/*.*"} ;
                                        tmp_newest_file=$(/bin/ls -ArtdF -1 ${tmp_find_newest_file} | tail -n 1) ;
                                        [[ -f "${tmp_newest_file}" ]] && realpathx ${tmp_newest_file} && return 0 ;
                                        return 1 ;
                                    }

function find_newest_folder()       {
                                        # find_newest_folder "${EXT_DIR}/build"
                                        # find_newest_folder "${EXT_DIR}/build/"
                                        tmp_find_newest_folder=${1:-"$(pwd -L)"} ;
                                        tmp_find_newest_folder=${tmp_find_newest_folder%/}  ;
                                        # dumpkey tmp_find_newest_folder
                                        tmp_newest_folder=$(/bin/ls -rthF -1 ${tmp_find_newest_folder} | grep '/' | sed 's#/##' | tail -n 1) ;
                                        [[ -d "${tmp_newest_folder}" ]] && realpathx "${tmp_newest_folder}" && return 0 ;
                                        return 1 ;
                                    }
alias ffnew=find_newest_file
alias fdnew=find_newest_folder   

#  **************************************** find module path *************************************************************
function find_module_path() {
  # g++ -print-file-name=libasan.so
  # /usr/lib/gcc/x86_64-linux-gnu/9/libasan.so
  # module_name=${1:-"libstdc++.so.6"}
  module_name=${1:-"libasan.so"}
  dumpcmd "g++ -print-file-name=${module_name}"
  g++ -print-file-name=${module_name}
  echo
  dumpinfo "using cmd ${brown} imod <mod_path> ${blue} to show module info"
}
alias fmod=find_module_path

#  **************************************** find file or text in special folder *************************************************************
# find -L ${PWD}/ -maxdepth 1 -type f  -print  | sort -n
# find . -maxdepth 2 -ls
function ffcsh()     {  find_text_file_in_dir   "$1"        "${HOME}/csh_env"                             ; }
function ftcsh()     {  find_text_in_dir        "$1"        "${HOME}/csh_env"                             ; }
function ffsh()      {                         
                        find_text_file_in_dir   "$1"        "${BASH_DIR}"                    ; 
                        dumpinfo "use${brown} ffsh1 ${blue}to search in : ${EXT_DIR}/myReference/note/svn_note"   ;
                     }
function ffsh2()     {  find_text_file_in_dir   "$1"        "${EXT_DIR}/myReference/note/svn_note" ;}              
function fftest()    {  find_text_file_in_dir   "$1"        "${BASH_DIR}/test"               ; }
function ftsh()      {
                        find_text_in_dir        "$1"        "${BASH_DIR}"                    ; 
                        dumpinfo "use${brown} ftsh1 ${blue}to search in : ${EXT_DIR}/myReference/note/svn_note"   ;
                     }
function ftsh2()     {  find_text_in_dir        "$1"        "${EXT_DIR}/myReference/note/svn_note" ;}              
function ftgdb()     {  find_text_in_dir        "$1"        "${BASH_DIR}/app/gdb"            ; }

# ******************************************************* find cmd ***************************************************************************************************
source ${BASH_DIR}/init/find_class_function_definition.sh
# ***************************************************************************************************************************************************************************************************************
bash_script_o
