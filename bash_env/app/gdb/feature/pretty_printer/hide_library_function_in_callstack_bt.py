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
import  os

import inspect
# Python 2/3 way to get "imap", suggested by SO
try:
    from itertools import imap
except ImportError:
    # Python3
    imap = map

import re
import subprocess
from gdb.FrameDecorator import FrameDecorator


from print_python_color             import *    # import  {py_xxx}, e.g. {py_green}, {py_end}
from customized_common_function     import *    # import  addPath2Env

addPath2Env('${BASH_DIR}/app/gdb/feature/pretty_printer')
from enhance_callstack_bt_frame_filter import *

nvidia_filter = NvidiaStackFrameFilter()

print(f'+++++++++ loading {py_green}{inspect.stack()[0][1]}:{inspect.stack()[0][2]}{py_end}')


# ************************************************************************************************************

# define a stack frame filter
class CustomizedStackFrameFilter:
    """Filter library functions out of stack trace"""

    def __init__(self):
        # set required attributes
        self.name = 'CustomizedStackFrameFilter'
        self.enabled = True
        self.priority = 0

        # register with current program space
        # (manual suggests avoiding global filter list; this seems appropriate)
        gdb.current_progspace().frame_filters[self.name] = self
        print(f'{py_blue}Register {py_brown} CustomizedStackFrameFilter {py_blue} is done       {py_black}# {inspect.stack()[0][1]}:{inspect.stack()[0][2]}{py_end}')

    @staticmethod
    def __cond_squash(iterable, squashfn):
        """wrap iterator to compress subsequences for which a predicate is true, keeping only the *last* of each"""
        last = None              # we have to buffer 1 item
        for item in iterable:
            if squashfn(item):
                last = item
            else:
                if last is not None:
                    yield last   # empty buffer this time
                    last = None
                yield item       # resume un-squashed iteration
        if last is not None:
            yield last           # in case we end in "squashed" mode

    @staticmethod
    def __adjacent_squash(iterable, squashfn):
        """wrap iterator to compress subsequences with a binary predicate

        This adapter will drop all but the last of any sequence for which
        squashfn(prev, current) is true
        """

        last = None
        for item in iterable:
            if last is None:
                last = item
            else:
                if squashfn(last, item):
                    # discard previous
                    last = item
                else:
                    yield last
                    last = item
        if last is not None:
            yield last

    @staticmethod
    def __same_cgroup(prog, a, b):
        """return true if a and b match the same capture group of prog"""

        if (a.function() == a.address()) or (b.function() == b.address()):
            # we don't know the function name for at least one of the frames
            return False
        if not prog.match(str(a.function())) or not prog.match(str(b.function())):
            # at least one doesn't match at all
            return False
        a_match = prog.match(a.function())
        b_match = prog.match(b.function())
        if a_match.lastindex is None or b_match.lastindex is None:
            # no capture group matched in one or both
            return False
        # figure out if there are any matching capture groups
        # "groups" will give us a tuple of all the capture groups
        # and None if the particular group did not match
        for a, b in zip(a_match.groups(), b_match.groups()):
            if a is not None and b is not None:
                return True

        return False


    def filter(self, frame_iter):
        # first check for multi-regex option
        squash_regexes = gdb.parameter('backtrace-strip-regexes')
        # If present we compress stack frames with matching capture groups
        if squash_regexes:
            prog = re.compile(squash_regexes)
            # if there are no (or one) capture groups, treat this like squash_regex
            if prog.groups < 2:
                squash_regex = squash_regexes
            else:
                # wrap the current iterator in a squash-matching-subsequences iterator
                # with the predicate "function name matches same regex"
                ufi = CustomizedStackFrameFilter.__adjacent_squash(frame_iter,
                                                   lambda a, b : CustomizedStackFrameFilter.__same_cgroup(prog, a, b))
                # further wrap in a decorator and return
                return imap(CudaFunctionNameConverter, ufi)
        else:
            # single regex is simpler - we compress based on match/nomatch
            squash_regex = gdb.parameter('backtrace-strip-regex')

        if squash_regex:
            ufi = CustomizedStackFrameFilter.__cond_squash(frame_iter,
                                           lambda x : ((x.function() != x.address()) and
                                                       re.match(squash_regex, x.function())))
            return imap(CudaFunctionNameConverter, ufi)
        else:
            # just add the decorator to the original iterator
            return imap(CudaFunctionNameConverter, frame_iter)

def removeCustomizedStackFrameFilter():
    progspace = gdb.current_progspace()
    if 'CustomizedStackFrameFilter' in progspace.frame_filters:
        print(f'{py_blue}remove {py_brown} removeCustomizedStackFrameFilter {py_blue} is done        {py_black}# {inspect.stack()[0][1]}:{inspect.stack()[0][2]}{py_end}')
        del progspace.frame_filters['CustomizedStackFrameFilter']
    else:
        print(f'{py_red}CustomizedStackFrameFilter is not in the frame_filters       {py_black}# {inspect.stack()[0][1]}:{inspect.stack()[0][2]}{py_end}')

def toggleCustomizedStackFrameFilter():
    progspace = gdb.current_progspace()
    if 'CustomizedStackFrameFilter' in progspace.frame_filters:
        removeCustomizedStackFrameFilter()
    else:
        CustomizedStackFrameFilter()


# CustomizedStackFrameFilter()
# removeCustomizedStackFrameFilter()
# toggleCustomizedStackFrameFilter()


print(f'--------- leaving {py_green}{inspect.stack()[0][1]}:{inspect.stack()[0][2]}{py_end}')

