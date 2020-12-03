@if {"%_Echo%"}=={"1"} ( @echo on ) else ( @echo off )

rem set default value
if not defined window_sizeH set window_sizeH=0x002d
if not defined window_sizeW set window_sizeW=00a0
if not defined buffer_sizeH set buffer_sizeH=07d0
if not defined buffer_sizeW set buffer_sizeW=0x0082
if not defined historyLines set historyLines=5000

rem remove prefix 0x
set window_sizeH=%window_sizeH:0x=%
set window_sizeW=%window_sizeW:0x=%
set buffer_sizeH=%buffer_sizeH:0x=%
set buffer_sizeW=%buffer_sizeW:0x=%

rem update registry
set keypath_console="HKEY_CURRENT_USER\Console"
echo set console window size, heigth * width = %window_sizeH% * %window_sizeW%
reg add %keypath_console% /t REG_DWORD /v WindowSize /d 0x%window_sizeH%%window_sizeW% /f

echo set console window buffer size, heigth * width = %buffer_sizeH% * %buffer_sizeW%
reg add %keypath_console% /t REG_DWORD /v ScreenBufferSize /d 0x%buffer_sizeH%%buffer_sizeW% /f

echo set console window history line number %historyLines%
reg add %keypath_console% /t REG_DWORD /v HistoryBufferSize /d %historyLines% /f

echo set quick edit mode
reg add %keypath_console% /t REG_DWORD /v QuickEdit /d 0x0000001 /f

echo set auto complete feature
set keypath_cmdProc="HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Command Processor"
reg add %keypath_cmdProc% /t REG_DWORD /v CompletionChar /d 0x00000040 /f
reg add %keypath_cmdProc% /t REG_DWORD /v PathCompletionChar /d 0x00000040 /f
