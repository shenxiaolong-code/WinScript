
bash_script_i
# ${EXT_DIR}/dbg_investigate/localBuild/cask_sdk_dev_farm/_deps/googletest-src/googletest/cmake
#  cd ./cask_core
#  find ./  -type f -iname "CMakeLists.txt" | xargs grep -n -- "--warning-as-error"
#  find ./  -type f -iname "CMakeLists.txt" | xargs grep -n -- "-Werror"

if [ -f "./cask_core/cask_plugin/CMakeLists.txt" ] ; then
    this_repo_folder=`pwd -L`
    echo
    echo "# to disable the debug info of device code to reduce the ci build binary code :"                  
    echo "# add ' --suppress-debug-info ' in :"
    echo "${green}update : ${red}${this_repo_folder}/cask_core/cask_plugin/CMakeLists.txt:1515 ${end}"
    sed -i -- 's/"--warning-as-error;/"--suppress-debug-info;--warning-as-error;/g'  "./cask_core/cask_plugin/CMakeLists.txt"

    # cat -n ./cask_core/cask_plugin/CMakeLists.txt | grep -- "--warning-as-error;"
    # alternative in cmake option: -DCASK_COMPILE_WARNINGS_AS_ERRORS=FALSE 
    # echo "# remove ' --warning-as-error; ' in :"  
    # echo "${green}update : ${red}${this_repo_folder}/cask_core/cask_plugin/CMakeLists.txt:1515${end}"
    # sed -i -- 's/--warning-as-error;//g'  "./cask_core/cask_plugin/CMakeLists.txt"

    echo                                                                                            
    echo "# search ' -lineinfo ' in CMakeLists.txt , and comment out this line"                             
    # echo "./cask_core/CMakeLists.txt:868"
    echo "${green}update : ${red}${this_repo_folder}/cask_core/CMakeLists.txt:868 ${end}"
    sed -i -- 's/\(.*:-lineinfo\)/# \1/g'  "./cask_core/CMakeLists.txt"
    # echo "./cask_core/cask-tester/CMakeLists.txt:213"
    echo "${green}update : ${red}${this_repo_folder}/cask_core/cask-tester/CMakeLists.txt:213 ${end}"
    sed -i -- 's/ -lineinfo//g'  "./cask_core/cask-tester/CMakeLists.txt"

    # https://unix.stackexchange.com/questions/112023/how-can-i-replace-a-string-in-a-files
    # replace in file : sed -i -- 's/foo/bar/g' *

    echo
    echo "${green}repo dir : ${red}.${end}"
else
    echo "${red}[ERROR]${brown}this script MUST be run in cask5 (cask_sdk) repo directory.${end}"
fi

bash_script_o

