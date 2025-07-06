when first use Microsoft Symbol Server , windbg will pop-up a alert prompt dialog.


to disable this prompt dialog:
copy empty file named symsrv.yes to the directory which symsrv.dll lies in.

use empty file named symsrv.no to refuse this prompt.



to exclude Files from Symbols List because: 
1. some specified files
2. some files without symbol file always , e.g. 3rd lib
3. don't load symbols
copy file symsrv.ini into the directory which symsrv.dll lies in.
In most installations, the file does not exist and you will need to create a new one.
in symsrv.ini
add any file name into [Exclusions] section, wildcards is supported.
