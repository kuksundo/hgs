unit UnitHttpModule;

interface

uses System.SysUtils, mORMot, SynCommons, UnitInterfaceHTTPManager;

function HttpStart(ARoot, AIpAddr, APort: string): boolean;
procedure HttpStop;

var
  //g_HTTPClient.FHTTPClient.ServiceRegister([TypeInfo(IAlarmReport)], sicClientDriven);
  g_HTTPClient: TmORMotHTTPClient;

implementation

function HttpStart(ARoot, AIpAddr, APort: string): boolean;
var
  LError: RawUTF8;
begin
//  if not IsPortActive(AIpAddr, StrToIntDef(APort, -1)) then
//  begin
//      DisplayMessage(FormatDateTime('mm¿ù ddÀÏ, hh:nn:ss', now) + ' => Server(IP : ' +
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
  begin
    g_HTTPClient.FHTTPClient.SessionClose;
    g_HTTPClient.Destroy;
//    FreeAndNil(g_HTTPClient);
  end;
end;


end.
