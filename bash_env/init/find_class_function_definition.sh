#!/bin/bash

bash_script_i

# it is better to user grep than find because the output includes the line number.
function find_cmd_def_path()  {
  dumpinfox "${black} ${FUNCNAME[0]} : ${green}Searching command ${brown}$1${green} in ${red}${BASH_DIR} ${end}" ;
  grep --color=always -snIRHP --exclude-dir={.svn,.git,.vscode} "^ *$1.*\(\) +\{|^ *(function +)?+$1(?=.*\(\))|^ *(export +)?$1=|^ *alias +$1="  --include="*.sh"  ${BASH_DIR} | sed 's#:#  #2' ;  echo ;   
  dumpinfo "use${brown} ??? $1 ${blue}to list all related commands"
  }
function list_related_cmds()  { 
  # egrep --color=always -snIRH --exclude-dir={.svn,.git,.vscode} "^ *$1.*\(\) +\{|^ *function +$1.*\(\)|^ *alias +$1"  --include="*.sh" ${BASH_DIR} | sed 's#:#  #2' ;  echo ;
  alias | grep "$1" | grep -oP "^[^=]+"  # list all alias
  declare -F | grep "$1"                 # compgen -A function
  }

function find_cmd_implement() {
  local cmd_str=$1
  dumpkey cmd_str
  command type $cmd_str
  # alias bd7='source xxx.sh'
  cmd_next=$(command type $cmd_str | grep "is aliased to" | grep -oP "is aliased to .\K[^']+" | xargs | cut -d' ' -f 1)
  if [[ "${cmd_next}" != "" && "${cmd_next}" != "\K[^" ]] ; then
    find_cmd_implement "${cmd_next}"
  else
    # loop is end, dump more info
    echo
    dumpinfo "use${brown} ?? ${blue}to cmd source ; use${brown} ??? ${blue}to list all related commands"
  fi
}

# example :  recommand : command -v python
# $ type python
# python is aliased to `/home/utils/Python-3.9.1/bin/python3'
# python is /usr/bin/python
# python is /bin/python

# $ which python
# /usr/bin/python

# $ command -v python
# alias python='/home/utils/Python-3.9.1/bin/python3'

# find app path :   command -v python  | type python  | which python
function where() {
  [[ -z $1 ]] && { dumpinfox "empty search string , usage e.g. where python"; where python ;  return 1; }
  dumpinfo "${brown}compgen -c ${end}:${blue} list all command"
  # dumpinfo "${brown}command -v $1 ${end}:${blue} recommend usage to find the path of the command"

  echo
  dumpcmd "alias $1    # show the definition of the alias"
  alias $1
  
  echo
  dumpcmd "type -a $1    # show all definition of the command( alias, function, builtin, file)"
  type -a $1
  
  echo
  dumpcmd "which $1    # find the path of executable file"
  which $1

  echo
  dumpcmd "whereis $1    # find binary, source code and manual page for a command"
  whereis $1

  echo
  dumpcmd "command -v $1    # get the path or type of the command"
  command -v $1  
}
# alias k=kk        # parsel the alias immediately when the alias is defined
# alias k='kk'      # parsel the alias             when the alias is called
alias       ?=find_cmd_implement
alias       ??=find_cmd_def_path
alias       ???=list_related_cmds


# ****************************** find C++ class , struct , enum , #define or function ****************************************
# C++ type  : [a-zA-Z_][a-zA-Z0-9_]*(&|\\*)?
# namespace : [a-zA-Z_][a-zA-Z0-9_]*
# qualifier : (static|const|voliate|inline|virtual|override|= *delete)*
# e.g.      : NotNull<StructureType const *> Cutlass3xTypes::ConvFpropPayload_ty() const {
cpp_alnum='[[:alnum:]]'
cpp_type="^${cpp_alnum}(${cpp_alnum}|_)*(&|\\*)?"
cpp_no_tail_semicolon='(?!.*; *$)'                    # without line tail ; , it is defintion, not declaration. and not call : int a = func(); 
cpp_not_call='(?! *(if *\(|return ))'                 # it is defintion, not call , e.g. , return func , if(func)
# cpp_template="<(${cpp_type}[ ,]*)*>?"
# cpp_ns='[a-zA-Z_][a-zA-Z0-9_]*'
# cpp_qualifier_prefix='(static|const|volatile|inline|virtual) *'
# cpp_qualifier_suffix='(const|volatile|override|= *delete)? *'
# cpp_bracket='\\('
# cpp_include='*.cpp,*.xx,*.cc,*.c,*.h,*.hpp,*.hh,*.hxx'

# $2  or "$2" ?   $2 can search in multiple file, "$2" can avoid blank char issue in folder path 
# --include='*.cpp' --include='*.py'
# --include='*.{cpp,h,hpp}' --include='*.py'   # it is not alwasy supported in all grep version
# --exclude='*.py'
function find_cpp_class_defintion_impl()           {  
  dumppos
  echo -e "\n# ${green}for cuda class, search in :${blue} ${CUDA_PATH}/include ${end}" ;
  if [[ -z $1 ]] ; then
    dumperr "empty search string"
    return 1
  fi

  local multi_folders=${@:2}
  multi_folders=$(echo "${multi_folders:-$(pwd -L)}" | xargs | sed -E 's#[;,\|]+# #g' | xargs -n1 readlink -f | tr '\n' ' ' | update_symbol_path )
  echo -e "# ${FUNCNAME[0]} : ${green}search ${brown} $1 ${green}definition in${brown} ${multi_folders} ${end}"  ;  
  dumpcmd "grep -sniIRHP --exclude-dir={.svn,.git,.vscode} --exclude='*.{md,txt,html}' --color=always  \"^ *(struct|class|enum .*|namespace|#define|def |function) +$1\b|^ *$1::$1|^ *(alias) +$1=|^ *(export )? *$1=\"  ${multi_folders}"
  grep -sniIRHP --exclude-dir={.svn,.git,.vscode} --exclude='*.{md,txt,html}' --color=always  "^ *(struct|class|enum .*|namespace|#define|def |function) +$1\b|^ *$1::$1|^ *(alias) +$1=|^ *(export )? *$1="  ${multi_folders} | sed 's#:#  #2' ;
  echo -e "#${black} ${FUNCNAME[0]} : ${green}search ${brown} $1 ${green}definition in${brown} ${multi_folders} ${end}"  ; 
  dumppos  
  }

function find_defintion_test()           {  
  dumppos
  echo -e "\n# ${green}for cuda class, search in :${blue} ${CUDA_PATH}/include ${end}" ;
  echo -e "# ${FUNCNAME[0]} : ${green}search ${brown} $1 ${green}definition in${brown} ${2:-`pwd -L`} ${end}"  ;  
  [[ -f "${curFile}" ]] && egrep -snIRH --color=always  "^ *using +$1 *="  ${curFile} ; #| sed 's#:#  #2' ;
  grep -snIRHPz --exclude-dir={.svn,.git,.vscode} --exclude='*.{md,txt,html}' --color=always  "(?s)^ *(struct|class|enum .*|namespace|#define|def |function)[\r\n ]+$1${cpp_no_tail_semicolon}|^ *$1::$1|^ *(alias) +$1=|^ *(export )? *$1="  $2 | sed 's#:#  #2' ;
  echo -e "#${black} ${FUNCNAME[0]} : ${green}search ${brown} $1 ${green}definition in${brown} ${2:-`pwd -L`} ${end}"  ; 
  dumppos  
  }

function list_cpp_all_class_defintion_x() {
  echo -e "\n#${black} ${FUNCNAME[0]} : ${green}list all class definition in${brown} ${1} ${end}"  ;   
  grep -snIRHP --color=always  "^ *\(struct\|class\|enum .*\) .*" $1 | sed 's#:#  #2'  ; 
}

# grep 效率变化曲线 : 为了不显著降低 grep 查询效率，把查询 类定义 和查询 C++ 函数 分开, 但是查询 python, shell等脚本语言的函数可以放在一起
# 在实际应用中，当组合条件数量从1逐渐增加到N时，查询效率通常呈现出非线性的下降趋势。具体而言：
# - 当条件数量较少（如1到3个）时，效率变化不大。
# - 当条件数量在3到10个之间时，效率开始显著下降。
# - 超过10个条件后，每增加一个条件所需的时间可能会成倍增加，尤其是在处理大文件时。

function find_cpp_function_definition_impl() {
    dumppos
    local multi_folders=${@:2}
    multi_folders=$(echo "${multi_folders:-$(pwd -L)}" | xargs | sed -E 's#[;,\|]+# #g' | xargs -n1 readlink -f | tr '\n' ' ' | update_symbol_path )
    echo -e "\n#${black} ${FUNCNAME[0]} : ${green}search ${brown} $1 ${green}function defintion in${brown} ${multi_folders} ${end}"  ;
    # member function or global function
    dumpcmd "grep -sniIRHP --color=always --exclude-dir={.svn,.git,.vscode}  \"${cpp_not_call}(${cpp_type}::$1| $1)${cpp_no_tail_semicolon}|^ *$1${cpp_no_tail_semicolon}\"  ${multi_folders}"
    grep -sniIRHP --color=always --exclude-dir={.svn,.git,.vscode}  "${cpp_not_call}(${cpp_type}::$1| $1)${cpp_no_tail_semicolon}|^ *$1${cpp_no_tail_semicolon}"  ${multi_folders}  | sed 's#:#  #2'
    echo -e "\n${green}for cuda function, search in :${brown} ${CUDA_PATH}/include ${end}" ;
    echo -e "# ${FUNCNAME[0]} : ${green}search ${brown} $1 ${green}function defintion in${brown} ${multi_folders} ${end}"  ;    
}

function find_cpp_function_definition_test() {
    dumppos
    local multi_folders=${@:2}
    multi_folders=$(echo "${multi_folders:-$(pwd -L)}" | xargs | sed -E 's#[;,\|]+# #g' | xargs -n1 readlink -f | tr '\n' ' ' | update_symbol_path )
    echo -e "\n#${black} ${FUNCNAME[0]} : ${green}search ${brown} $1 ${green}function defintion in${brown} ${multi_folders} ${end}"  ;   
    # member function or global function
    dumpcmd "grep -sniIRHP --color=always --exclude-dir={.svn,.git,.vscode}  \"(^ *$1|::$1| $1)${cpp_no_tail_semicolon}\"  ${multi_folders}"
    grep -sniIRHP --color=always --exclude-dir={.svn,.git,.vscode}  "(^ *$1|::$1| $1)${cpp_no_tail_semicolon}"  ${multi_folders}  | sed 's#:#  #2'
    echo -e "\n${green}for cuda function, search in :${brown} ${CUDA_PATH}/include ${end}" ;
    echo -e "# ${FUNCNAME[0]} : ${green}search ${brown} $1 ${green}function defintion in${brown} ${multi_folders} ${end}"  ;    
}

function list_all_function_defintion_x() {
  echo -e "\n# list_all_function_defintion_x : ${green}list all function defintion in${brown} ${1} ${end}"  ;  
  egrep -sniIRHP --color=always  "${cpp_not_call}(${cpp_type}::$1| $1)${cpp_no_tail_semicolon}|^ *$1${cpp_no_tail_semicolon}"  | sed 's#:#  #2' ;
}

# grep can't match Carriage Return -- it can't match line tail by string$
alias   find_defintion=find_cpp_class_defintion_impl
# alias   find_defintion=find_defintion_test  # not fixed bug : fdef7 DynamicShaderEmitter
function find_cpp_class_defintion()             {  find_defintion       "$1"  "${2:-`pwd -L`}"     ;                                                                      }
function find_cpp_class_defintion_cask5()       {  find_defintion       "$1"  "${CASK_5_PATH}"  ;                                                                         }
function find_cpp_class_defintion_cask6()       {  find_defintion       "$1"  "${REPO_DIR_CASK6}"  ;                                                                      }
function find_cpp_class_defintion_dkg()         {  find_defintion       "$1"  "${REPO_DIR_DKG}"  ;                                                                        }
function find_cpp_class_defintion_nvvm()        {  find_defintion       "$1"  "${REPO_DIR_LLVM_SOLID}"  ;                                                                 }
function find_cpp_class_defintion_llvm()        {  find_defintion       "$1"  "${LLVM_PATH}/include/llvm;${LLVM_PATH}/include/mlir;${LLVM_PATH}/lib/cmake"  ;             }
function find_cpp_class_defintion_cutlass()     {  find_defintion       "$1"  "${REPO_DIR_CUTLASS}"  ;                                                                    }
function find_cpp_class_defintion_api()         {  find_defintion       "$1"  "${CUDA_PATH}/include"  ;                                                                   }
function find_cpp_class_defintion_all()         {  find_cpp_class_defintion_cask6   "$1" ; find_cpp_class_defintion_api  "$1" ;  find_cpp_class_defintion_cutlass  "$1" ; }

alias fdef5=find_cpp_class_defintion_cask5
alias fdef6=find_cpp_class_defintion_cask6
alias fdef7=find_cpp_class_defintion_dkg
alias fdefvm=find_cpp_class_defintion_llvm
alias fdefllvm=find_cpp_class_defintion_llvm
alias fdefapi=find_cpp_class_defintion_api
alias fdefcu=find_cpp_class_defintion_cutlass
alias fdefa=find_cpp_class_defintion_all
alias fdef=find_cpp_class_defintion
alias fdefd=find_cpp_class_defintion_cask6
alias fcls=fdef

# grep can't match Carriage Return -- it can't match line tail by string$
# alias    find_cpp_function_defintion=find_cpp_function_definition_impl
alias    find_cpp_function_defintion=find_cpp_function_definition_test
function find_function_defintion_current()     {  find_cpp_function_defintion       "$1"  "${2:-`pwd -L`}"     ;                                                            }
function find_function_defintion_cask5()       {  find_cpp_function_defintion       "$1"  "${CASK_5_PATH}"  ;                                                               }
function find_function_defintion_cask6()       {  find_cpp_function_defintion       "$1"  "${REPO_DIR_CASK6}"  ;                                                            }
function find_function_defintion_dkg()         {  find_cpp_function_defintion       "$1"  "${REPO_DIR_DKG}"  ;                                                              }
function find_function_defintion_nvvm()        {  find_cpp_function_defintion       "$1"  "${REPO_DIR_LLVM_SOLID}"  ;                                                       }
function find_function_defintion_llvm()        {  find_cpp_function_defintion       "$1"  "${LLVM_PATH}/include/llvm;${LLVM_PATH}/include/mlir;${LLVM_PATH}/lib/cmake"  ;   }
function find_function_defintion_api()         {  find_cpp_function_defintion       "$1"  "${CUDA_PATH}/include"  ;                                                         }
function find_function_defintion_cutlass()     {  find_cpp_function_defintion       "$1"  "${REPO_DIR_CUTLASS}"  ;                                                          }
function find_function_defintion_all()         {  find_cpp_function_defintion       "$1"  "${REPO_DIR_CASK6};${CUDA_PATH}/include;${REPO_DIR_CUTLASS}" ;                    }

alias ffunc5=find_function_defintion_cask5
alias ffunc6=find_function_defintion_cask6
alias ffunc7=find_function_defintion_dkg
alias ffuncvm=find_function_defintion_nvvm
alias ffuncllvm=find_function_defintion_llvm
alias ffuncapi=find_function_defintion_api
alias ffunccu=find_function_defintion_cutlass
alias ffunca=find_function_defintion_all
alias ffunc=find_function_defintion_current

bash_script_o
