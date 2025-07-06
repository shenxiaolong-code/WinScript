bash_script_i
echo

check_stale_folder_pwd=$(pwd -L | update_symbol_path)
check_stale_folder_realpath=$(realpathx . | update_symbol_path)

if [[ "${check_stale_folder_pwd}" != "${check_stale_folder_realpath}" ]] ; then
    # the real path is in unexpected : ${EXT_DIR}/tmp/to_del
    # realpath can expose the current real path , pwd can't
    dumperr "stale handle error occurs , pwd is stale folder, need to jump to parent foler and entry again."
    dumpinfo "pwd      : ${check_stale_folder_pwd}"
    dumpinfo "realpath : ${check_stale_folder_realpath}"
    cd ${check_stale_folder_pwd}
    # return 1
else
    # dumpinfo "pwd      : ${check_stale_folder_pwd}"
    # dumpinfo "realpath : ${check_stale_folder_realpath}"
    return 0
fi




echo
bash_script_o
