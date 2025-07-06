
import sys
import inspect
import gdb
print(f'+++++++++ loading \033[92m{inspect.stack()[0][1]}:{inspect.stack()[0][2]}\033[0m')
is_print_type=0
variable_types_to_check = ["cask6::StringView", "SomeOtherType"]

class PrintStringsVariable(gdb.Command):
    def __init__(self):
        super(PrintStringsVariable, self).__init__("psvar", gdb.COMMAND_USER)
        print('\033[92mcmd \033[91m psvar \033[92m is registered \033[0m')

    def invoke(self, arg, from_tty):
        print(f'\033[92m{inspect.stack()[0][1]}:{inspect.stack()[0][2]}\033[0m')
        if gdb.selected_frame() is None:
            return
        frame = gdb.selected_frame()
            
        # Capture and print function arguments
        for symbol in frame.block():
            if symbol.is_argument:
                if symbol.type and any(t in str(symbol.type) for t in variable_types_to_check):
                    print(f'Function argument: {symbol.name}={symbol.value(frame)}')
                else:
                    print(f'is_argument : {symbol.is_argument}   , symbol.type : {symbol.type}  ') if is_print_type else None
        
        # Capture and print local variables
        block = frame.block()
        while block:
            for symbol in block:
                if symbol.is_variable:
                    if symbol.type and any(t in str(symbol.type) for t in variable_types_to_check):
                        val = symbol.value(frame)
                        print(f'Variable: {symbol.name}={val}')
                    else:
                        print(f'is_variable : {symbol.is_variable}   , symbol.type : {symbol.type}  ') if is_print_type else None
            block = block.superblock

PrintStringsVariable()

print(f'--------- leaving \033[92m{inspect.stack()[0][1]}:{inspect.stack()[0][2]}\033[0m')