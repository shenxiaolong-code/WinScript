bash_script_i
echo ${BASH_SOURCE[0]} $*
# http://c.biancheng.net/view/806.html 
# in csh  shell : source xxx.csh        |&      tee log.txt
# in bash shell : source xxx.sh  2>&1   |       tee log.txt             # exception will cause some env vars value change
# in bash shell : source xxx.sh         |       tee log.txt             # fix env vars value change

# bash escape chars:  https://www.baeldung.com/linux/bash-escape-characters
# $ <dollar-sign>, e.g. $() and ${}
# ` <grave-accent>, also known as the backquote operator
# ” <quotation-mark>, when we need a double quote within double quotes
# newline <newline>, which is equivalent to <LF> under Linux
# \ <backslash>, when prefixing a character in this list except <exclamation-mark>
# ! <exclamation-mark>, when history expansion is enabled outside POSIX mode, usually the case

tem_file_log=${TEMP_DIR}/to_del/temp_$RANDOM.log
# begin_debug_mode         # start debugging from here
echo "--------------------------------------------------- test begin "---------------------------------------------------



echo "--------------------------------------------------- test end "---------------------------------------------------
dumpinfo "${tem_file_log}"
# end_debug_mode            # stop debugging from here
bash_script_o


