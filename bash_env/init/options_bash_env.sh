bash_script_i

# show all options : set -o

# https://www.cnblogs.com/shamoguzhou/p/7045666.html
# grep: warning: GREP_OPTIONS is deprecated; please use an alias or script
# export GREP_OPTIONS="--color=always"
# export GREP_OPTIONS="--color=auto"

# disable overwrite existing file
# set noclobber                             # force overwrite by : echo "some string"   >|  existing_file
                                            # show current set : set -o | grep noclobber

#  https://stackoverflow.com/questions/3474526/stop-on-first-error
# This tells bash that it should exit the script if any statement returns a non-true return value. 
# The benefit of using -e is that it prevents errors snowballing into serious issues when they could have been caught earlier. 
# Again, for readability you may want to use set -o errexit.
# set -e
# similar to :
# some_prog || exit 1
# some_other_prog || exit 1

# set -v          # enable echo cmd
# set -x          # activate debugging from here , it is recommanded option for first debug
# set +x		      # stop debugging from here
# set +v          # disable echo cmd

# set -o option_name
# set -x                # 对于单字母选项

# show all possible completion matches if the completion is ambiguous
# avoid "Display all <n> possibilities? (y or n)" prompt
bind 'set show-all-if-ambiguous on'
set -o ignoreeof                  # ignore EOF (Ctrl+D) in interactive shell

# suggested options when debugging.  close them in default
# set -u                            # treat unset variables as an error
# set -o pipefail                   # return value of pipeline is status of last command to exit with non-zero status

# echo "current enabled options : $-"
# echo "parsed all options  : set -o"
# set -o

# allexport       off             #  自动导出所有定义的变量到环境变量中
# braceexpand     on              #  启用花括号展开功能，如 {1..3} 会展开为 1 2 3
# emacs           on              #  使用 emacs 风格的行编辑模式
# errexit         off             #  当任何命令返回非零状态时退出 shell
# errtrace        off             #  在 shell 函数中继承 ERR 陷阱
# functrace       off             #  在 shell 函数中继承 DEBUG 和 RETURN 陷阱
# hashall         on              #  缓存所有命令的路径，提高执行速度
# histexpand      on              #  启用历史命令展开功能，如 !n 执行第 n 条历史命令
# history         on              #  启用命令历史记录功能
# ignoreeof       off             #  忽略 EOF（Ctrl+D）在交互式 shell 中的作用
# interactive-comments    on      #  允许在交互式 shell 中使用注释
# keyword         off             #  启用关键字展开功能
# monitor         on              #  启用作业状态监控
# noclobber       off             #  防止重定向时覆盖已存在的文件
# noexec          off             #  防止执行命令，只进行语法检查
# noglob          off             #  禁用文件名展开（通配符）
# nolog           off             #  禁用命令日志记录
# notify          off             #  在作业状态改变时通知用户
# nounset         off             #  将未设置的变量视为错误
# onecmd          off             #  读取并执行一条命令后退出
# physical        off             #  使用物理目录结构
# pipefail        off             #  管道返回值是最后一个非零退出状态的命令的状态
# posix           off             #  启用 POSIX 模式
# privileged      off             #  启用特权模式
# verbose         off             #  打印 shell 输入行
# vi              off             #  使用 vi 风格的行编辑模式
# xtrace          off             #  打印命令及其参数执行过程


bash_script_o
