# bash_script_i
# echo

return
# it is replace by  convert_name : 
# ${EXT_DIR}/myDepency/gdb_pretty_printer/gdb_python_api/gdb_util/backtrace.py:34
: '
def convert_name(name):
    if re.match(r'^(_ZN7|_ZN4|__device_stub__ZN)', name):
        print(f'\033[92m{inspect.stack()[0][1]}:{inspect.stack()[0][2]}\033[0m')
        result = subprocess.check_output(['cu++filt', '-p', name]).decode('utf-8').strip()
        return result
    else:
        return name
'

# cu++filt               # ${CUDA_PATH}/bin/cu++filt
debug_log=${TEMP_DIR}/to_del/temp_$RANDOM.log
echo "" >| ${debug_log}

tmp_input_file=$1
if [[ ! -f "${tmp_input_file}" ]] ; then
    tmp_dir=${tmp_input_file%/*}
    tmp_name=${tmp_input_file##*/}
    tmp_input_file=${tmp_dir}/$(date "+%Y%m%d")/${tmp_name}
fi

echo "update file : ${tmp_input_file}"
if [[ -f "${tmp_input_file}" ]] ; then
    # translate device function symbol into C++ function
    awk '{for(i=1;i<=NF;i++)if($i~/^(_ZN7|_ZN4|__device_stub__ZN)/){print $i}}' $tmp_input_file | while read line
    do
        result=$(cu++filt -p "$line")
        sed -i "s/$line/$result/g" $tmp_input_file
        (
            echo "$line"
            echo "$result"
            echo ""
        ) >>  ${debug_log}
    done

    # #21 0x00000000004ec065 in main => #21 main
    sed -i -- 's/ 0x.* in / /g'   "${tmp_input_file}"    
    sed -i -- 's#at /home/#\n    // /home/#g'   "${tmp_input_file}"

    (
        echo
        echo
        echo "# generate time : $(date "+%Y%m%d_%H%M")"
        echo "# updated by    : ${BASH_SOURCE[0]}:$LINENO"
        echo "# cu++filt path : $(which cu++filt)"
        echo "# debug log     : ${debug_log}"
    ) >> ${tmp_input_file}
fi

# echo
# bash_script_o

# ********************
# ${BASH_DIR}/app/gdb/feature/bp/test_c++filt.sh
# cu++filt -p _ZN7cutlass4conv6device20ConvUniversalAdapterIN5cask678_GLOBAL__N__529891d8_45_cutlass3x_fprop_ws_nq_2d_sm100_host_shader_cu_81dcb742152cutlass3x_sm100_tensorop_s64x128x16_conv3d_fprop_weight_stationary_nq_2d_tiled_f16_f16_f32_f16_f16_t1xr3xs3_64x128x64_1x1x1_ndhwc_ndhwc_ndhwc_align8_1smEE3runERNS0_6kernel13ConvUniversalINS0_10collective14CollectiveConvINS0_60MainloopSm100TmaWeightStationaryUmmaWarpSpecializedNq2dTiledILNS0_8OperatorE0ELi19ELi3ELi3EN4cute5tupleIJNSD_1CILi1EEESG_SG_EEENS0_49KernelNq2dTiledTmaWarpSpecializedStride1x1x1Sm100INSE_IJSG_NSF_ILi3EEESJ_EEEEEEENSE_IJNSF_ILi64EEENSF_ILi128EEENSE_IJSN_EEEEEENS_6half_tESR_NSD_8TiledMMAINSD_8MMA_AtomIJNSD_31SM100_HMMA_SS_WEIGHT_STATIONARYISR_SR_fLi64ELi128ELNSD_4UMMA5MajorE0ELSW_0ELNSV_7ScaleInE0ELSX_0ELNSV_8MaxShiftE1EEEEEENSD_6LayoutISH_NSE_IJNSF_ILi0EEES12_S12_EEEEENSE_IJNSD_10UnderscoreES15_S15_EEEEENS9_6detail27Sm100ImplicitGemmTileTraitsINSD_13SM90_TMA_LOADENSD_14ComposedLayoutINSD_7SwizzleILi3ELi4ELi3EEENSD_18smem_ptr_flag_bitsILi16EEENS11_INSE_IJNSE_IJSN_NSF_ILi16EEEEEESG_NSF_ILi4EEENSF_ILi19EEEEEENSE_IJNSE_IJSN_SG_EEES12_S1G_NSF_ILi4096EEEEEEEEEEEENS18_34Sm100NqTwodTiledWithHaloTileTraitsINSD_16SM100_TMA_LOAD_WENS1B_IS1D_S1F_NS11_INSE_IJNSE_IJNSF_ILi136EEES1G_EEESG_S1I_SJ_EEENSE_IJS1L_S12_S1G_NSF_ILi8704EEEEEEEEEENS1B_IS1D_S1F_KNS11_INSE_IJNSE_IJSO_S1G_EEESG_S1I_SJ_EEES1X_EEEENS1B_IS1D_S1F_NS11_IS21_NSE_IJS1L_S12_S1G_NSF_ILi8192EEEEEEEEEEEEEENS_8epilogue10collective18CollectiveEpilogueINS2B_29Sm100Nq2dTiledWarpSpecializedEJNSE_IJNS11_ISN_SG_EENS11_INSE_IJNSF_ILi32EEENSF_ILi2EEEEEENSE_IJSG_SN_EEEEEEEESR_NSE_IJNSE_IJllllEEESG_S12_EEESR_S2N_ffNS1B_IS1D_S1F_NS11_INSE_IJSN_NSF_ILi8EEEEEES2J_EEEES2R_jNS2B_6fusion17LinearCombinationISR_fSR_fLNS_15FloatRoundStyleE2EEENSD_21SM100_LDTM_16dp256b4xENSD_21SM100_STTM_32dp32b16xENSD_17SM90_U16x8_STSM_TENSD_9Copy_AtomIJNSD_25SM80_CP_ASYNC_CACHEALWAYSINS_9uint128_tES31_EESR_EEENSD_17SM75_U16x8_LDSM_TEEEEvvE6ParamsEP11CUstream_stPNS_15CudaHostAdapterE
# => 
# cutlass::conv::device::ConvUniversalAdapter<cask6::<unnamed>::cutlass3x_sm100_tensorop_s64x128x16_conv3d_fprop_weight_stationary_nq_2d_tiled_f16_f16_f32_f16_f16_t1xr3xs3_64x128x64_1x1x1_ndhwc_ndhwc_ndhwc_align8_1sm>::run

# c++filt _ZNK5cask636GemmBiasActivationAuxShaderCutlass3xIN7cutlass4gemm6device20GemmUniversalAdapterINS_62_GLOBAL__N__29449fe5_29_cutlass3x_gemm_host_shader_cu_78d939f292cutlass3x_sm100_tensorop_s64x128x16gemm_f16_f16_f32_f16_f16_64x128x64_1x1x1_0_nnn_align8_1smEvEEE25queryDeviceWorkspaceSize_ERKNS_12LaunchToken3ERKNS_16ExecutionContextENS_13ConstByteSpanE
# =>
# cask6::GemmBiasActivationAuxShaderCutlass3x<cutlass::gemm::device::GemmUniversalAdapter<cask6::(anonymous namespace)::cutlass3x_sm100_tensorop_s64x128x16gemm_f16_f16_f32_f16_f16_64x128x64_1x1x1_0_nnn_align8_1sm, void> >::queryDeviceWorkspaceSize_(cask6::LaunchToken3 const&, cask6::ExecutionContext const&, cask6::ConstByteSpan) const