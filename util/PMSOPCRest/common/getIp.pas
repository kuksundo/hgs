unit getIp;

interface

uses Classes, SysUtils, WinSock;

function GetLocalIP(AIndex: integer; AStrings: TStrings=nil) : string;
function GetLocalIPList : TStrings;

implementation

function RemoveNonIp(AString: string): string;
var
 I: Integer;
begin
 Result := '';
 for I := 1 to Length(AString) do
   if (AString[I] in ['0'..'9','.']) then
     Result := Result + AString[I];
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
    Buffer : array [0..63] of PAnsichar;
    I    : Integer;
    GInitData      : TWSADATA;
begin
  // WSAStartup은 응용 프로그램이 원도우즈 소겟을 이용할 때 최초로 호출하여
  // 다른 소켓 함수를 사용할 수 있도록 초기화 한다.(마무리는 WSACleanup사용)
  // 이 함수는 응용 프로그램에 필요한 원도우즈 소켓 API의 버전을 알려주고,
  // 소켓 내부의 구현 사항을 리턴한다.
    WSAStartup($101, GInitData);
    Result := '';
    GetHostName(@Buffer, SizeOf(Buffer));
    phe :=GetHostByName(@buffer);
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


