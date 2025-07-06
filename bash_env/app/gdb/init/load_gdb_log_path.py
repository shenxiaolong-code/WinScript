
import gdb
import os
import time
import inspect

print(f'+++++++++ loading \033[92m{inspect.stack()[0][1]}:{inspect.stack()[0][2]}\033[0m')

class SetLogPath(gdb.Command):
    def __init__(self):
        super(SetLogPath, self).__init__("set_log_path", gdb.COMMAND_USER)

    def invoke(self, arg, from_tty):
        pid = os.getpid()
        current_time = time.strftime("%Y%m%d_%H%M%S")
        app_full_path = gdb.current_progspace().filename
        print(f'\033[92mgdb app path : \033[95m{app_full_path}\033[0m')
        
        # log_file = f'{gdb_temp_dir}/gdb_log_{app_full_path}_{pid}_{current_time}.log'
        log_file = "{}_{}_{}.log".format(app_full_path, current_time, pid)
        print(f'\033[92mgdb log file : \033[95m{log_file}\033[0m')
        gdb.execute("set logging file {}".format(log_file))
        gdb.execute("set logging overwrite on")
        # gdb.execute("set logging redirect on")
        # gdb.execute("set logging on")
        gdb.execute("set logging enabled on")
        # gdb.execute("show logging")

        # his_file = f'{gdb_temp_dir}/gdb_his_{app_full_path}_{pid}_{current_time}.log'        
        # his_file = "{}/gdb_history_{}_{}.txt".format(gdb_temp_dir,pid, current_time)
        his_file = "{}_{}_{}.cmd_his.log".format(app_full_path, current_time, pid)
        print(f'\033[92mgdb cmd history file : \033[95m{his_file}\033[0m')
        gdb.execute("set history expansion")
        gdb.execute("set history filename {}".format(log_file))
        gdb.execute("set history save on")
        gdb.execute("show history")


class ListFilesWithPID(gdb.Command):
    def __init__(self):
        super(ListFilesWithPID, self).__init__("ilog", gdb.COMMAND_USER)

    def invoke(self, arg, from_tty):
        print(f'\033[92m{inspect.stack()[0][1]}:{inspect.stack()[0][2]}\033[0m')
        pid = str(os.getpid())
        app_full_path = gdb.current_progspace().filename
        app_directory = os.path.dirname(app_full_path)

        files = os.listdir(app_directory)
        files_with_pid = [f for f in files if pid in f]
        print(f'current debug process id : {pid} , log dir : {app_directory}')
        if files_with_pid:
            for f in files_with_pid:
                print(f'{app_directory}/{f}')

SetLogPath()
ListFilesWithPID()

print(f'--------- leaving \033[92m{inspect.stack()[0][1]}:{inspect.stack()[0][2]}\033[0m')

