///<summary> This unit contains operating system dependent functions, at least some of them. </summary>
unit u_dzOsUtils;

interface

uses
  Windows,
  SysUtils,
  Classes,
  u_dzTranslator;

type
  EOsFunc = class(Exception);
  EOFNoFileinfo = class(EOsFunc);

///<summary> Determines the computername
///          @returns a string with the computername, or an empty string if there was an error </summary>
function GetComputerName: string;

///<summary> Determines the name of the user who runs this program.
///          @returns a string with the user logon name </summary>
function GetUserName: string;

///<summary> Returns the current user's home directory.
///          Examines the environment variable HOME and if that is not
///          set, it concatenates HOMEDRV and HOMEPATH </summary>
function GetHomeDir: string;

///<summary> Calls the windows function with the same name and returns its result </summary>
function ExpandEnvironmentStrings(const _WithVariables: string): string;
///<summary> Calls the windows API function GetEnvironmentStrings and returns them result
///          in the string list.
///          @param Vars is the string list that contains the environment
///          @returns true, if the function succeeded, false otherwise. </summary>
function GetEnvironmentVars(const _Vars: TStrings): Boolean;

///<summary> Reads an integer value from the registry.
///          @param RootKey is the HK_* constant specifying the registry branch to read
///          @param Key is a string specifying the name of registry key to read
///          @param Name is a string specifying the the name of the registry value to read
///          @param Value returns the integer value read from the registry, only valid if
///                       the function result is true.
///          @returns true, if an integer value could be read, false, if it does not exist
///                      or is not an integer value. </summary>
function GetRegValue(_RootKey: HKEY; const _Key, _Name: string; out _Value: Integer): Boolean; overload;

///<summary> Writes a string value from the registry.
///          @param RootKey is the HK_* constant specifying the registry branch to read
///          @param Key is a string specifying the name of registry key to read
///          @param Name is a string specifying the the name of the registry value to read
///          @param Value is the string value to write to the registry. </summary>
procedure SetRegValue(_RootKey: HKEY; const _Key, _Name, _Value: string); overload;

///<summary> Reads a file's version information and returns the four parts of the version
///          number.
///          @param Filename is a string with the name of the file to check, if empty, the
///                 current program is checked.
///          @param Major is a word returning the major version number
///          @param Minor is a word returning the minor version number
///          @param Revision is a word returning the revision number
///          @param Build is a word returning the build number
///          @returns True, if version information was found,
///                   False if the file does not contain any version information </summary>
///          @note: There is also an overloaded version that returns integers.
function GetFileBuildInfo(_Filename: string;
  out _Major, _Minor, _Revision, _Build: Integer): Boolean; overload;

///<summary> Reads a file's version information and returns the four parts of the version
///          number.
///          @param Filename is a string with the name of the file to check, if empty, the
///                 current program is checked.
///          @param Major is an integer returning the major version number
///          @param Minor is an integer returning the minor version number
///          @param Revision is an integer returning the revision number
///          @param Build is an integer returning the build number
///          @returns True, if version information was found,
///                   False if the file does not contain any version information </summary>
///          @note: There is also an overloaded version that returns words.
function GetFileBuildInfo(const _Filename: string;
  out _Major, _Minor, _Revision, _Build: Word): Boolean; overload;

///<summary> Reads a file's version information
///          @param Filename is the file whose version information should be read,
///                          if empty the current program is checked.
///          @param AllowException is a boolean that determines if missing version information
///                                should cause an exception, if false, 'unknown' is returned
///          @returns a string containing the version number as Major.Minor.Revision.Build
///                   or 'unknown' if it can not be determined. </summary>
function GetFileBuildInfo(const _Filename: string = ''; _AllowException: Boolean = False): string; overload;

///<summary> Reads a file's product information and returns the four parts of the version
///          number.
///          @param Filename is a string with the name of the file to check, if empty, the
///                 current program is checked.
///          @param Major is a word returning the major version number
///          @param Minor is a word returning the minor version number
///          @param Revision is a word returning the revision number
///          @param Build is a word returning the build number
///          @returns True, if version information was found,
///                   False if the file does not contain any version information </summary>
function GetFileProductInfo(_Filename: string;
  out _Major, _Minor, _Revision, _Build: Integer): Boolean; overload;

///<summary> Reads a file's product information
///          @param Filename is the file whose version information should be read,
///                          if empty the current program is checked.
///          @param AllowException is a boolean that determines if missing version information
///                                should cause an exception, if false, 'unknown' is returned
///          @returns a string containing the version number as Major.Minor.Revision.Build
///                   or 'unknown' if it can not be determined. </summary>
function GetFileProductInfo(const _Filename: string; _AllowException: Boolean = False): string; overload;

///<summary> @returns the filename of the current module </summary>
function GetModuleFilename: string; overload;
function GetModuleFilename(const _Module: Cardinal): string; overload;

///<summary> registers an open command for a file extension
///          @param Extension is the file extension to register e.g. '.bla'
///          @param DocumentName is the user friendly name for the file type e.g. 'Bla bla file'
///          @param OpenCommand is the command that must be executed to open that file
///                             e.g. '"c:\program files\My Company\My App\myprog.exe" "%1"'
///                             Don't forget to put quotes around both, the executable name and
///                             the parameter, and also don't forget to pass the parameter.
///          @param ShortDocName is an internal, short name for the file type e.g. 'MyProg.bla'
//                               You should always supply one
procedure RegisterFileAssociation(const _Extension, _DocumentName, _OpenCommand: string); overload; deprecated;
procedure RegisterFileAssociation(const _Extension, _ShortDocName, _DocumentName, _OpenCommand: string); overload;

function OsHasNTSecurity: Boolean;

///<summary> Checks whether the currently logged on user (the one who runs this process) has administrator rights
///          (In Win9x this always returns true, in WinNT+ it checks whether the user is member of the
///          administrators group </summary>
function CurrentUserHasAdminRights: Boolean;

///<summary> tries to open a file with the associated application
///          @param Filename is the name of the file to open
///          @returns true on success, false otherwise </summary>
function OpenFileWithAssociatedApp(const _Filename: string; _ShowAssociateDialog: Boolean = False): Boolean;

///<summary> Calls ShellExecuteEx with the given parameters </summary>
function ShellExecEx(const Filename: string; const Parameters: string;
  const Verb: string; CmdShow: Integer; _ShowAssociateDialog: Boolean = False): Boolean;

///<summary> Simulates mouse movement, so that the screen saver does not start. This is the only
///          way to prevent the screen saver to start from Vista onwards if password protection
///          is enabled. (according to http://stackoverflow.com/a/1675793/49925)
procedure JiggleMouse;

///<summary> Calls Windows.CharToOem </summary>
function CharToOem(const _s: string): AnsiString;
///<summary> Calls Windows.OemToChar </summary>
function OemToChar(const _s: AnsiString): string;

///<summary>
/// @returns true, if the shift key is currently pressed </summary>
function IsShiftDown: Boolean;

function ShutdownWindows(_Force, _Reboot: Boolean): Boolean;

implementation

uses
  Registry,
  ShellApi,
  u_dzMiscUtils;

function _(const _s: string): string; inline;
begin
  Result := dzDGetText(_s, 'dzlib');
end;

function IsShiftDown: Boolean;
var
  State: TKeyboardState;
begin
  GetKeyboardState(State);
  Result := ((State[vk_Shift] and 128) <> 0);
end;

function GetComputerName: string;
var
  Len: Cardinal;
begin
  Len := 2 * MAX_COMPUTERNAME_LENGTH; // just in case it is longer than 15 characters, you never know...
  SetLength(Result, Len + 1);
  if Windows.GetComputerName(@Result[1], Len) then
    SetLength(Result, Len)
  else
    Result := '';
end;

function GetUserName: string;
var
  Groesse: Cardinal;
  LastError: Cardinal;
begin
  Groesse := 80;
  SetLength(Result, Groesse);
  if Windows.GetUserName(PChar(Result), Groesse) then begin
    SetLength(Result, Groesse - 1);
  end else begin
    LastError := GetLastError;
    RaiseLastOSErrorEx(LastError, _('%s (code %d) calling Windows.GetUsername'));
  end;
end;

function ExpandEnvironmentStrings(const _WithVariables: string): string;
var
  Res: Integer;
  MaxLen: Integer;
  LastError: Cardinal;
begin
  MaxLen := Length(_WithVariables) + 16 * 1024; // 16 KB should be enough for everybody... ;-)
  SetLength(Result, MaxLen);
  Res := Windows.ExpandEnvironmentStrings(PChar(_WithVariables), PChar(Result), MaxLen);
  if Res > MaxLen then begin
    MaxLen := Res + 1;
    SetLength(Result, MaxLen);
    Res := Windows.ExpandEnvironmentStrings(PChar(_WithVariables), PChar(Result), MaxLen);
  end;
  if Res = 0 then begin
    LastError := GetLastError;
    RaiseLastOSErrorEx(LastError, _('Error %1:s (%0:d) calling Windows.ExpandEnvironmentStrings'));
  end;
  SetLength(Result, Res - 1);
end;

function GetEnvironmentVars(const _Vars: TStrings): Boolean;
var
  Vars: PChar;
  p: PChar;
begin
  Result := False;
  _Vars.BeginUpdate;
  try
    _Vars.Clear;
    Vars := Windows.GetEnvironmentStrings;
    if Vars <> nil then begin
      try
        p := Vars;
        while p^ <> #0 do begin
          _Vars.Add(p);
          p := StrEnd(p);
          Inc(p);
        end;
      finally
        Windows.FreeEnvironmentStrings(Vars);
      end;
      Result := True;
    end;
  finally
    _Vars.EndUpdate;
  end;
end;

function GetHomeDir: string;
begin
  Result := GetEnvironmentVariable('HOME');
  if Result = '' then
    Result := GetEnvironmentVariable('HOMEDRIVE') + GetEnvironmentVariable('HOMEPATH');
end;

function GetRegValue(_RootKey: HKEY; const _Key, _Name: string; out _Value: Integer): Boolean;
var
  Reg: TRegistry;
begin
  Result := False;
  Reg := TRegistry.Create;
  try
    Reg.RootKey := _RootKey;
    if Reg.OpenKeyReadOnly(_Key) then
      try
        try
          _Value := Reg.ReadInteger(_Name);
          Result := True;
        except
          // ignore exceptions, return false
        end; //FI:W501
      finally
        Reg.CloseKey;
      end
  finally
    Reg.Free;
  end;
end;

procedure SetRegValue(_RootKey: HKEY; const _Key, _Name, _Value: string); overload;
var
  Reg: TRegistry;
begin
  Reg := TRegistry.Create;
  try
    Reg.RootKey := _RootKey;
    if Reg.OpenKey(_Key, True) then
      try
        Reg.WriteString(_Name, _Value);
      finally
        Reg.CloseKey;
      end
  finally
    Reg.Free;
  end;
end;

procedure RegisterFileAssociation(const _Extension, _ShortDocName, _DocumentName, _OpenCommand: string);
begin
  SetRegValue(HKEY_CLASSES_ROOT, _Extension, '', _ShortDocName);
  SetRegValue(HKEY_CLASSES_ROOT, _ShortDocName, '', _DocumentName);
  SetRegValue(HKEY_CLASSES_ROOT, Format('%s\shell\command', [_ShortDocName]), '', _OpenCommand);
end;

procedure RegisterFileAssociation(const _Extension, _DocumentName, _OpenCommand: string);
begin
  RegisterFileAssociation(_Extension, _DocumentName, _DocumentName, _OpenCommand);
end;

function GetModuleFilename(const _Module: Cardinal): string;
var
  Buffer: array[0..260] of Char;
begin
  SetString(Result, Buffer, Windows.GetModuleFilename(_Module, Buffer, SizeOf(Buffer)))
end;

function GetModuleFilename: string;
begin
  Result := GetModuleFilename(HInstance);
end;

function GetFileBuildInfo(_Filename: string;
  out _Major, _Minor, _Revision, _Build: Integer): Boolean;
var
  VerInfoSize: DWORD;
  VerInfo: Pointer;
  VerValueSize: DWORD;
  VerValue: PVSFixedFileInfo;
  Dummy: DWORD;
begin
  if _Filename = '' then
    _Filename := GetModuleFilename;
  VerInfoSize := GetFileVersionInfoSize(PChar(_Filename), Dummy);
  Result := (VerInfoSize <> 0);
  if Result then begin
    GetMem(VerInfo, VerInfoSize);
    try
      GetFileVersionInfo(PChar(_Filename), 0, VerInfoSize, VerInfo);
      VerQueryValue(VerInfo, '\', Pointer(VerValue), VerValueSize);
      with VerValue^ do begin
        _Major := dwFileVersionMS shr 16;
        _Minor := dwFileVersionMS and $FFFF;
        _Revision := dwFileVersionLS shr 16;
        _Build := dwFileVersionLS and $FFFF;
      end;
    finally
      FreeMem(VerInfo, VerInfoSize);
    end;
  end;
end;

function GetFileProductInfo(_Filename: string;
  out _Major, _Minor, _Revision, _Build: Integer): Boolean;
var
  VerInfoSize: DWORD;
  VerInfo: Pointer;
  VerValueSize: DWORD;
  VerValue: PVSFixedFileInfo;
  Dummy: DWORD;
begin
  if _Filename = '' then
    _Filename := GetModuleFilename;
  VerInfoSize := GetFileVersionInfoSize(PChar(_Filename), Dummy);
  Result := (VerInfoSize <> 0);
  if Result then begin
    GetMem(VerInfo, VerInfoSize);
    try
      GetFileVersionInfo(PChar(_Filename), 0, VerInfoSize, VerInfo);
      VerQueryValue(VerInfo, '\', Pointer(VerValue), VerValueSize);
      with VerValue^ do begin
        _Major := dwProductVersionMS shr 16;
        _Minor := dwProductVersionMS and $FFFF;
        _Revision := dwProductVersionLS shr 16;
        _Build := dwProductVersionLS and $FFFF;
      end;
    finally
      FreeMem(VerInfo, VerInfoSize);
    end;
  end;
end;

function GetFileBuildInfo(const _Filename: string;
  out _Major, _Minor, _Revision, _Build: Word): Boolean;
var
  Major, Minor, Revision, Build: Integer;
begin
  Result := GetFileBuildInfo(_Filename, Major, Minor, Revision, Build);
  if Result then begin
    _Major := Major;
    _Minor := Minor;
    _Revision := Revision;
    _Build := Build;
  end;
end;

function GetFileBuildInfo(const _Filename: string; _AllowException: Boolean): string;
var
  Major: Integer;
  Minor: Integer;
  Revision: Integer;
  Build: Integer;
begin
  if GetFileBuildInfo(_Filename, Major, Minor, Revision, Build) then
    Result := Format('%d.%d.%d.%d', [Major, Minor, Revision, Build])
  else if _AllowException then
    raise EOFNoFileinfo.CreateFmt(_('No version information available for %s'), [_Filename])
  else
    Result := 'unknown';
end;

function GetFileProductInfo(const _Filename: string; _AllowException: Boolean): string;
var
  Major: Integer;
  Minor: Integer;
  Revision: Integer;
  Build: Integer;
begin
  if GetFileProductInfo(_Filename, Major, Minor, Revision, Build) then
    Result := Format('%d.%d.%d.%d', [Major, Minor, Revision, Build])
  else if _AllowException then
    raise EOFNoFileinfo.CreateFmt(_('No version information available for %s'), [_Filename])
  else
    Result := 'unknown';
end;

function OsHasNTSecurity: Boolean;
var
  vi: TOSVersionInfo;
begin
  FillChar(vi, SizeOf(vi), 0);
  vi.dwOSVersionInfoSize := SizeOf(vi);
  GetVersionEx(vi);
  Result := (vi.dwPlatformId = VER_PLATFORM_WIN32_NT);
end;

const
  SECURITY_NT_AUTHORITY: SID_IDENTIFIER_AUTHORITY = (Value: (0, 0, 0, 0, 0, 5)); // ntifs

  SECURITY_BUILTIN_DOMAIN_RID: DWORD = $00000020;
  DOMAIN_ALIAS_RID_ADMINS: DWORD = $00000220;
  DOMAIN_ALIAS_RID_USERS: DWORD = $00000221;
  DOMAIN_ALIAS_RID_GUESTS: DWORD = $00000222;
  DOMAIN_ALIAS_RID_POWER_: DWORD = $00000223;

function CurrentUserIsInAdminGroup: Boolean;
var
  bSuccess: Boolean;
  psidAdministrators: Pointer;
  X: Integer;
  ptgGroups: PTokenGroups;
  hAccessToken: THandle;
  dwInfoBufferSize: Cardinal;
begin
  Result := False;
  bSuccess := OpenThreadToken(GetCurrentThread, TOKEN_QUERY, True, hAccessToken);
  if not bSuccess then begin
    if GetLastError = ERROR_NO_TOKEN then
      bSuccess := OpenProcessToken(GetCurrentProcess, TOKEN_QUERY, hAccessToken);
  end;
  if bSuccess then begin
    try
      GetMem(ptgGroups, 1024);
      try
        bSuccess := GetTokenInformation(hAccessToken, TokenGroups, ptgGroups, 1024, dwInfoBufferSize);
        if bSuccess then begin
          AllocateAndInitializeSid(SECURITY_NT_AUTHORITY, 2, SECURITY_BUILTIN_DOMAIN_RID, DOMAIN_ALIAS_RID_ADMINS, 0, 0, 0, 0, 0, 0, psidAdministrators);
          try
{$R-}
            for X := 0 to ptgGroups.GroupCount - 1 do
              if EqualSid(psidAdministrators, ptgGroups.Groups[X].Sid) then begin
                Result := True;
                Break;
              end;
          finally
{$R+}
            FreeSid(psidAdministrators);
          end;
        end;
      finally
        FreeMem(ptgGroups);
      end;
    finally
      CloseHandle(hAccessToken);
    end;
  end;
end;

type
  TCheckTokenMembership = function(TokenHandle: THandle; SidToCheck: PSID; var IsMember: BOOL): BOOL; Stdcall;
var
  CheckTokenMembership: TCheckTokenMembership = nil;

function IsUserAdmin: Boolean;
var
  b: BOOL;
  AdministratorsGroup: PSID;
  Hdl: HMODULE;
begin
  {
    This function returns true if you are currently running with admin privileges.
    In Vista and later, if you are non-elevated, this function will return false
    (you are not running with administrative privileges).
    If you *are* running elevated, then IsUserAdmin will return true, as you are
    running with admin privileges.

    Windows provides this similar function in Shell32.IsUserAnAdmin.
    But the function is deprecated, and this code is lifted
    from the docs for CheckTokenMembership:
      http://msdn.microsoft.com/en-us/library/aa376389.aspx
  }

  {
    Routine Description: This routine returns TRUE if the callers
    process is a member of the Administrators local group. Caller is NOT
    expected to be impersonating anyone and is expected to be able to
    open its own process and process token.
      Arguments: None.
      Return Value:
        TRUE - Caller has Administrators local group.
        FALSE - Caller does not have Administrators local group.
  }
  { idea from:
    http://stackoverflow.com/a/8290384/49925
    but heavily modified }
  Result := False;
  if not AllocateAndInitializeSid(
    SECURITY_NT_AUTHORITY,
    2, //2 sub-authorities
    SECURITY_BUILTIN_DOMAIN_RID, //sub-authority 0
    DOMAIN_ALIAS_RID_ADMINS, //sub-authority 1
    0, 0, 0, 0, 0, 0, //sub-authorities 2-7 not passed
    AdministratorsGroup) then
    Exit; //=>
  try
    if @CheckTokenMembership = nil then begin
      Hdl := LoadLibrary(advapi32);
      if Hdl = 0 then
        Exit; //=>
      @CheckTokenMembership := GetProcAddress(Hdl, 'CheckTokenMembership');
      if @CheckTokenMembership = nil then begin
        FreeLibrary(Hdl);
        Exit; //=>
      end;
    end;
    if CheckTokenMembership(0, AdministratorsGroup, b) then
      Result := b;
  finally
    FreeSid(AdministratorsGroup);
  end;
end;

function CurrentUserHasAdminRights: Boolean;
begin
  if OsHasNTSecurity then
    Result := IsUserAdmin // CurrentUserIsInAdminGroup
  else
    Result := True;
end;

function ShellExecEx(const Filename: string; const Parameters: string;
  const Verb: string; CmdShow: Integer; _ShowAssociateDialog: Boolean = False): Boolean;
var
  Sei: TShellExecuteInfo;
begin
  FillChar(Sei, SizeOf(Sei), #0);
  Sei.cbSize := SizeOf(Sei);
  Sei.FMask := SEE_MASK_DOENVSUBST;
  if not _ShowAssociateDialog then
    Sei.FMask := Sei.FMask or SEE_MASK_FLAG_NO_UI;
  Sei.lpFile := PChar(Filename);
  if Parameters <> '' then
    Sei.lpParameters := PChar(Parameters)
  else
    Sei.lpParameters := nil;
  if Verb <> '' then
    Sei.lpVerb := PChar(Verb)
  else
    Sei.lpVerb := nil;
  Sei.nShow := CmdShow;
  Result := ShellExecuteEx(@Sei);
end;

function OpenFileWithAssociatedApp(const _Filename: string; _ShowAssociateDialog: Boolean = False): Boolean;
begin
  Result := ShellExecEx(_Filename, '', 'open', SW_SHOWNORMAL, _ShowAssociateDialog);
end;

procedure JiggleMouse;
var
  Inpt: TInput;
begin
  Inpt.Itype := INPUT_MOUSE;
  Inpt.mi.dx := 0;
  Inpt.mi.dy := 0;
  Inpt.mi.mouseData := 0;
  Inpt.mi.dwFlags := MOUSEEVENTF_MOVE;
  Inpt.mi.Time := 0;
  Inpt.mi.dwExtraInfo := 0;
  SendInput(1, Inpt, SizeOf(Inpt));
end;

function CharToOem(const _s: string): AnsiString;
begin
  SetLength(Result, Length(_s));
  Windows.CharToOem(PChar(_s), PAnsiChar(Result))
end;

function OemToChar(const _s: AnsiString): string;
begin
  SetLength(Result, Length(_s));
  Windows.OemToChar(PAnsiChar(_s), PChar(Result));
end;

function ShutdownWindows(_Force, _Reboot: Boolean): Boolean;
var
  hToken: THandle;
  tp: TTokenPrivileges;
  h,
    Flag: DWORD;
begin
  // if Windows NT/2000/XP or later, we first need to get the rights
  if (Win32Platform = VER_PLATFORM_WIN32_NT) then begin
    Flag := EWX_POWEROFF;
    OpenProcessToken(GetCurrentProcess, TOKEN_ADJUST_PRIVILEGES, hToken);
    LookupPrivilegeValue(nil, 'SeShutdownPrivilege', tp.Privileges[0].Luid);
    tp.PrivilegeCount := 1;
    tp.Privileges[0].Attributes := SE_PRIVILEGE_ENABLED;
    h := 0;
    AdjustTokenPrivileges(hToken, False, tp, 0, PTokenPrivileges(nil)^, h);
    CloseHandle(hToken);
  end else
    Flag := EWX_SHUTDOWN; // Win 98 / ME

  if _Force then
    Flag := Flag or EWX_FORCE;
  if _Reboot then
    Flag := Flag or EWX_REBOOT;

  Result := ExitWindowsEx(Flag, 0);
end;

end.

