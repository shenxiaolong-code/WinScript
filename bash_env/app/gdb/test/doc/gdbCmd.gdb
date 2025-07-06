List of gdb commands grouped by categories (classes of commands).

List of classes of commands:

running -- Running the program
stack -- Examining the stack
data -- Examining data
breakpoints -- Making program stop at certain points
files -- Specifying and examining files
status -- Status inquiries
support -- Support facilities
user-defined -- User-defined commands
aliases -- Aliases of other commands
obscure -- Obscure features
internals -- Maintenance commands


Running the program.
List of commands:

show follow-fork-mode -- Show debugger response to a program call of fork or vfork
show args -- Show arguments to give program being debugged when it is started
info handle -- What debugger does when program gets various signals
kill -- Kill execution of program being debugged
target -- Connect to a target machine or process
handle -- Specify how to handle a signal
run -- Start debugged program
continue -- Continue program being debugged
go -- Usage: go <location>
jump -- Continue program being debugged at specified line or address
until -- Execute until the program reaches a source line greater than the current
step -- Step program until it reaches a different source line
next -- Step program
finish -- Execute until selected stack frame returns
nexti -- Step one instruction
stepi -- Step one instruction exactly
signal -- Continue program giving it signal specified by the argument
detach -- Detach a process or file previously attached
attach -- Attach to a process or file outside of GDB
unset environment -- Cancel environment variable VAR for the program
tty -- Set terminal for future runs of program being debugged
set follow-fork-mode -- Set debugger response to a program call of fork or vfork
set environment -- Set environment variable value to give the program
set args -- Set arguments to give program being debugged when it is started
thread -- Use this command to switch between threads
thread apply -- Apply a command to a list of threads
apply all -- Apply a command to all threads


Examining the stack.
List of commands:

backtrace_other_thread -- Print backtrace of all stack frames for a thread with stack pointer SP and
bt -- Print backtrace of all stack frames
backtrace -- Print backtrace of all stack frames
select-frame -- Select a stack frame without printing anything
frame -- Select and print a stack frame
down -- Select and print stack frame called by this one
up -- Select and print stack frame that called this one
return -- Make selected stack frame return to its caller


Examining data.
List of commands:

whatis -- Print data type of expression EXP
ptype -- Print definition of type TYPE
inspect -- Same as "print" command
print -- Print value of expression EXP
call -- Call a function in the program
set -- Evaluate expression EXP and assign result to variable VAR
set variable -- Evaluate expression EXP and assign result to variable VAR
output -- Like "print" but don't put in value history and don't print newline
printf -- Printf "printf format string"
display -- Print value of expression EXP each time the program stops
undisplay -- Cancel some expressions to be displayed when program stops
disassemble -- Disassemble a specified section of memory
x -- Examine memory: x/FMT ADDRESS
delete display -- Cancel some expressions to be displayed when program stops
disable display -- Disable some expressions to be displayed when program stops
enable display -- Enable some expressions to be displayed when program stops


Breakpoints -- Making program stop at certain points.
List of commands:

awatch -- Set a watchpoint for an expression
rwatch -- Set a read watchpoint for an expression
watch -- Set a watchpoint for an expression
tcatch -- Set temporary catchpoints to catch events
catch -- Set catchpoints to catch events
xbreak -- Set breakpoint at procedure exit
break -- Set breakpoint at specified line or function
clear -- Clear breakpoint at specified line or function
delete -- Delete some breakpoints or auto-display expressions
disable -- Disable some breakpoints
enable -- Enable some breakpoints
thbreak -- Set a temporary hardware assisted breakpoint
hbreak -- Set a hardware assisted  breakpoint
txbreak -- Set temporary breakpoint at procedure exit
tbreak -- Set a temporary breakpoint
condition -- Specify breakpoint number N to break only if COND is true
commands -- Set commands to be executed when a breakpoint is hit
ignore -- Set ignore-count of breakpoint number N to COUNT


Files -- Specifying and examining files.
List of commands:

show gnutarget -- Show the current BFD target
cd -- Set working directory to DIR for debugger and program being debugged
pwd -- Print working directory
core-file -- Use FILE as core dump for examining memory and registers
section -- Change the base address of section SECTION of the exec file to ADDR
exec-file -- Use FILE as program for getting contents of pure memory
file -- Use FILE as program to be debugged
sharedlibrary -- Load shared object library symbols for files matching REGEXP
objectretry -- Retry loading object files that failed previously
objectload -- Force an object file to be loaded and its debug information
path -- Add directory DIR(s) to beginning of search path for object files
load -- Dynamically load FILE into the running program
add-shared-symbol-files -- Load the symbols from shared objects in the dynamic linker's link map
add-symbol-file -- Usage: add-symbol-file FILE ADDR
symbol-file -- Load symbol table from executable file FILE
set gnutarget -- Set the current BFD target
list -- List specified function or line
reverse-search -- Search backward for regular expression (see regex(3)) from last line listed
search -- Search for regular expression (see regex(3)) from last line listed
forward-search -- Search for regular expression (see regex(3)) from last line listed
directory -- Add directory DIR to beginning of search path for source files
objectdir -- Add directory DIR to beginning of search path for object files


Status inquiries.
List of commands:

show -- Generic command for showing things about the debugger
info -- Generic command for showing things about the program being debugged


Support facilities.
List of commands:

if -- Execute nested commands once IF the conditional expression is non zero
while -- Execute nested commands WHILE the conditional expression is non zero
show confirm -- Show whether to confirm potentially dangerous operations
show history -- Generic command for showing command history parameters
show editing -- Show editing of command lines as they are typed
show verbose -- Show verbosity
show prompt -- Show gdb's prompt
show complaints -- Show max number of complaints about incorrect symbols
show demangle-style -- Show the current C++ demangling style
show write -- Show writing into executable and core files
show check range -- Show range checking
show check type -- Show type checking
show language -- Show the current source language
show remotecache -- Show cache use for remote targets
show auto-solib-add -- Show autoloading size threshold (in megabytes) of shared library symbols
show opaque-type-resolution -- Show resolution of opaque struct/class/union types (if set before loading symbols)
show stop-on-solib-events -- Show stopping for shared library events
show symbol-reloading -- Show dynamic symbol table reloading multiple times in one run
show radix -- Show the default input and output number radices
show output-radix -- Show default output radix for printing of values
show input-radix -- Show default input radix for entering numbers
show print object -- Show printing of object's derived type based on vtable info
show print vtbl -- Show printing of C++ virtual function tables
show print static-members -- Show printing of C++ static members
show print address -- Show printing of addresses
show print array -- Show prettyprinting of arrays
show print union -- Show printing of unions interior to structures
show print pretty -- Show prettyprinting of structures
show print asm-demangle -- Show demangling of C++ names in disassembly listings
show print sevenbit-strings -- Show printing of 8-bit characters in strings as \nnn
---Type <return> to continue, or q <return> to quit
show print demangle -- Show demangling of encoded C++ names when displaying symbols
show overload-resolution -- Show overload resolution in evaluating C++ functions
show listsize -- Show number of source lines gdb will list by default
show debug -- Show printing of  debug traces
show can-use-hw-watchpoints -- Show debugger's willingness to use watchpoint hardware
show pagination -- Show state of pagination
show height -- Show number of lines gdb thinks are in a page
show width -- Show number of characters gdb thinks are in a line
dont-repeat -- Don't repeat this command
help -- Print list of commands
quit -- Exit gdb
source -- Read commands from a file named FILE
define -- Define a new command name
document -- Document a user-defined command
echo -- Print a constant string
boot -- Boot the damn target board
make -- Run the ``make'' program using the rest of the line as arguments
shell -- Execute the rest of the line as a shell command
set confirm -- Set whether to confirm potentially dangerous operations
set history -- Generic command for setting command history parameters
set editing -- Set editing of command lines as they are typed
set verbose -- Set verbosity
set prompt -- Set gdb's prompt
set complaints -- Set max number of complaints about incorrect symbols
set demangle-style -- Set the current C++ demangling style
set write -- Set writing into executable and core files
set check range -- Set range checking
set check type -- Set type checking
set language -- Set the current source language
set remotecache -- Set cache use for remote targets
set auto-solib-add -- Set autoloading size threshold (in megabytes) of shared library symbols
set opaque-type-resolution -- Set resolution of opaque struct/class/union types (if set before loading symbols)
set stop-on-solib-events -- Set stopping for shared library events
set symbol-reloading -- Set dynamic symbol table reloading multiple times in one run
 ---Type <return> to continue, or q <return> to quit
set radix -- Set default input and output number radices
set output-radix -- Set default output radix for printing of values
set input-radix -- Set default input radix for entering numbers
set print object -- Set printing of object's derived type based on vtable info
set print vtbl -- Set printing of C++ virtual function tables
set print static-members -- Set printing of C++ static members
set print address -- Set printing of addresses
set print array -- Set prettyprinting of arrays
set print union -- Set printing of unions interior to structures
set print pretty -- Set prettyprinting of structures
set print asm-demangle -- Set demangling of C++ names in disassembly listings
set print sevenbit-strings -- Set printing of 8-bit characters in strings as \nnn
set print demangle -- Set demangling of encoded C++ names when displaying symbols
set overload-resolution -- Set overload resolution in evaluating C++ functions
set listsize -- Set number of source lines gdb will list by default
set debug -- Set printing of  debug traces
set can-use-hw-watchpoints -- Set debugger's willingness to use watchpoint hardware
set pagination -- Set state of pagination
set height -- Set number of lines gdb thinks are in a page
set width -- Set number of characters gdb thinks are in a line
edit -- Run the editor (specified by $EDITOR) on the current source file
down-silently -- Same as the `down' command
up-silently -- Same as the `up' command


User-defined commands.
The commands in this class are those defined by the user.
Use the "define" command to define a command.


Aliases of other commands.
List of commands:

ni -- Step one instruction
si -- Step one instruction exactly
where -- Print backtrace of all stack frames
delete breakpoints -- Delete some breakpoints or auto-display expressions
disable breakpoints -- Disable some breakpoints



Obscure features.
List of commands:

complete -- List the completions for the rest of the line as a command
remote <command> -- Send a command to the remote monitor
stop -- There is no `stop' command



Maintenance commands.
Some gdb commands are provided just for use by gdb maintainers.
These commands are subject to frequent change, and may not be as
well documented as user commands.

List of commands:

show watchdog -- Show watchdog timer
show targetdebug -- Show target debugging
maintenance -- Commands for use by GDB maintainers
maintenance check-symtabs -- Check consistency of psymtabs and symtabs
maintenance space -- Set the display of space usage
maintenance time -- Set the display of time usage
maintenance demangle -- Demangle a C++ mangled name
maintenance dump-me -- Get fatal error; make debugger dump its core
maintenance print -- Maintenance command for printing GDB internal state
maintenance print statistics -- Print statistics about internal gdb state
maintenance print objfiles -- Print dump of current object file definitions
maintenance print psymbols -- Print dump of current partial symbol definitions
maintenance print msymbols -- Print dump of current minimal symbol definitions
maintenance print symbols -- Print dump of current symbol definitions
maintenance print type -- Print a type chain for a given symbol
maintenance print unwind -- Print unwind table entry at given address
maintenance info -- Commands for showing internal info about the program being debugged
maintenance info sections -- List the BFD sections of the exec and core files
maintenance info breakpoints -- Status of all breakpoints
set watchdog -- Set watchdog timer
set targetdebug -- Set target debugging