bash_script_i
echo

# md cuda-gpgpu-31256743
# tar -zxvf cuda-gpgpu-31256743.tgz -C ./cuda-gpgpu-31256743
# tar -xvf xxx.tar.gz

packedFile=$1
outputFolderPath="$2"
# .tgz    : compressed packedFile
# .tar.gz : archive packedFile
# .tar    : uncompressed packedFile
#  tar xvf dir_20230426_0604_SW_3114/CUDA-gdb-package.tar.bz2 -C ./cuda_udbg/

if [[ ! -f $packedFile ]] ; then
    dumperr "packed file not found : "
    dumpkey packedFile
    return 1
fi
outputFolderName=dir_`echo $packedFile | sed 's#.*/##' | sed 's#\.tar.*##' | sed 's#\.tgz.*##' | sed 's#\.#_#g' | sed 's#-#_#g' | cut -c1-32`

function generate_unpack_folder_path()
{
  if [[ "${outputFolderPath}" == "" ]] ; then    
      outputFolderPath="$(pwd -L)/${outputFolderName}"
      [ -d "${outputFolderPath}" ] &&  dumpinfox "Delete existing non-empty unpack output folder '${outputFolderPath}' ...  "  &&  rd "${outputFolderPath}" > /dev/null
      [ ! -d "${outputFolderPath}" ] &&  mkdir -p "${outputFolderPath}"
  else
      [ "${outputFolderPath:-1}" != "/" ] && outputFolderPath="${outputFolderPath}/"
      if [ ${outputFolderPath}  ==  *"${outputFolderName}/" ] && [ -d "${outputFolderPath}" ] && [ "$(ls -A ${outputFolderPath} )" ] ; then
          # this folder is created automatical by myself
          dumpinfox "delete existing non-empty unpack output folder '${outputFolderPath}' ... "
          rd "${outputFolderPath}" > /dev/null
      fi
      [ ! -d "${outputFolderPath}" ]      &&  mkdir -p "${outputFolderPath}"
      outputFolderPath=$(cd $outputFolderPath && pwd -L)
      [ "$(ls -A ${outputFolderPath} )" ] &&  outputFolderPath="${outputFolderPath}/${outputFolderName}" &&  mkdir -p "${outputFolderPath}"
  fi

  # 根据文件扩展名自动解压缩
  dumpinfox "unpack    :${red} ${packedFile}"
  dumpinfo  "unpack to :${brown} ${outputFolderPath}"
}

function do_unpack() {
  case "$packedFile" in
    *.tar.gz|*.tgz)
      dumpinfox "unpacking  :  tar -xzf $packedFile -C ${outputFolderPath}"
      tar -xzvf "$packedFile" -C "$outputFolderPath"
      ;;
    *.tar.bz2|*.tbz)
      dumpinfox "unpacking  :  tar -xjf $packedFile -C ${outputFolderPath}"
      tar -xjvf "$packedFile" -C "$outputFolderPath"
      ;;
    *.tar.xz|*.txz)
      dumpinfox "unpacking  :  tar -xJf $packedFile -C ${outputFolderPath}"
      tar -xJvf "$packedFile" -C "$outputFolderPath"
      ;;
    *.zip)
      dumpinfox "unpacking  :  unzip $packedFile -d ${outputFolderPath}"
      unzip -o "$packedFile" -d "$outputFolderPath"
      ;;
    *.a)
      dumpinfox "unpacking  :  ar x $packedFile --output=${outputFolderPath}"
      ar x "$packedFile" --output="$outputFolderPath"
      ;;
    *)
      dumperr "unsupported file type : $packedFile"
      ;;
  esac
}

function is_has_only_one_subfolder() {
    local dir="$1"
    
    # 检查输入的目录是否存在且是一个目录
    if [[ ! -d "$dir" ]]; then
        echo "Error: $dir is not a valid directory."
        return 1
    fi

    # 统计子目录的数量
    local subdir_count=$(find "$dir" -mindepth 1 -maxdepth 1 -type d | wc -l)

    # 统计文件的数量（排除子目录）
    local file_count=$(find "$dir" -mindepth 1 -maxdepth 1 -type f | wc -l)

    # 检查条件：只有一个子目录且没有文件
    if [[ $subdir_count -eq 1 && $file_count -eq 0 ]]; then
        # local unique_subfolder_path=$(find "${dir}" -mindepth 1 -maxdepth 1 -type d)
        # [[ -n $2 ]] && echo ${unique_subfolder_path}
        dumpinfox "The directory '$dir' contains only one subdirectory."
        return 0
    else
        dumpinfox "The directory '$dir' does not meet the criteria."
        return 1
    fi
}

function move_possible_unique_subfoler_up(){
  is_has_only_one_subfolder "${outputFolderPath}" || return 0

  dumpinfox "Only one subfolder found in '${outputFolderPath}'"
  local subfolder=$(find "${outputFolderPath}" -mindepth 1 -maxdepth 1 -type d)
  local new_unpacked_folder=$(echo ${subfolder} | sed 's#dir_[^/]\+/##' )
  # dumpkey subfolder
  # dumpkey new_unpacked_folder
  # [[ -d ${new_unpacked_folder} ]] && mv ${new_unpacked_folder} "${new_unpacked_folder}_$(date "+%Y%m%d_%H%M")"
  [[ -d ${new_unpacked_folder} ]] && rd ${new_unpacked_folder} > /dev/null
  mv "${subfolder}" "${new_unpacked_folder}"
  rm -rf "${outputFolderPath}"
  outputFolderPath="${new_unpacked_folder}"
}

function unapck_main() {
    generate_unpack_folder_path "$@"
    do_unpack "$@"
    move_possible_unique_subfoler_up

    dumpinfox "Done to unpack :\n${end}#${brown} $packedFile${green}  \n${end}# =>\n${end}#${brown} ${outputFolderPath}"
    # echo "${green}folder path    :${brown}  ${outputFolderPath}${end}"
    dumpkey outputFolderPath
}

unapck_main "$@"

echo
bash_script_o