#!/bin/bash

bash_script_i
echo


function feature_doing(){
    dumppos
}

function feature_main()
{
    dumppos
    feature_doing
}

function feature_tc()
{
    dumppos
    dumpcmdline
    cd $( mktemp -d -p ${TEMP_DIR}/to_del )
    feature_main "$@"
}

# [[ $# -le 2 ]] && feature_tc "$@" || feature_main "$@"
# feature_main "$@"
feature_tc  "$@"

echo
bash_script_o
