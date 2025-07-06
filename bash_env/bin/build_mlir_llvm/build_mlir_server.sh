bash_script_i
echo

# vscode setting workspace : Server_path
# ${EXT_DIR}/build/dkg_with_ninja/build/tools/mlir-lsp-server/nv-mlir-lsp-server

dumpinfo "build guide :${green} https://releases.llvm.org/18.1.8/docs/GettingStarted.html"

llvm_repo_path=${EXT_DIR}/repo/offical_llvm_project_repo

# git clone https://github.com/llvm/llvm-project.git  ${EXT_DIR}/repo/llvm_project
if [[ ! -d ${llvm_repo_path} ]] ; then
    dumpinfo "git clone --recurse-submodules https://github.com/llvm/llvm-project.git  ${llvm_repo_path}"
    # git submodule update --init --recursive
    git clone --recurse-submodules https://github.com/llvm/llvm-project.git  ${llvm_repo_path}
fi
# [[ ! -f ${llvm_repo_path}/mlir/include/mlir/IR/Module.h ]] && dumperr "no mlir submodule, wrong llvm repo content" && return 2

build_type=Debug
# build_type=Release
output_folder=${EXT_DIR}/build/offical_llvm_${build_type}
# keep the successful build
[[ -f $output_folder/build/build.ninja ]] && mv $output_folder  ${output_folder}_$(date "+%Y%m%d_%H%M%S")
# delete the failed build
[[ -d $output_folder ]] && source ${BASH_DIR}/bin/del_big_folder_async.sh  $output_folder

mkdir -p $output_folder
cd ${output_folder}

source ${BASH_DIR}/nvidia/amodel/run_on_amodel/example/load_amodel_env_fixed.sh

# source ${BASH_DIR}/app/vscode/config/mlir/build_cmake.sh
source ${BASH_SOURCE[0]%/*}/build_cmake.sh

echo
dumpinfox "configure vscode for mlir server"
dumpinfo "mlir.server_path : ${output_folder}/bin/mlir-lsp-server"
dumpinfo "mlir.pdll_server_path : ${output_folder}/bin/mlir-pdll-lsp-server",
dumpinfo  "mlir.tablegen_server_path : ${output_folder}/bin/tblgen-lsp-server"

# "mlir.pdll_compilation_databases": [
#   "/path/to/your/pdll_compile_commands.yml"
# ],
# "mlir.tablegen_compilation_databases": [
#   "/path/to/your/tablegen_compile_commands.yml"
# ]

echo
dumpinfox "restart  Restart Language Server"
dumpinfo "MLIR: Restart Language Server"

echo
dumpinfox "test mlir server syntax highlighting and code completion"
echo codeopen "${EXT_DIR}/repo/dkg_root/dynamic-kernel-generator/cutlass_ir/compiler/test/Integration/CuteNvGPU/sm100_sm130/gemm_256x128x64_1-ktile_2cta_tnt_f16_f16_f32_f32_stg.mlir"

echo
bash_script_o
