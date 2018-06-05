unit UnitInterfaceHTTPManager;

interface

uses System.SysUtils, SynCommons, mORMot, mORMotHttpClient;

type
  TmORMotHTTPClient = class
  private
    FRootName,
    FServerIP,
    FPortName,
    FUserName,
    FPassword: string;
    FModel: TSQLModel;
  public
    FHTTPClient: TSQLRestClientURI;

    constructor Create(ARootName, AServerIP, APortName: string);
    destructor Destroy;
    procedure InitVar(ARootName, AServerIP, APortName: string; AModel: TSQLModel);
    function CreateHTTPClient: RawUTF8;
  end;

var
  g_HTTPOK: Boolean;

implementation

{ TmORMotHTTPClient }

constructor TmORMotHTTPClient.Create(ARootName, AServerIP, APortName: string);
begin
  InitVar(ARootName, AServerIP, APortName,nil);
end;

function TmORMotHTTPClient.CreateHTTPClient: RawUTF8;
begin
  Result := '';

  if FHTTPClient = nil then
  begin
    if FModel = nil then
      FModel := TSQLModel.Create([], FRootName);

    FHTTPClient := TSQLHttpClient.Create(FServerIP, FPortName, FModel);

    try
      if not FHTTPClient.ServerTimeStampSynchronize then
      begin
        FHTTPClient.SetUser('User','synopse');
//        (FHTTPClient as TSQLHttpClientGeneric).KeepAliveMS := 30000;
//        (FHTTPClient as TSQLHttpClientGeneric).Compression := [hcSynShaAes];
        Result := FHTTPClient.LastErrorMessage;
  //      ShowMessage(UTF8ToString(FClient_BWQry.LastErrorMessage));
  //      DestroyHTTPClient_BWQry;
  //      DisplayMessage(FormatDateTime('mm월 dd일, hh:nn:ss', now) + ' : ' + UTF8ToString(FClient_BWQry.LastErrorMessage));
  //      DisplayMessage(FormatDateTime('mm월 dd일, hh:nn:ss', now) + ' : CreateHTTPClient_BWQry-FClient_BWQry.ServerTimeStampSynchronize');
        exit;
      end;
    except
      on E: Exception do
      begin
        try
          raise E.Create('Initialize error!');
        finally
          Halt(0);
        end;
      end;
    end;

    //TSQLRestServerAuthenticationNone.ClientSetUser(Client,'User','');
    if FUserName = '' then
      FUserName := 'User';

    if FPassword = '' then
      FPassword := 'synopse';

    FHTTPClient.SetUser(FUserName,FPassword);//'User','synopse');
    g_HTTPOK := True;
  end;
end;

destructor TmORMotHTTPClient.Destroy;
begin
  if Assigned(FModel) then
    FModel.Free;

  FHTTPClient.Free;

  inherited;
end;

procedure TmORMotHTTPClient.InitVar(ARootName, AServerIP, APortName: string;
  AModel: TSQLModel);
begin
  FRootName := ARootName;
  FServerIP := AServerIP;
  FPortName := APortName;
//  FModel := AModel;
end;

end.
