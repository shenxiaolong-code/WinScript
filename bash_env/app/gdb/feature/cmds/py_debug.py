
#  https://stackoverflow.com/questions/5941158/gdb-print-to-file-instead-of-stdout
# Inside gdb
# (gdb) rdr info -o /absolute/path/info.txt
# (gdb) rdr info registers eax -o ./eax.txt
# (gdb) rdr bt -o ./bt.txt

# https://blog.cryptomilk.org/2010/12/23/gdb-backtrace-to-file/
import os
import argparse
import inspect
import pdb
import gdb

from print_python_color     import *

print(f'+++++++++ loading \033[92m{inspect.stack()[0][1]}:{inspect.stack()[0][2]}\033[0m')

class DebugGdbPrint(gdb.Command):
    def __init__(self):        
        super().__init__("pydbg", gdb.COMMAND_USER, gdb.COMPLETE_COMMAND)
        # print(f'\033[92mcmd \033[91m pydbg \033[92m is registered \033[0m')
        print(f'{py_blue}cmd {py_brown} bteu {py_blue} is registered {py_end}')

    def invoke(self, argstr, from_tty):
        print(f'\033[92m[debug] \033[91m{inspect.stack()[0][1]}:{inspect.stack()[0][2]}\033[0m')
        # example : pdb.run(f'gdb.execute("p ss")')
        parser = argparse.ArgumentParser()
        parser.add_argument('command', nargs='+')
        nm = parser.parse_args(argstr.split())
        print(f'\033[92m[debug] \033[91m{nm.command}\033[0m')
        pdb.run('gdb.execute("{nm.command}")')

DebugGdbPrint()

print(f'--------- leaving \033[92m{inspect.stack()[0][1]}:{inspect.stack()[0][2]}\033[0m')
