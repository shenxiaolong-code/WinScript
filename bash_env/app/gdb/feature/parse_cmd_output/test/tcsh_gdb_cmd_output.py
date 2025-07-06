
print("+++++++++ loading ${BASH_DIR}/app/gdb/feature/parse_cmd_output/test/tcsh_gdb_cmd_output.py ...")
#  https://stackoverflow.com/questions/5941158/gdb-print-to-file-instead-of-stdout
# Inside gdb
# (gdb) rdr info -o /absolute/path/info.txt
# (gdb) rdr info registers eax -o ./eax.txt
# (gdb) rdr bt -o ./bt.txt

# https://blog.cryptomilk.org/2010/12/23/gdb-backtrace-to-file/

import os
import gdb
import argparse
import inspect

class CmdParseOutput(gdb.Command):
    def __init__(self):
        super().__init__("rdc", gdb.COMMAND_USER, gdb.COMPLETE_COMMAND)

    def invoke(self, argstr, from_tty):
        print(f'\033[92m[debug] \033[91m{inspect.stack()[0][1]}:{inspect.stack()[0][2]}\033[0m')
        parser = argparse.ArgumentParser()
        parser.add_argument('command', nargs='+')
        parser.add_argument('-c', "--cmd", required=True, help="shell cmd")

        nm = parser.parse_args(argstr.split())
        # https://stackoverflow.com/questions/16132163/using-less-as-gdb-pager/66590807#66590807
        # https://stackoverflow.com/questions/89228/how-do-i-execute-a-program-or-call-a-system-command
        
        with os.popen( nm.cmd ) as pipe:
            try:
                pipe.read(gdb.execute(argstr, to_string=True))
            except Exception as e:
                pipe.write(str(e))       

CmdParseOutput()

# https://stackoverflow.com/questions/15960180/how-to-grep-on-gdb-print
class GrepCmd (gdb.Command):
    """Execute command, but only show lines matching the pattern
    Usage: grep_cmd <cmd> <pattern> """

    def __init__ (_):
        super ().__init__ ("grep_cmd", gdb.COMMAND_STATUS)

    def invoke (_, args_raw, __):
        args = gdb.string_to_argv(args_raw)
        if len(args) != 2:
            print("Wrong parameters number. Usage: grep_cmd <cmd> <pattern>")
        else:
            for line in gdb.execute(args[0], to_string=True).splitlines():
                if args[1] in line:
                    print(line)

GrepCmd()

print("--------- leaving ${BASH_DIR}/app/gdb/feature/parse_cmd_output/test/tcsh_gdb_cmd_output.py ...")