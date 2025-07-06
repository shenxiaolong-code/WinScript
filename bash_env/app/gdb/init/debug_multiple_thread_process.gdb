# bash_script_i


#***********************************************  multiple process setting  *****************************************************
# https://evilpan.com/2020/09/13/gdb-tips/
# https://blog.csdn.net/cjfeii/article/details/21647663 

if 1
    # set the debug targe process : parent or child process ( parent is needed, the child process is render process in most scenario )
    # on      gdb env : we expect to debug the host code on parent process.
    # on cuda gdb env : we expect to debug the device code on child process.  inferior to child process
    echo \033[35menabled debug multiple process - parent ... \033[37m \r\n
    # set follow-fork-mode child
    set follow-fork-mode parent

    # off : can debug all process, GDB attach all processes after fork/vfork, othere un-active process is suspended 
    # on  : only debug single process (depending on the set follow-fork-mode command), another process will be detached. [ default value ]
    echo \033[35menabled debug multiple process - debug all process ... \033[37m \r\n
    set detach-on-fork off
    # set detach-on-fork on

    # https://evilpan.com/2020/09/13/gdb-tips/
    # before the child proces is loaded , to set pre-breakpoint on child process module.
    # set breakpoint pending on to avoid unnecessary error  report because the child process is not loaded
    set breakpoint pending on
else
    echo \033[35mMultiple process debug is disabled ... \033[37m \r\n
end

if 0
    echo \033[35mCatch child event and breakpoints is enabled ... \033[37m \r\n
    # catch fork system event
    catch fork
    catch exec

    # set entry breakpoint in child process -- it need the breakpoint pending on mode
    b _start

    # attach $parent_pid
    # file child
    # continue
else
    echo \033[35mCatch child process is disabled ... \033[37m \r\n
end

if 0    
    # show multiple process setting
    show follow-fork-mode
    show detach-on-fork

    # peb  | proc    
    # show multiple process debug status.
    info inferiors

    # show multiple process info
    show process info
    info proc
    
    # switch to process 1
    inferior 1
end

#***********************************************  multiple thread setting  *****************************************************
# NOTE : those options MUST be loaded after the debugger is initialed and the project symbol is loaded.
#        cudagdb not supports those options

if 1
    # show scheduler-locking
    # https://wizardforcel.gitbooks.io/100-gdb-tips/content/set-detach-on-fork.html
    # https://sourceware.org/gdb/onlinedocs/gdb/All_002dStop-Mode.html
    # Set the mode for allowing threads of multiple processes to be resumed when an execution command is issued. 
    # When on, all threads of all processes are allowed to run. 
    # When off, only the threads of the current process are resumed. The default is off
    echo \033[35menabled debug multiple threads - all threads allowed to run ... \033[37m \r\n
    set schedule-multiple on

    if $_isvoid($cudagdb)==1 
        # show scheduler-locking
        # avoid thread switch when step debug
        # Behaves like on when stepping, and off otherwise. 
        # Threads other than the current never get a chance to run when you step, and they are completely free to run when you use commands like ‘continue’, ‘until’, or ‘finish’.        
        #  ( cudagdb ) Target 'multi-thread' cannot support this command.
        echo \033[35menabled debug multiple threads - avoid thread switch when step debug ... \033[37m \r\n
        set scheduler-locking step
    end
else
    echo \033[35mMultiple threads debug is disabled ... \033[37m \r\n
end

if 0
    # show multiple thread setting
    info set scheduler-locking
    help set scheduler-locking

    # show other thread info
    thread apply all bt
    thread apply <tid> bt
    thread apply <tid> info local

    # switch thread
    thread <tid>    

    # show current thread id
    # thread
    p $_thread
end

echo \r\n --------- leaving ${BASH_DIR}/app/gdb/init/debug_multiple_thread_process.gdb ...\r\n