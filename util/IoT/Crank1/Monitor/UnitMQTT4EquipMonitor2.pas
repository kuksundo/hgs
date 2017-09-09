unit UnitMQTT4EquipMonitor2;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, OtlParallel, OtlTaskControl, QProgress, Kit,
  iComponent, iVCLComponent, iCustomComponent, iMotor, Vcl.ComCtrls, Generics.Collections,
  AdvChartView, DBAdvChartView, Vcl.ExtCtrls, AdvOfficePager, Vcl.StdCtrls,
  UnitEquipStatusClass, UnitTimerPool, UnitMQTTClass, UnitWorker4OmniMsgQ,
  UnitMQTTClientConfig, Vcl.Menus, cyBasePanel, cyPanel,UnitMQTTMsg.Events;

const
  COMM_CHECK_INTERVAL = 30000; //5분
  MQ_TOPIC = '/topic/IoT_Crank1_EquipStatus';

type
  TForm9 = class(TForm)
    Panel1: TPanel;
    AdvOfficePager1: TAdvOfficePager;
    LayOutPage1: TAdvOfficePage;
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
    DBAdvChartView1: TDBAdvChartView;
    DBAdvChartView2: TDBAdvChartView;
    Panel68: TPanel;
    Splitter5: TSplitter;
    DBAdvChartView3: TDBAdvChartView;
    DBAdvChartView4: TDBAdvChartView;
    StatusBar1: TStatusBar;
    Memo1: TMemo;
    MainMenu1: TMainMenu;
    File1: TMenuItem;
    Option1: TMenuItem;
    Config1: TMenuItem;
    Close1: TMenuItem;
    GridPanel1: TGridPanel;
    CyPanel1: TCyPanel;
    CyPanel2: TCyPanel;
    CyPanel3: TCyPanel;
    CyPanel4: TCyPanel;
    CyPanel5: TCyPanel;
    CyPanel6: TCyPanel;
    CyPanel7: TCyPanel;
    CyPanel8: TCyPanel;
    CyPanel9: TCyPanel;
    CyPanel10: TCyPanel;
    CyPanel11: TCyPanel;
    CyPanel12: TCyPanel;
    CyPanel13: TCyPanel;
    CyPanel14: TCyPanel;
    CyPanel15: TCyPanel;
    CyPanel17: TCyPanel;
    CyPanel16: TCyPanel;
    CyPanel18: TCyPanel;
    CyPanel19: TCyPanel;
    CyPanel20: TCyPanel;
    CyPanel21: TCyPanel;
    CyPanel22: TCyPanel;
    CyPanel23: TCyPanel;
    CyPanel24: TCyPanel;
    CyPanel25: TCyPanel;
    CyPanel26: TCyPanel;
    CyPanel27: TCyPanel;
    CyPanel28: TCyPanel;
    CyPanel29: TCyPanel;
    CyPanel30: TCyPanel;
    Panel260: TPanel;
    Panel261: TPanel;
    Kit25: TKit;
    Panel263: TPanel;
    Panel262: TPanel;
    Panel266: TPanel;
    Panel267: TPanel;
    QProgress10: TQProgress;
    Panel269: TPanel;
    Panel170: TPanel;
    Panel171: TPanel;
    K_394: TKit;
    Panel173: TPanel;
    NO_394: TPanel;
    Panel176: TPanel;
    Panel177: TPanel;
    Q_394: TQProgress;
    RT_394: TPanel;
    Panel180: TPanel;
    Panel181: TPanel;
    K_391: TKit;
    Panel183: TPanel;
    NO_391: TPanel;
    Panel186: TPanel;
    Panel187: TPanel;
    Q_391: TQProgress;
    RT_391: TPanel;
    Panel190: TPanel;
    Panel191: TPanel;
    K_392: TKit;
    Panel193: TPanel;
    NO_392: TPanel;
    Panel196: TPanel;
    Panel197: TPanel;
    Q_392: TQProgress;
    RT_392: TPanel;
    Panel200: TPanel;
    Panel201: TPanel;
    K_351: TKit;
    Panel203: TPanel;
    NO_351: TPanel;
    Panel206: TPanel;
    Panel207: TPanel;
    Q_351: TQProgress;
    RT_351: TPanel;
    Panel210: TPanel;
    Panel211: TPanel;
    K_393: TKit;
    Panel213: TPanel;
    NO_393: TPanel;
    Panel216: TPanel;
    Panel217: TPanel;
    Q_393: TQProgress;
    RT_393: TPanel;
    Panel220: TPanel;
    Panel221: TPanel;
    K_387: TKit;
    Panel223: TPanel;
    NO_387: TPanel;
    Panel226: TPanel;
    Panel227: TPanel;
    Q_387: TQProgress;
    RT_387: TPanel;
    Panel230: TPanel;
    Panel231: TPanel;
    K_358: TKit;
    Panel233: TPanel;
    NO_358: TPanel;
    Panel236: TPanel;
    Panel237: TPanel;
    Q_358: TQProgress;
    RT_358: TPanel;
    Panel240: TPanel;
    Panel241: TPanel;
    K_389: TKit;
    Panel243: TPanel;
    NO_389: TPanel;
    Panel246: TPanel;
    Panel247: TPanel;
    Q_389: TQProgress;
    RT_389: TPanel;
    Panel270: TPanel;
    Panel271: TPanel;
    K_386: TKit;
    Panel273: TPanel;
    NO_386: TPanel;
    Panel276: TPanel;
    Panel277: TPanel;
    Q_386: TQProgress;
    RT_386: TPanel;
    Panel139: TPanel;
    Panel140: TPanel;
    K_327: TKit;
    Panel142: TPanel;
    NO_327: TPanel;
    Panel146: TPanel;
    Panel150: TPanel;
    Q_327: TQProgress;
    RT_327: TPanel;
    Panel124: TPanel;
    Panel125: TPanel;
    K_399: TKit;
    Panel127: TPanel;
    NO_399: TPanel;
    Panel130: TPanel;
    Panel131: TPanel;
    Q_399: TQProgress;
    RT_399: TPanel;
    Panel70: TPanel;
    Panel71: TPanel;
    K_384: TKit;
    Panel73: TPanel;
    NO_384: TPanel;
    Panel76: TPanel;
    Panel78: TPanel;
    Q_384: TQProgress;
    RT_384: TPanel;
    Panel82: TPanel;
    Panel83: TPanel;
    K_385: TKit;
    Panel85: TPanel;
    NO_385: TPanel;
    Panel90: TPanel;
    Panel91: TPanel;
    Q_385: TQProgress;
    RT_385: TPanel;
    Panel99: TPanel;
    Panel100: TPanel;
    K_388: TKit;
    Panel102: TPanel;
    NO_388: TPanel;
    Panel105: TPanel;
    Panel106: TPanel;
    Q_388: TQProgress;
    RT_388: TPanel;
    Panel109: TPanel;
    Panel110: TPanel;
    K_251: TKit;
    Panel112: TPanel;
    NO_251: TPanel;
    Panel115: TPanel;
    Panel116: TPanel;
    Q_251: TQProgress;
    RT_251: TPanel;
    Panel119: TPanel;
    Panel120: TPanel;
    K_252: TKit;
    Panel122: TPanel;
    NO_252: TPanel;
    Panel135: TPanel;
    Panel136: TPanel;
    Q_252: TQProgress;
    RT_252: TPanel;
    Panel145: TPanel;
    Panel147: TPanel;
    K_253: TKit;
    Panel149: TPanel;
    NO_253: TPanel;
    Panel155: TPanel;
    Panel156: TPanel;
    Q_253: TQProgress;
    RT_253: TPanel;
    Panel159: TPanel;
    Panel160: TPanel;
    K_258: TKit;
    Panel162: TPanel;
    NO_258: TPanel;
    Panel165: TPanel;
    Panel166: TPanel;
    Q_258: TQProgress;
    RT_258: TPanel;
    Panel72: TPanel;
    Panel84: TPanel;
    K_259: TKit;
    Panel101: TPanel;
    NO_259: TPanel;
    Panel121: TPanel;
    Panel126: TPanel;
    Q_259: TQProgress;
    RT_259: TPanel;
    LayOutPage2: TAdvOfficePage;
    Panel250: TPanel;
    Panel251: TPanel;
    K_396: TKit;
    Panel253: TPanel;
    NO_396: TPanel;
    Panel256: TPanel;
    Panel257: TPanel;
    Q_396: TQProgress;
    RT_396: TPanel;
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
    CyPanel53: TCyPanel;
    CyPanel54: TCyPanel;
    CyPanel55: TCyPanel;
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
    CyPanel72: TCyPanel;
    CyPanel73: TCyPanel;
    CyPanel74: TCyPanel;
    CyPanel75: TCyPanel;
    CyPanel76: TCyPanel;
    CyPanel77: TCyPanel;
    CyPanel78: TCyPanel;
    CyPanel79: TCyPanel;
    CyPanel80: TCyPanel;
    CyPanel81: TCyPanel;
    CyPanel82: TCyPanel;
    CyPanel83: TCyPanel;
    CyPanel84: TCyPanel;
    CyPanel85: TCyPanel;
    CyPanel86: TCyPanel;
    CyPanel87: TCyPanel;
    CyPanel88: TCyPanel;
    CyPanel89: TCyPanel;
    CyPanel90: TCyPanel;
    CyPanel91: TCyPanel;
    CyPanel92: TCyPanel;
    CyPanel93: TCyPanel;
    CyPanel94: TCyPanel;
    CyPanel95: TCyPanel;
    CyPanel96: TCyPanel;
    CyPanel97: TCyPanel;
    CyPanel98: TCyPanel;
    Panel382: TPanel;
    Panel383: TPanel;
    K_339: TKit;
    Panel385: TPanel;
    NO_339: TPanel;
    Panel388: TPanel;
    Panel389: TPanel;
    Q_339: TQProgress;
    RT_339: TPanel;
    Panel392: TPanel;
    Panel393: TPanel;
    K_294: TKit;
    Panel395: TPanel;
    NO_294: TPanel;
    Panel398: TPanel;
    Panel399: TPanel;
    Q_294: TQProgress;
    RT_294: TPanel;
    Panel361: TPanel;
    Panel362: TPanel;
    K_322: TKit;
    Panel364: TPanel;
    NO_322: TPanel;
    Panel367: TPanel;
    Panel368: TPanel;
    Q_322: TQProgress;
    RT_322: TPanel;
    Panel351: TPanel;
    Panel352: TPanel;
    K_342: TKit;
    Panel354: TPanel;
    NO_342: TPanel;
    Panel357: TPanel;
    Panel358: TPanel;
    Q_342: TQProgress;
    RT_342: TPanel;
    Panel341: TPanel;
    Panel342: TPanel;
    K_350: TKit;
    Panel344: TPanel;
    NO_350: TPanel;
    Panel347: TPanel;
    Panel348: TPanel;
    Q_350: TQProgress;
    RT_350: TPanel;
    Panel331: TPanel;
    Panel332: TPanel;
    K_257: TKit;
    Panel334: TPanel;
    NO_257: TPanel;
    Panel337: TPanel;
    Panel338: TPanel;
    Q_257: TQProgress;
    RT_257: TPanel;
    Panel321: TPanel;
    Panel322: TPanel;
    K_254: TKit;
    Panel324: TPanel;
    NO_254: TPanel;
    Panel327: TPanel;
    Panel328: TPanel;
    Q_254: TQProgress;
    RT_254: TPanel;
    Panel311: TPanel;
    Panel312: TPanel;
    K_341: TKit;
    Panel314: TPanel;
    NO_341: TPanel;
    Panel317: TPanel;
    Panel318: TPanel;
    Q_341: TQProgress;
    RT_341: TPanel;
    Panel432: TPanel;
    Panel433: TPanel;
    K_324: TKit;
    Panel435: TPanel;
    NO_324: TPanel;
    Panel438: TPanel;
    Panel439: TPanel;
    Q_324: TQProgress;
    RT_324: TPanel;
    Panel282: TPanel;
    Panel283: TPanel;
    K_346: TKit;
    Panel285: TPanel;
    NO_346: TPanel;
    Panel288: TPanel;
    Panel289: TPanel;
    Q_346: TQProgress;
    RT_346: TPanel;
    Panel292: TPanel;
    Panel293: TPanel;
    K_325: TKit;
    Panel295: TPanel;
    NO_325: TPanel;
    Panel298: TPanel;
    Panel299: TPanel;
    Q_325: TQProgress;
    RT_325: TPanel;
    Panel302: TPanel;
    Panel303: TPanel;
    K_345: TKit;
    Panel305: TPanel;
    NO_345: TPanel;
    Panel308: TPanel;
    Panel309: TPanel;
    Q_345: TQProgress;
    RT_345: TPanel;
    Panel372: TPanel;
    Panel373: TPanel;
    K_344: TKit;
    Panel375: TPanel;
    NO_344: TPanel;
    Panel378: TPanel;
    Panel379: TPanel;
    Q_344: TQProgress;
    RT_344: TPanel;
    AdvOfficePage1: TAdvOfficePage;
    Panel69: TPanel;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    MQServerIPEdit: TEdit;
    MQServerPortEdit: TEdit;
    TopicEdit: TEdit;
    MainMenu2: TMainMenu;
    MenuItem1: TMenuItem;
    MenuItem2: TMenuItem;
    MenuItem3: TMenuItem;
    MenuItem4: TMenuItem;
    Memo2: TMemo;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure Config1Click(Sender: TObject);
  private
    FpjhMQTTClass: TpjhMQTTClass;
    FEquipStatusInfo: TEquipStatusInfo;
    FConfigSettings: TConfigSettings;
    FPJHTimerPool: TPJHTimerPool;
    FOnUpdateCommStatusList: TDictionary<string, TVpTimerTriggerEvent>;
    FHandleUpdateCommStatusList: TDictionary<integer, TVpTimerTriggerEvent>;

    FSuspending: Boolean;//Config 중에는 True
    FIsDestroying: Boolean;
    FIsSyncProcEnter: Boolean;//

    procedure WorkerResult(var msg: TMessage); message MSG_RESULT;
    function GetEquipNo(ATopic: string): string;
    procedure DisplayMessage2Memo(msg: string; ADest: integer);
    procedure AdjustEquipStatus(AEquipNo, AStatus: string);
  protected
    procedure OnUpdateCommStatus1(Sender : TObject; Handle : Integer;
            Interval : Cardinal; ElapsedTime : LongInt);
    procedure OnUpdateCommStatus2(Sender : TObject; Handle : Integer;
            Interval : Cardinal; ElapsedTime : LongInt);
    procedure OnUpdateCommStatus3(Sender : TObject; Handle : Integer;
            Interval : Cardinal; ElapsedTime : LongInt);
    procedure OnUpdateCommStatus4(Sender : TObject; Handle : Integer;
            Interval : Cardinal; ElapsedTime : LongInt);
    procedure OnUpdateCommStatus5(Sender : TObject; Handle : Integer;
            Interval : Cardinal; ElapsedTime : LongInt);
    procedure OnUpdateCommStatus6(Sender : TObject; Handle : Integer;
            Interval : Cardinal; ElapsedTime : LongInt);
    procedure OnUpdateCommStatus7(Sender : TObject; Handle : Integer;
            Interval : Cardinal; ElapsedTime : LongInt);
    procedure OnUpdateCommStatus8(Sender : TObject; Handle : Integer;
            Interval : Cardinal; ElapsedTime : LongInt);
    procedure OnUpdateCommStatus9(Sender : TObject; Handle : Integer;
            Interval : Cardinal; ElapsedTime : LongInt);
    procedure OnUpdateCommStatus10(Sender : TObject; Handle : Integer;
            Interval : Cardinal; ElapsedTime : LongInt);
    procedure OnUpdateCommStatus11(Sender : TObject; Handle : Integer;
            Interval : Cardinal; ElapsedTime : LongInt);
    procedure OnUpdateCommStatus12(Sender : TObject; Handle : Integer;
            Interval : Cardinal; ElapsedTime : LongInt);
    procedure OnUpdateCommStatus13(Sender : TObject; Handle : Integer;
            Interval : Cardinal; ElapsedTime : LongInt);
    procedure OnUpdateCommStatus14(Sender : TObject; Handle : Integer;
            Interval : Cardinal; ElapsedTime : LongInt);
    procedure OnUpdateCommStatus15(Sender : TObject; Handle : Integer;
            Interval : Cardinal; ElapsedTime : LongInt);
    procedure OnUpdateCommStatus16(Sender : TObject; Handle : Integer;
            Interval : Cardinal; ElapsedTime : LongInt);
    procedure OnUpdateCommStatus17(Sender : TObject; Handle : Integer;
            Interval : Cardinal; ElapsedTime : LongInt);
    procedure OnUpdateCommStatus18(Sender : TObject; Handle : Integer;
            Interval : Cardinal; ElapsedTime : LongInt);
    procedure OnUpdateCommStatus19(Sender : TObject; Handle : Integer;
            Interval : Cardinal; ElapsedTime : LongInt);
    procedure OnUpdateCommStatus20(Sender : TObject; Handle : Integer;
            Interval : Cardinal; ElapsedTime : LongInt);
    procedure OnUpdateCommStatus21(Sender : TObject; Handle : Integer;
            Interval : Cardinal; ElapsedTime : LongInt);
    procedure OnUpdateCommStatus22(Sender : TObject; Handle : Integer;
            Interval : Cardinal; ElapsedTime : LongInt);
    procedure OnUpdateCommStatus23(Sender : TObject; Handle : Integer;
            Interval : Cardinal; ElapsedTime : LongInt);
    procedure OnUpdateCommStatus24(Sender : TObject; Handle : Integer;
            Interval : Cardinal; ElapsedTime : LongInt);
    procedure OnUpdateCommStatus25(Sender : TObject; Handle : Integer;
            Interval : Cardinal; ElapsedTime : LongInt);
    procedure OnUpdateCommStatus26(Sender : TObject; Handle : Integer;
            Interval : Cardinal; ElapsedTime : LongInt);
    procedure OnUpdateCommStatus27(Sender : TObject; Handle : Integer;
            Interval : Cardinal; ElapsedTime : LongInt);
    procedure OnUpdateCommStatus28(Sender : TObject; Handle : Integer;
            Interval : Cardinal; ElapsedTime : LongInt);
    procedure OnUpdateCommStatus29(Sender : TObject; Handle : Integer;
            Interval : Cardinal; ElapsedTime : LongInt);
    procedure OnUpdateCommStatus30(Sender : TObject; Handle : Integer;
            Interval : Cardinal; ElapsedTime : LongInt);

    procedure OnReConnectMQTT(Sender : TObject; Handle : Integer;
            Interval : Cardinal; ElapsedTime : LongInt);

    procedure InitEquipRunComponent;
    procedure InitOnUpdateCommStatusList;
    procedure SetRunComponent(ACompName, AValue: string);
    procedure SetCommComponent(ACompName, AValue: string);

    function GetTimerHandleIndex(AHandle: integer): integer;
    procedure UpdateCommStatus(AHandle, AItemIndex: integer);
  public
    procedure InitVar;
    procedure FinalizeVar;
    procedure InitMQTT(AUserId, APasswd, AServerIP, ATopic: string);
    procedure DestroyMQTT;

    procedure Syncro_Main(AMsgEvent: TMQTTMsgEvent);
  end;

var
  Form9: TForm9;

implementation

uses OtlComm, UnitMQTTMsg.EventThreads;

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

procedure TForm9.AdjustEquipStatus(AEquipNo, AStatus: string);
var
  idx,iNum,iPreLen: Integer;
  wCtrl: TWinControl;
begin
  iPreLen := Length(AEquipNo);

  if(iPreLen<1)then Exit;

  SetRunComponent(AEquipNo, AStatus);
end;

procedure TForm9.Config1Click(Sender: TObject);
begin
  FSuspending := True;
  try
    TConfigF.SetConfig(FConfigSettings);
  finally
    FSuspending := False;
  end;
end;

procedure TForm9.DestroyMQTT;
begin
  if Assigned(FpjhMQTTClass) then
    FpjhMQTTClass.Free;
end;

procedure TForm9.DisplayMessage2Memo(msg: string; ADest: integer);
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

procedure TForm9.FinalizeVar;
begin
  FIsDestroying := True;

  FPJHTimerPool.RemoveAll;
  FPJHTimerPool.Free;
  FEquipStatusInfo.Free;
  FOnUpdateCommStatusList.Free;
  FHandleUpdateCommStatusList.Free;
  FConfigSettings.Free;
  DestroyMQTT;
end;

procedure TForm9.FormCreate(Sender: TObject);
begin
  InitVar;
end;

procedure TForm9.FormDestroy(Sender: TObject);
begin
  FinalizeVar;
end;

function TForm9.GetEquipNo(ATopic: string): string;
var
  LStrList: TStringList;
begin
// /dev/mc/xxx/ 형태로 들어옴
  LStrList := TStringList.Create;
  try
    ExtractStrings(['/'], [], PChar(ATopic), LStrList);
//    LStrList.StrictDelimiter := True;
//    LStrList.Delimiter := '/';
//    LStrList.Add(ATopic);
    if LStrList.Count > 2 then
      Result := LStrList.Strings[2]
    else
      TMQTTMsgEvent.Create('', 'Topic Error : ' + ATopic).Queue;

  finally
    LStrList.Free;
  end;
end;

function TForm9.GetTimerHandleIndex(AHandle: integer): integer;
var
  i: integer;
  LESItem: TEquipStatusItem;
begin
  Result := -1;

  for i := 0 to FEquipStatusInfo.EquipStatusCollect.Count - 1 do
  begin
    LESItem := FEquipStatusInfo.EquipStatusCollect.Items[i];
    if LESItem.CommStatusTimerHandle = AHandle then
    begin
      Result := i;
      break;
    end;
  end;
end;

procedure TForm9.InitEquipRunComponent;
var
  LESItem: TEquipStatusItem;
  i: integer;
  LComponent: TComponent;
  LTrigger: TVpTimerTriggerEvent;
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
      LESItem.CommComponent := LComponent;

    LComponent := nil;
    LComponent := FindComponent('NO_' + EquipNameAry[i]);//TPanel

    if Assigned(LComponent) then
      LESItem.EquipNoComponent := LComponent;

    LTriggerName := 'OnUpdateCommStatus' + IntToStr(i+1);
    if FOnUpdateCommStatusList.ContainsKey(LTriggername) then
    begin
      LTrigger := FOnUpdateCommStatusList.Items[LTriggerName];
      LESItem.CommStatusTimerHandle := FPJHTimerPool.AddOneShot(LTrigger, COMM_CHECK_INTERVAL);
      FHandleUpdateCommStatusList.Add(LESItem.CommStatusTimerHandle, LTrigger);
      LESItem.OnUpdateCommStatusName := LTriggerName;
      LESItem.OnUpdateCommStatus := LTrigger;
    end;
  end;
end;

procedure TForm9.InitMQTT(AUserId, APasswd, AServerIP, ATopic: string);
begin
  if not Assigned(FpjhMQTTClass) then
  begin
    FpjhMQTTClass := TpjhMQTTClass.Create(AUserId,
                                            APasswd,
                                            AServerIP, '',
                                            ATopic,
                                            Self.Handle);
    FpjhMQTTClass.SetSynchroProc(Syncro_Main);
  end;
end;

procedure TForm9.InitOnUpdateCommStatusList;
begin
  FOnUpdateCommStatusList.Add('OnUpdateCommStatus1',OnUpdateCommStatus1);
  FOnUpdateCommStatusList.Add('OnUpdateCommStatus2',OnUpdateCommStatus2);
  FOnUpdateCommStatusList.Add('OnUpdateCommStatus3',OnUpdateCommStatus3);
  FOnUpdateCommStatusList.Add('OnUpdateCommStatus4',OnUpdateCommStatus4);
  FOnUpdateCommStatusList.Add('OnUpdateCommStatus5',OnUpdateCommStatus5);
  FOnUpdateCommStatusList.Add('OnUpdateCommStatus6',OnUpdateCommStatus6);
  FOnUpdateCommStatusList.Add('OnUpdateCommStatus7',OnUpdateCommStatus7);
  FOnUpdateCommStatusList.Add('OnUpdateCommStatus8',OnUpdateCommStatus8);
  FOnUpdateCommStatusList.Add('OnUpdateCommStatus9',OnUpdateCommStatus9);
  FOnUpdateCommStatusList.Add('OnUpdateCommStatus10',OnUpdateCommStatus10);
  FOnUpdateCommStatusList.Add('OnUpdateCommStatus11',OnUpdateCommStatus11);
  FOnUpdateCommStatusList.Add('OnUpdateCommStatus12',OnUpdateCommStatus12);
  FOnUpdateCommStatusList.Add('OnUpdateCommStatus13',OnUpdateCommStatus13);
  FOnUpdateCommStatusList.Add('OnUpdateCommStatus14',OnUpdateCommStatus14);
  FOnUpdateCommStatusList.Add('OnUpdateCommStatus15',OnUpdateCommStatus15);
  FOnUpdateCommStatusList.Add('OnUpdateCommStatus16',OnUpdateCommStatus16);
  FOnUpdateCommStatusList.Add('OnUpdateCommStatus17',OnUpdateCommStatus17);
  FOnUpdateCommStatusList.Add('OnUpdateCommStatus18',OnUpdateCommStatus18);
  FOnUpdateCommStatusList.Add('OnUpdateCommStatus19',OnUpdateCommStatus19);
  FOnUpdateCommStatusList.Add('OnUpdateCommStatus20',OnUpdateCommStatus20);
  FOnUpdateCommStatusList.Add('OnUpdateCommStatus21',OnUpdateCommStatus21);
  FOnUpdateCommStatusList.Add('OnUpdateCommStatus22',OnUpdateCommStatus22);
  FOnUpdateCommStatusList.Add('OnUpdateCommStatus23',OnUpdateCommStatus23);
  FOnUpdateCommStatusList.Add('OnUpdateCommStatus24',OnUpdateCommStatus24);
  FOnUpdateCommStatusList.Add('OnUpdateCommStatus25',OnUpdateCommStatus25);
  FOnUpdateCommStatusList.Add('OnUpdateCommStatus26',OnUpdateCommStatus26);
  FOnUpdateCommStatusList.Add('OnUpdateCommStatus27',OnUpdateCommStatus27);
  FOnUpdateCommStatusList.Add('OnUpdateCommStatus28',OnUpdateCommStatus28);
  FOnUpdateCommStatusList.Add('OnUpdateCommStatus29',OnUpdateCommStatus29);
  FOnUpdateCommStatusList.Add('OnUpdateCommStatus30',OnUpdateCommStatus30);
end;

procedure TForm9.InitVar;
begin
  FConfigSettings := TConfigSettings.create(ChangeFileExt(Application.ExeName, '.ini'));
  FEquipStatusInfo := TEquipStatusInfo.Create(Self);
  FPJHTimerPool := TPJHTimerPool.Create(Self);
  FPJHTimerPool.Add(OnReConnectMQTT, 1800000);//30분(1800000)에 한번씩 Reconnect함
  FOnUpdateCommStatusList := TDictionary<string, TVpTimerTriggerEvent>.create;
  FHandleUpdateCommStatusList := TDictionary<integer, TVpTimerTriggerEvent>.Create;
  InitOnUpdateCommStatusList;
  //가공장비 리스트를 FEquipStatusInfo에 저장함
  InitEquipRunComponent;

  MQTTMsgEventThread.SetDisplayMsgProc(DisplayMessage2Memo);
  InitMQTT('','','127.0.0.1',MQ_TOPIC);

  FIsDestroying := False;
end;

procedure TForm9.OnReConnectMQTT(Sender: TObject; Handle: Integer;
  Interval: Cardinal; ElapsedTime: Integer);
begin
  if FIsDestroying then
    exit;

  Parallel.Async(
    procedure
    begin
      TMQTTMsgEvent.Create('','OnReConnectMQTT Doing!').Queue;
      if FpjhMQTTClass.MQTTUnSubscribe <> -1 then
        TMQTTMsgEvent.Create('','UnSubscribe 성공').Queue;

      if not FpjhMQTTClass.DisConnectMQTT then
        TMQTTMsgEvent.Create('','Disconnect 실패').Queue;
    end,
    Parallel.TaskConfig.OnTerminated(
      procedure (const task: IOmniTaskControl)
      begin
        // executed in main thread
        FpjhMQTTClass.ConnectMQTT();
        TMQTTMsgEvent.Create('','Reconnect 성공').Queue;
      end
    )
  );
end;

procedure TForm9.OnUpdateCommStatus1(Sender: TObject; Handle: Integer;
  Interval: Cardinal; ElapsedTime: Integer);
var
  i: integer;
begin
  if FSuspending then
    exit;

  i := GetTimerHandleIndex(Handle);

  if i <> -1 then
  begin
    FEquipStatusInfo.EquipStatusCollect.Items[i].CommStatusTimerHandle :=
      FPJHTimerPool.AddOneShot(OnUpdateCommStatus1, COMM_CHECK_INTERVAL);
    UpdateCommStatus(Handle,i);
  end;
end;

procedure TForm9.OnUpdateCommStatus10(Sender: TObject; Handle: Integer;
  Interval: Cardinal; ElapsedTime: Integer);
var
  i: integer;
begin
  if FSuspending then
    exit;

  i := GetTimerHandleIndex(Handle);

  if i <> -1 then
  begin
    FEquipStatusInfo.EquipStatusCollect.Items[i].CommStatusTimerHandle :=
      FPJHTimerPool.AddOneShot(OnUpdateCommStatus10, COMM_CHECK_INTERVAL);
    UpdateCommStatus(Handle,i);
  end;
end;

procedure TForm9.OnUpdateCommStatus11(Sender: TObject; Handle: Integer;
  Interval: Cardinal; ElapsedTime: Integer);
var
  i: integer;
begin
  if FSuspending then
    exit;

  i := GetTimerHandleIndex(Handle);

  if i <> -1 then
  begin
    FEquipStatusInfo.EquipStatusCollect.Items[i].CommStatusTimerHandle :=
      FPJHTimerPool.AddOneShot(OnUpdateCommStatus11, COMM_CHECK_INTERVAL);
    UpdateCommStatus(Handle,i);
  end;
end;

procedure TForm9.OnUpdateCommStatus12(Sender: TObject; Handle: Integer;
  Interval: Cardinal; ElapsedTime: Integer);
var
  i: integer;
begin
  if FSuspending then
    exit;

  i := GetTimerHandleIndex(Handle);

  if i <> -1 then
  begin
    FEquipStatusInfo.EquipStatusCollect.Items[i].CommStatusTimerHandle :=
      FPJHTimerPool.AddOneShot(OnUpdateCommStatus12, COMM_CHECK_INTERVAL);
    UpdateCommStatus(Handle,i);
  end;
end;

procedure TForm9.OnUpdateCommStatus13(Sender: TObject; Handle: Integer;
  Interval: Cardinal; ElapsedTime: Integer);
var
  i: integer;
begin
  if FSuspending then
    exit;

  i := GetTimerHandleIndex(Handle);

  if i <> -1 then
  begin
    FEquipStatusInfo.EquipStatusCollect.Items[i].CommStatusTimerHandle :=
      FPJHTimerPool.AddOneShot(OnUpdateCommStatus13, COMM_CHECK_INTERVAL);
    UpdateCommStatus(Handle,i);
  end;
end;

procedure TForm9.OnUpdateCommStatus14(Sender: TObject; Handle: Integer;
  Interval: Cardinal; ElapsedTime: Integer);
var
  i: integer;
begin
  if FSuspending then
    exit;

  i := GetTimerHandleIndex(Handle);

  if i <> -1 then
  begin
    FEquipStatusInfo.EquipStatusCollect.Items[i].CommStatusTimerHandle :=
      FPJHTimerPool.AddOneShot(OnUpdateCommStatus14, COMM_CHECK_INTERVAL);
    UpdateCommStatus(Handle,i);
  end;
end;

procedure TForm9.OnUpdateCommStatus15(Sender: TObject; Handle: Integer;
  Interval: Cardinal; ElapsedTime: Integer);
var
  i: integer;
begin
  if FSuspending then
    exit;

  i := GetTimerHandleIndex(Handle);

  if i <> -1 then
  begin
    FEquipStatusInfo.EquipStatusCollect.Items[i].CommStatusTimerHandle :=
      FPJHTimerPool.AddOneShot(OnUpdateCommStatus15, COMM_CHECK_INTERVAL);
    UpdateCommStatus(Handle,i);
  end;
end;

procedure TForm9.OnUpdateCommStatus16(Sender: TObject; Handle: Integer;
  Interval: Cardinal; ElapsedTime: Integer);
var
  i: integer;
begin
  if FSuspending then
    exit;

  i := GetTimerHandleIndex(Handle);

  if i <> -1 then
  begin
    FEquipStatusInfo.EquipStatusCollect.Items[i].CommStatusTimerHandle :=
      FPJHTimerPool.AddOneShot(OnUpdateCommStatus16, COMM_CHECK_INTERVAL);
    UpdateCommStatus(Handle,i);
  end;
end;

procedure TForm9.OnUpdateCommStatus17(Sender: TObject; Handle: Integer;
  Interval: Cardinal; ElapsedTime: Integer);
var
  i: integer;
begin
  if FSuspending then
    exit;

  i := GetTimerHandleIndex(Handle);

  if i <> -1 then
  begin
    FEquipStatusInfo.EquipStatusCollect.Items[i].CommStatusTimerHandle :=
      FPJHTimerPool.AddOneShot(OnUpdateCommStatus17, COMM_CHECK_INTERVAL);
    UpdateCommStatus(Handle,i);
  end;
end;

procedure TForm9.OnUpdateCommStatus18(Sender: TObject; Handle: Integer;
  Interval: Cardinal; ElapsedTime: Integer);
var
  i: integer;
begin
  if FSuspending then
    exit;

  i := GetTimerHandleIndex(Handle);

  if i <> -1 then
  begin
    FEquipStatusInfo.EquipStatusCollect.Items[i].CommStatusTimerHandle :=
      FPJHTimerPool.AddOneShot(OnUpdateCommStatus18, COMM_CHECK_INTERVAL);
    UpdateCommStatus(Handle,i);
  end;
end;

procedure TForm9.OnUpdateCommStatus19(Sender: TObject; Handle: Integer;
  Interval: Cardinal; ElapsedTime: Integer);
var
  i: integer;
begin
  if FSuspending then
    exit;

  i := GetTimerHandleIndex(Handle);

  if i <> -1 then
  begin
    FEquipStatusInfo.EquipStatusCollect.Items[i].CommStatusTimerHandle :=
      FPJHTimerPool.AddOneShot(OnUpdateCommStatus19, COMM_CHECK_INTERVAL);
    UpdateCommStatus(Handle,i);
  end;
end;

procedure TForm9.OnUpdateCommStatus2(Sender: TObject; Handle: Integer;
  Interval: Cardinal; ElapsedTime: Integer);
var
  i: integer;
begin
  if FSuspending then
    exit;

  i := GetTimerHandleIndex(Handle);

  if i <> -1 then
  begin
    FEquipStatusInfo.EquipStatusCollect.Items[i].CommStatusTimerHandle :=
      FPJHTimerPool.AddOneShot(OnUpdateCommStatus2, COMM_CHECK_INTERVAL);
    UpdateCommStatus(Handle,i);
  end;
end;

procedure TForm9.OnUpdateCommStatus20(Sender: TObject; Handle: Integer;
  Interval: Cardinal; ElapsedTime: Integer);
var
  i: integer;
begin
  if FSuspending then
    exit;

  i := GetTimerHandleIndex(Handle);

  if i <> -1 then
  begin
    FEquipStatusInfo.EquipStatusCollect.Items[i].CommStatusTimerHandle :=
      FPJHTimerPool.AddOneShot(OnUpdateCommStatus20, COMM_CHECK_INTERVAL);
    UpdateCommStatus(Handle,i);
  end;
end;

procedure TForm9.OnUpdateCommStatus21(Sender: TObject; Handle: Integer;
  Interval: Cardinal; ElapsedTime: Integer);
var
  i: integer;
begin
  if FSuspending then
    exit;

  i := GetTimerHandleIndex(Handle);

  if i <> -1 then
  begin
    FEquipStatusInfo.EquipStatusCollect.Items[i].CommStatusTimerHandle :=
      FPJHTimerPool.AddOneShot(OnUpdateCommStatus21, COMM_CHECK_INTERVAL);
    UpdateCommStatus(Handle,i);
  end;
end;

procedure TForm9.OnUpdateCommStatus22(Sender: TObject; Handle: Integer;
  Interval: Cardinal; ElapsedTime: Integer);
var
  i: integer;
begin
  if FSuspending then
    exit;

  i := GetTimerHandleIndex(Handle);

  if i <> -1 then
  begin
    FEquipStatusInfo.EquipStatusCollect.Items[i].CommStatusTimerHandle :=
      FPJHTimerPool.AddOneShot(OnUpdateCommStatus22, COMM_CHECK_INTERVAL);
    UpdateCommStatus(Handle,i);
  end;
end;

procedure TForm9.OnUpdateCommStatus23(Sender: TObject; Handle: Integer;
  Interval: Cardinal; ElapsedTime: Integer);
var
  i: integer;
begin
  if FSuspending then
    exit;

  i := GetTimerHandleIndex(Handle);

  if i <> -1 then
  begin
    FEquipStatusInfo.EquipStatusCollect.Items[i].CommStatusTimerHandle :=
      FPJHTimerPool.AddOneShot(OnUpdateCommStatus23, COMM_CHECK_INTERVAL);
    UpdateCommStatus(Handle,i);
  end;
end;

procedure TForm9.OnUpdateCommStatus24(Sender: TObject; Handle: Integer;
  Interval: Cardinal; ElapsedTime: Integer);
var
  i: integer;
begin
  if FSuspending then
    exit;

  i := GetTimerHandleIndex(Handle);

  if i <> -1 then
  begin
    FEquipStatusInfo.EquipStatusCollect.Items[i].CommStatusTimerHandle :=
      FPJHTimerPool.AddOneShot(OnUpdateCommStatus24, COMM_CHECK_INTERVAL);
    UpdateCommStatus(Handle,i);
  end;
end;

procedure TForm9.OnUpdateCommStatus25(Sender: TObject; Handle: Integer;
  Interval: Cardinal; ElapsedTime: Integer);
var
  i: integer;
begin
  if FSuspending then
    exit;

  i := GetTimerHandleIndex(Handle);

  if i <> -1 then
  begin
    FEquipStatusInfo.EquipStatusCollect.Items[i].CommStatusTimerHandle :=
      FPJHTimerPool.AddOneShot(OnUpdateCommStatus25, COMM_CHECK_INTERVAL);
    UpdateCommStatus(Handle,i);
  end;
end;

procedure TForm9.OnUpdateCommStatus26(Sender: TObject; Handle: Integer;
  Interval: Cardinal; ElapsedTime: Integer);
var
  i: integer;
begin
  if FSuspending then
    exit;

  i := GetTimerHandleIndex(Handle);

  if i <> -1 then
  begin
    FEquipStatusInfo.EquipStatusCollect.Items[i].CommStatusTimerHandle :=
      FPJHTimerPool.AddOneShot(OnUpdateCommStatus26, COMM_CHECK_INTERVAL);
    UpdateCommStatus(Handle,i);
  end;
end;

procedure TForm9.OnUpdateCommStatus27(Sender: TObject; Handle: Integer;
  Interval: Cardinal; ElapsedTime: Integer);
var
  i: integer;
begin
  if FSuspending then
    exit;

  i := GetTimerHandleIndex(Handle);

  if i <> -1 then
  begin
    FEquipStatusInfo.EquipStatusCollect.Items[i].CommStatusTimerHandle :=
      FPJHTimerPool.AddOneShot(OnUpdateCommStatus27, COMM_CHECK_INTERVAL);
    UpdateCommStatus(Handle,i);
  end;
end;

procedure TForm9.OnUpdateCommStatus28(Sender: TObject; Handle: Integer;
  Interval: Cardinal; ElapsedTime: Integer);
var
  i: integer;
begin
  if FSuspending then
    exit;

  i := GetTimerHandleIndex(Handle);

  if i <> -1 then
  begin
    FEquipStatusInfo.EquipStatusCollect.Items[i].CommStatusTimerHandle :=
      FPJHTimerPool.AddOneShot(OnUpdateCommStatus28, COMM_CHECK_INTERVAL);
    UpdateCommStatus(Handle,i);
  end;
end;

procedure TForm9.OnUpdateCommStatus29(Sender: TObject; Handle: Integer;
  Interval: Cardinal; ElapsedTime: Integer);
var
  i: integer;
begin
  if FSuspending then
    exit;

  i := GetTimerHandleIndex(Handle);

  if i <> -1 then
  begin
    FEquipStatusInfo.EquipStatusCollect.Items[i].CommStatusTimerHandle :=
      FPJHTimerPool.AddOneShot(OnUpdateCommStatus29, COMM_CHECK_INTERVAL);
    UpdateCommStatus(Handle,i);
  end;
end;

procedure TForm9.OnUpdateCommStatus3(Sender: TObject; Handle: Integer;
  Interval: Cardinal; ElapsedTime: Integer);
var
  i: integer;
begin
  if FSuspending then
    exit;

  i := GetTimerHandleIndex(Handle);

  if i <> -1 then
  begin
    FEquipStatusInfo.EquipStatusCollect.Items[i].CommStatusTimerHandle :=
      FPJHTimerPool.AddOneShot(OnUpdateCommStatus3, COMM_CHECK_INTERVAL);
    UpdateCommStatus(Handle,i);
  end;
end;

procedure TForm9.OnUpdateCommStatus30(Sender: TObject; Handle: Integer;
  Interval: Cardinal; ElapsedTime: Integer);
var
  i: integer;
begin
  if FSuspending then
    exit;

  i := GetTimerHandleIndex(Handle);

  if i <> -1 then
  begin
    FEquipStatusInfo.EquipStatusCollect.Items[i].CommStatusTimerHandle :=
      FPJHTimerPool.AddOneShot(OnUpdateCommStatus30, COMM_CHECK_INTERVAL);
    UpdateCommStatus(Handle,i);
  end;
end;

procedure TForm9.OnUpdateCommStatus4(Sender: TObject; Handle: Integer;
  Interval: Cardinal; ElapsedTime: Integer);
var
  i: integer;
begin
  if FSuspending then
    exit;

  i := GetTimerHandleIndex(Handle);

  if i <> -1 then
  begin
    FEquipStatusInfo.EquipStatusCollect.Items[i].CommStatusTimerHandle :=
      FPJHTimerPool.AddOneShot(OnUpdateCommStatus4, COMM_CHECK_INTERVAL);
    UpdateCommStatus(Handle,i);
  end;
end;

procedure TForm9.OnUpdateCommStatus5(Sender: TObject; Handle: Integer;
  Interval: Cardinal; ElapsedTime: Integer);
var
  i: integer;
begin
  if FSuspending then
    exit;

  i := GetTimerHandleIndex(Handle);

  if i <> -1 then
  begin
    FEquipStatusInfo.EquipStatusCollect.Items[i].CommStatusTimerHandle :=
      FPJHTimerPool.AddOneShot(OnUpdateCommStatus5, COMM_CHECK_INTERVAL);
    UpdateCommStatus(Handle,i);
  end;
end;

procedure TForm9.OnUpdateCommStatus6(Sender: TObject; Handle: Integer;
  Interval: Cardinal; ElapsedTime: Integer);
var
  i: integer;
begin
  if FSuspending then
    exit;

  i := GetTimerHandleIndex(Handle);

  if i <> -1 then
  begin
    FEquipStatusInfo.EquipStatusCollect.Items[i].CommStatusTimerHandle :=
      FPJHTimerPool.AddOneShot(OnUpdateCommStatus6, COMM_CHECK_INTERVAL);
    UpdateCommStatus(Handle,i);
  end;
end;

procedure TForm9.OnUpdateCommStatus7(Sender: TObject; Handle: Integer;
  Interval: Cardinal; ElapsedTime: Integer);
var
  i: integer;
begin
  if FSuspending then
    exit;

  i := GetTimerHandleIndex(Handle);

  if i <> -1 then
  begin
    FEquipStatusInfo.EquipStatusCollect.Items[i].CommStatusTimerHandle :=
      FPJHTimerPool.AddOneShot(OnUpdateCommStatus7, COMM_CHECK_INTERVAL);
    UpdateCommStatus(Handle,i);
  end;
end;

procedure TForm9.OnUpdateCommStatus8(Sender: TObject; Handle: Integer;
  Interval: Cardinal; ElapsedTime: Integer);
var
  i: integer;
begin
  if FSuspending then
    exit;

  i := GetTimerHandleIndex(Handle);

  if i <> -1 then
  begin
    FEquipStatusInfo.EquipStatusCollect.Items[i].CommStatusTimerHandle :=
      FPJHTimerPool.AddOneShot(OnUpdateCommStatus8, COMM_CHECK_INTERVAL);
    UpdateCommStatus(Handle,i);
  end;
end;

procedure TForm9.OnUpdateCommStatus9(Sender: TObject; Handle: Integer;
  Interval: Cardinal; ElapsedTime: Integer);
var
  i: integer;
begin
  if FSuspending then
    exit;

  i := GetTimerHandleIndex(Handle);

  if i <> -1 then
  begin
    FEquipStatusInfo.EquipStatusCollect.Items[i].CommStatusTimerHandle :=
      FPJHTimerPool.AddOneShot(OnUpdateCommStatus9, COMM_CHECK_INTERVAL);
    UpdateCommStatus(Handle,i);
  end;
end;

procedure TForm9.SetCommComponent(ACompName, AValue: string);
begin

end;

procedure TForm9.SetRunComponent(ACompName, AValue: string);
var
  i,j: integer;
  LEquipStatusItem: TEquipStatusItem;
  LIsRun: Boolean;
begin
  for i := 0 to FEquipStatusInfo.EquipStatusCollect.Count - 1 do
  begin
    LEquipStatusItem := FEquipStatusInfo.EquipStatusCollect.Items[i];
    if LEquipStatusItem.EquipName = ACompName then
    begin
      LEquipStatusItem.LastUpdatedDate := now;
//      if Assigned(LEquipStatusItem.OnUpdateCommStatus) then
//        j := FPJHTimerPool.AddOneShot(LEquipStatusItem.OnUpdateCommStatus,COMM_CHECK_INTERVAL);

      if Assigned(LEquipStatusItem.RunComponent) then
      begin
        LIsRun := AValue = '1';

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

      break;
    end;
  end;
end;

procedure TForm9.Syncro_Main(AMsgEvent: TMQTTMsgEvent);
var
  LStr: string;
  Li: integer;
  LESItem: TEquipStatusItem;
begin
  if FIsSyncProcEnter then
    exit;

  FIsSyncProcEnter := True;
  try
    if AMsgEvent.Command = 4 then //일정 시간 내 데이터 없을 경우 통신 끊김으로 판단
    begin
      Li := StrToInt(AMsgEvent.Topic); //Index
      LESItem := FEquipStatusInfo.EquipStatusCollect.Items[Li];
      if Assigned(LESItem.CommComponent) then
      begin
        TKit(LESItem.CommComponent).KitColor := red;

        if Assigned(LESItem.EquipNoComponent) then
        begin
          if not TKit(LESItem.CommComponent).TimerEnable then
            TPanel(LESItem.EquipNoComponent).Color := clRed
          else
            TPanel(LESItem.EquipNoComponent).Color := clBlack;
        end;
      end;
    end
    else
    if AMsgEvent.Topic <> '' then
    begin
      LStr := GetEquipNo(AMsgEvent.Topic);
      AdjustEquipStatus(LStr, AMsgEvent.FFMessage);
    end;
  finally
    FIsSyncProcEnter := False;
  end;
end;

procedure TForm9.UpdateCommStatus(AHandle, AItemIndex: integer);
var
  i: integer;
begin
//  EnterCriticalSection(GlobalSection);
  try
    TMQTTMsgEvent.Create(IntToStr(AItemIndex), IntToStr(AHandle), 4).Queue;
  finally
//    LeaveCriticalSection(GlobalSection);
  end;
end;

procedure TForm9.WorkerResult(var msg: TMessage);
var
  Amsg: TOmniMessage;
  rec : TCommandMsgRecord;
  LHandle, Li: integer;
  LESItem: TEquipStatusItem;
begin
  while FpjhMQTTClass.GetResponseQMsg(Amsg) do
  begin
    if FSuspending then
      continue;

//    rec := Amsg.MsgData.ToRecord<TCommandMsgRecord>;

//    if rec.FCommand = 4 then //일정 시간 내 데이터 없을 경우 통신 끊김으로 판단
//    begin
//      Li := StrToInt(rec.FTopic); //Index
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
//    else  //MQTT Receive
//    if rec.FTopic <> '' then
//    begin
//      LStr := GetEquipNo(rec.FTopic);
//      AdjustEquipStatus(LStr, rec.FMessage);
//    end;
  end;
end;

end.
