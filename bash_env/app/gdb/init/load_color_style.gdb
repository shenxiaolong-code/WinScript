# https://codeantenna.com/a/eXKbj2H0jN
# many network material has not method , only effect.
# syntax : set style textType attr value
# textType : address filename function sources variable
# attr : background  foreground intensity
# value： when attr==intensity , only normal , bold , dim are available
# color value : none, black, red, green, yellow, blue, magenta, cyan, white.

# check and adjust it by cmd : show style
# check change by gdb cmd : bt
set style address foreground blue
set style filename foreground green
set style function foreground yellow
set style highlight foreground red
set style metadata intensity dim
set style title foreground magenta
set style title intensity bold
set style tui-active-border foreground cyan
set style tui-border foreground cyan
set style variable foreground cyan


# gdb 9.2 feature:
set style variable foreground yellow
set style sources  on

# gdb 12 feature:
if $_gdb_major > 11
    set style version foreground magenta
    set style version intensity bold
end


# for complex color , see 
# https://stackoverflow.com/questions/209534/how-to-highlight-and-color-gdb-output-during-interactive-debugging/17341335#17341335
# theory : replace built-in command by customized cmd , and use color output text to show output.

# run below command in gdb:
# echo \033[30m0000\033[31m1111\033[32m2222\033[33m3333\033[34m4444\033[35m5555\033[36m6666\033[37m7777\r\n

# run below command in gdb script:
# echo \033[33m r11
# printf "=0x%016lX  ", $r11
# echo \033[34mr12
# printf "=0x%016lX  ", $r12
# echo \033[35mr13
# printf "=0x%016lX  ", $r13
