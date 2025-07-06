bash_script_i
dumpcmdline
# echo "Current working directory: $(pwd)"

tmp_build_path="$(pwd -L)"
makefile_path=$1
[[ ! -f "${makefile_path}" && -f ./Makefile                         ]] && makefile_path=./Makefile
[[ ! -f "${makefile_path}" && -f $tmp_build_path/build/Makefile     ]] && makefile_path="${tmp_build_path}/build/Makefile"
[[ ! -f "${makefile_path}" && -f $tmp_build_path/build/build.ninja  ]] && makefile_path="${tmp_build_path}/build/build.ninja"
# makefile_path="${1:-${tmp_build_path}/build/Makefile}"
if [[ ! -f "${makefile_path}" ]] ; then
    dumperr "${red}No make file ${green}${makefile_path} ${red}, can not make directly.${end}"
    dumpkey makefile_path
    # dumpinfo "run cmd '${red} ninja -C ./build -t targets ${green}' if your project is using${brown} ninja ${green}build system"
    return
fi

tmp_log_file="${TEMP_DIR}/to_del/target_log_${tmp_build_path##*/}.log"

function dump_makefile_targets() {
    # pushd ${makefile_path%/*}
    dumpinfox "generate all targets in ${makefile_path}"
    dumpinfo  "output log : ${brown}${tmp_log_file}${end}"
    # https://blog.csdn.net/caz28/article/details/131766158
    echo                                                                                                                                        >| "${tmp_log_file}"
    dumpinfo "make -f $makefile_path help"                                                                                                      >> "${tmp_log_file}"
    make -f $makefile_path help                                                                                                                 >> "${tmp_log_file}"
    echo                                                                                                                                        >> "${tmp_log_file}"
    makefile_folder=${makefile_path%/*}
    dumpinfo "make -qp"                                                                                                                         >> "${tmp_log_file}"
    ( cd $makefile_folder && make -qp ) | awk -F':' '/^[a-zA-Z0-9][^$#\/\t=]*:([^=]|$)/ {split($1,A,/ /);for(i in A)print A[i]}'|sort -u        >> "${tmp_log_file}"
    # popd
}

function dump_ninja_targets() {
    dumpinfox "generate all targets in ./build/build.ninja"
    dumpinfo  "output log : ${brown}${tmp_log_file}${end}"
    # https://blog.csdn.net/caz28/article/details/131766158
    echo                                                                                                                                        >| "${tmp_log_file}"
    dumpinfo "ninja -C ${makefile_path%/*} -t targets"                                                                                          >> "${tmp_log_file}"
    ninja -C ${makefile_path%/*} -t targets                                                                                                     >> "${tmp_log_file}"
}


if [[ ! -f "${tmp_log_file}" || "$1" != "" || ! -v reuse_targets ]] ; then
    [[ "${makefile_path##*/}" == "Makefile"     ]] && dump_makefile_targets
    [[ "${makefile_path##*/}" == "build.ninja"  ]] && dump_ninja_targets
else
    dumpinfox "${red}Reuse existing target log file : ${green}${tmp_log_file}${end}"
fi

dumpinfox "All targets in ${makefile_path}"
cat $tmp_log_file
# below options list all targets include compile command , it is very slow
# make -p -f Makefile

echo
dumpinfo "${tmp_log_file}"
dumpinfo "search all cmake option , run cmd ${brown} search_cmake_options "
# dumpinfo "${EXT_DIR}/repo/linux_pratice/cmake_build/doc/search_cmake_options_tips.txt"
# dumpinfo "https://cmake.org/cmake/help/latest/manual/cmake-variables.7.html"
bash_script_o
