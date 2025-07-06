bash_script_i_blue
# source  s1.sh          // don't start new process
# .       s1.sh          // don't start new process
# bash    s1.sh          //       start new process
# ./s1.sh                //       start new process

# best shell script practice : use upper-case in shell env script.  in lower-case in user cmd script.

# verify the environment variables
# EXT_DIR is set in ${EXT_DIR}/bash_env/init/script_path_config.sh
# EXT_DIR="${EXT_DIR}"
[[ ! -d ${EXT_DIR} ]]  && {
    command echo -e "\e[1;31mError : \e[1;34mSCRATCH_DIR does not exist: \e[0;33m${EXT_DIR}\e[0;0m"    
    return 1
}

source  ${BASH_DIR}/init/init_color_variables.sh
source  ${BASH_DIR}/init/init_color_variables_sed.sh noShow

# export    TMP="${TEMP_DIR}"                                          # don't export TMP because TMP will be used in some user scripts.
alias   gtmp='cd ${TEMP_DIR} ; list_dir_with_reversed_index ;'                       # ${EXT_DIR}/tmp
alias   gtmp2='cd ${TEMP_PATH2} ; list_dir_with_reversed_index ;'                     # /home/scratch.xiaolongs_gpu/temp
alias   gtest='cd ${TEMP_DIR}/test ; list_dir_with_reversed_index ;'
alias   gdep='cd ${EXT_DIR}/myDepency; list_dir_with_reversed_index ;'   # dependency folder, can't be deleted
alias   gdel='cd $( mktemp -d -p ${TEMP_DIR}/to_del )'
alias   ldel='ll ${TEMP_DIR}/to_del ;'


# https://docs.nvidia.com/cuda/cuda-gdb/index.html
# Temporary Directory
# warning : if only TMPDIR is set without CUDBG_APICLIENT_PID, it will cause cuda gdb internal error 
# export  TMPDIR="${TEMP_DIR}"                                      # used by cuda gdb
# export  CUDBG_APICLIENT_PID=


source  ${BASH_DIR}/init/options_bash_env.sh
source  ${BASH_DIR}/init/alias_color.sh
source  ${BASH_DIR}/app/vscode/vscode_shell_integration.sh
# source  ${BASH_DIR}/app/ai_cursor/alias_ai_cursor.sh
source  ${BASH_DIR}/init/alias_and_function.sh
source  ${BASH_DIR}/init/alias_find_file_or_text.sh
source  ${BASH_DIR}/app/git/git_alias.sh
source  ${BASH_DIR}/app/svn/alias_svn.sh
source  ${BASH_DIR}/init/init_linux_cpp_pratice.sh

# https://phoenixnap.com/kb/change-bash-prompt-linux
# https://linuxhint.com/bash-ps1-customization/
# export PS1="[${purple}\t${green} \u@\h${cyan} \w${end}]${brown}[\s-\v]${red}\$ ${end}"
# \e[0; : set prompt
# \e[2; : set title

# \w : full path  ;  \W : folder name
# \u : xiaolongs  ;  \h : sc-xterm-84
# \t : 00:29:21   ;  \T : 12:29:52

# \w always show ~ short path if in home dir , $(pwd -L) will show full path
# export PS1_RAW="[ ${blue}\h ${purple}\T${green} \w${end} ][ ${brown}\s-\v${end} ]\n${red}\$ ${end}"
# export PS1=${PS1_RAW}
export PROMPT_COMMAND='PS1="[ ${blue}\h ${purple}\T${green} $(pwd -L)${end} ][ ${brown}\s-\v${end} ]\n${red}\$ ${end}"'

: '
my_customized_prompt() {
  printf "\033]0;%s@%s:%s\007" "${USER}" "${HOSTNAME%%.*}" "${PWD/#$HOME/\~}"
}
PROMPT_COMMAND=my_customized_prompt
'

# https://cloud.tencent.com/developer/article/1452456
# https://askubuntu.com/questions/636944/how-to-change-the-title-of-the-current-terminal-tab-using-only-the-command-line
# https://tldp.org/HOWTO/Xterm-Title-4.html
function title() {
  # TITLE="\[\e]2;[ `date "+%Y-%m-%d_%H:%M"` \h : \W ] $*\a\]"
  # TITLE="\[\e]2;[ `date "+%Y-%m-%d_%H:%M"` ] ${imageName} : \w ] $*\a\]"  
  TITLE="\[\e]2;[ `date "+%Y-%m-%d_%H:%M"` ${envMode}] $*\a\]"  
  PS1=${PS1_RAW}${TITLE}
}

bash_script_o

