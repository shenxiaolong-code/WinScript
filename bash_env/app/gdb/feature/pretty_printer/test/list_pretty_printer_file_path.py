import gdb
import gdb.printing

print(f'+++++++++ loading \033[92m{inspect.stack()[0][1]}:{inspect.stack()[0][2]}\033[0m')

import sys

def list_loaded_python_files():
    gdb.write("Loaded Python files:\n")
    for module in sys.modules.values():
        if hasattr(module, '__file__'):
            gdb.write("{}\n".format(module.__file__))

list_loaded_python_files()


print(f'--------- leaving \033[92m{inspect.stack()[0][1]}:{inspect.stack()[0][2]}\033[0m')