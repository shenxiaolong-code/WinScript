
bash_script_i

# code --install-extension  betwo.vscode-linux-binary-preview           # binary preview
# Supported file types
# Shared objects (.so)
# Archives (.a)
# Executable binary files
# Compressed Archives (.tar, .rar, .zip, .7z)

# 在Linux系统中，有几种方法可以找到模块：
# 1. lsmod                此命令列出了当前在Linux内核中加载的所有模块⁵。
# 2. modprobe             此命令可以用来在当前目录和子目录中查找所有模块³。
# 3. find                 可以用来在当前目录和子目录中搜索所有带有“.ko”扩展名的文件³。
# 4. modinfo              此命令显示有关Linux内核加载模块的信息⁵。
# 5. /proc/modules file   此文件包含了所有已加载模块的列表²。
# 6. /lib/modules/$(uname -r)/modules.builtin file    此文件包含了所有内置模块的列表⁴。

# fetch symbol
# nm -CD libcask_cutlass3x.so | grep 'W cutlass::' | wc -l

mod_name=${1:-"libstdc++.so.6"}
# mod_name=${1:-"libcudart.so.11.0"}
# g++ -print-file-name=libasan.so
# /usr/lib/gcc/x86_64-linux-gnu/9/libasan.so
dumpinfox "query the module path :${brown} g++ -print-file-name=${mod_name}"
find_module_path ${mod_name}

echo
dumppos
echo "debug/show verbose link/run procedure of ${mod_name}"
# https://docs.google.com/presentation/d/1qZBUG_P87TZ8st1a_gjH9Fh_MclTQPUdaeR8fAwitKs/edit#slide=id.g230a5d89770_0_62
echo "${green}setenv LD_DEBUG 'help /bin/ls' ${end}"
# ls 
echo "${green}setenv LD_DEBUG 'libs /bin/ls' ${end}"
# ls
# unsetenv LD_DEBUG

echo
dumppos
echo "show File information whether it has debug symbols or not"
echo "${green}file ${mod_name}  ${end}"

echo
dumppos
echo "all symbols string in module, similiar dumpbin on windows"
# readelf --dyn-syms ${mod_name}         # need build with -rdynamic option 
# readelf -a ${mod_name}                 # show all info , similiar dumpbin on windows
echo "${green}readelf -a ${mod_name}  ${end}"
echo "all direct depencies in module, similiar ldd"
echo "${green}readelf -d ${mod_name} | grep "NEEDED" ${end}"

echo
dumppos
echo "${green}list all depencies of Linked libraries, similiar with windbg : lm${end}"
echo "${green}ldd  ${mod_name}  ${end}"
echo "${green}using lsmod to list all loaded modules and grep output result ${end}"
echo "${red}lsmod${end}"

echo
dumppos
echo "show all string in module"
echo "${green}strings  ${mod_name}  ${end}"

echo
dumppos
echo "all contained symbols in module which is installed in current system"
# nm -C xxx.a
# nm -C ${mod_name}                      # dump unqualified name in .a file , similiar with windows dumpbin
echo "${green}nm ${mod_name}  ${end}"

echo
dumppos
echo "${green}direct located the required module ${end}"
echo "e.g. locate  ${mod_name} "
echo ${red}locate  ${mod_name}  ${end}

echo
dumppos
echo "${green}scan system process module, and fine the required module path ${end}"
echo "e.g. dpkg -L libstdc++6 | grep python"
echo "${red}dpkg -L ${mod_name} | grep python${end}"

echo
dumppos
echo "${green}ls /lib/x86_64-linux-gnu/${mod_name}*${end}"
ls /lib/x86_64-linux-gnu/${mod_name}*
echo "${green}ls /usr/lib/x86_64-linux-gnu/${mod_name}*${end}"
ls /usr/lib/x86_64-linux-gnu/${mod_name}*



echo
bash_script_o
