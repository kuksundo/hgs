
{*******************************************************}
{                                                       }
{                 IPScan Version 1.5                    }
{                                                       }
{         Copyright (c) 1999-2016 Vadim Crits           }
{                                                       }
{*******************************************************}

program IPScan;

{$APPTYPE CONSOLE}
{$R-}
{$IF CompilerVersion >= 24}
  {$LEGACYIFEND ON}
{$IFEND}

uses
  Windows,
  SysUtils,
  NB30,
  WinSock,
  IPHlpApi,
  NetUtils,
  NetConst
{$IF CompilerVersion > 24}
  , AnsiStrings
{$IFEND};

{$R IPScan.res}

type
  PNBStat = ^TNBStat;
  TNBStat = record
    AdapterStatus: TAdapterStatus;
    NameBuffer: array[0..254] of TNameBuffer;
  end;

  PNBInfo = ^TNBInfo;
  TNBInfo = record
    ComputerName: array[0..NCBNAMSZ - 1] of AnsiChar;
    GroupName: array[0..NCBNAMSZ - 1] of AnsiChar;
    MacAddress: array[0..17] of AnsiChar;
  end;

var
  StartAddress, EndAddress, CurrentAddress: Longint;
  dwTimeOut: DWORD = 1000;
  LanaEnum: TLanaEnum;
  hIcmp: THandle;
  CSect: TRTLCriticalSection;
  I, J: Integer;
  Params: array[0..MAXIMUM_WAIT_OBJECTS - 1] of Longint;
  Handles: array[0..MAXIMUM_WAIT_OBJECTS - 1] of THandle;
  ThreadId: DWORD;

function GetLana(var LanaEnum: TLanaEnum): Boolean;
var
  NCB: TNCB;
begin
  FillChar(LanaEnum, SizeOf(TLanaEnum), 0);
  FillChar(NCB, SizeOf(TNCB), 0);
  with NCB do
  begin
    ncb_command := AnsiChar(NCBENUM);
    ncb_buffer := PAnsiChar(@LanaEnum);
    ncb_length := SizeOf(TLanaEnum);
    Netbios(@NCB);
    Result := (ncb_retcode = AnsiChar(NRC_GOODRET)) and (Byte(LanaEnum.length) > 0);
  end;
end;

function NBReset(const LanaNum: AnsiChar): Boolean;
var
  NCB: TNCB;
begin
  FillChar(NCB, SizeOf(TNCB), 0);
  with NCB do
  begin
    ncb_command := AnsiChar(NCBRESET);
    ncb_lana_num := LanaNum;
    Netbios(@NCB);
    Result := (ncb_retcode = AnsiChar(NRC_GOODRET));
  end;
end;

function GetNetBiosInfo(const LanaNum: AnsiChar; const IpAddress: string;
  var NBInfo: TNBInfo): Boolean;
var
  NCB: TNCB;
  NBStat: TNBStat;
  I: Integer;
begin
  FillChar(NCB, SizeOf(TNCB), 0);
  FillChar(NBStat, SizeOf(TNBStat), 0);
  with NCB do
  begin
    ncb_command := AnsiChar(NCBASTAT);
    ncb_buffer := PAnsiChar(@NBStat);
    ncb_length := SizeOf(TNBStat);
    {$IF CompilerVersion > 24}AnsiStrings.{$IFEND}
    StrCopy(ncb_callname, PAnsiChar(AnsiString(IpAddress)));
    ncb_lana_num := LanaNum;
    NetBios(@NCB);
    Result := ncb_retcode = AnsiChar(NRC_GOODRET);
    with NBStat, NBInfo do
      if Result then
      begin
        for I := 0 to AdapterStatus.name_count - 1 do
          if (NameBuffer[I].Name[15] = #0) then
          begin
            case NameBuffer[I].name_flags of
              AnsiChar(UNIQUE_NAME + REGISTERED):
                {$IF CompilerVersion > 24}AnsiStrings.{$IFEND}
                StrCopy(@ComputerName,
                  PAnsiChar(AnsiString(Trim(string(NameBuffer[I].Name)))));
              AnsiChar(GROUP_NAME + REGISTERED):
                {$IF CompilerVersion > 24}AnsiStrings.{$IFEND}
                StrCopy(@GroupName,
                  PAnsiChar(AnsiString(Trim(string(NameBuffer[I].Name)))));
            end;
            if (ComputerName <> '') and (GroupName <> '') then
              Break;
          end;
        {$IF CompilerVersion > 24}AnsiStrings.{$IFEND}
        StrCopy(@MacAddress, PAnsiChar(AnsiString(
          FormatMacAddress(PByteArray(@AdapterStatus.adapter_address)^))));
      end
      else
      begin
        {$IF CompilerVersion > 24}AnsiStrings.{$IFEND}
        StrCopy(@ComputerName, PAnsiChar(AnsiString(SUnknown)));
        {$IF CompilerVersion > 24}AnsiStrings.{$IFEND}
        StrCopy(@GroupName, PAnsiChar(AnsiString(SUnknown)));
        {$IF CompilerVersion > 24}AnsiStrings.{$IFEND}
        StrCopy(@MacAddress, PAnsiChar(AnsiString(SUnknown)));
      end;
  end;
end;

function Ping(IpAddress: DWORD): Boolean;
const
  BUFFER_SIZE  = 32;
var
  pIpe: PIcmpEchoReply;
  PingBuffer: Pointer;
  dwRetVal: DWORD;
begin
  GetMem(pIpe, SizeOf(TICMPEchoReply) + BUFFER_SIZE);
  try
    GetMem(PingBuffer, BUFFER_SIZE);
    try
      FillChar(PingBuffer^, BUFFER_SIZE, $AA);
      pIpe^.Data := PingBuffer;
      dwRetVal := IcmpSendEcho(hIcmp, IpAddress, PingBuffer, BUFFER_SIZE, nil,
                               pIpe, SizeOf(TICMPEchoReply) + BUFFER_SIZE, dwTimeOut);
      Result := dwRetVal <> 0;
    finally
      FreeMem(PingBuffer);
    end;
  finally
    FreeMem(pIpe);
  end;
end;

function Execute(P: Pointer): Integer;
var
  dwIpAddr: DWORD;
  IpAddress: string;
  I: Integer;
  NBInfo: TNBInfo;
begin
  dwIpAddr := ntohl(PDWORD(P)^);
  if Ping(dwIpAddr) then
  begin
    IpAddress := FormatIpAddress(dwIpAddr);
    for I := 0 to Byte(LanaEnum.length) - 1 do
    begin
      FillChar(NBInfo, SizeOf(TNBInfo), 0);
      if GetNetBiosInfo(LanaEnum.lana[I], IpAddress, NBInfo) then
        Break;
    end;
    EnterCriticalSection(CSect);
    try
      Writeln(Format('%-16s%-16s%-16s%-17s', [IpAddress, NBInfo.ComputerName,
                                              NBInfo.GroupName, NBInfo.MacAddress]));
    finally
      LeaveCriticalSection(CSect);
    end;
  end;
  Result := 0;
end;

begin
  if (ParamCount < 2) or (ParamCount > 4) then
  begin
    Writeln(SUsage);
    Halt;
  end;
  StartAddress := htonl(inet_addr(PAnsiChar(AnsiString(ParamStr(1)))));
  if (StartAddress = Longint(INADDR_NONE)) or (Pos('.', ParamStr(1)) = 0) then
  begin
    Writeln;
    Writeln(SInvalidStartIp);
    Halt;
  end;
  EndAddress := htonl(inet_addr(PAnsiChar(AnsiString(ParamStr(2)))));
  if (EndAddress = Longint(INADDR_NONE)) or (Pos('.', ParamStr(2)) = 0) then
  begin
    Writeln;
    Writeln(SInvalidEndIp);
    Halt;
  end;
  if StartAddress > EndAddress then
  begin
    Writeln;
    Writeln(SStartIpGreaterEndIpErr);
    Halt;
  end;
  if ParamCount > 2 then
    if FindCmdLineSwitch('w', ['-'], True) then
      try
        if StrToInt(ParamStr(4)) > 0 then
          dwTimeOut := StrToInt(ParamStr(4))
        else
          Abort;
      except
        Writeln;
        Writeln(SInvalidTimeout);
        Halt;
      end
    else
    begin
      Writeln;
      Writeln(SInvalidSwitch);
      Halt;
    end;
  if not GetLana(LanaEnum) then
  begin
    Writeln;
    Writeln(SProblemWithNic);
    Halt;
  end;
  if Win32Platform = VER_PLATFORM_WIN32_NT then
    for I := 0 to Byte(LanaEnum.length) - 1 do
      if not NBReset(LanaEnum.lana[I]) then
      begin
        Writeln;
        Writeln(SResetLanaErr);
        Halt;
      end;
  hIcmp := IcmpCreateFile;
  if hIcmp = INVALID_HANDLE_VALUE then
  begin
    Writeln;
    Writeln(SIcmpInitErr);
    Halt;
  end;
  Writeln;
  Writeln(Format('%-16s%-16s%-16s%-17s', [SIpAddress, SComputer, SGroup, SMacAddress]));
  Writeln(StringOfChar('=', 65));
  CurrentAddress := StartAddress;
  FillChar(Params, SizeOf(Params), 0);
  FillChar(Handles, SizeOf(Handles), 0);
  InitializeCriticalSection(CSect);
  try
    I := 0;
    while True do
    begin
      Params[I] := CurrentAddress;
      Handles[I] := BeginThread(nil, 0, Execute, @Params[I], 0, ThreadID);
      Inc(I);
      if (I = MAXIMUM_WAIT_OBJECTS) or (CurrentAddress = EndAddress) then
      begin
        WaitForMultipleObjects(I, @Handles[0], True, INFINITE);
        for J := 0 to I - 1 do
          CloseHandle(Handles[J]);
        FillChar(Params, SizeOf(Params), 0);
        FillChar(Handles, SizeOf(Handles), 0);
        I := 0;
      end;
      if CurrentAddress = EndAddress then
        Break
      else
        Inc(CurrentAddress);
    end;
  finally
    DeleteCriticalSection(CSect);
    IcmpCloseHandle(hIcmp);
  end;
end.
