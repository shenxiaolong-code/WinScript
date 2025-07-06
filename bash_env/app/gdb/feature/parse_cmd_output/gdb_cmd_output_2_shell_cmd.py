
import sys
import inspect
from print_python_color             import *

print(f'+++++++++ loading {py_green}{inspect.stack()[0][1]}:{inspect.stack()[0][2]}{py_end}')

import os
import argparse
import shlex
from datetime import datetime

# example :  dbg -g 'x $rip'
class GdbCommandToShell(gdb.Command):
    def __init__(self):
        super(GdbCommandToShell, self).__init__("gdb2shell", gdb.COMMAND_USER)

    def invoke(self, arg, from_tty):
        print(f'{py_black}{inspect.stack()[0][1]}:{inspect.stack()[0][2]}{py_end}')
        # Parse the arguments
        parser = argparse.ArgumentParser()
        parser.add_argument('-g', '--gdb-cmd', required=True, help='The GDB command to execute')
        parser.add_argument('-c', '--shell-cmd', default=f"source ${BASH_DIR}/app/gdb/feature/parse_cmd_output/gdb_cmd_output_2_shell_cmd.sh", help='The shell command to execute')
        parser.add_argument('-p', '--gdb-cmd-output-file', default=f"${EXT_DIR}/tmp/to_del/gdb2shell_{datetime.now().strftime('%Y%m%d%H%M%S')}.txt", help='The file to store the output of the GDB command')
        args = parser.parse_args(shlex.split(arg))

        # Execute the GDB command and get the output
        # print(f'args.gdb_cmd={args.gdb_cmd}')
        gdb_output = gdb.execute(args.gdb_cmd, to_string=True)

        # Write the output of the GDB command to a file
        with open(args.gdb_cmd_output_file, 'w') as file:
            file.write(gdb_output)

        # Execute the shell command
        shell_cmd = args.shell_cmd + " " + args.gdb_cmd_output_file
        gdb.execute("shell " + shell_cmd)

# Register the command
GdbCommandToShell()



print(f'--------- leaving {py_green}{inspect.stack()[0][1]}:{inspect.stack()[0][2]}{py_end}')