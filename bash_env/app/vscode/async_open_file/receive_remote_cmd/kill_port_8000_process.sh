bash_script_i
echo

# $ lsof -i:8000
# COMMAND     PID      USER   FD   TYPE   DEVICE SIZE/OFF NODE NAME
# python3 3934032 xiaolongs    4u  IPv4 24957473      0t0  TCP *:8000 (LISTEN)

# pgrep will exclude the self query process. it is better to query the pid directly
# pgrep -f server_listen_on_303.py
# 3934032

# port_used=$(lsof -i:8000 | grep "xiaolongs")
# pid_8000=$(echo ${port_used} | cut -d' ' -f 2)
pid_8000=$(pgrep -f server_listen_on_303.py)
if [[ "${pid_8000}" != "" ]] ; then
    # dumpkey  pid_8000
    ps -p ${pid_8000}
    lsof -i:8000 | grep "xiaolongs"
    dump_and_run_shell_cmd "kill -9 ${pid_8000}"
    [[ "${pid_8000}" != "" ]] && kill -9 ${pid_8000}
else
    dumpinfo "server_listen_on_303.py is not rinning."
fi

echo
bash_script_o
