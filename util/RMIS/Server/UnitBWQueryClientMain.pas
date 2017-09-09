unit UnitBWQueryClientMain;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, MSHTML, Activex,
  Vcl.ComCtrls, Vcl.StdCtrls, Vcl.Buttons, Vcl.ExtCtrls, TimerPool, OmniXML, OmniXMLUtils, OmniXMLXPath,
  AAFont, AACtrls, Vcl.OleCtrls, SHDocVw, IdHTTP, AdvGrid, DateUtils,
  SynCommons, mORMot, mORMotSQLite3, mORMotHttpServer,
  AdvOfficePager, Vcl.Menus, Generics.Collections, OtlTask,
  OtlCommon, OtlCollections, OtlParallel, OtlTaskControl, BW_Query_Class,
  tmsAdvGridExcel, UnitBWQueryInterface, UnitBWQueryConfig, UnitHhiOfficeNewsInterface,
  mORMotHttpClient, ralarm, Sea_Ocean_News_Class, UnitDPMSInfoClass, UnitIPCClientRMIS
;//  {$IFDEF USECODESITE} ,CodeSiteLogging {$ENDIF}

type

  TDisplayTarget = (dtSystemLog, dtConnectLog, dtCommLog, dtStatusBar);

  TServiceBWQuery = class(TInterfacedObject, IBWQuery)
  public
    function GetBWQryClass(AQueryName: RawUTF8; out ACount: Integer): TRawUTF8DynArray;
    function GetCellData(AQueryName: RawUTF8; out AEPCollect: TBWQryCellDataCollect): Boolean;
    function GetCellDataAll(out ABWQryCellDataAll: TBWQryCellDataAllCollect): Boolean;
    function GetRowHeaderData(AQueryName: RawUTF8; out AColCountOfRow: integer;  out AEPCollect: TBWQryRowHeaderCollect): Boolean;
    function GetColHeaderData(AQueryName: RawUTF8; out AEPCollect: TBWQryColumnHeaderCollect): Boolean;
    function GetOrderPlanPerProduct(out ACollect: TBWQryCellDataCollect): Boolean; //제품별 월별 수주 경영계획
    function GetSalesPlanPerProduct(out ACollect: TBWQryCellDataCollect): Boolean; //제품별 월별 매출 경영계획
    function GetProfitPlanPerProduct(out ACollect: TBWQryCellDataCollect): Boolean; //제품별 월별 손익 경영계획
    function GetNewsList2: TRawUTF8DynArray; //일간 조선 해양 뉴스
//    function GetAttachFileHhiOfficeNews(AFileName: RawUTF8): TServiceCustomAnswer; //일간 조선 해양 뉴스 첨부파일(pdf) 반환
    procedure GetAttachFileHhiOfficeNews2(AFileName:RawUTF8; out AFile: RawByteString); //일간 조선 해양 뉴스 첨부파일(pdf) 반환
    procedure GetHhiOfficeNewsList2(out ASeaOceanNewsCollect: TSONewsCollect);
    function GetDPMSInfo(AFrom, ATo: string): RawUTF8;
    function GetInquiryPerProdPerGrade: TRawUTF8DynArray; //등급별 제품별 Inquiry 금액
  end;

  TMainForm = class(TForm)
    AdvOfficePager1: TAdvOfficePager;
    AdvOfficePager11: TAdvOfficePage;
    AdvOfficePager12: TAdvOfficePage;
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
    BWQryFetchAlarm: TAlarmFromTo;
    Edit2: TEdit;

    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FCSServerStartBtnClick(Sender: TObject);
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
    procedure BWQryFetchAlarmAlarmBegin(Sender: TObject);
  private
    FPJHTimerPool: TPJHTimerPool;

    FXMLFromQry: string;
    FInquiryList: TDictionary<integer, TInquiryInfo>;
    FCurQryKey: String;//FBWQryList중에서 현재 실행 중인 Query Key string을 저장함

    procedure StartServer;
    procedure ProcessQueryXML(AXMLString: string; const task: IOmniTask);
    procedure LoadQueryListFromTxt;
    procedure LoadInquiryList(ABWQryClass: TBWQryClass);
    procedure ClearInqryList;
    function GetQueryClass(AQueryName: string): TBWQryClass;
    function GetCurQryClass: TBWQryClass;
    function GetQueryType(AQueryName: string): integer;
    procedure ChangeDataFormat;

    procedure OnGetBWQuery(Sender : TObject; Handle : Integer;
            Interval : Cardinal; ElapsedTime : LongInt);
    procedure OnAutoStart(Sender : TObject; Handle : Integer;
            Interval : Cardinal; ElapsedTime : LongInt);

    procedure OnGetBWQueryCompleted(const task: IOmniTaskControl);
    procedure OnGetOrderPlanPerProductCompleted(const task: IOmniTaskControl);
    procedure OnGetSalesPlanPerProductCompleted(const task: IOmniTaskControl);
    procedure OnGetProfitPlanPerProductCompleted(const task: IOmniTaskControl);
    procedure OnPulseEventCompleted(const task: IOmniTaskControl);

    procedure ExecuteGetBWQry;
    function GetBWQuery(const task: IOmniTask): boolean;
    function GetNewsService2: TRawUTF8DynArray;
    function SetQryParamType(AQryText: string; const AParamName: string;
      AParamType: TQryParameterType; AParamDir: TQryParameterDir; ADate: TDate): string;
    function GetEndOfMonth(ADate: TDate): string;
    function GetOrderPlanPerProduct(const task: IOmniTask): boolean;
    procedure _GetBizPlanPerProduct(AQryName: string; ARow: integer; ACollect: TBWQryCellDataCollect; AExcludeRow: integer = -1);
    function GetSalesPlanPerProduct(const task: IOmniTask): boolean;
    function GetProfitPlanPerProduct(const task: IOmniTask): boolean;
    function GetInquiryPerProdPerGrade: TRawUTF8DynArray; //등급별 제품별 Inquiry 금액

    function DoPulseEvent(const task: IOmniTask): boolean;
    procedure DisplayMessage(msg: string);
  protected
    FSettings : TConfigSettings;
//    FAutoStartTimerHandle: integer;
    FQryCount: integer;
    FGetBWQryFuture: IOmniFuture<Boolean>;

    FClient_HhiOfficeNews: TSQLRestClientURI;
    FModel_HhiOfficeNews: TSQLModel;
    Server_HhiOfficeNews: AnsiString;
    PortNum_HhiOfficeNews: string;
    FClient_Connected: Boolean;
    FNewsList2: TStringList;//일간조선해양 뉴스
    FIsServiceServer: Boolean;//True = TServiceBWQuery 서비스를 제공함
  public
    FBWQryList: TDictionary<string, TBWQryClass>;
    FGetQrying: Boolean;
    FSeaOceanNewsList2: TSONewsCollect;//일간조선해양 뉴스(TCollect 에 저장함 )
    FOrderPlanPerProduct: TBWQryCellDataCollect; //제품별 수주 경영계획
    FSalesPlanPerProduct: TBWQryCellDataCollect; //제품별 매출 경영계획
    FProfitPlanPerProduct: TBWQryCellDataCollect;//제품별 손익 경영계획
    FCellDataAllCollect: TBWQryCellDataAllCollect;

    FDPMSInfo: TDPMSInfo;
    FIPCClientRMIS: TIPCClientRMIS;

    procedure InitVar;
    procedure DestroyVar;
    function getContent(url: String): String;
    procedure QryData2DataView(AQueryName: string);
    procedure HeaderData2Grid(ABWQryClass: TBWQryClass; AGrid: TAdvStringGrid);
    procedure RowHeaderNCellData2Grid(ABWQryClass: TBWQryClass; AGrid: TAdvStringGrid);
    procedure ColumnHeaderNCellData2Grid(ABWQryClass: TBWQryClass; AGrid: TAdvStringGrid);
    function GetCellDataAll: TRawUTF8DynArray;

    procedure LoadConfigFromFile(AFileName: string = '');
    procedure LoadConfig2Form(AForm: TConfigF);
    procedure LoadConfigForm2Object(AForm: TConfigF);
    procedure SetConfig;
    procedure ApplyUI;

    procedure ConnectToHhiOfficeNewsServer;
    procedure CreateHTTPClient_HhiOfficeNews(AServerIP: string);
    procedure DestroyHTTPClient_HhiOfficeNews;
    procedure GetHhiOfficeNewsFromServer;

    function GetDPMSInfo(AFrom, ATo: string): RawUTF8;
  end;

var
  MainForm: TMainForm;
  g_GetCellDataAllRunning: Boolean;

implementation

uses UnitDataView, UnitDM, IPC_BWQry_Const;

{$R *.dfm}


procedure TMainForm.AlarmFromTo1AlarmBegin(Sender: TObject);
begin
  try
    GetHhiOfficeNewsFromServer;
  except
  end;
end;

procedure TMainForm.ApplyUI;
begin
  AlarmFromTo1.ActiveBegin := False;
  AlarmFromTo1.AlarmTimeBegin := FSettings.ServerTimeToGetHhiOfficeNews;
  AlarmFromTo1.ActiveBegin := True;
end;

procedure TMainForm.BWQryFetchAlarmAlarmBegin(Sender: TObject);
begin
  ExecuteGetBWQry;
end;

procedure TMainForm.HeaderData2Grid(ABWQryClass: TBWQryClass; AGrid: TAdvStringGrid);
var
  i, j, LCount, LCol, LRow: integer;
  LColX, LRowX, LSpanY: integer;
  LColX2, LRowX2, LSpanY2: integer;
  LStr, LMerge1, LMerge2: string;
begin
  LCount := ABWQryClass.BWQryRowHeaderCollect.ColCountOfRow;
  AGrid.ColCount := ABWQryClass.BWQryColumnHeaderCollect.Count+LCount;
  AGrid.RowCount := ABWQryClass.BWQryRowHeaderCollect.Count;
  AGrid.FixedCols := LCount;
  AGrid.FixedRows := 1;

  for i := 0 to ABWQryClass.BWQryColumnHeaderCollect.Count - 1 do
  begin
    LCol := LCount + i;
    LRow := 0;
    LStr := ABWQryClass.BWQryColumnHeaderCollect.Items[i].ColumnHeaderData;
    LStr := StringReplace(LStr, '수주액-', '', [rfReplaceAll, rfIgnoreCase]);
    AGrid.Cells[LCol, LRow] := LStr;
  end;

  LRowX := 1;
  LColX := 0;
  LMerge1 := 'A';
  LRowX2 := 1;
  LColX2 := 1;
  LMerge2 := 'AE';
  LSpanY := 0;
  LSpanY2 := 0;

  for i := 0 to ABWQryClass.BWQryRowHeaderCollect.Count - 1 do
  begin
    LStr := ABWQryClass.BWQryRowHeaderCollect.Items[i].RowHeaderData;

    for j := 0 to LCount - 1 do
    begin
      LCol := j;
      LRow := i+1;
      AGrid.Cells[LCol, LRow] := strToken(LStr, ';');

      if j = 0 then
      begin
        if LMerge1 <> AGrid.Cells[LCol, LRow] then
        begin
          AGrid.MergeCells(LColX, LRowX, 1, LSpanY);
          LSpanY := 1;
          LRowX := LRow;
          LColX := j;
          LMerge1 := AGrid.Cells[LCol, LRow];
        end
        else
        begin
          Inc(LSpanY);
        end;
      end
      else
      if j = 1 then
      begin
        if LMerge2 <> AGrid.Cells[LCol, LRow] then
        begin
          AGrid.MergeCells(LColX2, LRowX2, 1, LSpanY2);
          LSpanY2 := 1;
          LRowX2 := LRow;
          LColX2 := j;
          LMerge2 := AGrid.Cells[LCol, LRow];
        end
        else
        begin
          Inc(LSpanY2);
        end;
      end;
    end;
  end;
end;

//수주 일별 부문별;ZKA_ZKSDINM01_D_L_Q201 쿼리에만 해당 됨
procedure TMainForm.RowHeaderNCellData2Grid(ABWQryClass: TBWQryClass;
  AGrid: TAdvStringGrid);
var
  i, j, LCount, LCol, LRow: integer;
  LStr: string;
begin
  LCount := ABWQryClass.BWQryRowHeaderCollect.ColCountOfRow;
  AGrid.ColCount := ABWQryClass.BWQryColumnHeaderCollect.Count + LCount;
  AGrid.RowCount := ABWQryClass.BWQryRowHeaderCollect.Count;
  AGrid.FixedRows := 1;
  AGrid.FixedCols := 0;

  for i := 0 to ABWQryClass.BWQryRowHeaderCollect.Count - 1 do
  begin
    LStr := ABWQryClass.BWQryRowHeaderCollect.Items[i].RowHeaderData;

    for j := 0 to LCount - 1 do
    begin
      LCol := j;
      LRow := i+1;
      AGrid.Cells[LCol, LRow] := strToken(LStr, ';');
    end;
  end;

end;

procedure TMainForm.ChangeDataFormat;
var
  LKey, LStr: string;
  LBWQryClass: TBWQryClass;
  i: integer;
  Ldouble: double;
begin
  for LKey in FBWQryList.Keys do
  begin
    LBWQryClass := FBWQryList.Items[LKey];
    for i := 0 to LBWQryClass.BWQryCellDataCollect.Count - 1 do
    begin
      LStr := LBWQryClass.BWQryCellDataCollect.Items[i].CellData;

      if (LStr <> '') and (Pos('.', LStr) = 0) and (Pos(',', LStr) = 0)then
      begin
        Ldouble := StrToFloatDef(LStr,0.0);
        LBWQryClass.BWQryCellDataCollect.Items[i].CellData := FormatFloat('#,##0', Ldouble);
      end;
    end;
  end;
end;

procedure TMainForm.ClearInqryList;
var
  LKey: integer;
begin
  for LKey in FInquiryList.Keys do
    TInquiryInfo(FInquiryList.Items[LKey]).Free;

  FInquiryList.Clear;
end;

procedure TMainForm.Close1Click(Sender: TObject);
begin
  Close;
end;

procedure TMainForm.ColumnHeaderNCellData2Grid(ABWQryClass: TBWQryClass;
  AGrid: TAdvStringGrid);
var
  i, j, LCount, LCol, LRow: integer;
  LStr: string;
begin
//  LCount := ABWQryClass.BWQryColumnHeaderCollect.FixedColumnCount;
//  AGrid.RowCount := ABWQryClass.BWQryRowHeaderCollect.Count +
//    ABWQryClass.BWQryColumnHeaderCollect.FixedColumnCount;
  AGrid.ColCount := ABWQryClass.BWQryColumnHeaderCollect.Count;
  AGrid.FixedRows := ABWQryClass.BWQryColumnHeaderCollect.FixedColumnCount;
  AGrid.FixedCols := ABWQryClass.BWQryRowHeaderCollect.ColCountOfRow+1;

  LCount := 0;

//  for i := 0 to ABWQryClass.BWQryColumnHeaderCollect.Count - 1 do
//  begin
//    LStr := ABWQryClass.BWQryColumnHeaderCollect.Items[i].ColumnHeaderData;
//
//    if LCount <> ABWQryClass.BWQryColumnHeaderCollect.Items[i].ColumnHeaderLevel then
//      LCount := ABWQryClass.BWQryColumnHeaderCollect.Items[i].ColumnHeaderLevel;
//
//    for j := 0 to ABWQryClass.BWQryColumnHeaderCollect.FixedColumnCount - 1 do
//    begin
//      LCol := j + AGrid.FixedRows;
//      LRow := i + AGrid.FixedCols + LCount;
//      AGrid.Cells[LCol, LRow] := strToken(LStr, ';');
//    end;
//  end;

  for i := 0 to ABWQryClass.BWQryCellDataCollect.Count - 1 do
  begin
    LCol := ABWQryClass.BWQryCellDataCollect.Items[i].Col + AGrid.FixedCols;
    LRow := ABWQryClass.BWQryCellDataCollect.Items[i].Row + AGrid.FixedRows;
    AGrid.Cells[LCol, LRow] := ABWQryClass.BWQryCellDataCollect.Items[i].CellData;
  end;
end;

procedure TMainForm.Config1Click(Sender: TObject);
begin
  SetConfig;
end;

procedure TMainForm.ConnectToHhiOfficeNewsServer;
var
  Lip: string;
begin
  if FSettings.ServerIP_HhiOfficeNews <> '' then
    Lip := FSettings.ServerIP_HhiOfficeNews
  else
    Lip := 'localhost';

  CreateHTTPClient_HhiOfficeNews(Lip);
end;

procedure TMainForm.CreateHTTPClient_HhiOfficeNews(AServerIP: string);
begin
  if Assigned(FClient_HhiOfficeNews) then
    DestroyHTTPClient_HhiOfficeNews;

  if FClient_HhiOfficeNews = nil then
  begin
    if FModel_HhiOfficeNews = nil then
      FModel_HhiOfficeNews := TSQLModel.Create([],HHIOFFICE_ROOT_NAME);

    FClient_HhiOfficeNews := TSQLHttpClient.Create(AServerIP,HHIOFFICE_PORT_NAME, FModel_HhiOfficeNews);

    if not FClient_HhiOfficeNews.ServerTimeStampSynchronize then
    begin
      //ShowMessage(UTF8ToString(FClient_News.LastErrorMessage));
      DestroyHTTPClient_HhiOfficeNews;
      exit;
    end;

    //TSQLRestServerAuthenticationNone.ClientSetUser(Client,'User','');
    FClient_HhiOfficeNews.SetUser('User','synopse');//'BWQueryServer','BWQryServer');
    FClient_HhiOfficeNews.ServiceRegister([TypeInfo(IHhiOfficeNewsList)],sicShared);
    FClient_Connected := True;
  end;
end;

procedure TMainForm.DestroyHTTPClient_HhiOfficeNews;
begin
  if Assigned(FClient_HhiOfficeNews) then
    FreeAndNil(FClient_HhiOfficeNews);

  if Assigned(FModel_HhiOfficeNews) then
    FreeAndNil(FModel_HhiOfficeNews);

//  FCS.DisplayMessage(FormatDateTime('mm월 dd일, hh:nn:ss', now) + ' : ' + UTF8ToString(FClient_HhiOfficeNews.LastErrorMessage), dtSystemLog);
  DisplayMessage(FormatDateTime('mm월 dd일, hh:nn:ss', now) + ' : CreateHTTPClient_HhiOfficeNews');
  FClient_Connected := False;
end;

procedure TMainForm.DestroyVar;
var
  LKey: string;
begin
  FPJHTimerPool.RemoveAll;
  FPJHTimerPool.Free;
  FSettings.Free;

  ClearInqryList;

  FInquiryList.Free;

  for LKey in FBWQryList.Keys do
    TBWQryClass(FBWQryList.Items[LKey]).Free;

  FBWQryList.Free;
  FNewsList2.Free;
  FSeaOceanNewsList2.Free;
  FOrderPlanPerProduct.Free;
  FSalesPlanPerProduct.Free;
  FProfitPlanPerProduct.Free;
  FCellDataAllCollect.Free;
  FDPMSInfo.Free;
  FIPCClientRMIS.Free;
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

function TMainForm.DoPulseEvent(const task: IOmniTask): boolean;
var
  LEventData: TEventData_BWQry;
begin
  LEventData.FBWQryClass := UTF8ToString(ObjectToJSon(FCellDataAllCollect));
  FIPCClientRMIS.PulseEventData(LEventData);
end;

procedure TMainForm.ExecuteGetBWQry;
begin
  Memo1.Lines.Clear;
  DisplayMessage(FormatDateTime('mm월 dd일, hh:nn:ss => ', now) + '=================');

  FGetBWQryFuture := Parallel.Future<Boolean>(GetBWQuery, Parallel.TaskConfig.OnTerminated(OnGetBWQueryCompleted));
//  Parallel.Async(GetBWQuery, Parallel.TaskConfig.OnTerminated(OnGetBWQueryCompleted));
end;

procedure TMainForm.FCSJvXPButton6Click(Sender: TObject);
begin
  FGetBWQryFuture.Cancel;
  FGetBWQryFuture.WaitFor(INFINITE);
  FGetBWQryFuture := nil;
  ShowMessage('Calceled!');
end;

procedure TMainForm.FCSServerStartBtnClick(Sender: TObject);
begin
  StartServer;
end;

procedure TMainForm.FormActivate(Sender: TObject);
begin
  GetHhiOfficeNewsFromServer;
end;

procedure TMainForm.FormCreate(Sender: TObject);
begin
  InitVar;
end;

procedure TMainForm.FormDestroy(Sender: TObject);
begin
  DestroyVar;
end;

function TMainForm.GetBWQuery(const task: IOmniTask): boolean;
var
  WaitResult: Integer;
  LKey, LQryTxt, LNewQryTxt: string;
  LQryParamType: TQryParameterType;
begin
//  QProgress1.Active := True;
//  FQryRunning := True;
//  Panel1.Caption := '자료 갱신 중...';
  {$IFDEF USECODESITE}
  CodeSite.EnterMethod('TMainForm.GetBWQuery Begin ===>');
  try
//    CodeSite.Send('Msg.WParam', Ord(LDragCopyMode));
  finally
    CodeSite.ExitMethod('TTMainForm.GetBWQuery <===');
  end;
  {$ENDIF}
  FGetQrying := True;
  FQryCount := 0;

  for LKey in FBWQryList.Keys do
  begin
    if task.CancellationToken.IsSignalled then
      break;

    LQryTxt := FBWQryList.Items[LKey].QueryText;
    LQryParamType := FBWQryList.Items[LKey].QryParamType;

    if Pos('VAR_VALUE_LOW_EXT_2=', LQryTxt) > 0  then
    begin
      LQryTxt := SetQryParamType(LQryTxt, 'VAR_VALUE_LOW_EXT_2=', LQryParamType, qpdBegin, Date);
//      LNewQryTxt :=  + FormatDateTime('yyyy', Date) + '0101';
//      LQryTxt := StringReplace(LQryTxt, 'VAR_VALUE_LOW_EXT_2=', LNewQryTxt, [rfReplaceAll, rfIgnoreCase]);
    end;

    if Pos('VAR_VALUE_HIGH_EXT_2=', LQryTxt) > 0  then
    begin
//      LNewQryTxt := 'VAR_VALUE_HIGH_EXT_2=' + FormatDateTime('yyyymmdd', now);
      LQryTxt := SetQryParamType(LQryTxt, 'VAR_VALUE_HIGH_EXT_2=', LQryParamType, qpdCustom, Date);
//      StringReplace(LQryTxt, 'VAR_VALUE_HIGH_EXT_2=', LNewQryTxt, [rfReplaceAll, rfIgnoreCase]);
    end;

    if Pos('VAR_VALUE_EXT_1=', LQryTxt) > 0  then
    begin
//      LNewQryTxt := 'VAR_VALUE_EXT_1=' + FormatDateTime('yyyymmdd', now);
//      LQryTxt := StringReplace(LQryTxt, 'VAR_VALUE_EXT_1=', LNewQryTxt, [rfReplaceAll, rfIgnoreCase]);
      LQryTxt := SetQryParamType(LQryTxt, 'VAR_VALUE_EXT_1=', LQryParamType, qpdCustom, Date);
    end;

    if Pos('VAR_VALUE_LOW_EXT_1=', LQryTxt) > 0  then
    begin
//      LNewQryTxt := 'VAR_VALUE_LOW_EXT_1=' + FormatDateTime('yyyymmdd', now-1);
//      LQryTxt := StringReplace(LQryTxt, 'VAR_VALUE_LOW_EXT_1=', LNewQryTxt, [rfReplaceAll, rfIgnoreCase]);
      LQryTxt := SetQryParamType(LQryTxt, 'VAR_VALUE_LOW_EXT_1=', LQryParamType, qpdBegin, Date-1);
    end;

    if Pos('VAR_VALUE_HIGH_EXT_1=', LQryTxt) > 0  then
    begin
//      LNewQryTxt := 'VAR_VALUE_HIGH_EXT_1=' + FormatDateTime('yyyymmdd', now);
//      LQryTxt := StringReplace(LQryTxt, 'VAR_VALUE_HIGH_EXT_1=', LNewQryTxt, [rfReplaceAll, rfIgnoreCase]);
      LQryTxt := SetQryParamType(LQryTxt, 'VAR_VALUE_HIGH_EXT_1=', LQryParamType, qpdEnd, Date);
    end;

    FXMLFromQry := GetContent(LQryTxt);

    task.Invoke(
      procedure
      begin
        DisplayMessage(LQryTxt + #13#10);
        DisplayMessage('============================================================================');
        DisplayMessage(FXMLFromQry);
        DisplayMessage('============================================================================');
      end);
    FCurQryKey := LKey;
    ProcessQueryXML(FXMLFromQry, task);

    Inc(FQryCount);
  end;
  {$IFDEF USECODESITE}
  CodeSite.EnterMethod('TMainForm.GetBWQuery End ===>');
  try
//    CodeSite.Send('Msg.WParam', Ord(LDragCopyMode));
  finally
    CodeSite.ExitMethod('TMainForm.GetBWQuery <===');
  end;
  {$ENDIF}
end;

function TMainForm.GetCellDataAll: TRawUTF8DynArray;
var
  LKey: string;
  LCount: integer;
  LDynArr: TDynArray;
  LValue: RawUTF8;
  LItem: TBWQryCellDataAllItem;
begin
  LDynArr.Init(TypeInfo(TRawUTF8DynArray), Result, @LCount);
  FCellDataAllCollect.Clear;

  for LKey in FBWQryList.Keys do
  begin
    LValue := ObjectToJSon(FBWQryList.Items[LKey].BWQryCellDataCollect);
    LItem := FCellDataAllCollect.Add;
    LItem.ObjectJSON := UTF8ToString(LValue);
    LItem.QryName := LKey;
    LDynArr.Add(LValue);
  end;
end;

function TMainForm.getContent(url: String): String;
var
  LIdHTTP: TIdHTTP;
begin
  LIdHTTP := TIdHTTP.Create(nil);
  LIdHTTP.HandleRedirects := True;
  try
    try
      Result := LIdHTTP.Get(url);
    except

    end;
  finally
    LIdHTTP.Free;
  end;
end;

function TMainForm.GetCurQryClass: TBWQryClass;
var
  LKey: string;
begin
  for LKey in FBWQryList.Keys do
  begin
    if FCurQryKey = FBWQryList.Items[LKey].QueryName then
    begin
      Result := FBWQryList.Items[LKey];
      break;
    end;
  end;
end;

function TMainForm.GetDPMSInfo(AFrom, ATo: string): RawUTF8;
var
  LSql: string;
  i: integer;
begin
  // 날짜별 사용실적
  LSql := ' select stday,sum(cnt) ccc ' +
          ' from ( ' +
          '   SELECT empno,substr(stdate,1,8) stday,count(*) cnt ' +
          '   FROM KX01.GTAA003 ' +
          '   WHERE SYSID = ''A13'' ' +
          '        and stdate >= :F ' +
          '        and stdate <= :T ' +
          '   group by empno,substr(stdate,1,8) ' +
          ' ) a, KX01.GTAA004 b ' +
          ' where a.empno = b.empno ' +
          '       and b.dept != ''KX60'' ' +
          ' group by stday';

  with DM1.DPMSQuery1 do
  begin
    Close;
    SQL.Clear;
    SQL.Add(LSql);
    ParamByName('F').AsString := AFrom;
    ParamByName('T').AsString := ATo;
    Open;

    if RecordCount > 0 then
    begin
      FDPMSInfo.DPMSUsagePerDateCollect.Clear;
//      FDPMSInfo.DPMSUsagePerDeptCollect.Clear;

      for i := 0 to RecordCount - 1 do
      begin
        with FDPMSInfo.DPMSUsagePerDateCollect.Add do
        begin
          FFDate := FieldByName('stday').AsString;
          UsageCount := FieldByName('ccc').AsInteger;
        end;

        Next;
      end;
    end;

    LSql := ' select a.dept,a.deptnm,d.cnt dept_emp_cnt, ' +
            ' e.cnt, count(a.prjt_id) prjt_cnt,sum(b.cnt) task_cnt ' +
            ' from dpms_prjt a, ' +
            '     (select prjt_id,count(*) cnt ' +
            '      from dpms_prjt_task ' +
            '      group by prjt_id) b, KX01.GTAA004 c, ' +
            '               (SELECT dept,count(*) cnt FROM KX01.GTAA004 ' +
            '                where dept = ''AK00'' or division = ''K'' and statcd = 1 ' +
            '                group by dept) d, ' +
            '     (select dept,count(empno) cnt ' +
            '      from (select distinct b.dept,a.empno from KX01.GTAA003 a, ' +
            '           kx01.gtaa004 b where a.empno = b.empno and ' +
            '           a. SYSID = ''A13'') ' +
            '      group by dept) e ' +
            ' where a.prjt_id = b.prjt_id ' +
            '   and a.reger = c.empno ' +
            '   and a.dept = d.dept ' +
            '   and a.dept = e.dept ' +
            '   and a.dept != ''KX60'' ' +
            ' group by a.dept,a.deptnm,d.cnt,e.cnt ';

    Close;
    SQL.Clear;
    SQL.Add(LSql);
    Open;

    if RecordCount > 0 then
    begin
      FDPMSInfo.DPMSUsagePerDeptCollect.Clear;

      for i := 0 to RecordCount - 1 do
      begin
        with FDPMSInfo.DPMSUsagePerDeptCollect.Add do
        begin
          Dept := FieldByName('DEPTNM').AsString;
          UserCount := FieldByName('CNT').AsInteger;
          ProjCount := FieldByName('PRJT_CNT').AsInteger;
          TaskCount := FieldByName('TASK_CNT').AsInteger;
        end;

        Next;
      end;
    end;
  end;

  Result := ObjectToJson(FDPMSInfo);
end;

function TMainForm.GetEndOfMonth(ADate: TDate): string;
begin
  Result := IntToStr(MonthDays[IsLeapYear(YearOf(ADate)), MonthOf(ADate)]);
end;

procedure TMainForm.GetHhiOfficeNewsFromServer;
var
  I: IHhiOfficeNewsList;
  LDynArr: TRawUTF8DynArray;
  Li,LRow: integer;
  LStr: string;
  LSCA: TServiceCustomAnswer;
begin
  LDynArr := nil;

  if not Assigned(FClient_HhiOfficeNews) then
  begin
    try
      ConnectToHhiOfficeNewsServer;
    except
      on E: Exception do
      begin
        DestroyHTTPClient_HhiOfficeNews;
        DisplayMessage(FormatDateTime('mm월 dd일, hh:nn:ss', now) + ' : ' + E.Message);
        DisplayMessage(FormatDateTime('mm월 dd일, hh:nn:ss', now) + ' : DestroyHTTPClient_News');
        exit;
      end;
    end;
  end;

  if not Assigned(FClient_HhiOfficeNews) then
  begin
    DisplayMessage(FormatDateTime('mm월 dd일, hh:nn:ss', now) + ' : GetNewsFromServer Error => not Assigned(FClient_HhiOfficeNews)');
    exit;
  end;

  I := FClient_HhiOfficeNews.Service<IHhiOfficeNewsList>;

  try
    if I <> nil then
      I.GetHhiOfficeNewsList2(FSeaOceanNewsList2);
//      LDynArr := I.GetHhiOfficeNewsList;

  except
    on E: Exception do
    begin
      DestroyHTTPClient_HhiOfficeNews;
      DisplayMessage(FormatDateTime('mm월 dd일, hh:nn:ss', now) + ' : ' + E.Message);
      DisplayMessage(FormatDateTime('mm월 dd일, hh:nn:ss', now) + ' : DestroyHTTPClient_News');
      exit;
    end;
  end;

//  FNewsList2.Clear;

  DisplayMessage(DateTimeToStr(Now) + ' : GetHhiOfficeNewsFromServer [ ' + IntToStr(FSeaOceanNewsList2.Count) + ' 개 뉴스 수신 ]');
//  for Li := 0 to High(LDynArr) - 1 do
  for Li := 0 to FSeaOceanNewsList2.Count - 1 do
  begin
    DisplayMessage(DateTimeToStr(Now) + ' : 일간조선해양뉴스: ' + FSeaOceanNewsList2.Items[Li].NewsContent);
//    if LDynArr[Li] <> '' then
//    begin
//      LStr := Utf8ToString(LDynArr[Li]);
//      LStr := StringReplace(LStr, '- ', '', [rfReplaceAll, rfIgnoreCase]);
//      FNewsList2.Add(LStr);
//    end;
  end;

//  FCS.DisplayMessage(DateTimeToStr(Now) + ' : GetHhiOfficeNewsFromServer [ ' + IntToStr(FNewsList2.Count) + ' 개 뉴스 수신 ]', dtCommLog);

//  for Li := 0 to FNewsList2.Count - 1 do
//    FCS.DisplayMessage(DateTimeToStr(Now) + ' : 일간조선해양뉴스: ' + FNewsList2.Strings[Li], dtCommLog);

  try
    if I <> nil then
    begin
      LSCA := I.GetAttachFileHhiOfficeNews('');
      FileFromString(LSCA.Content, SHIP_OCEAN_PDF_FILE);
    end;
  except
    on E: Exception do
    begin
      DestroyHTTPClient_HhiOfficeNews;
      DisplayMessage(FormatDateTime('mm월 dd일, hh:nn:ss', now) + ' : ' + E.Message);
      DisplayMessage(FormatDateTime('mm월 dd일, hh:nn:ss', now) + ' : DestroyHTTPClient_News');
      exit;
    end;
  end;

  I := nil;
  DestroyHTTPClient_HhiOfficeNews;
end;

function TMainForm.GetInquiryPerProdPerGrade: TRawUTF8DynArray;
const
  ExchangeRate4USD = 1080;
var
  LBWQryClass: TBWQryClass;
  LCount: integer;
  LDynArr: TDynArray;
  LValue: RawUTF8;
  i,j: integer;
  LSum : array of array of extended; //박용기계 등급별 누계 금액
  LStr: string;
begin
  LDynArr.Init(TypeInfo(TRawUTF8DynArray),Result,@LCount);

  LBWQryClass := nil;
  LBWQryClass := GetQueryClass('ZKA_ZKSDINM01_D_T_Q201_1');

  if Assigned(LBWQryClass) then
  begin
    SetLength(LSum, 4, 9);
//    FillChar(LSum, Length(LSum), 0);  //에러 남, 원인 모름(초기화는 자동으로 됨)
    try
      for i := 0 to LBWQryClass.BWQryCellDataCollect.Count - 1 do
      begin
        if LBWQryClass.BWQryCellDataCollect.Items[i].CellData = '' then
          continue;

        //박용기계
        if ((LBWQryClass.BWQryCellDataCollect.Items[i].Row >= 1) and (LBWQryClass.BWQryCellDataCollect.Items[i].Row <= 6)) then
        begin
          if (LBWQryClass.BWQryCellDataCollect.Items[i].Col = 5) then
            LSum[0,0] := LSum[0,0] + StrToFloatDef(LBWQryClass.BWQryCellDataCollect.Items[i].CellData, 0.0)//A 등급 년누계($)
          else
          if (LBWQryClass.BWQryCellDataCollect.Items[i].Col = 11) then
            LSum[0,1] := LSum[0,1] + StrToFloatDef(LBWQryClass.BWQryCellDataCollect.Items[i].CellData, 0.0)//A2 등급 년누계($)
          else
          if (LBWQryClass.BWQryCellDataCollect.Items[i].Col = 17) then
            LSum[0,2] := LSum[0,2] + StrToFloatDef(LBWQryClass.BWQryCellDataCollect.Items[i].CellData, 0.0)//B 등급 년누계($)
          else
          if (LBWQryClass.BWQryCellDataCollect.Items[i].Col = 23) then
            LSum[0,3] := LSum[0,3] + StrToFloatDef(LBWQryClass.BWQryCellDataCollect.Items[i].CellData, 0.0)//B1 등급 년누계($)
          else
          if (LBWQryClass.BWQryCellDataCollect.Items[i].Col = 29) then
            LSum[0,4] := LSum[0,4] + StrToFloatDef(LBWQryClass.BWQryCellDataCollect.Items[i].CellData, 0.0)//C 등급 년누계($)
          else
          if (LBWQryClass.BWQryCellDataCollect.Items[i].Col = 35) then
            LSum[0,5] := LSum[0,5] + StrToFloatDef(LBWQryClass.BWQryCellDataCollect.Items[i].CellData, 0.0)//D 등급 년누계($)
          else
          if (LBWQryClass.BWQryCellDataCollect.Items[i].Col = 41) then
            LSum[0,6] := LSum[0,6] + StrToFloatDef(LBWQryClass.BWQryCellDataCollect.Items[i].CellData, 0.0)//FO 등급 년누계($)
          else
          if (LBWQryClass.BWQryCellDataCollect.Items[i].Col = 47) then
            LSum[0,7] := LSum[0,7] + StrToFloatDef(LBWQryClass.BWQryCellDataCollect.Items[i].CellData, 0.0)//S 등급 년누계($)
          else
          if (LBWQryClass.BWQryCellDataCollect.Items[i].Col = 53) then
            LSum[0,8] := LSum[0,8] + StrToFloatDef(LBWQryClass.BWQryCellDataCollect.Items[i].CellData, 0.0);//기타 등급 년누계($)
        end
        else//엔진발전
        if ((LBWQryClass.BWQryCellDataCollect.Items[i].Row >= 7) and (LBWQryClass.BWQryCellDataCollect.Items[i].Row <= 12)) then
        begin
          if (LBWQryClass.BWQryCellDataCollect.Items[i].Col = 5) then
            LSum[1,0] := LSum[1,0] + StrToFloatDef(LBWQryClass.BWQryCellDataCollect.Items[i].CellData, 0.0)//A 등급 년누계($)
          else
          if (LBWQryClass.BWQryCellDataCollect.Items[i].Col = 11) then
            LSum[1,1] := LSum[1,1] + StrToFloatDef(LBWQryClass.BWQryCellDataCollect.Items[i].CellData, 0.0)//A2 등급 년누계($)
          else
          if (LBWQryClass.BWQryCellDataCollect.Items[i].Col = 17) then
            LSum[1,2] := LSum[1,2] + StrToFloatDef(LBWQryClass.BWQryCellDataCollect.Items[i].CellData, 0.0)//B 등급 년누계($)
          else
          if (LBWQryClass.BWQryCellDataCollect.Items[i].Col = 23) then
            LSum[1,3] := LSum[1,3] + StrToFloatDef(LBWQryClass.BWQryCellDataCollect.Items[i].CellData, 0.0)//B1 등급 년누계($)
          else
          if (LBWQryClass.BWQryCellDataCollect.Items[i].Col = 29) then
            LSum[1,4] := LSum[1,4] + StrToFloatDef(LBWQryClass.BWQryCellDataCollect.Items[i].CellData, 0.0)//C 등급 년누계($)
          else
          if (LBWQryClass.BWQryCellDataCollect.Items[i].Col = 35) then
            LSum[1,5] := LSum[1,5] + StrToFloatDef(LBWQryClass.BWQryCellDataCollect.Items[i].CellData, 0.0)//D 등급 년누계($)
          else
          if (LBWQryClass.BWQryCellDataCollect.Items[i].Col = 41) then
            LSum[1,6] := LSum[1,6] + StrToFloatDef(LBWQryClass.BWQryCellDataCollect.Items[i].CellData, 0.0)//FO 등급 년누계($)
          else
          if (LBWQryClass.BWQryCellDataCollect.Items[i].Col = 47) then
            LSum[1,7] := LSum[1,7] + StrToFloatDef(LBWQryClass.BWQryCellDataCollect.Items[i].CellData, 0.0)//S 등급 년누계($)
          else
          if (LBWQryClass.BWQryCellDataCollect.Items[i].Col = 53) then
            LSum[1,8] := LSum[1,8] + StrToFloatDef(LBWQryClass.BWQryCellDataCollect.Items[i].CellData, 0.0);//기타 등급 년누계($)
        end
        else//산업기계
        if ((LBWQryClass.BWQryCellDataCollect.Items[i].Row >= 13) and (LBWQryClass.BWQryCellDataCollect.Items[i].Row <= 15)) then
        begin
          if (LBWQryClass.BWQryCellDataCollect.Items[i].Col = 5) then
            LSum[2,0] := LSum[2,0] + StrToFloatDef(LBWQryClass.BWQryCellDataCollect.Items[i].CellData, 0.0)//A 등급 년누계($)
          else
          if (LBWQryClass.BWQryCellDataCollect.Items[i].Col = 11) then
            LSum[2,1] := LSum[2,1] + StrToFloatDef(LBWQryClass.BWQryCellDataCollect.Items[i].CellData, 0.0)//A2 등급 년누계($)
          else
          if (LBWQryClass.BWQryCellDataCollect.Items[i].Col = 17) then
            LSum[2,2] := LSum[2,2] + StrToFloatDef(LBWQryClass.BWQryCellDataCollect.Items[i].CellData, 0.0)//B 등급 년누계($)
          else
          if (LBWQryClass.BWQryCellDataCollect.Items[i].Col = 23) then
            LSum[2,3] := LSum[2,3] + StrToFloatDef(LBWQryClass.BWQryCellDataCollect.Items[i].CellData, 0.0)//B1 등급 년누계($)
          else
          if (LBWQryClass.BWQryCellDataCollect.Items[i].Col = 29) then
            LSum[2,4] := LSum[2,4] + StrToFloatDef(LBWQryClass.BWQryCellDataCollect.Items[i].CellData, 0.0)//C 등급 년누계($)
          else
          if (LBWQryClass.BWQryCellDataCollect.Items[i].Col = 35) then
            LSum[2,5] := LSum[2,5] + StrToFloatDef(LBWQryClass.BWQryCellDataCollect.Items[i].CellData, 0.0)//D 등급 년누계($)
          else
          if (LBWQryClass.BWQryCellDataCollect.Items[i].Col = 41) then
            LSum[2,6] := LSum[2,6] + StrToFloatDef(LBWQryClass.BWQryCellDataCollect.Items[i].CellData, 0.0)//FO 등급 년누계($)
          else
          if (LBWQryClass.BWQryCellDataCollect.Items[i].Col = 47) then
            LSum[2,7] := LSum[2,7] + StrToFloatDef(LBWQryClass.BWQryCellDataCollect.Items[i].CellData, 0.0)//S 등급 년누계($)
          else
          if (LBWQryClass.BWQryCellDataCollect.Items[i].Col = 53) then
            LSum[2,8] := LSum[2,8] + StrToFloatDef(LBWQryClass.BWQryCellDataCollect.Items[i].CellData, 0.0);//기타 등급 년누계($)
        end
        else//로봇시스템
        if ((LBWQryClass.BWQryCellDataCollect.Items[i].Row >= 16) and (LBWQryClass.BWQryCellDataCollect.Items[i].Row <= 20)) then
        begin
          if (LBWQryClass.BWQryCellDataCollect.Items[i].Col = 5) then
            LSum[3,0] := LSum[3,0] + StrToFloatDef(LBWQryClass.BWQryCellDataCollect.Items[i].CellData, 0.0)//A 등급 년누계($)
          else
          if (LBWQryClass.BWQryCellDataCollect.Items[i].Col = 11) then
            LSum[3,1] := LSum[3,1] + StrToFloatDef(LBWQryClass.BWQryCellDataCollect.Items[i].CellData, 0.0)//A2 등급 년누계($)
          else
          if (LBWQryClass.BWQryCellDataCollect.Items[i].Col = 17) then
            LSum[3,2] := LSum[3,2] + StrToFloatDef(LBWQryClass.BWQryCellDataCollect.Items[i].CellData, 0.0)//B 등급 년누계($)
          else
          if (LBWQryClass.BWQryCellDataCollect.Items[i].Col = 23) then
            LSum[3,3] := LSum[3,3] + StrToFloatDef(LBWQryClass.BWQryCellDataCollect.Items[i].CellData, 0.0)//B1 등급 년누계($)
          else
          if (LBWQryClass.BWQryCellDataCollect.Items[i].Col = 29) then
            LSum[3,4] := LSum[3,4] + StrToFloatDef(LBWQryClass.BWQryCellDataCollect.Items[i].CellData, 0.0)//C 등급 년누계($)
          else
          if (LBWQryClass.BWQryCellDataCollect.Items[i].Col = 35) then
            LSum[3,5] := LSum[3,5] + StrToFloatDef(LBWQryClass.BWQryCellDataCollect.Items[i].CellData, 0.0)//D 등급 년누계($)
          else
          if (LBWQryClass.BWQryCellDataCollect.Items[i].Col = 41) then
            LSum[3,6] := LSum[3,6] + StrToFloatDef(LBWQryClass.BWQryCellDataCollect.Items[i].CellData, 0.0)//FO 등급 년누계($)
          else
          if (LBWQryClass.BWQryCellDataCollect.Items[i].Col = 47) then
            LSum[3,7] := LSum[3,7] + StrToFloatDef(LBWQryClass.BWQryCellDataCollect.Items[i].CellData, 0.0)//S 등급 년누계($)
          else
          if (LBWQryClass.BWQryCellDataCollect.Items[i].Col = 53) then
            LSum[3,8] := LSum[3,8] + StrToFloatDef(LBWQryClass.BWQryCellDataCollect.Items[i].CellData, 0.0);//기타 등급 년누계($)
        end
      end;

      for i := Low(LSum) to High(LSum) do
      begin
        for j := Low(LSum[0]) to High(LSum[0]) do
        begin
          LValue := StringToUTF8(FormatFloat(',0', LSum[i,j]/100000000 * ExchangeRate4USD));  //단위 억원
          LDynArr.Add(LValue);
        end;
      end;
    finally
      LSum := nil;
    end;

//      LStr := IntToStr(LBWQryClass.BWQryCellDataCollect.Items[i].Col) + ':' +
//      IntToStr(LBWQryClass.BWQryCellDataCollect.Items[i].Row) + ' = ' +
//      LBWQryClass.BWQryCellDataCollect.Items[i].CellData;
//      Memo1.Lines.Add(LStr);

  end;

  DisplayMessage(DateTimeToStr(Now) + ' : GetInquiryPerProdPerGrade [ ' + IntToStr(LDynArr.Count) + ' 개 데이터 전송 ]');
end;

function TMainForm.GetNewsService2: TRawUTF8DynArray;
var
  LCount: integer;
  LDynArr: TDynArray;
  LValue: RawUTF8;
  i: integer;
begin
  LDynArr.Init(TypeInfo(TRawUTF8DynArray),Result,@LCount);

  LValue := '일간조선해양 ( Updated:  ' + FormatDateTime('mm월 dd일, hh:nn:ss', now) + ' )';
  LDynArr.Add(LValue);

  for i := 0 to FNewsList2.Count - 1 do
  begin
    LValue := StringToUTF8(FNewsList2.Strings[i]);
    LDynArr.Add(LValue);
  end;

  DisplayMessage(DateTimeToStr(Now) + ' : GetNewsService2 [ ' + IntToStr(FNewsList2.Count) + ' 개 뉴스 전송 ]');
end;

function TMainForm.GetOrderPlanPerProduct(const task: IOmniTask): boolean;
begin
  if FQryCount = 0 then
    exit;

  FOrderPlanPerProduct.Clear;

  _GetBizPlanPerProduct('ZKA_ZKSDSOM01_D_C_Q201', 7, FOrderPlanPerProduct);
  _GetBizPlanPerProduct('ZKA_ZKSDSOM01_D_C_Q203', 7, FOrderPlanPerProduct);
  //산업기계실적/계획 데이터에서 "기어박스" 항목이 빠짐 따라서 ARow값을 4->3으로 수정함
  _GetBizPlanPerProduct('ZKA_ZKSDSOM01_D_C_Q206', 3, FOrderPlanPerProduct);
  _GetBizPlanPerProduct('ZKA_ZKSDSOM01_D_C_Q208', 6, FOrderPlanPerProduct);
  _GetBizPlanPerProduct('ZKA_ZKSDSOM01_D_C_Q218_1', 5, FOrderPlanPerProduct);
end;

function TMainForm.GetProfitPlanPerProduct(const task: IOmniTask): boolean;
begin
  if FQryCount = 0 then
    exit;

  FProfitPlanPerProduct.Clear;

  _GetBizPlanPerProduct('ZKA_ZKEISM003_D_C_Q001_1', 0, FProfitPlanPerProduct,6);
end;

function TMainForm.GetQueryClass(AQueryName: string): TBWQryClass;
var
  LKey: string;
begin
  for LKey in FBWQryList.Keys do
  begin
//    if FBWQryList.Items[LKey].QueryName = AQueryName then
    if LKey = AQueryName then
    begin
      FCurQryKey := LKey;
      Result := GetCurQryClass;
      exit;
    end;
  end;
end;

function TMainForm.GetQueryType(AQueryName: string): integer;
var
  LKey: string;
begin
  for LKey in FBWQryList.Keys do
  begin
    if FCurQryKey = FBWQryList.Items[LKey].QueryName then
    begin
      Result := FBWQryList.Items[LKey].QueryType;
      break;
    end;
  end;
end;

function TMainForm.GetSalesPlanPerProduct(const task: IOmniTask): boolean;
begin
  if FQryCount = 0 then
    exit;

  FSalesPlanPerProduct.Clear;

  _GetBizPlanPerProduct('ZKA_ZKSDBIM01_D_C_Q225_1', 0, FSalesPlanPerProduct, 5);
end;

procedure TMainForm.Header1Click(Sender: TObject);
begin
  QryData2DataView(TMenuItem(Sender).Hint);
end;

procedure TMainForm.Header2Click(Sender: TObject);
begin
  QryData2DataView(TMenuItem(Sender).Hint);
end;

procedure TMainForm.HEADER3Click(Sender: TObject);
begin
  QryData2DataView(TMenuItem(Sender).Hint);
end;

procedure TMainForm.InitVar;
begin
  FIsServiceServer := False;

  FSettings := TConfigSettings.create(ChangeFileExt(Application.ExeName, '.ini'));
  LoadConfigFromFile;
  FPJHTimerPool := TPJHTimerPool.Create(nil);
  FBWQryList := TDictionary<string, TBWQryClass>.Create;
  FInquiryList := TDictionary<integer, TInquiryInfo>.Create;
  FNewsList2 := TStringList.Create;
  FOrderPlanPerProduct := TBWQryCellDataCollect.Create(TBWQryCellDataItem);
  FSalesPlanPerProduct := TBWQryCellDataCollect.Create(TBWQryCellDataItem);
  FProfitPlanPerProduct := TBWQryCellDataCollect.Create(TBWQryCellDataItem);
  FCellDataAllCollect := TBWQryCellDataAllCollect.Create(TBWQryCellDataAllItem);

  LoadQueryListFromTxt;
  FPJHTimerPool.AddOneShot(OnGetBWQuery, 500);

  TJSONSerializer.RegisterCollectionForJSON(TBWQryColumnHeaderCollect, TBWQryColumnHeaderItem);
  TJSONSerializer.RegisterCollectionForJSON(TBWQryRowHeaderCollect, TBWQryRowHeaderItem);
  TJSONSerializer.RegisterCollectionForJSON(TBWQryCellDataCollect, TBWQryCellDataItem);
  TJSONSerializer.RegisterCollectionForJSON(TBWQryCellDataAllCollect, TBWQryCellDataAllItem);
  TJSONSerializer.RegisterCollectionForJSON(TSONewsCollect, TSONewsItem);

  FSeaOceanNewsList2 := TSONewsCollect.Create(TSONewsItem);

  FDPMSInfo := TDPMSInfo.Create(Self);
  FIPCClientRMIS := TIPCClientRMIS.Create;

  if FIsServiceServer then
  begin

  end;

  if FSettings.ServerTimeToGetHhiOfficeNews <> '' then
  begin
    AlarmFromTo1.AlarmTimeBegin := FSettings.ServerTimeToGetHhiOfficeNews;
    AlarmFromTo1.ActiveBegin := True;
  end;

end;

procedure TMainForm.LoadConfig2Form(AForm: TConfigF);
begin
  FSettings.LoadConfig2Form(AForm, FSettings);
  AForm.BWQryRG.ItemIndex := FSettings.BWQryFetchType;
  AForm.BWQryRGClick(nil);
end;

procedure TMainForm.LoadConfigForm2Object(AForm: TConfigF);
begin
  FSettings.LoadConfigForm2Object(AForm, FSettings);
  FSettings.BWQryFetchType := AForm.BWQryRG.ItemIndex;
end;

procedure TMainForm.LoadConfigFromFile(AFileName: string);
begin
  FSettings.Load(AFileName);
end;

procedure TMainForm.LoadInquiryList(ABWQryClass: TBWQryClass);
var
  LInquiryInfo: TInquiryInfo;
  i, LRow, LCount: integer;
  LStr: string;
begin
  ClearInqryList;
  LCount := ABWQryClass.BWQryRowHeaderCollect.ColCountOfRow;

  for i := 0 to ABWQryClass.BWQryRowHeaderCollect.Count - 1 do
  begin
    LStr := ABWQryClass.BWQryRowHeaderCollect.Items[i].RowHeaderData;

    LInquiryInfo := TInquiryInfo.Create;
    LInquiryInfo.FRow := i+1;
    LInquiryInfo.ProductCategory := strToken(LStr, ';');
    LInquiryInfo.ProjectName := strToken(LStr, ';');
    LInquiryInfo.ShipNo := strToken(LStr, ';');
    LInquiryInfo.ProductType := strToken(LStr, ';');
    LInquiryInfo.ContractDate := strToken(LStr, ';');
    LInquiryInfo.DueDate := strToken(LStr, ';');
    LInquiryInfo.CustomerName := strToken(LStr, ';');
    LInquiryInfo.CustomerNation := strToken(LStr, ';');
    LInquiryInfo.InqNo := strToken(LStr, ';');
    LInquiryInfo.InquiryRecvDate := strToken(LStr, ';');

    FInquiryList.Add(LInquiryInfo.FRow, LInquiryInfo);
  end;

  for i := 0 to ABWQryClass.BWQryCellDataCollect.Count - 1 do
  begin
    LRow := ABWQryClass.BWQryCellDataCollect.Items[i].Row+1;
    LInquiryInfo := FInquiryList.Items[LRow];

    if LInquiryInfo.FRow = LRow then
    begin
      case (i mod 2) of
        0: LInquiryInfo.ProductCount := ABWQryClass.BWQryCellDataCollect.Items[i].CellData;
        1: LInquiryInfo.Price := ABWQryClass.BWQryCellDataCollect.Items[i].CellData;
      end;
    end;
  end;
end;

procedure TMainForm.LoadQueryListFromTxt;
var
  LBWQryListClass: TBWQryListClass;
  LBWQryClass: TBWQryClass;
  i: integer;
begin
  LBWQryListClass := TBWQryListClass.Create(nil);

  try
    LBWQryListClass.LoadFromTxt('BWQuery.txt');

    for i := 0 to LBWQryListClass.BWQryCollect.Count - 1 do
    begin
      LBWQryClass := TBWQryClass.Create(nil);
      LBWQryClass.Description := LBWQryListClass.BWQryCollect.Items[i].Description;
      LBWQryClass.QueryName := LBWQryListClass.BWQryCollect.Items[i].QueryName;
      LBWQryClass.QueryText := LBWQryListClass.BWQryCollect.Items[i].QueryText;
      LBWQryClass.QueryType := LBWQryListClass.BWQryCollect.Items[i].QueryType;
      LBWQryClass.QryParamType := LBWQryListClass.BWQryCollect.Items[i].QryParamType;

      FBWQryList.Add(LBWQryClass.QueryName, LBWQryClass);
    end;
  finally
    LBWQryListClass.Free;
  end;
end;

procedure TMainForm.N10Click(Sender: TObject);
begin
  QryData2DataView(TMenuItem(Sender).Hint);
end;

procedure TMainForm.N11Click(Sender: TObject);
begin
  QryData2DataView(TMenuItem(Sender).Hint);
end;

procedure TMainForm.N15Click(Sender: TObject);
begin
  QryData2DataView(TMenuItem(Sender).Hint);
end;

procedure TMainForm.N16Click(Sender: TObject);
begin
  QryData2DataView(TMenuItem(Sender).Hint);
end;

procedure TMainForm.N17Click(Sender: TObject);
begin
  QryData2DataView(TMenuItem(Sender).Hint);
end;

procedure TMainForm.N18Click(Sender: TObject);
begin
  QryData2DataView(TMenuItem(Sender).Hint);
end;

procedure TMainForm.N19Click(Sender: TObject);
begin
  QryData2DataView(TMenuItem(Sender).Hint);
end;

procedure TMainForm.N1Click(Sender: TObject);
begin
  QryData2DataView(TMenuItem(Sender).Hint);
end;

procedure TMainForm.N20Click(Sender: TObject);
begin
  QryData2DataView(TMenuItem(Sender).Hint);
end;

procedure TMainForm.N23Click(Sender: TObject);
begin
  QryData2DataView(TMenuItem(Sender).Hint);
end;

procedure TMainForm.N24Click(Sender: TObject);
begin
  QryData2DataView(TMenuItem(Sender).Hint);
end;

procedure TMainForm.N25Click(Sender: TObject);
begin
  QryData2DataView(TMenuItem(Sender).Hint);
end;

procedure TMainForm.N26Click(Sender: TObject);
begin
  QryData2DataView(TMenuItem(Sender).Hint);
end;

procedure TMainForm.N27Click(Sender: TObject);
begin
  QryData2DataView(TMenuItem(Sender).Hint);
end;

procedure TMainForm.N28Click(Sender: TObject);
begin
  QryData2DataView(TMenuItem(Sender).Hint);
end;

procedure TMainForm.N29Click(Sender: TObject);
begin
  QryData2DataView(TMenuItem(Sender).Hint);
end;

procedure TMainForm.N2Click(Sender: TObject);
begin
  QryData2DataView(TMenuItem(Sender).Hint);
end;

procedure TMainForm.N3Click(Sender: TObject);
begin
  QryData2DataView(TMenuItem(Sender).Hint);
end;

procedure TMainForm.N4Click(Sender: TObject);
begin
  QryData2DataView(TMenuItem(Sender).Hint);
end;

procedure TMainForm.N5Click(Sender: TObject);
begin
  QryData2DataView(TMenuItem(Sender).Hint);
end;

procedure TMainForm.N6Click(Sender: TObject);
begin
  QryData2DataView(TMenuItem(Sender).Hint);
end;

procedure TMainForm.N7Click(Sender: TObject);
begin
  QryData2DataView(TMenuItem(Sender).Hint);
end;

procedure TMainForm.N8Click(Sender: TObject);
begin
  QryData2DataView(TMenuItem(Sender).Hint);
end;

procedure TMainForm.N9Click(Sender: TObject);
begin
  QryData2DataView(TMenuItem(Sender).Hint);
end;

procedure TMainForm.OnAutoStart(Sender: TObject; Handle: Integer;
  Interval: Cardinal; ElapsedTime: Integer);
begin
//  if ElapsedTime > 10000 then
//  begin
//    FPJHTimerPool.Remove(FAutoStartTimerHandle);
//    FAutoStartTimerHandle := -1;
//    FCSServerStartBtnClick(nil);
//  end
//  else
//    FCS.AutoStartCheck.Caption := 'Auto start after ' + IntToStr((10000 - ElapsedTime) div 1000) + ' seconds';
end;

procedure TMainForm.OnGetBWQuery(Sender: TObject; Handle: Integer;
  Interval: Cardinal; ElapsedTime: Integer);
begin
  ExecuteGetBWQry;
end;

procedure TMainForm.OnGetBWQueryCompleted(const task: IOmniTaskControl);
var
  LStr: string;
begin
//  QProgress1.Active := False;
//  FQryRunning := False;

  LStr := Copy(Caption, 1, Pos(' => ', Caption) - 1);

  if LStr = '' then
    LStr := Caption;

  Caption := LStr + ' => ' + IntToStr(FQryCount) + ' Query Updated: ' + FormatDateTime('mm월 dd일, hh:nn:ss', now);

  if TBWQryFetchType(FSettings.BWQryFetchType) = ftCyclic then
    FPJHTimerPool.AddOneShot(OnGetBWQuery, 1800000)//1800000
  else
  if TBWQryFetchType(FSettings.BWQryFetchType) = ftScheduledTime then
  begin
    BWQryFetchAlarm.AlarmTimeBegin := FSettings.ServerTimeToGetBWQry;
    BWQryFetchAlarm.ActiveBegin := True;
  end;

  if FOrderPlanPerProduct.Count = 0 then
    Parallel.Future<Boolean>(GetOrderPlanPerProduct, Parallel.TaskConfig.OnTerminated(OnGetOrderPlanPerProductCompleted));

  if FSalesPlanPerProduct.Count = 0 then
    Parallel.Future<Boolean>(GetSalesPlanPerProduct, Parallel.TaskConfig.OnTerminated(OnGetSalesPlanPerProductCompleted));

  if FProfitPlanPerProduct.Count = 0 then
    Parallel.Future<Boolean>(GetProfitPlanPerProduct, Parallel.TaskConfig.OnTerminated(OnGetProfitPlanPerProductCompleted));

  Parallel.Future<Boolean>(DoPulseEvent, Parallel.TaskConfig.OnTerminated(OnPulseEventCompleted));

  FGetQrying := False;
end;

procedure TMainForm.OnGetOrderPlanPerProductCompleted(
  const task: IOmniTaskControl);
var
  i: integer;
  LStr: string;
begin
  for i := 0 to FOrderPlanPerProduct.Count - 1 do
  begin
    LStr := LStr + IntToStr(FOrderPlanPerProduct.Items[i].Col) + ',' +
          IntToStr(FOrderPlanPerProduct.Items[i].Row) + ',' + FOrderPlanPerProduct.Items[i].CellData + #13#10;
  end;

  DisplayMessage('============================================================================');
  DisplayMessage(LStr);
  DisplayMessage('============================================================================');
end;

procedure TMainForm.OnGetProfitPlanPerProductCompleted(
  const task: IOmniTaskControl);
var
  i: integer;
  LStr: string;
begin
  for i := 0 to FProfitPlanPerProduct.Count - 1 do
  begin
    LStr := LStr + IntToStr(FProfitPlanPerProduct.Items[i].Col) + ',' +
          IntToStr(FProfitPlanPerProduct.Items[i].Row) + ',' + FProfitPlanPerProduct.Items[i].CellData + #13#10;
  end;

  DisplayMessage('============================================================================');
  DisplayMessage(LStr);
  DisplayMessage('============================================================================');
end;

procedure TMainForm.OnGetSalesPlanPerProductCompleted(
  const task: IOmniTaskControl);
var
  i: integer;
  LStr: string;
begin
  for i := 0 to FSalesPlanPerProduct.Count - 1 do
  begin
    LStr := LStr + IntToStr(FSalesPlanPerProduct.Items[i].Col) + ',' +
          IntToStr(FSalesPlanPerProduct.Items[i].Row) + ',' + FSalesPlanPerProduct.Items[i].CellData + #13#10;
  end;

  DisplayMessage('============================================================================');
  DisplayMessage(LStr);
  DisplayMessage('============================================================================');
end;

procedure TMainForm.OnPulseEventCompleted(const task: IOmniTaskControl);
begin

end;

procedure TMainForm.ProcessQueryXML(AXMLString: string; const task: IOmniTask);
var
  LXMLDoc: IXMLDocument;
  LRootNode, LSubNode, LLeafNode, LLeafNode2: IXMLNode;
  LBWQryClass: TBWQryClass;
  LBWQryCellDataItem: TBWQryCellDataItem;
  LBWQryRowHeaderItem: TBWQryRowHeaderItem;
  LBWQryColumnHeaderItem: TBWQryColumnHeaderItem;
  i,j,k: integer;
  LCol, LRow: integer;
begin
  LXMLDoc := CreateXMLDoc;
  try
    LXMLDoc.LoadXML(AXMLString);

    if LXMLDoc.DocumentElement <> nil then
    begin
      LRootNode := LXMLDoc.DocumentElement;

      for i := 0 to LRootNode.ChildNodes.Length - 1 do
      begin
        if task.CancellationToken.IsSignalled then
          break;

        LSubNode := LRootNode.ChildNodes.Item[i];

        if LSubNode.NodeName = 'variable' then
        begin
          if LSubNode.Attributes.Length > 0 then
          begin
            if LSubNode.Attributes.Item[0].NodeValue = 'colHeader' then
            begin
              LBWQryClass := GetCurQryClass;
              LBWQryClass.BWQryColumnHeaderCollect.Clear;

              for j := 0 to LSubNode.ChildNodes.Length - 1 do
              begin
                LSubNode := LSubNode.ChildNodes.Item[j];

                if LSubNode.NodeName = 'row' then
                begin
                  for k := 0 to LSubNode.ChildNodes.Length - 1 do
                  begin
                    LLeafNode2 := LSubNode.ChildNodes.Item[k];

                    if LLeafNode2.NodeName = 'column' then
                    begin
                      if LLeafNode2.HasChildNodes then
                      begin
                        LBWQryColumnHeaderItem := LBWQryClass.BWQryColumnHeaderCollect.Add;
                        LLeafNode2 := LLeafNode2.ChildNodes.Item[0];//CDATA Section
                        LBWQryColumnHeaderItem.ColumnHeaderData := LBWQryColumnHeaderItem.ColumnHeaderData +
                                        LLeafNode2.NodeValue + ';';
                        LBWQryColumnHeaderItem.ColumnHeaderLevel := j;
                      end;
                    end;
                  end;//for
                end;
              end;//for

              LBWQryClass.BWQryColumnHeaderCollect.FixedColumnCount := j;
            end
            else
            if LSubNode.Attributes.Item[0].NodeValue = 'rowHeader' then
            begin
              LBWQryClass := GetCurQryClass;
              LBWQryClass.BWQryRowHeaderCollect.Clear;

              for j := 0 to LSubNode.ChildNodes.Length - 1 do
              begin
                LLeafNode := LSubNode.ChildNodes.Item[j];

                if LLeafNode.NodeName = 'row' then
                begin
                  LBWQryRowHeaderItem := LBWQryClass.BWQryRowHeaderCollect.Add;

                  for k := 0 to LLeafNode.ChildNodes.Length - 1 do //row 및의 column 수 만긐 반복
                  begin
                    LLeafNode2 := LLeafNode.ChildNodes.Item[k];

                    if LLeafNode2.NodeName = 'column' then
                    begin
                      if LLeafNode2.HasChildNodes then
                      begin
                        LLeafNode2 := LLeafNode2.ChildNodes.Item[0];//CDATA Section
                        LBWQryRowHeaderItem.RowHeaderData := LBWQryRowHeaderItem.RowHeaderData + LLeafNode2.NodeValue + ';';
                      end;
                    end;
                  end;//for

                  LBWQryClass.BWQryRowHeaderCollect.ColCountOfRow := LLeafNode.ChildNodes.Length;
                end;
              end;//for
            end
            else
            if LSubNode.Attributes.Item[0].NodeValue = 'cellData' then
            begin
              LBWQryClass := GetCurQryClass;
              LBWQryClass.BWQryCellDataCollect.Clear;

              for j := 0 to LSubNode.ChildNodes.Length - 1 do
              begin
                LLeafNode := LSubNode.ChildNodes.Item[j];

                if LLeafNode.NodeName = 'row' then
                begin
                  for k := 0 to LLeafNode.ChildNodes.Length - 1 do
                  begin
                    LLeafNode2 := LLeafNode.ChildNodes.Item[k];

                    if LLeafNode2.NodeName = 'column' then
                    begin
                      if LLeafNode2.HasChildNodes then
                      begin
                        LLeafNode2 := LLeafNode2.ChildNodes.Item[0];//CDATA Section
                        LBWQryCellDataItem := LBWQryClass.BWQryCellDataCollect.Add;
                        LBWQryCellDataItem.Row := j;
                        LBWQryCellDataItem.Col := k;
                        LBWQryCellDataItem.CellData := LLeafNode2.NodeValue
                      end;
                    end;
                  end;//for
                end;
              end;
            end
          end;
        end;
      end;
    end;
  finally
    ChangeDataFormat;

    LBWQryClass := GetCurQryClass;
    if LBWQryClass.QueryName = 'ZKA_ZKSDINM01_D_L_Q201' then
      LoadInquiryList(LBWQryClass);

    LXMLDoc := nil;
  end;
end;

procedure TMainForm.QryData2DataView(AQueryName: string);
var
  LBWQryClass: TBWQryClass;
  LDataViewF: TDataViewF;
  LXlsFileName: string;
  i, LCol, LRow, LFixedColCount: integer;
  LQryType: integer;
begin
  LBWQryClass := nil;
  LBWQryClass := GetQueryClass(AQueryName);

  if Assigned(LBWQryClass) then
  begin
    LDataViewF := TDataViewF.Create(Self);
    try
      LXlsFileName := ExtractFilePath(Application.ExeName) + '..\Maps\' + AQueryName + '.xls';

      if FileExists(LXlsFileName) then
      begin
        LQryType := GetQueryType(AQueryName);
        case LQryType of
          0: LDataViewF.AdvGridExcelIO1.XLSImport(LXlsFileName);
          1: begin
            LDataViewF.AdvGridExcelIO1.XLSImport(LXlsFileName);
            RowHeaderNCellData2Grid(LBWQryClass, LDataViewF.AdvGridWorkbook1.Grid);
          end;
          2: begin
            LDataViewF.AdvGridExcelIO1.XLSImport(LXlsFileName);
            ColumnHeaderNCellData2Grid(LBWQryClass, LDataViewF.AdvGridWorkbook1.Grid);
          end;
        end;
      end
      else
        HeaderData2Grid(LBWQryClass, LDataViewF.AdvGridWorkbook1.Grid);

      LFixedColCount := LBWQryClass.BWQryRowHeaderCollect.ColCountOfRow;

      for i := 0 to LBWQryClass.BWQryCellDataCollect.Count - 1 do
      begin
        LCol := LBWQryClass.BWQryCellDataCollect.Items[i].Col+LFixedColCount;
        LRow := LBWQryClass.BWQryCellDataCollect.Items[i].Row+1;
        LDataViewF.AdvGridWorkbook1.Grid.Cells[LCol, LRow] := LBWQryClass.BWQryCellDataCollect.Items[i].CellData;
      end;

      LDataViewF.Panel1.Caption := LBWQryClass.Description;
      LDataViewF.ShowModal;
    finally
      LDataViewF.Free;
    end;
  end;
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

function TMainForm.SetQryParamType(AQryText: string; const AParamName: string;
  AParamType: TQryParameterType; AParamDir: TQryParameterDir; ADate: TDate): string;
var
  LNewQryTxt: string;
begin
  case AParamType of
    qptYear: begin
      if AParamDir = qpdBegin then
        LNewQryTxt := AParamName + FormatDateTime('yyyy', ADate) + '0101'
      else
      if AParamDir = qpdCustom then
        LNewQryTxt := AParamName + FormatDateTime('yyyymmdd', ADate)
      else
      if AParamDir = qpdEnd then
        LNewQryTxt := AParamName + FormatDateTime('yyyy', ADate) + '1231';
    end;

    qptMonth: begin
      if AParamDir = qpdBegin then
        LNewQryTxt := AParamName + FormatDateTime('yyyymm', ADate) + '01'
      else
      if AParamDir = qpdCustom then
        LNewQryTxt := AParamName + FormatDateTime('yyyymmdd', ADate)
      else
      if AParamDir = qpdEnd then
        LNewQryTxt := AParamName + FormatDateTime('yyyymm', ADate) + GetEndOfMonth(ADate);
    end;

    qptDay: begin
      LNewQryTxt := AParamName + FormatDateTime('yyyymmdd', ADate)
    end;
  end;

  Result := StringReplace(AQryText, AParamName, LNewQryTxt, [rfReplaceAll, rfIgnoreCase]);
end;

procedure TMainForm.StartServer;
begin

end;

//ARow: 수주 계획의 경우 제품별(대형/중형/산업기계 등)로 가져오므로 경영계획이 있는 행(ARow)만 관리 함
//      매출/손익의 경우 제품별이 아닌 부문별(박용/발전/로봇 등) 이므로 ARow = 0으로 처리함.
//AExcludeRow: 보다 큰 Row는 건너뜀
procedure TMainForm._GetBizPlanPerProduct(AQryName: string; ARow: integer;
  ACollect: TBWQryCellDataCollect; AExcludeRow: integer);
var
  LBWQryClass: TBWQryClass;
  i, LCol, LRow: integer;
begin
  LBWQryClass := nil;
  LBWQryClass := GetQueryClass(AQryName);

  if Assigned(LBWQryClass) then
  begin
    for i := 0 to LBWQryClass.BWQryCellDataCollect.Count - 1 do
    begin
      LCol := LBWQryClass.BWQryCellDataCollect.Items[i].Col;
      LRow := LBWQryClass.BWQryCellDataCollect.Items[i].Row;

      if AExcludeRow <> -1 then
        if AExcludeRow <= LRow then
          continue;

      if ARow = 0 then
      begin
        with ACollect.Add do
        begin
          Col := LCol;
          Row := LRow;
          CellData := LBWQryClass.BWQryCellDataCollect.Items[i].CellData;
//          DataName := LBWQryClass.BWQryCellDataCollect.Items[i].DataName;
        end;
      end
      else
      if LRow = ARow then
      begin
        with ACollect.Add do
        begin
          Col := LCol;
          Row := LRow;
          CellData := LBWQryClass.BWQryCellDataCollect.Items[i].CellData;
//          DataName := LBWQryClass.BWQryCellDataCollect.Items[i].DataName;
        end;
      end;
    end;
  end;
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
  if MainForm.FGetQrying then
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

    for LKey in MainForm.FBWQryList.Keys do
    begin
      LBQC := MainForm.GetQueryClass(MainForm.FBWQryList.Items[LKey].QueryName);

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
    LBQC := MainForm.GetQueryClass(AQueryName);

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
  Result := MainForm.FGetQrying;

  if Result then
  begin
    exit;
  end;

  LQueryName := Utf8ToString(AQueryName);
  LBQC := nil;
  LBQC := MainForm.GetQueryClass(AQueryName);
//  LBWCellData := TBWQryCellDataCollect.Create(TBWQryCellDataItem);

  try
//    LBWCellData.Assign(LBQC.BWQryCellDataCollect);
    if Assigned(LBQC) then
    begin
      CopyObject(LBQC.BWQryCellDataCollect, AEPCollect);
      LRemoteIP := FormatDateTime('mm월 dd일, hh:nn:ss => ', now) + IntToStr(LBQC.BWQryCellDataCollect.Count) + ' Data have Sent to client(IP:';
      LRemoteIP := LRemoteIP + FindIniNameValue(pointer(ServiceContext.Request.Call.InHead),'REMOTEIP: ') +  ') for Query ( ' + AQueryName + ' )';
      MainForm.DisplayMessage(LRemoteIP);
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

  if MainForm.FGetQrying then
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
    MainForm.GetCellDataAll;
    CopyObject(MainForm.FCellDataAllCollect, ABWQryCellDataAll);
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
  Result := MainForm.FGetQrying;

  if Result then
  begin
    exit;
  end;

  LBQC := nil;
  LQueryName := Utf8ToString(AQueryName);
  LBQC := MainForm.GetQueryClass(AQueryName);

  if Assigned(LBQC) then
    CopyObject(LBQC.BWQryColumnHeaderCollect, AEPCollect);
end;

function TServiceBWQuery.GetDPMSInfo(AFrom, ATo: string): RawUTF8;
begin
  Result := MainForm.GetDPMSInfo(AFrom, ATo);
end;

procedure TServiceBWQuery.GetHhiOfficeNewsList2(
  out ASeaOceanNewsCollect: TSONewsCollect);
begin
  CopyObject(MainForm.FSeaOceanNewsList2, ASeaOceanNewsCollect);
end;

function TServiceBWQuery.GetInquiryPerProdPerGrade: TRawUTF8DynArray;
var
  LCount: integer;
  LDynArr: TDynArray;
begin
  LDynArr.Init(TypeInfo(TRawUTF8DynArray),Result,@LCount);
  Result := MainForm.GetInquiryPerProdPerGrade;
end;

function TServiceBWQuery.GetNewsList2: TRawUTF8DynArray;
var
  LCount: integer;
  LDynArr: TDynArray;
begin
  LDynArr.Init(TypeInfo(TRawUTF8DynArray),Result,@LCount);
  Result := MainForm.GetNewsService2;
end;

function TServiceBWQuery.GetOrderPlanPerProduct(
  out ACollect: TBWQryCellDataCollect): Boolean;
begin
  Result := False;

  if MainForm.FOrderPlanPerProduct.Count > 0 then
  begin
    CopyObject(MainForm.FOrderPlanPerProduct, ACollect);
    Result := True;
  end;
end;

function TServiceBWQuery.GetProfitPlanPerProduct(
  out ACollect: TBWQryCellDataCollect): Boolean;
begin
  Result := False;

  if MainForm.FOrderPlanPerProduct.Count > 0 then
  begin
    CopyObject(MainForm.FProfitPlanPerProduct, ACollect);
    Result := True;
  end;
end;

function TServiceBWQuery.GetRowHeaderData(AQueryName: RawUTF8; out AColCountOfRow: integer;
  out AEPCollect: TBWQryRowHeaderCollect): Boolean;
var
  LQueryName: string;
  LBQC: TBWQryClass;
begin
  Result := MainForm.FGetQrying;

  if Result then
  begin
    exit;
  end;

  LBQC := nil;
  LQueryName := Utf8ToString(AQueryName);
  LBQC := MainForm.GetQueryClass(AQueryName);
  AColCountOfRow := LBQC.BWQryRowHeaderCollect.ColCountOfRow;

  if Assigned(LBQC) then
    CopyObject(LBQC.BWQryRowHeaderCollect, AEPCollect);
end;

function TServiceBWQuery.GetSalesPlanPerProduct(
  out ACollect: TBWQryCellDataCollect): Boolean;
begin
  Result := False;

  if MainForm.FOrderPlanPerProduct.Count > 0 then
  begin
    CopyObject(MainForm.FSalesPlanPerProduct, ACollect);
    Result := True;
  end;
end;

end.
