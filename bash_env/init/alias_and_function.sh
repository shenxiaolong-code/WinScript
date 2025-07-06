bash_script_i
# prefix :
# h | i  :  help | info
# l      :  list
# g | cd :  go | change directory
# f      :  find   # ff : find file ,  fd : find dir   , ft : find text

source ${BASH_DIR}/init/is_test_function.sh
source ${BASH_DIR}/bin/read_std_input.sh
# when use multiple quote in alias, you need it. see example timeout
q1="'"
q2='"'
# invalid_char_in_path='[<>:"/\\|?*]'
invalid_char_in_path='[\[\]<>"|?*]'
# echo "$anyString" | grep -vP "$invalid_char_in_path"

# alias   rinit='source ${BASH_DIR}/login_init.sh'
# alias   envl="ffx ${HOME}/Downloads ;"

# only in bash shell, the function can be exported and it can be used in other bash sub-process script.
# export -f function_name

alias   rinit="source ${HOME}/.bashrc"

alias   test="source ${TEST_DIR}/_test_bash.sh  1 2 3 4 5 "
alias   test2="source ${BASH_DIR}/test/_test_bash.sh  1 2 3 4 5"
alias   dtstr='date "+%Y%m%d_%H%M%S"'
alias   dtstr2='date +"%Y/%m/%d %T"'


# -t   sort by last modified time
# -r   reverse sort
# -h   size by b , k, M , instead of alway bytes
# -F   diff foler from file : filename  dir_name/
# -1   show only one fine per line
# show newest file :  /bin/ls -1 -td  _log/_2_make.*.log | head -n 1
# -1: 每行只显示一个文件或目录。
# -A: 显示所有文件，包括以。开头的隐藏文件，但不包括特殊目录。和..。
# -r: 逆序排列。
# -t: 按修改时间排序。
# -d: 路径中包含目录信息，而不仅仅只有文件名。
# -F: 在文件名后加上符号来表示文件类型，如 / 表示目录，* 表示可执行文件，@表示符号链接，等等。
# awk is powerfull but too slow , it is not suitable for interactive mode.

# nl :  add line number
# -n ln : left align.   -n rn : right align without leading spaces .    -n rz : right align with leading spaces
# -w 3 : width 3
# -s " " : separator " "
# -b p"$1" : prefix with $1
function    add_index_on_head_for_special_line() { nl -n ln -w 3 -s " " -b p"$1"                                        ; }   # add index column to previous cmd output line which include $1    .e.g : /bin/ls --color=auto   -lrth -1 | add_index_on_head_for_special_line  xiaolongs
function    insert_str_in_Nth_colunm()           { sed -r "s#^( *[^ ]+)(( +[^ ]+){$2})#\1   ${s_red}$1${s_end} \2   #g" ; }   #                                                                         /bin/ls --color=always -lrth -1 | insert_str_in_Nth_colunm       yy  3
function    move_column_1_to_Nth_colunm()        { sed -r "s#^( *[^ ]+)(( +[^ ]+){$1})#\2   ${s_red}\1${s_end}  #g"     ; }   #                                                                         /bin/ls --color=always -lrth -1 | move_column_1_to_Nth_colunm        3 
function    add_index_on_head_for_folder()       { add_index_on_head_for_special_line "drwxr" | sed -r 's#^ #.#g'       ; }   # add index column to previous cmd output and fill . if empty      .e.g : /bin/ls --color=auto   -lrth -1 | add_index_on_head_for_folder  
function    list_dir_with_reversed_index()       { /bin/ls --color=always -lrth -1 | tac | add_index_on_head_for_folder | tac | move_column_1_to_Nth_colunm 8 ; }
function    get_folder_name_by_index()           { /bin/ls -lrth -1 | tac | add_index_on_head_for_folder | grep "^${1:-1} " | sed -E 's#.*[0-9]{2}:[0-9]{2} ##' ;} 

function    only_show_Nth_column()               { sed -r "s#^(( *[^ ]+){$1})( +[^ ]+)*#\2#g"           ; }     #   /bin/ls --color=always -lrth -1 | only_show_Nth_column          3
function    only_show_first_N_columns()          { sed -r "s#^(( *[^ ]+){$1})( +[^ ]+)*#\1#g"           ; }     #   /bin/ls --color=always -lrth -1 | only_show_first_N_columns      3
function    remove_first_N_columns()             { sed -r "s#^(( *[^ ]+){$1})(( +[^ ]+)*)#\3#g"         ; }     #   only_show_last_N_columns is invalid, use remove_first_N_columns to work around only_show_last_N_columns. e.g.  /bin/ls --color=always -lrth -1 | remove_first_N_column  3
function    show_columns_count()                 { awk '{print NF}'                                     ; }     #   /bin/ls --color=always -lrth -1 | show_columns_count
function    show_max_columns_count()             { awk '{print NF}' | sort -n | tail -1                 ; }     #   /bin/ls --color=always -lrth -1 | show_max_columns_count

function    ls_sort_by_time() { /bin/ls --color=auto -rth -1 "$@"   ; }   # list file by time
function    ls_sort_by_name() { /bin/ls --color=auto -1 "$@" | sort ; }   # list file by name
alias       lsn=ls_sort_by_name
alias       lst=ls_sort_by_time
alias       ls=' /bin/ls --color=auto -rth -1'                      # only list one file name per line
alias       lss=' /bin/ls --color=auto -rth '                       # only list file name
alias       lsa='/bin/ls --color=auto -rthA -1'
# run raw built-in ls, instead of alias ls : \ls 
alias       ll=' /bin/ls --color=auto -lrth -1'                     # list file attribute, owner, group , size , data time , name
alias       lla='/bin/ls --color=auto -lrthA -1'
# lli is conflict with lli in llvm
#[[ -z ${BASH_ALIASES[lli]} ]] && alias lli='list_dir_with_reversed_index'
alias       llx='list_dir_with_reversed_index'
alias       cdx='goto_sub_folder_by_index_or_name'
alias       update_symbol_path='sed "s#/scratch.xiaolongs_gpu_1/#/xlshen/scratch/#g"'
alias       echo_align='printf "%-124s  \\\\\\n"'                     # align the output to 124 characters for multiple lines, see align_format_string.sh
alias       align_2_max_legth='cut -c 1-220'


function    realpathx() {
    local tmp_path=${1}
    command echo "$(realpath -s -m -q "$tmp_path")"
    # command echo "$(cd "${tmp_path%/*}" && pwd -L)/${tmp_path##*/}"
}

# ${BASH_SOURCE[0]%/*} can't wrok sometimes if 
# the script is sourced by other script
# the script is executed by relative path
alias       get_current_script_dir='echo $(cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd -L)'
# alias     get_current_script_dir='echo $(command echo "$(realpath -s -m -q "${BASH_SOURCE[0]}")")'

# if envsubst not found, then create a dummy one to do nothing without error , so that the following command can run without exception
# your_command | envsubst | grep ...
# alias envsubst=':'   # do nothing will lost the output , the grep will not work
if ! command -v envsubst &> /dev/null; then
function    envsubst() {
    cat
  }
fi

# fix : {  } 2&>1  | tee log.txt 
# if  {  } contain multiple command line (e.g. cmake ...; make ... ;) , the block buffer might cause part log missing in the log file ( e.g. execute_process ).  the line buffer can fix this issue.
# usage : linebuffered your_command
# linebuffered cmake ... ; linebuffered make ... ; linebuffered make install
alias linebuffered='stdbuf -oL'

function md5_string(){
    echo -n "$1" | md5sum | cut -f1 -d " "
}

function md5_file(){
    md5sum "$1" | cut -f1 -d " "
}

function fullpath {                                             # get full path , replace realpath command to avoid expand the symbolic link
    [[ -z "$1" ]] && pwd -L                                     || {
        [[ -d $1 ]] && (cd "$1" && pwd -L)                      || 
        echo "$(cd "$(dirname "$1")"; pwd -L)/$(basename "$1")"
    }
}

# list path : list file and folder full path , depth : 1
# find_all_path_in_dir_depth_1  .  "*.json"
# find_all_path_in_dir_depth_1 $(pwd -L) "*.sh"
function find_all_path_in_dir_depth_1() { 
    local tmp_dir="${1:-$(pwd -L)}"
    tmp_dir="$(cd "$tmp_dir" && pwd -L)" || return 1
    local filter="${2:-"*"}"
    
    local cmd="command ls --color=always -1 -Artd $tmp_dir/$filter 2>/dev/null"
    # local cmd="command ls --color=always -1 -Art \"$tmp_dir/\"$filter 2>/dev/null"
    dumpcmd "$cmd"
    
    # 使用 eval 展开通配符
    eval "$cmd" | sort
}

alias       lp=find_all_path_in_dir_depth_1
alias       lp2='find_all_path_in_dir_depth_1 | sed "s#$(pwd -L)#$(pwd -P)#g"'
alias       lpa=find_all_file_in_dir
alias       ps='\ps -u ${user} -f'                    # search process , \ps -u ${user} -f | grep -v "ps -u -f"

function    show_all_shell_cmds() {
    # Display all <n> possibilities? (y or n)

    # show all shell cmds in history with line number
    # history | awk '{$1=""; print $0}' | sort | uniq    
    
    ## same to tap twice
    dumpinfo "show all shell built-in cmds :"
    # compgen -c | column
    # compgen -c | pr -t -8
    compgen -c | pr -t -8 -w 280
    # compgen -c | pr -t -8 -b

    dumpinfo "show all shell function :"
    dumpcmd "compgen -A function | column"

    dumpinfo "show all shell alias :"
    dumpcmd "compgen -A alias | pr -t -8 -w 280"
}
alias cmds=show_all_shell_cmds
# set auto completion option prompt for cmds show_all_shell_cmds (tap twice)
complete -W "a f" show_all_shell_cmds
# complete -p show_all_shell_cmds


# prompt_confirm && echo "yes" || echo "no"
# prompt_confirm "${blue}Input${brown} yes ${blue}to comfirm to create worktree" && echo "yes" || echo "no"
# echo yes | prompt_confirm "are you sure to continue?"
# echo no | prompt_confirm "are you sure to continue?"
function prompt_confirm() {
    dumppos2
    local bTEST=no
    local prompt_text="${1:-"${blue}Input${brown} yes ${blue}to continue"}"
    dumpinfo "${blue}${prompt_text}\n${end}# ${blue}default is${red} no ${blue}to cancel.${end} [${s_brown}yes${end}/${red}no${end}] "
    read -r bTEST
    # if [[ $bTEST =~ ^[Yy]$  ]]; then
    if [[ "${bTEST}" == "yes" ]]; then
        dumpinfo "${green}${prompt_text} ${end}:${brown} yes"
        return 0
    else
        dumpinfo "${green}${prompt_text} ${end}:${red} no"
        return 1
    fi
}

function tee_split_very_big_log() {
    # tee >(split -d -b 100M - "$1.log.")
    local tmp_file_path=${1:-"$(pwd -L)/test_$RANDOM.log"}
    tmp_file_path=${tmp_file_path%.*}
    tee >(split -d -b 100M --additional-suffix=.log - ${tmp_file_path}_ )
}
alias teex=tee_split_very_big_log

function toLower() {
    echo "$1" | tr '[:upper:]' '[:lower:]'
}

function toUpper() {
    echo "$1" | tr '[:lower:]' '[:upper:]'
}

function tmuxx () {
    ssh $1 -t "tmux new-session -A -s main"
} 

# batch_replace usage :
# declare -A associative_array=( )
# declare -A associative_array=(["one"]="Baeldung" ["two"]="is" ["three"]="cool" ["four"]="yeah")
# array_string=$(declare -p associative_array)

# replace substring in a string map.  map[key] => map[value]
function map_batch_replace_in_string() {
    replaced_key=
    declare -A associative_array
    src=$1
    local tmp_array_string=$2
    eval "declare -A associative_array="${tmp_array_string#*=}
    for key in "${!associative_array[@]}"; do
        if [[ "$src" =~ $key ]]; then
            src=$(echo "$src" | sed "s@$key@${associative_array[$key]}@")
            \echo $src
            replaced_key=${key}
            return
        fi
    done
    \echo $src
}
# src_string="one two three four"
# echo $(map_batch_replace_in_string "$src_string" "$array_string")

# replace file in a string map.  map[key] => map[value]
function map_batch_replace_in_file() {
    declare -A associative_array
    file=$1
    local tmp_array_string=$2
    eval "declare -A associative_array="${tmp_array_string#*=}
    for key in "${!associative_array[@]}"; do
        if [ "$key" != "${associative_array[$key]}" ]; then
            \echo -e "'${brown}$key${green} ' => '${red}${associative_array[$key]}${end}'"
            # echo sed -i "s@$key@${associative_array[$key]}@g" "$file"
            sed -i "s@$key@${associative_array[$key]}@g" "$file"
        fi
    done
}

# src_file="${EXT_DIR}/tmp/test/_test_bash.sh"
# map_batch_replace_in_file "$src_file" "$array_string"

# sed -n '12,24p' example.txt        # print line 12 to 24
# sed -n '12;24p' example.txt        # print line 12 and 24

# sed -i -E "${lineNo}s#(.*)${str_escaped}#\1${new_str_escaped}#" file
# . ^ $ * + ? ( ) [ ] { } | \ /
# str_escaped=$(escape_sed_regex "$str")
function escape_sed_regex() {
  echo "$1" | sed -E 's/[]\/$*.^|[]/\\&/g'
}

# & <split_char , e.g. / #>
# new_str_escaped=$(escape_sed_replacement "$new_str")
function escape_sed_replacement() {
  echo "$1" | sed -e 's/[&/\]/\\&/g'
}

function choose_sed_delim() {
    local pat="$1"
    local rep="$2"
    local delim="!"
    if [[ "$pat" == *"!"* || "$rep" == *"!"* ]]; then
        delim="@"
    fi
    if [[ "$pat" == *"@"* || "$rep" == *"@"* ]]; then
        delim="|"
    fi
    echo "$delim"
}

function updateFile_replace_string() {
    local filename=$1
    local regularFmt=$2
    local replaced_string=$3
    local delim=$(choose_sed_delim "$regularFmt" "$replaced_string")
    sed -i "s${delim}${regularFmt}${delim}${replaced_string}${delim}g" "$filename"
}

function updateFile_replace_Nth_line() {
    local filename=$1
    local line_number=$2
    local replaced_string=$3
    sed -i "${line_number}s/^.*$/$replaced_string/" "$filename"
}

function updateFile_delete_line() {
    local filename=$1
    local line_string=$2

    # Use sed to delete the line containing the string.
    sed -i "!$line_string!d" "$filename"
}

function updateFile_delete_Nth_line() {
    local filename=$1
    local line_number=$2
    sed -i "${line_number}d" "$filename"
}

function updateFile_comment_out_whole_line() {
    local filename=$1
    local line_string=$2
    # 将路径中的/替换为\/ : /${line_string}/s/ 场景的分隔符必须是 /
    line_string=${line_string//\//\\/}
    sed -i "/${line_string}/s/^[[:space:]#]*/# /" "$filename"
}

function updateFile_comment_out_Nth_line() {
    local filename=$1
    local line_number=$2
    sed -i "${line_number}s/^[[:space:]]*#*[[:space:]]*/# /" "$filename"
}

function updateFile_uncomment_out_whole_line() {
    local filename=$1
    local line_string=$2
    # 将路径中的/替换为\/ : /${line_string}/s/ 场景的分隔符必须是 /
    line_string=${line_string//\//\\/}
    sed -i "/${line_string}/s/^[[:space:]#]*//" "$filename"
}

function updateFile_uncomment_out_Nth_line() {
    local filename=$1
    local line_number=$2
    sed -i "${line_number}s/^[[:space:]]*#*[[:space:]]*//" "$filename"
}

# updateFile_insert_line_before_line_string ${EXT_DIR}/tmp/test/_test_bash.sh  insert_info_before_line_string "# hello ,fine"
function updateFile_insert_line_before_line_string() {
    local filename=$1
    local line_string=$2
    local insert_text=$3

    # Use sed to insert the text before the line containing the string.
    sed -i "/$line_string/i $insert_text" "$filename"
}

function updateFile_insert_line_after_line_string() {
    local filename=$1
    local line_string=$2
    local insert_text=$3

    # Use sed to insert the text after the line containing the string.
    sed -i "!$line_string!a $insert_text" "$filename"
}

function updateFile_insert_line_before_Nth_line() {
    local filename=$1
    local line_number=$2
    local insert_text=$3

    # Use sed to insert the text before the line number.
    sed -i "${line_number}i $insert_text" "$filename"
}

function updateFile_insert_line_after_Nth_line() {
    local filename=$1
    local line_number=$2
    local insert_text=$3

    # Use sed to insert the text after the line number.
    sed -i "${line_number}a $insert_text" "$filename"
}

# locate_file_path_in_var_paths "ddd.py" "PYTHONPATH"
# locate_file_path_in_var_paths "your_executable" "CUSTOM_VAR"
function locate_file_path_in_var_paths {
    local filename="$1"
    local env_var_name="$2"

    if [[ $# -lt 2 ]]; then
        dumperr "locate_file_path_in_var_paths : paramter is not enough. use which if you want to search in PATH"
        return 1
    fi

    # 获取指定环境变量的值
    local paths="${!env_var_name}"

    # 检查环境变量是否为空
    if [[ -z "$paths" ]]; then
        # echo "Environment variable '$env_var_name' is not set or empty."
        return 2
    fi

    # 将路径分割成数组
    IFS=':' read -r -a path_array <<< "$paths"

    # 检查每个路径
    for path in "${path_array[@]}"; do
        if [[ -f "$path/$filename" ]]; then
            # echo "$filename found at: $path/$filename"
            echo "$path/$filename"
            return 0
        fi
    done

    # echo "$filename not found in $env_var_name"
    return 3
}
alias whichx='locate_file_path_in_var_paths'    # similiar to which command , which only search PATH env var

# get_app_full_path gdb
function get_app_full_path() {
    # dumpinfox "get_app_full_path : $1"
    [[ -z $1 ]] && dumperr "get_app_full_path : input app name is empty" && return
    local app_name=$1
    # local app_full_path=$(which $app_name)
    app_full_path=$(type $app_name 2>/dev/null | grep "aliased to" | sed 's#[^/]*\(/.*\).$#\1#g')
    echo $app_full_path
}

# add a new path into env var
# add_path_to_env_var   ${BASH_DIR}/bin    PATH
# better way : type nvcc &>/dev/null || { PATH=${CUDA_PATH}/bin:$PATH; LIBRARY_PATH=${CUDA_PATH}/lib:$LIBRARY_PATH; }
function add_path_to_env_var() {    
    local path_to_add="$1"
    local env_var_name="${2:-"PATH"}"

    # 检查路径是否存在
    if [ ! -e "$path_to_add" ]; then
        dumperr "not existed path: $path_to_add"
        return
    fi
    
    # 获取环境变量的值
    local env_var_value="${!env_var_name}"

    # 检查路径是否已经存在于环境变量中
    if [[ ":$env_var_value:" != *":$path_to_add:"* ]]; then
        if [[ -n "$env_var_value" ]]; then
            # 如果环境变量不为空，则添加路径到现有值
            export "$env_var_name"="$path_to_add:$env_var_value"
        else
            # 如果环境变量为空，则直接赋值
            export "$env_var_name"="$path_to_add"
        fi
        
        # dumpkey "Done to add $path_to_add to $env_var_name "
    else
        debugkey "var $env_var_name has included $path_to_add"
    fi
}
alias add_path_2_env=add_path_to_env_var

# remove_repeated_or_invalid_path_from_env_var  PATH 
function remove_repeated_or_invalid_path_from_env_var() {
    local env_var_name="$1"
    
    # Get the value of the specified environment variable
    local paths="${!env_var_name}"
    
    # Use an array to store unique paths
    IFS=: read -ra path_array <<< "$paths"
    local unique_paths=()

    for p in "${path_array[@]}"; do
        # Check if the path is valid
        if [[ -d "$p" ]]; then
            if [[ ! " ${unique_paths[*]} " =~ " $p " ]]; then
                unique_paths+=("$p")  # Add unique path
            fi
        else
            [[ -n $p ]] && dumpinfo "${red}Invalid path :${brown} '$p'"  # this usage will trigger error handler
            # dumpinfo "${env_var_name} : ${paths}"
        fi
    done

    # Reconstruct the unique paths string from valid paths
    local new_paths=$(IFS=:; echo "${unique_paths[*]}")
    
    # Replace multiple colons with a single colon and remove trailing colons using sed
    new_paths=$(echo "$new_paths" | sed -E 's/:+/:/g; s/:$//')

    # Check if new_paths is different from the original paths to determine if an update is needed
    if [[ "$paths" != "$new_paths" ]]; then
        eval "$env_var_name=\"$new_paths\""
        export "$env_var_name"   # Update the environment variable
        dumpinfox "Updated '$env_var_name' due to :  valid paths or repeated path or multiple :: or : on value tail."
        dumpkey2 "${env_var_name}" "$new_paths"
    # else
    #     debuginfo "No invalid or duplicated paths found."
    fi
}
alias clean_path=remove_repeated_or_invalid_path_from_env_var

# remove_app_search_path  gdb
function remove_app_search_path() {
    # 获取应用程序名称
    local app_name="$1"

    # get the full path of the application
    # app_path=$(type -p "$app_name" | sed 's/.* //')
    app_path=$(type $app_name | sed 's#[^/]*\(/.*\).$#\1#g')
    # dumpkey app_path
    # dumpkey PATH

    # if the application is found in PATH
    if [[ -n "$app_path" ]]; then
        # get the directory path of the application
        local dir_path
        dir_path=$(dirname "$app_path")

        # remove the directory path from PATH
        local new_path=""
        IFS=: read -ra path_array <<< "$PATH"
        for path in "${path_array[@]}"; do
            if [[ "$path" != "$dir_path" ]]; then
                new_path="${new_path:+$new_path:}$path"
            fi
        done

        # update the PATH environment variable
        PATH="$new_path"
        export PATH="$PATH"
        dumpinfox "Removed $dir_path from PATH."
        # dumpkey PATH
    else
        debuginfo "Application '$app_name' not found in PATH."
    fi
}

# remove_invalid_char_in_path ".*cutlass3x_sm100_sparse_compression.*.*"
function remove_invalid_char_in_path() {
    local input_path="$1"
    local valid_path="${input_path//[^a-zA-Z0-9\/_.-]/}"
    valid_path="${valid_path/#\./}"
    valid_path="${valid_path/%\./}"
    valid_path="${valid_path%%.*}"
    valid_path="${valid_path//\/\//\/}"
    echo "$valid_path"
}

function list_function_in_script_file() {
    local filename=$1
    [[ ! -f "$filename" ]] && dumperr "file not existed : $filename" && return 1

    # Use grep to list all function definitions in the script file
    dumpinfo "[${FUNCNAME[0]}]${green}Functions in ${brown}$filename :"
    # egrep --color=always "^ *function +[a-zA-Z_][a-zA-Z0-9_]+" "$filename" | sed 's/^[ \t]*//'
    grep -EniH --color=always "^ *function +\w+|^ *alias +\w+\b" "$filename" | sed 's/^[ \t]*//' | sed 's#:#  #2' | align_2_max_legth
    # dumpinfo "[${FUNCNAME[0]}] ${green}Functions in ${brown}$filename :"
}

function show_app_usage() {
  dumpcmdline
  # $(\type $1 | head -n 1  | grep -oP "/[^']+")
  local cmd_name=${1##*/}
  cmd_name="${cmd_name%.*}"
  echo -e "${green}built-in cmd '${brown}help${green}' is available to show built-in cmds.${end}"
  if [[ "$1" != "" ]] ; then
    local tmp_file_path=${EXT_DIR}/myReference/note/help_usage/temp/${cmd_name}_help.txt
    (
      command type -a  $1
      echo " "
      echo "$1 usage :"
      $1 --help
    ) >| ${tmp_file_path}
    find -L ${EXT_DIR}/myReference/note/help_usage/temp/ -maxdepth 1 -type f  -print  | sort -n | sed "s#${tmp_file_path}#${s_red}${tmp_file_path}${s_end}#g"
    [[ -f "${tmp_file_path}" ]] && codeopen ${tmp_file_path}
  else
    dumperr "parameter can't be empty."
  fi
}
alias usage=show_app_usage

function cp_file_template() {
    target_path=${1:-"test_$RANDOM"}
    [[ "$target_path" != *"/"* ]] && target_path=$(pwd -L)/${target_path}
    local target_dir=$(command dirname $target_path)
    [[ ! -d "$target_dir" ]] && mkdir -p "$target_dir"

    local file_template=$2
    if [[ ! -f "$file_template" ]] ; then
        touch  ${target_path}
        dumpinfo "create new file : ${coral_256} ${target_path}"
    else
        local ext_name=${2:+.${file_template##*.}}    
        # process exception : ${BASH_DIR}/app/git/build_local_git
        target_path=${target_path%/*}/$(echo ${target_path##*/} | sed 's#\..*##g' )${ext_name}
        [[ -f $file_template ]] && cp  $file_template  ${target_path}
        dumpinfo "${file_template}${end}  => ${coral_256} ${target_path}"
    fi
    
    # /bin/ls -Artd ${target_dir}/* | tail -n 1 ;     
    [[ -f $target_path ]] && { codeopen "$target_path" ; } || { dumperr "file not existed : $target_path" ; }
}

function cpany()    { cp_file_template $1                                                       ; }
function cpsh()     { cp_file_template $1 ${BASH_DIR}/test/_template.sh    ; sed -i "s#main#main_$(basename "${1%.*}")#g" $target_path ;}
function cpcsh()    { cp_file_template $1 ${HOME}/bash_env/test/_template.csh            ; }
function cptmp()    { code --goto ${TEMP_DIR}/del/temp_file.txt                                ; }

alias   ienv='source ${BASH_DIR}/app/info/info_devlop_env.sh'
alias   idev=ienv
alias   isys='source ${BASH_DIR}/app/info/info_system.sh ;'
alias   systeminfo=isys
function imod()     {  source  ${BASH_DIR}/app/info/info_of_known_path_module.sh         "$1" ;  }             # dump symbol & module info
alias   lpath=find_module_path                                                                                        
alias   epath='env | grep --color=auto  -i "path"'                                                          # search path setting in environment variable

# du -rsc *xxx*
function   isizex() { du -hcl --max-depth=$1  . | sort -rn ; echo -e "${green}only show special files size :${brown} du -rsc *xxx* ${end}" ; }
alias   isize='isizex 1'
alias   isize2='isizex 2'

function   download_file()      {  source ${BASH_DIR}/bin/download/download.sh   "$@"           ; }     # download from url
alias      dl=download_file

function unpack()      {  source ${BASH_DIR}/bin/unpack.sh   "$@"             ; }
function pack()        {  source ${BASH_DIR}/bin/packFolder.sh   "$@"         ; }

# read_variable <src_var> <dst_var> [default_ini_path]
function read_variable() {
    unset $1
    default_ini_path=${3:-"${EXT_DIR}/myDepency/ini_input/default.ini"}
    # export $2=$(cat ${default_ini_path} | grep -v '^# ' | grep -oP "(?<=$1=).*")
    export $2=$(grep -m 1 -oP "^\s*(?!#)\s*$1=\K.*" "${default_ini_path}")
    echo -e "# ${color_gen}export ${color_key}${2}${end} = ${color_value}${!2}${end}      [ ${cyan}read ${green}$1 ${end}from ${default_ini_path} ]"
}

# write_variable <var_name> <var_value> [default_ini_path]
function write_variable() {
    default_ini_path=${3:-"${EXT_DIR}/myDepency/ini_input/default.ini"}
    # grep -cP "^$1="  ${default_ini_path}  &> /dev/null  &&  sed -i -- "s#^$1=.*#$1=$2#" ${default_ini_path} || echo "$1=$2"  >> ${default_ini_path}
    grep -cP "^\s*(?!#)\s*$1="  ${default_ini_path}  &> /dev/null  &&  sed -i -- "s#^$1=.*#$1=$2#" ${default_ini_path} || echo "$1=$2"  >> ${default_ini_path}
    echo "# ${color_gen}export ${color_key}$1${end} = ${color_value}$2${end}      [ ${cyan}update${green} $1 ${end}to ${default_ini_path} ]"
}

function readvar()     {  read_variable      "$@"                          ; }
function readvarx()    {  read_variable      "$@" ; dump_position_caller   ; }
function writevar()    {  write_variable     "$@"                          ; }
function writevarx()   {  write_variable     "$@" ; dump_position_caller   ; }

# control terminal output text style , color range : [1-7]
# https://tldp.org/HOWTO/Bash-Prompt-HOWTO/x405.html
function dump_link     {  tput smul; tput setaf ${2:-2}; echo "$1" ; tput sgr0                  ; }

function check_folder_exist {
  if [[ ! -d "$1" ]] ; then
    echo "${red}folder '${brown}$1${red}' not existed ${end}"
    kill -INT $$
  fi
}

function check_file_exist {
  if [[ ! -f "$1" ]] ; then
    echo "${red}file '${brown}$1${red}' not existed ${end}"
    kill -INT $$
  fi
}

# rsync -r -v --progress -e ssh --verbose  user@remote:/path/to/source      /path/to/destination
# rsync -r -v --progress -e ssh --verbose  /path/to/source                  user@remote:/path/to/destination
# need the ssh can login the remote machine
function copy_folder_files_and_show_process_between_hosts()     {  rsync -r -v --progress -e ssh  "$@"      ; }
function vscode_open_newest_text_file_by_ls()     { codeopen $(/bin/ls -t $1 | xargs file -i | grep "text/plain" | head -n 1 | cut -d: -f1)                         ; }
function vscode_open_newest_text_file_by_find()   { codeopen $(find $1 -maxdepth 1 -type f -exec file {} \; | grep "text" | cut -d: -f1 | xargs ls -t | head -n 1)  ; }

alias ofl='  vscode_open_newest_text_file_by_ls   $(pwd -L)'     # open last text file  in current folder
alias ofl2=' vscode_open_newest_text_file_by_find $(pwd -L) '    # open last text file  in current folder

alias osh="vscode_add_folder ${BASH_DIR}/"
alias ocsh="vscode_add_folder ${EXT_DIR}/bash_env/"

alias cdroot="cd ${EXT_DIR} ; list_dir_with_reversed_index ;"
alias cdsh="cd ${BASH_DIR} ; list_dir_with_reversed_index ;"
alias cdcsh="cd ${EXT_DIR}/csh_env ; list_dir_with_reversed_index ;"

# generate_cpp_source_from_td_file ${EXT_DIR}/repo/dkg_root/dkg_debug_dkg/collective_ir/include/collective_ir/Dialect/Collective/IR/CollectiveDialect.td
function load_cmd_and_generate_log(){
    # ${BASH_DIR}/init/log_source_script.sh
    [[ $# -lt 1 ]] && { dumperr "Usage: load_cmd <cmd>" ; return 1 ; }
    [[ -d ./cmds ]] && { local tmp_log_dir=$(pwd -L)/local_logs ;} || { local tmp_log_dir="${TEMP_DIR}/to_del/script_log" ; }
    [[ ! -d ${tmp_log_dir} ]] && mkdir -p ${tmp_log_dir}
    local cmd_log=${tmp_log_dir}/$(basename ${1})_$(date "+%Y%m%d_%H%M").log
    dumpkey cmd_log
    {
        date +"%Y/%m/%d %T"
        echo run on ${envMode} : $(hostname)
        echo "raw cmd : load ${@}"
        echo "pwd : $(pwd -L)"
        echo "----------------------------------------------------------------------------------------------------- "
        echo
    } >| ${cmd_log}

    dumpcmd "${@:1}"
    if [[ -f $1 ]] ; then
        source ${@:1}  2>&1 | tee -a ${cmd_log}
    else        
        ${@:1}  2>&1 | tee -a ${cmd_log}
    fi
    echo
    dumpinfo "log file :${red} ${cmd_log}"
    source ${BASH_DIR}/nvidia/bin/remove_color_from_log_file.sh ${cmd_log} > /dev/null
}
alias load='load_cmd_and_generate_log'
# function load()      {  source ${BASH_DIR}/init/log_source_script.sh   "$@"                             ; }
# function loadrun()   {  source ${BASH_DIR}/nvidia/run_test/run_test_cmd_line_set_tester.sh   "$@"       ; }
# function loadbd()    {  source ${BASH_DIR}/nvidia/build/buildkit/build_checker.sh   "$@"                ; }

function goto_newest_folder()               { cd $(/bin/ls -td -- ${1:-$(pwd -L)}/*/ | head -n ${2:-1}  | tail -n 1 ) ; }
function goto_sub_folder_by_index_or_name()  { 
                                                [[ $2 ]] && dumpinfo "$(get_current_function_name) $*"
                                                tmp_dir=$(get_folder_name_by_index $1) ; 
                                                echo cd "${tmp_dir}" ; 
                                                cd "${tmp_dir}" ;
                                                ll ;
                                                # alias_and_function.sh is loaded before alias_job.sh
                                                [[ -f ./cur_job/alias_task.sh ]] && load_build_foler
                                                # is_function_defined load_build_foler && [[ -f "./cmds/_1_cmake.sh" ]] && load_build_foler
                                             }

alias   cds=goto_sub_folder_by_index_or_name            # change directory to sub folder by index or name
alias   cdp='cd $(pwd -P)'                              # cd to physical path

function cpc()       { cp       "$1"    ./            ; }           # copy file to current folder 
function cpf()       { cp -rf   "$1"    ${2:-"./"}    ; }           # copy folder 

alias       al='alias'
alias       h='history'
alias       pause='echo "press any key to continue" ; read'
alias       exit_script='${brown}kill current script process automatically without exit session.${end} ; echo ; kill -INT $$ ; '
alias       mklink='ln -s '
alias       quit='exit'
alias       epath='env | grep --color=auto  -i "path"'                                          # search path setting in environment variable
function    print_file_full_path() { 
            local tmp_file_path=${2:-$(pwd -L)}/$1  ; 
            [[ -f ${tmp_file_path%:*} ]] && { codeopen $tmp_file_path ; }  || { dumpinfox "file not existed :${brown} $tmp_file_path" ; }
    }                              # print_relate_path
alias       pf=print_file_full_path
alias       mktmpx='mktemp -d ${TEMP_DIR}/XXXXXXXXXX'

alias       clean='source ${BASH_DIR}/bin/clean_system.sh  '               # sync to clean folder
alias       cls='clear'
# alias       cls='reset'         # reset is powerful than clear , but it will clear all history and slow

alias bashvar='source ${BASH_DIR}/test/all_builtin_internal_variable.sh 1 2 3 4'

function timeout()   {
  read -t $1 -p "continue auto after $1 second " || false
}

function re_create_existing_folder()  {                                                                               # re-create current folder path
  cd ${HOME}
  [[ -d "$1" ]] && delete_folder "$1"
  mkdir -p "$1"
  cd -    
  }
function re_create_cur_folder()  { tmp=`pwd -L` ; cd .. ; delete_folder "$tmp" ; mkdir "${tmp}" ; cd "${tmp}" ; list_dir_with_reversed_index   ; }    # re-create current folder path 
   
function delete_folder()         {  source ${BASH_DIR}/bin/del_big_folder_async.sh "$1"            ; } 
function delete_folder_force()   {  source ${BASH_DIR}/bin/del_big_folder_async.sh "$1" "--force"  ; }
function delete_file()           {  source ${BASH_DIR}/bin/delete_file_safe.sh "$1"                ; }
function rename_cur_folder()     {  tmp=`pwd -L` ; cd .. ; mv "$tmp" "$1" ; cd "$1"                                     ; }   # rename current folder

# chmod 755 <to_del_folder>     # resolve : cannot remove 'desktop.ini': Permission denied
# rm -rf    <to_del_folder>

alias tmpfile='echo ${TEMP_DIR}/to_del/temp_$RANDOM.log'
alias rd='delete_folder'
alias rdf='delete_folder_force'
alias rdc='rd "$(pwd)" ; list_dir_with_reversed_index ;'                                                   # delete current folder 
alias md='mkdir -p'
alias mdc=re_create_cur_folder 
alias rmd=re_create_existing_folder                                                                        # delete everything in current folder 
alias mvc=rename_cur_folder
alias del=delete_file
function remove_color_from_log_file() { sed -i 's#\x1B\[[0-9;]*[a-zA-Z]##g' "$1" ; }                       # remove color from log file
alias rmcolor=remove_color_from_log_file
# alias     rm='/usr/bin/rm'

alias genkey='source ${BASH_DIR}/app/ssh/addSSHKeyWithoutPwd.sh'                         # generate ssh key without password
alias ilog='find ${HOME} -maxdepth 1 -type f  -iname "*history"  -print'


bash_script_o
