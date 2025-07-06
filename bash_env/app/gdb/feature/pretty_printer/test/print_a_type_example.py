

# this script comes from MS AI copilot

class PrettyPrinterDict(gdb.printing.PrettyPrinter):
    def __init__(self):
        super(PrettyPrinterDict, self).__init__("my_pretty_printer")

    def __call__(self, val):
        if str(val.type) == "std::map":
            return self.MapIterator(val)
        return None

    class MapIterator(object):
        def __init__(self, val):
            self.val = val
            self.count = 0

        def to_string(self):
            return "Python Dictionary"

        def children(self):
            for field in self.val.type.fields():
                yield 'key', field.key()
                yield 'value', field.value()
                self.count += 1

        def display_hint(self):
            return 'map'

gdb.printing.register_pretty_printer(gdb.current_objfile(), PrettyPrinterDict(), replace=True)

