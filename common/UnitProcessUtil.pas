unit UnitProcessUtil;

interface

uses Windows, sysutils, classes, Forms, shellapi, Graphics, math, MMSystem,
    JclStringConversions, WinSock, Winapi.Messages, TLHelp32, Registry;

type
  PProcWndInfo = ^TProcWndInfo;
  TProcWndInfo = record
    TargetProcessID: DWORD;
    FoundWindow    : HWND;
  end; { TProcWndInfo }

function ExecNewProcess(ProgramName : String; Wait: Boolean): string;
function ExecNewProcess2(ProgramName: string; ParamString : String = ''): THandle;
function FileExecute(const FileName, Params, StartDir: string): Cardinal;
function ExecAndWait(const ExecuteFile, ParamString: string) : THandle;
function GetHandleByPID(Pid: longword): THandle;
function DSiGetProcessWindow(targetProcessID: cardinal): HWND;
function KillTask(ExeFileName: string): Integer;//파일명으로 실행중인 프로세스 죽이기
function isOpen(ExeFileName: string): integer; //파일명으로 실행여부 확인하고 프로세 아이디 얻기
procedure RunAsAdmin(hWnd : Hwnd; aFile : string; aParameters : string);
function IsUACActive: Boolean;

type
  TExecuteFileOption = (
    eoHide,
    eoWait,
    eoElevate
  );
  TExecuteFileOptions = set of TExecuteFileOption;

function ExecuteFile(Handle: HWND; const Filename, Paramaters: String; Options: TExecuteFileOptions): Integer;

implementation

function ExecNewProcess(ProgramName : String; Wait: Boolean): string;
var
  StartInfo : TStartupInfo;
  ProcInfo : TProcessInformation;
  CreateOK : Boolean;
begin
  Result := '';
  { fill with known state }
  FillChar(StartInfo,SizeOf(TStartupInfo),#0);
  FillChar(ProcInfo,SizeOf(TProcessInformation),#0);
  StartInfo.cb := SizeOf(TStartupInfo);
  CreateOK :=   CreateProcessW(nil,
      PWideChar(UTF8Decode(ProgramName)),       // command line
      nil,          // process security attributes
      nil,          // primary thread security attributes
      TRUE,         // handles are inherited
      0,            // creation flags
      nil,          // use parent's environment
      nil,          // use parent's current directory
      StartInfo,  // STARTUPINFO pointer
      ProcInfo);  // receives PROCESS_INFORMATION
  WaitForInputIdle(ProcInfo.hProcess, INFINITE);
    { check to see if successful }
  if CreateOK then
    begin
        //may or may not be needed. Usually wait for child processes
      if Wait then
        WaitForSingleObject(ProcInfo.hProcess, INFINITE);
    end
  else
    Result := 'Unable to run '+ProgramName;

  CloseHandle(ProcInfo.hProcess);
  CloseHandle(ProcInfo.hThread);
end;

function ExecNewProcess2(ProgramName: string; ParamString : String = ''): THandle;
var
  StartInfo : TStartupInfo;
  ProcInfo : TProcessInformation;
  CreateOK : Boolean;
  Res: Boolean;
  Msg: TagMsg;
begin
  Result := 0;
  { fill with known state }
  FillChar(StartInfo,SizeOf(TStartupInfo),#0);
  FillChar(ProcInfo,SizeOf(TProcessInformation),#0);
  StartInfo.cb := SizeOf(TStartupInfo);

  if ParamString <> '' then
    ProgramName := ProgramName + ' ' + ParamString;

  CreateOK :=   CreateProcessW(nil,
      PChar(ProgramName),       // command line
      nil,          // process security attributes
      nil,          // primary thread security attributes
      TRUE,         // handles are inherited
      0,            // creation flags
      nil,          // use parent's environment
      nil,          // use parent's current directory
      StartInfo,  // STARTUPINFO pointer
      ProcInfo);  // receives PROCESS_INFORMATION
    { check to see if successful }
  if CreateOK then
  begin
    WaitForInputIdle(ProcInfo.hProcess, 1000);

    {while WaitForSingleObject(ProcInfo.hProcess,1) = WAIT_TIMEOUT do
    begin
      repeat
        Res := PeekMessage(Msg, ProcInfo.hProcess, 0,0,PM_REMOVE);
        if Res then
        begin
          TranslateMessage(Msg);
          DispatchMessage(Msg);
        end;
      until not Res;
    end;
     }
    //Result := GetHandleByPID(ProcInfo.dwProcessId);
    Result := ProcInfo.dwProcessId;
  end;
  CloseHandle(ProcInfo.hProcess);
  CloseHandle(ProcInfo.hThread);
end;

function FileExecute(const FileName, Params, StartDir: string): Cardinal;
begin
  Result := ShellExecute(Application.Handle, 'open', PChar(FileName),
                    PChar(Params), PChar(StartDir), SW_SHOWNORMAL);
end;

function ExecAndWait(const ExecuteFile, ParamString: string) : THandle;
var
  SEInfo: TShellExecuteInfo;
  ExitCode: DWORD;
begin
  Result := 0;

  try
    FillChar(SEInfo, Sizeof(SEInfo), 0);
    SEInfo.cbSize := SizeOf(TShellExecuteInfo);
    with SEInfo do
    begin
      fMask := SEE_MASK_NOCLOSEPROCESS;
      Wnd := Application.Handle;
      lpFile := PChar(ExecuteFile);
      lpParameters := PChar(ParamString);
      nShow := SW_SHOW;
    end;

    if ShellExecuteEx(@SEInfo) then
    begin
      Result := SEInfo.hProcess;
    end;

  Except

  end;
end;

function GetHandleByPID(Pid: longword): THandle; // 델마당 '나도 한때는' 님의 코드를 슬쩍...
var
  test_hwnd  : longword;
  test_pid : longword;
  test_thread_id : longword;
begin
  Result := 0;
  test_hwnd := FindWindow(nil, nil);
  while test_hwnd <> 0 do
  begin
    If GetParent(test_hwnd) = 0 Then
    begin
      test_thread_id := GetWindowThreadProcessId(test_hwnd, test_pid);
      if test_pid = Pid then
      begin
        Result :=  test_hwnd;
        exit;
      end;
    end;
    test_hwnd := GetWindow(test_hwnd, GW_HWNDNEXT);
  end;
end;

function EnumGetProcessWindow(wnd: HWND; userParam: LPARAM): BOOL; stdcall;
var
  wndProcessID: DWORD;
begin
  GetWindowThreadProcessId(wnd, @wndProcessID);
  if (wndProcessID = PProcWndInfo(userParam)^.TargetProcessID) and
     //(GetWindowLong(wnd, GWL_HINSTANCE) <> 0) then
     (GetWindowLong(wnd, GWL_HWNDPARENT) = 0) then
  begin
    PProcWndInfo(userParam)^.FoundWindow := Wnd;
    Result := false;
  end
  else
    Result := true;
end; { EnumGetProcessWindow }

{ln}
function DSiGetProcessWindow(targetProcessID: cardinal): HWND;
var
  procWndInfo: TProcWndInfo;
begin
  procWndInfo.TargetProcessID := targetProcessID;
  procWndInfo.FoundWindow := 0;
  EnumWindows(@EnumGetProcessWindow, LPARAM(@procWndInfo));
  Result := procWndInfo.FoundWindow;
end; { DSiGetProcessWindow }

//출처 http://www.delphi3000.com/articles/article_4324.asp?SK=
//실행파일명으로 프로세스 종료
function KillTask(ExeFileName: string): Integer;
const
  PROCESS_TERMINATE = $0001;
var
  ContinueLoop: BOOL;
  FSnapshotHandle: THandle;
  FProcessEntry32: TProcessEntry32;
begin
  Result := 0;
  FSnapshotHandle := CreateToolhelp32Snapshot(TH32CS_SNAPPROCESS, 0);
  FProcessEntry32.dwSize := SizeOf(FProcessEntry32);
  ContinueLoop := Process32First(FSnapshotHandle, FProcessEntry32);
  while Integer(ContinueLoop) <> 0 do
  begin
    if ((UpperCase(ExtractFileName(FProcessEntry32.szExeFile)) =
      UpperCase(ExeFileName)) or (UpperCase(FProcessEntry32.szExeFile) =
      UpperCase(ExeFileName))) then
      Result := Integer(TerminateProcess(
        OpenProcess(PROCESS_TERMINATE,
        BOOL(0),
        FProcessEntry32.th32ProcessID),
        0));

    ContinueLoop := Process32Next(FSnapshotHandle, FProcessEntry32);
  end;
  CloseHandle(FSnapshotHandle);
end;

 //출처 http://www.delphi3000.com/articles/article_4324.asp?SK=
 //
function isOpen(ExeFileName: string): integer;
const
  PROCESS_TERMINATE = $0001;
var
  ContinueLoop: BOOL;
  FSnapshotHandle: THandle;
  FProcessEntry32: TProcessEntry32;

begin
  Result := 0;
  FSnapshotHandle := CreateToolhelp32Snapshot(TH32CS_SNAPPROCESS, 0);
  FProcessEntry32.dwSize := SizeOf(FProcessEntry32);
  ContinueLoop := Process32First(FSnapshotHandle, FProcessEntry32);

  while Integer(ContinueLoop) <> 0 do
  begin
    if ((UpperCase(ExtractFileName(FProcessEntry32.szExeFile)) =
      UpperCase(ExeFileName)) or (UpperCase(FProcessEntry32.szExeFile) =
      UpperCase(ExeFileName))) then
    begin
      result := FProcessEntry32.th32ProcessID;
      break;
    end;
    ContinueLoop := Process32Next(FSnapshotHandle, FProcessEntry32);
  end;
  CloseHandle(FSnapshotHandle);
end;

//관리자 권한으로 실행하기
procedure RunAsAdmin(hWnd : Hwnd; aFile : string; aParameters : string);
var
  sei : TShellExecuteInfoA;
begin
  FillChar(sei, SizeOf(sei), 0);
  sei.cbSize := SizeOf(sei);
  sei.Wnd := hWnd;
  sei.fMask := SEE_MASK_FLAG_DDEWAIT or SEE_MASK_FLAG_NO_UI;
  sei.lpVerb := pAnsiChar('runas');
  sei.lpFile := pAnsiChar(aFile);
  sei.lpParameters := PAnsiChar(aParameters);
  sei.nShow := SW_SHOWNORMAL;
  if not ShellExecuteEX(@sei) then
    RaiseLastOSError;
end;

function IsUACActive: Boolean;
var
  Reg: TRegistry;
begin
  Result := FALSE;

  // There's a chance it's active as we're on Vista or Windows 7. Now check the registry
  if CheckWin32Version(6, 0) then
  begin
    Reg := TRegistry.Create;
    try
      Reg.RootKey := HKEY_LOCAL_MACHINE;

      if Reg.OpenKeyReadOnly('SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System') then
      begin
        if (Reg.ValueExists('EnableLUA')) and (Reg.ReadBool('EnableLUA')) then
          Result := TRUE;
      end;
    finally
      FreeAndNil(Reg);
    end;
  end;
end;

//ExecuteFile(Self.Handle, 'Filename', 'Parameters', [eoHide, eoWait, eoElevate]);
function ExecuteFile(Handle: HWND; const Filename, Paramaters: String; Options: TExecuteFileOptions): Integer;
var
  ShellExecuteInfo: TShellExecuteInfo;
  ExitCode: DWORD;
begin
  Result := -1;

  ZeroMemory(@ShellExecuteInfo, SizeOf(ShellExecuteInfo));
  ShellExecuteInfo.cbSize := SizeOf(TShellExecuteInfo);
  ShellExecuteInfo.Wnd := Handle;
  ShellExecuteInfo.fMask := SEE_MASK_NOCLOSEPROCESS;

  if (eoElevate in Options) and (IsUACActive) then
    ShellExecuteInfo.lpVerb := PChar('runas');

  ShellExecuteInfo.lpFile := PChar(Filename);

  if Paramaters <> '' then
    ShellExecuteInfo.lpParameters := PChar(Paramaters);

  // Show or hide the window
  if eoHide in Options then
    ShellExecuteInfo.nShow := SW_HIDE
  else
    ShellExecuteInfo.nShow := SW_SHOWNORMAL;

  if ShellExecuteEx(@ShellExecuteInfo) then
    Result := 0;

  if (Result = 0) and (eoWait in Options) then
  begin
    GetExitCodeProcess(ShellExecuteInfo.hProcess, ExitCode);

    while (ExitCode = STILL_ACTIVE) and
          (not Application.Terminated) do
    begin
      sleep(50);

      GetExitCodeProcess(ShellExecuteInfo.hProcess, ExitCode);
    end;

    Result := ExitCode;
  end;
end;

end.
