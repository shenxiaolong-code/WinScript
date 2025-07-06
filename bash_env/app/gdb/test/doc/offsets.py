# https://stackoverflow.com/questions/9788679/how-to-get-the-relative-address-of-a-field-in-a-structure-dump-c
# in .gdbinit
# source ${BASH_DIR}/app/gdb/test/offsets.py
# usage example : offsets-of "struct A"

import gdb

class Offsets(gdb.Command):
    def __init__(self):
        super (Offsets, self).__init__ ('offsets-of', gdb.COMMAND_DATA)

    def invoke(self, arg, from_tty):
        argv = gdb.string_to_argv(arg)
        if len(argv) != 1:
            raise gdb.GdbError('offsets-of takes exactly 1 argument.')

        stype = gdb.lookup_type(argv[0])

        print argv[0], '{'
        for field in stype.fields():
            print '    %s => %d' % (field.name, field.bitpos//8)
        print '}'

Offsets()
