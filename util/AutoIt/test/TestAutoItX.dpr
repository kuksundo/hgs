{-----------------------------------------------------------------------------
 Unit Name: TestAutoItX3
 Author:    Melloware <info@melloware.com>
            http://www.melloware.com
 Purpose:   To demonstrate using the AutoItX3 DLL from Delphi.
            Advantages of this version of the DLL Wrapper.
            1. Dynamically loaded so no error with be thrown if DLL is not
               found on the path.  You can query boolean AutoItXDLLLoaded
               property to find out if it is loaded.
            2. Defaults for integer parameters as listed in the API spec. So
               instead of:
               AU3_WinWaitActive('Untitled - Notepad', '', 0);
               you can use:
               AU3_WinWaitActive('Untitled - Notepad', '');
               if you want the default.
            3. Ability to query for the version of the DLL you are using by
               the method AutoItXVersion() which return 3.2.8.4 or whatever
               the version of the AutoItXDLl you are using.
 History:   History:   09/29/2007   Initial Version
-----------------------------------------------------------------------------}
program TestAutoItX;

uses
  Vcl.Dialogs,
  Windows,
  AutoItX3 in '..\AutoItX3.pas';

begin
    (*
    Like this:
    Sleep(1000)
    Run("notepad.exe")
    WinWaitActive("Untitled -", "")
    Send("Hello{!}")
    Sleep(5000)
    WinClose("notepad.exe")
    WinWaitActive("Untitled -", "")
    Send("!n")
    *)
   if not AutoItXDLLLoaded then
   begin
      MessageDlg('AutoItX3 DLL is not found in the path!', mtError, [mbOK], 0);
   end
   else
   begin
      AU3_Sleep(1000);
      AU3_Run('notepad.exe', '');
      AU3_WinWaitActive('제목 없음 - 메모장', '');
      AU3_Send(StringToOleStr( 'DLL Version: ' + AutoItXVersion + ' {ENTER}'));
      AU3_Send(StringToOleStr('DLL Description: ' + AutoItXDescription));
      AU3_Sleep(5000);
      AU3_WinClose('제목 없음 - 메모장', '');
      AU3_WinWaitActive('메모장', '저장 안 함(&N)');
      AU3_Send('!n');
   end;

end.

