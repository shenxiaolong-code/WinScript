
# https://stackoverflow.com/questions/67200091/registering-a-gdb-pretty-printer-for-a-specialization-of-stdunordered-map
# https://rev.ng/gitlab/or1k/gcc/-/commit/510f22a93fea5dff7077a55c1401b63315e3568c


# https://rethinkdb.com/blog/make-debugging-easier-with-custom-pretty-printers

import re
import gdb
import inspect

print(f'+++++++++ loading \033[92m{inspect.stack()[0][1]}:{inspect.stack()[0][2]}\033[0m')
# print("+++++++++ loading ${BASH_DIR}/app/gdb/feature/pretty_printer/pretty_printer_template_type.py ...")

class bcolors:
    PURPLE = '\033[95m'
    BLUE = '\033[94m'
    CYAN = '\033[96m'
    GREEN = '\033[92m'
    YELLOW = '\033[93m'
    RED = '\033[91m'
    END = '\033[0m'
    BOLD = '\033[1m'
    UNDERLINE = '\033[4m'

# /usr/share/gcc/python/libstdcxx/v6/printers.py
# lookup type interpreter
def lookup_function (val):
    "Look-up and return a pretty-printer that can print val."
    # Get the type.
    type = val.type
 
    # If it points to a reference, get the reference.
    if type.code == gdb.TYPE_CODE_REF:
        type = type.target ()
 
    # Get the unqualified type, stripped of typedefs.
    type = type.unqualified ().strip_typedefs ()
 
    # Get the type name.    
    typename = type.tag
 
    if typename == None:
        return None
 
    # investigate current type string with template sub-type
    # print(f'\033[92m[debug] \033[91m{typename}\033[0m')    

    # Iterate over local dictionary of types to determine
    # if a printer is registered for that type.  Return an
    # instantiation of the printer if found.
    for function in sorted(pretty_printers_dict):
       if function.match (typename):
           return pretty_printers_dict[function] (val)
 
    # Cannot find a pretty printer.  Return None.
    return None

class SpanPrettyPrinter:
    "Print a Span<T> object"

    def __init__(self, val):
        self.val = val

    def to_string(self):
        print(f' \033[90m{inspect.stack()[0][1]}:{inspect.stack()[0][2]} \033[91m{self.val.type}\033[0m')
        # 获取 start_ 和 count_ 成员的值
        start = self.val['start_']
        count = self.val['count_']
        # 格式化输出
        return 'Span<{}>[{}]'.format(start.type.target(), count)

    def children(self):
        # 用于展示数组的元素
        start = self.val['start_']
        count = self.val['count_']
        for i in range(int(count)):
            elem = start.dereference()  # 注意这里使用 dereference() 获取指针指向的值
            if i > 0:  # 移动指针到下一个元素
                start = start + 1
            yield ('[{}]'.format(i), elem)

    def display_hint(self):
        # 提示 GDB 这是一个数组类型
        return 'Span<T> array'

class ArrayPrinter:
    "Print a Array<T, N>"

    def __init__(self, val):
        self.val = val

    def to_string(self):
        print(f' \033[90m{inspect.stack()[0][1]}:{inspect.stack()[0][2]} \033[91m{self.val.type}\033[0m')
        # 获取数组的大小
        size = self.val.type.template_argument(1)
        # 构建显示的字符串
        result = 'Array of size %s: [' % size
        # 遍历数组元素
        for i in range(int(size)):
            if i > 0:
                result += ', '
            result += str(self.val['storage_'][i])
        result += ']'
        return result

    def display_hint(self):
        return 'cask6::Array<T, N> array'

# one type interpreter for cask::NotNull< >
class nv_NotNull:
    """Print a cask::NotNull."""

    def __init__(self, val):
        self.val = val

    def to_string(self):
        # debug output : print current source file and line no
        # print("${BASH_DIR}/app/gdb/feature/pretty_printer/test/test_template_type_pretty-printer.py:50")        
        # print(f'\033[90m[debug] \033[91m{inspect.stack()[0][1]}:{inspect.stack()[0][2]}\033[0m')
        
        # if for void* member pointer 
        # return self.val['_M_ptr'].cast(self.val.type.template_argument(0).pointer()).dereference()

        # print(f'\033[90m{inspect.stack()[0][1]}:{inspect.stack()[0][2]} \033[91m{self.val.type}\033[0m')
        print(f' \033[90m{inspect.stack()[0][1]}:{inspect.stack()[0][2]} \033[91m{self.val.type}\033[0m')
        # return self.val['ptr_'].dereference()
        # valStr=" xiaolong : {}  ".format( self.val['ptr_'] )
        # return valStr
        return self.val['ptr_']

    def display_hint(self):
        return 'cask::NotNull'

# register the pretty-printer
pretty_printers_dict = {}
# pretty_printers_dict[re.compile ('^cask::NotNull<.*>$')] = nv_NotNull
pretty_printers_dict[re.compile ('^cask6::Span<.*>$')] = SpanPrettyPrinter
# pretty_printers_dict[re.compile ('^cask6::Array<.*,.*>$')] = ArrayPrinter

# pretty_printers_dict[re.compile ('^std::unique_ptr<.*>$')] = std_unique_ptr

gdb.pretty_printers.append(lookup_function)

# print("--------- leaving ${BASH_DIR}/app/gdb/feature/pretty_printer/pretty_printer_template_type.py ...")
print(f'--------- leaving \033[92m{inspect.stack()[0][1]}:{inspect.stack()[0][2]}\033[0m')
