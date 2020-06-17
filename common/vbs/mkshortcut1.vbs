'  mklink /d  "C:\Documents and Settings\%USERNAME%\Desktop\Program1 shortcut.lnk" "c:\program Files\App1\program1.exe"

' usage example
' cscript createLink.vbs "C:\Documents and Settings\%USERNAME%\Desktop\Program1 shortcut.lnk" "c:\program Files\App1\program1.exe" 
' cscript createLink.vbs "C:\Documents and Settings\%USERNAME%\Start Menu\Programs\Program1 shortcut.lnk" "c:\program Files\App1\program1.exe" 

set objWSHShell = CreateObject("WScript.Shell")
set objFso = CreateObject("Scripting.FileSystemObject")

sShortcut = objWSHShell.ExpandEnvironmentStrings(WScript.Arguments.Item(0))
sTargetPath = objWSHShell.ExpandEnvironmentStrings(WScript.Arguments.Item(1))
'sWorkingDirectoryNew = objWSHShell.ExpandEnvironmentStrings(WScript.Arguments.Item(3))
sWorkingDirectory = objFso.GetParentFolderName(sShortcut)

set oShellLink = objWSHShell.CreateShortcut(sShortcut) 
oShellLink.TargetPath = sTargetPath
'oShellLink.WorkingDirectory = sWorkingDirectoryNew
oShellLink.WorkingDirectory = sWorkingDirectory

' oShellLink.WindowStyle = 1
' oShellLink.IconLocation = "c:\application folder\application.ico"
' oShellLink.Description = "Shortcut Script"
oShellLink.Save

