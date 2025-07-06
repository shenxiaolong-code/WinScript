
bash_script_i

alias   gdb1='source  ${BASH_DIR}/app/gdb/load_alias_gdb.sh '
alias   gdb2='source  ${BASH_DIR}/app/gdb/load_alias_gdb.sh  use_customized_gdb '
alias   gdb12='alias gdb ${HOME}/gdb_12/gdb '
alias   killgdb='killall -9 gdb '

# general gdb shortcut
function debug_with_gdb()     { 
        gdb -q --command=${BASH_DIR}/app/gdb/init/project_init.gdb  --args "$@"  ;  
        echo "\n${red}more debug info, see${brown} ${HOME}/bash_env/nvidia/bin/show_nv_debug_option.csh ${end}"  ; 
        }
function debug_with_cuda_gdb()                      { ${CUDA_PATH}/bin/cuda-gdb -q --command=${BASH_DIR}/app/gdb/init/project_init.gdb --args "$@"     ; }
function check_with_cuda_compute_sanitizer ()       { ${CUDA_PATH}/bin/compute-sanitizer  "$@"     ; }
alias    gdbx=debug_with_gdb
alias    gdbxq=debug_with_gdb_quiet_with_script
alias    gdbxx=debug_with_cuda_gdb
alias    chkx=check_with_cuda_compute_sanitizer
alias    gdbx2=check_with_cuda_compute_sanitizer

alias ggdb='cd ${BASH_DIR}/app/gdb ;'

function fgdb()     {   find ${BASH_DIR} -type f -iname "*.gdb" | grep --color=auto -i "$1"              ; }
function fgdbt()    {   find ${BASH_DIR} -type f -iname "*.gdb"    | xargs grep --color=auto  -nIR "$1"  ; }

function bps() {
    echo ${red}not in debugger${end}
    echo ${BASH_DIR}/app/gdb/feature/bp/load_app_spec_breakpoint.py
    echo ${BASH_DIR}/app/gdb/feature/bp/alias_gdb_breakpoint.gdb ; 
    echo ${BASH_DIR}/app/gdb/cuda_gdb/gdb_init_nvidia.gdb ;    
    echo ${BASH_DIR}/app/gdb/feature/bp/load_breakpoint_examples.gdb ;     
    [[ ./cmds/gdb_breakpoints.ini ]] && dumpinfo "$(pwd -L)/cmds/gdb_breakpoints.ini"
    # echo ${job_path}/breakpoint.gdb; 
    # [[ -d ${job_path} ]] &&  ff "*.gdb"  ${job_path}
    ffa ${EXT_DIR}/myDepency/gdb_nvidia/breakpoint
}

# set gdb_ver=`gdb -v | head -n 1`

bash_script_o

# [ 22:54 xiaolongs@ipp2-0154  ${EXT_DIR}/build/CFK_9823_Trmm_all_fram ][csh]
# $ ldd ${EXT_DIR}/myDepency/tools/gdb_build/static_gdb12/bin/gdb
#         linux-vdso.so.1 (0x00007ffdf0d81000)
#         libncursesw.so.6 => /usr/lib/x86_64-linux-gnu/libncursesw.so.6 (0x000014e0267cb000)
# ...
#         /lib64/ld-linux-x86-64.so.2 (0x000014e02719e000)
#         libz.so.1 => /usr/lib/x86_64-linux-gnu/libz.so.1 (0x000014e025d17000)
#         libutil.so.1 => /usr/lib/x86_64-linux-gnu/libutil.so.1 (0x000014e025d12000)
# [ 22:54 xiaolongs@ipp2-0154  ${EXT_DIR}/build/CFK_9823_Trmm_all_fram ][csh]

# on xiaolongs@a1u1g-mil-0576 , the gdb version is 12.1
# [ 20:10 xiaolongs@ipp1-3194  ${EXT_DIR}/myDepency ][csh]
# $ gdb -v
# GNU gdb (Ubuntu 12.1-0ubuntu1~22.04) 12.1
# Copyright (C) 2022 Free Software Foundation, Inc.
# License GPLv3+: GNU GPL version 3 or later <http://gnu.org/licenses/gpl.html>
# This is free software: you are free to change and redistribute it.
# There is NO WARRANTY, to the extent permitted by law.
# [ 20:10 xiaolongs@ipp1-3194  ${EXT_DIR}/myDepency ][csh]
# $ ? gdb
# /usr/bin/gdb
# [ 20:10 xiaolongs@ipp1-3194  ${EXT_DIR}/myDepency ][csh]
# $ ldd /usr/bin/gdb
#         linux-vdso.so.1 (0x00007ffcd1bb2000)
#         libreadline.so.8 => /usr/lib/x86_64-linux-gnu/libreadline.so.8 (0x000014d639fe3000)
#         libz.so.1 => /usr/lib/x86_64-linux-gnu/libz.so.1 (0x000014d639fc7000)
# ...
#         libresolv.so.2 => /usr/lib/x86_64-linux-gnu/libresolv.so.2 (0x000014d635cf4000)
# [ 20:10 xiaolongs@ipp1-3194  ${EXT_DIR}/myDepency ][csh]

