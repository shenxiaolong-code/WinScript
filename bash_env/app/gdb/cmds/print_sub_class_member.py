
import sys
import gdb
import inspect
print(f'+++++++++ loading \033[92m{inspect.stack()[0][1]}:{inspect.stack()[0][2]}\033[0m')

class ShowSubClassMemberValueCommand(gdb.Command):
    def __init__(self):
        super(ShowSubClassMemberValueCommand, self).__init__("psm", gdb.COMMAND_USER)

    def invoke(self, arg, from_tty):
        if '->' in arg:
            variable_name, member_name = arg.split('->')
        elif '.' in arg:
            variable_name, member_name = arg.split('.')
        else:
            args = gdb.string_to_argv(arg)
            if len(args) != 2:
                print("Usage: psm <variable_name> <member_name>")
                return
            variable_name = args[0]
            member_name = args[1]

        try:
            var = gdb.parse_and_eval(variable_name)
            derived_var = var.cast(var.dynamic_type)
            member_value = derived_var[member_name]
            print(f'\033[92m{inspect.stack()[0][1]}:{inspect.stack()[0][2]}\033[0m')
            print(f"p {arg} :\n{member_value}")
            
        except Exception as e:
            print(f"Error: {e}")

ShowSubClassMemberValueCommand()



print(f'--------- leaving \033[92m{inspect.stack()[0][1]}:{inspect.stack()[0][2]}\033[0m')