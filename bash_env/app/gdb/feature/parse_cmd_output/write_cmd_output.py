
#  https://stackoverflow.com/questions/5941158/gdb-print-to-file-instead-of-stdout
# Inside gdb
# (gdb) rdr info -o /absolute/path/info.txt
# (gdb) rdr info registers eax -o ./eax.txt
# (gdb) rdr bt -o ./bt.txt

# https://blog.cryptomilk.org/2010/12/23/gdb-backtrace-to-file/
import os
from datetime import datetime
import argparse
import re
import inspect
import subprocess

print(f'+++++++++ loading \033[92m{inspect.stack()[0][1]}:{inspect.stack()[0][2]}\033[0m')

def convert_path(original_path):
    # 获取当前日期并格式化为 yyyymmdd
    current_date = datetime.now().strftime("%Y%m%d")

    # 分割路径为目录部分和文件名
    directory, filename = os.path.split(original_path)

    # 构造新的目录路径，包含日期
    new_directory = os.path.join(directory, current_date)

    # 构造新的文件路径
    new_outfile = os.path.join(new_directory, filename)

    # 检查新的目录是否存在，如果不存在，则创建它
    if not os.path.exists(new_directory):
        os.makedirs(new_directory)

    # 返回新的文件路径
    return new_outfile

class RedirOutput(gdb.Command):
    def __init__(self):
        super().__init__("rdr", gdb.COMMAND_USER, gdb.COMPLETE_COMMAND)

    def get_current_work_dir(self):
        # 执行 'info proc' 命令
        info_proc_output = gdb.execute('info proc', to_string=True)

        # 使用正则表达式解析输出以获取当前工作目录
        match = re.search(r'cwd = (.*)', info_proc_output)
        if match:
            current_work_dir = match.group(1)
            return current_work_dir
        else:
            print("Could not find the current working directory, use default dir.")
            return "${EXT_DIR}/build/_bd_template_cask6"
    
    def invoke(self, argstr, from_tty):
        print(f'\033[92m[debug] \033[91m{inspect.stack()[0][1]}:{inspect.stack()[0][2]}\033[0m')
        parser = argparse.ArgumentParser()
        parser.add_argument('command', nargs='+')
        parser.add_argument('-o', "--outfile", required=True, help="output file")

        nm = parser.parse_args(argstr.split())
        outfile = convert_path(os.path.join( '${EXT_DIR}/tmp', nm.outfile ))

        with open(outfile, "w") as output_file:
            try:
                output_file.write(gdb.execute(' '.join(nm.command), to_string=True))
            except Exception as e:
                print(str(e))
        print(os.path.abspath(outfile))

        bash_script_path="${BASH_DIR}/app/gdb/feature/parse_cmd_output/rdr_post_process.sh"
        current_work_dir=self.get_current_work_dir()
        subprocess.run(['bash', '-c', f". {bash_script_path} {current_work_dir} {os.path.abspath(outfile)}"])

RedirOutput()

print(f'--------- leaving \033[92m{inspect.stack()[0][1]}:{inspect.stack()[0][2]}\033[0m')
