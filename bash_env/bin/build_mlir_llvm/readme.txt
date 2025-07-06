

# Build MLIR Language Server Protocol
https://gitlab-master.nvidia.com/dlarch-fastkernels/dynamic-kernel-generator/-/tree/master#build-mlir-language-server-protocol

# nv llvm project : dkg
https://gitlab-master.nvidia.com/dlarch-fastkernels/dynamic-kernel-generator/-/tree/master#build-dkg-with-local-llvmnvsolid-build

# llvm vscode extension
https://mlir.llvm.org/docs/Tools/MLIRLSP/#visual-studio-code

# LLVM Download Page
https://releases.llvm.org/download.html

# llvm build giude
https://releases.llvm.org/18.1.8/docs/GettingStarted.html

# Getting Started with the LLVM System
https://llvm.org/docs/GettingStarted.html#checkout

# My First Language Frontend with LLVM Tutorial
https://llvm.org/docs/tutorial/MyFirstLanguageFrontend/index.html

# This section gives an example of using LLVM with the Clang front end.
https://llvm.org/docs/GettingStarted.html#id33

在 CMake 配置 LLVM 项目时，有多个环境变量和 CMake 变量可以使用。以下是一些常用的环境变量和 CMake 变量的列表：

## 常用 CMake 变量

1. **LLVM_DIR**：
   - 指定包含 `LLVMConfig.cmake` 的目录，通常用于指向 LLVM 安装路径。

2. **CMAKE_BUILD_TYPE**：
   - 设置构建类型，可能的值有 `Debug`、`Release`、`RelWithDebInfo` 和 `MinSizeRel`。

3. **CMAKE_INSTALL_PREFIX**：
   - 指定安装路径，当执行 `make install` 时，LLVM 将被安装到该路径下。

4. **LLVM_TARGETS_TO_BUILD**：
   - 指定要构建的目标架构，使用分号分隔的列表，例如 `X86;ARM`，或使用 `all` 来构建所有目标。

5. **LLVM_ENABLE_PROJECTS**：
   - 指定要构建的子项目，例如 `clang;lld`。

6. **LLVM_ENABLE_RUNTIMES**：
   - 指定要构建的运行时库，例如 `libcxx;libcxxabi`。

7. **BUILD_SHARED_LIBS**：
   - 设置为 `ON` 以构建共享库，默认值为 `OFF`。

8. **LLVM_USE_LINKER**：
   - 指定使用的链接器，例如 `lld` 或 `gold`。

9. **LLVM_ENABLE_ASSERTIONS**：
   - 设置为 `ON` 以启用断言，默认在调试构建中为 `ON`，在发布构建中为 `OFF`。

10. **LLVM_PARALLEL_LINK_JOBS**：
    - 设置并行链接作业的数量，以提高构建速度。

11. **CMAKE_C_COMPILER** 和 **CMAKE_CXX_COMPILER**：
    - 指定 C 和 C++ 编译器的路径。

12. **CMAKE_C_FLAGS** 和 **CMAKE_CXX_FLAGS**：
    - 为 C 和 C++ 源文件编译时添加额外的标志。

13. **LLVM_INCLUDE_DIRS**：
    - 包含 LLVM 头文件的路径列表。

14. **LLVM_DEFINITIONS**：
    - 编译时使用的预处理器定义列表。

15. **LLVM_PACKAGE_VERSION**：
    - LLVM 的版本信息，可以用于条件判断。

16. **LLVM_TOOLS_BINARY_DIR**：
    - 包含 LLVM 工具（如 `llvm-as`, `lli` 等）的目录路径。

17. **CMAKE_MODULE_PATH**：
    - 用于指定自定义模块搜索路径，可以添加包含其他 CMake 文件的目录。

18. **LLVM_ENABLE_DOXYGEN**：
    - 设置为 `ON` 以启用 Doxygen 文档生成。

19. **LLVM_ENABLE_SPHINX**：
    - 设置为 `ON` 以启用 Sphinx 文档生成。

20. **LLVM_OPTIMIZED_TABLEGEN**：
    - 设置为 `ON` 以生成优化过的 TableGen 编译器。

## 使用方法

在运行 CMake 命令时，可以通过 `-D` 选项设置这些变量。例如：

```bash
cmake -G Ninja \
      -DLLVM_DIR=/path/to/llvm/lib/cmake/llvm \
      -DCMAKE_BUILD_TYPE=Release \
      -DLLVM_TARGETS_TO_BUILD="X86" \
      ..
```

cmake --help-variable-list 
cmake --help-variable VARIABLE_NAME