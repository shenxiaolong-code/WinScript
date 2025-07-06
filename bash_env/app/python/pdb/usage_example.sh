
# some path variables
set CASK6_REPO="${REPO_DIR_CASK6}"
set CASK6_BUILD="${EXT_DIR}/build/CFK_9823_Port_XMMA_trmm_out_place"

# setup python lib search path , which is used by :  import xxx
set CASK5_DEP_DIR=${CASK6_BUILD}/_deps/xmma-src 
setenv PYTHONPATH  ${BASH_DIR}/app/python/pdb:${CASK5_DEP_DIR}/bladeworks:${CASK5_DEP_DIR}/cask_core:${CASK5_DEP_DIR}/xmma:${CASK6_REPO}/frameworks/xmma/codegen

# start debug
# python -m ipdb -c ${BASH_DIR}/app/python/pdb/python_pdb_init.py   ${REPO_DIR_CASK6}/frameworks/xmma/codegen/gen/can_configure_gen.py update-all --cask-sdk ${CASK5_DEP_DIR}
python -m ipdb -c <spec_init_script>   ${REPO_DIR_CASK6}/frameworks/xmma/codegen/gen/can_configure_gen.py update-all --cask-sdk ${CASK5_DEP_DIR}

