#!/bin/bash

bash_script_i

# while_loop is better than for_loop
# because for_loop will expand the shell wildcard, which is not what we want if we are searching for a file , e.g. rea*
# if there are readme.md in the current directory, for_loop will expand it to search readme.md, instead of expected rea*
# while_loop will not expand the shell wildcard, so it will search for the expected rea*

function demo_pipe_accept_a_line(){
    ll | while read -r per_line; do
        echo "${per_line}"
    done | head -n 3
}

function demo_pipe_accept_a_line_and_split_by_space(){
    # git status --porcelain 
    echo  M cmake/Download.cmake | while read -r status file ; do
        echo "status: $status, file: $file"
    done

    echo  11 22 33 | while read -r col1 col2 col3 ; do
        echo "col2: $col2, col1: $col1,  col3: $col3"
    done
}

# a alternative way to replace the read_std_input
function demo_pipe_accpt_a_word(){
    for per_word in $(ls) ; do
        echo ${per_word}
    done
}

function demo_pipe_accpt_a_word_by_xargs(){
    # 不使用 -n1，一次性传递所有参数
    command echo "./tools ./test ./include" | xargs readlink -f
    # readlink -f ./tools ./test ./include

    # 使用 -n1，每次只传递一个参数
    command echo "./tools ./test ./include" | xargs -n1 readlink -f # | tr '\n' ' '
    command ls -1 -Artd ${job_path}/build_cmds/* | xargs -n1 -I @ echo @/cmds
    # readlink -f ./tools
    # readlink -f ./test
    # readlink -f ./include
}

# read_std_input resolve below issue
: '
echo "test pipeline" | use_pipe_func_fails
function use_pipe_func_fails() {
    local input=$1
    echo "use_pipe_func_fails : $input"    # the input is empty
}
# => # echo "test pipeline" | use_pipe_func_ok
function use_pipe_func_ok() {
    local input=$(read_std_input)
    echo "use_pipe_func_ok : $input"       # the input is ok
}
'

# read input parameter from command line pipe
# see use_pipe_func_ok
function read_std_input() {
    if [ -p /dev/stdin ]; then
        cat -
    else
        echo "$*"
    fi
}
# compatible with terminal and pipeline
# ls | user_pipe_func_example
# ll | user_pipe_func_example
function user_pipe_func_example() {
    while read std_input_line; do
        echo "${FUNCNAME[0]} : $std_input_line"
    done
}

# cat $file | pipe_callback myFunc
function pipe_callback() {
    local callback_user_func=$1
    shift

    while IFS= read -r std_input_line; do
        $callback_user_func $std_input_line ${@:1}
    done < <(read_std_input)
}
function test_pipe_callback() {
    while IFS= read -r std_input_line; do
        echo "$std_input_line"
    done < <(read_std_input)
}

bash_script_o
