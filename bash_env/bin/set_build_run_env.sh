bash_script_i

curLib="."
if [[ -f "./install/test/cask/bin/cask_tester" ]]; then
    echo "${green} set cask6 LD_LIBRARY_PATH ${end}"
    curLib="`pwd -L`/install/lib64"
fi
if [[ -f "./install/bin/cask-sdk-cask-tester" ]]; then
    echo "${green} set cask5 LD_LIBRARY_PATH ${end}"
    curLib="`pwd -L`/install/lib64"
fi

LD_LIBRARY_PATH="${curLib}:${PATH}:$CUDA_INSTALL_DIR/lib64:${LD_LIBRARY_PATH}"
export LD_LIBRARY_PATH="${LD_LIBRARY_PATH}"
echo "${brown}LD_LIBRARY_PATH:${green}${LD_LIBRARY_PATH}${end}"

echo
bash_script_o

