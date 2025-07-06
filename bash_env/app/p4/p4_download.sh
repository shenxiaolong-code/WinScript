#!/bin/bash

bash_script_i
echo

# need to check below clietn configuration file and replace the needed path
workspace_config_file="${BASH_SOURCE[0]%/*}/config/p4_client_map.txt"
p4_local_dir="/home/scratch.xiaolongs_gpu/sync_with_windows/nv_p4v_doc"

debug_p4=1

source ${BASH_SOURCE[0]%/*}/config/p4_server_config.sh

function configure_p4_variables() {
    # load from p4_client_map.txt
    export p4_client_config_file="$1"
    [[ ! -f "${p4_client_config_file}" ]] && { dumpkey p4_client_config_file  ; dumperr "p4_client_config_file ${p4_client_config_file} not found"; return 1; }
    dumpinfox "p4 client config file: ${p4_client_config_file}"
    dumpinfo "info comes from : ${p4_client_config_file}"
    P4CLIENT="$(grep -oP "(?<=^Client: )[^ ]+" ${p4_client_config_file} )"
    P4Root="$(grep -oP '(?<=^Root: )[^ ]+' ${p4_client_config_file})"
    [[ -z "${P4CLIENT}" || -z "${P4Root}" ]] && { dumpkey P4CLIENT ; dumpkey P4Root ; dumperr "P4CLIENT or P4Root is empty"; return 2; }

    load_p4_server_config_1

    return 0
}

function dump_p4_info(){
    dumpinfo "dump_p4_info ..."
    dumpinfox "p4 client config:"
    dumpkey P4CLIENT
    dumpkey P4Root
    dumpinfo "p4 client config:"
    grep -E '^[[:space:]]*View:' ${p4_client_config_file} | awk '{print $2}' | sed 's@^@# @g'

    echo
    dumpinfox "p4 server config:"
    dumpkey P4PORT
    dumpkey P4USER
    dumpkey P4PASSWD

    echo
    dumpinfox "p4 authentication ticket:${red} ${HOME}/.p4ticket"
    cat ${HOME}/.p4ticket
}

function create_p4_client_if_not_exist() {
    local P4Root="${p4_local_dir}/${P4CLIENT}"

    if ! p4 clients | grep -q "^Client ${P4CLIENT} "; then
        dumpinfox "P4CLIENT ${P4CLIENT} 不存在，自动创建..."
        local tmp_file="${TEMP_DIR}/to_del/${P4CLIENT}.p4client"
        p4 client -o $P4CLIENT > ${tmp_file}
        sed -i "s#^Root:.*#Root: ${P4Root}#" ${tmp_file}

        # 自动生成 View 字段
        awk '/^View:/ {flag=1; print "View:"; next} flag && NF==0 {flag=0} !flag {print}' ${tmp_file} > ${tmp_file}.tmp
        grep -E '^[[:space:]]*View:' ${p4_client_config_file} | awk '{print "\t" $2, $3}' >> ${tmp_file}.tmp
        mv ${tmp_file}.tmp ${tmp_file}
        dumpinfo "${tmp_file}"
        cat ${tmp_file}
        [[ ${debug_p4} -eq 1 ]] && cursor --diff ${workspace_config_file} ${tmp_file}
        dumpcmd "p4 client -i < ${tmp_file}"
        p4 client -i < ${tmp_file}
    else
        dumpinfo "P4CLIENT ${P4CLIENT} 已存在，直接使用。"
    fi
}

function check_saml_auth(){
    local saml_file="${TEMP_DIR}/to_del/p4_saml_auth_result.txt"
    [[ -f ${saml_file} ]] && { dumpinfo "found saml auth file : ${saml_file}" ; return 0 ;}
    dumpinfox "no saml auth file : ${saml_file}"
    dumpinfo "do saml authentication, run script :${lime_256} source ${${BASH_SOURCE[0]}%/*}/p4_saml_authentication.sh"
    source ${${BASH_SOURCE[0]}%/*}/p4_saml_authentication.sh
    return 1
}

function login_p4_if_not_login() {
    [[ ${debug_p4} -eq 1 ]] && check_saml_auth || return 1
    p4 login -s &>/dev/null
    if [[ $? -ne 0 ]]; then
        local saml_file_login="${TEMP_DIR}/to_del/p4_saml_auth_login.txt"
        dumpinfox "p4 未登录，正在自动登录..."
        # echo "${P4PASSWD}" | p4 -u "${P4USER}" login      # if the password include special escape chars, use this line instead of above line
        dumpcmd "p4 -u ${P4USER} -P '********' login"
        # p4 -u ${P4USER} -P 'ggGG55%%123!@#' login
        p4 -u ${P4USER} login
        p4 login -s  2>&1 > ${saml_file_login}
        [[ $? -ne 0 ]] && {
            dumpinfo "${saml_file_login}"
            cat ${saml_file_login}
            dumperr "p4 login failed"; 
            return 1; 
        }
        dumpinfo "p4 login success"
        return 0
    else
        dumpinfo "p4 已经处于登录状态。"
        return 0
    fi
}

# Function to configure Perforce client workspace
function login_p4() {
    # P4CLIENT 和 p4 workspace 是同一个概念，只是叫法不同。
    # 4CLIENT 是“名字”，workspace 是“本地目录和映射规则的集合”，但在 Perforce 语境下，二者指向同一个东西。
    dumpinfox "login_p4 ..."
    [[ ! -d "${P4Root}" ]] && mkdir -p "${P4Root}"
    login_p4_if_not_login || {
        dump_p4_info
        return 1
    }
    create_p4_client_if_not_exist "${P4CLIENT}" 
    dumpinfo "Done to configure client"
    return 0
}

function download_one_url() {
    login_p4_if_not_login || return 1
    # Sync specified path files to local workspace
    dumpinfox "download_one_url ..."
    # download_url="//sw/rel/gpu_drv/r535/r535_00/drivers/common/build"     # Replace with your local download path.  format MUST be : //depot/path/to/files
    download_url="$1"    
    dumpcmd "p4 sync ${download_url}/..."
    p4 sync ${download_url}/...
    dumpcmd "p4 fstat -m 5 ${download_url}/..."
    p4 fstat -m 5 ${download_url}/...
    dumpinfo "Done to download ${download_url} to ${P4Root}"
}

# Function to login to Perforce and sync files
function sync_workspace() {
    login_p4_if_not_login || return 1
    dumpinfox "sync_workspace ..."
    dumpinfo "sync ${P4CLIENT} to ${P4Root}"
    grep -E '^[[:space:]]*View:' ${p4_client_config_file} | awk '{print $2}' | sed 's@^@# @g'

    dumpcmd "p4 sync"
    p4 sync
    dumpinfo "Done p4 sync"
}

# Main function to execute the script
function p4_sync_main() {
    echo
    configure_p4_variables "${workspace_config_file}" || return 1
    echo
    dump_p4_info
    echo
    login_p4 || return 1
    echo
    dump_p4_info || return 1
    echo
    sync_workspace || return 1
}

p4_sync_main "$@"

echo
bash_script_o
