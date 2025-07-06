# bash_script_i
# https://www.adacore.com/gems/gem-119-gdb-scripting-part-1
# https://johnysswlab.com/gdb-a-quick-guide-to-make-your-debugging-easier/
echo --------- loading ${BASH_DIR}/app/gdb/test/test.gdb:16 ...\r\n
# shell /bin/ls --color=auto -1 -ArtdF ${BASH_DIR}/app/gdb/test/*

# echo the parameter count is : $argc  \r\n
# echo the first parameter is : $arg0  \r\n
source ${BASH_DIR}/app/gdb/test/print_color.gdb



# pnv : ${EXT_DIR}/myDepency/gdb_nvidia/dump_info/dump_kernel_launch_parameter.gdb

# shell /bin/ls --color=auto -1 -ArtdF ${BASH_DIR}/app/gdb/test/*
if 0
    set pagination off
    catch syscall write
    run
end

if $argc == 1
    f 1
    echo 0...
    p operands[0].kind()
    echo 1...
    p operands[1].kind()
    echo 2...
    p operands[2].kind()
    echo 3...
    p operands[3].kind()
    echo 4...
    p operands[4].kind()
    echo 5...
    p operands[5].kind()
    echo 6...
    p operands[6].kind()
    echo 7...
    p operands[7].kind()
end

if $argc == 2
    # source ${BASH_DIR}/app/gdb/test/test.gdb  "cu"
    if (int)strcmp($arg1, "cu") == 0
        echo "2nd parameter is cu."
    else
        echo "2nd parameter is NOT cu , it is $arg1."
    end
end

# help ftrace : might powerful
# ftrace conv2d_fprop_implicit_gemm_f32nhwc_f32nhwc_f32nhwc_simt_f32_sm100.cu:91


echo \r\n--------- leaving ${BASH_DIR}/app/gdb/test/test.gdb:22 ...\r\n\r\n\r\n