
# https://blog.csdn.net/qfturauyls/article/details/109371860
# or edit : ~/.gitconfig

# use vscode plugin diffmerge as the git diff tool
# code --install-extension  aaghabeiki.gitdiffer                          # git differ

# git config --global diff.tool diffmerge
# git config --global difftool.diffmerge.cmd diffmerge "$LOCAL" "$REMOTE"

# git config --global diff.tool myDIff
# git config --global difftool.myDIff.cmd '/usr/bin/diff "$LOCAL" "$REMOTE"'

# git config --global merge.tool diffmerge
# git config --global mergetool.diffmerge.cmd diffmerge --merge --result="$MERGED" "$LOCAL" "$(if test -f "$BASE"; then echo "$BASE"; else echo "$LOCAL"; fi)" "$REMOTE"
# git config --global mergetool.diffmerge.trustexitcode true