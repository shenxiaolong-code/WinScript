bash_script_i

# is_now_time_after "16:23:20"
function is_now_time_after() {
    echo "test time : $1"
    echo "now time  : $(date +%H:%M:%S)"
    local now_time=$(date +%H:%M:%S)
    local now_time_seconds=$(date -d $now_time +%s)
    local input_time_seconds=$(date -d $1 +%s)
    # [[ $now_time_seconds -gt $input_time_seconds ]] && dumpinfo "now time[$now_time] is after test time [$1]" || dumpinfo "now time[$now_time] is before test time [$1]"
    [[ $now_time_seconds -gt $input_time_seconds ]] && return 0 || return 1
}
#  is_now_time_after "02:35:55" && echo "now time is after test time" || echo "now time is before test time"
#  is_now_time_after "02:40:55"
#  if [[ $? == 0 ]] ; then
#      echo "now time is after test time"
#  else
#      echo "now time is before test time"
#  fi

# is_file_in_env_path "ssss.py" "PYTHONPATH"
# is_file_in_env_path "ddd" "PATH"
# is_file_in_env_path "ddd" "PATH" || export PATH=/.../scripts:$PATH
function is_file_in_env_path() {
    local filename="$1"
    local env_var_name="$2"

    # 获取环境变量的值
    local paths="${!env_var_name}"

    # 将路径分割成数组
    IFS=':' read -r -a path_array <<< "$paths"

    # 检查每个路径
    for path in "${path_array[@]}"; do
        if [[ -f "$path/$filename" ]]; then
            # echo "Found $filename in $path"
            return 0
        fi
    done

    # echo "$filename not found in $env_var_name"
    return 1
}


# convert_to_China_time "10:01:01"
function convert_to_China_time() {
    # Parse the input time string
    local input_time=$1
    IFS=":" read -r -a time_parts <<< "$input_time"

    # Add 8 hours to convert to China time (UTC+8)
    local hour_in_china=$((10#${time_parts[0]} + 8))
    if [ $hour_in_china -ge 24 ]; then
        hour_in_china=$((hour_in_china - 24))
    fi

    # Format the China time as a string
    local china_time=$(printf "%02d:%s:%s" $hour_in_china ${time_parts[1]} ${time_parts[2]})
    dumpinfo "input time[$1] convert to China time[$china_time]"
    echo $china_time
}
# convert_to_China_time "19:01:01"

# is_same_path "/path/to/file_or_link1" "/path/to/file_or_link2"
# symbol path, real path ... , absolute path, relative path, ... compare
function is_same_path() {
    local path1="$1"
    local path2="$2"

    # 检查两个路径是否存在
    if [[ -e "$path1" && -e "$path2" ]]; then
        if [[ "$path1" -ef "$path2" ]]; then
            # dumpinfo "same path : $path1 and $path2"
            return 0
        else
            # dumpinfo "different path : $path1 and $path2"
            return 1
        fi
    else
        # dumpinfo "path not exist : $path1 or $path2"
        return 2
    fi
}

function is_not_same_path() {
    return ! is_same_path "$@"
}

function is_url_valid() {
    url=$1
    # curl --head --silent --fail ${url}
    response=$(curl -Is "$url")
    # response=$(curl -Is --max-time 2 "$url")
    if [[ -z "$response" || "$response" == *"404"* || "$response" == *"403"* ]]; then
        return 1
    else
        return 0
    fi
}

# curl -Is "$url"
# HTTP/2 401 
# date: Fri, 10 May 2024 10:39:39 GMT
# content-type: application/json
# x-jfrog-version: Artifactory/7.55.14 75514900
# x-artifactory-id: 10d9ca414768b002cb0b9e0100a8dd76d65fd996
# x-artifactory-node-id: artifactory-ha-artifactory-ha-member-5
# www-authenticate: Basic realm="Artifactory Realm"
# access-control-allow-methods: GET, POST, DELETE, PUT
# access-control-allow-headers: X-Requested-With, Content-Type, X-Codingpedia
# cache-control: no-store
# strict-transport-security: max-age=15724800; includeSubDomains

function is_url_invalid() {
    ! is_url_valid $1 && return 0 || return 1
}

function test_url() {
    # test_url "https://www.google.com"
    curl -Is "$1"
    echo
    is_url_valid "$1" && tmp_result="valid" || tmp_result="invalid"
    echo "${green}url '${brown} $1 ${green}' is ${red}${tmp_result}${end}"
}

function is_number() {
    re='^[0-9]+$'
    [[ $1 =~ $re ]] && return 0 || return 1
}
# [[ ${branch_paramter} =~ ^[0-9]+$ ]] && echo "is number" || echo "not number"
# is_number "5df" && echo "is number" || echo "not number"
# is_number "df" && echo "is number" || echo "not number"
# is_number "44" && echo "is number" || echo "not number"

# if is_number "5df" ; then
#     echo "is number"
# else
#     echo "not number"
# fi

function is_string_without_number() {
    re='^[a-zA-Z]+$'
    [[ $1 =~ $re ]] && return 0 || return 1
}

function is_string() {
    ! is_number $1 && return 0 || return 1
}

function is_empty_folder() {
    local folder_path="${1:-.}"
    [[ ! -d "$folder_path" ]] && return 1
    echo command ls -A "$folder_path"
    [[ -z "$(command ls -A "$folder_path")" ]] && return 0 || return 1
}

function is_not_empty_folder() {
    ! is_empty_folder $1 && return 0 || return 1
}

# usage : is_contain_special_file_in_folder "*.sh" $(pwd -L) 
function is_contain_special_file_in_folder() {
    local file_pattern="${1:-*}"
    local folder_path="${2:-.}"
    [[ ! -d "$folder_path" ]] && return 1
    folder_path=$(cd "$folder_path" && pwd -L)
    # 使用 eval 来确保通配符被正确展开
    local cmd="ls -A $folder_path/$file_pattern 2>/dev/null"
    [[ -n "$(eval $cmd)" ]] && return 0 || return 1
}

function is_text_file() {
    local file_path="$1"
    # file -i ${file_path}
    # ${BASH_DIR}/bin/show_file_info.sh: text/x-shellscript; charset=us-ascii
    # ${EXT_DIR}/repo/dkg_root/dkg_myelin_test_failure_nvbugs_5044478/scripts/lit_wrapper.py.in: text/plain; charset=us-ascii
    # ${EXT_DIR}/repo/dkg_root/dkg_myelin_test_failure_nvbugs_5044478/scripts/release.py: text/x-python; charset=us-ascii

    if file -i "$file_path" | grep -q " text/"; then
        # echo "$file_path is a binary file."
        return 0
    else
        # echo "$file_path is a text file."
        return 1
    fi
}

function is_binary_file() {    
    ! is_text_file $1 && return 0 || return 1
}

# function is_string() {
#     is_number $1
#     local result=$?
#     return $((1 - $result))
# }


function is_alias_defined() {
    local alias_name="$1"
    alias "$alias_name" &>/dev/null
    return $?
}

function is_function_defined() {
    local function_name="$1"
    declare -f "$function_name" &>/dev/null
    return $?
}

function is_cmd_exist() {
    command -v "$1" &>/dev/null
    return $?
}

function is_in_docker() {
    grep -q '/docker/' /proc/1/cgroup
    return $?
}

bash_script_o
