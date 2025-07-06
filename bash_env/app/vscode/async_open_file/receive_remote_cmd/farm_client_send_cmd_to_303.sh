
bash_script_i

cmd_file_path=$1
# ${EXT_DIR}/dbg_investigate/repo/cutlass/test/unit/conv/device/conv2d_fprop_implicit_gemm_f32nhwc_f32nhwc_f32nhwc_simt_f32_sm100.cu:83
cmd_file_path_only=${cmd_file_path%%:*}

if [[ -f "${cmd_file_path_only}" ]] ; then
    # curl "http://10.32.208.143:8000/openfile?path=${EXT_DIR}/tmp/cache/bd1.sh"
    echo ssh xiaolongs@computelab-303 "curl -s 'http://computelab-303.nvidia.com:8000/openfile?path=${cmd_file_path}'"
    # curl "http://computelab-303.nvidia.com:8000/openfile?path=${cmd_file_path}"
    ssh xiaolongs@computelab-303 "curl -s 'http://computelab-303.nvidia.com:8000/openfile?path=${cmd_file_path}'"
else
    dumpinfo "file '${cmd_file_path}' not exist."
fi

bash_script_o
