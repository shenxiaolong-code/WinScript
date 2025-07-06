

echo \033[36m+++++++++ loading \033[35m${BASH_DIR}/app/gdb/feature/bp/alias_gdb_breakpoint.gdb \033[37m...\r\n

# this is a wrapper script to resolve load error issue in inital loading.

# this script should be called in inital script without any parameter , else it will throw below error.
# ${BASH_DIR}/app/gdb/feature/bp/alias_gdb_breakpoint.gdb:4: Error in sourced command file:
# $env::HOME/bash_env/nvidia/gdb_init_nvidia.gdb:215: Error in sourced command file:
# Invalid type combination in equality test.

# for predefined_breakpoint_impl.gdb :
# if with parameter , it can't be called in script.  but it needs parameter when call it manual.

# https://stackoverflow.com/questions/3744554/testing-if-a-gdb-convenience-variable-is-defined
# https://sourceware.org/gdb/onlinedocs/gdb/Command-and-Variable-Index.html

define load_breakpoint_hints
    echo xxv manifest to query global variables
    echo \r\n${BASH_DIR}/app/gdb/feature/bp/alias_gdb_breakpoint.gdb
    echo \r\nuse single commnad 'd' without parameter to cleanup all breakpoints. 'bl' to list all breakpoints.
    echo \r\nUpdate filter         : \033[36m${BASH_DIR}/app/gdb/feature/skip_filter/loadFilter_nvidia.gdb \033[37m
    echo \r\nUpdate multiple debug : \033[36m${BASH_DIR}/app/gdb/init/debug_multiple_thread_process.gdb \033[37m    
    echo \r\nUpdate breakpoint map : \033[35m${BASH_DIR}/app/gdb/feature/bp/load_app_spec_breakpoint.py \033[37m    
    echo \r\n\033[32mrun cmd '\033[33mbsave\033[32m' or '\033[33mbload\033[32m' to save/load breakpoint from file.\033[37m\r\n
    echo \r\n\033[32mrun cmd '\033[33mbps\033[32m' to open breakpoint file list.\033[37m\r\n

    # echo \r\n\033[32m1.Task-related    breakpoint :\033[31m ${EXT_DIR}/myTasks/curTask/cutlass_ramp_up/breakpoint.gdb  \033[37m
    echo \r\n\033[32m2.Project-related breakpoint :\033[35m ${BASH_DIR}/app/gdb/cuda_gdb/gdb_init_nvidia.gdb  \033[37m
    echo \r\n\033[32m                             :\033[31m ${BASH_DIR}/app/gdb/feature/bp/load_app_spec_breakpoint.py  \033[37m
    echo \r\n\033[32m2.1. app-related breakpoint  : 
    show_script_path " "
    echo \033[32m3.General         breakpoint :\033[31m ${BASH_DIR}/app/gdb/feature/bp/load_breakpoint_examples.gdb  \033[37m
    echo \r\n\033[32m4.Entry main      breakpoint :\033[31m ${BASH_DIR}/app/gdb/feature/bp/alias_gdb_breakpoint.gdb  \033[37m

    # e.g. Thread 1 "cask_forge" hit Breakpoint 14, 0x0000155553865910 in cask::TypeDeclEmitter::emit_(std::ostream&, cask::NotNull<cask::Type const*>)@plt () from /home/.../bin/libcask_core.so
    # https://stackoverflow.com/questions/28243549/prevent-plt-procedure-linkage-table-breakpoints-in-gdb
    echo \r\n\r\n\033[32muse '\033[33mb *func\033[32m' to set breakpoint, instead of  '\033[31mb func\033[32m' to avoid break in the @plt func in .so module.\033[37m
    echo \r\n\033[32muse '\033[33mb func:2\033[32m' to set breakpoint NO 2 line after the function, instead of  '\033[31mb func\033[32m' to avoid break in the @plt func in .so module.\033[37m
    echo \r\n\033[32mrun cmd '\033[33m info line cuda_runtime.h:1 \033[32m' to open \033[31m  cuda driver API header \033[32m to check ::cuXXX function.\033[37m\r\n    
    echo \r\n
end
document load_breakpoint_hints
    show breakpoint cmd and file path.
end

define bps
    # $argc can only be used in gdb function, it can't be used in gdb init procedure
    if $argc == 0
        load_breakpoint_hints
    else
        source ${BASH_DIR}/app/gdb/feature/bp/load_breakpoint_examples.gdb
    end
end
document bps
	reload gdb breakpoints : ${BASH_DIR}/app/gdb/feature/bp/load_breakpoint_examples.gdb
end

b main
    set $main_bp=$bpnum
    commands    
    # echo \033[36mLoading manual options after the module is loaded automatical ... \033[37m\r\n    
    echo \033[35mBreakpoint \033[32mmain \033[35mis hitted, load nvidia project seting ... \033[37m\r\n
    echo \033[32m${BASH_DIR}/app/gdb/feature/bp/alias_gdb_breakpoint.gdb:59 \033[37m\r\n
    source ${BASH_DIR}/app/gdb/feature/skip_filter/loadFilter_nvidia.gdb
    source ${BASH_DIR}/app/gdb/init/loadOptions_manual.gdb
    source ${BASH_DIR}/app/gdb/cuda_gdb/gdb_init_nvidia.gdb
    # d $bpnum
    printf "\nbreakpoint main number( $bpnum ) = %d \n", $main_bp    
    d $main_bp
    echo \r\n\033[32mBreakpoint \033[33mmain \033[32mis deleted after it is triggered! \033[37m\r\n
    frame 0
    echo \r\n\033[36mProject is loaded, now symbol query is available. \033[37m\r\n
end

# ****************************************************************************************************************************************************************

define bpw
    source     ${BASH_DIR}/app/gdb/feature/bp/load_std_output.gdb
end

document bpw
    set breakpoint on std::cout function , ${BASH_DIR}/app/gdb/feature/bp/alias_gdb_breakpoint.gdb
end

echo \033[36m--------- leaving \033[35m${BASH_DIR}/app/gdb/feature/bp/alias_gdb_breakpoint.gdb\033[37m ...\r\n

