#!/bin/bash

bash_script_i
echo

function setup_hook_dir() {
    [[ -f ~/.git-templates ]]   && rm ~/.git-templates
    ln -s ${BASH_SOURCE[0]%/*}  ~/.git-templates
    git config --global init.templatedir '~/.git-templates'
}

function set_permission() {
    chmod a+x ~/.git-templates/hooks/post-commit
}

function reinit_existing_repos() {
    local repo_root=${1:-~}
    for repo in $(find ${repo_root}/ -name .git -type d); do
        repo=${repo%/.git}
        echo "Re-initializing $repo"
        git init -q --template ~/.git-templates $repo
    done
}

function setup_git_global_hool_main() {
    setup_hook_dir
    set_permission
    reinit_existing_repos
}

setup_git_global_hool_main "$@"

echo
bash_script_o
