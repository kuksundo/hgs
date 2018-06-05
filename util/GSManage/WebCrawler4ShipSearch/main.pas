unit main;

interface
{$I cef.inc}

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ceflib, cefvcl, Buttons, ActnList, Menus, ComCtrls,
  ExtCtrls, XPMan, Registry, ShellApi, SyncObjs, System.Actions, HtmlParserEx,
  OtlCommon, OtlComm, OtlTaskControl, OtlContainerObserver, otlTask, OtlParallel,
  OtlCollections,
  SynCommons, UnitVesselMasterRecord, IPC.Events;

type
  THtmlRec = record
    FHtmlMsg: string;
    FHtmlStatusCode: integer;
  end;

  TUrlRec = record
    FUrlMsg: string;
    FWaitTime: integer;
  end;

  TMainForm = class(TForm)
    crm: TChromium;
    DevTools: TChromiumDevTools;
    StatusBar: TStatusBar;
    ActionList: TActionList;
    actPrev: TAction;
    actNext: TAction;
    actHome: TAction;
    actReload: TAction;
    actGoTo: TAction;
    MainMenu: TMainMenu;
    File1: TMenuItem;
    est1: TMenuItem;
    mGetsource: TMenuItem;
    mGetText: TMenuItem;
    actGetSource: TAction;
    actGetText: TAction;
    actZoomIn: TAction;
    actZoomOut: TAction;
    actZoomReset: TAction;
    Zoomin1: TMenuItem;
    Zoomout1: TMenuItem;
    Zoomreset1: TMenuItem;
    actExecuteJS: TAction;
    ExecuteJavaScript1: TMenuItem;
    Exit1: TMenuItem;
    Print1: TMenuItem;
    actFileScheme1: TMenuItem;
    actDom: TAction;
    VisitDOM1: TMenuItem;
    SaveDialog: TSaveDialog;
    actDevTool: TAction;
    DevelopperTools1: TMenuItem;
    Panel1: TPanel;
    SpeedButton1: TSpeedButton;
    SpeedButton2: TSpeedButton;
    SpeedButton3: TSpeedButton;
    SpeedButton4: TSpeedButton;
    edAddress: TEdit;
    SpeedButton5: TSpeedButton;
    actDoc: TAction;
    Help1: TMenuItem;
    Documentation1: TMenuItem;
    actGroup: TAction;
    Googlegroup1: TMenuItem;
    actFileScheme: TAction;
    actPrint: TAction;
    Hgs1: TMenuItem;
    GetVesselInfofromIMONo1: TMenuItem;
    OpenDialog1: TOpenDialog;
    GotoSeaweb1: TMenuItem;
    GetVesselInfofromhtml1: TMenuItem;
    ShowHtmlSource1: TMenuItem;
    ShowTextSource1: TMenuItem;
    GetVesselInfofromhtmlwithMQ1: TMenuItem;
    Timer1: TTimer;
    Memo1: TMemo;
    Splitter: TSplitter;
    DisplayMsgTest1: TMenuItem;
    UrlDequeueSignal1: TMenuItem;
    GetVesselInfoFromText1: TMenuItem;
    GetVesselInfofromIMONo2: TMenuItem;
    N1: TMenuItem;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure edAddressKeyPress(Sender: TObject; var Key: Char);
    procedure actPrevExecute(Sender: TObject);
    procedure actNextExecute(Sender: TObject);
    procedure actHomeExecute(Sender: TObject);
    procedure actReloadExecute(Sender: TObject);
    procedure actReloadUpdate(Sender: TObject);
    procedure actGoToExecute(Sender: TObject);
    procedure actHomeUpdate(Sender: TObject);
    procedure actGetSourceExecute(Sender: TObject);
    procedure actGetTextExecute(Sender: TObject);
    procedure actZoomInExecute(Sender: TObject);
    procedure actZoomOutExecute(Sender: TObject);
    procedure actZoomResetExecute(Sender: TObject);
    procedure actExecuteJSExecute(Sender: TObject);
    procedure Exit1Click(Sender: TObject);
    procedure actFileSchemeExecute(Sender: TObject);
    procedure actDomExecute(Sender: TObject);
    procedure actNextUpdate(Sender: TObject);
    procedure actPrevUpdate(Sender: TObject);
    procedure crmAddressChange(Sender: TObject; const browser: ICefBrowser;
      const frame: ICefFrame; const url: ustring);
    procedure crmLoadEnd(Sender: TObject; const browser: ICefBrowser;
      const frame: ICefFrame; httpStatusCode: Integer);
    procedure crmLoadStart(Sender: TObject; const browser: ICefBrowser;
      const frame: ICefFrame);
    procedure crmStatusMessage(Sender: TObject; const browser: ICefBrowser;
      const value: ustring);
    procedure crmTitleChange(Sender: TObject; const browser: ICefBrowser;
      const title: ustring);
    procedure actDevToolExecute(Sender: TObject);
    procedure actDocExecute(Sender: TObject);
    procedure actGroupExecute(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure crmBeforeDownload(Sender: TObject; const browser: ICefBrowser;
      const downloadItem: ICefDownloadItem; const suggestedName: ustring;
      const callback: ICefBeforeDownloadCallback);
    procedure crmDownloadUpdated(Sender: TObject; const browser: ICefBrowser;
      const downloadItem: ICefDownloadItem;
      const callback: ICefDownloadItemCallback);
    procedure crmProcessMessageReceived(Sender: TObject;
      const browser: ICefBrowser; sourceProcess: TCefProcessId;
      const message: ICefProcessMessage; out Result: Boolean);
    procedure actPrintExecute(Sender: TObject);
    procedure crmBeforeContextMenu(Sender: TObject; const browser: ICefBrowser;
      const frame: ICefFrame; const params: ICefContextMenuParams;
      const model: ICefMenuModel);
    procedure crmContextMenuCommand(Sender: TObject; const browser: ICefBrowser;
      const frame: ICefFrame; const params: ICefContextMenuParams;
      commandId: Integer; eventFlags: TCefEventFlags; out Result: Boolean);
    procedure crmCertificateError(Sender: TObject; const browser: ICefBrowser;
      certError: Integer; const requestUrl: ustring; const sslInfo: ICefSslInfo;
      const callback: ICefRequestCallback; out Result: Boolean);
    procedure crmBeforePopup(Sender: TObject; const browser: ICefBrowser;
      const frame: ICefFrame; const targetUrl, targetFrameName: ustring;
      targetDisposition: TCefWindowOpenDisposition; userGesture: Boolean;
      var popupFeatures: TCefPopupFeatures; var windowInfo: TCefWindowInfo;
      var client: ICefClient; var settings: TCefBrowserSettings;
      var noJavascriptAccess: Boolean; out Result: Boolean);
    procedure crmBeforeResourceLoad(Sender: TObject; const browser: ICefBrowser;
      const frame: ICefFrame; const request: ICefRequest;
      const callback: ICefRequestCallback; out Result: TCefReturnValue);
    procedure GetVesselInfofromIMONo1Click(Sender: TObject);
    procedure GotoSeaweb1Click(Sender: TObject);
    procedure GetVesselInfofromhtml1Click(Sender: TObject);
    procedure ShowHtmlSource1Click(Sender: TObject);
    procedure ShowTextSource1Click(Sender: TObject);
    procedure GetVesselInfofromhtmlwithMQ1Click(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
    procedure DisplayMsgTest1Click(Sender: TObject);
    procedure UrlDequeueSignal1Click(Sender: TObject);
    procedure GetVesselInfofromIMONo2Click(Sender: TObject);
  private
    FDisplayStopEvent,
    FStopEvent,
    FUrlStopEvent    : TEvent;
    FDisplayMsgQueue,
    FHtmlMsgQueue,
    FUrlMsgQueue : TOmniMessageQueue;
    FLoading: Boolean;

    function IsMain(const b: ICefBrowser; const f: ICefFrame = nil): Boolean;

    function ExtractDockSurveyFromHtml(AHtml: IHtmlElement; var ADoc: variant): variant;
    function ExtractShipNameNIMONoFromHtml(AHtml: IHtmlElement; var ADoc: variant): variant;
    //Ownership은 JS함수로 결과를 보여주므로 Html로는 정보 추출 안되어 txt로 입력 받음
    procedure ExtractOwnershipFromTxt(ATxt: string; var ADoc: variant);

//    procedure PipeLine_LoadUrl(const input: TOmniValue; var output: TOmniValue);
//    procedure PipeLine_GetSource(const input: TOmniValue; var output: TOmniValue);
//                                  //const input, output: IOmniBlockingCollection
//    procedure PipeLine_PrecessHtml(const input: TOmniValue; var output: TOmniValue);
  public
    UrlMsgDequeEvent, UrlMsgStartEvent: Event;
//    FFetchVesselInfoPipeline: IOmniPipeline;

    procedure AsynDisplayMsg;
    procedure AsynProcessHtml;
    procedure AsynProcessUrl;
    procedure AsynGetVesselInfoFromIMONo(AImoNo: string='');
    procedure PipeLineLoadHtmlFromWeb(AUrl: string);
    procedure UrlMsgEnqueue(AUrl: string);
    procedure DisplayMsgEnqueue(AMsg: string);

    procedure GetVesselInfoFromIMONo;
    procedure LoadHtmlFromFile(AFileName: string);
    procedure LoadHtmlFromWeb(AUrl: string);
    procedure LoadHtmlFromWeb_(AUrl: string);
    procedure GetVesselInfoFromHtml(AMsgID: integer; ATextSource: string);
    procedure GetVesselInfoFromText(AText: string; var ADoc: variant);
    procedure ExtractVesselInfoFromHtml(AHtml: string);
    procedure GetTextNHtmlFromChromium;
  end;

  TCustomRenderProcessHandler = class(TCefRenderProcessHandlerOwn)
  protected
    procedure OnWebKitInitialized; override;
  end;

  TTestExtension = class
    class function hello: string;
    class procedure mouseover(const data: string);
  end;

var
  g_OnlyViewSrc: Boolean;
  MainForm: TMainForm;

implementation

uses UnitStringUtil, FrmIMONoEdit;

const
  CUSTOMMENUCOMMAND_INSPECTELEMENT = 7241221;

{$R *.dfm}

procedure TMainForm.actDevToolExecute(Sender: TObject);
begin
  if actDevTool.Checked then
  begin
    DevTools.Visible := True;
    Splitter.Visible := True;
    DevTools.ShowDevTools(crm.Browser);
  end else
  begin
    DevTools.CloseDevTools(crm.Browser);
    Splitter.Visible := False;
    DevTools.Visible := False;
  end;
end;

procedure TMainForm.actDocExecute(Sender: TObject);
begin
  crm.Load('http://magpcss.org/ceforum/apidocs3');
end;

procedure TMainForm.actDomExecute(Sender: TObject);
begin
  if crm.Browser <> nil then
    crm.Browser.MainFrame.ExecuteJavaScript(
      'document.body.addEventListener("mouseover", function(evt){'+
        'function getpath(n){'+
          'var ret = "<" + n.nodeName + ">";'+
          'if (n.parentNode){return getpath(n.parentNode) + ret} else '+
          'return ret'+
        '};'+
        'app.mouseover(getpath(evt.target))}'+
      ')', 'about:blank', 0);
end;

procedure TMainForm.actExecuteJSExecute(Sender: TObject);
begin
  if crm.Browser <> nil then
    crm.Browser.MainFrame.ExecuteJavaScript(
      'alert(''JavaScript execute works!'');', 'about:blank', 0);
end;

procedure TMainForm.actFileSchemeExecute(Sender: TObject);
begin
  if crm.Browser <> nil then
    crm.Browser.MainFrame.LoadUrl('local://c/');
end;

procedure CallbackGetSource(const src: ustring);
var
  source: ustring;
  LOmniValue: TOmniValue;
  LHtmlRec: THtmlRec;
begin
  source := src;
//  source := StringReplace(source, '<', '&lt;', [rfReplaceAll]);
//  source := StringReplace(source, '>', '&gt;', [rfReplaceAll]);
  source := '<html><body>Source:<pre>' + source + '</pre></body></html>';
//  MainForm.FHtmlSource := source;

  if source <> ''  then
  begin
//    LHtmlRec.FHtmlMsg := source;
//    LOmniValue := TOmniValue.FromRecord<THtmlRec>(LHtmlRec);
//    MainForm.FHtmlMsgQueue.Enqueue(TOmniMessage.Create(2, LOmniValue));
  end;
//  MainForm.crm.Browser.MainFrame.LoadString(source, 'source://html');
end;

procedure TMainForm.actGetSourceExecute(Sender: TObject);
begin
  crm.Browser.MainFrame.GetSourceProc(CallbackGetSource);
end;

procedure CallbackGetText(const txt: ustring);
var
  source: ustring;
  LOmniValue: TOmniValue;
  LHtmlRec: THtmlRec;
begin
  source := txt;

  if g_OnlyViewSrc then
  begin
    g_OnlyViewSrc := False;
    MainForm.Memo1.Clear;
    MainForm.Memo1.Lines.Add(source);
    exit;
  end;

//  MainForm.FTextSource := source;
  LHtmlRec.FHtmlMsg := source;
  LOmniValue := TOmniValue.FromRecord<THtmlRec>(LHtmlRec);
  MainForm.FHtmlMsgQueue.Enqueue(TOmniMessage.Create(2, LOmniValue));
//  source := StringReplace(source, '<', '&lt;', [rfReplaceAll]);
//  source := StringReplace(source, '>', '&gt;', [rfReplaceAll]);
//  source := '<html><body>Text:<pre>' + source + '</pre></body></html>';
//  MainForm.crm.Browser.MainFrame.LoadString(source, 'source://text');
end;

procedure TMainForm.actGetTextExecute(Sender: TObject);
begin
  g_OnlyViewSrc := True;
  crm.Browser.MainFrame.GetTextProc(CallbackGetText);
end;

procedure TMainForm.actGoToExecute(Sender: TObject);
begin
  if crm.Browser <> nil then
    crm.Browser.MainFrame.LoadUrl(edAddress.Text);
end;

procedure TMainForm.actGroupExecute(Sender: TObject);
begin
  crm.Load('https://groups.google.com/forum/?fromgroups#!forum/delphichromiumembedded');
end;

procedure TMainForm.actHomeExecute(Sender: TObject);
begin
  if crm.Browser <> nil then
    crm.Browser.MainFrame.LoadUrl(crm.DefaultUrl);
end;

procedure TMainForm.actHomeUpdate(Sender: TObject);
begin
  TAction(Sender).Enabled := crm.Browser <> nil;
end;

procedure TMainForm.actNextExecute(Sender: TObject);
begin
  if crm.Browser <> nil then
    crm.Browser.GoForward;
end;

procedure TMainForm.actNextUpdate(Sender: TObject);
begin
  if crm.Browser <> nil then
    actNext.Enabled := crm.Browser.CanGoForward else
    actNext.Enabled := False;
end;

procedure TMainForm.actPrevExecute(Sender: TObject);
begin
  if crm.Browser <> nil then
    crm.Browser.GoBack;
end;

procedure TMainForm.actPrevUpdate(Sender: TObject);
begin
  if crm.Browser <> nil then
    actPrev.Enabled := crm.Browser.CanGoBack else
    actPrev.Enabled := False;
end;

procedure TMainForm.actPrintExecute(Sender: TObject);
begin
  crm.Browser.Host.Print;
end;

procedure TMainForm.actReloadExecute(Sender: TObject);
begin
  if crm.Browser <> nil then
    if FLoading then
      crm.Browser.StopLoad else
      crm.Browser.Reload;
end;

procedure TMainForm.actReloadUpdate(Sender: TObject);
begin
  if FLoading then
    TAction(sender).Caption := 'X' else
    TAction(sender).Caption := 'R';
  TAction(Sender).Enabled := crm.Browser <> nil;
end;

function TMainForm.IsMain(const b: ICefBrowser; const f: ICefFrame): Boolean;
begin
  Result := (b <> nil) and (b.Identifier = crm.BrowserId) and ((f = nil) or (f.IsMain));
end;

procedure TMainForm.LoadHtmlFromFile(AFileName: string);
var
  LStrStream: TStringStream;
begin
  LStrStream := TStringStream.Create;
  try
    LStrStream.LoadFromFile(AFileName);
    ExtractVesselInfoFromHtml(LStrStream.DataString);
  finally
    LStrStream.Free;
  end;
end;

procedure TMainForm.LoadHtmlFromWeb(AUrl: string);
begin
  LoadHtmlFromWeb_(AUrl);
//  TDocVariant.New(LDoc);
//  LoadHtmlFromWeb(AUrl);
//  Memo1.Lines.Add(LDoc);
end;

procedure TMainForm.LoadHtmlFromWeb_(AUrl: string);
var
  LStr, LStr2: string;
//  LStrStream: TStringStream;
begin
//  LStrStream := TStringStream.Create;
//  try
//    LStrStream.LoadFromFile('E:\aaa\ttt\searchship.html');
//    FHtmlSource := LStrStream.DataString;
//    LStrStream.Clear;
//    LStrStream.LoadFromFile('E:\aaa\ttt\searchship.txt');
//    FTextSource := LStrStream.DataString;
//  finally
//    LStrStream.Free;
//  end;

  crm.Browser.MainFrame.LoadUrl(AUrl);
end;

procedure TMainForm.PipeLineLoadHtmlFromWeb(AUrl: string);
begin
//  if Assigned(FFetchVesselInfoPipeline) then
//    if not FFetchVesselInfoPipeline.Output.IsCompleted then
//      exit;
//
//  FFetchVesselInfoPipeline := Parallel.Pipeline
//    .Stage(PipeLine_LoadUrl)//.NumTasks(Environment.Process.Affinity.Count * 2)
//    .Stage(PipeLine_GetSource)
//    .Stage(PipeLine_PrecessHtml)
//    .Run;

end;

procedure TMainForm.ShowHtmlSource1Click(Sender: TObject);
begin
//  Memo1.Lines.Add(FHtmlSource);
end;

procedure TMainForm.ShowTextSource1Click(Sender: TObject);
begin
//  Memo1.Lines.Add(FTextSource);
end;

procedure TMainForm.Timer1Timer(Sender: TObject);
begin
  Timer1.Enabled := False;
  FLoading := False;
  GetTextNHtmlFromChromium;
end;

procedure TMainForm.UrlDequeueSignal1Click(Sender: TObject);
begin
  UrlMsgDequeEvent.Signal;
end;

procedure TMainForm.UrlMsgEnqueue(AUrl: string);
var
  LOmniValue: TOmniValue;
  LUrlRec: TUrlRec;
begin
  LUrlRec.FUrlMsg := AUrl;
  LOmniValue := TOmniValue.FromRecord<TUrlRec>(LUrlRec);
  FUrlMsgQueue.Enqueue(TOmniMessage.Create(1, LOmniValue));
end;

procedure TMainForm.actZoomInExecute(Sender: TObject);
begin
  if crm.Browser <> nil then
    crm.Browser.Host.ZoomLevel := crm.Browser.Host.ZoomLevel + 0.5;
end;

procedure TMainForm.actZoomOutExecute(Sender: TObject);
begin
  if crm.Browser <> nil then
    crm.Browser.Host.ZoomLevel := crm.Browser.Host.ZoomLevel - 0.5;
end;

procedure TMainForm.actZoomResetExecute(Sender: TObject);
begin
  if crm.Browser <> nil then
    crm.Browser.Host.ZoomLevel := 0;
end;

procedure TMainForm.AsynDisplayMsg;
begin
  Parallel.Async(
    procedure (const task: IOmniTask)
    var
      i: integer;
      handles: array [0..1] of THandle;
      msg    : TOmniMessage;
      LHtmlRec: THtmlRec;
      LStr: string;
    begin
      handles[0] := FDisplayStopEvent.Handle;
      handles[1] := FDisplayMsgQueue.GetNewMessageEvent;

      while WaitForMultipleObjects(2, @handles, false, INFINITE) = (WAIT_OBJECT_0 + 1) do
      begin
        while FDisplayMsgQueue.TryDequeue(msg) do
        begin
          try
            LHtmlRec := msg.MsgData.ToRecord<THtmlRec>;
            if msg.MsgID = 1 then
            begin
              LStr := LHtmlRec.FHtmlMsg;
            end
            else
            if msg.MsgID = 2 then
            begin
            end
            else
            if msg.MsgID = 3 then
            begin
            end;

            task.Invoke(
              procedure
              begin
                if LStr <> '' then
                begin
                  Memo1.Lines.Add(LStr);
                  LStr := '';
                end;
              end
            );
          finally

          end;
        end;//while
      end;//while
    end,

    Parallel.TaskConfig.OnMessage(Self).OnTerminated(
      procedure
      begin
      end
    )
  );
end;

procedure TMainForm.AsynGetVesselInfoFromIMONo(AImoNo: string);
const
  SEA_WEB_IMO = 'https://maritime.ihs.com/Areas/Seaweb/authenticated/authenticated_handler.aspx?control=shipovw&LRNO=';
  MaxCount = 3000;
begin
  Parallel.Async(
    procedure (const task: IOmniTask)
    var
      i: integer;
      LStr: string;
      LSQLVesselMaster: TSQLVesselMaster;
      LIsCompleted: Boolean;
    begin
      while True do
      begin
        try
          if AImoNo = '' then
          begin
            LSQLVesselMaster := GetVesselMasterFromSpecialSurveyDueZero;
            LSQLVesselMaster.FillRewind;

  //          for i := 1 to MaxCount do
            i := 0;
            while LSQLVesselMaster.FillOne do
            begin
  //            if LSQLVesselMaster.FillOne then
  //            begin
                if LSQLVesselMaster.IMONo <> '' then
                begin
                  LStr := SEA_WEB_IMO+LSQLVesselMaster.IMONo;
                  UrlMsgEnqueue(LStr);
                end;
                StatusBar.Panels[1].Text := IntToStr(i) + '/' + IntToStr(MaxCount);
                UrlMsgDequeEvent.Signal;
                UrlMsgStartEvent.WaitForSignal();
                Inc(i);
  //            end;
            end;

            LIsCompleted := True;
            StatusBar.Panels[1].Text := IntToStr(i) + '/' + IntToStr(MaxCount);
          end
          else
          begin
            LStr := SEA_WEB_IMO+AImoNo;
            UrlMsgEnqueue(LStr);
            StatusBar.Panels[1].Text := '1/1';
            UrlMsgDequeEvent.Signal;
          end;

          Break;
//          UrlMsgStartEvent.Signal;

          task.Invoke(
            procedure
            begin
//              if LIsCompleted then
//                ShowMessage(IntToStr(i) + ' 건 처리 완료');
            end
          );
        finally

        end;
      end;//while
    end,

    Parallel.TaskConfig.OnMessage(Self).OnTerminated(
      procedure
      begin
      end
    )
  );
end;

procedure TMainForm.AsynProcessHtml;
begin
  Parallel.Async(
    procedure (const task: IOmniTask)
    var
      i: integer;
      handles: array [0..1] of THandle;
      msg    : TOmniMessage;
      LHtmlRec: THtmlRec;
      LStr, LText: string;
    begin
      handles[0] := FStopEvent.Handle;
      handles[1] := FHtmlMsgQueue.GetNewMessageEvent;

      while WaitForMultipleObjects(2, @handles, false, INFINITE) = (WAIT_OBJECT_0 + 1) do
      begin
        while FHtmlMsgQueue.TryDequeue(msg) do
        begin
          try
            LHtmlRec := msg.MsgData.ToRecord<THtmlRec>;
            if msg.MsgID = 1 then
            begin
            end
            else
            if msg.MsgID = 2 then
            begin
              LText := LHtmlRec.FHtmlMsg;
//              LHtml := LHtmlRec.FHtmlMsg;
            end
            else
            if msg.MsgID = 3 then
            begin
            end;

            task.Invoke(
              procedure
              begin
                if msg.MsgID = 2 then
                begin
//                  DisplayMsgEnqueue(LText);
                  GetVesselInfoFromHtml(msg.MsgID, LText);
                  LText := '';
                  UrlMsgStartEvent.Signal;
                end;
              end
            );
          finally

          end;
        end;//while
      end;//while
    end,

    Parallel.TaskConfig.OnMessage(Self).OnTerminated(
      procedure
      begin
      end
    )
  );
end;

procedure TMainForm.AsynProcessUrl;
begin
  Parallel.Async(
    procedure (const task: IOmniTask)
    var
      i: integer;
      handles: array [0..1] of THandle;
      msg    : TOmniMessage;
      LUrlRec: TUrlRec;
      LStr: string;
      LExuceteTask: Boolean;
    begin
      handles[0] := FUrlStopEvent.Handle;
      handles[1] := FUrlMsgQueue.GetNewMessageEvent;
      LExuceteTask := False;

      while WaitForMultipleObjects(2, @handles, false, INFINITE) = (WAIT_OBJECT_0 + 1) do
      begin
        while FUrlMsgQueue.TryDequeue(msg) do
        begin
          try
            LStr := '';
            LUrlRec := msg.MsgData.ToRecord<TUrlRec>;

//            if LUrlRec.FUrlMsg = '' then
//              Continue;

            LStr := LUrlRec.FUrlMsg;
            LExuceteTask := LStr <> '';

            if msg.MsgID = 1 then
            begin
            end
            else
            if msg.MsgID = 2 then
            begin
            end
            else
            if msg.MsgID = 3 then
            begin
            end;

            task.Invoke(
              procedure
              begin
                if LExuceteTask then
                begin
                  if crm.Browser <> nil then
                  begin
  //                  DisplayMsgEnqueue('LStr: ' + LStr);
                    if LStr = '' then
                    begin
                      DisplayMsgEnqueue('LStr = ');
                      UrlMsgDequeEvent.Signal;
                    end
                    else
                    begin
                      crm.Browser.MainFrame.LoadUrl(LStr);
                      DisplayMsgEnqueue('LoadUrl: ' + LStr);
//                      UrlMsgStartEvent.Signal;
                    end;
                  end;
                  LExuceteTask := False;
                end
                else
                  UrlMsgDequeEvent.Signal;
              end
            );
          finally
          end;
        end;//while

        UrlMsgDequeEvent.WaitForSignal();
      end;//while
    end,

    Parallel.TaskConfig.OnMessage(Self).OnTerminated(
      procedure
      begin
      end
    )
  );
end;

procedure TMainForm.crmAddressChange(Sender: TObject;
  const browser: ICefBrowser; const frame: ICefFrame; const url: ustring);
begin
  if IsMain(browser, frame) then
    edAddress.Text := url;
end;

procedure TMainForm.crmBeforeContextMenu(Sender: TObject;
  const browser: ICefBrowser; const frame: ICefFrame;
  const params: ICefContextMenuParams; const model: ICefMenuModel);
begin
  model.AddItem(CUSTOMMENUCOMMAND_INSPECTELEMENT, 'Inspect Element');
end;

procedure TMainForm.crmBeforeDownload(Sender: TObject;
  const browser: ICefBrowser; const downloadItem: ICefDownloadItem;
  const suggestedName: ustring; const callback: ICefBeforeDownloadCallback);
begin
  callback.Cont(ExtractFilePath(ParamStr(0)) + suggestedName, True);
end;

procedure TMainForm.crmBeforePopup(Sender: TObject; const browser: ICefBrowser;
  const frame: ICefFrame; const targetUrl, targetFrameName: ustring;
  targetDisposition: TCefWindowOpenDisposition; userGesture: Boolean;
  var popupFeatures: TCefPopupFeatures; var windowInfo: TCefWindowInfo;
  var client: ICefClient; var settings: TCefBrowserSettings;
  var noJavascriptAccess: Boolean; out Result: Boolean);
begin
  // prevent popup
  crm.Load(targetUrl);
  Result := True;
end;

procedure TMainForm.crmBeforeResourceLoad(Sender: TObject;
  const browser: ICefBrowser; const frame: ICefFrame;
  const request: ICefRequest; const callback: ICefRequestCallback;
  out Result: TCefReturnValue);
var
  u: TUrlParts;
begin
  // redirect home to google
  if CefParseUrl(request.Url, u) then
    if (u.host = 'home') then
    begin
      u.host := 'www.google.com';
      request.Url := CefCreateUrl(u);
    end;
end;

procedure TMainForm.crmCertificateError(Sender: TObject;
  const browser: ICefBrowser; certError: Integer; const requestUrl: ustring;
  const sslInfo: ICefSslInfo; const callback: ICefRequestCallback;
  out Result: Boolean);
begin
  // let use untrusted certificates (ex: cacert.org)
  MainForm.Caption := sslInfo.GetIssuer.GetDisplayName;
  callback.Cont(True);
  Result := True;
end;

procedure TMainForm.crmContextMenuCommand(Sender: TObject;
  const browser: ICefBrowser; const frame: ICefFrame;
  const params: ICefContextMenuParams; commandId: Integer;
  eventFlags: TCefEventFlags; out Result: Boolean);
var
  mousePoint: TCefPoint;
begin
  Result := False;
  if (commandId = CUSTOMMENUCOMMAND_INSPECTELEMENT) then
  begin
    mousePoint.x := params.XCoord;
    mousePoint.y := params.YCoord;
    Splitter.Visible := True;
    DevTools.Visible := True;
    actDevTool.Checked := True;
    DevTools.CloseDevTools(crm.Browser);
    application.ProcessMessages;
    DevTools.ShowDevTools(crm.Browser,@mousePoint);
    Result := True;
  end;
end;

procedure TMainForm.crmDownloadUpdated(Sender: TObject;
  const browser: ICefBrowser; const downloadItem: ICefDownloadItem;
  const callback: ICefDownloadItemCallback);
begin
  if downloadItem.IsInProgress then
    StatusBar.SimpleText := IntToStr(downloadItem.PercentComplete) + '%' else
    StatusBar.SimpleText := '';
end;

procedure TMainForm.crmLoadEnd(Sender: TObject; const browser: ICefBrowser;
  const frame: ICefFrame; httpStatusCode: Integer);
begin
  if IsMain(browser, frame) then
  begin
    FLoading := False;
    Timer1.Enabled := True;
  end;
end;

procedure TMainForm.crmLoadStart(Sender: TObject; const browser: ICefBrowser;
  const frame: ICefFrame);
begin
  if IsMain(browser, frame) then
    FLoading := True;
end;

procedure TMainForm.crmProcessMessageReceived(Sender: TObject;
  const browser: ICefBrowser; sourceProcess: TCefProcessId;
  const message: ICefProcessMessage; out Result: Boolean);
begin
  if (message.Name = 'mouseover') then
  begin
    StatusBar.SimpleText := message.ArgumentList.GetString(0);
    Result := True;
  end else
    Result := False;
end;

procedure TMainForm.crmStatusMessage(Sender: TObject;
  const browser: ICefBrowser; const value: ustring);
begin
  StatusBar.SimpleText := value
end;

procedure TMainForm.crmTitleChange(Sender: TObject; const browser: ICefBrowser;
  const title: ustring);
begin
  if IsMain(browser) then
    Caption := title;
end;

procedure TMainForm.DisplayMsgEnqueue(AMsg: string);
var
  LOmniValue: TOmniValue;
  LHtmlRec: THtmlRec;
begin
  LHtmlRec.FHtmlMsg := AMsg;
  LOmniValue := TOmniValue.FromRecord<THtmlRec>(LHtmlRec);
  FDisplayMsgQueue.Enqueue(TOmniMessage.Create(1, LOmniValue));
end;

procedure TMainForm.DisplayMsgTest1Click(Sender: TObject);
begin
  UrlMsgEnqueue('aaa');
end;

procedure TMainForm.edAddressKeyPress(Sender: TObject; var Key: Char);
begin
  if Key = #13 then
  begin
    if crm.Browser <> nil then
    begin
      crm.Browser.MainFrame.LoadUrl(edAddress.Text);
      Abort;
    end;
  end;
end;

procedure TMainForm.Exit1Click(Sender: TObject);
begin
  Close;
end;

function TMainForm.ExtractDockSurveyFromHtml(AHtml: IHtmlElement; var ADoc: variant): variant;
var
  LStr, LStr2: string;
  LHtml, LHtml2: IHtmlElement;
  LHtmlList, LHtmlList2: IHtmlElementList;
  LIsExit: Boolean;
begin
  if AHtml <> nil then
  begin
    LIsExit := False;
    TDocVariant.New(Result);
    LHtmlList := AHtml.SimpleCSSSelector('table');

    for LHtml in LHtmlList do
    begin
      LStr := LHtml.Attributes['class'];
      if LStr = 'indent_wrap' then
      begin
        LHtmlList2 := LHtml.SimpleCSSSelector('span');
        for LHtml2 in LHtmlList2 do
        begin
          LStr := LHtml2.Text;

          if Pos('Special Survey Due', LStr) <> 0 then
          begin
            LStr2 := strToken(LStr, ',');
            System.Delete(LStr2,1,19);
            ADoc.SpecialSurveyDueDate := LStr2;
//              Memo1.Lines.Add('Special Survey Due: ' + LStr2);
          end
          else
            ADoc.SpecialSurveyDueDate := '';

          if Pos('Docking Survey Due', LStr) <> 0 then
          begin
            LStr2 := strToken(LStr, ',');
            LStr2 := strToken(LStr, ',');
            LStr2 := Copy(LStr2, Length(LStr2)-9,10);
            ADoc.DockingSurveyDueDate := LStr2;
//              Memo1.Lines.Add('Docking Survey Due: ' + LStr2);
            LIsExit := True;
          end
          else
            ADoc.DockingSurveyDueDate := '';

          if LIsExit then
            exit;
        end;
      end;
    end;
  end;
end;

procedure TMainForm.ExtractOwnershipFromTxt(ATxt: string; var ADoc: variant);
var
  LStr: string;
  i: integer;
begin
  i := Pos('Group Owner', Atxt);
  System.Delete(ATxt, 1, i-1);
  LStr := strToken(ATxt, #9);
  LStr := strToken(ATxt, #9);
//    LStr := Copy(ATxt, 1, Pos('Address Location', ATxt));
  ADoc.OwnerName := LStr;
//    Memo1.Lines.Add('Group Owner: ' + LStr);
  LStr := strToken(ATxt, #9);
  LStr := strToken(ATxt, #9);
  ADoc.OwnerCountry := LStr;
//    Memo1.Lines.Add('Group Owner Address Location: ' + LStr);

  i := Pos('Operator', Atxt);
  System.Delete(ATxt, 1, i-1);
  LStr := strToken(ATxt, #9);
  LStr := strToken(ATxt, #9);
  ADoc.OperatorName := LStr;
//    Memo1.Lines.Add('Operator: ' + LStr);
  LStr := strToken(ATxt, #9);
  LStr := strToken(ATxt, #9);
  ADoc.OperatorCountry := LStr;
//    Memo1.Lines.Add('Operator Address Location: ' + LStr);

  i := Pos('Technical Manager', Atxt);
  System.Delete(ATxt, 1, i-1);
  LStr := strToken(ATxt, #9);
  LStr := strToken(ATxt, #9);
  ADoc.TechManagerName := LStr;
//    Memo1.Lines.Add('Technical Manager: ' + LStr);
  LStr := strToken(ATxt, #9);
  LStr := strToken(ATxt, #9);
  ADoc.TechManagerCountry := LStr;
//    Memo1.Lines.Add('Technical Manager Address Location: ' + LStr);
end;

function TMainForm.ExtractShipNameNIMONoFromHtml(AHtml: IHtmlElement; var ADoc: variant): variant;
var
  LStr, LStr2: string;
  LHtmlList, LHtmlList2: IHtmlElementList;
  LHtml, LHtml2: IHtmlElement;
  LIsShipName, LIsIMONo, LIsShipType, LIsStatus: boolean;
begin
  if AHtml <> nil then
  begin
    TDocVariant.New(Result);
    LHtmlList := AHtml.SimpleCSSSelector('table');

    for LHtml in LHtmlList do
    begin
      LStr := LHtml.Attributes['class'];
      if LStr = 'indent' then
      begin
        LHtmlList2 := LHtml.SimpleCSSSelector('td');
        for LHtml2 in LHtmlList2 do
        begin
          LStr := LHtml2.Attributes['class'];
          if LStr = 'label' then
          begin
            LIsShipName := LHtml2.Text = 'Ship Name';

            if not LIsShipName then
            begin
              LIsShipType := LHtml2.Text = 'Shiptype';

              if not LIsShipType then
              begin
                LIsIMONo := LHtml2.Text = 'IMO/LR No.';

                if not LIsIMONo then
                begin
                  LIsStatus := LHtml2.Text = 'Status';
                end;
              end;
            end;
          end;

          if LStr = 'data' then
          begin
            if LIsShipName then
            begin
              ADoc.ShipName := LHtml2.Text;
//                Memo1.Lines.Add('Ship Name: ' + LHtml2.Text);
              LIsShipName := False;
            end
            else
              ADoc.ShipName := '';

            if LIsShipType then
            begin
              ADoc.ShipType := LHtml2.Text;
//                Memo1.Lines.Add('Ship Type: ' + LHtml2.Text);
              LIsShipType := False;
            end
            else
              ADoc.ShipType := '';

            if LIsIMONo then
            begin
              ADoc.IMONo := LHtml2.Text;
//                Memo1.Lines.Add('IMO No: ' + LHtml2.Text);
              LIsIMONo := False;
            end
            else
              ADoc.IMONo := '';

            if LIsStatus then
            begin
              ADoc.VesselStatus := LHtml2.Text;
//                Memo1.Lines.Add('Status: ' + LHtml2.Text);
              LIsStatus := False;
            end
            else
              ADoc.VesselStatus := '';
          end;
        end;
      end;
    end;
  end;
end;

procedure TMainForm.ExtractVesselInfoFromHtml(AHtml: string);
var
  LHtml: IHtmlElement;
  LHtmlList: IHtmlElementList;
begin
  LHtml := ParserHtml(AHtml);

  if LHtml <> nil then
  begin
    LHtmlList := LHtml.SimpleCSSSelector('a');

    for LHtml in LHtmlList do
      Memo1.Lines.Add(LHtml.Attributes['href']);
  end;
end;

procedure TMainForm.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
begin
  // avoid AV when closing application
  if CefSingleProcess then
    crm.Load('about:blank');
  CanClose := True;
end;

procedure TMainForm.FormCreate(Sender: TObject);
begin
  FLoading := False;
  g_OnlyViewSrc := False;
  FDisplayMsgQueue := TOmniMessageQueue.Create(1000);
  FDisplayStopEvent := TEvent.Create;
  FHtmlMsgQueue := TOmniMessageQueue.Create(1000);
  FStopEvent := TEvent.Create;
  FUrlMsgQueue := TOmniMessageQueue.Create(1000);
  FUrlStopEvent := TEvent.Create;
  UrlMsgDequeEvent := Event.Create('CONSUME_EVENT_NAME');
  UrlMsgStartEvent := Event.Create('UrlMsgStartEvent_EVENT_NAME');

//  produceEvent := Event.Create('PRODUCE_EVENT_NAME');
  InitVesselInfo4SeaWebClient(Application.ExeName);
  AsynProcessHtml;
  AsynProcessUrl;
  AsynDisplayMsg;
end;

procedure TMainForm.FormDestroy(Sender: TObject);
begin
  FDisplayStopEvent.SetEvent;
  FStopEvent.SetEvent;
  FUrlStopEvent.SetEvent;
  FHtmlMsgQueue.Free;
  FUrlMsgQueue.Free;
  FDisplayMsgQueue.Free;
  FreeAndNil(FDisplayStopEvent);
  FreeAndNil(FStopEvent);
  FreeAndNil(FUrlStopEvent);
end;

procedure TMainForm.GetTextNHtmlFromChromium;
begin
  crm.Browser.MainFrame.GetTextProc(CallbackGetText);
//  crm.Browser.MainFrame.GetSourceProc(CallbackGetSource);
end;

procedure TMainForm.GetVesselInfoFromHtml(AMsgID: integer;
  ATextSource: string);
var
  LHtmlElement: IHtmlElement;
  LDoc, LDoc2: Variant;
  LStr: string;
begin
  if AMsgID = 2 then
  begin
    TDocVariant.New(LDoc);
//    TDocVariant.New(LDoc2);
//    LHtmlElement := ParserHtml(AHtmlSource);
//    ExtractDockSurveyFromHtml(LHtmlElement, LDoc);
    GetVesselInfoFromText(ATextSource, LDoc);
    LStr := LDoc;
    if LStr <> 'null' then
    begin
//    Memo1.Lines.Clear;
//      Memo1.Lines.Add(LDoc);
//      ExtractShipNameNIMONoFromHtml(LHtmlElement, LDoc);
//      Memo1.Lines.Add(LDoc);
//      ExtractOwnershipFromTxt(ATextSource, LDoc);
      Memo1.Lines.Add(LDoc);
      AddOrUpdateVesselInfo4SeaWebFromVariant(LDoc);
    end;
  end;
end;

procedure TMainForm.GetVesselInfofromhtml1Click(Sender: TObject);
begin
  GetVesselInfoFromHtml(2, '');
end;

procedure TMainForm.GetVesselInfofromhtmlwithMQ1Click(Sender: TObject);
var
  LOmniValue: TOmniValue;
  LHtmlRec: THtmlRec;
begin
  LHtmlRec.FHtmlMsg := '';
  LOmniValue := TOmniValue.FromRecord<THtmlRec>(LHtmlRec);
  FHtmlMsgQueue.Enqueue(TOmniMessage.Create(1, LOmniValue));
end;

procedure TMainForm.GetVesselInfoFromIMONo;
var
  LIMONoEditF: TIMONoEditF;
  LIMONo: string;
begin
  with TIMONoEditF.Create(Self) do
  begin
    try
      if ShowModal = mrOK then
      begin
        LIMONo := Edit1.Text;
        if LIMONo <> '' then
          AsynGetVesselInfoFromIMONo(LIMONo);
      end;
    finally
      Free;
    end;
  end;
end;

procedure TMainForm.GetVesselInfofromIMONo1Click(Sender: TObject);
begin
  AsynGetVesselInfoFromIMONo;
end;

procedure TMainForm.GetVesselInfofromIMONo2Click(Sender: TObject);
begin
  GetVesselInfoFromIMONo;
end;

procedure TMainForm.GetVesselInfoFromText(AText: string; var ADoc: variant);
var
  LStr: string;
  i: integer;
begin
  i := Pos('Ship Name', AText);
  if i <> 0 then
  begin
    System.Delete(AText, 1, i-1);
    LStr := strToken(AText, #9);
    LStr := strToken(AText, #9);
    ADoc.ShipName := LStr;
  end
  else
    ADoc.ShipName := '';

  i := Pos('Shiptype', AText);
  if i <> 0 then
  begin
    System.Delete(AText, 1, i-1);
    LStr := strToken(AText, #9);
    LStr := strToken(AText, #10);
    ADoc.ShiptypeDesc := LStr;
  end
  else
    ADoc.ShiptypeDesc := '';

  i := Pos('IMO/LR No.', AText);
  if i <> 0 then
  begin
    System.Delete(AText, 1, i-1);
    LStr := strToken(AText, #9);
    LStr := strToken(AText, #9);
    ADoc.IMONo := LStr;
  end
  else
    ADoc.IMONo := '';

  i := Pos('Status', AText);
  if i <> 0 then
  begin
    System.Delete(AText, 1, i-1);
    LStr := strToken(AText, #9);
    LStr := strToken(AText, #10);
    ADoc.VesselStatus := LStr;
  end
  else
    ADoc.VesselStatus := '';

  i := Pos('Group Owner', AText);
  if i <> 0 then
  begin
    System.Delete(AText, 1, i-1);
    LStr := strToken(AText, #9);
    LStr := strToken(AText, #9);
    ADoc.OwnerName := LStr;

    LStr := strToken(AText, #9);
    LStr := strToken(AText, #9);
    ADoc.OwnerCountry := LStr;
  end
  else
  begin
    ADoc.OwnerName := '';
    ADoc.OwnerCountry := '';
  end;


  i := Pos('Operator', AText);
  if i <> 0 then
  begin
    System.Delete(AText, 1, i-1);
    LStr := strToken(AText, #9);
    LStr := strToken(AText, #9);
    ADoc.OperatorName := LStr;

    LStr := strToken(AText, #9);
    LStr := strToken(AText, #9);
    ADoc.OperatorCountry := LStr;
  end
  else
  begin
    ADoc.OperatorName := '';
    ADoc.OperatorCountry := '';
  end;

  i := Pos('Technical Manager', AText);
  if i <> 0 then
  begin
    System.Delete(AText, 1, i-1);
    LStr := strToken(AText, #9);
    LStr := strToken(AText, #9);
    ADoc.TechManagerName := LStr;

    LStr := strToken(AText, #9);
    LStr := strToken(AText, #9);
    ADoc.TechManagerCountry := LStr;
  end
  else
  begin
    ADoc.TechManagerName := '';
    ADoc.TechManagerCountry := '';
  end;


  i := Pos('Special Survey Due', AText);
  if i <> 0 then
  begin
    System.Delete(AText, 1, i-1);
    LStr := strToken(AText, ' ');
    LStr := strToken(AText, ' ');
    LStr := strToken(AText, ' ');
    LStr := strToken(AText, ',');
    ADoc.SpecialSurveyDueDate := LStr;
  end
  else
    ADoc.SpecialSurveyDueDate := '';

  i := Pos('Docking Survey Due', AText);
  if i <> 0 then
  begin
    System.Delete(AText, 1, i-1);
    LStr := strToken(AText, ' ');
    LStr := strToken(AText, ' ');
    LStr := strToken(AText, ' ');
    LStr := strToken(AText, ',');
    ADoc.DockingSurveyDueDate := LStr;
  end
  else
    ADoc.DockingSurveyDueDate := '';

  i := Pos('Ship Builder', AText);
  if i <> 0 then
  begin
    System.Delete(AText, 1, i-1);
    LStr := strToken(AText, #10);
    LStr := strToken(AText, ' ');
    i := Pos('Yard', AText);
    LStr := Trim(Copy(AText, 1, i-1));
    ADoc.ShipBuilderName := LStr;
  end
  else
    ADoc.ShipBuilderName := '';

  i := Pos('hull No.:', AText);
  if i <> 0 then
  begin
    LStr := strToken(AText, ':');
    LStr := strToken(AText, #10);
    ADoc.HullNo := Trim(LStr);
  end
  else
    ADoc.HullNo := '';
end;

procedure TMainForm.GotoSeaweb1Click(Sender: TObject);
begin
  if crm.Browser <> nil then
    crm.Browser.MainFrame.LoadUrl('http://maritime.ihs.com');
end;

{ TCustomRenderProcessHandler }


function getpath(const n: ICefDomNode): string;
begin
  Result := '<' + n.Name + '>';
  if (n.Parent <> nil) then
    Result := getpath(n.Parent) + Result;
end;

procedure TCustomRenderProcessHandler.OnWebKitInitialized;
begin
{$IFDEF DELPHI14_UP}
  TCefRTTIExtension.Register('app', TTestExtension);
{$ENDIF}
end;

{ TTestExtension }

class procedure TTestExtension.mouseover(const data: string);
var
  msg: ICefProcessMessage;
begin
  msg := TCefProcessMessageRef.New('mouseover');
  msg.ArgumentList.SetString(0, data);
  TCefv8ContextRef.Current.Browser.SendProcessMessage(PID_BROWSER, msg);
end;

class function TTestExtension.hello: string;
begin
  Result := 'Hello from Delphi';
end;

initialization
  CefRemoteDebuggingPort := 9000;
  CefRenderProcessHandler := TCustomRenderProcessHandler.Create;
  CefBrowserProcessHandler := TCefBrowserProcessHandlerOwn.Create;
end.

