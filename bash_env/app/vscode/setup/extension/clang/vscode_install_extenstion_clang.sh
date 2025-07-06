bash_script_i
echo

# NOTE : this extension might cause vscode performance issue
#        https://github.com/microsoft/vscode/wiki/Performance-Issues#consuming-cpu
# https://confluence.nvidia.com/display/NSWX/Visual+Studio+Code+Setup
# IntelliSense cache
# see vscode setting : ctrl+, -> Intelli Sense Cache Path -> remote
export XDG_CACHE_HOME="${TEMP_DIR}/cache/vscode"
[[ ! -d "${XDG_CACHE_HOME}" ]] && mkdir -p "${XDG_CACHE_HOME}"

# enable clang in cmake build suite
export CMAKE_EXPORT_COMPILE_COMMANDS=1
# it can be enable by below way 
# 1. cmake -DCMAKE_EXPORT_COMPILE_COMMANDS=1 /path/to/src ...
# 2. in CMakeLists.txt
#    set(CMAKE_EXPORT_COMPILE_COMMANDS ON)

code --force --install-extension   llvm-vs-code-extensions.vscode-clangd
# https://confluence.nvidia.com/display/GCA/Lifehacks+for+Compute+Arch+Engineers+in+China#LifehacksforComputeArchEngineersinChina-MSVSCodetips
# code --force --install-extension   llvm-vs-code-extensions.vscode-clangd    # clangd , can open file quickly by relative path. need cmake option : -DCMAKE_EXPORT_COMPILE_COMMANDS=1
#                                                                               Intelli Sense Engine , it is better than MS Intelli Sense Engine
# merge below config into setting.json
# menu File → Preferences → Settings
# ${BASH_DIR}/app/vscode/setup/extension/clang/settings_clang.json

# https://confluence.nvidia.com/display/TegraGraphics/VS+Code+useful+tips
# download clangd from : https://github.com/clangd/clangd/releases/tag/14.0.3
# e.g. https://github.com/clangd/clangd/releases/download/snapshot_20231210/clangd-linux-snapshot_20231210.zip
# ln -s  ${BASH_DIR}/app/vscode/setup/extension/clang/config.yaml         $HOME/.config/clangd/config.yaml

# If clangd reports "too many errors emitted, stopping now" error messages in VSCode, create a .clangd file in your workspace
# ln -s ${BASH_DIR}/app/vscode/setup/extension/clang/.clangd   <workspace>/.clangd


echo
bash_script_o
