unit UnitMain;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes,
  System.StrUtils, Vcl.Graphics, MSHTML, Activex,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, VclTee.TeeGDIPlus, VCLTee.TeeSurfa,
  VCLTee.TeeMapSeries, VCLTee.TeeWorldSeries, VCLTee.Series, VCLTee.TeeDonut,
  VCLTee.GanttCh, AdvPanel, IdBaseComponent, IdComponent, IdTCPConnection,
  IdTCPClient, IdHTTP, Vcl.ExtCtrls, VCLTee.TeEngine, VCLTee.TeeURL,
  VCLTee.TeeExcelSource, Vcl.StdCtrls, Vcl.Grids, AdvObj, BaseGrid, AdvGrid,
  NxCollection, VCLTee.TeeBezie, VCLTee.TeeProcs, VCLTee.Chart, AdvOfficePager,
  Vcl.Menus, VCLTee.ImaPoint, iComponent, iVCLComponent, iCustomComponent,
  iPositionComponent, iProgressComponent, iLedBar, VCLTee.TeCanvas, Generics.Collections,
  VCLTee.TeeTools, VCLTee.TeeLighting, VCLTee.TeeLegendScrollBar,
  VCLTee.TeeSeriesTextEd, VCLTee.TeeEdiGrad, OmniXML, OmniXMLUtils, OmniXMLXPath,
  OtlCommon, OtlCollections, OtlParallel, OtlTaskControl, BW_Query_Class, TimerPool,
  QProgress, AdvGridWorkbook, tmsAdvGridExcel, cefvcl, ceflib, AAFont, AACtrls,
  Vcl.Buttons, Vcl.ComCtrls;

const
  KBS_NEWS_LATEST_URL = 'http://news.kbs.co.kr/news/NewsCategory.do?SEARCH_SECTION=0001&SEARCH_CATEGORY=0004';
  KBS_NEWS_MAIN_URL = 'http://news.kbs.co.kr/news/NewsCategory.do?SEARCH_SECTION=0001&&source=http://news.kbs.co.kr/common/NewsMain.html';
//  SERIES_COLOR: array[1..8] of TColor = ($00BD814F, $004D50C0, $0059BB9B, $00A26480, $00C6AC4B, $003D84DB, $00D7B395, 0);
  SERIES_COLOR: array[1..8] of TColor = ($00FF0000, $000000FF, $0000FF00, $00FF00FF, $00FBFB04, $0000FFFF, $00D7B395, 0);
  NUM_OF_SALES_SERIES = 5;
  NUM_OF_PROFIT_SERIES = 6;

type
  NEWS_TYPE = (ntLatest, ntMain);

  TMainF = class(TForm)
    AdvOfficePager1: TAdvOfficePager;
    AdvOfficePager11: TAdvOfficePage;
    AdvOfficePager12: TAdvOfficePage;
    AdvOfficePager13: TAdvOfficePage;
    Splitter1: TSplitter;
    Splitter2: TSplitter;
    SalesChart: TChart;
    Series1: TBarSeries;
    Series2: TBarSeries;
    Series4: TLineSeries;
    Panel2: TPanel;
    ProfitChart: TChart;
    NxExpandPanel1: TNxExpandPanel;
    Button1: TButton;
    Button2: TButton;
    Button3: TButton;
    OpenDialog1: TOpenDialog;
    TeeExcelSource1: TTeeExcelSource;
    Timer1: TTimer;
    OrderChart: TChart;
    BarSeries1: TBarSeries;
    BarSeries2: TBarSeries;
    BezierSeries1: TBezierSeries;
    IdHTTP1: TIdHTTP;
    Panel3: TPanel;
    Splitter3: TSplitter;
    AdvPanelGroup1: TAdvPanelGroup;
    Chart4: TChart;
    AdvPanelGroup4: TAdvPanelGroup;
    Chart5: TChart;
    Panel4: TPanel;
    Splitter4: TSplitter;
    AdvPanelGroup2: TAdvPanelGroup;
    OrderChart2: TChart;
    DonutSeries1: TDonutSeries;
    AdvPanelGroup3: TAdvPanelGroup;
    Splitter5: TSplitter;
    Panel5: TPanel;
    Panel1: TPanel;
    Panel6: TPanel;
    PopupMenu1: TPopupMenu;
    ApplyChart1: TMenuItem;
    GetQuery1: TMenuItem;
    Timer2: TTimer;
    Series6: TPieSeries;
    Chart8: TChart;
    Series8: TLineSeries;
    Series9: TLineSeries;
    Panel7: TPanel;
    iLedBar1: TiLedBar;
    iLedBar2: TiLedBar;
    iLedBar3: TiLedBar;
    iLedBar4: TiLedBar;
    iLedBar5: TiLedBar;
    iLedBar6: TiLedBar;
    iLedBar7: TiLedBar;
    iLedBar8: TiLedBar;
    iLedBar9: TiLedBar;
    iLedBar10: TiLedBar;
    iLedBar11: TiLedBar;
    iLedBar12: TiLedBar;
    iLedBar13: TiLedBar;
    iLedBar14: TiLedBar;
    iLedBar15: TiLedBar;
    iLedBar16: TiLedBar;
    iLedBar17: TiLedBar;
    iLedBar18: TiLedBar;
    iLedBar19: TiLedBar;
    iLedBar20: TiLedBar;
    iLedBar21: TiLedBar;
    iLedBar22: TiLedBar;
    iLedBar23: TiLedBar;
    iLedBar24: TiLedBar;
    Shape1: TShape;
    Label1: TLabel;
    ComboFlat1: TComboFlat;
    SeriesTextSource1: TSeriesTextSource;
    ListCities: TListBox;
    Chart7: TChart;
    PointSeries1: TPointSeries;
    ChartTool1: TCursorTool;
    ChartTool2: TMarksTipTool;
    ChartTool3: TAxisScrollTool;
    ChartTool4: TGridBandTool;
    ChartTool5: TLegendScrollBar;
    ChartTool6: TLightTool;
    ChartTool7: TRotateTool;
    ChartTool8: TMarksTipTool;
    ChartTool9: TAnnotationTool;
    Series7: THorizBarSeries;
    WorldSeries1: TWorldSeries;
    imer1: TMenuItem;
    ScreenNavi1: TMenuItem;
    Panel8: TPanel;
    Panel9: TPanel;
    Panel10: TPanel;
    Panel11: TPanel;
    Panel12: TPanel;
    Panel13: TPanel;
    Panel14: TPanel;
    Panel15: TPanel;
    Panel16: TPanel;
    Panel17: TPanel;
    Panel18: TPanel;
    Panel19: TPanel;
    Label2: TLabel;
    QProgress1: TQProgress;
    AdvGridExcelIO1: TAdvGridExcelIO;
    AdvGridWorkbook1: TAdvGridWorkbook;
    DataView1: TMenuItem;
    N1: TMenuItem;
    N2: TMenuItem;
    N3: TMenuItem;
    Header1: TMenuItem;
    Header2: TMenuItem;
    N4: TMenuItem;
    N5: TMenuItem;
    N6: TMenuItem;
    N7: TMenuItem;
    HEADER3: TMenuItem;
    N8: TMenuItem;
    N9: TMenuItem;
    N10: TMenuItem;
    N11: TMenuItem;
    N12: TMenuItem;
    N13: TMenuItem;
    N14: TMenuItem;
    AAFadeText1: TAAFadeText;
    AdvOfficePage1: TAdvOfficePage;
    FChromium: TChromium;
    StatusBar: TStatusBar;
    Panel20: TPanel;
    SpeedButton1: TSpeedButton;
    SpeedButton2: TSpeedButton;
    SpeedButton3: TSpeedButton;
    SpeedButton4: TSpeedButton;
    edAddress: TEdit;
    SpeedButton5: TSpeedButton;
    procedure Timer1Timer(Sender: TObject);
    procedure ApplyChart1Click(Sender: TObject);
    procedure GetQuery1Click(Sender: TObject);
    procedure Timer2Timer(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure ListCitiesClick(Sender: TObject);
    procedure imer1Click(Sender: TObject);
    procedure Panel1Click(Sender: TObject);
    procedure ScreenNavi1Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure N1Click(Sender: TObject);
    procedure FChromiumLoadEnd(Sender: TObject; const browser: ICefBrowser;
      const frame: ICefFrame; httpStatusCode: Integer; out Result: Boolean);
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
    procedure SpeedButton5Click(Sender: TObject);
  private
    FXMLFromQry: string;
    FBWQryList: TDictionary<string, TBWQryClass>;
    FCurQryKey: String;//FBWQryList중에서 현재 실행 중인 Query Key string을 저장함
    FPJHTimerPool: TPJHTimerPool;
    FCompleteRedirectEvent: THandle;
//    FChromium: TChromium;
    FNewsList: TStringList;
    FNewsType: NEWS_TYPE;
    FQryRunning: Boolean;

    procedure InitVar;
    procedure DestroyVar;
    procedure LoadMap;
    procedure LoadCityList;
    function CurrentCity:Integer;
    function WhereIsFile(const FileName:String):String;
    procedure ProcessQueryXML(AXMLString: string);
    procedure LoadQueryListFromTxt;
    function GetQueryClass(AQueryName: string): TBWQryClass;
    function GetCurQryClass: TBWQryClass;

    procedure OnGetBWQuery(Sender : TObject; Handle : Integer;
            Interval : Cardinal; ElapsedTime : LongInt);
    procedure OnGetNews(Sender : TObject; Handle : Integer;
            Interval : Cardinal; ElapsedTime : LongInt);
    procedure OnGetBWQueryCompleted(const task: IOmniTaskControl);
    procedure GetBWQuery;
    procedure GetLatestNews;
    procedure GetMainNews;
    procedure GetNews2Memo;
    procedure GetNews2Memo2;
    function GetInnersByClass(const Doc: IDispatch; const classname: string;var Lst:TStringList; ATagName: string = ''): Integer;
    function GetInnersByTagName(const Doc: IDispatch; const TagName: string;var Lst:TStringList): Integer;
    procedure GetTitleByClass(const AHtml, classname: string; var Lst:TStringList);
    procedure ChangeDataFormat;
  public
    procedure CreateChartSeries(AChart: TChart; AStackedBarCount: integer);
    procedure CreateChartDonutSeries(AChart: TChart);
    procedure ClearChartSeries(AChart: TChart);
    procedure ClearChartDnoutSeries(AChart: TChart);
    function getContent(url: String): String;
    procedure QryData2Chart;
    procedure SalesData2Chart;
    procedure ProfitData2Chart;
    procedure OrderData2Chart;
    procedure Order2Data2Chart;
    procedure QryData2DataView(AQueryName: string);
  end;

var
  MainF: TMainF;

implementation

uses VClTee.TeeSHP, UnitDataView;

{$R *.dfm}

function strWordCount(ASource, AWord: String): Integer;
var
  Start : Integer;
begin
  Result := 0;
  Start := Pos(AWord, ASource);

  while Start > 0 do
    begin
      Inc(Result);
      Start := PosEx(AWord, ASource, Start + 1);
    end;
end;

function GetToken( var str1: string; AComma: string): String;
var
  i,j: integer;
begin
  i := Pos(AComma,Str1);
  if i > 0 then
  begin
    j := Length(AComma);
    Result := System.Copy(Str1, 1, i-1);
    System.Delete(Str1,1,i+j-1);
  end
  else
  begin
    Result := Str1;
    Str1 := '';
  end;
end;

procedure TMainF.ApplyChart1Click(Sender: TObject);
var
  i: integer;
begin
  CreateChartSeries(OrderChart,2);
  CreateChartSeries(SalesChart,2);
  CreateChartSeries(ProfitChart,2);

  OrderChart.Series[0].LegendTitle := '수주 실적 A등급';
  OrderChart.Series[1].LegendTitle := '수주 실적 B등급';
  OrderChart.Series[2].LegendTitle := '수주 계획';

  SalesChart.Series[0].LegendTitle := '매출 확정';
  SalesChart.Series[1].LegendTitle := '매출 미확정';
  SalesChart.Series[2].LegendTitle := '매출 계획';

  ProfitChart.Series[0].LegendTitle := '손익 누계';
  ProfitChart.Series[1].LegendTitle := '손익 실적';
  ProfitChart.Series[2].LegendTitle := '손익 계획';

  for i := 1 to 12 do
  begin
    OrderChart.Series[2].Add(Random(1000));
    SalesChart.Series[2].Add(Random(1000));
    ProfitChart.Series[2].Add(Random(1000));
  end;

  Timer1Timer(nil);
//  Timer1.Enabled := True;
end;

procedure TMainF.Button3Click(Sender: TObject);
begin
//  getContent('http://hhibwp.hhi.co.kr:8000/sap/bc/bsp/sap/zbwxa_bsp/data.xml?infocube=ZKSDBIM01&sap-user=KEAASC0&sap-password=keaasc00&query=ZKA_ZKSDBIM01_D_T_Q214&VAR_NAME_1=ZCALDAY01&VAR_VALUE_EXT_1=20150224');
//  Button3.Enabled := False;
//  GetLatestNews;
//  GetMainNews;
//  GetQueryData('');
SalesData2Chart;       ProfitData2Chart;
end;

procedure TMainF.ChangeDataFormat;
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

procedure TMainF.ClearChartDnoutSeries(AChart: TChart);
var
  i: integer;
begin
  for i := 0 to AChart.SeriesCount - 1 do
    TDonutSeries(AChart.Series[i]).Clear;

//  TDonutSeries(AChart.Series[i]).Delete;
end;

procedure TMainF.ClearChartSeries(AChart: TChart);
var
  i: integer;
begin
  for i := 0 to AChart.SeriesCount - 1 do
    AChart.Series[i].Clear;
end;

procedure TMainF.CreateChartDonutSeries(AChart: TChart);
var
  tmp : TChartSeries;
begin
  AChart.RemoveAllSeries;
  AChart.Axes.Bottom.LabelStyle := talText;
//  AChart.Legend.LegendStyle
  tmp := AChart.AddSeries(TDonutSeries);
  tmp.Marks.Visible := True;
  tmp.Marks.ArrowLength := 0;
  tmp.Marks.Font.Size := 10;
  tmp.Marks.Style := smsLabelValue;
  tmp.Marks.MultiLine := True;
  tmp.ValueFormat := '#,##0.###천 $';
end;

procedure TMainF.CreateChartSeries(AChart: TChart; AStackedBarCount: integer);
var
  tmp : TChartSeries;
  i: integer;
begin
  AChart.RemoveAllSeries;
  AChart.Axes.Bottom.LabelStyle := talText;
//  AChart.Legend.LegendStyle

  for i := 1 to AStackedBarCount do
  begin
    tmp := AChart.AddSeries(TBarSeries);
    tmp.Color := SERIES_COLOR[i mod High(SERIES_COLOR)];
    tmp.Marks.Visible := False;
    tmp.Marks.ArrowLength := 10;
    tmp.Marks.Font.Size := 10;
    tmp.Pen.Visible := False;
//    tmp.Name := AChart.Name + '_B' + IntToStr(i);
    TBarSeries(tmp).MultiBar := mbStacked;
  end;

  tmp.Marks.Visible := True;//맨 위 시리즈만 Mark 보이기

  tmp := AChart.AddSeries(TLineSeries);
  tmp.Marks.Visible := False;
  tmp.Color := SERIES_COLOR[i mod High(SERIES_COLOR)];
  TLineSeries(tmp).LinePen.Width := 4;
//  tmp.Name := AChart.Name + '_S';
  TLineSeries(tmp).Pointer.Style := psCircle;
  TLineSeries(tmp).Pointer.Size := 5;
  TLineSeries(tmp).Pointer.Visible := True;
end;

function TMainF.CurrentCity: Integer;
begin
  result:= Integer(ListCities.Items.Objects[ListCities.ItemIndex] );
end;

procedure TMainF.DestroyVar;
var
  LKey: string;
begin
  FNewsList.Free;
//  FChromium.Free;
  FPJHTimerPool.RemoveAll;
  FPJHTimerPool.Free;

  for LKey in FBWQryList.Keys do
    TBWQryClass(FBWQryList.Items[LKey]).Free;

  FBWQryList.Free;
end;

procedure TMainF.FChromiumLoadEnd(Sender: TObject; const browser: ICefBrowser;
  const frame: ICefFrame; httpStatusCode: Integer; out Result: Boolean);
begin
//  if httpStatusCode <> 0 then
//    GetNews2Memo2;
//    GetNews2Memo;
//  showmessage(inttostr(httpStatusCode));
end;

procedure TMainF.FormActivate(Sender: TObject);
var
  i: integer;
begin
//  Chart1.Axes.FastCalc:=True;  // bypass range checking to improve speed
//
//  Chart1.Axes.Left.Minimum:=-90;
//  Chart1.Axes.Left.Maximum:=90;
//
//  Chart1.Axes.Left.AxisValuesFormat:='0'+Char(186);
//  Chart1.Axes.Bottom.AxisValuesFormat:='0'+Char(186);
//
//  Chart1.Axes.Left.Grid.Style:=psSolid;
//  Chart1.Axes.Left.Grid.Color:=ApplyDark(Chart1.Color,16);
//  Chart1.Axes.Left.Grid.SmallDots:=True;
//
//  Chart1.Axes.Bottom.Grid.Style:=psSolid;
//  Chart1.Axes.Bottom.Grid.Color:=ApplyDark(Chart1.Color,16);
//  Chart1.Axes.Bottom.Grid.SmallDots:=True;

//  ApplyChart1Click(nil);

//  for i := Chart7.Series[0].Count - 1 to 0 do
//    if Chart7.Series[0].Labels[i] <> 'France' then
//      Chart7.Series[0].Destroy;

  CreateChartSeries(SalesChart, 5);
  LoadMap;
end;

procedure TMainF.FormCreate(Sender: TObject);
begin
  InitVar;
end;

procedure TMainF.FormDestroy(Sender: TObject);
begin
  DestroyVar;
end;

procedure TMainF.GetBWQuery;
var
  WaitResult: Integer;
  LKey, LQryTxt, LNewQryTxt: string;
begin
  QProgress1.Active := True;
  FQryRunning := True;
  Panel1.Caption := '자료 갱신 중...';
//  if FCompleteRedirectEvent = 0 then
//    FCompleteRedirectEvent := CreateEvent(nil, False, False, nil);

  for LKey in FBWQryList.Keys do
  begin
    LQryTxt := FBWQryList.Items[LKey].QueryText;

    if Pos('VAR_VALUE_LOW_EXT_2=', LQryTxt) > 0  then
    begin
      LNewQryTxt := 'VAR_VALUE_LOW_EXT_2=' + FormatDateTime('yyyy', Date) + '0101';
      LQryTxt := StringReplace(LQryTxt, 'VAR_VALUE_LOW_EXT_2=', LNewQryTxt, [rfReplaceAll, rfIgnoreCase]);
    end;

    if Pos('VAR_VALUE_HIGH_EXT_2=', LQryTxt) > 0  then
    begin
      LNewQryTxt := 'VAR_VALUE_HIGH_EXT_2=' + FormatDateTime('yyyymmdd', now);
      LQryTxt := StringReplace(LQryTxt, 'VAR_VALUE_HIGH_EXT_2=', LNewQryTxt, [rfReplaceAll, rfIgnoreCase]);
    end;

    if Pos('VAR_VALUE_EXT_1=', LQryTxt) > 0  then
    begin
      LNewQryTxt := 'VAR_VALUE_EXT_1=' + FormatDateTime('yyyymmdd', now);
      LQryTxt := StringReplace(LQryTxt, 'VAR_VALUE_EXT_1=', LNewQryTxt, [rfReplaceAll, rfIgnoreCase]);
    end;

    FXMLFromQry := GetContent(LQryTxt);
    FCurQryKey := LKey;
    ProcessQueryXML(FXMLFromQry);

//    WaitResult := WaitForSingleObject(FCompleteRedirectEvent, 50000);

//    if WaitResult = WAIT_OBJECT_0 then
//    begin
//      ProcessQueryXML(FXMLFromQry);
//    end
//    else
//    if WaitResult = WAIT_TIMEOUT then
//    begin
//
//    end;
  end;
end;

function TMainF.getContent(url: String): String;
var
  LIdHTTP: TIdHTTP;
begin
  LIdHTTP := TIdHTTP.Create(nil);
  LIdHTTP.HandleRedirects := True;
  try
    try
      Result := LIdHTTP.Get(url);

  //  ShowMessage(IdHTTP1.Get(dest));
  //  try
  //    FXMLFromQry := IdHTTP1.Get(dest);
  //    PulseEvent(FCompleteRedirectEvent);
  //    ProcessQueryXML(FXMLFromQry);
  //    Handled := True;
  //    Button3.Enabled := True;
  //  except

  //  end;
    except

    end;
  finally
    LIdHTTP.Free;
  end;
end;

function TMainF.GetCurQryClass: TBWQryClass;
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

function TMainF.GetInnersByClass(const Doc: IDispatch; const classname: string;
  var Lst: TStringList; ATagName: string): Integer;
var
  Document: IHTMLDocument2;     // IHTMLDocument2 interface of Doc
  Body: IHTMLElement2;          // document body element
  Tags: IHTMLElementCollection; // all tags in document body
  Tag: IHTMLElement;            // a tag in document body
  I: Integer;                   // loops thru tags in document body
  LHtml: string;
begin
  Lst.Clear;
  Result := 0 ;
  // Check for valid document: require IHTMLDocument2 interface to it
  if not Supports(Doc, IHTMLDocument2, Document) then
    raise Exception.Create('Invalid HTML document');
  // Check for valid body element: require IHTMLElement2 interface to it
  if not Supports(Document.body, IHTMLElement2, Body) then
    raise Exception.Create('Can''t find <body> element');
  // Get all tags in body element ('*' => any tag name)
  Tags := Body.getElementsByTagName('*');
  // Scan through all tags in body
  for I := 0 to Pred(Tags.length) do
  begin
    // Get reference to a tag
    Tag := Tags.item(I, EmptyParam) as IHTMLElement;
    // Check tag's id and return it if id matches
    if SameText(Tag.className, classname) then
    begin
      if ATagName <> '' then
        LHtml := Tag.innerText
      else
        LHtml := Tag.innerHTML;

      Lst.Add(LHtml);
      Inc(Result);
    end;
  end;
end;

function TMainF.GetInnersByTagName(const Doc: IDispatch; const TagName: string;
  var Lst: TStringList): Integer;
var
  Document: IHTMLDocument2;     // IHTMLDocument2 interface of Doc
  Body: IHTMLElement2;          // document body element
  Tags: IHTMLElementCollection; // all tags in document body
  Tag: IHTMLElement;            // a tag in document body
  I: Integer;                   // loops thru tags in document body
begin
  Lst.Clear;
  Result := 0 ;
  // Check for valid document: require IHTMLDocument2 interface to it
  if not Supports(Doc, IHTMLDocument2, Document) then
    raise Exception.Create('Invalid HTML document');
  // Check for valid body element: require IHTMLElement2 interface to it
  if not Supports(Document.body, IHTMLElement2, Body) then
    raise Exception.Create('Can''t find <body> element');
  // Get all tags in body element ('*' => any tag name)
  Tags := Body.getElementsByTagName(TagName);
  // Scan through all tags in body
  for I := 0 to Pred(Tags.length) do
  begin
    // Get reference to a tag
    Tag := Tags.item(I, EmptyParam) as IHTMLElement;
    // Check tag's id and return it if id matches
//    if SameText(Tag.className, classname) then
//    begin
      Lst.Add(Tag.innerHTML);
      Inc(Result);
//    end;
  end;
end;

procedure TMainF.GetLatestNews;
//var
//  frame: ICefFrame;
//  source: string;
//  LStr: string;
begin
  FNewsType := ntLatest;
  FChromium.Browser.MainFrame.LoadUrl(KBS_NEWS_LATEST_URL);

//  if FChromium.Browser <> nil then
//  begin
//    frame := FChromium.Browser.MainFrame;
//    source := frame.Text;
//    LStr := GetToken(source, '[최신뉴스]');
//    FNewsList.Clear;
//
//    LStr := GetToken(source, '[최신뉴스]');
//    FNewsList.Add(LStr);
//  end;
end;

procedure TMainF.GetMainNews;
begin
//  FNewsType := ntMain;
//  FChromium.Browser.Reload;
//  FChromium.Browser.MainFrame.LoadUrl(KBS_NEWS_MAIN_URL);
end;

procedure TMainF.GetNews2Memo;
var
  Lframe: ICefFrame;
  source: string;
  LStr, LStr2: string;
  i, LCount: integer;
begin
  if FChromium.Browser <> nil then
  begin
    Lframe := FChromium.Browser.MainFrame;
    case FNewsType of
      ntLatest: begin
        LStr2 := '[최신뉴스]';
        source := Lframe.Text;
        LCount := strWordCount(source, LStr2);
        LStr := GetToken(source, LStr2);
        FNewsList.Clear;

        for i := 1 to LCount do
        begin
          LStr := GetToken(source, LStr2);
          FNewsList.Add(LStr);
        end;
      end;

      ntMain: begin
        LStr2 := '뉴스 > 전체';
        source := Lframe.Text;
        if source <> '' then
        begin
          GetToken(source, LStr2);
          FNewsList.Clear;

          while true do
          begin
            LStr := GetToken(source, #10);
            LStr := GetToken(source, #10);
            LStr := GetToken(source, #10);

            if Pos('관련뉴스', LStr) > 0 then
              LStr := GetToken(source, #10);

            if (LStr = '') or (LStr = '12345678910') then
              break;

            FNewsList.Add(LStr);
          end;
        end;
      end;
    end;
  end;

  AAFadeText1.Text.Lines.Clear;
  AAFadeText1.Text.Lines.AddStrings(FNewsList);
//  memo1.Lines.AddStrings(FNewsList);
end;

procedure TMainF.GetNews2Memo2;
var
  Lframe: ICefFrame;
  source: string;
  LStr, LStr2: string;
  i, LCount: integer;
  doc, doc2: IHTMLDocument2;
  ArrayV, ArrayV2: OleVariant;
  LStrList: TStringList;
begin
  if FChromium.Browser <> nil then
  begin
    Lframe := FChromium.Browser.MainFrame;
    source := Lframe.Source;

    if pos('[최신뉴스]', source) = 0 then
      exit;

    FNewsList.Clear;

    doc := coHTMLDocument.Create as IHTMLDocument2;
    try
      ArrayV := VarArrayCreate([0,0], varVariant);
      ArrayV[0] := source;
      doc.write(PSafeArray(TVarData(ArrayV).VArray));
//      doc.write(source);
      doc.close;

      LStrList := TStringList.Create;
      try
        GetInnersByClass(doc,'subject',LStrList);
        LStr := '<html><body>Source:<pre>' + LStrList.Text + '</pre></body></html>';
  //      GetTitleByClass(LStr, 'tit', LStrList);
        doc2 := coHTMLDocument.Create as IHTMLDocument2;
        ArrayV2 := VarArrayCreate([0,0], varVariant);
        ArrayV2[0] := LStr;
        doc2.write(PSafeArray(TVarData(ArrayV2).VArray));
//        doc2.write(LStr);
        doc2.close;
        FNewsList.Clear;
        GetInnersByClass(doc2,'tit',FNewsList,'A');
  //      GetInnersByTagName(doc,'A',LStrList);
  //      memo1.Lines.Add(LStrList.Text);
      finally
        LStrList.Free;
//        doc2 := UnAssigned;
      end;
    finally
//      doc := UnAssigned;
    end;
//    ShowMessage(doc.body.innerHTML);
//    for i := 0 to doc.body.all.length - 1 do
//    begin
//      el := doc.body.all.item(i);
//      if (el.tagName = 'ul') and (el.className = 'subject') then
//        ShowMessage(el.innerText);
//    end;

//    case FNewsType of
//      ntLatest: begin
//      end;
//
//      ntMain: begin
//
//            FNewsList.Add(LStr);
//      end;
//    end;//case
  end;

  if FNewsList.Count = 0 then
    FPJHTimerPool.AddOneShot(OnGetNews, 2000);

  AAFadeText1.Text.Lines.Clear;

  for i := 0 to FNewsList.Count - 1 do
    AAFadeText1.Text.Lines.Add('('+IntToStr(i+1)+') ' + FNewsList.Strings[i]);
//  AAFadeText1.Text.Lines.AddStrings(FNewsList);
  LStr := Copy(Caption, 1, Pos(' => ', Caption) - 1);

  if LStr = '' then
    LStr := Caption;

  Caption := LStr + ' => ' + IntToStr(FNewsList.Count) + ' News Updated: ' + FormatDateTime('mm월 dd일, hh:nn:ss', now);
end;

procedure TMainF.GetQuery1Click(Sender: TObject);
begin
//  ShowMessage(getContent('http://hhibwp.hhi.co.kr:8000/sap/bc/bsp/sap/zbwxa_bsp/data.xml?infocube=ZKSDSOM01&sap-user=KEAASC0&sap-password=keaasc00&query=ZKA_ZKSDSOM02_D_T_Q206&VAR_NAME_1=ZCALDAY01&VAR_VALUE_EXT_1=20150224'));
end;

function TMainF.GetQueryClass(AQueryName: string): TBWQryClass;
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

procedure TMainF.GetTitleByClass(const AHtml, classname: string;
  var Lst: TStringList);
var
  LXMLDoc: IXMLDocument;
  LRootNode, LSubNode: IXMLNode;
  i: integer;
begin
  LXMLDoc := CreateXMLDoc;
  try
    LXMLDoc.LoadXML(AHtml);

    if LXMLDoc.DocumentElement <> nil then
    begin
      LRootNode := LXMLDoc.DocumentElement;

      for i := 0 to LRootNode.ChildNodes.Length - 1 do
      begin
        LSubNode := LRootNode.ChildNodes.Item[i];

        if LSubNode.NodeName = 'A' then
        begin
          Lst.Add(LSubNode.NodeValue);
        end;
      end;
    end;
  finally
    LXMLDoc := nil;
  end;

end;

procedure TMainF.Header1Click(Sender: TObject);
begin
  QryData2DataView(TMenuItem(Sender).Hint);
end;

procedure TMainF.Header2Click(Sender: TObject);
begin
  QryData2DataView(TMenuItem(Sender).Hint);
end;

procedure TMainF.HEADER3Click(Sender: TObject);
begin
  QryData2DataView(TMenuItem(Sender).Hint);
end;

procedure TMainF.imer1Click(Sender: TObject);
begin
//  Timer1Timer(nil);
//  Timer1.Enabled := not Timer1.Enabled;
end;

procedure TMainF.InitVar;
var
  LBWQryClass: TBWQryClass;
begin
  FPJHTimerPool := TPJHTimerPool.Create(nil);
  FBWQryList := TDictionary<string, TBWQryClass>.Create;
  LBWQryClass := TBWQryClass.Create(nil);
  LoadQueryListFromTxt;

  FPJHTimerPool.AddOneShot(OnGetBWQuery, 500);
  AdvGridExcelIO1.XLSImport('E:\pjh\project\util\RMIS\매출샘플.xls');
//  FChromium.DefaultUrl := KBS_NEWS_MAIN_URL;
//  FChromium := TChromium.Create(nil);
//  FChromium.OnLoadEnd := FChromiumLoadEnd;
  FNewsList := TStringList.Create;

  CreateChartSeries(SalesChart, NUM_OF_SALES_SERIES);
  CreateChartSeries(ProfitChart, NUM_OF_PROFIT_SERIES);
  CreateChartDonutSeries(OrderChart2);
end;

procedure TMainF.ListCitiesClick(Sender: TObject);
var tmp : Integer;
begin
  tmp := CurrentCity;
  ChartTool9.Text:=PointSeries1.XLabel[ tmp ];
  ChartTool9.Visible:=True;
  ChartTool9.Callout.XPosition:=PointSeries1.CalcXPos(tmp);
  ChartTool9.Callout.YPosition:=PointSeries1.CalcYPos(tmp);
  ChartTool9.Callout.Arrow.Show;
end;

procedure TMainF.LoadCityList;
var t : Integer;
begin
  ListCities.Clear;
  ListCities.Sorted:=False;

  for t := 0 to PointSeries1.Count-1 do
    ListCities.Items.AddObject(PointSeries1.XLabel[t],TObject(t));

  ListCities.Sorted:=True;
end;

procedure TMainF.LoadMap;
  procedure LoadMapFromResource(Series:TMapSeries;
                                const ShpName,ShxName:String);
  var shp : TResourceStream;
      shx : TResourceStream;
  begin
    shp:=TeeResourceStream(ShpName);
    try
      shx:=TeeResourceStream(ShxName);
      try
        VCLTee.TeeSHP.LoadMap(Series,shp,shx, nil, 'CNTRY_NAME', 'POP_CNTRY');
      finally
        shx.Free;
      end;
    finally
      shp.Free;
    end;
  end;

var tmpGrad : TCustomTeeGradient;
    Old : Char;
begin
  case ComboFlat1.ItemIndex of
    0: LoadMapFromResource(WorldSeries1,'TeeWorldShp','TeeWorldShx');
    1: LoadMapFromResource(WorldSeries1,'TeeUSAStatesShp','TeeUSAStatesShx');
  else
    LoadMapFromResource(WorldSeries1,'TeeSpainShp','TeeSpainShx');
  end;

  // When loading the USA States map, set axes to zoom on 50 USA States
  case ComboFlat1.ItemIndex of
    1: begin
         Chart7.Axes.Left.SetMinMax(24,50);
         Chart7.Axes.Bottom.SetMinMax(-125,-67);
         SeriesTextSource1.Close;
         SeriesTextSource1.FileName := WhereIsFile('USACities.txt');

         // Force decimal separator character to: ","
         Old:={$IFDEF D15}FormatSettings.{$ENDIF}DecimalSeparator;

         {$IFDEF D15}FormatSettings.{$ENDIF}DecimalSeparator:='.';
         try
           SeriesTextSource1.Open;
         finally
           FormatSettings.DecimalSeparator := Old;
         end;
       end;
    0: begin
         Chart7.Axes.Left.SetMinMax(-90,90);
         Chart7.Axes.Bottom.SetMinMax(-180,180);
         TWorldSeries.AddCities(PointSeries1);
       end;
    else
    begin
      Chart7.Axes.Left.Automatic:=True;
      Chart7.Axes.Bottom.Automatic:=True;
    end;
  end;//case

  LoadCityList;

  PointSeries1.Pointer.HorizSize := 3;
  PointSeries1.Pointer.VertSize := 3;
  ChartTool9.Visible:=false;

  WorldSeries1.UseColorRange:= Random(100)<50;

  if WorldSeries1.UseColorRange then
  begin
    tmpGrad:=TCustomTeeGradient.Create(nil);
    try
      TTeeGradientEditor.DefaultGradient(tmpGrad, True,
                            Random(TeeMaxSampleGradient+1));
      WorldSeries1.StartColor:=tmpGrad.StartColor;
      WorldSeries1.MidColor:=tmpGrad.MidColor;
      WorldSeries1.EndColor:=tmpGrad.EndColor;
    finally
      tmpGrad.Free;
    end;
  end
  else
  begin
    WorldSeries1.UsePalette:=True;
    WorldSeries1.PaletteStyle:=TTeePaletteStyle(Random(1+Ord(psRainbow)));
  end;
end;

procedure TMainF.LoadQueryListFromTxt;
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

      FBWQryList.Add(LBWQryClass.QueryName, LBWQryClass);
    end;
  finally
    LBWQryListClass.Free;
  end;
end;

procedure TMainF.N10Click(Sender: TObject);
begin
  QryData2DataView(TMenuItem(Sender).Hint);
end;

procedure TMainF.N11Click(Sender: TObject);
begin
  QryData2DataView(TMenuItem(Sender).Hint);
end;

procedure TMainF.N1Click(Sender: TObject);
var
  LStr: string;
begin
  LStr := TMenuItem(Sender).Hint; //Get Query Name
  QryData2DataView(LStr);
end;

procedure TMainF.N2Click(Sender: TObject);
begin
  QryData2DataView(TMenuItem(Sender).Hint);
end;

procedure TMainF.N3Click(Sender: TObject);
begin
  QryData2DataView(TMenuItem(Sender).Hint);
end;

procedure TMainF.N4Click(Sender: TObject);
begin
  QryData2DataView(TMenuItem(Sender).Hint);
end;

procedure TMainF.N5Click(Sender: TObject);
begin
  QryData2DataView(TMenuItem(Sender).Hint);
end;

procedure TMainF.N6Click(Sender: TObject);
begin
  QryData2DataView(TMenuItem(Sender).Hint);
end;

procedure TMainF.N7Click(Sender: TObject);
begin
  QryData2DataView(TMenuItem(Sender).Hint);
end;

procedure TMainF.N8Click(Sender: TObject);
begin
  QryData2DataView(TMenuItem(Sender).Hint);
end;

procedure TMainF.N9Click(Sender: TObject);
begin
  QryData2DataView(TMenuItem(Sender).Hint);
end;

procedure TMainF.OnGetBWQuery(Sender: TObject; Handle: Integer;
  Interval: Cardinal; ElapsedTime: Integer);
begin
  Parallel.Async(GetBWQuery, Parallel.TaskConfig.OnTerminated(OnGetBWQueryCompleted));
//  GetMainNews;
end;

procedure TMainF.OnGetBWQueryCompleted(const task: IOmniTaskControl);
begin
  QProgress1.Active := False;
  FQryRunning := False;
  Panel1.Caption := '완료';
  QryData2Chart;
  FPJHTimerPool.AddOneShot(OnGetBWQuery, 60000);
end;

procedure TMainF.OnGetNews(Sender: TObject; Handle: Integer; Interval: Cardinal;
  ElapsedTime: Integer);
begin
//  GetMainNews;
end;

//부문별 수주 현황(도넛차트)
procedure TMainF.Order2Data2Chart;
var
  LBWQryClass: TBWQryClass;
  LBWQryCellDataItem: TBWQryCellDataItem;
  i, j, LRow, LCol: integer;
  LDouble: double;
  LSum: array of string;
  LStr: string;
begin
  SetLength(LSum, 5);

  ClearChartDnoutSeries(OrderChart2);

  LBWQryClass := GetQueryClass('ZKA_ZKSDSOM01_D_T_Q227'); //수주총괄

  //부문별 리스트 가져오기, 0번째(합계)는 제외
  for i := 1 to LBWQryClass.BWQryRowHeaderCollect.Count - 1 do
    LSum[i-1] := LBWQryClass.BWQryRowHeaderCollect.Items[i].RowHeaderData;

  for i := 0 to LBWQryClass.BWQryCellDataCollect.Count - 1 do
  begin
    LRow := LBWQryClass.BWQryCellDataCollect.Items[i].Row;
    LCol := LBWQryClass.BWQryCellDataCollect.Items[i].Col;

    if LRow > 0 then  //합계는 제외
    begin
      LStr := LBWQryClass.BWQryCellDataCollect.Items[i].CellData;
      LStr := StringReplace(LStr, ',', '', [rfReplaceAll, rfIgnoreCase]);
      LDouble := StrToFloatDef(LStr, 0.0);
      j := TDonutSeries(OrderChart2.Series[0]).AddPie(LDouble);
//       .Add(LDouble);//, LongMonthNames[LCol+1]);
      OrderChart2.Series[0].ValueMarkText[j] := LSum[LRow];
    end;
  end;

  LSum := nil;
end;

//월별 수주 현황(바차트)
procedure TMainF.OrderData2Chart;
begin

end;

procedure TMainF.Panel1Click(Sender: TObject);
begin
  if AdvOfficePager1.ActivePageIndex = AdvOfficePager1.AdvPageCount - 1 then
    AdvOfficePager1.ActivePageIndex := 0
  else
    AdvOfficePager1.ActivePageIndex := AdvOfficePager1.ActivePageIndex + 1;
end;

procedure TMainF.ProcessQueryXML(AXMLString: string);
var
  LXMLDoc: IXMLDocument;
  LRootNode, LSubNode, LLeafNode, LLeafNode2: IXMLNode;
  LBWQryClass: TBWQryClass;
  LBWQryCellDataItem: TBWQryCellDataItem;
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
        LSubNode := LRootNode.ChildNodes.Item[i];

        if LSubNode.NodeName = 'variable' then
        begin
          if LSubNode.Attributes.Length > 0 then
          begin
            if LSubNode.Attributes.Item[0].NodeValue = 'colHeader' then
            begin
              LSubNode := LSubNode.ChildNodes.Item[0];

              if LSubNode.NodeName = 'row' then
              begin
                LBWQryClass := GetCurQryClass;
                LBWQryClass.BWQryColumnHeaderCollect.Clear;

                for j := 0 to LSubNode.ChildNodes.Length - 1 do
                begin
                  LLeafNode := LSubNode.ChildNodes.Item[j];

                  if LLeafNode.NodeName = 'column' then
                  begin
                    if LLeafNode.HasChildNodes then
                    begin
                      LLeafNode := LLeafNode.ChildNodes.Item[0];//CDATA Section
                      LBWQryClass.BWQryColumnHeaderCollect.Add.ColumnHeaderData := LLeafNode.NodeValue;
                    end;
                  end;
                end;//for
              end;
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
                  LLeafNode := LLeafNode.ChildNodes.Item[0];

                  if LLeafNode.NodeName = 'column' then
                  begin
                    if LLeafNode.HasChildNodes then
                    begin
                      LLeafNode := LLeafNode.ChildNodes.Item[0];//CDATA Section
                      LBWQryClass.BWQryRowHeaderCollect.Add.RowHeaderData := LLeafNode.NodeValue;
                    end;
                  end;
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
    LXMLDoc := nil;
  end;
end;

procedure TMainF.ProfitData2Chart;
var
  tmp : TChartSeries;
  LKey, LStr: string;
  LBWQryClass: TBWQryClass;
  LBWQryCellDataItem: TBWQryCellDataItem;
  i, j, LRow, LCol: integer;
  LDouble: double;
  LSum: array of string;
begin
  SetLength(LSum, 12);

//  CreateChartSeries(ProfitChart, NUM_OF_PROFIT_SERIES);
  ClearChartSeries(ProfitChart);

  LBWQryClass := GetQueryClass('ZKA_ZKEISM003_D_C_Q001'); //손익총괄(월별)

  //부문별 리스트 가져오기, 0번째(실적합계)와 6번째(계획합계)는 제외
  for i := 1 to LBWQryClass.BWQryRowHeaderCollect.Count - 2 do
  begin
    LStr := StringReplace(LBWQryClass.BWQryRowHeaderCollect.Items[i].RowHeaderData, '실적_', '', [rfReplaceAll, rfIgnoreCase]);
    LStr := StringReplace(LStr, '_손익', '', [rfReplaceAll, rfIgnoreCase]);
    ProfitChart.Series[i-1].Title := LStr;
  end;

  ProfitChart.Series[i-1].Title := '계획';

  for i := 0 to LBWQryClass.BWQryCellDataCollect.Count - 1 do
  begin
    LRow := LBWQryClass.BWQryCellDataCollect.Items[i].Row;
    LCol := LBWQryClass.BWQryCellDataCollect.Items[i].Col;

    if (LRow <> 0) and (LRow <> 7) then  //합계는 제외
    begin
      LStr := LBWQryClass.BWQryCellDataCollect.Items[i].CellData;
      LStr := StringReplace(LStr, ',', '', [rfReplaceAll, rfIgnoreCase]);
      LDouble := StrToFloatDef(LStr, 0.0);
      j := ProfitChart.Series[LRow-1].Add(LDouble, LongMonthNames[LCol+1]);

      if ProfitChart.Series[LRow-1].Marks.Visible then
        ProfitChart.Series[LRow-1].ValueMarkText[j] := LSum[LCol];
    end
    else
    if LRow = 0 then//합계를 배열에 저장함
    begin
      LSum[LCol] := LBWQryClass.BWQryCellDataCollect.Items[i].CellData;
    end;
  end;

  LBWQryClass := GetQueryClass('ZKA_ZKEISM003_D_C_Q001B'); //손익 추정 계획(월별)
  for i := 0 to LBWQryClass.BWQryCellDataCollect.Count - 1 do
  begin
    LRow := LBWQryClass.BWQryCellDataCollect.Items[i].Row;
    LCol := LBWQryClass.BWQryCellDataCollect.Items[i].Col;
//    memo1.Lines.Add(IntToStr(Lcol) + ':' + IntToStr(LRow)); // => 0:0, 1:0 순으로 저장 됨

    if LRow = 0 then  //손익 추정 합계(월별)
    begin
      LStr := LBWQryClass.BWQryCellDataCollect.Items[i].CellData;
      LStr := StringReplace(LStr, ',', '', [rfReplaceAll, rfIgnoreCase]);
      LDouble := StrToFloatDef(LStr, 0.0);
      j := ProfitChart.Series[ProfitChart.SeriesCount-1].Add(LDouble, LongMonthNames[LCol+1]);

      if ProfitChart.Series[ProfitChart.SeriesCount-1].Marks.Visible then
        ProfitChart.Series[ProfitChart.SeriesCount-1].ValueMarkText[j] := LSum[LCol];
    end;
  end;

  LSum := nil;
end;

procedure TMainF.QryData2Chart;
begin
  SalesData2Chart;
  ProfitData2Chart;
//  Order2Data2Chart;
end;

procedure TMainF.QryData2DataView(AQueryName: string);
var
  LBWQryClass: TBWQryClass;
  LDataViewF: TDataViewF;
  LXlsFileName: string;
  i, LCol, LRow: integer;
begin
  LBWQryClass := nil;
  LBWQryClass := GetQueryClass(AQueryName);

  if Assigned(LBWQryClass) then
  begin
    LDataViewF := TDataViewF.Create(Self);
    try
      LXlsFileName := ExtractFilePath(Application.ExeName) + 'Maps\' + AQueryName + '.xls';
      LDataViewF.AdvGridExcelIO1.XLSImport(LXlsFileName);

      for i := 0 to LBWQryClass.BWQryCellDataCollect.Count - 1 do
      begin
        LCol := LBWQryClass.BWQryCellDataCollect.Items[i].Col+1;
        LRow := LBWQryClass.BWQryCellDataCollect.Items[i].Row+2;
        LDataViewF.AdvGridWorkbook1.Grid.Cells[LCol, LRow] := LBWQryClass.BWQryCellDataCollect.Items[i].CellData;
      end;

      LDataViewF.Panel1.Caption := LBWQryClass.Description;
      LDataViewF.ShowModal;
    finally
      LDataViewF.Free;
    end;
  end;
end;

procedure TMainF.SalesData2Chart;
var
  tmp : TChartSeries;
  LKey, LStr: string;
  LBWQryClass: TBWQryClass;
  LBWQryCellDataItem: TBWQryCellDataItem;
  i, j, LRow, LCol: integer;
  LDouble: double;
  LSum: array of string;
begin
  SetLength(LSum, 12);

//  CreateChartSeries(SalesChart, NUM_OF_SALES_SERIES);
  ClearChartSeries(SalesChart);

  LBWQryClass := GetQueryClass('ZKA_ZKSDBIM01_D_T_Q206'); //총괄매출

  //제품별 리스트 가져오기, 0번째는 합계이므로 제외
  for i := 1 to LBWQryClass.BWQryRowHeaderCollect.Count - 1 do
  begin
    SalesChart.Series[i-1].Title := LBWQryClass.BWQryRowHeaderCollect.Items[i].RowHeaderData;
  end;

  SalesChart.Series[i-1].Title := '계획';

  LBWQryClass := GetQueryClass('ZKA_ZKSDBIM01_D_C_Q225'); //총괄매출(월별실적 및 계획))
  //월별 계획 가져옴
  for i := 0 to LBWQryClass.BWQryCellDataCollect.Count - 1 do
  begin
    LRow := LBWQryClass.BWQryCellDataCollect.Items[i].Row;
    LCol := LBWQryClass.BWQryCellDataCollect.Items[i].Col;

    if LRow = 6 then //계획-합계 Row 임
    begin
      LStr := LBWQryClass.BWQryCellDataCollect.Items[i].CellData;
      LStr := StringReplace(LStr, ',', '', [rfReplaceAll, rfIgnoreCase]);
      LDouble := StrToFloatDef(LStr, 0.0);
      j := SalesChart.Series[LRow-1].Add(LDouble, LongMonthNames[LCol+1]);
    end;
  end;

  LBWQryClass := GetQueryClass('ZKA_ZKSDBIM01_D_C_Q226'); //총괄 매출(월추정추이)
  //부문별로 시리즈에 데이터 할당
  for i := 0 to LBWQryClass.BWQryCellDataCollect.Count - 1 do
  begin
     //합계 월별 매출 데이터(LRow = 0)
     //박용기계 월별 매출 데이터(LRow = 1)
     //엔진발전 월별 매출 데이터(LRow = 2)
     //산업기계 월별 매출 데이터(LRow = 3)
     //로봇시스템 월별 매출 데이터(LRow = 4)
     //글로벌서비스 월별 매출 데이터(LRow = 5)
    LRow := LBWQryClass.BWQryCellDataCollect.Items[i].Row;
    LCol := LBWQryClass.BWQryCellDataCollect.Items[i].Col;
//    memo1.Lines.Add(IntToStr(Lcol) + ':' + IntToStr(LRow)); // => 0:0, 1:0 순으로 저장 됨

    if LRow > 0 then  //합계는 제외
    begin
      LStr := LBWQryClass.BWQryCellDataCollect.Items[i].CellData;
      LStr := StringReplace(LStr, ',', '', [rfReplaceAll, rfIgnoreCase]);
      LDouble := StrToFloatDef(LStr, 0.0);
      j := SalesChart.Series[LRow-1].Add(LDouble, LongMonthNames[LCol+1]);

      if SalesChart.Series[LRow-1].Marks.Visible then
        SalesChart.Series[LRow-1].ValueMarkText[j] := LSum[LCol];
//      SalesChart.Series[LRow-1].XLabel[LCol+1] := LongMonthNames[LCol+1];
    end
    else//합계를 배열에 저장함
    begin
      LSum[LCol] := LBWQryClass.BWQryCellDataCollect.Items[i].CellData;
    end;
  end;

  LSum := nil;
end;

procedure TMainF.ScreenNavi1Click(Sender: TObject);
begin
  Timer2.Enabled := not Timer2.Enabled;
end;

procedure TMainF.SpeedButton5Click(Sender: TObject);
begin
  if FChromium.Browser <> nil then
    FChromium.Browser.MainFrame.LoadUrl(edAddress.Text);
end;

procedure TMainF.Timer1Timer(Sender: TObject);
var
  i: integer;
begin
  OrderChart.Series[0].Clear;
  OrderChart.Series[1].Clear;
//  Chart1.Series[2].Clear;
  SalesChart.Series[0].Clear;
  SalesChart.Series[1].Clear;
//  Chart2.Series[2].Clear;
  ProfitChart.Series[0].Clear;
  ProfitChart.Series[1].Clear;
//  Chart3.Series[2].Clear;

  for i := 1 to 12 do
  begin
    OrderChart.Series[0].Add( Random(1000), LongMonthNames[i]);
    SalesChart.Series[0].Add( Random(1000), LongMonthNames[i]);
    ProfitChart.Series[0].Add( Random(1000), LongMonthNames[i]);
  end;

  for i := 1 to 12 do
  begin
    OrderChart.Series[1].Add( Random(1000));
    SalesChart.Series[1].Add( Random(1000));
    ProfitChart.Series[1].Add( Random(1000));
  end;

end;

procedure TMainF.Timer2Timer(Sender: TObject);
begin
  if AdvOfficePager1.ActivePageIndex = AdvOfficePager1.AdvPageCount - 1 then
    AdvOfficePager1.ActivePageIndex := 0
  else
    AdvOfficePager1.ActivePageIndex := AdvOfficePager1.ActivePageIndex + 1;
end;

function TMainF.WhereIsFile(const FileName: String): String;
begin
  if FileExists(FileName) then
     result:=FileName
  else
  if FileExists('Maps\'+FileName) then
     result:='Maps\'+FileName
  else
  if FileExists('..\Maps\'+FileName) then
     result:='..\Maps\'+FileName
  else
     result:='';
end;

end.
