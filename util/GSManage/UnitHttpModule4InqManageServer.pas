unit UnitHttpModule4InqManageServer;

interface

uses System.SysUtils, System.Classes, UnitInterfaceHTTPManager, UnitInqManageWSInterface,
  mORMot, SynCommons, UnitHttpModule;

function MakeCommand4InqManagerServer(ACommand, AParam: RawUTF8): RawUTF8;
function SendReq2InqManagerServer_Http(AIpAddress, APort, ARoot: string; ACommand, AParam: RawUTF8): RawUTF8;

//function SendReqTaskInfo_Http(AIpAddress: string; ASearchRec: RawUTF8): RawUTF8;
//function SendReqTaskDetail_Http(AIpAddress: string; AIDList: RawUTF8): RawUTF8;
//function SendReqTaskEmailList_Http(AIpAddress: string; ATaskID: RawUTF8): RawUTF8;
//function SendReqTaskEmailContent_Http(AIpAddress: string; ACommand4OL: RawUTF8): RawUTF8;

implementation

uses UnitBase64Util, CommonData;

function MakeCommand4InqManagerServer(ACommand, AParam: RawUTF8): RawUTF8;
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

function SendReq2InqManagerServer_Http(AIpAddress, APort, ARoot: string; ACommand, AParam: RawUTF8): RawUTF8;
var
  I: IInqManageService;
  LCommand: RawUTF8;
begin        //RCS_ROOT_NAME, RCS_DEFAULT_IP, RCS_PORT_NAME
  if HttpStart(ARoot, AIpAddress, APort) then
  begin
    try
      g_HTTPClient.FHTTPClient.ServiceRegister([TypeInfo(IInqManageService)], sicShared); //sicClientDriven

      try
        I := g_HTTPClient.FHTTPClient.Service<IInqManageService>;
      except
        on E: Exception do
        begin
          I := nil;
          exit;
        end;
      end;

      if I <> nil then
      begin
        LCommand := MakeCommand4InqManagerServer(ACommand, AParam);
        Result := I.ServerExecute(LCommand);
      end;
    finally
      I := nil;
      HttpStop;
    end;
  end;
end;

//function SendReqTaskInfo_Http(AIpAddress: string; ASearchRec: RawUTF8): RawUTF8;
//var
//  LCommand: RawUTF8;
//begin
//  LCommand := MakeCommand4InqManagerServer(CMD_REQ_TASK_LIST, ASearchRec);
//  Result := SendReq2InqManagerServer_Http(AIpAddress, LCommand);
//end;
//
//function SendReqTaskDetail_Http(AIpAddress: string; AIDList: RawUTF8): RawUTF8;
//var
//  LCommand: RawUTF8;
//begin
//  LCommand := MakeCommand4InqManagerServer(CMD_REQ_TASK_DETAIL, AIDList);
//  Result := SendReq2InqManagerServer_Http(AIpAddress, LCommand);
//end;
//
//function SendReqTaskEmailList_Http(AIpAddress: string; ATaskID: RawUTF8): RawUTF8;
//var
//  LCommand: RawUTF8;
//begin
//  LCommand := MakeCommand4InqManagerServer(CMD_REQ_TASK_EAMIL_LIST, ATaskID);
//  Result := SendReq2InqManagerServer_Http(AIpAddress, LCommand);
//end;
//
//function SendReqTaskEmailContent_Http(AIpAddress: string; ACommand4OL: RawUTF8): RawUTF8;
//var
//  LCommand: RawUTF8;
//begin
//  LCommand := MakeCommand4InqManagerServer(CMD_REQ_TASK_EAMIL_CONTENT, ACommand4OL);
//  Result := SendReq2InqManagerServer_Http(AIpAddress, LCommand);
//end;

end.
