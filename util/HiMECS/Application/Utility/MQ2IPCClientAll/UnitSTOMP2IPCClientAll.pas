unit UnitSTOMP2IPCClientAll;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, TimerPool,
  UnitIPCClientAll, UnitSTOMPClass, UnitConfigIniClass, UnitSTOMP2IPCClientAllConfig,
  Vcl.Menus, UnitWorker4OmniMsgQ, Vcl.StdCtrls, OtlComm, SynCommons,
  IPC_Modbus_Standard_Const, Vcl.ComCtrls, Vcl.ExtCtrls;

type
  TSTOMP2IPCClientAllF = class(TForm)
    MainMenu1: TMainMenu;
    File1: TMenuItem;
    Option1: TMenuItem;
    Config1: TMenuItem;
    Close1: TMenuItem;
    MsgWindowMemo: TMemo;
    Panel1: TPanel;
    StatusBar1: TStatusBar;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    MQServerIPEdit: TEdit;
    MQServerPortEdit: TEdit;
    TopicEdit: TEdit;
    PopupMenu1: TPopupMenu;
    ShowEventName1: TMenuItem;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure Close1Click(Sender: TObject);
    procedure Config1Click(Sender: TObject);
    procedure ShowEventName1Click(Sender: TObject);
  private
    FIPCClientAll: TIPCClientAll;
    FpjhSTOMPClass: TpjhSTOMPClass;
    FPJHTimerPool: TPJHTimerPool;
    FParamFileNameChanged: Boolean;
    FIniFileName: string;

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
    procedure SetParamItemValueFromModbusComm(AJsonRecord: string);
    procedure DisplayMessage(msg: string; ADspNo: Integer=1);
  public
    FExeFilePath: string;
    FSettings : TConfigSettings;

    procedure InitVar;
    procedure DestroyVar;
    procedure InitSTOMP;
    procedure DestroySTOMP;
    procedure InitIPCClientAll;
    procedure DestroyIPCClientAll;

    procedure DispConfigData;
  end;

var
  STOMP2IPCClientAllF: TSTOMP2IPCClientAllF;

implementation

uses CommonUtil, EngineParameterClass, StompTypes;

{$R *.dfm}

{ TSTOMP2IPCClientAllF }

procedure TSTOMP2IPCClientAllF.ApplyUI;
begin
  InitIPCClientAll;
  InitSTOMP;
end;

procedure TSTOMP2IPCClientAllF.Close1Click(Sender: TObject);
begin
  Close;
end;

procedure TSTOMP2IPCClientAllF.Config1Click(Sender: TObject);
begin
  SetConfig;
end;

procedure TSTOMP2IPCClientAllF.DestroyIPCClientAll;
begin
  if Assigned(FIPCClientAll) then
    FIPCClientAll.Free;
end;

procedure TSTOMP2IPCClientAllF.DestroySTOMP;
begin
  if Assigned(FpjhSTOMPClass) then
    FpjhSTOMPClass.Free;
end;

procedure TSTOMP2IPCClientAllF.DestroyVar;
begin
  if Assigned(FPJHTimerPool) then
  begin
    FPJHTimerPool.RemoveAll;
    FreeAndNil(FPJHTimerPool);
  end;

  DestroySTOMP;
  FSettings.Free;
end;

procedure TSTOMP2IPCClientAllF.DispConfigData;
begin
  MQServerIPEdit.Text := FSettings.MQServerIP;
  MQServerPortEdit.Text := FSettings.MQServerPort;
  TopicEdit.Text := FSettings.MQServerTopic;
end;

procedure TSTOMP2IPCClientAllF.DisplayMessage(msg: string; ADspNo: Integer);
begin
  case ADspNo of
    1 : begin
      if msg = ' ' then
      begin
        exit;
      end
      else
        ;

      with MsgWindowMemo do
      begin
        if Lines.Count > 500 then
          Clear;

        Lines.Add(msg);
      end;//with
    end;//dtSendMemo
  end;
end;

procedure TSTOMP2IPCClientAllF.FormCreate(Sender: TObject);
begin
  InitVar;
end;

procedure TSTOMP2IPCClientAllF.FormDestroy(Sender: TObject);
begin
  DestroyVar;
end;

procedure TSTOMP2IPCClientAllF.InitIPCClientAll;
begin
  if not Assigned(FIPCClientAll) then
    FIPCClientAll := TIPCClientAll.Create;

  if FParamFileNameChanged then
  begin
    FIPCClientAll.FEngineParameter.LoadFromJSONFile(FSettings.ParamFileName);
    FParamFileNameChanged := False;
  end;

  FIPCClientAll.CreateIPCClientAll;
end;

procedure TSTOMP2IPCClientAllF.InitSTOMP;
begin
  if FSettings.MQServerTopic = '' then
    FSettings.MQServerTopic := '/topic/' + FIPCClientAll.GetEngineName;//'UniqueEngineName';

  if not Assigned(FpjhSTOMPClass) then
  begin
    FpjhSTOMPClass := TpjhSTOMPClass.CreateWithStr(FSettings.MQServerUserId,
                                            FSettings.MQServerPasswd,
                                            FSettings.MQServerIP,
                                            FSettings.MQServerTopic,
                                            Self.Handle);
  end;
end;

procedure TSTOMP2IPCClientAllF.InitVar;
var
  LStr: string;
begin
  FPJHTimerPool := TPJHTimerPool.Create(nil);
  FExeFilePath := ExtractFilePath(Application.ExeName);
  FIniFileName := '';

  if ParamCount > 0 then
  begin
    LStr := UpperCase(ParamStr(1));
    if POS('/F', LStr) > 0 then  //FIniFileName 설정
    begin
      Delete(LStr,1,2);

      if POS(':\', LStr) = 0 then
        LStr := '.\' + LStr;

      FIniFileName := LStr;
    end;
  end;

  if FIniFileName = '' then
    FIniFileName := ChangeFileExt(Application.ExeName, '.ini');

  FSettings := TConfigSettings.create(FIniFileName);
  LoadConfigFromFile;
  FParamFileNameChanged := True;

  if FileExists(FSettings.ParamFileName) then
  begin
    InitIPCClientAll;
    InitSTOMP;
  end
  else
    ShowMessage('Param File Name is empty or not exist    !');

  DispConfigData;
end;

procedure TSTOMP2IPCClientAllF.LoadConfig2Form(AForm: TConfigF);
begin
  FSettings.LoadConfig2Form(AForm, FSettings);
end;

procedure TSTOMP2IPCClientAllF.LoadConfigForm2Object(AForm: TConfigF);
begin
  FSettings.LoadConfigForm2Object(AForm, FSettings);
end;

procedure TSTOMP2IPCClientAllF.LoadConfigFromFile(AFileName: string);
begin
  FSettings.Load(AFileName);
end;

procedure TSTOMP2IPCClientAllF.ProcessResults;
var
  msg: TOmniMessage;
  LStompFrame: IStompFrame;
begin
  while FpjhSTOMPClass.GetResponseQMsg(msg) do
  begin
    LStompFrame := msg.MsgData.AsInterface as IStompFrame;
    SetParamItemValueFromModbusComm(LStompFrame.GetBody);
    DisplayMessage(LStompFrame.GetBody);
  end;
end;

procedure TSTOMP2IPCClientAllF.SetConfig;
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

procedure TSTOMP2IPCClientAllF.SetParamItemValueFromModbusComm(AJsonRecord: string);
var //Block No를 찾아서 Value에 저장함(ModbusComm 통신프로그램에서 직접 수신하는 경우임)
  i, LBlockNo, LByteCount: integer;
  LCollect: TEngineParameterCollect;
  LValue: TEventData_Modbus_Standard_DynArr;
  LEventData: TEventData_Modbus_Standard;
  LUtf8: RawUTF8;
begin
  LUtf8 := StringToUTF8(AJsonRecord);
  RecordLoadJSON(LValue, pointer(LUtf8), TypeInfo(TEventData_Modbus_Standard_DynArr));
  Copy_DynArrRec_2_EventData_Modbus_Standard(LValue, LEventData);
  FIPCClientAll.PulseEventData<TEventData_Modbus_Standard>(LEventData);
  DisplayMessage('******' + LEventData.EngineName + '****** Pulse Event OK!');
  //ACsv = blockno,bytecount,data1,data2...
//  LBlockNo := StrToInt(strToken(ACsv, ','));
//  LByteCount := StrToInt(strToken(ACsv, ','));
//
//  for i := 0 to FIPCClientAll.FEngineParameter.EngineParameterCollect.Count - 1 do
//  begin
//    LCollect := FIPCClientAll.FEngineParameter.EngineParameterCollect;
//
//    if LBlockNo = LCollect.Items[i].BlockNo then
//    begin
//      if ACsv <> '' then
//        LCollect.Items[i].Value := strToken(ACsv, ',');
//    end;
//  end;
end;

procedure TSTOMP2IPCClientAllF.ShowEventName1Click(Sender: TObject);
begin
  ShowMessage(FIPCClientAll.GetEventName);
end;

procedure TSTOMP2IPCClientAllF.WorkerResult(var msg: TMessage);
begin
  ProcessResults;
end;

end.
