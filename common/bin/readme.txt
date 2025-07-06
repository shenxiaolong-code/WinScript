search.exe 	:  快速搜索本地磁盘上文件。使用search.exe -?来查看搜索选项。
search.exe stig.exe
search.exe "D:\sourceCode\webex-jabbermeeting\" .sln
search.exe "D:\sourceCode\jabberGit127\"^|"D:\sourceCode\jabberGit128\"  jabber*.sln
search.exe "D:\sourceCode\jabberGit127\"^|"D:\sourceCode\jabberGit128\"  jabber*.sln^|zli*.sln

runAsAdmin.exe	:  以管理员权限运行指定的命令行字符串。如： runAsAdmin.exe cmd.exe /k "c:\my path\scrpit.bat"
                   core\Projects\CppTools\sources\runAsAdmin

7z.exe		：  模块信息查看工具，比如版本号，32/64位。

cecho.exe   : https://www.codeproject.com/Articles/17033/Add-Colors-to-Batch-Files