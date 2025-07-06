bash_script_i
# dumpcmdline
echo
# curl -u "xiaolongs" https://urm.nvidia.com/artifactory/sw-fastkernels-generic-local/cuda/gpgpu/x86_64/linux/generic/release-internal/cuda-gpgpu-31256743.tgz -o cuda-gpgpu-31256743.tgz
# wget https://${URM_USER}:${URM_TOKEN}@urm.nvidia.com/artifactory/sw-fastkernels-generic/cuda_driver/cuda_a/x86_64/linux/release/cuda_driver-cuda_a-31321809.tgz

# support :
# https://urm.nvidia.com/artifactory/sw-fastkernels-generic-local/cuda/gpgpu/x86_64/linux/generic/release-internal/cuda-gpgpu-31256743.tgz      =>  ./cuda-gpgpu-31256743.tgz
# https://urm.nvidia.com/artifactory/sw-fastkernels-generic/cicd/kernel_store_cask/main/Nightly_Generic/239/                                    =>  ./web_src.html

download_url=$1
out_file_path=$2
dumpkeyx download_url
dumpkey out_file_path

if [[ "${download_url}" == "" ]] ; then
    dumpkeyx download_url
    dumpkey out_file_path
    dumperr "download error : download_url is empty"
    return 1
fi

function fetch_file_name_from_url() {
    file_name=$(echo ${download_url} | sed 's#.*/##g')
    if [[ "${file_name}" == "" ]] ; then
        if [[ "${download_url: -1}" == "/" ]] ; then
            file_name="web_src.html"
        else
            file_name=$(date "+%Y%m%d_%H%M")_$(echo ${download_url} | sed 's#.*/##g')
        fi
    fi
    echo ${file_name}
}

function process_out_file_path() {
    time_stamp=$(date "+%Y%m%d_%H%M")
    if [[ -z $out_file_path ]] ; then
        file_name=$(fetch_file_name_from_url)
        # out_dir_default="$(mktemp -d ${TEMP_DIR}/to_del/download/XXXXXXXXXX)"
        # url_md5=$(md5_string "${download_url}")
        out_dir_default="${TEMP_DIR}/download/$(echo $file_name | sed 's#\..*##g')"
        out_dir="${out_dir_default}"        
    else
        [[ "${out_file_path: -1}"  == "/"  ]] && out_file_path=${out_file_path}/$(fetch_file_name_from_url)
        out_file_path=$(command realpath -m -s $out_file_path | update_symbol_path)          # -m : --allow-not-existing , -s : not resolve symlinks , realpath will remove the tail /, e.g.  /home/scratch/  =>  /home/scratch
        file_name=$(echo ${out_file_path} | sed 's#.*/##g')
        out_dir=$(command dirname ${out_file_path})

        # [[ "${out_file_path:0:1}" == "."   ]] && out_file_path=$(pwd -L)/${out_file_path}       # e.g.  ./abc.txt       ; ../add/abc.txt
        # [[ "${out_file_path: -1}"  == "."  ]] && out_file_path=${out_file_path}/                # e.g.  ./ddddd/fffd/.  ; ./ddddd/fffd/..        
        # [[ "${out_file_path:0:1}" != "/"   ]] && file_name=${out_file_path}                     # only file name , no path , e.g.  abc.txt
        # [[ "${out_file_path: -1}"  == "/"  ]] && out_dir="$out_file_path"                       # only dir name ,  no file , e.g.  /home/        

        if [[ -z $file_name ]] ; then
            if [[ "${download_url}" == *"/" ]] ; then                                           # download_url is a web page , instead of a file
                file_name="web_src_${time_stamp}.html"
            else
                file_name=${time_stamp}_$(echo ${download_url} | sed 's#.*/##g')
            fi
        fi
        [[ -z $out_dir ]]   && out_dir="$(pwd -L)"
    fi
    [[ -d ${out_dir} ]] && is_inside_git_svn_repo "${out_dir}"  && out_dir="${TEMP_DIR}/to_del/download"
    [[ ! -d "${out_dir}" ]] && mkdir -p "${out_dir}"
    out_dir=$( cd ${out_dir} && pwd -L )    
    out_file_path="${out_dir}/${file_name}"
    
    if [[ -f "$out_file_path" ]]; then
        dumpinfo "backup existing $out_file_path =>  ${out_dir}/bak_$(date "+%Y%m%d_%H%M")_${file_name}  ... "
        mv ${out_file_path}  ${out_dir}/bak_$(date "+%Y%m%d_%H%M")_${file_name}
        # /usr/bin/rm  $out_file_path
    fi
    # dumpkey out_dir_default
    # dumpkey out_file_path
}

function download_nivida_internal_file_with_user_pwd() {   
    # need URM_USER and URM_TOKEN setting
    # https://urm.nvidia.com/artifactory/sw-fastkernels-generic-local/cicd/cask/main/Nightly_Generic/413/
    # https://${URM_USER}:${URM_TOKEN}@urm.nvidia.com/artifactory/sw-fastkernels-generic-local/cicd/cask/main/Nightly_Generic/413/

    # URM_TOKEN will be deprecated after 2024.11.8
    # dl_user_name="${URM_USER}"
    # dl_user_pwd="${URM_TOKEN}"
    # JFROG_TOKEN will launch from 2024.11.8 to replace URM_TOKEN
    dl_user_name="${JFROG_USER}"
    dl_user_pwd="${JFROG_TOKEN}"
    
    # nvidia internal auth way 
    dumpinfox "Downloading nivida internal file ..."
    # dumpinfo "downloading by wget ( CI pipeline ) : $download_url"
    # see : ${BASH_DIR}/nvidia/init/load_credential.sh:56
    # dumpcmd curl -u "${dl_user_name}:\${dl_user_pwd}" $download_url -o $out_file_path
    # curl -u "${dl_user_name}:${dl_user_pwd}" $download_url -o $out_file_path

    dumpcmd wget --user="${dl_user_name}" --password="\${dl_user_pwd}" $download_url --output-document=$out_file_path
    wget --user="${dl_user_name}" --password="${dl_user_pwd}" $download_url --output-document=$out_file_path
    wget_status=$?
    # wget -P ${EXT_DIR}/temp/   https://github.com/gdbinit/Gdbinit/blob/master/gdbinit
    
    if [[ ! -f $out_file_path ]] ; then
        dumpkeyx download_url
        dumpkey out_file_path
        dumperr "download_nivida_internal_file_with_user_pwd fails"
        echo
        return 2
    fi
    return 0
}

function download_external_file_without_user_pwd() {
    dumpinfox "Downloading external file ..."

    ## curl -u "xiaolongs" $download_url -o $out_file_path
    # dumpinfo "curl $download_url -o $out_file_path"
    # curl "$download_url" -o $out_file_path

    dumpcmd wget "$download_url" --output-document=$out_file_path
    # wget -P "$temp_dir" "$download_url"
    wget "$download_url" --output-document=$out_file_path
    wget_status=$?
    if [[ ! -f $out_file_path ]] ; then
        dumpkeyx download_url
        dumpkey out_file_path
        dumperr "download_external_file_without_user_pwd download fails"
        return 2
    fi
    return 0
}

function record_download_history() {
    download_history=${out_dir}/_download_links.txt
    dumpinfox "download record : ${download_history}"
    [[ ! -f "$download_history" ]]  &&  echo  > ${download_history}
    {
        echo
        date "+%Y%m%d_%H%M"
        echo "$download_url"
        echo "$out_file_path"
    }   >> ${download_history}

    # don generate .last file again because the date time is added in file name
}

# 函数：检查文件是否被压缩
function isCompressedFile() {
    local file="$1"

    # 检查文件是否存在
    if [[ ! -f "$file" ]]; then
        echo
        dumperr "File does not exist."
        return 1
    fi

    # 使用 file 命令获取文件类型信息
    local fileType=$(file --mime-type -b "$file")
    # dumpkey fileType

    # 检查文件类型以判断是否为压缩文件
    case "$fileType" in
        application/gzip | application/x-gzip | application/x-tar | application/x-zip | application/x-rar | application/x-bzip2 | application/x-7z-compressed | application/x-xz )
            dumpinfo "$file is a compressed file."
            return 0
            ;;
        *)
            dumpinfo "$file is not a compressed file."
            return 1
            ;;
    esac
}

function process_nvidia_dkg_specify() {
    [[ "${outputFolderPath}" != *"/dkg" ]]  && return
    [[ ! -d ${outputFolderPath}/lib64   ]]  && return
    [[ ! -d ${job_path} ]]                  && return

    if [[ -f ${job_path}/artifact ]] ; then
        rm ${job_path}/artifact
    fi

    ln -s ${outputFolderPath%/dkg} ${job_path}/artifact
}

function main(){
    process_out_file_path   $@
    [[ ! -d "${out_dir}" ]] && mkdir -p "${out_dir}"
    debugkey out_dir

    # echo "${green}download url  : ${red}${download_url}${end}"
    # echo "${green}output file   : ${red}${out_file_path}${end}" 
    # echo

    [[ -z $download_url ]]  &&  dumperr "download error : download_url is empty" && return 1
    # dumpkeyx download_url
    dumpkey  out_file_path
    if [[ $download_url == *".nvidia.com"* ]]  ; then
        download_nivida_internal_file_with_user_pwd
    else
        download_external_file_without_user_pwd
    fi

    [[ ! -f $out_file_path ]] && dumperr "download fails" && return 2

    record_download_history

   [[ -z $disable_auto_unapck ]] &&  isCompressedFile  "$out_file_path" > /dev/null && source ${BASH_DIR}/bin/unpack.sh  "$out_file_path"  $(dirname "$out_file_path")/
   process_nvidia_dkg_specify

    dumpkeyx out_file_path
    dumpkey download_history
    # dumpinfox "${green}output path :${brown_L} $out_file_path${end}"
    # dumpinfo  "${blue}$download_history${end}"
}

# process_out_file_path  $@
main "$@"

echo
bash_script_o
return $wget_status


# 在使用 `curl` 和 `wget` 下载文件时，设置用户密码的方式有多种形式。以下是两者的主要方法：
## 使用 `curl` 设置用户密码的方式

##  1. **使用 `-u` 或 `--user` 选项**：
##     - 格式：`curl -u username:password URL`
##     - 示例：`curl -u 'bob:12345' https://example.com`
##     - 说明：`curl` 会将用户名和密码进行 Base64 编码，并在请求中添加 `Authorization` 头。
##  
##  2. **在 URL 中包含用户名和密码**：
##     - 格式：`curl https://username:password@example.com`
##     - 示例：`curl https://bob:12345@example.com`
##     - 说明：直接在 URL 中包含用户名和密码。
##  
##  3. **仅提供用户名，提示输入密码**：
##     - 格式：`curl -u username URL`
##     - 示例：`curl -u 'bob' https://example.com`
##     - 说明：不提供密码，`curl` 会提示输入密码。
##  
##  4. **使用 `.netrc` 文件**：
##     - 格式：在 `~/.netrc` 文件中添加以下内容：
##       ```
##       machine example.com
##       login bob
##       password 12345
##       ```
##     - 使用命令：`curl -n https://example.com`
##     - 说明：通过 `-n` 选项使 `curl` 使用 `.netrc` 文件中的凭据。
##  
##  5. **手动设置 Authorization 头**：
##     - 格式：使用自定义头部。
##     - 示例：
##       ```bash
##       curl -H "Authorization: Basic $(echo -n 'username:password' | base64)" https://example.com
##       ```
##     - 说明：手动编码并设置 Authorization 头。
##  
##  ## 使用 `wget` 设置用户密码的方式
##  
##  1. **使用 `--user` 和 `--password` 选项**：
##     - 格式：`wget --user=username --password=password URL`
##     - 示例：`wget --user=bob --password=12345 http://example.com`
##     - 说明：直接在命令中指定用户名和密码。
##  
##  2. **使用 `--ask-password` 提示输入密码**：
##     - 格式：`wget --user=username --ask-password URL`
##     - 示例：`wget --user=bob --ask-password http://example.com`
##     - 说明：只提供用户名，系统会提示输入密码。
##  
##  3. **使用 `.netrc` 文件**：
##     - 格式与 curl 相同，在 `~/.netrc` 文件中添加凭据。
##     - 使用命令：直接运行 `wget URL`
##     - 说明：如果 `.netrc` 文件配置正确，wget 会自动读取凭据。
