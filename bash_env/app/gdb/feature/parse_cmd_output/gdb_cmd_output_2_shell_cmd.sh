
# source ${BASH_DIR}/init/alias_dump_debug.sh

#echo -e "# +++++++++ loading ${BASH_SOURCE[0]}:$LINENO ..."
echo -e "# ${BASH_SOURCE[0]}:$LINENO      $*"
# echo

gdb_cmd_output_file=$1

if [[ -f $gdb_cmd_output_file ]] ; then
    location=$(cat $gdb_cmd_output_file | sed 's#.*/home/#/home/#' | sed 's#>.*##')
    file=$(echo $location | sed 's#:.*##')
    line=$(echo $location | sed 's#.*:##')
    # echo $location
    # echo sed -n "${line}p" $file
    echo -e "\e[0;32m$location\e[0;0m"
    if [[ -f $file ]] ; then
        # echo -e "\e[0;31m$( sed -n "${line}p" $file)\e[0;0m"
        # echo -e "\e[0;31m$( sed -n "$((line-1)),$((line+2))p" $file)\e[0;0m"
        echo -e "\e[0;31m$( sed -n "$((line-1)),$((line))p" $file)\e[0;0m"
        codeopen $location
    fi
    cat $gdb_cmd_output_file
fi

# echo
# echo -e "# --------- leaving ${BASH_SOURCE[0]}:$LINENO  "

