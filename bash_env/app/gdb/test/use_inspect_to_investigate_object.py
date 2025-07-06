

# python ${BASH_DIR}/app/gdb/test/use_inspect_to_investigate_object.py

import inspect

def list_members(obj):
    members = inspect.getmembers(obj)
    for member in members:
        print(member)

# 示例对象
class MyClass:
    def __init__(self):
        self.name = "John"
        self.age = 30

my_object = MyClass()

# 列出示例对象的所有成员
list_members(my_object)