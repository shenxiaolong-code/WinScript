#!/usr/bin/env python3

import gdb
from print_python_color             import *    # import  {py_xxx}, e.g. {py_green}, {py_end}

print(f'+++++++++ loading {py_green}{inspect.stack()[0][1]}:{inspect.stack()[0][2]}{py_end}')

# Register GDB command to set verbose mode
def set_verbose_mode():
    class SetVerboseCommand(gdb.Command):
        """Set verbose mode for path addition."""
        def __init__(self):
            super(SetVerboseCommand, self).__init__("verbose", gdb.COMMAND_USER)
            print(f'{py_blue}cmd {py_brown} verbose {py_blue} is registered       {py_black}# {inspect.stack()[0][1]}:{inspect.stack()[0][2]}{py_end}')

        def invoke(self, arg, from_tty):
            if arg in ['1']:
                setVerboseMode(True)
            elif arg in ['0']:
                setVerboseMode(False)
            else:
                print("Usage: set_verbose <1|0>")

    SetVerboseCommand()

# Register the command when the module is loaded
set_verbose_mode()

print(f'{py_green}{inspect.stack()[0][1]}:{inspect.stack()[0][2]}{py_end}')
