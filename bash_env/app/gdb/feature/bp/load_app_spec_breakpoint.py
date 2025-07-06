import gdb
import sys
import inspect
print(f'+++++++++ loading \033[92m{inspect.stack()[0][1]}:{inspect.stack()[0][2]}\033[0m')
app_script_map = {
    "cask_tester"   : "${EXT_DIR}/myDepency/gdb_nvidia/breakpoint/bp_cask_tester.gdb",
    "cask_forge"    : "${EXT_DIR}/myDepency/gdb_nvidia/breakpoint/bp_forge.gdb",
    "cask_test_unit_dynamic_shader"    : "${EXT_DIR}/myDepency/gdb_nvidia/breakpoint/TestConvDynamicShader.gdb",
    "cutlass_test_unit_conv_device_simt_sm100"    : "${EXT_DIR}/myDepency/gdb_nvidia/breakpoint/cutlass_test_unit_conv_device_simt_sm100.gdb",
#   "default"       : "${EXT_DIR}/myDepency/gdb_nvidia/breakpoint/bp_cutlass.gdb",
    "unittest"      : "${BASH_DIR}/app/gdb/feature/bp/bp_google_unittest.gdb",
    "default"       : "${EXT_DIR}/myDepency/gdb_nvidia/breakpoint/bp_except_launch.gdb"
}

#####################################################################################################################

class LoadAppBreakpoint(gdb.Command):
    def __init__(self):
        super(LoadAppBreakpoint, self).__init__("load_app_breakpoint", gdb.COMMAND_USER)

    def invoke(self, arg, from_tty):
        load_app_specific_script()

class ShowScriptPath(gdb.Command):
    def __init__(self):
        super(ShowScriptPath, self).__init__("show_script_path", gdb.COMMAND_USER)

    def invoke(self, arg, from_tty):
        args = gdb.string_to_argv(arg)
        prefix = args[0] if len(args) > 0 else ''
        suffix = args[1] if len(args) > 1 else ''
        show_script_path(prefix, suffix)

# 在 GDB 中注册这个命令
ShowScriptPath()
LoadAppBreakpoint()

def get_app_name():
    app_path = gdb.selected_inferior().progspace.filename
    app_name = app_path.split('/')[-1]
    return app_name

def get_app_script_file(app_name):
    return app_script_map.get(app_name, app_script_map["default"])

def show_script_path(prefix='', suffix=''):
    print(f'{prefix}\033[93m{get_app_script_file(get_app_name())}\033[0m{suffix}')

def load_app_specific_script():
    app_name = get_app_name()
    script_file = get_app_script_file(app_name)

    if script_file is not None:
        print(f'\033[90m{inspect.stack()[0][1]}:{inspect.stack()[0][2]}\033[0m')
        print(f'loading\033[95m {script_file} \033[0m...\r\n')
        gdb.execute("source " + script_file)
    else:
        print(f'\033[92m{inspect.stack()[0][1]}:{inspect.stack()[0][2]}\033[0m  {app_name} : {script_file}')
        print("No specific GDB script for this app.")


print(f'--------- leaving \033[92m{inspect.stack()[0][1]}:{inspect.stack()[0][2]}\033[0m')