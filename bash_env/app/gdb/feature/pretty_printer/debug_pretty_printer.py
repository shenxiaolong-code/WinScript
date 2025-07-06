
import sys
import inspect
import pdb

print(f'+++++++++ loading \033[92m{inspect.stack()[0][1]}:{inspect.stack()[0][2]}\033[0m')

# or direct run in gdb : 
# py pdb.run('gdb.execute("print $1[0]")')
pdb.run('gdb.execute("print operation_launch_")')
# dv
# inspect.getmembers(type)

print(f'--------- leaving \033[92m{inspect.stack()[0][1]}:{inspect.stack()[0][2]}\033[0m')