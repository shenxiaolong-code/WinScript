# bash_script_i
# https://sourceware.org/gdb/onlinedocs/gdb/Messages_002fWarnings.html

set verbose off
set complaints 0
set trace-commands off
set debug auto-load off

source ${BASH_DIR}/app/gdb/init/loadInfo.gdb

echo done to load quiet mode.
echo \r\n --------- leaving ${BASH_DIR}/app/gdb/init/mode_quiet.gdb ...\r\n