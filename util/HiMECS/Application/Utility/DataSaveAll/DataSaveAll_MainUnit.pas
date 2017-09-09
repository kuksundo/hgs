unit DataSaveAll_MainUnit;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ExtCtrls, Vcl.Menus, Vcl.StdCtrls,
  Vcl.ComCtrls, iniFiles, DataSave2FileThread, UnitFrameIPCMonitorAll,
  DataSave2DBThread, DeCAL, commonUtil, DataSaveAll_Const,
  DataSaveAll_ConfigUnit, TimerPool, HiMECSConst, EngineParameterClass,
  IPCThrd_HiMECS_MDI, JvFormPlacement, JvComponentBase, JvAppStorage,
  JvAppIniStorage;

type
  TDisplayTarget = (dtSendMemo, dtStatusBar);

  TFrmDataSaveAll = class(TForm)
    Protocol: TMemo;
    StatusBar1: TStatusBar;
    MainMenu1: TMainMenu;
    FILE1: TMenuItem;
    Connect1: TMenuItem;
    Disconnect1: TMenuItem;
    N1: TMenuItem;
    Close1: TMenuItem;
    HELP1: TMenuItem;
    Option1: TMenuItem;
    Help2: TMenuItem;
    About1: TMenuItem;
    Timer1: TTimer;
    PopupMenu1: TPopupMenu;
    Actionsave1: TMenuItem;
    SaveDialog1: TSaveDialog;
    OpenDialog1: TOpenDialog;
    ActionLoadFromFile1: TMenuItem;
    Panel1: TPanel;
    CB_Active: TCheckBox;
    Label2: TLabel;
    RunHourPanel: TPanel;
    Panel2: TPanel;
    GroupBox1: TGroupBox;
    CB_DBlogging: TCheckBox;
    CB_CSVlogging: TCheckBox;
    ED_csv: TEdit;
    RB_bydate: TRadioButton;
    RB_byfilename: TRadioButton;
    GroupBox2: TGroupBox;
    Label1: TLabel;
    RB_byevent: TRadioButton;
    RB_byinterval: TRadioButton;
    ED_interval: TEdit;
    JvAppIniFileStorage1: TJvAppIniFileStorage;
    JvFormStorage1: TJvFormStorage;
    procedure Connect1Click(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure Option1Click(Sender: TObject);
    procedure CB_ActiveClick(Sender: TObject);
    procedure RB_byfilenameClick(Sender: TObject);
    procedure RB_bydateClick(Sender: TObject);
    procedure Actionsave1Click(Sender: TObject);
    procedure ActionLoadFromFile1Click(Sender: TObject);
  private
    //DB에 데이터저장을 위한 변수선언부
    FDataSave2DBThread: TDataSave2DBThread; //DB에 데이타 저장하는 객체

    //CSV 파일 저장을 위한 변수선언부///////////////////////////////////////////
    FLogStart: Boolean;  //Log save Start sig.
    FTagNameBuf: string;  //파일에 제목을 저장하기 위한 버퍼
    FSaveFileName: string; //데이타를 저장할 File 이름(설정에 따라 변경됨)
    FSaveDataBuf: string; //파일에 저장할 데이타를 저장하는 버퍼
    FSaveDBDataBuf: string; //DB에 저장할 데이타를 저장하는 버퍼
    FFileName_Convention: TFileName_Convetion;//파일에 저장시에 파일이름부여 방법
    FDataSave2FileThread: TDataSave2FileThread;//파일에 데이타 저장하는 객체
    FCSVHeader: string;
    FDynamoHeader:string;
    FDynamoCSVData: string;

    FMapFileName: string;
    FParamFileName: string;
    FPowerMeterSMM: string;
    FECSSMM: string;
    FDynamoSMM: string;
    FEngParamEncrypt: Boolean;
    FEngParamFileFormat: integer;

    FPJHTimerPool: TPJHTimerPool;
    FDataSaveTimerHandle: integer;
    FRunHourCalcTimerHandle: integer;
    FRunHourSaveTimerHandle: integer;
    FDBReConnectTimerHandle: integer;
    FRunHourSaveInterval: integer;
    FRunHourValue: LongInt;//Run Hour Value by Seconds
    FRunHourValueFromini: LongInt;//Run Hour Value by Seconds from ini
    FSemaphoreHandle: THandle;//Run hour 계산시 다른 프로세스에서 중복 실행 금지
    FRunHourEnable: Boolean;//Run hour를 파일에 쓰고자 할 경우: True일 경우에만 가능

    FParameterSourceList,
    FParameterOriginalList: TStringList;
    FDestroying: Boolean;   //종료중이면 True(종료시 먹통 떄문에 추가함)
    FSaveInterval: integer;
    FReConnectInterval: integer;
    FConfigModified: Boolean;

    //TFrameIPCMonitorAll1.FEngineParameter.EngineParameterCollect.Items[FParamIndex].Value 값이 0이 아닐 경우에만
    //데이터를 저장함(FIsSaveOnly = True)
    FIsSaveOnly: boolean;
    FIsSaveRunHour: boolean;
    FAutoChangeSaveFileName: boolean;
    FParamIndex: Integer;
    FParamRunHourIndex: integer;
    FActionDataIni: string;//Action data 저장 할 ini file name: param으로 입력 받음
    FIsAutoRun: Boolean;

    //IPC Thread -->
    Flags: TClientFlags;
    IPCClient_HiMECS_MDI: TIPCClient_HiMECS_MDI;
    procedure OnConnect(Sender: TIPCThread_HiMECS_MDI; Connecting: Boolean);
    procedure OnSignal(Sender: TIPCThread_HiMECS_MDI; Data: TEventData_HiMECS_MDI);
    procedure UpdateStatusBar(var Msg: TMessage); message WM_UPDATESTATUS_HiMECS_MDI;
    //IPC Thread <--

    procedure WMDBDisconnected(var Msg: TMessage); message WM_DB_DISCONNECTED;
    //ini 파일 설정과 저장을 위한 함수 선언부
    procedure LoadConfigDataini2Form(FSaveConfigF: TFrmDataSaveAllConfig);
    procedure SaveConfigDataForm2ini(FSaveConfigF: TFrmDataSaveAllConfig);
    procedure LoadConfigDataini2Var(AFileName: string='');
    //procedure SaveConfigDataParam2ini;
    procedure AdjustConfigData(AParamModified: Boolean = True);
    procedure LoadRunHourFromini;
    procedure SaveRunHour2ini;
    function IsRunHourEnable: Boolean;
    procedure SaveActionData2ini;
    procedure LoadActionDataFromini(AFileName: string='');
    procedure ApplyActionData;

    procedure InitVar;
    procedure IPCAll_Init;
    procedure IPCAll_Final;

    procedure MakeCSVHeader(AParamFileNameChanged: Boolean);

    procedure OnDataSave(Sender : TObject; Handle : Integer;
            Interval : Cardinal; ElapsedTime : LongInt);
    procedure OnReconnectWhenDBDisconnect(Sender : TObject; Handle : Integer;
            Interval : Cardinal; ElapsedTime : LongInt);
    procedure OnRunHourCalc(Sender : TObject; Handle : Integer;
            Interval : Cardinal; ElapsedTime : LongInt);
    procedure OnRunHourSave(Sender : TObject; Handle : Integer;
            Interval : Cardinal; ElapsedTime : LongInt);
    procedure OnDataSaveOnce(Sender : TObject; Handle : Integer;
            Interval : Cardinal; ElapsedTime : LongInt);
  protected
    procedure WatchValue2Screen_Analog(Name: string; AValue: string;
                                AEPIndex: integer);
    //엔진이 멈추거나 프로그램 종료시 100건 이전의 DataList의 Data를 저장할 때
    //ADataStopping = True
    procedure Proc_DataSave(ADataStopping: Boolean);
    function GetIniFileName: string;
  public
    FFilePath: string;      //파일을 저장할 경로
    FIniFileName: string;   //ini File name
    FMonitorStart: Boolean; //타이머 동작 완료하면 True
    //DB 저장시 모든 데이터 수신 후 DB 입력해야 하므로 현재 수신된 Block No가 필요
    FCurrentBlockNo: integer;
    FLastBlockNo: integer;

    FHostName: string;//DB Host Name(IP address)
    FDBName: string;  //DB Name(Mysql의 DB Name)
    FLoginID: string;   //Login Name
    FPasswd: string;  //Password
    FSaveTableName: string;
    FConnectedDB: Boolean;
    FAppendStr: string;
    FBulkDataMode: Boolean; //통신Interval이 200ms 이하이면 True(100건씩 파일에 저장함)

    FToggleBackground: Boolean;
    FDataSaveStopping: Boolean;

    procedure SaveData2DB;
    procedure SaveData2File;
    procedure CreateSave2DBThread;
    procedure CreateSave2FileThread;
    procedure DisplayMessage(msg: string; ADspNo: TDisplayTarget);
    procedure DisplayMessage2SB(Msg: string);
    procedure DestroySave2FileThread;
    procedure DestroySave2DBThread;
    procedure AdjustBulkMode;
  end;

var
  FrmDataSaveAll: TFrmDataSaveAll;

implementation

{$R *.dfm}

//24시간을 초과한 경우에도 hhh:mm:ss로 표시 가능
//V: second
Function FORMAT_TIME (V : Integer) : string; { format time as hh:mm:ss }
Var
  Hour,Min,Sec : Integer;
  str1: string;
begin
  FORMAT_TIME := '';

  if V < 0 then
    exit;

  Hour := V div 3600;
  V := V mod 3600;               { process hours }

  Min := V div 60;
  Sec := V mod 60;                 { process minutes }

  FORMAT_TIME := Format('%d:%.2d:%.2d',[Hour,Min,Sec]);
end;

procedure TFrmDataSaveAll.ActionLoadFromFile1Click(Sender: TObject);
begin
  OpenDialog1.InitialDir := FFilePath;
  if OpenDialog1.Execute then
  begin
    if OpenDialog1.FileName <> '' then
    begin
      LoadActionDataFromini(OpenDialog1.FileName);
    end;
  end;
end;

procedure TFrmDataSaveAll.Actionsave1Click(Sender: TObject);
begin
  SaveActionData2ini;
end;

procedure TFrmDataSaveAll.AdjustBulkMode;
begin
  if not Assigned(FDataSave2FileThread) then
    exit;

  if FBulkDataMode then
  begin
    StatusBar1.Panels[0].Text := 'Bulk Mode';

    if not Assigned(FDataSave2FileThread.FDataList) then
      FDataSave2FileThread.FDataList := TStringList.Create;
  end
  else
  begin
    StatusBar1.Panels[0].Text := '';

    if Assigned(FDataSave2FileThread.FDataList) then
      FreeAndNil(FDataSave2FileThread.FDataList);
  end;

end;

procedure TFrmDataSaveAll.AdjustConfigData(AParamModified: Boolean = True);
begin
  if AParamModified then //Parameter File Name이 변경 되었을 경우에만 True
  begin
    if FileExists(FParamFileName) then
    begin
      TFrameIPCMonitorAll1.FEngineParameter.EngineParameterCollect.Clear;
      if FEngParamFileFormat = 0 then //XML File Format
        TFrameIPCMonitorAll1.FEngineParameter.LoadFromFile(FParamFileName, ExtractFileName(FParamFileName), FEngParamEncrypt)
      else
      if FEngParamFileFormat = 1 then //JSON File Format
        TFrameIPCMonitorAll1.FEngineParameter.LoadFromJSONFile(FParamFileName, ExtractFileName(FParamFileName), FEngParamEncrypt);

      MakeCSVHeader(AParamModified);
      //SaveConfigDataParam2ini;
    end
    else
      ShowMessage('Not exist parameter file: ' + FParamFileName);

    Label2.Visible := FIsSaveRunHour;
    RunHourPanel.Visible := FIsSaveRunHour;
  end
  else
    MakeCSVHeader(AParamModified);

  FBulkDataMode := FSaveInterval <= 200;
  AdjustBulkMode;
end;

procedure TFrmDataSaveAll.ApplyActionData;
begin
  CB_Active.Checked := True;

  CB_ActiveClick(nil);
end;

procedure TFrmDataSaveAll.CB_ActiveClick(Sender: TObject);
begin
  if CB_Active.Checked then
  begin
    DisplayMessage (#13#10+ '#####################' +#13#10+ TimeToStr(Time)+' Start Data Receiving', dtSendMemo);
    //CSV 파일에 Data Save할 경우
    if CB_CSVlogging.Checked then
    begin
      FSaveFileName := ED_csv.Text;
      FPJHTimerPool.RemoveAll;
      CreateSave2FileThread;
      FDataSaveTimerHandle := FPJHTimerPool.Add(OnDataSave, FSaveInterval);
    end;

    //Database에 Data Save할 경우
    if CB_DBlogging.Checked then
    begin
      FPJHTimerPool.RemoveAll;
      CreateSave2DBThread;
      FDataSaveTimerHandle := FPJHTimerPool.Add(OnDataSave, FSaveInterval);
    end;
  end
  else
  begin
    FMonitorStart := False;
    DisplayMessage (TimeToStr(Time)+#13#10+' Processing terminated', dtSendMemo);
    FPJHTimerPool.RemoveAll;

    if FIsSaveRunHour then
    begin
      if FRunHourCalcTimerHandle <> -1 then
      begin
        FPJHTimerPool.Remove(FRunHourCalcTimerHandle);
        FRunHourCalcTimerHandle := -1;
        FPJHTimerPool.Remove(FRunHourSaveTimerHandle);
        FRunHourSaveTimerHandle := -1;
        SaveRunHour2ini;
      end;
    end;
  end;
end;

procedure TFrmDataSaveAll.Connect1Click(Sender: TObject);
begin
  CreateSave2DBThread;
end;

procedure TFrmDataSaveAll.CreateSave2DBThread;
begin
  if not Assigned(FDataSave2DBThread) then
  begin
    FDataSave2DBThread := TDataSave2DBThread.Create(Self);
    with FDataSave2DBThread do
    begin
      //FHostName := Self.FHostName;
      //FDBName := Self.FDBName;
      //FLoginID := Self.FLoginID;
      //FPasswd := Self.FPasswd;
      if FDataSave2DBThread.FOraSession1.Connected then
      begin
        FDataSave2DBThread.Create_InsertSQL(FSaveTableName);
        DisplayMessage ('Server Connected', dtSendMemo);
        Resume;
      end
    end;//with
  end;//if

  if not FDataSave2DBThread.FOraSession1.Connected then
  begin
    FDataSave2DBThread.ConnectDB;
    FDataSave2DBThread.Create_InsertSQL(FSaveTableName);
    FDataSave2DBThread.Resume;
    if FDataSave2DBThread.FOraSession1.Connected then
      DisplayMessage ('Server Re-Connected', dtSendMemo);
  end;
end;

////////////////////////////////////////////////////////////////////////////////
//CSV 파일 저장 쓰레드  생성 함수
procedure TFrmDataSaveAll.CreateSave2FileThread;
begin
  if not Assigned(FDataSave2FileThread) then
  begin
    FDataSave2FileThread := TDataSave2FileThread.Create(Self);
    AdjustBulkMode;
    FDataSave2FileThread.Resume;
  end;
end;

procedure TFrmDataSaveAll.DestroySave2DBThread;
begin
  if Assigned(FDataSave2DBThread) then
  begin
    FDataSave2DBThread.Terminate;
    FDataSave2DBThread.FDataSaveEvent.Signal;
    FDataSave2DBThread.Free;
    FDataSave2DBThread := nil;
  end;//if
end;

procedure TFrmDataSaveAll.DestroySave2FileThread;
begin
  if Assigned(FDataSave2FileThread) then
  begin
    FDataSave2FileThread.Terminate;
    FDataSave2FileThread.FDataSaveEvent.Signal;
    FDataSave2FileThread.Free;
    FDataSave2FileThread := nil;
  end;//if
end;

procedure TFrmDataSaveAll.DisplayMessage(msg: string; ADspNo: TDisplayTarget);
begin
  if FToggleBackground then
    Protocol.Color := $0080FF80
  else
    Protocol.Color := clWhite;

  case ADspNo of
    dtSendMemo : begin
      if msg = ' ' then
      begin
        exit;
      end
      else
        ;

      with Protocol do
      begin
        if Lines.Count > 100 then
          Clear;

        Lines.Add(msg);
      end;//with
    end;//dtSendMemo

    dtStatusBar: begin
       StatusBar1.SimplePanel := True;
       StatusBar1.SimpleText := msg;
    end;//dtStatusBar
  end;//case
end;

procedure TFrmDataSaveAll.DisplayMessage2SB(Msg: string);
begin
  StatusBar1.SimplePanel := True;
  StatusBar1.SimpleText := Msg;
end;

procedure TFrmDataSaveAll.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  if CB_Active.Checked then
  begin
    FMonitorStart := False;
    DisplayMessage (TimeToStr(Time)+#13#10+' Processing terminated', dtSendMemo);
    FPJHTimerPool.RemoveAll;

    if FIsSaveRunHour then
      SaveRunHour2ini;
  end;

  if FSemaphoreHandle <> 0 then
    CloseHandle(FSemaphoreHandle);

  FMonitorStart := False;

  DestroySave2FileThread;
  DestroySave2DBThread;

  IPCClient_HiMECS_MDI.Free;
  FParameterSourceList.Free;
  FParameterOriginalList.Free;
  FPJHTimerPool.RemoveAll;
  FPJHTimerPool.Free;
end;

procedure TFrmDataSaveAll.FormCreate(Sender: TObject);
begin
//  JvAppIniFileStorage1.FileName := GetIniFileName;
  //JvFormStorage1.Active := True;
  GetIniFileName;
  InitVar;
end;

function TFrmDataSaveAll.GetIniFileName: string;
var
  LStr: string;
  i: integer;
begin
  if ParamCount > 0 then
  begin
    LStr := ParamStr(1);
    i := Pos('/A', UpperCase(LStr)); //Automatic Start
    if i > 0 then  //A 제거
    begin
      FIniFileName := '.\'+ Copy(LStr, i+2, Length(LStr)-i-1);//환경저장 파일이름
    end;
  end
  else
  begin
    FIniFileName := SAVEINIFILENAME;
  end;

  Result := FIniFileName;
end;

procedure TFrmDataSaveAll.InitVar;
begin
  FFilePath := ExtractFilePath(Application.ExeName); //맨끝에 '\' 포함됨
  FPJHTimerPool := TPJHTimerPool.Create(nil);
  FRunHourCalcTimerHandle := -1;
  FRunHourSaveTimerHandle := -1;
  FDBReConnectTimerHandle := -1;
  FRunHourValueFromini := -1;
  FParameterOriginalList := TStringList.Create;
  FParameterSourceList := TStringList.Create;
  FMonitorStart := False;
  FDestroying := False;
end;

procedure TFrmDataSaveAll.IPCAll_Final;
begin
  TFrameIPCMonitorAll1.DestroyIPCMonitorAll;
  DisplayMessage('All IPCMonitor is destroyed.', dtSendMemo);
end;

procedure TFrmDataSaveAll.IPCAll_Init;
var
  LStr: string;
  i: integer;
  LEPItem: TEngineParameterItem;
begin
  StatusBar1.Panels[1].Text := '';

  for i := 0 to FParameterSourceList.Count - 1 do
  begin
    LEPItem := TEngineParameterItem(FParameterSourceList.Objects[i]);
    if (LEPItem.ParameterSource = psECS_AVAT) or
      (LEPItem.ParameterSource = psECS_kumo) then
    begin
      if FMapFileName <> '' then
        TFrameIPCMonitorAll1.SetModbusMapFileName(FMapFileName, LEPItem.ParameterSource);
    end;

    LStr := TFrameIPCMonitorAll1.CreateIPCMonitor_xx(LEPItem.ParameterSource, LEPItem.SharedName);
    DisplayMessage(LStr + ' Created.', dtSendMemo);
    if StatusBar1.Panels[1].Text = '' then
      StatusBar1.Panels[1].Text := LStr
    else
      StatusBar1.Panels[1].Text := StatusBar1.Panels[1].Text + ', ' + LStr;
  end;
end;

function TFrmDataSaveAll.IsRunHourEnable: Boolean;
var
    hSem: THANDLE;
begin
  hSem := CreateSemaphore(nil, 0, 1, RUNHOUR_SEMAPHORENAME);
  // 보호속성 = NULL, 초기 카운트 = 0, 최대 카운트 = 1, 세마포어 이름 = RUNHOUR_SEMAPHORENAME
  if (hSem <> 0) and (GetLastError() = ERROR_ALREADY_EXISTS) then
  begin
    // 이미 세마포어가  만들어져 있는 경우에 False Return
    CloseHandle(hSem);
    Result := False;
    exit;
  end;

  FSemaphoreHandle := hSem;
  Result := True;
end;

procedure TFrmDataSaveAll.LoadActionDataFromini(AFileName: string='');
var
  iniFile: TIniFile;
begin
  SetCurrentDir(FFilePath);

  if AFileName = '' then
    FActionDataIni := ExtractFileName(Application.ExeName)+'ActionData.ini'
  else
    FActionDataIni := AFileName;

  LoadConfigDataini2Var(FActionDataIni);

  iniFile := nil;
  iniFile := TInifile.create(FActionDataIni);

  try
    with iniFile do
    begin
      CB_DBLogging.Checked := ReadBool(ACTIONSAVE_SECTION, 'DB Logging', False);
      CB_CSVLogging.Checked := ReadBool(ACTIONSAVE_SECTION, 'CSV Logging', False);
      RB_Bydate.Checked := ReadBool(ACTIONSAVE_SECTION, 'By Date', False);
      RB_ByFileName.Checked := ReadBool(ACTIONSAVE_SECTION, 'By File Name', False);

      if RB_Bydate.Checked then
        RB_bydateClick(nil);

      if RB_ByFileName.Checked then
        ED_csv.Text := ReadString(ACTIONSAVE_SECTION, 'CSV File Name', '');

      RB_ByEvent.Checked := ReadBool(ACTIONSAVE_SECTION, 'By Event', False);
      RB_ByInterval.Checked := ReadBool(ACTIONSAVE_SECTION, 'By Interval', False);
      ED_interval.Text := ReadString(ACTIONSAVE_SECTION, 'Interval', '');
    end;//with

    DisplayMessage(#13#10+'Action Data Loaded'+#13#10, dtSendMemo);

  finally
    iniFile.Free;
    iniFile := nil;
  end;//try
end;

procedure TFrmDataSaveAll.LoadConfigDataini2Form(
  FSaveConfigF: TFrmDataSaveAllConfig);
var
  iniFile: TIniFile;
  LStr, LFileName: string;
  i: integer;
  LStrList: TStringList;
begin
  SetCurrentDir(FFilePath);

  if FIsAutoRun then
    LFileName := FActionDataIni
  else
    LFileName := SAVEINIFILENAME;

  iniFile := nil;
  iniFile := TInifile.create(LFileName);
  try
    with iniFile, FSaveConfigF do
    begin
      MapFilenameEdit.FileName := ReadString(DATASAVE_SECTION, 'Modbus Map File Name1', '');
      ParaFilenameEdit.FileName := ReadString(DATASAVE_SECTION, 'Parameter File Name', '');
      BlockNoEdit.Text := ReadString(DATASAVE_SECTION, 'Block No', '1');
      IntervalSE.Value := ReadInteger(DATASAVE_SECTION, 'Save Interval', 1000);

      ServerEdit.Text := ReadString(DATASAVE_SECTION, 'DB Server', '10.100.23.114:1521:TBACS');
      UserEdit.Text := ReadString(DATASAVE_SECTION, 'User ID', 'TBACS');
      PasswdEdit.Text := ReadString(DATASAVE_SECTION, 'Passwd', 'TBACS');
      TableNameCombo.Text := ReadString(DATASAVE_SECTION, 'Table Name', 'BF1562_18H3240V_ANALOG_DATA');
      ReConnectIntervalEdit.Value := ReadInteger(DATASAVE_SECTION, 'Reconnect Interval', 10000);

      EngParamEncryptCB.Checked := ReadBool(DATASAVE_SECTION, 'Parameter Encrypt', False);
      ConfFileFormatRG.ItemIndex := ReadInteger(DATASAVE_SECTION, 'Param File Format', 0);
      AppendStrEdit.Text := ReadString(DATASAVE_SECTION, 'Append String To CSV FileName', '');

      SaveOnlyCB.Checked := ReadBool(DATASAVE_SECTION, 'Save Only', False);
      SaveRunHourCB.Checked := ReadBool(DATASAVE_SECTION, 'Save Run Hour', False);
      ParamIndexEdit.Text := ReadString(DATASAVE_SECTION, 'Parameter Index', '');
      RunHourIndexEdit.Text := ReadString(DATASAVE_SECTION, 'Run Hour Index', '');
      RHIntervalSE.Value := ReadInteger(DATASAVE_SECTION, 'Run Hour Save Interval', 60000);

      FNameType_RG.ItemIndex := Readinteger(DATASAVE_SECTION, 'SaveFileName Change Type', 0);

      //parameter file에서 Item을 읽은 후 존재하는 Item Check Box만 Enable 함
      LStrList := TStringList.Create;
      try
        ParameterSource2Strings(LStrList);
        ParamSourceCLB.Items.AddStrings(LStrList);

        for i := 0 to ParamSourceCLB.Items.Count - 1 do
        begin
          if FParameterOriginalList.IndexOf(ParamSourceCLB.Items.Strings[i]) = -1 then
            ParamSourceCLB.ItemEnabled[i] := False;

          if ParamSourceCLB.ItemEnabled[i] then
            ParamSourceCLB.Checked[i] := ReadBool(PARAM_SECTION, ParamSourceCLB.Items.Strings[i], False);
        end;
      finally
        LStrList.Free;
      end;
    end;//with
  finally
    iniFile.Free;
    iniFile := nil;
  end;//try
end;

procedure TFrmDataSaveAll.LoadConfigDataini2Var(AFileName: string='');
var
  iniFile: TIniFile;
  LStr, LFileName: string;
  i,j: integer;
  LBool: Boolean;
  LStrList: TStringList;
begin
  SetCurrentDir(FFilePath);

  if AFileName = '' then
    LFileName := SAVEINIFILENAME
  else
    LFileName := AFileName;

  iniFile := nil;
  iniFile := TInifile.create(LFileName);
  try
    with iniFile do
    begin
      //FPowerMeterSMM := ReadString(DATASAVE_SECTION, 'Power Meter Shared Memory Name', '192.168.0.48');
      //FECSSMM := ReadString(DATASAVE_SECTION, 'ECS Shared Memory Name', '');
      //FDynamoSMM := ReadString(DATASAVE_SECTION, 'Dynamo Shared Memory Name', '');

      FMapFileName := ReadString(DATASAVE_SECTION, 'Modbus Map File Name1', '');
      LStr := ReadString(DATASAVE_SECTION, 'Parameter File Name', '');
      FConfigModified := False;

      if (FParamFileName <> LStr) or (LStr = '') then
      begin
        FParamFileName := LStr;
        FConfigModified := True;
      end;

      FLastBlockNo := ReadInteger(DATASAVE_SECTION, 'Block No', 1);
      FSaveInterval := ReadInteger(DATASAVE_SECTION, 'Save Interval', 1000);
      FEngParamEncrypt := ReadBool(DATASAVE_SECTION, 'Parameter Encrypt', false);
      FEngParamFileFormat := ReadInteger(DATASAVE_SECTION, 'Param File Format', 0);
      FReConnectInterval := ReadInteger(DATASAVE_SECTION, 'Reconnect Interval', 10000);

      FAppendStr := ReadString(DATASAVE_SECTION, 'Append String To CSV FileName', '');

      FHostName := ReadString(DATASAVE_SECTION, 'DB Server', '10.100.23.114:1521:TBACS');
      FLoginID := ReadString(DATASAVE_SECTION, 'User ID', 'TBACS');
      FPasswd := ReadString(DATASAVE_SECTION, 'Passwd', 'TBACS');
      FSaveTableName := ReadString(DATASAVE_SECTION, 'Table Name', '');

      FIsSaveOnly := ReadBool(DATASAVE_SECTION, 'Save Only', False);
      FIsSaveRunHour := ReadBool(DATASAVE_SECTION, 'Save Run Hour', False);
      FParamIndex := ReadInteger(DATASAVE_SECTION, 'Parameter Index', -1);
      FParamRunHourIndex := ReadInteger(DATASAVE_SECTION, 'Run Hour Index', -1);
      FRunHourSaveInterval := ReadInteger(DATASAVE_SECTION, 'Run Hour Save Interval', 60000);

      i := ReadInteger(DATASAVE_SECTION, 'SaveFileName Change Type', 0);
      FAutoChangeSaveFileName := (i = 0);

      AdjustConfigData(FConfigModified);

      //Parameter File 내 ParameterSource를 모두 가져옴
      TFrameIPCMonitorAll1.GetParameterSourceList(FParameterSourceList);

      LStrList := TStringList.Create;
      try
        ReadSectionValues(PARAM_SECTION, LStrList);
        //Ini File에서 True 인 Parameter Source만 FParameterSourceList에 남겨두고 나머지 제거
        for i := 0 to LStrList.Count - 1 do
        begin
          if not StrToBool(LStrList.ValueFromIndex[i]) then
          begin
            j := FParameterSourceList.IndexOf(LStrList.Names[i]);
            if j <> -1 then
              FParameterSourceList.Delete(j);
          end;
        end;
      finally
        LStrList.Free;
      end;

    end;//with
  finally
    iniFile.Free;
    iniFile := nil;
  end;//try
end;

procedure TFrmDataSaveAll.LoadRunHourFromini;
var
  iniFile: TIniFile;
  LStr: string;
begin
  SetCurrentDir(FFilePath);
  LStr := ExtractFilename(FParamFileName);
  LStr := ChangeFileExt(LStr, '');
  iniFile := TInifile.create('.\'+LStr+'_'+SAVERUNHOURINIFILENAME);
  try
    with iniFile do
    begin
      FRunHourValue := Readinteger('Run Hour', 'Value', 0);
      RunHourPanel.Caption := FORMAT_TIME(FRunHourValue);
    end;//with
  finally
    iniFile.Free;
    iniFile := nil;
  end;//try
end;

procedure TFrmDataSaveAll.MakeCSVHeader(AParamFileNameChanged: Boolean);
var
  i: integer;
  LStr, LName: string;
begin
  LStr := formatDateTime('yyyy-mm-dd hh:nn:ss:zzz',now);

  if AParamFileNameChanged then
  begin
    FParameterSourceList.Clear;
    FParameterOriginalList.Clear;

    for i := 0 to TFrameIPCMonitorAll1.FEngineParameter.EngineParameterCollect.Count - 1 do
    begin
      if UpperCase(TFrameIPCMonitorAll1.FEngineParameter.EngineParameterCollect.Items[i].TagName) = 'DUMMY' then
        continue;

      if TFrameIPCMonitorAll1.FEngineParameter.EngineParameterCollect.Items[i].ParameterSource = psManualInput then
        continue;

      LStr := LStr + ',' + replaceString(TFrameIPCMonitorAll1.FEngineParameter.EngineParameterCollect.Items[i].Description, ',', '', False);

      LName := ParameterSource2String(TFrameIPCMonitorAll1.FEngineParameter.EngineParameterCollect.Items[i].ParameterSource);

      if FParameterOriginalList.IndexOf(LName) = -1 then
        FParameterOriginalList.AddObject(LName,TFrameIPCMonitorAll1.FEngineParameter.EngineParameterCollect.Items[i]);
    end;

    if TFrameIPCMonitorAll1.FEngineParameter.EngineParameterCollect.Count > 0 then
    begin
      i := 0;
      LName := '';

      if TFrameIPCMonitorAll1.FEngineParameter.EngineParameterCollect.Items[i].ParameterSource = psFlowMeterKral then
      begin
        while (i < TFrameIPCMonitorAll1.FEngineParameter.EngineParameterCollect.Count - 1) do
        begin
          LName := LName + ',' + replaceString(TFrameIPCMonitorAll1.FEngineParameter.EngineParameterCollect.Items[i].Description, ',', '', False);//TFrameIPCMonitorAll1.FEngineParameter.EngineParameterCollect.Items[i].Description;
          i := i + 2;
        end;//while

        LStr := LName;
      end;
    end;

  end
  else
  begin
    if TFrameIPCMonitorAll1.FEngineParameter.EngineParameterCollect.Count > 0 then
    begin
      i := 0;
      LName := '';

      if TFrameIPCMonitorAll1.FEngineParameter.EngineParameterCollect.Items[i].ParameterSource = psFlowMeterKral then
      begin
        while (i < TFrameIPCMonitorAll1.FEngineParameter.EngineParameterCollect.Count - 1) do
        begin
          LName := LName + ',' + replaceString(TFrameIPCMonitorAll1.FEngineParameter.EngineParameterCollect.Items[i].Description, ',', '', False);//TFrameIPCMonitorAll1.FEngineParameter.EngineParameterCollect.Items[i].Description;
          i := i + 2;
        end;//while

        LStr := LName;
      end;
    end
    else
    begin
      for i := 0 to TFrameIPCMonitorAll1.FEngineParameter.EngineParameterCollect.Count - 1 do
      begin
        LName := ParameterSource2String(TFrameIPCMonitorAll1.FEngineParameter.EngineParameterCollect.Items[i].ParameterSource);

        if FParameterSourceList.IndexOf(LName) > -1 then
        begin
          LStr := LStr + ',' + replaceString(TFrameIPCMonitorAll1.FEngineParameter.EngineParameterCollect.Items[i].Description, ',', '', False);//TFrameIPCMonitorAll1.FEngineParameter.EngineParameterCollect.Items[i].Description;
        end;
      end;
    end;
  end;

  FTagNameBuf := LStr;
end;

procedure TFrmDataSaveAll.OnConnect(Sender: TIPCThread_HiMECS_MDI;
  Connecting: Boolean);
begin
  PostMessage(Handle, WM_UPDATESTATUS_HiMECS_MDI, WPARAM(Connecting), 0);
end;

procedure TFrmDataSaveAll.OnDataSave(Sender: TObject; Handle: Integer;
  Interval: Cardinal; ElapsedTime: Integer);
var
  i,j: integer;
  LStr, LValue, LName: string;
  Le: Double;
  LEPItem: TEngineParameterItem;
begin
  if TFrameIPCMonitorAll1.FCommDisconnected then
    exit;

  if FIsSaveRunHour then
  begin
    with TFrameIPCMonitorAll1.FEngineParameter.EngineParameterCollect do
    begin
      if (FParamRunHourIndex >= 0) and
        (FParamRunHourIndex < Count) then
      begin
        if StrToIntDef(Items[FParamRunHourIndex].Value, -1) > 0 then
        begin
          if FRunHourCalcTimerHandle = -1 then
          begin
            FRunHourCalcTimerHandle := FPJHTimerPool.Add(OnRunHourCalc, 1000);
            FRunHourSaveTimerHandle := FPJHTimerPool.Add(OnRunHourSave, FRunHourSaveInterval);

            if FRunHourValueFromini = -1 then
              LoadRunHourFromini;
            FRunHourValueFromini := FRunHourValue;
          end;
        end
        else
        begin
          if FRunHourCalcTimerHandle <> -1 then
          begin
            FPJHTimerPool.Remove(FRunHourCalcTimerHandle);
            FRunHourCalcTimerHandle := -1;
            FPJHTimerPool.Remove(FRunHourSaveTimerHandle);
            FRunHourSaveTimerHandle := -1;
            SaveRunHour2ini;
          end;
        end;
      end;
    end;//with
  end;

  if FIsSaveOnly then
  begin
    with TFrameIPCMonitorAll1.FEngineParameter.EngineParameterCollect do
    begin
      if (FParamIndex >= 0) and
        (FParamIndex < Count) then
      begin
        if StrToIntDef(Items[FParamIndex].Value, 0) = 0 then
        begin
          if FDataSaveStopping then
            FPJHTimerPool.AddOneShot(OnDataSaveOnce, 100);
          exit;
        end;
      end;
    end;
  end;

  FDataSaveStopping := True;

  if FAutoChangeSaveFileName then
  begin
    LStr := FormatDatetime('yyyymmdd',date)+'.'+'CSV';

    if FSaveFileName <> LStr then
      if (CB_CSVlogging.Checked) and (FFileName_Convention = FC_YMD) then
        FSaveFileName := LStr;
  end;

  Proc_DataSave(False); //DataList에 100건 채워져야 저장함. = False
end;

procedure TFrmDataSaveAll.OnDataSaveOnce(Sender: TObject; Handle: Integer;
  Interval: Cardinal; ElapsedTime: Integer);
begin
  FDataSaveStopping := False;
  Proc_DataSave(True); //DataList에 100건 이하여도 저장함. = True
end;

procedure TFrmDataSaveAll.OnRunHourCalc(Sender: TObject; Handle: Integer;
  Interval: Cardinal; ElapsedTime: Integer);
begin
  FRunHourValue := FRunHourValueFromini + FPJHTimerPool.ElapsedTimeSec[FRunHourCalcTimerHandle];
  RunHourPanel.Caption := FORMAT_TIME(FRunHourValue);
end;

procedure TFrmDataSaveAll.OnRunHourSave(Sender: TObject; Handle: Integer;
  Interval: Cardinal; ElapsedTime: Integer);
begin
  SaveRunHour2ini;
end;

procedure TFrmDataSaveAll.OnSignal(Sender: TIPCThread_HiMECS_MDI;
  Data: TEventData_HiMECS_MDI);
begin
  Flags := Data.Flags;
end;

procedure TFrmDataSaveAll.OnReconnectWhenDBDisconnect(Sender: TObject;
  Handle: Integer; Interval: Cardinal; ElapsedTime: Integer);
begin
  StatusBar1.SimplePanel := true;
  StatusBar1.SimpleText := FormatDateTime('yyyy-mm-dd hh:mi:ss:zzz', now) + ' => ' + 'DB Try Reconnect';

  FDataSave2DBThread.DisConnectDB;
  FDataSave2DBThread.ConnectDB;

  if FDataSave2DBThread.FOraSession1.Connected then
  begin
    FPJHTimerPool.Remove(FDBReConnectTimerHandle);
    FDBReConnectTimerHandle := -1;
  end;
end;

procedure TFrmDataSaveAll.Option1Click(Sender: TObject);
var
  FSaveConfigF: TFrmDataSaveAllConfig;
begin
  FSaveConfigF := TFrmDataSaveAllConfig.Create(Application);
  FPJHTimerPool.Enabled[FDataSaveTimerHandle] := False;

  try
    with FSaveConfigF do
    begin
      LoadConfigDataini2Form(FSaveConfigF);

      if ShowModal = mrOK then
      begin
        SaveConfigDataForm2ini(FSaveConfigF);
        if FIsAutoRun then
        begin
          LoadConfigDataini2Var(FActionDataIni);
          SaveActionData2ini;
          IPCAll_Final;
          IPCAll_Init;
          ApplyActionData;
        end
        else
          LoadConfigDataini2Var;
        //AdjustConfigData(FConfigModified);
      end;
    end;
  finally
    FSaveConfigF.Free;
    FPJHTimerPool.Enabled[FDataSaveTimerHandle] := True;
  end;
end;

procedure TFrmDataSaveAll.Proc_DataSave(ADataStopping: Boolean);
var
  i,j: integer;
  LStr, LName: String;
begin
  i := 0;
  LStr := '';

  if TFrameIPCMonitorAll1.FCommDisconnected then
    exit;

  if TFrameIPCMonitorAll1.FEngineParameter.EngineParameterCollect.Items[i].ParameterSource = psFlowMeterKral then
  begin
    if TFrameIPCMonitorAll1.FEngineParameter.EngineParameterCollect.Count > 0 then
    begin
      while (i < TFrameIPCMonitorAll1.FEngineParameter.EngineParameterCollect.Count - 1) do
      begin
        j := StrToIntDef(TFrameIPCMonitorAll1.FEngineParameter.EngineParameterCollect.Items[i].Value,0);
        j := (j shl 16) or StrToIntDef(TFrameIPCMonitorAll1.FEngineParameter.EngineParameterCollect.Items[i+1].Value,0);
        LStr := LStr + ',' + FloatToStr(j/10);
        i := i + 2;
      end;
    end;
  end
  else
  begin
    for i := 0 to TFrameIPCMonitorAll1.FEngineParameter.EngineParameterCollect.Count - 1 do
    begin
      if UpperCase(TFrameIPCMonitorAll1.FEngineParameter.EngineParameterCollect.Items[i].TagName) = 'DUMMY' then
        continue;

      LName := ParameterSource2String(TFrameIPCMonitorAll1.FEngineParameter.EngineParameterCollect.Items[i].ParameterSource);

      if FParameterSourceList.IndexOf(LName) > -1 then
        LStr := LStr + ',' + TFrameIPCMonitorAll1.FEngineParameter.EngineParameterCollect.Items[i].Value;

      //binary data일 경우 -> 0이면 False, 0이 아니면 False로 함
      {if not TFrameIPCMonitorAll1.FEngineParameter.EngineParameterCollect.Items[i].Alarm then
      begin
        if StrToIntDef(TFrameIPCMonitorAll1.FEngineParameter.EngineParameterCollect.Items[i].Value,0) = 0 then
          LValue := 'False'
        else
          LValue := 'True';
      end
      else
        LValue := TFrameIPCMonitorAll1.FEngineParameter.EngineParameterCollect.Items[i].Value;
      }
    end;//for
  end;


  if LStr[Length(LStr)] = ',' then
    System.Delete(LStr,Length(LStr),1);

  FSaveDataBuf := LStr;

  if CB_DBlogging.Checked then
    SaveData2DB;

  if FBulkDataMode then
  begin
    LStr := formatDateTime('yyyy-mm-dd hh:nn:ss:zzz',now) + LStr;
    FDataSave2FileThread.FDataList.Add(LStr);
    if FDataSave2FileThread.FDataList.Count < 100 then
    begin
      if ADataStopping then
        if CB_CSVlogging.Checked then
          SaveData2File;
      exit
    end
    else
      FToggleBackground := not FToggleBackground;
  end
  else
  begin
    FToggleBackground := not FToggleBackground;
  end;

  if CB_CSVlogging.Checked then
    SaveData2File;
end;

procedure TFrmDataSaveAll.RB_bydateClick(Sender: TObject);
begin
  FFileName_Convention := FC_YMD;
  ED_CSV.Text := FormatDatetime('yyyymmdd',date)+'.'+'CSV';
  ED_csv.enabled := False;
end;

procedure TFrmDataSaveAll.RB_byfilenameClick(Sender: TObject);
begin
  FFileName_Convention := FC_FIXED;
  ED_csv.enabled := True;
end;

procedure TFrmDataSaveAll.SaveActionData2ini;
var
  iniFile: TIniFile;
  LFileName: string;
  i: integer;
  LStrList: TStringList;
begin
  SetCurrentDir(FFilePath);

  SaveDialog1.InitialDir := FFilePath;

  if SaveDialog1.Execute then
  begin
    LFileName := ExtractRelativePath(FFilePath, SaveDialog1.FileName);

    if FileExists(LFileName) then
    begin
      if MessageDlg('File is already exist. Are you overwrite? if No press, then save is cancelled.',
                                mtConfirmation, [mbYes, mbNo], 0)= mrNo then
        exit
      else
      begin
        //AssignFile(F, LFileName);
        //Rewrite(F);
        //CloseFile(F);
      end;
    end;
  end;

  FActionDataIni := LFileName;

  if FActionDataIni = '' then
    FActionDataIni := ExtractFileName(Application.ExeName)+'ActionData.ini';

  iniFile := nil;
  iniFile := TInifile.create(FActionDataIni);
  try
    with iniFile do
    begin
      WriteBool(ACTIONSAVE_SECTION, 'DB Logging', CB_DBLogging.Checked);
      WriteBool(ACTIONSAVE_SECTION, 'CSV Logging', CB_CSVLogging.Checked);
      WriteBool(ACTIONSAVE_SECTION, 'By Date', RB_Bydate.Checked);
      WriteBool(ACTIONSAVE_SECTION, 'By File Name', RB_ByFileName.Checked);
      WriteString(ACTIONSAVE_SECTION, 'CSV File Name', ED_csv.Text);
      WriteBool(ACTIONSAVE_SECTION, 'By Event', RB_ByEvent.Checked);
      WriteBool(ACTIONSAVE_SECTION, 'By Interval', RB_ByInterval.Checked);
      WriteString(ACTIONSAVE_SECTION, 'Interval', ED_interval.Text);

      //WriteString(DATASAVE_SECTION, 'Power Meter Shared Memory Name', FPowerMeterSMM);
      //WriteString(DATASAVE_SECTION, 'ECS Shared Memory Name',FECSSMM);
      //WriteString(DATASAVE_SECTION, 'Dynamo Shared Memory Name', FDynamoSMM);
      WriteString(DATASAVE_SECTION, 'Modbus Map File Name1', FMapFileName);
      WriteString(DATASAVE_SECTION, 'Parameter File Name', FParamFileName);
      WriteInteger(DATASAVE_SECTION, 'Block No', FLastBlockNo);
      WriteInteger(DATASAVE_SECTION, 'Save Interval', FSaveInterval);
      WriteBool(DATASAVE_SECTION, 'Parameter Encrypt', FEngParamEncrypt);
      WriteInteger(DATASAVE_SECTION, 'Param File Format', FEngParamFileFormat);

      WriteString(DATASAVE_SECTION, 'DB Server', FHostName);
      WriteString(DATASAVE_SECTION, 'User ID', FLoginID);
      WriteString(DATASAVE_SECTION, 'Passwd', FPasswd);
      WriteString(DATASAVE_SECTION, 'Table Name', FSaveTableName);
      WriteInteger(DATASAVE_SECTION, 'Reconnect Interval', FReConnectInterval);

      WriteBool(DATASAVE_SECTION, 'Save Only', FIsSaveOnly);
      WriteBool(DATASAVE_SECTION, 'Save Run Hour', FIsSaveRunHour);
      WriteInteger(DATASAVE_SECTION, 'Parameter Index', FParamIndex);
      WriteInteger(DATASAVE_SECTION, 'Run Hour Index', FParamRunHourIndex);
      WriteInteger(DATASAVE_SECTION, 'Run Hour Save Interval', FRunHourSaveInterval);

      LStrList := TStringList.Create;
      try
        ParameterSource2Strings(LStrList);

        for i := 0 to LStrList.Count - 1 do
        begin
          if FParameterSourceList.IndexOf(LStrList.Strings[i]) = -1 then
            WriteBool(PARAM_SECTION, LStrList.Strings[i], False)
          else
            WriteBool(PARAM_SECTION, LStrList.Strings[i], True);
        end;
      finally
        LStrList.Free;
      end;

      if FAutoChangeSaveFileName then
        i := 0
      else
        i := 1;

      WriteInteger(DATASAVE_SECTION, 'SaveFileName Change Type', i);
    end;//with

    DisplayMessage(#13#10+'Action Data Saved'+#13#10, dtSendMemo);
  finally
    iniFile.Free;
    iniFile := nil;
  end;//try
end;

procedure TFrmDataSaveAll.SaveConfigDataForm2ini(
  FSaveConfigF: TFrmDataSaveAllConfig);
var
  iniFile: TIniFile;
  LStr,LFileName: string;
  LBool: Boolean;
  i: integer;
begin
  SetCurrentDir(FFilePath);
  DisplayMessage(#13#10+'System configuration changed'+#13#10+'Please restart program...' , dtSendMemo);

  if FIsAutoRun then
    LFileName := FActionDataIni
  else
    LFileName := SAVEINIFILENAME;

  iniFile := nil;
  iniFile := TInifile.create(LFileName);
  try
    with iniFile, FSaveConfigF do
    begin
      //WriteString(DATASAVE_SECTION, 'Power Meter Shared Memory Name', Ed_PowerMeterMM.Text);
      //WriteString(DATASAVE_SECTION, 'ECS Shared Memory Name', Ed_sharedmemory.Text);
      //WriteString(DATASAVE_SECTION, 'Dynamo Shared Memory Name', Ed_DynamoMM.Text);

      WriteString(DATASAVE_SECTION, 'Modbus Map File Name1', ExtractRelativePath(FFilepath, MapFilenameEdit.FileName));
      WriteString(DATASAVE_SECTION, 'Parameter File Name', ExtractRelativePath(FFilepath, ParaFilenameEdit.FileName));
      WriteString(DATASAVE_SECTION, 'Block No', BlockNoEdit.Text);
      WriteInteger(DATASAVE_SECTION, 'Save Interval', IntervalSE.Value);

      WriteString(DATASAVE_SECTION, 'DB Server', ServerEdit.Text);
      WriteString(DATASAVE_SECTION, 'User ID', UserEdit.Text);
      WriteString(DATASAVE_SECTION, 'Passwd', PasswdEdit.Text);
      WriteString(DATASAVE_SECTION, 'Table Name', TableNameCombo.Text);
      WriteInteger(DATASAVE_SECTION, 'Reconnect Interval', ReConnectIntervalEdit.Value);

      WriteBool(DATASAVE_SECTION, 'Parameter Encrypt', EngParamEncryptCB.Checked);
      WriteInteger(DATASAVE_SECTION, 'Param File Format', ConfFileFormatRG.ItemIndex);
      WriteString(DATASAVE_SECTION, 'Append String To CSV FileName', AppendStrEdit.Text);

      WriteBool(DATASAVE_SECTION, 'Save Only', SaveOnlyCB.Checked);
      WriteBool(DATASAVE_SECTION, 'Save Run Hour', SaveRunHourCB.Checked);

      WriteString(DATASAVE_SECTION, 'Parameter Index', ParamIndexEdit.Text);
      WriteString(DATASAVE_SECTION, 'Run Hour Index', RunHourIndexEdit.Text);
      WriteInteger(DATASAVE_SECTION, 'Run Hour Save Interval', RHIntervalSE.Value);
      Writeinteger(DATASAVE_SECTION, 'SaveFileName Change Type', FNameType_RG.ItemIndex);

      for i := 0 to ParamSourceCLB.Items.Count - 1 do
      begin
        WriteBool(PARAM_SECTION, ParamSourceCLB.Items.Strings[i], ParamSourceCLB.Checked[i]);
      end;
    end;//with
  finally
    iniFile.Free;
    iniFile := nil;
  end;//try
end;

{
procedure TFrmDataSaveAll.SaveConfigDataParam2ini;
var
  iniFile: TIniFile;
  LStr: string;
  LBool: Boolean;
begin
  SetCurrentDir(FFilePath);
  iniFile := nil;
  iniFile := TInifile.create(SAVEINIFILENAME);
  try
    with iniFile do
    begin
      LStr := ParameterSource2String(psECS_AVAT);
      LBool := FParameterSourceList.IndexOf(LStr) <> -1;
      WriteBool(DATASAVE_SECTION, LStr, LBool);

      LStr := ParameterSource2String(psECS_kumo);
      LBool := FParameterSourceList.IndexOf(LStr) <> -1;
      WriteBool(DATASAVE_SECTION, LStr, LBool);

      LStr := ParameterSource2String(psWT1600); //Power meter
      LBool := FParameterSourceList.IndexOf(LStr) <> -1;
      WriteBool(DATASAVE_SECTION, LStr, LBool);

      LStr := ParameterSource2String(psMT210); //Air Flow Meter
      LBool := FParameterSourceList.IndexOf(LStr) <> -1;
      WriteBool(DATASAVE_SECTION, LStr, LBool);

      LStr := ParameterSource2String(psMEXA7000); //'Gas Analyzer'
      LBool := FParameterSourceList.IndexOf(LStr) <> -1;
      WriteBool(DATASAVE_SECTION, LStr, LBool);

      LStr := ParameterSource2String(psDynamo); //Dyname Meter
      LBool := FParameterSourceList.IndexOf(LStr) <> -1;
      WriteBool(DATASAVE_SECTION, LStr, LBool);

      LStr := ParameterSource2String(psGasCalculated); //Gas Calculation
      LBool := FParameterSourceList.IndexOf(LStr) <> -1;
      WriteBool(DATASAVE_SECTION, LStr, LBool);

      LStr := ParameterSource2String(psPLC_S7); //S7 PLC
      LBool := FParameterSourceList.IndexOf(LStr) <> -1;
      WriteBool(DATASAVE_SECTION, LStr, LBool);

      LStr := ParameterSource2String(psECS_Woodward); //'Atlas II'
      LBool := FParameterSourceList.IndexOf(LStr) <> -1;
      WriteBool(DATASAVE_SECTION, LStr, LBool);
    end;//with
  finally
    iniFile.Free;
    iniFile := nil;
  end;//try
end;
}

procedure TFrmDataSaveAll.SaveData2DB;
begin
  //if FCurrentBlockNo < 5 then
  //  exit;

  if not FConnectedDB then
  begin
    FDataSave2DBThread.DisConnectDB;
    FConnectedDB := FDataSave2DBThread.ConnectDB;

    if not FConnectedDB then
    begin
      DisplayMessage(TimeToStr(Time)+' Database is disconnected', dtSendMemo);
      exit;
    end;
  end;

  with FDataSave2DBThread do
  begin
    FSaveDBDataBuf := FSaveDataBuf;
    //FStrData := FloatToStr(now) + FSaveDBDataBuf; //저장할 데이터(FSaveDataBuf)를 변수(FStrData)에 입력
    FStrData := formatDateTime('yyyymmddhhnnsszzz',now) + FSaveDBDataBuf; //저장할 데이터(FSaveDataBuf)를 변수(FStrData)에 입력

    if not FSaving then
      FDataSaveEvent.Signal;
  end;//with
end;

procedure TFrmDataSaveAll.SaveData2File;
begin
  with FDataSave2FileThread do
  begin
    FStrData := formatDateTime('yyyy-mm-dd hh:nn:ss:zzz',now) + FSaveDataBuf; //저장할 데이터(FSaveDataBuf)를 변수(FStrData)에 입력
    FTagData := FTagNameBuf;  //최초에 저장파일 생성 시 헤더(머릿말) 입력
    FName_Convention := FFileName_Convention; //파일명을 지정해주는 방법설정
    FFileName := FSaveFileName; //파일명 지정 (FName_Convention이 FC_Fixed에서만 사용)
    FAppendString2FileName := FAppendStr;

    if FAppendString2FileName = '' then
      FAppendString2FileName := 'csv'
    else
      FAppendString2FileName := FAppendString2FileName + '.csv';

    if not FSaving then
      DisplayMessage(TimeToStr(Time)+' => ' + FormatDatetime('yyyymmdd',date) + '.' + FAppendString2FileName + ' data saved.', dtSendMemo);
    FDataSaveEvent.Signal;
  end;//with

  FSaveDataBuf := '';
end;

procedure TFrmDataSaveAll.SaveRunHour2ini;
var
  iniFile: TIniFile;
  LStr: string;
begin
  if not FRunHourEnable then
    exit;

  SetCurrentDir(FFilePath);
  LStr := ExtractFilename(FParamFileName);
  LStr := ChangeFileExt(LStr, '');
  iniFile := TInifile.create('.\'+LStr+'_'+SAVERUNHOURINIFILENAME);
  try
    with iniFile do
    begin
      Writeinteger('Run Hour', 'Value', FRunHourValue);
    end;//with
  finally
    iniFile.Free;
    iniFile := nil;
  end;//try
end;

procedure TFrmDataSaveAll.Timer1Timer(Sender: TObject);
var
  LStr: string;
  i: integer;
begin
  Timer1.Enabled := False;
  LStr := '/a9H27DFDBSave.ini';
  //TFrameIPCMonitorAll1.FWatchValue2Screen_AnalogEvent := WatchValue2Screen_Analog;
  TFrameIPCMonitorAll1.InitVar;//FConfigOption을 먼저 생성 후
  TFrameIPCMonitorAll1.SetValue2ScreenEvent(WatchValue2Screen_Analog,nil);

  if ParamCount > 0 then
  begin
    LStr := ParamStr(1);
    i := Pos('/A', UpperCase(LStr)); //Automatic Start
    if i > 0 then  //A 제거
    begin
      //LStr := '.\'+ Copy(LStr, i+2, Length(LStr)-i-1);//환경저장 파일이름
      LoadActionDataFromini(FIniFileName);
      FIsAutoRun := True;
    end;
  end
  else
  begin
    LoadConfigDataini2Var; //SAVEINIFILENAME 할당함
  end;

  //AdjustConfigData;

  IPCAll_Init;

  ED_CSV.Text := FormatDatetime('yyyymmdd',date)+'.'+'CSV';
  FMonitorStart := True;

  //CreateSave2FileThread;
  LoadRunHourFromini;
  FRunHourEnable := IsRunHourEnable;

  if not FRunHourEnable then
  begin
    RunHourPanel.Font.Color := clYellow;
    Label2.Visible := False;
    RunHourPanel.Visible := False;
  end;

  if FIsAutoRun then
    ApplyActionData;

  if FActionDataIni <> '' then
    Self.Caption := FActionDataIni;
  ///======================================================================
  //LStr := Format('%s (%X)', [Application.Title, GetCurrentProcessID]);
  //Label4.Caption := IntToStr(GetCurrentProcessID);
  try
    IPCClient_HiMECS_MDI := TIPCClient_HiMECS_MDI.Create(GetCurrentProcessID, Self.Caption);
    //IPCClient_HiMECS_MDI := TIPCClient_HiMECS_MDI.Create(GetCurrentProcessID, LStr);
    //IPCClient_HiMECS_MDI.OnConnect := OnConnect;
    //IPCClient_HiMECS_MDI.OnSignal := OnSignal;
    IPCClient_HiMECS_MDI.Activate;

    if not (IPCClient_HiMECS_MDI.State = stConnected) then
      OnConnect(nil, False);
  except
    Application.HandleException(ExceptObject);
    Application.Terminate;
  end;
end;

procedure TFrmDataSaveAll.UpdateStatusBar(var Msg: TMessage);
const
  ConnectStr: Array[Boolean] of PChar = ('Not Connected', 'Connected');
begin
  StatusBar1.SimpleText := ConnectStr[Boolean(Msg.WParam)];
end;

procedure TFrmDataSaveAll.WatchValue2Screen_Analog(Name, AValue: string;
  AEPIndex: integer);
begin
;
end;

procedure TFrmDataSaveAll.WMDBDisconnected(var Msg: TMessage);
begin
  StatusBar1.SimplePanel := true;
  StatusBar1.SimpleText := FormatDateTime('yyyy-mm-dd hh:mi:ss:zzz', now) + ' => ' + 'DB Disconnected';

  if FDBReConnectTimerHandle = -1 then
    FDBReConnectTimerHandle := FPJHTimerPool.Add(OnReconnectWhenDBDisconnect,FReConnectInterval);
end;



end.
