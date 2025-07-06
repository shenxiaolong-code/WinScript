
bash_script_i

[[ $1 == "" ]]  || {
  echo "${red}empty parameter,the ${green} usage example :${end}"
  echo "source ${BASH_DIR}/app/git/git_backup_commit_id.sh   44f0642454"
  echo "source ${BASH_DIR}/app/git/git_backup_commit_id.sh   HEAD"
  echo "source ${BASH_DIR}/app/git/git_backup_commit_id.sh   HEAD~2"  
  # echo "source ${BASH_DIR}/app/git/git_backup_commit_id.sh   $(git rev-parse --short HEAD)"
  return 1
}

# backup last N commits files
# usage example : source ${BASH_DIR}/app/git/git_backup_commit_id.sh   44f0642454
echo
echo backup all files in commid id : ${red}$1${end}
gitCommitID=$(git show --oneline "$1" | cut -d' '  -f 1)

backFolderRoot=${BACKUP_DIR}/git_backup
if [[ ! -d "${backFolderRoot}" ]] ; then
    mkdir "${backFolderRoot}"
fi

gitCmd="git diff --name-only  HEAD..HEAD~${commitNumber}"
gitCmd="git diff-tree --no-commit-id --name-only -r  ${gitCommitID}"

curFoler=`pwd -L`
curBrName=`git symbolic-ref --short HEAD`
backFolderName=`date "+%Y%m%d_%H%M"`_`echo ${curBrName} | sed 's#/#_#g'`_id_${gitCommitID}
backFolder=${backFolderRoot}/${backFolderName}
if [[ -d "${backFolder}" ]] ; then
    rm -rf "${backFolder}"
fi

gitFiles=(` ${gitCmd} `)
for i in ${gitFiles[@]} ; do
  if [[ ! -r "${curFoler}/$i" ]] ; then
    continue
  fi
  srcFile=${curFoler}/`echo $i|cut -f2 -d' '`
  dstFile=${backFolder}/$i
  dstFolder=`echo ${dstFile} | sed 's#\(.*\)/.*#\1#g'`
  if [[ ! -d "${dstFolder}" ]] ; then
    mkdir -p "${dstFolder}"
  fi
  # echo  backuping $i to : ${dstFile}
  cp "${srcFile}" "${dstFile}"
  echo $i
done

echo
echo "files  in backup folder ( ${backFolder} )"
dstFiles=`find "${backFolder}" -type f -iname "*"`
for  i in ${dstFiles[@]} ; do
    echo ${gray}$i${end}
done

echo
echo "files  in git repo ( ${curFoler} )"
${gitCmd}

echo
echo ${gitCmd}
echo you can run cmd to resotre one backup : ${green}rbak  ${backFolderName}${end}
echo list all backups : ${brown}lbak${end}

echo 
echo usage example : source ${BASH_DIR}/app/git/git_backup_commit_id.sh

echo
bash_script_o