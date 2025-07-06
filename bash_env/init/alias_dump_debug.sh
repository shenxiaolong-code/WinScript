
# the debug_bash_script is used to debug the environment varable is changed unexpected.
# usage : un-comment the printf line to enable the environment varable debug feature
function debug_bash_script() {
    # printf "# \e[0;34m[$1] \e[0;35m%-16s\e[0;0m = \e[0;33m %s \e[0;0m \n" "cur_repo_dir"  "${cur_repo_dir}"  ;
    # echo ${PATH} | grep --color=always "cmake-3.22.1" ;
    :       # place holder cmd , empty cmd , always return sucessful 0
}
function debug_bash_script_i() {    debug_bash_script  "debug_i"  ; }
function debug_bash_script_o() {    debug_bash_script  "debug_o"  ; }

alias bash_script_i='[[ ! -v disable_bash_script_io ]] && echo -e "# +++++++++ loading ${BASH_SOURCE[0]}:${LINENO}  \e[0;30m:  ${BASH_SOURCE[1]##*/}:${BASH_LINENO[0]} \e[0;0m" ; debug_bash_script_i ;'
alias bash_script_o='debug_bash_script_o ; [[ ! -v disable_bash_script_io ]] && echo -e "# --------- leaving ${BASH_SOURCE[0]}:${LINENO}  "'

# see : ${BASH_DIR}/init/bashrc
alias bash_script_i_blue='echo -e "# +++++++++ loading ${blue}${BASH_SOURCE[0]}:${LINENO} ${end}  \e[0;30m:  ${BASH_SOURCE[1]##*/}:${BASH_LINENO[0]} \e[0;0m" ; debug_bash_script_i ;'
alias bash_script_i_green='echo -e "# +++++++++ loading ${green}${BASH_SOURCE[0]}:${LINENO} ${end}  \e[0;30m:  ${BASH_SOURCE[1]##*/}:${BASH_LINENO[0]} \e[0;0m" ; debug_bash_script_i ;'
alias bash_script_o_blue='debug_bash_script_o ; echo -e "# --------- leaving ${blue}${BASH_SOURCE[0]}:${LINENO}  ${end}"'
alias bash_script_o_green='debug_bash_script_o ; echo -e "# --------- leaving ${green}${BASH_SOURCE[0]}:${LINENO}  ${end}"'

# ********************************************************************************************************************************************************
# see exported variable
# export -p
# declare -p <var_name>

# dump : always do ; debug : do only when enable debug flag
# add "# " in dump info to adapt generate cmd script
# function dump_env_variable2()   {  echo ${blue}[info] ${purple}$1${end} = ${brown} $2 ${end}                             ; }
function  dump_env_variable2()     {  printf "# [${steelblue_24} dumpkey  ${end}] ${gold_256}%-16s${end} = ${azure_256} %s ${end} \n" $1  "$2"  ; }
function  dump_env_variable()      {  v2=$1 ;    dump_env_variable2  $1  "${!v2}"                                                               ; }
# https://unix.stackexchange.com/questions/222487/bash-dynamic-variable-variable-names

# ${FUNCNAME[$i] is better than 'caller $i' with more information , more accurate , more reliable , more readable , more performance
# current function frame index is 0, the caller index is 1
function dump_call_stack() {
    \echo -e "#${blue} call stack : max ${#FUNCNAME[@]} levels${end}"

    # 计算最大函数名长度
    local max_length=0
    for func in "${FUNCNAME[@]}"; do
        local length=${#func}
        if (( length > max_length )); then
            max_length=$length
        fi
    done
    (( max_length += 2 ))

    # 输出调用栈信息
    local i=1       # i=0 will show dump_call_stack itself
    for (( i; i<${#FUNCNAME[@]}; i++ )); do
        local func="${FUNCNAME[$i]:-(top_layer)}"        
        local src="${BASH_SOURCE[$i]:-(no_src)}"
        local line="${BASH_LINENO[$((i - 1))]}"
        
        if is_string ${line} ; then
            if [[ -f $src && (( $i < ${#FUNCNAME[@]} )) ]]; then
                # correct the line number : get the function line number from the source file
                line=$(grep -nH "$func()" $src | grep -oP "(?<=:)[0-9]+")
                # line="$(grep -n "$func()" "$src" | cut -d':' -f1)"
                # line="$(grep -n "^[[:space:]]*$func()[[:space:]]*{*" "$src" | cut -d':' -f1)"
            fi
        fi        
        printf "# [ %d ] ${brown}%-${max_length}s${blue} %-s${end}\r\n" $i "$func" "$src:$line"
    done
}
alias dumpstack=dump_call_stack
# auto dump call stack when error occurs and exit
# trap 'dump_call_stack' ERR
# doSomething
# trap - ERR
#!/bin/bash

# alias   current_position='command echo "[ current ] ${FUNCNAME[0]} ${BASH_SOURCE[0]}:${LINENO}"'
# alias   caller_position=' command echo "[ caller  ] ${FUNCNAME[1]} ${BASH_SOURCE[1]}:${BASH_LINENO[0]}"'
alias     dump_position_current=' echo -e "# ${black}[ current ] ${FUNCNAME[0]} ${BASH_SOURCE[0]}:${LINENO}${end}" '
alias     dump_position_caller='  echo -e "# ${black}[ caller  ] ${FUNCNAME[1]} ${BASH_SOURCE[1]}:${BASH_LINENO[0]}${end}"  '

alias     get_current_function_name='[[ ${FUNCNAME[0]} != source ]] && echo ${FUNCNAME[0]}'
alias     dumpcmdline='command echo -e "# [${cyan_L} dumpcmdline ${end}] [ ${BASH_SOURCE[0]}:${LINENO} ${end}] ${brown} $(get_current_function_name)${red} $* ${end}" '
alias     dumpcmdline2='command echo -e "# [${cyan_L} dumpcmdline2 ${end}] [ ${BASH_SOURCE[0]}:${LINENO} ${end}]${brown} $(get_current_function_name)${red} $* ${end}\n$(dump_position_current) \r\n$(dump_position_caller)" '
# alias   dump_position='printf "# [${black} dumppos  ${end}] %-2s ${black}${BASH_SOURCE[0]}:${LINENO}${end} # ${black}${BASH_SOURCE[1]}:${BASH_LINENO[0]}${end}\n" "$(get_current_function_name)" '
alias     dump_position='printf "# [${black} dumppos  ${end}] %s ${black}${BASH_SOURCE[0]}:${LINENO}${end} # ${black}${BASH_SOURCE[1]}:${BASH_LINENO[0]}${end}\n" "$(get_current_function_name)" '
alias     dump_caller='command echo -e "# [${black} dumppos  ${end}] ${black}${BASH_SOURCE[1]}:${BASH_LINENO[0]}${end}\n"'
alias     dumppos=dump_position
alias     dumppos2=dump_caller

# remove the 2nd : char and later blank but keep the color
# sed "s#:# #2"  => remove_grep_2nd_colon_and_blank
# grep -nH --color=always "$*" file | remove_grep_2nd_colon_and_blank
alias remove_grep_2nd_colon_and_blank='sed "s#:\x1B\[m\x1B\[K\s*# \x1B\[m\x1B\[K#2"'

function  dump_information()      {  \echo -e "# [${seagreen_24} dumpinfo ${end}]${blue} $*  ${end}"    ;   }
function  dump_warning()          {  \echo -e "# [${orange_256} dumpwarn ${end}]${brown} $*  ${end}"    ;   }
function  dump_info_error()       {  
        \echo -e "# [${crimson_24} dumperr  ${end}]${crimson_24} $*  ${end}" >&2 ;
        grep -F -nH --color=always "$*" ${BASH_SOURCE[1]} | remove_grep_2nd_colon_and_blank >&2 ; 
        dump_call_stack  >&2 ;
        echo "press any key to continue" >&2 ;
        read ;
    }

# dump_and_run_shell_cmd  echo "hello world"  "# it is test comments"
function dump_and_run_shell_cmd() {
    local command="$*"    
    local cmd=$(echo "$command" | cut -d'#' -f1 | xargs)
    local comment=$(echo "$command" | grep -oP '#.*' | xargs)
    echo -e "# [${purple_L} dumpcmd ${end}]${brown} $cmd  ${comment:+${green}\t\t${comment}} ${end}"
    eval "$cmd"
}
function  dump_cur_shell_cmd()  {  
                                    \echo -e "# [${purple_L} dumpcmd  ${end}]${brown} $(sed -E "s/ # / ${green_256}# /" <<< "$*")  ${end}"  ;
                                    export LAST_CMD="$*"                                                                            ;  # used by donecmd
                                }
alias     dumpkey='    dump_env_variable '
alias     dumpkey2='   dump_env_variable2 '
alias     dumpkeyx='   dump_position  &&  dump_env_variable '
alias     dumpkeyx2='  dump_position  &&  dump_env_variable2 '

alias     dumpcmd='    dump_cur_shell_cmd '
alias     dumpcmdx='   dump_position  &&  dump_cur_shell_cmd '
alias     donecmd='    echo -e "# [${red} donecmd  ${end}]${brown} ${LAST_CMD}  ${end}"'
alias     donecmdx='   dump_position  && donecmd '
alias     runcmd='     dump_and_run_shell_cmd '
alias     runcmdx='    dump_position  &&  dump_and_run_shell_cmd '

alias     dumpinfo='   dump_information '
alias     dumpinfox='  dump_position  &&  dump_information '
alias     dumpwarn='   dump_position  &&  dump_warning '
alias     dumperr='    dump_info_error '

function  debug_env_variable()     {  [[ -v debug ]] &&  dump_env_variable   "$1"        ; }
function  debug_env_variable2()    {  [[ -v debug ]] &&  dump_env_variable2  "$1"  "$2"  ; }
alias     debugkey=' [[ -v debug ]] &&  dumpkeyx  '
alias     debugkey2='[[ -v debug ]] &&  dumpkeyx2 '
alias     debuginfo='[[ -v debug ]] &&  dumpinfo  '
alias     debugpos=' [[ -v debug ]] &&  dump_position  '

alias     debug_script_i='[[ -v debug ]] && bash_script_i '
alias     debug_script_i='[[ -v debug ]] && bash_script_o '

alias     is_this_line_inside_function='[[ -n ${FUNCNAME[1]} ]] '

# echo -e "\x1B[35m" | view_escape_chars
# echo -e "this is ${red} red ${end} text"
# echo -e "this is ${red} red ${end} text" | view_escape_chars
# echo $red_L   | cat -A
# echo $s_red_L | cat -A
function view_escape_chars() {
    cat -A
}

# asc to hex string
# echo "123456" | view_hex_string 
# echo -e "this is ${red} red ${end} text" | view_hex_string
function view_hex_string(){
    xxd -g 1    
    # od -A n -t x1
}

# hex to asc string
# echo "31 32 33 34 35 36 0a" | view_asc_string
# echo "74 68 69 73 20 69 73 20 1b 5b 30 3b 33 31 6d 20 72 65 64 20 1b 5b 30 3b 30 6d 20 74 65 78 74 0a" | view_asc_string
function view_asc_string(){
    # echo -e "\x31\x32\x33\x34\x35\x36"
    xxd -r -p
}

function begin_debug_mode() {
    output_file="${TEMP_DIR}/cache/trace_output.txt"
    # create file handle 3
    exec 3> "$output_file"
    # redirect stdout to file handle 3
    BASH_XTRACEFD=3
    # enable debug mode
    set -v
    set -x
    \echo -e "# ${purple_L}debug mode enabled ${end}"
    \echo "[begin] $(date +"%Y/%m/%d %T")"
}

function end_debug_mode() {
    \echo "[end] $(date +"%Y/%m/%d %T")"
    # disable debug mode
    set +x
    set +v
    # close file handle 3
    exec 3>&-
    \echo -e "# ${purple_L}debug mode disabled ${end}"
    \echo -e "# ${red}trace output file :${brown} ${output_file} ${end}"
    codeopen "$output_file"
}

function generate_log_header() {
    {
        echo 
        echo "$(date +"%Y/%m/%d %T")"
        echo "$(hostname) : ${envMode}"
        echo "$(pwd -L)"
        echo "generated by : $1:$2 "
    } >> "$1.log"    
    dumpinfo "$1.log"
}

function generate_cmd_log() {
    random_value=$RANDOM
    tee "${TEMP_DIR}/to_del/cmd_log_${random_value}.log" & echo "${TEMP_DIR}/to_del/cmd_log_${random_value}.log"
}

alias genlog=' tee  "${BASH_SOURCE[0]}.log"  ;  generate_log_header  ${BASH_SOURCE[0]}  $LINENO ; '
alias cmdlog=generate_cmd_log

# error capture function
# show current error_handerl : trap -p ERR
# trap 'error_handler_special' ERR
# non_existent_command  # 这将触发“command not found”错误
function error_handler_special() {    
    local exit_code=$?               # 获取退出状态
    local command="${1:-$BASH_COMMAND}"  # 获取导致错误的命令

    # grep find failure will return 1
    [[ $exit_code != 1 ]] && \echo -e "# [${red} Unhandled Error ${end}]${blue} error cmd : ${command} ,  exit_code: ${exit_code} ${end}"
    if [[ $exit_code == 127 ]]; then  # command not found
        dump_call_stack
    fi
}
# set -E
# trap 'error_handler' ERR              # can't get the old bash cmd $BASH_COMMAND
# trap 'error_handler_special "$BASH_COMMAND"' ERR

# alias source=' echo -e "#                   \e[0;30m${BASH_SOURCE[0]}:${LINENO}\e[0;0m" ; \source '
# alias bash_script_i=
