
import gdb
import inspect

print(f'+++++++++ loading \033[92m{inspect.stack()[0][1]}:{inspect.stack()[0][2]}\033[0m')

def show_current_line_position(address):
    # 执行info line命令
    result = gdb.execute("info line *" + address, to_string=True)
    # 提取文件路径和行号
    lines = result.split('\n')
    for line in lines:
        if "Line" in line:
            # 提取文件路径和行号信息
            parts = line.split('"')
            if len(parts) > 1:
                filepath = parts[1]
                line_info = parts[0].split(' ')[1]
                return {'filepath': filepath, 'lineNo': line_info}
    return None

# 定义一个函数来提取地址
def extract_address_from_info_line(line):
    # 执行info line命令
    result = gdb.execute("info line " + line, to_string=True)
    # 搜索地址字符串的开始位置
    address_start = result.find("0x")
    # 搜索地址字符串的结束位置
    address_end = result.find(" ", address_start)
    # 提取地址字符串
    address = result[address_start:address_end]
    return address

# 定义一个GDB命令来使用这个函数
class SetRIPCommand(gdb.Command):
    def __init__(self):
        super(SetRIPCommand, self).__init__("jmp", gdb.COMMAND_USER)
        print('\033[92mcmd \033[91m jmp \033[92m is registered \033[0m')

    def invoke(self, arg, from_tty):
        # 提取地址
        print(f'\033[91m[debug]\033[0m \033[90m{inspect.stack()[0][1]}:{inspect.stack()[0][2]}\033[0m')
        address = extract_address_from_info_line(arg)
        # 设置$rip寄存器的值
        # db.execute("x " + address)
        position_info=show_current_line_position(address)
        if position_info is not None:
            print("\033[92mFile path: \033[94m{}\033[92m:\033[91m{}\033[0m".format(position_info['filepath'], position_info['lineNo']))
        gdb.execute("set $rip = " + address)
        # print("RIP set to: , line number" + address)
        print("\033[92mRIP set to: \033[93m{} \033[92m, query line symbol: \033[91minfo line {}\033[0m".format(address, arg))

# 注册这个GDB命令
SetRIPCommand()

print(f'--------- leaving \033[92m{inspect.stack()[0][1]}:{inspect.stack()[0][2]}\033[0m')