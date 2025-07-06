# bash_script_i
# https://sourceware.org/gdb/onlinedocs/gdb/Set-Catchpoints.html#Set-Catchpoints
# alias sxe is available

# **** note : catch can't work on :  catch xxx  # comment string
# # comment string must in different line

# *******************************************************************************************
# awatch                #   Set a watchpoint for an expression
# break                 #   Set breakpoint at specified location
# break-range           #   Set a breakpoint for an address range

# ********************************** throw     =>  catch *********************************************************
# 1. throw
# Catch an exception throw
catch throw
catch throw std::exception
# 1. catch __cxxabiv1::__cxa_begin_catch (exc_obj_in=0x2f876b0)  when catch throw can't work
b __cxa_begin_catch
# 2. catch all function in exception handel source file eh_catch.cc
# rb eh_catch.cc:.*

# ------------------------------------------------------------------------------------------------
# Set catchpoints to catch events
#   use b __raise_exception , instead of catch catch to avoid enter SEH ( system-exception-handle )
# b __raise_exception

# 2. catch
#   Catch an exception
catch catch

# *******************************************************************************************

# catch exec            #   Catch calls to exec
# catch fork            #   Catch calls to fork
# catch handlers        #   Catch Ada exceptions
# catch load            #   Catch loads of shared libraries
# catch rethrow         #   Catch an exception
# catch signal          #   Catch signals by their names and/or numbers
# catch syscall         #   Catch system calls by their names
                        #   if break when process exit : catch syscall exit exit_group
# *******************************************************************************************
# catch unload          #   Catch unloads of shared libraries
# catch vfork           #   Catch calls to vfork

# *******************************************************************************************

# bash_script_o

