
import sys
import inspect
print(f'+++++++++ loading \033[92m{inspect.stack()[0][1]}:{inspect.stack()[0][2]}\033[0m')
print(f'\033[90m90 \033[91m91 \033[92m92 \033[93m93 \033[94m94 \033[95m95 \033[96m96 \033[97m97 \033[0m')
# print(f'\033[91mLog\033[0m \033[90m{inspect.stack()[0][1]}:{inspect.stack()[0][2]}\033[0m')
# valStr="\033[91m{}\033[0m  {} ".format(self.val['start_'],f'\033[90m{inspect.stack()[0][1]}:{inspect.stack()[0][2]}\033[0m')

import gdb

# 在 AI 中搜索 inferior_frame () 在 python 中的用法示例，越多越好，我自己筛选 ， 然后不停地叫继续
# inferior_frame () 自来于 : ${EXT_DIR}/myDepency/gdb_pretty_printer/gdb_python_api/gdb_util/backtrace.py 

# 1. 获取当前帧的函数名
frame = gdb.inferior_frame()
function_name = frame.function().name
print("Current function: {}".format(function_name))

members = inspect.getmembers(frame)
for member in members:
    print(member)

# 2. 遍历当前帧的参数
frame = gdb.inferior_frame()
block = frame.block()
for arg in block:
    print("Argument: {}".format(arg.name))

# 3. 获取当前帧的局部变量信息
frame = gdb.inferior_frame()
block = frame.block()
for sym in block:
    if sym.is_argument:
        continue
    print("Local variable: {} = {}".format(sym.name, frame.read_var(sym)))

# 4. 检查当前帧是否为主函数
frame = gdb.inferior_frame()
if frame.function().name == "main":
    print("Current frame is in main function")

# 5. 获取当前帧的源文件和行号信息
frame = gdb.inferior_frame()
source_file = frame.find_sal().symtab.fullname()
line_number = frame.find_sal().line
print("Source file: {}, Line number: {}".format(source_file, line_number))

# 6. 检查当前帧是否为特定函数调用
frame = gdb.inferior_frame()
if frame.function().name == "my_function":
    print("Current frame is in my_function")

# 7. 获取当前帧的返回值
frame = gdb.inferior_frame()
return_value = frame.read_var ("$rax")  # 根据具体架构和寄存器名称调整
print("Return value: {}".format(return_value))

# 8. 遍历当前帧的所有变量
frame = gdb.inferior_frame()
block = frame.block()
for sym in block:
    value = frame.read_var(sym)
    print("Variable: {} = {}".format(sym.name, value))

# 9. 检查当前帧的调用链
frame = gdb.inferior_frame()
call_stack = []
while frame is not None:
    call_stack.append(frame.function().name)
    frame = frame.older()
print("Call stack: {}".format(call_stack))

# 10. 获取当前帧的参数和对应数值
frame = gdb.inferior_frame()
args = frame.find_sal().line
for arg in args:
    arg_name = arg.sym.name
    arg_value = frame.read_var(arg.sym)
    print("Argument: {} = {}".format(arg_name, arg_value))

# 11. 检查当前帧是否为特定源文件中的函数调用
frame = gdb.inferior_frame()
source_file = frame.find_sal().symtab.filename
if source_file == "example.c":
    print("Current frame is in a function from example.c")

# 12. 获取当前帧的寄存器信息
frame = gdb.inferior_frame()
registers = frame.read_register()
for reg_name, reg_value in registers.items():
    print("Register {}: {}".format(reg_name, reg_value))

# 13. 检查当前帧是否包含特定变量
frame = gdb.inferior_frame()
variable_name = "my_variable"
block = frame.block()
if block[variable_name]:
    print("Current frame contains variable: {}".format(variable_name))

# 14. 获取当前帧的调用指令地址
frame = gdb.inferior_frame()
pc_address = frame.pc()
print("Program Counter address: {}".format(pc_address))

# 15. 获取当前帧的源文件路径和函数调用行号
frame = gdb.inferior_frame()
source_file = frame.find_sal().symtab.filename
line_number = frame.find_sal().line
print("Source file: {}, Line number: {}".format(source_file, line_number))

# 16. 检查当前帧是否为特定源文件中的特定行号
frame = gdb.inferior_frame()
source_file = frame.find_sal().symtab.filename
line_number = frame.find_sal().line
if source_file == "example.c" and line_number == 10:
    print("Current frame is in example.c at line 10.")

# 17. 获取当前帧的调用指令地址对应的源码位置
frame = gdb.inferior_frame()
pc_address = frame.pc()
sal = gdb.find_pc_line(pc_address)
if sal is not None:
    print("Source file: {}, Line number: {}".format(sal.symtab.filename, sal.line))

# 18. 获取当前帧的调用指令地址对应的源码位置和函数名
frame = gdb.inferior_frame()
pc_address = frame.pc()
sal = gdb.find_pc_line(pc_address)
if sal is not None:
    print("Function: {}, Source file: {}, Line number: {}".format(sal.function.name, sal.symtab.filename, sal.line))

# 19. 检查当前帧是否为特定函数调用并输出其参数
frame = gdb.inferior_frame()
if frame.function().name == "my_function":
    args = frame.find_sal().line
    for arg in args:
        arg_name = arg.sym.name
        arg_value = frame.read_var(arg.sym)
        print("Argument: {} = {}".format(arg_name, arg_value))

# 20. 获取当前帧的调用指令地址对应的源码位置和偏移量
frame = gdb.inferior_frame()
pc_address = frame.pc()
sal = gdb.find_pc_line(pc_address)
if sal is not None:
    offset = pc_address - sal.pc
    print("Source file: {}, Line number: {}, Offset: {}".format(sal.symtab.filename, sal.line, offset))

# 21. 检查当前帧是否包含特定寄存器并输出其值
frame = gdb.inferior_frame()
register_name = "rax"
if register_name in frame.architecture().registers:
    register_value = frame.read_register(register_name)
    print("Register {}: {}".format(register_name, register_value))

# 22. 获取当前帧的调用指令地址对应的源码位置和函数调用深度
frame = gdb.inferior_frame()
pc_address = frame.pc()
sal = gdb.find_pc_line(pc_address)
call_depth = frame.num_args()
if sal is not None:
    print("Function: {}, Source file: {}, Line number: {}, Call depth: {}".format(sal.function.name, sal.symtab.filename, sal.line, call_depth))

# 23. 检查当前帧是否为特定函数调用并输出其局部变量
frame = gdb.inferior_frame()
if frame.function().name == "my_function":
    block = frame.block()
    for sym in block:
        if not sym.is_argument:
            var_value = frame.read_var(sym)
            print("Local variable: {} = {}".format(sym.name, var_value))




print(f'--------- leaving \033[92m{inspect.stack()[0][1]}:{inspect.stack()[0][2]}\033[0m')