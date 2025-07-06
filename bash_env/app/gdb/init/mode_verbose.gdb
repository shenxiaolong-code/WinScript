# bash_script_i

# https://sourceware.org/gdb/onlinedocs/gdb/Messages_002fWarnings.html

set verbose on
set complaints 99
set trace-commands on
set debug auto-load on

source ${BASH_DIR}/app/gdb/init/loadInfo.gdb




echo done to load verbose mode.
echo \r\n --------- leaving ${BASH_DIR}/app/gdb/init/mode_verbose.gdb ...\r\n
