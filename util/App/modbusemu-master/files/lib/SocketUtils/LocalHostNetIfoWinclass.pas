unit LocalHostNetIfoWinclass;

{$mode objfpc}{$H+}

interface

uses Classes, Contnrs,
     LocalHostNetIfoBaseClass,
     IPHelper;
const
  cLocalhoctIP = '127.0.0.1';

type
  {
    Класс для "предоставления" информации по одному конкретному адаптеру
    и управления его включением и выключением
  }

  { TNetItfInfoWin }

  TNetItfInfoWin = class(TNetItfInfoBase)
   private
    FItfRow     : PMIB_IFROW;
    FIPInfo     : PIP_ADAPTER_INFO;
    FIPGWList   : TObjectList;
    function GetItfAdmStatus: TAdmStatusEnum;
    function GetItfInDiscards: Cardinal;
    function GetItfInErrors: Cardinal;
    function GetItfInNUcastPkts: Cardinal;
    function GetItfInOctets: Cardinal;
    function GetItfInUcastPkts: Cardinal;
    function GetItfInUnknownProtos: Cardinal;
    function GetItfLastChange: Cardinal;
    function GetItfMAC: String;
    function GetItfMTU: Cardinal;
    function GetItfOperStatus: TOperStatusEnum;
    function GetItfOutDiscards: Cardinal;
    function GetItfOutErrors: Cardinal;
    function GetItfOutNUcastPkts: Cardinal;
    function GetItfOutOctets: Cardinal;
    function GetItfOutQLen: Cardinal;
    function GetItfOutUcastPkts: Cardinal;
    function GetItfSpeed: Cardinal;
    function GetItfType: TItfTypeEnum;
    function GetIsIPInfoPresent: Boolean;
    function GetItfAdapterName: String;
    function GetItfDHCPEnabled: Boolean;
    function GetItfDHSPServerIP: String;
    function GetItfDHSPServerIPMask: String;
    function GetItfHaveWINS: Boolean;
    function GetItfPrimaryWINS: String;
    function GetItfSecondaryWINS: String;
    function GetItfPrimaryWINSMask: String;
    function GetItfSecondaryWINSMask: String;
    function GetItfGWAddress(index: Integer): TIPInfoObj;
    function GetItfGWCount: Integer;
   protected
    function GetIPAddress(index : Integer): TIPInfoObj; override;
    function GetIPCount: Integer; override;

    function GetItfIndex: Cardinal; override;
    function GetItfDescription: String; override;
    function GetItfName: String; override;
   public
    constructor Create(ItfInfo : PMIB_IFROW); reintroduce;
    destructor  Destroy; override;

    procedure Start;
    procedure Stop;

    procedure Update(ROW : PMIB_IFROW); overload;
    procedure Update(IPInfo : PIP_ADAPTER_INFO); overload;

    function GetItfInfoAsString : String; override;

    property ItfType            : TItfTypeEnum read GetItfType;
    property ItfMTU             : Cardinal read GetItfMTU;
    property ItfSpeed           : Cardinal read GetItfSpeed;
    property ItfMAC             : String read GetItfMAC;
    property ItfAdmStatus       : TAdmStatusEnum read GetItfAdmStatus;
    property ItfOperStatus      : TOperStatusEnum read GetItfOperStatus;
    property ItfLastChange      : Cardinal read GetItfLastChange;
    property ItfInOctets        : Cardinal read GetItfInOctets;
    property ItfInUcastPkts     : Cardinal read GetItfInUcastPkts;
    property ItfInNUcastPkts    : Cardinal read GetItfInNUcastPkts;
    property ItfInDiscards      : Cardinal read GetItfInDiscards;
    property ItfInErrors        : Cardinal read GetItfInErrors;
    property ItfInUnknownProtos : Cardinal read GetItfInUnknownProtos;
    property ItfOutOctets       : Cardinal read GetItfOutOctets;
    property ItfOutUcastPkts    : Cardinal read GetItfOutUcastPkts;
    property ItfOutNUcastPkts   : Cardinal read GetItfOutNUcastPkts;
    property ItfOutDiscards     : Cardinal read GetItfOutDiscards;
    property ItfOutErrors       : Cardinal read GetItfOutErrors;
    property ItfOutQLen         : Cardinal read GetItfOutQLen;

    property IsIPInfoPresent    : Boolean read GetIsIPInfoPresent;

    property ItfAdapterName       : String read GetItfAdapterName;
    property ItfDHCPEnabled       : Boolean read GetItfDHCPEnabled;
    property ItfDHSPServerIP      : String read GetItfDHSPServerIP;
    property ItfDHSPServerIPMask  : String read GetItfDHSPServerIPMask;
    property ItfHaveWINS          : Boolean read GetItfHaveWINS;
    property ItfPrimaryWINS       : String read GetItfPrimaryWINS;
    property ItfPrimaryWINSMask   : String read GetItfPrimaryWINSMask;
    property ItfSecondaryWINS     : String read GetItfSecondaryWINS;
    property ItfSecondaryWINSMask : String read GetItfSecondaryWINSMask;
    property ItfIPCount           : Integer read GetIPCount;
    property ItfIPAddress[index : Integer]: TIPInfoObj read GetIPAddress;
    property ItfGWCount           : Integer read GetItfGWCount;
    property ItfGWAddress[index : Integer]: TIPInfoObj read GetItfGWAddress;
  end;

  {
    Класс-контейнер поддерживает информацию по по всем адаптерам имеющимся в
    системе
  }
  TLocalHostNetWinInfo = class(TLocalHostNetInfoBase)
  private
   FItfTable        : PMIB_IFTABLE;
   FItfTableSize    : Cardinal;

   FIPInfoTable     : PIP_ADAPTER_INFO;
   FIPInfoTableSize : Cardinal;
  public
   constructor Create(AOwner : TComponent); override;
   // обновление информации по интерфейсам в системе
   procedure Update; override;
   // очистка списка
   procedure Clear; override;
   // заполняет переданный список перечнем IP адресов имеющихся на локальной машине
   procedure GetIPListStrings(DestStrins : TStrings; IsClearDest : Boolean = True); override;
  end;

implementation

uses SysUtils,
     SocketMisc, TypInfo, SocketResStrings;

{ TLocalHostNetWinInfo }

constructor TLocalHostNetWinInfo.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  if AOwner <> nil then ChangeName(format('LocalHostNetWinInfo%d',[AOwner.ComponentCount+1]))
   else ChangeName(format('LocalHostNetWinInfo%d',[0]));
  FItfTable := nil;
  FItfTableSize := 0;
  FIPInfoTable := nil;
  FIPInfoTableSize := 0;
  FHostName := GetLocalHostName;
end;

procedure TLocalHostNetWinInfo.Clear;
begin
  FItfList.Clear;
  if FItfTable <> nil then
   begin
    FreeMem(FItfTable,FItfTableSize);
    FItfTable := nil;
    FItfTableSize := 0;
   end;
  if FIPInfoTable <> nil then
   begin
    FreeMem(FIPInfoTable);
    FIPInfoTable := nil;
    FIPInfoTableSize := 0;
   end;
end;

{function TLocalHostNetWinInfo.GetInterfases(index: Cardinal): TNetItfInfoBase;
begin
  Result := TNetItfInfoBase(FItfList.Items[index]);
end;

function TLocalHostNetWinInfo.GetItfCount: Cardinal;
begin
  Result := FItfList.Count;
end;}

procedure TLocalHostNetWinInfo.Update;
var ErrorCode : Cardinal;
    i, Count : Integer;
    TempROW : PMIB_IFROW;
    TempItf : TNetItfInfoWin;
    TempIPInfoTable : PIP_ADAPTER_INFO;
    TempNetInfo : TNetItfInfoWin;
begin
  Clear;

  // получаем объем памяти необходимый для таблицы интерфейсов
  GetIfTable(nil,@FItfTableSize, False);

  FItfTable:=AllocMem(FItfTableSize);

  // получаем саму таблицу
  ErrorCode := GetIfTable(FItfTable,@FItfTableSize,True);
  if ErrorCode <> NO_ERROR then raise Exception.CreateFmt(rsFormatGetIfError,[ErrorCode]);

  Count := FItfTable^.dwNumEntries -1;
  for i:=0 to Count do
  begin
    TempROW := GetIfRowP(FItfTable,i);
    TempItf := TNetItfInfoWin.Create(TempROW);
    FItfList.Add(TempItf);
  end;

  GetAdaptersInfo(nil, @FIPInfoTableSize);

  FIPInfoTable:=AllocMem(FIPInfoTableSize);

  ErrorCode := GetAdaptersInfo(FIPInfoTable,@FIPInfoTableSize);
  if ErrorCode <> NO_ERROR then raise Exception.CreateFmt(rsFormatGetIfError,[ErrorCode]);

  TempIPInfoTable := FIPInfoTable;
  repeat
   TempNetInfo:=TNetItfInfoWin(GetItfInfoByIndex(TempIPInfoTable^.Index));
   if TempNetInfo = nil then Continue;

   TempNetInfo.Update(TempIPInfoTable);

   TempIPInfoTable := TempIPInfoTable^.Next
  until TempIPInfoTable = nil;

end;

procedure TLocalHostNetWinInfo.GetIPListStrings(DestStrins: TStrings; IsClearDest : Boolean = True);
var i, Count, ii, Count1 : Integer;
    TempItf : TNetItfInfoWin;
begin
  if DestStrins = nil then Exit;
  Count := ItfCount-1;
  if IsClearDest then DestStrins.Clear;
  for i := 0 to Count do
  begin
   TempItf := TNetItfInfoWin(Interfaces[i]);
   if not TempItf.IsIPInfoPresent then Continue;
   Count1:=TempItf.ItfIPCount-1;
   for ii:=0 to Count1 do DestStrins.Add(TempItf.ItfIPAddress[ii].IP);
  end;
  DestStrins.Add(cLocalhoctIP);
end;

{ TNetItfInfoWin }

constructor TNetItfInfoWin.Create(ItfInfo: PMIB_IFROW);
begin
  inherited Create;
  FItfRow   := ItfInfo;
  FIPGWList := TObjectList.Create(True);
end;

destructor TNetItfInfoWin.Destroy;
begin
  FItfRow := nil;
  FIPInfo := nil;
  FIPGWList.Free;
  inherited;
end;

function TNetItfInfoWin.GetItfGWAddress(index: Integer): TIPInfoObj;
begin
  Result := TIPInfoObj(FIPGWList.Items[index]);
end;

function TNetItfInfoWin.GetIsIPInfoPresent: Boolean;
begin
  Result := FIPInfo<>nil;
end;

function TNetItfInfoWin.GetItfAdapterName: String;
begin
  Result:='';
  if FIPInfo = nil then Exit;
  Result := StrPas(FIPInfo^.AdapterName)
end;

function TNetItfInfoWin.GetItfAdmStatus: TAdmStatusEnum;
begin
  if FItfRow = nil then raise Exception.Create(rsROWNotInstalled);
  Result := TAdmStatusEnum(FItfRow^.dwAdminStatus);
end;

function TNetItfInfoWin.GetIPAddress(index : Integer): TIPInfoObj;
begin
  Result := inherited GetIPAddress(index);
end;

function TNetItfInfoWin.GetIPCount: Integer;
begin
  Result := inherited GetIPCount;
end;

function TNetItfInfoWin.GetItfDescription: String;
begin
  if FItfRow = nil then raise Exception.Create(rsROWNotInstalled);
  Result := StrPas(@FItfRow^.bDescr);
end;

function TNetItfInfoWin.GetItfName: String;
begin
  Result := '';
end;

function TNetItfInfoWin.GetItfDHCPEnabled: Boolean;
begin
  Result:=False;
  if FIPInfo = nil then Exit;
  Result := Boolean(FIPInfo^.DhcpEnabled);
end;

function TNetItfInfoWin.GetItfDHSPServerIP: String;
begin
  Result:='';
  if FIPInfo = nil then Exit;
  Result := StrPas(FIPInfo^.DhcpServer.IpAddress.S);
end;

function TNetItfInfoWin.GetItfDHSPServerIPMask: String;
begin
  Result:='';
  if FIPInfo = nil then Exit;
  Result := StrPas(FIPInfo^.DhcpServer.IpMask.S);
end;

function TNetItfInfoWin.GetItfGWCount: Integer;
begin
  Result := FIPGWList.Count;
end;

function TNetItfInfoWin.GetItfHaveWINS: Boolean;
begin
  Result:=False;
  if FIPInfo = nil then Exit;
  Result := Boolean(FIPInfo^.HaveWins);
end;

function TNetItfInfoWin.GetItfIndex: Cardinal;
begin
  if FItfRow = nil then raise Exception.Create(rsROWNotInstalled);
  Result := FItfRow^.dwIndex;
end;

function TNetItfInfoWin.GetItfInDiscards: Cardinal;
begin
  if FItfRow = nil then raise Exception.Create(rsROWNotInstalled);
  Result := FItfRow^.dwInDiscards;
end;

function TNetItfInfoWin.GetItfInErrors: Cardinal;
begin
  if FItfRow = nil then raise Exception.Create(rsROWNotInstalled);
  Result := FItfRow^.dwInErrors;
end;

function TNetItfInfoWin.GetItfInfoAsString: String;
var i : Integer;
begin
  if FItfRow = nil then raise Exception.Create(rsROWNotInstalled);

  Result := Format(rsGetInf1,[ItfAdapterName+#13#10]);

  Result := Result+ Format('Описание: %s',[StrPas(@FItfRow^.bDescr)+#13#10]);

  Result:= Result + Format(rsFormatIndex, [FItfRow^.dwIndex])+#13#10;
  Result:= Result + Format(rsFormatType, [IfTypeToStr(FItfRow^)])+#13#10;
  Result:= Result + Format(rsFormatMTU,[FItfRow^.dwMtu])+#13#10;
  if FItfRow^.dwSpeed < 1000000 then Result:= Result + Format(rsFormatSpeed,[FItfRow^.dwSpeed])+#13#10
   else Result:= Result + Format(rsFormatSpeedM,[FItfRow^.dwSpeed div 1000000])+#13#10;
  Result:= Result + Format(rsFormatMACAddress,[GetHardwareAddress(FItfRow^)])+#13#10;
  Result:= Result + Format(rsFormatAdminStatus,[GetAdminStatus(FItfRow^)])+#13#10;
  Result:= Result + Format(rsFormatOperStatus,[GetOperStatus(FItfRow^)])+#13#10;

  Result:= Result + rsFormatIn+#13#10;

  if FItfRow^.dwInOctets < 1048576 then Result:= Result + #9+Format(rsFormatOctets,[FItfRow^.dwInOctets])+#13#10
   else Result:= Result + #9+Format(rsFormatOctetsM,[FItfRow^.dwInOctets div 1048576])+#13#10;
  Result:= Result + #9+Format(rsFormatUnicast,[FItfRow^.dwInUcastPkts])+#13#10;
  Result:= Result + #9+Format(rsFormatNUnicast,[FItfRow^.dwInNUcastPkts])+#13#10;
  Result:= Result + #9+Format(rsFormatDiscards,[FItfRow^.dwInDiscards])+#13#10;
  Result:= Result + #9+Format(rsFormatErrors,[FItfRow^.dwInErrors])+#13#10;
  Result:= Result + #9+Format(rsFormatInUnknProts,[FItfRow^.dwInUnknownProtos])+#13#10;

  Result:= Result + rsFormatOut+#13#10;

  if FItfRow^.dwOutOctets < 1048576 then Result:= Result + #9+Format(rsFormatOctets,[FItfRow^.dwOutOctets])+#13#10
   else Result:= Result + #9+Format(rsFormatOctetsM,[FItfRow^.dwOutOctets div 1048576])+#13#10;
  Result:= Result + #9+Format(rsFormatUnicast,[FItfRow^.dwOutUcastPkts])+#13#10;
  Result:= Result + #9+Format(rsFormatNUnicast,[FItfRow^.dwOutNUcastPkts])+#13#10;
  Result:= Result + #9+Format(rsFormatDiscards,[FItfRow^.dwOutDiscards])+#13#10;
  Result:= Result + #9+Format(rsFormatErrors,[FItfRow^.dwOutErrors])+#13#10;
  Result:= Result + #9+Format(rsFormatOutQLen,[FItfRow^.dwOutQLen])+#13#10;

  Result:= Result + rsGetInf2 + #13#10;
  for i := 0 to ItfIPCount-1 do
  begin
   Result:= Result + #9+Format(rsGetInf3,[ItfIPAddress[i].IP])+#13#10;
   Result:= Result + #9+Format(rsGetInf4,[ItfIPAddress[i].Mask])+#13#10;
  end;

  Result:= Result + rsGetInf5 + #13#10;
  for i := 0 to ItfGWCount-1 do
  begin
   Result:= Result + #9+Format(rsGetInf3,[ItfGWAddress[i].IP])+#13#10;
   Result:= Result + #9+Format(rsGetInf4,[ItfGWAddress[i].Mask])+#13#10;
  end;

  Result:= Result + rsGetInf6 + #13#10;

  Result:= Result + #9+Format(rsGetInf7,[BoolToStr(ItfDHCPEnabled, True)])+#13#10;
  if ItfDHCPEnabled then Result:= Result + #9+Format('IP: %s',[ItfDHSPServerIP])+#13#10;

  Result:= Result + rsGetInf8 + #13#10;

  Result:= Result + #9+Format(rsGetInf7,[BoolToStr(ItfHaveWINS, True)])+#13#10;
  if ItfHaveWINS then
   begin
    Result:= Result + #9+Format(rsGetInf9,[ItfPrimaryWINS])+#13#10;
    Result:= Result + #9+Format(rsGetInf10,[ItfPrimaryWINSMask])+#13#10;
    Result:= Result + #9+Format(rsGetInf11,[ItfSecondaryWINS])+#13#10;
    Result:= Result + #9+Format(rsGetInf12,[ItfSecondaryWINSMask])+#13#10;
   end; 

end;

function TNetItfInfoWin.GetItfInNUcastPkts: Cardinal;
begin
  if FItfRow = nil then raise Exception.Create(rsROWNotInstalled);
  Result := FItfRow^.dwInNUcastPkts;
end;

function TNetItfInfoWin.GetItfInOctets: Cardinal;
begin
  if FItfRow = nil then raise Exception.Create(rsROWNotInstalled);
  Result := FItfRow^.dwInOctets;
end;

function TNetItfInfoWin.GetItfInUcastPkts: Cardinal;
begin
  if FItfRow = nil then raise Exception.Create(rsROWNotInstalled);
  Result := FItfRow^.dwInUcastPkts;
end;

function TNetItfInfoWin.GetItfInUnknownProtos: Cardinal;
begin
  if FItfRow = nil then raise Exception.Create(rsROWNotInstalled);
  Result := FItfRow^.dwInUnknownProtos;
end;

function TNetItfInfoWin.GetItfLastChange: Cardinal;
begin
  if FItfRow = nil then raise Exception.Create(rsROWNotInstalled);
  Result := FItfRow^.dwLastChange;
end;

function TNetItfInfoWin.GetItfMAC: String;
begin
  if FItfRow = nil then raise Exception.Create(rsROWNotInstalled);
  Result := GetHardwareAddress(FItfRow^);
end;

function TNetItfInfoWin.GetItfMTU: Cardinal;
begin
  if FItfRow = nil then raise Exception.Create(rsROWNotInstalled);
  Result := FItfRow^.dwMtu;
end;

function TNetItfInfoWin.GetItfOperStatus: TOperStatusEnum;
begin
  if FItfRow = nil then raise Exception.Create(rsROWNotInstalled);
  Result := TOperStatusEnum(FItfRow^.dwOperStatus);
end;

function TNetItfInfoWin.GetItfOutDiscards: Cardinal;
begin
  if FItfRow = nil then raise Exception.Create(rsROWNotInstalled);
  Result := FItfRow^.dwOutDiscards;
end;

function TNetItfInfoWin.GetItfOutErrors: Cardinal;
begin
  if FItfRow = nil then raise Exception.Create(rsROWNotInstalled);
  Result := FItfRow^.dwOutErrors;
end;

function TNetItfInfoWin.GetItfOutNUcastPkts: Cardinal;
begin
  if FItfRow = nil then raise Exception.Create(rsROWNotInstalled);
  Result := FItfRow^.dwOutNUcastPkts;
end;

function TNetItfInfoWin.GetItfOutOctets: Cardinal;
begin
  if FItfRow = nil then raise Exception.Create(rsROWNotInstalled);
  Result := FItfRow^.dwOutOctets;
end;

function TNetItfInfoWin.GetItfOutQLen: Cardinal;
begin
  if FItfRow = nil then raise Exception.Create(rsROWNotInstalled);
  Result := FItfRow^.dwOutQLen;
end;

function TNetItfInfoWin.GetItfOutUcastPkts: Cardinal;
begin
  if FItfRow = nil then raise Exception.Create(rsROWNotInstalled);
  Result := FItfRow^.dwOutUcastPkts;
end;

function TNetItfInfoWin.GetItfPrimaryWINS: String;
begin
  Result:='';
  if FIPInfo = nil then Exit;
  Result := StrPas(FIPInfo^.PrimaryWinsServer.IpAddress.S);
end;

function TNetItfInfoWin.GetItfPrimaryWINSMask: String;
begin
  Result:='';
  if FIPInfo = nil then Exit;
  Result := StrPas(FIPInfo^.PrimaryWinsServer.IpMask.S);
end;

function TNetItfInfoWin.GetItfSecondaryWINS: String;
begin
  Result:='';
  if FIPInfo = nil then Exit;
  Result := StrPas(FIPInfo^.SecondaryWinsServer.IpAddress.S);
end;

function TNetItfInfoWin.GetItfSecondaryWINSMask: String;
begin
  Result:='';
  if FIPInfo = nil then Exit;
  Result := StrPas(FIPInfo^.SecondaryWinsServer.IpMask.S);
end;

function TNetItfInfoWin.GetItfSpeed: Cardinal;
begin
  if FItfRow = nil then raise Exception.Create(rsROWNotInstalled);

  if FItfRow^.dwSpeed < 1000000 then Result := FItfRow^.dwSpeed
   else Result := FItfRow^.dwSpeed div 1000000;
end;

function TNetItfInfoWin.GetItfType: TItfTypeEnum;
begin
  if FItfRow = nil then raise Exception.Create(rsROWNotInstalled);
  Result := TItfTypeEnum(FItfRow^.dwType);
end;

procedure TNetItfInfoWin.Start;
var ErrorCode : Cardinal;
begin
  if FItfRow = nil then raise Exception.Create(rsROWNotInstalled);
  if ItfAdmStatus = asUP then Exit;

  FItfRow^.dwAdminStatus := MIB_IF_ADMIN_STATUS_UP;

  ErrorCode := SetIfEntry(FItfRow);
  if ErrorCode <> no_error then raise Exception.CreateFmt(rsFormatGetIfError,[ErrorCode]);

end;

procedure TNetItfInfoWin.Stop;
var ErrorCode : Cardinal;
begin
  if FItfRow = nil then raise Exception.Create(rsROWNotInstalled);
  if ItfAdmStatus <> asUP then Exit;

  FItfRow^.dwAdminStatus := MIB_IF_ADMIN_STATUS_DOWN;

  ErrorCode := SetIfEntry(FItfRow);
  if ErrorCode <> no_error then raise Exception.CreateFmt(rsFormatGetIfError,[ErrorCode]);
end;

procedure TNetItfInfoWin.Update(ROW: PMIB_IFROW);
begin
  FItfRow:=ROW;
end;

procedure TNetItfInfoWin.Update(IPInfo: PIP_ADAPTER_INFO);
var TempIPInfo : PIP_ADDR_STRING;
    TempIPObj  : TIPInfoObj;
begin
  IPList.Clear;
  FIPInfo := IPInfo;
  if FIPInfo = nil then Exit;
  // загрузка  списка адресов
  TempIPInfo := @FIPInfo^.IpAddressList;
  repeat
   TempIPObj := TIPInfoObj.Create(StrPas(TempIPInfo^.IpAddress.S),StrPas(TempIPInfo^.IpMask.S));
   IPList.Add(TempIPObj);
   TempIPInfo := TempIPInfo^.Next;
  until TempIPInfo = nil;

  TempIPInfo := @FIPInfo^.GatewayList;
  repeat
   TempIPObj := TIPInfoObj.Create(StrPas(TempIPInfo^.IpAddress.S),StrPas(TempIPInfo^.IpMask.S));
   FIPGWList.Add(TempIPObj);
   TempIPInfo := TempIPInfo^.Next;
  until TempIPInfo = nil;
end;

end.
