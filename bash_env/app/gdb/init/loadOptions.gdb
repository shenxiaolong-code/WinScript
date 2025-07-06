# bash_script_i

set $USECOLOR = 1
set $COLOREDPROMPT = 1

# set radix 0x10
# input decimal , output hex
set input-radix  0xa
set output-radix 0x10

set breakpoint pending on
# you won't need to confirm commands
set confirm off
set follow-fork-mode child

# make GDB display all information at once
set height 0
set width 0

delete user_command finishu

# for symbol name search
# set case-sensitive off

# https://sourceware.org/gdb/onlinedocs/gdb/Caching-Target-Data.html
set stack-cache off
set code-cache off

# automatically display value of expression EXP every time when the program step stops , windbg : .pcmds
set listsize 5

# show source file full path, instead of only file name or relative path.  relative | absolute | basename
# https://visualgdb.com/gdbreference/commands/set_filename-display
set filename-display absolute

# https://stackoverflow.com/questions/28815621/how-to-disable-type-return-to-continue-or-q-return-to-quit-in-gdb
# disable Type <return> to continue, or q <return> to quit
# if the screen is too long, you won't need to press y to scroll it
set pagination off
# above option can't disable the initial "disable Type <return> to continue, or q <return> to quit" , and below is also invalid: 
# gdb -iex 'set pagination off' --args ...
# gdb -batch-silent off' --args ...

# set color gdb prompt char
# set prompt \033[32m>>> \033[0m
set prompt \033[35m[gdb] \033[0m

# bt show the function stack before the main entry.
set backtrace past-main on
set backtrace past-entry on

# disable the error : "Stopped due to shared library event (no libraries added or removed)"
# https://visualgdb.com/gdbreference/commands/set_stop-on-solib-events
set stop-on-solib-events 0

# handle SIGPIPE nostop noprint pass

# https://sourceware.org/gdb/onlinedocs/gdb/Print-Settings.html#Print-Settings
# https://developer.apple.com/library/archive/documentation/DeveloperTools/gdb/gdb/gdb_9.html
# p output the address of variable , for easy to cast , data breakpoint.  check status : show print address
set print address on
# set print address off

set print type typedefs on

# Printing of function arguments at function entry. Valid arguments are no, only, preferred, if-needed, both, compact, default.
set print entry-values compact
# Printing of return value after `finish' is on
# set print finish
# Pretty formatting of structures , instead of one line
set print pretty on
# show print pretty

# Show printing of symbol names when printing pointers.
show print symbol

set print symbol-filename on
# set print max-symbolic-offset 512
set print symbol on
# enable will output too many disassemble code for template code
set  disassemble-next-line off
# show disassemble-next-line
# https://visualgdb.com/gdbreference/commands/expression_evaluating_commands
set print array on
set print array-indexes on

# show full context of string/array, instead of truncted context. non-zero specify the length. 0 means all
alias -a limit = set print elements
# limit 0
# set print elements 32
set print elements 0

set print object on
set print vtbl on
# set print frame-arguments  scalars

set print thread-events on

# bash_script_o
