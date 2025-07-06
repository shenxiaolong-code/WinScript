

echo \033[36m+++++++++ loading \033[35m${BASH_DIR}/app/gdb/feature/bp/load_breakpoint_examples.gdb \033[37m...\r\n
echo loading breakpoints ..

# source ${BASH_DIR}/app/gdb/feature/bp/load_app_spec_breakpoint.py
source ${BASH_DIR}/app/gdb/cuda_gdb/gdb_init_nvidia.gdb

# breakpoint on funcName No 3 line
# b funcName + 3

if 0
    # 创建新的条件断点
    b tester_util.cpp:370  if i == 2
        commands
            p i
        
    # 创建新的一次性断点
    tbreak  tester_util.cpp:370

    # 创建函数内部偏离指定行的断点， 例如在函数内部偏离函数名称行 7 行的断点
    b DynamicShaderGenerator::generateDynamicShader:7
    command
    p name
    continue
    end

    # 给存在的断点 15 做附加：
    # 增加断点条件
    condition 15 i == 2
    
    # 清除断点条件
    conditions 15
    
    # 增加断点执行命令
    commands 15
    # b   __GI___assert_fail

    # break on all function in a source file
    # rbreak example.cpp:.*

    b writeFile
    b readBytes

    # break on cout << 
    # rbreak std::ostream::operator<<
    # or
    # info func std::ostream::operator<<
    # b ostream:606        

    b           "operator new"
    rbreak      .*::operator\(\)
    # https://stackoverflow.com/questions/1538463/how-can-i-put-a-breakpoint-on-something-is-printed-to-the-terminal-in-gdb
    # breakpoint on std::cout
    b write if 1==$rdi

    # https://stackoverflow.com/questions/8235436/how-can-i-monitor-whats-being-put-into-the-standard-out-buffer-and-break-when-a
    # on 32 bit system 
    # b write if 1 == *(int*)($esp + 4) && strcmp((char*)*(int*)($esp + 8), "your string") != 0
    # da $esp + 8

    # on 64 bit system 
    # b write if 1 == $rdi && strcmp((char*)($rsi), "your string") != 0

    break function if strcmp(output_string, "exception") == 0

    b 16 if $_regex(str1, ".*char11.*")
    b 18 if $_regex(str2.c_str(), ".*string11.*")

    break tester_util.cpp:292
        condition $bpnum reference_provider == 1
        commands
          p reference_shader.name_
          p shader->name_
        end

    # not equal , but match
    # b write if 1 == $rdi && strstr((char*)($rsi), "your string") != 0
    # da $rsi

    # str is std::string string    
    b xmma/xmma_jit/include/xmma_jit/cpp/string.h:67 if str.find("wo2",0) != -1

    # watch $rsp if $_regex($_as_string($rip), ".* <target_fn")

    b write if 1 == $rdi && strstr((char*)($rsi), "cannot find serialization") != 0
        commands
            silent
            finish
        end
    # ignore 1 220


    b kernel_dispatch.cpp:194
        commands
            silent
            ba serialization_mode_
            continue
        end
    
    set $var = 0                                # yes, you can declare variables ...
    break function2 if $var++ < 3
        command 3
            print $var
            backtrace full
            continue
        end

    echo \033[33mDone to load breakpoints \n\n\033[37m
    bl
    
end

echo \033[36m\r\n--------- leaving \033[35m${BASH_DIR}/app/gdb/feature/bp/load_breakpoint_examples.gdb:79  \033[37m ... \r\n

