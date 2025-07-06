bash_script_i
# backup folder without repeat -- use md5sum string to recoginze the existed folder
# e.g. source ./backup_folder_best.sh <src_dir> <dst_dir_root> <ID_file_path> [opt_subFolder]

# set src_dir="${HOME}/bash_env/test"
# set src_dir=`pwd -L`
src_dir=$1
# set dst_dir_root=${BACKUP_DIR}/test
dst_dir_root=$2

# set ID_file_path="${BASH_DIR}/bin/backup_folder_best.sh"
ID_file_path=$3

# set opt_subFolder="/log"
# set opt_subFolder=
opt_subFolder=$4

if [[ -d "${src_dir}" ]]; then
    folder_name=`echo ${src_dir} | sed 's#.*/##g'`
    dst_dir="${dst_dir_root}/${folder_name}"

    md5_flag=$(md5_file ${ID_file_path})
    debugkey md5_flag
    opt_subFolder_name="`echo ${opt_subFolder} | sed 's#_##g' | sed 's#.*/#_#g'`_"
    bak_dir=${dst_dir}/`date "+%Y%m%d_%H%M"`${opt_subFolder_name}${md5_flag}
    debugkey bak_dir
    
    if [[ -d "${dst_dir}" ]] ; then
        existed_bak_dir=`\\ls ${dst_dir} | grep -m 1 ${md5_flag}`
        debugkey existed_bak_dir
        if [[ "${existed_bak_dir}" == "" ]] ; then
            cp -r "${src_dir}${opt_subFolder}"  ${bak_dir}
            echo "${green}backup :${cyan}\n${brown}${src_dir}${opt_subFolder} \n=>\n${bak_dir}${end}"
        else
            echo "${green}backup ${red}${existed_bak_dir}${green} exists in below folder:\n${dst_dir}${end}"
        fi
    else
        mkdir -p "${dst_dir}"
        cp -r "${src_dir}${opt_subFolder}"  ${bak_dir}
        echo "${green}backup :${cyan}\n${brown}${src_dir}${opt_subFolder} \n=>\n${bak_dir}${end}"
    fi
else
    echo "${green}source folder ${red}${src_dir}${green} not exist.${end}"
fi

bash_script_o