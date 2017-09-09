unit UnitCATVAsyncIPC;

interface

uses Winapi.Windows, Winapi.Messages, WinTypes, SysUtils,
  // cromis units
  Cromis.Comm.Custom, Cromis.Comm.IPC, Cromis.Threading, Cromis.AnyValue,
  GpCommandLineParser, UnitCatvParamClass;

Const
  IPCSERVERNAME = 'CATV IPC Server';

type
  TCATVAsycIPC = class
    procedure OnAsynchronousIPCTask(const ATask: ITask);
    procedure SyncIPCTask;
    procedure SendCommandToCromisIPC;
  end;

implementation

{ TCATVAsycIPC }

procedure TCATVAsycIPC.OnAsynchronousIPCTask(const ATask: ITask);
var
  IPCClient: TIPCClient;
  LRequest: IIPCData;
  LResult: IIPCData;
  LStr: AnsiString;
begin
  IPCClient := TIPCClient.Create;
  try
    LRequest := TMessageData.Create;
    LRequest.ID := DateTimeToStr(Now);
    LRequest.Data.WriteUTF8String('Command', 'CHANGE_FILENAME');
    LStr := ParamStr(1);
    LRequest.Data.WriteUTF8String('FileName', LStr);
    LResult := IPCClient.ExecuteRequest(LRequest);
  finally
    IPCClient.Free;
  end;
end;

procedure TCATVAsycIPC.SendCommandToCromisIPC;
var
  AsyncTask: ITask;
  FTaskPool: TTaskPool;
begin
//  AsyncTask := FTaskPool.AcquireTask(OnAsynchronousIPCTask, 'AsyncTask');
////  AsyncTask.Values.Ensure('ComputerName').AsString := eComputerName.Text;
//  AsyncTask.Values.Ensure('ServerName').AsString := IPCSERVERNAME;
//  AsyncTask.Run;
  SyncIPCTask;
end;

procedure TCATVAsycIPC.SyncIPCTask;
var
  IPCClient: TIPCClient;
  LRequest: IIPCData;
  LResult: IIPCData;
  LCommandLine: TCatvParameter;
  LMsg: string;

  function CommandLineParse(var AErrMsg: string): boolean;
  var
    LStr: string;
  begin
    AErrMsg := '';

    try
      CommandLineParser.Options := [opIgnoreUnknownSwitches];
      Result := CommandLineParser.Parse(LCommandLine);
    except
      on E: ECLPConfigurationError do begin
        AErrMsg := '*** Configuration error ***' + #13#10 +
          Format('%s, position = %d, name = %s',
            [E.ErrorInfo.Text, E.ErrorInfo.Position, E.ErrorInfo.SwitchName]);
        Exit;
      end;
    end;

    if not Result then
    begin
      AErrMsg := Format('%s, position = %d, name = %s',
        [CommandLineParser.ErrorInfo.Text, CommandLineParser.ErrorInfo.Position,
         CommandLineParser.ErrorInfo.SwitchName]) + #13#10;
      for LStr in CommandLineParser.Usage do
        AErrMsg := AErrMSg + LStr + #13#10;
    end
    else
    begin
    end;
  end;

begin
  IPCClient := TIPCClient.Create;
  LCommandLine := TCatvParameter.Create;
  try
    IPCClient.ServerName := IPCSERVERNAME;
    IPCClient.ConnectClient(cDefaultTimeout);
    try
      if IPCClient.IsConnected then
      begin
        CommandLineParse(LMsg);
        LRequest := TMessageData.Create;
        LRequest.ID := DateTimeToStr(Now);
        LRequest.Data.WriteUnicodeString('Command', 'CHANGE_FILENAME');

        if LCommandLine.DisplayFileName <> '' then
          LRequest.Data.WriteUnicodeString('FileName', LCommandLine.DisplayFileName);

        if LCommandLine.DirName <> '' then
          LRequest.Data.WriteUnicodeString('DirName', LCommandLine.DirName);

//        LStr := ParamStr(1);
        LResult := IPCClient.ExecuteRequest(LRequest);

        if IPCClient.AnswerValid then
        begin

        end;
      end;
    finally
      IPCClient.DisconnectClient;
    end;
  finally
    IPCClient.Free;
    LCommandLine.Free;
  end;
end;

end.
