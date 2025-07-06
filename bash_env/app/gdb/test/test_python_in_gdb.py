
import sys
import inspect
import gdb
from print_python_color             import *
from print_obj_members              import *


print(f'+++++++++ loading {py_green}{inspect.stack()[0][1]}:{inspect.stack()[0][2]}{py_end}')
print(f'{py_red}test color in py :{py_cyan} ${EXT_DIR}/repo/linux_pratice/linuxRepo/python_pratice/utils/print_python_color.py {py_end}')
print(f'{py_black}black : 90 {py_red}  red : 91 {py_green}  green : 92 {py_brown}  brown : 93 {py_blue}  blue : 94 {py_purple}  purple : 95 {py_cyan}  cyan : 96 {py_black}  gray : 97 {py_end}\n')

# refer to : ${BASH_DIR}/app/gdb/feature/parse_cmd_output/write_cmd_output.py


# debug pretty printer
# ${BASH_DIR}/app/gdb/feature/pretty_printer/debug_pretty_printer.py
# import pdb
# pdb.run('gdb.execute("print $1[0]")')

# print(sys.path)
# py pdb.run('gdb.execute("print $1[0]")')
print(f'{py_green}{inspect.stack()[0][1]}:{inspect.stack()[0][2]}{py_end}')
print("use cmd 'py <py_script_file_path>' to run python script \n")





print(f'--------- leaving {py_green}{inspect.stack()[0][1]}:{inspect.stack()[0][2]}{py_end}')