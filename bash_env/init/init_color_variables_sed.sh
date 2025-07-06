# avoid repeated load
if [[ "${s_end}" == ""  || "$1" != "" ]] ; then
bash_script_i
# ref : ${BASH_DIR}/app/vscode/keyboard_binding/process_activeFile.sh

#  $'\x1B[30m' 比 '\x1B[30m' 更好，因为它更为安全和可靠， 它是Bash 的 ANSI C 字符串语法，它会将 \x1B 转换为实际的转义字符（ESC），确保颜色代码被正确解析和应用
# 直接使用 \x1B 可能会在某些 Bash 版本或终端中表现不一致
#  export           	       black='\x1B[0;30m'
#  export           	       black=$'\x1B[0;30m'

# 基础颜色
export                       s_reset=$'\x1B[K'
export                         s_end=$'\x1B[0;0m'
export                       s_end_L=$'\x1B[1;0m'

# 基础8色及其高亮版本
export                       s_black=$'\x1B[0;30m'
export                     s_black_L=$'\x1B[1;30m'

export                         s_red=$'\x1B[0;31m'
export                       s_red_L=$'\x1B[1;31m'

export                       s_green=$'\x1B[0;32m'
export                     s_green_L=$'\x1B[1;32m'

export                       s_brown=$'\x1B[0;33m'
export                     s_brown_L=$'\x1B[1;33m'

export                        s_blue=$'\x1B[0;34m'
export                      s_blue_L=$'\x1B[1;34m'

export                      s_purple=$'\x1B[0;35m'
export                    s_purple_L=$'\x1B[1;35m'

export                        s_cyan=$'\x1B[0;36m'
export                      s_cyan_L=$'\x1B[1;36m'

export                        s_gray=$'\x1B[0;37m'
export                      s_gray_L=$'\x1B[1;37m'

export                         s_num="[[:digit:]]"
export                        s_char="[[:print:]]"
export                       s_blank="[[:blank:]]"
export                       s_space="[[:space:]]"

# demo usage
# echo "${REPO_DIR_CASK6}/frameworks/cutlass3x/lib/gemm_sm100.cpp:74" | sed "s#\(.*/\)\(.*\)#${s_brown}\1${s_red}\2${s_end}#g"

# 256色系列
export                  s_green_256=$'\x1B[38;5;34m'    # 深绿色
export                   s_lime_256=$'\x1B[38;5;118m'   # 浅绿色
export                    s_sky_256=$'\x1B[38;5;117m'   # 天蓝色
export                  s_azure_256=$'\x1B[38;5;45m'    # 湖蓝色
export                   s_pink_256=$'\x1B[38;5;205m'   # 粉红色
export                 s_purple_256=$'\x1B[38;5;135m'   # 紫色
export                  s_coral_256=$'\x1B[38;5;209m'   # 珊瑚色
export                   s_gold_256=$'\x1B[38;5;220m'   # 金色
export                 s_orange_256=$'\x1B[38;5;208m'   # 橙色
export                   s_rust_256=$'\x1B[38;5;166m'   # 锈红色

# 24位真彩色系列
export                s_orange_24=$'\x1B[38;2;255;165;0m'     # 标准橙色
export             s_turquoise_24=$'\x1B[38;2;64;224;208m'    # 绿松石色
export               s_crimson_24=$'\x1B[38;2;220;20;60m'     # 深红色
export             s_steelblue_24=$'\x1B[38;2;70;130;180m'    # 钢青色
export                s_tomato_24=$'\x1B[38;2;255;99;71m'     # 番茄红
export             s_darkgreen_24=$'\x1B[38;2;0;100;0m'       # 深绿色
export              s_seagreen_24=$'\x1B[38;2;46;139;87m'     # 海绿色
export             s_royalblue_24=$'\x1B[38;2;65;105;225m'    # 皇家蓝
export               s_magenta_24=$'\x1B[38;2;255;0;255m'     # 品红色
export            s_darkviolet_24=$'\x1B[38;2;148;0;211m'     # 深紫色

bash_script_o
fi

function test_sed_color() {
    echo -e "=== 256色系列 ==="
    show_color_asc_code_sed s_green_256
    show_color_asc_code_sed s_lime_256
    show_color_asc_code_sed s_sky_256
    show_color_asc_code_sed s_azure_256
    show_color_asc_code_sed s_pink_256
    show_color_asc_code_sed s_purple_256
    show_color_asc_code_sed s_coral_256
    show_color_asc_code_sed s_gold_256
    show_color_asc_code_sed s_orange_256
    show_color_asc_code_sed s_rust_256
    
    echo -e "\n=== 24位真彩色系列 ==="
    show_color_asc_code_sed s_orange_24
    show_color_asc_code_sed s_turquoise_24
    show_color_asc_code_sed s_crimson_24
    show_color_asc_code_sed s_steelblue_24
    show_color_asc_code_sed s_tomato_24
    show_color_asc_code_sed s_darkgreen_24
    show_color_asc_code_sed s_seagreen_24
    show_color_asc_code_sed s_royalblue_24
    show_color_asc_code_sed s_magenta_24
    show_color_asc_code_sed s_darkviolet_24
    
    echo -e "\n=== 基础颜色系列及其高亮版本 ==="
    show_color_asc_code_sed s_black
    show_color_asc_code_sed s_black_L
    
    show_color_asc_code_sed s_red
    show_color_asc_code_sed s_red_L
    
    show_color_asc_code_sed s_green
    show_color_asc_code_sed s_green_L
    
    show_color_asc_code_sed s_brown
    show_color_asc_code_sed s_brown_L
    
    show_color_asc_code_sed s_blue
    show_color_asc_code_sed s_blue_L
    
    show_color_asc_code_sed s_purple
    show_color_asc_code_sed s_purple_L
    
    show_color_asc_code_sed s_cyan
    show_color_asc_code_sed s_cyan_L
    
    show_color_asc_code_sed s_gray
    show_color_asc_code_sed s_gray_L
    
    echo -e "\n=== 控制序列 ==="
    show_color_asc_code_sed s_end
    show_color_asc_code_sed s_end_L
    show_color_asc_code_sed s_reset
    echo
}

if [[ "$1" == "showTest" ]] ; then
    bash_script_i
    echo
    test_sed_color
    
    echo "=== 颜色组合示例 ==="
    echo "combin"   | sed "s#\(.*\)#normal : ${s_black}00000${s_red}11111${s_green}22222${s_brown}33333${s_blue}44444${s_purple}55555${s_cyan}66666${s_gray}77777${s_end}#g"
    echo "combin"   | sed "s#\(.*\)#light  : ${s_black_L}00000${s_red_L}11111${s_green_L}22222${s_brown_L}33333${s_blue_L}44444${s_purple_L}55555${s_cyan_L}66666${s_gray_L}77777${s_end_L}#g"
    
    echo
    echo "${BASH_SOURCE[0]}:$LINENO"
    bash_script_o
fi

