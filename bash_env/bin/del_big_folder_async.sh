
bash_script_i

function quick_delete_folder_check(){
    [[ ! -d "${to_del_folder}" ]] && { 
        dumperr "folder ${brown}${to_del_folder}${end} not exists." 
        return 1 
    }

    local force_mode=$2
    if [[ "$force_mode" != "--force" ]] ; then
        # protect some important special folders
        is_inside_git_svn_repo ${to_del_folder}                          && { dumperr "can't quickly deleted git svn repo folder : ${brown}${to_del_folder}${end}"   ; return 1 ; }
        is_same_path ${to_del_folder} "${EXT_DIR}"             && { dumperr "can't quickly deleted necessary folder : ${brown}${to_del_folder}${end}"      ; return 1 ; }
        is_same_path ${to_del_folder} "${EXT_DIR}/build"       && { dumperr "can't quickly deleted necessary folder : ${brown}${to_del_folder}${end}"      ; return 1 ; }
        is_same_path ${to_del_folder} "${EXT_DIR}/myDepency"   && { dumperr "can't quickly deleted necessary folder : ${brown}${to_del_folder}${end}"      ; return 1 ; }
        is_same_path ${to_del_folder} "${EXT_DIR}/tmp"         && { dumperr "can't quickly deleted necessary folder : ${brown}${to_del_folder}${end}"      ; return 1 ; }
        is_same_path ${to_del_folder} "${EXT_DIR}/myTasks"     && { dumperr "can't quickly deleted necessary folder : ${brown}${to_del_folder}${end}"      ; return 1 ; }
        is_same_path ${to_del_folder} "${EXT_DIR}/repo/linux_pratice"  && { dumperr "can't quickly deleted necessary folder : ${brown}${to_del_folder}${end}"    ; return 1 ; }
    else
        dumpcmdline
        echo "${red}force delete folder ${brown}${to_del_folder}${end} ..."
        prompt_confirm "input${brown} yes ${blue}to comfirm to delete folder" || return 2
    fi
    return 0
}

function quick_delete_folder_check_inusing() {
    if lsof "$to_del_folder" >/dev/null 2>&1; then
        dumpinfo "Directory $to_del_folder is in use, need L kill -9 pid \n"
        lsof "$to_del_folder" 2> /dev/null | grep "${to_del_folder}" | grep "${USER}" # | awk 'NR>1 {print $2}' | xargs  echo kill -9 ${1}
        return 1
    fi
    return 0
}

function quick_delete_folder_doing() {
    is_same_path ${to_del_folder} $(pwd) && cd ${to_del_folder}/..

    local to_dst_folder="$2"
    if [[ "${to_dst_folder}" == "" || "${to_dst_folder}" == "--force" ]] ; then
        to_dst_folder="${TEMP_DIR}/to_del"
        [[ ! -d "${to_dst_folder}" ]] && mkdir -p "${to_dst_folder}"
    fi
    to_dst_folder="$(cd ${to_dst_folder} && pwd)"

    if [[ ! -d "${to_dst_folder}" ]] ; then
        mkdir -p "${to_dst_folder}"
    fi

    to_del_folder="$(realpath ${to_del_folder})"

    if [[ "${to_del_folder}" != "${TEMP_DIR}" ]] &&  [[ "${to_del_folder}" != "${to_dst_folder}" ]] ;then
        echo "${green}quick delete folder ${brown}${to_del_folder}${end} ..."
        local mv_dir_name="`echo ${to_del_folder} | sed 's#/#_#g'`_`date "+%Y%m%d_%H%M"`"
        deleted_folder_dir=${to_dst_folder}/${mv_dir_name}
        mv  "${to_del_folder}"   "${deleted_folder_dir}"
        echo "${red}${deleted_folder_dir}${end}"
        echo
        dumpinfo "restore cmd : mv ${deleted_folder_dir} ${to_del_folder}"
    else
        echo "${green} immediately delete ${brown}${to_del_folder}${end} ..."
        echo "${brown} need manual delete to avoid risk to delete important folder${end} ..."
        # rm -rf "${to_del_folder}"  &
        # mkdir -p "${to_del_folder}"
    fi    
}

function quick_delete_folder_main() {
    to_del_folder=$(cd $1 && pwd )          # resolve relative path , else the is_inside_git_svn_repo is very very very slow
    deleted_folder_dir=

    quick_delete_folder_check "$@" || return 1

    if quick_delete_folder_check_inusing ; then
        quick_delete_folder_doing "$@"
        return $?
    else
        dumpinfo "Directory $to_del_folder is in use, can't delete it now."
        return 1
    fi
}

quick_delete_folder_main "$@"

bash_script_o
