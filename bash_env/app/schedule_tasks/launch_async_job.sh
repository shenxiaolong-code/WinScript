bash_script_i

source ${BASH_SOURCE[0]%/*}/schedule_job_by_crontab.sh


# background job is sub-process, it can't access the parent process's env variable , so the delay_start_launch might can't run correctly.
# here we use the sync way to run the delay_start_launch.sh befor fixing this issue
# (sleep 60 &&  source ${BASH_SOURCE[0]%/*}/delay_start_launch.sh  ) & > /dev/null   2>&1
dumpinfox  "async load :${brown} ${BASH_SOURCE[0]%/*}/delay_start_launch.sh "
source ${BASH_SOURCE[0]%/*}/delay_start_launch.sh

bash_script_o
