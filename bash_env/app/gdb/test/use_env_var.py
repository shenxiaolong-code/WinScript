# https://stackoverflow.com/questions/9814185/how-to-access-environment-variables-inside-gdbinit-and-inside-gdb-itself

print("+++++++++ loading ${BASH_DIR}/app/gdb/test/use_env_var.py ...\r\n")

import os

# use below cmd to check whether environment var is defined
# show env
# need the environment var ' CMAKE_PATH ' is set
gdb.execute('directory' + os.environ['CMAKE_PATH'] + '/bin')

# run below cmd to check the result :
# show directories

print("--------- leaving ${BASH_DIR}/app/gdb/test/use_env_var.py ...\r\n\r\n")