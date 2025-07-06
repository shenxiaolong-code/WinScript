import sys
import inspect
import gdb
import re

print(f'+++++++++ loading \033[92m{inspect.stack()[0][1]}:{inspect.stack()[0][2]}\033[0m')

class StepHandler(gdb.Command):
    """Custom step command that also prints the current file and line number."""

    def __init__(self):
        super(StepHandler, self).__init__("gdb_step_action", gdb.COMMAND_USER)

    def extract_last_path(self, s):
        # Line 901 of "${EXT_DIR}/repo/kernel_store/splitK_perf_options_slices_and_buffer_worktree/cask/include/cask/computations/convolution.hpp" starts at address 0x50f57a <_ZN5cask612computations17Convolution_dgrad9Arguments4viewEv+94 at ${EXT_DIR}/repo/kernel_store/splitK_perf_options_slices_and_buffer_worktree/cask/include/cask/computations/convolution.hpp:901> and ends at 0x50f58d <_ZN5cask612computations17Convolution_dgrad9Arguments4viewEv+113 at ${EXT_DIR}/repo/kernel_store/splitK_perf_options_slices_and_buffer_worktree/cask/include/cask/computations/convolution.hpp:907>.
        pattern = r'(/[^<]*:\d+)>'
        matches = re.findall(pattern, s)
        if matches:
            return matches[-1]
        else:
            return None

    def invoke(self, arg, from_tty):
        # print(f'\033[92m{inspect.stack()[0][1]}:{inspect.stack()[0][2]}\033[0m')
        symbol_info=gdb.execute("info line", to_string=True)
        src_path=self.extract_last_path(symbol_info)
        gdb.execute(f"shell ${BASH_DIR}/app/gdb/feature/hook_step/gdb_step_action.sh '{src_path}'")  

StepHandler()

print(f'--------- leaving \033[92m{inspect.stack()[0][1]}:{inspect.stack()[0][2]}\033[0m')
