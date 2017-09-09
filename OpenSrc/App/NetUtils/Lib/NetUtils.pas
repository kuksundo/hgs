unit NetUtils;

interface

uses
  Windows, IPHlpApi;

const
  NI_NOFQDN      = $01;
  NI_NUMERICHOST = $02;
  NI_NAMEREQD    = $04;
  NI_NUMERICSERV = $08;
  NI_DGRAM       = $10;

  NI_MAXHOST     = 1025;
  NI_MAXSERV     = 32;

  TcpStateNames: array[TMibTcpState] of string = (
    'CLOSED',
    'LISTENING',
    'SYN_SENT',
    'SYN_RECEIVED',
    'ESTABLISHED',
    'FIN_WAIT_1',
    'FIN_WAIT_2',
    'CLOSE_WAIT',
    'CLOSING',
    'LAST_ACK',
    'TIME_WAIT',
    'DELETE_TCB');

type
  PHostBuf = ^THostBuf;
  THostBuf = array[0..NI_MAXHOST - 1] of AnsiChar;

  PServBuf = ^TServBuf;
  TServBuf = array[0..NI_MAXSERV - 1] of AnsiChar;

  PAddrInfo = ^TAddrInfo;
  TAddrInfo = record
    ai_flags: Integer;
    ai_family: Integer;
    ai_socktype: Integer;
    ai_protocol: Integer;
    ai_addrlen: LongWord;
    ai_canonname: PAnsiChar;
    ai_addr: PSockAddr;
    ai_next: PAddrInfo;
  end;

procedure GetFileVersion(const FileName: string; var Version, Build: string);
function FormatIpAddress(Value: LongWord): string; overload;
function FormatIpAddress(const Value: TSockAddrInet;
  WithScopeId: Boolean = False): string; overload;
function FormatIpv6Address(const Value: array of Byte): string;
function IpAddressPrefixToIpv4Mask(Value: LongWord): string;
function IsZeroIpAddress(const Value: TSockAddrInet): Boolean;
function FormatMacAddress(const Value: array of Byte): string;
function FormatNumber(Value: Int64): string;
function CompareNumber(N1, N2: Integer): Integer;
function AlignString(const Value: string): string;
function AlignIpAddress(const Value: string): string;
function AlignAddress(const Value: string): string;
function CheckMacAddress(const Value: string): Boolean;
function CheckIpAddress(const Value: string): Boolean;
function CheckPort(const Value: string): Boolean;
procedure DecodeMSecs(const MSecs: LongWord; var Days, Hours, Mins, Secs: Word);
procedure SendMagicPacket(const MacAddress, IpAddress: string; Port: Word);
function getnameinfo(sa: PSockAddr; salen: Integer; host: PAnsiChar;
  hostlen: DWORD; serv: PAnsiChar; servlen: DWORD; flags: Integer): Integer; stdcall;
function getaddrinfo(pNodeName, pServiceName: PAnsiChar; pHints: PAddrInfo;
  var ppResult: PAddrInfo): Integer; stdcall;
procedure freeaddrinfo(pAddrInfo: PAddrInfo); stdcall;

implementation

uses SysUtils, WinSock, Math;

procedure GetFileVersion(const FileName: string; var Version, Build: string);
var
  dwSize: DWORD;
  Buffer: Pointer;
  FileInfo: PVSFixedFileInfo;
begin
  dwSize := GetFileVersionInfoSize(PChar(FileName), dwSize);
  if dwSize > 0 then
  begin
    Buffer := AllocMem(dwSize);
    try
      GetFileVersionInfo(PChar(FileName), 0, dwSize, Buffer);
      VerQueryValue(Buffer, '\', Pointer(FileInfo), dwSize);
      Version := Format('%d.%d', [FileInfo.dwFileVersionMS shr 16,
                                  FileInfo.dwFileVersionMS and $FFFF]);
      Build := Format('%d.%d', [FileInfo.dwFileVersionLS shr 16,
                                FileInfo.dwFileVersionLS and $FFFF]);
    finally
      FreeMem(Buffer);
    end;
  end;
end;

function FormatIpAddress(Value: LongWord): string;
begin
  Result := Format('%u.%u.%u.%u', [Value and $FF,
                                  (Value shr 8) and $FF,
                                  (Value shr 16) and $FF,
                                  (Value shr 24) and $FF]);
end;

function FormatIpAddress(const Value: TSockAddrInet;
  WithScopeId: Boolean = False): string;
var
  Buf: array[0..45] of WideChar;
begin
  with Value do
    if si_family = AF_INET then
      Result := FormatIpAddress(Ipv4.sin_addr.S_un.S_addr)
    else
    begin
      Result := '';
      if Assigned(RtlIpv6AddressToString(@Ipv6.sin6_addr, Buf)) then
      begin
        Result := Buf;
        if WithScopeId and (Ipv6.sin6_scope_id <> 0) then
          Result := Result + '%' + IntToStr(Ipv6.sin6_scope_id);
      end;
  end;
end;

function FormatIpv6Address(const Value: array of Byte): string;
begin
  Result := Format('%x:%x:%x:%x:%x:%x:%x:%x', [MakeWord(Value[1], Value[0]),
                                               MakeWord(Value[3], Value[2]),
                                               MakeWord(Value[5], Value[4]),
                                               MakeWord(Value[7], Value[6]),
                                               MakeWord(Value[9], Value[8]),
                                               MakeWord(Value[11], Value[10]),
                                               MakeWord(Value[13], Value[12]),
                                               MakeWord(Value[15], Value[14])]);
end;

function IpAddressPrefixToIpv4Mask(Value: LongWord): string;
begin
  if Value <> 0 then
    Value := not ((1 shl (32 - Value)) - 1);
  Result := Format('%u.%u.%u.%u', [(Value shr 24) and $FF,
                                   (Value shr 16) and $FF,
                                   (Value shr 8) and $FF,
                                    Value and $FF]);
end;

function IsZeroIpAddress(const Value: TSockAddrInet): Boolean;
var
  I: Integer;
begin
  with Value do
    if si_family = AF_INET then
      Result := Ipv4.sin_addr.S_un.S_addr = 0
    else
    begin
      Result := True;
      with Ipv6.sin6_addr.u do
        for I := 0 to High(Byte) do
          if Byte[I] <> 0 then
          begin
            Result := False;
            Break;
          end;
    end;
end;

function FormatMacAddress(const Value: array of Byte): string;
begin
  Result := Format('%2.2x-%2.2x-%2.2x-%2.2x-%2.2x-%2.2x', [Value[0], Value[1],
                                                           Value[2], Value[3],
                                                           Value[4], Value[5]]);
end;

function FormatNumber(Value: Int64): string;
var
  StartIndex, I: Integer;
begin
  Result := IntToStr(Value);
  StartIndex := 1;
  if Value < 0 then
    Inc(StartIndex);
  I := Length(Result) - 2;
  while I > StartIndex do
  begin
    Insert({$IF CompilerVersion > 22}FormatSettings.{$IFEND}
      ThousandSeparator, Result, I);
    Dec(I, 3);
  end;
end;

function CompareNumber(N1, N2: Integer): Integer;
begin
  if N1 < N2 then
    Result := -1
  else if N1 = N2 then
    Result := 0
  else
    Result := 1;
end;

function AlignString(const Value: string): string;
begin
  Result := Format('%25s', [Value]);
end;

function AlignIpAddress(const Value: string): string;
var
  P, Start: PAnsiChar;
  S: string;
begin
  Result := '';
  if Pos(':', Value) > 0 then
    Result := Format('3%60s', [Value])
  else if Pos('.', Value) > 0 then
  begin
    P := PAnsiChar(AnsiString(Value));
    while P^ <> #0 do
    begin
      Start := P;
      while not (P^ in [#0, '.']) do Inc(P);
      SetString(S, Start, P - Start);
      Result := Result + Format('%3s', [S]);
      if P^ <> #0 then
      begin
        Result := Result + '.';
        Inc(P);
      end;
    end;
  end
  else if Value <> '' then
    Result := AlignString(Value);
end;

function AlignAddress(const Value: string): string;
var
  IpAddress, Port: string;
begin
  if Pos('[', Value) > 0 then
  begin
    IpAddress := AlignIpAddress(Copy(Value, 2, Pos(']', Value) - 2));
    Port := Copy(Value, Pos(']', Value) + 2, MaxInt);
  end
  else
  begin
    IpAddress := AlignIpAddress(Copy(Value, 1, Pos(':', Value) - 1));
    Port := Copy(Value, Pos(':', Value) + 1, MaxInt);
  end;
  Result := Format('%s:%5s', [IpAddress, Port]);
end;

function CheckMacAddress(const Value: string): Boolean;
var
  I, N: Integer;
  P, Start: PAnsiChar;
  S: string;
begin
  I := 0;
  P := PAnsiChar(AnsiString(Value));
  while P^ <> #0 do
  begin
    Start := P;
    while not (P^ in [#0, #45]) do Inc(P);
    SetString(S, Start, P - Start);
    if not (TryStrToInt(HexDisplayPrefix + S, N) and (N in [0..255])) then
      Break;
    Inc(I);
    if P^ <> #0 then Inc(P);
  end;
  Result := I = 6;
end;

function CheckIpAddress(const Value: string): Boolean;
var
  I, N: Integer;
  P, Start: PAnsiChar;
  S: string;
begin
  I := 0;
  P := PAnsiChar(AnsiString(Value));
  while P^ <> #0 do
  begin
    Start := P;
    while not (P^ in [#0, #46]) do Inc(P);
    SetString(S, Start, P - Start);
    if not (TryStrToInt(S, N) and (N in [0..255])) then
      Break;
    Inc(I);
    if P^ <> #0 then Inc(P);
  end;
  Result := I = 4;
end;

function CheckPort(const Value: string): Boolean;
var
  I: Integer;
begin
  Result := TryStrToInt(Value, I) and (I >= Low(Word)) and (I <= High(Word));
end;

procedure DecodeMSecs(const MSecs: LongWord; var Days, Hours, Mins, Secs: Word);
begin
  Days := MSecs div MSecsPerDay;
  DivMod(MSecs mod MSecsPerDay div MSecsPerSec, SecsPerMin * MinsPerHour, Hours, Secs);
  DivMod(Secs, SecsPerMin, Mins, Secs);
end;

procedure SendMagicPacket(const MacAddress, IpAddress: string; Port: Word);

  procedure CheckWSResult(ResultCode: Integer);
  var
    ErrorCode: Integer;
  begin
    if ResultCode <> 0 then
    begin
      ErrorCode := WSAGetLastError;
      raise Exception.Create(SysErrorMessage(ErrorCode));
    end;
  end;

const
  MAGICPACKET_LEN = 102;
  PHYSADDR_LEN = 6;
var
  WSAData: TWSAData;
  Sock: TSocket;
  Addr: TSockAddr;
  OptVal: LongBool;
  RetVal: Integer;
  Position: DWORD;
  MagicData: array[0..MAGICPACKET_LEN - 1] of Byte;
  MacAddr: array[0..PHYSADDR_LEN - 1] of Byte;
begin
  CheckWSResult(WSAStartup($0101, WSAData));
  try
    Sock := socket(PF_INET, SOCK_DGRAM, IPPROTO_IP);
    if Sock = INVALID_SOCKET then
      CheckWSResult(Sock);
    Addr.sin_family := AF_INET;
    Addr.sin_port := htons(Port);
    Addr.sin_addr.S_addr := inet_addr(PAnsiChar(AnsiString(IpAddress)));
    if Addr.sin_addr.S_addr = Longint(INADDR_BROADCAST) then
    begin
      OptVal := True;
      CheckWSResult(setsockopt(Sock, SOL_SOCKET, SO_BROADCAST,
                    PAnsiChar(@OptVal), SizeOf(OptVal)));
    end;
    MacAddr[0] := StrToInt(HexDisplayPrefix + Copy(MacAddress, 1, 2));
    MacAddr[1] := StrToInt(HexDisplayPrefix + Copy(MacAddress, 4, 2));
    MacAddr[2] := StrToInt(HexDisplayPrefix + Copy(MacAddress, 7, 2));
    MacAddr[3] := StrToInt(HexDisplayPrefix + Copy(MacAddress, 10, 2));
    MacAddr[4] := StrToInt(HexDisplayPrefix + Copy(MacAddress, 13, 2));
    MacAddr[5] := StrToInt(HexDisplayPrefix + Copy(MacAddress, 16, 2));
    FillChar(MagicData, SizeOf(MagicData), $FF);
    Position := PHYSADDR_LEN;
    while Position < SizeOf(MagicData) do
    begin
      Move(MacAddr, Pointer(DWORD(@MagicData) + Position)^, PHYSADDR_LEN);
      Inc(Position, PHYSADDR_LEN);
    end;
    RetVal := sendto(Sock, MagicData, SizeOf(MagicData), 0, Addr, SizeOf(Addr));
    if RetVal = SOCKET_ERROR then
      CheckWSResult(RetVal);
    CheckWSResult(closesocket(Sock));
  finally
    CheckWSResult(WSACleanup);
  end;
end;

const
  ws2lib = 'ws2_32.dll';

function getnameinfo; external ws2lib name 'getnameinfo';
function getaddrinfo; external ws2lib name 'getaddrinfo';
procedure freeaddrinfo; external ws2lib name 'freeaddrinfo';

end.
