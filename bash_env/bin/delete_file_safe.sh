bash_script_i
to_del_file="$1"

if [[ -f "${to_del_file}"  ]] ; then    
    to_dst_folder="$2"
    if [[ "${to_dst_folder}" == "" ]] ; then
        to_dst_folder="${TEMP_DIR}/to_del"
    fi
    to_dst_folder="`realpath ${to_dst_folder}`"

    if [[ ! -d "${to_dst_folder}" ]] ; then
        mkdir -p "${to_dst_folder}"
    fi

    to_del_file="`realpath ${to_del_file}`"
    b_test_foler=`echo ${to_del_file} | sed "s#${to_dst_folder}.*#${to_dst_folder}#g"`
    if [ "${b_test_foler}" != "${to_dst_folder}" ] ; then
        echo "${green}quick delete file ${brown}${to_del_file}${end} ..."
        mv_dir_name="`echo ${to_del_file} | sed 's#/#_#g'`_`date "+%Y%m%d_%H%M"`"
        mv  "${to_del_file}"   "${to_dst_folder}/${mv_dir_name}"
        echo "${red}${to_dst_folder}/${mv_dir_name}${end}"
    else
        echo "${green} immediately delete ${red}${to_del_file}${end} ..."
        echo "${brown} need manual delete to avoid risk to delete important folder${end} ..."
        echo "${green} cmd : ${brown}/usr/bin/rm -f ${to_del_file}${end} "
        # rm -rf "${to_del_file}"  &
        # mkdir -p "${to_del_file}"
    fi    
    
    # cmd : clean
    # source ${BASH_DIR}/bin/clean_system.sh   & 
else
    echo "${red}file ${end}'${green}${to_del_file}${end}'${red} not exists.${end}"
fi

bash_script_o
