
# bash_script_i

# ugly gdb command alias , it doesn't support any argugments
# the ony useful is :
# alias spe = set print elements
# spe 20
# https://stackoverflow.com/questions/30494918/gdb-alias-for-quick-saving-loading-of-breakpoints
# use -a to short a long command , e.g
# alias -a di = disas
# alias .=p $pc
# alias bm=rbreak
# alias hh=help

define rinit
    source ${BASH_DIR}/app/gdb/gdb_init.gdb
end
document rinit
	reload gdb init procedure : source ${BASH_DIR}/app/gdb/gdb_init.gdb
end

define rload
    source ${BASH_DIR}/app/gdb/init/loadAlias.gdb
end
document rload
	reload the gdb alias script : source ${BASH_DIR}/app/gdb/init/loadAlias.gdb
end 

define ipath
    source ${BASH_DIR}/app/gdb/feature/cmds/info_path.gdb
end
document ipath
	source  ${BASH_DIR}/app/gdb/feature/cmds/info_path.gdb
    show all path-related information.
end

define al
    help aliases
end
document al
	Prints list all defined aliases
end 

define ver
    show version
    cver
end
document ver
	show current gdb version and compiler  info
end 

define fl
    help user-defined
end
document fl
    list all user-defined commands.
end

define fh
if $_isvoid($_gdb_major)==0    
    # command "|" is supported after gdb 9.0
    | echo . | cat ${EXT_DIR}/myReference/gdb_debug_cmd_list_all.txt | grep "$arg0"
end
    echo  \033[32muse built-in command '\033[33m apropos word \033[32m' to list all word related command.\033[37m\r\n
end
document fh
    search gdb cmd
end

define hh
    echo use "help <cmd>" to show detail usage
    echo \r\n help user-defined      -- list all User-defined commands.      ( fl )    
    echo \r\n help aliases           -- list all user customized aliases.    ( al )
    echo \r\n help function          -- list all built-in debugger functon.
    echo \r\n show user              -- list all user customized command implement body
    echo \r\n show                   -- list all setting options setting   
    echo \r\n show convenience       -- list all gdb internal function and customized variables.\r\n
    echo \r\n help xxx               -- show user customized command 'xxx' document description.
    echo \r\n show user xxx          -- show user customized command 'xxx' implement body    
    echo \r\n ff xxx                 -- search gdb command which is related to string 'xxx'   
    echo \r\n apropos xxx            -- \033[32msearch gdb command which is related to string '\033[33mxxx\033[32m' by gdb built-in command\033[37m
    echo \r\n all cmd                :  \033[35m${EXT_DIR}/myReference/gdb_debug_cmd_list_all.txt\033[37m
    echo \r\n link                   :  \033[35mhttps://visualgdb.com/gdbreference/commands/\033[37m
    echo \r\n
end
document hh
    list all internal/user-defined finction and alias 
    use help <cmd> to show detail usage
    all cmd   : ${EXT_DIR}/myReference/gdb_debug_cmd_list_all.txt
    link      : https://visualgdb.com/gdbreference/commands/ 
end

define uf
    disassemble /s $arg0
    echo \r\nDone : disassemble /s $arg0
    echo \r\n u  $arg0  10  : only disassemble  preious 10 bytes
    echo \r\nlist $arg0     : used to show function source code\r\n
end
document uf
	disassemble function
end

define u
    disassemble /s
    echo \r\nDone : disassemble /s $arg0,+$arg1
    echo \r\n or  : disassemble /s $arg0,addressEnd
    echo \r\n or  : disassemble /r $arg0,+$arg1
    echo \r\n or  : disassemble /m $arg0,+$arg1    
    echo \r\nlist $arg0  : used to show function source code\r\n
end
document u
	disassemble /s | /r | /m 
    disassemble function/addressBegin[,addressEnd]
    disassemble function/addressBegin[,+offset]
end

define ucx
    u $pc-0x5  0x5+$arg0
    echo \r\n
    help u
end
document ucx
	disassemble current address with specified size
end

define uc
    u $pc-0x5  0x25
    echo \r\n
    help u
end
document uc
	disassemble current address
end

define bte
    # source ${BASH_DIR}/app/gdb/feature/pretty_printer/hide_library_function_in_callstack_bt.py
    source ${BASH_DIR}/app/gdb/feature/pretty_printer/enhance_callstack_bt_frame_filter.py
end
document bte
	enhanced thread stack show
end

define bta
    info threads
    thread apply all bt
end
document bta
	show all threads callstack
end

define bts
    thread apply all bt
end
document bts
	show all threads callstack
end

define btx
    thread $arg0
end
document btx
	switch Nth thread callstack
end

define le
    # p $_siginfo
    # p $_exception
    info breakpoint $bpnum

    echo \033[33m more : \033[37m\r\n
    echo \033[32m p $_siginfo \033[37m\r\n
    echo \033[32m p $_exception \033[37m\r\n
    echo \033[32m p $bpnum \033[37m\r\n
end
document le
	last hitted signal and exception , breakpoint event.  p  $bpnum
end

define bd
    source ${BASH_DIR}/app/gdb/feature/cmds/show_compiler.py
    echo Done to show comipler info \r\n
end
document bd
    show compiler information when build this module.
    source ${BASH_DIR}/app/gdb/feature/cmds/show_compiler.py
    https://stackoverflow.com/questions/28295075/determine-compiler-name-version-from-gdb
end

define sx
    info signals
end
document sx
    show current exception event list
    info signals
end

define sxe    
    source ${BASH_DIR}/app/gdb/feature/bp/load_sx_exception_signal.gdb

    echo summary :\033[32m ${BASH_DIR}/app/gdb/feature/bp/load_sx_exception_signal.gdb \033[37m
    echo \r\nif break when process exit ( windbg : sxe epr ) , run below commnad :
    echo \r\ncatch syscall exit exit_group\r\n\r\n
end
document sxe
    catch exception
    ${BASH_DIR}/app/gdb/init/loadAlias.gdb:207
end

define sxenv    
    source ${EXT_DIR}/myReference/note/cask_breakpoints/load_sx_exception_signal_nvidia.gdb.gdb

    echo summary :\033[32m ${EXT_DIR}/myReference/note/cask_breakpoints/load_sx_exception_signal_nvidia.gdb.gdb \033[37m \r\n
end
document sxenv
    catch nvidia exception
    ${BASH_DIR}/app/gdb/init/loadAlias.gdb:214
end

define test
    source ${BASH_DIR}/app/gdb/test/test.gdb
end
define testpy
    source ${BASH_DIR}/app/gdb/test/test_python_in_gdb.py
end

define rdrtest
    rdr test 1 -o ${EXT_DIR}/tmp/to_del/test.gdb.log
    echo \r\n ${BASH_DIR}/app/gdb/test/test.gdb \r\n
end

# watch : gdb will break when a write occurs
# rwatch: gdb will break wnen a read occurs
# awatch: gdb will break in both cases
# If -l or -location is given, this evaluates EXPRESSION and watches
define ba
   # awatch -l $arg0
   echo write breakpoint : watch addr $arg0 \r\n
   echo r/w   breakpoint : awatch addr $arg0 \r\n
   awatch $arg0
   show can-use-hw-watchpoints
end
document ba
   set a data access breakpoint : write and read.
   awatch addr
end

define f0
   frame 0
end
document f0
   show current code line information.  frame 0
end

define f1
   frame 1
end
document f1
   show caller line information.  frame 1
end

define fmt
   # echo hex : 
   echo p /x $arg0 : 
   p /x $arg0
   echo p /d $arg0 : 
   p /d $arg0
   echo p /u $arg0 : 
   p /u $arg0
   echo p /o $arg0 : 
   p /o $arg0
   echo p /t $arg0 : 
   p /t $arg0
   echo p /a $arg0 : 
   p /a $arg0
   echo p /c $arg0 : 
   p /c $arg0
   echo p /f $arg0 : 
   p /f $arg0
   echo p /s $arg0 : 
   p /s $arg0
   echo p /r $arg0 : 
   p /r $arg0
   echo \r\n config print radix :
   echo \r\n set output-radix 8
   echo \r\n set output-radix 10
   echo \r\n set output-radix 16 \r\n
end
document fmt
   show value by different format
end

define func
   echo  this first function parameter is $arg0 \r\n
   info symbol $arg0
end
document func
   show function information.
end

define log
   show logging
end
document log
   show current gdb sessiong log info.
end

define offset
   echo ptype /o $arg0 \r\n   
   ptype /o $arg0
end
document offset
   show every member filed offset of a struct.
end

define offsetx
   echo -exec p  params.$arg0 \r\n
   p  &params.$arg0
   p (void*)(&params.$arg0)-(void*)(&params)
   whatis &params.$arg0
end
document offsetx
   show params member offer and type.
end

define hh_replaced_by_help
   !grep -iR $arg0 ${BASH_DIR}/app/gdb/test/gdbCmd.gdb
end
document hh_replaced_by_help
   show a command usage, regular is supported.
   Syntax hh <cmdName>
   example : hh hh
end

define dv
   echo fucntion signature: frame  \r\n
   frame
   
   echo \r\n
   echo function parameter ： i   args \r\n
   i   args

   echo \r\n
   echo local variables : i   locals \r\n
   i   locals 
end
document dv
	show current function stack call arguments and local variables.
end 

define go
    echo go until line $arg0 ... \r\n
    until $arg0
end
document go
    go until line
end

define ss
    echo go out currrent functon ... \r\n
    finish
end
document ss
    go out currrent functon
    name to 'ss' , instead of 'gu' , because previous cmd is 's' in general , so 'ss' is more convenience 
end

define on
    echo open verbose message mode ... \r\n
    source ${BASH_DIR}/app/gdb/init/mode_verbose.gdb
end
document on
    open verbose message mode ... 
end

define off
    echo close verbose message mode ... \r\n
    source ${BASH_DIR}/app/gdb/init/mode_quiet.gdb
end
document off
    close verbose message mode ...
end

# ************************** breakpoint related begin ***********************************************************

define bsave    
    info breakpoint
    save breakpoints cmds/gdb_breakpoints.ini
    echo \r\nsave breakpoint to file : \r\n
    echo \033[35m
    shell readlink -f cmds/gdb_breakpoints.ini
    echo \033[37m\r\n
end
document bsave    
    save breakpoint to file cmds/gdb_breakpoints.ini
end

define bload
    source cmds/gdb_breakpoints.ini
    echo \r\nload breakpoint from file : \r\n
    echo \033[35m
    shell readlink -f cmds/gdb_breakpoints.ini
    echo \033[37m\r\n
end
document bload    
    load breakpoint from file cmds/gdb_breakpoints.ini
end

define bl    
    info breakpoint
    echo \r\nmaint info breakpoints : show verbose breakpoint info. \r\n
    echo \033[35m
    shell readlink -f cmds/gdb_breakpoints.ini
    echo \033[37m\r\n
end
document bl    
    list all breakpoints
end

define lb
    printf  "last hitted breakpoint number ( $bpnum ) : %d\r\n" , $bpnum    
end
document lb
	last hitted breakpoint
end

define bc
    dr @plt
end
document bc
	cleanup all expected/unnecessary breakpoint : @plt
    https://stackoverflow.com/questions/28243549/prevent-plt-procedure-linkage-table-breakpoints-in-gdb
    ${BASH_DIR}/app/gdb/feature/bp/regular_delete_breakpoint.py
end

define bm    
    echo rbreak  .
    echo \r\nrbreak file.c:.*  \r\n
end
document bm    
    list rbreak usage
end

# ************************** breakpoint related end ***********************************************************

define usrc    
    layout src
end
document usrc    
    show source code window
    use ctrl + xa to close window mode.
end

define uasm    
    layout asm
end
document usrc    
    show asm instruction window
    use ctrl + xa to close window mode.
end

define uboth    
    layout split
end
document uboth    
    show source code and asm instruction window
    use ctrl + xa to close window mode.
end

define cls    
    shell clear
end
document cls    
    clear command window screen. shortcut : ctrl + L
end

define db
    echo x/$arg1bx $arg0  \r\n
    x/$arg1bx $arg0    
    
    echo \r\nx/$arg1cs $arg0 \r\n
    x/$arg1cs $arg0

    echo \r\nDone to dump address $arg0 , bytes : $arg1 \r\n
end
document db
	dump address n bytes content
    Syntax  : db <addr> <size>
    example : db myPtr  8
end 

define dd
    echo x/$arg1xw $arg0  \r\n
    x/$arg1xw $arg0

    echo \r\nDone to dump memory address $arg0 , dword count : $arg1 \r\n
end
document dd
	dump address n bytes content
    Syntax  : db <addr> <size>
    example : db myPtr  8
end 

define da    
    set print elements 0
    x/s $arg0
    set print elements 5
end
document da    
    show address as string method.
    Syntax : da <address>
    example : da myPtr
end

define dds
    x/i         $arg0    
end
document dds
	try to show symbol information of specified address, perhaps it is data address, instead of symbol address ....
    Syntax  : dds   <address>
              x/i   <address>
    Example : dds  0x12345678
end

define sym
    echo \r\n ptype $arg0     // use ptype /o $arg0 to print offsets and sizes of fields in a struct. \r\n
    # ptype $arg0
end
document sym    
    show type info of a symbol ( class or var name)
    Syntax : sym <class_or_var_name>
    example : sym myObj
end

define syms
    echo \r\n you can below cmd to check more info ... 
    echo \r\n \033[32m class symbol    : has only type info , e.g. type name
    echo \r\n \033[32m instance symbol : has type + data(address) info , e.g. func/var 
    echo \r\n \033[32m explore $arg0              \033[37m : show class member fields - it is useful to print member    
    echo \r\n \033[32m p       $arg0              \033[37m : show source code path   ， func/var symbol.
    echo \r\n \033[32m whatis  $arg0              \033[37m : only show type name     ， var or class_member.
    echo \r\n \033[32m ptype   $arg0              \033[37m : show type defintion     ， var or class symbol.    
    echo \r\n \033[32m info scope $arg0           \033[37m : List scope variables    ,  function name, a source line , or address
    echo \r\n \033[32m info symbol $arg0          \033[37m : enumerate name symbol   ， class symbol ( regular expression ) 
    echo \r\n \033[32m info types $arg0           \033[37m : show symbol def path    ， class symbol.( regular expression ) 
    echo \r\n \033[32m info func $arg0            \033[37m : show function defintion ， func symbol. ( regular expression ) 
    echo \r\n \033[32m p pObj->execute            \033[37m : show anyone function of a object.
    echo \r\n \033[32m list $arg0                 \033[37m : list func source code   ， func symbol. 
    echo \r\n \033[32m uf $arg0                   \033[37m : disassemble func        ,  func symbol. it can list actul call file path and line number.
    echo \r\n \033[32m info line $arg0            \033[37m : get the address of file:line
    echo \r\n \033[32m info variables $arg0       \033[37m : enumerate var symbol    ,  func/var symbol ( regular expression ) 
    echo \r\n \033[32m info classes $arg0         \033[37m : enumerate C++ type      ,  class symbol ( regular expression ) 
    echo \r\n \033[32m maint info psymtabs $arg0  \033[37m : list struct defintion   ,  class symbol ( regular expression )
    echo \r\n \033[32m macro expand $arg0         \033[37m : expand macro            ， macro
    echo \r\n \033[32m info macro $arg0           \033[37m : show macro defintion    ， macro , need compile option -gdwarf-2 -g3 
    echo \r\n "suggested usage  :\033[32m pt $arg0 -> xx sym  / explore x   \033[37m "
    echo \r\n "suggested usage  :\033[32m xxf func  -> p func  \033[37m  "
    
    echo \033[32mshow virtual member function of a object :\033[33m info vtbl obj\033[37m\r\n
    echo \033[32mshow anyone member function of a object :\033[33m p pObj->execute\033[37m\r\n
    echo \r\n
    echo \r\n ${BASH_DIR}/app/gdb/init/loadAlias.gdb:453\r\n
end
document syms
    list all cmd which is related to a symbol ( class or var name)
end

define cmdline
   info proc 
   show args
   echo \r\npeb      : query process info. \r\n
end
document cmdline
	List command line arguments of the specified process.
end

define peb
   info proc all
   info inferiors
end
document peb
	List all available info about the specified process.
end

define ln
    echo \033[32mmore possible cmds  : \033[37m
    echo \r\n info address, info registers, info files, info line, info registers, info source, info sources, info symbol, info types, info variables, info vector, info vtbl
    echo \r\n \033[32mhttps://visualgdb.com/gdbreference/commands/information_displaying_commands\033[37m
    echo \r\n ls      : query symbol of current address. 
    echo \r\n info line kernel_dispatch.cpp:139      : query address of current symbol. \r\n\r\n
    info symbol $arg0
    p           $arg0  
end
document ln
	show symbol information of specified address ....
    Syntax  : lnx <var_or_class_name>
              info symbol  <var_or_class_name>
    Example : lnx  0x12345678
    refe to : https://sourceware.org/gdb/onlinedocs/gdb/Convenience-Vars.html
end

define ls    
    echo \033[32mmore possible cmds  : \033[37m
    echo \r\n info address, info registers, info files, info line, info registers, info source, info sources, info symbol, info types, info variables, info vector, info vtbl
    echo \r\n \033[32mhttps://visualgdb.com/gdbreference/commands/information_displaying_commands\033[37m
    printf  "\r\n last hitted breakpoint number ( $bpnum ) : %d" , $bpnum  
    echo \r\n ln addr : query symbol of specified address.  'ls' is same to 'ln $pc'
    echo \r\n lsa     : list all symbol for current address.
    echo \r\n frame   : list current source path:lineNumber (p $pc) , current source code. 
    echo \r\n li      : lists ten more lines after or around previous listing. see help li
    echo \r\n lsrc    : list current source code.    
    echo \r\n info line kernel_dispatch.cpp:139      : query address of current symbol. \r\n\r\n
    info frame
    ln  $pc
end
document ls
    show the source code information of current instruction
end

define lsrc
    echo previous 3 lines ....\r\n
    list -3
    echo \r\nlater 3 lines ....\r\n
    list
    echo use ls to list current source file path info.  \r\n
end
document lsrc
    show the source code [-3,+3] line information of current instruction    
end

define lsa
    info    source
    info    line
    info    symbol $pc
    p       $pc 
    ln      $pc
    echo ln addr : query symbol of specified address.  'ls' is same to 'ln $pc'
    echo \r\nlsrc    : list current source code. \r\n 
end
document lsa
    show the source code information of current instruction
end

define addr    
    info address $arg0    
    echo prompt : use "xx $arg0" to query all symbol which include '$arg0'\r\n
end
document addr
	show address information of specified actual symbol, e.g. main
    Syntax  : addr  <symbol_name>
              info address <symbol_name>
    Example : addr  main
end 

define xx
if $_isvoid($_gdb_major)==0    
    # command "|" is supported after gdb 9.0
    | info types $arg0     | grep -v "typedef" | sed 's/File //'  | tr '\n' ' ' |  sed 's#/home/.*:  /home/#/home/#g' | sed 's#/home/#\n/home/#g' | grep -v "/home/utils/" | sed 's#: \([0-9]*\):#:\1 \1: #' | sed 's#/home/#\n/home/#g' | sed 's# \([0-9]*\):#\n\1:#g' | sed 's#;#  ;#g'
    | info func $arg0      | grep -v "typedef" | sed 's/File //'  | tr '\n' ' ' |  sed 's#/home/.*:  /home/#/home/#g' | sed 's#/home/#\n/home/#g' | grep -v "/home/utils/" | sed 's#: \([0-9]*\):#:\1 \1: #' | sed 's#/home/#\n/home/#g' | sed 's# \([0-9]*\):#\n\1:#g' | sed 's#;#  ;#g'
    | info variables $arg0 | grep -v "typedef" | sed 's/File //'  | tr '\n' ' ' |  sed 's#/home/.*:  /home/#/home/#g' | sed 's#/home/#\n/home/#g' | grep -v "/home/utils/" | sed 's#: \([0-9]*\):#:\1 \1: #' | sed 's#/home/#\n/home/#g' | sed 's# \([0-9]*\):#\n\1:#g' | sed 's#;#  ;#g'
else
    info types $arg0
    info func $arg0
    info variables $arg0
end    
    echo done to enumerate all class symbols    : \033[32minfo types $arg0  \033[37m\r\n
    echo done to enumerate all func symbols     : \033[32minfo func $arg0  \033[37m\r\n
    echo done to enumerate all global variables : \033[32minfo variables $arg0  \033[37m\r\n
    echo \r\n
end
document xx
	emulate matched symbol information , regular express (.*xxx.*) is supported , it is time-consumed.
    Syntax  : xx  <symbol_name>
              info types <symbol_name>
              info func <symbol_name>
              info variables  <global_object_name>
    Example : xx  .*::domain_error
end

define xxt
    rdr info line $arg0 -o ${EXT_DIR}/myReference/note/info_line.txt
    ! source ${BASH_DIR}/app/gdb/feature/parse_cmd_output/parse_info_line.sh
    
if $_isvoid($_gdb_major)==0    
    # command "|" is supported after gdb 9.0
    # | pt $arg0 | grep "type ="
    # | info types $arg0 | grep -v "typedef" | sed 's/File //'  | tr '\n' ' ' |  sed 's#/home/.*:  /home/#/home/#g' | sed 's#/home/#\n/home/#g' | grep -v "/home/utils/" | sed 's#: \([0-9]*\):#:\1 \1: #' | sed 's#/home/#\n/home/#g' | sed 's# \([0-9]*\):#\n\1:#g' | sed 's#;#  ;#g'
    # info line $arg0
    # ! source ${BASH_DIR}/app/gdb/feature/parse_cmd_output/parse_info_line.sh
else
    # info types $arg0    
    # info line $arg0
    # ! source ${BASH_DIR}/app/gdb/feature/parse_cmd_output/parse_info_line.sh
end
    echo done to enumerate all class symbols    : \033[32minfo types $arg0  \033[37m\r\n
end
document xxt
	emulate matched symbol information , regular express (.*xxx.*) is supported , it is time-consumed.
    Syntax  : xxt  <symbol_name>
              info types <symbol_name>
    Example : xxt  .*::domain_error
    Note    : command "|" is supported after gdb 9.0
end

define xxf
    rdr info line $arg0 -o ${EXT_DIR}/myReference/note/info_line.txt
    ! source ${BASH_DIR}/app/gdb/feature/parse_cmd_output/parse_info_line.sh
if $_isvoid($_gdb_major)==0    
    # command "|" is supported after gdb 9.0
    # | info func $arg0 | sed 's/File //'  | tr '\n' '!' | sed 's#!\+#!#g' | sed 's#:!\([0-9]*\):#:\1!\1:#g' | sed 's#!#\n#g' | sed 's#/home/#\n/home/#g' | sed 's#Non-debugging#\nNon-debugging#g' | sed 's#/home/\(.*\)/\(.*\):#\2\n/home/\1/\2:#g' | sed 's#std::.*>#std...#g'
    # info line $arg0
    # ! source ${BASH_DIR}/app/gdb/feature/parse_cmd_output/parse_info_line.sh
else
    # info func $arg0
    # info line $arg0
    # ! source ${BASH_DIR}/app/gdb/feature/parse_cmd_output/parse_info_line.sh
end    
    echo done to enumerate all func symbols     : \033[32minfo func $arg0  \033[37m\r\n
    echo try  \033[32minfo line $arg0  \033[37m for more detail \r\n
end
document xxf
	emulate matched symbol information , regular express (.*xxx.*) is supported , it is time-consumed.
    Syntax  : xxf  <symbol_name>
              info func <symbol_name>
    Example : xxf  .*::domain_error
end

define pv
if $_isvoid($_gdb_major)==0    
    # command "|" is supported after gdb 9.0
    | info vtbl $arg0 | sed 's/(.*)/( ... )/' | sed 's/: .*\?</ /'
else
    info vtbl $arg0    
end    
    echo \033[32minfo func $arg0\033[37m
end
document pv
	print virtual function table of one C++ object.
    Syntax  : pf  <object_name>
              info vtbl <object_name>
    Example : pf  myObj
end

define xxv
if $_isvoid($_gdb_major)==0    
    # command "|" is supported after gdb 9.0
    | info variables $arg0 | sed 's/File //'  | tr '\n' ' ' |  sed 's#/home/.*:  /home/#/home/#g' | sed 's#/home/#\n/home/#g' | grep -v "/home/utils/" | sed 's#: \([0-9]*\):#:\1 \1: #' | sed 's#/home/#\n/home/#g' | sed 's# \([0-9]*\):#\n\1:#g' | sed 's#;#  ;#g' | sed 's#Non-debugging#\n\nNon-debugging#g' | sed 's# 0x\([0-9a-e]*\) #\n0x\1 #g' | sed 's#std::.*>#std...#g'
else
    info variables $arg0
end    
    echo \033[32minfo variables $arg0\033[37m
    echo \r\nuse p <symbol_name> to get the source code file and lineNumber.
    echo \r\n
end
document xxv
	emulate matched global variables, regular express (.*xxx.*) is supported , it is time-consumed.
    Syntax  : xxv  <symbol_name>
              info variables <symbol_name>
    Example : xxv  kernel_test_.*
end

define threads
    info threads
    info cuda threads
    echo \r\nyou can use ' thread 1 '  or ' cuda thread 1 ' to switch thread.\r\n
end
document threads
    show thread info
end

define pp
    print *$arg0 
    echo \r\n
    whatis  *$arg0
end
document pp
    print value of pointer
    name to 'pp' , instead of 'pthis' , because previous cmd is 'p' in general , so 'pp' is more convenience 
end

define pa
    echo \033[32mprint $arg0@4  \033[37m\r\n
    print $arg0@4
    echo \033[31musage :\033[32m p ptr@N \033[37m \r\n
end
document pa
    print pointer as a array
    p ptr@N
end

define ppt
    ptype /m this
    echo \r\n
    whatis  *this
end
document ppt
    it show the this data member 
end

define pr
    print /r $arg0    
end
document pr
    show raw type definition.  print /r $arg0
end

define pm
    ptype /m $arg0    
end
document pm
    only show type data member.  pt /m $arg0
    show type definition without member function.  ptype /m $arg0
end

define pptr    
    p *($arg0._M_t._M_head_impl)
end
document pptr    
    print a std::unique_ptr<T> pointer content
    pptr var
end

define lm
    info sharedlibrary
    echo \033[32minfo sharedlibrary \033[37m\r\n
end
document lm
    show loaded modules in current process.
end

define var
    echo \r\n info variables : list "All global and static variable names" (huge list.
    echo \r\n info locals    : list "Local variables of current stack frame" (names and values), including static variables in that function.
    echo \r\n info args      : list "Arguments of the current stack frame" (names and values)
    echo \r\n
end
document var
    show list variable usage.
end

define srcpath
    show directories
    echo source folder map:\r\n
    show substitute-path
    echo use directory [dirs] to add sources search path.\r\n    
end
document srcpath
    show current source files search path.
end

define sympath
    show path
    echo use path [dirs] to add symbol path.\r\n
end
document sympath
    show current symbol search path
end

define exepath    
    echo TODO.\r\n
end
document exepath    
    show current modules search path. TODO : ${BASH_DIR}/app/gdb/init/loadAlias.gdb
end

define color    
    echo demo gdb color text output : (  \\033[3xm  )\r\n
    echo \033[30m0000\033[31m1111\033[32m2222\033[33m3333\033[34m4444\033[35m5555\033[36m6666\033[37m7777\r\n
    # print "\033[92m0000\033[31m1111\033[32m2222\033[33m3333\033[34m4444\033[35m5555\033[36m6666\033[0m7777\r\n"

    # run below command in gdb script:
    echo \033[33mr11
    printf "=0x%016lX  ", 5
    echo \033[34mr12
    printf "=0x%016lX  ", 6
    echo \033[35mr13
    printf "=0x%016lX  ", 7
    echo \r\n\033[36m${BASH_DIR}/app/gdb/init/loadAlias.gdb:752

    echo \033[37m\r\n
end
document color    
    show how to use gdb color text ouput
end

# https://sourceware.org/gdb/onlinedocs/gdb/Define.html
# _________________ map gdb feature to simple windbg command _________________

source ${BASH_DIR}/app/gdb/cuda_gdb/loadAlias_nvidia.gdb
echo \r\n--------- leaving \033[32m${BASH_DIR}/app/gdb/init/loadAlias.gdb\033[37m ...\r\n