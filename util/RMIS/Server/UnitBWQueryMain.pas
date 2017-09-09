unit UnitBWQueryMain;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs,
  Vcl.ComCtrls, Vcl.StdCtrls, Vcl.Buttons, Vcl.ExtCtrls, TimerPool,
  Vcl.OleCtrls, SHDocVw,
  SynCommons, mORMot, mORMotSQLite3, mORMotHttpServer, UnitFrameCommServer,
  AdvOfficePager, Vcl.Menus, BW_Query_Class,
  tmsAdvGridExcel, UnitBWQueryInterface, UnitBWQueryConfig, UnitHhiOfficeNewsInterface,
  ralarm, Sea_Ocean_News_Class, UnitDPMSInfoClass, UnitSessionInterface,
  UnitFrameIPCMonitorRMIS, UnitExtraMH, UnitDPMS, UnitExtraMHInfoInterface, UnitDPMSInfoInterface,
  UnitBWQuery, UnitHHIOfficeNews, RMISConst

;//  {$IFDEF USECODESITE} ,CodeSiteLogging {$ENDIF}

type
  TServiceBWQuery = class(TInterfacedObject, IBWQuery, IDPMSInfo, IExtraMHInfo)//, ISessionLog)
  public
    function GetBWQryClass(AQueryName: RawUTF8; out ACount: Integer): TRawUTF8DynArray;
    function GetCellData(AQueryName: RawUTF8; out AEPCollect: TBWQryCellDataCollect): Boolean;
    function GetCellDataAll(out ABWQryCellDataAll: TBWQryCellDataAllCollect): Boolean;
    function GetRowHeaderData(AQueryName: RawUTF8; out AColCountOfRow: integer;  out AEPCollect: TBWQryRowHeaderCollect): Boolean;
    function GetColHeaderData(AQueryName: RawUTF8; out AEPCollect: TBWQryColumnHeaderCollect): Boolean;
    function GetOrderPlanPerProduct(out ACollect: TBWQryCellDataCollect): Boolean;
    function GetSalesPlanPerProduct(out ACollect: TBWQryCellDataCollect): Boolean; //제품별 매출 경영계획
    function GetProfitPlanPerProduct(out ACollect: TBWQryCellDataCollect): Boolean; //제품별 손익 경영계획
    function GetNewsList2: TRawUTF8DynArray; //일간 조선 해양 뉴스
//    function GetAttachFileHhiOfficeNews(AFileName: RawUTF8): TServiceCustomAnswer; //일간 조선 해양 뉴스 첨부파일(pdf) 반환
    procedure GetAttachFileHhiOfficeNews2(AFileName:RawUTF8; out AFile: RawByteString); //일간 조선 해양 뉴스 첨부파일(pdf) 반환
    procedure GetHhiOfficeNewsList2(out ASeaOceanNewsCollect: TSONewsCollect);
    function GetInquiryPerProdPerGrade: TRawUTF8DynArray; //등급별 제품별 Inquiry 금액

    function GetDPMSInfo(AFrom, ATo: string): RawUTF8;
    function GetExtraMHInfo(AFrom, ATo: string): RawUTF8;
//    function LogIn(AUserId, APasswd, AIpAddress, AUserName: string): Boolean;
//    function LogOut(AUserId, APasswd, AIpAddress, AUserName: string): Boolean;
  end;

  TMainForm = class(TForm)
    AdvOfficePager1: TAdvOfficePager;
    AdvOfficePager11: TAdvOfficePage;
    AdvOfficePager12: TAdvOfficePage;
    FCS: TFrameCommServer;
    MainMenu1: TMainMenu;
    File1: TMenuItem;
    Etc1: TMenuItem;
    Close1: TMenuItem;
    Config1: TMenuItem;
    AdvGridExcelIO1: TAdvGridExcelIO;
    PopupMenu1: TPopupMenu;
    DataView1: TMenuItem;
    N12: TMenuItem;
    N1: TMenuItem;
    N2: TMenuItem;
    N3: TMenuItem;
    Header1: TMenuItem;
    Header2: TMenuItem;
    N13: TMenuItem;
    N4: TMenuItem;
    N5: TMenuItem;
    N6: TMenuItem;
    N7: TMenuItem;
    HEADER3: TMenuItem;
    N14: TMenuItem;
    N8: TMenuItem;
    N9: TMenuItem;
    N10: TMenuItem;
    N11: TMenuItem;
    Memo1: TMemo;
    N15: TMenuItem;
    N16: TMenuItem;
    N17: TMenuItem;
    N18: TMenuItem;
    N19: TMenuItem;
    N20: TMenuItem;
    Edit1: TEdit;
    AlarmFromTo1: TAlarmFromTo;
    N21: TMenuItem;
    N22: TMenuItem;
    N23: TMenuItem;
    N24: TMenuItem;
    N25: TMenuItem;
    N26: TMenuItem;
    N27: TMenuItem;
    N28: TMenuItem;
    N29: TMenuItem;
    TFrameIPCMonitor1: TFrameIPCMonitor4RMIS;
    Inquiry1: TMenuItem;
    OnGetBWQuery1: TMenuItem;
    est1: TMenuItem;
    N30: TMenuItem;
    N31: TMenuItem;
    N32: TMenuItem;
    N33: TMenuItem;
    N34: TMenuItem;
    N35: TMenuItem;
    GS1: TMenuItem;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FCSServerStartBtnClick(Sender: TObject);
    procedure FCSServerStopBtnClick(Sender: TObject);
    procedure Close1Click(Sender: TObject);
    procedure Config1Click(Sender: TObject);
    procedure N2Click(Sender: TObject);
    procedure N3Click(Sender: TObject);
    procedure Header1Click(Sender: TObject);
    procedure Header2Click(Sender: TObject);
    procedure N4Click(Sender: TObject);
    procedure N5Click(Sender: TObject);
    procedure N6Click(Sender: TObject);
    procedure N7Click(Sender: TObject);
    procedure HEADER3Click(Sender: TObject);
    procedure N8Click(Sender: TObject);
    procedure N9Click(Sender: TObject);
    procedure N10Click(Sender: TObject);
    procedure N11Click(Sender: TObject);
    procedure FCSAutoStartCheckClick(Sender: TObject);
    procedure N16Click(Sender: TObject);
    procedure N15Click(Sender: TObject);
    procedure FCSJvXPButton6Click(Sender: TObject);
    procedure N17Click(Sender: TObject);
    procedure N18Click(Sender: TObject);
    procedure N19Click(Sender: TObject);
    procedure N20Click(Sender: TObject);
    procedure N1Click(Sender: TObject);
    procedure AlarmFromTo1AlarmBegin(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure N23Click(Sender: TObject);
    procedure N24Click(Sender: TObject);
    procedure N25Click(Sender: TObject);
    procedure N26Click(Sender: TObject);
    procedure N27Click(Sender: TObject);
    procedure N29Click(Sender: TObject);
    procedure N28Click(Sender: TObject);
    procedure Inquiry1Click(Sender: TObject);
    procedure OnGetBWQuery1Click(Sender: TObject);
    procedure est1Click(Sender: TObject);
  private
    procedure StartServer;
  protected
    FSettings : TConfigSettings;
//    FAutoStartTimerHandle: integer;

  public
    FExeFilePath: string;

    FBWQuery: TBWQuery;
    FDPMS: TDPMS;
    FExtraMH: TExtraMH;
    FHHIOfficeNews: THHIOfficeNews;

    procedure InitVar;
    procedure DestroyVar;

    procedure LoadConfigFromFile(AFileName: string = '');
    procedure LoadConfig2Form(AForm: TConfigF);
    procedure LoadConfigForm2Object(AForm: TConfigF);
    procedure SetConfig;
    procedure ApplyUI;

    procedure ClearMessage;
    procedure DisplayMessage(msg: string);
    procedure DisplayMessage2FCS(msg: string; ADest: integer);
    procedure SetFormCaption(ACaption: string);
    function GetFormCaption: string;
  end;

var
  MainForm: TMainForm;

implementation

uses UnitDM;

{$R *.dfm}

procedure TMainForm.AlarmFromTo1AlarmBegin(Sender: TObject);
var
  LPort: string;
begin
  try
    LPort := FSettings.ServerPort_HhiOfficeNews;

    if LPort = '' then
    begin
      LPort := HHIOFFICE_PORT_NAME;
      FSettings.ServerPort_HhiOfficeNews := LPort;
    end;

    FHHIOfficeNews.GetHhiOfficeNewsFromServer(FSettings.ServerIP_HhiOfficeNews, LPort);
  except
  end;
end;

procedure TMainForm.ApplyUI;
begin
  AlarmFromTo1.ActiveBegin := False;
  AlarmFromTo1.AlarmTimeBegin := FSettings.ServerTimeToGetHhiOfficeNews;
  AlarmFromTo1.ActiveBegin := True;
end;

procedure TMainForm.ClearMessage;
begin
  Memo1.Lines.Clear;
end;

procedure TMainForm.Close1Click(Sender: TObject);
begin
  Close;
end;

procedure TMainForm.Config1Click(Sender: TObject);
begin
  SetConfig;
end;

procedure TMainForm.DestroyVar;
begin
  FCS.DestroyHttpServer;
  FSettings.Free;
  FBWQuery.Free;
  FDPMS.Free;
  FExtraMH.Free;
  FHHIOfficeNews.Free;
end;

procedure TMainForm.DisplayMessage(msg: string);
begin
  if msg = ' ' then
    exit;

  with Memo1 do
  begin
    if Lines.Count > 10000 then
      Clear;

    Lines.Add(msg);
  end;//with
end;

procedure TMainForm.DisplayMessage2FCS(msg: string; ADest: integer);
begin
  FCS.DisplayMessage(Msg, TDisplayTarget(ADest));
end;

procedure TMainForm.est1Click(Sender: TObject);
begin
  FExtraMH.GetExtraMHInfo('201501', '201508');
end;

procedure TMainForm.FCSAutoStartCheckClick(Sender: TObject);
begin
  if not FCS.AutoStartCheck.Checked then
  begin
//    FPJHTimerPool.Remove(FAutoStartTimerHandle);
//    FAutoStartTimerHandle := -1;
  end;
end;

procedure TMainForm.FCSJvXPButton6Click(Sender: TObject);
begin
//  FGetBWQryFuture.Cancel;
//  FGetBWQryFuture.WaitFor(INFINITE);
//  FGetBWQryFuture := nil;
//  ShowMessage('Calceled!');
end;

procedure TMainForm.FCSServerStartBtnClick(Sender: TObject);
begin
  StartServer;
end;

procedure TMainForm.FCSServerStopBtnClick(Sender: TObject);
begin
  FCS.ServerStopBtnClick(Sender);
end;

procedure TMainForm.FormActivate(Sender: TObject);
var
  LPort: string;
begin
  LPort := FSettings.ServerPort_HhiOfficeNews;

  if LPort = '' then
  begin
    LPort := HHIOFFICE_PORT_NAME;
    FSettings.ServerPort_HhiOfficeNews := LPort;
  end;

  FHHIOfficeNews.GetHhiOfficeNewsFromServer(FSettings.ServerIP_HhiOfficeNews, LPort);
end;

procedure TMainForm.FormCreate(Sender: TObject);
begin
  InitVar;
end;

procedure TMainForm.FormDestroy(Sender: TObject);
begin
  DestroyVar;
end;

function TMainForm.GetFormCaption: string;
begin
  Result := Caption;
end;

procedure TMainForm.Header1Click(Sender: TObject);
begin
  FBWQuery.QryData2DataView(TMenuItem(Sender).Hint);
end;

procedure TMainForm.Header2Click(Sender: TObject);
begin
  FBWQuery.QryData2DataView(TMenuItem(Sender).Hint);
end;

procedure TMainForm.HEADER3Click(Sender: TObject);
begin
  FBWQuery.QryData2DataView(TMenuItem(Sender).Hint);
end;

procedure TMainForm.InitVar;
begin
  FExeFilePath := ExtractFilePath(Application.ExeName);

  FSettings := TConfigSettings.create(ChangeFileExt(Application.ExeName, '.ini'));
  LoadConfigFromFile;

  FBWQuery := TBWQuery.Create;
  FDPMS := TDPMS.Create;
  FExtraMH := TExtraMH.Create;
  FHHIOfficeNews := THHIOfficeNews.Create;
  FBWQuery.FExeFilePath := FExeFilePath;
  g_DisplayMessage2MainForm := DisplayMessage;
  g_DisplayMessage2FCS := DisplayMessage2FCS;
  g_ClearMessage := ClearMessage;
  g_SetFormCaption := SetFormCaption;
  g_GetFormCaption := GetFormCaption;

  //  if FCS.AutoStartCheck.Checked then
//    FAutoStartTimerHandle := FPJHTimerPool.Add(OnAutoStart, 1000);
  FCS.FStartServerProc := StartServer;
  FCS.FAutoStartInterval := 10000; //10초

  if FSettings.ServerTimeToGetHhiOfficeNews <> '' then
  begin
    AlarmFromTo1.AlarmTimeBegin := FSettings.ServerTimeToGetHhiOfficeNews;
    AlarmFromTo1.ActiveBegin := True;
  end;

end;

procedure TMainForm.Inquiry1Click(Sender: TObject);
begin
  FBWQuery.QryData2DataView(TMenuItem(Sender).Hint);
end;

procedure TMainForm.LoadConfig2Form(AForm: TConfigF);
begin
  FSettings.LoadConfig2Form(AForm, FSettings);
end;

procedure TMainForm.LoadConfigForm2Object(AForm: TConfigF);
begin
  FSettings.LoadConfigForm2Object(AForm, FSettings);
end;

procedure TMainForm.LoadConfigFromFile(AFileName: string);
begin
  FSettings.Load(AFileName);
end;

procedure TMainForm.N10Click(Sender: TObject);
begin
  FBWQuery.QryData2DataView(TMenuItem(Sender).Hint);
end;

procedure TMainForm.N11Click(Sender: TObject);
begin
  FBWQuery.QryData2DataView(TMenuItem(Sender).Hint);
end;

procedure TMainForm.N15Click(Sender: TObject);
begin
  FBWQuery.QryData2DataView(TMenuItem(Sender).Hint);
end;

procedure TMainForm.N16Click(Sender: TObject);
begin
  FBWQuery.QryData2DataView(TMenuItem(Sender).Hint);
end;

procedure TMainForm.N17Click(Sender: TObject);
begin
  FBWQuery.QryData2DataView(TMenuItem(Sender).Hint);
end;

procedure TMainForm.N18Click(Sender: TObject);
begin
  FBWQuery.QryData2DataView(TMenuItem(Sender).Hint);
end;

procedure TMainForm.N19Click(Sender: TObject);
begin
  FBWQuery.QryData2DataView(TMenuItem(Sender).Hint);
end;

procedure TMainForm.N1Click(Sender: TObject);
begin
  FBWQuery.QryData2DataView(TMenuItem(Sender).Hint);
end;

procedure TMainForm.N20Click(Sender: TObject);
begin
  FBWQuery.QryData2DataView(TMenuItem(Sender).Hint);
end;

procedure TMainForm.N23Click(Sender: TObject);
begin
  FBWQuery.QryData2DataView(TMenuItem(Sender).Hint);
end;

procedure TMainForm.N24Click(Sender: TObject);
begin
  FBWQuery.QryData2DataView(TMenuItem(Sender).Hint);
end;

procedure TMainForm.N25Click(Sender: TObject);
begin
  FBWQuery.QryData2DataView(TMenuItem(Sender).Hint);
end;

procedure TMainForm.N26Click(Sender: TObject);
begin
  FBWQuery.QryData2DataView(TMenuItem(Sender).Hint);
end;

procedure TMainForm.N27Click(Sender: TObject);
begin
  FBWQuery.QryData2DataView(TMenuItem(Sender).Hint);
end;

procedure TMainForm.N28Click(Sender: TObject);
begin
  FBWQuery.QryData2DataView(TMenuItem(Sender).Hint);
end;

procedure TMainForm.N29Click(Sender: TObject);
begin
  FBWQuery.QryData2DataView(TMenuItem(Sender).Hint);
end;

procedure TMainForm.N2Click(Sender: TObject);
begin
  FBWQuery.QryData2DataView(TMenuItem(Sender).Hint);
end;

procedure TMainForm.N3Click(Sender: TObject);
begin
  FBWQuery.QryData2DataView(TMenuItem(Sender).Hint);
end;

procedure TMainForm.N4Click(Sender: TObject);
begin
  FBWQuery.QryData2DataView(TMenuItem(Sender).Hint);
end;

procedure TMainForm.N5Click(Sender: TObject);
begin
  FBWQuery.QryData2DataView(TMenuItem(Sender).Hint);
end;

procedure TMainForm.N6Click(Sender: TObject);
begin
  FBWQuery.QryData2DataView(TMenuItem(Sender).Hint);
end;

procedure TMainForm.N7Click(Sender: TObject);
begin
  FBWQuery.QryData2DataView(TMenuItem(Sender).Hint);
end;

procedure TMainForm.N8Click(Sender: TObject);
begin
  FBWQuery.QryData2DataView(TMenuItem(Sender).Hint);
end;

procedure TMainForm.N9Click(Sender: TObject);
begin
  FBWQuery.QryData2DataView(TMenuItem(Sender).Hint);
end;

procedure TMainForm.OnGetBWQuery1Click(Sender: TObject);
begin
//  FPJHTimerPool.AddOneShot(OnGetBWQuery, 500);
end;

procedure TMainForm.SetConfig;
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

procedure TMainForm.SetFormCaption(ACaption: string);
begin
  Caption := ACaption;
end;

procedure TMainForm.StartServer;
begin                                                                                                           //sicClientDriven
  FCS.CreateHttpServer(BWQRY_ROOT_NAME, 'BWQuery.json', BWQRY_PORT_NAME, TServiceBWQuery,
    [TypeInfo(IBWQuery), TypeInfo(IDPMSInfo), TypeInfo(IExtraMHInfo)], sicClientDriven, True);
  FCS.ServerStartBtnClick(nil);
end;

{ TServiceBWQuery }

//function TServiceBWQuery.GetAttachFileHhiOfficeNews(
//  AFileName: RawUTF8): TServiceCustomAnswer;
//begin
//  Result.Header := TEXT_CONTENT_TYPE_HEADER;
//  Result.Content := StringFromFile(SHIP_OCEAN_PDF_FILE);
//end;

procedure TServiceBWQuery.GetAttachFileHhiOfficeNews2(AFileName: RawUTF8;
  out AFile: RawByteString);
var
  LFileName: TFileName;
begin
  LFileName := SHIP_OCEAN_PDF_FILE;

  if AFileName <> '' then
    LFileName := AFileName;

  AFile := StringFromFile(LFileName);
end;

function TServiceBWQuery.GetBWQryClass(AQueryName: RawUTF8; out ACount: Integer): TRawUTF8DynArray;
var
  LKey: string;
  LQueryName: string;
  LBQC: TBWQryClass;
  LCount: integer;
  LDynArr: TDynArray;
  LValue: RawUTF8;
begin
//  AServerBusy := MainForm.FGetQrying;
  if MainForm.FBWQuery.FGetQrying then
  begin
    LDynArr.Init(TypeInfo(TRawUTF8DynArray),Result,@LCount);
    LDynArr.Add('GetQrying');
    exit;
  end;

  LBQC := nil;
  LQueryName := Utf8ToString(AQueryName);

  if LQueryName = 'NULL' then //모든 BWQryList를 가져옴
  begin
    LDynArr.Init(TypeInfo(TRawUTF8DynArray),Result,@LCount);

    for LKey in MainForm.FBWQuery.FBWQryList.Keys do
    begin
      LBQC := MainForm.FBWQuery.GetQueryClass(MainForm.FBWQuery.FBWQryList.Items[LKey].QueryName);

      if Assigned(LBQC) then
      begin
        LValue := StringToUTF8(LBQC.Description) + ';';
        LValue := LValue + StringToUTF8(LBQC.QueryName) + ';';
        LValue := LValue + StringToUTF8(LBQC.QueryText) + ';';
        LValue := LValue + StringToUTF8(IntToStr(LBQC.QueryType)) + ';';
        LValue := LValue + StringToUTF8(IntToStr(Ord(LBQC.QryParamType))) + ';';
        LDynArr.Add(LValue);
      end;
    end;

//    ShowMessage(LBQC.QueryName);
  end
  else
  begin
    LBQC := MainForm.FBWQuery.GetQueryClass(AQueryName);

    if Assigned(LBQC) then
    begin
      LDynArr.Init(TypeInfo(TRawUTF8DynArray),Result,@LCount);
      LValue := StringToUTF8(LBQC.Description);
      LDynArr.Add(LValue);
      LValue := StringToUTF8(LBQC.QueryName);
      LDynArr.Add(LValue);
      LValue := StringToUTF8(LBQC.QueryText);
      LDynArr.Add(LValue);
      LValue := StringToUTF8(IntToStr(LBQC.QueryType));
      LDynArr.Add(LValue);
      LValue := StringToUTF8(IntToStr(Ord(LBQC.QryParamType)));
      LDynArr.Add(LValue);
    end;
  end;

  ACount := LCount;
end;

function TServiceBWQuery.GetCellData(AQueryName: RawUTF8;
  out AEPCollect: TBWQryCellDataCollect): Boolean;
var
//  LBWCellData: TBWQryCellDataCollect;
  LQueryName, LRemoteIP: string;
  LBQC: TBWQryClass;
begin
  Result := MainForm.FBWQuery.FGetQrying;

  if Result then
  begin
    exit;
  end;

  LQueryName := Utf8ToString(AQueryName);
  LBQC := nil;
  LBQC := MainForm.FBWQuery.GetQueryClass(AQueryName);
//  LBWCellData := TBWQryCellDataCollect.Create(TBWQryCellDataItem);

  try
//    LBWCellData.Assign(LBQC.BWQryCellDataCollect);
    if Assigned(LBQC) then
    begin
      CopyObject(LBQC.BWQryCellDataCollect, AEPCollect);
      LRemoteIP := FormatDateTime('mm월 dd일, hh:nn:ss => ', now) + IntToStr(LBQC.BWQryCellDataCollect.Count) + ' Data have Sent to client(IP:';
      LRemoteIP := LRemoteIP + FindIniNameValue(pointer(ServiceContext.Request.Call.InHead),'REMOTEIP: ') +  ') for Query ( ' + AQueryName + ' )';
      MainForm.FCS.DisplayMessage(LRemoteIP, dtCommLog);
    end;
  finally
//    LBWCellData.Free;
  end;
end;

function TServiceBWQuery.GetCellDataAll(out ABWQryCellDataAll: TBWQryCellDataAllCollect): Boolean;
var
//  LDynArr: TDynArray;
  LValue: RawUTF8;
  LCount: integer;
begin
//  LDynArr.Init(TypeInfo(TRawUTF8DynArray), Result, @LCount);
  Result := False;

  if MainForm.FBWQuery.FGetQrying then
  begin
//    LDynArr.Add('GetQrying');
    exit;
  end;

  if g_GetCellDataAllRunning then
  begin
//    LDynArr.Add('GetCellDataAllRunning');
    exit;
  end
  else
    g_GetCellDataAllRunning := True;

  try
    MainForm.FBWQuery.GetCellDataAll;
    CopyObject(MainForm.FBWQuery.FCellDataAllCollect, ABWQryCellDataAll);
    Result := True;
//    LDynArr.Add('Success');
  finally
    g_GetCellDataAllRunning := False;
  end;
end;

function TServiceBWQuery.GetColHeaderData(AQueryName: RawUTF8;
  out AEPCollect: TBWQryColumnHeaderCollect): Boolean;
var
  LQueryName: string;
  LBQC: TBWQryClass;
begin
  Result := MainForm.FBWQuery.FGetQrying;

  if Result then
  begin
    exit;
  end;

  LBQC := nil;
  LQueryName := Utf8ToString(AQueryName);
  LBQC := MainForm.FBWQuery.GetQueryClass(AQueryName);

  if Assigned(LBQC) then
    CopyObject(LBQC.BWQryColumnHeaderCollect, AEPCollect);
end;

function TServiceBWQuery.GetDPMSInfo(AFrom, ATo: string): RawUTF8;
begin
  Result := MainForm.FDPMS.GetDPMSInfo(AFrom, ATo);
end;

function TServiceBWQuery.GetExtraMHInfo(AFrom, ATo: string): RawUTF8;
begin
  Result := MainForm.FExtraMH.GetExtraMHInfo(AFrom, ATo);
end;

procedure TServiceBWQuery.GetHhiOfficeNewsList2(
  out ASeaOceanNewsCollect: TSONewsCollect);
begin
  CopyObject(MainForm.FHHIOfficeNews.FSeaOceanNewsCollect, ASeaOceanNewsCollect);
end;

function TServiceBWQuery.GetInquiryPerProdPerGrade: TRawUTF8DynArray;
var
  LCount: integer;
  LDynArr: TDynArray;
begin
  LDynArr.Init(TypeInfo(TRawUTF8DynArray),Result,@LCount);
  Result := MainForm.FBWQuery.GetInquiryPerProdPerGrade;
end;

function TServiceBWQuery.GetNewsList2: TRawUTF8DynArray;
var
  LCount: integer;
  LDynArr: TDynArray;
begin
  LDynArr.Init(TypeInfo(TRawUTF8DynArray),Result,@LCount);
  Result := MainForm.FHHIOfficeNews.GetSONewsFromList;
end;

function TServiceBWQuery.GetOrderPlanPerProduct(
  out ACollect: TBWQryCellDataCollect): Boolean;
begin
  Result := False;

  if MainForm.FBWQuery.FOrderPlanPerProduct.Count > 0 then
  begin
    CopyObject(MainForm.FBWQuery.FOrderPlanPerProduct, ACollect);
    Result := True;
  end;
end;

function TServiceBWQuery.GetProfitPlanPerProduct(
  out ACollect: TBWQryCellDataCollect): Boolean;
begin
  Result := False;

  if MainForm.FBWQuery.FOrderPlanPerProduct.Count > 0 then
  begin
    CopyObject(MainForm.FBWQuery.FProfitPlanPerProduct, ACollect);
    Result := True;
  end;
end;

function TServiceBWQuery.GetRowHeaderData(AQueryName: RawUTF8; out AColCountOfRow: integer;
  out AEPCollect: TBWQryRowHeaderCollect): Boolean;
var
  LQueryName: string;
  LBQC: TBWQryClass;
begin
  Result := MainForm.FBWQuery.FGetQrying;

  if Result then
  begin
    exit;
  end;

  LBQC := nil;
  LQueryName := Utf8ToString(AQueryName);
  LBQC := MainForm.FBWQuery.GetQueryClass(AQueryName);
  AColCountOfRow := LBQC.BWQryRowHeaderCollect.ColCountOfRow;

  if Assigned(LBQC) then
    CopyObject(LBQC.BWQryRowHeaderCollect, AEPCollect);
end;

function TServiceBWQuery.GetSalesPlanPerProduct(
  out ACollect: TBWQryCellDataCollect): Boolean;
begin
  Result := False;

  if MainForm.FBWQuery.FOrderPlanPerProduct.Count > 0 then
  begin
    CopyObject(MainForm.FBWQuery.FSalesPlanPerProduct, ACollect);
    Result := True;
  end;
end;

end.
