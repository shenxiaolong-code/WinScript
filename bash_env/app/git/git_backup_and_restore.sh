#!/bin/bash

bash_script_i

distribute_git_patch() {
    local patch_file=${1}
    ll ${BACKUP_DIR}/git_backup/*.patch | sed "s#${patch_file}#${s_red}${patch_file}${s_end}#"
    if [[ -d  ${job_path} ]] ; then
        cp ${patch_file} ${job_path}/material/
        ll ${job_path}/material/*.patch      | grep --color=always "${patch_file##*/}"
    fi
}

function export_git_stash_2_patch() {
    # git stash show -u -p stash@{0} > my_stash.patch
    local index=${1:-0}
    git stash list | grep "stash@{${index}}"
    echo "\n"
    local patch_name=$(git stash list | grep "stash@{${index}}" | grep -oP "(?<=On) *\w+|(?<= : )[^\[]+" | xargs | sed 's# #_#g')
    local patch_file=${BACKUP_DIR}/git_backup/patch_${patch_name}.patch
    [[ -f ${patch_file} ]] && rm ${patch_file}
    # dumpkey patch_file
    # git stash show -p stash@{0} > ${BACKUP_DIR}/git_backup/patch_$(git show -s --format=%s).patch
    git stash show -u -p stash@{$index} > ${patch_file}
    distribute_git_patch ${patch_file}
}

function export_git_diff_2_patch() {
    # git diff > ${BACKUP_DIR}/git_backup/changes.patch    
    local patch_file=${BACKUP_DIR}/git_backup/diff_$(get_branch_name_local)_$(date "+%Y%m%d_%H%M").patch
    git diff > ${patch_file}
    distribute_git_patch ${patch_file}
}

function import_git_patch_from_backup() {
    local patch_file=${1}
    [[ -z ${patch_file} ]] && { 
        dumpinfo "patch file is empty, please specify the patch file to import from below list:"
        ls ${BACKUP_DIR}/git_backup/patch_*.patch | sed "s#\(patch_.*\)#${s_red}\1${s_end}#g"
        return 1
    }

    [[ ! -f ${patch_file} ]] && {
        dumpinfo "patch file ${patch_file} does not exist"
        return 1
    }
    dumpcmd "git apply --reject ${patch_file}"
    git apply --reject ${patch_file}
    dumpcmd "git status -uno -u"
    git status -uno -u
    dumpcmd "run cmd ${brwon} check_git_patch_can_be_applied ${patch_file} ${blue} to check more details"
}

function check_git_patch_can_be_applied() {
    local patch_file=${1}
    if git apply --check ${patch_file} 2> /dev/null ; then
        dumpinfo "Patch can be applied cleanly"
        return 0
    else
        dumpinfo "Patch cannot be applied cleanly, here are some options:"
        cat << EOF
        1. Try three-way merge with -3 option
           git apply -3 ${patch_file}

        2. Create .rej files with --reject option
           git apply --reject ${patch_file}

        3. Check detailed failure reasons
           git apply --verbose ${patch_file}

        4. Fix whitespace issues
           git apply --whitespace=fix ${patch_file}

        5. Check if patch can be applied
           git apply --check ${patch_file}
EOF
        return 1
    fi
}

function import_git_patch_from_backup_by_pop_index() {
    [[ ! -d ${job_path}/material/ ]] && { dumperr "job_path is not exist : ${job_path}/material/" ; return 1; }
    is_contain_special_file_in_folder "*.patch" ${job_path}/material/ || {
        dumperr "no patch file in ${job_path}/material/"
        return 1
    }
    
    local index=${1:-0}
    local patch_file=$(command ls -ArtdF -1 ${BACKUP_DIR}/git_backup/diff_*.patch | tail -n $(($index+1))  | head -n 1)
    import_git_patch_from_backup ${patch_file}
}

# bakup committed modification
function gbakid()           { source ${BASH_DIR}/app/git/git_backup_commit_id.sh  $1       ; }     # bakid         3f00dbb
function gbaklastcommit()   { gbakid HEAD        ; }     # bakcommit     1

function git_stash_current_change() {
    bModified=0
    git diff-index --quiet HEAD -- || bModified=1 ; 
    if [[ "${bModified}" == "1" ]] ; then
        # git stash save "save sync_backup_$(dtstr)"
        # alias gsave2='gpushx "[$(date "+%Y%m%d_%H%M")] $(git rev-parse --short HEAD) : $(git show -s --format=%s)"'
        local tmp_stash_check_file=${TEMP_DIR}/to_del/stash_save_$(date "+%Y%m%d_%H%M%S").txt
        git diff --check > ${tmp_stash_check_file}
        git diff --cached --check >> ${tmp_stash_check_file}
        dumpinfo "${tmp_stash_check_file}"
        grep -cP "trailing whitespace|space before tab in indent" ${tmp_stash_check_file} > /dev/null && {
            cat ${tmp_stash_check_file}
            dumpinfo "found '${magenta_24}trailing whitespace${green}' or '${magenta_24}space before tab in indent${green}' issue, fix it by :"
            dumpinfo "method 1 : run${lime_256} chkblank"
            dumpinfo "method 2 : check the src file by regular ${red}' +$'${green} in vscode replace to remove the unnecessary trailing whitespace.${end}"
            prompt_confirm "continue to save stash (${pink_256}not suggested${blue}), yes or no ?" || { dumpinfo "abort to save stash!" ; return 1 ; }
        }
        
        local stash_msg="[$(date "+%Y%m%d_%H%M")] ${1:-$(git show -s --format=%s)} [ $(git rev-parse --short HEAD) ]"
        dumpcmd "git stash save -u '${stash_msg}'"
        git stash save -u "${stash_msg}"
    else
        dumpinfo "no local modification to backup."
    fi
    return 0
}

# 请注意，如果你的改动在暂存区和工作区都有，那么你可能需要分两次来恢复你的改动。
# 首先，使用 git stash apply --index 来恢复暂存区的改动，
# 然后再使用 git stash apply 来恢复工作区的改动。这样，你就可以保留你在两个区域的改动。
# 如果只使用 git stash apply ， 则暂存区 (staged chnage) 里的改动就丢失了，还原出来的全部在工作区 (changes) , 这可能不是我们所需要的，我们需要的是 pop 后来的状态和 save 前的状态一模一样。
# git stash apply --index stash@{2}   
function restore_git_modification() {
    bModified=0
    echo "${green}restore local modification from git stash.${end}"
    # git stash apply --index stash@{1}
    resotre_index=${1:-"0"}
    if [[ -z $1 ]] ; then
        dumpinfo "apply the newest stash from possible same branch"
        # get newest stash index from same branch , instead of the newest stash
        pop_stash="$(git stash list | grep "$(get_branch_name_local)" | head -n 1 )"
        if [[ $pop_stash != "" ]] ; then
            dumpinfo "apply stash from current branch"
        else 
            dumpinfo "apply stash from master branch"
            pop_stash="$(git stash list | grep "$(git symbolic-ref refs/remotes/origin/HEAD | sed 's#.*/##g')" | head -n 1 )"
            [[ -z ${pop_stash} ]] && pop_stash="stash@{0}"
        fi
        resotre_index="${pop_stash:7:1}"
    fi
    # git stash list | sed -n "$(expr $resotre_index + 1) p"

    dumpinfo "stage current changes to avoid the apply stash failure -- it should be deleted after apply stash"
    dumpcmd git add -u
    git add -u

    # git stash apply --index ;
    dumpcmdx git stash apply --index "stash@{${resotre_index}}"
    dumpinfo "${brown}$(git stash list | grep "stash@{${resotre_index}}" )"
    local tmp_stash_apply_file=${TEMP_DIR}/to_del/stash_apply_$(date "+%Y%m%d_%H%M%S").txt
    git stash apply --index "stash@{${resotre_index}}" > ${tmp_stash_apply_file} 2>&1
    cat ${tmp_stash_apply_file} | sed "s#modified:   \(.*\)#modified:${s_red}   $(pwd -L)/\1${s_end}#g"
    grep -v '<stdin>:' ${tmp_stash_apply_file} | grep -cP "trailing whitespace|space before tab in indent" > /dev/null && {
        cat ${tmp_stash_apply_file}
        dumpinfo "${tmp_stash_apply_file}"
        dumpinfo "found '${magenta_24}trailing whitespace${green}' or '${magenta_24}space before tab in indent${green}' issue, fix it by :"
        dumpinfo "method 1 : run${lime_256} chkblank"
        dumpinfo "method 2 : check the src file by regular ${red}' +$'${green} in vscode replace to remove the unnecessary trailing whitespace.${end}"
    } || dumpinfo "${tmp_stash_apply_file}"
    # dumpinfo "if ${red}Aborting ${blue}, please stage all local modification and try again."
}


function export_git_stash_by_index() {
    local stash_index=${1:-0}
    local stash_name=$(git stash list | sed -n "$(($stash_index+1))p" | sed 's#-#_#' | cut -d':' -f 2 | cut -d' ' -f 3 )
    local stash_file_name=${stash_name}_${stash_index}_$(date "+%Y%m%d_%H%M%S").patch
    local stash_file_path=${BACKUP_DIR}/git_backup/${stash_file_name}    
    # git stash show -p stash@{${1:-0}} > ${stash_file_path}
    dumpinfo ${stash_file_path}
    dumpinfo "use cmd ${end} lbak ${green}to list all available backup files"
}

function import_git_stash_by_patch_file_path() {
    echo $1
    local stash_file_path=${1}
    [[ ! ( $stash_file_path =~ "/" ) ]] && stash_file_path=${BACKUP_DIR}/git_backup/${stash_file_path}
    dumpinfo ${stash_file_path}
    [[ ! -f $stash_file_path ]] && ( dumperr "stash file not exist : $stash_file_path" ; return 1 )
    import_git_patch_from_backup $stash_file_path
}


function copy_local_modification_from_other_repo() {
    local tmp_src_dir=$1
    [[ ! -d ${tmp_src_dir} ]] && { dumperr "source dir is not exist : ${tmp_src_dir}" ; return 1; }
    local tmp_dst_dir=$(get_git_svn_dir_root)
    [[ ! -d ${tmp_dst_dir} ]] && { dumperr "destination dir is not exist : ${tmp_dst_dir}" ; return 2; }

    git -C "${tmp_src_dir}" status -uno -u --porcelain
    for file in $(git -C "${tmp_src_dir}" status -uno -u --porcelain | cut -d' ' -f 3); do
        dumpinfo "copy file : ${file}"
        cp "${tmp_src_dir}/${file}" "${tmp_dst_dir}/${file}"
    done
}

function save_local_change_into_stash()    { git_stash_current_change  "manual_save : $*"   ; glist ; dumpinfo "${red}gsavel ${blue}to  replace last stash record with current changes"   ; }
function replace_last_stash_with_current_change()   { 
                        dumpinfo "replace last stash record with current changes"
                        # dumpcmd "git stash push -k -u -f"
                        # git stash push -k -u -f
                        # backup current local staged change into lastest stash record , continue working on current local repo
                        # -k : keep the current staged change in current local repo. (Note : not include unstaged change)
                        # -u : include untracked files in the stash, --include-untracked
                        # -f : force to update the lastest stash record stash (stash@{0}) with current local change

                        last_stash_msg=$(git stash list | sed -n '1p' | grep -oP "(?<=manual_save : ).+(?= \[)") 
                        git_stash_current_change  "manual_save : ${last_stash_msg}"   ; 
                        dumpcmd "git stash drop 1 "
                        git stash drop 1 ;
                        dumpcmd "git stash apply --index \"stash@{0}\""
                        git stash apply --index "stash@{0}"
                        # --index      : resotre all stage/unstage change and try to merge the staged/unstaged change into current local repo
                        # --keep-index : only restore the unstaged change , not apply the staged change -- it is not expected
                        glist ;
                    }
function pop_change_from_stash()    { restore_git_modification "${1}"   ; glist ;   }
function delete_stash_by_index()    { git stash drop $1                 ; glist ;   }

#   src : local_change  , commit_id     , version_diff  , other_branch  , stash
#   dst : stash         , patch_file    , backup_folder
function show_git_backup_ways() {
    if [[ $# == 0 ]] ; then
        dumpinfo "[ way 1 ] ${brown}gsave ${black}# stash change -- git_stash_current_change"
        dumpinfo "          ${brown}gpop ${red}[idx] ${black}# restore from stash change -- restore_git_modification"
        echo
        dumpinfo "[ way 2 ] 0 : ${brown}list_git_backup      ${black}# list all backup files in ${BACKUP_DIR}/git_backup"
        dumpinfo "          1 : ${brown}export_git_stash_2_patch  ${red}<idx> or ${brown}gexport ${black}# save stash to patch file "
        dumpinfo "          2 : ${brown}export_git_diff_2_patch   ${red}<msg> or ${brown}gexport2 ${black}# save diff to patch file "
        dumpinfo "          3 : ${brown}import_git_patch_from_backup ${red}<patch_file> ${black} or ${brown}gimport ${black}# restore from patch file "        
        echo
        dumpinfo "[ way 3 ] 4 : ${brown}gbakid     ${red}<commit_id> ${black}# backup by commit id "
        dumpinfo "          5 : ${brown}gbaklastcommit ${black}# backup last commits "        
        dumpinfo "          6 : ${brown}copy_local_modification_from_other_repo ${red}<src_dir> ${black}# copy files from other repo "
        dumpinfo "              ${brown}jbak       ${black}# job_backup_repo_file  | backup files to job_path/material"
        dumpinfo "              ${brown}jres       ${black}# job_restore_repo_file | restore files from job_path/material"
    fi

    [[ $1 == "0" ]] && list_git_backup
    [[ $1 == "1" ]] && export_git_stash_2_patch      $2
    [[ $1 == "2" ]] && export_git_diff_2_patch      "${@:2}"
    [[ $1 == "3" ]] && import_git_patch_from_backup "${@:2}"
    [[ $1 == "4" ]] && source ${BASH_DIR}/app/git/git_backup_commit_id.sh $2 
    [[ $1 == "5" ]] && gbaklastcommit
    [[ $1 == "6" ]] && copy_local_modification_from_other_repo "$2"
}

alias gexport=export_git_stash_2_patch
alias gexport2=export_git_diff_2_patch
alias gimport=import_git_patch_from_backup
alias gbak=show_git_backup_ways

# patch file
alias patchi=import_git_stash_by_patch_file_path
alias patcho=export_git_stash_by_index
function list_git_backup() {
    echo ll ${BACKUP_DIR}/git_backup ;
    lp ${BACKUP_DIR}/git_backup | sed "s#debug#${s_red}debug${s_end}#g" ; 
    dumpinfo "restore a patch    : patchi patchFileName" ;
    dumpcmd "git stash list"
    git stash list | sed "s#$(get_branch_name_local)#${s_red}&${s_end}#g"
    dumpinfo "restore a patch from stash : gpop [idx]"
}
# backup folder
alias lbak=list_git_backup

alias cdbak='cd ${BACKUP_DIR}/git_backup/`/bin/ls -rthF ${BACKUP_DIR}/git_backup | tail -n 1` ;  list_dir_with_reversed_index ; '

if [[ 1 -eq 2 ]] ; then
    alias gsave=export_git_diff_2_patch
    alias gpop=import_git_patch_from_backup_by_pop_index
else
    alias gsave=save_local_change_into_stash
    alias gsavel=replace_last_stash_with_current_change
    alias gpop=pop_change_from_stash
    alias gdropx=delete_stash_by_index
fi

bash_script_o
