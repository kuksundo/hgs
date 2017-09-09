unit UnitEngParamClient;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ComCtrls, JvExComCtrls, JvStatusBar,
  Vcl.ExtCtrls, AdvOfficePager, Vcl.StdCtrls,
  NxColumnClasses, NxColumns, NxScrollControl, NxCustomGridControl,
  NxCustomGrid, NxGrid, SynCommons, mORMot, mORMotHttpClient,
  UnitEngParamInterface, EngineParameterClass, UnitIPCClientAll,
  UnitFrameWatchGrid, JvDialogs, Vcl.Menus, UnitFrameIPCMonitorAll, HiMECSConst,
  IPC_EngineParam_Const, SynEdit, SynMemo, UnitEPClientConfig, GpCommandLineParser,
  UnitRegistrationClass;

type
  TDisplayTarget = (dtSystemLog, dtConnectLog, dtCommLog, dtStatusBar);

  TCommandData = class
  strict private
    FAutoStart: boolean;
    FServerIP: string;
    FServerPort: string;
    FSharedMN: string;
  public
    [CLPLongName('SIP'), CLPDescription('Server IP Address', '<dt>')]
    property ServerIP: string read FServerIP write FServerIP;

    [CLPLongName('SPORT'), CLPDescription('Server Port No', '<dt>')]
    property ServerPort: string read FServerPort write FServerPort;

    [CLPLongName('Shared Name', 'SMN'), CLPDescription('Shared Memory Name')]
    property SharedMN: string read FSharedMN write FSharedMN;
  end;

  TForm3 = class(TForm)
    AdvOfficePager1: TAdvOfficePager;
    ItemsTabSheet: TAdvOfficePage;
    Panel1: TPanel;
    JvStatusBar1: TJvStatusBar;
    Label3: TLabel;
    ServerIPEdit: TEdit;
    Panel2: TPanel;
    Label1: TLabel;
    SearchEdit: TEdit;
    Button4: TButton;
    Button2: TButton;
    QuitButton: TButton;
    Button1: TButton;
    Label2: TLabel;
    ServerPortEdit: TEdit;
    FWG: TFrameWatchGrid;
    ItemsPopup: TPopupMenu;
    LoadParameterFromFile1: TMenuItem;
    N1: TMenuItem;
    DeleteItems1: TMenuItem;
    JvOpenDialog1: TJvOpenDialog;
    Timer1: TTimer;
    PageControl2: TPageControl;
    TabSheet4: TTabSheet;
    SMUDPSysLog: TSynMemo;
    TabSheet5: TTabSheet;
    SMUDPConnectLog: TSynMemo;
    TabSheet6: TTabSheet;
    SMCommLog: TSynMemo;
    Splitter1: TSplitter;
    AddToNewWindow1: TMenuItem;
    IPCMonitorAll1: TFrameIPCMonitor;
    N2: TMenuItem;
    Setup1: TMenuItem;
    Button3: TButton;
    SaveDialog1: TSaveDialog;
    RestoreRegFile1: TMenuItem;
    N3: TMenuItem;
    procedure Button2Click(Sender: TObject);
    procedure QuitButtonClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure LoadParameterFromFile1Click(Sender: TObject);
    procedure DeleteItems1Click(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure Button4Click(Sender: TObject);
    procedure AddToNewWindow1Click(Sender: TObject);
    procedure Setup1Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure RestoreRegFile1Click(Sender: TObject);
  private
    FItemsChanged: Boolean;
    FEngParamFilled: Boolean;

    FIPCClientAll: TIPCClientAll;
    FWatchHandles : TpjhArrayHandle;//Parameter 창 PopupMenu에서 Add to Multi-Watch 창을 띄운 경우의 Handle을 저장 함
    FRegInfo: TRegistrationInfo;

    procedure CreateHTTPClient(AServerIP: string);
    procedure ConnectToServer;
    procedure DisConnectServer;

    procedure DeleteEngineParamterFromGrid(AIndex: integer);
    procedure WatchValue2Screen_Analog(Name: string; AValue: string;
                                AEPIndex: integer);
    procedure WatchValue2Screen_Digital(Name: string; AValue: string;
                                AEPIndex: integer);
    procedure GetEngineParameterFromSavedWatchListFile(AAutoStart: Boolean;
              AFileName: string);
    procedure DisplayIPCClientList;
    procedure DisplayMessage(msg: string; ADspNo: TDisplayTarget);
    procedure CommandLineParse;
    procedure RestoreRegFile;
  protected
    FSettings : TConfigSettings;
  public
    FClient: TSQLRestClientURI;
//    Database: TSQLRest;
    FModel: TSQLModel;
    Server: AnsiString;
    PortNum: string;

    FServerConnected: Boolean;

    procedure GetEngParamCollect;
    procedure GetEngParamValues;

    procedure LoadConfigFromFile(AFileName: string = '');
    procedure LoadConfig2Form(AForm: TConfigF);
    procedure LoadConfigForm2Object(AForm: TConfigF);
    procedure SetConfig;
    procedure ApplyUI;
  end;

var
  Form3: TForm3;

implementation

uses CommonUtil, shellapi, UnitRegistration;

{$R *.dfm}

procedure TForm3.AddToNewWindow1Click(Sender: TObject);
var
  i: integer;
  LHandle: Integer;
  LRunOnce: Boolean;
begin
  LRunOnce := False;
  LHandle := -1;

  if FWG.NextGrid1.SelectedCount > 0 then
  begin
    SetCurrentDir(ExtractFilePath(Application.ExeName));

    for i := 0 to FWG.NextGrid1.RowCount - 1 do
    begin
      if FWG.NextGrid1.Row[i].Selected then
      begin
        IPCMonitorAll1.MoveEngineParameterItemRecord2(FWG.FEngineParameterItemRecord,i);
        FWG.FEngineParameterItemRecord.FParamDragCopyMode := dcmCopyOnlyNonExist;
        LHandle := FWG.SendEngParam2HandleWindow(FWatchHandles, '.\' + HiMECSWatchName2, LHandle);
      end;
    end;
  end;
end;

procedure TForm3.ApplyUI;
begin
  ServerIPEdit.Text := FSettings.ServerIP;
  ServerPortEdit.Text := FSettings.ServerPort;
end;

procedure TForm3.Button1Click(Sender: TObject);
begin
  if not FServerConnected then
    ConnectToServer;

  GetEngParamCollect;

  Timer1.Enabled := True;
end;

procedure TForm3.Button2Click(Sender: TObject);
begin
  if not FServerConnected then
    ConnectToServer;

  GetEngParamCollect;
end;

procedure TForm3.Button3Click(Sender: TObject);
begin
//  GetDosOutput('Ping.exe ' + FSettings.ServerIP);
  Pingit(FSettings.ServerIP, Handle);
end;

procedure TForm3.Button4Click(Sender: TObject);
begin
  if FWG.NextGrid1.SearchRow(SearchEdit.Text) then
    FWG.NextGrid1.SetFocus;
end;

procedure TForm3.CommandLineParse;
var
  cl    : TCommandData;
//  cp    : IGpCommandLineParser;
  parsed: boolean;
  i: integer;
  LCmd: string;
begin
  cl := TCommandData.Create;
//  cp := CreateCommandLineParser;
  try
    try
      i := Length(Application.ExeName);
      LCmd := Copy(CmdLine, i + 4, Length(CmdLine) - (i + 2));

      parsed := CommandLineParser.Parse(LCmd, cl);
    except
      on E: ECLPConfigurationError do begin
        DisplayMessage('*** Configuration error ***', dtSystemLog);
        DisplayMessage(Format('%s, position = %d, name = %s',
          [E.ErrorInfo.Text, E.ErrorInfo.Position, E.ErrorInfo.SwitchName]), dtSystemLog);
        Exit;
      end;
    end;

    if not parsed then begin
      DisplayMessage(Format('%s, position = %d, name = %s',
        [CommandLineParser.ErrorInfo.Text, CommandLineParser.ErrorInfo.Position,
         CommandLineParser.ErrorInfo.SwitchName]), dtSystemLog);
      DisplayMessage('', dtSystemLog);
//      lbLog.Items.AddStrings(CommandLineParser.Usage);
    end
    else
    begin
      if cl.SharedMN <> '' then
        FSettings.SharedName := cl.SharedMN;

      if cl.ServerIP <> '' then
        FSettings.ServerIP := cl.ServerIP;

      if cl.ServerPort <> '' then
        FSettings.ServerPort := cl.ServerPort;

      ServerIPEdit.Text := FSettings.ServerIP;
      ServerPortEdit.Text := FSettings.ServerPort;

      DisplayMessage('Shared Name: ' + FSettings.SharedName, dtSystemLog);
      DisplayMessage('Server IP: ' + FSettings.ServerIP, dtSystemLog);
      DisplayMessage('Server Port: ' + FSettings.ServerPort, dtSystemLog);
    end;
  finally
//    cp.Free;
    cl.Free;
  end;
end;

procedure TForm3.ConnectToServer;
var
  Lip: string;
begin
  if ServerIPEdit.Text <> '' then
    Lip := ServerIPEdit.Text
  else
    Lip := 'localhost';

  CreateHTTPClient(Lip);
end;

procedure TForm3.CreateHTTPClient(AServerIP: string);
begin
  if FClient = nil then
  begin
    if FModel=nil then
      FModel := TSQLModel.Create([],ROOT_NAME);

    FClient := TSQLHttpClient.Create(AServerIP, PORT_NAME, FModel);

    if not FClient.ServerTimeStampSynchronize then
    begin
      ShowMessage(UTF8ToString(FClient.LastErrorMessage));
      exit;
    end;

    //TSQLRestServerAuthenticationNone.ClientSetUser(Client,'User','');
    FClient.SetUser('User','synopse');
    FClient.ServiceRegister([TypeInfo(IEngParameter)],sicShared);
    FServerConnected := True;

    ServerIPEdit.Text := AServerIP;
    ServerPortEdit.Text := PORT_NAME;
  end;
end;

procedure TForm3.DeleteEngineParamterFromGrid(AIndex: integer);
begin
  FWG.FreeStrListFromGrid(AIndex);
  FWG.NextGrid1.DeleteRow(AIndex);
  FIPCClientAll.FEngineParameter.EngineParameterCollect.Delete(AIndex);
end;

procedure TForm3.DeleteItems1Click(Sender: TObject);
begin
  FWG.DeleteGridItem;
end;

procedure TForm3.DisConnectServer;
begin

end;

procedure TForm3.DisplayIPCClientList;
var
  i: integer;
begin
  for i := 0 to FIPCClientAll.FIPCClientList.Count - 1 do
    DisplayMessage(FIPCClientAll.FIPCClientList.Strings[i] + ' Created.', dtSystemLog);
end;

procedure TForm3.DisplayMessage(msg: string; ADspNo: TDisplayTarget);
var
//  LMemoHandle, LMemoCount: integer;
  LMemo: TSynMemo;
begin
  if msg = ' ' then
  begin
    exit;
  end;

  LMemo := nil;

  case ADspNo of
    dtSystemLog : begin
      with SMUDPSysLog do
      begin
        if Lines.Count > 100 then
          Clear;
        Lines.Add(msg);
      end;//with

      LMemo := SMUDPSysLog;
    end;//dtSystemLog
    dtConnectLog: begin
      with SMUDPConnectLog do
      begin
        if Lines.Count > 100 then
          Clear;
        Lines.Add(msg);
      end;//with

      LMemo := SMUDPConnectLog;
    end;//dtConnectLog
    dtCommLog: begin
      //SMCommLog.IsScrolling := true;
      with SMCommLog do
      begin
        if Lines.Count > 100 then
          Clear;
        Lines.Add(msg);
      end;//with

      LMemo := SMCommLog;
    end;//dtCommLog

    dtStatusBar: begin
       JvStatusBar1.SimplePanel := True;
       JvStatusBar1.SimpleText := msg;
    end;//dtStatusBar
  end;//case

  if Assigned(LMemo) then
  begin
    LMemo.SelStart := LMemo.GetTextLen;
    LMemo.SelLength := 0;
    LMemo.ScrollBy(0, LMemo.Lines.Count);
    LMemo.Refresh;
//    SendMessage(LMemoHandle, EM_SCROLLCARET, 0, 0);
//    SendMessage(LMemoHandle, EM_LINESCROLL, 0, LMemoCount);
  end;
end;

procedure TForm3.FormCreate(Sender: TObject);
begin
  if not TRegistrationF.IsRegistrationValid(FRegInfo) then
  begin
    ShowMessage('Product is not registered!');
    TerminateProcess(GetCurrentProcess, 0);
//    Halt(0);
  end;

  FRegInfo.SaveToRegistry;

  FIPCClientAll := TIPCClientAll.Create;

  FWG.FCalculatedItemTimerHandle := -1;
  FWG.SetIPCMonitorAll(IPCMonitorAll1);
  FWG.SetStatusBar(JvStatusBar1);
  FWG.SetMainFormHandle(Handle);
  FWG.SetDeleteEngineParamterFromGrid(DeleteEngineParamterFromGrid);
  FWG.SetWatchValue2Screen_Analog(WatchValue2Screen_Analog);
  FWG.NextGrid1.PopupMenu := ItemsPopup;
  FWG.NextGrid1.DoubleBuffered := False;

  FWG.NextGrid1.Columns.Item[0].Visible := False;
  FWG.NextGrid1.Columns.Item[1].Visible := False;
  FWG.NextGrid1.Columns.Item[5].Visible := False;
  FWG.NextGrid1.Columns.Item[6].Visible := False;

  IPCMonitorAll1.FNextGrid := FWG.NextGrid1;
  IPCMonitorAll1.FPageControl := AdvOfficePager1;

  FSettings := TConfigSettings.create(ChangeFileExt(Application.ExeName, '.ini'));
  LoadConfigFromFile;
  CommandLineParse;
  ApplyUI;
end;

procedure TForm3.FormDestroy(Sender: TObject);
begin
  FRegInfo.Free;

  if Assigned(FClient) then
    FClient.Free;

  if Assigned(FModel) then
    FModel.Free;

  FIPCClientAll.Free;
  FSettings.Free;
end;

procedure TForm3.GetEngineParameterFromSavedWatchListFile(AAutoStart: Boolean;
  AFileName: string);
var
  i, j: integer;
  LStrList: TStringList;
  LStr: string;
begin
  if FileExists(AFileName) then
  begin
    if FWG.NextGrid1.RowCount > 0 then
    begin
      i := MessageDlg('Do you want to apppend the items to the grid?' + #13#10 + 'If you want to clear the items, Click ''No''',
                                mtConfirmation, [mbYes, mbNo, mbCancel], 0);
      case i of
        mrNo: begin
          IPCMonitorAll1.FEngineParameter.EngineParameterCollect.Clear;
          FWG.NextGrid1.ClearRows;
        end;
        mrCancel: exit;
      end;
    end;

    FWG.AppendEngineParameterFromFile(AFileName, 1, False, False);
    FWG.FCompoundItemList.clear;

    for i := 0 to IPCMonitorAll1.FEngineParameter.EngineParameterCollect.Count - 1 do
    begin
      IPCMonitorAll1.MoveEngineParameterItemRecord2(FWG.FEngineParameterItemRecord,i);
      IPCMonitorAll1.CreateIPCMonitor(FWG.FEngineParameterItemRecord, True);

      j := FWG.NextGrid1.AddRow();

      if FWG.FEngineParameterItemRecord.FDescription = '' then
        FWG.NextGrid1.CellsByName['ItemName', j] := FWG.FEngineParameterItemRecord.FTagName
      else
        FWG.NextGrid1.CellsByName['ItemName', j] := FWG.FEngineParameterItemRecord.FDescription;

      FWG.NextGrid1.CellsByName['FUnit', j] := FWG.FEngineParameterItemRecord.FUnit;

      if FWG.FEngineParameterItemRecord.FParameterSource = psManualInput then
        FWG.NextGrid1.CellsByName['Value', j] := FWG.FEngineParameterItemRecord.FValue;

      if IPCMonitorAll1.FEngineParameter.EngineParameterCollect.Items[i].FormulaValueList <> '' then
      begin
        FWG.NextGrid1.CellByName['ItemName',j].AsString :=
          IPCMonitorAll1.FEngineParameter.EngineParameterCollect.Items[i].Description;

        LStr := IPCMonitorAll1.FEngineParameter.EngineParameterCollect.Items[i].FormulaValueList;
        LStrList := TStringList.Create;
        LStrList.Text := LStr;
        FWG.NextGrid1.Row[j].Data := LStrList;
        FWG.FCompoundItemList.add(j);

        if FWG.FCalculatedItemTimerHandle = -1 then
          FWG.FCalculatedItemTimerHandle := FWG.FPJHTimerPool.Add(FWG.OnDisplayCalculatedItemValue,1000);
      end; //if
    end; //for
  end;
end;

procedure TForm3.GetEngParamCollect;
var
  I: IEngParameter;
  LDynArr: TRawUTF8DynArray;
  Lip: string;
  Li,LRow: integer;
  LEPCollect: TEngineParameterCollect;
begin
  if FEngParamFilled then
    exit;

  LEPCollect := TEngineParameterCollect.Create(TEngineParameterItem);
  try
    I := FClient.Service<IEngParameter>;

    if I <> nil then
      I.GetEngParam(LEPCollect);

    if Assigned(LEPCollect) then
    begin
      FWG.NextGrid1.ClearRows;

      for Li := 0 to LEPCollect.Count - 1 do
      begin
//        if LEPCollect.Items[Li].TagName <> '' then
//        begin
//          LRow := FWG.NextGrid1.AddRow;
//          FWG.NextGrid1.CellByName['ItemName',LRow].AsString := LEPCollect.Items[Li].TagName;
//        end;

        if LEPCollect.Items[Li].SensorType = stCalculated then
          LEPCollect.Items[Li].Alarm := True;

        LEPCollect.Items[Li].ParameterSource := psEngineParam;
        LEPCollect.Items[Li].AbsoluteIndex := Li;

        if FSettings.SharedName <> '' then
          LEPCollect.Items[Li].SharedName := FSettings.SharedName;
      end;

      FIPCClientAll.FEngineParameter.EngineParameterCollect.AddEngineParameterCollect(LEPCollect);
      //FIPCClientAll.FEngineParameter.EngineParameterCollect와 FWG.IPCMonotorAll.FEngineParameter.EngineParameterCollect는 내용이 같아야 함
      //ParameterSource를 수정한 후 복사하기 위해 이 위치에서 실행 함.
      FWG.SetEngParamCollect2IPCMonotorAll(LEPCollect);

      for Li := 0 to LEPCollect.Count - 1 do
         FWG.AddEngineParameter2Grid(Li);

      FIPCClientAll.CreateIPCClientAll;
      Caption := Caption + '(' + FIPCClientAll.GetEventName + ')';
    end;

    FEngParamFilled := True;

  finally
    LEPCollect.Free;
  end;
end;

procedure TForm3.GetEngParamValues;
var
  I: IEngParameter;
  LDynArr: TRawUTF8DynArray;
  Lip: string;
  Li,LRow: integer;
  LEventData: TEventData_EngineParam;
begin
  LDynArr := nil;

  I := FClient.Service<IEngParameter>;

  if I <> nil then
    LDynArr := I.GetTagValues;

  for Li := 0 to High(LDynArr) - 1 do
  begin
    if LDynArr[Li] <> '' then
    begin
//      FWG.NextGrid1.CellByName['Value',Li].AsString := LDynArr[Li];
      FIPCClientAll.FEngineParameter.EngineParameterCollect.Items[Li].Value := LDynArr[Li];

      if Li < High(LEventData.FData) then
        LEventData.FData[Li] := UTF8ToString(LDynArr[Li]);
    end
    else
      if Li < High(LEventData.FData) then
        LEventData.FData[Li] := '';
  end;

  LEventData.FDataCount := High(LDynArr);

  FIPCClientAll.PulseEventData_EngineParam(LEventData);
  DisplayMessage(FIPCClientAll.FEngineParameter.EngineParameterCollect.Items[0].SharedName + ' Pulse Event', dtStatusBar);

//  SendAlarm2Server;
end;

procedure TForm3.LoadConfig2Form(AForm: TConfigF);
begin
  FSettings.LoadConfig2Form(AForm, FSettings);
end;

procedure TForm3.LoadConfigForm2Object(AForm: TConfigF);
begin
  FSettings.LoadConfigForm2Object(AForm, FSettings);

  DisplayMessage('============================================================', dtSystemLog);
  DisplayMessage('Shared Name: ' + FSettings.SharedName, dtSystemLog);
  DisplayMessage('Server IP: ' + FSettings.ServerIP, dtSystemLog);
  DisplayMessage('Server Port: ' + FSettings.ServerPort, dtSystemLog);
end;

procedure TForm3.LoadConfigFromFile(AFileName: string);
begin
  FSettings.Load(AFileName);
end;

procedure TForm3.LoadParameterFromFile1Click(Sender: TObject);
var
  LEngineParameter: TEngineParameter;
  i: integer;
begin
//  JvOpenDialog1.InitialDir := FApplicationPath+'doc';
  JvOpenDialog1.Filter := '*.param||*.*';

  if JvOpenDialog1.Execute then
  begin
    if jvOpenDialog1.FileName <> '' then
    begin
      GetEngineParameterFromSavedWatchListFile(False, jvOpenDialog1.FileName);
      FItemsChanged := True;
    end;
  end;
end;

procedure TForm3.QuitButtonClick(Sender: TObject);
begin
  Close;
end;

//.hjp file을 registry에서 읽어서 복원함
procedure TForm3.RestoreRegFile;
var
  LIIFFile, LPhrase: string;
  LRegInfo: TRegistrationInfo;
begin
  LRegInfo := TRegistrationInfo.Create(nil);
  try
    LIIFFile := ChangeFileExt(Application.ExeName, '.iif'); //프로그램 처음 설치 시 생성되는 파일: 설치 일자 CPU ID 등이 저장됨
    LPhrase := FRegInfo.MakePassPhrase(ExtractFileName(Application.ExeName));

    if FileExists(LIIFFile) then
    begin
      LRegInfo.LoadFromJSONFile(LIIFFile, LPhrase, True);

      if LRegInfo.RegFileName <> '' then
      begin
        FRegInfo.LoadFromRegistry;
        FRegInfo.SaveToJSONFile(LRegInfo.RegFileName, LPhrase, True);
      end;
    end;
  finally
    LRegInfo.Free;
  end;
end;

procedure TForm3.RestoreRegFile1Click(Sender: TObject);
begin
  RestoreRegFile;
end;

procedure TForm3.SetConfig;
var
  LConfigF: TConfigF;
begin
  LConfigF := TConfigF.Create(Self);

  try
    LoadConfig2Form(LConfigF);

    if LConfigF.ShowModal = mrOK then
    begin
      LoadConfigForm2Object(LConfigF);
      FSettings.Save();
      ApplyUI;
    end;
  finally
    LConfigF.Free;
  end;
end;

procedure TForm3.Setup1Click(Sender: TObject);
begin
  SetConfig;
end;

procedure TForm3.Timer1Timer(Sender: TObject);
begin
  Timer1.Enabled := False;
  try
    GetEngParamValues;
  finally
    Timer1.Enabled := True;
  end;
end;

//Calculated Item 값 갱신 후 실행 됨.
procedure TForm3.WatchValue2Screen_Analog(Name, AValue: string;
  AEPIndex: integer);
begin
  if UpperCase(AdvOfficePager1.ActivePage.Name) = ITEMS_SHEET_NAME then
  begin
    FWG.NextGrid1.CellsByName['Value', AEPIndex] := IPCMonitorAll1.FEngineParameter.EngineParameterCollect.Items[AEPIndex].Value;
  end;
end;

procedure TForm3.WatchValue2Screen_Digital(Name, AValue: string;
  AEPIndex: integer);
begin
;
end;

end.
