unit UnitFrameSTOMP2IPCMonitorAll;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, TimerPool,
  UnitFrameIPCMonitorAll, UnitSTOMPClass, UnitConfigIniClass, UnitSTOMP2IPCMonitorAllConfig,
  Vcl.Menus, UnitWorker4OmniMsgQ, Vcl.StdCtrls, OtlComm, EngineParameterClass;

type
  TFrameSTOMP2IPCMonitor = class(TFrame)
  private
    FrameIPCMonitor: TFrameIPCMonitor;
    FpjhSTOMPClass: TpjhSTOMPClass;
    FPJHTimerPool: TPJHTimerPool;
    FParamFileNameChanged: Boolean;

    procedure LoadConfigFromFile(AFileName: string = '');
    procedure LoadConfig2Form(AForm: TConfigF);
    procedure LoadConfigForm2Object(AForm: TConfigF);
    procedure SetConfig;
    procedure ApplyUI;
  protected
//    procedure OnMakeData4Simulate(Sender : TObject; Handle : Integer;
//            Interval : Cardinal; ElapsedTime : LongInt);
    procedure WorkerResult(var msg: TMessage); message MSG_RESULT;
    procedure ProcessResults;
    procedure SetParamItemValueFromModbusComm(ACsv: string);
  public
    FExeFilePath: string;
    FSettings : TConfigSettings;

    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;

    procedure InitVar;
    procedure DestroyVar;
    procedure InitSTOMP;
    procedure DestroySTOMP;
    procedure InitIPCClientAll;
    procedure DestroyIPCClientAll;

    procedure SetFrameIPCMonitor(AFrame:TFrameIPCMonitor);
  end;

implementation

uses CommonUtil;

{$R *.dfm}

{ TFrameSTOMP2IPCMonitor }

procedure TFrameSTOMP2IPCMonitor.ApplyUI;
begin
  InitIPCClientAll;
  InitSTOMP;
end;

constructor TFrameSTOMP2IPCMonitor.Create(AOwner: TComponent);
begin
  inherited;
  InitVar;
end;

destructor TFrameSTOMP2IPCMonitor.Destroy;
begin
  DestroyVar;

  inherited;
end;

procedure TFrameSTOMP2IPCMonitor.DestroyIPCClientAll;
begin

end;

procedure TFrameSTOMP2IPCMonitor.DestroySTOMP;
begin
  FpjhSTOMPClass.Free;
end;

procedure TFrameSTOMP2IPCMonitor.DestroyVar;
begin

end;

procedure TFrameSTOMP2IPCMonitor.InitIPCClientAll;
begin
  if not Assigned(FrameIPCMonitor) then
    FrameIPCMonitor := TFrameIPCMonitor.Create;

  if FParamFileNameChanged then
    FrameIPCMonitor.FEngineParameter.LoadFromJSONFile(FSettings.ParamFileName)
end;

procedure TFrameSTOMP2IPCMonitor.InitSTOMP;
begin
  if FSettings.MQServerTopic = '' then
    FSettings.MQServerTopic := FrameIPCMonitor.GetEventName;//'UniqueEngineName';

  if not Assigned(FpjhSTOMPClass) then
  begin
    FpjhSTOMPClass := TpjhSTOMPClass.Create(FSettings.MQServerUserId,
                                            FSettings.MQServerPasswd,
                                            FSettings.MQServerIP,
                                            FSettings.MQServerTopic,
                                            Self.Handle);
  end;
end;

procedure TFrameSTOMP2IPCMonitor.InitVar;
begin
  FPJHTimerPool := TPJHTimerPool.Create(nil);
  FExeFilePath := ExtractFilePath(Application.ExeName);
  FSettings := TConfigSettings.create(ChangeFileExt(Application.ExeName, '.ini'));
  LoadConfigFromFile;

  if FileExists(FSettings.ParamFileName) then
  begin
    InitIPCClientAll;
    InitSTOMP;
  end
  else
    ShowMessage('Param File Name is empty or not exist    !');
end;

procedure TFrameSTOMP2IPCMonitor.LoadConfig2Form(AForm: TConfigF);
begin
  FSettings.LoadConfig2Form(AForm, FSettings);
end;

procedure TFrameSTOMP2IPCMonitor.LoadConfigForm2Object(AForm: TConfigF);
begin
  FSettings.LoadConfigForm2Object(AForm, FSettings);
end;

procedure TFrameSTOMP2IPCMonitor.LoadConfigFromFile(AFileName: string);
begin
  FSettings.Load(AFileName);
end;

procedure TFrameSTOMP2IPCMonitor.ProcessResults;
var
  msg: TOmniMessage;
begin
  while FpjhSTOMPClass.GetResponseQMsg(msg) do
  begin
//    Memo1.Lines.Add(msg.MsgData);
  end;
end;

procedure TFrameSTOMP2IPCMonitor.SetConfig;
var
  LConfigF: TConfigF;
  LParamFileName: string;
begin
  LConfigF := TConfigF.Create(Self);

  try
    LParamFileName := FSettings.ParamFileName;
    LoadConfig2Form(LConfigF);

    if LConfigF.ShowModal = mrOK then
    begin
      LoadConfigForm2Object(LConfigF);
      FSettings.Save();

      FParamFileNameChanged := (LParamFileName <> FSettings.ParamFileName) and
        (FileExists(FSettings.ParamFileName));
      ApplyUI;
    end;
  finally
    LConfigF.Free;
  end;
end;

procedure TFrameSTOMP2IPCMonitor.SetFrameIPCMonitor(AFrame: TFrameIPCMonitor);
begin
  FrameIPCMonitor := AFrame;
end;

procedure TFrameSTOMP2IPCMonitor.SetParamItemValueFromModbusComm(ACsv: string);
var //Block No를 찾아서 Value에 저장함(ModbusComm 통신프로그램에서 직접 수신하는 경우임)
  i, LBlockNo, LByteCount: integer;
  LCollect: TEngineParameterCollect;
begin
  //ACsv = blockno,bytecount,data1,data2...
  LBlockNo := StrToInt(strToken(ACsv, ','));
  LByteCount := StrToInt(strToken(ACsv, ','));

  for i := 0 to FIPCClientAll.FEngineParameter.EngineParameterCollect.Count - 1 do
  begin
    LCollect := FIPCClientAll.FEngineParameter.EngineParameterCollect;

    if LBlockNo = LCollect.Items[i].BlockNo then
    begin
      if ACsv <> '' then
        LCollect.Items[i].Value := strToken(ACsv, ',');
    end;
  end;
end;

procedure TFrameSTOMP2IPCMonitor.WorkerResult(var msg: TMessage);
begin
  ProcessResults;
end;

end.
