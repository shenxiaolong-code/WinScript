
开发 mlir 项目中， vscode 一定要使用 MLIR 的插件，这样可以方便的查看 .td 文件的定义，以及 .mlir 文件的语法高亮。
安装插件：MLIR Language Support 
配置方法：
可以直接搜索 MLIR ， 这样可以同时显示下面的三个配置项：
注意： 那些文件可能没有运行权限，需要手工添加运行权限。
chmod +x ${EXT_DIR}/myDepency/llvm_mlir_for_dkg/assert_20241023/bin/mlir-lsp-server
chmod +x ${EXT_DIR}/myDepency/llvm_mlir_for_dkg/assert_20241023/bin/tblgen-lsp-server
chmod +x ${EXT_DIR}/myDepency/llvm_mlir_for_dkg/assert_20241023/bin/mlir-pdll-lsp-server


Mlir: Tablegen_server_path: 
${EXT_DIR}/myDepency/llvm_mlir_for_dkg/assert_20241023/bin/tblgen-lsp-server
让 vscode outline 支持 .td 文件解析
确保工作区顶级目录下有一个名为 tablegen_compile_commands.yml 的文件，例如：
${EXT_DIR}/build/dkg_mlir_lsp_server/build/tablegen_compile_commands.yml
如果要手工指定文件路径，可以在工作区设置中设置 mlir.tablegenCompileCommandsFile 选项来指定这个文件的路径
Mlir: Tablegen_compilation_databases ： <tablegen_compile_commands.yml>
这个文件是由 cmake 自动生成的 ： 当 CMakelists.txt 中包含/显式指定了 mlir_tablegen(MyTableGenFile.td -o MyOutputFile.cpp) 时，cmake 会自动生成这个文件。


Mlir: Server_path : 
${EXT_DIR}/myDepency/llvm_mlir_for_dkg/assert_20241023/bin/mlir-lsp-server
${EXT_DIR}/build/dkg_mlir_lsp_server/build/tools/mlir-lsp-server/nv-mlir-lsp-server
让vscode 支持 .mlir 文件的语法高亮


Mlir: Pdll_server_path:
${EXT_DIR}/myDepency/llvm_mlir_for_dkg/assert_20241023/bin/mlir-pdll-lsp-server