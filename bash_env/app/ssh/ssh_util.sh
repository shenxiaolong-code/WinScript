bash_script_i


function get_remote_window_file() {
    local user_name="${USER}"  # 获取当前用户
    local remote_window_file_path="$1"  # 从参数获取远程 Windows 文件路径
    printf "# [info] remote_window_file_path = %s\n" "$remote_window_file_path"

    # 从 SVN 仓库中获取 Windows IP 地址
    local window_ip=$(svn info "${BASH_DIR}" | grep "^URL:" | sed 's#.*//##g' | sed 's#/.*##g')

    if [ -z "$window_ip" ]; then
        echo "无法从 SVN 仓库获取 Windows IP 地址"
        return 1
    fi

    # 自动处理 Windows 路径，将反斜杠替换为正斜杠
    local unix_path=$(printf "%s" "$remote_window_file_path" | sed 's#\\#/#g')
    
    # 获取文件名
    local file_name="${unix_path##*/}"

    # 使用 ssh 登录到 Windows 并复制文件到当前目录
    printf "# [info] 正在从 %s@%s:%s 复制文件到当前目录...\n" "$user_name" "$window_ip" "$unix_path"
    
    # password free methodlp
    # sshpass  -f ${BASH_DIR}/nvidia/init/windows_password_file.txt  scp -v "${user_name}@${window_ip}:${unix_path}" "./${file_name}"     # -f 从文件中获取密码
    scp -i ${HOME}/.ssh/id_rsa -v "${user_name}@${window_ip}:${unix_path}" "./${file_name}"         # -i 指定私钥文件
    # sshpass  -e  scp -v "${user_name}@${window_ip}:${unix_path}" "./${file_name}"                         # -e 从环境变量 SSHPASS 中获取密码

    # 使用 scp 命令进行文件复制，系统会提示输入密码
    # scp    "${user_name}@${window_ip}:${unix_path}" "./${file_name}"
    # scp -v "${user_name}@${window_ip}:${unix_path}" "./${file_name}"    

    # need windows to install sshd service
    # powershell -Command "Get-Service sshd"
    # powershell -Command "Start-Service sshd"
    # powershell -Command "Set-Service -Name sshd -StartupType 'Automatic'"

    # verify :
    # ssh xiaolongs@10.23.148.225
    # ssh xiaolongs@${window_ip}    
}


# get_remote_window_file 'C:\temp\llvm_ir_steps.png'


bash_script_o
