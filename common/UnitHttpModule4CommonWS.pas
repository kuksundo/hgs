unit UnitHttpModule4CommonWS;

interface

uses System.SysUtils, System.Classes, UnitInterfaceHTTPManager, UnitCommonWSInterface,
  mORMot, SynCommons, UnitHttpModule;

function MakeCommand4CommonWSServer(ACommand, AParam: RawUTF8): RawUTF8;
function SendReq2CommonWS_Http(AIpAddress, APort, ARoot: string; ACommand, AParam: RawUTF8): RawUTF8;

implementation

uses UnitBase64Util, CommonData;

function MakeCommand4CommonWSServer(ACommand, AParam: RawUTF8): RawUTF8;
var
  LStrList: TStringList;
  LStr: string;
begin
  LStrList := TStringList.Create;
  try
    LStrList.Add('Command=' + ACommand);
    LStrList.Add('Parameter=' + AParam);
    Result := StringToUTF8(LStrList.Text);
    Result := MakeRawUTF8ToBin64(Result);
  finally
    LStrList.Free;
  end;
end;

function SendReq2CommonWS_Http(AIpAddress, APort, ARoot: string; ACommand, AParam: RawUTF8): RawUTF8;
var
  I: ICommonWSService;
  LCommand: RawUTF8;
begin        //RCS_ROOT_NAME, RCS_DEFAULT_IP, RCS_PORT_NAME
  if HttpStart(ARoot, AIpAddress, APort) then
  begin
    try
      g_HTTPClient.FHTTPClient.ServiceRegister([TypeInfo(ICommonWSService)], sicShared); //sicClientDriven

      try
        I := g_HTTPClient.FHTTPClient.Service<ICommonWSService>;
      except
        on E: Exception do
        begin
          I := nil;
          exit;
        end;
      end;

      if I <> nil then
      begin
        LCommand := MakeCommand4CommonWSServer(ACommand, AParam);
        Result := I.ServerExecute(LCommand);
      end;
    finally
      I := nil;
      HttpStop;
    end;
  end;
end;

end.
