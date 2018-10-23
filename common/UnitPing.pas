unit UnitPing;

interface

uses Windows, SysUtils, Classes,  Controls, Winsock, StdCtrls;

function pingip(ip:string):string;
function GetLocalIP(AIndex: integer; AStrings: TStrings=nil) : string;
function GetLocalIPList : TStrings;

type
  TSunB = packed record
    s_b1, s_b2, s_b3, s_b4: byte;
  end;

  TSunW = packed record
    s_w1, s_w2: word;
  end;

  PIPAddr = ^TIPAddr;
  TIPAddr = record
    case integer of
      0: (S_un_b: TSunB);
      1: (S_un_w: TSunW);
      2: (S_addr: longword);
  end;

 IPAddr = TIPAddr;

  PIPOptionInformation = ^TIPOptionInformation;
  TIPOptionInformation = packed record
  TTL: Byte;
  TOS: Byte;
  Flags: Byte;
  OptionsSize: Byte;
  OptionsData: PChar;
end;

  PIcmpEchoReply = ^TIcmpEchoReply;
  TIcmpEchoReply = packed record
    Address: DWORD;
    Status: DWORD;
    RTT: DWORD;
    DataSize: Word;
    Reserved: Word;
    Data: Pointer;
    Options: TIPOptionInformation;
  end;

TIcmpCreateFile = function : THandle; stdcall;
TIcmpCloseHandle = function(icmpHandle : THandle) : boolean; stdcall;
TIcmpSendEcho = function  (IcmpHandle : THandle; DestinationAddress : IPAddr;
    RequestData : Pointer; RequestSize : Smallint;
    RequestOptions : pointer;
    ReplyBuffer : Pointer;
    ReplySize : DWORD;
    Timeout : DWORD) : DWORD; stdcall;

  Tping =class(Tobject)
  private
    { Private declarations }
    hICMP: THANDLE;
    IcmpCreateFile : TIcmpCreateFile;
    IcmpCloseHandle: TIcmpCloseHandle;
    IcmpSendEcho: TIcmpSendEcho;
  public
    FIPAddr: IPAddr;
    FIpAddress: Ansistring;

    function   pinghost(ip:string;var info:string): Boolean;
    function   pinghost2: Boolean;
    constructor create(AIPAddress: string);
    destructor destroy;override;
    { Public declarations }
  end;

var
  hICMPdll: HMODULE;

implementation

procedure TranslateStringToTInAddr(AIP: Ansistring; var AInAddr);
var
  phe: PHostEnt;
  pac: PAnsiChar;
  GInitData: TWSAData;
begin
  WSAStartup($101, GInitData);
  try
    phe := GetHostByName(PAnsiChar(AIP));
    if Assigned(phe) then
    begin
      pac := phe^.h_addr_list^;
      if Assigned(pac) then
      begin
        with TIPAddr(AInAddr).S_un_b do begin
          s_b1 := Byte(pac[0]);
          s_b2 := Byte(pac[1]);
          s_b3 := Byte(pac[2]);
          s_b4 := Byte(pac[3]);
        end;
      end
      else
      begin
        raise Exception.Create('Error getting IP from HostName');
      end;
    end
    else
    begin
      raise Exception.Create('Error getting HostName');
    end;
  except
    FillChar(AInAddr, SizeOf(AInAddr), #0);
  end;
  WSACleanup;
end;

constructor Tping.create(AIPAddress: string);
begin
  inherited create;

  hICMPdll := LoadLibrary('icmp.dll');
  @ICMPCreateFile := GetProcAddress(hICMPdll, 'IcmpCreateFile');
  @IcmpCloseHandle := GetProcAddress(hICMPdll,'IcmpCloseHandle');
  @IcmpSendEcho := GetProcAddress(hICMPdll, 'IcmpSendEcho');
  hICMP := IcmpCreateFile;

  FIPAddress := AIPAddress;
  TranslateStringToTInAddr(FIPAddress, FIPAddr);
end;

destructor Tping.destroy;
begin
  IcmpCloseHandle(hICMP);
  FreeLibrary(hIcmpDll);
  inherited destroy;
end;

function Tping.pinghost(ip:string;var info:string): Boolean;
var
  // IP Options for packet to send
  IPOpt:TIPOptionInformation;
  FIPAddress:DWORD;
  pReqData,pRevData:PChar;
  // ICMP Echo reply buffer
  pIPE:PIcmpEchoReply;
  FSize: DWORD;
  MyString:string;
  FTimeOut:DWORD;
  BufferSize:DWORD;
  DW : DWORD;
  rep : array[1..128] of byte;
begin
  if ip <> '' then
  begin
    FIPAddress := inet_addr(PAnsiChar(ip));
    FSize := 40;
    BufferSize := SizeOf(TICMPEchoReply) + FSize;
    GetMem(pRevData,FSize);
    GetMem(pIPE,BufferSize);
    FillChar(pIPE^, SizeOf(pIPE^), 0);
    pIPE^.Data := pRevData;
    MyString := 'Test Net - Sos Admin';
    pReqData := PChar(MyString);
    FillChar(IPOpt, Sizeof(IPOpt), 0);
    IPOpt.TTL := 64;
    FTimeOut := 4000;
    try
      //IcmpSendEcho(hICMP, FIPAddress, pReqData, Length(MyString),@IPOpt, pIPE, BufferSize, FTimeOut);
      //DW := IcmpSendEcho(hICMP, FIPAddress, nil, 0,nil, @rep, 128, 0);
      Result := (DW <> 0);
      //if pReqData^ = pIPE^.Options.OptionsData^ then
      //info:=ip+ '　' + IntToStr(pIPE^.DataSize) + '　　　' +IntToStr(pIPE^.RTT);
    except
      info:='Can not find host!';
      FreeMem(pRevData);
      FreeMem(pIPE);
      Exit;
    end;

    FreeMem(pRevData);
    FreeMem(pIPE);
  end;
end;

function Tping.pinghost2: Boolean;
var
  DW : DWORD;
  rep : array[1..128] of byte;
begin
  result := false;
  DW := IcmpSendEcho(hICMP, FIPAddr, nil, 0, nil, @rep, 128, 500);
  Result := (DW <> 0);
end;

function pingip(ip:string):string;
var
  str:string;
  ping:Tping;
begin
  //ping:=Tping.create ;
  ping.pinghost(ip,str);
  result:=str;
  ping.destroy ;
end;

// returns ISP assigned IP
//AIndex = -1 이면 모든 어댑터 IP를 AStrings로 반환함
//AIndex = 0 이면 첫번째 어댑터 IP를 반환함
function GetLocalIP(AIndex: integer; AStrings: TStrings=nil) : string;
type
    TaPInAddr = array [0..10] of PInAddr;
    PaPInAddr = ^TaPInAddr;
var
    phe  : PHostEnt;
    pptr : PaPInAddr;
    Buffer : array [0..63] of Ansichar;
    I    : Integer;
    GInitData      : TWSADATA;
begin
  // WSAStartup은 응용 프로그램이 원도우즈 소겟을 이용할 때 최초로 호출하여
  // 다른 소켓 함수를 사용할 수 있도록 초기화 한다.(마무리는 WSACleanup사용)
  // 이 함수는 응용 프로그램에 필요한 원도우즈 소켓 API의 버전을 알려주고,
  // 소켓 내부의 구현 사항을 리턴한다.
    WSAStartup($101, GInitData);
    Result := '';
    GetHostName(Buffer, SizeOf(Buffer));
    phe :=GetHostByName(buffer);
    if phe = nil then Exit;
    pptr := PaPInAddr(Phe^.h_addr_list);
    I := 0;

    while pptr^[I] <> nil do
    begin
      result:=StrPas(inet_ntoa(pptr^[I]^));

      if AIndex = -1 then
      begin
        AStrings.Add(Result);
      end;

      if (AIndex = I) then
        exit;

      Inc(I);
    end;
    WSACleanup;
end;

//IP List를 반환함
//
function GetLocalIPList : TStrings;
begin
  Result := TStringList.Create;
  GetLocalIP(-1, Result);
end;

end.

