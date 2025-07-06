
bash_script_i

source ${BASH_DIR}/app/python/python_virtual_env.sh
source ${BASH_DIR}/app/python/update_python_env.sh

function dump_python_module_info() {
  python -m pip show $1
}

function is_python_module_installed() {
  python -c "import $1" 1> /dev/null 2> /dev/null && return 0 || return 1
}

export python_debug_init_script=${BASH_DIR}/app/python/pdb/python_pdb_init.py
function install_ipdb_dependency_module() {
  dumpinfo "check and install ipdb dependency module"
  is_python_module_installed ipdb       ||  pip install ipdb
  is_python_module_installed readline   ||  pip install readline
  ln -sf ${python_debug_init_script} ~/.ipdb
}

function install_pdb_dependency_module(){
  dumpinfo "check and install pdb dependency module"
  ln -sf ${python_debug_init_script} ~/.pdbrc
  ll ~/.pdbrc
}

function  show_python_information() {
    echo "PYTHON3_PATH          : ${PYTHON3_PATH}"
    echo "PYTHONPATH            : ${PYTHONPATH}"
    echo "python path           : $(which python)"
    echo "python version        : $(python --version)"
    echo "python user lib path  : ${python_cusotmized_lib_dir}      # PYTHONUSERBASE"
    echo "python cache path     : ${python_cusotmized_cache_dir}                  # PYTHONPYCACHEPREFIX"
    echo "my own python utils   : ${PYTHONPATH_MY}                            # PYTHONPATH_MY"
    is_python_running_virtual_env
    dumpinfo "frequently used python virtual env cmd :${brown} setup_python_environment_for_dkg ${green} active_python_virtual_env_last ${red} deactivate "
    dumpinfo "installed python poackages , cmd :${brown} pip list"
    dumpinfo "${BASH_SOURCE[0]}:${LINENO}"
}
alias ipy=show_python_information
alias ipython=show_python_information
alias pylast=active_python_virtual_env_last
# alias py=python -v

function clean_python_cache() {
  local project_dir=${1:-$(pwd -L)}
  dumpinfox "clean python cache - project : ${red}${project_dir}"
  # find -L ${project_dir} -type d -iname "__pycache__" ! -path '*/.svn/*' ! -path '*/.git/*' ! -path '*/.vscode/*' ! -path '*/.snapshot/*' ! -path '*/.cpan/*' | xargs -I {} echo rm -rf {}
  find -L ${project_dir} -type d -iname "__pycache__" ! -path '*/.svn/*' ! -path '*/.git/*' ! -path '*/.vscode/*' ! -path '*/.snapshot/*' ! -path '*/.cpan/*' | xargs -I  @ bash -c  "echo rm -rf @ ; rm -rf @ ;"

  dumpinfo "clean python cache - system : ${red}${python_cusotmized_cache_dir}"
  rm -rf ${python_cusotmized_cache_dir}
  mkdir -p ${python_cusotmized_cache_dir}
}

function create_python_file() { 
  cp_file_template $1 ${BASH_DIR}/app/python/template.py
  sed -i "s#ut_my_user_function#ut_$(basename "${1%.*}")#g" $target_path ;
}  
alias cppy=create_python_file
alias cleanpy=clean_python_cache

# https://github.com/pypa/get-pip
alias getpip='python ${PYTHONPATH_MY}/get-pip.py --user'
function    install_python_module_to_user_folder() {   python  pip install $1  --user  -v ;     }                                 # install to user folder to avoid permission issue
# pip always use verbose mode
# export PIP_VERBOSE=3
alias       pipu=install_python_module_to_user_folder

# pip install -r requirements.txt -c constraints.txt
# 可以使用 pip install -r requirements.txt 命令来一次性安装所有的依赖
alias install_cask6_needed_python_componmnet=" pip install --upgrade setuptools wheel ; pip install -r ${REPO_DIR_CASK6}/bloom/requirements.txt ;"
alias pipnv6=install_cask6_needed_python_componmnet

alias       svnpy='svn commit -m "update" ${PYTHONPATH_MY}'
alias       gpy="cd ${PYTHONPATH_MY}/ ; ll ;"
alias       testpy='python ${PYTHONPATH_MY}/test/test.py'

function ffpy ()    {
                      find_file_in_dir "$1" "*.py" "${2:-$(pwd -L)}" 
                    }
function ffpyh()    {
                      ffpy "$1" "${PYTHONPATH_MY}" 
                    }
function ftpy()     {
                      find_text_in_xxx_file "$1" "*.py" "${2:-$(pwd -L)}"
                    }
function ftpyh()    {
                      ftpy "$1" "${PYTHONPATH_MY}"
                    }
function loadpy()   {  source ${BASH_DIR}/init/log_python_script.sh   "$@" ; }

bash_script_o