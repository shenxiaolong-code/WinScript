srcSrv.ini copy from windbg directory, and it can be renamed to any name.
https://docs.microsoft.com/en-us/windows-hardware/drivers/debugger/the-srcsrv-ini-file

when use source server to get exact version source file, windbg will popup security alert because the svn.exe is not included into srcSrv.ini as trusted application.

here is solution: add svn.exe as trusted application and add it into new .ini file

to use one different source server file, set environment variable SRCSRV_INI_FILE to new file full path , example :
set SRCSRV_INI_FILE=D:\work\shenxiaolong\core\WinScript\Windbg\setup\symSrv\srcSrv.ini