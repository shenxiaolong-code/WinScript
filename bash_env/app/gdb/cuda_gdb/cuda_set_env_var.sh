
echo \033[36m+++++++++ loading \033[35m${BASH_DIR}/app/gdb/cuda_gdb/cuda_set_env_var.sh\033[37m ...
# https://docs.nvidia.com/cuda/cuda-gdb/index.html#set-cuda-break-on-launch

export  CUDA_LAUNCH_BLOCKING=1

# # https://docs.google.com/presentation/d/1qZBUG_P87TZ8st1a_gjH9Fh_MclTQPUdaeR8fAwitKs/edit#slide=id.g2310ef90fc8_2_19
# avoid cudagdb hang issue 
export  CUDA_VISIBLE_DEVICES=0

# If breakpoints are unable to be hit, try setting this environment variable before starting your application.
export  OPTIX_FORCE_DEPRECATED_LAUNCHER=1

export  CUDBG_USE_LEGACY_DEBUGGER=1

echo \r\n\033[36m--------- leaving \033[35m${BASH_DIR}/app/gdb/cuda_gdb/cuda_set_env_var.sh\033[37m ...