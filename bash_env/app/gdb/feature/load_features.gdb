
# bash_script_i

source ${BASH_DIR}/app/gdb/feature/skip_filter/loadFilter.gdb
# source ${BASH_DIR}/app/gdb/feature/bp/load_breakpoint.gdb
source ${BASH_DIR}/app/gdb/feature/bp/regular_delete_breakpoint.py
# source ${BASH_DIR}/app/gdb/cuda_gdb/hide_library_function_in_callstack_bt.py
# source ${BASH_DIR}/app/gdb/feature/pretty_printer/enhance_callstack_bt_frame_filter.py
source ${BASH_DIR}/app/gdb/feature/pretty_printer/load_pretty_printer.gdb

# Python Exception <class 'AttributeError'>: 'NoneType' object has no attribute 'startswith'
#6  0x000015554e2cfa1a in ${BASH_DIR}/app/gdb/feature/gdb_python_api/gdb_util/backtrace.py:40
# source ${BASH_DIR}/app/gdb/feature/gdb_python_api/gdb_util/backtrace.py

source ${BASH_DIR}/app/gdb/feature/parse_cmd_output/write_cmd_output.py
source ${BASH_DIR}/app/gdb/feature/parse_cmd_output/gdb_cmd_output_2_shell_cmd.py
source ${BASH_DIR}/app/gdb/feature/cmds/register_cmds.gdb

# third open source gdb lib
source ${BASH_DIR}/app/gdb/feature/gdb_python_api/load_gdb_python_api.gdb
# source ${BASH_DIR}/app/gdb/feature/gdb_dashboard/load_gdb_dashboard.gdb

# bash_script_o