
import gdb
import re
import subprocess
import inspect

# source ${BASH_DIR}/app/gdb/feature/bp/test_c++filt.sh

print(f'+++++++++ loading \033[92m{inspect.stack()[0][1]}:{inspect.stack()[0][2]}\033[0m')

pattern = "_ZN.*"

def dumpObj(obj):
    print(f'\033[92m{inspect.stack()[0][1]}:{inspect.stack()[0][2]}\033[0m')
    members = inspect.getmembers(obj) 
    for member in members:
        print(member)

def dumpFrame(frame):
    print(f'\033[92m{inspect.stack()[0][1]}:{inspect.stack()[0][2]}\033[0m')
    if hasattr(frame, 'name'):
        print(f'{frame.name()}  {frame.level()}')    

def dumpFrameArgs(frame):
    print(f'\033[92m{inspect.stack()[0][1]}:{inspect.stack()[0][2]}\033[0m')
    block = frame.block()
    # block_name = block.function.name
    print(f'No. {frame.level()} frame :')
    for symbol in block:
        if symbol.is_argument:
            arg_name = symbol.print_name
            arg_type = symbol.type
            arg_value = frame.read_var(arg_name)
            print(f"{arg_name} = {str(arg_value)}")              

class ShowSelectedFrameInfo(gdb.Command):
    def __init__(self):
        super(ShowSelectedFrameInfo, self).__init__("fii", gdb.COMMAND_STACK, gdb.COMPLETE_NONE)
        print('\033[92mcmd \033[91m fii \033[92m is registered \033[0m')

    def invoke(self, arg, from_tty):
        print(f'\033[92m{inspect.stack()[0][1]}:{inspect.stack()[0][2]}\033[0m')
        dumpFrameArgs(gdb.selected_frame())

class FilteredBacktraceCommand(gdb.Command):
    def __init__(self):
        super(FilteredBacktraceCommand, self).__init__("btf", gdb.COMMAND_STACK, gdb.COMPLETE_NONE)
        print(f'\033[92mcmd \033[91m btf \033[92m is registered \033[0m')

    def invoke(self, arg, from_tty):
        print(f'\033[92m{inspect.stack()[0][1]}:{inspect.stack()[0][2]}\033[0m')
        frame = gdb.newest_frame()
        frameNo=0
        while frame is not None:
            func_name = frame.name()
            sal = frame.find_sal()
            if re.match(pattern, func_name):
                func_name = '[device function long name]'
                print(f"#{frameNo:<2} {func_name:<64} at {sal.symtab.fullname()}:{sal.line}")
            else:
                # gdb.execute('frame %d' % frame.level)
                if hasattr(sal.symtab, 'fullname'):
                    print(f"#{frameNo:<2} {func_name:<64} at {sal.symtab.fullname()}:{sal.line}")
                else:
                    gdb.execute('frame %d' % frameNo)
                # gdb.execute('frame %d' % frameNo)
                # print(frame.level)
                # print(f"#{frameNo} {func_name} at {sal.symtab.fullname()}:{sal.line}")
                # dumpObj(sal.symtab)                
            frameNo +=1
            frame = frame.older()
        # dumpFrame(gdb.newest_frame().older())
        # dumpFrameArgs(gdb.newest_frame().older())
        # dumpObj(gdb.newest_frame().older()) 
        # dumpFuncInfo(gdb.newest_frame().older())           

FilteredBacktraceCommand()
ShowSelectedFrameInfo()

print(f'--------- leaving \033[92m{inspect.stack()[0][1]}:{inspect.stack()[0][2]}\033[0m')


# https://nvidia.slack.com/archives/C03JL87UNSC/p1703713919552849?thread_ts=1703712592.162619&cid=C03JL87UNSC
# $ c++filt _ZNK5cask636GemmBiasActivationAuxShaderCutlass3xIN7cutlass4gemm6device20GemmUniversalAdapterINS_62_GLOBAL__N__29449fe5_29_cutlass3x_gemm_host_shader_cu_78d939f292cutlass3x_sm100_tensorop_s64x128x16gemm_f16_f16_f32_f16_f16_64x128x64_1x1x1_0_nnn_align8_1smEvEEE25queryDeviceWorkspaceSize_ERKNS_12LaunchToken3ERKNS_16ExecutionContextENS_13ConstByteSpanE
# cask6::GemmBiasActivationAuxShaderCutlass3x<cutlass::gemm::device::GemmUniversalAdapter<cask6::(anonymous namespace)::cutlass3x_sm100_tensorop_s64x128x16gemm_f16_f16_f32_f16_f16_64x128x64_1x1x1_0_nnn_align8_1sm, void> >::queryDeviceWorkspaceSize_(cask6::LaunchToken3 const&, cask6::ExecutionContext const&, cask6::ConstByteSpan) const

