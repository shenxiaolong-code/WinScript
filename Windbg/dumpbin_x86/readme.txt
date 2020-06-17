此文件组用于dump x86架构下exe/dll/lib中的符号。
注意：dumpbin.exe/link.exe/mspdb80.dll/undname.exe都来自于VC9(VS2008)。
e.g. : dumpSymbols.bat myDll.lib
然后查看myDll_dump目录下的各种log文件(文件名字指示了符号分组内容)。

如果需要导出其它架构下的符号，需要使用WINCE600下的wce600\lib\target目录中各个对应平台下的程序。