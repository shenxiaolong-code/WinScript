# ln -s ${BASH_DIR}/app/gdb/gdb_init.gdb   ~/.gdbinit
# ln -s ${BASH_DIR}/app/gdb/test/ddd_init  ~/.dddinit

# highlight file context by file extension : associations
# https://stackoverflow.com/questions/29973619/how-to-associate-a-file-extension-with-a-certain-language-in-vs-code
# easy way : ctrl + shift + p  => change language mode => shell script


echo \033[36m+++++++++ loading \033[35m$env::HOME/.gdbinit\033[37m ...\r\n
echo \033[36m+++++++++ loading \033[35m${BASH_DIR}/app/gdb/gdb_init.gdb\033[37m ...\r\n
# echo sourced by $env::HOME/.gdbinit    \r\n
# echo ddd init file path : $env::HOME/.ddd/init\r\n
# https://github.com/gdbinit/Gdbinit/blob/master/gdbinit
# https://gist.github.com/CocoaBeans/1879270

# resolve issue : warning: GDB: Failed to set controlling terminal: Operation not permitted
# chmod +x $env::HOME/.gdbinit

# NOTE : 
# Not load project-specified gdb script file in gdb_init.gdb file , it should be put : <projDir>/.gdbinit
# the better alternative way    :
# in global common init         : /home/<user>/.gdbinit
# in shell command line         : gdb --command=<gdb_script_path> --args /home/.../bin/cask-sdk-cask-tester run ...
# in vscode gdb launch.json     : "setupCommands":[ { "text": "source /home/.../gdb_init_cppTest.gdb", } ]
# in project specified init     : <projDir>/.gdbinit

# the script file load time point :
# .gdbinit will be loaded when gdb started immediately.
# <gdb_script_path>  of  gdb --command=<gdb_script_path> will be loaded after the main user module symbols is loaded.
# =>  system breakpoints should be set in .gdbinit -- but we can put complex breakpoint examples in .gdbinit with arounding by  if 0 ... end
# =>  user module breakpoints should be set in <gdb_script_path> without pending.

##################################################  implement  ##################################################
# https://docs.amd.com/bundle/ROCDubugger-User-Guide/page/Convenience-Vars.html
# how to remove a convenience variable
# begin
set $gdb_init_phase=1
shell source ${BASH_DIR}/app/gdb/init/prepare_gdb_path.sh
source ${BASH_DIR}/app/gdb/init/loadPath.gdb
source ${BASH_DIR}/app/gdb/init/loadOptions.gdb
source ${BASH_DIR}/app/gdb/feature/load_features.gdb
source ${BASH_DIR}/app/gdb/init/loadAlias.gdb
source ${BASH_DIR}/app/gdb/init/loadTracepointCmd.gdb
source ${BASH_DIR}/app/gdb/feature/bp/load_sx_exception_signal.gdb
source ${BASH_DIR}/app/gdb/cmds/print_string_var_in_cur_function.py
source ${BASH_DIR}/app/gdb/feature/pretty_printer/register_verbose_cmd.py
source ${BASH_DIR}/app/gdb/cmds/print_sub_class_member.py
source ${BASH_DIR}/app/gdb/cmds/jump_to_line.py
source ${BASH_DIR}/app/gdb/feature/hook_step/setup_step_hook.gdb
# source ${BASH_DIR}/app/gdb/cmds/print_other_frame_var.py

# https://sourceware.org/gdb/onlinedocs/gdb/Convenience-Funs.html
if $_isvoid($cudagdb)==1
    source ${BASH_DIR}/app/gdb/init/loadWindowLayout.gdb
end

if $_shell("test -f ./project_init.gdb && echo 1 || echo 0") == 1
    echo "[gdb_init] found project_init.gdb, loading...";
    source ./project_init.gdb
else
    echo "[gdb_init] project_init.gdb not found in current directory.";
end

info auto-load

set $gdb_init_phase=2

echo
echo \r\nDone to load all init script.
echo \r\n\033[33m[prompt]: \033[32muse setting \033[37m' \033[31mset verbose\033[37m '\033[32m to enable gdb verbose mode.\033[37m
echo \r\n\033[33m[prompt]: \033[32muse cmd \033[37m' \033[31mlimit\033[37m '\033[32m to set array/string display size .\033[37m
echo \r\n\033[36m--------- leaving \033[35m${BASH_DIR}/app/gdb/gdb_init.gdb\033[37m ...
echo \r\n--------- leaving $env::HOME/.gdbinit ...\r\n\r\n
