
# info pretty-printer

# should copy from /usr/share/gcc/python
print(f'+++++++++ loading \033[92m{inspect.stack()[0][1]}:{inspect.stack()[0][2]}\033[0m')
# how to know current used printers.py path
# see ${BASH_DIR}/app/gdb/feature/pretty_printer/debug_pretty_printer.py
# next 
# > /usr/share/gcc/python/libstdcxx/v6/printers.py(1530)__call__()
# e.g. ${EXT_DIR}/myDepency/gdb_pretty_printer/python/libstdcxx/v6/printers.py

import sys 
# need libstdcxx exist
# /home/utils/gdb-12.1-2  has not include libstdcxx
# sys.path.insert(0, '/home/utils/gdb-12.1-2/share/gdb/python')

# see :  ${BASH_DIR}/nvidia/loadEnv/loadEnv_build_farm_cask6_sm100_amodel.sh:59
# see :  ${BASH_DIR}/nvidia/loadEnv/loadEnv_build_farm_cask6_sm90_not_amodel.sh:27
sys.path.insert(0, '/home/utils/gcc-11.2.0/share/gcc-11.2.0/python')
# make a copy because the original path is not editable. we need to update/log it
# sys.path.insert(0, '${EXT_DIR}/myDepency/gdb_pretty_printer/python_from_gcc_1120')

from libstdcxx.v6.printers import register_libstdcxx_printers
# after 9.0 , register_libstdcxx_printers is loaded automatically.  previous gdb version need to be load manual.
register_libstdcxx_printers (None)

# print("--------- leaving ${BASH_DIR}/app/gdb/feature/pretty_printer/pretty_printer_builtin_stl.py ...")
print(f'--------- leaving \033[92m{inspect.stack()[0][1]}:{inspect.stack()[0][2]}\033[0m')

# Note
# get the pretty printer for stl
# Ensure that the GDB version is 7.0 or later. This means it has support for Python scripting

# need to find the correct libstdcxx path , check /usr/share path for version of libstdstdc++ -
# dpkg -L libstdc++6 | grep python
# e.g. :
# /usr/share/gcc/python/libstdcxx
# /usr/share/gcc-5/python/libstdcxx
# see implement :  /usr/share/gcc/python/libstdcxx/v6/printers.py

# issue : RuntimeError: pretty-printer already registered: libstdc++-v6
# https://stackoverflow.com/questions/18289377/gdb-runtimeerror-pretty-printer-already-registered-libstdc-v6
# solution : comment out the line : register_libstdcxx_printers (None)

# get the newest stl pretty printer
# https://sourceware.org/gdb/wiki/STLSupport
# # https://codeyarns.com/tech/2014-07-17-how-to-enable-pretty-printing-for-stl-in-gdb.html#gsc.tab=0
# svn co svn://gcc.gnu.org/svn/gcc/trunk/libstdc++-v3/python stlprettyprinter



