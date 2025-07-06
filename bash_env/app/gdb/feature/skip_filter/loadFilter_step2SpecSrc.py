# https://stackoverflow.com/questions/5676241/tell-gdb-to-skip-standard-files

import os.path

print("+++++++++ loading ${BASH_DIR}/app/gdb/feature/skip_filter/loadFilter_step2SpecSrc.py ...")

class StepSource(gdb.Command):
    def __init__(self):
        super().__init__(
            'ss',
            gdb.COMMAND_BREAKPOINTS,
            gdb.COMPLETE_NONE,
            False
        )
    def invoke(self, argument, from_tty):
        argv = gdb.string_to_argv(argument)
        if argv:
            if len(argv) > 1:
                gdb.write('Usage:\nns [source-name]]\n')
                return
            source = argv[0]
            full_path = False if os.path.basename(source) == source else True
        else:
            source = gdb.selected_frame().find_sal().symtab.fullname()
            full_path = True
        print(f'\033[92m{inspect.stack()[0][1]}:{inspect.stack()[0][2]}\033[0m')
        thread = gdb.inferiors()[0].threads()[0]
        while True:
            message = gdb.execute('next', to_string=True)
            if not thread.is_valid():
                break
            try:
                cur_source = gdb.selected_frame().find_sal().symtab.fullname()
                if not full_path:
                    cur_source = os.path.basename(cur_source)
            except:
                break
            else:
                if source == cur_source:
                    break
StepSource()

print("--------- leaving ${BASH_DIR}/app/gdb/feature/skip_filter/loadFilter_step2SpecSrc.py ...")

