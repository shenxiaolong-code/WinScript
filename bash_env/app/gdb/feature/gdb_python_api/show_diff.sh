bash_script_i
echo



# show change
git -C ${EXT_DIR}/myDepency/gdb_pretty_printer/gdb_python_api  status
# git -C ${EXT_DIR}/myDepency/gdb_pretty_printer/gdb_python_api  diff
code --diff  ${EXT_DIR}/myDepency/gdb_pretty_printer/gdb_python_api/gdb_util/backtrace.py.raw  ${EXT_DIR}/myDepency/gdb_pretty_printer/gdb_python_api/gdb_util/backtrace.py 

rm ./backtrace.py 
cp ${EXT_DIR}/myDepency/gdb_pretty_printer/gdb_python_api/gdb_util/backtrace.py   ./

echo
bash_script_o
