
import inspect
import gdb.printing

print(f'+++++++++ loading \033[92m{inspect.stack()[0][1]}:{inspect.stack()[0][2]}\033[0m')
# print("+++++++++ loading ${BASH_DIR}/app/gdb/feature/pretty_printer/pretty_printer_nvidia.py ...")

# https://www.youtube.com/watch?v=6DBV4uQ_COc
# https://sourceware.org/gdb/onlinedocs/gdb/Writing-a-Pretty_002dPrinter.html
# https://sourceware.org/gdb/onlinedocs/gdb/Pretty-Printing.html#Pretty-Printing

# cask::GpcSkyline
# b  cask::tester::Trace::processSkylineArgs
# p skyline_ 
# print with defaut printer : p /r skyline_

# see :  /usr/share/gcc/python/libstdcxx/v6/printers.py
# ${EXT_DIR}/myDepency/gdb_pretty_printer/python/libstdcxx/v6/printers.py:234

# for C++ template class cast, refer to : SharedPointerPrinter  in printers.py
# single void* member type cast : return self.val['_M_ptr'].cast(self.val.type.template_argument(0).pointer()).dereference()
# multiple member value format  : return " ({}*){} ".format( str(self.val.type.template_argument(0)) , str(self.val['_M_ptr']) )
# cast type to explicit type    : return self.val['sin_addr'].address().cast(gdb.lookup_type("unsigned char *"))

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

class std_mutex:
    """Print a std::mutex."""

    def __init__(self, val):
        self.val = val

    def to_string(self):
        return "std::mutex"

    def display_hint(self):
        return 'std::mutex'

def pretty_printer_general_common_type_list(val):
    if(str(val.type) == 'std::mutex'): return std_mutex(val)

gdb.pretty_printers.append(pretty_printer_general_common_type_list)

print(f'--------- leaving \033[92m{inspect.stack()[0][1]}:{inspect.stack()[0][2]}\033[0m')

