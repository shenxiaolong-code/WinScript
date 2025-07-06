#!/bin/bash

bash_script_i

function is_python_running_virtual_env() {
    # https://stackoverflow.com/questions/1871549/determine-if-python-is-running-inside-virtualenv
    if [[ -n "$VIRTUAL_ENV" ]]; then
        # VIRTUAL_ENV include the virtual env name
        # VIRTUAL_ENV example : ${EXT_DIR}/tmp/to_del/tmp.NJo2K5sbRM/env
        dumpinfo "Python is running inside ${brown}virtualenv ${blue}at $VIRTUAL_ENV"
        return 0
    else
        dumpinfo "Python is ${brown}not ${blue}running inside virtualenv"
        return 1
    fi
}

function is_python_running_virtual_env_on_dir() {
    local env_dir=${1:-./}
    is_python_running_virtual_env 1> /dev/null && { is_same_path "${env_dir}/env" "$VIRTUAL_ENV"  && return 0 || return 1 ; }
    return 1
}

function is_exist_python_virtual_env_on_dir() {
    local env_dir=${1:-./}
    [[ -f ${env_dir}/env/bin/activate ]] && return 0 || return 1
}

function active_python_virtual_env_on_dir() {
    local env_dir=${1:-./}
    dumpinfox "active_python_virtual_env_on_dir on directory: ${env_dir}"
    [[ ! -f ${env_dir}/env/bin/activate ]]              && { dumperr "Invalid virtual environment directory: $env_dir"; return 1; }
    is_python_running_virtual_env_on_dir ${env_dir} && return 0
    deactive_python_virtual_env
    source ${env_dir}/env/bin/activate || { dumperr "Failed to activate virtual environment in: $env_dir"; return 2; }
    # now the variable $VIRTUAL_ENV is available

    # setup the python path
    PYTHON3_PATH=${env_dir}/env
    export_python_path
    dumpkey VIRTUAL_ENV
    return 0
}

function active_python_virtual_env_last() {        
    readvar virtual_env_last_$envMode VIRTUAL_ENV_LAST
    [[ ! -d $VIRTUAL_ENV_LAST ]] && { dumperr "Invalid virtual environment directory: $VIRTUAL_ENV_LAST"; return 1; }
    active_python_virtual_env_on_dir $VIRTUAL_ENV_LAST
    return $?
}

function set_last_python_virtual_env_on_dir() {
    local env_dir=${1:-./}
    env_dir=$(realpathx $env_dir)
    is_exist_python_virtual_env_on_dir $env_dir && { writevar virtual_env_last "$env_dir" ; return 0 ; }
    return 1
}

function deactive_python_virtual_env() {
    is_python_running_virtual_env 1> /dev/null && deactivate
    return 0
}

function setup_python_virtual_env_on_dir() {
    # Use venv or conda to create a virtual environment named env on current working directory
    local python_big_version=$(python3 --version | grep -oP "\d+\.\d+" | sed 's#\.##')    # 3.9.x.y => 39
    [[ ${python_big_version} -lt 39 ]] && { dumperr "python virtual env need version 3.9 or later, current version is $(python3 --version)" ; return 1 ;}
    
    local default_env_dir="${EXT_DIR}/myDepency/python_suite/generated_virtual_env/pyenv_$(date "+%Y%m%d_%H%M")"
    env_dir=${1:-${default_env_dir}}
    # check if there is the virtual environment
    is_exist_python_virtual_env_on_dir $env_dir && {  active_python_virtual_env_on_dir $env_dir  ; return $? ; }
    
    # create the virtual environment
    dumpinfox "${FUNCNAME[0]} on directory: ${env_dir}"    
    [[ ! -d ${env_dir}     ]] &&  mkdir -p ${env_dir}
    [[ ! -d ${env_dir}     ]] &&  { dumperr "Fails to create dir ${env_dir}" ; return 2 ;}
    # python -m venv /path/to/your/directory/myenv
    dumpcmd "python3 -m venv $env_dir/env  # ${FUNCNAME[0]}"
    python3 -m venv $env_dir/env || { dumperr "Failed to create virtual environment : $env_dir/env"; return 3; }
    dumpcmd "source $env_dir/env/bin/activate  # ${FUNCNAME[0]}"
    source $env_dir/env/bin/activate    # now the variable $VIRTUAL_ENV is available
    
    # setup the python path
    PYTHON3_PATH=${env_dir}/env
    export_python_path
    
    # set_last_python_virtual_env_on_dir
    # writevar virtual_env_last "$env_dir"
    dumpkey   PYTHON3_PATH
    dumpinfo "update the${brown} virtual_env_last=${env_dir} ${blue}if you want to use this virtual env next time"
    grep -nH --color=always "virtual_env_last" ${EXT_DIR}/myDepency/ini_input/default.ini
    dumpinfo "Done.  run cmd${brown} deactivate ${blue}to exit the python virtual venv"
}


function setup_dkg_python_module_dependency(){
    # install projected-required python modules
    # $env_dir/env/bin/python3 -m pip install -U -r ${SOURCE}/bloom/requirements.txt -c ${SOURCE}/bloom/constraints.txt

    dumpcmd "pip install --upgrade pip  # ${FUNCNAME[0]}"
    pip install --upgrade pip
    
    # https://nvidia.slack.com/archives/C06NEMRTWMS/p1735839493166929?thread_ts=1735108211.910449&cid=C06NEMRTWMS
    # nrsu is internal module, need the --index-url and --extra-index-url
    # ERROR: Could not find a version that satisfies the requirement nrsu>=1.0.230530150711 (from versions: none)
    # ERROR: No matching distribution found for nrsu>=1.0.230530150711
    local setup_cmd="python3 -m pip install --index-url https://urm.nvidia.com/artifactory/api/pypi/sw-dl-cask-pypi/simple --extra-index-url https://sc-hw-artf.nvidia.com/artifactory/api/pypi/compute-pypi/simple -U -r ${REPO_DIR_DKG_DOCKER}/dependency/pip/cask-build/python3.12/requirements-expanded.txt"
    dumpcmd "${setup_cmd}  # ${FUNCNAME[0]}"
    ${setup_cmd}
    donecmd
    # install the modules required by the ./scripts/code-format-helper.py
    pip3 install requests
    pip3 install typing_extensions
}

# setup_python_environment_for_dkg ${EXT_DIR}/myDepency/python_suite/generated_virtual_env/dkg_farm
function setup_python_environment_for_dkg() {
    # https://gitlab-master.nvidia.com/dlarch-fastkernels/dynamic-kernel-generator/-/blob/master/bloom/README.md?ref_type=heads
    # https://nvidia.slack.com/archives/C0752R5M7C7/p1725652369501779?thread_ts=1725647087.148669&cid=C0752R5M7C7
    local default_env_dir="${EXT_DIR}/myDepency/python_suite/generated_virtual_env/dkg_${envMode}"
    local env_dir=${1:-${default_env_dir}}
    env_dir=$(realpathx $env_dir)
    dumpinfox "install python virtual and dependency modules ..."
    setup_python_virtual_env_on_dir $env_dir || { dumperr "Failed to setup python virtual environment"; return 1; }
    setup_dkg_python_module_dependency    
}

bash_script_o
