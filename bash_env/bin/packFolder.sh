bash_script_i
echo

# md cuda-gpgpu-31256743
# tar -zxvf cuda-gpgpu-31256743.tgz -C ./cuda-gpgpu-31256743

tgzFolder=$1
tgzFile=zip_`echo $tgzFolder | sed 's#.*/##g'`.zip
echo $tgzFolder

if [ -f "$tgzFile" ] ; then
    echo "deleting existing '$tgzFile' ... "
    rm "$tgzFile"
fi


# tar -zcvf myfolder.tar.gz myfolder
# tar -zcvf "${tgzFile}"  "${tgzFolder}"

# zip -r temp.zip Documents
zip -r "${tgzFile}" "${tgzFolder}"

echo
echo "Done to pack : $tgzFolder"
echo "$PWD/$tgzFile"

echo
bash_script_o