bash_script_i

# usage : source commit_my_svn_update.csh  10.19.228.200

if ( -d "./.svn/" ) then
    echo "update my svn repo url because my svn server IP is changed ..."
    set rel_path="`svn info | grep 'Relative URL' | sed 's#.*^##' `"
    if ( $?debug ) echo "${purple}[debug]${green}rel_path${end}=${red}${rel_path}${end}"

    set srv_url="`svn info | grep 'Repository Root:' | sed 's#.*/svn/#https://$1/svn/#' `"
    if ( $?debug ) echo "${purple}[debug]${green}srv_url${end}=${red}${srv_url}${end}"

    echo svn relocate ${srv_url}${rel_path}  --username 'xlshen' --password 'aaAA11!!'  # --non-interactive  --no-auth-cache
    # svn relocate ${srv_url}${rel_path}  --username 'xlshen' --password 'aaAA11!!' # --non-interactive --no-auth-cache

    # svn relocate https://10.19.228.84/svn/work/linuxPratice/linuxScript  --username 'xlshen' --password 'aaAA11!!' --non-interactive --no-auth-cache

    echo
    svn info ;
else
    echo "current folder is not a svn repo folder!"
endif


bash_script_o
