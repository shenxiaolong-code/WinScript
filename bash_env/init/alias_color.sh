#!/bin/bash

bash_script_i
# echo 'grep -oPnH -m 1 --color=always "color_error" ${BASH_SOURCE[0]} | cat -A          # 使用 cat -A 查看特殊字符, 比如颜色字符代码, 用于调试目的 , e.g.  echo -e "\x1B\[35m" | cat -A  ' 

# 在处理 ANSI 转义序列时，常见的转义方式有三种：\e、\033 和 \x1B。它们都代表相同的 ESC 字符（ASCII 码 27）
# test : [[ $red == $s_red ]] && echo "red is equal to s_red" || echo "red is not equal to s_red"
# $'\x1B[32m'           <==>      $'\e[32m'
#  '\x1B[32m'           !=         '\e[32m'             
#  注意 \e 和 \x1B 的默认颜色是不同的，\x1B 默认是亮色，\e 默认是暗色
#  \x1B[32m    <==> \x1B[1;32m
#    \e[32m    <==>   \e[0;32m
# 所以定义颜色变量时，使用 s_green=$'...' 的方式，而不是 s_green='...' 的方式可以保证更好的兼容性，而且不再需要区分 sed 和 echo 的转义方式 : 
# echo -e "\e[32m"                  # echo need \e
# ... | sed "s#^#\x1B\[32m#g"       # sed need \x1B

# 当使用 s_green=$'...' + 明确的亮暗色  的方式时，下面两个文件可以合并为一个文件： (不使用缺省值 , 因为两者的缺省值刚好相反) 
# ${BASH_DIR}/init/init_color_variables.sh
# ${BASH_DIR}/init/init_color_variables_sed.sh

# 但在不同的上下文和编程语言中使用时，可能会有不同的适用性和兼容性。
# \e        文字表示	    在 Bash 和某些其他 shell 中常用，表示 ESC 字符。
# \033	    八进制表示	    表示 ASCII 码 27 的八进制形式，广泛支持于多种编程语言。
# \x1B	    十六进制表示	表示 ASCII 码 27 的十六进制形式，通常在 C 和 Python 等语言中使用。
# 建议用法 ： 如果遇到颜色不能显示的问题，可以尝试在 \033  \x1B  \e  之间切换，以找到支持的转义方式。

alias   color='   source ${BASH_DIR}/init/init_color_variables.sh                   "showTest" '
alias   colorsed='source ${BASH_DIR}/init/init_color_variables_sed.sh               "showTest" '
alias   colorpy=' python ${EXT_DIR}/repo/linux_pratice/linuxRepo/python_pratice/utils/print_python_color.py  "showTest" '

# export  GREP_COLOR='0;32'   # set grep filter output color (not include the path color) : 0;32 : green

# show_color_asc_code sed
# show_color_asc_code sed_L
# ${BASH_DIR}/init/init_color_variables.sh:71
function show_color_asc_code() {
    printf "${!1}%18s${end} : %-24s\n"  $1  $(echo ${!1} | cat -A | sed 's#..#\\e#' | sed 's#.$##')
    # echo -n "${!1}$1${end}    \t\t : "
    # ^[[1;31m$
    # echo ${!1} | cat -A | sed 's#..#\\e#' | sed 's#.$##'
}

# show_color_asc_code_sed   s_sed
# show_color_asc_code_sed   s_sed_L
# ${BASH_DIR}/init/init_color_variables_sed.sh:46
function show_color_asc_code_sed() {
    # printf "${!1}%18s${end} : %-24s\n"  $1  $(echo ${!1} | cat -A | sed 's#..#\\x1B#' | sed 's#.$##')
    printf "${!1}%18s${s_end} : %-24s\n" "$1" "$(echo "${!1}" | cat -A | sed 's#..#\\x1B#' | sed 's#.$##')"
    # echo -n "${!1}$1${end}    \t\t : "
    # ^[[1;31m$
    # echo ${!1} | cat -A | sed 's#..#\\e#' | sed 's#.$##'
}

# get_color_code purple
# get_color_code s_purple
function get_color_code() {
    local color_code="${!1}"
    echo -e "${color_code}" | grep -oP "(?<=\x1B\[)[0-9;]+|(?<=\033\[)[0-9;]+|(?<=\\e\[)[0-9;]+"        # \\e  \033  \x1B
}

# echo -e "this is ${purple} color ${end} text"
# echo -e "this is ${purple} color ${end} text" | replace_color_code purple 
# echo -e "this is ${purple} color ${end} text" | replace_color_code purple blue
function replace_color_code() {
    local old_color_code="$(get_color_code $1 )"
    local new_color_code=0
    [[ -n $2 ]] && new_color_code="$(get_color_code $2 )"
    [[ -z $old_color_code || -z $new_color_code ]] && { dumperr "empty color code" ;  return 1 ;}
    sed "s#\[${old_color_code}m#\[${new_color_code}m#g"
    # sed "s/\x1B\[35m/\x1B\[0m/g"                                  # purple => default
    # view the color code : echo -e "\x1B\[35m" | cat -A
    # cat -A
}

# echo -e "this is ${green} color ${end} text" 
# echo -e "this is ${green} color ${end} text" | view_escape_chars
# echo -e "this is ${green} color ${end} text" | view_escape_chars | convert_color_sequence_hardcode
# echo "^[[0;32m" | convert_color_sequence_hardcode
function convert_color_sequence_hardcode() {
    # ^[[0;32m      =>     \x1B\[0;32m
    sed 's#\^\[\[#\\x1B\\\[#g'
}

# echo $(pwd -L) | grep --color=always -P ".*" 
# echo $(pwd -L) | grep --color=always -P ".*" | view_escape_chars 
# echo $(pwd -L) | grep --color=always -P ".*" | view_escape_chars | convert_color_sequence_hardcode
# echo $(pwd -L) | grep --color=always -P ".*" | replace_color_code_hardcode "\x1B\[01;31m\x1B\[K"  green
function view_escape_chars_color() {
    # ${red}      =>     \x1B\[0;32m
    view_escape_chars | convert_color_sequence_hardcode
}

# echo -e "this is \x1B\[01;31m\x1B\[K color ${end} text" | replace_color_code_hardcode "\x1B\[01;31m\x1B\[K"  purple
# query the hardcode sequence by convert_color_sequence_hardcode
function replace_color_code_hardcode() {
    local old_color_code="$1"
    local new_color_code=0
    [[ -n $2 ]] && new_color_code="$(get_color_code $2 )"
    [[ -z $old_color_code || -z $new_color_code ]] && { dumperr "empty color code" ;  return 1 ;}
    sed "s#${old_color_code}#\x1B\[${new_color_code}m#g"
}

# grep -nH 选项的输出例子
# /home/logs/dkg_test_consoleText_20241128_0620.txt:63:https | cat -A
# ^[[35m^[[K/home/logs/dkg_test_consoleText_20241128_0620.txt^[[m^[[K^[[36m^[[K:^[[m^[[K^[[32m^[[K63^[[m^[[K^[[36m^[[K:^[[m^[[K^[[01;31m^[[Khttps:
# ANSI 转义序列 ^[[K 中，^[[ 是表示 ESC 字符的转义序列，而 K 是控制字符，具体含义如下
# ^[：表示 ESC 字符（Escape），在 Bash 中通常用 \e、\033 或 \x1B 表示。
# [：后接的左方括号表示这是一个控制序列引导符（CSI）。
# ^[[m：重置颜色, 相当于 \033[0m 或 \e[0m 或 \x1B[0m
# ^[[K：这是一个控制命令，表示清除行的内容。它不涉及任何颜色设置
#       ESC[0K  ： 从光标当前位置到行尾清除内容。
#       ESC[1K  ： 从行首到光标当前位置清除内容。
#       ESC[2K  ： 清除整行内容。 
#       ESC[[K  ： 表示清除当前行
# 清除 grep -nH 中的颜色序列，就是要清除下面的两个序列 （ 替换成 : ）
# ^[[m^[[K^[[36m^[[K:^[[m^[[K^[[32m^[[K  
# ^[[m^[[K^[[36m^[[K:^[[m^[[K^[[01;31m^[[K
# grep --color=always -nH 'replace_grep_path_color' ${BASH_DIR}/init/alias_color.sh
# grep --color=always -nH 'replace_grep_path_color' ${BASH_DIR}/init/alias_color.sh | replace_grep_path_color
function replace_grep_path_color() {
    replace_color_code purple black | sed -e 's#\x1B\[m\x1B\[K\x1B\[36m\x1B\[K##g'  -e 's#\x1B\[m\x1B\[K\x1B\[32m\x1B\[K##g'  -e "s#\x1B\[m\x1B\[K\x1B\[01;31m\x1B\[K#${s_green}#"
}

# echo -e "${purple}This is purple text${end} and ${blue}this is blue text${end}."
# echo -e "${purple}This is purple text${end} and ${blue}this is blue text${end}." | remove_color_code  purple
function remove_color_code() {
    local color_code="$(get_color_code $1)"

    if [[ -z "$color_code" ]]; then
        dumperr "Invalid color name: $1"
        return 1
    fi

    # 使用 sed 移除指定颜色的 ANSI 转义序列
    sed -r "s/(\x1B\[${color_code}m|\\033\[${color_code}m|\\e\[${color_code}m)//g"
}

# echo -e "${s_red}This is red text${s_end} and ${green}this is green text${end}."
# echo -e "${s_red}This is red text${s_end} and ${green}this is green text${end}." | remove_all_color_code
function remove_all_color_code() {
    # 使用 sed 移除 ANSI 转义序列
    sed -r 's/(\x1B\[[0-9;]*m|\033\[[0-9;]*m|\\e\[[0-9;]*m|\x1B\[[012\[]?K)//g'
}


bash_script_o

