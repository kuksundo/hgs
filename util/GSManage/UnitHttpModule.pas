unit UnitHttpModule;

interface

uses System.SysUtils, UnitInterfaceHTTPManager, UnitRegCodeServerInterface,
  mORMot, SynCommons, UnitRegCodeConst;

function HttpStart(ARoot, AIpAddr, APort: string): boolean;
procedure HttpStop;
function SendReqSerialNo_Http(ACustomerInfo: RawUTF8): RawUTF8;
function SendReqRegCode_Http(ACustomerInfo: RawUTF8): RawUTF8;
function SendReqExpireDate_Http(ACustomerInfo: RawUTF8): RawUTF8;
function SendReqExpireUsage_Http(ACustomerInfo: RawUTF8): RawUTF8;

var
  //g_HTTPClient.FHTTPClient.ServiceRegister([TypeInfo(IAlarmReport)], sicClientDriven);
  g_HTTPClient: TmORMotHTTPClient;

implementation

uses GetIp;

function HttpStart(ARoot, AIpAddr, APort: string): boolean;
var
  LError: RawUTF8;
begin
//  if not IsPortActive(AIpAddr, StrToIntDef(APort, -1)) then
//  begin
//      DisplayMessage(FormatDateTime('mm월 dd일, hh:nn:ss', now) + ' => Server(IP : ' +
//        FSettings.ServerIP + ', Port: ' + FSettings.ServerPort + ') is not available!');
//    Result := False;
//    exit;
//  end;

  g_HTTPClient := TmORMotHttpClient.Create(ARoot, AIpAddr, APort);
  LError := g_HTTPClient.CreateHTTPClient;

  Result := LError = '';
end;

procedure HttpStop;
begin
  if Assigned(g_HTTPClient) then
    FreeAndNil(g_HTTPClient);
end;

function SendReqSerialNo_Http(ACustomerInfo: RawUTF8): RawUTF8;
var
  I: IRegCodeServer;
begin
  Result := '';

  if HttpStart(RCS_ROOT_NAME, RCS_DEFAULT_IP, RCS_PORT_NAME) then
  begin
    try
      g_HTTPClient.FHTTPClient.ServiceRegister([TypeInfo(IRegCodeServer)], sicClientDriven);

      try
        I := g_HTTPClient.FHTTPClient.Service<IRegCodeServer>;
      except
        on E: Exception do
        begin
          I := nil;
  //        DisplayMessage(FormatDateTime('mm월 dd일, hh:nn:ss', now) + ' : ' + E.Message);
  //        DisplayMessage(FormatDateTime('mm월 dd일, hh:nn:ss', now) + ' : NotifyAlarmConfigChanged2Server-FHTTPClient.Service<IAlarmReport>');
          exit;
        end;
      end;

      if I <> nil then
      begin
        Result := I.GetSerialNo(ACustomerInfo);
      end;
    finally
      I := nil;
      HttpStop;
    end;
  end;
end;

function SendReqRegCode_Http(ACustomerInfo: RawUTF8): RawUTF8;
var
  I: IRegCodeServer;
begin
  if HttpStart(RCS_ROOT_NAME, RCS_DEFAULT_IP, RCS_PORT_NAME) then
  begin
    try
      g_HTTPClient.FHTTPClient.ServiceRegister([TypeInfo(IRegCodeServer)], sicClientDriven);

      try
        I := g_HTTPClient.FHTTPClient.Service<IRegCodeServer>;
      except
        on E: Exception do
        begin
          I := nil;
          exit;
        end;
      end;

      if I <> nil then
      begin
        Result := I.GetRegCode(ACustomerInfo);
      end;
    finally
      I := nil;
      HttpStop;
    end;
  end;
end;

function SendReqExpireDate_Http(ACustomerInfo: RawUTF8): RawUTF8;
var
  I: IRegCodeServer;
begin
  if HttpStart(RCS_ROOT_NAME, RCS_DEFAULT_IP, RCS_PORT_NAME) then
  begin
    try
      g_HTTPClient.FHTTPClient.ServiceRegister([TypeInfo(IRegCodeServer)], sicClientDriven);

      try
        I := g_HTTPClient.FHTTPClient.Service<IRegCodeServer>;
      except
        on E: Exception do
        begin
          I := nil;
          exit;
        end;
      end;

      if I <> nil then
      begin
        Result := I.GetExpireDate(ACustomerInfo);
      end;
    finally
      I := nil;
      HttpStop;
    end;
  end;
end;

function SendReqExpireUsage_Http(ACustomerInfo: RawUTF8): RawUTF8;
var
  I: IRegCodeServer;
begin
  if HttpStart(RCS_ROOT_NAME, RCS_DEFAULT_IP, RCS_PORT_NAME) then
  begin
    try
      g_HTTPClient.FHTTPClient.ServiceRegister([TypeInfo(IRegCodeServer)], sicClientDriven);

      try
        I := g_HTTPClient.FHTTPClient.Service<IRegCodeServer>;
      except
        on E: Exception do
        begin
          I := nil;
          exit;
        end;
      end;

      if I <> nil then
      begin
        Result := I.GetExpireUsage(ACustomerInfo);
      end;
    finally
      I := nil;
      HttpStop;
    end;
  end;
end;

end.
