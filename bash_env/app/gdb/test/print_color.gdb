
echo  \033[31msource ${BASH_DIR}/app/gdb/test/print_color.gdb \033[0m \r\n
echo \033[36mhex output : \033[32m
printf "0x%016lX  \r\n", 3
echo \033[0m

echo \033[30mblack  : 0 \033[0m
echo \033[31m red    : 1 \033[0m
echo \033[32m green  : 2 \033[0m
echo \033[33m brown  : 3 \033[0m
echo \033[34m blue   : 4 \033[0m
echo \033[35m purple : 5 \033[0m
echo \033[36m cyan   : 6 \033[0m
echo \033[37m gray   : 7 \033[0m
echo \r\n

echo -------------------------------------------------------------------------------\r\n
echo   \033[35mp6 :\033[33m ${EXT_DIR}/myDepency/gdb_nvidia/dump_info/dump_kernel_launch_parameter_cask6.gdb \033[0m \r\n
echo   \033[35mpcu :\033[33m ${EXT_DIR}/myDepency/gdb_nvidia/dump_info/dump_kernel_launch_parameter_cutlass.gdb \033[0m \r\n
echo   \033[35mpnv :\033[33m ${EXT_DIR}/myDepency/gdb_nvidia/dump_info/dump_kernel_launch_parameter.gdb \033[0m \r\n
echo   \033[35mpref :\033[33m ${EXT_DIR}/myDepency/gdb_nvidia/dump_info/compare_cask_reference_findReferenceKernel.gdb \033[0m \r\n
echo   \033[35mgdb jump :\033[33m ${BASH_DIR}/app/gdb/test/jump_to_address.txt \033[0m \r\n
