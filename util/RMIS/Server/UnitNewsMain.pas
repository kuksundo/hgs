unit UnitNewsMain;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, cefvcl, ceflib, MSHTML, Activex,
  Vcl.ComCtrls, Vcl.StdCtrls, Vcl.Buttons, Vcl.ExtCtrls, TimerPool, OmniXML, OmniXMLUtils, OmniXMLXPath,
  AAFont, AACtrls;

const
  KBS_NEWS_LATEST_URL = 'http://news.kbs.co.kr/news/NewsCategory.do?SEARCH_SECTION=0001&SEARCH_CATEGORY=0004';
  KBS_NEWS_MAIN_URL = 'http://news.kbs.co.kr/news/NewsCategory.do?SEARCH_SECTION=0001&&source=http://news.kbs.co.kr/common/NewsMain.html';

type
  TMainForm = class(TForm)
    FChromium: TChromium;
    Panel20: TPanel;
    SpeedButton1: TSpeedButton;
    SpeedButton2: TSpeedButton;
    SpeedButton3: TSpeedButton;
    SpeedButton4: TSpeedButton;
    SpeedButton5: TSpeedButton;
    edAddress: TEdit;
    StatusBar: TStatusBar;
    Panel6: TPanel;
    AAFadeText1: TAAFadeText;
    procedure FChromiumLoadEnd(Sender: TObject; const browser: ICefBrowser;
      const frame: ICefFrame; httpStatusCode: Integer; out Result: Boolean);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure SpeedButton5Click(Sender: TObject);
  private
    FPJHTimerPool: TPJHTimerPool;
    FNewsList: TStringList;

    procedure CallbackGetSource(const src: ustring);
    procedure OnGetNews(Sender : TObject; Handle : Integer;
            Interval : Cardinal; ElapsedTime : LongInt);

    procedure GetMainNews;

    function GetInnersByClass(const Doc: IDispatch; const classname: string;var Lst:TStringList; ATagName: string = ''): Integer;
    function GetInnersByTagName(const Doc: IDispatch; const TagName: string;var Lst:TStringList): Integer;
    procedure GetTitleByClass(const AHtml, classname: string; var Lst:TStringList);
    procedure GetNews2Memo2;
  public
    FSource: ustring;

    procedure InitVar;
    procedure DestroyVar;
  end;

var
  MainForm: TMainForm;

implementation

{$R *.dfm}

procedure TMainForm.CallbackGetSource(const src: ustring);
var
  Lframe: ICefFrame;
  source: string;
  LStr, LStr2: string;
  i, LCount: integer;
  doc, doc2: IHTMLDocument2;
  ArrayV, ArrayV2: OleVariant;
  LStrList: TStringList;
begin
  source := src;
  source := StringReplace(source, '<', '&lt;', [rfReplaceAll]);
  source := StringReplace(source, '>', '&gt;', [rfReplaceAll]);
  source := '<html><body>Source:<pre>' + source + '</pre></body></html>';
//  MainForm.FSource := source;

  if pos('[최신뉴스]', source) = 0 then
    exit;

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
      FNewsList.Clear;
      GetInnersByClass(doc2,'tit',FNewsList,'A');
    finally
      LStrList.Free;
    end;
  finally
  end;

  if FNewsList.Count = 0 then
    FPJHTimerPool.AddOneShot(OnGetNews, 2000);

  for i := 0 to FNewsList.Count - 1 do
    AAFadeText1.Text.Lines.Add('('+IntToStr(i+1)+') ' + FNewsList.Strings[i]);

  LStr := Copy(Caption, 1, Pos(' => ', Caption) - 1);

  if LStr = '' then
    LStr := Caption;

  Caption := LStr + ' => ' + IntToStr(FNewsList.Count) + ' News Updated: ' + FormatDateTime('mm월 dd일, hh:nn:ss', now);
end;


procedure TMainForm.DestroyVar;
begin
  FNewsList.Free;
//  FChromium.Free;
  FPJHTimerPool.RemoveAll;
  FPJHTimerPool.Free;
end;

procedure TMainForm.FChromiumLoadEnd(Sender: TObject; const browser: ICefBrowser;
  const frame: ICefFrame; httpStatusCode: Integer; out Result: Boolean);
begin
  if httpStatusCode <> 0 then
    GetNews2Memo2;
end;

procedure TMainForm.FormCreate(Sender: TObject);
begin
  InitVar;
end;

procedure TMainForm.FormDestroy(Sender: TObject);
begin
  DestroyVar;
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
  FChromium.Browser.Reload;
end;

procedure TMainForm.GetNews2Memo2;
begin
  if FChromium.Browser <> nil then
    FChromium.Browser.MainFrame.GetSourceProc(CallbackGetSource);
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

procedure TMainForm.InitVar;
begin
  FPJHTimerPool := TPJHTimerPool.Create(nil);
  FNewsList := TStringList.Create;
  FChromium.DefaultUrl := KBS_NEWS_MAIN_URL;
  OnGetNews(nil,0,0,0);
  FPJHTimerPool.Add(OnGetNews, 10000);
end;

procedure TMainForm.OnGetNews(Sender: TObject; Handle: Integer; Interval: Cardinal;
  ElapsedTime: Integer);
begin
  GetMainNews;
end;

procedure TMainForm.SpeedButton5Click(Sender: TObject);
begin
  FChromium.Browser.Reload;
end;

end.
