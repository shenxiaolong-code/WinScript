bash_script_i
echo

(
    echo
    echo "list a config value"
    echo git config --get core.editor
    echo "show single git config usage"
    echo git -P help config
    echo git -P help config core.editor

    echo
    dumpinfo "list all config and its source file"
    git help --config
    # git help -c
    # git config --system -l
    # git config --global -l
    # git config --local  -l

    dumpinfo "list all available config (include default config)"
    git config --list --show-origin
    
    echo
    echo "${BASH_DIR}/app/git/git_alias.sh"
) | tee "${TEMP_DIR}/to_del/git_config_list.txt"

echo
dumpinfo "${TEMP_DIR}/to_del/git_config_list.txt"
bash_script_o
