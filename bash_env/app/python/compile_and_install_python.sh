#!/bin/bash

bash_script_i
echo

# nvidia lsf farm python: https://confluence.nvidia.com/display/PYTHON/Python+on+LSF+Farm
# A new build is created every 2 weeks and installed under :
# /home/utils/Python/builds/

# this script is working for 303, but wil fails for lsf farm

# python installer folder
pyenv_dir="${EXT_DIR}/myDepency/python_suite/pyenv/${envMode}"
# expected_python_version="3.11.0"
expected_python_version="3.12.0"

function download_python_installer_pyenv(){    
    [[ -d $pyenv_dir ]] && rm -rf $pyenv_dir
    [[ ! -d ${pyenv_dir%/*} ]] && mkdir -p ${pyenv_dir%/*}

    dumpcmd "git clone https://github.com/pyenv/pyenv.git   ${pyenv_dir}"
    git clone https://github.com/pyenv/pyenv.git   ${pyenv_dir}
    cd ${pyenv_dir} || { dumperr "cd ${pyenv_dir} failed" ; return 1 ; }
    if [[ ! -d "plugins/pyenv-virtualenv" ]] ; then
        # mkdir plugins
        # download pyenv-virtualenv plugin, it is required by ： pyenv virtualenv-init -
        dumpcmd "git clone https://github.com/pyenv/pyenv-virtualenv.git     $(pwd -L)/plugins/pyenv-virtualenv  # it is required by ： pyenv virtualenv-init -"
        git clone https://github.com/pyenv/pyenv-virtualenv.git     $(pwd -L)/plugins/pyenv-virtualenv
    fi

    export PYENV_ROOT="${pyenv_dir}"
    export PATH="$PYENV_ROOT/bin:$PATH"
    eval "$(./bin/pyenv init -)"
    eval "$(./bin/pyenv virtualenv-init -)"
    # If you want a release build with all stable optimizations active (PGO, etc),
    # please run ./configure --enable-optimizations
    dumpcmd "./bin/pyenv --version"
    ./bin/pyenv --version
}

function install_python(){
    dumpcmd "pyenv install ${expected_python_version} -v"
    pyenv install ${expected_python_version} -v
    # pyenv uninstall ${expected_python_version}
    dumpinfo "python ${expected_python_version} install folder :${brown} $(pyenv prefix ${expected_python_version})"
    
    PYTHON3_PATH=$(pyenv prefix ${expected_python_version})
    export_python_path
    # PYTHONPATH=$PYENV_ROOT/versions/${expected_python_version}:$PYTHONPATH
    # PATH=$PYENV_ROOT/versions/${expected_python_version}/bin:$PATH    
    # export PYTHONPATH
    # export PATH
}

function main(){
    download_python_installer_pyenv || return 1
    install_python
    dumpkey PYTHONPATH    
}

main "$@"

echo
bash_script_o
