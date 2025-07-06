


# parse info line xxxx output

echo
echo "+++++++++++++++++++++++++++++++ parse_info_line.sh +++++++++++++++++++++++++++++++++++++++++++++"
echo "/home/scratch.xiaolongs_gpu/temp/info_line.txt"
cat /home/scratch.xiaolongs_gpu/temp/info_line.txt | grep "at address"
echo "**************************************************************************************************************"
# cat /home/scratch.xiaolongs_gpu/temp/info_line.txt | tail -n 24 | egrep "^Line" | sed 's#Line \(.*\) of "\(.*\)"#\2:\1\n#g' | sed 's# at /#\n/#g' | sed 's#^.*<##g'  | sed 's#>.*##g' | grep -v "+" | sed 's#^\([^/]\)#\n\1#'

# cat /home/scratch.xiaolongs_gpu/temp/info_line.txt | grep "at address"  | sed 's# at /.*##g' # | sed 's#and.*##g' | cut -c18- | sed 's#..$##g' | uniq 
# cat /home/scratch.xiaolongs_gpu/temp/info_line.txt | grep "is at address"  | sed 's#is at address.*##g'
cat /home/scratch.xiaolongs_gpu/temp/info_line.txt | grep "is at address"  | sed 's#is at address.*##g' | sed 's#Line \(.*\) of "\(.*\)"#type declare : \2:\1#g' 

cat /home/scratch.xiaolongs_gpu/temp/info_line.txt | grep "starts at address"  | sed 's#.*address##g' | sed 's#and.*##g' | cut -c18- | sed 's#..$##g' | uniq 

echo "${BASH_DIR}/app/gdb/feature/parse_cmd_output/parse_info_line.sh" | sed 's#^#\n#'
# echo "/home/scratch.xiaolongs_gpu/temp/gdb_log.txt"
echo "/home/scratch.xiaolongs_gpu/temp/info_line.txt"
echo "---------------------------- parse_info_line.sh ---------------------------------------------------"

