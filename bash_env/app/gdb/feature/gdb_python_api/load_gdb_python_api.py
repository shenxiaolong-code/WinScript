


import sys 
# need libstdcxx exist
# /home/utils/gdb-12.1-2  has not include libstdcxx
# sys.path.insert(0, '/home/utils/gdb-12.1-2/share/gdb/python')

# see :  ${BASH_DIR}/nvidia/loadEnv/loadEnv_build_farm_cask6_sm100_amodel.sh:59
# see :  ${BASH_DIR}/nvidia/loadEnv/loadEnv_build_farm_cask6_sm90_not_amodel.sh:27
sys.path.insert(0, '${EXT_DIR}/myDepency/gdb_pretty_printer/gdb_python_api')

