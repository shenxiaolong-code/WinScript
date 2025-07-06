
# ------------------------------------- debug feature definition begin  ----------------------------------------------------
# printf "# \e[0;34m[init] \e[0;35m%-16s\e[0;0m = \e[0;33m %s \e[0;0m \n" "cur_repo_dir"  "${cur_repo_dir}"  ;
# if found the initial cur_repo_dir exist with wrong value, it is vscode bug, instead of bash shell env.
# verify : sshf in the vscode terminal , all works fine.
# solution : ( 1. is suggested )
# 1  : https://github.com/microsoft/vscode/issues/70248#issuecomment-501495472
#      uncheck terminal.integrated.inheritEnv
# 2  : https://github.com/microsoft/vscode/issues/70248
#      check vscode config : terminal.integrated.env.linux
#      "cur_repo_dir":""

echo -e "# +++++++++ loading ${BASH_SOURCE[0]}:${LINENO}  \e[0;30m:  ${BASH_SOURCE[1]##*/}:${BASH_LINENO[0]} \e[0;0m" 
unset disable_bash_script_io
# in defalut, alias only works in interactive terminate mode.
# for script mode, we need to enable it explictly by : shopt -s expand_aliases
# shopt -p      # show all bash options
# https://stackoverflow.com/questions/33135897/bash-alias-command-not-found
shopt -s expand_aliases         # extends alias
# shopt -s extglob              # extends regexes

source ${BASH_DIR}/init/alias_dump_debug.sh

# ------------------------------------- debug feature definition end  ----------------------------------------------------
# disable_bash_script_io=1
# bash_script_i
source ${BASH_DIR}/login_init.sh
# source ${BASH_DIR}/nvidia/login_init_amd.sh  "$@"
# source ${BASH_DIR}/nvidia/login_init_nv.sh  "$@"
# bash_script_o


if [[ -v disable_bash_script_io ]] ; then
  unset disable_bash_script_io
fi

echo -e "# --------- leaving ${BASH_SOURCE[0]}:${LINENO}  "