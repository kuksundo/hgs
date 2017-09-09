unit UnitSTOMP4EquipMonitor;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, UnitSTOMPClass, UnitWorker4OmniMsgQ,
  Vcl.Menus, Vcl.ComCtrls, Vcl.StdCtrls, Vcl.ExtCtrls, UnitMQConfig,
  QProgress, Kit, cyBasePanel, cyPanel,
  AdvOfficePager, OtlParallel, OtlTaskControl, UnitEquipStatusClass, UnitSTOMPMsg.Events;

const
  MQ_TOPIC = '/topic/IoT_Crank1_EquipStatus';

type
  TForm8 = class(TForm)
    Panel1: TPanel;
    AdvOfficePager1: TAdvOfficePager;
    LayOutPage1: TAdvOfficePage;
    Memo1: TMemo;
    GridPanel1: TGridPanel;
    CyPanel1: TCyPanel;
    CyPanel2: TCyPanel;
    CyPanel3: TCyPanel;
    Panel250: TPanel;
    Panel251: TPanel;
    K_396: TKit;
    Panel253: TPanel;
    NO_396: TPanel;
    Panel256: TPanel;
    Panel257: TPanel;
    Q_396: TQProgress;
    RT_396: TPanel;
    CyPanel4: TCyPanel;
    CyPanel5: TCyPanel;
    Panel240: TPanel;
    Panel241: TPanel;
    K_389: TKit;
    Panel243: TPanel;
    NO_389: TPanel;
    Panel246: TPanel;
    Panel247: TPanel;
    Q_389: TQProgress;
    RT_389: TPanel;
    CyPanel6: TCyPanel;
    Panel230: TPanel;
    Panel231: TPanel;
    K_358: TKit;
    Panel233: TPanel;
    NO_358: TPanel;
    Panel236: TPanel;
    Panel237: TPanel;
    Q_358: TQProgress;
    RT_358: TPanel;
    CyPanel7: TCyPanel;
    Panel220: TPanel;
    Panel221: TPanel;
    K_387: TKit;
    Panel223: TPanel;
    NO_387: TPanel;
    Panel226: TPanel;
    Panel227: TPanel;
    Q_387: TQProgress;
    RT_387: TPanel;
    CyPanel8: TCyPanel;
    Panel210: TPanel;
    Panel211: TPanel;
    K_393: TKit;
    Panel213: TPanel;
    NO_393: TPanel;
    Panel216: TPanel;
    Panel217: TPanel;
    Q_393: TQProgress;
    RT_393: TPanel;
    CyPanel9: TCyPanel;
    Panel200: TPanel;
    Panel201: TPanel;
    K_351: TKit;
    Panel203: TPanel;
    NO_351: TPanel;
    Panel206: TPanel;
    Panel207: TPanel;
    Q_351: TQProgress;
    RT_351: TPanel;
    CyPanel10: TCyPanel;
    Panel190: TPanel;
    Panel191: TPanel;
    K_392: TKit;
    Panel193: TPanel;
    NO_392: TPanel;
    Panel196: TPanel;
    Panel197: TPanel;
    Q_392: TQProgress;
    RT_392: TPanel;
    CyPanel11: TCyPanel;
    CyPanel12: TCyPanel;
    Panel180: TPanel;
    Panel181: TPanel;
    K_391: TKit;
    Panel183: TPanel;
    NO_391: TPanel;
    Panel186: TPanel;
    Panel187: TPanel;
    Q_391: TQProgress;
    RT_391: TPanel;
    CyPanel13: TCyPanel;
    Panel170: TPanel;
    Panel171: TPanel;
    K_394: TKit;
    Panel173: TPanel;
    NO_394: TPanel;
    Panel176: TPanel;
    Panel177: TPanel;
    Q_394: TQProgress;
    RT_394: TPanel;
    CyPanel14: TCyPanel;
    CyPanel15: TCyPanel;
    Panel260: TPanel;
    Panel261: TPanel;
    Kit25: TKit;
    Panel263: TPanel;
    Panel262: TPanel;
    Panel266: TPanel;
    Panel267: TPanel;
    QProgress10: TQProgress;
    Panel269: TPanel;
    CyPanel17: TCyPanel;
    Panel72: TPanel;
    Panel84: TPanel;
    K_259: TKit;
    Panel101: TPanel;
    NO_259: TPanel;
    Panel121: TPanel;
    Panel126: TPanel;
    Q_259: TQProgress;
    RT_259: TPanel;
    CyPanel16: TCyPanel;
    Panel159: TPanel;
    Panel160: TPanel;
    K_258: TKit;
    Panel162: TPanel;
    NO_258: TPanel;
    Panel165: TPanel;
    Panel166: TPanel;
    Q_258: TQProgress;
    RT_258: TPanel;
    CyPanel18: TCyPanel;
    Panel145: TPanel;
    Panel147: TPanel;
    K_253: TKit;
    Panel149: TPanel;
    NO_253: TPanel;
    Panel155: TPanel;
    Panel156: TPanel;
    Q_253: TQProgress;
    RT_253: TPanel;
    CyPanel19: TCyPanel;
    Panel119: TPanel;
    Panel120: TPanel;
    K_252: TKit;
    Panel122: TPanel;
    NO_252: TPanel;
    Panel135: TPanel;
    Panel136: TPanel;
    Q_252: TQProgress;
    RT_252: TPanel;
    CyPanel20: TCyPanel;
    Panel109: TPanel;
    Panel110: TPanel;
    K_251: TKit;
    Panel112: TPanel;
    NO_251: TPanel;
    Panel115: TPanel;
    Panel116: TPanel;
    Q_251: TQProgress;
    RT_251: TPanel;
    CyPanel21: TCyPanel;
    CyPanel22: TCyPanel;
    Panel99: TPanel;
    Panel100: TPanel;
    K_388: TKit;
    Panel102: TPanel;
    NO_388: TPanel;
    Panel105: TPanel;
    Panel106: TPanel;
    Q_388: TQProgress;
    RT_388: TPanel;
    CyPanel23: TCyPanel;
    Panel82: TPanel;
    Panel83: TPanel;
    K_385: TKit;
    Panel85: TPanel;
    NO_385: TPanel;
    Panel90: TPanel;
    Panel91: TPanel;
    Q_385: TQProgress;
    RT_385: TPanel;
    CyPanel24: TCyPanel;
    Panel70: TPanel;
    Panel71: TPanel;
    K_384: TKit;
    Panel73: TPanel;
    NO_384: TPanel;
    Panel76: TPanel;
    Panel78: TPanel;
    Q_384: TQProgress;
    RT_384: TPanel;
    CyPanel25: TCyPanel;
    Panel124: TPanel;
    Panel125: TPanel;
    K_399: TKit;
    Panel127: TPanel;
    NO_399: TPanel;
    Panel130: TPanel;
    Panel131: TPanel;
    Q_399: TQProgress;
    RT_399: TPanel;
    CyPanel26: TCyPanel;
    CyPanel27: TCyPanel;
    Panel139: TPanel;
    Panel140: TPanel;
    K_327: TKit;
    Panel142: TPanel;
    NO_327: TPanel;
    Panel146: TPanel;
    Panel150: TPanel;
    Q_327: TQProgress;
    RT_327: TPanel;
    CyPanel28: TCyPanel;
    CyPanel29: TCyPanel;
    CyPanel30: TCyPanel;
    Panel270: TPanel;
    Panel271: TPanel;
    K_386: TKit;
    Panel273: TPanel;
    NO_386: TPanel;
    Panel276: TPanel;
    Panel277: TPanel;
    Q_386: TQProgress;
    RT_386: TPanel;
    LayOutPage2: TAdvOfficePage;
    GridPanel2: TGridPanel;
    CyPanel31: TCyPanel;
    CyPanel32: TCyPanel;
    CyPanel33: TCyPanel;
    CyPanel34: TCyPanel;
    CyPanel35: TCyPanel;
    CyPanel36: TCyPanel;
    CyPanel37: TCyPanel;
    CyPanel38: TCyPanel;
    CyPanel39: TCyPanel;
    CyPanel40: TCyPanel;
    CyPanel41: TCyPanel;
    CyPanel42: TCyPanel;
    CyPanel46: TCyPanel;
    CyPanel47: TCyPanel;
    CyPanel48: TCyPanel;
    CyPanel49: TCyPanel;
    CyPanel50: TCyPanel;
    CyPanel51: TCyPanel;
    CyPanel52: TCyPanel;
    Panel392: TPanel;
    Panel393: TPanel;
    K_294: TKit;
    Panel395: TPanel;
    NO_294: TPanel;
    Panel398: TPanel;
    Panel399: TPanel;
    Q_294: TQProgress;
    RT_294: TPanel;
    CyPanel53: TCyPanel;
    CyPanel54: TCyPanel;
    CyPanel55: TCyPanel;
    Panel382: TPanel;
    Panel383: TPanel;
    K_339: TKit;
    Panel385: TPanel;
    NO_339: TPanel;
    Panel388: TPanel;
    Panel389: TPanel;
    Q_339: TQProgress;
    RT_339: TPanel;
    CyPanel56: TCyPanel;
    CyPanel57: TCyPanel;
    GridPanel3: TGridPanel;
    CyPanel65: TCyPanel;
    CyPanel66: TCyPanel;
    CyPanel67: TCyPanel;
    CyPanel68: TCyPanel;
    CyPanel69: TCyPanel;
    CyPanel70: TCyPanel;
    CyPanel71: TCyPanel;
    Panel361: TPanel;
    Panel362: TPanel;
    K_322: TKit;
    Panel364: TPanel;
    NO_322: TPanel;
    Panel367: TPanel;
    Panel368: TPanel;
    Q_322: TQProgress;
    RT_322: TPanel;
    CyPanel72: TCyPanel;
    CyPanel73: TCyPanel;
    Panel351: TPanel;
    Panel352: TPanel;
    K_342: TKit;
    Panel354: TPanel;
    NO_342: TPanel;
    Panel357: TPanel;
    Panel358: TPanel;
    Q_342: TQProgress;
    RT_342: TPanel;
    CyPanel74: TCyPanel;
    CyPanel75: TCyPanel;
    Panel341: TPanel;
    Panel342: TPanel;
    K_350: TKit;
    Panel344: TPanel;
    NO_350: TPanel;
    Panel347: TPanel;
    Panel348: TPanel;
    Q_350: TQProgress;
    RT_350: TPanel;
    CyPanel76: TCyPanel;
    Panel331: TPanel;
    Panel332: TPanel;
    K_257: TKit;
    Panel334: TPanel;
    NO_257: TPanel;
    Panel337: TPanel;
    Panel338: TPanel;
    Q_257: TQProgress;
    RT_257: TPanel;
    CyPanel77: TCyPanel;
    Panel321: TPanel;
    Panel322: TPanel;
    K_254: TKit;
    Panel324: TPanel;
    NO_254: TPanel;
    Panel327: TPanel;
    Panel328: TPanel;
    Q_254: TQProgress;
    RT_254: TPanel;
    CyPanel78: TCyPanel;
    CyPanel79: TCyPanel;
    Panel311: TPanel;
    Panel312: TPanel;
    K_341: TKit;
    Panel314: TPanel;
    NO_341: TPanel;
    Panel317: TPanel;
    Panel318: TPanel;
    Q_341: TQProgress;
    RT_341: TPanel;
    CyPanel80: TCyPanel;
    CyPanel81: TCyPanel;
    CyPanel82: TCyPanel;
    CyPanel83: TCyPanel;
    Panel372: TPanel;
    Panel373: TPanel;
    K_344: TKit;
    Panel375: TPanel;
    NO_344: TPanel;
    Panel378: TPanel;
    Panel379: TPanel;
    Q_344: TQProgress;
    RT_344: TPanel;
    CyPanel84: TCyPanel;
    CyPanel85: TCyPanel;
    Panel302: TPanel;
    Panel303: TPanel;
    K_345: TKit;
    Panel305: TPanel;
    NO_345: TPanel;
    Panel308: TPanel;
    Panel309: TPanel;
    Q_345: TQProgress;
    RT_345: TPanel;
    CyPanel86: TCyPanel;
    CyPanel87: TCyPanel;
    CyPanel88: TCyPanel;
    Panel292: TPanel;
    Panel293: TPanel;
    K_325: TKit;
    Panel295: TPanel;
    NO_325: TPanel;
    Panel298: TPanel;
    Panel299: TPanel;
    Q_325: TQProgress;
    RT_325: TPanel;
    CyPanel89: TCyPanel;
    CyPanel90: TCyPanel;
    Panel282: TPanel;
    Panel283: TPanel;
    K_346: TKit;
    Panel285: TPanel;
    NO_346: TPanel;
    Panel288: TPanel;
    Panel289: TPanel;
    Q_346: TQProgress;
    RT_346: TPanel;
    CyPanel91: TCyPanel;
    CyPanel92: TCyPanel;
    CyPanel93: TCyPanel;
    CyPanel94: TCyPanel;
    CyPanel95: TCyPanel;
    CyPanel96: TCyPanel;
    CyPanel97: TCyPanel;
    Panel432: TPanel;
    Panel433: TPanel;
    K_324: TKit;
    Panel435: TPanel;
    NO_324: TPanel;
    Panel438: TPanel;
    Panel439: TPanel;
    Q_324: TQProgress;
    RT_324: TPanel;
    CyPanel98: TCyPanel;
    AdvOfficePager12: TAdvOfficePage;
    Splitter2: TSplitter;
    Splitter3: TSplitter;
    Panel66: TPanel;
    Panel77: TPanel;
    Panel80: TPanel;
    Panel86: TPanel;
    Panel89: TPanel;
    InComP2ActivePnl: TPanel;
    Panel92: TPanel;
    Panel93: TPanel;
    Panel94: TPanel;
    InComP2ReActivePnl: TPanel;
    Panel96: TPanel;
    Panel97: TPanel;
    Panel2: TPanel;
    Panel3: TPanel;
    Panel4: TPanel;
    Panel5: TPanel;
    Panel6: TPanel;
    Panel7: TPanel;
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
    Panel20: TPanel;
    Panel21: TPanel;
    Panel22: TPanel;
    Panel23: TPanel;
    Panel24: TPanel;
    Panel25: TPanel;
    Panel26: TPanel;
    Panel27: TPanel;
    Panel28: TPanel;
    Panel29: TPanel;
    Panel30: TPanel;
    Panel31: TPanel;
    Panel32: TPanel;
    Panel33: TPanel;
    Panel34: TPanel;
    Panel35: TPanel;
    Panel36: TPanel;
    Panel37: TPanel;
    Panel38: TPanel;
    Panel39: TPanel;
    Panel40: TPanel;
    Panel41: TPanel;
    Panel42: TPanel;
    Panel43: TPanel;
    Panel44: TPanel;
    Panel45: TPanel;
    Panel46: TPanel;
    Panel47: TPanel;
    Panel48: TPanel;
    Panel49: TPanel;
    Panel50: TPanel;
    Panel51: TPanel;
    Panel52: TPanel;
    Panel53: TPanel;
    Panel54: TPanel;
    Panel55: TPanel;
    Panel56: TPanel;
    Panel57: TPanel;
    Panel58: TPanel;
    Panel59: TPanel;
    Panel60: TPanel;
    Panel61: TPanel;
    Panel62: TPanel;
    Panel63: TPanel;
    Panel64: TPanel;
    Panel65: TPanel;
    Panel67: TPanel;
    Splitter4: TSplitter;
    Panel68: TPanel;
    Splitter5: TSplitter;
    AdvOfficePage1: TAdvOfficePage;
    Panel69: TPanel;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    MQServerIPEdit: TEdit;
    MQServerPortEdit: TEdit;
    TopicEdit: TEdit;
    Memo2: TMemo;
    StatusBar1: TStatusBar;
    MainMenu1: TMainMenu;
    File1: TMenuItem;
    Close1: TMenuItem;
    Option1: TMenuItem;
    Config1: TMenuItem;
    Etc1: TMenuItem;
    EquipList1: TMenuItem;
    Panel74: TPanel;
    Panel75: TPanel;
    Panel79: TPanel;
    Panel81: TPanel;
    Panel87: TPanel;
    RunPanel: TPanel;
    DisconnectPanel: TPanel;
    Panel98: TPanel;
    StopPanel: TPanel;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure Config1Click(Sender: TObject);
    procedure Close1Click(Sender: TObject);
    procedure EquipList1Click(Sender: TObject);
  private
    FpjhSTOMPClass: TpjhSTOMPClass;
    FExeFilePath: string;
    FIniFileName: string;
    FIsDestroying: Boolean;
    FParamFileNameChanged: Boolean;
    FEquipStatusInfo: TEquipStatusInfo;
    FIsSyncProcEnter: Boolean;//

    procedure InitVar;
    procedure FinalizeVar;
    procedure InitSTOMP(AUserId, APasswd, AServerIP, ATopic: string; APort: string = '');
    procedure DestroySTOMP;
    procedure InitEquipRunComponent;
    procedure FinalizeEquipRunComponent;

    procedure WorkerResult(var msg: TMessage); message MSG_RESULT;
    procedure ProcessSubscribeMsg;
    procedure SendData2MQ(AMsg: string; ATopic: string = '');
    procedure Syncro_Main(AMsgEvent: TSTOMPMsgEvent);
    procedure AdjustEquipStatus(AEquipNo, AStatus: string);
    procedure SetRunComponent(ACompName: string = ''; AValue: string = '');
    procedure SetCommComponent(ACompName, AValue: string);
    function GetEquipNo(ATopic: string): string;

    procedure GetCollectFromSTOMP;
    procedure OnGetCollectFromSTOMPCompleted(const task: IOmniTaskControl);

    procedure LoadConfigFromFile(AFileName: string = '');
    procedure LoadConfig2Form(AForm: TConfigF);
    procedure LoadConfigForm2Object(AForm: TConfigF);
    procedure SetConfig;
    procedure ApplyUI;
    procedure DispConfigData;
    procedure DisplayMessage2Memo(msg: string; ADest: integer);
    procedure DisplayEquipList2Grid;
  public
    FSettings : TConfigSettings;
  end;

var
  Form8: TForm8;

implementation

uses otlcomm, OtlCommon, StompTypes, UnitSTOMPMsg.EventThreads,
  SynCommons, UnitEquipList;

{$R *.dfm}

type
  TRGB = record
      R: Integer;
      G: Integer;
      B: Integer;
  end;

  THLS = record
      H: Integer;
      L: Integer;
      S: Integer;
  end;

  THSV = record
      H: Integer;
      S: Integer;
      V: Integer;
  end;

function ColorToRGB(PColor: TColor): TRGB;
var
  i: Integer;
begin
  i := PColor;
  Result.R := 0;
  Result.G := 0;
  Result.B := 0;

  while i - 65536 >= 0 do
  begin
    i := i - 65536;
    Result.B := Result.B + 1;
  end;

  while i - 256 >= 0 do
  begin
    i := i - 256;
    Result.G := Result.G + 1;
  end;

  Result.R := i;
end;

function CalcComplementalColor(AColor: TColor): TColor;
var
  LRGB: TRGB;
  LHLS: THLS;
begin
  LRGB := ColorToRGB(AColor);

  if AColor >= 0 then
    Result := RGB((255-LRGB.R),(255-LRGB.G),(255-LRGB.B))
  else
    Result := $00ffffff;
end;

procedure TForm8.AdjustEquipStatus(AEquipNo, AStatus: string);
var
  idx,iNum,iPreLen: Integer;
  wCtrl: TWinControl;
begin
  SetRunComponent(AEquipNo, AStatus);

  RunPanel.Caption := IntToStr(FEquipStatusInfo.EquipStatusCollect.GetRunStatusEquipCount('1'));
  StopPanel.Caption := IntToStr(FEquipStatusInfo.EquipStatusCollect.GetRunStatusEquipCount('0'));
  DisconnectPanel.Caption := IntToStr(FEquipStatusInfo.EquipStatusCollect.GetDisconnectedEquipCount);
end;

procedure TForm8.ApplyUI;
begin
  DispConfigData;
end;

procedure TForm8.Close1Click(Sender: TObject);
begin
  Close;
end;

procedure TForm8.Config1Click(Sender: TObject);
begin
  SetConfig;
end;

procedure TForm8.DestroySTOMP;
begin
  if Assigned(FpjhSTOMPClass) then
    FpjhSTOMPClass.Free;
end;

procedure TForm8.DispConfigData;
begin
  MQServerIPEdit.Text := FSettings.MQServerIP;
  MQServerPortEdit.Text := FSettings.MQServerPort;
  TopicEdit.Text := FSettings.MQServerTopic;
end;

procedure TForm8.DisplayEquipList2Grid;
begin
  Create_EquipList_Frm(FEquipStatusInfo);
end;

procedure TForm8.DisplayMessage2Memo(msg: string; ADest: integer);
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
        if Lines.Count > 100 then
          Clear;
        Lines.Add(DateTimeToStr(now) + ' :: ' + msg);
      end;//with
    end;//dtSystemLog
  end;//case
end;

procedure TForm8.EquipList1Click(Sender: TObject);
begin
  DisplayEquipList2Grid;
end;

procedure TForm8.FinalizeEquipRunComponent;
var
  i: integer;
begin
  for i := 0 to FEquipStatusInfo.EquipStatusCollect.Count - 1 do
  begin
    if Assigned(FEquipStatusInfo.EquipStatusCollect.Items[i].CommComponent) then
      TKit(FEquipStatusInfo.EquipStatusCollect.Items[i].CommComponent).TimerEnable := False;

    if Assigned(FEquipStatusInfo.EquipStatusCollect.Items[i].RunComponent) then
      TQProgress(FEquipStatusInfo.EquipStatusCollect.Items[i].RunComponent).Active := False;
  end;
end;

procedure TForm8.FinalizeVar;
begin
  DestroySTOMP;
  FinalizeEquipRunComponent;
  FSettings.Free;
  FEquipStatusInfo.Free;
end;

procedure TForm8.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  FIsDestroying := True;
end;

procedure TForm8.FormCreate(Sender: TObject);
begin
  InitVar;
end;

procedure TForm8.FormDestroy(Sender: TObject);
begin
  FinalizeVar;
end;

procedure TForm8.GetCollectFromSTOMP;
var
  msg: TOmniMessage;
  FStompFrame: IStompFrame;
  LJSon: string;
  LUtf8: RawUTF8;
  LValue: TEquipRunStatusRecord;
  LUrl, LUrlOk: string;
  LESItem: TEquipStatusItem;
  i: integer;
begin
  while FpjhSTOMPClass.GetResponseQMsg(msg) do
  begin
    FStompFrame := msg.MsgData.AsInterface as IStompFrame;
    LJSon := FStompFrame.GetBody;

    LUtf8 := StringToUTF8(LJSon);
    RecordLoadJSON(LValue, pointer(LUtf8), TypeInfo(TEquipRunStatusRecord));
    FEquipStatusInfo.SetCollectFromRecord(LValue);

    TSTOMPMsgEvent.Create(MQ_TOPIC, LJSon, 4).Queue;
  end;
end;

function TForm8.GetEquipNo(ATopic: string): string;
var
  LStrList: TStringList;
begin
  Result := '';
///dev/mc/xxx/ 형태로 들어옴
  LStrList := TStringList.Create;
  try
    ExtractStrings(['/'], [], PChar(ATopic), LStrList);

    if LStrList.Count > 2 then
      Result := LStrList.Strings[2]
    else;
///     TSTOMPMsgEvent.Create('', 'GetEquipNo -> Topic Error : ' + ATopic).Queue;

  finally
    LStrList.Free;
  end;
end;

procedure TForm8.InitEquipRunComponent;
var
  LESItem: TEquipStatusItem;
  i: integer;
  LComponent: TComponent;
  LTriggerName: string;
begin
  FEquipStatusInfo.EquipStatusCollect.Clear;

  for i := Low(EquipNameAry) to High(EquipNameAry) do
  begin
    LESItem := FEquipStatusInfo.EquipStatusCollect.Add;
    LESItem.EquipName := EquipNameAry[i];
    LComponent := nil;
    LComponent := FindComponent('Q_' + EquipNameAry[i]);//TQProgress

    if Assigned(LComponent) then
      LESItem.RunComponent := LComponent;

    LComponent := nil;
    LComponent := FindComponent('RT_' + EquipNameAry[i]);//TPanel(Run Text 표시)

    if Assigned(LComponent) then
      LESItem.RunTextComponent := LComponent;

    LComponent := nil;
    LComponent := FindComponent('K_' + EquipNameAry[i]);//Tkit

    if Assigned(LComponent) then
    begin
      LESItem.CommComponent := LComponent;
      TKit(LComponent).ShowHint := True;
    end;

    LComponent := nil;
    LComponent := FindComponent('NO_' + EquipNameAry[i]);//TPanel

    if Assigned(LComponent) then
      LESItem.EquipNoComponent := LComponent;
  end;
end;

procedure TForm8.InitSTOMP(AUserId, APasswd, AServerIP, ATopic: string; APort: string);
begin
//  if APort = '' then

  if not Assigned(FpjhSTOMPClass) then
  begin
    FpjhSTOMPClass := TpjhSTOMPClass.CreateWithStr(AUserId,
                                            APasswd,
                                            AServerIP,
                                            ATopic,
                                            Self.Handle);
   STOMPMsgEventThread.SetSynchroProc(Syncro_Main);
  end;
end;

procedure TForm8.InitVar;
var
  LStr: string;
begin
  FExeFilePath := ExtractFilePath(Application.ExeName);
  FIniFileName := '';

  if ParamCount > 0 then
  begin
    LStr := UpperCase(ParamStr(1));
    if POS('/F', LStr) > 0 then  //FIniFileName 설정
    begin
      Delete(LStr,1,2);

      if POS(':\', LStr) = 0 then
        LStr := '.\' + LStr;

      FIniFileName := LStr;
    end;
  end;

  if FIniFileName = '' then
    FIniFileName := ChangeFileExt(Application.ExeName, '.ini');

  FSettings := TConfigSettings.create(FIniFileName);
  LoadConfigFromFile;

  FEquipStatusInfo := TEquipStatusInfo.Create(Self);
  FEquipStatusInfo.InitEquipStatusInfo;
  InitEquipRunComponent;

  STOMPMsgEventThread.SetDisplayMsgProc(DisplayMessage2Memo);
  InitSTOMP(FSettings.MQServerUserId,FSettings.MQServerPasswd,FSettings.MQServerIP,FSettings.MQServerTopic);
end;

procedure TForm8.LoadConfig2Form(AForm: TConfigF);
begin
  FSettings.LoadConfig2Form(AForm, FSettings);
end;

procedure TForm8.LoadConfigForm2Object(AForm: TConfigF);
begin
  FSettings.LoadConfigForm2Object(AForm, FSettings);
end;

procedure TForm8.LoadConfigFromFile(AFileName: string);
begin
  FSettings.Load(AFileName);

  if FSettings.MQServerIP = '' then
    FSettings.MQServerIP := '127.0.0.1';

  if FSettings.MQServerTopic = '' then
    FSettings.MQServerTopic := MQ_TOPIC;

  ApplyUI;
end;

procedure TForm8.OnGetCollectFromSTOMPCompleted(const task: IOmniTaskControl);
begin

end;

procedure TForm8.ProcessSubscribeMsg;
begin
  Parallel.Async(GetCollectFromSTOMP, Parallel.TaskConfig.OnTerminated(OnGetCollectFromSTOMPCompleted));
end;

procedure TForm8.SendData2MQ(AMsg, ATopic: string);
begin
  FpjhSTOMPClass.StompSendMsg(AMsg, ATopic);
end;

procedure TForm8.SetCommComponent(ACompName, AValue: string);
begin

end;

procedure TForm8.SetConfig;
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

      FParamFileNameChanged := (LParamFileName <> FSettings.ParamFileName) and
        (FileExists(FSettings.ParamFileName));
      ApplyUI;
    end;
  finally
    LConfigF.Free;
  end;
end;

procedure TForm8.SetRunComponent(ACompName, AValue: string);
var
  i,j: integer;
  LEquipStatusItem: TEquipStatusItem;
  LIsRun: Boolean;
begin
  for i := 0 to FEquipStatusInfo.EquipStatusCollect.Count - 1 do
  begin
    LEquipStatusItem := FEquipStatusInfo.EquipStatusCollect.Items[i];
//    if LEquipStatusItem.EquipName = ACompName then
//    begin
//      LEquipStatusItem.LastUpdatedDate := now;

    if not LEquipStatusItem.CommConnected then
    begin
      if Assigned(LEquipStatusItem.CommComponent) then
      begin
        TKit(LEquipStatusItem.CommComponent).KitColor := Red;

        if Assigned(LEquipStatusItem.EquipNoComponent) then
        begin
          TPanel(LEquipStatusItem.EquipNoComponent).Hint := DateTimeToStr(LEquipStatusItem.LastUpdatedDate);
          TPanel(LEquipStatusItem.EquipNoComponent).ShowHint := True;
        end;
      end;
    end
    else
    begin
      if Assigned(LEquipStatusItem.RunComponent) then
      begin
        LIsRun := LEquipStatusItem.RunStatus = '1';

        if (AdvOfficePager1.ActivePage = LayOutPage1) or (AdvOfficePager1.ActivePage = LayOutPage2) then
        begin
          if LIsRun <> TQProgress(LEquipStatusItem.RunComponent).Active then
          begin
            TQProgress(LEquipStatusItem.RunComponent).Active := LIsRun;

            if LIsRun then
            begin
              TPanel(LEquipStatusItem.RunTextComponent).Caption := '가동';
              TPanel(LEquipStatusItem.RunTextComponent).Color := clLime;
              TPanel(LEquipStatusItem.RunTextComponent).Font.Color := CalcComplementalColor(clLime);
            end
            else
            begin
              TPanel(LEquipStatusItem.RunTextComponent).Caption := '대기';
              TPanel(LEquipStatusItem.RunTextComponent).Color := clRed;
              TPanel(LEquipStatusItem.RunTextComponent).Font.Color := CalcComplementalColor(clRed);
            end;
          end
          else
          if TPanel(LEquipStatusItem.RunTextComponent).Color = clBlack then
          begin
            TPanel(LEquipStatusItem.RunTextComponent).Caption := '대기';
            TPanel(LEquipStatusItem.RunTextComponent).Color := clRed;
            TPanel(LEquipStatusItem.RunTextComponent).Font.Color := CalcComplementalColor(clRed);
          end;
        end;
      end;

      if Assigned(LEquipStatusItem.CommComponent) then
      begin
        TKit(LEquipStatusItem.CommComponent).KitColor := Green;
          TKit(LEquipStatusItem.CommComponent).TimerEnable := True;
      end;

      if Assigned(LEquipStatusItem.EquipNoComponent) then
      begin
        TPanel(LEquipStatusItem.EquipNoComponent).Color := clBlack;
      end;
    end;//else

//      break;
//    end;
  end;
end;

procedure TForm8.Syncro_Main(AMsgEvent: TSTOMPMsgEvent);
var
  LStr: string;
  Li: integer;
  LESItem: TEquipStatusItem;
begin
  if FIsSyncProcEnter then
    exit;

  FIsSyncProcEnter := True;
  try
//    if AMsgEvent.Command = 4 then //일정 시간 내 데이터 없을 경우 통신 끊김으로 판단
//    begin
//      Li := StrToInt(AMsgEvent.Topic); //Index
//      LESItem := FEquipStatusInfo.EquipStatusCollect.Items[Li];
//      if Assigned(LESItem.CommComponent) then
//      begin
//        TKit(LESItem.CommComponent).KitColor := red;
//
//        if Assigned(LESItem.EquipNoComponent) then
//        begin
//          if not TKit(LESItem.CommComponent).TimerEnable then
//            TPanel(LESItem.EquipNoComponent).Color := clRed
//          else
//            TPanel(LESItem.EquipNoComponent).Color := clBlack;
//        end;
//      end;
//    end
//    else
    if AMsgEvent.Topic <> '' then
    begin
//      LStr := GetEquipNo(AMsgEvent.Topic);
      AdjustEquipStatus(LStr, AMsgEvent.FFMessage);
    end;
  finally
    FIsSyncProcEnter := False;
  end;
end;

procedure TForm8.WorkerResult(var msg: TMessage);
begin
  if not FIsDestroying then
    ProcessSubscribeMsg;
end;

end.
