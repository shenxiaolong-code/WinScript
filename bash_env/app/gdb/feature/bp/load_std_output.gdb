
# https://stackoverflow.com/questions/1538463/how-can-i-put-a-breakpoint-on-something-is-printed-to-the-terminal-in-gdb
# breakpoint on std::cout
b write if 1==$rdi
    commands
    silent
    finish
    end

# https://stackoverflow.com/questions/8235436/how-can-i-monitor-whats-being-put-into-the-standard-out-buffer-and-break-when-a
# on 32 bit system 
# b write if 1 == *(int*)($esp + 4) && strcmp((char*)*(int*)($esp + 8), "your string") != 0
# da $esp + 8

# on 64 bit system 
# b write if 1 == $rdi && strcmp((char*)($rsi), "your string") != 0

# not equal , but match
# b write if 1 == $rdi && strstr((char*)($rsi), "your string") != 0
# da $rsi
