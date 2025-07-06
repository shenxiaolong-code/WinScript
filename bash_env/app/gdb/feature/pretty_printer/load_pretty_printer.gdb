# bash_script_i
# dpkg --list | grep libstdc++

# see :
# ${EXT_DIR}/myDepency/tools/gdb12/static_gdb12/share/gdb/python/gdb/command/pretty_printers.py

source      ${BASH_DIR}/app/gdb/feature/pretty_printer/pretty_printer_nvidia.py
source      ${BASH_DIR}/app/gdb/feature/pretty_printer/pretty_printer_template_type.py
source      ${BASH_DIR}/app/gdb/feature/pretty_printer/pretty_printer_general_common_type.py
source      ${BASH_DIR}/app/gdb/feature/pretty_printer/pretty_printer_gdb_func.gdb
# source    ${BASH_DIR}/app/gdb/test/stl-views.gdb

define iprinter
    source ${BASH_DIR}/app/gdb/feature/pretty_printer/test/list_pretty_printer_file_path.py
end
document iprinter
	listed loaded printer path.
    ${BASH_DIR}/app/gdb/feature/pretty_printer/load_pretty_printer.gdb
end

if $_isvoid($pretty_printer_builtin_stl)==1
    source ${BASH_DIR}/app/gdb/feature/pretty_printer/pretty_printer_builtin_stl.py
else        
    echo \033[33mbelow pretty printer is loaded, skipping reload to avoid python exception .... \r\n \033[37m
    echo \033[36m${BASH_DIR}/app/gdb/feature/pretty_printer/pretty_printer_builtin_stl.py \r\n \033[37m
end

# cudagdb is defined in $env::HOME/bash_env/app_init/cuda-gdbinit
if $_isvoid($cudagdb)==1  
    # cuda gdb doesn't support below python interpreter
    # Unable to locate matching libpython3.9 for the installed python3 interpreter. Python integration disabled.

    echo \033[33mcuda-gdb is not used. \r\n \033[37m    
    # source ${BASH_DIR}/app/gdb/feature/pretty_printer/pretty_printer_nvidia.py
    set $pretty_printer_builtin_stl=1
else
    echo \033[36m[cuda gdb] \033[35mstl pretty printer is disabled becaused python issue on cuda-gdb. \033[37m \r\n
end

# use cmd 'pr' to print raw structure (print raw)

# use below command to show registered pretty printer
# info pretty-printer  | disable/enable   pretty-printer

source  ${BASH_DIR}/app/gdb/feature/pretty_printer/pretty_printer_gdb_func.gdb

# bash_script_o