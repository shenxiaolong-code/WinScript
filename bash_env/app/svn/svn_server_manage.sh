#!/bin/bash

bash_script_i

function _init_svn_env() {
  SVN_USER='xlshen'
  SVN_PWD='aaAA11!!'
  SVN_PATH_PARENT='https://10.23.148.225/svn/work/linuxPratice'
}

function add_svn_repo() {
  # Requires environment variables:
  _init_svn_env

  local cur_repo_dir=$(pwd -L)
  local cur_repo_dir_bak=${cur_repo_dir}_bak_$(date +%Y%m%d_%H%M%S)

  local repo_name=$(basename "${cur_repo_dir}" | sed 's/\./_/g')
  local svn_parent_url="$SVN_PATH_PARENT"
  local svn_repo_url="${svn_parent_url}/${repo_name}"

  cd ..
  mv "${cur_repo_dir}" "${cur_repo_dir_bak}"

  echo
  dumpinfox "1.Creating repository directory: $svn_repo_url"
  # 1. Create repository emptydirectory remotely
  dumpcmd "svn mkdir $svn_repo_url -m 'Create repository directory $repo_name' --username $SVN_USER --password ****** --non-interactive"
  svn mkdir "$svn_repo_url" -m "Create repository directory $repo_name" --username "$SVN_USER" --password "$SVN_PWD" --non-interactive || {
    dumperr "Failed to create repository directory"
    return 1
  }
  dumpinfo "Successfully created repository directory: $svn_repo_url"

  
  echo
  dumpinfo "2.backup the original repo to ${cur_repo_dir_bak} and ready to import"
    # Temporarily move .git directory to avoid importing it
  [[ -d ${cur_repo_dir_bak}/.git ]] && {
    dumpinfo "Moving ${cur_repo_dir_bak}/.git directory to avoid importing it"
    local git_bak=${TEMP_DIR}/git_bak_$(date +%Y%m%d_%H%M%S)
    mv ${cur_repo_dir_bak}/.git "$git_bak"
    gitignore_bak=${TEMP_DIR}/.gitignore_bak_$(date +%Y%m%d_%H%M%S)
    [[ -f ${cur_repo_dir_bak}/.gitignore ]] && mv ${cur_repo_dir_bak}/.gitignore ${gitignore_bak}
  }

  echo
  dumpinfo "3.Importing repo directory content to $svn_repo_url  # (no trunk)"
  dumpcmd "svn import -m 'Import project code' --username $SVN_USER --password ****** --non-interactive ${cur_repo_dir_bak} $svn_repo_url"
  svn import -m "Import project code" --username "$SVN_USER" --password "$SVN_PWD" --non-interactive "${cur_repo_dir_bak}" "$svn_repo_url" || {
    [[ -d "$git_bak" ]] && mv "$git_bak" ${cur_repo_dir_bak}/.git
    [[ -f "${gitignore_bak}" ]] && mv "${gitignore_bak}" ${cur_repo_dir_bak}/.gitignore
    mv "${cur_repo_dir_bak}" "${cur_repo_dir}"
    cd "${cur_repo_dir}"
    dumperr "Import failed"
    return 1
  }
  dumpinfo "Imported successfully"

  echo
  dumpinfo "4.Checkout the new repository directory to set svn:ignore properties"
  dumpcmd "svn checkout --username $SVN_USER --password ****** --non-interactive $svn_repo_url ${cur_repo_dir}"
  svn checkout --username "$SVN_USER" --password "$SVN_PWD" --non-interactive "$svn_repo_url" "${cur_repo_dir}" || {
    [[ -d "${cur_repo_dir}" ]] && rm -rf "${cur_repo_dir}"
    mv "${cur_repo_dir_bak}" "${cur_repo_dir}"
    [[ -d "${git_bak}" ]] && mv "${git_bak}" "${cur_repo_dir}/.git"
    [[ -f "${gitignore_bak}" ]] && mv "${gitignore_bak}" "${cur_repo_dir}/.gitignore"
    cd "${cur_repo_dir}"
    dumperr "Failed to checkout repository"
    return 1
  }

  echo
  cd "${cur_repo_dir}"
  [[ -d "${git_bak}" ]] &&mv "${git_bak}" ./.git
  [[ -f "${gitignore_bak}" ]] && mv "${gitignore_bak}" ./.gitignore
  
  dumpinfo "5.Set svn:ignore for .git and .gitignore"
  # 4. Set svn:ignore for .git and .gitignore
  echo -e ".git\n.gitignore" > ignore_list.txt

  # 5. Append .gitignore contents if exists
  if [ -f "./.gitignore" ]; then
    cat "./.gitignore" >> ignore_list.txt
  fi

  # Remove duplicates and empty lines
  sort ignore_list.txt | uniq | grep -v '^$' > ignore_final.txt

  # Set svn:ignore property
  dumpcmd "svn propset svn:ignore -F ignore_final.txt ."
  svn propset svn:ignore -F ignore_final.txt . || {
    dumperr "Failed to set svn:ignore"
    return 1
  }
  dumpinfo "Successfully set svn:ignore for .git and .gitignore"

  echo
  dumpinfo "6.Commit svn:ignore changes"
  dumpcmd "svn commit -m 'Set svn:ignore for .git, .gitignore and gitignore contents' --username $SVN_USER --password ****** --non-interactive"
  svn commit -m "Set svn:ignore for .git, .gitignore and gitignore contents" --username "$SVN_USER" --password "$SVN_PWD" --non-interactive || {
    dumperr "Failed to commit svn:ignore"
    return 1
  }
  dumpinfo "Successfully committed svn:ignore changes"

  echo
  dumpinfo "Repository created and imported successfully at $svn_repo_url"
  dumpinfo "You can delete this repo on svn server with cmd :${brown} remove_svn_repo $svn_repo_url"
}

function remove_svn_repo() {
  _init_svn_env
  local svn_repo_url=$1
  dumpcmd "svn delete $svn_repo_url -m 'Delete repository directory $svn_repo_url' --username $SVN_USER --password ****** --non-interactive"
  svn delete "$svn_repo_url" -m "Delete repository directory $svn_repo_url" --username "$SVN_USER" --password "$SVN_PWD" --non-interactive || {
    dumpinfo "Usage example: ${brown}remove_svn_repo ${SVN_PATH_PARENT}/yyy${end}"
    dumperr "Failed to delete repository directory"
    return 1
  }
  dumpinfo "Successfully deleted repository directory $svn_repo_url"
}

function list_remote_svn_repo() {
  _init_svn_env
  dumpcmd "svn list $SVN_PATH_PARENT --username $SVN_USER --password ****** --non-interactive"
  svn list "$SVN_PATH_PARENT" --username "$SVN_USER" --password "$SVN_PWD" --non-interactive || {
    dumperr "Failed to list remote svn repo"
    return 1
  }
  dumpinfo "Successfully listed remote svn repo"
}

bash_script_o
