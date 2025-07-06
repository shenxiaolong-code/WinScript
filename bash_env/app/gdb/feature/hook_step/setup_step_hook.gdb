
echo --------- loading ${BASH_DIR}/app/gdb/feature/hook_step/setup_step_hook.gdb:16 ...\r\n

source ${BASH_DIR}/app/gdb/feature/hook_step/gdb_step_action.py

# define hookpre-step
#   gdb_step_action
# end

# define hookpost-step
#     gdb_step_action
# end

# define hookpost-finish
#     gdb_step_action
# end

define hookpost-next
    gdb_step_action
end

define hookpost-frame
    gdb_step_action
end

# define hookpost-continue
#     gdb_step_action
# end

define hookpost-until
    gdb_step_action
end

# define hookpost-return
#     gdb_step_action
# end


# run, continue, next, step, finish, until, return, jump, break, tbreak, rbreak, watch, rwatch, awatch, catch, commands, condition, enable, disable, delete, clear, frame, select, thread, signal, handle, info, show, set, print, list, whatis, ptype, display, undisplay, x, disassemble, dump, append, call, cd, pwd, search, shell, make, user, server, target, load, symbol-file, add-symbol-file, file, core-file, exec-file, section, dir, source, echo, define, document, undefine, save, quit, help, complete, apropos

echo --------- leaving ${BASH_DIR}/app/gdb/feature/hook_step/setup_step_hook.gdb:22 ...\r\n