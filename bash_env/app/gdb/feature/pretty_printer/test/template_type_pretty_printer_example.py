
# https://stackoverflow.com/questions/67200091/registering-a-gdb-pretty-printer-for-a-specialization-of-stdunordered-map
# https://rev.ng/gitlab/or1k/gcc/-/commit/510f22a93fea5dff7077a55c1401b63315e3568c


# https://rethinkdb.com/blog/make-debugging-easier-with-custom-pretty-printers

import re
import gdb
 
def lookup_function (val):
    "Look-up and return a pretty-printer that can print val."
    # Get the type.
    type = val.type
 
    # If it points to a reference, get the reference.
    if type.code == gdb.TYPE_CODE_REF:
        type = type.target ()
 
    # Get the unqualified type, stripped of typedefs.
    type = type.unqualified ().strip_typedefs ()
 
    # Get the type name.    
    typename = type.tag
 
    if typename == None:
        return None
 
    # Iterate over local dictionary of types to determine
    # if a printer is registered for that type.  Return an
    # instantiation of the printer if found.
    for function in sorted(pretty_printers_dict):
       if function.match (typename):
           return pretty_printers_dict[function] (val)
 
    # Cannot find a pretty printer.  Return None.
    return None
 

# /usr/share/gcc/python/libstdcxx/v6/printers.py

class shared_ptr_template:
    def __init__(self, val):
        self.val = val
 
    def to_string(self):        
        return str(self.val['_M_ptr'])
 
    def display_hint(self):
        return 'std::shared_ptr'
        

# register the pretty-printer
pretty_printers_dict = {}
pretty_printers_dict[re.compile ('^std::shared_ptr<.*>$')] = shared_ptr_template

gdb.pretty_printers.append(lookup_function)

