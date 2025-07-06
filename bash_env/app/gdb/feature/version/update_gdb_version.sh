echo ++++++++++++++  hello , ${green}loading${end} ${BASH_DIR}/app/gdb/feature/version/update_gdb_version.sh ...


# best to use newer gdb version ( > 9) , newer gdb will provide powser feature.
# https://confluence.nvidia.com/pages/viewpage.action?spaceKey=~jianh&title=A+Simple+way+to+Remote+debug+TensorRT+in+VSCode
# https://drive.google.com/file/d/1xV_ppU5T2DRA9GIv0PtN8N6s-ttIdaMQ/view?usp=sharing

# show version
gdbVer=`gdb --version | grep "GNU gdb" | awk '{print $NF}' | cut -d'.' -f 1 `
if [[ "$1" == "" ]] ; then
    echo "current gdb version: ${gdbVer}"
    gdb --version | grep "GNU gdb" 
fi

if [[ ${gdbVer} < 9 ]] ; then
    if [[ "$1" == "" ]] ; then
        echo update gdb path.
    fi
    
    gdb_install_dir="${EXT_DIR}/myDepency/tools/gdb"
    # set gdb_install_dir="${EXT_DIR}/myDepency/tools/gdb-11"
    
    alias   gdb="${gdb_install_dir}/bin/gdb"
    export  LIBDIR="${gdb_install_dir}/lib"
    export  LD_LIBRARY_PATH="${gdb_install_dir}/lib:${path}:${LD_LIBRARY_PATH}"
    export  path="${gdb_install_dir}/bin:${path}"
    
    
    gdb --version | grep "GNU gdb" 
    if [[ "$1" == "" ]] ; then
        echo "new gdb version:"
        gdb --version | grep "GNU gdb" 
    fi
fi

echo --------------  byebye, ${red}leaving${end} ${BASH_DIR}/app/gdb/feature/version/update_gdb_version.sh