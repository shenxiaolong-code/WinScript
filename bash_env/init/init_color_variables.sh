# alias   echo='command echo -e'

if [[ "${black}" == "" || "$1" != "" ]] ; then
bash_script_i
# http://www.andrewnoske.com/wiki/Bash_-_adding_color
# use tput to change terminal echo output color : e.g. :  tput smul; echo "underlined"; tput setaf 1; echo "underlined & red"
# https://blog.csdn.net/wocjj/article/details/7474965

# 
# # 使用 \e
# echo -e "\e[31mThis is red text\e[0m"
# 
# # 使用 \033
# echo -e "\033[32mThis is green text\033[0m"
# 
# # 使用 \x1B
# echo -e "\x1B[34mThis is blue text\x1B[0m"

#  $'\e[30m' 比 '\e[30m' 更好，因为它更为安全和可靠， 它是Bash 的 ANSI C 字符串语法，它会将 \e 转换为实际的转义字符（ESC），确保颜色代码被正确解析和应用
# 直接使用 \e 可能会在某些 Bash 版本或终端中表现不一致
#  export           	   black='\e[0;30m'
#  export           	   black=$'\e[0;30m'


# 38;5  : 256 color mode,    usage : \x1b[38;5;idxm      , e.g. : \x1b[38;5;165mhello\x1b[0m
# 38;2  : 24-bit color mode, usage : \x1b[38;2;R;G;B;m   , e.g. : \x1b[38;2;255;0;0m红色\x1b[0m    
# colorRGB has higher priority than colorN , 16,777,216 colors > 256 colors

# define [0-255] digital color
function colorN() {
    printf '\x1b[38;5;%dm' "$1"
}
function colorRGB() {
    printf '\x1b[38;2;%d;%d;%dm' "${1:-255}" "${2:-255}" "${3:-255}"
}

# 基础颜色
export                 reset=$'\e[K'
export                   end=$'\e[0;0m'
export                 end_L=$'\e[1;0m'

# 基础8色及其高亮版本
export                 black=$'\e[0;30m'
export               black_L=$'\e[1;30m'

export                   red=$'\e[0;31m'
export                 red_L=$'\e[1;31m'

export                 green=$'\e[0;32m'
export               green_L=$'\e[1;32m'

export                 brown=$'\e[0;33m'
export               brown_L=$'\e[1;33m'

export                  blue=$'\e[0;34m'
export                blue_L=$'\e[1;34m'

export                purple=$'\e[0;35m'
export              purple_L=$'\e[1;35m'

export                  cyan=$'\e[0;36m'
export                cyan_L=$'\e[1;36m'

export                  gray=$'\e[0;37m'
export                gray_L=$'\e[1;37m'

# 256色系列
export              green_256=$'\e[38;5;34m'    # 深绿色
export               lime_256=$'\e[38;5;118m'   # 浅绿色
export                sky_256=$'\e[38;5;117m'   # 天蓝色
export              azure_256=$'\e[38;5;45m'    # 湖蓝色
export               pink_256=$'\e[38;5;205m'   # 粉红色
export             purple_256=$'\e[38;5;135m'   # 紫色
export              coral_256=$'\e[38;5;209m'   # 珊瑚色
export               gold_256=$'\e[38;5;220m'   # 金色
export             orange_256=$'\e[38;5;208m'   # 橙色
export               rust_256=$'\e[38;5;166m'   # 锈红色

# 24位真彩色系列
export            orange_24=$'\e[38;2;255;165;0m'     # 标准橙色
export         turquoise_24=$'\e[38;2;64;224;208m'    # 绿松石色
export           crimson_24=$'\e[38;2;220;20;60m'     # 深红色
export         steelblue_24=$'\e[38;2;70;130;180m'    # 钢青色
export            tomato_24=$'\e[38;2;255;99;71m'     # 番茄红
export         darkgreen_24=$'\e[38;2;0;100;0m'       # 深绿色
export          seagreen_24=$'\e[38;2;46;139;87m'     # 海绿色
export         royalblue_24=$'\e[38;2;65;105;225m'    # 皇家蓝
export           magenta_24=$'\e[38;2;255;0;255m'     # 品红色
export        darkviolet_24=$'\e[38;2;148;0;211m'     # 深紫色

# 常用组合
export           color_error="${crimson_24}"
export             color_key="${gold_256}"
export           color_value="${azure_256}"
export             color_gen="${seagreen_24}"

: '
more color value : 
https://gist.github.com/raghav4/48716264a0f426cf95e4342c21ada8e7
https://talyian.github.io/ansicolors/
'
bash_script_o
fi

function list_all_256_color() {
    # 显示256色
    echo 'echo -e "256色显示:\\x1b[38;5;165mhello\\x1b[0m"'
    echo -e "256色显示:\x1b[38;5;165mhello\x1b[0m"
    for i in {0..255}; do 
        printf "\x1b[38;5;${i}mcolor %-3d\x1b[0m " $i
        if [ $((($i + 1) % 8)) -eq 0 ]; then 
            echo ""
        fi
    done
        
    # 显示真彩色示例
    echo -e "\n\n真彩色示例:"
    dumpinfox "use colorRGB to show color"
    echo -e "$(colorRGB)default color(colorRGB)\x1b[0m"
    # 基本颜色
    echo -e "$(colorRGB 255 0 0 )红色(colorRGB 255 0 0 )\x1b[0m      $(colorRGB 0 255 0 )绿色(colorRGB 0 255 0 )\x1b[0m      $(colorRGB 0 0 255 )蓝色(colorRGB 0 0 255 )\x1b[0m"
    # 混合颜色
    echo -e "$(colorRGB 255 165 0 )橙色(colorRGB 255 165 0 )\x1b[0m    $(colorRGB 128 0 128 )紫色(colorRGB 128 0 128 )\x1b[0m    $(colorRGB 255 192 203 )粉色(colorRGB 255 192 203 )\x1b[0m"
    # 更多颜色
    echo -e "$(colorRGB 255 255 0 )黄色(colorRGB 255 255 0 )\x1b[0m    $(colorRGB 0 255 255 )青色(colorRGB 0 255 255 )\x1b[0m    $(colorRGB 255 0 255 )品红(colorRGB 255 0 255 )\x1b[0m"
    # 灰度
    echo -e "$(colorRGB 128 128 128 )灰色(colorRGB 128 128 128 )\x1b[0m  $(colorRGB 192 192 192 )浅灰(colorRGB 192 192 192 )\x1b[0m  $(colorRGB 64 64 64 )深灰(colorRGB 64 64 64 )\x1b[0m"
    # 其他常用颜色
    echo -e "$(colorRGB 139 69 19 )棕色(colorRGB 139 69 19 )\x1b[0m    $(colorRGB 0 128 0 )深绿(colorRGB 0 128 0 )\x1b[0m      $(colorRGB 0 0 128 )深蓝(colorRGB 0 0 128 )\x1b[0m"

    dumpinfox "use colorN [0-255] to show color"
    echo "$(colorN 165)colorN 165${end}"
    echo "$(colorN 165)colorN 165 $(colorN 208)colorN 208${end}"
    printf "%s%s%s\n" "$(colorN 165)" "colorN 165" "${end}"
}

# 显示颜色代码的辅助函数已定义在 alias_color.sh 中
# show_color_asc_code() {
#     printf "${!1}%18s${end} : %-24s\n" "$1" "$(echo "${!1}" | cat -A | sed 's#..#\\e#' | sed 's#.$##')"
# }

function test_color() {
    echo -e "=== 256色系列 ==="
    show_color_asc_code green_256
    show_color_asc_code lime_256
    show_color_asc_code sky_256
    show_color_asc_code azure_256
    show_color_asc_code pink_256
    show_color_asc_code purple_256
    show_color_asc_code coral_256
    show_color_asc_code gold_256
    show_color_asc_code orange_256
    show_color_asc_code rust_256
    
    echo -e "\n=== 24位真彩色系列 ==="
    show_color_asc_code orange_24
    show_color_asc_code turquoise_24
    show_color_asc_code crimson_24
    show_color_asc_code steelblue_24
    show_color_asc_code tomato_24
    show_color_asc_code darkgreen_24
    show_color_asc_code seagreen_24
    show_color_asc_code royalblue_24
    show_color_asc_code magenta_24
    show_color_asc_code darkviolet_24
    
    echo -e "\n=== 基础颜色系列及其高亮版本 ==="
    show_color_asc_code black
    show_color_asc_code black_L
    
    show_color_asc_code red
    show_color_asc_code red_L
    
    show_color_asc_code green
    show_color_asc_code green_L
    
    show_color_asc_code brown
    show_color_asc_code brown_L
    
    show_color_asc_code blue
    show_color_asc_code blue_L
    
    show_color_asc_code purple
    show_color_asc_code purple_L
    
    show_color_asc_code cyan
    show_color_asc_code cyan_L
    
    show_color_asc_code gray
    show_color_asc_code gray_L
    
    echo -e "\n=== 控制序列 ==="
    show_color_asc_code end
    show_color_asc_code end_L
    show_color_asc_code reset
    
    echo -e "\n=== 常用组合 ==="
    show_color_asc_code color_error
    show_color_asc_code color_key
    show_color_asc_code color_value
    show_color_asc_code color_gen
    echo
}

if [[ "$1" == "showTest" ]] ; then
    bash_script_i
    echo
    list_all_256_color
    echo
    test_color
    
    echo "=== 颜色组合示例 ==="
    echo -e "normal : ${black}00000${red}11111${green}22222${brown}33333${blue}44444${purple}55555${cyan}66666${gray}77777${end}"
    echo -e "light  : ${black_L}00000${red_L}11111${green_L}22222${brown_L}33333${blue_L}44444${purple_L}55555${cyan_L}66666${gray_L}77777${end_L}"
    
    echo -e "\n=== 256色组合示例 ==="
    echo '${green_256} ${lime_256} ${sky_256} ${azure_256} ${pink_256} ${purple_256} ${coral_256} ${gold_256} ${end}'
    echo -e "${green_256}深绿 ${lime_256}浅绿 ${sky_256}天蓝 ${azure_256}湖蓝 ${pink_256}粉红 ${purple_256}紫色 ${coral_256}珊瑚 ${gold_256}金色 ${end}"
    
    echo -e "\n=== 24位真彩色组合示例 ==="
    echo '${orange_24} ${turquoise_24} ${crimson_24} ${steelblue_24} ${tomato_24} ${darkgreen_24} ${seagreen_24} ${royalblue_24} ${end}'
    echo -e "${orange_24}橙色 ${turquoise_24}绿松石 ${crimson_24}深红 ${steelblue_24}钢青 ${tomato_24}番茄 ${darkgreen_24}深绿 ${seagreen_24}海绿 ${royalblue_24}皇蓝 ${end}"
    
    echo -e "\n=== 实用示例 ==="
    echo 'echo -e "[${color_error}error${end}] set ${color_key}key${end}=${color_value}value${end}"'
    echo -e "[${color_error}error${end}] set ${color_key}key${end}=${color_value}value${end}"
    
    # echo 'printf "%-20s: ${red}%-10s${end} ${green}%-10s${end} ${blue}%-10s${end}\n" "align test" "red" "green" "blue"'
    # printf "%-20s: ${red}%-10s${end} ${green}%-10s${end} ${blue}%-10s${end}\n" "align test" "red" "green" "blue"
    echo -e "\n=== hardcode 颜色 ==="
    echo 'command echo -e "# loading \e[0;34m${BASH_SOURCE[0]}:$LINENO \e[0;0m ..."'
    command echo -e "# loading \e[0;34m${BASH_SOURCE[0]}:$LINENO \e[0;0m ..."
    echo 'printf "\e[0;32m%-13s: \e[0;35m%-32s \e[0;0m<= \e[0;33m%s \e[0;0m\n" "link file"   p1  p2'
    printf "\e[0;32m%-13s: \e[0;35m%-32s \e[0;0m<= \e[0;33m%s \e[0;0m\n" "link file"   p1  p2
    
    echo
    echo "${BASH_SOURCE[0]}:$LINENO"
    bash_script_o
fi
