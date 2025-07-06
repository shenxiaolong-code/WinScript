#!/bin/bash

bash_script_i
# p4_path=/home/utils/p4v-2021.1.2075061
p4_path=/home/utils/p4-2018.1

# //hw/doc/
# p4hw:2001

# //sw/rel/:
# p4proxy-zj:2006
function load_p4_server_config_1() {
    # export P4HOST="p4proxy-zj"    
    export P4PORT="p4proxy-zj:2006"
    export P4USER="xiaolongs"
    # export P4PASSWD=${myLoginPwd}
    export P4PASSWD='ggGG55%%123!@#'
}

function load_p4_server_config_2() {
    # export P4HOST="p4proxy-zj"    
    export P4PORT="p4proxy-zj:2006"
    export P4USER="xiaolongs"
   #  export P4PASSWD=${myLoginPwd}
    export P4PASSWD='ggGG55%%123!@#'
}

function configure_p4_path() {
    [[ ! -f "${p4_path}/bin/p4" ]] && { dumpkey p4_path  ; dumperr "p4_path ${p4_path} not found"; return 1; }
    which p4 > /dev/null || { PATH=${p4_path}/bin:$PATH; export PATH; LD_LIBRARY_PATH=${p4_path}/lib:$LD_LIBRARY_PATH; export LD_LIBRARY_PATH; }
    dumpinfox "p4 path : $(which p4)"
    return 0
}

which p4 > /dev/null || configure_p4_path

bash_script_o
