
echo  +++++++++ loading ${BASH_DIR}/app/gdb/cuda_gdb/loadAlias_cudagdb.gdb ...\r\n

# https://stackoverflow.com/questions/6683721/check-global-device-memory-using-cuda-gdb
define pd
   # print ((@global double *)dst)[0]@3
   echo print ((@global double *)$arg0)[0]@$arg1  \r\n
   print ((@global double *)$arg0)[0]@$arg1
end
document pd
   print cuda device memory by double
end

define pda
   # p *(double (*)[4][5])0x7fffffffb050
   echo format :
   echo \r\np *(double (*)[4][5])0x7fffffffb050
end
document pda
   print memory by matrix
end


# bash_script_o

