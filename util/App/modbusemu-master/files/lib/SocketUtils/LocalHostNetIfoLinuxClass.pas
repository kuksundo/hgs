unit LocalHostNetIfoLinuxClass;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Sockets, SocketSimpleTypes,
  LocalHostNetIfoBaseClass;

{$IFDEF UNIX}
type

  TNetItfLinuxInfo  = class(TNetItfInfoBase)
  private
    FSocket  : TSocket;
    FIfReq   : Tifreq;
  protected
    function GetItfIndex:Cardinal; override;
    function GetItfDescription: String; override;
    function GetItfName: String; override;
  public
    constructor Create(ASocket : TSocket; AReq : Tifreq); virtual; overload;
    destructor  Destroy; override;

    function GetItfInfoAsString : String; override;

    procedure AddIPAddr(AReq : Tifreq);

    procedure Update;
  end;

  { TLocalHostNetLinuxInfo }

  TLocalHostNetLinuxInfo = class(TLocalHostNetInfoBase)
  private
   FSocket  : TSocket;
   FIfConf  : ifconf;
  protected
   function GetItfByName(AName : String) : TNetItfLinuxInfo;
  public
   constructor Create(AOwner : TComponent); override;
   destructor  Destroy; override;
   // обновление информации по интерфейсам в системе
   procedure Update; override;
   // очистка списка
   procedure Clear; override;
   // заполняет переданный список перечнем IP адресов имеющихся на локальной машине
   procedure GetIPListStrings(DestStrins : TStrings; IsClearDest : Boolean = True); override;
  end;

{$ENDIF}

implementation

{$IFDEF UNIX}

uses BaseUnix,
     SocketMisc, SocketResStrings;

{ TLocalHostNetLinuxInfo }

constructor TLocalHostNetLinuxInfo.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  if AOwner <> nil then ChangeName(format('LocalHostNetLinuxInfo%d',[AOwner.ComponentCount+1]))
   else ChangeName(format('LocalHostNetLinuxInfo%d',[0]));
  FIfConf.ifc_len           := 4096;
  FIfConf.ifc_ifcu.ifcu_req := GetMem(4096);
  FillByte(FIfConf.ifc_ifcu.ifcu_req^,4096,0);
  FSocket := INVALID_SOCKET;
end;

destructor TLocalHostNetLinuxInfo.Destroy;
begin
  if FSocket <> INVALID_SOCKET then FpClose(FSocket);
  Clear;
  Freemem(FIfConf.ifc_ifcu.ifcu_req);
  inherited Destroy;
end;

procedure TLocalHostNetLinuxInfo.Update;
//type
//   PIfRegArray = ^TIfRegArray;
//   TIfRegArray = array[0..20] of TIFreq;

var ErrCode    : LongInt;
    i,IfCount  : integer;
    IfRequest  : Tifreq;
    TempItfObj : TNetItfLinuxInfo;
//    TempRegArr : PIfRegArray;
    TempName   : String;
    TempSize   : Integer;
    TempLen    : Integer;
    TempPIFReg : Pifreq;
begin
  Clear;

  if FSocket = INVALID_SOCKET then
   begin
    FSocket := fpsocket(AF_INET,SOCK_DGRAM,0);
    if FSocket = -1 then RaiseLastOSError;
   end;

  if FpIOCtl(FSocket,SIOCGIFCONF,@FIfConf) = -1 then
   begin
    ErrCode := fpgeterrno;
    FpClose(FSocket);
    FSocket := INVALID_SOCKET;
    RaiseLastOSError(ErrCode);
   end;
  TempSize := SizeOf(TIFreq);
  TempLen  := FIfConf.ifc_len;
  IfCount  := TempLen div TempSize;

  TempSize := round(TempLen/IfCount);
//  TempRegArr := PIfRegArray(FIfConf.ifc_ifcu.ifcu_req);
  TempPIFReg := Pifreq(FIfConf.ifc_ifcu.ifcu_req);

  for i := 0 to IfCount-1 do
   begin
//    IfRequest := TempRegArr^[i];
    IfRequest := TempPIFReg^;//[i];

    TempPIFReg := Pifreq(Pointer(PtrUInt(TempPIFReg)+TempSize));

    if IfRequest.ifr_ifru.ifru_addr.sa_family <> AF_INET then Continue;

    TempName := StrPas(PChar(@IfRequest.ifr_ifrn.ifrn_name[0]));
    TempItfObj := GetItfByName(TempName);

    if Assigned(TempItfObj) then
     begin
      TempItfObj.AddIPAddr(IfRequest);
     end
    else
     begin
      TempItfObj := TNetItfLinuxInfo.Create(FSocket,IfRequest);
      FItfList.Add(TempItfObj);
      TempItfObj.Update;
     end;
   end;
end;

function TLocalHostNetLinuxInfo.GetItfByName(AName: String): TNetItfLinuxInfo;
var i,Count : Integer;
    TempItf : TNetItfLinuxInfo;
begin
  Result := nil;
  Count := FItfList.Count-1;
  for i := 0 to Count do
   begin
    TempItf := TNetItfLinuxInfo(FItfList.Items[i]);
    if SameText(AName, TempItf.ItfName) then
     begin
      Result := TempItf;
      Break;
     end;
   end;
end;

procedure TLocalHostNetLinuxInfo.Clear;
begin
  FItfList.Clear;
  FillByte(FIfConf.ifc_ifcu.ifcu_req^,4096,0);
end;

procedure TLocalHostNetLinuxInfo.GetIPListStrings(DestStrins: TStrings; IsClearDest: Boolean);
var ii,i, Count,Count1 : Integer;
    TempItem : TNetItfLinuxInfo;
begin
  if IsClearDest then DestStrins.Clear;
  Count := FItfList.Count-1;
  for i := 0 to Count do
   begin
    TempItem := TNetItfLinuxInfo(FItfList.Items[i]);
    Count1 := TempItem.ItfIPCount-1;
    for ii := 0 to Count1 do
     begin
      DestStrins.Add(TempItem.ItfIPAddress[ii].IP);
     end;
   end;
end;

{ TNetItfLinuxInfo }

constructor TNetItfLinuxInfo.Create(ASocket: TSocket; AReq: Tifreq);
begin
  if ASocket = INVALID_SOCKET then raise Exception.Create(rsLinNetInfo1);
  inherited Create;
  FSocket := ASocket;
  FIfReq  := AReq;
  AddIPAddr(AReq);
end;

destructor TNetItfLinuxInfo.Destroy;
begin
  inherited Destroy;
end;

function TNetItfLinuxInfo.GetItfInfoAsString: String;
begin
  Result := '';
end;

procedure TNetItfLinuxInfo.AddIPAddr(AReq: Tifreq);
var TempIPAddr : TIPInfoObj;
    TempAddr, TempMask : String;
    TempReq : TIFreq;
begin
  TempAddr := GetIPStr(htonl(AReq.ifr_ifru.ifru_addr.sin_addr.S_addr));
  TempReq.ifr_ifrn.ifrn_name := AReq.ifr_ifrn.ifrn_name;
  if FpIOCtl(FSocket, SIOCGIFNETMASK ,@TempReq) = -1 then
   begin
    RaiseLastOSError;
   end;
  TempMask := GetIPStr(htonl(TempReq.ifr_ifru.ifru_netmask.sin_addr.S_addr));
  TempIPAddr := TIPInfoObj.Create(TempAddr,TempMask);
  IPList.Add(TempIPAddr);
end;

procedure TNetItfLinuxInfo.Update;
begin

end;

function TNetItfLinuxInfo.GetItfIndex: Cardinal;
begin
  Result := 0;
end;

function TNetItfLinuxInfo.GetItfDescription: String;
begin
  Result := '';
end;

function TNetItfLinuxInfo.GetItfName: String;
begin
  Result := StrPas(PChar(@FIfReq.ifr_ifrn.ifrn_name[0]));
end;

{$ENDIF}
end.

