program IPConSvc;

{$IF CompilerVersion >= 24}
  {$LEGACYIFEND ON}
{$IFEND}

uses
  InitFont,
  SvcMgr,
  Forms,
  Windows,
  SysUtils,
  WinSvc,
  NetConst,
  SvcMain in 'SvcMain.pas' {ConnForm},
  CSConst in 'CSConst.pas';

{$R *.res}
{$R IPConSvc_Icon.res}

function Installing: Boolean;
begin
  Result := FindCmdLineSwitch('INSTALL', ['-', '\', '/'], True) or
    FindCmdLineSwitch('UNINSTALL', ['-', '\', '/'], True);
end;

function StartService: Boolean;

  function LocalSystemUserName: string;
  const
   SECURITY_NT_AUTHORITY: TSIDIdentifierAuthority = (Value: (0, 0, 0, 0, 0, 5));
   SECURITY_LOCAL_SYSTEM_RID: DWORD = $00000012;
  var
    IdentifierAuthority: TSIDIdentifierAuthority;
    Sid: PSID;
    NameSize, DomainSize: DWORD;
    UserName, DomainName: string;
    SidNameUse: SID_NAME_USE;
  begin
    Result := '';
    IdentifierAuthority := SECURITY_NT_AUTHORITY;
    if AllocateAndInitializeSid(IdentifierAuthority, 1,
      SECURITY_LOCAL_SYSTEM_RID, 0, 0, 0, 0, 0, 0, 0, Sid) then
      if Assigned(Sid) then
      try
        NameSize := 0;
        DomainSize := 0;
        LookupAccountSID(nil, Sid, nil, NameSize, nil, DomainSize, SidNameUse);
        if GetLastError = ERROR_INSUFFICIENT_BUFFER then
        begin
          SetLength(UserName, NameSize);
          SetLength(DomainName, DomainSize);
          if LookupAccountSid(nil, Sid, PChar(UserName), NameSize,
            PChar(DomainName), DomainSize, SidNameUse) then
          begin
            SetLength(UserName, NameSize);
            Result := UserName;
          end;
        end;
      finally
        FreeSid(Sid);
      end;
  end;

var
  Mgr, Svc: Integer;
  UserName, ServiceStartName: string;
  Config: Pointer;
  Size: DWORD;
begin
  Result := False;
  Mgr := OpenSCManager(nil, nil, SC_MANAGER_ALL_ACCESS);
  if Mgr <> 0 then
  begin
    Svc := OpenService(Mgr, PChar(SServiceName), SERVICE_ALL_ACCESS);
    Result := Svc <> 0;
    if Result then
    begin
      QueryServiceConfig(Svc, nil, 0, Size);
      Config := AllocMem(Size);
      try
        QueryServiceConfig(Svc, Config, Size, Size);
        ServiceStartName := PQueryServiceConfig(Config)^.lpServiceStartName;
        if CompareText(ServiceStartName, 'LocalSystem') = 0 then
          ServiceStartName := LocalSystemUserName;
      finally
        Dispose(Config);
      end;
      CloseServiceHandle(Svc);
    end;
    CloseServiceHandle(Mgr);
  end;
  if Result then
  begin
    Size := 256;
    SetLength(UserName, Size);
    GetUserName(PChar(UserName), Size);
    SetLength(UserName, StrLen(PChar(UserName)));
    Result := CompareText(UserName, ServiceStartName) = 0;
  end;
end;

begin
  if not Installing then
  begin
    CreateMutex(nil, True, 'IPCONNSVC');
    if GetLastError in [ERROR_ALREADY_EXISTS, ERROR_ACCESS_DENIED] then
    begin
      MessageBox(0, PChar(SAlreadyRunning), PChar(SServiceTitle),
        MB_OK or MB_ICONERROR);
      Halt;
    end;
  end;
  if Installing or StartService then
  begin
    SvcMgr.Application.Initialize;
    ConnService := TConnService.CreateNew(SvcMgr.Application, 0);
    if not Installing then
    begin
      SvcMgr.Application.CreateForm(TConnForm, ConnForm);
      ConnForm.Initialize(False);
    end;
    SvcMgr.Application.Run;
  end
  else
  begin
    Forms.Application.Initialize;
  {$IF CompilerVersion >= 18.5}
    Application.MainFormOnTaskBar := True;
  {$IFEND}
    Forms.Application.ShowMainForm := False;
    Forms.Application.CreateForm(TConnForm, ConnForm);
    ConnForm.Initialize(True);
    Forms.Application.Run;
  end;
end.