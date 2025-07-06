

# experiment gdb_python_api
# https://github.com/jefftrull/gdb_python_api
# see video tutorial
# https://youtube.com/watch?v=ck_jCH_G7pA

source ${BASH_DIR}/app/gdb/feature/gdb_python_api/load_gdb_python_api.py

# git clone https://github.com/jefftrull/gdb_python_api  ${EXT_DIR}/myDepency/gdb_pretty_printer/gdb_python_api
source ${EXT_DIR}/myDepency/gdb_pretty_printer/gdb_python_api/gdb_util/stepping.py
# affected cmds : su -- Stepping only into user code
# https://github.com/jefftrull/gdb_python_api#stepping-only-into-user-code

source ${EXT_DIR}/myDepency/gdb_pretty_printer/gdb_python_api/gdb_util/backtrace.py

# affected cmds : bt  -- Backtrace Cleanup for a group function
# for continus call stack which has the save prefix, only show the last one.
# this technique is useful for c++ std template library -- we don't care about the std function call stack
# https://github.com/jefftrull/gdb_python_api#backtrace-cleanup-for-c-template-libraries
set backtrace-strip-regexes (^std::)|(^boost::)
# set backtrace-strip-regexes (^std::)|(^__gnu)|(^boost::)|(^cutlass::)|(^cask6::)
# show backtrace-strip-regex


# the source code download to : 
# ${BASH_DIR}/app/gdb/feature/gdb_python_api

