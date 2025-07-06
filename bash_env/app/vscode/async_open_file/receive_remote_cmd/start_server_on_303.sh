bash_script_i
# dumpcmdline

# if ! ps -ef | grep -v grep | grep server_listen_on_303.py > /dev/null; then
#     source ${BASH_SOURCE[0]%/*}/start_server_on_303.sh
# fi

if [[ "computelab-303.nvidia.com" =~ "$(hostname)" ]] ; then
    ps | pgrep -f server_listen_on_303.py > /dev/null && code_server_is_runnning=1 || code_server_is_runnning=0
    if [[ "${code_server_is_runnning}" == "0" ]] ; then
        # active_python_virtual_env_last
        # else sometime there is the python syntax error, so we need to use the python303_env
        # print(f'cmd: python {" ".join(sys.argv)}\r\n\x1b[30m{inspect.stack()[0][1]}:{inspect.stack()[0][2]}\x1b[0m')
        # SyntaxError: invalid syntax
        python303_env="${EXT_DIR}/myDepency/python_suite/generated_virtual_env/dkg_303/env/bin/python"

        # sleep 2
        dumpcmd "python ${BASH_SOURCE[0]%/*}/impl/server_listen_on_303.py"
        # setsid env will fork current process and run the command in a new session with current environment
        # setsid env python ${BASH_SOURCE[0]%/*}/impl/server_listen_on_303.py &
        ${python303_env} ${BASH_SOURCE[0]%/*}/impl/server_listen_on_303.py &
    else
        pid_8000=$(pgrep -f server_listen_on_303.py)
        # ps -p ${pid_8000}
        [[ ${disable_bash_script_io} != 1 && $# == 0 ]] && command echo -e "server_listen_on_303.py is running ... , pid : ${pid_8000}  \r\nRun ' kill -9 ${pid_8000} ' or ' kill303 ' to kill it."
    fi
else
    dumpinfo "start_server_on_303.sh can only run on 303 machine, current $(hostname) is Not on computelab-303.nvidia.com"
fi

bash_script_o
