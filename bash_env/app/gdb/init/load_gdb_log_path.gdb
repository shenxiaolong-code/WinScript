echo \r\n+++++++++ loading ${BASH_DIR}/app/gdb/init/load_gdb_log_path.gdb ...\r\n
# set log file path first, then log on
# The default logfile is gdb.txt.
# set logging file ${BASH_DIR}/app/gdb/test/gdb_log_`date +"%Y%m%d_%I%M_%p".log`
# set logging on

# shell datetime=$(date '+%Y%m%d_%H%M%S')
# shell pid=$$
# shell logfile="/path/to/your/log/directory/gdb_log_${pid}_${datetime}.txt"


echo \033[33mgdb log folder \033[37m : \033[32m${EXT_DIR}/tmp/cache/gdb_tmp/\033[37m \r\n

# shell script defect : shell script <scipt>.sh is async in other process, it can't grante that script is finished after next line

# source ${EXT_DIR}/tmp/cache/gdb_tmp/gdb_log_file.gdb
source ${BASH_DIR}/app/gdb/init/load_gdb_log_path.py
set_log_path

# define ilog
#    echo ${EXT_DIR}/tmp/cache/gdb_tmp/gdb_log.txt\r\n
#    echo ${EXT_DIR}/tmp/cache/gdb_tmp/gdb_history.txt\r\n
# end
# 
# document ilog
# 	print log and history cmd file path.
# end

# gdb core.3599 -ex bt -ex quit 2>&1   |  tee    ${BASH_DIR}/app/gdb/gdb_log.txt
# The behaviour of fflush( NULL ) is well-defined as flushing all output streams
# call fflush(0)  : flush log file immediately. ( refresh log )

# bash_script_o