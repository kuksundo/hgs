unit List_Unit;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ImgList, AdvGlowButton, iniFiles,
  NxColumnClasses, NxColumns, NxScrollControl, NxCustomGridControl,
  NxCustomGrid, NxGrid, NxCollection, AdvNavBar, Vcl.ExtCtrls, AdvSplitter,
  AdvSmoothPanel, AdvToolBar, AdvToolBarStylers, Vcl.StdCtrls, iComponent,
  iVCLComponent, iCustomComponent, iLed, iLedRectangle, JvExExtCtrls,
  JvExtComponent, JvPanel, JvExControls, JvNavigationPane, AdvSmoothProgressBar,
  AdvMenus, Vcl.Menus, AdvMenuStylers, iPipe, iPipeJoint, AdvSmoothPopup,
  iTimers, AdvSmartMessageBox, AdvAlertWindow, JvLabel, Vcl.Imaging.pngimage,
  Vcl.Imaging.jpeg, CurvyControls, TimerPool, System.DateUtils, Config_Unit,
  PPP_Const, UnitMongoDBManager, SynCommons;

type
  TList_Frm = class(TForm)
    ImageList1: TImageList;
    imagelist24x24: TImageList;
    ImageList16x16: TImageList;
    AdvNavBar1: TAdvNavBar;
    JvNavPanelHeader1: TJvNavPanelHeader;
    AdvNavBarPanel1: TAdvNavBarPanel;
    AdvGlowButton1: TAdvGlowButton;
    Bevel1: TBevel;
    AdvDockPanel1: TAdvDockPanel;
    AdvToolBarOfficeStyler1: TAdvToolBarOfficeStyler;
    AdvMenuOfficeStyler1: TAdvMenuOfficeStyler;
    AdvMainMenu1: TAdvMainMenu;
    Tasks1: TMenuItem;
    AddChild: TMenuItem;
    Window1: TMenuItem;
    N1: TMenuItem;
    AdvMenuStyler1: TAdvMenuStyler;
    AdvSmoothPopup1: TAdvSmoothPopup;
    iTimers1: TiTimers;
    AdvSmartMessageBox1: TAdvSmartMessageBox;
    AdvGlowButton3: TAdvGlowButton;
    AdvGlowButton7: TAdvGlowButton;
    AdvGlowButton8: TAdvGlowButton;
    Timer1: TTimer;
    Image1: TImage;
    LEDAlarmList1: TMenuItem;
    Panel1: TPanel;
    JvNavPanelHeader3: TJvNavPanelHeader;
    Label2: TLabel;
    Timer2: TTimer;
    CurvyPanel2: TCurvyPanel;
    AdvGlowButton2: TAdvGlowButton;
    LetterDilivery1: TMenuItem;
    Network1: TMenuItem;
    IP1: TMenuItem;
    PMSOPCClient1: TMenuItem;
    N2: TMenuItem;
    Report1: TMenuItem;
    N3: TMenuItem;
    procedure AdvNavBar1PanelActivate(Sender: TObject; OldActivePanel,
      NewActivePanel: Integer; var Allow: Boolean);
    procedure AdvGlowButton1Click(Sender: TObject);
    procedure AdvGlowButton3Click(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure AdvGlowButton7Click(Sender: TObject);
    procedure AdvGlowButton8Click(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure LEDAlarmList1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure AdvGlowButton2Click(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure LetterDilivery1Click(Sender: TObject);
    procedure IP1Click(Sender: TObject);
    procedure PMSOPCClient1Click(Sender: TObject);
    procedure N3Click(Sender: TObject);
    procedure JvNavPanelHeader1Click(Sender: TObject);
  private
    FHostName : string;
    FLoginID : string;
    FPasswd : string;
    FSaveTableName : string;
    FReConnect : integer;

    FMongoHostName : string;
    FMongoLoginID : string;
    FMongoPasswd : string;
    FMongoDBName : string;
    FMongoCollectionName : string;
    FMongoReConnect : integer;

    FEngParamEncrypt : Boolean;
    FConfFileFormat : integer;

    procedure OnGet6H17UInfo(Sender : TObject; Handle : Integer;
            Interval : Cardinal; ElapsedTime : LongInt);
    procedure OnGet18H25Info(Sender : TObject; Handle : Integer;
            Interval : Cardinal; ElapsedTime : LongInt);
    procedure OnGet18H32Info(Sender : TObject; Handle : Integer;
            Interval : Cardinal; ElapsedTime : LongInt);
    procedure OnGet20H32Info(Sender : TObject; Handle : Integer;
            Interval : Cardinal; ElapsedTime : LongInt);
    procedure OnResetSound_Running(Sender : TObject; Handle : Integer;
            Interval : Cardinal; ElapsedTime : LongInt);
    procedure OnResetSound_Stop(Sender : TObject; Handle : Integer;
            Interval : Cardinal; ElapsedTime : LongInt);
    { Private declarations }
//    FCurrentForm : TForm;

    procedure ChildFormClose(Sender: TObject; var Action: TCloseAction);
    procedure ShowSmartMessage();
    procedure SetLedLamp(ARed,AYellow,AGreen,ASound : Integer);
  public
    FCommonEngineRunning : Integer;//0= AllEngineStop, Others= SomeEngineRunning
    F6H17UEngineStatus : Integer;//0= EngineStop, 1=EngineRunning, 2=EngineShutdown
    F18H25EngineStatus : Integer;//0= EngineStop, 1=EngineRunning, 2=EngineShutdown
    F18H32EngineStatus : Integer;//0= EngineStop, 1=EngineRunning, 2=EngineShutdown
    F20H32EngineStatus : Integer;//0= EngineStop, 1=EngineRunning, 2=EngineShutdown
    FTimerPool : TPJHTimerPool;

    FMongoDBManager: TMongoDBManager;

    function ISCreateForm(aClass: TFormClass; aName ,aCaption : String): TForm;
    //ini 파일 설정과 저장을 위한 함수 선언부
    procedure LoadConfigDataini2Form(ASaveConfigF: TConfigF);
    procedure SaveConfigDataForm2ini(ASaveConfigF: TConfigF);
    procedure LoadConfigDataini2Var(AFileName: string='');

    procedure ShowReportForm(ADocs: TVariantDynArray);

  end;

var
  List_Frm: TList_Frm;

implementation

uses
  DataModule_Unit,
  EngineOVerView_Unit,
  EngineOVerView2_Unit,
  CommonUtil_Unit,
  Network_Unit,
  Dump_Unit,
  ListHome_Unit,
  Main_Unit,
  LEDAlarmlistLampGen_Unit,
  Pipe_Unit,
  Himsen_Communicator_Unit,
  NetWork_Sub_Ip_Unit,
  UnitClientMain,
  UnitGridView,
  UnitkwhReport;

procedure Usb_Qu_Open()  cdecl ; external 'Quvc_dll.dll';
procedure Usb_Qu_Close()  cdecl ; external 'Quvc_dll.dll';
function  Usb_Qu_Getstate(): integer cdecl ; external 'Quvc_dll.dll';
function Usb_Qu_write(Qu_index : byte;  Qu_type : byte; var pData): bool cdecl ; external 'Quvc_dll.dll';

{$R *.dfm}

procedure TList_Frm.AdvGlowButton1Click(Sender: TObject);
begin
  ISCreateForm(TMain_Frm,'Main_Frm','[내구성 시험장 설비 보기]');
  ShowSmartMessage();
end;

procedure TList_Frm.SaveConfigDataForm2ini(ASaveConfigF: TConfigF);
var
  iniFile: TIniFile;
  LStr,LFileName: string;
  LBool: Boolean;
  i: integer;
begin
//  SetCurrentDir(FFilePath);

//  LFileName := FIniFileName;

  iniFile := nil;
  iniFile := TInifile.create(LFileName);
  try
    with iniFile, ASaveConfigF do
    begin
      WriteInteger(DATASAVE_SECTION, 'DB Type', DB_Type_RG.ItemIndex);

      WriteString(ORACLE_SECTION, 'DB Server', ServerEdit.Text);
      WriteString(ORACLE_SECTION, 'User ID', UserEdit.Text);
      WriteString(ORACLE_SECTION, 'Passwd', PasswdEdit.Text);
      WriteString(ORACLE_SECTION, 'Table Name', TableNameCombo.Text);
      WriteInteger(ORACLE_SECTION, 'Reconnect Interval', ReConnectIntervalEdit.Value);

      WriteString(MONGODB_SECTION, 'DB Server Address', MongoServerEdit.Text);
      WriteString(MONGODB_SECTION, 'User ID', MongoUserEdit.Text);
      WriteString(MONGODB_SECTION, 'Passwd', MongoPasswdEdit.Text);
      WriteString(MONGODB_SECTION, 'DataBase Name', MongoDBNameCombo.Text);
      WriteString(MONGODB_SECTION, 'Collection Name', MongoCollNameCombo.Text);
      WriteInteger(MONGODB_SECTION, 'Reconnect Interval', MongoReConnectEdit.Value);

      WriteBool(DATASAVE_SECTION, 'Parameter Encrypt', EngParamEncryptCB.Checked);
      WriteInteger(DATASAVE_SECTION, 'Param File Format', ConfFileFormatRG.ItemIndex);
    end;//with
  finally
    iniFile.Free;
    iniFile := nil;
  end;//try
end;

procedure TList_Frm.SetLedLamp(ARed, AYellow, AGreen, ASound: Integer);
const
  C_index       =	0;
  C_type	      = 0;     {    Sound 5ea model  }
  { C_type      = 3;     {    Sound 25ea model group Select 0-4 }

  C_dont	      = 100;   {  // Don't care  // Do not change before state }
  C_off         = 0;
  C_on          = 1;
  C_onoff       = 2;
var
  iStat : integer;
  m_str : string;
  bret : bool;
  cData:array [0..6] of Byte;
  i: Integer;

begin
  iStat := Usb_Qu_Getstate;
  if iStat > 0 then
  begin
    cData[0] := ARed;          { lamp  1 }
    cData[1] := AYellow;       { lamp  2 }
    cData[2] := AGreen;        { lamp  3 }
    cData[3] := C_dont;
    cData[5] := ASound;       { Sound Select 0-5;   0-off }

    bret := Usb_Qu_write(C_index, C_type, cData[0]);
  end;
end;

procedure TList_Frm.ShowReportForm(ADocs: TVariantDynArray);
var
  Lkwh_reportF: Tkwh_reportF;
  LnxTextColumn: TnxTextColumn;
  LNxComboBoxColumn: TNxComboBoxColumn;
  i: integer;
  LDateTime: TDateTime;
  LStr: string;
begin
  Lkwh_reportF := Tkwh_reportF.Create(Self);
  try
    with Lkwh_reportF do
    begin
      ShowModal;
    end;
  finally
    FreeAndNil(Lkwh_reportF);
  end;
end;

procedure TList_Frm.ShowSmartMessage();
begin
  With AdvSmartMessageBox1.Messages.Add do
  begin
    Font.Size := 16;

    Text := '각 엔진을 누르면 해당하는 정보를 볼 수가 있습니다.';
    Show;
  end;
end;

procedure TList_Frm.Timer1Timer(Sender: TObject);
begin
  Label2.Caption := FormatDateTime('dd일 HH:mm:ss',Now);
end;

procedure TList_Frm.AdvGlowButton7Click(Sender: TObject);
begin
  ISCreateForm(TNetwork_Frm,'Network_Frm','[내구성 시험장 계통도]');

end;

procedure TList_Frm.AdvGlowButton8Click(Sender: TObject);
begin
  ISCreateForm(TEngineOverView_Frm,'EngineOverView_Frm','[엔진 계통도]');
end;

procedure TList_Frm.AdvGlowButton2Click(Sender: TObject);
begin
  ISCreateForm(TPipe_Frm,'PIPE_Frm','[PIPE LINE]');
end;

procedure TList_Frm.AdvGlowButton3Click(Sender: TObject);
begin
  ISCreateForm(TEngineOverView2_Frm,'EngineOverView2_Frm','[엔진 현황]');
end;

procedure TList_Frm.AdvNavBar1PanelActivate(Sender: TObject; OldActivePanel,
  NewActivePanel: Integer; var Allow: Boolean);
begin
  {if Assigned(FCurrentForm) then
    FreeAndNil(FCurrentForm);

  try
    case NewActivePanel of
      0 : FCurrentForm := Main_Frm.Create(Application);
      1 : FCurrentForm := Main_Frm.Create(Application);
      2 : FCurrentForm := Main_Frm.Create(Application);
    end;
  finally
    if Assigned(FCurrentForm) then
      FCurrentForm.Parent := mainPanel;

  end;}
end;

procedure TList_Frm.Button1Click(Sender: TObject);
begin
  ISCreateForm(TEngineOverView_Frm,'EngineOverView_Frm','[내구성 시험장 계통도]');
  ShowSmartMessage();
end;

procedure TList_Frm.IP1Click(Sender: TObject);
begin
  ISCreateForm(TNetWork_Sub_Ip_Frm,'NetWork_Sub_Ip_Frm','[IP검색]');
end;

function TList_Frm.ISCreateForm(aClass: TFormClass; aName,
  aCaption: String): TForm;
var
  aForm : TForm;
  i : Integer;
begin
  aForm := nil;
  try
    LockMDIChild(True);
    for i:=(List_Frm.MDIChildCount - 1) DownTo 0 Do
    begin
      if SameText(List_Frm.MDIChildren[I].Name,aName) then
      begin
        aForm := List_Frm.MDIChildren[I];
        Break;
      end;
    end;

    if aForm = nil Then
    begin
      aForm := aClass.Create(Application);
      with aForm do
      begin
        Caption := aCaption;
        OnClose := ChildFormClose;

      end;
      //AdvToolBar1.AddMDIChildMenu(aForm);
//      AdvOfficeMDITabSet1.AddTab(aForm);
    end;

    if aForm.WindowState = wsMinimized then
      aForm.WindowState := wsNormal;

    aForm.Show;
    Result := aForm;
  finally
    LockMDIChild(False);
  end;
end;

procedure TList_Frm.JvNavPanelHeader1Click(Sender: TObject);
var
  float : extended;
  LFormatRadix, LFormatSep: string;
  j,LRadix: integer;
begin
  // Set up our floating point number
  float := 11111234.567;
  LRadix := 0;

  if LRadix > 0 then
    LFormatRadix := '.';

  for j := 1 to LRadix do
    LFormatRadix := LFormatRadix + '#';

  if False then
    LFormatSep := '#,##0'
  else
    LFormatSep := '0';

  LFormatSep := LFormatSep + LFormatRadix;
//  ShowMessage(FormatFloat('#,##0.##', float));
  ShowMessage(FormatFloat(LFormatSep, float));
end;

procedure TList_Frm.LEDAlarmList1Click(Sender: TObject);
begin
  ISCreateForm(TLEDAlarmlistLampGen_Frm,'LEDAlarmlistLampGen_Frm','[알람리스트]');
end;

procedure TList_Frm.LetterDilivery1Click(Sender: TObject);
begin
  ISCreateForm(THimsen_Communicator_Frm,'Himsen_Communicator_Frm','[메신져]');
end;

procedure TList_Frm.LoadConfigDataini2Form(ASaveConfigF: TConfigF);
var
  iniFile: TIniFile;
  LStr, LFileName: string;
  i: integer;
  LStrList: TStringList;
begin
//  SetCurrentDir(FFilePath);

  LFileName := SAVEINIFILENAME;

  iniFile := nil;
  iniFile := TInifile.create(LFileName);
  try
    with iniFile, ASaveConfigF do
    begin
      ServerEdit.Text := ReadString(ORACLE_SECTION, 'DB Server', '10.100.23.114:1521:TBACS');
      UserEdit.Text := ReadString(ORACLE_SECTION, 'User ID', 'TBACS');
      PasswdEdit.Text := ReadString(ORACLE_SECTION, 'Passwd', 'TBACS');
      TableNameCombo.Text := ReadString(ORACLE_SECTION, 'Table Name', 'BF1562_18H3240V_ANALOG_DATA');
      ReConnectIntervalEdit.Value := ReadInteger(ORACLE_SECTION, 'Reconnect Interval', 10000);

      MongoServerEdit.Text := ReadString(MONGODB_SECTION, 'DB Server Address', '10.100.23.114');
      MongoUserEdit.Text := ReadString(MONGODB_SECTION, 'User ID', 'TBACS');
      MongoPasswdEdit.Text := ReadString(MONGODB_SECTION, 'Passwd', 'TBACS');
      MongoDBNameCombo.Text := ReadString(MONGODB_SECTION, 'DataBase Name', 'PMS_DB');
      MongoCollNameCombo.Text := ReadString(MONGODB_SECTION, 'Collection Name', 'PMS_COLL');
      MongoReConnectEdit.Value := ReadInteger(MONGODB_SECTION, 'Reconnect Interval', 10000);

      EngParamEncryptCB.Checked := ReadBool(DATASAVE_SECTION, 'Parameter Encrypt', False);
      ConfFileFormatRG.ItemIndex := ReadInteger(DATASAVE_SECTION, 'Param File Format', 0);
    end;
  finally
    FreeAndNil(iniFile);
  end;
end;

procedure TList_Frm.LoadConfigDataini2Var(AFileName: string);
var
  iniFile: TIniFile;
  LStr, LFileName: string;
  i,j: integer;
  LBool: Boolean;
  LStrList: TStringList;
begin
//  SetCurrentDir(FFilePath);

  LFileName := AFileName;

  iniFile := nil;
  iniFile := TInifile.create(LFileName);
  try
    with iniFile do
    begin
      FHostName := ReadString(ORACLE_SECTION, 'DB Server', '10.100.23.114:1521:TBACS');
      FLoginID := ReadString(ORACLE_SECTION, 'User ID', 'TBACS');
      FPasswd := ReadString(ORACLE_SECTION, 'Passwd', 'TBACS');
      FSaveTableName := ReadString(ORACLE_SECTION, 'Table Name', 'BF1562_18H3240V_ANALOG_DATA');
      FReConnect := ReadInteger(ORACLE_SECTION, 'Reconnect Interval', 10000);

      FMongoHostName := ReadString(MONGODB_SECTION, 'DB Server Address', '10.100.23.114');
      FMongoLoginID := ReadString(MONGODB_SECTION, 'User ID', 'TBACS');
      FMongoPasswd := ReadString(MONGODB_SECTION, 'Passwd', 'TBACS');
      FMongoDBName := ReadString(MONGODB_SECTION, 'DataBase Name', 'PMS_DB');
      FMongoCollectionName := ReadString(MONGODB_SECTION, 'Collection Name', 'PMS_COLL');
      FMongoReConnect := ReadInteger(MONGODB_SECTION, 'Reconnect Interval', 10000);

      FEngParamEncrypt := ReadBool(DATASAVE_SECTION, 'Parameter Encrypt', False);
      FConfFileFormat := ReadInteger(DATASAVE_SECTION, 'Param File Format', 0);

    end;//with
  finally
    iniFile.Free;
    iniFile := nil;
  end;//try
end;

procedure TList_Frm.N3Click(Sender: TObject);
var
  LFromtm, LToTm: TDateTime;
  LYear, LMonth, LDay: word;
  LHour, LMin, LSec, LMSec: word;
  LDocs: TVariantDynArray;
begin
  LFromtm := now-1;
  DecodeDateTime(LFromtm, LYear, LMonth, LDay, LHour, LMin, LSec, LMsec);
  LHour := 0;
  LMin := 0;
  LSec := 0;
  LMsec := 0;
  LFromTm := EncodeDateTime(LYear, LMonth, LDay, LHour, LMin, LSec, LMSec);
  LFromTm := TTimeZone.Local.ToUniversalTime(LFromTm);

  LTotm := now-1;
  DecodeDateTime(LTotm, LYear, LMonth, LDay, LHour, LMin, LSec, LMsec);
  LHour := 23;
  LMin := 59;
  LSec := 59;
  LTotm := EncodeDateTime(LYear, LMonth, LDay, LHour, LMin, LSec, LMSec);
  LTotm := TTimeZone.Local.ToUniversalTime(LTotm);

  SetLength(LDocs, 5);
  ShowReportForm(LDocs);
end;

procedure TList_Frm.OnGet18H25Info(Sender: TObject; Handle: Integer;
  Interval: Cardinal; ElapsedTime: Integer);
var
  iStat, i : integer;
begin
  with DM1.OraQuery1 do
  begin
    Close;
    SQL.Clear;
    //DATA27 = ENGINE RPM  DATA67 = COMMON SHUT DOWN
    SQL.Add('SELECT DATASAVEDTIME, DATA27, DATA92 FROM TBACS.YE0594_18H2533V_MEASURE_DATA ' +
            'WHERE DATASAVEDTIME like :param1 ');
    ParamByName('param1').AsString := FormatDateTime('YYYYMMDDHHMMSS%',IncSecond(Now,-1));
    Open;

    begin
      //최초발생
      if (FieldByName('DATA27').AsInteger > 0) AND (F18H25EngineStatus = 0) then
      begin
        SetLedLamp(0,0,2,4);
        FTimerPool.AddOneShot(OnResetSound_Running,3000);
        F18H25EngineStatus := 1;
        Inc(FCommonEngineRunning);
      end
      else
      // 엔진종료
      if (FieldByName('DATA27').AsInteger = 0) AND (F18H25EngineStatus = 0) then
      begin

      end
      else
      // 엔진정상종료
      if (FieldByName('DATA27').AsInteger = 0) AND (F18H25EngineStatus = 1) then
      begin
        F18H25EngineStatus := 0;
        if FCommonEngineRunning > 0 then
          Dec(FCommonEngineRunning);

        if FCommonEngineRunning > 0 then
        begin
          SetLedLamp(0,0,2,1);
          FTimerPool.AddOneShot(OnResetSound_Running,3000);
        end
        else
        begin
          SetLedLamp(0,0,0,1);
          FTimerPool.AddOneShot(OnResetSound_Stop,3000);
        end;
      end;
    end;
  end;
end;


procedure TList_Frm.OnGet18H32Info(Sender: TObject; Handle: Integer;
  Interval: Cardinal; ElapsedTime: Integer);
var
  iStat, i : integer;
begin
  with DM1.OraQuery1 do
  begin
    Close;
    SQL.Clear;
    //DATA88 = ENGINE RUNNING STATUS  DATA99 = COMMON SHUT DOWN
    SQL.Add('SELECT DATASAVEDTIME, DATA99, DATA88 FROM TBACS.BF1562_18H3240V_MEASURE_DATA ' +
            'WHERE DATASAVEDTIME like :param1 ');
    ParamByName('param1').AsString := FormatDateTime('YYYYMMDDHHMMSS%',IncSecond(Now,-1));
    Open;

    begin
      //최초발생
      if (FieldByName('DATA88').AsInteger > 0) AND (F18H32EngineStatus = 0) then
      begin
        SetLedLamp(0,0,2,4);
        FTimerPool.AddOneShot(OnResetSound_Running,3000);
        F18H32EngineStatus := 1;
        Inc(FCommonEngineRunning);
      end
      else
      // 엔진종료
      if (FieldByName('DATA88').AsInteger = 0) AND (F18H32EngineStatus = 0) then
      begin

      end
      else
      // 엔진정상종료
      if (FieldByName('DATA88').AsInteger = 0) AND (F18H32EngineStatus = 1) then
      begin
        F18H32EngineStatus := 0;
        if FCommonEngineRunning > 0 then
          Dec(FCommonEngineRunning);

        if FCommonEngineRunning > 0 then
        begin
          SetLedLamp(0,0,2,1);
          FTimerPool.AddOneShot(OnResetSound_Running,3000);
        end
        else
        begin
          SetLedLamp(0,0,0,1);
          FTimerPool.AddOneShot(OnResetSound_Stop,3000);
        end;
      end;
    end;
  end;
end;


procedure TList_Frm.OnGet20H32Info(Sender: TObject; Handle: Integer;
  Interval: Cardinal; ElapsedTime: Integer);
var
  iStat, i : integer;
begin
  with DM1.OraQuery1 do
  begin
    Close;
    SQL.Clear;
    //DATA88 = ENGINE RUNNING STATUS  DATA99 = COMMON SHUT DOWN
    SQL.Add('SELECT DATASAVEDTIME, DATA88, DATA99 FROM TBACS.BF1656_20H3240V_MEASURE_DATA ' +
            'WHERE DATASAVEDTIME like :param1 ');
    ParamByName('param1').AsString := FormatDateTime('YYYYMMDDHHMMSS%',IncSecond(Now,-1));
    Open;

    begin
      //최초발생
      if (FieldByName('DATA88').AsInteger > 0) AND (F20H32EngineStatus = 0) then
      begin
        SetLedLamp(0,0,2,4);
        FTimerPool.AddOneShot(OnResetSound_Running,3000);
        F20H32EngineStatus := 1;
        Inc(FCommonEngineRunning);
      end
      else
      // 엔진종료
      if (FieldByName('DATA88').AsInteger = 0) AND (F20H32EngineStatus = 0) then
      begin

      end
      else
      // 엔진정상종료
      if (FieldByName('DATA88').AsInteger = 0) AND (F20H32EngineStatus = 1) then
      begin
        F20H32EngineStatus := 0;
        if FCommonEngineRunning > 0 then
          Dec(FCommonEngineRunning);

        if FCommonEngineRunning > 0 then
        begin
          SetLedLamp(0,0,2,1);
          FTimerPool.AddOneShot(OnResetSound_Running,3000);
        end
        else
        begin
          SetLedLamp(0,0,0,1);
          FTimerPool.AddOneShot(OnResetSound_Stop,3000);
        end;
      end;
    end;
  end;
end;

procedure TList_Frm.OnGet6H17UInfo(Sender: TObject; Handle: Integer;
  Interval: Cardinal; ElapsedTime: Integer);
var
  iStat, i : integer;
begin
  with DM1.OraQuery1 do
  begin
    Close;
    SQL.Clear;
    //DATA73 = ENGINE RPM  DATA27 = COMMON SHUT DOWN
    SQL.Add('SELECT DATASAVEDTIME, DATA27, DATA48 FROM TBACS.YE0539_6H1728U_MEASURE_DATA ' +
            'WHERE DATASAVEDTIME like :param1 ');
    ParamByName('param1').AsString := FormatDateTime('YYYYMMDDHHMMSS%',IncSecond(Now,-1));
    Open;

    begin
      //최초발생
      if (FieldByName('DATA27').AsInteger > 100) AND (F6H17UEngineStatus = 0) then
      begin
        SetLedLamp(0,0,2,4);
        FTimerPool.AddOneShot(OnResetSound_Running,3000);
        F6H17UEngineStatus := 1;
        Inc(FCommonEngineRunning);
      end
      else
      // 엔진종료
      if (FieldByName('DATA27').AsInteger = 0) AND (F6H17UEngineStatus = 0) then
      begin
        SetLedLamp(0,0,0,0);
      end
      else
      // 엔진정상종료
      if (FieldByName('DATA27').AsInteger = 0) AND (F6H17UEngineStatus = 1) then
      begin
        F6H17UEngineStatus := 0;
        if FCommonEngineRunning > 0 then
          Dec(FCommonEngineRunning);

        if FCommonEngineRunning > 0 then
        begin
          SetLedLamp(0,0,2,2);
          FTimerPool.AddOneShot(OnResetSound_Running,3000);
        end
        else
        begin
          FTimerPool.AddOneShot(OnResetSound_Stop,3000);
        end;
      end;
    end;
  end;
end;

procedure TList_Frm.OnResetSound_Running(Sender: TObject; Handle: Integer;
  Interval: Cardinal; ElapsedTime: Integer);
begin
  SetLedLamp(0,0,2,0);
end;

procedure TList_Frm.OnResetSound_Stop(Sender: TObject; Handle: Integer;
  Interval: Cardinal; ElapsedTime: Integer);
begin
  SetLedLamp(0,0,0,0);
end;

procedure TList_Frm.PMSOPCClient1Click(Sender: TObject);
begin
  PMSOPCClientF.Show;
end;

procedure TList_Frm.ChildFormClose(Sender: TObject; var Action: TCloseAction);
begin
  //AdvToolBar1.RemoveMDIChildMenu(TForm(Sender));
  Action   := caFree;
end;

procedure TList_Frm.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Usb_Qu_Close();
  FTimerPool.Free;
  FMongoDBManager.Free;
  Action := caFree;
end;

procedure TList_Frm.FormCreate(Sender: TObject);
{var
  LForm : TLEDAlarmlistLampGen_Frm; }
begin
  FTimerPool := TPJHTimerPool.Create(Self);
  FMongoDBManager := TMongoDBManager.Create('10.14.21.117', 'PMS_DB', 'PMS_COLL', 27017);

//  FTimerPool.Add(OnGet6H17UInfo,1000);
//  FTimerPool.Add(OnGet18H25Info,1000);
//  FTimerPool.Add(OnGet18H32Info,1000);
//  FTimerPool.Add(OnGet20H32Info,1000);

//  LForm := TLEDAlarmlistLampGen_Frm.Create(Self);
// LForm.Visible := False;

end;

procedure TList_Frm.FormShow(Sender: TObject);
begin
//  ISCreateForm(TListHome_Frm,'ListHome_Frm','[내구성관관리시스템홈]');
end;

end.
