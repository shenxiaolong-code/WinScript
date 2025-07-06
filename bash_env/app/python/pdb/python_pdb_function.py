#!/usr/bin/env python3

import os
import sys
import inspect

# from print_python_color             import *    # import  {py_xxx}, e.g. {py_green}, {py_end}
# from customized_common_function     import *    # import  addPath2Env

print( f"\033[92mloading \033[90m${BASH_DIR}/app/python/pdb/python_pdb_function.py:{inspect.stack()[0][2]} ...\033[0m")

# Print member of self
def example_func():
    print( f"\033[92m ******************* example_func ******************* \033[0m")


print( f"\r\n\033[92mDone : \033[90m${BASH_DIR}/app/python/pdb/python_pdb_function.py:{inspect.stack()[0][2]} \033[0m")