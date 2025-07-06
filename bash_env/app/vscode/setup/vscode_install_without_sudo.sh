cd /local_vol1_nobackup/

vscodeBin=/local_vol1_nobackup/vscode-linux-x64
if [  ! -d "$vscodeBin"  ] ; then
    echo "no folder '$vscodeBin',create it ..."
    mkdir $vscodeBin    
fi

downloadFolder=/local_vol1_nobackup/xiaoshen/downloadedApps
vscodePackage=$downloadFolder/vs_code.tar.gz
if [  ! -r "$vscodePackage"  ] ; then        
    echo "no folder '$downloadFolder',create it ..."
    if [  ! -d "$downloadFolder"  ] ; then
        mkdir $downloadFolder
    fi
    echo "downloading vscode to $vscodePackage"
vsLink=https://az764295.vo.msecnd.net/stable/ee8c7def80afc00dd6e593ef12f37756d8f504ea/code-stable-x64-1633631666.tar.gz
    curl $vsLink  -o $vscodePackage
fi

cd $vscodeBin
echo "unpack $vscodePackage to $vscodeBin"
tar -C $vscodeBin -zxvf $vscodePackage
echo "create soft link in system-known path '/home/xiaoshen/linuxScript/bin/vscodeSoftLink' "
ln -s $vscodeBin/bin/code   /home/xiaoshen/linuxScript/bin/vscodeSoftLink
echo "create alias to start vscode quickly"
alias code='$vscodeBin/bin/code --extensions-dir ~/xiaoshen/linuxVscode/extensions --user-data-dir ~/xiaoshen/linuxVscode/vscode_user_data'

echo "Done to install vscode on linux system without sudo"

