echo +++++++++ loading ${BASH_DIR}/app/gdb/init/loadPath.gdb:1 ... \n
source ${BASH_DIR}/app/gdb/init/loadPath_python.py

# if auto-load is on, then gdb will load the module in : /usr/share/gdb/auto-load
# set debug auto-load on
# source      ./cmds/_run_gdb_env.gdb
# source      ./cmds/_run_sm90_amodel_env.sh

# add pre-defined source code path
# https://sourceware.org/gdb/onlinedocs/gdb/Source-Path.html
# show directories  | directory
echo \033[33madd directory   : \033[32m${EXT_DIR}/myDepency/src_in_docker/c++\033[37m\r\n
directory       "${EXT_DIR}/myDepency/src_in_docker/c++"
# https://ftp.gnu.org/gnu/glibc/
echo \033[33madd directory   : \033[32m${EXT_DIR}/myDepency/src_in_docker/glibc-2.23\033[37m\r\n
directory       "${EXT_DIR}/myDepency/src_in_docker/glibc-2.23"

# directory     "${cur_repo_dir}"
# directory     "/home/utils/gcc-4.1.1/gcc-4.1.1/libstdc++-v3/libsupc++"

# set substitute-path from to
# show substitute-path | unset substitute-path [path]
# if the file :
# /usr/include/c++/4.8.2/bits/shared_ptr.h      =>      /usr/include/c++/9/bits/shared_ptr.h
# then the command :
# set substitute-path /usr/include/c++/4.8.2  /usr/include/c++/9
# on 303  :  /usr/include/c++/4.8.2     =>  /usr/include/c++/9
# on sm75 :
echo \033[33mmap source code : \033[32m/usr/include/c++ \033[33m => \033[32m ${EXT_DIR}/myDepency/src_in_docker/c++ \033[37m\r\n
set substitute-path /usr/include/c++            ${EXT_DIR}/myDepency/src_in_docker/c++
echo \033[33mmap source code : \033[32m/build/glibc-S7Ft5T \033[33m => \033[32m ${EXT_DIR}/myDepency/src_in_docker \033[37m
set substitute-path /build/glibc-S7Ft5T     ${EXT_DIR}/myDepency/src_in_docker
set substitute-path /build/tmp              ${EXT_DIR}/myDepency/src_in_docker

# how to find the system build src :  https://developer.aliyun.com/article/498552
# info sources 
# /opt/rh/devtoolset-6/root/usr/include/c++/6.3.1/bits/stl_stack.h,
# /usr/include/x86_64-linux-gnu/bits/stat.h,
# /usr/lib/gcc/x86_64-linux-gnu/9/include/stddef.h,
# search & download : 
# e.g. https://ftp.gnu.org/gnu/gcc/?spm=a2c6h.12873639.article-detail.5.4623fb5fzwbjIF

# add pre-defined symbol search path
# path        "${cur_build_dir}"

# Set the list of directories (and their subdirectories) trusted for automatic loading and execution of scripts.
# https://sourceware.org/gdb/onlinedocs/gdb/Auto_002dloading-safe-path.html
# gdb will load the module in : /usr/share/gdb/auto-load
# show auto-load safe-path   |   set auto-load safe-path   <reset_load_path1:reset_load_path2:reset_load_path3>
add-auto-load-safe-path     ${BASH_DIR}/app/gdb/cmds
add-auto-load-safe-path     ${BASH_DIR}/app/gdb/feature/bp
add-auto-load-safe-path     /home/utils/gcc-11.2.0/lib64

echo \nshow auto-load safe-path : \n
show auto-load safe-path

echo --------- leaving ${BASH_DIR}/app/gdb/init/loadPath.gdb:57  \n 

