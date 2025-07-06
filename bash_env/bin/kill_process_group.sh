#!/bin/bash
bash_script_i

DRY_RUN=${DRY_RUN:-1}    # default to dry run mode

function generate_procss_file() {
    local filter_pattern=$1
    local output_file="${2:-${TEMP_DIR}/to_del/kill_process_list_$(date '+%Y%m%d_%H%M%S').txt}"
    
    ps -f | grep -E "$filter_pattern" | grep -v "grep" | grep -v $$  > "$output_file"
    [[ -s "$output_file" ]] && echo "$output_file"
}

function kill_processs_from_file() {
    local input_file=$1
    dumpinfo "process file: $input_file"
    [[ $DRY_RUN -eq 1 ]] && cat "$input_file"
    
    declare -A child_pids parent_pids
    
    # Only process lines that match the standard ps output format
    while read -r _ pid ppid _; do
        child_pids[$ppid]="${child_pids[$ppid]} $pid"
        parent_pids[$pid]=$ppid
    done < <(grep -E "^[a-zA-Z0-9+_-]+[[:space:]]+[0-9]+[[:space:]]+[0-9]+" "$input_file")

    # Check if we found any valid processes
    [[ ${#parent_pids[@]} -eq 0 ]] && {
        echo "No valid processes found in $input_file" >&2
        return 1
    }

    # Kill leaf processes first (those without children)
    for pid in "${!parent_pids[@]}"; do
        # Skip if this process has children
        [[ -z "${child_pids[$pid]}" ]] && {
            if [[ $DRY_RUN -eq 1 ]]; then
                echo "[DRY-RUN] graceful exit process :${brown} kill -15 $pid ${end} or force kill :${brown} kill -9 $pid ${end} ( PPID: ${parent_pids[$pid]} )"
            else
                echo "Killing process: $pid (PPID: ${parent_pids[$pid]})"
                kill -15 "$pid" 2>/dev/null
            fi
        }
    done
}

function kill_processs_from_pattern() {
    local file_path=$(generate_procss_file "$1")
    [[ -n "$file_path" ]] && kill_processs_from_file "$file_path"
}

# process_example.txt example
# $ ps
# UID          PID    PPID  C STIME TTY          TIME CMD
# xiaolon+  848898       1  0 Feb17 ?        00:00:11 docker run --runtime=nvidia -u 45406:30 -v /tmp/tmp.hygskMMF3T:/etc/passwd -v /tmp/tmp.QdlYRZ5wub:/etc/group --
# xiaolon+ 1492262 1492228  0 Feb17 ?        00:01:13 ${HOME}/.cursor-server/cursor-f5f18731406b73244e0558ee7716d77c8096d150 command-shell --cli-data-dir /ho
# xiaolon+ 1492408 1492262  0 Feb17 ?        00:00:00 sh ${HOME}/.cursor-server/cli/servers/Stable-f5f18731406b73244e0558ee7716d77c8096d150/server/bin/cursor
# xiaolon+ 1492412 1492408  0 Feb17 ?        00:02:21 ${HOME}/.cursor-server/cli/servers/Stable-f5f18731406b73244e0558ee7716d77c8096d150/server/node /home/xi
# xiaolon+ 1492489 1492412  0 Feb17 ?        00:02:41 ${HOME}/.cursor-server/cli/servers/Stable-f5f18731406b73244e0558ee7716d77c8096d150/server/node /home/xi
# xiaolon+ 1492566 1492412  0 Feb17 ?        00:00:54 ${HOME}/.cursor-server/cli/servers/Stable-f5f18731406b73244e0558ee7716d77c8096d150/server/node /home/xi
# xiaolon+ 1492613 1492412  0 Feb17 ?        00:08:06 ${HOME}/.cursor-server/cli/servers/Stable-f5f18731406b73244e0558ee7716d77c8096d150/server/node --dns-re
# xiaolon+ 1493334 1492613  0 Feb17 ?        00:00:03 ${HOME}/.cursor-server/cli/servers/Stable-f5f18731406b73244e0558ee7716d77c8096d150/server/node /home/xi
# xiaolon+ 1494295 1492613  0 Feb17 ?        00:00:41 ${HOME}/.cursor-server/cli/servers/Stable-f5f18731406b73244e0558ee7716d77c8096d150/server/node /home/xi
# xiaolon+ 1494590 1492613  0 Feb17 ?        00:00:01 ${HOME}/.cursor-server/extensions/ms-python.python-2024.12.3-linux-x64/python-env-tools/bin/pet server
# xiaolon+ 1494946 1492489  0 Feb17 pts/95   00:00:00 /usr/bin/bash --init-file ${HOME}/.cursor-server/cli/servers/Stable-f5f18731406b73244e0558ee7716d77c809
# xiaolon+ 1495214 1492613  0 Feb17 ?        00:06:18 ${HOME}/.cursor-server/cli/servers/Stable-f5f18731406b73244e0558ee7716d77c8096d150/server/node /home/xi

function tc_kill_process() {
    # case 1: dry run mode
    echo "Test Case 1: Dry Run Mode"
    DRY_RUN=1 kill_processs_from_file "./process_example.txt"

    # case 2: do kill mode
    echo -e "\nTest Case 2: Do Kill Mode"
    DRY_RUN=1 kill_processs_from_pattern "/.cursor-server/"
}

function main_kill_process() {
    if [[ $# -lt 1 ]]; then
        echo "Usage: $0 <pattern|file>"
        return 1
    fi
    if [[ -f $1 ]]; then
        kill_processs_from_file "$1"
    else
        kill_processs_from_pattern "$1"
    fi
}

main_kill_process "$@"
# tc_kill_process

bash_script_o