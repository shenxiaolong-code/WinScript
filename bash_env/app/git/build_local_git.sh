#!/bin/bash

bash_script_i
echo

git_src_download_dir=${EXT_DIR}/tmp/cache/git_src
git_install_dir=${EXT_DIR}/myDepency/tools/git_local_build

function download_git_source(){
    dumppos
    # wget https://mirrors.edge.kernel.org/pub/software/scm/git/git-2.41.0.tar.gz
    # tar -xzf git-2.41.0.tar.gz
    # cd git-2.41.0

    # clean download && build
    # [[ -d ${git_src_download_dir} ]] && rm -rf ${git_src_download_dir}

    if [[ ! -d ${git_src_download_dir} ]]; then
        mkdir -p ${git_src_download_dir}
    fi
    outputFolderPath=${git_src_download_dir}/git-2.41.0
    [[ -d "${outputFolderPath}" ]] && rm -rf ${outputFolderPath}

    git_src_download_url=https://mirrors.edge.kernel.org/pub/software/scm/git/git-2.41.0.tar.gz
    git_src_download_package=${git_src_download_dir}/git-2.41.0.tar.gz
    [[ ! -f ${git_src_download_package} ]] && source ${BASH_DIR}/bin/download/download.sh ${git_src_download_url}   ${git_src_download_dir}/
    if [[ ! -f ${git_src_download_package} ]] ; then
        dumperr "Fails to download git source package : ${git_src_download_package}"
        return 1
    else
        [[ ! -d "${outputFolderPath}" ]] && source ${BASH_DIR}/bin/unpack.sh  ${git_src_download_package} ${git_src_download_dir}/
    fi

    if [[ -d "${outputFolderPath}"  ]]; then
        return 0
    else    
        dumpkey git_src_download_url
        dumpkey git_src_download_dir
        dumperr "Fails to download git source to dir : ${git_src_download_dir}"
        return 1
    fi
}

function build_git_locally()
{
    dumppos
    cd ${outputFolderPath}
    # try to fix possible failure because of missing dynamic library
    # NO_GETTEXT=1   :  no multi-language support, else need lib msgfmt : /bin/sh: 1: msgfmt: not found
    {
        ./configure --prefix=${git_install_dir}
        make NO_GETTEXT=1
        make install
    }  2>&1 | tee ${git_src_download_dir}/git_build.log

    dumpinfo "git build log : ${git_src_download_dir}/git_build.log"
    if [[ -f "${git_install_dir}/bin/git" ]]; then
        return 0
    else
        dumpkey git_install_dir
        dumperr "Fails to build git to dir : ${git_install_dir}"
        return 1
    fi
}

function configure_git_env_vars()
{
    dumppos
    export PATH="${git_install_dir}:$PATH"
    export LD_LIBRARY_PATH="${git_install_dir}/lib:$LD_LIBRARY_PATH"
    command -v git 
    git --version
}

download_git_source "$@" && build_git_locally "$@" && configure_git_env_vars "$@"

echo
bash_script_o
