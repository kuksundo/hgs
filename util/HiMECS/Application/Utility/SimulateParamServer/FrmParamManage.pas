unit FrmParamManage;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes,
  Vcl.Graphics, System.SyncObjs,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, JvBaseDlg, JvSelectDirectory,
  Vcl.ExtCtrls, AdvSmoothSplashScreen, Vcl.Menus, Vcl.ImgList, NxColumnClasses,
  NxColumns, NxScrollControl, NxCustomGridControl, NxCustomGrid, NxGrid, SBPro,
  AdvOfficeTabSet, Vcl.StdCtrls, AeroButtons, JvExControls, JvLabel,
  CurvyControls, AdvOfficePager, Vcl.ComCtrls, UnitSTOMPClass, UnitWorker4OmniMsgQ,
  FrmParamConfig, UnitSimulateParamRecord, UnitIPCClientAll, HiMECSConst,
  UnitCommandLineUtil, UnitFGSSData;
//  UnitCommandLineUtil, UnitSimulateParamCommandLineOption;

const
  MQ_TOPIC_STOMP = '/topic/#/';
  MEMO_MAX_LINES = 100;

type
  TThreadSimulateEvent = class(TThread)
  private
    FIPCClientAll: TIPCClientAll;
  protected
    procedure Execute; override;
  public
    FParamListJson: string;
    FPauseEvent : TEvent;
    FStop, FPause: Boolean;
    FCurrentIndex: integer;

    constructor Create(CreateSuspended: Boolean; APauseEvent: TEvent);
    destructor Destroy; override;
    procedure ReStart;
  end;

  TParamManageF = class(TForm)
    AdvOfficePager1: TAdvOfficePager;
    ParamListPage: TAdvOfficePage;
    STOMPPage: TAdvOfficePage;
    Splitter1: TSplitter;
    CurvyPanel1: TCurvyPanel;
    JvLabel6: TJvLabel;
    JvLabel3: TJvLabel;
    JvLabel1: TJvLabel;
    JvLabel2: TJvLabel;
    SubSystemNameEdit: TEdit;
    Panel1: TPanel;
    btn_Search: TAeroButton;
    btn_Close: TAeroButton;
    AeroButton1: TAeroButton;
    SystemNameEdit: TEdit;
    ProdTypeCB: TComboBox;
    ModelNameCB: TComboBox;
    TaskTab: TAdvOfficeTabSet;
    StatusBarPro1: TStatusBarPro;
    ParamListGrid: TNextGrid;
    NxIncrementColumn1: TNxIncrementColumn;
    ProductType: TNxTextColumn;
    SystemName: TNxTextColumn;
    SubSystemName: TNxTextColumn;
    Subject: TNxTextColumn;
    JsonParamCollect: TNxButtonColumn;
    UpdateDate: TNxTextColumn;
    imagelist24x24: TImageList;
    ImageList16x16: TImageList;
    MainMenu1: TMainMenu;
    File1: TMenuItem;
    ImportGeneratorMasterFromXlsFile1: TMenuItem;
    N2: TMenuItem;
    Close1: TMenuItem;
    View1: TMenuItem;
    DataBase1: TMenuItem;
    ools1: TMenuItem;
    OpenDialog1: TOpenDialog;
    PopupMenu1: TPopupMenu;
    Add1: TMenuItem;
    N1: TMenuItem;
    DeleteSelectedCert1: TMenuItem;
    ImageList32x32: TImageList;
    SplashScreen1: TAdvSmoothSplashScreen;
    Timer1: TTimer;
    JvSelectDirectory1: TJvSelectDirectory;
    Memo1: TMemo;
    Panel2: TPanel;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    MQServerIPEdit: TEdit;
    MQServerPortEdit: TEdit;
    TopicEdit: TEdit;
    StatusBar1: TStatusBar;
    SeqNo: TNxNumberColumn;
    ModelName: TNxTextColumn;
    JvLabel4: TJvLabel;
    SubjectEdit: TEdit;
    CSVValues: TNxButtonColumn;
    ProjectName: TNxTextColumn;
    JvLabel5: TJvLabel;
    ProjectNameCB: TComboBox;
    Config1: TMenuItem;
    Enable: TNxCheckBoxColumn;
    TransferStepCheck: TCheckBox;

    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure btn_SearchClick(Sender: TObject);
    procedure btn_CloseClick(Sender: TObject);
    procedure ParamListGridCellDblClick(Sender: TObject; ACol, ARow: Integer);
    procedure AeroButton1Click(Sender: TObject);
    procedure Close1Click(Sender: TObject);
    procedure Config1Click(Sender: TObject);
    procedure DeleteSelectedCert1Click(Sender: TObject);
    procedure Add1Click(Sender: TObject);
    procedure ProdTypeCBChange(Sender: TObject);
  private
    FpjhSTOMPClass: TpjhSTOMPClass;
    FThreadSimulateEvent: TThreadSimulateEvent;
    FExeFilePath: string;
    FIsDestroying: Boolean;
    FStepIndex: integer;
    FJsonParamCollect,
    FCSVValues: string;
    FPauseEvent : TEvent;

    procedure InitVar;
    procedure FinalizeVar;
    procedure InitSTOMP(AUserId, APasswd, AServerIP, ATopic: string);
    procedure DestroySTOMP;

    procedure WorkerResult(var msg: TMessage); message MSG_RESULT;
    procedure ProcessSubscribeMsg;
    procedure SendData2MQ(AMsg: string; ATopic: string = '');

    procedure LoadConfigFromFile(AFileName: string = '');
    procedure LoadConfig2Form(AForm: TConfigF);
    procedure LoadConfigForm2Object(AForm: TConfigF);
    procedure SetConfig;
    procedure ApplyUI;
    procedure DispConfigData;
    procedure DisplaySTOMPMessage2Memo(msg: string; ADest: integer);

    procedure GetParamList2Grid(AIsFromRemote: Boolean = False);
    procedure GetSimParamSearchParam2Rec(var ASimParamSearchRec: TSimParamSearchRec);
    procedure GetSimParamSearchFromGrid2Rec(var ASimParamSearchRec: TSimParamSearchRec);
    procedure GetParamListFromLocal(ASimParamSearchRec: TSimParamSearchRec);
    procedure GetParamListFromVariant2Grid(ADoc: Variant);

    procedure ShowParamEditFormFromGrid(ARow: integer);
    procedure ProcessSimulateOneStep;
    procedure FillInModelKind;
  public
    FSettings : TConfigSettings;
    FParamListJson: string;
    FCurrentIndex: integer;
  end;

procedure CreateParamManageR(AJsonParamCollect, ACSVValues: string);

var
  ParamManageF: TParamManageF;

implementation

uses otlcomm, StompTypes, UnitSTOMPMsg.EventThreads, UnitVesselData,
  UnitHGSCurriculumData, SynCommons, FrmSimulateParamEdit, IPC_FGSS_KM_Const,
  UnitBase64Util, UnitStringUtil;

{$R *.dfm}

procedure CreateParamManageR(AJsonParamCollect, ACSVValues: string);
var
  LParamManageF: TParamManageF;
begin
  LParamManageF := TParamManageF.Create(nil);
  try
    AJsonParamCollect := MakeBase64ToString(AJsonParamCollect);
    ACSVValues := MakeBase64ToString(ACSVValues);
    LParamManageF.FJsonParamCollect := AJsonParamCollect;
    LParamManageF.FCSVValues := ACSVValues;
    LParamManageF.STOMPPage.Visible := False;
    LParamManageF.AeroButton1.Visible := False;

    LParamManageF.ShowModal;
  finally
    LParamManageF.Free;
  end;
end;

procedure TParamManageF.Add1Click(Sender: TObject);
begin
  ShowParamEditFormFromGrid(-1);
end;

procedure TParamManageF.AeroButton1Click(Sender: TObject);
begin
  if FSettings.UseSharedMM then
  begin
    if Assigned(FThreadSimulateEvent) then
    begin
      if FThreadSimulateEvent.Terminated then
        FThreadSimulateEvent := nil
      else
      if not TransferStepCheck.Checked then
      begin
        FThreadSimulateEvent.FStop := True;
        Sleep(500);
        FThreadSimulateEvent.Terminate;
      end;
    end;

    if not Assigned(FThreadSimulateEvent) then
    begin
      FThreadSimulateEvent := TThreadSimulateEvent.Create(True, FPauseEvent);
      FThreadSimulateEvent.FreeOnTerminate := True;
      FThreadSimulateEvent.FParamListJson := Self.FParamListJson;
      FThreadSimulateEvent.FPause := TransferStepCheck.Checked;

      FThreadSimulateEvent.Resume;
    end;

    if TransferStepCheck.Checked then
    begin
//      Winapi.Windows.PulseEvent(FPauseEvent.Handle);
      FPauseEvent.SetEvent;
      ParamListGrid.SelectedRow := FThreadSimulateEvent.FCurrentIndex;
      ParamListGrid.ScrollToRow(ParamListGrid.SelectedRow);
      StatusBarPro1.Panels[3].Text := ParamListGrid.CellsByName['SeqNo',ParamListGrid.SelectedRow];//  IntToStr(ParamListGrid.SelectedRow+1);
    end;
  end;

  if FSettings.UseSTOMP then
  begin
    InitSTOMP(FSettings.STOMPServerUserId,
      FSettings.STOMPServerPasswd,
      FSettings.STOMPServerIP,
      FSettings.STOMPServerTopic);
  end;
end;

procedure TParamManageF.ApplyUI;
begin
  DispConfigData;
end;

procedure TParamManageF.btn_CloseClick(Sender: TObject);
begin
  Close;
end;

procedure TParamManageF.btn_SearchClick(Sender: TObject);
begin
  GetParamList2Grid;
end;

procedure TParamManageF.Close1Click(Sender: TObject);
begin
  Close;
end;

procedure TParamManageF.Config1Click(Sender: TObject);
begin
  SetConfig;
end;

procedure TParamManageF.DeleteSelectedCert1Click(Sender: TObject);
var
  LSimParamSearchRec: TSimParamSearchRec;
  LCertNo: string;
begin
  if ParamListGrid.SelectedRow = -1 then
    exit;

  if MessageDlg('Selected Parameter will be deleted.' + #13#10 + 'Are you sure?',
    mtConfirmation, [mbYes, mbNo], 0)= mrNo then
    exit;

  GetSimParamSearchFromGrid2Rec(LSimParamSearchRec);
  DeleteSimulateParam(LSimParamSearchRec);
  GetParamList2Grid;
  ParamListGrid.ScrollToRow(ParamListGrid.SelectedRow);
end;

procedure TParamManageF.DestroySTOMP;
begin
  if Assigned(FpjhSTOMPClass) then
    FpjhSTOMPClass.Free;
end;

procedure TParamManageF.DispConfigData;
begin
  MQServerIPEdit.Text := FSettings.STOMPServerIP;
  MQServerPortEdit.Text := FSettings.STOMPServerPort;
  TopicEdit.Text := FSettings.STOMPServerTopic;
end;

procedure TParamManageF.DisplaySTOMPMessage2Memo(msg: string; ADest: integer);
begin
  if FIsDestroying then
    exit;

  if msg = ' ' then
  begin
    exit;
  end;

  case ADest of
    0 : begin
      with Memo1 do
      begin
        if Lines.Count > MEMO_MAX_LINES then
          Clear;
        Lines.Add(DateTimeToStr(now) + ' :: ' + msg);
      end;//with
    end;//dtSystemLog
  end;//case
end;

procedure TParamManageF.FillInModelKind;
begin
  case TShipProductType(ProdTypeCB.ItemIndex) of
    shptME:;
    shptGE:;
    shptCB:;
    shptTR:;
    shptGEN:;
    shptAMS:;
    shptSWBD:;
    shptMOTOR:;
    shptSCR:;
    shptBWTS:;
    shptFGSS:FGSSModelKind2List(ModelNameCB.Items);
    shptCOPT:;
    shptPROPELLER:;
    shptEGR:;
    shptVDR:;
  end;
end;

procedure TParamManageF.FinalizeVar;
begin
  FSettings.Free;
  FreeAndNil(FPauseEvent);

  DestroySimulateParam;
  DestroySTOMP;
end;

procedure TParamManageF.FormCreate(Sender: TObject);
begin
  InitVar;
end;

procedure TParamManageF.FormDestroy(Sender: TObject);
begin
  FinalizeVar;
end;

procedure TParamManageF.GetParamList2Grid(AIsFromRemote: Boolean);
var
  LSQLSimulateParamRecord: TSQLSimulateParamRecord;
  LSimParamSearchRec: TSimParamSearchRec;
  LDoc: Variant;
begin
  ParamListGrid.BeginUpdate;
  try
    ParamListGrid.ClearRows;
    GetSimParamSearchParam2Rec(LSimParamSearchRec);

//    if AIsFromRemote then
//      GetVesselListFromRemote(LSimParamSearchRec)
//    else
      GetParamListFromLocal(LSimParamSearchRec);
  finally
    ParamListGrid.EndUpdate;
  end;
end;

procedure TParamManageF.GetParamListFromLocal(
  ASimParamSearchRec: TSimParamSearchRec);
var
  LSQLSimulateParamRecord: TSQLSimulateParamRecord;
  LDoc: Variant;
  LDynUtf8File: TRawUTF8DynArray;
  LDynArrFile: TDynArray;
  LUtf8: RawUTF8;
begin
  LSQLSimulateParamRecord := GetSimulateParamRecordFromSearchRec(ASimParamSearchRec);
  try
    if LSQLSimulateParamRecord.IsUpdate then
    begin
      LSQLSimulateParamRecord.FillRewind;
      LDynArrFile.Init(TypeInfo(TRawUTF8DynArray), LDynUtf8File);

      while LSQLSimulateParamRecord.FillOne do
      begin
        LDoc := GetVariantFromSimulateParamRecord(LSQLSimulateParamRecord);
        GetParamListFromVariant2Grid(LDoc);
        LUtf8 := VariantSaveJson(LDoc);
        LDynArrFile.Add(LUtf8);
      end;//while

      LDoc := _JSON(LDynArrFile.SaveToJSON);
      FParamListJson := LDoc;
      StatusBarPro1.Panels[1].Text := IntToStr(ParamListGrid.RowCount);
    end;
  finally
    LSQLSimulateParamRecord.Free;
  end;
end;

procedure TParamManageF.GetParamListFromVariant2Grid(ADoc: Variant);
var
  LRow: integer;
  LShipProductTypes: integer;//TShipProductTypes;
begin
  LRow := ParamListGrid.AddRow;

  LShipProductTypes := ADoc.ProductType;

  ParamListGrid.CellsByName['Enable', LRow] := ADoc.Enable;

  if LShipProductTypes > -1 then
    ParamListGrid.CellsByName['ProductType', LRow] := g_ShipProductType.ToString(LShipProductTypes);

  ParamListGrid.CellsByName['ModelName', LRow] := ADoc.ModelName;
  ParamListGrid.CellsByName['ProjectName', LRow] := ADoc.ProjectName;
  ParamListGrid.CellsByName['SystemName', LRow] := ADoc.SystemName;
  ParamListGrid.CellsByName['SubSystemName', LRow] := ADoc.SubSystemName;
  ParamListGrid.CellsByName['SeqNo', LRow] := ADoc.SeqNo;
  ParamListGrid.CellsByName['Subject', LRow] := ADoc.Subject;
  ParamListGrid.CellsByName['JsonParamCollect', LRow] := ADoc.JsonParamCollect;
  ParamListGrid.CellsByName['CSVValues', LRow] := ADoc.CSVValues;

  if ADoc.UpdateDate > 127489752310 then
    ParamListGrid.CellsByName['UpdateDate', LRow] := DateToStr(TimeLogToDateTime(ADoc.UpdateDate));
end;

procedure TParamManageF.GetSimParamSearchFromGrid2Rec(
  var ASimParamSearchRec: TSimParamSearchRec);
var
  LRow: integer;
begin
  if ParamListGrid.SelectedRow = -1 then
    Exit;

  LRow := ParamListGrid.SelectedRow;
  ASimParamSearchRec := Default(TSimParamSearchRec);

  ASimParamSearchRec.fProductType := g_ShipProductType.ToType(ParamListGrid.CellsByName['ProductType', LRow]);
  ASimParamSearchRec.fModelName := ParamListGrid.CellsByName['ModelName', LRow];
  ASimParamSearchRec.fProjectName := ParamListGrid.CellsByName['ProjectName', LRow];
  ASimParamSearchRec.fSystemName := ParamListGrid.CellsByName['SystemName', LRow];
  ASimParamSearchRec.fSubSystemName := ParamListGrid.CellsByName['SubSystemName', LRow];
  ASimParamSearchRec.fSubject := ParamListGrid.CellsByName['Subject', LRow];
  ASimParamSearchRec.fSeqNo := ParamListGrid.CellByName['SeqNo', LRow].AsInteger;
end;

procedure TParamManageF.GetSimParamSearchParam2Rec(
  var ASimParamSearchRec: TSimParamSearchRec);
begin
  ASimParamSearchRec := Default(TSimParamSearchRec);

  if ProdTypeCB.ItemIndex = -1 then
    ASimParamSearchRec.fProductType := g_ShipProductType.ToType(0)
  else
    ASimParamSearchRec.fProductType := g_ShipProductType.ToType(ProdTypeCB.ItemIndex);

  ASimParamSearchRec.fModelName := ModelNameCB.Text;
  ASimParamSearchRec.fProjectName := ProjectNameCB.Text;
  ASimParamSearchRec.fSystemName := SystemNameEdit.Text;
  ASimParamSearchRec.fSubSystemName := SubSystemNameEdit.Text;
  ASimParamSearchRec.fSubject := SubjectEdit.Text;
end;

procedure TParamManageF.InitSTOMP(AUserId, APasswd, AServerIP, ATopic: string);
begin
  if not Assigned(FpjhSTOMPClass) then
  begin
    FpjhSTOMPClass := TpjhSTOMPClass.CreateWithStr(AUserId,
                                            APasswd,
                                            AServerIP,
                                            ATopic,
                                            Self.Handle);
  end;
end;

procedure TParamManageF.InitVar;
var
  LStr: string;
begin
  FExeFilePath := ExtractFilePath(Application.ExeName);
  FThreadSimulateEvent := nil;
  FSettings := TConfigSettings.Create('');

  if FSettings.IniFileName = '' then
    FSettings.IniFileName := ChangeFileExt(Application.ExeName, '.ini');

  LoadConfigFromFile(FSettings.IniFileName);
  InitSimulateParamClient(HGS_SIMULATE_PARAM_DB_NAME);

  STOMPMsgEventThread.SetDisplayMsgProc(DisplaySTOMPMessage2Memo);
//  InitSTOMP(FSettings.STOMPServerUserId,FSettings.STOMPServerPasswd,FSettings.STOMPServerIP,FSettings.STOMPServerTopic);
  FPauseEvent := TEvent.Create;
  ShipProductType2List(ProdTypeCB.Items);
end;

procedure TParamManageF.LoadConfig2Form(AForm: TConfigF);
begin
  FSettings.LoadConfig2Form(AForm, FSettings);
end;

procedure TParamManageF.LoadConfigForm2Object(AForm: TConfigF);
begin
  FSettings.LoadConfigForm2Object(AForm, FSettings);
end;

procedure TParamManageF.LoadConfigFromFile(AFileName: string);
begin
  FSettings.Load(AFileName);

  if FSettings.STOMPServerIP = '' then
    FSettings.STOMPServerIP := '127.0.0.1';

  if FSettings.STOMPServerTopic = '' then
    FSettings.STOMPServerTopic := MQ_TOPIC_STOMP;

  ApplyUI;
end;

procedure TParamManageF.ParamListGridCellDblClick(Sender: TObject; ACol,
  ARow: Integer);
begin
  if ARow = -1 then
    Exit;

  ShowParamEditFormFromGrid(ARow);
end;

procedure TParamManageF.ProcessSimulateOneStep;
begin

end;

procedure TParamManageF.ProcessSubscribeMsg;
var
  msg: TOmniMessage;
  FStompFrame: IStompFrame;
begin
  while FpjhSTOMPClass.GetResponseQMsg(msg) do
  begin
    FStompFrame := msg.MsgData.AsInterface as IStompFrame;
//    Memo1.Lines.Add(FStompFrame.GetBody);
  end;
end;

procedure TParamManageF.ProdTypeCBChange(Sender: TObject);
begin
  FillInModelKind;
end;

procedure TParamManageF.SendData2MQ(AMsg, ATopic: string);
begin
  FpjhSTOMPClass.StompSendMsg(AMsg, ATopic);
end;

procedure TParamManageF.SetConfig;
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

      ApplyUI;
    end;
  finally
    LConfigF.Free;
  end;
end;

procedure TParamManageF.ShowParamEditFormFromGrid(ARow: integer);
var
  LSimParamSearchRec: TSimParamSearchRec;
begin
  if ARow <> -1 then
    GetSimParamSearchFromGrid2Rec(LSimParamSearchRec);

  if CreateOrShowParamEditFormFromDB(LSimParamSearchRec,
    FJsonParamCollect, FCSVValues) = mrOK then
  begin
    GetParamList2Grid;
    ParamListGrid.ScrollToRow(ARow);
  end;
end;

procedure TParamManageF.WorkerResult(var msg: TMessage);
begin
  ProcessSubscribeMsg;
end;

{ TThreadSimulateEvent }

constructor TThreadSimulateEvent.Create(CreateSuspended: Boolean; APauseEvent: TEvent);
begin
  FPauseEvent := APauseEvent;//TEvent.Create;
  FIPCClientAll := TIPCClientAll.Create;
  FIPCClientAll.CreateIPCClient(psFGSS_KM);

  inherited Create(CreateSuspended);
end;

destructor TThreadSimulateEvent.Destroy;
begin
  FreeAndNil(FIPCClientAll);

  inherited;
end;

procedure TThreadSimulateEvent.Execute;
var
//  LDynUtf8: TRawUTF8DynArray;
//  LDynArr: TDynArray;
  LUtf8: RawUTF8;
  LData: TEventData_FGSS_KM;
  LDocData: TDocVariantData;
  LVar: Variant;
  i, j, LDelaySecs: integer;
  LStr: string;
  LEnable: Boolean;
begin
  LDocData.InitJSON(FParamListJson);
//  LDynArr.Init(TypeInfo(TRawUTF8DynArray), LDynUtf8);

//  while not terminated do
//  begin
    for i := 0 to LDocData.Count - 1 do
    begin
      if FStop then
        break;

      LVar := _JSON(LDocData.Value[i]);
      LEnable := LVar.Enable;

      if LEnable then
      begin
        FCurrentIndex := i;

        if FPause then
        begin
          FPauseEvent.WaitFor(INFINITE);
          FPauseEvent.ResetEvent;
        end;

        LUtf8 := LVar.CSVValues;
        LDelaySecs := LVar.DelaySecs;

        if LDelaySecs > 0 then
          Sleep(LDelaySecs);

        LStr := UTF8ToString(LUtf8);

        j := 0;
        while LStr <> '' do
        begin
          LData.FData[j] := strToken(LStr, ',');
          inc(j);
        end;

  //      CSVToRawUTF8DynArray(PUTF8Char(LUtf8),',', ';',LDynUtf8);

  //      for j := Low(LDynUtf8) to High(LDynUtf8) do
  //        LData.FData[j] := LDynUtf8[j];

        LData.FDataCount := j;//High(LDynUtf8) + 1;
        FIPCClientAll.PulseEventData<TEventData_FGSS_KM>(LData);
      end;
    end;
//  end;
  Terminate;
end;

procedure TThreadSimulateEvent.ReStart;
begin
  FPauseEvent.SetEvent;
end;

end.
