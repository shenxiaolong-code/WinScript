#!/bin/bash

bash_script_i

# install to user dir to avoid permission issue , will install to PYTHONUSERBASE folder , default is ~/.local
# pip install --user <package_name>
# pip uninstall <package_name>          # e.g. pip uninstall pyyaml
python_cusotmized_lib_dir=${EXT_DIR}/myDepency/python_suite/python_cusotmized_lib_dir
[[ ! -d "${python_cusotmized_lib_dir}"  ]] && mkdir -p "${python_cusotmized_lib_dir}"
[[ ! -d "${python_cusotmized_lib_dir}"  ]] && dumperr "invalid path python_cusotmized_lib_dir : ${brown}${python_cusotmized_lib_dir}${end}"
export    PYTHONUSERBASE=${python_cusotmized_lib_dir}

# change the path of python compile cache folder path : __pycache__  after python 3.8
# https://stackoverflow.com/questions/3522079/changing-the-directory-where-pyc-files-are-created
# In the result, you can control using PYTHONPYCACHEPREFIX=path, -X pycache_prefix=path and sys.pycache_prefix.
python_cusotmized_cache_dir=${EXT_DIR}/myDepency/python_suite/runtime_cache
[[ ! -d "${python_cusotmized_cache_dir}"  ]] && mkdir -p "${python_cusotmized_cache_dir}"
[[ ! -d "${python_cusotmized_cache_dir}"  ]] && dumperr "invalid path python_cusotmized_cache_dir : ${brown}${python_cusotmized_cache_dir}${end}"

export      PYTHONPYCACHEPREFIX="${python_cusotmized_cache_dir}"

# https://cmake.org/cmake/help/latest/command/execute_process.html
# echo the execute_process cmd in  CMakeLists.txt
export      CMAKE_EXECUTE_PROCESS_COMMAND_ECHO=stdout

# disable generate .pyc file in the <python_source_dir>/__pycache__ folder
# it will cause weird behavior when the source code is changed but the .pyc file is not updated -- it is very difficult to debug
export      PYTHONDONTWRITEBYTECODE=1

## --------------------------------------------------------------------------------------------------------------------------
#  PYTHONPATH : python search path
PYTHONPATH_MY=${EXT_DIR}/repo/linux_pratice/linuxRepo/python_pratice
[[ ! -d "${PYTHONPATH_MY}" ]] && dumperr "invalid path PYTHONPATH_MY : ${brown}${PYTHONPATH_MY}${end}"

## --------------------------------------------------------------------------------------------------------------------------
# export  PYTHONPATH=/home/utils/Python-3.9.1:${EXT_DIR}/myDepency/tools/python_cusotmized_lib_dir:${EXT_DIR}/repo/linux_pratice/linuxRepo/python_pratice/utils
function setup_python_path_predef() {
  if [[ "${envMode}" == "303" ]] ; then
    # PYTHON3_PATH_303="${EXT_DIR}/myDepency/tools/pyenv/versions/3.11.0"
    PYTHON_PATH=/home/utils/Python-3.9.1
  elif [[ "${envMode}" == "docker" ]] ; then
    # /usr/local/bin/python3
    PYTHON_PATH=/usr/local
  else
    # A new build is created every 2 weeks and installed under /home/utils/Python/builds/
    # https://confluence.nvidia.com/display/PYTHON/Python+on+LSF+Farm
    # PYTHON_PATH=/home/utils/Python/builds/3.11.9-20241001
    PYTHON_PATH=/home/utils/Python/builds/3.12.5-20241215
  fi
  PYTHON3_PATH="${PYTHON_PATH}"
  if [[ ! -d $PYTHON3_PATH ]] ; then
    dumperr "invalid path PYTHON3_PATH : ${brown}${PYTHON3_PATH}${end}"
    return 1
  fi
}

function export_python_path() {
    [[ ! -d "${PYTHON3_PATH}" ]] && { dumperr "invalid path PYTHON3_PATH : ${brown}${PYTHON3_PATH}${end}" ; return 1 ;}
    export  PYTHON3_PATH="${PYTHON3_PATH}"
    export  PYTHONPATH="${PYTHON3_PATH}:${python_cusotmized_lib_dir}:${PYTHONPATH_MY}/utils"
    export  PATH="${PYTHON3_PATH}/bin:${python_cusotmized_lib_dir}/bin::${PATH}"
    export  LIBRARY_PATH="${PYTHON3_PATH}/lib:${LIBRARY_PATH}"
    export  LD_LIBRARY_PATH="${PYTHON3_PATH}/lib:${LD_LIBRARY_PATH}"
    
    remove_repeated_or_invalid_path_from_env_var PYTHONPATH           > /dev/null
    remove_repeated_or_invalid_path_from_env_var PATH                 > /dev/null
    remove_repeated_or_invalid_path_from_env_var LIBRARY_PATH         > /dev/null
    remove_repeated_or_invalid_path_from_env_var LD_LIBRARY_PATH      > /dev/null

    update_python_alias
}

function update_python_alias() {
  alias     python=${PYTHON3_PATH}/bin/python3
  # alias   pythonx='python -m ipdb '
  # alias   pythonx='python -m pdbpp '           # pip install pdbpp
  # alias   pythonx='python3 -m pdb '

  # python3 -v : verbose mode
  alias     pythonx='install_pdb_dependency_module ; ${PYTHON3_PATH}/bin/python3 -m pdb '
  # alias     pythonx=' install_ipdb_dependency_module ;  ${PYTHON3_PATH}/bin/python3  -m ipdb '
  # alias     pythonx=' install_ipdb_dependency_module ;  ${PYTHON3_PATH}/bin/python3  -m ipdb -c ${python_debug_init_script} '
  # alias   py=python3
  alias     py=${PYTHON3_PATH}/bin/python3
  # alias     py=${VIRTUAL_ENV:-${PYTHON3_PATH}}/bin/python3
  alias     py3=${PYTHON3_PATH}/bin/python3
  alias     pyx=pythonx
  alias     cdpy='cd ${PYTHON3_PATH}; dumpinfo "goto the python lib folder , cmd :${brown} cdpylib" ;  '
  alias     cdpylib='cd ${python_cusotmized_lib_dir} ; dumpinfo "installed python poackages , cmd :${brown} pip list" ; '
  alias     pyh='echo ${python_debug_init_script}:113'
}

function update_python_env() {
  is_python_running_virtual_env || setup_python_path_predef
  export_python_path
  update_python_alias
}
update_python_env

bash_script_o
