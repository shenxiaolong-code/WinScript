
# bash_script_i

source  ${BASH_DIR}/app/gdb/feature/cmds/py_debug.py
# source  ${BASH_DIR}/app/gdb/feature/cmds/btOnlyShowFuncName.py
# source  ${BASH_DIR}/app/gdb/feature/cmds/decode_bt_output_by_hook.py
source  ${BASH_DIR}/app/gdb/feature/cmds/show_compiler.py

if $_isvoid($_gdb_major)==0    
    # _gdb_major is new built-in variable in gdb 9.0
    # https://android.googlesource.com/toolchain/gdb/+/76f55a3e2a750d666fbe2e296125b31b4e792461/gdb-9.1/gdb/NEWS    
    source ${BASH_DIR}/app/gdb/feature/cmds/load_gdb_version90_supported.gdb
else
    echo \033[31mcurrent gdb version is lesser than 9.0 , some feature is not supported.\033[37m\r\n
    echo see \033[32m${BASH_DIR}/app/gdb/feature/cmds/load_gdb_version90_supported.gdb\033[37m\r\n
end

# bash_script_o