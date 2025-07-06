
bash_script_i

/usr/bin/rm ${HOME}/.history.*     2>      /dev/null

echo
pushd ${TEMP_DIR}
ll "${TEMP_DIR}/to_del"

echo "rm -rf  ${TEMP_DIR}/to_del"
# https://askubuntu.com/questions/763056/bash-script-help-check-permission-755-on-all-files-in-a-folder
# only 755 folder can be deleted
find ${TEMP_DIR}/to_del -maxdepth 1 -type d -not -perm 755 -exec chmod 755 {} \;
# /usr/bin/rm -rf  ${TEMP_DIR}/to_del
# find ${TEMP_DIR}/to_del -maxdepth 1 -type d  -perm 755  -exec rm -rf {} \;

impl_dir="${TEMP_DIR}/to_del_cleaning_$(date "+%Y%m%d_%H%M")"

mv ${TEMP_DIR}/to_del   ${impl_dir}
mkdir -p  ${TEMP_DIR}/to_del

dumpinfo "deleting${brown} ${impl_dir} ${green}async , now${brown} ${TEMP_DIR}/to_del ${green}is available.${end}"
time  /usr/bin/rm -rf -v  ${impl_dir}  
# /usr/bin/rm -rf  ${impl_dir}   &

echo "\n${brown}Done to remove folder : ${green} ${TEMP_DIR}/to_del ${red}\nll ${TEMP_DIR}/to_del${end}"
ll ${TEMP_DIR}/to_del
echo
popd

dumpinfo "\ndone to clean system"
bash_script_o
