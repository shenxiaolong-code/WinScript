#!/bin/bash

bash_script_i


# 解决 linux上 saml 认证问题
# 1. 删除 windows 上的文件 ： C:\Users\xiaolongs\p4tickets.txt
# 2. 在 linux 获得 saml 认证的 url :
#      echo 'ggGG55%%123!@#' | p4 -u xiaolongs -p p4proxy-zj:2006 login
#      Navigate to URL: https://nv-has.nvidia.com/saml/login/01JTJ8H866S0PTP51SG5AQZ0CJ?instanceId=none
#      Login invalid.
#      'loginhook-a1' validation failed: check the loginhook extension logs
# 3. 打开windows 浏览器，访问上述 url，登录 p4v , 这时可以看到 C:\Users\xiaolongs\p4tickets.txt 重新生成了
# 4. 将 windows 上的文件 ： C:\Users\xiaolongs\p4tickets.txt 中更新的内容复制到 linux 上的文件 ： ${HOME}/.p4ticket
# 5. 再次运行脚本 ${BASH_DIR}/app/p4/p4_download.sh

# NOTE ： 
# 1. p4 saml 认证是帐号绑定的，不是平台绑定的，所以在 windows 上登录 p4v 后更新生成的 p4tickets.txt 文件内容，可以被 linux 使用
# 2. windows 上 p4tickets.txt 文件格式：
#     localhost:p4sw=xiaolongs:3950CBBC9B3D04FEF25F866CAACFF843
# 3. linux 上 .p4ticket 文件格式：
#     3950CBBC9B3D04FEF25F866CAACFF843
# 所以只需要复制一部分内容到 linux 上即可

source ${BASH_SOURCE[0]%/*}/config/p4_server_config.sh

function resolve_linux_p4_saml_auth_issue(){
    dumpinfox "run saml authentication ..."
    # 1. 删除 windows 上的文件 ： C:\Users\xiaolongs\p4tickets.txt
    dumpinfox "1. delete ${HOME}/.p4ticket"
    [[ -f ${HOME}/.p4ticket ]] && cat ${HOME}/.p4ticket && rm -f ${HOME}/.p4ticket
    # 2. 在 linux 获得 saml 认证的 url :
    #      echo 'ggGG55%%123!@#' | p4 -u xiaolongs -p p4proxy-zj:2006 login
    echo
    dumpinfox "2. get saml auth url"
    local saml_file_auth="${TEMP_DIR}/to_del/p4_saml_auth_result.txt"
    dumpinfo "${saml_file_auth}"
    dumpcmd "echo 'ggGG55%%123!@#' | p4 -u xiaolongs -p p4proxy-zj:2006 login"
    echo 'ggGG55%%123!@#' | p4 -u xiaolongs -p p4proxy-zj:2006 login 2>&1 > ${saml_file_auth}
    cat ${saml_file_auth}
    saml_url=$(cat ${saml_file_auth} | grep -oP '(?<=Navigate to URL: )[^ ]+')
    [[ -z "${saml_url}" ]] && {
        dumperr "failed to get saml auth url"
        return 1
    }
    export saml_url
    
    echo
    dumpinfox "3. open saml auth url in vscode"
    vscode_open_link "${saml_url}"
    dumpinfo '3.1 open p4v in windows and view the C:\Users\xiaolongs\p4tickets.txt is generated again'
    pause
    
    echo
    dumpinfox "4. touch ${HOME}/.p4ticket"
    touch ${HOME}/.p4ticket
    chmod 600 ${HOME}/.p4ticket
    
    dumpinfox '5. copy the digital part of C:\Users\xiaolongs\p4tickets.txt file'
    dumpinfo "open ${HOME}/.p4ticket in vscode and paste into ${HOME}/.p4ticket"
    vscode_open_file "${HOME}/.p4ticket"
    dumpwarn "any non-digital is not allowed in file :${crimson_24} ${HOME}/.p4ticket"
    dumpcmd "cat -A ${HOME}/.p4ticket"
    cat -A ${HOME}/.p4ticket
    return 0
}

load_p4_server_config_1 && resolve_linux_p4_saml_auth_issue

bash_script_o
