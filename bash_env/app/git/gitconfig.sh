bash_script_i
echo

# https://blog.csdn.net/qfturauyls/article/details/109371860
# https://askubuntu.com/questions/651166/best-alternative-for-winmerge

# or open config file  : git config --global -e

# --prune: delete remote branch that has been deleted when sync with remote repo
git config --global fetch.prune true

# --rebase: rebase the current branch on top of the upstream branch after fetching
git config --global pull.rebase true

# fix whitespace issues
git config --global apply.whitespace fix
# 配置 git 对所有操作都检查空白字符 
git config --global core.whitespace trailing-space,space-before-tab 

# no unecessary git warning : warning: skipped previously applied commit e4fe3a0eee
git config --global advice.skippedCherryPicks false

# enable rerere to avoid duplicate commit
git config --global rerere.enabled true
# git rerere clear 

# use vscode as default editor
git config --global core.editor "cursor --wait"

# use vscode as default compare tool
git config --global diff.tool vscode
git config --global difftool.vscode.cmd "cursor --wait --diff $LOCAL $REMOTE"

# use vscode plugin diffmerge as the git diff tool
# cursor --install-extension  aaghabeiki.gitdiffer                          # git differ

# git config --global diff.tool diffmerge
# git config --global difftool.diffmerge.cmd diffmerge "$LOCAL" "$REMOTE"

# git config --global diff.tool myDIff
# git config --global difftool.myDIff.cmd '/usr/bin/diff "$LOCAL" "$REMOTE"'

# git config --global merge.tool diffmerge
# git config --global mergetool.diffmerge.cmd diffmerge --merge --result="$MERGED" "$LOCAL" "$(if test -f "$BASE"; then echo "$BASE"; else echo "$LOCAL"; fi)" "$REMOTE"
# git config --global mergetool.diffmerge.trustexitcode true

# disable ssl verification
# fix : error setting certificate verify locations:  CAfile: /etc/pki/tls/certs/ca-bundle.crt CApath: none
git config --global http.sslverify false

# don't wrap long lines
# git config --global --get core.pager
# git config --global core.pager 'less -S'
git config --global pager.branch 'less -S'

echo
bash_script_o


# git config --global --add       safe.directory  ${EXT_DIR}/repo/dkg_root/dynamic-kernel-generator
# git config --global --unset-all safe.directory


