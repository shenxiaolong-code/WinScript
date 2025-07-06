from subprocess import Popen, PIPE
import re
import sys
import gdb

import inspect
print(f'+++++++++ loading \033[92m{inspect.stack()[0][1]}:{inspect.stack()[0][2]}\033[0m')

# https://stackoverflow.com/questions/28243549/prevent-plt-procedure-linkage-table-breakpoints-in-gdb
# dr @plt

class RDelete(gdb.Command):
  """Delete breakpoints for all locations matching REGEXP."""

  def __init__(self):
    super (RDelete, self).__init__ ("dr", gdb.COMMAND_BREAKPOINTS, gdb.COMPLETE_LOCATION)
    print(f'\033[92mcmd \033[91m dr \033[92m is registered \033[0m')

  def invoke(self, argstr, from_tty):
    print(f'\033[92m{inspect.stack()[0][1]}:{inspect.stack()[0][2]}\033[0m\nDelete all brekpoint match regular expression: \033[93m{argstr}\033[0m\n')
    # .* is supported
    bppat = re.compile(argstr)
    for bp in gdb.breakpoints():
      if bppat.search(bp.location):
        print("Deleting breakpoint {} at {}".format(bp.number, bp.location))
        bp.delete()

RDelete()

print(f'--------- leaving \033[92m{inspect.stack()[0][1]}:{inspect.stack()[0][2]}\033[0m')
