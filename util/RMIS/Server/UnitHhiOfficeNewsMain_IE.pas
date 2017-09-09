unit UnitHhiOfficeNewsMain_IE;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, MSHTML, Activex,
  Vcl.ComCtrls, Vcl.StdCtrls, Vcl.Buttons, Vcl.ExtCtrls, TimerPool, OmniXML, OmniXMLUtils, OmniXMLXPath,
  AAFont, AACtrls, Vcl.OleCtrls, SHDocVw, UnitHhiOfficeNewsInterface,
  SynCommons, mORMot, mORMotSQLite3, mORMotHttpServer, UnitFrameCommServer,
  AdvOfficePager, UnitNewsConfig, Vcl.Menus, ralarm, IdBaseComponent,
  IdComponent, IdTCPConnection, IdTCPClient, IdHTTP, Sea_Ocean_News_Class;

const
  KBS_NEWS_LATEST_URL = 'http://news.kbs.co.kr/news/NewsCategory.do?SEARCH_SECTION=0001&SEARCH_CATEGORY=0004';
  SHIP_OCEAN_NEWS_URL = 'http://hhioffice.hhi.co.kr/board/Lists/M4137/AllItems.aspx?MenuID=M4137';
  SHIP_OCEAN_NEWS_FILE = 'c:\private\sonews.txt';
type
  THhiOfficeServiceNewsList = class(TInterfacedObject, IHhiOfficeNewsList)
  public
    function GetHhiOfficeNewsList: TRawUTF8DynArray; //일간 조선 해양 뉴스
    function GetTimeOnHhiOfficeNews: RawUTF8; //일간 조선 해양 뉴스 가져오는 시간(RAlarm 설정 값)
    function GetAttachFileHhiOfficeNews(AFileName: RawUTF8): TServiceCustomAnswer;
    procedure GetHhiOfficeNewsList2(out ASeaOceanNewsCollect: TSONewsCollect);
  end;

  TMainForm = class(TForm)
    StatusBar1: TStatusBar;
    Panel6: TPanel;
    AAFadeText1: TAAFadeText;
    AdvOfficePager1: TAdvOfficePager;
    ServerPage: TAdvOfficePage;
    NewsPage: TAdvOfficePage;
    WebBrowser1: TWebBrowser;
    FCS: TFrameCommServer;
    Panel20: TPanel;
    SpeedButton1: TSpeedButton;
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
    IdHTTP1: TIdHTTP;
    SpeedButton2: TSpeedButton;
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
    procedure SpeedButton1Click(Sender: TObject);
    procedure IdHTTP1Redirect(Sender: TObject; var dest: string;
      var NumRedirect: Integer; var Handled: Boolean; var VMethod: string);
    procedure WebBrowser1FileDownload(ASender: TObject;
      ActiveDocument: WordBool; var Cancel: WordBool);
    procedure SpeedButton2Click(Sender: TObject);
  private
    FPJHTimerPool: TPJHTimerPool;
    FSeaOceanNewsList: TStringList;//일간조선해양 뉴스
    FSeaOceanNewsList2: TSONewsCollect;//일간조선해양 뉴스(TCollect 에 저장함

    FModel: TSQLModel;
    FHTTPServer: TSQLHttpServer;
    FRestServer: TSQLRestServer;

    FNewCount: integer;
    FSeaOceanAttachedFileURL: string;
    FSeaOceanAttachedFileStream: TMemoryStream;

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

    function GetInnersByClass(const Doc: IDispatch; const classname: string; var Lst:TStringList; ATagName: string = ''): Integer;
    function GetInnersByTagName(const Doc: IDispatch; const ATagName: string; var Lst:TStringList; AttributeName: string = ''): string;
    function GetInnersByTagName2(const Doc: IDispatch; var Lst:TStringList): string;
    function GetAttchUrlByTagName(const Doc: IDispatch): string;
    function GetInnersByAttrubute(const Doc: IDispatch; const AttributeName: string; var Lst:TStringList; AttributeValue: string = ''): Integer;
    procedure GetTitleByClass(const AHtml, classname: string; var Lst:TStringList);
    procedure ExecuteOnclick(const Doc: IDispatch; const ATagName: string);
    function GetSeaOceanUrlFromXML(AXML, AValue: string): string;
    function GetSeaOceanUrlFromString(AStr: string): string;
    procedure GetSeaOceanNew2List;
    procedure GetNews1;
    procedure GetNews2;
    procedure DownloadFile(AUrl: string; AStream: TMemoryStream);
  protected
    FSettings : TConfigSettings;
    FOnGetNewsHandle: integer;
    FSeaOceanFS: TFileStream;

  public
    procedure InitVar;
    procedure DestroyVar;

    function GetSeaOceanNewsService: TRawUTF8DynArray;

    procedure LoadConfigFromFile(AFileName: string = '');
    procedure LoadConfig2Form(AForm: TConfigF);
    procedure LoadConfigForm2Object(AForm: TConfigF);
    procedure SetConfig;
    procedure ApplyUI;
  end;

var
  MainForm: TMainForm;

implementation

uses WebBrowserUtil;//, IdHTTP;

{$R *.dfm}

function NextPos2(SearchStr, Str : String; Position : integer) : integer;
begin
  delete(Str, 1, Position-1);
  Result := pos(upperCase(SearchStr), upperCase(Str));
  If Result = 0 then exit;
  If (Length(Str) > 0) and (Length(SearchStr) > 0) then
    Result := Result + Position - 1;
end;

function strToken(var S: String; Seperator: string): String;
var
  I, j: Word;
begin
  I:=Pos(Seperator,S);

  if I<>0 then
  begin
    j := Length(Seperator);
    Result:=System.Copy(S,1,I-1);
    System.Delete(S,1,I);
  end else
  begin
    Result:=S;
    S:='';
  end;
end;

function GetInParentheses(Src: string): string;
begin
  Result := strToken(Src, '(');
  Result := strToken(Src, ')');
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
  GetMainNews;
end;

procedure TMainForm.ApplyUI;
begin
;
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
  FSeaOceanAttachedFileStream.Free;
  FCS.DestroyHttpServer;

  FSeaOceanNewsList.Free;
  FSeaOceanNewsList2.Free;
//  FChromium.Free;
  FPJHTimerPool.RemoveAll;
  FPJHTimerPool.Free;
  FSettings.Free;
end;

procedure TMainForm.DownloadFile(AUrl: string; AStream: TMemoryStream);
//var
//  IdHTTP1: TIdHTTP;
//  Stream: TMemoryStream;
//  Url, FileName: String;
begin
//  IdHTTP1 := TIdHTTP.Create(Self);
//  IdHTTP1.HandleRedirects := True;
//  Stream := TMemoryStream.Create;
  try
    IdHTTP1.Get(AUrl, AStream);
//    Stream.SaveToFile(FileName);
  finally
//    Stream.Free;
//    IdHTTP1.Free;
  end;
end;

procedure TMainForm.ExecuteOnclick(const Doc: IDispatch;
  const ATagName: string);
var
  Document: IHTMLDocument2;     // IHTMLDocument2 interface of Doc
  Body: IHTMLElement2;          // document body element
  Tags: IHTMLElementCollection; // all tags in document body
  Tag: IHTMLElement;            // a tag in document body
  I: Integer;
  LOnClick: OleVariant;
  LHtml, LAtt: string;
begin
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
    if Tag.tagName = 'DIV' then
    begin
      LAtt := Tag.innerText;

      if Pos(ATagName, LAtt) > 0 then
      begin
        Tag.click;
        exit;
      end;
    end;
  end;
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

function TMainForm.GetAttchUrlByTagName(const Doc: IDispatch): string;
var
  Document: IHTMLDocument2;     // IHTMLDocument2 interface of Doc
  Body: IHTMLElement2;          // document body element
  Tags: IHTMLElementCollection; // all tags in document body
  Tag: IHTMLElement;            // a tag in document body
  I: Integer;                   // loops thru tags in document body
  LAtt, ATagName: string;
  LOleStr: OleVariant;
begin
  // Check for valid document: require IHTMLDocument2 interface to it
  if not Supports(Doc, IHTMLDocument2, Document) then
    raise Exception.Create('Invalid HTML document');
  // Check for valid body element: require IHTMLElement2 interface to it
  if not Supports(Document.body, IHTMLElement2, Body) then
    raise Exception.Create('Can''t find <body> element');
  // Get all tags in body element ('*' => any tag name)
  Tags := Body.getElementsByTagName('a');
  // Scan through all tags in body
  for I := 0 to Pred(Tags.length) do
  begin
    // Get reference to a tag
    Tag := Tags.item(I, EmptyParam) as IHTMLElement;

    if SameText(Tag.tagName, 'a') then
    begin
      LAtt := Tag.innerText;
//      LAtt := Tag.innerHTML;

      if (Pos('.pdf', LAtt) > 0) then
      begin
        LOleStr := Tag.getAttribute('href',0);

        if LOleStr = Null then
          Continue;

        LAtt := VarToStr(LOleStr);
        Result := LAtt;
        exit;
      end;
    end;
  end;
end;

function TMainForm.GetInnersByAttrubute(const Doc: IDispatch;
  const AttributeName: string; var Lst: TStringList; AttributeValue: string): Integer;
var
  Document: IHTMLDocument2;     // IHTMLDocument2 interface of Doc
  Body: IHTMLElement2;          // document body element
  Tags: IHTMLElementCollection; // all tags in document body
  Tag: IHTMLElement;            // a tag in document body
  I: Integer;
  LOleStr: OleVariant;
  LHtml, LAtt: string;
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
    LOleStr := Tag.getAttribute(AttributeName,0);

    if LOleStr = Null then
      Continue;

    LAtt := VarToStr(LOleStr);

    if AttributeValue <> '' then
    begin
      if SameText(LAtt, AttributeValue) then
      begin
  //      if ATagName <> '' then
  //        LHtml := Tag.innerText
  //      else
          LHtml := Tag.innerHTML;

        Lst.Add(LHtml);
        Inc(Result);
      end;
    end
    else
    begin
      Lst.Add(LAtt);
      Inc(Result);
    end;
  end;
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

//TagName에서 InnerText = AInnerStr 인 것만 Lst에 저장함
function TMainForm.GetInnersByTagName(const Doc: IDispatch; const ATagName: string;
  var Lst: TStringList; AttributeName: string): string;
var
  Document: IHTMLDocument2;     // IHTMLDocument2 interface of Doc
  Body: IHTMLElement2;          // document body element
  Tags: IHTMLElementCollection; // all tags in document body
  Tag: IHTMLElement;            // a tag in document body
  I: Integer;                   // loops thru tags in document body
  LAtt: string;
begin
  Lst.Clear;
//  Result := 0 ;
  // Check for valid document: require IHTMLDocument2 interface to it
  if not Supports(Doc, IHTMLDocument2, Document) then
    raise Exception.Create('Invalid HTML document');
  // Check for valid body element: require IHTMLElement2 interface to it
  if not Supports(Document.body, IHTMLElement2, Body) then
    raise Exception.Create('Can''t find <body> element');
  // Get all tags in body element ('*' => any tag name)
  Tags := Body.getElementsByTagName(ATagName);
  // Scan through all tags in body
  for I := 0 to Pred(Tags.length) do
  begin
    // Get reference to a tag
    Tag := Tags.item(I, EmptyParam) as IHTMLElement;

    if AttributeName <> '' then
    begin
      if SameText(Tag.tagName, ATagName) then
      begin
//        LAtt := Tag.getAttribute('onclick',0);
//        if LOleStr = Null then
//          Continue;
//
//        LAtt := VarToStr(LOleStr);
        LAtt := Tag.innerText;

        if Pos(AttributeName, LAtt) > 0 then
        begin
          Result := Tag.outerHTML;
          exit;
        end;
      end;
    end
    else
    begin
      if SameText(Tag.tagName, ATagName) then
      begin
        LAtt := Tag.innerText;
        if (Pos('&nbsp', LAtt) = 0) and (Length(LAtt) > 3) then
        begin
//          Lst.DelimitedText := '#$D#$A';
          if (Pos('첨부파일', LAtt) = 0) and (Length(LAtt) < 50)  then
            Lst.add(Tag.innerText);
//          ShowMessage(Lst.Strings[2]);
//          exit;
        end;
      end;
//      Inc(Result);
    end;
  end;
end;

function TMainForm.GetInnersByTagName2(const Doc: IDispatch;
  var Lst: TStringList): string;
var
  Document: IHTMLDocument2;     // IHTMLDocument2 interface of Doc
  Body: IHTMLElement2;          // document body element
  Tags: IHTMLElementCollection; // all tags in document body
  Tag: IHTMLElement;            // a tag in document body
  I,j: Integer;                   // loops thru tags in document body
  LAtt, ATagName: string;
  LSONewsItem: TSONewsItem;
begin
  Lst.Clear;
  ATagName := 'p';
  // Check for valid document: require IHTMLDocument2 interface to it
  if not Supports(Doc, IHTMLDocument2, Document) then
    raise Exception.Create('Invalid HTML document');
  // Check for valid body element: require IHTMLElement2 interface to it
  if not Supports(Document.body, IHTMLElement2, Body) then
    raise Exception.Create('Can''t find <body> element');
  // Get all tags in body element ('*' => any tag name)
  Tags := Body.getElementsByTagName('p');
  // Scan through all tags in body
  FSeaOceanNewsList2.Clear;

  for I := 0 to Pred(Tags.length) do
  begin
    // Get reference to a tag
    Tag := Tags.item(I, EmptyParam) as IHTMLElement;

    if SameText(Tag.tagName, 'p') then
    begin
      LAtt := Tag.innerText;
      if (Pos('&nbsp', LAtt) = 0) and (Length(LAtt) > 3) then
      begin
//          Lst.DelimitedText := '#$D#$A';
        if (Pos('첨부파일', LAtt) = 0) and (Length(LAtt) < 50)  then
        begin
          strToken(LAtt, '-');
          LSONewsItem := FSeaOceanNewsList2.Add;
          LSONewsItem.NewsContent := LAtt;
          Lst.add(LAtt);
//          ShowMessage(Lst.Text);
//          exit;
        end;
      end
      else
      begin
        if LAtt <> '' then
        begin
          j := StrToIntDef(GetInParentheses(LAtt), -1);
          if j <> -1 then
            LSONewsItem.PdfPageNo := j;
//          ShowMessage(LAtt + ' : ' + IntToStr(LSONewsItem.PdfPageNo));
        end;
//        exit;
      end;
    end;
  end;
end;

procedure TMainForm.GetMainNews;
begin
  WebBrowser1.Navigate(SHIP_OCEAN_NEWS_URL);
  NewsPage.Caption := '최근 산업동향';
  FPJHTimerPool.AddOneShot(OnGetNews1, 5000);
//  GetNews1;
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
  source := GetWebBrowserHTML(WebBrowser1);
  source := '<html><body>Source:<pre>' + source + '</pre></body></html>';
  FormatSettings.DateSeparator := '/';
  LStr2 := '[일간조선해양 ' + formatDateTime('m/d' , date) + ']';

  if pos(LStr2, source) = 0 then
    exit;

//  FSeaOceanNewsList.Clear;

  doc := coHTMLDocument.Create as IHTMLDocument2;
  try
    ArrayV := VarArrayCreate([0,0], varVariant);
    ArrayV[0] := source;
    doc.write(PSafeArray(TVarData(ArrayV).VArray));
    doc.close;

    LStrList := TStringList.Create;
    try
      GetInnersByAttrubute(doc,'webPartID',LStrList,'HHIHPW_Board');
//      LStr := '<html><body>Source:<pre>' + LStrList.Text + '</pre></body></html>';
      LStr := '<html><body>' + LStrList.Text + '</body></html>';
      doc2 := coHTMLDocument.Create as IHTMLDocument2;
      ArrayV2 := VarArrayCreate([0,0], varVariant);
      ArrayV2[0] := LStr;
      doc2.write(PSafeArray(TVarData(ArrayV2).VArray));
      doc2.close;

//      if FSeaOceanNewsList.Count >= FSettings.NumOfNewsList then
//        FSeaOceanNewsList.Clear;

      AAFadeText1.Text.Lines.Clear;
      LStrList.Clear;
      LStrList.Text := GetInnersByTagName(doc2, 'DIV', FSeaOceanNewsList, LStr2);
      LStr := GetSeaOceanUrlFromString(LStrList.Text);

      if LStr <> '' then
      begin
        Webbrowser1.Navigate(LStr);
        edAddress.Text := LStr;
        NewsPage.Caption := '일간조선해양';
        FPJHTimerPool.AddOneShot(OnGetNews2, 5000);
      end;
//      GetSeaOceanUrlFromXML(LStrList.Text, LStr2);
//      GetInnersByTagName(doc2,'SPAN', LStrList);
//
//      if FSeaOceanNewsList.Count <> LStrList.Count then
//      begin
//        FCS.DisplayMessage('FSeaOceanNewsList(onclick) 와 LStrList(SPAN) 갯수가 다름.', dtSystemLog);
//        exit;
//      end;

//      for i := 0 to LStrList.Count - 1 do
//        if Pos(LStr2, LStrList.Strings[i]) > 0 then
//          AAFadeText1.Text.Lines.Add('('+IntToStr(i+1)+') ' + FSeaOceanNewsList.Strings[i]);
//
//      LStr := Copy(Caption, 1, Pos(' => ', Caption) - 1);
//
//      if LStr = '' then
//        LStr := Caption;
//
//      Caption := LStr + ' => ' + IntToStr(FSeaOceanNewsList.Count) + ' News Updated: ' + FormatDateTime('mm월 dd일, hh:nn:ss', now);
//      AAFadeText1.Active := True;
    finally
      doc2 := nil;
      LStrList.Free;
    end;
  finally
    doc := nil;
  end;

//  if FSeaOceanNewsList.Count = 0 then
//    FPJHTimerPool.AddOneShot(OnGetNews, 2000);
end;

procedure TMainForm.GetNews2;
begin

end;

procedure TMainForm.GetSeaOceanNew2List;
var
  LStr: string;
  doc: IHTMLDocument2;
  ArrayV: OleVariant;
  i: integer;
begin
  LStr := GetWebBrowserHTML(WebBrowser1);

  if LStr <> '' then
  begin
    FSeaOceanNewsList.Clear;
    doc := coHTMLDocument.Create as IHTMLDocument2;
    try
      ArrayV := VarArrayCreate([0,0], varVariant);
      ArrayV[0] := LStr;
      doc.write(PSafeArray(TVarData(ArrayV).VArray));
      doc.close;
      GetInnersByTagName2(doc, FSeaOceanNewsList);
      FSeaOceanAttachedFileURL := GetAttchUrlByTagName(doc);
      WebBrowser1.Navigate(FSeaOceanAttachedFileURL);
//      DownloadFile(FSeaOceanAttachedFileURL, FSeaOceanAttachedFileStream);
//      GetInetFileNSave2File(FSeaOceanAttachedFileURL, 'c:\temp\일간조선해양.pdf');
      GetInetFileNSave2Stream(FSeaOceanAttachedFileURL, FSeaOceanAttachedFileStream);

      if FSeaOceanAttachedFileStream.Size > 0 then
        FSeaOceanAttachedFileStream.SaveToFile(SHIP_OCEAN_PDF_FILE);

      for i := 0 to FSeaOceanNewsList.Count - 1 do
      begin
        AAFadeText1.Text.Lines.Add('('+IntToStr(i+1)+') ' + FSeaOceanNewsList.Strings[i]);
      end;

      if FSeaOceanNewsList.Count > 0 then
      begin
        LStr := Copy(Caption, 1, Pos(' => ', Caption) - 1);

        if LStr = '' then
          LStr := Caption;

        Caption := LStr + ' => ' + IntToStr(FSeaOceanNewsList.Count) + ' News Updated: ' + FormatDateTime('mm월 dd일, hh:nn:ss', now);
        AAFadeText1.Active := True;
      end
      else
      begin
        StatusBar1.SimplePanel := True;
        StatusBar1.SimpleText := FormatDateTime('mm월 dd일, hh:nn:ss => ', now) + 'FSeaOceanNewsList 내용 없음!';
      end;
    finally
      doc := nil;
    end;
  end
  else
  begin
    StatusBar1.SimplePanel := True;
    StatusBar1.SimpleText := FormatDateTime('mm월 dd일, hh:nn:ss => ', now) + 'HTML 내용 없음!';
  end;
end;

function TMainForm.GetSeaOceanNewsService: TRawUTF8DynArray;
var
  LCount: integer;
  LDynArr: TDynArray;
  LValue: RawUTF8;
  i: integer;
begin
  LDynArr.Init(TypeInfo(TRawUTF8DynArray),Result,@LCount);

//  LValue := '일간조선해양 ( Updated:  ' + FormatDateTime('mm월 dd일, hh:nn:ss', now) + ' )';
//  LDynArr.Add(LValue);

  for i := 0 to FSeaOceanNewsList.Count - 1 do
  begin
    LValue := StringToUTF8(FSeaOceanNewsList.Strings[i]);

    if i = 0 then
      LValue := LValue + '( Updated:  ' + FormatDateTime('mm월 dd일, hh:nn:ss', now) + ' )';

    LDynArr.Add(LValue);
  end;

  FCS.DisplayMessage(DateTimeToStr(Now) + ' : GetNewsService2 [ ' + IntToStr(FSeaOceanNewsList.Count) + ' 개 뉴스 전송 ]', dtCommLog);

end;

procedure TMainForm.GetTitleByClass(const AHtml, classname: string;
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

procedure TMainForm.IdHTTP1Redirect(Sender: TObject; var dest: string;
  var NumRedirect: Integer; var Handled: Boolean; var VMethod: string);
begin
  Handled := True;
end;

procedure TMainForm.InitVar;
begin
  SetCurrentDir(ExtractFilePath(Application.ExeName));
  FSettings := TConfigSettings.create(ChangeFileExt(Application.ExeName, '.ini'));
  LoadConfigFromFile;
  FPJHTimerPool := TPJHTimerPool.Create(nil);
  FSeaOceanNewsList := TStringList.Create;
  FSeaOceanNewsList2 := TSONewsCollect.Create(TSONewsItem);
//  OnGetNews(nil,0,0,0);
  GetMainNews;
  AlarmFromTo1.AlarmTimeBegin := '08:11:00';
  AlarmFromTo1.ActiveBegin := True;
//  FOnGetNewsHandle := FPJHTimerPool.Add(OnGetNews, 60000);
  FNewCount := 0;
  FSeaOceanAttachedFileStream := TMemoryStream.Create;
//  AAFadeText1.Active := True;
  TJSONSerializer.RegisterCollectionForJSON(TSONewsCollect, TSONewsItem);

  FCS.FStartServerProc := StartServer;
  FCS.FAutoStartInterval := 10000; //10초
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
  GetNews1;
//  FPJHTimerPool.AddOneShot(OnGetNews1, 60000);
//  FPJHTimerPool.AddOneShot(OnGetNews1Refresh, 130000);
end;

procedure TMainForm.OnGetNews1Refresh(Sender: TObject; Handle: Integer;
  Interval: Cardinal; ElapsedTime: Integer);
begin
  GetMainNews;
end;

procedure TMainForm.OnGetNews2(Sender: TObject; Handle: Integer;
  Interval: Cardinal; ElapsedTime: Integer);
begin
  FPJHTimerPool.Remove(Handle);
  GetSeaOceanNew2List;
end;

function TMainForm.GetSeaOceanUrlFromString(AStr: string): string;
var
  LStr: string;
  i, j: integer;
begin
  i := Pos('http:', AStr);
  j := NextPos2('Navi=true', AStr, i);
  Result := Copy(AStr, i, j-i+9);
end;

function TMainForm.GetSeaOceanUrlFromXML(AXML, AValue: string): string;
var
  LXMLDoc: IXMLDocument;
  LRootNode, LSubNode, LLeafNode, LLeafNode2: IXMLNode;
  i,j,k: integer;
  LAttr: IXMLNamedNodeMap;
  LNodeList: IXMLNodeList;
begin
  LXMLDoc := CreateXMLDoc;
  try
    LXMLDoc.LoadXML(AXML);

    if LXMLDoc.DocumentElement <> nil then
    begin
      LRootNode := LXMLDoc.DocumentElement;

      //<html>
      if LRootNode <> nil then
      begin
        if LRootNode.HasChildNodes then
        begin
          LRootNode := LRootNode.FirstChild;

          //<body>
          if LRootNode <> nil then
          begin
            if LRootNode.HasChildNodes then
            begin
              LNodeList := LRootNode.ChildNodes;

              //<TBODY>
              if LNodeList <> nil then
              begin
                for i := 0 to LRootNode.ChildNodes.Length - 1 do
                begin
                  LSubNode := LRootNode.ChildNodes.Item[i];

                  //<TR>
                  if LSubNode <> nil then
                  begin
                    if LSubNode.HasChildNodes then
                    begin
                      LLeafNode := LSubNode.FirstChild;

                      //<TD>
                      if LLeafNode <> nil then
                      begin
                        if LLeafNode.HasChildNodes then
                        begin
                          LLeafNode := LLeafNode.FirstChild;

                          //<DIV>
                          if LLeafNode <> nil then
                          begin
                            if Pos(AValue, LLeafNode.NodeValue) > 0 then
                            begin
                              LAttr := LLeafNode.Attributes;

                              if LAttr <> nil then
                              begin
                                LLeafNode2 := LAttr.GetNamedItem('onclick');

                                if LLeafNode2 <> nil then
                                begin
                                  Result := LLeafNode2.NodeValue;
                                end;
                              end;
                            end;
                          end;
                        end;
                      end;
                    end;
                  end;
                end;
              end;
            end;
          end;

        end;

      end;


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
                for j := 0 to LSubNode.ChildNodes.Length - 1 do
                begin
                  LLeafNode := LSubNode.ChildNodes.Item[j];

                  if LLeafNode.NodeName = 'column' then
                  begin
                    if LLeafNode.HasChildNodes then
                    begin
//                      LLeafNode := LLeafNode.ChildNodes.Item[0];//CDATA Section
//                      LBWQryClass.BWQryColumnHeaderCollect.Add.ColumnHeaderData := LLeafNode.NodeValue;
                    end;
                  end;
                end;//for
              end;
            end;
          end;
        end;
      end;
    end;
  finally
    LXMLDoc := nil;
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

procedure TMainForm.SpeedButton1Click(Sender: TObject);
var
  i: integer;
  LStr: string;
begin
  for i := 0 to FSeaOceanNewsList2.Count - 1 do
    LStr := LStr + FSeaOceanNewsList2.Items[i].NewsContent + ' (' + IntToStr(FSeaOceanNewsList2.Items[i].PdfPageNo) + ')' + #13#10;

  ShowMessage(LStr);
//  GetSeaOceanNew2List;
end;

procedure TMainForm.SpeedButton2Click(Sender: TObject);
var
  vIn, vOut: OleVariant;
  LStr: string;
begin
//  SaveBrowserDoc(WebBrowser1, False);
//  LStr := '.\신문\test.pdf';
//  vIn := LStr;
  WebBrowser1.ExecWB(OLECMDID_SAVEAS,OLECMDEXECOPT_DONTPROMPTUSER,vIn,vOut);
end;

procedure TMainForm.SpeedButton5Click(Sender: TObject);
begin
  WebBrowser1.Navigate(edAddress.Text);
//  ShowMessage(GetInParentheses('(1)'));
//  LStr := '123,456';
//  ShowMessage(strToken(LStr, ','));
end;

procedure TMainForm.StartServer;
begin
  FCS.CreateHttpServer(HHIOFFICE_ROOT_NAME, 'News.json', HHIOFFICE_PORT_NAME, THhiOfficeServiceNewsList, [TypeInfo(IHhiOfficeNewsList)], sicShared);
  FCS.ServerStartBtnClick(nil);
end;

procedure TMainForm.WebBrowser1FileDownload(ASender: TObject;
  ActiveDocument: WordBool; var Cancel: WordBool);
begin

end;

{ TServiceNewsList }

//procedure THhiOfficeServiceNewsList.GetAttachFileHhiOfficeNews(Ctxt: TSQLRestServerURIContext);
//var
//  fileName: TFileName;
//  content: RawByteString;
//  contentType: RawUTF8;
//begin
//  fileName :=  'c:\temp\' + ExtractFileName(Ctxt.Input['filename']); // or Ctxt.Input['filename']
//  content := StringFromFile(fileName);
//  if content='' then
//    Ctxt.Error('',HTML_NOTFOUND)
//  else
//    Ctxt.Returns(content,HTML_SUCCESS,HEADER_CONTENT_TYPE+
//         GetMimeContentType(pointer(content),Length(content),fileName));
//
////  MainForm.FSeaOceanAttachedFileStream.
//end;

function THhiOfficeServiceNewsList.GetAttachFileHhiOfficeNews(
  AFileName: RawUTF8): TServiceCustomAnswer;
begin
  Result.Header := TEXT_CONTENT_TYPE_HEADER;
  Result.Content := StringFromFile(SHIP_OCEAN_PDF_FILE);
end;

function THhiOfficeServiceNewsList.GetHhiOfficeNewsList: TRawUTF8DynArray;
var
  LCount: integer;
  LDynArr: TDynArray;
begin
  LDynArr.Init(TypeInfo(TRawUTF8DynArray),Result,@LCount);
  Result := MainForm.GetSeaOceanNewsService;
end;

procedure THhiOfficeServiceNewsList.GetHhiOfficeNewsList2(
  out ASeaOceanNewsCollect: TSONewsCollect);
begin
  CopyObject(MainForm.FSeaOceanNewsList2, ASeaOceanNewsCollect);
end;

function THhiOfficeServiceNewsList.GetTimeOnHhiOfficeNews: RawUTF8;
begin
  Result := StringToUtf8(MainForm.AlarmFromTo1.AlarmTimeBegin);
end;

end.
