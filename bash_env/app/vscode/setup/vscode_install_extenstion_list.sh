bash_script_i
echo

# extension is lesser, the more stable.
# ${BASH_DIR}/app/vscode/bin/vscode_install_extenstion_list.sh
# search extension by rating
# <ext_name> @sort:rating

# below command MUST be run inside a Visual Studio Code terminal 
# code --list-extensions 

# write vscode extension
# ${EXT_DIR}/vscode_space/vscode_server/extensions/seanmcbreen.mdtools-1.0.1
# ${EXT_DIR}/vscode_space/vscode_server/extensions/xiaolongs.first_extension-0.1

# 1. MUST
# read and edit
code --install-extension  eamodio.gitlens                                   # git repo helper, copy remote file URL
code --install-extension  ms-vscode.notepadplusplus-keybindings             # notepad++ shortcut,  e.g. column edit , copy ...
code --install-extension  alefragnani.Bookmarks                             # linux remote  , bookmark
# C++ development
code --install-extension  ms-vscode.cpptools                               # C/C++ IntelliSense, debugging, and code browsing..  cppdbg  -- which is needed
code --install-extension  ms-vscode.cpptools-themes
code --install-extension  GitHub.copilot                                    # AI code assistant , https://marketplace.visualstudio.com/items?itemName=GitHub.copilot

# 2. optional
code --install-extension  vscode-icons-team.vscode-icons                    # show different color icon for different type file.
code --install-extension  buuug7.chinese-punctuation-to-english             # covert chinese-punctuation-to-english

# 3. tryable
source ${BASH_DIR}/app/vscode/setup/extension/clang/vscode_install_extenstion_clang.sh      # possible vscode persormance issue


# 4. additional
code --install-extension  twxs.cmake                                        # use this cmake extension , instead of ms-vscode.cmake-tools
code --install-extension  vscode-icons-team.vscode-icons                    # show different color icon for different type file.
code --install-extension  tomoki1207.pdf                                    # vscode pdf viewer

code --install-extension  eightHundreds.vscode-mindmap                      # vscode mindmap
code --install-extension  buuug7.chinese-punctuation-to-english             # covert chinese-punctuation-to-english


# code --install-extension  ms-vscode.cmake-tools
# code --install-extension  ms-vscode.cpptools-themes
# code --install-extension  ms-vscode.cpptools-extension-pack               # suite = C++ + cmake + themes , not suggested
# code --install-extension  ms-vscode.cpptools                              # MS C++ recommended extension.
# code --install-extension  ms-vscode-remote.remote-ssh                     # it will be installed automaticall when open a remote-ssh machine.
# code --install-extension  ms-python.python                                # cause terminal issue : fork: retry: Resource temporarily unavailable

# code --install-extension  wwm.better-align
# code --install-extension  samuelcolvin.jinjahtml                          # .j2 file parsel
# code --install-extension  ryu1kn.partial-diff                             # diff  , use vscode diff is better.
# code --install-extension  nvidia.nsight-vscode-edition                    # cuda gdb support.
# code --install-extension  kriegalex.vscode-cudacpp                        # cuda plugin
# code --install-extension  johnstoncode.svn-scm                            # svn plugin
# code --install-extension  jerrygoyal.shortcut-menu-bar                    # customizwd cmd buttons
# code --install-extension  jeff-hykin.better-cpp-syntax
# code --install-extension  eg2.vscode-npm-script                           # npm package manager tools
# code --install-extension  donjayamanne.githistory
# code --install-extension  cschlosser.doxdocgen
# code --install-extension  coolchyni.beyond-debug                          # GDB(beyond) , maybe conflict
# code --install-extension  christian-kohler.npm-intellisense               # npm-intellisense
# code --install-extension  betwo.vscode-linux-binary-preview               # binary preview
# code --install-extension  alefragnani.read-only-indicator                 # read-only extension to avoid modify by mistake.
# code --install-extension  HyunKyunMoon.gzipdecompressor                   # zip file unpack tool
# code --install-extension  shakram02.bash-beautify                         # auto format bash script
# code --install-extension  fabiospampinato.vscode-highlight                # hight paintext file context (.txt)
# code --install-extension  alefragnani.read-only-indicator                 # read-only extension to avoid modify by mistake.
# code --install-extension  ajshort.include-autocomplete                    # C++ #include autocomplete
# code --install-extension  DamianKoper.gdb-debug                           # gdb  , maybe conflict


echo
bash_script_o
