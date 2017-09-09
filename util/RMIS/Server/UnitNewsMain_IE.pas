unit UnitNewsMain_IE;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, MSHTML, Activex,
  Vcl.ComCtrls, Vcl.StdCtrls, Vcl.Buttons, Vcl.ExtCtrls, TimerPool, OmniXML, OmniXMLUtils, OmniXMLXPath,
  AAFont, AACtrls, Vcl.OleCtrls, SHDocVw, UnitNewsInterface, OtlTask,
  OtlCommon, OtlCollections, OtlParallel, OtlTaskControl, OtlSync,
  SynCommons, mORMot, mORMotSQLite3, mORMotHttpServer, UnitFrameCommServer,
  AdvOfficePager, UnitNewsConfig, Vcl.Menus, ralarm, mORMotHttpClient,
  UnitHhiOfficeNewsInterface, UnitRSSAddressClass, SortCollections,
  // NativeXml component
  NativeXml,
  NativeXmlNodes,
  NativeXmlCodepages;


const
  KBS_NEWS_LATEST_URL = 'http://news.kbs.co.kr/news/NewsCategory.do?SEARCH_SECTION=0001&SEARCH_CATEGORY=0004';
  KBS_NEWS_MAIN_URL = 'http://news.kbs.co.kr/news/NewsCategory.do?SEARCH_SECTION=0001&&source=http://news.kbs.co.kr/common/NewsMain.html';
  SHIP_OCEAN_NEWS_FILE = 'c:\private\sonews.txt';

type
  TServiceNewsList = class(TInterfacedObject, INewsList)
  public
    function GetNewsList: TRawUTF8DynArray;  //RSS 뉴스
    function GetNewsList2: TRawUTF8DynArray; //일간 조선 해양 뉴스
    function GetRSSNewsList(out ACollect: TRSSNewsList): Boolean;  //RSS 뉴스
  end;

  TMainForm = class(TForm)
    StatusBar1: TStatusBar;
    Panel6: TPanel;
    AAFadeText1: TAAFadeText;
    AdvOfficePager1: TAdvOfficePager;
    AdvOfficePager11: TAdvOfficePage;
    AdvOfficePager12: TAdvOfficePage;
    WebBrowser1: TWebBrowser;
    FCS: TFrameCommServer;
    Panel20: TPanel;
    SpeedButton1: TSpeedButton;
    SpeedButton2: TSpeedButton;
    SpeedButton3: TSpeedButton;
    SpeedButton4: TSpeedButton;
    SpeedButton5: TSpeedButton;
    edAddress: TEdit;
    MainMenu1: TMainMenu;
    File1: TMenuItem;
    Etc1: TMenuItem;
    Close1: TMenuItem;
    Config1: TMenuItem;
    N1: TMenuItem;
    N2: TMenuItem;
    AlarmFromTo1: TAlarmFromTo;
    Edit1: TEdit;
    RSSAddressConfig1: TMenuItem;
    AdvOfficePage1: TAdvOfficePage;
    ListView1: TListView;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure SpeedButton5Click(Sender: TObject);
    procedure FCSServerStartBtnClick(Sender: TObject);
    procedure FCSServerStopBtnClick(Sender: TObject);
    procedure AAFadeText1Complete(Sender: TObject);
    procedure Close1Click(Sender: TObject);
    procedure Config1Click(Sender: TObject);
    procedure AAFadeText1Click(Sender: TObject);
    procedure N1Click(Sender: TObject);
    procedure AlarmFromTo1AlarmBegin(Sender: TObject);
    procedure RSSAddressConfig1Click(Sender: TObject);
  private
    FPJHTimerPool: TPJHTimerPool;
    FNewsList: TStringList; //KBS News
    FNewsList2: TStringList;//일간조선해양 뉴스

    FModel: TSQLModel;
    FHTTPServer: TSQLHttpServer;
    FRestServer: TSQLRestServer;

    FClient_HhiOfficeNews: TSQLRestClientURI;
    FModel_HhiOfficeNews: TSQLModel;
    Server_HhiOfficeNews: AnsiString;
    PortNum_HhiOfficeNews: string;
    FClient_Connected: Boolean;

    FNewCount: integer;

    procedure OnGetNews(Sender : TObject; Handle : Integer;
            Interval : Cardinal; ElapsedTime : LongInt);
    procedure OnGetNews1(Sender : TObject; Handle : Integer;
            Interval : Cardinal; ElapsedTime : LongInt);
    procedure OnGetNews1Refresh(Sender : TObject; Handle : Integer;
            Interval : Cardinal; ElapsedTime : LongInt);
    procedure OnGetNews2(Sender : TObject; Handle : Integer;
            Interval : Cardinal; ElapsedTime : LongInt);

    procedure StartServer;
    procedure GetMainNews;

    function GetInnersByClass(const Doc: IDispatch; const classname: string;var Lst:TStringList; ATagName: string = ''): Integer;
    function GetInnersByTagName(const Doc: IDispatch; const TagName: string;var Lst:TStringList): Integer;
    procedure GetTitleByClass(const AHtml, classname: string; var Lst:TStringList);
    procedure GetNews1;
    procedure GetNews2;
    procedure GetRSS;
    function HttpGet(url: string; var page: string): boolean;
    function GetRSSXML(url: TOmniValue; var page: string): boolean;
    procedure ParallelRSSRetriever;
    procedure Retriever(const input: TOmniValue; var output: TOmniValue);
    procedure Inserter(const input, output: IOmniBlockingCollection);
    procedure SetRSSNewsList(ANewsList: TRSSNewsList);
  protected
    FSettings : TConfigSettings;
    FOnGetNewsHandle: integer;
    FRSSAddressInfo: TRSSAddressInfo;
    FRSSFetchPipeline: IOmniPipeline;
    FRSSNewsList: TRSSNewsList;
  public
    FNewsOmniMREW : TOmniMREW;

    procedure InitVar;
    procedure DestroyVar;

    procedure ConnectToHhiOfficeNewsServer;
    procedure CreateHTTPClient_HhiOfficeNews(AServerIP: string);
    procedure DestroyHTTPClient_HhiOfficeNews;

    function GetNewsService: TRawUTF8DynArray;
    function GetNewsService2: TRawUTF8DynArray;

    procedure GetHhiOfficeNewsFromServer;

    procedure LoadConfigFromFile(AFileName: string = '');
    procedure LoadConfig2Form(AForm: TConfigF);
    procedure LoadConfigForm2Object(AForm: TConfigF);
    procedure SetConfig;
    procedure ApplyUI;
  end;

var
  MainForm: TMainForm;
  g_GetNewsListRunning: Boolean;

implementation

uses WebBrowserUtil, UnitRSSAddrEdit, IdHTTP, IdGlobalProtocols;

{$R *.dfm}

PROCEDURE ReplaceCharacterEntities (VAR Str : STRING);
VAR
  Start  : INTEGER;
  PAmp   : PChar;
  PSemi  : PChar;
  PosAmp : INTEGER;
  Len    : INTEGER;
BEGIN
  IF Str = '' THEN EXIT;
  Start := 1;
  Str := StringReplace(Str,#$A,'',[rfReplaceAll, rfIgnoreCase]);
  Str := StringReplace(Str,#9,'',[rfReplaceAll, rfIgnoreCase]);
  REPEAT
    PAmp := StrPos (PChar (Str) + Start-1, '&#');
    IF PAmp = NIL THEN BREAK;
    PSemi := StrScan (PAmp+2, ';');
    IF PSemi = NIL THEN BREAK;
    PosAmp := PAmp - PChar (Str) + 1;
    Len    := PSemi-PAmp+1;
    IF CompareText (Str [PosAmp+2], 'x') = 0
      THEN Str [PosAmp] := CHR (StrToIntDef ('$'+Copy (Str, PosAmp+3, Len-4), 0))
      ELSE Str [PosAmp] := CHR (StrToIntDef (Copy (Str, PosAmp+2, Len-3), 32));
    Delete (Str, PosAmp+1, Len-1);
    Start := PosAmp + 1;
  UNTIL FALSE;
END;

//Extrae unicamente el Texto del HTML si es que lo tiene
FUNCTION TextFromHTML(s: string):string;
var
  IsText: Boolean;
  i: Integer;
begin
  result := '';
  IsText := true;

  for i := 1 to Length(s) do begin
    if s[i] = '<' then IsText := false;
    if IsText then result := result + s[i];
    if s[i] = '>' then IsText := true;
  end;

  Result := StringReplace(Result, '&quot;', '"',  [rfReplaceAll]);
  Result := StringReplace(Result, '&apos;', '''', [rfReplaceAll]);
  Result := StringReplace(Result, '&gt;',   '>',  [rfReplaceAll]);
  Result := StringReplace(Result, '&lt;',   '<',  [rfReplaceAll]);
  Result := StringReplace(Result, '&amp;',  '&',  [rfReplaceAll]);
  Result := StringReplace(Result, '&nbsp;',  ' ',  [rfReplaceAll]);
end;

procedure TMainForm.AAFadeText1Click(Sender: TObject);
begin
  OnGetNews1(nil,0,0,0);
end;

procedure TMainForm.AAFadeText1Complete(Sender: TObject);
begin
//  GetMainNews;
//  ShowMessage('AAFadeText1Complete');
//  AAFadeText1.Text.Lines.Add(IntToStr(Random(100)));
//  AAFadeText1.Active := True;
end;

procedure TMainForm.AlarmFromTo1AlarmBegin(Sender: TObject);
begin
  GetHhiOfficeNewsFromServer;
end;

procedure TMainForm.ApplyUI;
begin
  AlarmFromTo1.ActiveBegin := False;
  AlarmFromTo1.AlarmTimeBegin := FSettings.ServerTimeToGetHhiOfficeNews;
  AlarmFromTo1.ActiveBegin := True;
end;

procedure TMainForm.Close1Click(Sender: TObject);
begin
  Close;
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
      FModel_HhiOfficeNews := TSQLModel.Create([],NEWS_ROOT_NAME);

    FClient_HhiOfficeNews := TSQLHttpClient.Create(AServerIP,NEWS_PORT_NAME, FModel_HhiOfficeNews);

    if not FClient_HhiOfficeNews.ServerTimeStampSynchronize then
    begin
      //ShowMessage(UTF8ToString(FClient_News.LastErrorMessage));
      DestroyHTTPClient_HhiOfficeNews;
      exit;
    end;

    //TSQLRestServerAuthenticationNone.ClientSetUser(Client,'User','');
    FClient_HhiOfficeNews.SetUser('User','synopse');
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
  FCS.DisplayMessage(FormatDateTime('mm월 dd일, hh:nn:ss', now) + ' : CreateHTTPClient_HhiOfficeNews', dtSystemLog);
  FClient_Connected := False;
end;

procedure TMainForm.DestroyVar;
begin
  FRSSNewsList.Free;
  FRSSAddressInfo.Free;

  FNewsList.Free;
  FNewsList2.Free;
//  FChromium.Free;
  FPJHTimerPool.RemoveAll;
  FPJHTimerPool.Free;
  FSettings.Free;

  FCS.DestroyHttpServer;
end;

procedure TMainForm.FCSServerStartBtnClick(Sender: TObject);
begin
  StartServer;
end;

procedure TMainForm.FCSServerStopBtnClick(Sender: TObject);
begin
  FCS.ServerStopBtnClick(Sender);
end;

procedure TMainForm.FormCreate(Sender: TObject);
begin
  InitVar;
end;

procedure TMainForm.FormDestroy(Sender: TObject);
begin
  DestroyVar;
end;

procedure TMainForm.GetHhiOfficeNewsFromServer;
var
  I: IHhiOfficeNewsList;
  LDynArr: TRawUTF8DynArray;
  Li,LRow: integer;
begin
  LDynArr := nil;

  if not Assigned(FClient_HhiOfficeNews) then
    ConnectToHhiOfficeNewsServer;

  if not Assigned(FClient_HhiOfficeNews) then
  begin
    FCS.DisplayMessage(FormatDateTime('mm월 dd일, hh:nn:ss', now) + ' : GetNewsFromServer Error => not Assigned(FClient_HhiOfficeNews)', dtSystemLog);
    exit;
  end;

  I := FClient_HhiOfficeNews.Service<IHhiOfficeNewsList>;

  try
    if I <> nil then
      LDynArr := I.GetHhiOfficeNewsList;

  except
    on E: Exception do
    begin
      DestroyHTTPClient_HhiOfficeNews;
      FCS.DisplayMessage(FormatDateTime('mm월 dd일, hh:nn:ss', now) + ' : ' + E.Message, dtSystemLog);
      FCS.DisplayMessage(FormatDateTime('mm월 dd일, hh:nn:ss', now) + ' : DestroyHTTPClient_News', dtSystemLog);
      exit;
    end;
  end;

  FNewsList2.Clear;

  for Li := 0 to High(LDynArr) - 1 do
  begin
    if LDynArr[Li] <> '' then
    begin
      FNewsList2.Add(Utf8ToString(LDynArr[Li]));
    end;
  end;

  FCS.DisplayMessage(DateTimeToStr(Now) + ' : GetHhiOfficeNewsFromServer [ ' + IntToStr(FNewsList2.Count) + ' 개 뉴스 수신 ]', dtCommLog);

  for Li := 0 to FNewsList2.Count - 1 do
    AAFadeText1.Text.Lines.Add('('+IntToStr(Li+1)+') ' + FNewsList2.Strings[Li]);

  AAFadeText1.Active := True;

  I := nil;
  DestroyHTTPClient_HhiOfficeNews;
end;

function TMainForm.GetInnersByClass(const Doc: IDispatch; const classname: string;
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

function TMainForm.GetInnersByTagName(const Doc: IDispatch; const TagName: string;
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

procedure TMainForm.GetMainNews;
begin
//  FPJHTimerPool.AddOneShot(OnGetNews1, 30000);
//  WebBrowser1.Navigate(KBS_NEWS_MAIN_URL);
//  GetNews1;
  GetRSS;
end;

procedure TMainForm.GetNews1;
var
  source: string;
  doc, doc2: IHTMLDocument2;
  ArrayV, ArrayV2: OleVariant;
  LStrList: TStringList;
  LStr, LStr2: string;
  i, LCount: integer;
begin
  source := GetHTML(WebBrowser1);
  source := '<html><body>Source:<pre>' + source + '</pre></body></html>';

  if pos('[최신뉴스]', source) = 0 then
    exit;
  FNewsOmniMREW.EnterWriteLock;
  FNewsList.Clear;

  doc := coHTMLDocument.Create as IHTMLDocument2;
  try
    ArrayV := VarArrayCreate([0,0], varVariant);
    ArrayV[0] := source;
    doc.write(PSafeArray(TVarData(ArrayV).VArray));
    doc.close;

    LStrList := TStringList.Create;
    try
      GetInnersByClass(doc,'subject',LStrList);
      LStr := '<html><body>Source:<pre>' + LStrList.Text + '</pre></body></html>';
      doc2 := coHTMLDocument.Create as IHTMLDocument2;
      ArrayV2 := VarArrayCreate([0,0], varVariant);
      ArrayV2[0] := LStr;
      doc2.write(PSafeArray(TVarData(ArrayV2).VArray));
      doc2.close;

      if FNewsList.Count >= FSettings.NumOfNewsList then
        FNewsList.Clear;

      AAFadeText1.Text.Lines.Clear;
      GetInnersByClass(doc2,'tit',FNewsList,'A');

      for i := 0 to FNewsList.Count - 1 do
        AAFadeText1.Text.Lines.Add('('+IntToStr(i+1)+') ' + FNewsList.Strings[i]);

      for i := 0 to FNewsList2.Count - 1 do
        AAFadeText1.Text.Lines.Add('('+IntToStr(i+1)+') ' + FNewsList2.Strings[i]);

      LStr := Copy(Caption, 1, Pos(' => ', Caption) - 1);

      if LStr = '' then
        LStr := Caption;

      Caption := LStr + ' => ' + IntToStr(FNewsList.Count) + ' News Updated: ' + FormatDateTime('mm월 dd일, hh:nn:ss', now);
      AAFadeText1.Active := True;
    finally
      LStrList.Free;
    end;
  finally
    FNewsOmniMREW.ExitWriteLock;
  end;

  if FNewsList.Count = 0 then
    FPJHTimerPool.AddOneShot(OnGetNews, 2000);
end;

procedure TMainForm.GetNews2;
begin
  FNewsList2.Clear;
  FNewsList2.LoadFromFile(SHIP_OCEAN_NEWS_FILE);
end;

function TMainForm.GetNewsService: TRawUTF8DynArray;
var
  LCount: integer;
  LDynArr: TDynArray;
  LValue: RawUTF8;
  i: integer;
begin
  LDynArr.Init(TypeInfo(TRawUTF8DynArray),Result,@LCount);

  LValue := ' 뉴스 속보 ( Updated:  ' + FormatDateTime('mm월 dd일, hh:nn:ss', now) + ' )';
  LDynArr.Add(LValue);

  for i := 0 to FNewsList.Count - 1 do
  begin
    LValue := StringToUTF8(FNewsList.Strings[i]);
    LDynArr.Add(LValue);
  end;

  FCS.DisplayMessage(DateTimeToStr(Now) + ' : GetNewsService [ ' + IntToStr(FNewsList.Count) + ' 개 뉴스 전송 ]', dtCommLog);
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

  FCS.DisplayMessage(DateTimeToStr(Now) + ' : GetNewsService2 [ ' + IntToStr(FNewsList2.Count) + ' 개 뉴스 전송 ]', dtCommLog);
end;

procedure TMainForm.GetRSS;
begin
  ParallelRSSRetriever;
end;

function TMainForm.GetRSSXML(url: TOmniValue; var page: string): boolean;
var
  LDoc: TXMLDocument;
  StartItemNode : IXMLNode;
  NodoXML : IXMLNode;
  sPost, sFecha, sDescripcion: String;
  LRSSNewsItem: TRSSNewsItem;
begin
//  LDoc := TXMLDocument.Create(Self);
//  try
//    LDoc.FileName := TRSSAddressItem(url).RSSAddress;
//    LDoc.Active := True;
//    NodoXML := LDoc.DocumentElement.ChildNodes.FindNode('channel');
//
//    StartItemNode := LDoc.DocumentElement.ChildNodes.First.ChildNodes.FindNode('item');
//    NodoXML := StartItemNode;
//
//    repeat
//      sPost := NodoXML.ChildNodes['title'].Text;
//      sFecha := NodoXML.ChildNodes['pubDate'].Text;
////        sFecha := DateTimeToStr(strinternettodatetime(sFecha));
//      sDescripcion := NodoXML.ChildNodes['description'].Text;
//
//      LRSSNewsItem := FRSSNewsList.Add;
//      LRSSNewsItem.NewsCompany := TRSSAddressItem(url).NewsGubun;
//      LRSSNewsItem.NewType := TRSSAddressItem(url).RSSDescription;
//      LRSSNewsItem.NewsTitle := sPost;
//      LRSSNewsItem.NewsContent := sDescripcion;
//
//      NodoXML := NodoXML.NextSibling;
//    until NodoXML = nil;
//
//    page := LDoc.XML.Text;
//  finally
//    LDoc.Free;
//  end;
end;

procedure TMainForm.GetTitleByClass(const AHtml, classname: string;
  var Lst: TStringList);
var
  LXMLDoc: OmniXML.IXMLDocument;
  LRootNode, LSubNode: OmniXML.IXMLNode;
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

function TMainForm.HttpGet(url: string; var page: string): boolean;
var
  LIdHTTP: TIdHTTP;
begin
  Result := False;
  LIdHTTP := TIdHTTP.Create(nil);
  LIdHTTP.HandleRedirects := True;
  try
    try
      page := LIdHTTP.Get(url);
      Result := page <> '';
    except
    end;
  finally
    LIdHTTP.Free;
  end;
end;

procedure TMainForm.InitVar;
begin
  SetCurrentDir(ExtractFilePath(Application.ExeName));
//  SetCurrentDir('c:\private');
  FSettings := TConfigSettings.create(ChangeFileExt(ExtractFileName(Application.ExeName), '.ini'));
  LoadConfigFromFile;
  FPJHTimerPool := TPJHTimerPool.Create(nil);
  FNewsList := TStringList.Create;
  FNewsList2 := TStringList.Create;
  FNewCount := 0;
  AAFadeText1.Active := True;

  FRSSAddressInfo := TRSSAddressInfo.Create(Self);
  FRSSNewsList := TRSSNewsList.Create(TRSSNewsItem);
  TJSONSerializer.RegisterCollectionForJSON(TRSSNewsList, TRSSNewsItem);

  if FSettings.ServerTimeToGetHhiOfficeNews <> '' then
  begin
    AlarmFromTo1.AlarmTimeBegin := FSettings.ServerTimeToGetHhiOfficeNews;
    AlarmFromTo1.ActiveBegin := True;
  end;

  if FSettings.RSSAddrFileName = '' then
    FSettings.RSSAddrFileName := DEFAULT_RSS_ADDR_FILE_NAME;

  FRSSAddressInfo.LoadFromJSONFile(FSettings.RSSAddrFileName);

  GetMainNews;
  FOnGetNewsHandle := FPJHTimerPool.Add(OnGetNews1, 60000);

  FCS.FStartServerProc := StartServer;
  FCS.FAutoStartInterval := 10000; //10초
end;

procedure TMainForm.Inserter(const input, output: IOmniBlockingCollection);
var
  page   : TOmniValue;
  LRSSNewsList: TRSSNewsList;
begin
  // connect to database
  for page in input do begin
    LRSSNewsList := TRSSNewsList(Page.AsObject);
    output.Add(LRSSNewsList.Items[0].NewsContent);
    SetRSSNewsList(LRSSNewsList);
    LRSSNewsList.Free;
  end;

  OutPut.CompleteAdding;
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

procedure TMainForm.N1Click(Sender: TObject);
begin
  GetNews2;
end;

procedure TMainForm.OnGetNews(Sender: TObject; Handle: Integer; Interval: Cardinal;
  ElapsedTime: Integer);
begin
//  if FNewCount < 2 then
//  begin
    GetMainNews;
//    Inc(FNewCount);
//  end
//  else
//    FPJHTimerPool.Remove(FOnGetNewsHandle);
end;

procedure TMainForm.OnGetNews1(Sender: TObject; Handle: Integer;
  Interval: Cardinal; ElapsedTime: Integer);
begin
  StatusBar1.SimplePanel := True;
  StatusBar1.SimpleText := FormatDateTime('mm월 dd일, hh:nn:ss => ', now) + 'Timer Executed!';
//  GetNews1;
  GetRSS;
//  FPJHTimerPool.AddOneShot(OnGetNews1Refresh, 130000);
//  FPJHTimerPool.AddOneShot(OnGetNews1, 30000);
end;

procedure TMainForm.OnGetNews1Refresh(Sender: TObject; Handle: Integer;
  Interval: Cardinal; ElapsedTime: Integer);
begin
  GetMainNews;
end;

procedure TMainForm.OnGetNews2(Sender: TObject; Handle: Integer;
  Interval: Cardinal; ElapsedTime: Integer);
begin

end;

procedure TMainForm.ParallelRSSRetriever;
var
  s       : string;
  i: integer;
  LRss: TOmniValue;
  LItem: TListItem;
begin
  if Assigned(FRSSFetchPipeline) then
    if not FRSSFetchPipeline.Output.IsCompleted then
      exit;

  // set up pipeline
  FRSSFetchPipeline := Parallel.Pipeline
    .Stage(Retriever)//.NumTasks(Environment.Process.Affinity.Count * 2)
    .Stage(Inserter)
    .Run;

  // insert URLs to be retrieved
  for i := 0 to FRSSAddressInfo.RSSAddressCollect.Count - 1 do
    if FRSSAddressInfo.RSSAddressCollect.Items[i].RSSUsed then
      FRSSFetchPipeline.Input.Add(FRSSAddressInfo.RSSAddressCollect.Items[i]);

  FRSSFetchPipeline.Input.CompleteAdding;
  FRSSNewsList.Clear;
  // wait for pipeline to complete
  FRSSFetchPipeline.WaitFor(INFINITE);

  FRSSNewsList.Sort;
//    for LRss in FRSSFetchPipeline.Output do
//      Memo1.Lines.Add(LRss.AsString);// := FRSSFetchPipeline.Output.Next.AsString;
  try
//    Memo1.Lines.Clear;
    ListView1.Items.BeginUpdate;
    ListView1.Clear;

    with ListView1 do
    begin
      for i := FRSSNewsList.Count - 1 downto 0 do
      begin
        LItem := Items.Add;
        LItem.Caption := DateTimeToStr(FRSSNewsList.Items[i].NewsUpdateDate);
        LItem.SubItems.Add(FRSSNewsList.Items[i].NewsTitle);
        LItem.SubItems.Add(FRSSNewsList.Items[i].NewsCompany);
        LItem.SubItems.Add(FRSSNewsList.Items[i].NewsContent);
      end;
    end;
//      Memo1.Lines.Add(DateTimeToStr(FRSSNewsList.Items[i].NewsUpdateDate) + ' : ' + FRSSNewsList.Items[i].NewsTitle);
  finally
    ListView1.Items.EndUpdate;
  end;
end;

procedure TMainForm.Retriever(const input: TOmniValue; var output: TOmniValue);
var
  pageContents: string;
  LRSSNewsList: TRSSNewsList;
begin
  if HttpGet(TRSSAddressItem(input).RSSAddress, pageContents) then
//  if GetRSSXML(input, pageContents) then
  begin
    LRSSNewsList := TRSSNewsList.Create(TRSSNewsItem);
    with LRSSNewsList.Add do
    begin
      NewsCompany := TRSSAddressItem(input).NewsGubun;
      NewType := TRSSAddressItem(input).RSSDescription;
      NewsContent := pageContents;
    end;
    output := LRSSNewsList;
  end;
end;

procedure TMainForm.RSSAddressConfig1Click(Sender: TObject);
begin
  Create_RSSAddrForm;
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

procedure TMainForm.SetRSSNewsList(ANewsList: TRSSNewsList);
var
  LRSSNewsItem: TRSSNewsItem;
  iChannel: integer;
  iItem   : integer;
  FXml: TNativeXml;
  Node, ItemNode: TXMLNode;
  nodeList: TsdNodeList;
begin
  FXml := TNativeXml.Create(Self);
  FXml.ReadFromString(StringToUTF8(ANewsList.Items[0].NewsContent));

  try
    if Assigned(FXml.Root) then
    begin
      if FXml.ExternalEncoding <> seUTF8 then
        exit;

      Node := FXml.Root.FindNode('channel');

      if Assigned(Node) then
      begin
        nodeList := TsdNodeList.Create(False);
        try
          FNewsOmniMREW.EnterWriteLock;
          Node.FindNodes('item', nodeList);
          for iItem := 0 to nodeList.Count - 1 do
          begin
            LRSSNewsItem := FRSSNewsList.Add;
            LRSSNewsItem.NewsCompany := ANewsList.Items[0].NewsCompany;
            LRSSNewsItem.NewType := ANewsList.Items[0].NewType;
            LRSSNewsItem.NewsTitle := UTF8ToString(nodeList[iItem].FindNode('title').Value);
            LRSSNewsItem.NewsContent := UTF8ToString(nodeList[iItem].FindNode('description').Value);
            LRSSNewsItem.NewsLink := UTF8ToString(nodeList[iItem].FindNode('link').Value);

            if Assigned(nodeList[iItem].FindNode('dc:date')) then
              LRSSNewsItem.NewsUpdateDate := StrToDateTime(nodeList[iItem].FindNode('dc:date').Value)
            else
            if Assigned(nodeList[iItem].FindNode('pubDate')) then
              LRSSNewsItem.NewsUpdateDate := StrToDateTime(nodeList[iItem].FindNode('pubDate').Value);
          end;
        finally
          FNewsOmniMREW.ExitWriteLock;
          nodeList.Free;
        end;

//        ItemNode := Node.FindNode('item');
//
//        if Assigned(ItemNode) then
//        begin
//          repeat
//            LRSSNewsItem := FRSSNewsList.Add;
//            LRSSNewsItem.NewsCompany := ANewsList.Items[0].NewsCompany;
//            LRSSNewsItem.NewType := ANewsList.Items[0].NewType;
//            LRSSNewsItem.NewsTitle := UTF8ToString(ItemNode.FindNode('title').Value);
//            LRSSNewsItem.NewsContent := UTF8ToString(ItemNode.FindNode('description').Value);
//            LRSSNewsItem.NewsLink := UTF8ToString(ItemNode.FindNode('link').Value);
//
//            ItemNode := Node.NextSibling(ItemNode);
//          until not Assigned(Node);
//        end;
      end;
    end;
  finally
    FreeAndNil(FXml);
  end;

//  except
//    on E: EDOMParseError do
//    ShowMessage('Ocurrio un Error al Leer RSS');
//    on E: Exception do
//    ShowMessage('Error!');
//  end;
end;

procedure TMainForm.SpeedButton5Click(Sender: TObject);
begin
  WebBrowser1.Navigate(KBS_NEWS_MAIN_URL);
end;

procedure TMainForm.StartServer;
begin
  FCS.CreateHttpServer(NEWS_ROOT_NAME, 'News.json', NEWS_PORT_NAME, TServiceNewsList, [TypeInfo(INewsList)], sicShared);
  FCS.ServerStartBtnClick(nil);
end;

{ TServiceNewsList }

function TServiceNewsList.GetNewsList: TRawUTF8DynArray;
var
  LCount: integer;
  LDynArr: TDynArray;
begin
  if g_GetNewsListRunning then
    exit
  else
    g_GetNewsListRunning := True;

  try
    LDynArr.Init(TypeInfo(TRawUTF8DynArray),Result,@LCount);
    Result := MainForm.GetNewsService;
  finally
    g_GetNewsListRunning := False;
  end;
end;

function TServiceNewsList.GetNewsList2: TRawUTF8DynArray;
var
  LCount: integer;
  LDynArr: TDynArray;
begin
  LDynArr.Init(TypeInfo(TRawUTF8DynArray),Result,@LCount);
  Result := MainForm.GetNewsService2;
end;

function TServiceNewsList.GetRSSNewsList(out ACollect: TRSSNewsList): Boolean;
begin
  Result := False;

  MainForm.FNewsOmniMREW.EnterReadLock;
  try
    if MainForm.FRSSNewsList.Count > 0 then
    begin
      CopyObject(MainForm.FRSSNewsList, ACollect);
      Result := True;
    end;
  finally
    MainForm.FNewsOmniMREW.ExitReadLock;
  end;
end;

end.
