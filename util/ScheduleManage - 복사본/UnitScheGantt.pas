unit UnitScheGantt;

interface

{$I cef.inc}

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ceflib, cefvcl, Buttons, ActnList, Menus, ComCtrls,
  ExtCtrls, XPMan, Registry, ShellApi, SyncObjs, System.Actions, Vcl.ImgList,
  AdvNavBar, NxCollection, SynCommons, mORMot, mORMotSQLite3, SynSQLite3Static,
  ScheduleSampleDataModel, AeroButtons, AdvGroupBox, AdvOfficeButtons,
  JvExControls, JvLabel, CurvyControls, UnitTreeGridGanttRecord, HoliDayCollect,
  AdvPageControl, AdvOfficePager, UnitWorker4OmniMsgQ, OtlParallel, OtlTaskControl,
  NxPropertyItems, NxPropertyItemClasses, NxScrollControl, NxInspector,
  pjhComboBox;

type
  TMyClass = class(TObject)
  private
    FValue: string;
  protected
    procedure SetValue(Value: string);
    function GetValue: string;
  public
    property Value: string read GetValue write SetValue;
  end;

  TMyHandler = class(TCefv8HandlerOwn)
  protected
    function Execute(const name: ustring; const obj: ICefv8Value;
      const arguments: TCefv8ValueArray; var retval: ICefv8Value;
      var exception: ustring): Boolean; override;
  end;

  TGanttForm = class(TForm)
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
    actChromeDevTool: TAction;
    DebuginChrome1: TMenuItem;
    actPrint: TAction;
    SpeedButton6: TSpeedButton;
    Panel2: TPanel;
    ImageList32x32: TImageList;
    imagelist24x24: TImageList;
    ImageList16x16: TImageList;
    AdvNavBar1: TAdvNavBar;
    Panel3: TPanel;
    crm: TChromium;
    NxSplitter1: TNxSplitter;
    NxSplitter2: TNxSplitter;
    NxSplitter3: TNxSplitter;
    Button1: TButton;
    Button5: TButton;
    Button6: TButton;
    Button3: TButton;
    Button4: TButton;
    Button2: TButton;
    Memo1: TMemo;
    NxExpandPanel1: TNxExpandPanel;
    AdvOfficePager1: TAdvOfficePager;
    AdvOfficePager11: TAdvOfficePage;
    AdvOfficePager12: TAdvOfficePage;
    CurvyPanel1: TCurvyPanel;
    JvLabel4: TJvLabel;
    JvLabel6: TJvLabel;
    JvLabel1: TJvLabel;
    JvLabel3: TJvLabel;
    JvLabel5: TJvLabel;
    CurvyPanel2: TCurvyPanel;
    Label4: TLabel;
    rg_period: TAdvOfficeRadioGroup;
    dt_begin: TDateTimePicker;
    dt_end: TDateTimePicker;
    cb_ShipNo: TComboBox;
    cb_ProjNo: TComboBox;
    AeroButton3: TAeroButton;
    cb_Dept: TComboBox;
    cb_Factory: TComboBox;
    cb_engType: TComboBox;
    Panel5: TPanel;
    JvLabel2: TJvLabel;
    cb_SearchMode: TComboBox;
    RG_SchType: TAdvOfficeRadioGroup;
    JvLabel7: TJvLabel;
    AdvNavBarPanel1: TAdvNavBarPanel;
    AeroButton2: TAeroButton;
    CB_ExProcess: TCheckBox;
    AeroButton1: TAeroButton;
    ProjectInfoInspector: TNextInspector;
    EngineItem: TNxTextItem;
    ScheduleItem: TNxTextItem;
    FactoryItem: TNxTextItem;
    ModuleItem: TNxTextItem;
    cb_projnoinc: TComboBoxInc;
    ProjItem: TNxTextItem;
    GroupBox1: TGroupBox;
    cb_plan: TCheckBox;
    cb_modify: TCheckBox;
    cb_siljeok: TCheckBox;

    procedure edAddressKeyPress(Sender: TObject; var Key: Char);
    procedure actPrevExecute(Sender: TObject);
    procedure actNextExecute(Sender: TObject);
    procedure actHomeExecute(Sender: TObject);
    procedure actReloadExecute(Sender: TObject);
    procedure actReloadUpdate(Sender: TObject);
    procedure actGoToExecute(Sender: TObject);
    procedure FormCreate(Sender: TObject);
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
    procedure actChromeDevToolExecute(Sender: TObject);
    procedure crmBeforeResourceLoad(Sender: TObject; const browser: ICefBrowser;
      const frame: ICefFrame; const request: ICefRequest; out Result: Boolean);
    procedure crmBeforePopup(Sender: TObject; const browser: ICefBrowser;
      const frame: ICefFrame; const targetUrl, targetFrameName: ustring;
      var popupFeatures: TCefPopupFeatures; var windowInfo: TCefWindowInfo;
      var client: ICefClient; var settings: TCefBrowserSettings;
      var noJavascriptAccess: Boolean; out Result: Boolean);
    procedure actPrintExecute(Sender: TObject);
    procedure crmAfterCreated(Sender: TObject; const browser: ICefBrowser);
    procedure executeChromeJavaScript(AScript: string);
    procedure SpeedButton6Click(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure crmConsoleMessage(Sender: TObject; const browser: ICefBrowser;
      const message, source: ustring; line: Integer; out Result: Boolean);
    procedure Button2Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure Button4Click(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure Button5Click(Sender: TObject);
    procedure Button6Click(Sender: TObject);
    procedure rg_periodClick(Sender: TObject);
    procedure cb_ProjNoDropDown(Sender: TObject);
    procedure cb_ShipNoDropDown(Sender: TObject);
    procedure AeroButton2Click(Sender: TObject);
    procedure AeroButton3Click(Sender: TObject);
    procedure AeroButton1Click(Sender: TObject);
    procedure cb_projnoincDropDown(Sender: TObject);
    procedure cb_projnoincSelect(Sender: TObject);
    procedure cb_planClick(Sender: TObject);
    procedure cb_modifyClick(Sender: TObject);
    procedure cb_siljeokClick(Sender: TObject);
  private
    FLoading: Boolean;
    FDevToolLoaded: Boolean;

    FScheduleDatabase: TSQLRest;
    FScheduleModel: TSQLModel;
    FBaseInfoDatabase: TSQLRest;
    FBaseInfoModel: TSQLModel;
    FHolidayDatabase: TSQLRest;
    FHolidayModel: TSQLModel;

    //화면에서 부서명을 선택하면 DB에서는 부서코드로 검색하기 위함
    FDeptCodeList: TStringList;

    FGanttConfig1: TTGGanttConfig;
    FGanttConfigString : string;
    FpjhOmniMsgQClass: TpjhOmniMsgQClass;

    function IsMain(const b: ICefBrowser; const f: ICefFrame = nil): Boolean;
    procedure InitDataBase;
    procedure InitGantt;
    procedure InitMQ;
    procedure InsertSchduleData(AWorkSheet: variant);
    procedure InsertSchduleDataFromCSV(AFileName: string);
    procedure InsertSchduleDataFromExcel(AFileName: string);
    procedure InsertBaseInfoData(AWorkSheet: variant);
    procedure InsertBaseInfoFromExcel(AFileName: string);
    procedure InsertHolidayData(AWorkSheet: variant);
    procedure InsertHolidayFromExcel(AFileName: string);

    function GetTGConfig1(AExecludeFrom, AExcludeTo: TDateTime): string;
    function GetVar2TGConfig1(ATGGanttConfig: TTGGanttConfig): string;
    function GetVar2TGGanttChanges1(ATGGanttChanges: TTGGanttChanges): string;
    function GetGridChangesAll: string;
    function GetStartDateFromRecord(AId: string): String;

    procedure SetBigoFlag(AChange: Variant);
    procedure WorkerResult(var msg: TMessage); message MSG_RESULT;
    procedure ProcessScheduleMsg;
    procedure GetScheduleChanged;
    procedure OnGetScheduleChangedCompleted(const task: IOmniTaskControl);
    procedure AdaptScheduleChanged(AVar: variant);

    procedure DisplayMsq(AMsg: string);
    procedure SetProjInfo2Inspector(AProjNo: string);
    function AddItemsToInspector(AInspector: TNextInspector; ANxItemClass: TNxItemClass;
                ABaseIndex: integer; AName, ACaption, AValue: string):TNxPropertyItem;
    procedure DisplayDate(AVisible: Boolean; AColIndex: integer);
  end;

  TCustomRenderProcessHandler = class(TCefRenderProcessHandlerOwn)
  protected
    procedure OnWebKitInitialized; override;
    function OnProcessMessageReceived(const browser: ICefBrowser; sourceProcess: TCefProcessId;
      const message: ICefProcessMessage): Boolean; override;
  end;

  TTestExtension = class
    class function hello: string;
  end;

var
  GanttForm: TGanttForm;
  test: TMyClass;

implementation

uses ExcelUtil, DateUtils, UnitScheManageDM, OtlCommon, OtlComm, UnitStringUtil,
  ProjectBaseClass;

{$R *.dfm}

function GetTokenWithComma( var str1: string; AComma: string = ',' ): String;
var
  i: integer;
begin
  i := Pos(AComma,Str1);
  if i > 0 then
  begin
    Result := System.Copy(Str1, 1, i-1);
    System.Delete(Str1,1,i);
  end
  else
  begin
    Result := Str1;
    Str1 := '';
  end;
end;

procedure MouseDownCallback(const Event: ICefDomEvent);
begin
  ShowMessage('Mouse down on '+Event.Target.Name);
end;

procedure AttachMouseDownListenerProc(const Doc: ICefDomDocument);
begin
  Doc.Body.AddEventListenerProc('mousedown', True, MouseDownCallback);
end;

procedure RegisterExtension;
var
  Code:string;
begin
  Code :=
   'var cef;'+
   'if (!cef)'+
   '  cef = {};'+
   'if (!cef.test)'+
   '  cef.test = {};'+
   '(function() {'+
   '  cef.test.__defineGetter__(''test_param'', function() {'+
   '    native function GetTestParam();'+
   '    return GetTestParam();'+
   '  });'+
   '  cef.test.__defineSetter__(''test_param'', function(b) {'+
   '    native function SetTestParam();'+
   '    if(b) SetTestParam(b);'+
   '  });'+
   '  cef.test.test_object = function() {'+
   '    native function GetTestObject();'+
   '    return GetTestObject();'+
   '  };'+
   '})();';

  CefRegisterExtension('example/v8', Code, TMyHandler.Create as ICefv8Handler);
end;

procedure TGanttForm.actChromeDevToolExecute(Sender: TObject);
var
  reg: TRegistry;
  path, url: string;
begin
  reg := TRegistry.Create;
  try
    reg.RootKey := HKEY_LOCAL_MACHINE;
    if reg.OpenKeyReadOnly('\SOFTWARE\Microsoft\Windows\CurrentVersion\App Paths\chrome.exe') then
      path := ExtractFilePath(reg.ReadString('')) else
      Exit;
  finally
    reg.Free;
  end;

  if DirectoryExists(path) then
  begin
    url := crm.Browser.Host.GetDevToolsUrl(True);
    ShellExecute(0, 'open', 'chrome.exe', PChar(url), PChar(Path), 0);
  end;
end;

procedure TGanttForm.actDevToolExecute(Sender: TObject);
begin
  actDevTool.Checked := not actDevTool.Checked;
//  debug.Visible := actDevTool.Checked;
//  Splitter1.Visible := actDevTool.Checked;
  if actDevTool.Checked then
  begin
    if not FDevToolLoaded then
    begin
//      debug.Load(crm.Browser.Host.GetDevToolsUrl(True));
      FDevToolLoaded := True;
    end;
  end;
end;

procedure TGanttForm.actDocExecute(Sender: TObject);
begin
  crm.Load('http://magpcss.org/ceforum/apidocs3');
end;

procedure TGanttForm.actDomExecute(Sender: TObject);
begin
  crm.browser.SendProcessMessage(PID_RENDERER,
    TCefProcessMessageRef.New('visitdom'));
end;

procedure TGanttForm.actExecuteJSExecute(Sender: TObject);
begin
  if crm.Browser <> nil then
    crm.Browser.MainFrame.ExecuteJavaScript(
      'alert(''JavaScript execute works!'');', 'about:blank', 0);
end;

procedure TGanttForm.actFileSchemeExecute(Sender: TObject);
begin
  if crm.Browser <> nil then
    crm.Browser.MainFrame.LoadUrl('local://c/');
end;

procedure CallbackGetSource(const src: ustring);
var
  source: ustring;
begin
  source := src;
  source := StringReplace(source, '<', '&lt;', [rfReplaceAll]);
  source := StringReplace(source, '>', '&gt;', [rfReplaceAll]);
  source := '<html><body>Source:<pre>' + source + '</pre></body></html>';
  GanttForm.crm.Browser.MainFrame.LoadString(source, '');
end;

procedure TGanttForm.actGetSourceExecute(Sender: TObject);
begin
  crm.Browser.MainFrame.GetSourceProc(CallbackGetSource);
end;

procedure CallbackGetText(const txt: ustring);
var
  source: ustring;
begin
  source := txt;
  source := StringReplace(source, '<', '&lt;', [rfReplaceAll]);
  source := StringReplace(source, '>', '&gt;', [rfReplaceAll]);
  source := '<html><body>Text:<pre>' + source + '</pre></body></html>';
  GanttForm.crm.Browser.MainFrame.LoadString(source, '');
end;

procedure TGanttForm.actGetTextExecute(Sender: TObject);
begin
  crm.Browser.MainFrame.GetTextProc(CallbackGetText);
end;

procedure TGanttForm.actGoToExecute(Sender: TObject);
begin
  if crm.Browser <> nil then
    crm.Browser.MainFrame.LoadUrl(edAddress.Text);
end;

procedure TGanttForm.actGroupExecute(Sender: TObject);
begin
  crm.Load('https://groups.google.com/forum/?fromgroups#!forum/delphichromiumembedded');
end;

procedure TGanttForm.actHomeExecute(Sender: TObject);
begin
  if crm.Browser <> nil then
    crm.Browser.MainFrame.LoadUrl(crm.DefaultUrl);
end;

procedure TGanttForm.actHomeUpdate(Sender: TObject);
begin
  TAction(Sender).Enabled := crm.Browser <> nil;
end;

procedure TGanttForm.actNextExecute(Sender: TObject);
begin
  if crm.Browser <> nil then
    crm.Browser.GoForward;
end;

procedure TGanttForm.actNextUpdate(Sender: TObject);
begin
  if crm.Browser <> nil then
    actNext.Enabled := crm.Browser.CanGoForward else
    actNext.Enabled := False;
end;

procedure TGanttForm.actPrevExecute(Sender: TObject);
begin
  if crm.Browser <> nil then
    crm.Browser.GoBack;
end;

procedure TGanttForm.actPrevUpdate(Sender: TObject);
begin
  if crm.Browser <> nil then
    actPrev.Enabled := crm.Browser.CanGoBack else
    actPrev.Enabled := False;
end;

procedure TGanttForm.actPrintExecute(Sender: TObject);
begin
  if crm.Browser <> nil then
    crm.Browser.Host.Print;
end;

procedure TGanttForm.actReloadExecute(Sender: TObject);
begin
  if crm.Browser <> nil then
    if FLoading then
      crm.Browser.StopLoad else
      crm.Browser.Reload;
end;

procedure TGanttForm.actReloadUpdate(Sender: TObject);
begin
  if FLoading then
    TAction(sender).Caption := 'X' else
    TAction(sender).Caption := 'R';
  TAction(Sender).Enabled := crm.Browser <> nil;
end;

procedure TGanttForm.InitDataBase;
begin
  FScheduleModel := CreateScheduleModel;
  FScheduleDatabase := TSQLRestServerDB.Create(FScheduleModel,
    ExtractFilePath(ExeVersion.ProgramFileName) + PROJ_SCH_DB_NAME);
//    ChangeFileExt(ExeVersion.ProgramFileName,'.db3'));
  TSQLRestServerDB(FScheduleDatabase).CreateMissingTables;

  FBaseInfoModel := CreateBaseInfoModel;
  FBaseInfoDatabase := TSQLRestServerDB.Create(FBaseInfoModel,
    ExtractFilePath(ExeVersion.ProgramFileName) + PROJ_BASE_INFO_DB_NAME);
  TSQLRestServerDB(FBaseInfoDatabase).CreateMissingTables;

  DM1.GetBaseInfoFrommORMot(FBaseInfoDatabase, DM1.FDynHimsenJobRelation);

  FHolidayModel := CreateHolidayModel;
  FHolidayDatabase := TSQLRestServerDB.Create(FHolidayModel,
    ExtractFilePath(ExeVersion.ProgramFileName) + HOLIDAY_INFO_DB_NAME);
  TSQLRestServerDB(FHolidayDatabase).CreateMissingTables;

  DM1.GetHolidayFrommORMot(FHolidayDatabase);
end;

procedure TGanttForm.InitGantt;
var
  V: variant;
  LStr: string;
begin
  V := _JSon(GetTGConfig1(now, now),[dvoSerializeAsExtendedJson]);
  FGanttConfigString := V;
  FGanttConfigString := StringReplace(FGanttConfigString, 'F_Type', 'Type', [rfReplaceAll]);
  FGanttConfigString := StringReplace(FGanttConfigString, '@@@', '', [rfReplaceAll]);
//  FGanttConfigString := StringReplace(FGanttConfigString, 'GanttZoom:" "', 'GanttZoom:""', [rfReplaceAll]);

//  LStr := LStr + 'Grids.OnAfterValueChanged = function(grid,row,col,val){' + #13#10;
//  LStr := LStr + 'console.log(row + "-" + col + "-" + val)return ;};' + #13#10;
  LStr := LStr + 'var GridData={###};' + #13#10;
  LStr := LStr + 'var grid = TreeGrid(''<bdo Sync="0" Debug="" Upload_Type="Body" Upload_Format="JSON" Data_Script="GridData"></bdo>'',"Gantt");'+ #13#10;
//  LStr := LStr + 'Grids.OnAfterValueChanged = function(grid,row,col,val){' + #13#10;
//  LStr := LStr + 'console.log(row + "-" + col + "-" + val);}' + #13#10;
  LStr := LStr + 'Grids.OnGanttChanged = function(G,row,col,item,newv,new2,old,old2,action){' + #13#10;
  LStr := LStr + '  var gstart = G.GetValue(row, "START");' + #13#10;
//  LStr := LStr + '  if (!gstart){ ' + #13#10;
//  LStr := LStr + '    G.SetValue(row,"START",old);' + #13#10;
//  LStr := LStr + '  }' + #13#10;
//  LStr := LStr + '  var gend = G.GetValue(row, "ENDDATE");' + #13#10;
//  LStr := LStr + '  if (!gend){ ' + #13#10;
//  LStr := LStr + '    G.SetValue(row,"ENDDATE",old2);' + #13#10;
//  LStr := LStr + '  }' + #13#10;
  LStr := LStr + '  var gbigo = G.GetValue(row, "BIGO");' + #13#10;
  LStr := LStr + '  if (gbigo){ ' + #13#10;
  LStr := LStr + '    G.SetValue(row,"FLAGS",gstart);' + #13#10;
  LStr := LStr + '  }' + #13#10;
  LStr := LStr + '  else {' + #13#10;
  LStr := LStr + '    G.SetValue(row,"FLAGS","");' + #13#10;
  LStr := LStr + '  }' + #13#10;
  LStr := LStr + '  console.log(grid.GetChanges(row));}' + #13#10;
//  LStr := LStr + '  console.log(' + CHANGED_ROW_TAG+ '"=" + grid.GetChanges(row));}' + #13#10;
//  LStr := LStr + 'Grids.OnGanttMainChanged = function(grid,row,col,plan,newv,old,action){' + #13#10;
//  LStr := LStr + 'console.log(row + "-" + col + "-" + newv);}' + #13#10;
//  LStr := LStr + 'var gstart = DateToString(G.GetValue(row, "START"));' + #13#10;
  LStr := StringReplace(LStr, '{###}', FGanttConfigString, [rfReplaceAll]);

  executeChromeJavaScript(LStr);
end;

procedure TGanttForm.InitMQ;
begin
  FpjhOmniMsgQClass := TpjhOmniMsgQClass.Create(1000, Handle);
end;

procedure TGanttForm.InsertBaseInfoData(AWorkSheet: variant);
var
  LRec: TSQLHimsenJobRelation;
  i, LRow, LCol: integer;
  LStr: string;
begin
  LRow := AWorkSheet.Usedrange.EntireRow.Count;

  LRec := TSQLHimsenJobRelation.Create;
  try
    with LRec do
    begin
      for i := 4 to LRow do
      begin
        LCol := 1;
        EngineType := StringToUTF8(AWorkSheet.Cells[i,LCol].value);
        Inc(LCol);
        PPartNo := StringToUTF8(AWorkSheet.Cells[i,LCol].value);
        Inc(LCol);
        PJobCode := StringToUTF8(AWorkSheet.Cells[i,LCol].value);
        Inc(LCol);
        APartNo := StringToUTF8(AWorkSheet.Cells[i,LCol].value);
        Inc(LCol);
        AJobCode := StringToUTF8(AWorkSheet.Cells[i,LCol].value);
        Inc(LCol);
        RelType := StringToUTF8(AWorkSheet.Cells[i,LCol].value);
        Inc(LCol);
        BufferDay := StringToUTF8(AWorkSheet.Cells[i,LCol].value);
        Inc(LCol);
        Bigo := StringToUTF8(AWorkSheet.Cells[i,LCol].value);

        FBaseInfoDatabase.Add(LRec, True);
      end;

      ShowMessage('DB Base Info Data 저장 완료!(' + IntToStr(LRow) + ' 건)');
    end;

  finally
    LRec.Free;
  end;
end;

procedure TGanttForm.InsertBaseInfoFromExcel(AFileName: string);
var
  LExcel, LWorkSheet: variant;
begin
  LExcel := GetActiveExcelOleObject(True);
  LExcel.WorkBooks.Open(AFileName);
  try
    LWorkSheet := LExcel.ActiveWorkBook.WorkSheets[6];
    InsertBaseInfoData(LWorkSheet);
  finally
    LExcel.WorkBooks.Close;
  end;
end;

procedure TGanttForm.InsertHolidayData(AWorkSheet: variant);
var
  LRec: TSQLHolidayRecord;
  i, LRow, LCol: integer;
  LStr, LStr2: string;
  LGubun: THolidayGubun;
begin
  LRow := AWorkSheet.Usedrange.EntireRow.Count;

  LRec := TSQLHolidayRecord.Create;
  try
    with LRec do
    begin
      for i := 2 to LRow do
      begin
        HolidayDate := StrToDate(AWorkSheet.Cells[i,3].value);
        Inc(LCol);
        Description := StringToUTF8(AWorkSheet.Cells[i,5].value);
        LStr := AWorkSheet.Cells[i,6].value;
        LStr2 := AWorkSheet.Cells[i,7].value;

        if LStr <> '' then
          LGubun := hgAssembly;

        if LStr2 <> '' then
        begin
          if LGubun = hgAssembly then
            LGubun := hgAll
          else
            LGubun := hgOfficialTest;
        end;

        HolidayGubun := LGubun;
        UpdateDate := StrToDate(AWorkSheet.Cells[i,10].value);

        FHolidayDatabase.Add(LRec, True);
      end;

      ShowMessage('DB Holiday Data 저장 완료!(' + IntToStr(LRow) + ' 건)');
    end;

  finally
    LRec.Free;
  end;
end;

procedure TGanttForm.InsertHolidayFromExcel(AFileName: string);
var
  LExcel, LWorkSheet: variant;
begin
  LExcel := GetActiveExcelOleObject(True);
  LExcel.WorkBooks.Open(AFileName);
  try
    LWorkSheet := LExcel.ActiveWorkBook.WorkSheets[1];
    InsertHolidayData(LWorkSheet);
  finally
    LExcel.WorkBooks.Close;
  end;
end;

procedure TGanttForm.InsertSchduleData(AWorkSheet: variant);
var
  LRec: TSQLScheduleSampleRecord;
  i, LRow, LCol: integer;
  LStr: string;
  LBatch: TSQLRestBatch;
begin
  LRow := AWorkSheet.Usedrange.EntireRow.Count;

  LRec := TSQLScheduleSampleRecord.Create;
  LBatch := TSQLRestBatch.Create(FScheduleDatabase,
                                TSQLScheduleSampleRecord,
                                10000,
                                []);
  try
    with LRec do
    begin
      for i := 2 to LRow do
      begin
        LCol := 1;
        ProjNo := StringToUTF8(AWorkSheet.Cells[i,LCol].value);
        Inc(LCol);
        ShipNo := StringToUTF8(AWorkSheet.Cells[i,LCol].value);
        Inc(LCol);
        CylCount := StringToUTF8(AWorkSheet.Cells[i,LCol].value);
        Inc(LCol);
        EngineType := StringToUTF8(AWorkSheet.Cells[i,LCol].value);
        Inc(LCol);
        EngineCount := StringToUTF8(AWorkSheet.Cells[i,LCol].value);
        Inc(LCol);
        DeliveryDate := StrToDateDef(AWorkSheet.Cells[i,LCol].value,0.0);
        Inc(LCol);
        ActCode := StringToUTF8(AWorkSheet.Cells[i,LCol].value);
        Inc(LCol);
        Description := StringToUTF8(AWorkSheet.Cells[i,LCol].value);
        Inc(LCol);
        Duration := StringToUTF8(AWorkSheet.Cells[i,LCol].value);
        Inc(LCol);
        ProcessNo := StringToUTF8(AWorkSheet.Cells[i,LCol].value);
        Inc(LCol);
        FactoryName := StringToUTF8(AWorkSheet.Cells[i,LCol].value);
        Inc(LCol);
        ProcessDept := StringToUTF8(AWorkSheet.Cells[i,LCol].value);
        Inc(LCol);
        MachineNo := StringToUTF8(AWorkSheet.Cells[i,LCol].value);
        Inc(LCol);
        StandardOfEstimate := StringToUTF8(AWorkSheet.Cells[i,LCol].value);
        Inc(LCol);
        SOEAdjustFactor := StringToUTF8(AWorkSheet.Cells[i,LCol].value);
        Inc(LCol);
        RealAdjustValue := StringToUTF8(AWorkSheet.Cells[i,LCol].value);
        Inc(LCol);
        MHPerDay := StringToUTF8(AWorkSheet.Cells[i,LCol].value);
        Inc(LCol);
        StartDatePlan := StrToDateDef(AWorkSheet.Cells[i,LCol].value,0.0);
        Inc(LCol);
        EndDatePlan := StrToDateDef(AWorkSheet.Cells[i,LCol].value,0.0);
        Inc(LCol);
        StartDateActual := StrToDateDef(AWorkSheet.Cells[i,LCol].value,0.0);
        Inc(LCol);
        EndDateActual := StrToDateDef(AWorkSheet.Cells[i,LCol].value,0.0);
        Inc(LCol);
        StartDatePredict := StrToDateDef(AWorkSheet.Cells[i,LCol].value,0.0);
        Inc(LCol);
        EndDatePredict := StrToDateDef(AWorkSheet.Cells[i,LCol].value,0.0);

        LBatch.Add(LRec, True);
      end;

      FScheduleDatabase.BatchSend(LBatch);
      ShowMessage('DB Sample Data 저장 완료!(' + IntToStr(LRow) + ' 건)');
    end;

  finally
    LRec.Free;
  end;
end;

procedure TGanttForm.InsertSchduleDataFromCSV(AFileName: string);
var
  LRec: TSQLScheduleSampleRecord;
  i, LRow, LCol: integer;
  LStr, LStr2: string;
  LBatch: TSQLRestBatch;
  LStrList: TStringList;
begin
  LStrList := TStringList.Create;
  LStrList.LoadFromFile(AFileName);
  LRow := LStrList.Count;

  LRec := TSQLScheduleSampleRecord.Create;
  LBatch := TSQLRestBatch.Create(FScheduleDatabase,
                                TSQLScheduleSampleRecord,
                                10000,
                                []);
  try
    with LRec do
    begin
      for i := 0 to LRow - 1 do
      begin
        LStr2 := LStrList.Strings[i];
        LStr := GetTokenWithComma(LStr2); //No
        ProjNo := GetTokenWithComma(LStr2);
        ShipNo := GetTokenWithComma(LStr2);
        CylCount := GetTokenWithComma(LStr2);
        EngineType := GetTokenWithComma(LStr2);
        EngineCount := GetTokenWithComma(LStr2);
        GetTokenWithComma(LStr2);
        DeliveryDate := StrToDateTimeDef(GetTokenWithComma(LStr2),0);
        ActCode := GetTokenWithComma(LStr2);
        Description := GetTokenWithComma(LStr2);
        Duration := GetTokenWithComma(LStr2);
        ProcessNo := GetTokenWithComma(LStr2);
        FactoryName := GetTokenWithComma(LStr2);
        ProcessDept := GetTokenWithComma(LStr2);
        MachineNo := GetTokenWithComma(LStr2);
        StandardOfEstimate := GetTokenWithComma(LStr2);
        SOEAdjustFactor := GetTokenWithComma(LStr2);
        RealAdjustValue := GetTokenWithComma(LStr2);
        MHPerDay := GetTokenWithComma(LStr2);
        StartDatePlan := StrToDateTimeDef(GetTokenWithComma(LStr2),0);
        EndDatePlan := StrToDateTimeDef(GetTokenWithComma(LStr2),0);
        StartDateActual := StrToDateTimeDef(GetTokenWithComma(LStr2),0);
        EndDateActual := StrToDateTimeDef(GetTokenWithComma(LStr2),0);
        StartDatePredict := StrToDateTimeDef(GetTokenWithComma(LStr2),0);
        EndDatePredict := StrToDateTimeDef(GetTokenWithComma(LStr2),0);

        LBatch.Add(LRec, True);
      end;

      FScheduleDatabase.BatchSend(LBatch);
      ShowMessage('DB Sample Data 저장 완료!(' + IntToStr(LRow) + ' 건)');
    end;

  finally
    LRec.Free;
  end;
end;

procedure TGanttForm.InsertSchduleDataFromExcel(AFileName: string);
var
  LExcel, LWorkSheet: variant;
begin
  LExcel := GetActiveExcelOleObject(True);
  LExcel.WorkBooks.Open(AFileName);
  try
    LWorkSheet := LExcel.ActiveWorkBook.WorkSheets[1];
    InsertSchduleData(LWorkSheet);
  finally
    LExcel.WorkBooks.Close;
  end;
end;

function TGanttForm.IsMain(const b: ICefBrowser; const f: ICefFrame): Boolean;
begin
  Result := (b <> nil) and (b.Identifier = crm.BrowserId) and ((f = nil) or (f.IsMain));
end;

procedure TGanttForm.OnGetScheduleChangedCompleted(
  const task: IOmniTaskControl);
begin

end;

procedure TGanttForm.ProcessScheduleMsg;
begin
  Parallel.Async(GetScheduleChanged, Parallel.TaskConfig.OnTerminated(OnGetScheduleChangedCompleted));
end;

procedure TGanttForm.rg_periodClick(Sender: TObject);
begin
  dt_begin.Enabled := False;
  dt_end.Enabled := False;
  case rg_period.ItemIndex of
    0:
      begin
        dt_begin.Date := Now;
        dt_end.Date := Now;
      end;
    1:
      begin
        dt_begin.Date := StartOfTheWeek(Now);
        dt_end.Date := EndOfTheWeek(Now);
      end;
    2:
      begin
        dt_begin.Date := StartOfTheMonth(Now);
        dt_end.Date := EndOfTheMonth(Now);
      end;
    3:
      begin
        dt_begin.Enabled := True;
        dt_end.Enabled := True;
      end;
  end;
end;

procedure TGanttForm.SetBigoFlag(AChange: Variant);
var
  LStr: string;
  LChanges: TTGGanttChanges;
begin
//  LStr := TDocVariantData(AChange).Value[0].BIGO;
  with TDocVariantData(AChange) do
  begin
    if Value[0].Exists('BIGO') then
    begin
      SetLength(LChanges.Changes,1);
      LChanges.Changes[0].id :=  Value[0].id;
      LChanges.Changes[0].FLAGS := GetStartDateFromRecord(Value[0].id);
//      LData := GetVar2TGGanttChanges1(LChanges);
//      LStr := 'grid.AddDataFromServer(' + LData + ');';
      executeChromeJavaScript(LStr);

    end;
//    ShowMessage(TDocVariantData(AChange).Value[0].BIGO);
  end;
end;

procedure TGanttForm.SpeedButton6Click(Sender: TObject);
begin
  //crm.Browser.MainFrame.VisitDomProc(AttachMouseDownListenerProc);
end;

procedure TGanttForm.WorkerResult(var msg: TMessage);
begin
  ProcessScheduleMsg;
end;

procedure TGanttForm.actZoomInExecute(Sender: TObject);
begin
  if crm.Browser <> nil then
    crm.Browser.Host.ZoomLevel := crm.Browser.Host.ZoomLevel + 0.5;
end;

procedure TGanttForm.actZoomOutExecute(Sender: TObject);
begin
  if crm.Browser <> nil then
    crm.Browser.Host.ZoomLevel := crm.Browser.Host.ZoomLevel - 0.5;
end;

procedure TGanttForm.actZoomResetExecute(Sender: TObject);
begin
  if crm.Browser <> nil then
    crm.Browser.Host.ZoomLevel := 0;
end;

procedure TGanttForm.AdaptScheduleChanged(AVar: variant);
var
  i: integer;
begin
  with TDocVariantData(AVar) do
  begin
//    for i := 0 to Count - 1 do
//    begin
//      Value[i].Exists()
//    end;
  end;

//  if TDocVariantData(AVar).Value[0].Exists('BIGO') then
//    ShowMessage(TDocVariantData(AVar).Value[0].BIGO);
end;

function TGanttForm.AddItemsToInspector(AInspector: TNextInspector;
  ANxItemClass: TNxItemClass; ABaseIndex: integer; AName, ACaption,
  AValue: string): TNxPropertyItem;
begin
  Result := nil;
  Result := AInspector.Items.AddChild(AInspector.Items[ABaseIndex], ANxItemClass);

  if Result <> nil then
  begin
    if AName <> '' then
      Result.Name := AName;

    if ACaption <> '' then
      Result.Caption := ACaption;

    if AValue <> '' then
      Result.AsString := AValue;
  end;

  AInspector.Invalidate;
end;

procedure TGanttForm.AeroButton1Click(Sender: TObject);
begin
  GetGridChangesAll;
end;

procedure TGanttForm.AeroButton2Click(Sender: TObject);
begin
  Close;
end;

procedure TGanttForm.AeroButton3Click(Sender: TObject);
var
  LStr, LStr2, LData, LExclude: string;
  LStrList: TStringList;
  V,V2: variant;
  LFDate,LTDate: TDateTime;
begin
  executeChromeJavaScript('grid = Grids["Him_Sch"];' + #13#10 + 'grid.Dispose(); grid.Clear();');

  if cb_SearchMode.ItemIndex = -1 then
  begin
    LFDate := 0;
    LTDate := 0;
  end
  else
  begin
    LFDate := dt_begin.DateTime;
    LTDate := dt_end.DateTime;
  end;

//  V := _JSon(GetTGConfig1(LFDate, LTDate),[dvoSerializeAsExtendedJson]);
//  LData := V;

  //LFDate에 가장 빠른 시작일, LTDate에 가장 늦은 종료일이 들어감
  //Body Data가 반환됨
  LStr2 := DM1.GetRecordJsonFromODAC(cb_ProjNo.Text, cb_SearchMode.ItemIndex,
   RG_SchType.ItemIndex, CB_ExProcess.Checked, LFDate, LTDate);

//  LStr2 := DM1.GetRecordJsonFrommORMot(FScheduleDatabase,
//    cb_ProjNo.Text, cb_SearchMode.ItemIndex, RG_SchType.ItemIndex,
//    CB_ExProcess.Checked, LFDate, LTDate);

  LStr := DM1.GetGanttExclude(LFDate,LTDate);
  FGanttConfig1.Cols[0].GanttExclude := LStr;

  LData := GetVar2TGConfig1(FGanttConfig1);

  LData := StringReplace(LData, 'Body:[]', LStr2, [rfReplaceAll]);

  LStr := 'GridData={###};' + #13#10;
  LStr := LStr + 'grid = TreeGrid(''<bdo Sync="0" Debug="" Upload_Type="Body" Upload_Format="JSON" Data_Script="GridData"></bdo>'',"Gantt");';
  LStr := StringReplace(LStr, '{###}', LData, [rfReplaceAll]);
//  LStr := StringReplace(LStr, 'F_Type', 'Type', [rfReplaceAll]);
//  LStr := StringReplace(LStr, 'GanttZoom:" "', 'GanttZoom:""', [rfReplaceAll]);
//  LStr := StringReplace(LStr, 'Body:[]', LStr2, [rfReplaceAll]);

//  LStr := StringReplace(LStr, 'Body:[]', LStr2, [rfReplaceAll]);

  executeChromeJavaScript(LStr);
//  executeChromeJavaScript('grid.Clear();');
//  executeChromeJavaScript('grid.Dispose();');
//  executeChromeJavaScript('grid.Reload();');
//  Memo1.Lines.Text := LStr;
end;

procedure TGanttForm.Button1Click(Sender: TObject);
var
  LStr, LData: string;
  LStrList: TStringList;
begin
//  LData := ' " <Grid> <Body> <B> ';
//  LData := LData + ' <I id=''1'' L=''Task 1'' T=''Subtask 1'' C=''100'' S=''5/18/2008'' E=''5/20/2008'' D=''2''/> ';
//  LData := LData + ' </B> </Body> </Grid> " ';
//
//  LStr := 'TreeGrid( { Data:{ Data:';
//  LStr := LStr + LData + ' } },"Main" ) ';

  LStrList:= TStringList.Create;
  try
//    LStrList.LoadFromFile('E:\test.xml');
    LStrList.LoadFromFile('E:\Jsontest.txt');
    LData := LStrList.Text;
    LStrList.Clear;
    LStrList.LoadFromFile('E:\JsonDatatest4.txt');
    LStr := LStrList.Text;
    LStr := StringReplace(LStr, #13#10, '', [rfReplaceAll]);

    LData := StringReplace(LData, '{###}', LStr, [rfReplaceAll]);
  finally
    LStrList.Free;
  end;

//  LStr := StringReplace(LStr, #13#10, '', [rfReplaceAll]);
//  LStr := 'TreeGrid("' + LData + '","Main" )';
  executeChromeJavaScript(LData);
end;

procedure TGanttForm.Button2Click(Sender: TObject);
var
  LStr: string;
begin
  //TreeGrid(Upload_Type="Body")를 하면 Grid의 모든 Row를 가져옴
  //TreeGrid(Upload_Type="Body" Upload_Format="JSON")를 하면 결과값이 JSON으로 반환 됨
//  LStr := 'var grid = Grids[0];' + #13#10;
//  LStr := LStr + 'var data' + #13#10;
//  LStr := LStr + ' data = grid.GetXmlData();' + #13#10;
//  LStr := LStr + ' data = grid.GetChanges();' + #13#10;
  LStr := LStr + ' console.log(grid.GetChanges());';

  executeChromeJavaScript(LStr);
end;

procedure TGanttForm.Button3Click(Sender: TObject);
var
  V,V2: variant;
  LStr, LData: RawUtf8;
begin
//  V := _Json('{name:"john", year:1982}');
//  V2 := _JsonFmt('{%:?, %:?}',['name','year'],['john',1982], [dvoSerializeAsExtendedJson]);
//  ShowMessage(V2);
//  V := _JSon(GetTGConfig1(),[dvoSerializeAsExtendedJson]);

//  LData := V;
//  LStr := 'var GridData={###};' + #13#10;
//  LStr := LStr + 'TreeGrid(''<bdo Sync="0" Debug="" Upload_Type="Body" Upload_Format="JSON" Data_Script="GridData"></bdo>'',"Gantt");';
//  LStr := StringReplace(LStr, '{###}', LData, [rfReplaceAll]);
//  LStr := StringReplace(LStr, 'F_Type', 'Type', [rfReplaceAll]);
//  executeChromeJavaScript(LStr);
//  Memo1.Lines.Text := LStr;

  GetGridChangesAll;
end;

procedure TGanttForm.Button4Click(Sender: TObject);
begin
//  InsertSchduleDataFromExcel('e:\Bar Chart Test 용 공사별 공정착수완료일 List2.xlsx');
//  InsertSchduleDataFromCSV('e:\Bar Chart Test 용 공사별 공정착수완료일 List1.csv');
//  InsertBaseInfoFromExcel('e:\기준데이터1.xlsx');
  InsertHolidayFromExcel('e:\work calendar.xlsx');
end;

procedure TGanttForm.Button5Click(Sender: TObject);
var
  LStr, LData: string;
  LStrList: TStringList;
begin
  LStrList:= TStringList.Create;
  try
//    LStrList.LoadFromFile('E:\Jsontest.txt');
//    LData := LStrList.Text;
//    LStrList.Clear;
    LStrList.LoadFromFile('E:\JsonDatatest10.txt');
    LStr := LStrList.Text;
//    LStr := StringReplace(LStr, #13#10, '', [rfReplaceAll]);
//    LData := StringReplace(LData, '{###}', LStr, [rfReplaceAll]);
  finally
    LStrList.Free;
  end;

  executeChromeJavaScript(LStr);
end;

procedure TGanttForm.Button6Click(Sender: TObject);
var
  LStr, LData: string;
  LV: Variant;
  LChanges: TTGGanttChanges;
begin
//  crm.Browser.Reload;
//  grid.GetChanges()
//  TDocVariant.New(LV, [dvoSerializeAsExtendedJson]);
//  LV.id := '1_JP0001-W0700';
//  LV.FLAGS := '08/21/2016';
//  LData := Utf8ToString(VariantSaveJson(LV));
  SetLength(LChanges.Changes,1);
  LChanges.Changes[0].id :=  '1_JP0001-W0700';
  LChanges.Changes[0].FLAGS := '08/21/2016';
  LData := GetVar2TGGanttChanges1(LChanges);
//  LData := '{Changes:[' + Utf8ToString(VariantSaveJson(LV)) + ']}';
  LStr := 'grid.AddDataFromServer(' + LData + ');';
  executeChromeJavaScript(LStr);
end;

procedure TGanttForm.cb_ShipNoDropDown(Sender: TObject);
begin
  DM1.GetShipNoListFrommORMot(FScheduleDatabase, cb_ShipNo.Items);
end;

procedure TGanttForm.cb_siljeokClick(Sender: TObject);
begin
  DisplayDate(cb_siljeok.Checked,2);
end;

procedure TGanttForm.cb_modifyClick(Sender: TObject);
begin
  DisplayDate(cb_modify.Checked,1);
end;

procedure TGanttForm.cb_planClick(Sender: TObject);
begin
  DisplayDate(cb_plan.Checked,0);
end;

procedure TGanttForm.cb_ProjNoDropDown(Sender: TObject);
begin
//  DM1.GetProjNoListFrommORMot(FScheduleDatabase, cb_ProjNo.Items);
  DM1.GetProjNoListFromODAC(cb_ProjNo.Items);
end;

procedure TGanttForm.cb_projnoincDropDown(Sender: TObject);
begin
  cb_projnoinc.Items.Clear;
  cb_projnoinc.Items.AddStrings(DM1.FProjList);
end;

procedure TGanttForm.cb_projnoincSelect(Sender: TObject);
begin
  SetProjInfo2Inspector(cb_projnoinc.Text);
end;

procedure TGanttForm.crmAddressChange(Sender: TObject;
  const browser: ICefBrowser; const frame: ICefFrame; const url: ustring);
begin
  if IsMain(browser, frame) then
    edAddress.Text := url;
end;

procedure TGanttForm.crmAfterCreated(Sender: TObject;
  const browser: ICefBrowser);
begin
  TCefRTTIExtension.Register('myclass', TMyClass);
end;

procedure TGanttForm.crmBeforeDownload(Sender: TObject;
  const browser: ICefBrowser; const downloadItem: ICefDownloadItem;
  const suggestedName: ustring; const callback: ICefBeforeDownloadCallback);
begin
  callback.Cont(ExtractFilePath(ParamStr(0)) + suggestedName, True);
end;

procedure TGanttForm.crmBeforePopup(Sender: TObject; const browser: ICefBrowser;
  const frame: ICefFrame; const targetUrl, targetFrameName: ustring;
  var popupFeatures: TCefPopupFeatures; var windowInfo: TCefWindowInfo;
  var client: ICefClient; var settings: TCefBrowserSettings;
  var noJavascriptAccess: Boolean; out Result: Boolean);
begin
  // prevent popup
  crm.Load(targetUrl);
  Result := True;
end;

procedure TGanttForm.crmBeforeResourceLoad(Sender: TObject;
  const browser: ICefBrowser; const frame: ICefFrame;
  const request: ICefRequest; out Result: Boolean);
var
  u: TUrlParts;
begin
  // redirect home to google
  if CefParseUrl(request.Url, u) then
    if (u.host = 'home') then
    begin
      u.host := 'E:\pjh\vcl\dcef\dcef3\demos\test.html';//'www.google.com';
      request.Url := CefCreateUrl(u);
    end;
end;

procedure TGanttForm.crmConsoleMessage(Sender: TObject;
  const browser: ICefBrowser; const message, source: ustring; line: Integer;
  out Result: Boolean);
var
  LValue: TOmniValue;
  V, V2: variant;
  LStr: string;
//  V2: TVariantDynArray;
begin
  LValue := message;
  FpjhOmniMsgQClass.FResponseQueue.Enqueue(TOmniMessage.Create(0, LValue));
  DisplayMsq(message);

//  V := _JSon(message);
//  LStr := V.Changes;
//  V2 := _JsonFast(LStr);
//  SetBigoFlag(V2);
//  LStr := TDocVariantData(V2).Value[0].BIGO;
//  if TDocVariantData(V2).Value[0].Exists('BIGO') then
//    ShowMessage(TDocVariantData(V2).Value[0].BIGO);
end;

procedure TGanttForm.crmDownloadUpdated(Sender: TObject;
  const browser: ICefBrowser; const downloadItem: ICefDownloadItem;
  const callback: ICefDownloadItemCallback);
begin
  if downloadItem.IsInProgress then
    StatusBar.SimpleText := IntToStr(downloadItem.PercentComplete) + '%' else
    StatusBar.SimpleText := '';
end;

procedure TGanttForm.crmLoadEnd(Sender: TObject; const browser: ICefBrowser;
  const frame: ICefFrame; httpStatusCode: Integer);
begin
  if IsMain(browser, frame) then
    FLoading := False;

  InitGantt;
end;

procedure TGanttForm.crmLoadStart(Sender: TObject; const browser: ICefBrowser;
  const frame: ICefFrame);
begin
  if IsMain(browser, frame) then
    FLoading := True;
end;

procedure TGanttForm.crmProcessMessageReceived(Sender: TObject;
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

procedure TGanttForm.crmStatusMessage(Sender: TObject;
  const browser: ICefBrowser; const value: ustring);
begin
  StatusBar.SimpleText := value
end;

procedure TGanttForm.crmTitleChange(Sender: TObject; const browser: ICefBrowser;
  const title: ustring);
begin
  if IsMain(browser) then
    Caption := title;
end;

//  SetLength(LChanges.Changes,10000);
//  m := 0;

//  LStr := 'grid.GanttUpdate = 1;';
//  executeChromeJavaScript(LStr);
//      G_ExcludeNullList.Clear;
//      G_ExcludeNullList.Add('START');
//          G_ExcludeNullList.Add('ENDDATE');
//          LChanges.Changes[m].START := '11/30/2016';
//          LChanges.Changes[m].ENDDATE := '';
//          LStr := LStr + 'grid.Recalculate(row, "START", 1);';
//      LStr := LStr + 'val = grid.CheckGantt(row, "ENDDATE", "");';
//      LStr := LStr + 'grid.SetValue(row, "ENDDATE", "",1);';
//          LStr := LStr + 'grid.Recalculate(row, "ENDDATE");';
//          LStr := LStr + 'val = grid.CheckGantt(row, "DUR", val);';
//          LStr := LStr + 'grid.SetValue(row, "DUR", 3,1);';
//          LStr := LStr + 'grid.Recalculate(row, "DUR");';

procedure TGanttForm.DisplayDate(AVisible: Boolean; AColIndex: integer);
//AColIndex: 0 = 계획, 1 = 수정, 2 = 실적
var
  LStr, LRowId, LColName1, LColName2, LValue1, LValue2: string;
  LData: RawUTF8;
  LV: Variant;
//  LChanges: TTGGanttChanges;
  i,j,k,m: integer;

  procedure ShowOrHideDate(BRowId, BColName1, BColName2, BValue1, BValue2: string);
  begin
    if not AVisible then
    begin
      BValue1 := '""';
      BValue2 := '""';
    end
    else
    begin
      BValue1 := '"' + BValue1 + '"';
      BValue2 := '"' + BValue2 + '"';
    end;

    LStr := 'var row = grid.GetRowById("' + BRowId + '");';
    LStr := LStr + 'var val = grid.CheckGantt(row, "' + BColName1 + '", ' + BValue1 + ');';
    LStr := LStr + 'grid.SetValue(row, "' + BColName1 + '", ' + BValue1 + ',1);';
    LStr := LStr + 'var val = grid.CheckGantt(row, "' + BColName2 + '", ' + BValue2 + ');';
    LStr := LStr + 'grid.SetValue(row, "' + BColName2 + '", ' + BValue2 + ',1);';

    executeChromeJavaScript(LStr);
  end;
begin
//  TDocVariant.New(LV);//, [dvoSerializeAsExtendedJson]
  LColName1 := 'START';
  LColName2 := 'ENDDATE';

  if AColIndex > 0 then
  begin
    LColName1 := LColName1 + IntToStr(AColIndex);
    LColName2 := LColName2 + IntToStr(AColIndex);
  end;

  LStr := 'grid.GanttUpdate = 1;';
  executeChromeJavaScript(LStr);

  for i := 0 to DM1.FProjList.Count - 1 do
  begin
    for j := 0 to TProjectInfo(DM1.FProjList.Objects[i]).FProcessList.Count - 1 do
    begin
      for k := 0 to TStringList(TProjectInfo(DM1.FProjList.Objects[i]).FProcessList.Objects[j]).Count - 1 do
      begin
        if AVisible then
        begin
//          LV.Clear;
          LV := _JSON(TStringList(TProjectInfo(DM1.FProjList.Objects[i]).FProcessList.Objects[j]).ValueFromIndex[k]);
//          VariantLoadJson(LV, @LData[1]);

          case AColIndex of
            0: begin
              LValue1 := LV.START;
              LValue2 := LV.ENDDATE;
            end;
            1: begin
              if LV.Exists('START1') then
                LValue1 := LV.START1;

              if LV.Exists('ENDDATE1') then
                LValue2 := LV.ENDDATE1;
            end;
            2: begin
              if LV.Exists('START2') then
                LValue1 := LV.START2;

              if LV.Exists('ENDDATE2') then
                LValue2 := LV.ENDDATE2;
            end;
          end;
        end;

        LRowId := IntToStr(i + 1) + '_' + TStringList(TProjectInfo(DM1.FProjList.Objects[i]).FProcessList.Objects[j]).Names[k];
        ShowOrHideDate(LRowId, LColName1, LColName2, LValue1, LValue2);
      end;
    end;
  end;

//        LChanges.Changes[m].id := IntToStr(i + 1) + '_' + TStringList(TProjectInfo(DM1.FProjList.Objects[i]).FProcessList.Objects[j]).Names[k];
//  SetLength(LChanges.Changes,m+1);
//  LData := GetVar2TGGanttChanges1(LChanges);
//  LStr := 'grid.AddDataFromServer(' + LData + ');';
//  executeChromeJavaScript(LStr);

  LStr := 'grid.GanttUpdate = 0; grid.RefreshGantt();';
  executeChromeJavaScript(LStr);
end;

procedure TGanttForm.DisplayMsq(AMsg: string);
begin
  Memo1.Lines.Add(AMsg);
end;

procedure TGanttForm.SetProjInfo2Inspector(AProjNo: string);
var
  LPropertyItem: TNxPropertyItem;
  i: integer;
  LProjectInfo: TProjectInfo;
begin
  if AProjNo = '' then
    exit;

  for i := ProjectInfoInspector.Items.Count - 1 downto 0 do
    ProjectInfoInspector.Items[i].Clear;

  LProjectInfo := nil;
  LProjectInfo := DM1.GetProjInfo(AProjNo);

  if Assigned(LProjectInfo) then
  begin
    ProjectInfoInspector.BeginUpdate;

    try
      LPropertyItem := AddItemsToInspector(ProjectInfoInspector, TNxTextItem, ProjItem.NodeIndex,
        'FShipNo', '호선', LProjectInfo.ShipNo);
      LPropertyItem.ItemHeight := 20;
      LPropertyItem := AddItemsToInspector(ProjectInfoInspector, TNxTextItem, ProjItem.NodeIndex,
        'FProjNo', '공사번호', LProjectInfo.ProjectNo);
      LPropertyItem.ItemHeight := 20;
      LPropertyItem := AddItemsToInspector(ProjectInfoInspector, TNxTextItem, ProjItem.NodeIndex,
        'FShipOwner', '선주', LProjectInfo.ShipOwner);
      LPropertyItem.ItemHeight := 20;
      LPropertyItem := AddItemsToInspector(ProjectInfoInspector, TNxTextItem, ProjItem.NodeIndex,
        'FSociety', '선급', LProjectInfo.ClassSociety);
      LPropertyItem.ItemHeight := 20;

      LPropertyItem := AddItemsToInspector(ProjectInfoInspector, TNxTextItem, EngineItem.NodeIndex,
        'FEngineCount', '엔진대수', LProjectInfo.EngineCount);
      LPropertyItem.ItemHeight := 20;
      LPropertyItem := AddItemsToInspector(ProjectInfoInspector, TNxTextItem, EngineItem.NodeIndex,
        'FEngineType', '엔진타입', LProjectInfo.ProjectInfoCollect.Items[0].EngType);
      LPropertyItem.ItemHeight := 20;

      LPropertyItem := AddItemsToInspector(ProjectInfoInspector, TNxTextItem, ScheduleItem.NodeIndex,
        'FAssyDate', '착수일', DateTimeToStr(LProjectInfo.AssyStartDate));
      LPropertyItem.ItemHeight := 20;
      LPropertyItem := AddItemsToInspector(ProjectInfoInspector, TNxTextItem, ScheduleItem.NodeIndex,
        'FDeliveryDate', '납기', DateTimeToStr(LProjectInfo.DeliveryDate));
      LPropertyItem.ItemHeight := 20;

      LPropertyItem := AddItemsToInspector(ProjectInfoInspector, TNxTextItem, FactoryItem.NodeIndex,
        'FAssyFactory', '조립공장', LProjectInfo.AssyFactory);
      LPropertyItem.ItemHeight := 20;
      LPropertyItem := AddItemsToInspector(ProjectInfoInspector, TNxTextItem, FactoryItem.NodeIndex,
        'FTestFactory', '시운전공장', LProjectInfo.TestFactory);
      LPropertyItem.ItemHeight := 20;
      LPropertyItem := AddItemsToInspector(ProjectInfoInspector, TNxTextItem, FactoryItem.NodeIndex,
        'FSJDept', '선조립 부서', LProjectInfo.SJDept);
      LPropertyItem.ItemHeight := 20;
      LPropertyItem := AddItemsToInspector(ProjectInfoInspector, TNxTextItem, FactoryItem.NodeIndex,
        'FSWDept', '수압+HEAD 부서', LProjectInfo.SWDept);
      LPropertyItem.ItemHeight := 20;
      LPropertyItem := AddItemsToInspector(ProjectInfoInspector, TNxTextItem, FactoryItem.NodeIndex,
        'FJJDept', '종조립 부서', LProjectInfo.JJDept);
      LPropertyItem.ItemHeight := 20;

      LPropertyItem := AddItemsToInspector(ProjectInfoInspector, TNxTextItem, ModuleItem.NodeIndex,
        'FModuleCyl', 'CYL', LProjectInfo.Module1);
      LPropertyItem.ItemHeight := 20;
      LPropertyItem := AddItemsToInspector(ProjectInfoInspector, TNxTextItem, ModuleItem.NodeIndex,
        'FModuleFEB', 'F.E.B', LProjectInfo.Module2);
      LPropertyItem.ItemHeight := 20;
      LPropertyItem := AddItemsToInspector(ProjectInfoInspector, TNxTextItem, ModuleItem.NodeIndex,
        'FModuleB_F', 'B/F', LProjectInfo.Module3);
      LPropertyItem.ItemHeight := 20;
      LPropertyItem := AddItemsToInspector(ProjectInfoInspector, TNxTextItem, ModuleItem.NodeIndex,
        'FModuleTerminal', 'TERMINAL', LProjectInfo.Module4);
      LPropertyItem.ItemHeight := 20;
    finally
      ProjectInfoInspector.ExpandAll;
      ProjectInfoInspector.EndUpdate;
    end;
  end;

end;

procedure TGanttForm.edAddressKeyPress(Sender: TObject; var Key: Char);
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

procedure TGanttForm.executeChromeJavaScript(AScript: string);
begin
  if crm.Browser <> nil then
    crm.Browser.FocusedFrame.ExecuteJavaScript(
      AScript, 'about:blank', 0);
end;

procedure TGanttForm.Exit1Click(Sender: TObject);
begin
  Close;
end;

procedure TGanttForm.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
begin
  // avoid AV when closing application
  if CefSingleProcess then
  begin
    crm.Load('about:blank');
//    debug.Load('about:blank');
//    while debug.Browser.IsLoading or crm.Browser.IsLoading  do
//      Application.ProcessMessages;
  end;
  CanClose := True;
end;

procedure TGanttForm.FormCreate(Sender: TObject);
begin
  FLoading := False;
  FDevToolLoaded := False;

  FDeptCodeList:= TStringList.Create;
  ProjectInfoInspector.DoubleBuffered := False;

  InitDatabase;
  InitMQ;
end;

procedure TGanttForm.FormDestroy(Sender: TObject);
begin
  FDeptCodeList.Free;
  FScheduleDatabase.Free;
  FScheduleModel.Free;
  FBaseInfoDatabase.Free;
  FBaseInfoModel.Free;
  FpjhOmniMsgQClass.Free;
end;

function TGanttForm.GetGridChangesAll: string;
var
  LStr: string;
begin
  LStr := 'console.log(' + CHANGED_ALL_TAG+ '"=" + grid.GetChanges());';
  executeChromeJavaScript(LStr);
end;

procedure TGanttForm.GetScheduleChanged;
var
  msg: TOmniMessage;
  LJson: string;
  LUtf8: RawUTF8;
  V, V2: variant;
  LStr: string;
begin
  while FpjhOmniMsgQClass.FResponseQueue.TryDequeue(msg) do
  begin
    LJson := msg.MsgData.AsString;
    LStr := strToken(LJson, '=');

    //Gantt가 변할 때마다 들어옴
    if LStr = CHANGED_ROW_TAG then
    begin

    end
    else//저장 버튼을 눌렀을떄 들어옴
    if LStr = CHANGED_ALL_TAG then
    begin
      LUtf8 := StringToUTF8(LJson);
      V := _JSon(LUtf8);
      LStr := V.Changes;
      V2 := _JsonFast(LStr);

      AdaptScheduleChanged(V2);
    end;

//    LUtf8 := StringToUTF8(LJson);
//    RecordLoadJSON(LValue, pointer(LUtf8), TypeInfo(TEquipRunStatusRecord));
//    V := _JSon(LUtf8);
//    LStr := V.Changes;
//    V2 := _JsonFast(LStr);
//  SetBigoFlag(V2);
//  LStr := TDocVariantData(V2).Value[0].BIGO;
//  if TDocVariantData(V2).Value[0].Exists('BIGO') then
//    ShowMessage(TDocVariantData(V2).Value[0].BIGO);
  end;
end;

function TGanttForm.GetStartDateFromRecord(AId: string): String;
begin

end;

function TGanttForm.GetTGConfig1(AExecludeFrom, AExcludeTo: TDateTime): string;
var
  LStr: string;
begin
  FGanttConfig1.Cfg.Code := TG_REG_CODE;
  FGanttConfig1.Cfg.id := 'Him_Sch';
//  FGanttConfig1.Cfg.NoVScroll := '1';
  FGanttConfig1.Cfg.IdChars := '0123456789';
  FGanttConfig1.Cfg.NumberId := '1';
  FGanttConfig1.Cfg.Undo := '1';
  FGanttConfig1.Cfg.ChangesUpdate := 1;
//  FGanttConfig1.Cfg.ResizingMain := '1';

  FGanttConfig1.Cfg.MainCol := 'Process';

  SetLength(FGanttConfig1.LeftCols, 21);

  FGanttConfig1.LeftCols[0].Name := 'id';
  FGanttConfig1.LeftCols[0].F_Type := 'Text';
  FGanttConfig1.LeftCols[0].Visible := '0';

  FGanttConfig1.LeftCols[1].Name := 'Process';
  FGanttConfig1.LeftCols[1].F_Type := 'Text';
  FGanttConfig1.LeftCols[1].CanEdit := '0';
  FGanttConfig1.LeftCols[1].CanSort := '0';
  FGanttConfig1.LeftCols[1].Align := 'Left';

  FGanttConfig1.LeftCols[2].Name := 'START';
  FGanttConfig1.LeftCols[2].F_Type := 'Date';
  FGanttConfig1.LeftCols[2].Format := 'M/dd';
  FGanttConfig1.LeftCols[2].EditFormat := '%d';

  FGanttConfig1.LeftCols[3].Name := 'ENDDATE';
  FGanttConfig1.LeftCols[3].F_Type := 'Date';
  FGanttConfig1.LeftCols[3].Format := 'M/dd';
  FGanttConfig1.LeftCols[3].EditFormat := '%d';

  FGanttConfig1.LeftCols[4].Name := 'DUR';
  FGanttConfig1.LeftCols[4].F_Type := 'Float';
  FGanttConfig1.LeftCols[4].CanEmpty := '1';

  FGanttConfig1.LeftCols[5].Name := 'COMP';
  FGanttConfig1.LeftCols[5].F_Type := 'Float';
  FGanttConfig1.LeftCols[5].Format := '0.#';

  FGanttConfig1.LeftCols[6].Name := 'PARTS';
  FGanttConfig1.LeftCols[6].Width := '80';
  FGanttConfig1.LeftCols[6].F_Type := 'Date';
  FGanttConfig1.LeftCols[6].Format := 'dddddd';
  FGanttConfig1.LeftCols[6].Range := '1';
  FGanttConfig1.LeftCols[6].Visible := '0';

  FGanttConfig1.LeftCols[7].Name := 'ANC';
  FGanttConfig1.LeftCols[7].F_Type := 'Text';
  FGanttConfig1.LeftCols[7].Visible := '0';

  FGanttConfig1.LeftCols[8].Name := 'ES';
  FGanttConfig1.LeftCols[8].F_Type := 'Date';
  FGanttConfig1.LeftCols[8].Format := 'dddddd';
  FGanttConfig1.LeftCols[8].EditFormat := '%d';
  FGanttConfig1.LeftCols[8].Visible := '0';

  FGanttConfig1.LeftCols[9].Name := 'LFinish';
  FGanttConfig1.LeftCols[9].F_Type := 'Date';
  FGanttConfig1.LeftCols[9].Format := 'dddddd';
  FGanttConfig1.LeftCols[9].EditFormat := '%d';
  FGanttConfig1.LeftCols[9].Visible := '0';

  FGanttConfig1.LeftCols[10].Name := 'DEC';
  FGanttConfig1.LeftCols[10].F_Type := 'Text';
  FGanttConfig1.LeftCols[10].Visible := '0';

  FGanttConfig1.LeftCols[11].Name := 'RES';
  FGanttConfig1.LeftCols[11].F_Type := 'Text';
  FGanttConfig1.LeftCols[11].Visible := '0';

  FGanttConfig1.LeftCols[12].Name := 'BIGO';
  FGanttConfig1.LeftCols[12].F_Type := 'Text';
  FGanttConfig1.LeftCols[12].Visible := '0';

  FGanttConfig1.LeftCols[13].Name := 'FLAGS';
  FGanttConfig1.LeftCols[13].F_Type := 'Date';
  FGanttConfig1.LeftCols[13].Format := 'dddddd';
  FGanttConfig1.LeftCols[13].Visible := '0';

  FGanttConfig1.LeftCols[14].Name := 'ICONS';
  FGanttConfig1.LeftCols[14].F_Type := 'Text';
  FGanttConfig1.LeftCols[14].Visible := '0';

  FGanttConfig1.LeftCols[15].Name := 'START1';
  FGanttConfig1.LeftCols[15].F_Type := 'Date';
  FGanttConfig1.LeftCols[15].Format := 'M/dd';
  FGanttConfig1.LeftCols[15].EditFormat := '%d';
  FGanttConfig1.LeftCols[15].Visible := '0';

  FGanttConfig1.LeftCols[16].Name := 'ENDDATE1';
  FGanttConfig1.LeftCols[16].F_Type := 'Date';
  FGanttConfig1.LeftCols[16].Format := 'M/dd';
  FGanttConfig1.LeftCols[16].EditFormat := '%d';
  FGanttConfig1.LeftCols[16].Visible := '0';

  FGanttConfig1.LeftCols[17].Name := 'DUR1';
  FGanttConfig1.LeftCols[17].F_Type := 'Float';
  FGanttConfig1.LeftCols[17].CanEmpty := '1';
  FGanttConfig1.LeftCols[17].Visible := '0';

  FGanttConfig1.LeftCols[18].Name := 'START2';
  FGanttConfig1.LeftCols[18].F_Type := 'Date';
  FGanttConfig1.LeftCols[18].Format := 'M/dd';
  FGanttConfig1.LeftCols[18].EditFormat := '%d';
  FGanttConfig1.LeftCols[18].Visible := '0';

  FGanttConfig1.LeftCols[19].Name := 'ENDDATE2';
  FGanttConfig1.LeftCols[19].F_Type := 'Date';
  FGanttConfig1.LeftCols[19].Format := 'M/dd';
  FGanttConfig1.LeftCols[19].EditFormat := '%d';
  FGanttConfig1.LeftCols[19].Visible := '0';

  FGanttConfig1.LeftCols[20].Name := 'DUR2';
  FGanttConfig1.LeftCols[20].F_Type := 'Float';
  FGanttConfig1.LeftCols[20].CanEmpty := '1';
  FGanttConfig1.LeftCols[20].Visible := '0';

  SetLength(FGanttConfig1.Cols, 1);

  FGanttConfig1.Cols[0].Name := 'GANTT';
  FGanttConfig1.Cols[0].F_Type := 'Gantt';
  FGanttConfig1.Cols[0].GanttDataUnits := 'd';
  FGanttConfig1.Cols[0].GanttUnits := 'd';
  FGanttConfig1.Cols[0].GanttLastUnit := 'd'; //Start 와 EndDate가 동일할 경우 마일스톤 아이콘으로 보이지 않음
  FGanttConfig1.Cols[0].GanttWidth := '16';
  FGanttConfig1.Cols[0].GanttAncestors := 'ANC';
  FGanttConfig1.Cols[0].GanttDescendants := 'DEC';
  FGanttConfig1.Cols[0].GanttStart := 'START';
  FGanttConfig1.Cols[0].GanttEnd := 'ENDDATE';
  FGanttConfig1.Cols[0].GanttDuration := 'DUR';
  FGanttConfig1.Cols[0].GanttComplete := 'COMP';
  FGanttConfig1.Cols[0].GanttParts := 'PARTS';
//  FGanttConfig1.Cols[0].GanttMinStart := 'ES';
//  FGanttConfig1.Cols[0].GanttMaxEnd := 'LFinish';
  FGanttConfig1.Cols[0].GanttLeft := '1';
  FGanttConfig1.Cols[0].GanttRight := '1';
  FGanttConfig1.Cols[0].GanttCount := 3;  //이 값이 0이면 debug 창에 '-' undefined 에러 남
  FGanttConfig1.Cols[0].GanttStart1 := 'START1';
  FGanttConfig1.Cols[0].GanttEnd1 := 'ENDDATE1';
  FGanttConfig1.Cols[0].GanttDuration1 := 'DUR1';
  FGanttConfig1.Cols[0].GanttTop1 := '15';
  FGanttConfig1.Cols[0].GanttClass1 := 'Maroon';

  FGanttConfig1.Cols[0].GanttStart2 := 'START2';
  FGanttConfig1.Cols[0].GanttEnd2 := 'ENDDATE2';
  FGanttConfig1.Cols[0].GanttDuration2 := 'DUR2';
  FGanttConfig1.Cols[0].GanttTop2 := '30';
  FGanttConfig1.Cols[0].GanttClass2 := 'Navy';
                 //w: 주단위,  d: 일단위 #
  FGanttConfig1.Cols[0].GanttHeader1 := 'w#yyyy년 M월 ddddddd 주';
  FGanttConfig1.Cols[0].GanttHeader2 := 'd#dd';
//  FGanttConfig1.Cols[0].GanttHeader3 := 'd#ddddd';
  FGanttConfig1.Cols[0].GanttCorrectDependencies := '0';
//  FGanttConfig1.Cols[0].GanttResources := 'RES';
//  FGanttConfig1.Cols[0].GanttResourcesAssign := '4';
//  FGanttConfig1.Cols[0].GanttResourcesExtra := '3';
  FGanttConfig1.Cols[0].GanttText := 'BIGO';
  FGanttConfig1.Cols[0].GanttFlags := 'FLAGS';
  FGanttConfig1.Cols[0].GanttFlagTexts := 'BIGO';
  FGanttConfig1.Cols[0].GanttFlagIcons := 'ICONS';
//  FGanttConfig1.Cols[0].GanttZoomFit := 3;
//  FGanttConfig1.Cols[0].GanttZoom := '@@@';

//  LStr := FormatDateTime('m/d/yyyy', AExecludeFrom);
//  LStr := 'w#' + LStr + '~' + FormatDateTime('m/d/yyyy', AExcludeTo) + '#1';
//  FGanttConfig1.Cols[0].GanttExclude := LStr;//'w#mm/dd/yyyy~mm/dd/yyyy#3';
  LStr := DM1.GetGanttExclude(AExecludeFrom,AExcludeTo);
//  FGanttConfig1.Cols[0].GanttExclude := 'w#1/5/2015~1/7/2015#1;' + LStr;//y#9/14/2016~9/15/2016#1';
  FGanttConfig1.Cols[0].GanttExclude := LStr;
  FGanttConfig1.Cols[0].GanttCheckExclude := 0;
  FormatSettings.DateSeparator := '/';
  FGanttConfig1.Cols[0].GanttLines := '8#' + FormatDateTime('mm/dd/yyyy', now) + '#Red'; //오늘 날짜 빨간줄 표시

  SetLength(FGanttConfig1.Def, 3);

  FGanttConfig1.Def[0].Name := 'SUM';
  FGanttConfig1.Def[0].Calculated := '1';
  FGanttConfig1.Def[0].CalcOrder := 'START,ENDDATE,DUR,COMP,PARTS';
  FGanttConfig1.Def[0].STARTFormula := 'ganttstart()';
  FGanttConfig1.Def[0].ENDDATEFormula := 'ganttend()';
  FGanttConfig1.Def[0].DURFormula := 'ganttduration()';
  FGanttConfig1.Def[0].COMPFormula := 'ganttpercent()';
  FGanttConfig1.Def[0].PARTSFormula := 'ganttparts()';
  FGanttConfig1.Def[0].GANTTGanttClass := 'Olive';
  FGanttConfig1.Def[0].GANTTGanttIcons := '1';
  FGanttConfig1.Def[0].GANTTGanttEdit := 'all';//'@@@';
  FGanttConfig1.Def[0].CanEdit := '0';
  FGanttConfig1.Def[0].DefEmpty := '@@@';
  FGanttConfig1.Def[0].DefParent := '@@@';
  FGanttConfig1.Def[0].START1Formula := 'ganttstart()';
  FGanttConfig1.Def[0].ENDDATE1Formula := 'ganttend()';
  FGanttConfig1.Def[0].DUR1Formula := 'ganttduration()';
  FGanttConfig1.Def[0].COMP1Formula := 'ganttpercent()';
  FGanttConfig1.Def[0].PARTS1Formula := 'ganttparts()';
  FGanttConfig1.Def[0].START2Formula := 'ganttstart()';
  FGanttConfig1.Def[0].ENDDATE2Formula := 'ganttend()';
  FGanttConfig1.Def[0].DUR2Formula := 'ganttduration()';
  FGanttConfig1.Def[0].COMP2Formula := 'ganttpercent()';
  FGanttConfig1.Def[0].PARTS2Formula := 'ganttparts()';

  FGanttConfig1.Def[1].Name := 'SUMEDIT';
  FGanttConfig1.Def[1].Def := 'SUM';
//  FGanttConfig1.Def[1].PARTSFormula := 'sumparts()';  //이부분을 살리면 일정이 빈곳은 분리되어 표시 됨
  FGanttConfig1.Def[1].GANTTGanttSummary := '0';
  FGanttConfig1.Def[1].STARTCanEdit := '1';
  FGanttConfig1.Def[1].GANTTGanttClass := 'Group';
  FGanttConfig1.Def[1].GANTTGanttIcons := '1';
  FGanttConfig1.Def[1].GANTTGanttEdit := 'all';
//  FGanttConfig1.Def[1].DURFormula := 'ganttduration()';
  FGanttConfig1.Def[1].CanEdit := '0';
  FGanttConfig1.Def[1].DefEmpty := 'R';
  FGanttConfig1.Def[1].Expanded := '0';
  FGanttConfig1.Def[1].DefParent := 'SUMEDIT';

  FGanttConfig1.Def[2].Name := 'R';
  FGanttConfig1.Def[2].DefEmpty := 'R';
  FGanttConfig1.Def[2].DefParent := 'SUMEDIT';

  FGanttConfig1.Header.id := 'Header';//세부공정번호';
  FGanttConfig1.Header.Process := '공사번호/공정구분/세부공정';
  FGanttConfig1.Header.START := '착수일(계획)';
  FGanttConfig1.Header.ENDDATE := '완료일(계획)';
  FGanttConfig1.Header.START1 := '착수일(수정)';
  FGanttConfig1.Header.ENDDATE1 := '완료일(수정)';
  FGanttConfig1.Header.START2 := '착수일(실적)';
  FGanttConfig1.Header.ENDDATE2 := '완료일(실적)';
  FGanttConfig1.Header.COMP := '달성율';
  FGanttConfig1.Header.PARTS := 'Descrete parts of the task';
  FGanttConfig1.Header.DUR := '소요일';
  FGanttConfig1.Header.ANC := '선행공정';
  FGanttConfig1.Header.DEC := '후행공정';
  FGanttConfig1.Header.ES := '최소 시작일';
  FGanttConfig1.Header.LFinish := '최대 종료일';
  FGanttConfig1.Header.ENDTip := 'End Date';
  FGanttConfig1.Header.COMPTip := 'Percentage Complete';
  FGanttConfig1.Header.PARTSTip := 'Descrete parts of the task';
  FGanttConfig1.Header.DURTip := 'Duration';
  FGanttConfig1.Header.ANCTip := 'Ancestors (predecessors)';
  FGanttConfig1.Header.ESTip := 'Early start constraint';
  FGanttConfig1.Header.LFTip := 'Late finish constraint';
  FGanttConfig1.Header.SortIcons := '0';

//  FGanttConfig1.Resources.Name := '0';

  Result := Utf8ToString(RecordSaveJson(FGanttConfig1, TypeInfo(TTGGanttConfig)));
end;

function TGanttForm.GetVar2TGConfig1(ATGGanttConfig: TTGGanttConfig): string;
var
  V: variant;
  LStr: string;
begin
  LStr := Utf8ToString(RecordSaveJson(ATGGanttConfig, TypeInfo(TTGGanttConfig)));
  V := _JSon(LStr,[dvoSerializeAsExtendedJson]);
  FGanttConfigString := V;
  FGanttConfigString := StringReplace(FGanttConfigString, 'F_Type', 'Type', [rfReplaceAll]);
  FGanttConfigString := StringReplace(FGanttConfigString, '@@@', '', [rfReplaceAll]);
  Result := FGanttConfigString;
end;

function TGanttForm.GetVar2TGGanttChanges1(
  ATGGanttChanges: TTGGanttChanges): string;
var
  V: variant;
  LStr: string;
begin
  LStr := Utf8ToString(RecordSaveJson(ATGGanttChanges, TypeInfo(TTGGanttChanges)));
  V := _JSon(LStr,[dvoSerializeAsExtendedJson]);
  Result := V;
end;

{ TCustomRenderProcessHandler }

function getpath(const n: ICefDomNode): string;
begin
  Result := '<' + n.Name + '>';
  if (n.Parent <> nil) then
    Result := getpath(n.Parent) + Result;
end;

function TCustomRenderProcessHandler.OnProcessMessageReceived(
  const browser: ICefBrowser; sourceProcess: TCefProcessId;
  const message: ICefProcessMessage): Boolean;
begin
{$IFDEF DELPHI14_UP}
  if (message.Name = 'visitdom') then
    begin
      browser.MainFrame.VisitDomProc(
        procedure(const doc: ICefDomDocument) begin
          doc.Body.AddEventListenerProc('mouseover', True,
            procedure (const event: ICefDomEvent)
            var
              msg: ICefProcessMessage;
            begin
              msg := TCefProcessMessageRef.New('mouseover');
              msg.ArgumentList.SetString(0, getpath(event.Target));
              browser.SendProcessMessage(PID_BROWSER, msg);
            end)
        end);
        Result := True;
    end
  else
{$ENDIF}
    Result := False;
end;

procedure TCustomRenderProcessHandler.OnWebKitInitialized;
begin
{$IFDEF DELPHI14_UP}
  TCefRTTIExtension.Register('app', TTestExtension);
{$ENDIF}
  TCefRTTIExtension.Register('myclass', Test);
end;

{ TTestExtension }

class function TTestExtension.hello: string;
begin
  Result := 'Hello from Delphi';
end;

{ TMyClass }

function TMyClass.GetValue: string;
begin
  Result := 'This is the result from the getter: ' + FValue;
end;

procedure TMyClass.SetValue(Value: string);
begin
  if (Value <> FValue) then
  begin
    // set the Value and do anything you want.
    FValue := Value;

    ShowMessage('JavaScript tells us the following: ' + FValue);

    FValue := FValue + ' This is a modification from Delphi!';

  end;
end;

{ TMyHandler }

function TMyHandler.Execute(const name: ustring; const obj: ICefv8Value;
  const arguments: TCefv8ValueArray; var retval: ICefv8Value;
  var exception: ustring): Boolean;
begin
  ShowMessage('Execute!');
end;

initialization
  CefRemoteDebuggingPort := 9000;
  CefRenderProcessHandler := TCustomRenderProcessHandler.Create;
  CefBrowserProcessHandler := TCefBrowserProcessHandlerOwn.Create;
  //RegisterExtension;
  test := TMyClass.Create;
end.
