unit WebBrowserUtil;

interface

uses Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  ActiveX, Vcl.OleCtrls, SHDocVw, MSHTML, ComObj, Vcl.Forms, ExtActns, Wininet;

function GetWebBrowserHTML(const WebBrowser: TWebBrowser): String;
function GetHTML(w: TWebBrowser): String;
function GetHtml2(const WebBrowser:TWebBrowser): string;
procedure PrintBrowserDoc(AWB: TWebBrowser; ANoPrompt: Boolean);
procedure SaveBrowserDoc(AWB: TWebBrowser; ANoPrompt: Boolean);
procedure ExecHTML(WebBrowser:TWebBrowser;HtmlCode:string);
procedure WBLoadHTML(WebBrowser: TWebBrowser; HTMLCode: string) ;
function GetInetFileNSave2File(const fileURL, FileName: String): boolean;
function GetInetFileNSave2Stream(const fileURL: String; var AFS: TMemoryStream): boolean;
//procedure DownloadFileFromUrl(WebBrowser: TWebBrowser);
//procedure WB_SaveAs_MHT(WB: TWebBrowser; FileName: TFileName) ;

implementation

function GetWebBrowserHTML(const WebBrowser: TWebBrowser): String;
var
  LStream: TStringStream;
  Stream : IStream;
  LPersistStreamInit : IPersistStreamInit;
begin
  if not Assigned(WebBrowser.Document) then exit;
  LStream := TStringStream.Create('',TEncoding.UTF8);
  try
    LPersistStreamInit := WebBrowser.Document as IPersistStreamInit;
    Stream := TStreamAdapter.Create(LStream,soReference);
    LPersistStreamInit.Save(Stream,true);
    result := LStream.DataString;
  finally
    LStream.Free();
  end;
end;

function GetHTML(w: TWebBrowser): String;
Var
  e: IHTMLElement;
begin
  Result := '';
  if Assigned(w.Document) then
  begin
     e := (w.Document as IHTMLDocument2).body;

     if Not Assigned(e) then
      exit;

     while e.parentElement <> nil do
     begin
       e := e.parentElement;
     end;

     Result := e.outerHTML;
  end;
end;

function GetHtml2(const WebBrowser:TWebBrowser): string;
const
    BufSize   =   $10000;
var
  Size:   Int64;
  Stream:   IStream;
  hHTMLText:   HGLOBAL;
  psi:   IPersistStreamInit;
begin
  if   not   Assigned(WebBrowser.Document)   then   Exit;

  OleCheck(WebBrowser.Document.QueryInterface
  (IPersistStreamInit,   psi));
  try
  OleCheck(psi.GetSizeMax(Size));
      hHTMLText   :=   GlobalAlloc(GPTR,   BufSize);
      if   0   =   hHTMLText   then   RaiseLastWin32Error;

      OleCheck(CreateStreamOnHGlobal(hHTMLText,True,   Stream));

      try
          OleCheck(psi.Save(Stream,   False));

          Size   :=   StrLen(PChar(hHTMLText));
          SetLength(Result,   Size);
          CopyMemory(PChar(Result),   Pointer(hHTMLText),   Size);
      finally
          Stream   :=   nil;
      end;
  finally
      psi   :=   nil;
  end;
end;

procedure PrintBrowserDoc(AWB: TWebBrowser; ANoPrompt: Boolean);
const
  prompt: array[boolean] of Cardinal =
(OLECMDEXECOPT_DODEFAULT,OLECMDEXECOPT_DONTPROMPTUSER);
var
  CmdTarget: IOLECommandTarget;
  vIn, vOut: OleVariant;
begin
  if AWB.Document <> nil then
  try
    AWB.document.QueryInterface(IOLECommandTarget, CmdTarget);
    if CmdTarget <> nil then
    try
      CmdTarget.Exec(PGUID(nil), OLECMDID_PRINT, prompt[ANoPrompt], vIn, vOut);
    finally
      CmdTarget._Release;
    end;
  except
  end;
end;

{WebBrowser1.ExecWB(OLECMDID_NEW,1);
WebBrowser1.ExecWB(OLECMDID_OPEN,1);
WebBrowser1.ExecWB(OLECMDID_SAVE,1);

WebBrowser1.ExecWB(OLECMDID_SAVEAS,1);
///-
WebBrowser1.ExecWB(OLECMDID_PRINT,1);
WebBrowser1.ExecWB(OLECMDID_PRINTPREVIEW,1);
WebBrowser1.ExecWB(OLECMDID_PAGESETUP,1);
///-
WebBrowser1.ExecWB(OLECMDID_PROPERTIES,1);

///
WebBrowser1.ExecWB(OLECMDID_REDO ,1);
WebBrowser1.ExecWB(OLECMDID_UNDO ,1);
///-
WebBrowser1.ExecWB(OLECMDID_COPY,1);
WebBrowser1.ExecWB(OLECMDID_PASTE,1);
WebBrowser1.ExecWB(OLECMDID_CUT ,1);
WebBrowser1.ExecWB(OLECMDID_DELETE,1);
///-
WebBrowser1.ExecWB(OLECMDID_SELECTALL,1);
WebBrowser1.ExecWB(OLECMDID_CLEARSELECTION,1);

WebBrowser1.ExecWB(OLECMDID_FIND,1);}
procedure SaveBrowserDoc(AWB: TWebBrowser; ANoPrompt: Boolean);
const
  prompt: array[boolean] of Cardinal =
(OLECMDEXECOPT_DODEFAULT,OLECMDEXECOPT_DONTPROMPTUSER);
var
  CmdTarget: IOLECommandTarget;
  vIn, vOut: OleVariant;
begin
  if AWB.Document <> nil then
  try
    AWB.document.QueryInterface(IOLECommandTarget, CmdTarget);
    if CmdTarget <> nil then
    try
      CmdTarget.Exec(PGUID(nil), OLECMDID_SAVEAS, prompt[ANoPrompt], vIn, vOut);
    finally
      CmdTarget._Release;
    end;
  except
  end;
end;

procedure ExecHTML(WebBrowser:TWebBrowser;HtmlCode:string);
var
  StringStream:TStringStream;
begin
  StringStream := TStringStream.Create(HtmlCode);
  try
    StringStream.Position := 0;
    (WebBrowser.Document as IPersistStreamInit).Load(TStreamAdapter.Create(StringStream));
  finally
    StringStream.Free;
  end;
end;

procedure WBLoadHTML(WebBrowser: TWebBrowser; HTMLCode: string) ;
var
   sl: TStringList;
   ms: TMemoryStream;
begin
   WebBrowser.Navigate('about:blank') ;
   while WebBrowser.ReadyState < READYSTATE_INTERACTIVE do
    Application.ProcessMessages;

   if Assigned(WebBrowser.Document) then
   begin
     sl := TStringList.Create;
     try
       ms := TMemoryStream.Create;
       try
         HTMLCode:='<meta http-equiv="Content-Type" content="text/html; charset=gbk"/>'+HTMLCode;
         sl.Text := HTMLCode;
         sl.SaveToStream(ms) ;
         ms.Seek(0, 0) ;
         (WebBrowser.Document as IPersistStreamInit).Load(TStreamAdapter.Create(ms)) ;
       finally
         ms.Free;
       end;
     finally
       sl.Free;
     end;
   end;
end;

function GetInetFileNSave2File(const fileURL, FileName: String): boolean;
const
  BufferSize = 1024;
var
  hSession, hURL: HInternet;
  Buffer: array[1..BufferSize] of Byte;
  BufferLen: DWORD;
  f: File;
  sAppName: string;
begin
  Result:=False;
  sAppName := ExtractFileName(Application.ExeName);
  hSession := InternetOpen(
    PChar(sAppName),
    INTERNET_OPEN_TYPE_PRECONFIG,
    nil, nil, 0
    );
  try
    hURL := InternetOpenURL(hSession, PChar(fileURL), nil, 0, 0, 0);
    try
      AssignFile(f, FileName);
      Rewrite(f,1);
      repeat
        InternetReadFile(hURL, @Buffer, SizeOf(Buffer), BufferLen);
        BlockWrite(f, Buffer, BufferLen)
      until BufferLen = 0;
      CloseFile(f);
      Result:=True;
    finally
      InternetCloseHandle(hURL)
    end
  finally
    InternetCloseHandle(hSession)
  end
end;

function GetInetFileNSave2Stream(const fileURL: String; var AFS: TMemoryStream): boolean;
const
  BufferSize = 1024;
var
  hSession, hURL: HInternet;
  Buffer: array[1..BufferSize] of Byte;
  BufferLen: DWORD;
  sAppName: string;
begin
  Result:=False;
  sAppName := ExtractFileName(Application.ExeName);
  hSession := InternetOpen(
    PChar(sAppName),
    INTERNET_OPEN_TYPE_PRECONFIG,
    nil, nil, 0
    );
  try
    hURL := InternetOpenURL(hSession, PChar(fileURL), nil, 0, 0, 0);
    try
      AFS.Position := 0;

      repeat
        InternetReadFile(hURL, @Buffer, SizeOf(Buffer), BufferLen);
        AFS.WriteBuffer(@Buffer, BufferLen);
      until BufferLen = 0;

      Result:=True;
    finally
      InternetCloseHandle(hURL)
    end
  finally
    InternetCloseHandle(hSession)
  end
end;

//function GetCacheFileName(URL: string): string;
//var
//  pInfo: PInternetCacheEntryInfo;
//  bufSize: Cardinal;
//begin
//  Result := '';
//  bufSize := 0;
//  pInfo := nil;
//  if not GetUrlCacheEntryInfo(PChar(URL), pInfo^, bufSize) then
//  begin
//    if GetLastError = ERROR_INSUFFICIENT_BUFFER then
//      pInfo := AllocMem(bufSize)
//    else
//      Exit;
//  end
//  else
//    Exit;
//
//  if not GetUrlCacheEntryInfo(PChar(URL), pInfo^, bufSize) then
//  begin
//    FreeMem(pInfo);
//    Exit;
//  end;
//
//  Result := pInfo^.lpszLocalFileName;
//  FreeMem(pInfo);
//end;
//
//procedure DownloadFileFromUrl(WebBrowser: TWebBrowser);
//var
//  DownloadURL: TDownloadURL;
//begin
//  DownloadURL := TDownloadURL.Create(nil);
//  try
//    { If a cached file exists, remove it }
//    CacheFilename := GetCacheFilename(URL);
//    if FileExists(CacheFilename) then
//      SysUtils.DeleteFile(CacheFilename);
//
//    { Fetch the contents of the file }
//    DownloadURL.URL := URL;
//    DownloadURL.Filename := GenerateTempFilename;
//    DownloadURL.ExecuteTarget(nil);
//  finally
//     DownloadURL.Free;
//  end;
//end;
//uses CDO_TLB, ADODB_TLB;
//Usage: WB_SaveAs_MHT(WebBrowser1,'c:\WebBrowser1.mht') ;
//procedure WB_SaveAs_MHT(WB: TWebBrowser; FileName: TFileName) ;
//var
//   Msg: IMessage;
//   Conf: IConfiguration;
//   Stream: _Stream;
//   URL : widestring;
//begin
//   if not Assigned(WB.Document) then Exit;
//
//   URL := WB.LocationURL;
//
//   Msg := CoMessage.Create;
//   Conf := CoConfiguration.Create;
//   try
//     Msg.Configuration := Conf;
//     Msg.CreateMHTMLBody(URL, cdoSuppressAll, '', '') ;
//     Stream := Msg.GetStream;
//     Stream.SaveToFile(FileName, adSaveCreateOverWrite) ;
//   finally
//     Msg := nil;
//     Conf := nil;
//     Stream := nil;
//   end;
//end; (* WB_SaveAs_MHT *)

end.
