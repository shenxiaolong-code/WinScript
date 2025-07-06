#!/bin/bash

bash_script_i

# 声明全局变量
key_public_file_path=""
suffix="$(hostname | sed 's#\..*##g')_$(date "+%Y%m%d_%H%M")"

# 检查文件是否存在并删除
check_and_delete_file() {
    # 删除私钥文件
    [[ -f "${key_file_path}" ]] && rm -f "${key_file_path}"
    # 删除公钥文件
    [[ -f "${key_public_file_path}" ]] && rm -f "${key_public_file_path}"
}

# 生成 RSA 密钥
gen_key_rsa() {
    local key_size=4096  # 默认密钥大小
    key_file_path="$HOME/.ssh/id_rsa_${suffix}"
    key_public_file_path="${key_file_path}.pub"
    
    check_and_delete_file

    echo "Generating RSA key with size $key_size..."
    ssh-keygen -t rsa -b "$key_size" -f "$key_file_path" -N "" -C "linux_${suffix}"
    echo "RSA public key file path: $key_public_file_path"
}

# 生成 DSA 密钥
gen_key_dsa() {
    local key_size=1024  # DSA 的默认密钥大小
    key_file_path="$HOME/.ssh/id_dsa_${suffix}"
    key_public_file_path="${key_file_path}.pub"
    
    check_and_delete_file

    echo "Generating DSA key with size $key_size..."
    ssh-keygen -t dsa -b "$key_size" -f "$key_file_path" -N "" -C "linux_${suffix}"
    echo "DSA public key file path: $key_public_file_path"
}

# 生成 ECDSA 密钥
gen_key_ecdsa() {
    local key_size=256  # 默认密钥大小
    key_file_path="$HOME/.ssh/id_ecdsa_${suffix}"
    key_public_file_path="${key_file_path}.pub"
    
    check_and_delete_file

    echo "Generating ECDSA key with size $key_size..."
    ssh-keygen -t ecdsa -b "$key_size" -f "$key_file_path" -N "" -C "linux_${suffix}"
    echo "ECDSA public key file path: $key_public_file_path"
}

# 生成 Ed25519 密钥
gen_key_ed25519() {
    key_file_path="$HOME/.ssh/id_ed25519_${suffix}"
    key_public_file_path="${key_file_path}.pub"
    
    check_and_delete_file

    echo "Generating Ed25519 key..."
    ssh-keygen -t ed25519 -f "$key_file_path" -N "" -C "linux_${suffix}"
    echo "Ed25519 public key file path: $key_public_file_path"
}

# 主程序入口
main() {
    dumpinfox "Starting SSH key generation..."
    gen_key_rsa
    # gen_key_dsa
    # gen_key_ecdsa
    # gen_key_ed25519
    dumpinfo "SSH keys generated successfully."

    echo
    dumpinfox "Updating permissions ( authorized_keys and known_hosts ) ..."
    # chmod 700 ~/.ssh
    # chmod 640 ~/.ssh/authorized_keys
    # make myself is authorized by others
    echo "# public key generated on $suffix"    >> ~/.ssh/authorized_keys
    cat  ${key_public_file_path}                >> ~/.ssh/authorized_keys
    echo "\n"                                   >> ~/.ssh/authorized_keys
    # make myself is known by others
    echo "# public key generated on $suffix"    >> ~/.ssh/known_hosts
    cat  ${key_public_file_path}                >> ~/.ssh/known_hosts
    echo "\n"                                   >> ~/.ssh/known_hosts
    dumpinfo "Permissions updated successfully."

    echo
    ssh_key_file=$(echo $key_file_path | sed "s#_$suffix##")
    dumpinfox "update symbol link : $ssh_key_file "
    [[ -f $ssh_key_file ]] && rm $ssh_key_file && rm $ssh_key_file.pub
    ln -s   $key_file_path          $ssh_key_file
    ln -s   $key_file_path.pub      $ssh_key_file.pub
}

main "$@"

echo
dumpinfox "Public key file path: ${brown} ${key_public_file_path}"
dumpinfo "For Git repo, add the .pub key into: ${red} https://gitlab-master.nvidia.com/-/profile/keys"
dumpinfo "Copy the public key file content to remote machine file: ${purple} %USERPROFILE%/.ssh/authorized_keys"

bash_script_o