
# usage 
# ${BASH_DIR}/app/python/pdb/usage_example.sh

# ln -s ${BASH_DIR}/app/python/pdb/python_pdb_init.py  ~/.pdbrc
# used by python built-in debugger : pdb
# suggest : alias pythonx   python -m pdb -c <init_script_file>  <user_py_src_file> [args]
# -c <init_script_file> is similiar to ~/.pdbrc  
# or  
# gdb --command=<init_script_file> --args <user_app_file> [args]

# https://docs.python.org/3/library/pdb.html#debugger-commands
# ln -s ${BASH_DIR}/app/python/pdb/python_pdb_init.py  ${HOME}/.pdbrc

import sys
import os
import inspect
from print_python_color             import *    # import  {py_xxx}, e.g. {py_green}, {py_end}
from customized_common_function     import *    # import  addPath2Env

print(f'\n\033[93mdebug python script in linux environment ... \033[0m')
print( f"\033[92mloading {os.environ['HOME']}/.pdbrc:22 ...\033[0m")
print( f"\033[92mloading ${BASH_DIR}/app/python/pdb/python_pdb_init.py:22 ...\033[0m")
# print(f'+++++++++ loading {py_green}{inspect.stack()[0][1]}:{inspect.stack()[0][2]}{py_end}')
# sys.path.insert(0, os.path.dirname(os.path.realpath(__file__))+'/init')
sys.path.insert(0, '${BASH_DIR}/app/python/pdb/init')
sys.path.insert(0, '${BASH_DIR}/app/python/pdb/cmds')
# print(f'{py_green}{inspect.stack()[0][1]}:{inspect.stack()[0][2]}{py_end}')

####################################### alias begin #################################################################
######################################## warning ####################################################################
#######    Note : alias can't be defined in an independent python script, it should be defined in ~/.pdbrc    #######
#######    else pdb will throw below error:                                                                   #######
#######    *** SyntaxError: invalid syntax                                                                    #######
#####################################################################################################################
alias rc        os.system(' find ${BASH_DIR}/app/python/pdb -maxdepth 1 -type f -print ')
alias cls       os.system('clear')
alias helpx     os.system('echo ${BASH_DIR}/app/python/pdb/python_pdb_init.py:130')

# Print command line arguments
# print("Command line arguments:", sys.argv)
alias cmds p sys.argv

# pdb.set_trace()  is used to enter debugger in source code position, similar to the C++ code : breakpoint() ; or __asm { int 3 ; }
# https://docs.python.org/zh-cn/3/library/pdb.html
# cmd b can replace it in debugger environment
# import pdb
# pdb.set_trace()

# better but need install : pip install ipdb
# https://pypi.org/project/ipdb/
# https://code.activestate.com/recipes/498182/
# import ipdb
# ipdb.set_trace()

# show 5 lines in step debug
# context 5

# set system breakpoint
# setting the value of the PYTHONBREAKPOINT environment variable
# https://machinelearningmastery.com/setting-breakpoints-and-exception-hooks-in-python/
# os.environ['PYTHONBREAKPOINT'] = '0'
# PYTHONBREAKPOINT=ipdb.set_trace


# Print instance variables (usage "pi classInst")
alias pi for k in %1.__dict__.keys(): print(f"%1.{k} = {%1.__dict__[k]}")

# Print member of self
alias ps pi self

# Print the locals.
alias pl p_ locals() local:

# print the imported module file path , list module x
# https://stackoverflow.com/questions/729583/getting-filefile-path-of-imported-module
# print(os.path.abspath(my_module.__file__))
# some of the modules would throw AttributeError when using __file__ attribute to find the path
# e.g.  lmx    os
alias     lm  pp  sys.modules           # pprint  , "pretty print"
# alias   lm     sys.modules
# alias   lm     for modName in sys.modules: print('{} : {}'.format(modName,sys.modules[modName]))

alias   lmx    sys.modules['%1']
# alias lmx2   print(os.path.abspath(%1.__file__))
# alias lmx3   %1.__path__
# from  init import  utils
# alias lmx    utils.showModulePath(%1)

# listing out all attributes of an object in Python
# let's use the pprint module for readability
from pprint import pprint
# import inspect module
import inspect
# dir(inspect)
# list object all attributes and methods
# https://favtutor.com/blogs/print-object-attributes-python
# list all attributes
alias   xx      vars(%1)
alias   info    inspect.getmembers(%1)
alias   info2   pprint(inspect.getmembers(%1))

# list python class source code
# print os.path.dirname(os.path.abspath(inspect.getsourcefile(DummyClass))
alias xxt   print os.path.dirname(os.path.abspath(inspect.getsourcefile(%1))

# show global variable and value
alias xxv   globals()

# show local variable and value.  dir()  only show local variable name without value.
# alias dv    locals()
alias dv    dir()

alias pt    type(%1)
alias bl    b

#################################### alias end ####################################################################

# frequent used debug cmd
# up            ：移动到上一个栈帧（调用者）。
# down          ：移动到下一个栈帧（被调用者）。
# where | bt    ：显示当前的调用栈，列出所有的栈帧。

# debug sub-process or ...
# import pdb
# pdb.set_trace()

#################################### breakpoint begin ####################################################################
print( f"\r\n\033[92m${BASH_DIR}/app/python/pdb/python_pdb_init.py:119 \033[0m")
print( f"\033[94m{os.environ['HOME']}/.pdbrc:111\nset a python breakpoint example:\nb some_file:12\033[0m")
print( f"\033[94mset breakpoint in python source file : breakpoint()\033[0m")
# condition breakpoint
# b C:\Users\powlo\project\tests\TestCase.py:350, view.view_name == 'app.views.export'
# ignore 1 1000         # ignore 1000 times on breakpoint 1
# b ${EXT_DIR}/myDepency/gdb_pretty_printer/python/libstdcxx/v6/printers.py:91

b pre_build_action
b ${EXT_DIR}/repo/dkg_root/debug_setup_public_llvm_ci/scripts/release.py:290
b ${EXT_DIR}/repo/dkg_root/debug_setup_public_llvm_ci/scripts/release.py:609
b ${EXT_DIR}/repo/dkg_root/debug_setup_public_llvm_ci/bloom/build.py:341
b ${EXT_DIR}/repo/dkg_root/debug_setup_public_llvm_ci/bloom/build.py:758
b ${EXT_DIR}/repo/dkg_root/debug_setup_public_llvm_ci/bloom/build.py:584
b ${EXT_DIR}/repo/dkg_root/debug_setup_public_llvm_ci/bloom/build.py:601
b ${EXT_DIR}/repo/dkg_root/debug_setup_public_llvm_ci/bloom/build.py:607


#################################### breakpoint end ####################################################################
# python_function()
exec(open('${BASH_DIR}/app/python/pdb/python_pdb_function.py').read())

# print(f'--------- leaving \033[92m{inspect.stack()[0][1]}:{inspect.stack()[0][2]}\033[0m')
print( f"\033[92mDone : ${BASH_DIR}/app/python/pdb/python_pdb_init.py:133 \033[0m\n")



#   EOF                 ：退出调试器。
#   c                   ：继续执行，直到下一个断点。
#   d                   ：向下移动到调用栈中的下一个帧。
#   h   或   help       ：显示可用命令或特定命令的帮助信息。
#   list   或   l       ：显示当前行及其周围的源代码。
#   q   或   quit       ：退出调试器并终止程序。
#   rv                  ：打印当前函数最后一次返回的返回值。
#   undisplay           ：停止显示指定变量的值。
#
#   a                   ：显示当前函数的参数。
#   cl                  ：清除指定的断点。
#   debug               ：进入递归调试器，逐步执行指定代码。
#   help                ：显示帮助信息。
#   ll   或   longlist  ：显示更多行的源代码。
#   quit                ：退出调试器。
#   s   或   step       ：执行当前行并进入函数内部。
#   unt   或   until    ：执行直到当前行超过指定行号。
#
#   alias               ：定义命令别名。
#   clear               ：清除所有断点或指定断点。
#   disable             ：禁用指定的断点。
#   ignore              ：为指定断点设置忽略次数。
#   args                ：显示当前函数的参数。
#   commands            ：为断点指定一系列命令。
#
#   b   或   break      ：在指定行设置断点。
#   condition           ：为断点设置条件表达式。
#   down                ：向下移动到调用栈中的下一个帧。
#   j   或   jump       ：跳转到指定行并继续执行。
#   next   或   n       ：执行当前行并停在下一行。
#
#   return (r)          ：继续执行直到当前函数返回。
#   tbreak (t)          ：在指定位置设置临时断点。
#   w (where)           ：显示调用栈的信息。
#
#   bt (backtrace)      ：打印完整的调用栈跟踪信息。
#   continue (cont)     ：继续执行，直到遇到下一个断点或程序结束。
#   exit (exit)         ：退出调试器并终止程序。
#   pp (pretty print)   ：以更易读的格式打印表达式的值。



