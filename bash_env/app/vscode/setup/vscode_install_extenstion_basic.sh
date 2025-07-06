
bash_script_i
echo
# extension is lesser, the more stable.
# ide is code or cursor

# below command MUST be run inside a Visual Studio Code terminal
# ide --list-extensions
# ide --uninstall-extension ms-vscode.cpptools

#  issue : fork: retry: Resource temporarily unavailable
# see : ${BASH_DIR}/app/vscode/bin/vscode_troubleshoot.txt

# Recommended plugins
# https://confluence.nvidia.com/pages/viewpage.action?pageId=3138206030

# 1. MUST
# remote-ssh suite
# ide --install-extension  ms-vscode-remote.remote-ssh
ide --install-extension  ms-vscode-remote.remote-ssh-edit

# read and edit
ide --install-extension  ms-vscode.notepadplusplus-keybindings             # notepad++ shortcut,  e.g. column edit , copy ...
ide --install-extension  alefragnani.Bookmarks                             # linux remote  , bookmark

# version control
ide --install-extension  eamodio.gitlens                                   # git repo helper, copy remote file URL
ide --install-extension  GitLab.gitlab-workflow                            # integrate with JIRA , MR feature

# C++ development
ide --install-extension  ms-vscode.cpptools                                # C/C++ IntelliSense, debugging, and code browsing..  cppdbg  -- which is needed
ide --install-extension  ms-vscode.cpptools-themes

# python development
ide --install-extension  ms-python.python                                  # python development
ide --install-extension  ms-python.debugpy                                 # python debug

# AI assistant
ide --install-extension  GitHub.copilot                                    # AI code assistant , https://marketplace.visualstudio.com/items?itemName=GitHub.copilot
ide --install-extension  GitHub.copilot-chat                               # paied version of copilot

# llvm + mlir development
ide --install-extension  llvm-vs-code-extensions.vscode-clangd             # https://marketplace.visualstudio.com/items?itemName=llvm-vs-code-extensions.vscode-clangd
                                                                           # conflict with MS intelliSense, disable MS C/C++ extension : "C_Cpp.intelliSenseEngine": "disabled",
ide --install-extension  llvm-vs-code-extensions.vscode-mlir               # mlir development

# nvidia tabnine (current the license is not enogh)
# server url : https://tabnine-poc.hwinf-scm-aws.nvidia.com
# ide --install-extension  TabNine.tabnine-vscode-self-hosted-updater

# alefragnani.bookmarks
# cameron.vscode-pytest
# eamodio.gitlens
# eighthundreds.vscode-mindmap
# github.copilot
# github.copilot-chat
# llvm-vs-code-extensions.vscode-clangd
# llvm-vs-code-extensions.vscode-mlir
# matepek.vscode-catch2-test-adapter
# ms-python.debugpy
# ms-python.python
# ms-python.vscode-pylance
# ms-vscode.cpptools
# ms-vscode.cpptools-themes
# ms-vscode.notepadplusplus-keybindings
# streetsidesoftware.code-spell-checker
# undefined_publisher.nv-code

# install nvcode extension from local file
# guide   : https://confluence.nvidia.com/display/NLLMS/NVCode+Installation
#           https://nvcode.nvidia.com/docs/get-started/quickstart
# downoad : https://confluence.nvidia.com/display/NLLMS/Releases
#           https://nvcode.nvidia.com/assets/downloads/nv-code-1.5.0.vsix.zip
# install : ide --install-extension  C:\temp\nv-code-1.4.0.vsix
# get key : https://org.ngc.nvidia.com/setup/personal-keys
#           select 'Cloud Functions'
# nvcode-20241114  : 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
# ctrl+shift+p -> nvcode: sign in -> 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


bash_script_o
