#!/bin/bash

bash_script_i

# search cpp std path
# in general, it is /usr/include/c++/
# gcc -v  or g++ -v or  clang++ -v -E clang++
# g++ -E -v -xc++ /dev/null
# search vector under /usr/include/

[[ $envMode == "computeLabBuild" ]] && STD_LIB_PATH="/home/utils/gcc-11.2.0/include/c++/$(command ls /home/utils/gcc-11.2.0/include/c++/ | tail -n 1)"
[[ $envMode == "farm"            ]] && STD_LIB_PATH="/home/utils/gcc-11.2.0/include/c++/$(command ls /home/utils/gcc-11.2.0/include/c++/ | tail -n 1)"
[[ $envMode == "docker"          ]] && [[ -d "/home/utils/gcc/include/c++" ]] && STD_LIB_PATH="/home/utils/gcc/include/c++/$(command ls /home/utils/gcc/include/c++/ | tail -n 1)"
[[ $envMode == "303"             ]] && STD_LIB_PATH="/usr/include/c++/$(command ls /usr/include/c++/ | tail -n 1)" && PLATFORM_LIB_PATH="/usr/include/x86_64-linux-gnu/c++/9"

[[ ! -f ${STD_LIB_PATH}/vector ]] && STD_LIB_PATH=""
[[ -d  ${STD_LIB_PATH} ]] && {
    # e.g. /usr/include/c++/9
    export  STD_LIB_PATH             # gcc C++ standard library path
    # e.g. /usr/include/x86_64-linux-gnu/c++/9
    export  PLATFORM_LIB_PATH      # gcc platform specific path, include arch spec, os spec, platform spec type etc.
    dumpkey STD_LIB_PATH 
    dumpkey PLATFORM_LIB_PATH
}

function show_cpp_dev_info() {
    dumppos
    dumpkey STD_LIB_PATH 
    dumpkey PLATFORM_LIB_PATH
    echo '#include <type_traits>' | g++ -v -x c++ -c - 2>&1 | grep -A 20 "#include <...>"
}

function find_cpp_header_compile_denpendency() {
    local header_file=${1:-type_traits}
    dumpinfo "compile std file${red} ${header_file} ${blue}without link"
    echo "#include <${header_file}>" | g++ -v -x c++ -c - 2>&1 | grep -A 20 "#include <...>"
}

alias icpp=show_cpp_dev_info

bash_script_o
