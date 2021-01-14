Set WshShell = WScript.CreateObject("WScript.Shell")
WshShell.run "cmd"
WScript.Sleep 1000
'WshShell.SendKeys "cd Path to File Here\NodeJSThings"
WshShell.SendKeys "{ENTER}"
WshShell.SendKeys "node NodeTest.js"
WshShell.SendKeys "{ENTER}"