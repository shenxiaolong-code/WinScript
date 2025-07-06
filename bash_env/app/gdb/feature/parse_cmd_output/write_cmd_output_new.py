import os
import shutil
import datetime
import argparse
import gdb
import inspect

def convert_path(original_path):
    current_date = datetime.datetime.now().strftime("%Y%m%d_%H%M%S")
    directory, filename = os.path.split(original_path)
    new_outfile = os.path.join(directory, f"{filename}_{current_date}")
    return new_outfile

app_group_map = {
    "cask6": ["cask_tester", "cask_forge", "cask_test_unit_dynamic_shader"],
    "cutlass": ["unittest", "cutlass_test_unit_conv_device_simt_sm100"],
    # Add more mappings as needed
}

def get_app_name():
    app_path = gdb.selected_inferior().progspace.filename
    app_name = app_path.split('/')[-1]
    return app_name

def generate_outfile_path(command_name, app_name, app_group_map, base_directory, outfile=None):
    if outfile:
        if os.path.isdir(outfile):
            return os.path.join(outfile, f"{command_name}_{app_name}.txt")
        else:
            return outfile
    else:
        suffix = next((key for key, value in app_group_map.items() if app_name in value), 'unknown')
        return os.path.join(base_directory, f"{command_name}_{suffix}.txt")

def get_outfile_path(nm):
    parser = argparse.ArgumentParser()
    parser.add_argument('command', nargs='+')
    parser.add_argument('-o', "--outfile", help="output file")

    nm = parser.parse_args(nm.split())

    outfile = nm.outfile if nm.outfile and os.path.exists(nm.outfile) else generate_outfile_path(nm.command[-1], get_app_name(), app_group_map, '${EXT_DIR}/tmp')

    return outfile

def move_backup_existing_file(outfile):
    directory, filename = os.path.split(outfile)
    
    backup_directory = os.path.join(directory, "old")
    
    if not os.path.exists(backup_directory):
        os.makedirs(backup_directory)

    new_outfile = convert_path(outfile)
    
    shutil.move(outfile, new_outfile)

class RedirOutput(gdb.Command):
    def __init__(self):
        super().__init__("rdr", gdb.COMMAND_USER, gdb.COMPLETE_COMMAND)

    def invoke(self, argstr, from_tty):
        print(f'\033[92m[debug] \033[91m{inspect.stack()[0][1]}:{inspect.stack()[0][2]}\033[0m')

        outfile = get_outfile_path(argstr)
        move_backup_existing_file(outfile)

        with open(outfile, "w") as output_file:
            try:
                output_file.write(gdb.execute(' '.join(argstr.split()), to_string=True))
            except Exception as e:
                print(str(e))

        if not os.path.exists(outfile):
            print("Failed to write file, please check the code logic.")

        print(os.path.abspath(outfile))

RedirOutput()
