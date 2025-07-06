
echo  +++++++++ loading ${BASH_DIR}/app/gdb/cuda_gdb/loadOptions_cudagdb.gdb ...\r\n

# https://docs.google.com/presentation/d/1qZBUG_P87TZ8st1a_gjH9Fh_MclTQPUdaeR8fAwitKs/edit#slide=id.g2310ef90fc8_2_19

# auto stop in kernel launch, check params
set cuda  break_on_launch application
# disassemble/s

# If you forget to sync before checking result, this helps. 
set cuda launch_blocking 1
set cuda notify youngest

# Check launch params
# info cuda kernels

# https://docs.nvidia.com/cuda/cuda-gdb/index.html#set-cuda-break-on-launch
# fix : the variables may not be live all the time and will be reported as “Optimized Out”.
set cuda ptx_cache on

#  When enabled, this option tells the debugger to use safe tricks to accelerate single-stepping.
set cuda single_stepping_optimizations on

# bash_script_o

