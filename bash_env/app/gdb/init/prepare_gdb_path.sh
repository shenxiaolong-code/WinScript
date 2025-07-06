echo
echo "+++++++++ loading ${BASH_DIR}/app/gdb/init/prepare_gdb_path.sh ..."

echo "install python module : ${BASH_DIR}/app/gdb/requirements.txt "
pip install -r  ${BASH_DIR}/app/gdb/requirements.txt

echo
if [[ ! -d "${EXT_DIR}/tmp/cache/gdb_tmp" ]] ; then 
    mkdir -p "${EXT_DIR}/tmp/cache/gdb_tmp"
fi
echo "gdb temporary path : ${EXT_DIR}/tmp/cache/gdb_tmp"


# https://docs.nvidia.com/cuda/cuda-gdb/index.html
# Temporary Directory
# warning : if only TMPDIR is set without CUDBG_APICLIENT_PID, it will cause cuda gdb internal error 
# export  TMPDIR="${TEMP_DIR}"                                      # used by cuda gdb
# export  CUDBG_APICLIENT_PID=


echo "--------- leaving ${BASH_DIR}/app/gdb/init/prepare_gdb_path.sh ..."
