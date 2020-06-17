Wscript.Sleep WScript.Arguments.item(0) * 1000
Set WshShell = WScript.CreateObject("WScript.Shell")
WshShell.Sendkeys "{Enter}"
Set WshShell = Nothing