#!/usr/bin/env python3

import os
import sys
import inspect
from pprint import pprint

from print_python_color             import *    # import  {py_xxx}, e.g. {py_green}, {py_end}
from customized_common_function     import *    # import  addPath2Env
from print_current_callstack        import *

# ***************************************************** usage begin ***************************************************************************** #
# cmd ipy to show the python info
# or echo $PYTHONPATH
# PYTHONPATH  : /home/utils/Python-3.9.1:${EXT_DIR}/myDepency/tools/python_cusotmized_lib_dir:${EXT_DIR}/repo/linux_pratice/linuxRepo/python_pratice/utils

# this '${EXT_DIR}/repo/linux_pratice/linuxRepo/python_pratice/utils' pth has been added into the system PATH and sys.path
# import the python file from this path, e.g.
# from print_python_color             import *

# use the import function or global variable from the imported python file
# e.g. {py_green}, {py_end}
# ***************************************************** usage end  ****************************************************************************** #
python_script_i()
# print(f'{py_green}+++++++++ loading {inspect.stack()[0][1]}:{inspect.stack()[0][2]}{py_end}')
pprint(sys.path)

def my_user_function():
    dumppos()

def ut_my_user_function():
    my_user_function()


if __name__ == '__main__':    
    print("main function is called.")
    ut_my_user_function()


# print(f'{py_green}{inspect.stack()[0][1]}:{inspect.stack()[0][2]}{py_end}')
python_script_o()