bash_script_i
echo

tmp_src_repo=$1
# tmp_src_repo=${EXT_DIR}/repo/dkg_root/libcheck
tmp_dst_repo=$2
# tmp_dst_repo=${EXT_DIR}/repo/dkg_root/L1_libcheck_cfk_20174



[[ ! -d $tmp_src_repo || ! -d $tmp_dst_repo ]]  &&  { dumperr "src or dst folder is not exist" ; return 1 ; }
is_same_path $tmp_src_repo  $tmp_dst_repo       &&  { dumperr "src/dst folder is same"         ; return 2 ; }

function copy_file_between_different_worktree() {     
    [[ ! -f $tmp_src_repo/$1 ]]          && dumperr "[src] file $tmp_src_repo/$1 is not exist"    && return 1
    [[ ! -f $tmp_dst_repo/$1 ]]          && dumperr "[dst] file $tmp_dst_repo/$1 is not exist"    && return 2    

    cp $tmp_src_repo/$1 $tmp_dst_repo/$1
    echo $tmp_dst_repo/$1
}

 # git status -uno -u --porcelain
git status -uno -u --porcelain -s | grep -oP ' .*' | sed 's#^ *##'  | pipe_callback  copy_file_between_different_worktree

 #  copy_file_between_different_worktree cask/CMakeLists.txt
 #  copy_file_between_different_worktree frameworks/cutlass3x/CMakeLists.txt
 #  copy_file_between_different_worktree tools/releases/CMakeLists.txt


echo
bash_script_o
