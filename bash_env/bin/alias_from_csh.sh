bash_script_i
echo
# define same alias from .csh script

# cat $1 | grep "^alias" | grep -v ".csh" | grep -v "\!:1" | sed 's/#.*//g'  | sed 's/alias \+\([^ ]\+\) \+/alias \1=/g' # | sed 's/\\!:1//g'

# cat $1 | remove comment line | remove source .csh script | remove parameter line in aliash | remove commnet at line tail | refact bash alias command from csh alias
# cat $1 | grep "^alias" | grep -v ".csh" | grep -v "\!:1" | sed 's/#.*//g'  | sed 's/alias \+\([^ ]\+\) \+/alias \1=/g'

shFilePath=$2
if [[ "${shFilePath}" == "" ]]; then
    shFilePath=$( echo $1|sed 's#.*/#${EXT_DIR}/temp/#g'|sed 's/.csh/.sh/g' )
fi

echo "# source ${EXT_DIR}/_my_bash/bin/alias_from_csh.sh      $1"  | tee ${shFilePath}
echo " " >> ${shFilePath}

cat $1 | grep "^alias" | grep -v ".csh" | grep -v "\!:1" | grep "\`"     | sed 's/=`/=$(/' | sed 's/`/)/' | sed 's/#.*//g'  | sed 's/alias \+\([^ ]\+\) \+/alias \1=/g' >> ${shFilePath}
cat $1 | grep "^alias" | grep -v ".csh" | grep -v "\!:1" | grep -v "\`"  | sed 's/alias \+\([^ ]\+\) \+/alias \1=/g' >> ${shFilePath}

echo
cat  ${shFilePath}
# source ${shFilePath}

echo
echo "from : $1"
echo "to   : ${shFilePath}"

# cat a.txt | xargs -d $'\n' sh -c 'for arg do command1 "$arg"; command2 "$arg"; ...; done' 
# cat $1 | grep "^alias" | grep -v ".csh" | grep -v "\!:1" | sed 's/#.*//g'  | sed 's/alias \+\([^ ]\+\) \+/alias \1=/g' | xargs -d $'\n' sh -c '$arg'

echo
bash_script_o
