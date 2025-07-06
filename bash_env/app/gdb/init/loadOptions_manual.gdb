echo  \r\n+++++++++ loading ${BASH_DIR}/app/gdb/init/loadOptions_manual.gdb ...\r\n
# some setting and cmd can NOT be load in the gdb inital procedure, it can only be set after the gdb is initialed.
echo \033[36mThose seting or option MUST be loaded after the gdb is initialed.\r\n\033[37m

# source ${BASH_DIR}/app/gdb/init/debug_multiple_thread_process.gdb

# Automatic Display current source line when step debug.
# disable display dnums… | enable display dnums… | undisplay dnums… | delete display dnums…
delete display
# show current display seting
# info display
# auto display current function signature.      windbg : $ebp , function begin address
# display $_
# auto display current source file line.        windbg : $esp , function current address
display $pc

source ${BASH_DIR}/app/gdb/init/display_hook_stop.py

# bash_script_o
