
bash_script_i
# \echo -e "\n#\e[1;31m delay run:\e[1;32m ${BASH_SOURCE[0]%/*}/delay_start_launch.sh  \e[0m\n"

if [[  "$envMode" == "303"  ]] ; then
    :
    # it will cause python syntax error for correct statement
    # source ${BASH_DIR}/app/vscode/async_open_file/receive_remote_cmd/start_server_on_303.sh  noShow
fi

bash_script_o
