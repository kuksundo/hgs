#cs
Local $ProgName = "C:\Windows\system32\AutoNXLogOut.scr"
Local $ScrTimeOut = "600"
Local $sVar = RegRead("HKEY_CURRENT_USER\Control Panel\Desktop", "SCRNSAVE.EXE")

if $sVar <> $ProgName Then
   RegWrite("HKEY_CURRENT_USER\Control Panel\Desktop", "SCRNSAVE.EXE", "REG_SZ", $ProgName)
   RegWrite("HKEY_CURRENT_USER\Control Panel\Desktop", "ScreenSaveTimeOut", "REG_SZ", $ScrTimeOut)
EndIf
#ce

WinWaitActive("WinZip Setup", "switch between the two interfaces")
Send("!e")
