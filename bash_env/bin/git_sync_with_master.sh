
bash_script_i
# https://www.cnblogs.com/xinmengwuheng/p/7115549.html
# git rebase origin/dev              // it might be OK ?
masterBrName=dev
masterBrName=`git symbolic-ref refs/remotes/origin/HEAD | sed 's#.*/##g'`
curBrName=`git symbolic-ref --short HEAD`

# check local modification
# git diff-index --quiet HEAD -- || echo "modified!"; 
bModified=0
git diff-index --quiet HEAD -- || bModified=1
if [[ "${bModified}" == "1" ]]; then
    git stash save sync_backup_`dtstr`
    echo "${red}local modification is backuped into git stash.${end}"
fi

echo ${green}updating branch ${red} ${curBrName} ${end} ...
if [[ "${curBrName}" == "${masterBrName}" ]]; then
    git fetch --all --prune ; 
    git pull --rebase -X theirs
    echo
else
    git checkout  ${masterBrName}
    git fetch --all --prune ; 
    git pull --rebase -X theirs
    git checkout ${curBrName}
    # git merge ${masterBrName} --no-commit v1.0
    # git merge ${masterBrName} --no-commit --no-ff
    git merge --m "Merge branch 'dev' into ${curBrName}" ${masterBrName}
    
    echo
    echo ${cyan}resolve the possible sync conflicts by editing files. ${green}steps:${end}
    echo "git add <resolved_files>"
    echo 'git commit -m "message"'
    echo
fi

if [[ "${bModified}" == "1" ]]; then    
    # echo ${green}run possible cmd for saved modification : ${red}git stash pop ${end}
    # git stash pop
    echo "${purple}local modification exists, please run command ${red}git stash pop or gpop${purple} after you resolve all possible merge conflict .${end}"
fi

# git branch --contains f053976b2528e61e34e5f35423b162d204a89cb7

echo  --------- leaving ${EXT_DIR}/bin/git_sync_with_master.sh ...