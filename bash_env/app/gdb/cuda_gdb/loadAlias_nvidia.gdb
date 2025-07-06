
echo  +++++++++ loading ${BASH_DIR}/app/gdb/cuda_gdb/loadAlias_nvidia.gdb ...\r\n

# ************************************************************************************************************
define pnv
    source ${EXT_DIR}/myDepency/gdb_nvidia/dump_info/dump_kernel_launch_parameter.gdb
end
define p6
    source ${EXT_DIR}/myDepency/gdb_nvidia/dump_info/dump_kernel_launch_parameter_cask6.gdb
end
define pcu
    source ${EXT_DIR}/myDepency/gdb_nvidia/dump_info/dump_kernel_launch_parameter_cutlass.gdb
end
define pref
    source ${EXT_DIR}/myDepency/gdb_nvidia/dump_info/compare_cask_reference_findReferenceKernel.gdb
end

# ************************************************************************************************************
define update_callstack
	echo ${BASH_DIR}/app/gdb/cuda_gdb/loadAlias_nvidia.gdb:6 \r\n
    ! source ${BASH_DIR}/app/gdb/cmds/update_callstack.sh $arg0
end
document update_callstack
    update callstack for improving readability
    file : ${BASH_DIR}/app/gdb/cuda_gdb/loadAlias_nvidia.gdb
end

# ************************************************************************************************************

define rdrbt6
	echo ${BASH_DIR}/app/gdb/cuda_gdb/loadAlias_nvidia.gdb:17 \r\n
    rdr bt  -o  ${EXT_DIR}/myReference/note/temp_task/bt_$arg0_cask6.cpp
    update_callstack ${EXT_DIR}/myReference/note/temp_task/bt_$arg0_cask6.cpp
end
document rdrbt6
    write a gdb command bt output into a file
    file : ${BASH_DIR}/app/gdb/cuda_gdb/loadAlias_nvidia.gdb
end

define rdrbtcu
	echo ${BASH_DIR}/app/gdb/cuda_gdb/loadAlias_nvidia.gdb:27 \r\n
    rdr bt  -o  ${EXT_DIR}/myReference/note/temp_task/bt_$arg0_cutlass.cpp
    update_callstack ${EXT_DIR}/myReference/note/temp_task/bt_$arg0_cutlass.cpp
end
document rdrbtcu
    write a gdb command bt output into a file
    file : ${BASH_DIR}/app/gdb/cuda_gdb/loadAlias_nvidia.gdb
end

# ************************************************************************************************************

define rdrpcu
    echo ${BASH_DIR}/app/gdb/cuda_gdb/loadAlias_nvidia.gdb \r\n
	rdr p $arg0 -o  ${EXT_DIR}/myReference/note/temp_task/$arg1_cutlass.txt
    rdr pt $arg0 -o ${EXT_DIR}/myReference/note/temp_task/$arg1_type_cutlass.cpp
end
document rdrpcu
    write a object data and type info into a file.
    file : ${BASH_DIR}/app/gdb/cuda_gdb/loadAlias_nvidia.gdb
end

define rdrppcu
	echo ${BASH_DIR}/app/gdb/cuda_gdb/loadAlias_nvidia.gdb \r\n
    rdr p  *$arg0 -o ${EXT_DIR}/myReference/note/temp_task/$arg1_cutlass.txt
    rdr pt *$arg0 -o ${EXT_DIR}/myReference/note/temp_task/$arg1_type_cutlass.cpp
end
document rdrppcu
    write a object data and type info into a file.
    file : ${BASH_DIR}/app/gdb/cuda_gdb/loadAlias_nvidia.gdb
end

# ************************************************************************************************************
define rdrp6
	echo ${BASH_DIR}/app/gdb/cuda_gdb/loadAlias_nvidia.gdb \r\n
    rdr p $arg0 -o  ${EXT_DIR}/myReference/note/temp_task/$arg1_cask6.txt
    rdr pt $arg0 -o ${EXT_DIR}/myReference/note/temp_task/$arg1_type_cask6.cpp
end
document rdrp6
    write a object data and type info into a file.
    file : ${BASH_DIR}/app/gdb/cuda_gdb/loadAlias_nvidia.gdb
end

define rdrpp6
	echo ${BASH_DIR}/app/gdb/cuda_gdb/loadAlias_nvidia.gdb \r\n
    rdr p  *$arg0 -o ${EXT_DIR}/myReference/note/temp_task/$arg1_cask6.txt
    rdr pt *$arg0 -o ${EXT_DIR}/myReference/note/temp_task/$arg1_type_cask6.cpp
end
document rdrpp6
    write a object data and type info into a file.
    file : ${BASH_DIR}/app/gdb/cuda_gdb/loadAlias_nvidia.gdb
end

# ************************************************************************************************************

# bash_script_o

