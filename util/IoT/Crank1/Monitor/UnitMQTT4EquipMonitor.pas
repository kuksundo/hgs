unit UnitMQTT4EquipMonitor;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, QProgress, Kit,
  iComponent, iVCLComponent, iCustomComponent, iMotor, Vcl.ComCtrls, Generics.Collections,
  AdvChartView, DBAdvChartView, Vcl.ExtCtrls, AdvOfficePager, Vcl.StdCtrls,
  UnitEquipStatusClass, UnitTimerPool, UnitMQTTClass, UnitWorker4OmniMsgQ,
  UnitMQTTClientConfig, Vcl.Menus;

const
  COMM_CHECK_INTERVAL = 30000; //5분
  MQ_TOPIC = '/dev/mc/#/';
  EquipNameAry : array [0..29] of string = ( //크랑크 1공장 가공장비 리스트
    '394','391','392','351','393','387','358','389','396','259',
    '258','253','252','251','388','385','384','399','327','386',
    '254','257','322','324','346','325','345','344','339','294'
    );

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
    AdvOfficePager13: TAdvOfficePage;
    AdvChartView1: TAdvChartView;
    StatusBar1: TStatusBar;
    Panel69: TPanel;
    Panel139: TPanel;
    Panel140: TPanel;
    Panel142: TPanel;
    Panel146: TPanel;
    Panel150: TPanel;
    Panel151: TPanel;
    Panel152: TPanel;
    M_327: TiMotor;
    Panel124: TPanel;
    Panel125: TPanel;
    Panel127: TPanel;
    Panel130: TPanel;
    Panel131: TPanel;
    Panel132: TPanel;
    Panel133: TPanel;
    M_399: TiMotor;
    Panel70: TPanel;
    Panel71: TPanel;
    Panel73: TPanel;
    Panel76: TPanel;
    M_384: TiMotor;
    Panel78: TPanel;
    Panel79: TPanel;
    Panel81: TPanel;
    Panel82: TPanel;
    Panel83: TPanel;
    Panel85: TPanel;
    Panel90: TPanel;
    M_385: TiMotor;
    Panel91: TPanel;
    Panel95: TPanel;
    Panel98: TPanel;
    Panel99: TPanel;
    Panel100: TPanel;
    Panel102: TPanel;
    Panel105: TPanel;
    M_388: TiMotor;
    Panel106: TPanel;
    Panel107: TPanel;
    Panel108: TPanel;
    Panel109: TPanel;
    Panel110: TPanel;
    Panel112: TPanel;
    Panel115: TPanel;
    M_251: TiMotor;
    Panel116: TPanel;
    Panel117: TPanel;
    Panel118: TPanel;
    Panel119: TPanel;
    Panel120: TPanel;
    Panel122: TPanel;
    Panel135: TPanel;
    M_252: TiMotor;
    Panel136: TPanel;
    Panel137: TPanel;
    Panel138: TPanel;
    Panel145: TPanel;
    Panel147: TPanel;
    Panel149: TPanel;
    Panel155: TPanel;
    M_253: TiMotor;
    Panel156: TPanel;
    Panel157: TPanel;
    Panel158: TPanel;
    Panel159: TPanel;
    Panel160: TPanel;
    Panel162: TPanel;
    Panel165: TPanel;
    M_258: TiMotor;
    Panel166: TPanel;
    Panel167: TPanel;
    Panel168: TPanel;
    Panel169: TPanel;
    Panel170: TPanel;
    Panel171: TPanel;
    Panel173: TPanel;
    Panel176: TPanel;
    M_394: TiMotor;
    Panel177: TPanel;
    Panel178: TPanel;
    Panel179: TPanel;
    Panel180: TPanel;
    Panel181: TPanel;
    Panel183: TPanel;
    Panel186: TPanel;
    M_391: TiMotor;
    Panel187: TPanel;
    Panel188: TPanel;
    Panel189: TPanel;
    Panel190: TPanel;
    Panel191: TPanel;
    Panel193: TPanel;
    Panel196: TPanel;
    M_392: TiMotor;
    Panel197: TPanel;
    Panel198: TPanel;
    Panel199: TPanel;
    Panel200: TPanel;
    Panel201: TPanel;
    Panel203: TPanel;
    Panel206: TPanel;
    M_351: TiMotor;
    Panel207: TPanel;
    Panel208: TPanel;
    Panel209: TPanel;
    Panel210: TPanel;
    Panel211: TPanel;
    Panel213: TPanel;
    Panel216: TPanel;
    M_393: TiMotor;
    Panel217: TPanel;
    Panel218: TPanel;
    Panel219: TPanel;
    Panel220: TPanel;
    Panel221: TPanel;
    Panel223: TPanel;
    Panel226: TPanel;
    M_387: TiMotor;
    Panel227: TPanel;
    Panel228: TPanel;
    Panel229: TPanel;
    Panel230: TPanel;
    Panel231: TPanel;
    Panel233: TPanel;
    Panel236: TPanel;
    M_358: TiMotor;
    Panel237: TPanel;
    Panel238: TPanel;
    Panel239: TPanel;
    Panel240: TPanel;
    Panel241: TPanel;
    Panel243: TPanel;
    Panel246: TPanel;
    M_389: TiMotor;
    Panel247: TPanel;
    Panel248: TPanel;
    Panel249: TPanel;
    Panel250: TPanel;
    Panel251: TPanel;
    Panel253: TPanel;
    Panel256: TPanel;
    M_396: TiMotor;
    Panel257: TPanel;
    Panel260: TPanel;
    Panel261: TPanel;
    Panel263: TPanel;
    Panel266: TPanel;
    iMotor19: TiMotor;
    Panel267: TPanel;
    Panel268: TPanel;
    Panel269: TPanel;
    Panel270: TPanel;
    Panel271: TPanel;
    Panel273: TPanel;
    Panel276: TPanel;
    M_386: TiMotor;
    Panel277: TPanel;
    Panel278: TPanel;
    Panel279: TPanel;
    Memo1: TMemo;
    Panel280: TPanel;
    Panel311: TPanel;
    Panel312: TPanel;
    Panel314: TPanel;
    Panel317: TPanel;
    M_341: TiMotor;
    Panel318: TPanel;
    Panel319: TPanel;
    Panel320: TPanel;
    Panel321: TPanel;
    Panel322: TPanel;
    Panel324: TPanel;
    Panel327: TPanel;
    M_254: TiMotor;
    Panel328: TPanel;
    Panel329: TPanel;
    Panel330: TPanel;
    Panel331: TPanel;
    Panel332: TPanel;
    Panel334: TPanel;
    Panel337: TPanel;
    M_257: TiMotor;
    Panel338: TPanel;
    Panel339: TPanel;
    Panel340: TPanel;
    Panel341: TPanel;
    Panel342: TPanel;
    Panel344: TPanel;
    Panel347: TPanel;
    M_350: TiMotor;
    Panel348: TPanel;
    Panel349: TPanel;
    Panel350: TPanel;
    Panel351: TPanel;
    Panel352: TPanel;
    Panel354: TPanel;
    Panel357: TPanel;
    M_342: TiMotor;
    Panel358: TPanel;
    Panel359: TPanel;
    Panel360: TPanel;
    Panel361: TPanel;
    Panel362: TPanel;
    Panel364: TPanel;
    Panel367: TPanel;
    M_322: TiMotor;
    Panel368: TPanel;
    Panel369: TPanel;
    Panel370: TPanel;
    Panel281: TPanel;
    Panel282: TPanel;
    Panel283: TPanel;
    Panel285: TPanel;
    Panel288: TPanel;
    M_346: TiMotor;
    Panel289: TPanel;
    Panel290: TPanel;
    Panel291: TPanel;
    Panel292: TPanel;
    Panel293: TPanel;
    Panel295: TPanel;
    Panel298: TPanel;
    M_325: TiMotor;
    Panel299: TPanel;
    Panel300: TPanel;
    Panel301: TPanel;
    Panel302: TPanel;
    Panel303: TPanel;
    Panel305: TPanel;
    Panel308: TPanel;
    M_345: TiMotor;
    Panel309: TPanel;
    Panel310: TPanel;
    Panel371: TPanel;
    Panel372: TPanel;
    Panel373: TPanel;
    Panel375: TPanel;
    Panel378: TPanel;
    M_344: TiMotor;
    Panel379: TPanel;
    Panel380: TPanel;
    Panel381: TPanel;
    Panel382: TPanel;
    Panel383: TPanel;
    Panel385: TPanel;
    Panel388: TPanel;
    M_339: TiMotor;
    Panel389: TPanel;
    Panel390: TPanel;
    Panel391: TPanel;
    Panel392: TPanel;
    Panel393: TPanel;
    Panel395: TPanel;
    Panel398: TPanel;
    M_294: TiMotor;
    Panel399: TPanel;
    Panel400: TPanel;
    Panel401: TPanel;
    Panel432: TPanel;
    Panel433: TPanel;
    Panel435: TPanel;
    Panel438: TPanel;
    M_324: TiMotor;
    Panel439: TPanel;
    Panel440: TPanel;
    Panel441: TPanel;
    LayOutPage2: TAdvOfficePage;
    NO_396: TPanel;
    K_396: TKit;
    Panel254: TPanel;
    Panel255: TPanel;
    NO_389: TPanel;
    NO_358: TPanel;
    NO_387: TPanel;
    NO_393: TPanel;
    NO_351: TPanel;
    NO_392: TPanel;
    NO_258: TPanel;
    NO_253: TPanel;
    NO_252: TPanel;
    NO_251: TPanel;
    NO_388: TPanel;
    NO_385: TPanel;
    NO_384: TPanel;
    NO_399: TPanel;
    NO_322: TPanel;
    NO_342: TPanel;
    NO_350: TPanel;
    NO_257: TPanel;
    NO_294: TPanel;
    NO_339: TPanel;
    NO_344: TPanel;
    NO_345: TPanel;
    NO_325: TPanel;
    NO_391: TPanel;
    NO_394: TPanel;
    NO_327: TPanel;
    NO_386: TPanel;
    NO_254: TPanel;
    NO_341: TPanel;
    NO_346: TPanel;
    NO_324: TPanel;
    Panel262: TPanel;
    K_389: TKit;
    K_358: TKit;
    K_387: TKit;
    K_393: TKit;
    K_351: TKit;
    K_392: TKit;
    K_391: TKit;
    K_258: TKit;
    K_253: TKit;
    K_252: TKit;
    K_251: TKit;
    K_388: TKit;
    K_385: TKit;
    K_384: TKit;
    K_399: TKit;
    K_322: TKit;
    K_342: TKit;
    K_350: TKit;
    K_257: TKit;
    K_294: TKit;
    K_339: TKit;
    K_344: TKit;
    K_394: TKit;
    Kit25: TKit;
    K_327: TKit;
    K_386: TKit;
    K_345: TKit;
    K_325: TKit;
    K_346: TKit;
    K_324: TKit;
    K_341: TKit;
    K_254: TKit;
    Panel74: TPanel;
    Panel75: TPanel;
    Panel87: TPanel;
    Kit1: TKit;
    Panel88: TPanel;
    Panel103: TPanel;
    Panel104: TPanel;
    Panel113: TPanel;
    Panel114: TPanel;
    Panel123: TPanel;
    Panel128: TPanel;
    Panel129: TPanel;
    Kit2: TKit;
    Panel134: TPanel;
    Panel143: TPanel;
    Panel144: TPanel;
    Panel153: TPanel;
    Panel154: TPanel;
    Panel163: TPanel;
    Panel164: TPanel;
    Panel174: TPanel;
    Kit3: TKit;
    Panel175: TPanel;
    Panel184: TPanel;
    Panel185: TPanel;
    Panel194: TPanel;
    Panel195: TPanel;
    Panel204: TPanel;
    Panel205: TPanel;
    Panel214: TPanel;
    Kit4: TKit;
    Panel215: TPanel;
    Panel224: TPanel;
    Panel225: TPanel;
    Panel234: TPanel;
    Panel235: TPanel;
    Panel244: TPanel;
    Panel245: TPanel;
    Panel258: TPanel;
    Kit5: TKit;
    Panel259: TPanel;
    Panel264: TPanel;
    Panel265: TPanel;
    Panel274: TPanel;
    Panel275: TPanel;
    Panel286: TPanel;
    Panel287: TPanel;
    Panel296: TPanel;
    Kit6: TKit;
    Panel297: TPanel;
    Panel306: TPanel;
    Panel307: TPanel;
    Panel315: TPanel;
    Panel316: TPanel;
    Panel325: TPanel;
    Panel326: TPanel;
    Panel335: TPanel;
    Kit7: TKit;
    Panel336: TPanel;
    Panel345: TPanel;
    Panel346: TPanel;
    Panel355: TPanel;
    Panel356: TPanel;
    Panel365: TPanel;
    Panel366: TPanel;
    Panel376: TPanel;
    Kit8: TKit;
    Panel377: TPanel;
    Panel386: TPanel;
    Panel387: TPanel;
    Panel396: TPanel;
    Panel397: TPanel;
    Panel402: TPanel;
    Panel403: TPanel;
    Panel404: TPanel;
    Kit9: TKit;
    Panel405: TPanel;
    Panel406: TPanel;
    Panel407: TPanel;
    Panel408: TPanel;
    Panel409: TPanel;
    Panel410: TPanel;
    Panel411: TPanel;
    Panel412: TPanel;
    Kit10: TKit;
    Panel413: TPanel;
    Panel414: TPanel;
    Panel415: TPanel;
    Panel416: TPanel;
    Panel417: TPanel;
    Panel418: TPanel;
    Panel419: TPanel;
    Panel420: TPanel;
    Panel421: TPanel;
    Kit11: TKit;
    Panel422: TPanel;
    Panel423: TPanel;
    Panel424: TPanel;
    Panel425: TPanel;
    Panel426: TPanel;
    Panel427: TPanel;
    Panel428: TPanel;
    Panel429: TPanel;
    Kit12: TKit;
    Panel430: TPanel;
    Panel431: TPanel;
    Panel436: TPanel;
    Panel437: TPanel;
    Panel442: TPanel;
    Panel443: TPanel;
    Panel444: TPanel;
    Panel445: TPanel;
    Kit13: TKit;
    Panel446: TPanel;
    Panel447: TPanel;
    Panel448: TPanel;
    Panel449: TPanel;
    Panel450: TPanel;
    Panel451: TPanel;
    Panel452: TPanel;
    Panel453: TPanel;
    Kit14: TKit;
    Panel454: TPanel;
    Panel455: TPanel;
    Panel456: TPanel;
    Panel457: TPanel;
    Panel458: TPanel;
    Panel459: TPanel;
    Panel460: TPanel;
    Panel461: TPanel;
    Kit15: TKit;
    Panel462: TPanel;
    Panel463: TPanel;
    Panel464: TPanel;
    Panel465: TPanel;
    Panel466: TPanel;
    Panel467: TPanel;
    Panel468: TPanel;
    Panel469: TPanel;
    Kit16: TKit;
    Panel470: TPanel;
    Panel471: TPanel;
    Panel472: TPanel;
    Panel473: TPanel;
    Panel474: TPanel;
    Panel475: TPanel;
    Panel476: TPanel;
    Panel477: TPanel;
    Kit17: TKit;
    Panel478: TPanel;
    Panel479: TPanel;
    Panel480: TPanel;
    Panel481: TPanel;
    Panel482: TPanel;
    Panel483: TPanel;
    Panel484: TPanel;
    Panel485: TPanel;
    Kit18: TKit;
    Panel486: TPanel;
    Panel487: TPanel;
    Panel488: TPanel;
    Panel489: TPanel;
    Panel490: TPanel;
    Panel491: TPanel;
    Panel492: TPanel;
    Panel493: TPanel;
    Kit19: TKit;
    Panel494: TPanel;
    Panel495: TPanel;
    Panel496: TPanel;
    Panel497: TPanel;
    Panel498: TPanel;
    Panel499: TPanel;
    Panel500: TPanel;
    Panel501: TPanel;
    Kit20: TKit;
    Panel502: TPanel;
    Panel503: TPanel;
    Panel504: TPanel;
    Panel505: TPanel;
    Panel506: TPanel;
    Panel507: TPanel;
    Panel508: TPanel;
    Panel509: TPanel;
    Panel510: TPanel;
    Kit21: TKit;
    Panel511: TPanel;
    Panel512: TPanel;
    Panel513: TPanel;
    Panel514: TPanel;
    Panel515: TPanel;
    Panel516: TPanel;
    Panel517: TPanel;
    Panel518: TPanel;
    Kit22: TKit;
    Panel519: TPanel;
    Panel520: TPanel;
    Panel521: TPanel;
    Panel522: TPanel;
    Panel523: TPanel;
    Panel524: TPanel;
    Panel525: TPanel;
    Panel526: TPanel;
    Kit23: TKit;
    Panel527: TPanel;
    Panel528: TPanel;
    Panel529: TPanel;
    Panel530: TPanel;
    Panel531: TPanel;
    Panel532: TPanel;
    Panel533: TPanel;
    Panel534: TPanel;
    Kit24: TKit;
    Panel535: TPanel;
    Panel536: TPanel;
    Panel537: TPanel;
    Panel538: TPanel;
    Panel539: TPanel;
    Panel540: TPanel;
    Panel541: TPanel;
    Panel542: TPanel;
    Kit26: TKit;
    Panel543: TPanel;
    Panel544: TPanel;
    Panel545: TPanel;
    Panel546: TPanel;
    Panel547: TPanel;
    Panel548: TPanel;
    Panel549: TPanel;
    Panel550: TPanel;
    Kit27: TKit;
    Panel551: TPanel;
    Panel552: TPanel;
    Panel553: TPanel;
    Panel554: TPanel;
    Panel555: TPanel;
    Panel556: TPanel;
    Panel557: TPanel;
    Panel558: TPanel;
    Panel559: TPanel;
    Kit28: TKit;
    Panel560: TPanel;
    Panel561: TPanel;
    Panel562: TPanel;
    Panel563: TPanel;
    Panel564: TPanel;
    Panel565: TPanel;
    Panel566: TPanel;
    Panel567: TPanel;
    Kit29: TKit;
    Panel568: TPanel;
    Panel569: TPanel;
    Panel570: TPanel;
    Panel571: TPanel;
    Panel572: TPanel;
    Panel573: TPanel;
    Panel574: TPanel;
    Panel575: TPanel;
    Kit30: TKit;
    Panel576: TPanel;
    Panel577: TPanel;
    Panel578: TPanel;
    Panel579: TPanel;
    Panel580: TPanel;
    Panel581: TPanel;
    Panel582: TPanel;
    Panel583: TPanel;
    Kit31: TKit;
    Panel584: TPanel;
    Panel585: TPanel;
    Panel586: TPanel;
    Panel587: TPanel;
    Panel588: TPanel;
    Panel589: TPanel;
    Panel590: TPanel;
    Panel591: TPanel;
    Kit32: TKit;
    Panel592: TPanel;
    Panel593: TPanel;
    Panel594: TPanel;
    Panel595: TPanel;
    Panel596: TPanel;
    Panel597: TPanel;
    Panel598: TPanel;
    Panel599: TPanel;
    Kit33: TKit;
    Panel600: TPanel;
    Panel601: TPanel;
    Panel602: TPanel;
    Panel603: TPanel;
    Panel604: TPanel;
    Panel605: TPanel;
    Panel606: TPanel;
    Panel607: TPanel;
    Kit34: TKit;
    Panel608: TPanel;
    Panel609: TPanel;
    Panel610: TPanel;
    Panel611: TPanel;
    Panel612: TPanel;
    Panel613: TPanel;
    Memo2: TMemo;
    QProgress3: TQProgress;
    QProgress4: TQProgress;
    QProgress5: TQProgress;
    QProgress6: TQProgress;
    QProgress7: TQProgress;
    QProgress8: TQProgress;
    QProgress9: TQProgress;
    QProgress10: TQProgress;
    QProgress11: TQProgress;
    QProgress12: TQProgress;
    QProgress13: TQProgress;
    QProgress14: TQProgress;
    QProgress15: TQProgress;
    QProgress16: TQProgress;
    QProgress17: TQProgress;
    QProgress18: TQProgress;
    QProgress19: TQProgress;
    QProgress20: TQProgress;
    QProgress21: TQProgress;
    QProgress22: TQProgress;
    QProgress23: TQProgress;
    QProgress24: TQProgress;
    QProgress25: TQProgress;
    QProgress26: TQProgress;
    QProgress27: TQProgress;
    QProgress2: TQProgress;
    QProgress28: TQProgress;
    QProgress29: TQProgress;
    QProgress30: TQProgress;
    QProgress31: TQProgress;
    QProgress32: TQProgress;
    QProgress33: TQProgress;
    QProgress34: TQProgress;
    Panel72: TPanel;
    Panel84: TPanel;
    K_259: TKit;
    Panel101: TPanel;
    NO_259: TPanel;
    Panel121: TPanel;
    M_259: TiMotor;
    Panel126: TPanel;
    Panel141: TPanel;
    Panel148: TPanel;
    MainMenu1: TMainMenu;
    File1: TMenuItem;
    Option1: TMenuItem;
    Config1: TMenuItem;
    Close1: TMenuItem;
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
  end;

var
  Form9: TForm9;

implementation

uses OtlComm, UnitMQTTMsg.EventThreads, UnitMQTTMsg.Events;

{$R *.dfm}

{ TForm9 }

procedure TForm9.AdjustEquipStatus(AEquipNo, AStatus: string);
var
  idx,iNum,iPreLen: Integer;
  LMotor: TiMotor;
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
        Lines.Add(msg);
      end;//with
    end;//dtSystemLog
  end;//case
end;

procedure TForm9.FinalizeVar;
begin
  FPJHTimerPool.RemoveAll;
  FPJHTimerPool.Free;
  DestroyMQTT;
  FEquipStatusInfo.Free;
  FOnUpdateCommStatusList.Free;
  FHandleUpdateCommStatusList.Free;
  FConfigSettings.Free;
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
    Result := LStrList.Strings[2];
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
    LComponent := FindComponent('M_' + EquipNameAry[i]);//TiMotor

    if Assigned(LComponent) then
      LESItem.RunComponent := LComponent;

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
  FOnUpdateCommStatusList := TDictionary<string, TVpTimerTriggerEvent>.create;
  FHandleUpdateCommStatusList := TDictionary<integer, TVpTimerTriggerEvent>.Create;
  InitOnUpdateCommStatusList;
  //가공장비 리스트를 FEquipStatusInfo에 저장함
  InitEquipRunComponent;

  MQTTMsgEventThread.SetDisplayMsgProc(DisplayMessage2Memo);
  InitMQTT('','','127.0.0.1',MQ_TOPIC);
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
      if Assigned(LEquipStatusItem.OnUpdateCommStatus) then
        j := FPJHTimerPool.AddOneShot(LEquipStatusItem.OnUpdateCommStatus,COMM_CHECK_INTERVAL);

      if Assigned(LEquipStatusItem.RunComponent) then
      begin
        LIsRun := AValue = '1';

        if AdvOfficePager1.ActivePage = LayOutPage1 then
        begin
          if LIsRun <> TiMotor(LEquipStatusItem.RunComponent).FanOn then
            TiMotor(LEquipStatusItem.RunComponent).FanOn := LIsRun;
        end
        else
        if AdvOfficePager1.ActivePage = LayOutPage2 then
        begin

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
  LStr: string;
  LHandle, Li: integer;
  LESItem: TEquipStatusItem;
begin
  while FpjhMQTTClass.GetResponseQMsg(Amsg) do
  begin
    if FSuspending then
      continue;

    rec := Amsg.MsgData.ToRecord<TCommandMsgRecord>;

    if rec.FCommand = 4 then //일정 시간 내 데이터 없을 경우 통신 끊김으로 판단
    begin
//        LHandle := StrToInt(rec.FMessage); //Timer Handle이 문자로 옴
      Li := StrToInt(rec.FTopic); //Index
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
    else  //MQTT Receive
    if rec.FTopic <> '' then
    begin
      LStr := GetEquipNo(rec.FTopic);
      AdjustEquipStatus(LStr, rec.FMessage);
    end;
  end;
end;

end.
