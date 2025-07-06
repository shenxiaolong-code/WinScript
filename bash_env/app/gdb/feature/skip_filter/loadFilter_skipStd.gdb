# bash_script_i
# Note : skip without arguments will skip current function, it is useful.

if  0
    skip -gfi c++/*
else
    skip file shared_ptr_base.h
    skip file shared_ptr.h
    skip file unique_ptr.h
    skip file stl_vector.h
    skip file stl_map.h
    skip file allocator.h
    skip file stl_iterator.h
    skip file functional
    skip file move.h
    skip file stl_pair.h
    skip file basic_string.h    
    skip file stl_set.h
    skip file ostream
    skip file sstream
    skip file regex.h
end

if $_isvoid($_gdb_major)==0    
    # https://stackoverflow.com/questions/5676241/tell-gdb-to-skip-standard-files
    # https://sourceware.org/gdb/onlinedocs/gdb/Skipping-Over-Functions-and-Files.html
    echo \033[32m skip -gfi : ${EXT_DIR}/myDepency/src_in_docker \033[33m \033[37m
    #  skip -gfi c++/*    
    #  skip -rfu ^std::(allocator|basic_string)<.*>::~?\1 *\(
    #  skip -rfu ^std::([a-zA-z0-9_]+)<.*>::~?\1 *\(
    #  skip -rfu std::.*    
    #  skip -rfu operator.*
    #  skip -rfu .*::Instance
    #  skip -function "operator new"
else
    # only support file and function without wildchars in gdb 7.x    
    # skip function 
end 

# To skip all .h files in /usr/include/c++/9/bits
# skip -gfi /usr/include/c++/9/bits/*.h

# To skip the file /usr/include/c++/9/bits/stl_vector.h
# skip file /usr/include/c++/9/bits/stl_vector.h

# To skip all .h files in /usr/include/c++/9/bits
# skip -gfi /usr/include/c++/9/bits/*.h

echo \r\n--------- leaving ${BASH_DIR}/app/gdb/feature/skip_filter/loadFilter_skipStd.gdb ...\r\n
