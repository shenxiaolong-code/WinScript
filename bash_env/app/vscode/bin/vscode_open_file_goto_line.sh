

# https://sourceware.org/gdb/onlinedocs/gdb/Shell-Commands.html

# ${HOME}/scratch_1/vscode_space/.vscode-server/bin/6261075646f055b99068d3688932416f2346dd3b/bin/remote-cli/code  --goto ${HOME}/scratch_1/repo/cask_sdk_dbg/cask_core/tools/tester/src/debug.cpp:80

echo "[NOTE] code command MUST run in computelab-303 host terminal."
# the gdb must run on 303 machine
# echo code  --goto ${HOME}/scratch_1/repo/cask_sdk_dbg/cask_core/tools/tester/src/debug.cpp:80

# in gdb debug session :
# | frame 0 | grep ":" > ${EXT_DIR}/temp/gdb_cmd_output.txt
# !source ${HOME}/bash_env/app/vscode/bin/vscode_open_file_goto_line.csh
# echo\r\n

echo "From : ${HOME}/bash_env/app/vscode/bin/vscode_open_file_goto_line.csh"
echo "example of gdb command output => shell script input"
line=`cat ${EXT_DIR}/temp/gdb_cmd_output.txt | sed 's#.*/home#/home#g'`
echo ${line}
echo 


