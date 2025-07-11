bash_script_i
echo

dumpinfox "Fetch path from ${brown}${BASH_SOURCE[0]%/*}/build_mlir_server.sh"
# egrep "^output_folder=" ${BASH_SOURCE[0]%/*}/build_mlir_server.sh
source <(egrep "^output_folder=" ${BASH_SOURCE[0]%/*}/build_mlir_server.sh)
source <(egrep "^llvm_repo_path=" ${BASH_SOURCE[0]%/*}/build_mlir_server.sh)
source <(egrep "^build_type=" ${BASH_SOURCE[0]%/*}/build_mlir_server.sh)
dumpkey llvm_repo_path
dumpkey output_folder
cd ${output_folder}

# cmake -G Ninja ../llvm \
#   -DLLVM_ENABLE_PROJECTS=mlir \
#   -DCMAKE_INSTALL_PREFIX=~/llvm-install \
#   -DCMAKE_BUILD_TYPE=Release \
#   -DLLVM_ENABLE_ASSERTIONS=ON

source ${BASH_DIR}/nvidia/amodel/run_on_amodel/example/load_amodel_env_fixed.sh

tmp_llvm_log=${output_folder}/build.log
dumpkey tmp_llvm_log

(
    echo
    echo  "# $(date +"%Y/%m/%d %T") on $(hostname)"
    echo  "# generate by : ${BASH_SOURCE[0]%/*}/build_mlir_server.sh"
    echo  "# cmake cmd   : ${BASH_SOURCE[0]}:46"
    echo  "# build guide : https://releases.llvm.org/18.1.8/docs/GettingStarted.html"
    echo

    echo  "# configured variables:"
    echo  "llvm_repo_path : ${llvm_repo_path}"
    echo  "build_type     : ${build_type}"
    echo  "output_folder  : ${output_folder}"
    echo

    echo  "configure vscode for mlir server"
    echo  "mlir.server_path : ${output_folder}/bin/mlir-lsp-server"
    echo  "mlir.pdll_server_path : ${output_folder}/bin/mlir-pdll-lsp-server",
    echo  "mlir.tablegen_server_path : ${output_folder}/bin/tblgen-lsp-server"
    echo
) >| ${tmp_llvm_log}

cmake_cmd_file=${output_folder}/build_cmd.sh
dumpkey cmake_cmd_file
{
    echo "# generated by ${BASH_SOURCE[0]}:${LINENO}"
    echo
    printf "%-124s  \\\\\\n"  "cmake ${tmp_cmake_debug}"        \
    "-S ${llvm_repo_path}/llvm"                                 \
    "-B ${output_folder}/build"                                 \
    '-G "Ninja"'                                                \
    '-DLLVM_ENABLE_PROJECTS="mlir;clang;lld"'                   \
    -DBUILD_SHARED_LIBS=ON                                      \
    -DLLVM_INSTALL_UTILS=ON                                     \
    -DLLVM_BUILD_EXAMPLES=ON                                    \
    -DLLVM_ENABLE_RTTI=ON                                       \
    -DLLVM_BUILD_TOOLS=ON                                       \
    -DLLVM_ENABLE_ASSERTIONS=ON                                 \
    -DLLVM_USE_LINKER=lld                                       \
    -DCMAKE_BUILD_TYPE=${build_type}                            \
    -DCMAKE_INSTALL_PREFIX=${output_folder}/install             \
    -DCMAKE_C_COMPILER=/home/utils/gcc-11.2.0/bin/gcc           \
    -DCMAKE_CXX_COMPILER=/home/utils/gcc-11.2.0/bin/g++     

    echo
    echo
    echo "[[ -f ${output_folder}/build/build.ninja ]] && ninja install -C ${output_folder}/build "
    echo
} | tee ${cmake_cmd_file}

# cmake --build . --target install
# dumpinfox "cmmake --build ${output_folder} --target install"
# time cmake --build ${output_folder} --target install    |  tee -a ${tmp_llvm_log}

time source ${cmake_cmd_file} |  tee -a ${tmp_llvm_log}

# -DLLVM_BUILD_TOOLS=ON  will generate mlir language server ./bin/mlir-lsp-server , it is used in vscode plugin llvm-vs-code-extensions.vscode-mlir => setting workspace : Server_path
# -DLLVM_TARGETS_TO_BUILD="X86;NVPTX;AMDGPU" \
# -DLLVM_ENABLE_PROJECTS="clang;lld" \

# specify the MLIR_DIR and LLVM_DIR path to the MLIR source directory
# cmake -G Ninja .. -DMLIR_DIR=/path/to/mlir -DLLVM_DIR=/path/to/llvm -DBUILD_SHARED_LIBS=ON -DLLVM_ENABLE_PROJECTS="mlir"

# LLVM_BUILD_TOOLS will include below tools:
# echo
# dumpinfox "cmake --build . --target mlir-lsp-server"
# cmake --build ${output_folder}/build --target mlir-lsp-server

echo                            |  tee -a ${tmp_llvm_log}

echo
dumpcmd "ll ${output_folder}/build/bin"
ll ${output_folder}/build/bin

echo
bash_script_o
