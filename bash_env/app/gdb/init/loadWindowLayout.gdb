# bash_script_i

# https://ftp.gnu.org/old-gnu/Manuals/gdb/html_chapter/gdb_19.html
# cuda gdb dones't support below options. need to check where it is cuda gdb if enable them

# layout asm
# enable source mode to view realtime source code
# layout src

# cudagdb is defined in $env::HOME/bash_env/app_init/cuda-gdbinit
if $_isvoid($cudagdb)==1      
    # set window border split-line
    set tui border-kind ascii

    # set active window border style
    set tui active-border-mode bold

    # set non-active window border style
    set tui border-mode normal
else
    echo \033[36m[cuda gdb] \033[35mset tui option is disabled becaused no support in cuda gdb. \033[37m \r\n
end

# bash_script_o