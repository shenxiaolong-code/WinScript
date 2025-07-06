echo ++++++++++++++  hello , ${green}loading${end} ${BASH_DIR}/app/gdb/feature/version/install_gdb_without_sudo_test.sh ...
# https://blog.csdn.net/sl8023dxf/article/details/125352791

# install into ${EXT_DIR}/myDepency/tools/gdb
# set gdb_install_dir=${EXT_DIR}/myDepency/tools/gdb-11
# ${gdb_install_dir}/bin/gdb --version

# set gdb_install_dir=${EXT_DIR}/myDepency/tools/gdb9
gdb_install_dir=`which gdb | sed 's#/gdb##'`
export  path="${gdb_install_dir}:${path}"
export  LD_LIBRARY_PATH="${gdb_install_dir}:${path}:${LD_LIBRARY_PATH}"

echo
echo "${red}gdb --version${end}"
${gdb_install_dir}/gdb --version

echo
echo "${red}gdb -config${end}"
${gdb_install_dir}/gdb -config 

# configure
# By default this will install gdb binaries in /usr/local/bin and libs in /usr/local/lib
# export  PATH="${gdb_install_dir}/bin;${PATH}"
# export PATH=${gdb_install_dir}/bin;${PATH}
# alias gdb       "${gdb_install_dir}/bin/gdb"

echo --------------  byebye, ${red}leaving${end} ${BASH_DIR}/app/gdb/feature/version/install_gdb_without_sudo_test.sh