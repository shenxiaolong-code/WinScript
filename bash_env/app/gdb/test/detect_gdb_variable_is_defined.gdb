
# https://unix.stackexchange.com/questions/492768/gdb-customize-command-how-to-test-whether-a-variable-is-set

set $foo="abd"
p $foo

set $iInt=3
p $iInt

set $iVar=appVariable
p $iVar

p $_isvoid($iInt)
$3 = 0x0
p $_isvoid($iInt1)
$4 = 0x1

if $_isvoid($iInt1)==0  
    echo "variable iInt1 is defined"
else 
    echo "variable iInt1 is NOT defined"
end

set $v = 1
print $_isvoid($v)
print $_isvoid($v2)

# _gdb_major is new built-in variable in gdb 9.0
if $_isvoid($_gdb_major)==1
    echo \r\ncurrent gdb version is lesser than gdb 9.0 \r\n
else
    echo \r\ncurrent gdb version is greanter or queal than gdb 9.0.\r\n
end

