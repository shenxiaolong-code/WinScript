
echo -e "# +++++++++ loading ${BASH_SOURCE[0]}:$LINENO ..."
# echo $*

if [[ -d "$1/cmds" ]] ; then
    [[ ! -d "$1/gdb_output" ]] && mkdir -p "$1/gdb_output"
    cp "$2" "$1/gdb_output/"
    find $1/gdb_output/ -type f -iname "${2##*/}" | egrep -i --color=always "${2##*/}"
fi

echo -e "# --------- leaving ${BASH_SOURCE[0]}:$LINENO  "
