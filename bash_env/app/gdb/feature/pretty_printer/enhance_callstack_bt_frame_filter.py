# Utilities for scrubbing/filtering stack traces
# Copyright (c) 2018 Jeff Trull

# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:

# The above copyright notice and this permission notice shall be included in all
# copies or substantial portions of the Software.

# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
# SOFTWARE.

# copy from with improvement :
# https://github.com/jefftrull/gdb_python_api 
# ${EXT_DIR}/myDepency/gdb_pretty_printer/gdb_python_api/gdb_util/backtrace.py

import gdb
import re
import sys
# Python 2/3 way to get "imap", suggested by SO
try:
    from itertools import imap
except ImportError:
    # Python3
    imap = map

import os
import subprocess

# import  {py_xxx}, e.g. {py_green}, {py_end}
from print_python_color             import *
# import  addPath2Env
from customized_common_function     import *

import inspect
from print_python_color             import *

print(f'+++++++++ loading {py_green}{inspect.stack()[0][1]}:{inspect.stack()[0][2]}{py_end}')

# add cuda path to env
addPath2Env('/home/scratch.dllibs_jenkins_tmp/cask-cicd-cloud/cuda/gpgpu_internal/34380583')

# print(get_trimmed_line('${EXT_DIR}/repo/kernel_store/debug_cutlass_worktree/cutlass/test/unit/conv/device/conv3d_testbed.h',254))
def get_trimmed_line(filepath, line_number):
    # Check if the filepath is empty
    # print(f'{py_red}debug src parameters: {filepath}, {line_number}{py_end}')
    if not filepath:
        return ""

    # Check if the file exists
    if not os.path.exists(filepath):
        return ""

    # Check if line_number is None
    if line_number is None:
        return ""
    
    with open(filepath, 'r') as file:
        lines = file.readlines()

        # Check if the line number is within the valid range
        if line_number and 1 <= line_number <= len(lines):
            # Subtract 1 because list indices start from 0
            line = lines[line_number - 1]
            return f'[ {py_green}{line.strip()}{py_end} ]   '

    # Return an empty string if the parameters are invalid
    # print(f'{py_red}Invalid parameters: {filepath}, {line_number}{py_end}')
    return ""

# print(get_location_line('${EXT_DIR}/repo/kernel_store/debug_cutlass_worktree/cutlass/test/unit/conv/device/conv3d_testbed.h:254'))
def get_location_line(location):
    # Check if location is a string
    if not isinstance(location, str):
        return ""

    # Check if location contains a colon
    if ':' not in location:
        return ""

    # Split the location into filename and line number
    filename, line = location.rsplit(':', 1)

    # Check if filename is a valid file path
    if not os.path.isfile(filename):
        return ""

    # Check if line is a valid integer
    if not line.isdigit():
        return ""

    line = int(line)

    # Call get_trimmed_line function
    return get_trimmed_line(filename, line)

def highlight_only_func_name(function_name, filename, line):
    # check if there are any special characters in the function name
    if re.search(r'[<>,]', function_name) or re.search(r'\(.*::.*\)', function_name):
        return f'{get_trimmed_line(filename,line)}' + function_name

    # split the function name into parts
    parts = function_name.split('::')

    # highlight the last part
    parts[-1] = f'{py_red}' + parts[-1] + f'{py_end}'

    # return the joined parts
    return f'{get_trimmed_line(filename,line)}' + '::'.join(parts)

def highlight_special_function_full_symbol(name, filename, line):
    prefix_regexes = gdb.parameter('backtrace-strip-regexes')
    entry_pattern = r'(?!.*\@plt)(main|xxxx|.*::TestBody|.*::launch)'
    if bool(prefix_regexes) and re.match(prefix_regexes, name):
        # library functions , we don't want to see them
        return f'  {py_black}std_lib_function{py_end}'   
    elif re.match(entry_pattern, name):
        # expected special functions
        # print(f'{py_green}{inspect.stack()[0][1]}:{inspect.stack()[0][2]}{py_end}')
        result = f'{py_brown}{name}   {py_black}{inspect.stack()[0][1]}:{inspect.stack()[0][2]} {py_end}'
        return highlight_only_func_name(result, filename, line)
    else:
        # general functions
        return highlight_only_func_name(name, filename, line)

def convert_function_frame(name, filename, line):
    if re.match(r'^(_ZN7|_ZN4|_ZNK5|__device_stub__ZN)', name):
        # cuda device function
        print(f'{get_trimmed_line(filename,line)}{py_blue}' + filename + f':' + str(line) + f'      {py_black}# {inspect.stack()[0][1]}:{inspect.stack()[0][2]}{py_end}')
        result = subprocess.check_output(['cu++filt', '-p', name]).decode('utf-8').strip()
        return result
    else:
        # general function
        return highlight_special_function_full_symbol(name, filename, line)

# ************************************************************************************************************

# define a stack frame decorator to make them less verbose
class CustomizedFunctionNameConverter(gdb.FrameDecorator.FrameDecorator):
    def __init__(self, fobj):
        super(CustomizedFunctionNameConverter, self).__init__(fobj)

    # convert the function name to a more readable form
    def function(self):
        frame = self.inferior_frame()
        if 0 == frame.level():
            print(f'{py_black}{inspect.stack()[0][1]}:{inspect.stack()[0][2]}{py_end}')
        function_name = frame.name()
        if isinstance(function_name, str):
            # if hasattr(function_name, 'startswith'):
            if function_name.startswith("<lambda"):
                # this starts with an angle bracket but won't have any template parameters
                return function_name
        filename = super(CustomizedFunctionNameConverter, self).filename()
        line = super(CustomizedFunctionNameConverter, self).line()        
        if function_name is not None:
            function_name = convert_function_frame(function_name , filename, line)
        return function_name
    
    # highlight the filename
    # def filename(self):
    #     filename = super(CustomizedFunctionNameConverter, self).filename()
    #     return filename
    #     return f'{py_blue}' + filename + f'{py_end}  '    
    #     line = super(CustomizedFunctionNameConverter, self).line()
    #     return f'{py_blue}' + filename + str(line) + f'{py_end}  '    


# define a stack frame filter
class NvidiaStackFrameFilter:
    """Filter library functions out of stack trace"""

    def __init__(self):
        # set required attributes
        self.name = 'NvidiaStackFrameFilter'
        self.enabled = True
        self.priority = 0

        # register with current program space
        # (manual suggests avoiding global filter list; this seems appropriate)
        gdb.current_progspace().frame_filters[self.name] = self
        print(f'{py_blue}Register {py_brown} removeNvidiaStackFrameFilter {py_blue} is done        {py_black}# {inspect.stack()[0][1]}:{inspect.stack()[0][2]}{py_end}')

    def filter(self, frame_iter):
        return imap(CustomizedFunctionNameConverter, frame_iter)        


def removeNvidiaStackFrameFilter():
    progspace = gdb.current_progspace()
    if 'NvidiaStackFrameFilter' in progspace.frame_filters:
        print(f'{py_blue}remove {py_brown} removeNvidiaStackFrameFilter {py_blue} is done        {py_black}# {inspect.stack()[0][1]}:{inspect.stack()[0][2]}{py_end}')
        del progspace.frame_filters['NvidiaStackFrameFilter']
    else:
        print(f'{py_red}NvidiaStackFrameFilter is not in the frame_filters       {py_black}# {inspect.stack()[0][1]}:{inspect.stack()[0][2]}{py_end}')

def toggleNvidiaStackFrameFilter():
    progspace = gdb.current_progspace()
    if 'NvidiaStackFrameFilter' in progspace.frame_filters:
        removeNvidiaStackFrameFilter()
    else:
        NvidiaStackFrameFilter()

# NvidiaStackFrameFilter()
# removeNvidiaStackFrameFilter()
toggleNvidiaStackFrameFilter()

print(f'--------- leaving {py_green}{inspect.stack()[0][1]}:{inspect.stack()[0][2]}{py_end}')

