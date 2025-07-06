#!/bin/bash
# bash_script_i

# chmod +x  ${EXT_DIR}/tmp/cache/gdb_test/gdb_step_action.sh

# echo -e "# +++++++++ loading ${BASH_SOURCE[0]}:$LINENO ..."

# echo step hook is called.
tmp_file_path=${1%%:*}

if [[ -f "${tmp_file_path}" ]] ; then
    echo "open file : ${tmp_file_path}"
    echo ssh xiaolongs@computelab-303 "curl -s 'http://computelab-303.nvidia.com:8000/openfile?path=$1'"
else
    echo -e "${tmp_file_path} is not a valid file path."
fi

# echo -e "# +++++++++ leaving ${BASH_SOURCE[0]}:$LINENO ..."

# bash_script_o
