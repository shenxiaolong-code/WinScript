'  mklink /d  "C:\Documents and Settings\%USERNAME%\Desktop\Program1 shortcut.lnk" "c:\program Files\App1\program1.exe"

' usage example
' mkshortcut /target:TargetName /shortcut:ShortcutName
' C:>mkshortcut /target:"c:/documents and settings/giannis/desktop" /shortcut:"My Desktop"
set WshShell = WScript.CreateObject("WScript.Shell" )
set oShellLink = WshShell.CreateShortcut(Wscript.Arguments.Named("shortcut") & ".lnk")
oShellLink.TargetPath = Wscript.Arguments.Named("target")
oShellLink.WindowStyle = 1
oShellLink.Save