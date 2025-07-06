
# bash_script_i
# https://sourceware.org/gdb/onlinedocs/gdb/Dynamic-Printf.html#Dynamic-Printf
# _________________ gdb tracepoint alternative _________________

set dprintf-style call
set dprintf-function fprintf
set dprintf-channel myTracelog

# usage example:
# dprintf 25,"at line 25, glob=%d\n",glob


# bash_script_o