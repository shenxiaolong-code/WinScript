
import sys
import inspect
print(f'+++++++++ loading \033[92m{inspect.stack()[0][1]}:{inspect.stack()[0][2]}\033[0m')
# print(f'\033[91mLog\033[0m \033[90m{inspect.stack()[0][1]}:{inspect.stack()[0][2]}\033[0m')
# valStr="\033[91m{}\033[0m  {} ".format(self.val['start_'],f'\033[90m{inspect.stack()[0][1]}:{inspect.stack()[0][2]}\033[0m')

def display_hook_stop(event):
    print(f'\033[90m{inspect.stack()[0][1]}:{inspect.stack()[0][2]}\033[0m')
    print(f'\033[90m${BASH_DIR}/app/gdb/init/loadOptions_manual.gdb:15 \033[0m')
    gdb.execute("psvar")
    # gdb.execute("backtrace")
    # gdb.execute("info locals")    

def enable_hook():
    # Check if the handler is already connected, and disconnect it if it is
    if 'display_hook_stop_connected' in globals() and display_hook_stop_connected:
        gdb.events.stop.disconnect(display_hook_stop)

    # 将处理程序与每次停止关联起来
    gdb.events.stop.connect(display_hook_stop)

    # Set the connected state flag to True
    display_hook_stop_connected = True

# enable_hook()

print(f'--------- leaving \033[92m{inspect.stack()[0][1]}:{inspect.stack()[0][2]}\033[0m')