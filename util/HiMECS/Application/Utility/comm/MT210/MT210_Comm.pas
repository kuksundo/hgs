unit MT210_Comm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms, SyncObjs,
  Dialogs, CPort, DeCAL, IPCThrdClient_MT210, MT210ComConst, CommonUtil,
  StdCtrls, ComCtrls, ExtCtrls, DB, DBTables, Grids, DBGrids, iniFiles, MT210ComStruct,
  MyKernelObject, MT210ComThread, MT210Config, Menus, ByteArray,
  janSQL, janSQLStrings, CopyData, IPCThrd_MT210;

type
  TMT210ComF = class(TForm)
    Panel1: TPanel;
    StatusBar1: TStatusBar;
    ModBusSendComMemo: TMemo;
    Timer1: TTimer;
    MainMenu1: TMainMenu;
    N1: TMenuItem;
    N2: TMenuItem;
    N3: TMenuItem;
    N4: TMenuItem;
    About1: TMenuItem;
    Label4: TLabel;
    Button1: TButton;
    UnitLabel: TLabel;
    ValueEdit: TEdit;
    Label6: TLabel;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure WMReceiveString( var Message: TMessage ); message WM_RECEIVESTRING;
    procedure WMCopyData(var Msg: TMessage); message WM_COPYDATA;
    procedure Timer1Timer(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure N2Click(Sender: TObject);
    procedure N4Click(Sender: TObject);
    procedure Button1Click(Sender: TObject);
  private
    FFirst: Boolean;//맨처음에 실행될때 True 그 다음부터는 False
    FFilePath: string;      //파일을 저장할 경로
    FStoreType: TStoreType; //저장방식(ini or registry)
    FRecvStrBuf: String;        //스트링형 데이터 수신값이 저장됨
    FIPCClient: TIPCClient_MT210;//공유 메모리 및 이벤트 객체

    FQueryInterval: integer;
    FTimeOut: integer;

    //FEventHandle: TEvent;//Send한 후 Receive할때까지 Wait하는 Event

    FMT210ComThread: TMT210ComThread; //Thread 통신 객체

    procedure SetCurrentCommandIndex(aIndex: integer);
  public
    FComPort: TComPort;     //통신 포트
    FCommOK: Boolean;//통신포트가 정상이면 True
    FRecvByteBuf: TByteArray2;//헥사유형의 데이터 수신값이 저장됨
    FRecvWordBuf: array[0..255] of word;//TCP Wago 사용시 데이터 수신값 저장됨
    FCommandListOnce,
    FCommandListRepeat: TStringList;
    //현재 Comport에 Write한 FSendCommandList의 Index(0부터 시작함)
    FCurrentCommandIndex: integer;
    //일정시간 이상 통신에 대한 반응이 없으면 제어기 다운으로 간주(Wait 시간 설정)
    FCommFail: Boolean;
    FCommFailCount: integer; //통신 반응이 없이 FQueryInterval이 경과한 횟수
    FCriticalSection: TCriticalSection;

    procedure InitVar;
    procedure InitComport;
    procedure MakeCommand;
    function GetUnit(AUnit: string): string;

    procedure DisplayMessage(msg: string; IsSend: Boolean);

    procedure LoadConfigDataini2Form(ConfigForm:TMT210ConfigF);
    procedure LoadConfigDataini2Var;
    procedure SaveConfigDataForm2ini(ConfigForm:TMT210ConfigF);
    procedure SetConfigData;
    procedure SetConfigComm;
  published
    property FilePath: string read FFilePath;
    property StrBuf: string read FRecvStrBuf write FRecvStrBuf;
    property CurrentCommandIndex: integer read FCurrentCommandIndex write SetCurrentCommandIndex;
  end;

var
  MT210ComF: TMT210ComF;

implementation

{$R *.dfm}

procedure TMT210ComF.FormCreate(Sender: TObject);
begin
  InitVar;
end;

procedure TMT210ComF.FormDestroy(Sender: TObject);
begin
  FComport.Free;
  FIPCClient.Free;
  FCommandListOnce.Free;
  FCommandListRepeat.Free;
  FRecvByteBuf.Free;
  FCriticalSection.Free;
  //FEventHandle.Free;
  if FMT210ComThread.Suspended then
    FMT210ComThread.Resume;

  FMT210ComThread.Terminate;
  FMT210ComThread.FEventHandle.Signal;

  FMT210ComThread.Free;

end;

function TMT210ComF.GetUnit(AUnit: string): string;
begin
  Result := '';

  if AUnit = 'KPA' then
    Result := 'kPa'
  else if AUnit = 'KGF' then
    Result := 'kgf/cm²'
  else if AUnit = 'MHO' then
    Result := 'mmH2O'
  else if AUnit = 'MHG' then
    Result := 'mmHg'
  else if AUnit = 'IHO' then
    Result := 'inH2O'
  else if AUnit = 'IHG' then
    Result := 'inHg'
  else if AUnit = 'PSI' then
    Result := 'psi'
  else if AUnit = 'PP ' then
    Result := '%';
end;

procedure TMT210ComF.InitComport;
begin
  SetCurrentDir(FilePath);

  with FComport do
  begin
    FlowControl.ControlDTR := dtrEnable;
    OnRxChar := FMT210ComThread.OnReceiveChar;
    LoadSettings(FStoreType, FilePath+INIFILENAME);
    StatusBar1.Panels[0].Text := Port;
    StatusBar1.Panels[2].Text := BaudRateToStr(BaudRate)+','+
        DataBitsToStr(DataBits)+','+StopBitsToStr(StopBits)+','+ParityToStr(Parity.Bits);
    if Connected then
      Close;
  end;//with

end;

procedure TMT210ComF.InitVar;
begin
  FFirst := True;
  FCommOK := False;
  FStoreType := stIniFile;
  FFilePath := ExtractFilePath(Application.ExeName); //맨끝에 '\' 포함됨

  FIPCClient := TIPCClient_MT210.Create(0, IPCCLIENTNAME1, True);
  FCommandListRepeat := TStringList.Create;
  FCommandListOnce := TStringList.Create;
  FRecvByteBuf := TByteArray2.Create(0);
  FCriticalSection := TCriticalSection.Create;

  FComport := TComport.Create(nil);
  FComport.Name := 'COM1';
  FComport.SyncMethod := smWindowSync;

  FMT210ComThread := TMT210ComThread.Create(Self,1000);
  FMT210ComThread.CommPort := FComport;
  FMT210ComThread.StopComm := True;
  //SetConfigComm;

  LoadConfigDataini2Var;
end;

procedure TMT210ComF.MakeCommand;
var
  tmpstr: string;
  Li: integer;
begin
  FCommandListOnce.Clear;
  FCommandListRepeat.Clear;

  DisplayMessage('===================================', True);
  FCommandListOnce.Add(C_ESC_R);
  FCommandListOnce.Add(C_PU6);
  FCommandListOnce.Add(C_H1);
  FCommandListOnce.Add(C_DL0);

  for Li := 0 to FCommandListOnce.Count - 1 do
    DisplayMessage(FCommandListOnce.Strings[Li], True);

  FCommandListRepeat.Add(C_OD);

  for Li := 0 to FCommandListRepeat.Count - 1 do
    DisplayMessage(FCommandListRepeat.Strings[Li], True);

  DisplayMessage('===================================', True);

  FMT210ComThread.FSendCommandListOnce.Assign(FCommandListOnce);
  FMT210ComThread.FSendCommandListRepeat.Assign(FCommandListRepeat);
  //FMT210ComThread.FStopComm := False;
  FMT210ComThread.FSendCommandOnce := True;
  FMT210ComThread.FSendCommandRepeat := True;
  FMT210ComThread.Resume;
end;

procedure TMT210ComF.WMReceiveString(var Message: TMessage);
var
  TmpStr, TmpRecvStr: string;
  i, j, LengthStr: integer;
  EventData: TEventData_MT210;
begin  //CRLF가 없으면 쓰레드에서 이 함수로 넘어오지 않음
  FCriticalSection.Enter;
  try
    LengthStr := Length(FRecvStrBuf);
    EventData.FUnit := Copy(FRecvStrBuf,1,3);
    EventData.FUnit := GetUnit(EventData.FUnit);
    if EventData.FUnit <> UnitLabel.Caption then
      UnitLabel.Caption := EventData.FUnit;
    EventData.FState := Copy(FRecvStrBuf,4,1);
    if EventData.FState = 'N' then
    begin
      EventData.FData := StrToFloatDef(Copy(FRecvStrBuf,5,8),0.0);
      ValueEdit.Text := Copy(FRecvStrBuf,5,8);
      FIPCClient.PulseMonitor(EventData);
      //FMT210ComThread.FEventHandle.Signal;
      DisplayMessage(DateTimeToStr(Now) + '::********* 공유메모리에 데이타 전달함!!! **********'+#13#10, True);
    end
    else if EventData.FState = 'I' then
      DisplayMessage(DateTimeToStr(Now) + ':: Overange data'+#13#10, True)
    else if EventData.FState = 'O' then
      DisplayMessage(DateTimeToStr(Now) + ':: Computation overflow'+#13#10, True)
    else if EventData.FState = 'E' then
      DisplayMessage(DateTimeToStr(Now) + ':: No data'+#13#10, True)
  finally
    FCriticalSection.Leave;
  end;//try
end;

procedure TMT210ComF.Timer1Timer(Sender: TObject);
var
  LStr: string;
begin
  with Timer1 do
  begin
    Enabled := False;
    try
      SetCurrentDir(FilePath);
      if FFirst then
      begin
        if ParamCount > 0 then
        begin
          LStr := UpperCase(ParamStr(1));
          if LStr = '/A' then  //Automatic Communication Start
            Button1Click(nil);
        end;

        if FCommOK then
        begin
          FFirst := False;
          Interval := 500;
          MakeCommand;
        end;
      end//if
      else
      begin
        //SendQuery;
      end;
    finally
      Enabled := True;
    end;//try
  end;//with
end;

procedure TMT210ComF.DisplayMessage(msg: string; IsSend: Boolean);
begin
  if IsSend then
  begin
    if msg = ' ' then
    begin
      exit;
    end
    else ;

    with ModBusSendComMemo do
    begin
      if Lines.Count > 100 then
        Clear;

      Lines.Add(msg);
    end;//with
  end
  else
  begin
{    if msg = 'RxTrue' then
    begin
      exit;
    end
    else
    if msg = 'RxFalse' then
    begin
      exit;
    end;

    with ModBusRecvComMemo do
    begin
      if Lines.Count > 100 then
        Clear;

      Lines.Add(msg);
    end;//with
    }
  end;

end;

procedure TMT210ComF.SetCurrentCommandIndex(aIndex: integer);
begin
  if FCurrentCommandIndex <> aIndex then
    FCurrentCommandIndex := aIndex;
end;

procedure TMT210ComF.Button2Click(Sender: TObject);
begin
end;

//IniFile -> Form
procedure TMT210ComF.LoadConfigDataini2Form(ConfigForm:TMT210ConfigF);
var
  iniFile: TIniFile;
begin
  SetCurrentDir(FilePath);
  iniFile := nil;
  iniFile := TInifile.create(INIFILENAME);
  try
    with iniFile, ConfigForm do
    begin
      QueryIntervalEdit.Text := ReadString(IPCCLIENTNAME1, 'Query Interval','0');
      ResponseWaitTimeOutEdit.Text := ReadString(IPCCLIENTNAME1, 'Response Wait Time Out','0');
    end;//with
  finally
    iniFile.Free;
    iniFile := nil;
  end;//try
end;

procedure TMT210ComF.LoadConfigDataini2Var;
var
  iniFile: TIniFile;
begin
  SetCurrentDir(FilePath);
  iniFile := nil;
  iniFile := TInifile.create(INIFILENAME);
  try
    with iniFile do
    begin
      FQueryInterval := ReadInteger(IPCCLIENTNAME1, 'Query Interval',0);
      FMT210ComThread.QueryInterval := FQueryInterval;
      FTimeOut := ReadInteger(IPCCLIENTNAME1, 'Response Wait Time Out',0);
      FMT210ComThread.TimeOut := FTimeOut;
    end;//with

    FMT210ComThread.FComport.LoadSettings(FStoreType,FilePath + INIFILENAME);
  finally
    if not FFirst then
    begin
      MakeCommand;
    end;

    iniFile.Free;
    iniFile := nil;
  end;//try

end;

procedure TMT210ComF.SaveConfigDataForm2ini(ConfigForm:TMT210ConfigF);
var
  iniFile: TIniFile;
begin
  SetCurrentDir(FilePath);
  iniFile := nil;
  iniFile := TInifile.create(INIFILENAME);
  try
    with iniFile, ConfigForm do
    begin
      WriteString(IPCCLIENTNAME1, 'Query Interval',QueryIntervalEdit.Text);
      WriteString(IPCCLIENTNAME1, 'Response Wait Time Out', ResponseWaitTimeOutEdit.Text);
    end;//with
  finally
    iniFile.Free;
    iniFile := nil;
  end;//try
end;

procedure TMT210ComF.SetConfigData;
var
  ConfigData: TMT210ConfigF;
begin
  if Button1.Caption = 'Stop' then
    Button1Click(nil);

  ConfigData := nil;
  ConfigData := TMT210ConfigF.Create(Self);
  try
    with ConfigData do
    begin
      LoadConfigDataini2Form(ConfigData);
      if ShowModal = mrOK then
      begin
        SaveConfigDataForm2ini(ConfigData);
        LoadConfigDataini2Var;
      end;
    end;//with
  finally
    ConfigData.Free;
    ConfigData := nil;
  end;//try
end;

procedure TMT210ComF.N2Click(Sender: TObject);
begin
  SetConfigData;
end;

procedure TMT210ComF.N4Click(Sender: TObject);
begin
  Close;
end;

procedure TMT210ComF.SetConfigComm;
begin
  FComPort.ShowSetupDialog;
  FComPort.StoreSettings(FStoreType,FilePath + INIFILENAME);
  InitComPort;
end;

procedure TMT210ComF.WMCopyData(var Msg: TMessage);
begin
  DisplayMessage(PRecToPass(PCopyDataStruct(Msg.LParam)^.lpData)^.StrMsg,
             Boolean(PRecToPass(PCopyDataStruct(Msg.LParam)^.lpData)^.iHandle));
end;

procedure TMT210ComF.Button1Click(Sender: TObject);
begin
  try
    InitComPort;
  except
    ShowMessage('Comm port Initialize fail!');
  end;

  FMT210ComThread.StopComm := not FMT210ComThread.StopComm;

  if FMT210ComThread.StopComm then
  begin
    if FComport.Connected then
      FComport.Close;

    Button1.Caption := 'Start';
  end
  else
  begin
    //통신포트를 오픈한다
    FComport.Open;
    Sleep(100);
    FComport.ClearBuffer(True,True);

    FMT210ComThread.Resume;
    Button1.Caption := 'Stop';
  end;
end;

end.
