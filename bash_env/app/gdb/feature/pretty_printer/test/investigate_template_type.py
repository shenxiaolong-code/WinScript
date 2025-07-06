# https://forums.codeblocks.org/index.php?topic=22216.0

import gdb
import inspect


def real_to_string(self):
    # print self.val
    return '"' + self.val['list']['items'].string() + '"'


def real_lookup_type(val):
    # print(val.type)
    print(inspect.getmembers(val.type))
    # print 'fsjodifsiohfiosehfoshifhioehsfihseiofhs'
    if str(val.type) == 'Buf':
        # print '!!!!!!!!!!!!!!!!!!!!!!!'
        return BufPrinter(val)
    # else:
    #     print '=======================>'
    #     print val.type
    #     print '<======================='
    return None

class BufPrinter:
    def __init__(self, val):
        self.val = val

    def to_string(self):
        return real_to_string(self)

def lookup_type (val):
    return real_lookup_type(val)

gdb.pretty_printers.append(lookup_type)