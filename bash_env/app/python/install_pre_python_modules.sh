#!/bin/bash

bash_script_i
echo

echo pip install -r ${BASH_SOURCE[0]%/*}/requirements.txt

# ${EXT_DIR}/repo/dkg_root/mlir-lsp-server/clang/utils/analyzer/requirements.txt
# ${EXT_DIR}/repo/dkg_root/mlir-lsp-server/flang/examples/FlangOmpReport/requirements.txt
# ${EXT_DIR}/repo/dkg_root/mlir-lsp-server/lldb/test/requirements.txt
# ${EXT_DIR}/repo/dkg_root/mlir-lsp-server/llvm/docs/requirements.txt
# ${EXT_DIR}/repo/dkg_root/mlir-lsp-server/llvm/utils/git/requirements.txt
# ${EXT_DIR}/repo/dkg_root/mlir-lsp-server/llvm/utils/git/requirements.txt.in
# ${EXT_DIR}/repo/dkg_root/mlir-lsp-server/mlir/python/requirements.txt
# ${EXT_DIR}/repo/dkg_root/mlir-lsp-server/mlir/utils/mbr/requirements.txt
# ${EXT_DIR}/repo/dkg_root/mlir-lsp-server/third-party/benchmark/tools/requirements.txt

echo
bash_script_o
