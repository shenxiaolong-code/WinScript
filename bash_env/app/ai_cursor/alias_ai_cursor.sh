#!/bin/bash

bash_script_i

# nv cursor codebase lie in :
cursor_codebase_dir=${EXT_DIR}/vscode_space/empty_workspace
# add any folder or files to the codebase to speedup the ai cursor
# ${EXT_DIR}/vscode_space/empty_workspace/.nvcode.json

function init_cursor_codebase() {
    local tmp_codebase_dir="$(realpathx "${1:-${cursor_codebase_dir}}")"
    if [[ ! -d "$tmp_codebase_dir" ]]; then
        dumpkey tmp_codebase_dir
        dumperr "Directory does not exist: $tmp_codebase_dir"
        return 1
    fi
    [[ ! -d "$tmp_codebase_dir/.cursor"       ]] && ln -s "${BASH_DIR}/app/ai_cursor/cursor_config/cursor" "$tmp_codebase_dir/.cursor"
    [[ ! -f "$tmp_codebase_dir/.cursorignore" ]] && ln -s "${BASH_DIR}/app/ai_cursor/cursor_config/cursorignore" "$tmp_codebase_dir/.cursorignore"
    echo "$tmp_codebase_dir/.cursor"
    echo "$tmp_codebase_dir/.cursorignore"
}

# Initialize nvcode directory if not exists
function init_nvcode_dir() {
    # Create base directories if they don't exist
    mkdir -p ~/.nvcode/context
    
    # Initialize workspace.json if it doesn't exist, with empty folders array
    if [[ ! -f ~/.nvcode/workspace.json ]]; then
        echo '{"folders":[]}' > ~/.nvcode/workspace.json
    fi
    
    # Initialize context index if it doesn't exist
    if [[ ! -f ~/.nvcode/context/index.json ]]; then
        echo '{"version":1,"metadata_config":{},"items":[]}' > ~/.nvcode/context/index.json
    fi
    show_all_codebase
}

function clean_all_codebase()
{   
    # Initialize nvcode directory
    init_nvcode_dir
    
    # Clean the context directory
    rm -rf ~/.nvcode/context/*
    
    # Reinitialize the index file
    echo '{"version":1,"metadata_config":{},"items":[]}' > ~/.nvcode/context/index.json
    
    # Clean the workspace file - initialize with empty folders array
    echo '{"folders":[]}' > ~/.nvcode/workspace.json
    
    echo "All codebase context has been cleaned"
    show_all_codebase
}

function add_a_folder_to_codebase()
{
    dumpinfox "${1}"
    local folder_path="$1"
    
    # Check if folder exists
    if [[ ! -d "$folder_path" ]]; then
        echo "Error: Directory does not exist: $folder_path"
        return 1
    fi

    # Initialize nvcode directory
    init_nvcode_dir
    
    # Get absolute path
    folder_path=$(realpathx "$folder_path")
    
    # Add new folder to workspace
    local tmp_file=$(mktemp)
    jq --arg path "$folder_path" '.folders += [{"path": $path}]' ~/.nvcode/workspace.json > "$tmp_file"
    mv "$tmp_file" ~/.nvcode/workspace.json
    
    echo "Added folder to codebase: $folder_path"
    show_all_codebase
}

function show_all_codebase() {
    # Check if nvcode directory exists
    if [[ ! -d ~/.nvcode ]]; then
        echo "No codebase found: ~/.nvcode directory does not exist"
        return 1
    fi

    # Read workspace configuration
    if [[ ! -f ~/.nvcode/workspace.json ]]; then
        echo "No workspace configuration found"
        return 1
    fi

    echo -e "\nCurrent Codebase Folders (from ~/.nvcode/workspace.json):"
    echo "=================================================="
    # Display all folders from workspace.json
    jq -r '.folders[].path' ~/.nvcode/workspace.json | while read -r path; do
        if [[ -d "$path" ]]; then
            echo "📁 $path"
        else
            echo "❌ $path (not found)"
        fi
    done
    echo
}

alias initai=init_cursor_codebase
alias addai=add_a_folder_to_codebase
alias cleanai=clean_all_codebase
alias lai=show_all_codebase
alias cdai='cd ~/.nvcode ; lp ;'

bash_script_o
