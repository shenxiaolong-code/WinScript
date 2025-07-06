from subprocess import Popen, PIPE
from re import search
import sys
import gdb

import inspect
print(f'+++++++++ loading \033[92m{inspect.stack()[0][1]}:{inspect.stack()[0][2]}\033[0m')

# https://stackoverflow.com/questions/28295075/determine-compiler-name-version-from-gdb
# grab the executable filename from gdb
# this is probably not general enough --
# there might be several objfiles around

class ShowCompilerVersion(gdb.Command):
    def __init__(self):        
        super().__init__("cver", gdb.COMMAND_USER, gdb.COMPLETE_COMMAND)
        print(f'\033[92mcmd \033[91m cver \033[92m is registered \033[0m')

    def invoke(self, argstr, from_tty):
        objfilename = gdb.objfiles()[0].filename
        print( "file path : " +  str(objfilename))
        print(f'+++++++++ loading \033[92m{inspect.stack()[0][1]}:{inspect.stack()[0][2]}\033[0m')

        # run readelf
        process = Popen(['readelf', '-p', '.comment', objfilename], stdout=PIPE)
        output = process.communicate()[0].decode("utf-8")
        print( "compiler dump : " +  output)

        # below code can't work normally , comments out by if 0:
        # match the version number with a 
        regex = 'GCC: \(GNU\) ([\d.]+)'
        match=search(regex, output)
        if match:
          compiler_version=match.group(1)
          gdb.execute('set $compiler_version="'+str(compiler_version)+'"')
          print("compiler version : " + str(compiler_version))
          print("gdb variable $compiler_version is set, show the value : p $compiler_version")
        gdb.execute('init-if-undefined $compiler_version="None"')

ShowCompilerVersion()

# do what you want with the python compiler_version variable and/or
# with the $compiler_version convenience variable
# I use it to load version-specific pretty-printers

print(f'--------- leaving \033[92m{inspect.stack()[0][1]}:{inspect.stack()[0][2]}\033[0m')
