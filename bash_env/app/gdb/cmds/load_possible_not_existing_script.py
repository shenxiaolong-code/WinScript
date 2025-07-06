
import sys
import os
import gdb
import inspect
print(f'+++++++++ loading \033[92m{inspect.stack()[0][1]}:{inspect.stack()[0][2]}\033[0m')

# 检查是否有足够的参数传入
if len(sys.argv) > 1:
    script_name = sys.argv[1]
    
    # 检查路径是否为绝对路径
    if not os.path.isabs(script_name):
        print(f"Relative path provided:{script_name}")
        # 如果不是绝对路径，获取GDB的当前工作目录并附加
        working_directory = gdb.execute("pwd", to_string=True).strip()
        script_name = os.path.join(working_directory, script_name)
    else:
        print(f"Absolute path provided:{script_name}")
    
    # 检查文件是否存在
    if os.path.exists(script_name):
        gdb.execute("source " + script_name)
        print("Loaded script: " + script_name)
    else:
        print("File does not exist: " + script_name)
else:
    print("No script name provided.")

print(f'--------- leaving \033[92m{inspect.stack()[0][1]}:{inspect.stack()[0][2]}\033[0m')