
bash_script_i
# no passward input everytime
# https://cloud.tencent.com/developer/ask/sof/108946114
# run : gpg-agent --daemon
# svn up  --> prompt input password , do it.
# later svn command will not request password

dumpinfo "use cmd ${brown} myip ${blue} on local window terminal to get the svn server IP"
dumpinfo "run ${brown}svnip${blue} <serverIP> to update server IP: svn relocate https://<serverIP>/svn/work/linuxPratice/docker"
dumpinfo "username : xlshen , pwd : a1 sequence of 8 characters\n"
# svn info | grep URL:
# echo "svn relocate https://<srv_v4_IP_from_ipconfig>/svn/work/linuxPratice/docker"
# echo example : svn relocate https://10.19.164.213/svn/work/linuxPratice/docker

if is_inside_git_svn_repo ; then
    # https://stackoverflow.com/questions/2899209/how-to-save-password-when-using-subversion-from-the-console
    dumpinfo "restore svn password save:"
    # dumpinfo python ${BASH_DIR}/app/svn/store-plaintext-password.py -u xlshen "<https://10.19.180.103> VisualSVN Server"
    dumpinfo python ${BASH_DIR}/app/svn/store-plaintext-password.py -u xlshen "<https://$(svn info | grep "Repository Root" | sed "s#.*//##" | sed "s#/.*##")> VisualSVN Server"
    dumpinfo "if not work , update manually the newest file below ${HOME}/.subversion/auth/svn.simple/  by ${BASH_DIR}/app/svn/subversion_auth_svn_simple_example.txt."
    echo
fi

dumpinfo "frequently used svn cmds: ${purple}${BASH_DIR}/app/svn/alias_svn.sh ${end}"
dumpinfo "${red}svnc ${green}: commit current svn repo;   ${red}svnsh ${green}: commit bash script;   ${red}   svnpy ${green}: commit linux Repo;  ${red} svna ${green}: commit all svn on linux; ${end}"

echo
dumpinfox  "run cmd '${red} hsvn ${blue}' to show svn commit id related cmd"
# svn status | grep '^M' | awk '{print $2}' | xargs svn revert
# svn status | grep '^A' | awk '{print $2}' | xargs svn revert
# svn status | grep '^?' | awk '{print $2}' | xargs rm

# code --diff ${BASH_DIR}/nvidia/log_analysis/filte_build_error_lines.sh https://10.23.148.225:443/svn/work/linuxPratice/docker/nvidia/log_analysis/filte_build_error_lines.sh

# svn help commit
# svn relocate https://10.19.180.103/svn/work/linuxPratice/linuxScript  --username 'xlshen' --password 'aaAA11!!' --non-interactive   # --no-auth-cache

# find ~/.subversion/ -type f -iname "*"

echo
# echo cmd line : !!
bash_script_o
