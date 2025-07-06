
import inspect

print(f'+++++++++ loading \033[92m{inspect.stack()[0][1]}:{inspect.stack()[0][2]}\033[0m')

class BtFuncOnly(gdb.Command):
    """Backtrace with function singature only """
    def __init__(self):
        super(self.__class__, self).__init__('btf', gdb.COMMAND_FILES)
        print(f'\033[92mcmd \033[91m btf \033[92m is registered \033[0m')

    def invoke(self, argument, from_tty):
        frame = gdb.selected_frame()
        while frame is not None:
            gdb.write('{}\n'.format(frame.function()))
            frame = frame.older()
BtFuncOnly()

class BtNameOnly(gdb.Command):
    """Backtrace with function names only """
    def __init__(self):
        super(self.__class__, self).__init__('btn', gdb.COMMAND_FILES)
        print(f'\033[92mcmd \033[91m btn \033[92m is registered \033[0m')

    def invoke(self, argument, from_tty):
        frame = gdb.selected_frame()
        while frame is not None:
            gdb.write('{}\n'.format(frame.name()))
            frame = frame.older()
BtNameOnly()

# usage 
# source ${BASH_DIR}/app/gdb/featureScript/btOnlyShowFuncName.py
# btf
# btn 
# https://sourceware.org/gdb/onlinedocs/gdb/Frames-In-Python.html

print(f'--------- leaving \033[92m{inspect.stack()[0][1]}:{inspect.stack()[0][2]}\033[0m')
