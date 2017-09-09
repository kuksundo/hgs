unit UnitComponentIPCMonitorAll2;
{ Drag Drop과 WM_COPYDATA는 메인 폼에서 구현 할 것
 }
interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms, ComCtrls,
  Dialogs, NxCustomGridControl, NxCustomGrid, NxGrid, JvStatusBar, ShadowButton,
  TimerPool, DragDrop, DropTarget, DragDropText, AdvOfficePager,
  UnitFrameIPCConst, janSQL, CommonUtil, DeCAL, HiMECSConst,
  ConfigOptionClass, EngineParameterClass, ModbusComStruct,
  IPC_LBX_Const, IPC_WT1600_Const, IPC_ECS_kumo_Const, IPC_MEXA7000_Const,
  IPC_MT210_Const, IPC_DYNAMO_Const, IPC_ECS_AVAT_Const, IPC_GasCalc_Const,
  IPC_Kral_Const, IPC_ECS_Woodward_Const, IPC_PLC_S7_Const, IPC_FlowMeter_Const,
  IPC_EngineParam_Const, IPC_HIC_Const, IPC_Modbus_Standard_Const,
  IPCThreadEvent, IPCThrdMonitor_Generic, IPC_PMS_Const
 {$IFDEF USECODESITE} ,CodeSiteLogging {$ENDIF};

type
  TFrameIPCMonitorAll = class;

  TIPCMonitorClass = class
    FSharedName: string;
    FParamSource: TParameterSource;
  public
    FIPCObject: Pointer;
    FIPCMethod: Pointer;

    constructor create; overload;
    destructor destroy; override;
  published
    property SharedName: string read FSharedName write FSharedName;
    property ParamSource: TParameterSource read FParamSource write FParamSource;
//    property IPCObject: integer read FIPCObject write FIPCObject;
  end;

  TWT1600_Method = class
  public
    FIPCAll: TFrameIPCMonitorAll;
    FPSnSN: string;

    constructor create(AIPCAll: TFrameIPCMonitorAll); overload;
    destructor destroy; override;

    procedure WT1600_OnSignal(Data: TEventData_WT1600); virtual;
    procedure OverRide_WT1600(AIndex: integer); virtual;
  end;

  TMEXA7000_Method = class
  public
    FIPCAll: TFrameIPCMonitorAll;
    FPSnSN: string;

    constructor create(AIPCAll: TFrameIPCMonitorAll); overload;
    destructor destroy; override;

    procedure MEXA7000_OnSignal(Data: TEventData_MEXA7000); virtual;
    procedure OverRide_MEXA7000(AIndex: integer); virtual;
  end;

  TMEXA700_2_Method = class
  public
    FIPCAll: TFrameIPCMonitorAll;
    FPSnSN: string;

    constructor create(AIPCAll: TFrameIPCMonitorAll); overload;
    destructor destroy; override;

    procedure MEXA7000_2_OnSignal(Data: TEventData_MEXA7000_2); virtual;
    procedure OverRide_MEXA7000(AIndex: integer); virtual;
  end;

  TMT210_Method = class
  public
    FIPCAll: TFrameIPCMonitorAll;
    FPSnSN: string;

    constructor create(AIPCAll: TFrameIPCMonitorAll); overload;
    destructor destroy; override;

    procedure MT210_OnSignal(Data: TEventData_MT210); virtual;
    procedure OverRide_MT210(AIndex: integer); virtual;
  end;

  TECS_kumo_Method = class
  public
    FIPCAll: TFrameIPCMonitorAll;
    FPSnSN: string;

    constructor create(AIPCAll: TFrameIPCMonitorAll); overload;
    destructor destroy; override;

    procedure ECS_OnSignal_kumo(Data: TEventData_ECS_kumo); virtual;
    procedure OverRide_ECS_kumo(AIndex: integer); virtual;
    procedure OverRide_ECS_kumo2(AIndex: integer); virtual;
  end;

  TECS_AVAT_Method = class
  public
    FIPCAll: TFrameIPCMonitorAll;
    FPSnSN: string;

    constructor create(AIPCAll: TFrameIPCMonitorAll); overload;
    destructor destroy; override;

    procedure ECS_OnSignal_AVAT(Data: TEventData_ECS_AVAT); virtual;
    procedure OverRide_ECS_AVAT(AIndex: integer); virtual;
  end;

  TECS_Woodward_Method = class
  public
    FIPCAll: TFrameIPCMonitorAll;
    FPSnSN: string;

    constructor create(AIPCAll: TFrameIPCMonitorAll); overload;
    destructor destroy; override;

    procedure ECS_OnSignal_Woodward(Data: TEventData_ECS_Woodward); virtual;
    procedure OverRide_ECS_Woodward(AIndex: integer); virtual;
  end;

  TLBX_Method = class
  public
    FIPCAll: TFrameIPCMonitorAll;
    FPSnSN: string;

    constructor create(AIPCAll: TFrameIPCMonitorAll); overload;
    destructor destroy; override;

    procedure LBX_OnSignal(Data: TEventData_LBX); virtual;
    procedure OverRide_LBX(AIndex: integer); virtual;
  end;

  TFlowMeter_Method = class
  public
    FIPCAll: TFrameIPCMonitorAll;
    FPSnSN: string;

    constructor create(AIPCAll: TFrameIPCMonitorAll); overload;
    destructor destroy; override;

    procedure FlowMeter_OnSignal(Data: TEventData_FlowMeter); virtual;
    procedure OverRide_FlowMeter(AIndex: integer); virtual;
  end;

  TDYNAMO_Method = class
  public
    FIPCAll: TFrameIPCMonitorAll;
    FPSnSN: string;

    constructor create(AIPCAll: TFrameIPCMonitorAll); overload;
    destructor destroy; override;

    procedure DYNAMO_OnSignal(Data: TEventData_DYNAMO); virtual;
    procedure OverRide_DYNAMO(AIndex: integer); virtual;
  end;

  TGasCalc_Method = class
  public
    FIPCAll: TFrameIPCMonitorAll;
    FPSnSN: string;

    constructor create(AIPCAll: TFrameIPCMonitorAll); overload;
    destructor destroy; override;

    procedure GasCalc_OnSignal(Data: TEventData_GasCalc); virtual;
    procedure OverRide_GasCalc(AIndex: integer); virtual;
  end;

  TKRAL_Method = class
  public
    FIPCAll: TFrameIPCMonitorAll;
    FPSnSN: string;

    constructor create(AIPCAll: TFrameIPCMonitorAll); overload;
    destructor destroy; override;

    procedure KRAL_OnSignal(Data: TEventData_Modbus_Standard); virtual;
    procedure OverRide_KRAL(AIndex: integer); virtual;
  end;

  TPLC_S7_Method = class
  public
    FIPCAll: TFrameIPCMonitorAll;
    FPSnSN: string;

    constructor create(AIPCAll: TFrameIPCMonitorAll); overload;
    destructor destroy; override;

    procedure PLC_S7_OnSignal(Data: TEventData_PLC_S7); virtual;
    procedure OverRide_PLC_S7(AIndex: integer); virtual;
  end;

  TEngineParam_Method = class
  public
    FIPCAll: TFrameIPCMonitorAll;
    FPSnSN: string;

    constructor create(AIPCAll: TFrameIPCMonitorAll); overload;
    destructor destroy; override;

    procedure EngineParam_OnSignal(Data: TEventData_EngineParam); virtual;
    procedure OverRide_EngineParam(AIndex: integer); virtual;
  end;

  THIC_Method = class
  public
    FIPCAll: TFrameIPCMonitorAll;
    FPSnSN: string;

    constructor create(AIPCAll: TFrameIPCMonitorAll); overload;
    destructor destroy; override;

    procedure HIC_OnSignal(Data: TEventData_HIC); virtual;
    procedure OverRide_HIC(AIndex: integer); virtual;
  end;

  TPLCMODBUS_Method = class
  public
    FIPCAll: TFrameIPCMonitorAll;
    FPSnSN: string;

    constructor create(AIPCAll: TFrameIPCMonitorAll); overload;
    destructor destroy; override;

    procedure PLCMODBUS_OnSignal(Data: TEventData_Modbus_Standard); virtual;
    procedure OverRide_PLCMODBUS(AIndex: integer); virtual;
  end;

  TPMS_Method = class
  public
    FIPCAll: TFrameIPCMonitorAll;
    FPSnSN: string;

    constructor create(AIPCAll: TFrameIPCMonitorAll); overload;
    destructor destroy; override;

    procedure PMS_OnSignal(Data: TEventData_PMS); virtual;
    procedure OverRide_PMS(AIndex: integer); virtual;
  end;

  TECS_ComAP_Method = class
  public
    FIPCAll: TFrameIPCMonitorAll;
    FPSnSN: string;
    FECS_OnSignal: Boolean;

    constructor create(AIPCAll: TFrameIPCMonitorAll); overload;
    destructor destroy; override;

    procedure ECS_OnSignal_ComAP(Data: TEventData_Modbus_Standard); virtual;
    procedure OverRide_ECS_ComAP(AIndex: integer); virtual;
  end;

  TWatchValue2Screen_AnalogEvent =
    procedure(Name: string; AValue: string; AEPIndex: integer) of object;
  TWatchValue2Screen_DigitalEvent =
    procedure(Name: string; AValue: string; AEPIndex: integer) of object;

  TFrameIPCMonitorAll = class(TFrame)
  private
    FAddressMap: DMap;      //Modbus Map 데이타 저장 구초체

//    FECSData_kumo: TEventData_ECS_kumo;
//    FECSData_AVAT: TEventData_ECS_AVAT;
//    FECSData_Woodward: TEventData_ECS_Woodward;
//    FMEXA7000Data: TEventData_MEXA7000_2;
//    FLBXData: TEventData_LBX;
//    FWT1600Data: TEventData_WT1600;
//    FMT210Data: TEventData_MT210;
//    FDYNAMOData: TEventData_DYNAMO;
//    FFlowMeterData: TEventData_FlowMeter;
//    FGasCalcData: TEventData_GasCalc;
//    FKRALData: TEventData_Modbus_Standard;
//    FPLCData_S7: TEventData_PLC_S7;
//    FEngineParamData: TEventData_EngineParam;
//    FHICData: TEventData_HIC;
//    FPLCModbusData: TEventData_Modbus_Standard;
//    FPMSData: TEventData_PMS;
//    FECSData_ComAP: TEventData_Modbus_Standard;
//
//    FIPCMonitor_WT1600: TIPCMonitor<TEventData_WT1600>;//WT1600
//    FIPCMonitor_MEXA7000: TIPCMonitor<TEventData_MEXA7000_2>;//MEXA7000
//    FIPCMonitor_MT210: TIPCMonitor<TEventData_MT210>;//MT210
//    FIPCMonitor_ECS_kumo: TIPCMonitor<TEventData_ECS_kumo>;//kumo ECS
//    FIPCMonitor_ECS_AVAT: TIPCMonitor<TEventData_ECS_AVAT>;//AVAT ECS
//    FIPCMonitor_ECS_Woodward: TIPCMonitor<TEventData_ECS_Woodward>; //Woodward(AtlasII) ECS
//    FIPCMonitor_LBX: TIPCMonitor<TEventData_LBX>;//LBX
//    FIPCMonitor_FlowMeter: TIPCMonitor<TEventData_FlowMeter>;//FlowMeter
//    FIPCMonitor_Dynamo: TIPCMonitor<TEventData_DYNAMO>;//DynamoMeter
//    FIPCMonitor_GasCalc: TIPCMonitor<TEventData_GasCalc>;//Gas Total
//    FIPCMonitor_KRAL: TIPCMonitor<TEventData_Modbus_Standard>;//FlowMeter(KRAL)
//    FIPCMonitor_PLC_S7: TIPCMonitor<TEventData_PLC_S7>;//Siemens PLC S7-300
//    FIPCMonitor_EngineParam: TIPCMonitor<TEventData_EngineParam>;//Engine Parameter File
//    FIPCMonitor_HIC: TIPCMonitor<TEventData_HIC>;//Hybrid Injector Controller
//    FIPCMonitor_PLCModbus: TIPCMonitor<TEventData_Modbus_Standard>;//PLC Modbus
//    FIPCMonitor_PMS: TIPCMonitor<TEventData_PMS>;//PMS OPC
//    FIPCMonitor_ECS_ComAP: TIPCMonitor<TEventData_Modbus_Standard>;//ComAP ECS

    procedure UpdateTrace_WT1600(var Msg: TMessage); message WM_EVENT_WT1600;
    procedure UpdateTrace_MEXA7000(var Msg: TMessage); message WM_EVENT_MEXA7000;
    procedure UpdateTrace_MT210(var Msg: TMessage); message WM_EVENT_MT210;
    procedure UpdateTrace_ECS_kumo(var Msg: TMessage); message WM_EVENT_ECS_KUMO;
    procedure UpdateTrace_ECS_AVAT(var Msg: TMessage); message WM_EVENT_ECS_AVAT;
    procedure UpdateTrace_ECS_Woodward(var Msg: TMessage); message WM_EVENT_ECS_Woodward;
    procedure UpdateTrace_LBX(var Msg: TMessage); message WM_EVENT_LBX;
    procedure UpdateTrace_FlowMeter(var Msg: TMessage); message WM_EVENT_FLOWMETER;
    procedure UpdateTrace_DYNAMO(var Msg: TMessage); message WM_EVENT_DYNAMO;
    procedure UpdateTrace_GasCalc(var Msg: TMessage); message WM_EVENT_GASCALC;
    procedure UpdateTrace_KRAL(var Msg: TMessage); message WM_EVENT_KRAL;
    procedure UpdateTrace_PLC_S7(var Msg: TMessage); message WM_EVENT_PLC_S7;
    procedure UpdateTrace_EngineParam(var Msg: TMessage); message WM_EVENT_ENGINEPARAM;
    procedure UpdateTrace_HIC(var Msg: TMessage); message WM_EVENT_HIC;
    procedure UpdateTrace_PLCMODBUS(var Msg: TMessage); message WM_EVENT_PLCMODBUS;
    procedure UpdateTrace_PMS(var Msg: TMessage); message WM_EVENT_PMS;
    procedure UpdateTrace_ECS_ComAP(var Msg: TMessage); message WM_EVENT_ECS_COMAP;

    //WM_COPYDATA message를 받지 못함. Main Form에서 대신 처리
    //procedure WMCopyData(var Msg: TMessage); message WM_COPYDATA;

    procedure SendFormCopyData(ToHandle: integer; AForm:TForm);
  protected
    FEnterWatchValue2Screen: Boolean;

    FEngineParameterItemRecord: TEngineParameterItemRecord; //Save폼에 값 전달시 사용

//    procedure OverRide_WT1600(AData: TEventData_WT1600); virtual;
//    procedure OverRide_MEXA7000(AData: TEventData_MEXA7000_2); virtual;
//    procedure OverRide_MT210(AData: TEventData_MT210); virtual;
//    procedure OverRide_ECS_kumo(AData: TEventData_ECS_kumo); virtual;
//    procedure OverRide_ECS_kumo2(AData: TEventData_ECS_kumo); virtual;
//    procedure OverRide_ECS_AVAT(AData: TEventData_ECS_AVAT); virtual;
//    procedure OverRide_ECS_Woodward(AData: TEventData_ECS_Woodward); virtual;
//    procedure OverRide_LBX(AData: TEventData_LBX); virtual;
//    procedure OverRide_FlowMeter(AData: TEventData_FlowMeter); virtual;
//    procedure OverRide_DYNAMO(AData: TEventData_DYNAMO); virtual;
//    procedure OverRide_GasCalc(AData: TEventData_GasCalc); virtual;
//    procedure OverRide_KRAL(AData: TEventData_Modbus_Standard); virtual;
//    procedure OverRide_PLC_S7(AData: TEventData_PLC_S7); virtual;
//    procedure OverRide_EngineParam(AData: TEventData_EngineParam); virtual;
//    procedure OverRide_HIC(AData: TEventData_HIC); virtual;
//    procedure OverRide_PLCMODBUS(AData: TEventData_Modbus_Standard); virtual;
//    procedure OverRide_PMS(AData: TEventData_PMS); virtual;
//    procedure OverRide_ECS_ComAP(AData: TEventData_Modbus_Standard); virtual;


    procedure WatchValue2Screen_Analog(Name: string; AValue: string;
                           AEPIndex: integer; AIsFloat: Boolean = false);
    procedure WatchValue2Screen_Digital(Name: string; AValue: string;
                           AEPIndex: integer);
    procedure Value2Screen_ECS_kumo(AHiMap: THiMap; AEPIndex: integer; AModbusMode: integer);
    procedure Value2Screen_ECS_kumo2(AEPIndex: integer; AModbusMode: integer);
    procedure Value2Screen_ECS_AVAT(AHiMap: THiMap; AEPIndex: integer; AModbusMode: integer);
    procedure Value2Screen_ECS_Woodward(AEPIndex: integer; AModbusMode: integer);
    procedure Value2Screen_KRAL;

    procedure OnSetZeroWT1600(Sender : TObject; Handle : Integer;
            Interval : Cardinal; ElapsedTime : LongInt);
    procedure OnSetZeroMEXA7000(Sender : TObject; Handle : Integer;
            Interval : Cardinal; ElapsedTime : LongInt);
    procedure OnSetZeroMT210(Sender : TObject; Handle : Integer;
            Interval : Cardinal; ElapsedTime : LongInt);
    procedure OnSetZeroECS_kumo(Sender : TObject; Handle : Integer;
            Interval : Cardinal; ElapsedTime : LongInt);
    procedure OnSetZeroECS_AVAT(Sender : TObject; Handle : Integer;
            Interval : Cardinal; ElapsedTime : LongInt);
    procedure OnSetZeroECS_Woodward(Sender : TObject; Handle : Integer;
            Interval : Cardinal; ElapsedTime : LongInt);
    procedure OnSetZeroLBX(Sender : TObject; Handle : Integer;
            Interval : Cardinal; ElapsedTime : LongInt);
    procedure OnSetZeroFlowMeter(Sender : TObject; Handle : Integer;
            Interval : Cardinal; ElapsedTime : LongInt);
    procedure OnSetZeroDYNAMO(Sender : TObject; Handle : Integer;
            Interval : Cardinal; ElapsedTime : LongInt);
    procedure OnSetZeroGasCalc(Sender : TObject; Handle : Integer;
            Interval : Cardinal; ElapsedTime : LongInt);
    procedure OnSetZeroKRAL(Sender : TObject; Handle : Integer;
            Interval : Cardinal; ElapsedTime : LongInt);
    procedure OnSetZeroPLC_S7(Sender : TObject; Handle : Integer;
            Interval : Cardinal; ElapsedTime : LongInt);
    procedure OnSetZeroEngineParam(Sender : TObject; Handle : Integer;
            Interval : Cardinal; ElapsedTime : LongInt);
    procedure OnSetZeroHIC(Sender : TObject; Handle : Integer;
            Interval : Cardinal; ElapsedTime : LongInt);
    procedure OnSetZeroPLCMODBUS(Sender : TObject; Handle : Integer;
            Interval : Cardinal; ElapsedTime : LongInt);
    procedure OnSetZeroPMS(Sender : TObject; Handle : Integer;
            Interval : Cardinal; ElapsedTime : LongInt);
    procedure OnSetZeroECS_ComAP(Sender : TObject; Handle : Integer;
            Interval : Cardinal; ElapsedTime : LongInt);
  public
    FWatchValue2Screen_AnalogEvent: TWatchValue2Screen_AnalogEvent;
    FWatchValue2Screen_DigitalEvent: TWatchValue2Screen_DigitalEvent;
    FCurrentUserLevel: THiMECSUserLevel;
    FEngineParameter: TEngineParameter;

    //FConfigOption: TConfigOption;
    FModbusMapFileName: string;
    FFilePath: string;      //파일을 저장할 경로
    FCompleteReadMap_Avat,
    FCompleteReadMap_Woodward,
    FCompleteReadMap_kumo: Boolean; //Map file read 완료 했으면 True

    FNextGrid: TNextGrid;
    //FPageControl: TPageControl;
    FPageControl: TAdvOfficePager;
    FStatusBar: TjvStatusBar;

    FIsSetZeroWhenDisconnect: Boolean;// 통신이 일정시간 동안 안되면 구조체 값을 0으로
    FPJHTimerPool: TPJHTimerPool;
    FIPCMonitorList: TStringList;

    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;

    procedure InitVar;
    procedure DestroyVar;

    function CreateIPCMonitor(AEP_DragDrop: TEngineParameterItemRecord;
                            AIsOnlyCreate: Boolean = False;
              ADragCopyMode: TParamDragCopyMode = dcmCopyOnlyNonExist): integer;
    procedure CreateIPCMonitorFromParameter(var AIPCList: TStringList);
    procedure DestroyIPCMonitor(AIPCMonitor: TParameterSource);
    procedure DestroyIPCMonitorAll;
    function AssignedIPCMonitor(AIPCMonitor: TParameterSource): Boolean;

    procedure CreateECSkumoIPCMonitor(ASN, ASN2, APSnSN: string; AMonitor: TIPCMonitorClass);
    procedure CreateECSAVATIPCMonitor(ASN, ASN2, APSnSN: string; AMonitor: TIPCMonitorClass);
    procedure CreateECSWoodwardIPCMonitor(ASN, ASN2, APSnSN: string; AMonitor: TIPCMonitorClass);
    procedure CreateWT1600IPCMonitor(ASN, ASN2, APSnSN: string; AMonitor: TIPCMonitorClass);
    procedure CreateMT210IPCMonitor(ASN, ASN2, APSnSN: string; AMonitor: TIPCMonitorClass);
    procedure CreateMEXA7000IPCMonitor(ASN, ASN2, APSnSN: string; AMonitor: TIPCMonitorClass);
    procedure CreateLBXIPCMonitor(ASN, ASN2, APSnSN: string; AMonitor: TIPCMonitorClass);
    procedure CreateFlowMeterIPCMonitor(ASN, ASN2, APSnSN: string; AMonitor: TIPCMonitorClass);
    procedure CreateDynamoIPCMonitor(ASN, ASN2, APSnSN: string; AMonitor: TIPCMonitorClass);
    procedure CreateGasCalcIPCMonitor(ASN, ASN2, APSnSN: string; AMonitor: TIPCMonitorClass);
    procedure CreateKRALIPCMonitor(ASN, ASN2, APSnSN: string; AMonitor: TIPCMonitorClass);
    procedure CreatePLCS7IPCMonitor(ASN, ASN2, APSnSN: string; AMonitor: TIPCMonitorClass);
    procedure CreateEngineParamIPCMonitor(ASN, ASN2, APSnSN: string; AMonitor: TIPCMonitorClass);
    procedure CreateHICIPCMonitor(ASN, ASN2, APSnSN: string; AMonitor: TIPCMonitorClass);
    procedure CreatePLCMODBUSIPCMonitor(ASN, ASN2, APSnSN: string; AMonitor: TIPCMonitorClass);
    procedure CreatePMSIPCMonitor(ASN, ASN2, APSnSN: string; AMonitor: TIPCMonitorClass);
    procedure CreateECSComAPIPCMonitor(ASN, ASN2, APSnSN: string; AMonitor: TIPCMonitorClass);

    function CreateIPCMonitor_xx(AParameterSource: TParameterSource; ASharedName: string): String;
    function CreateIPCMonitor_ECS_AVAT(ASharedName: string = ''): String;
    function CreateIPCMonitor_ECS_Woodward(ASharedName: string = ''): String;
    function CreateIPCMonitor_DYNAMO(ASharedName: string = ''): String;
    function CreateIPCMonitor_FlowMeter(ASharedName: string = ''): String;
    function CreateIPCMonitor_LBX(ASharedName: string = ''): String;
    function CreateIPCMonitor_ECS_kumo(ASharedName: string = ''): String;
    function CreateIPCMonitor_MT210(ASharedName: string = ''): String;
    function CreateIPCMonitor_MEXA7000(ASharedName: string = ''): String;
    function CreateIPCMonitor_WT1600(ASharedName: string = ''): String;
    function CreateIPCMonitor_GasCalc(ASharedName: string = ''): String;
    function CreateIPCMonitor_KRAL(ASharedName: string = ''): String;
    function CreateIPCMonitor_PLC_S7(ASharedName: string = ''): String;
    function CreateIPCMonitor_EngineParam(ASharedName: string = ''): String;
    function CreateIPCMonitor_HIC(ASharedName: string = ''): String;
    function CreateIPCMonitor_PLCMODBUS(ASharedName: string = ''): String;
    function CreateIPCMonitor_PMS(ASharedName: string = ''): String;
    function CreateIPCMonitor_ECS_ComAP(ASharedName: string = ''): String;

    function MoveEngineParameterItemRecord(AEPItemRecord:TEngineParameterItemRecord;
                 ADragCopyMode: TParamDragCopyMode = dcmCopyOnlyNonExist): integer; virtual;
    procedure MoveEngineParameterItemRecord2(var AItemRecord: TEngineParameterItemRecord;
                                              AItemIndex: integer);

    procedure ReadMapAddress(AddressMap: DMap; MapFileName: string); virtual;
    procedure ReadMapAddressFromParamFile(AFilename: string;
      AEngParamEncrypt: Boolean; AModBusBlockList:DList); virtual;
    procedure SetModbusMapFileName(AFileName: string; APSrc: TParameterSource);
    procedure MakeMapFromParameter;

    function CheckUserLevelForWatchListFile(AFileName: string;
                          var AUserLevel: THiMECSUserLevel): Boolean;
    function CheckExeFileNameForWatchListFile(AFileName: string): string;
    function CheckExistTagName(AParameterSource: TParameterSource;
                                                  ATagName: string): integer;

    procedure DisplayMessage(Msg: string);
    procedure DisplayMessage2SB(AStatusBar: TjvStatusBar; Msg: string);
    procedure SetValue2ScreenEvent(AAnalogFunc: TWatchValue2Screen_AnalogEvent;
      ADigitalFunc: TWatchValue2Screen_DigitalEvent);

    procedure GetParameterSourceList(var AList: TStringList);

    procedure PulseEventSimulate(AIndex: integer);
  end;

  procedure CommonCommunication(AParameterSource: TParameterSource);

var
  g_FrameHandle: THandle;
  g_CommDisconnected: Boolean;// 통신이 일정시간 동안 안되면 True

implementation

{$R *.dfm}


procedure CommonCommunication(AParameterSource: TParameterSource);
begin
  if g_CommDisconnected then
    g_CommDisconnected := False;
end;

{ TFrame1 }

//IPC Monitor가 할당 되었으면 True 반환
function TFrameIPCMonitorAll.AssignedIPCMonitor(
  AIPCMonitor: TParameterSource): Boolean;
begin
//  case AIPCMonitor of
//    psECS_kumo: Result := Assigned(FIPCMonitor_ECS_kumo);
//    psECS_AVAT: Result := Assigned(FIPCMonitor_ECS_AVAT);
//    psMT210: Result := Assigned(FIPCMonitor_MT210);
//    psMEXA7000: Result := Assigned(FIPCMonitor_MEXA7000);
//    psLBX: Result := Assigned(FIPCMonitor_LBX);
//    psFlowMeter: Result := Assigned(FIPCMonitor_ECS_kumo);
//    psWT1600: Result := Assigned(FIPCMonitor_WT1600);
//    psGasCalculated: Result := Assigned(FIPCMonitor_GasCalc);
//    psECS_Woodward: Result := Assigned(FIPCMonitor_ECS_Woodward);
//    psDynamo: Result := Assigned(FIPCMonitor_Dynamo);
//    psPLC_S7: Result := Assigned(FIPCMonitor_PLC_S7);
//    psEngineParam: Result := Assigned(FIPCMonitor_EngineParam);
//    psHIC: Result := Assigned(FIPCMonitor_HIC);
////    psUnKnown: Result := Assigned(FIPCMonitor_EngineParam);
//    psPLC_Modbus: Result := Assigned(FIPCMonitor_PLCModbus);
//    psPMSOPC: Result := Assigned(FIPCMonitor_PMS);
//    psECS_ComAP: Result := Assigned(FIPCMonitor_ECS_ComAP);
//  else
//    Result := False;
//  end;
end;

//Exe Name과 filename이 다를 경우 Result에 exe name을 반환함
function TFrameIPCMonitorAll.CheckExeFileNameForWatchListFile(
  AFileName: string): string;
var
  i: integer;
  LStr,
  LExeName: string;
begin
  Result := '';
  LStr := System.Copy(AFileName,0,1);
  LExeName := ExtractFileName(Application.ExeName);
  if ((LStr = '1') and (LExeName = HiMECSWatchName2)) or
    ((LStr = '2') and (LExeName = HiMECSWatchSaveName)) then
    exit
  else
  begin
    if LStr = '1' then
      Result := HiMECSWatchName2
    else
    if LStr = '2' then
      Result := HiMECSWatchSaveName;
  end;
end;

function TFrameIPCMonitorAll.CheckExistTagName(AParameterSource: TParameterSource;
  ATagName: string): integer;
var
  i: integer;
begin
  Result := -1;

  for i := 0 to FEngineParameter.EngineParameterCollect.Count - 1 do
  begin
    if (FEngineParameter.EngineParameterCollect.Items[i].ParameterSource =
                                                AParameterSource) and
        (FEngineParameter.EngineParameterCollect.Items[i].TagName =
                                                ATagName) then
    begin
      Result := i;
      exit;
    end;
  end;
end;

//AUserLevel이 파일이름에 부착된 권한보다 강하면 Result = True
//Result가 False면 AUserLevel에 파일의 user Level 반환함.
function TFrameIPCMonitorAll.CheckUserLevelForWatchListFile(AFileName: string;
  var AUserLevel: THiMECSUserLevel): Boolean;
var
  i: integer;
  LUser: THiMECSUserLevel;
  LStr: string;
begin
  Result := False;
  i := Length(AFileName);
  LStr := System.Copy(AFileName,i,1);
  if LStr <> '' then
  begin
    LUser := THiMECSUserLevel(StrToInt(LStr));

    if AUserLevel > LUser then  //지울수 있는 권한이 없으면
    begin
      //ShowMessage('There is no authority to delete Watch File Name: File Level = ' + UserLevel2String(FCurrentUserlevel));
      AUserLevel := LUser;
      exit;
    end;
  end
  else
  begin
    ShowMessage('There is no User Level in the Watch File Name:' + AFileName);
    exit;
  end;

  Result := True;
end;

constructor TFrameIPCMonitorAll.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);

  InitVar;
end;

procedure TFrameIPCMonitorAll.CreateDynamoIPCMonitor(ASN, ASN2, APSnSN: string;
  AMonitor: TIPCMonitorClass);
var
  LObj: TIPCMonitor<TEventData_DYNAMO>;
begin
//  if Assigned(FIPCMonitor_Dynamo) then
//    exit;
//
//  if AEP_DragDrop.FSharedName = '' then
//    LSM := ParameterSource2SharedMN(AEP_DragDrop.FParameterSource)
//  else
//    LSM := AEP_DragDrop.FSharedName;
//
//  FIPCMonitor_Dynamo := TIPCMonitor<TEventData_DYNAMO>.Create(LSM, DYNAMO_EVENT_NAME, True);
//  FIPCMonitor_Dynamo.FIPCObject.OnSignal := Dynamo_OnSignal;
//  FIPCMonitor_Dynamo.FreeOnTerminate := True;
//  FIPCMonitor_Dynamo.Resume;

  LObj := TIPCMonitor<TEventData_DYNAMO>.Create(ASN, ASN2,True);
  AMonitor.FIPCObject := LObj;
  AMonitor.FIPCMethod := TDYNAMO_Method.Create(Self);
  TDYNAMO_Method(AMonitor.FIPCMethod).FPSnSN := APSnSN;
  LObj.FIPCObject.OnSignal := TDYNAMO_Method(AMonitor.FIPCMethod).Dynamo_OnSignal;
  LObj.FreeOnTerminate := True;
  LObj.Resume;
end;

procedure TFrameIPCMonitorAll.CreateECSAVATIPCMonitor(ASN, ASN2, APSnSN: string;
  AMonitor: TIPCMonitorClass);
var
  LObj: TIPCMonitor<TEventData_ECS_AVAT>;
begin
//  if Assigned(FIPCMonitor_ECS_AVAT) then
//    exit;

//  SetModbusMapFileName('', AEP_DragDrop.FParameterSource);
//  FAddressMap.clear;
//  ReadMapAddress(FAddressMap,FModbusMapFileName);//FConfigOption.ModbusFileName);

//  if AEP_DragDrop.FSharedName = '' then
//    LSM := ParameterSource2SharedMN(AEP_DragDrop.FParameterSource)
//  else
//    LSM := AEP_DragDrop.FSharedName;
//
//  FIPCMonitor_ECS_AVAT := TIPCMonitor<TEventData_ECS_AVAT>.Create(LSM, ECS_AVAT_EVENT_NAME, True);
//  SetModbusMapFileName('', AEP_DragDrop.FParameterSource);
//  FIPCMonitor_ECS_AVAT.FIPCObject.OnSignal := ECS_OnSignal_AVAT;
//  FIPCMonitor_ECS_AVAT.FreeOnTerminate := True;
//  FIPCMonitor_ECS_AVAT.Resume;

  LObj := TIPCMonitor<TEventData_ECS_AVAT>.Create(ASN, ASN2,True);
  AMonitor.FIPCObject := LObj;
  AMonitor.FIPCMethod := TECS_AVAT_Method.Create(Self);
  TECS_AVAT_Method(AMonitor.FIPCMethod).FPSnSN := APSnSN;
  LObj.FIPCObject.OnSignal := TECS_AVAT_Method(AMonitor.FIPCMethod).ECS_OnSignal_AVAT;
  LObj.FreeOnTerminate := True;
  LObj.Resume;

  FCompleteReadMap_Avat := True;
end;

procedure TFrameIPCMonitorAll.CreateECSComAPIPCMonitor(ASN, ASN2, APSnSN: string;
  AMonitor: TIPCMonitorClass);
var
  LObj: TIPCMonitor<TEventData_Modbus_Standard>;
begin
//  if Assigned(FIPCMonitor_ECS_ComAP) then
//    exit;
//
//  if AEP_DragDrop.FSharedName = '' then
//    LSM := ParameterSource2SharedMN(AEP_DragDrop.FParameterSource)
//  else
//    LSM := AEP_DragDrop.FSharedName;
//
//  FIPCMonitor_ECS_ComAP := TIPCMonitor<TEventData_Modbus_Standard>.Create(LSM, PLCMODBUS_EVENT_NAME, True);
//  FIPCMonitor_ECS_ComAP.FIPCObject.OnSignal := ECS_OnSignal_ComAP;
//  FIPCMonitor_ECS_ComAP.FreeOnTerminate := True;
//  FIPCMonitor_ECS_ComAP.Resume;

  LObj := TIPCMonitor<TEventData_Modbus_Standard>.Create(ASN, ASN2, True);
  AMonitor.FIPCObject := LObj;
  AMonitor.FIPCMethod := TECS_ComAP_Method.Create(Self);
  TECS_ComAP_Method(AMonitor.FIPCMethod).FPSnSN := APSnSN;
  LObj.FIPCObject.OnSignal := TECS_ComAP_Method(AMonitor.FIPCMethod).ECS_OnSignal_ComAP;
  LObj.FreeOnTerminate := True;
  LObj.Resume;
end;

//ASN: Shared Name
//ASN2: 공통 문자열
//APSnSN: param source 문자열 + Shared Name
procedure TFrameIPCMonitorAll.CreateECSkumoIPCMonitor(ASN, ASN2, APSnSN: string;
  AMonitor: TIPCMonitorClass);
var
  LObj: TIPCMonitor<TEventData_ECS_kumo>;
begin
//  if Assigned(FIPCMonitor_ECS_kumo) then
//    exit;

//  if AEP_DragDrop.FSharedName = '' then
//    LSM := ParameterSource2SharedMN(AEP_DragDrop.FParameterSource)
//  else
//    LSM := AEP_DragDrop.FSharedName;

//  FIPCMonitor_ECS_kumo := TIPCMonitor<TEventData_ECS_kumo>.Create(LSM, ECS_KUMO_EVENT_NAME, True);
//  FIPCMonitor_ECS_kumo.FIPCObject.OnSignal := ECS_OnSignal_kumo;
//  FIPCMonitor_ECS_kumo.FreeOnTerminate := True;
//  FIPCMonitor_ECS_kumo.Resume;

  LObj := TIPCMonitor<TEventData_ECS_kumo>.Create(ASN, ASN2,True);
  AMonitor.FIPCObject := LObj;
  AMonitor.FIPCMethod := TECS_kumo_Method.Create(Self);
  TECS_kumo_Method(AMonitor.FIPCMethod).FPSnSN := APSnSN;
  LObj.FIPCObject.OnSignal := TECS_kumo_Method(AMonitor.FIPCMethod).ECS_OnSignal_kumo;
  LObj.FreeOnTerminate := True;
  LObj.Resume;

  FCompleteReadMap_kumo := True;
end;

procedure TFrameIPCMonitorAll.CreateECSWoodwardIPCMonitor(ASN, ASN2, APSnSN: string;
  AMonitor: TIPCMonitorClass);
var
  LObj: TIPCMonitor<TEventData_ECS_Woodward>;
begin
//  if Assigned(FIPCMonitor_ECS_Woodward) then
//    exit;

  //SetModbusMapFileName('', AEP_DragDrop.FParameterSource);
//  FAddressMap.clear;
//  ReadMapAddress(FAddressMap,FModbusMapFileName);//FConfigOption.ModbusFileName);

//  if AEP_DragDrop.FSharedName = '' then
//    LSM := ParameterSource2SharedMN(AEP_DragDrop.FParameterSource)
//  else
//    LSM := AEP_DragDrop.FSharedName;
//
//  FIPCMonitor_ECS_Woodward := TIPCMonitor<TEventData_ECS_Woodward>.Create(LSM, ECS_WOODWARD_EVENT_NAME, True);
//  FIPCMonitor_ECS_Woodward.FIPCObject.OnSignal := ECS_OnSignal_Woodward;
//  FIPCMonitor_ECS_Woodward.FreeOnTerminate := True;
//  FIPCMonitor_ECS_Woodward.Resume;

  LObj := TIPCMonitor<TEventData_ECS_Woodward>.Create(ASN, ASN2,True);
  AMonitor.FIPCObject := LObj;
  AMonitor.FIPCMethod := TECS_Woodward_Method.Create(Self);
  TECS_Woodward_Method(AMonitor.FIPCMethod).FPSnSN := APSnSN;
  LObj.FIPCObject.OnSignal := TECS_Woodward_Method(AMonitor.FIPCMethod).ECS_OnSignal_Woodward;
  LObj.FreeOnTerminate := True;
  LObj.Resume;

  FCompleteReadMap_Woodward := True;
end;

procedure TFrameIPCMonitorAll.CreateEngineParamIPCMonitor(ASN, ASN2, APSnSN: string;
  AMonitor: TIPCMonitorClass);
var
  LObj: TIPCMonitor<TEventData_EngineParam>;
begin
//  if Assigned(FIPCMonitor_EngineParam) then
//    exit;
//
//  if AEP_DragDrop.FSharedName = '' then
//    LSM := ParameterSource2SharedMN(AEP_DragDrop.FParameterSource)
//  else
//    LSM := AEP_DragDrop.FSharedName;
//
//  FIPCMonitor_EngineParam := TIPCMonitor<TEventData_EngineParam>.Create(LSM, ENGINEPARAM_EVENT_NAME, True);
//  FIPCMonitor_EngineParam.FreeOnTerminate := True;
//  FIPCMonitor_EngineParam.FIPCObject.OnSignal := EngineParam_OnSignal;
//  FIPCMonitor_EngineParam.Resume;

  LObj := TIPCMonitor<TEventData_EngineParam>.Create(ASN, ASN2,True);
  AMonitor.FIPCObject := LObj;
  AMonitor.FIPCMethod := TEngineParam_Method.Create(Self);
  TEngineParam_Method(AMonitor.FIPCMethod).FPSnSN := APSnSN;
  LObj.FIPCObject.OnSignal := TEngineParam_Method(AMonitor.FIPCMethod).EngineParam_OnSignal;
  LObj.FreeOnTerminate := True;
  LObj.Resume;
end;

procedure TFrameIPCMonitorAll.CreateFlowMeterIPCMonitor(ASN, ASN2, APSnSN: string;
  AMonitor: TIPCMonitorClass);
var
  LObj: TIPCMonitor<TEventData_FlowMeter>;
begin
//  if Assigned(FIPCMonitor_FlowMeter) then
//    exit;
//
//  if AEP_DragDrop.FSharedName = '' then
//    LSM := ParameterSource2SharedMN(AEP_DragDrop.FParameterSource)
//  else
//    LSM := AEP_DragDrop.FSharedName;
//
//  FIPCMonitor_FlowMeter := TIPCMonitor<TEventData_FlowMeter>.Create(LSM, FLOWMETER_EVENT_NAME, True);
//  FIPCMonitor_FlowMeter.FIPCObject.OnSignal := FlowMeter_OnSignal;
//  FIPCMonitor_FlowMeter.FreeOnTerminate := True;
//  FIPCMonitor_FlowMeter.Resume;

  LObj := TIPCMonitor<TEventData_FlowMeter>.Create(ASN, ASN2,True);
  AMonitor.FIPCObject := LObj;
  AMonitor.FIPCMethod := TFlowMeter_Method.Create(Self);
  TFlowMeter_Method(AMonitor.FIPCMethod).FPSnSN := APSnSN;
  LObj.FIPCObject.OnSignal := TFlowMeter_Method(AMonitor.FIPCMethod).FlowMeter_OnSignal;
  LObj.FreeOnTerminate := True;
  LObj.Resume;
end;

procedure TFrameIPCMonitorAll.CreateGasCalcIPCMonitor(ASN, ASN2, APSnSN: string;
  AMonitor: TIPCMonitorClass);
var
  LObj: TIPCMonitor<TEventData_GasCalc>;
begin
//  if Assigned(FIPCMonitor_GasCalc) then
//    exit;
//
//  if AEP_DragDrop.FSharedName = '' then
//    LSM := ParameterSource2SharedMN(AEP_DragDrop.FParameterSource)
//  else
//    LSM := AEP_DragDrop.FSharedName;
//
//  FIPCMonitor_GasCalc := TIPCMonitor<TEventData_GasCalc>.Create(LSM, GASCALC_EVENT_NAME, True);
//  FIPCMonitor_GasCalc.FreeOnTerminate := True;
//  FIPCMonitor_GasCalc.FIPCObject.OnSignal := GasCalc_OnSignal;
//  FIPCMonitor_GasCalc.Resume;

  LObj := TIPCMonitor<TEventData_GasCalc>.Create(ASN, ASN2,True);
  AMonitor.FIPCObject := LObj;
  AMonitor.FIPCMethod := TGasCalc_Method.Create(Self);
  TGasCalc_Method(AMonitor.FIPCMethod).FPSnSN := APSnSN;
  LObj.FIPCObject.OnSignal := TGasCalc_Method(AMonitor.FIPCMethod).GasCalc_OnSignal;
  LObj.FreeOnTerminate := True;
  LObj.Resume;
end;

procedure TFrameIPCMonitorAll.CreateHICIPCMonitor(ASN, ASN2, APSnSN: string;
  AMonitor: TIPCMonitorClass);
var
  LObj: TIPCMonitor<TEventData_HIC>;
begin
//  if Assigned(FIPCMonitor_HIC) then
//    exit;
//
//  if AEP_DragDrop.FSharedName = '' then
//    LSM := ParameterSource2SharedMN(AEP_DragDrop.FParameterSource)
//  else
//    LSM := AEP_DragDrop.FSharedName;
//
//  FIPCMonitor_HIC := TIPCMonitor<TEventData_HIC>.Create(LSM, HIC_EVENT_NAME, True);
//  FIPCMonitor_HIC.FreeOnTerminate := True;
//  FIPCMonitor_HIC.FIPCObject.OnSignal := HIC_OnSignal;
//  FIPCMonitor_HIC.Resume;

  LObj := TIPCMonitor<TEventData_HIC>.Create(ASN, ASN2,True);
  AMonitor.FIPCObject := LObj;
  AMonitor.FIPCMethod := THIC_Method.Create(Self);
  THIC_Method(AMonitor.FIPCMethod).FPSnSN := APSnSN;
  LObj.FIPCObject.OnSignal := THIC_Method(AMonitor.FIPCMethod).HIC_OnSignal;
  LObj.FreeOnTerminate := True;
  LObj.Resume;
end;

function TFrameIPCMonitorAll.CreateIPCMonitor(AEP_DragDrop: TEngineParameterItemRecord;
  AIsOnlyCreate: Boolean = False; ADragCopyMode: TParamDragCopyMode = dcmCopyOnlyNonExist): integer;
var
  LSM, LSM2, LStr: string;
  LMonitor: TIPCMonitorClass;
begin
  if not AIsOnlyCreate then
    Result := MoveEngineParameterItemRecord(AEP_DragDrop, ADragCopyMode);

  if AEP_DragDrop.FSharedName = '' then
    LSM := ParameterSource2SharedMN(AEP_DragDrop.FParameterSource)
  else
    LSM := AEP_DragDrop.FSharedName;

  LStr := GetCombinedNamePSandSM(AEP_DragDrop.FParameterSource, LSM);

  if FIPCMonitorList.IndexOf(LStr) <> -1 then
    exit;

  LSM2 := ParameterSource2SharedMN(AEP_DragDrop.FParameterSource);

  LMonitor := TIPCMonitorClass.create;
  LMonitor.ParamSource := AEP_DragDrop.FParameterSource;
  FIPCMonitorList.AddObject(LStr, LMonitor);

  case AEP_DragDrop.FParameterSource of
    psECS_kumo: CreateECSkumoIPCMonitor(LSM, LSM2, LStr, LMonitor);
    psECS_AVAT: CreateECSAVATIPCMonitor(LSM, LSM2, LStr, LMonitor);
    psMT210: CreateMT210IPCMonitor(LSM, LSM2, LStr, LMonitor);
    psMEXA7000: CreateMEXA7000IPCMonitor(LSM, LSM2, LStr, LMonitor);
    psLBX: CreateLBXIPCMonitor(LSM, LSM2, LStr, LMonitor);
    psFlowMeter: CreateFlowMeterIPCMonitor(LSM, LSM2, LStr, LMonitor);
    psWT1600: CreateWT1600IPCMonitor(LSM, LSM2, LStr, LMonitor);
    psGasCalculated: CreateGasCalcIPCMonitor(LSM, LSM2, LStr, LMonitor);
    psECS_Woodward: CreateECSWoodwardIPCMonitor(LSM, LSM2, LStr, LMonitor);
    psDynamo: CreateDynamoIPCMonitor(LSM, LSM2, LStr, LMonitor);
    psFlowMeterKral: CreateKRALIPCMonitor(LSM, LSM2, LStr, LMonitor);
    psPLC_S7: CreatePLCS7IPCMonitor(LSM, LSM2, LStr, LMonitor);
    psEngineParam: CreateEngineParamIPCMonitor(LSM, LSM2, LStr, LMonitor);
    psHIC: CreateHICIPCMonitor(LSM, LSM2, LStr, LMonitor);
    psPLC_Modbus: CreatePLCMODBUSIPCMonitor(LSM, LSM2, LStr, LMonitor);
    psECS_ComAP: CreateECSComAPIPCMonitor(LSM, LSM2, LStr, LMonitor);
  end;
end;

//FEngineParameter 로 부터 IPC Monitor 생성함.
//반환: 생성된 IPC 리스트 반환
procedure TFrameIPCMonitorAll.CreateIPCMonitorFromParameter(
  var AIPCList: TStringList);
var
  i: integer;
  LStr: string;
begin
  AIPCList.Clear;

  for i := 0 to FEngineParameter.EngineParameterCollect.Count - 1 do
  begin
    LStr := ParameterSource2String(FEngineParameter.EngineParameterCollect.Items[i].ParameterSource);
    if AIPCList.IndexOf(LStr) = -1 then
    begin
      AIPCList.Add(LStr);
      FEngineParameterItemRecord.FParameterSource := FEngineParameter.EngineParameterCollect.Items[i].ParameterSource;
      CreateIPCMonitor(FEngineParameterItemRecord);
    end;
  end;
end;

//Result: Created Shared Memory Name
function TFrameIPCMonitorAll.CreateIPCMonitor_DYNAMO(ASharedName: string = ''): String;
begin
  Result := CreateIPCMonitor_xx(psDYNAMO, ASharedName);
end;

function TFrameIPCMonitorAll.CreateIPCMonitor_ECS_AVAT(ASharedName: string = ''): String;
begin
  Result := CreateIPCMonitor_xx(psECS_AVAT, ASharedName);
end;

function TFrameIPCMonitorAll.CreateIPCMonitor_ECS_ComAP(
  ASharedName: string): String;
begin
  Result := CreateIPCMonitor_xx(psECS_ComAP, ASharedName);
end;

function TFrameIPCMonitorAll.CreateIPCMonitor_ECS_kumo(ASharedName: string = ''): String;
begin
  Result := CreateIPCMonitor_xx(psECS_kumo, ASharedName);
end;

function TFrameIPCMonitorAll.CreateIPCMonitor_ECS_Woodward(
  ASharedName: string): String;
begin
  Result := CreateIPCMonitor_xx(psECS_Woodward, ASharedName);
end;

function TFrameIPCMonitorAll.CreateIPCMonitor_EngineParam(
  ASharedName: string): String;
begin
  Result := CreateIPCMonitor_xx(psEngineParam, ASharedName);
end;

function TFrameIPCMonitorAll.CreateIPCMonitor_FlowMeter(ASharedName: string = ''): String;
begin
  Result := CreateIPCMonitor_xx(psFlowMeter, ASharedName);
end;

function TFrameIPCMonitorAll.CreateIPCMonitor_GasCalc(ASharedName: string = ''): String;
begin
  Result := CreateIPCMonitor_xx(psGasCalculated, ASharedName);
end;

function TFrameIPCMonitorAll.CreateIPCMonitor_HIC(ASharedName: string): String;
begin
  Result := CreateIPCMonitor_xx(psHIC, ASharedName);
end;

function TFrameIPCMonitorAll.CreateIPCMonitor_KRAL(ASharedName: string): String;
begin
  Result := CreateIPCMonitor_xx(psFlowMeterKral, ASharedName);
end;

function TFrameIPCMonitorAll.CreateIPCMonitor_LBX(ASharedName: string = ''): String;
begin
  Result := CreateIPCMonitor_xx(psLBX, ASharedName);
end;

function TFrameIPCMonitorAll.CreateIPCMonitor_MEXA7000(ASharedName: string = ''): String;
begin
  Result := CreateIPCMonitor_xx(psMEXA7000, ASharedName);
end;

function TFrameIPCMonitorAll.CreateIPCMonitor_MT210(ASharedName: string = ''): String;
begin
  Result := CreateIPCMonitor_xx(psMT210, ASharedName);
end;

function TFrameIPCMonitorAll.CreateIPCMonitor_PLCMODBUS(
  ASharedName: string): String;
begin
  Result := CreateIPCMonitor_xx(psPLC_Modbus, ASharedName);
end;

function TFrameIPCMonitorAll.CreateIPCMonitor_PLC_S7(
  ASharedName: string): String;
begin
  Result := CreateIPCMonitor_xx(psPLC_S7, ASharedName);
end;

function TFrameIPCMonitorAll.CreateIPCMonitor_PMS(ASharedName: string): String;
begin
  Result := CreateIPCMonitor_xx(psPLC_Modbus, ASharedName);
end;

function TFrameIPCMonitorAll.CreateIPCMonitor_WT1600(ASharedName: string = ''): String;
begin
  Result := CreateIPCMonitor_xx(psWT1600, ASharedName);
end;

function TFrameIPCMonitorAll.CreateIPCMonitor_xx(
  AParameterSource: TParameterSource; ASharedName: string): String;
begin
  FEngineParameterItemRecord.FParameterSource := AParameterSource;

  if ASharedName <> '' then
  begin
    FEngineParameterItemRecord.FSharedName := ASharedName;
    Result := ASharedName;
  end
  else
    Result := ParameterSource2SharedMN(FEngineParameterItemRecord.FParameterSource);

  CreateIPCMonitor(FEngineParameterItemRecord);
  FillChar(FEngineParameterItemRecord, Sizeof(FEngineParameterItemRecord), #0);
end;

procedure TFrameIPCMonitorAll.CreateKRALIPCMonitor(ASN, ASN2, APSnSN: string;
  AMonitor: TIPCMonitorClass);
var
  LObj: TIPCMonitor<TEventData_Modbus_Standard>;
begin
//  if Assigned(FIPCMonitor_KRAL) then
//    exit;
//
//  if AEP_DragDrop.FSharedName = '' then
//    LSM := ParameterSource2SharedMN(AEP_DragDrop.FParameterSource)
//  else
//    LSM := AEP_DragDrop.FSharedName;
//
//  FIPCMonitor_KRAL := TIPCMonitor<TEventData_Modbus_Standard>.Create(LSM, KRAK_EVENT_NAME, True);
//  FIPCMonitor_KRAL.FreeOnTerminate := True;
//  FIPCMonitor_KRAL.FIPCObject.OnSignal := KRAL_OnSignal;
//  FIPCMonitor_KRAL.Resume;

  LObj := TIPCMonitor<TEventData_Modbus_Standard>.Create(ASN, ASN2,True);
  AMonitor.FIPCObject := LObj;
  AMonitor.FIPCMethod := TKRAL_Method.Create(Self);
  TKRAL_Method(AMonitor.FIPCMethod).FPSnSN := APSnSN;
  LObj.FIPCObject.OnSignal := TKRAL_Method(AMonitor.FIPCMethod).KRAL_OnSignal;
  LObj.FreeOnTerminate := True;
  LObj.Resume;
end;

procedure TFrameIPCMonitorAll.CreateLBXIPCMonitor(ASN, ASN2, APSnSN: string;
  AMonitor: TIPCMonitorClass);
var
  LObj: TIPCMonitor<TEventData_LBX>;
begin
//  if Assigned(FIPCMonitor_LBX) then
//    exit;
//
//  if AEP_DragDrop.FSharedName = '' then
//    LSM := ParameterSource2SharedMN(AEP_DragDrop.FParameterSource)
//  else
//    LSM := AEP_DragDrop.FSharedName;
//
//  FIPCMonitor_LBX := TIPCMonitor<TEventData_LBX>.Create(LSM, LBX_EVENT_NAME, True);
//  FIPCMonitor_LBX.FIPCObject.OnSignal := LBX_OnSignal;
//  FIPCMonitor_LBX.FreeOnTerminate := True;
//  FIPCMonitor_LBX.Resume;

  LObj := TIPCMonitor<TEventData_LBX>.Create(ASN, ASN2,True);
  AMonitor.FIPCObject := LObj;
  AMonitor.FIPCMethod := TLBX_Method.Create(Self);
  TLBX_Method(AMonitor.FIPCMethod).FPSnSN := APSnSN;
  LObj.FIPCObject.OnSignal := TLBX_Method(AMonitor.FIPCMethod).LBX_OnSignal;
  LObj.FreeOnTerminate := True;
  LObj.Resume;
end;

procedure TFrameIPCMonitorAll.CreateMEXA7000IPCMonitor(ASN, ASN2, APSnSN: string;
  AMonitor: TIPCMonitorClass);
var
  LObj: TIPCMonitor<TEventData_MEXA7000_2>;
begin
//  if Assigned(FIPCMonitor_MEXA7000) then
//    exit;
//
//  if AEP_DragDrop.FSharedName = '' then
//    LSM := ParameterSource2SharedMN(AEP_DragDrop.FParameterSource)
//  else
//    LSM := AEP_DragDrop.FSharedName;
//
//  FIPCMonitor_MEXA7000 := TIPCMonitor<TEventData_MEXA7000_2>.Create(LSM, MEXA7000_EVENT_NAME, True);
//  FIPCMonitor_MEXA7000.FIPCObject.OnSignal := MEXA7000_2_OnSignal;
//  FIPCMonitor_MEXA7000.FreeOnTerminate := True;
//  FIPCMonitor_MEXA7000.Resume;

  LObj := TIPCMonitor<TEventData_MEXA7000_2>.Create(ASN, ASN2,True);
  AMonitor.FIPCObject := LObj;
  AMonitor.FIPCMethod := TMEXA700_2_Method.Create(Self);
  TMEXA700_2_Method(AMonitor.FIPCMethod).FPSnSN := APSnSN;
  LObj.FIPCObject.OnSignal := TMEXA700_2_Method(AMonitor.FIPCMethod).MEXA7000_2_OnSignal;
  LObj.FreeOnTerminate := True;
  LObj.Resume;
end;

procedure TFrameIPCMonitorAll.CreateMT210IPCMonitor(ASN, ASN2, APSnSN: string;
  AMonitor: TIPCMonitorClass);
var
  LObj: TIPCMonitor<TEventData_MT210>;
begin
//  if Assigned(FIPCMonitor_MT210) then
//    exit;
//
//  if AEP_DragDrop.FSharedName = '' then
//    LSM := ParameterSource2SharedMN(AEP_DragDrop.FParameterSource)
//  else
//    LSM := AEP_DragDrop.FSharedName;
//
//  FIPCMonitor_MT210 := TIPCMonitor<TEventData_MT210>.Create(LSM, MT210_EVENT_NAME, True);
//  FIPCMonitor_MT210.FIPCObject.OnSignal := MT210_OnSignal;
//  FIPCMonitor_MT210.FreeOnTerminate := True;
//  FIPCMonitor_MT210.Resume;

  LObj := TIPCMonitor<TEventData_MT210>.Create(ASN, ASN2,True);
  AMonitor.FIPCObject := LObj;
  AMonitor.FIPCMethod := TMT210_Method.Create(Self);
  TMT210_Method(AMonitor.FIPCMethod).FPSnSN := APSnSN;
  LObj.FIPCObject.OnSignal := TMT210_Method(AMonitor.FIPCMethod).MT210_OnSignal;
  LObj.FreeOnTerminate := True;
  LObj.Resume;
end;

procedure TFrameIPCMonitorAll.CreatePLCMODBUSIPCMonitor(ASN, ASN2, APSnSN: string;
  AMonitor: TIPCMonitorClass);
var
  LObj: TIPCMonitor<TEventData_Modbus_Standard>;
begin
//  if Assigned(FIPCMonitor_PLCMODBUS) then
//    exit;
//
//  if AEP_DragDrop.FSharedName = '' then
//    LSM := ParameterSource2SharedMN(AEP_DragDrop.FParameterSource)
//  else
//    LSM := AEP_DragDrop.FSharedName;
//
//  FIPCMonitor_PLCMODBUS := TIPCMonitor<TEventData_Modbus_Standard>.Create(LSM, PLCMODBUS_EVENT_NAME, True);
//  FIPCMonitor_PLCMODBUS.FIPCObject.OnSignal := PLCMODBUS_OnSignal;
//  FIPCMonitor_PLCMODBUS.FreeOnTerminate := True;
//  FIPCMonitor_PLCMODBUS.Resume;

  LObj := TIPCMonitor<TEventData_Modbus_Standard>.Create(ASN, ASN2,True);
  AMonitor.FIPCObject := LObj;
  AMonitor.FIPCMethod := TPLCMODBUS_Method.Create(Self);
  TPLCMODBUS_Method(AMonitor.FIPCMethod).FPSnSN := APSnSN;
  LObj.FIPCObject.OnSignal := TPLCMODBUS_Method(AMonitor.FIPCMethod).PLCMODBUS_OnSignal;
  LObj.FreeOnTerminate := True;
  LObj.Resume;

  FCompleteReadMap_Woodward := True;
end;

procedure TFrameIPCMonitorAll.CreatePLCS7IPCMonitor(ASN, ASN2, APSnSN: string;
  AMonitor: TIPCMonitorClass);
var
  LObj: TIPCMonitor<TEventData_PLC_S7>;
begin
//  if Assigned(FIPCMonitor_PLC_S7) then
//    exit;
//
//  if AEP_DragDrop.FSharedName = '' then
//    LSM := ParameterSource2SharedMN(AEP_DragDrop.FParameterSource)
//  else
//    LSM := AEP_DragDrop.FSharedName;
//
//  FIPCMonitor_PLC_S7 := TIPCMonitor<TEventData_PLC_S7>.Create(LSM, PLC_S7_EVENT_NAME, True);
//  FIPCMonitor_PLC_S7.FreeOnTerminate := True;
//  FIPCMonitor_PLC_S7.FIPCObject.OnSignal := PLC_S7_OnSignal;
//  FIPCMonitor_PLC_S7.Resume;

  LObj := TIPCMonitor<TEventData_PLC_S7>.Create(ASN, ASN2,True);
  AMonitor.FIPCObject := LObj;
  AMonitor.FIPCMethod := TPLC_S7_Method.Create(Self);
  TPLC_S7_Method(AMonitor.FIPCMethod).FPSnSN := APSnSN;
  LObj.FIPCObject.OnSignal := TPLC_S7_Method(AMonitor.FIPCMethod).PLC_S7_OnSignal;
  LObj.FreeOnTerminate := True;
  LObj.Resume;
end;

procedure TFrameIPCMonitorAll.CreatePMSIPCMonitor(ASN, ASN2, APSnSN: string;
  AMonitor: TIPCMonitorClass);
var
  LObj: TIPCMonitor<TEventData_PMS>;
begin
//  if Assigned(FIPCMonitor_PMS) then
//    exit;
//
//  if AEP_DragDrop.FSharedName = '' then
//    LSM := ParameterSource2SharedMN(AEP_DragDrop.FParameterSource)
//  else
//    LSM := AEP_DragDrop.FSharedName;
//
//  FIPCMonitor_PMS := TIPCMonitor<TEventData_PMS>.Create(LSM, PMS_EVENT_NAME, True);
//  FIPCMonitor_PMS.FIPCObject.OnSignal := PMS_OnSignal;
//  FIPCMonitor_PMS.FreeOnTerminate := True;
//  FIPCMonitor_PMS.Resume;

  LObj := TIPCMonitor<TEventData_PMS>.Create(ASN, ASN2,True);
  AMonitor.FIPCObject := LObj;
  AMonitor.FIPCMethod := TPMS_Method.Create(Self);
  TPMS_Method(AMonitor.FIPCMethod).FPSnSN := APSnSN;
  LObj.FIPCObject.OnSignal := TPMS_Method(AMonitor.FIPCMethod).PMS_OnSignal;
  LObj.FreeOnTerminate := True;
  LObj.Resume;
end;

procedure TFrameIPCMonitorAll.CreateWT1600IPCMonitor(ASN, ASN2, APSnSN: string;
  AMonitor: TIPCMonitorClass);
var
  LObj: TIPCMonitor<TEventData_WT1600>;
begin
//  if Assigned(FIPCMonitor_WT1600) then
//    exit;
//
//  if AEP_DragDrop.FSharedName = '' then
//    LSM := ParameterSource2SharedMN(AEP_DragDrop.FParameterSource)
//  else
//    LSM := AEP_DragDrop.FSharedName;
//
//  FIPCMonitor_WT1600 := TIPCMonitor<TEventData_WT1600>.Create(LSM, WT1600_EVENT_NAME, True);
//  FIPCMonitor_WT1600.FreeOnTerminate := True;
//  FIPCMonitor_WT1600.FIPCObject.OnSignal := WT1600_OnSignal;
//  FIPCMonitor_WT1600.Resume;

  LObj := TIPCMonitor<TEventData_WT1600>.Create(ASN, ASN2,True);
  AMonitor.FIPCObject := LObj;
  AMonitor.FIPCMethod := TWT1600_Method.Create(Self);
  TWT1600_Method(AMonitor.FIPCMethod).FPSnSN := APSnSN;
  LObj.FIPCObject.OnSignal := TWT1600_Method(AMonitor.FIPCMethod).WT1600_OnSignal;
  LObj.FreeOnTerminate := True;
  LObj.Resume;
end;

destructor TFrameIPCMonitorAll.Destroy;
begin
  DestroyVar;

  inherited;
end;

procedure TFrameIPCMonitorAll.DestroyIPCMonitor(AIPCMonitor: TParameterSource);
begin

//  if Assigned(FIPCMonitor_WT1600) and (AIPCMonitor = psWT1600) then
//  begin
//    FIPCMonitor_WT1600.FIPCObject.OnSignal := nil;
//    FIPCMonitor_WT1600.FIPCObject.FMonitorEvent.Pulse;
//    FIPCMonitor_WT1600.Terminate;
//    FIPCMonitor_WT1600 := nil;
//  end;
//
//  if Assigned(FIPCMonitor_MEXA7000) and (AIPCMonitor = psMEXA7000)  then
//  begin
//    FIPCMonitor_MEXA7000.FIPCObject.OnSignal := nil;
//    FIPCMonitor_MEXA7000.Suspend;
//    FIPCMonitor_MEXA7000.FIPCObject.FMonitorEvent.Pulse;
//    FIPCMonitor_MEXA7000.Resume;
//    FIPCMonitor_MEXA7000.Terminate;
//    FIPCMonitor_MEXA7000 := nil;
//  end;
//
//  if Assigned(FIPCMonitor_MT210) and (AIPCMonitor = psMT210)  then
//  begin
//    FIPCMonitor_MT210.FIPCObject.OnSignal := nil;
//    FIPCMonitor_MT210.Suspend;
//    FIPCMonitor_MT210.FIPCObject.FMonitorEvent.Pulse;
//    FIPCMonitor_MT210.Resume;
//    FIPCMonitor_MT210.Terminate;
//    FIPCMonitor_MT210 := nil;
//  end;
//
//  if Assigned(FIPCMonitor_ECS_kumo) and (AIPCMonitor = psECS_kumo)  then
//  begin
//    FIPCMonitor_ECS_kumo.FIPCObject.OnSignal := nil;
//    FIPCMonitor_ECS_kumo.Suspend;
//    FIPCMonitor_ECS_kumo.FIPCObject.FMonitorEvent.Pulse;
//    FIPCMonitor_ECS_kumo.Resume;
//    FIPCMonitor_ECS_kumo.Terminate;
//    FIPCMonitor_ECS_kumo := nil;
//  end;
//
//  if Assigned(FIPCMonitor_ECS_Woodward) and (AIPCMonitor = psECS_Woodward)  then
//  begin
//    FIPCMonitor_ECS_Woodward.FIPCObject.OnSignal := nil;
//    FIPCMonitor_ECS_Woodward.Suspend;
//    FIPCMonitor_ECS_Woodward.FIPCObject.FMonitorEvent.Pulse;
//    FIPCMonitor_ECS_Woodward.Resume;
//    FIPCMonitor_ECS_Woodward.Terminate;
//    FIPCMonitor_ECS_Woodward := nil;
//  end;
//
//  if Assigned(FIPCMonitor_ECS_AVAT) and (AIPCMonitor = psECS_AVAT)  then
//  begin
//    FIPCMonitor_ECS_AVAT.FIPCObject.OnSignal := nil;
//    FIPCMonitor_ECS_AVAT.Suspend;
//    FIPCMonitor_ECS_AVAT.FIPCObject.FMonitorEvent.Pulse;
//    FIPCMonitor_ECS_AVAT.Resume;
//    FIPCMonitor_ECS_AVAT.Terminate;
//    FIPCMonitor_ECS_AVAT := nil;
//  end;
//
//  if Assigned(FIPCMonitor_LBX) and (AIPCMonitor = psLBX)  then
//  begin
//    FIPCMonitor_LBX.FIPCObject.OnSignal := nil;
//    FIPCMonitor_LBX.Suspend;
//    FIPCMonitor_LBX.FIPCObject.FMonitorEvent.Pulse;
//    FIPCMonitor_LBX.Resume;
//    FIPCMonitor_LBX.Terminate;
//    FIPCMonitor_LBX := nil;
//  end;
//
//  if Assigned(FIPCMonitor_Dynamo) and (AIPCMonitor = psDynamo)  then
//  begin
//    FIPCMonitor_Dynamo.FIPCObject.OnSignal := nil;
//    FIPCMonitor_Dynamo.Suspend;
//    FIPCMonitor_Dynamo.FIPCObject.FMonitorEvent.Pulse;
//    FIPCMonitor_Dynamo.Resume;
//    FIPCMonitor_Dynamo.Terminate;
//    FIPCMonitor_Dynamo := nil;
//  end;
//
//  if Assigned(FIPCMonitor_KRAL) and (AIPCMonitor = psFlowMeterKral)  then
//  begin
//    FIPCMonitor_KRAL.FIPCObject.OnSignal := nil;
//    FIPCMonitor_KRAL.Suspend;
//    FIPCMonitor_KRAL.FIPCObject.FMonitorEvent.Pulse;
//    FIPCMonitor_KRAL.Resume;
//    FIPCMonitor_KRAL.Terminate;
//    FIPCMonitor_KRAL := nil;
//  end;
//
//  if Assigned(FIPCMonitor_PLC_S7) and (AIPCMonitor = psPLC_S7)  then
//  begin
//    FIPCMonitor_PLC_S7.FIPCObject.OnSignal := nil;
//    FIPCMonitor_PLC_S7.Suspend;
//    FIPCMonitor_PLC_S7.FIPCObject.FMonitorEvent.Pulse;
//    FIPCMonitor_PLC_S7.Resume;
//    FIPCMonitor_PLC_S7.Terminate;
//    FIPCMonitor_PLC_S7 := nil;
//  end;
//
//  if Assigned(FIPCMonitor_GasCalc) and (AIPCMonitor = psGasCalculated)  then
//  begin
//    FIPCMonitor_GasCalc.FIPCObject.OnSignal := nil;
//    FIPCMonitor_GasCalc.Suspend;
//    FIPCMonitor_GasCalc.FIPCObject.FMonitorEvent.Pulse;
//    FIPCMonitor_GasCalc.Resume;
//    FIPCMonitor_GasCalc.Terminate;
//    FIPCMonitor_GasCalc := nil;
//  end;
//
//  if Assigned(FIPCMonitor_EngineParam) and (AIPCMonitor = psEngineParam)  then
//  begin
//    FIPCMonitor_EngineParam.FIPCObject.OnSignal := nil;
//    FIPCMonitor_EngineParam.Suspend;
//    FIPCMonitor_EngineParam.FIPCObject.FMonitorEvent.Pulse;
//    FIPCMonitor_EngineParam.Resume;
//    FIPCMonitor_EngineParam.Terminate;
//    FIPCMonitor_EngineParam := nil;
//  end;
//
//  if Assigned(FIPCMonitor_HIC) and (AIPCMonitor = psHIC)  then
//  begin
//    FIPCMonitor_HIC.FIPCObject.OnSignal := nil;
//    FIPCMonitor_HIC.Suspend;
//    FIPCMonitor_HIC.FIPCObject.FMonitorEvent.Pulse;
//    FIPCMonitor_HIC.Resume;
//    FIPCMonitor_HIC.Terminate;
//    FIPCMonitor_HIC := nil;
//  end;
//
//  if Assigned(FIPCMonitor_PLCModbus) and (AIPCMonitor = psPLC_Modbus)  then
//  begin
//    FIPCMonitor_PLCModbus.FIPCObject.OnSignal := nil;
//    FIPCMonitor_PLCModbus.Suspend;
//    FIPCMonitor_PLCModbus.FIPCObject.FMonitorEvent.Pulse;
//    FIPCMonitor_PLCModbus.Resume;
//    FIPCMonitor_PLCModbus.Terminate;
//    FIPCMonitor_PLCModbus := nil;
//  end;
//
//  if Assigned(FIPCMonitor_PMS) and (AIPCMonitor = psPMSOPC)  then
//  begin
//    FIPCMonitor_PMS.FIPCObject.OnSignal := nil;
//    FIPCMonitor_PMS.Suspend;
//    FIPCMonitor_PMS.FIPCObject.FMonitorEvent.Pulse;
//    FIPCMonitor_PMS.Resume;
//    FIPCMonitor_PMS.Terminate;
//    FIPCMonitor_PMS := nil;
//  end;
//
//  if Assigned(FIPCMonitor_ECS_ComAP) and (AIPCMonitor = psECS_ComAP)  then
//  begin
//    FIPCMonitor_ECS_ComAP.FIPCObject.OnSignal := nil;
//    FIPCMonitor_ECS_ComAP.Suspend;
//    FIPCMonitor_ECS_ComAP.FIPCObject.FMonitorEvent.Pulse;
//    FIPCMonitor_ECS_ComAP.Resume;
//    FIPCMonitor_ECS_ComAP.Terminate;
//    FIPCMonitor_ECS_ComAP := nil;
//  end;
end;

procedure TFrameIPCMonitorAll.DestroyIPCMonitorAll;
var
  i: integer;
  LPS: TParameterSource;
begin
  for i := Ord(Low(TParameterSource)) to Ord(High(TParameterSource)) do
  begin
    LPS := TParameterSource(i);
    DestroyIPCMonitor(LPS);
  end;
end;

procedure TFrameIPCMonitorAll.DestroyVar;
var
  i: integer;
begin
  for i := 0 to FIPCMonitorList.Count - 1 do
  begin
    TObject(TIPCMonitorClass(FIPCMonitorList.Objects[i]).FIPCObject).Free;
    TObject(TIPCMonitorClass(FIPCMonitorList.Objects[i]).FIPCMethod).Free;
    TIPCMonitorClass(FIPCMonitorList.Objects[i]).Free;
  end;

  FIPCMonitorList.Free;

  FPJHTimerPool.RemoveAll;
  FreeAndNil(FPJHTimerPool);

  //DestroyIPCMonitor;

  FEngineParameter.EngineParameterCollect.Clear;
  FreeAndNil(FEngineParameter);

  ObjFree(FAddressMap);
  FreeAndNil(FAddressMap);

  //FreeAndNil(FConfigOption);
end;

procedure TFrameIPCMonitorAll.DisplayMessage(Msg: string);
begin

end;

procedure TFrameIPCMonitorAll.DisplayMessage2SB(AStatusBar: TjvStatusBar; Msg: string);
begin
  if Assigned(AStatusBar) then
  begin
    AStatusBar.SimplePanel := True;
    AStatusBar.SimpleText := Msg;
  end;
end;

//procedure TFrameIPCMonitorAll.DYNAMO_OnSignal(Data: TEventData_DYNAMO);
//begin
//  CommonCommunication(psDynamo);
//end;
//
//procedure TFrameIPCMonitorAll.ECS_OnSignal_AVAT(Data: TEventData_ECS_AVAT);
//var
//  i,j,dcount: integer;
//  LStr: string;
//begin
//  LStr := GetCombinedNamePSandSM(psWT1600);
//  j := FIPCMonitorList.IndexOf(LStr);
//
//  if j <> -1 then
//  begin
//    with TEventData_ECS_AVAT(TIPCMonitor<TEventData_ECS_AVAT>(FIPCMonitorList.Objects[j]).FEventDataRecord) do
//    begin
//
//      if not FCompleteReadMap_Avat then
//        exit;
//
//      dcount := 0;
//      FillChar(InpDataBuf[0], High(InpDataBuf) - 1, #0);
//      ModBusMode := Data.ModBusMode;
//
//      if Data.ModBusMode = 0 then //ASCII Mode이면
//      begin
//        //ModePanel.Caption := 'ASCII Mode';
//        dcount := Data.NumOfData;
//        NumOfBit := Data.NumOfBit;
//
//        for i := 0 to dcount - 1 do
//          InpDataBuf[i] := Data.InpDataBuf[i];
//      end
//      else
//      if Data.ModBusMode = 1 then// RTU Mode 이면
//      begin
//        //ModePanel.Caption := 'RTU Mode';
//        dcount := Data.NumOfData div 2;
//        NumOfBit := Data.NumOfBit;
//
//        if dcount = 0 then
//          Inc(dcount);
//
//        for i := 0 to dcount - 1 do
//        begin
//          InpDataBuf[i] := Data.InpDataBuf2[i*2] ;
//          InpDataBuf[i] := InpDataBuf[i] shl 8 + Data.InpDataBuf2[i*2 + 1];
//    //      FModBusData.InpDataBuf[i] :=  ;
//        end;
//
//        if (Data.NumOfData mod 2) > 0 then
//          InpDataBuf[i] := Data.InpDataBuf2[i*2] ;
//      end//Data.ModBusMode = 1
//      else
//      if (Data.ModBusMode = 4) then //MODBUSTCP_MODE 이면
//      begin
//        dcount := Data.NumOfData;
//        NumOfBit := Data.NumOfBit;
//        System.Move(Data.InpDataBuf, InpDataBuf, Sizeof(Data.InpDataBuf));
//
//        //for i := 0 to dcount - 1 do
//          //FECSData.InpDataBuf[i] := Data.InpDataBuf[i];
//      end
//      else
//      if (Data.ModBusMode = 3) then //simulate from csv file
//      begin
//        dcount := Data.NumOfData;
//        NumOfBit := Data.NumOfBit;
//        System.Move(Data.InpDataBuf_double, InpDataBuf_double, Sizeof(Data.InpDataBuf_double));
//      end;//Data.ModBusMode = 3
//
//      ModBusAddress := Data.ModBusAddress;
//      BlockNo := Data.BlockNo;
//      NumOfData := dcount;
//      ModBusFunctionCode := Data.ModBusFunctionCode;
//      ModBusMapFileName := Data.ModBusMapFileName;
//      FModBusMapFileName := Data.ModBusMapFileName;
//
//      DisplayMessage2SB(FStatusBar, ModBusAddress + ' 데이타 도착');
//
//      SendMessage(Handle, WM_EVENT_ECS_AVAT, j,0);
//      CommonCommunication(psECS_AVAT);
//    end;
//  end;
//
////  if not FCompleteReadMap_Avat then
////    exit;
////
////  dcount := 0;
////  FillChar(FECSData_AVAT.InpDataBuf[0], High(FECSData_AVAT.InpDataBuf) - 1, #0);
////  FECSData_AVAT.ModBusMode := Data.ModBusMode;
////
////  if Data.ModBusMode = 0 then //ASCII Mode이면
////  begin
////    //ModePanel.Caption := 'ASCII Mode';
////    dcount := Data.NumOfData;
////    FECSData_AVAT.NumOfBit := Data.NumOfBit;
////
////    for i := 0 to dcount - 1 do
////      FECSData_AVAT.InpDataBuf[i] := Data.InpDataBuf[i];
////  end
////  else
////  if Data.ModBusMode = 1 then// RTU Mode 이면
////  begin
////    //ModePanel.Caption := 'RTU Mode';
////    dcount := Data.NumOfData div 2;
////    FECSData_AVAT.NumOfBit := Data.NumOfBit;
////
////    if dcount = 0 then
////      Inc(dcount);
////
////    for i := 0 to dcount - 1 do
////    begin
////      FECSData_AVAT.InpDataBuf[i] := Data.InpDataBuf2[i*2] ;
////      FECSData_AVAT.InpDataBuf[i] := FECSData_AVAT.InpDataBuf[i] shl 8 + Data.InpDataBuf2[i*2 + 1];
//////      FModBusData.InpDataBuf[i] :=  ;
////    end;
////
////    if (Data.NumOfData mod 2) > 0 then
////      FECSData_AVAT.InpDataBuf[i] := Data.InpDataBuf2[i*2] ;
////  end//Data.ModBusMode = 1
////  else
////  if (Data.ModBusMode = 4) then //MODBUSTCP_MODE 이면
////  begin
////    dcount := Data.NumOfData;
////    FECSData_AVAT.NumOfBit := Data.NumOfBit;
////    System.Move(Data.InpDataBuf, FECSData_AVAT.InpDataBuf, Sizeof(Data.InpDataBuf));
////
////    //for i := 0 to dcount - 1 do
////      //FECSData.InpDataBuf[i] := Data.InpDataBuf[i];
////  end
////  else
////  if (Data.ModBusMode = 3) then //simulate from csv file
////  begin
////    dcount := Data.NumOfData;
////    FECSData_AVAT.NumOfBit := Data.NumOfBit;
////    System.Move(Data.InpDataBuf_double, FECSData_AVAT.InpDataBuf_double, Sizeof(Data.InpDataBuf_double));
////  end;//Data.ModBusMode = 3
////
////  FECSData_AVAT.ModBusAddress := Data.ModBusAddress;
////  FECSData_AVAT.BlockNo := Data.BlockNo;
////  FECSData_AVAT.NumOfData := dcount;
////  FECSData_AVAT.ModBusFunctionCode := Data.ModBusFunctionCode;
////  FECSData_AVAT.ModBusMapFileName := Data.ModBusMapFileName;
////  FModBusMapFileName := Data.ModBusMapFileName;
////
////  DisplayMessage2SB(FStatusBar, FECSData_AVAT.ModBusAddress + ' 데이타 도착');
////
////  SendMessage(Handle, WM_EVENT_ECS_AVAT, 0,0);
////  CommonCommunication(psECS_AVAT);
//end;
//
//procedure TFrameIPCMonitorAll.ECS_OnSignal_ComAP(
//  Data: TEventData_Modbus_Standard);
//var
//  i,j,dcount: integer;
//  LStr: string;
//begin
//  LStr := GetCombinedNamePSandSM(psECS_ComAP);
//  j := FIPCMonitorList.IndexOf(LStr);
//
//  if j <> -1 then
//  begin
//    with TEventData_Modbus_Standard(TIPCMonitor<TEventData_Modbus_Standard>(FIPCMonitorList.Objects[j]).FEventDataRecord) do
//    begin
//      dcount := 0;
//      FillChar(InpDataBuf[0], High(InpDataBuf) - 1, #0);
//      ModBusMode := Data.ModBusMode;
//
//      if Data.ModBusMode = 0 then //ASCII Mode이면
//      begin
//        //ModePanel.Caption := 'ASCII Mode';
//        dcount := Data.NumOfData;
//        NumOfBit := Data.NumOfBit;
//
//        for i := 0 to dcount - 1 do
//          InpDataBuf[i] := Data.InpDataBuf[i];
//      end
//      else
//      if Data.ModBusMode = 1 then// RTU Mode 이면
//      begin
//        dcount := Data.NumOfData div 2;
//        NumOfBit := Data.NumOfBit;
//
//        if dcount = 0 then
//          Inc(dcount);
//
//        for i := 0 to dcount - 1 do
//        begin
//          InpDataBuf[i] := Data.InpDataBuf2[i*2] ;
//          InpDataBuf[i] := InpDataBuf[i] shl 8 + Data.InpDataBuf2[i*2 + 1];
//        end;
//
//        if (Data.NumOfData mod 2) > 0 then
//          InpDataBuf[i] := Data.InpDataBuf2[i*2] ;
//      end//Data.ModBusMode = 1
//      else
//      if (Data.ModBusMode = 4) then //MODBUSTCP_MODE 이면
//      begin
//        dcount := Data.NumOfData;
//        NumOfBit := Data.NumOfBit;
//        System.Move(Data.InpDataBuf, InpDataBuf, Sizeof(Data.InpDataBuf));
//      end
//      else
//      if (Data.ModBusMode = 3) then //simulate from csv file
//      begin
//        dcount := Data.NumOfData;
//        NumOfBit := Data.NumOfBit;
//        System.Move(Data.InpDataBuf_double, InpDataBuf_double, Sizeof(Data.InpDataBuf_double));
//      end//Data.ModBusMode = 3
//      else
//      if (Data.ModBusMode = 5) then//MODBUSSERIAL_TCP_MODE
//      begin
//        dcount := Data.NumOfData;
//        NumOfBit := Data.NumOfBit;
//        System.Move(Data.InpDataBuf, InpDataBuf, Sizeof(Data.InpDataBuf));
//      end;
//
//      ModBusAddress := Data.ModBusAddress;
//      BlockNo := Data.BlockNo;
//      NumOfData := dcount;
//      ModBusFunctionCode := Data.ModBusFunctionCode;
//      ModBusMapFileName := Data.ModBusMapFileName;
//      FModBusMapFileName := Data.ModBusMapFileName;
//
//      DisplayMessage2SB(FStatusBar, ModBusAddress + ' 데이타 도착');
//
//      SendMessage(Handle, WM_EVENT_ECS_COMAP, j,0);
//      CommonCommunication(psECS_ComAP);
//    end;
//  end;
//
////  dcount := 0;
////  FillChar(FECSData_ComAP.InpDataBuf[0], High(FECSData_ComAP.InpDataBuf) - 1, #0);
////  FECSData_ComAP.ModBusMode := Data.ModBusMode;
////
////  if Data.ModBusMode = 0 then //ASCII Mode이면
////  begin
////    //ModePanel.Caption := 'ASCII Mode';
////    dcount := Data.NumOfData;
////    FECSData_ComAP.NumOfBit := Data.NumOfBit;
////
////    for i := 0 to dcount - 1 do
////      FECSData_ComAP.InpDataBuf[i] := Data.InpDataBuf[i];
////  end
////  else
////  if Data.ModBusMode = 1 then// RTU Mode 이면
////  begin
////    dcount := Data.NumOfData div 2;
////    FECSData_ComAP.NumOfBit := Data.NumOfBit;
////
////    if dcount = 0 then
////      Inc(dcount);
////
////    for i := 0 to dcount - 1 do
////    begin
////      FECSData_ComAP.InpDataBuf[i] := Data.InpDataBuf2[i*2] ;
////      FECSData_ComAP.InpDataBuf[i] := FECSData_ComAP.InpDataBuf[i] shl 8 + Data.InpDataBuf2[i*2 + 1];
////    end;
////
////    if (Data.NumOfData mod 2) > 0 then
////      FECSData_ComAP.InpDataBuf[i] := Data.InpDataBuf2[i*2] ;
////  end//Data.ModBusMode = 1
////  else
////  if (Data.ModBusMode = 4) then //MODBUSTCP_MODE 이면
////  begin
////    dcount := Data.NumOfData;
////    FECSData_ComAP.NumOfBit := Data.NumOfBit;
////    System.Move(Data.InpDataBuf, FECSData_ComAP.InpDataBuf, Sizeof(Data.InpDataBuf));
////  end
////  else
////  if (Data.ModBusMode = 3) then //simulate from csv file
////  begin
////    dcount := Data.NumOfData;
////    FECSData_ComAP.NumOfBit := Data.NumOfBit;
////    System.Move(Data.InpDataBuf_double, FECSData_ComAP.InpDataBuf_double, Sizeof(Data.InpDataBuf_double));
////  end//Data.ModBusMode = 3
////  else
////  if (Data.ModBusMode = 5) then//MODBUSSERIAL_TCP_MODE
////  begin
////    dcount := Data.NumOfData;
////    FECSData_ComAP.NumOfBit := Data.NumOfBit;
////    System.Move(Data.InpDataBuf, FECSData_ComAP.InpDataBuf, Sizeof(Data.InpDataBuf));
////  end;
////
////  FECSData_ComAP.ModBusAddress := Data.ModBusAddress;
////  FECSData_ComAP.BlockNo := Data.BlockNo;
////  FECSData_ComAP.NumOfData := dcount;
////  FECSData_ComAP.ModBusFunctionCode := Data.ModBusFunctionCode;
////  FECSData_ComAP.ModBusMapFileName := Data.ModBusMapFileName;
////  FModBusMapFileName := Data.ModBusMapFileName;
////
////  DisplayMessage2SB(FStatusBar, FECSData_ComAP.ModBusAddress + ' 데이타 도착');
////
////  SendMessage(Handle, WM_EVENT_ECS_COMAP, 0,0);
////  CommonCommunication(psECS_ComAP);
//end;
//
//procedure TFrameIPCMonitorAll.ECS_OnSignal_kumo(Data: TEventData_ECS_kumo);
//var
//  i,j,dcount: integer;
//  LStr: string;
//begin
//  LStr := GetCombinedNamePSandSM(psWT1600);
//  j := FIPCMonitorList.IndexOf(LStr);
//
//  if j <> -1 then
//  begin
//    with TEventData_ECS_kumo(TIPCMonitor<TEventData_ECS_kumo>(FIPCMonitorList.Objects[j]).FEventDataRecord) do
//    begin
//      if not FCompleteReadMap_kumo then
//        exit;
//
//      FillChar(InpDataBuf[0], High(InpDataBuf) - 1, #0);
//      ModBusMode := Data.ModBusMode;
//
//      if Data.ModBusMode = 0 then //ASCII Mode이면
//      begin
//        //ModePanel.Caption := 'ASCII Mode';
//        dcount := Data.NumOfData;
//        NumOfBit := Data.NumOfBit;
//
//        for i := 0 to dcount - 1 do
//          InpDataBuf[i] := Data.InpDataBuf[i];
//      end
//      else
//      if Data.ModBusMode = 1 then// RTU Mode 이면
//      begin
//        //ModePanel.Caption := 'RTU Mode';
//        //dcount := Data.NumOfData div 2;
//        NumOfBit := Data.NumOfBit;
//
//        //if dcount = 0 then
//          //Inc(dcount);
//
//        //for i := 0 to dcount - 1 do
//        //begin
//        System.Move(Data.InpDataBuf, InpDataBuf, Sizeof(Data.InpDataBuf));
//          //InpDataBuf[i] := Data.InpDataBuf2[i*2] ;
//          //InpDataBuf[i] := InpDataBuf[i] shl 8 + Data.InpDataBuf2[i*2 + 1];
//        //end;
//
//        if (Data.NumOfData mod 2) > 0 then
//          InpDataBuf[i] := Data.InpDataBuf[i] ;
//          //InpDataBuf[i] := Data.InpDataBuf2[i*2] ;
//      end//Data.ModBusMode = 1
//      else
//      if (Data.ModBusMode = 3) then//simulation
//      begin
//        dcount := Data.NumOfData;
//        NumOfBit := Data.NumOfBit;
//        System.Move(Data.InpDataBuf_double, InpDataBuf_double, Sizeof(Data.InpDataBuf_double));
//      end;//Data.ModBusMode = 3
//
//      ModBusAddress := Data.ModBusAddress;
//      BlockNo := Data.BlockNo;
//      NumOfData := dcount;
//      ModBusFunctionCode := Data.ModBusFunctionCode;
//      ModBusMapFileName := Data.ModBusMapFileName;
//      FModBusMapFileName := Data.ModBusMapFileName;
//      DisplayMessage2SB(FStatusBar, ModBusAddress + ' 데이타 도착');
//
//      SendMessage(Handle, WM_EVENT_ECS_KUMO, j,0);
//      CommonCommunication(psECS_kumo);
//
//    end;
//  end;
//
////  if not FCompleteReadMap_kumo then
////    exit;
////
////  FillChar(FECSData_kumo.InpDataBuf[0], High(FECSData_kumo.InpDataBuf) - 1, #0);
////  FECSData_kumo.ModBusMode := Data.ModBusMode;
////
////  if Data.ModBusMode = 0 then //ASCII Mode이면
////  begin
////    //ModePanel.Caption := 'ASCII Mode';
////    dcount := Data.NumOfData;
////    FECSData_kumo.NumOfBit := Data.NumOfBit;
////
////    for i := 0 to dcount - 1 do
////      FECSData_kumo.InpDataBuf[i] := Data.InpDataBuf[i];
////  end
////  else
////  if Data.ModBusMode = 1 then// RTU Mode 이면
////  begin
////    //ModePanel.Caption := 'RTU Mode';
////    //dcount := Data.NumOfData div 2;
////    FECSData_kumo.NumOfBit := Data.NumOfBit;
////
////    //if dcount = 0 then
////      //Inc(dcount);
////
////    //for i := 0 to dcount - 1 do
////    //begin
////    System.Move(Data.InpDataBuf, FECSData_kumo.InpDataBuf, Sizeof(Data.InpDataBuf));
////      //FECSData_kumo.InpDataBuf[i] := Data.InpDataBuf2[i*2] ;
////      //FECSData_kumo.InpDataBuf[i] := FECSData_kumo.InpDataBuf[i] shl 8 + Data.InpDataBuf2[i*2 + 1];
////    //end;
////
////    if (Data.NumOfData mod 2) > 0 then
////      FECSData_kumo.InpDataBuf[i] := Data.InpDataBuf[i] ;
////      //FECSData_kumo.InpDataBuf[i] := Data.InpDataBuf2[i*2] ;
////  end//Data.ModBusMode = 1
////  else
////  if (Data.ModBusMode = 3) then//simulation
////  begin
////    dcount := Data.NumOfData;
////    FECSData_kumo.NumOfBit := Data.NumOfBit;
////    System.Move(Data.InpDataBuf_double, FECSData_kumo.InpDataBuf_double, Sizeof(Data.InpDataBuf_double));
////  end;//Data.ModBusMode = 3
////
////  FECSData_kumo.ModBusAddress := Data.ModBusAddress;
////  FECSData_kumo.BlockNo := Data.BlockNo;
////  FECSData_kumo.NumOfData := dcount;
////  FECSData_kumo.ModBusFunctionCode := Data.ModBusFunctionCode;
////  FECSData_kumo.ModBusMapFileName := Data.ModBusMapFileName;
////  FModBusMapFileName := Data.ModBusMapFileName;
////  DisplayMessage2SB(FStatusBar, FECSData_kumo.ModBusAddress + ' 데이타 도착');
////
////  SendMessage(Handle, WM_EVENT_ECS_KUMO, 0,0);
////  CommonCommunication(psECS_kumo);
//end;
//
//procedure TFrameIPCMonitorAll.ECS_OnSignal_Woodward(Data: TEventData_ECS_Woodward);
//var
//  i,j,dcount: integer;
//  LStr: string;
//begin
//  LStr := GetCombinedNamePSandSM(psWT1600);
//  j := FIPCMonitorList.IndexOf(LStr);
//
//  if j <> -1 then
//  begin
//    with TEventData_ECS_Woodward(TIPCMonitor<TEventData_ECS_Woodward>(FIPCMonitorList.Objects[j]).FEventDataRecord) do
//    begin
//      if not FCompleteReadMap_Woodward then
//        exit;
//
//      dcount := 0;
//      FillChar(InpDataBuf[0], High(InpDataBuf) - 1, #0);
//      ModBusMode := Data.ModBusMode;
//
//      if Data.ModBusMode = 0 then //ASCII Mode이면
//      begin
//        //ModePanel.Caption := 'ASCII Mode';
//        dcount := Data.NumOfData;
//        NumOfBit := Data.NumOfBit;
//
//        for i := 0 to dcount - 1 do
//          InpDataBuf[i] := Data.InpDataBuf[i];
//      end
//      else
//      if Data.ModBusMode = 1 then// RTU Mode 이면
//      begin
//        //ModePanel.Caption := 'RTU Mode';
//        dcount := Data.NumOfData div 2;
//        NumOfBit := Data.NumOfBit;
//
//        if dcount = 0 then
//          Inc(dcount);
//
//        for i := 0 to dcount - 1 do
//        begin
//          InpDataBuf[i] := Data.InpDataBuf2[i*2] ;
//          InpDataBuf[i] := InpDataBuf[i] shl 8 + Data.InpDataBuf2[i*2 + 1];
//    //      FModBusData.InpDataBuf[i] :=  ;
//        end;
//
//        if (Data.NumOfData mod 2) > 0 then
//          InpDataBuf[i] := Data.InpDataBuf2[i*2] ;
//      end//Data.ModBusMode = 1
//      else
//      if (Data.ModBusMode = 4) then //MODBUSTCP_MODE 이면
//      begin
//        dcount := Data.NumOfData;
//        NumOfBit := Data.NumOfBit;
//        System.Move(Data.InpDataBuf, InpDataBuf, Sizeof(Data.InpDataBuf));
//
//        //for i := 0 to dcount - 1 do
//          //FECSData.InpDataBuf[i] := Data.InpDataBuf[i];
//      end
//      else
//      if (Data.ModBusMode = 3) then //simulate from csv file
//      begin
//        dcount := Data.NumOfData;
//        NumOfBit := Data.NumOfBit;
//        System.Move(Data.InpDataBuf_double, InpDataBuf_double, Sizeof(Data.InpDataBuf_double));
//      end;//Data.ModBusMode = 3
//
//      ModBusAddress := Data.ModBusAddress;
//      BlockNo := Data.BlockNo;
//      NumOfData := dcount;
//      ModBusFunctionCode := Data.ModBusFunctionCode;
//      ModBusMapFileName := Data.ModBusMapFileName;
//      FModBusMapFileName := Data.ModBusMapFileName;
//
//      DisplayMessage2SB(FStatusBar, ModBusAddress + ' 데이타 도착');
//
//      SendMessage(Handle, WM_EVENT_ECS_Woodward, j, 0);
//      CommonCommunication(psECS_Woodward);
//    end;
//  end;
////  if not FCompleteReadMap_Woodward then
////    exit;
////
////  dcount := 0;
////  FillChar(FECSData_Woodward.InpDataBuf[0], High(FECSData_Woodward.InpDataBuf) - 1, #0);
////  FECSData_Woodward.ModBusMode := Data.ModBusMode;
////
////  if Data.ModBusMode = 0 then //ASCII Mode이면
////  begin
////    //ModePanel.Caption := 'ASCII Mode';
////    dcount := Data.NumOfData;
////    FECSData_Woodward.NumOfBit := Data.NumOfBit;
////
////    for i := 0 to dcount - 1 do
////      FECSData_Woodward.InpDataBuf[i] := Data.InpDataBuf[i];
////  end
////  else
////  if Data.ModBusMode = 1 then// RTU Mode 이면
////  begin
////    //ModePanel.Caption := 'RTU Mode';
////    dcount := Data.NumOfData div 2;
////    FECSData_Woodward.NumOfBit := Data.NumOfBit;
////
////    if dcount = 0 then
////      Inc(dcount);
////
////    for i := 0 to dcount - 1 do
////    begin
////      FECSData_Woodward.InpDataBuf[i] := Data.InpDataBuf2[i*2] ;
////      FECSData_Woodward.InpDataBuf[i] := FECSData_Woodward.InpDataBuf[i] shl 8 + Data.InpDataBuf2[i*2 + 1];
//////      FModBusData.InpDataBuf[i] :=  ;
////    end;
////
////    if (Data.NumOfData mod 2) > 0 then
////      FECSData_Woodward.InpDataBuf[i] := Data.InpDataBuf2[i*2] ;
////  end//Data.ModBusMode = 1
////  else
////  if (Data.ModBusMode = 4) then //MODBUSTCP_MODE 이면
////  begin
////    dcount := Data.NumOfData;
////    FECSData_Woodward.NumOfBit := Data.NumOfBit;
////    System.Move(Data.InpDataBuf, FECSData_Woodward.InpDataBuf, Sizeof(Data.InpDataBuf));
////
////    //for i := 0 to dcount - 1 do
////      //FECSData.InpDataBuf[i] := Data.InpDataBuf[i];
////  end
////  else
////  if (Data.ModBusMode = 3) then //simulate from csv file
////  begin
////    dcount := Data.NumOfData;
////    FECSData_Woodward.NumOfBit := Data.NumOfBit;
////    System.Move(Data.InpDataBuf_double, FECSData_Woodward.InpDataBuf_double, Sizeof(Data.InpDataBuf_double));
////  end;//Data.ModBusMode = 3
////
////  FECSData_Woodward.ModBusAddress := Data.ModBusAddress;
////  FECSData_Woodward.BlockNo := Data.BlockNo;
////  FECSData_Woodward.NumOfData := dcount;
////  FECSData_Woodward.ModBusFunctionCode := Data.ModBusFunctionCode;
////  FECSData_Woodward.ModBusMapFileName := Data.ModBusMapFileName;
////  FModBusMapFileName := Data.ModBusMapFileName;
////
////  DisplayMessage2SB(FStatusBar, FECSData_Woodward.ModBusAddress + ' 데이타 도착');
////
////  SendMessage(Handle, WM_EVENT_ECS_Woodward, 0,0);
////  CommonCommunication(psECS_Woodward);
//end;
//
//procedure TFrameIPCMonitorAll.EngineParam_OnSignal(Data: TEventData_EngineParam);
//var
//  j: integer;
//  LStr: string;
//begin
//  LStr := GetCombinedNamePSandSM(psEngineParam);
//  j := FIPCMonitorList.IndexOf(LStr);
//
//  if j <> -1 then
//  begin
//    with TEventData_EngineParam(TIPCMonitor<TEventData_EngineParam>(FIPCMonitorList.Objects[j]).FEventDataRecord) do
//    begin
//      System.Move(Data.FData, FData, Sizeof(Data.FData));
//      FDataCount := Data.FDataCount;
//
//      SendMessage(Handle, WM_EVENT_ENGINEPARAM, j,0);
//      CommonCommunication(psEngineParam);
//    end;
//  end;
////  System.Move(Data.FData, FEngineParamData.FData, Sizeof(Data.FData));
////  FEngineParamData.FDataCount := Data.FDataCount;
////
////  SendMessage(Handle, WM_EVENT_ENGINEPARAM, 0,0);
////  CommonCommunication(psEngineParam);
//end;
//
//procedure TFrameIPCMonitorAll.FlowMeter_OnSignal(Data: TEventData_FlowMeter);
//begin
////;
//  CommonCommunication(psFlowMeter);
//end;
//
////AAutoStart: True = 프로그램 시작시에 watch file name을 parameter로 입력받는 경우
////            False = LoadFromFile 메뉴로 실행되는 경우
//procedure TFrameIPCMonitorAll.GasCalc_OnSignal(Data: TEventData_GasCalc);
//var
//  i,j,dcount: integer;
//  LStr: string;
//begin
//  LStr := GetCombinedNamePSandSM(psWT1600);
//  j := FIPCMonitorList.IndexOf(LStr);
//
//  if j <> -1 then
//  begin
//    with TEventData_GasCalc(TIPCMonitor<TEventData_GasCalc>(FIPCMonitorList.Objects[j]).FEventDataRecord) do
//    begin
//      FSVP := Data.FSVP;
//      FIAH2 := Data.FIAH2;
//      FUFC := Data.FUFC;
//      FNhtCF := Data.FNhtCF;
//      FDWCFE := Data.FDWCFE;
//      FEGF := Data.FEGF;
//      FNOxAtO213 := Data.FNOxAtO213;
//      FNOx := Data.FNOx;
//      FAF1 := Data.FAF1;
//      FAF2 := Data.FAF2;
//      FAF3 := Data.FAF3;
//      FAF_Measured := Data.FAF_Measured;
//      FMT210 := Data.FMT210;
//      FFC := Data.FFC;
//      FEngineOutput := Data.FEngineOutput;
//      FGeneratorOutput := Data.FGeneratorOutput;
//      FEngineLoad := Data.FEngineLoad;
//      FGenEfficiency := Data.FGenEfficiency;
//      FBHP := Data.FBHP;
//      FBMEP := Data.FBMEP;
//      FLamda_Calculated := Data.FLamda_Calculated;
//      FLamda_Measured := Data.FLamda_Measured;
//      FLamda_Brettschneider := Data.FLamda_Brettschneider;
//      FAFRatio_Calculated := Data.FAFRatio_Calculated;
//      FAFRatio_Measured := Data.FAFRatio_Measured;
//      FExhTempAvg := Data.FExhTempAvg;
//      FWasteGatePosition := Data.FWasteGatePosition;
//      FThrottlePosition := Data.FThrottlePosition;
//      //FBoostPress := Data.FBoostPress;
//      FDensity := Data.FDensity;
//      FLCV := Data.FLCV;
//
//      SendMessage(Handle, WM_EVENT_GASCALC, j,0);
//      CommonCommunication(psGasCalculated);
//    end;
//  end;
////  FGasCalcData.FSVP := Data.FSVP;
////  FGasCalcData.FIAH2 := Data.FIAH2;
////  FGasCalcData.FUFC := Data.FUFC;
////  FGasCalcData.FNhtCF := Data.FNhtCF;
////  FGasCalcData.FDWCFE := Data.FDWCFE;
////  FGasCalcData.FEGF := Data.FEGF;
////  FGasCalcData.FNOxAtO213 := Data.FNOxAtO213;
////  FGasCalcData.FNOx := Data.FNOx;
////  FGasCalcData.FAF1 := Data.FAF1;
////  FGasCalcData.FAF2 := Data.FAF2;
////  FGasCalcData.FAF3 := Data.FAF3;
////  FGasCalcData.FAF_Measured := Data.FAF_Measured;
////  FGasCalcData.FMT210 := Data.FMT210;
////  FGasCalcData.FFC := Data.FFC;
////  FGasCalcData.FEngineOutput := Data.FEngineOutput;
////  FGasCalcData.FGeneratorOutput := Data.FGeneratorOutput;
////  FGasCalcData.FEngineLoad := Data.FEngineLoad;
////  FGasCalcData.FGenEfficiency := Data.FGenEfficiency;
////  FGasCalcData.FBHP := Data.FBHP;
////  FGasCalcData.FBMEP := Data.FBMEP;
////  FGasCalcData.FLamda_Calculated := Data.FLamda_Calculated;
////  FGasCalcData.FLamda_Measured := Data.FLamda_Measured;
////  FGasCalcData.FLamda_Brettschneider := Data.FLamda_Brettschneider;
////  FGasCalcData.FAFRatio_Calculated := Data.FAFRatio_Calculated;
////  FGasCalcData.FAFRatio_Measured := Data.FAFRatio_Measured;
////  FGasCalcData.FExhTempAvg := Data.FExhTempAvg;
////  FGasCalcData.FWasteGatePosition := Data.FWasteGatePosition;
////  FGasCalcData.FThrottlePosition := Data.FThrottlePosition;
////  //FGasCalcData.FBoostPress := Data.FBoostPress;
////  FGasCalcData.FDensity := Data.FDensity;
////  FGasCalcData.FLCV := Data.FLCV;
////
////  SendMessage(Handle, WM_EVENT_GASCALC, 0,0);
////  CommonCommunication(psGasCalculated);
//end;

//DataSaveAll에서 사용 됨
procedure TFrameIPCMonitorAll.GetParameterSourceList(var AList: TStringList);
var
  i,j: integer;
  LStr: string;
begin
  AList.Clear;

  for i := 0 to FEngineParameter.EngineParameterCollect.Count - 1 do
  begin
    LStr := ParameterSource2String(FEngineParameter.EngineParameterCollect.Items[i].ParameterSource);
    j := AList.IndexOf(LStr);
    if j = -1 then
      AList.AddObject(LStr, FEngineParameter.EngineParameterCollect.Items[i]);
  end;
end;

//procedure TFrameIPCMonitorAll.HIC_OnSignal(Data: TEventData_HIC);
//begin
//
//end;

procedure TFrameIPCMonitorAll.InitVar;
begin
  g_FrameHandle := Handle;

  FAddressMap := DMap.Create;
  //FConfigOption := TConfigOption.Create(nil); FModbusMapFileName 변수로 대체
  FEngineParameter := TEngineParameter.Create(nil);
  FPJHTimerPool := TPJHTimerPool.Create(nil);
  FNextGrid := nil;
  FCompleteReadMap_Avat := False;
  FCompleteReadMap_Woodward := False;
  FCompleteReadMap_kumo := False;
  FIsSetZeroWhenDisconnect := True;
  FCurrentUserLevel := HUL_Operator;
  FWatchValue2Screen_AnalogEvent := nil;
  FIPCMonitorList := TStringList.Create;
end;

//procedure TFrameIPCMonitorAll.KRAL_OnSignal(Data: TEventData_Modbus_Standard);
//var
//  i,j,dcount: integer;
//  LStr: string;
//begin
//  LStr := GetCombinedNamePSandSM(psFlowMeterKral);
//  j := FIPCMonitorList.IndexOf(LStr);
//
//  if j <> -1 then
//  begin
//    with TEventData_Modbus_Standard(TIPCMonitor<TEventData_Modbus_Standard>(FIPCMonitorList.Objects[j]).FEventDataRecord) do
//    begin
//      FillChar(InpDataBuf[0], High(InpDataBuf) - 1, #0);
//      ModBusMode := Data.ModBusMode;
//
//      if Data.ModBusMode = 0 then //ASCII Mode이면
//      begin
//        //ModePanel.Caption := 'ASCII Mode';
//        dcount := Data.NumOfData;
//        NumOfBit := Data.NumOfBit;
//
//        for i := 0 to dcount - 1 do
//          InpDataBuf2[i] := Data.InpDataBuf2[i];
//      end
//      else
//      if Data.ModBusMode = 1 then// RTU Mode 이면
//      begin
//        //ModePanel.Caption := 'RTU Mode';
//        dcount := Data.NumOfData;
//        NumOfBit := Data.NumOfBit;
//
//        if dcount = 0 then
//          Inc(dcount);
//
//        for i := 0 to dcount - 1 do
//        begin
//          InpDataBuf[i] := Data.InpDataBuf[i] ;
//        end;
//      end//Data.ModBusMode = 1
//      else
//      if (Data.ModBusMode = 3) then
//      begin
//        dcount := Data.NumOfData;
//        NumOfBit := Data.NumOfBit;
//        System.Move(Data.InpDataBuf_double, InpDataBuf_double, Sizeof(Data.InpDataBuf_double));
//      end;//Data.ModBusMode = 3
//
//      ModBusAddress := Data.ModBusAddress;
//      BlockNo := Data.BlockNo;
//      NumOfData := dcount;
//      ModBusFunctionCode := Data.ModBusFunctionCode;
//
//      DisplayMessage2SB(FStatusBar, ModBusAddress + ' 데이타 도착');
//
//      SendMessage(Handle, WM_EVENT_KRAL, j,0);
//      CommonCommunication(psFlowMeterKral);
//    end;
//  end;
//
////  FillChar(FKRALData.InpDataBuf[0], High(FKRALData.InpDataBuf) - 1, #0);
////  FKRALData.ModBusMode := Data.ModBusMode;
////
////  if Data.ModBusMode = 0 then //ASCII Mode이면
////  begin
////    //ModePanel.Caption := 'ASCII Mode';
////    dcount := Data.NumOfData;
////    FKRALData.NumOfBit := Data.NumOfBit;
////
////    for i := 0 to dcount - 1 do
////      FKRALData.InpDataBuf2[i] := Data.InpDataBuf2[i];
////  end
////  else
////  if Data.ModBusMode = 1 then// RTU Mode 이면
////  begin
////    //ModePanel.Caption := 'RTU Mode';
////    dcount := Data.NumOfData;
////    FKRALData.NumOfBit := Data.NumOfBit;
////
////    if dcount = 0 then
////      Inc(dcount);
////
////    for i := 0 to dcount - 1 do
////    begin
////      FKRALData.InpDataBuf[i] := Data.InpDataBuf[i] ;
////    end;
////  end//Data.ModBusMode = 1
////  else
////  if (Data.ModBusMode = 3) then
////  begin
////    dcount := Data.NumOfData;
////    FKRALData.NumOfBit := Data.NumOfBit;
////    System.Move(Data.InpDataBuf_double, FKRALData.InpDataBuf_double, Sizeof(Data.InpDataBuf_double));
////  end;//Data.ModBusMode = 3
////
////  FKRALData.ModBusAddress := Data.ModBusAddress;
////  FKRALData.BlockNo := Data.BlockNo;
////  FKRALData.NumOfData := dcount;
////  FKRALData.ModBusFunctionCode := Data.ModBusFunctionCode;
////
////  DisplayMessage2SB(FStatusBar, FKRALData.ModBusAddress + ' 데이타 도착');
////
////  SendMessage(Handle, WM_EVENT_KRAL, 0,0);
////  CommonCommunication(psFlowMeterKral);
//end;
//
//procedure TFrameIPCMonitorAll.LBX_OnSignal(Data: TEventData_LBX);
//var
//  i,j,dcount: integer;
//  LStr: string;
//begin
//  LStr := GetCombinedNamePSandSM(psWT1600);
//  j := FIPCMonitorList.IndexOf(LStr);
//
//  if j <> -1 then
//  begin
//    with TEventData_LBX(TIPCMonitor<TEventData_LBX>(FIPCMonitorList.Objects[j]).FEventDataRecord) do
//    begin
//      ENGRPM := Data.ENGRPM;
//      HTTEMP := Data.HTTEMP;
//      LOTEMP := Data.LOTEMP;
//      TCRPMA := Data.TCRPMA;
//      TCRPMB := Data.TCRPMB;
//      TCINLETTEMP := Data.TCINLETTEMP;
//
//      SendMessage(Handle, WM_EVENT_LBX, j,0);
//      CommonCommunication(psLBX);
//    end;
//  end;
//
////  FLBXData.ENGRPM := Data.ENGRPM;
////  FLBXData.HTTEMP := Data.HTTEMP;
////  FLBXData.LOTEMP := Data.LOTEMP;
////  FLBXData.TCRPMA := Data.TCRPMA;
////  FLBXData.TCRPMB := Data.TCRPMB;
////  FLBXData.TCINLETTEMP := Data.TCINLETTEMP;
////
////  SendMessage(Handle, WM_EVENT_LBX, 0,0);
////  CommonCommunication(psLBX);
//end;

procedure TFrameIPCMonitorAll.MakeMapFromParameter;
var
  HiMap: THiMap;
  i,j, LLastBlockNo, LLastIndex: integer;
begin
  FAddressMap.clear;

  for i := 0 to FEngineParameter.EngineParameterCollect.Count - 1 do
  begin
    HiMap := THiMap.Create;

    with HiMap, FEngineParameter do
    begin
      FName := EngineParameterCollect.Items[i].TagName;
      FDescription := EngineParameterCollect.Items[i].Description;
      FSid := i;
      FAddress := EngineParameterCollect.Items[i].Address;
      //kumo ECS를 Value2Screen_ECS 함수에서 처리하기 위함
      FUnit := EngineParameterCollect.Items[i].FFUnit;
      FBlockNo := i;

      j := 0;
      LLastIndex := 0;
      {if i = 0 then
        LLastBlockNo := FBlockNo;

      if LLastBlockNo <> FBlockNo then
      begin
        LLastIndex := 0;
        LLastBlockNo := FBlockNo;
      end;

      FListIndex := LLastIndex;
      inc(LLastIndex);
      }

      if UpperCase(FDescription) <> 'DUMMY' then
      begin
        FListIndexNoDummy := j;
        Inc(j);
      end
      else
        FListIndexNoDummy := -1;

      FAlarm := EngineParameterCollect.Items[i].Alarm;

      FMaxval := EngineParameterCollect.Items[i].MaxValue;
      FContact := EngineParameterCollect.Items[i].Contact;

      FAddressMap.PutPair([EngineParameterCollect.Items[i].FCode + HiMap.FAddress,HiMap]);
    end;//with
  end;//for
end;

//procedure TFrameIPCMonitorAll.MEXA7000_2_OnSignal(Data: TEventData_MEXA7000_2);
//var
//  i,j,dcount: integer;
//  LStr: string;
//begin
//  LStr := GetCombinedNamePSandSM(psMEXA7000);
//  j := FIPCMonitorList.IndexOf(LStr);
//
//  if j <> -1 then
//  begin
//    with TEventData_MEXA7000_2(TIPCMonitor<TEventData_MEXA7000_2>(FIPCMonitorList.Objects[j]).FEventDataRecord) do
//    begin
//      CO2 := Data.CO2;
//      CO_L := Data.CO_L;
//      O2 := Data.O2;
//      NOx := Data.NOx;
//      THC := Data.THC;
//      CH4 := Data.CH4;
//      non_CH4 := Data.non_CH4;
//      CollectedValue := Data.CollectedValue;
//
//      SendMessage(Handle, WM_EVENT_MEXA7000, j,0);
//      CommonCommunication(psMEXA7000);
//    end;
//  end;
//
////  FMEXA7000Data.CO2 := Data.CO2;
////  FMEXA7000Data.CO_L := Data.CO_L;
////  FMEXA7000Data.O2 := Data.O2;
////  FMEXA7000Data.NOx := Data.NOx;
////  FMEXA7000Data.THC := Data.THC;
////  FMEXA7000Data.CH4 := Data.CH4;
////  FMEXA7000Data.non_CH4 := Data.non_CH4;
////  FMEXA7000Data.CollectedValue := Data.CollectedValue;
////
////  SendMessage(Handle, WM_EVENT_MEXA7000, 0,0);
////  CommonCommunication(psMEXA7000);
//end;
//
//procedure TFrameIPCMonitorAll.MEXA7000_OnSignal(Data: TEventData_MEXA7000);
//var
//  i,j,dcount: integer;
//  LStr: string;
//begin
//  LStr := GetCombinedNamePSandSM(psMEXA7000);
//  j := FIPCMonitorList.IndexOf(LStr);
//
//  if j <> -1 then
//  begin
//    with TEventData_MEXA7000(TIPCMonitor<TEventData_MEXA7000>(FIPCMonitorList.Objects[j]).FEventDataRecord) do
//    begin
////      CO2 := StrToFloatDef(Data.CO2,0.0);
////      CO_L := StrToFloatDef(Data.CO_L,0.0);
////      O2 := StrToFloatDef(Data.O2,0.0);
////      NOx := StrToFloatDef(Data.NOx,0.0);
////      THC := StrToFloatDef(Data.THC,0.0);
////      CH4 := StrToFloatDef(Data.CH4,0.0);
////      non_CH4 := StrToFloatDef(Data.non_CH4,0.0);
////      CollectedValue := Data.CollectedValue;
//
//      SendMessage(Handle, WM_EVENT_MEXA7000, j,0);
//      CommonCommunication(psMEXA7000);
//    end;
//  end;
//
////  FMEXA7000Data.CO2 := StrToFloatDef(Data.CO2,0.0);
////  FMEXA7000Data.CO_L := StrToFloatDef(Data.CO_L,0.0);
////  FMEXA7000Data.O2 := StrToFloatDef(Data.O2,0.0);
////  FMEXA7000Data.NOx := StrToFloatDef(Data.NOx,0.0);
////  FMEXA7000Data.THC := StrToFloatDef(Data.THC,0.0);
////  FMEXA7000Data.CH4 := StrToFloatDef(Data.CH4,0.0);
////  FMEXA7000Data.non_CH4 := StrToFloatDef(Data.non_CH4,0.0);
////  FMEXA7000Data.CollectedValue := Data.CollectedValue;
////
////  SendMessage(Handle, WM_EVENT_MEXA7000, 0,0);
////  CommonCommunication(psMEXA7000);
//end;

//추가 또는 수정되는 FEngineParameter.EngineParameterCollectItem의 Index를 반환함
function TFrameIPCMonitorAll.MoveEngineParameterItemRecord(
  AEPItemRecord: TEngineParameterItemRecord;
  ADragCopyMode: TParamDragCopyMode = dcmCopyOnlyNonExist): integer;
var
  LEPItem: TEngineParameterItem;
  LMItem: TMatrixItem;
begin
  Result := CheckExistTagName(AEPItemRecord.FParameterSource,AEPItemRecord.FTagName);


  FEngineParameter.ProjectFileName := AEPItemRecord.FProjectFileName;

  case ADragCopyMode of
    dcmCopyOnlyExist: begin
      if Result > -1 then
      begin
        LEPItem := FEngineParameter.EngineParameterCollect.Items[Result];

        if LEPItem.ParameterType in TMatrixTypes then
          LMItem := FEngineParameter.MatrixCollect.Items[Result];
      end
      else
        exit;
    end;

    dcmCopyOnlyNonExist: begin
      if Result > -1 then
        exit;

      LEPItem := FEngineParameter.EngineParameterCollect.Add;

      if LEPItem.ParameterType in TMatrixTypes then
        LMItem := FEngineParameter.MatrixCollect.Add;
    end;

    dcmCopyAllOverWrite: begin
      if Result > -1 then
      begin
        LEPItem := FEngineParameter.EngineParameterCollect.Items[Result];

        if LEPItem.ParameterType in TMatrixTypes then
          LMItem := FEngineParameter.MatrixCollect.Items[Result];
      end
      else
      begin
        LEPItem := FEngineParameter.EngineParameterCollect.Add;

        if LEPItem.ParameterType in TMatrixTypes then
          LMItem := FEngineParameter.MatrixCollect.Add;
      end;
    end;
  end;

  AEPItemRecord.AssignToParamItem(LEPItem);

  if LEPItem.ParameterType in TMatrixTypes then
  begin
//    LMItem := FEngineParameter.MatrixCollect.Add;
    AEPItemRecord.AssignToMatrixitem(LMItem);
    LEPItem.MatrixItemIndex := FEngineParameter.MatrixCollect.Count - 1;
  end;

  FCurrentUserLevel := AEPItemRecord.FAllowUserLevelWatchList;

  FEngineParameter.FormWidth := AEPItemRecord.FFormWidth;
  FEngineParameter.FormHeight := AEPItemRecord.FFormHeight;
  FEngineParameter.FormTop := AEPItemRecord.FFormTop;
  FEngineParameter.FormLeft := AEPItemRecord.FFormLeft;
  FEngineParameter.FormState := AEPItemRecord.FFormState;

    //상속 받은 자손에서 구현할 것
    //if Assigned(AGrid) then
    //begin
    //  i := AGrid.AddRow();
    //  AGrid.CellsByName['ItemName', i] := Description;
    //  AGrid.CellsByName['FUnit', i] := FFUnit;
    //  AGrid.ClearSelection;
    //  AGrid.Selected[i] := True;
    //  AGrid.ScrollToRow(i);
    //end;
    //  AGrid.Cell[0, i].AsInteger := -1;
    //  AGrid.Cell[1, i].AsInteger := -1;
    //  AGrid.Cell[5, i].AsInteger := -1;
    //Administrator이상의 권한자 만이 Config form에서 level 조정 가능함
    {if FCurrentUserLevel <= HUL_Administrator then
    begin
      AllowUserlevelCB.Enabled := True;
    end;

    if AllowUserlevelCB.Text = '' then
      AllowUserlevelCB.Text := UserLevel2String(FCurrentUserLevel);
    }

  //Result := FEngineParameter.EngineParameterCollect.Count - 1;
end;

procedure TFrameIPCMonitorAll.MoveEngineParameterItemRecord2(
  var AItemRecord: TEngineParameterItemRecord; AItemIndex: integer);
begin
  FEngineParameter.EngineParameterCollect.Items[AItemIndex].AssignTo(AItemRecord);
  AItemRecord.FAllowUserLevelWatchList := FCurrentUserLevel;
  AItemRecord.FProjectFileName := FEngineParameter.ProjectFileName;
end;

//procedure TFrameIPCMonitorAll.MT210_OnSignal(Data: TEventData_MT210);
//var
//  i,j,dcount: integer;
//  LStr: string;
//begin
//  LStr := GetCombinedNamePSandSM(psMT210);
//  j := FIPCMonitorList.IndexOf(LStr);
//
//  if j <> -1 then
//  begin
//    with TEventData_MT210(TIPCMonitor<TEventData_MT210>(FIPCMonitorList.Objects[j]).FEventDataRecord) do
//    begin
//      FData := Data.FData;
//      SendMessage(Handle, WM_EVENT_MT210, j,0);
//      CommonCommunication(psMT210);
//    end;
//  end;
////  FMT210Data.FData := Data.FData;
////  SendMessage(Handle, WM_EVENT_MT210, 0,0);
////  CommonCommunication(psMT210);
//end;

procedure TFrameIPCMonitorAll.OnSetZeroDYNAMO(Sender: TObject; Handle: Integer;
  Interval: Cardinal; ElapsedTime: Integer);
var
  j: integer;
  LStr: string;
begin
  LStr := GetCombinedNamePSandSM(psMT210);
  j := FIPCMonitorList.IndexOf(LStr);

  if j <> -1 then
  begin
    FillChar(TIPCMonitor<TEventData_MT210>(FIPCMonitorList.Objects[j]).FEventDataRecord, Sizeof(TIPCMonitor<TEventData_MT210>(FIPCMonitorList.Objects[j]).FEventDataRecord), 0);

    if not g_CommDisconnected then
      g_CommDisconnected := True;
  end;
//  FillChar(FDYNAMOData, Sizeof(FDYNAMOData), 0);
//
//  if not FCommDisconnected then
//    FCommDisconnected := True;
end;

procedure TFrameIPCMonitorAll.OnSetZeroECS_AVAT(Sender: TObject; Handle: Integer;
  Interval: Cardinal; ElapsedTime: Integer);
var
  j: integer;
  LStr: string;
begin
  LStr := GetCombinedNamePSandSM(psECS_AVAT);
  j := FIPCMonitorList.IndexOf(LStr);

  if j <> -1 then
  begin
    FillChar(TIPCMonitor<TEventData_ECS_AVAT>(FIPCMonitorList.Objects[j]).FEventDataRecord, Sizeof(TIPCMonitor<TEventData_ECS_AVAT>(FIPCMonitorList.Objects[j]).FEventDataRecord), 0);

    if not g_CommDisconnected then
      g_CommDisconnected := True;
  end;
//  FillChar(FECSData_AVAT, Sizeof(FECSData_AVAT), 0);
//
//  if not FCommDisconnected then
//    FCommDisconnected := True;
end;

procedure TFrameIPCMonitorAll.OnSetZeroECS_ComAP(Sender: TObject;
  Handle: Integer; Interval: Cardinal; ElapsedTime: Integer);
var
  j: integer;
  LStr: string;
begin
  LStr := GetCombinedNamePSandSM(psECS_ComAP);
  j := FIPCMonitorList.IndexOf(LStr);

  if j <> -1 then
  begin
    FillChar(TIPCMonitor<TEventData_Modbus_Standard>(FIPCMonitorList.Objects[j]).FEventDataRecord, Sizeof(TIPCMonitor<TEventData_Modbus_Standard>(FIPCMonitorList.Objects[j]).FEventDataRecord), 0);

    if not g_CommDisconnected then
      g_CommDisconnected := True;
  end;
//  FillChar(FECSData_ComAP, Sizeof(FECSData_ComAP), 0);
//
//  if not FCommDisconnected then
//    FCommDisconnected := True;
end;

procedure TFrameIPCMonitorAll.OnSetZeroECS_kumo(Sender: TObject; Handle: Integer;
  Interval: Cardinal; ElapsedTime: Integer);
var
  j: integer;
  LStr: string;
begin
  LStr := GetCombinedNamePSandSM(psECS_kumo);
  j := FIPCMonitorList.IndexOf(LStr);

  if j <> -1 then
  begin
    FillChar(TIPCMonitor<TEventData_ECS_kumo>(FIPCMonitorList.Objects[j]).FEventDataRecord, Sizeof(TIPCMonitor<TEventData_ECS_kumo>(FIPCMonitorList.Objects[j]).FEventDataRecord), 0);

    if not g_CommDisconnected then
      g_CommDisconnected := True;
  end;

//  FillChar(FECSData_kumo, Sizeof(FECSData_kumo), 0);
//
//  if not FCommDisconnected then
//    FCommDisconnected := True;
end;

procedure TFrameIPCMonitorAll.OnSetZeroECS_Woodward(Sender: TObject;
  Handle: Integer; Interval: Cardinal; ElapsedTime: Integer);
var
  j: integer;
  LStr: string;
begin
  LStr := GetCombinedNamePSandSM(psECS_Woodward);
  j := FIPCMonitorList.IndexOf(LStr);

  if j <> -1 then
  begin
    FillChar(TIPCMonitor<TEventData_ECS_Woodward>(FIPCMonitorList.Objects[j]).FEventDataRecord, Sizeof(TIPCMonitor<TEventData_ECS_Woodward>(FIPCMonitorList.Objects[j]).FEventDataRecord), 0);

    if not g_CommDisconnected then
      g_CommDisconnected := True;
  end;
//  FillChar(FECSData_Woodward, Sizeof(FECSData_Woodward), 0);
//
//  if not FCommDisconnected then
//    FCommDisconnected := True;
end;

procedure TFrameIPCMonitorAll.OnSetZeroEngineParam(Sender: TObject;
  Handle: Integer; Interval: Cardinal; ElapsedTime: Integer);
var
  j: integer;
  LStr: string;
begin
  LStr := GetCombinedNamePSandSM(psEngineParam);
  j := FIPCMonitorList.IndexOf(LStr);

  if j <> -1 then
  begin
    FillChar(TIPCMonitor<TEventData_EngineParam>(FIPCMonitorList.Objects[j]).FEventDataRecord, Sizeof(TIPCMonitor<TEventData_EngineParam>(FIPCMonitorList.Objects[j]).FEventDataRecord), 0);

    if not g_CommDisconnected then
      g_CommDisconnected := True;
  end;
//  FillChar(FEngineParamData, Sizeof(FEngineParamData), 0);
//
//  if not FCommDisconnected then
//    FCommDisconnected := True;
end;

procedure TFrameIPCMonitorAll.OnSetZeroFlowMeter(Sender: TObject; Handle: Integer;
  Interval: Cardinal; ElapsedTime: Integer);
var
  j: integer;
  LStr: string;
begin
  LStr := GetCombinedNamePSandSM(psFlowMeter);
  j := FIPCMonitorList.IndexOf(LStr);

  if j <> -1 then
  begin
    FillChar(TIPCMonitor<TEventData_FlowMeter>(FIPCMonitorList.Objects[j]).FEventDataRecord, Sizeof(TIPCMonitor<TEventData_FlowMeter>(FIPCMonitorList.Objects[j]).FEventDataRecord), 0);

    if not g_CommDisconnected then
      g_CommDisconnected := True;
  end;
//  FillChar(FFlowMeterData, Sizeof(FFlowMeterData), 0);
//
//  if not FCommDisconnected then
//    FCommDisconnected := True;
end;

procedure TFrameIPCMonitorAll.OnSetZeroGasCalc(Sender: TObject; Handle: Integer;
  Interval: Cardinal; ElapsedTime: Integer);
var
  j: integer;
  LStr: string;
begin
  LStr := GetCombinedNamePSandSM(psGasCalculated);
  j := FIPCMonitorList.IndexOf(LStr);

  if j <> -1 then
  begin
    FillChar(TIPCMonitor<TEventData_GasCalc>(FIPCMonitorList.Objects[j]).FEventDataRecord, Sizeof(TIPCMonitor<TEventData_GasCalc>(FIPCMonitorList.Objects[j]).FEventDataRecord), 0);

    if not g_CommDisconnected then
      g_CommDisconnected := True;
  end;
//  FillChar(FGasCalcData, Sizeof(FGasCalcData), 0);
//
//  if not FCommDisconnected then
//    FCommDisconnected := True;
end;

procedure TFrameIPCMonitorAll.OnSetZeroHIC(Sender: TObject; Handle: Integer;
  Interval: Cardinal; ElapsedTime: Integer);
var
  j: integer;
  LStr: string;
begin
  LStr := GetCombinedNamePSandSM(psHIC);
  j := FIPCMonitorList.IndexOf(LStr);

  if j <> -1 then
  begin
    FillChar(TIPCMonitor<TEventData_HIC>(FIPCMonitorList.Objects[j]).FEventDataRecord, Sizeof(TIPCMonitor<TEventData_HIC>(FIPCMonitorList.Objects[j]).FEventDataRecord), 0);

    if not g_CommDisconnected then
      g_CommDisconnected := True;
  end;
//  FillChar(FHICData, Sizeof(FHICData), 0);
//
//  if not FCommDisconnected then
//    FCommDisconnected := True;
end;

procedure TFrameIPCMonitorAll.OnSetZeroKRAL(Sender: TObject; Handle: Integer;
  Interval: Cardinal; ElapsedTime: Integer);
var
  j: integer;
  LStr: string;
begin
  LStr := GetCombinedNamePSandSM(psFlowMeterKral);
  j := FIPCMonitorList.IndexOf(LStr);

  if j <> -1 then
  begin
    FillChar(TIPCMonitor<TEventData_Modbus_Standard>(FIPCMonitorList.Objects[j]).FEventDataRecord, Sizeof(TIPCMonitor<TEventData_Modbus_Standard>(FIPCMonitorList.Objects[j]).FEventDataRecord), 0);

    if not g_CommDisconnected then
      g_CommDisconnected := True;
  end;
//  FillChar(FKRALData, Sizeof(FKRALData), 0);
//
//  if not FCommDisconnected then
//    FCommDisconnected := True;
end;

procedure TFrameIPCMonitorAll.OnSetZeroLBX(Sender: TObject; Handle: Integer;
  Interval: Cardinal; ElapsedTime: Integer);
var
  j: integer;
  LStr: string;
begin
  LStr := GetCombinedNamePSandSM(psLBX);
  j := FIPCMonitorList.IndexOf(LStr);

  if j <> -1 then
  begin
    FillChar(TIPCMonitor<TEventData_LBX>(FIPCMonitorList.Objects[j]).FEventDataRecord, Sizeof(TIPCMonitor<TEventData_LBX>(FIPCMonitorList.Objects[j]).FEventDataRecord), 0);

    if not g_CommDisconnected then
      g_CommDisconnected := True;
  end;
//  FillChar(FLBXData, Sizeof(FLBXData), 0);
//
//  if not FCommDisconnected then
//    FCommDisconnected := True;
end;

procedure TFrameIPCMonitorAll.OnSetZeroMEXA7000(Sender: TObject; Handle: Integer;
  Interval: Cardinal; ElapsedTime: Integer);
var
  j: integer;
  LStr: string;
begin
  LStr := GetCombinedNamePSandSM(psMEXA7000);
  j := FIPCMonitorList.IndexOf(LStr);

  if j <> -1 then
  begin
    FillChar(TIPCMonitor<TEventData_MEXA7000>(FIPCMonitorList.Objects[j]).FEventDataRecord, Sizeof(TIPCMonitor<TEventData_MEXA7000>(FIPCMonitorList.Objects[j]).FEventDataRecord), 0);

    if not g_CommDisconnected then
      g_CommDisconnected := True;
  end;
//  FillChar(FMEXA7000Data, Sizeof(FMEXA7000Data), 0);
//
//  if not FCommDisconnected then
//    FCommDisconnected := True;
end;

procedure TFrameIPCMonitorAll.OnSetZeroMT210(Sender: TObject; Handle: Integer;
  Interval: Cardinal; ElapsedTime: Integer);
var
  j: integer;
  LStr: string;
begin
  LStr := GetCombinedNamePSandSM(psMT210);
  j := FIPCMonitorList.IndexOf(LStr);

  if j <> -1 then
  begin
    FillChar(TIPCMonitor<TEventData_MT210>(FIPCMonitorList.Objects[j]).FEventDataRecord, Sizeof(TIPCMonitor<TEventData_MT210>(FIPCMonitorList.Objects[j]).FEventDataRecord), 0);

    if not g_CommDisconnected then
      g_CommDisconnected := True;
  end;
//  FillChar(FMT210Data, Sizeof(FMT210Data), 0);
//
//  if not FCommDisconnected then
//    FCommDisconnected := True;
end;

procedure TFrameIPCMonitorAll.OnSetZeroPLCMODBUS(Sender: TObject;
  Handle: Integer; Interval: Cardinal; ElapsedTime: Integer);
var
  j: integer;
  LStr: string;
begin
  LStr := GetCombinedNamePSandSM(psPLC_Modbus);
  j := FIPCMonitorList.IndexOf(LStr);

  if j <> -1 then
  begin
    FillChar(TIPCMonitor<TEventData_Modbus_Standard>(FIPCMonitorList.Objects[j]).FEventDataRecord, Sizeof(TIPCMonitor<TEventData_Modbus_Standard>(FIPCMonitorList.Objects[j]).FEventDataRecord), 0);

    if not g_CommDisconnected then
      g_CommDisconnected := True;
  end;
//  FillChar(FPLCModbusData, Sizeof(FPLCModbusData), 0);
//
//  if not FCommDisconnected then
//    FCommDisconnected := True;
end;

procedure TFrameIPCMonitorAll.OnSetZeroPLC_S7(Sender: TObject; Handle: Integer;
  Interval: Cardinal; ElapsedTime: Integer);
var
  j: integer;
  LStr: string;
begin
  LStr := GetCombinedNamePSandSM(psPLC_S7);
  j := FIPCMonitorList.IndexOf(LStr);

  if j <> -1 then
  begin
    FillChar(TIPCMonitor<TEventData_PLC_S7>(FIPCMonitorList.Objects[j]).FEventDataRecord, Sizeof(TIPCMonitor<TEventData_PLC_S7>(FIPCMonitorList.Objects[j]).FEventDataRecord), 0);

    if not g_CommDisconnected then
      g_CommDisconnected := True;
  end;
//  FillChar(FPLCData_S7, Sizeof(FPLCData_S7), 0);
//
//  if not FCommDisconnected then
//    FCommDisconnected := True;
end;

procedure TFrameIPCMonitorAll.OnSetZeroPMS(Sender: TObject; Handle: Integer;
  Interval: Cardinal; ElapsedTime: Integer);
var
  j: integer;
  LStr: string;
begin
  LStr := GetCombinedNamePSandSM(psPMSOPC);
  j := FIPCMonitorList.IndexOf(LStr);

  if j <> -1 then
  begin
    FillChar(TIPCMonitor<TEventData_PMS>(FIPCMonitorList.Objects[j]).FEventDataRecord, Sizeof(TIPCMonitor<TEventData_PMS>(FIPCMonitorList.Objects[j]).FEventDataRecord), 0);

    if not g_CommDisconnected then
      g_CommDisconnected := True;
  end;
//  FillChar(FPMSData, Sizeof(FPMSData), 0);
//
//  if not FCommDisconnected then
//    FCommDisconnected := True;
end;

procedure TFrameIPCMonitorAll.OnSetZeroWT1600(Sender: TObject; Handle: Integer;
  Interval: Cardinal; ElapsedTime: Integer);
var
  j: integer;
  LStr: string;
begin
  LStr := GetCombinedNamePSandSM(psWT1600);
  j := FIPCMonitorList.IndexOf(LStr);

  if j <> -1 then
  begin
    FillChar(TIPCMonitor<TEventData_WT1600>(FIPCMonitorList.Objects[j]).FEventDataRecord, Sizeof(TIPCMonitor<TEventData_WT1600>(FIPCMonitorList.Objects[j]).FEventDataRecord), 0);

    if not g_CommDisconnected then
      g_CommDisconnected := True;
  end;
//  FillChar(FWT1600Data, Sizeof(FWT1600Data), 0);
//
//  if not FCommDisconnected then
//    FCommDisconnected := True;
//
//  {$IFDEF USECODESITE}
//  CodeSite.EnterMethod('OnSetZeroWT1600');
//  try
//    CodeSite.Send('FillChar(FWT1600Data, Sizeof(FWT1600Data), 0)');
//  {$ENDIF}
//  {$IFDEF USECODESITE}
//  finally
//    CodeSite.ExitMethod('OnSetZeroWT1600');
//  end;
//  {$ENDIF}
end;

procedure TFrameIPCMonitorAll.PulseEventSimulate(AIndex: integer);
begin
  TIPCObject<TEventData_Modbus_Standard>(TIPCMonitor<TEventData_Modbus_Standard>(TIPCMonitorClass(FIPCMonitorList.Objects[AIndex]).FIPCObject).FIPCObject).FMonitorEvent.Pulse;
end;

//procedure TFrameIPCMonitorAll.OverRide_DYNAMO(AIndex: integer);
//var
//  i, LRadix: integer;
//  LDataOk: Boolean;
//  LDYNAMOData: TEventData_DYNAMO;
//begin
//  LDYNAMOData := TEventData_DYNAMO(TIPCMonitor<TEventData_DYNAMO>(FIPCMonitorList.Objects[AIndex]).FEventDataRecord);
//
//  for i := 0 to FEngineParameter.EngineParameterCollect.Count - 1 do
//  begin
//    if FEngineParameter.EngineParameterCollect.Items[i].ParameterSource = psDynamo then
//    begin
////      LRadix := FEngineParameter.EngineParameterCollect.Items[i].RadixPosition;
//
//      if UpperCase(FEngineParameter.EngineParameterCollect.Items[i].TagName) = UpperCase('Power') then
//        FEngineParameter.EngineParameterCollect.Items[i].Value := FormatFloat(FEngineParameter.EngineParameterCollect.Items[i].DisplayFormat, LDYNAMOData.FPower) // FloatToStrF(FDYNAMOData.FPower, ffFixed, 12, LRadix)
//      else if UpperCase(FEngineParameter.EngineParameterCollect.Items[i].TagName) = UpperCase('Torque') then
//        FEngineParameter.EngineParameterCollect.Items[i].Value := FormatFloat(FEngineParameter.EngineParameterCollect.Items[i].DisplayFormat, LDYNAMOData.FTorque) //FloatToStrF(FDYNAMOData.FTorque, ffFixed, 12, LRadix)
//      else if UpperCase(FEngineParameter.EngineParameterCollect.Items[i].TagName) = UpperCase('RPM') then
//        FEngineParameter.EngineParameterCollect.Items[i].Value := FormatFloat(FEngineParameter.EngineParameterCollect.Items[i].DisplayFormat, LDYNAMOData.FRevolution) //FloatToStrF(FDYNAMOData.FRevolution, ffFixed, 12, LRadix)
//      else if UpperCase(FEngineParameter.EngineParameterCollect.Items[i].TagName) = UpperCase('BRG_TB') then
//        FEngineParameter.EngineParameterCollect.Items[i].Value := FormatFloat(FEngineParameter.EngineParameterCollect.Items[i].DisplayFormat, LDYNAMOData.FBrgTBTemp) //FloatToStrF(FDYNAMOData.FBrgTBTemp, ffFixed, 12, LRadix)
//      else if UpperCase(FEngineParameter.EngineParameterCollect.Items[i].TagName) = UpperCase('BRG_MTR') then
//        FEngineParameter.EngineParameterCollect.Items[i].Value := FormatFloat(FEngineParameter.EngineParameterCollect.Items[i].DisplayFormat, LDYNAMOData.FBrgMTRTemp) //FloatToStrF(FDYNAMOData.FBrgMTRTemp, ffFixed, 12, LRadix)
//      else if UpperCase(FEngineParameter.EngineParameterCollect.Items[i].TagName) = UpperCase('Inlet1') then
//        FEngineParameter.EngineParameterCollect.Items[i].Value := FormatFloat(FEngineParameter.EngineParameterCollect.Items[i].DisplayFormat, LDYNAMOData.FInletOpen1) //FloatToStrF(FDYNAMOData.FInletOpen1, ffFixed, 12, LRadix)
//      else if UpperCase(FEngineParameter.EngineParameterCollect.Items[i].TagName) = UpperCase('Inlet2') then
//        FEngineParameter.EngineParameterCollect.Items[i].Value := FormatFloat(FEngineParameter.EngineParameterCollect.Items[i].DisplayFormat, LDYNAMOData.FInletOpen2) //FloatToStrF(FDYNAMOData.FInletOpen2, ffFixed, 12, LRadix)
//      else if UpperCase(FEngineParameter.EngineParameterCollect.Items[i].TagName) = UpperCase('Outlet1') then
//        FEngineParameter.EngineParameterCollect.Items[i].Value := FormatFloat(FEngineParameter.EngineParameterCollect.Items[i].DisplayFormat, LDYNAMOData.FOutletOpen1) //FloatToStrF(FDYNAMOData.FOutletOpen1, ffFixed, 12, LRadix)
//      else if UpperCase(FEngineParameter.EngineParameterCollect.Items[i].TagName) = UpperCase('Outlet2') then
//        FEngineParameter.EngineParameterCollect.Items[i].Value := FormatFloat(FEngineParameter.EngineParameterCollect.Items[i].DisplayFormat, LDYNAMOData.FOutletOpen2) //FloatToStrF(FDYNAMOData.FOutletOpen2, ffFixed, 12, LRadix)
//      else if UpperCase(FEngineParameter.EngineParameterCollect.Items[i].TagName) = UpperCase('WaterInlet') then
//        FEngineParameter.EngineParameterCollect.Items[i].Value := FormatFloat(FEngineParameter.EngineParameterCollect.Items[i].DisplayFormat, LDYNAMOData.FWaterInletTemp) //FloatToStrF(FDYNAMOData.FWaterInletTemp, ffFixed, 12, LRadix)
//      else if UpperCase(FEngineParameter.EngineParameterCollect.Items[i].TagName) = UpperCase('WaterOutlet') then
//        FEngineParameter.EngineParameterCollect.Items[i].Value := FormatFloat(FEngineParameter.EngineParameterCollect.Items[i].DisplayFormat, LDYNAMOData.FWaterOutletTemp) //FloatToStrF(FDYNAMOData.FWaterOutletTemp, ffFixed, 12, LRadix)
//      else if UpperCase(FEngineParameter.EngineParameterCollect.Items[i].TagName) = UpperCase('Body1') then
//        FEngineParameter.EngineParameterCollect.Items[i].Value := FormatFloat(FEngineParameter.EngineParameterCollect.Items[i].DisplayFormat, LDYNAMOData.FBody1Press) //FloatToStrF(FDYNAMOData.FBody1Press, ffFixed, 12, LRadix)
//      else if UpperCase(FEngineParameter.EngineParameterCollect.Items[i].TagName) = UpperCase('Body2') then
//        FEngineParameter.EngineParameterCollect.Items[i].Value := FormatFloat(FEngineParameter.EngineParameterCollect.Items[i].DisplayFormat, LDYNAMOData.FBody2Press) //FloatToStrF(FDYNAMOData.FBody2Press, ffFixed, 12, LRadix)
//      else if UpperCase(FEngineParameter.EngineParameterCollect.Items[i].TagName) = UpperCase('WaterSupply') then
//        FEngineParameter.EngineParameterCollect.Items[i].Value := FormatFloat(FEngineParameter.EngineParameterCollect.Items[i].DisplayFormat, LDYNAMOData.FWaterSupply) //FloatToStrF(FDYNAMOData.FWaterSupply, ffFixed, 12, LRadix)
//      else if UpperCase(FEngineParameter.EngineParameterCollect.Items[i].TagName) = UpperCase('OilPress') then
//        FEngineParameter.EngineParameterCollect.Items[i].Value := FormatFloat(FEngineParameter.EngineParameterCollect.Items[i].DisplayFormat, LDYNAMOData.FOilPress); //FloatToStrF(FDYNAMOData.FOilPress, ffFixed, 12, LRadix);
//
//      WatchValue2Screen_Analog('', '',i);
//      LDataOk := True;
//    end;
//  end;
//  //상속 받은 자손에서 구현할 것
//  {if LDataOk then
//  begin
//    Timer1.Enabled := True;
//    FPJHTimerPool.AddOneShot(OnTrigger4AvgSave,2000);
//    DataSaveByEvent;
//  end;
//  }
//end;

//procedure TFrameIPCMonitorAll.OverRide_ECS_AVAT(AIndex: integer);
//var
//  it: DIterator;
//  pHiMap: THiMap;
//  i, j, k, BlockNo: integer;
//  tmpStr: string;
//  tmpByte, ProcessBitCnt: Byte;
//  LDataOk: Boolean;
//  FECSData_AVAT: TEventData_ECS_AVAT;
//begin
//  FECSData_AVAT := TEventData_ECS_AVAT(TIPCMonitor<TEventData_ECS_AVAT>(FIPCMonitorList.Objects[AIndex]).FEventDataRecord);
//
//  BlockNo := 0;
//  i := 0;
//  j := 0;
//  ProcessBitCnt := 0;
//  LDataOk := True;
//
//    if (FECSData_AVAT.ModBusFunctionCode = 3) or (FECSData_AVAT.ModBusFunctionCode = 4) then
//    begin
//      for k := 0 to FEngineParameter.EngineParameterCollect.Count - 1 do
//      begin
//        if FEngineParameter.EngineParameterCollect.Items[k].ParameterSource = psECS_AVAT then
//        begin
//          tmpStr := IntToStr(FECSData_AVAT.ModBusFunctionCode) +
//                      FEngineParameter.EngineParameterCollect.Items[k].Address;
//          it := FAddressMap.locate( [tmpStr] );
//          SetToValue(it);
//
//          while not atEnd(it) do
//          begin
//            if i > FECSData_AVAT.NumOfData - 1 then
//              break;
//
//            pHiMap := GetObject(it) as THiMap;
//
//            if (IntToStr(FECSData_Avat.ModBusFunctionCode) = FEngineParameter.EngineParameterCollect.Items[k].FCode) and
//                      (pHiMap.FAddress = FEngineParameter.EngineParameterCollect.Items[k].Address) then
//            begin
//              if (FECSData_AVAT.ModBusMode <> 3) and (FECSData_AVAT.BlockNo <> pHiMap.FBlockNo) then
//                break;
//
//              if FECSData_AVAT.ModBusMode = 3 then //pHiMap에는 dummy가 존재함
//              begin
//                if pHiMap.FListIndexNoDummy <> -1 then
//                  pHiMap.FValue := FECSData_AVAT.InpDataBuf_double[pHiMap.FListIndexNoDummy];
//              end
//              else
//                pHiMap.FValue := FECSData_AVAT.InpDataBuf[pHiMap.FListIndex];
//              //수신된 데이타를 화면에 뿌려줌
//              Value2Screen_ECS_AVAT(pHiMap,k, FECSData_AVAT.ModBusMode);
//              break;
//            end;
//
//            Inc(i);
//            Advance(it);
//            LDataOk := True;
//          end;//while
//        end;
//      end;//for
//    end
//    //======================================
//    else
//    begin
//      BlockNo := pHiMap.FBlockNo;
//      for i := 0 to FECSData_AVAT.NumOfData - 1 do
//      begin
//        tmpByte := Hi(FECSData_AVAT.InpDataBuf[i]);
//        for j := 0 to 7 do
//        begin
//          pHiMap := GetObject(it) as THiMap;
//          if not atEnd(it) then
//          begin
//            pHiMap.FValue := GetBitVal(tmpByte, j);
//            Inc(ProcessBitCnt);
//            Advance(it);
//          end;
//        end;
//
//        tmpByte := Lo(FECSData_AVAT.InpDataBuf[i]);
//        for j := 0 to 7 do
//        begin
//          pHiMap := GetObject(it) as THiMap;
//          if not atEnd(it) then
//          begin
//            pHiMap.FValue := GetBitVal(tmpByte, j);
//            Inc(ProcessBitCnt);
//            Advance(it);
//          end;
//        end;
//      end;
//
//      if ((FECSData_AVAT.NumOfBit div 8) mod 2) > 0 then
//      begin
//        tmpByte := Lo(FECSData_AVAT.InpDataBuf[i]);
//        for j := 0 to 7 do
//        begin
//          pHiMap := GetObject(it) as THiMap;
//          if not atEnd(it) then
//          begin
//            pHiMap.FValue := GetBitVal(tmpByte, j);
//            Inc(ProcessBitCnt);
//            Advance(it);
//          end;
//        end;
//      end;
//
//      for k := 0 to FEngineParameter.EngineParameterCollect.Count - 1 do
//      begin
//        if FEngineParameter.EngineParameterCollect.Items[k].ParameterSource = psECS_AVAT then
//        begin
//          if (IntToStr(FECSData_AVAT.ModBusFunctionCode) = FEngineParameter.EngineParameterCollect.Items[k].FCode) and
//                    (pHiMap.FAddress = FEngineParameter.EngineParameterCollect.Items[k].Address) then
//          begin
//            //수신된 데이타를 화면에 뿌려줌
//            Value2Screen_ECS_AVAT(pHiMap, k, FECSData_AVAT.ModBusMode);
//            break;
//          end;
//        end;
//      end;
//    end;//else
//
//  //상속 받은 자손에서 구현할 것
//  {if LDataOk then
//  begin
//    Timer1.Enabled := True;
//    FPJHTimerPool.AddOneShot(OnTrigger4AvgSave,2000);
//    DataSaveByEvent;
//  end;
//  }
//
//  DisplayMessage2SB(FStatusBar, FECSData_AVAT.ModBusAddress + ' 처리중...');
//end;

//procedure TFrameIPCMonitorAll.OverRide_ECS_ComAP(
//  AIndex: integer);
//var
//  i,j,k: integer;
//  Le: double;
//  LRadix: integer;
//  LECSData_ComAP: TEventData_Modbus_Standard;
//begin
//  LECSData_ComAP := TEventData_Modbus_Standard(TIPCMonitor<TEventData_Modbus_Standard>(FIPCMonitorList.Objects[AIndex]).FEventDataRecord);
//
//  if (LECSData_ComAP.ModBusFunctionCode = 1) or (LECSData_ComAP.ModBusFunctionCode = 2)
//    or (LECSData_ComAP.ModBusFunctionCode = 3) or (LECSData_ComAP.ModBusFunctionCode = 4) then
//  begin
//    for k := 0 to FEngineParameter.EngineParameterCollect.Count - 1 do
//    begin
//      if FEngineParameter.EngineParameterCollect.Items[k].ParameterSource = psECS_ComAP then
//      begin
//        if LECSData_ComAP.BlockNo <> FEngineParameter.EngineParameterCollect.Items[k].BlockNo then
//          Continue;
//
//        //AbsoluteIndex에 Modbus Map에서 각 Request별 위치 정보(공유메모리상의 Index)
//        i := FEngineParameter.EngineParameterCollect.Items[k].AbsoluteIndex;
//
//        if FEngineParameter.EngineParameterCollect.Items[k].Alarm then //Analog data
//        begin
//          if LECSData_ComAP.ModBusMode = 3 then //simulate from csv
//          begin
//            Le := LECSData_ComAP.InpDataBuf_double[i];
//          end
//          else
//          begin
//            case FEngineParameter.EngineParameterCollect.Items[k].MinMaxType of
//              mmtInteger: begin
//                if FEngineParameter.EngineParameterCollect.Items[k].MaxValue > 0 then
//                  Le := LECSData_ComAP.InpDataBuf[i]/FEngineParameter.EngineParameterCollect.Items[k].MaxValue
//                else
//                  Le := LECSData_ComAP.InpDataBuf[i];
//              end;
//              mmtReal: begin
//                if FEngineParameter.EngineParameterCollect.Items[k].MaxValue_Real > 0.0 then
//                  Le := LECSData_ComAP.InpDataBuf[i]/FEngineParameter.EngineParameterCollect.Items[k].MaxValue_Real
//                else
//                  Le := LECSData_ComAP.InpDataBuf[i];
//              end;
//            end;//case
//          end;
//
////          LRadix := FEngineParameter.EngineParameterCollect.Items[k].RadixPosition;
//
//          FEngineParameter.EngineParameterCollect.Items[k].Value := FormatFloat(FEngineParameter.EngineParameterCollect.Items[k].DisplayFormat, Le);
////          FEngineParameter.EngineParameterCollect.Items[k].Value := FloatToStrF(Le, ffFixed, 12, LRadix);//,'%.2f');
//        end
//        else //Digital data
//        begin
//          i := FEngineParameter.EngineParameterCollect.Items[k].AbsoluteIndex;
//
//          j := FEngineParameter.EngineParameterCollect.Items[k].RadixPosition;
//          //0이 아니면 True임
//          FEngineParameter.EngineParameterCollect.Items[k].Value := IntToStr(GetBitVal(LECSData_ComAP.InpDataBuf[i], j));
//        end;
//
//                  //수신된 데이타를 화면에 뿌려줌
//        Value2Screen_ECS_Woodward(k,LECSData_ComAP.ModBusMode);
//      end;
//    end;//for
//  end;
//end;

//procedure TFrameIPCMonitorAll.OverRide_ECS_kumo(AIndex: integer);
//var
//  it: DIterator;
//  pHiMap: THiMap;
//  i, j, k, BlockNo: integer;
//  tmpStr: string;
//  tmpByte, ProcessBitCnt: Byte;
//  LDataOk: Boolean;
//  FECSData_kumo: TEventData_ECS_kumo;
//begin
//  FECSData_kumo := TEventData_ECS_kumo(TIPCMonitor<TEventData_ECS_kumo>(FIPCMonitorList.Objects[AIndex]).FEventDataRecord);
//
//  BlockNo := 0;
//  i := 0;
//  j := 0;
//  ProcessBitCnt := 0;
//  LDataOk := False;
//
//  if FECSData_kumo.ModBusMode = 3 then //RTU mode simulated
//  begin
//    it := FAddressMap.start;
//  end
//  else
//  begin
//    tmpStr := IntToStr(FECSData_kumo.ModBusFunctionCode) + FECSData_kumo.ModBusAddress;
//    it := FAddressMap.locate( [tmpStr] );
//  end;
//
//  SetToValue(it);
//
//  while not atEnd(it) do
//  begin
//    if i > FECSData_kumo.NumOfData - 1 then
//      break;
//
//    pHiMap := GetObject(it) as THiMap;
//
//    if (FECSData_kumo.ModBusFunctionCode = 3) or (FECSData_kumo.ModBusFunctionCode = 4) then
//    begin
//      //BlockNo := pHiMap.FBlockNo;
//      for k := 0 to FEngineParameter.EngineParameterCollect.Count - 1 do
//      begin
//        if FEngineParameter.EngineParameterCollect.Items[k].ParameterSource = psECS_kumo then
//        begin
//          if (IntToStr(FECSData_kumo.ModBusFunctionCode) = FEngineParameter.EngineParameterCollect.Items[k].FCode) and
//                    (pHiMap.FAddress = FEngineParameter.EngineParameterCollect.Items[k].Address) then
//          begin
//            if FECSData_kumo.ModBusMode = 3 then
//              pHiMap.FValue := FECSData_kumo.InpDataBuf_double[i]
//            else
//              pHiMap.FValue := FECSData_kumo.InpDataBuf[i];
//            //수신된 데이타를 화면에 뿌려줌
//            Value2Screen_ECS_kumo(pHiMap,k,FECSData_kumo.ModBusMode);
//            break;
//          end;
//
//          LDataOk := True;
//        end;
//      end;//for
//
//      Inc(i);
//      Advance(it);
//    end;
//  end;//while
//
//  //상속 받은 자손에서 구현할 것
//  {if LDataOk then
//  begin
//    Timer1.Enabled := True;
//    FPJHTimerPool.AddOneShot(OnTrigger4AvgSave,2000);
//    DataSaveByEvent;
//  end;
//  }
//  DisplayMessage2SB(FStatusBar, FECSData_kumo.ModBusAddress + ' 처리중...');
//end;

//procedure TFrameIPCMonitorAll.OverRide_ECS_kumo2(AIndex: integer);
//var
//  i,k: integer;
//  Le: double;
//  LRadix: integer;
//  FECSData_kumo: TEventData_ECS_kumo;
//begin
//  FECSData_kumo := TEventData_ECS_kumo(TIPCMonitor<TEventData_ECS_kumo>(FIPCMonitorList.Objects[AIndex]).FEventDataRecord);
//
//  if (FECSData_kumo.ModBusFunctionCode = 3) or (FECSData_kumo.ModBusFunctionCode = 4) then
//  begin
//    for k := 0 to FEngineParameter.EngineParameterCollect.Count - 1 do
//    begin
//      if FEngineParameter.EngineParameterCollect.Items[k].ParameterSource = psECS_kumo then
//      begin
//        if FECSData_kumo.BlockNo <> FEngineParameter.EngineParameterCollect.Items[k].BlockNo then
//          Continue;
//
//        i := FEngineParameter.EngineParameterCollect.Items[k].AbsoluteIndex;
//
//        if FEngineParameter.EngineParameterCollect.Items[k].Alarm then //Analog data
//        begin
//          if FECSData_kumo.ModBusMode = 3 then
//          begin
//            Le := FECSData_kumo.InpDataBuf_double[i];
//          end
//          else
//          begin
//            Le := FECSData_kumo.InpDataBuf[i];
//            Le := (Le * FEngineParameter.EngineParameterCollect.Items[k].MaxValue) / 4095;
//          end;
//
////          LRadix := FEngineParameter.EngineParameterCollect.Items[k].RadixPosition;
//
//          FEngineParameter.EngineParameterCollect.Items[k].Value := FormatFloat(FEngineParameter.EngineParameterCollect.Items[i].DisplayFormat,Le);
////          FEngineParameter.EngineParameterCollect.Items[k].Value := FloatToStrF(Le, ffFixed, 12, LRadix);//,'%.2f');
//        end;
//
//        //수신된 데이타를 화면에 뿌려줌
//        Value2Screen_ECS_kumo2(k,FECSData_kumo.ModBusMode);
//      end;
//    end;//for
//  end;
//end;

//procedure TFrameIPCMonitorAll.OverRide_ECS_Woodward(
//  AIndex: integer);
//var
//  i,k: integer;
//  Le: double;
//  LRadix: integer;
//  FECSData_Woodward: TEventData_ECS_Woodward;
//begin
//  FECSData_Woodward := TEventData_ECS_Woodward(TIPCMonitor<TEventData_ECS_Woodward>(FIPCMonitorList.Objects[AIndex]).FEventDataRecord);
//
//  if (FECSData_Woodward.ModBusFunctionCode = 1) or (FECSData_Woodward.ModBusFunctionCode = 2)
//    or (FECSData_Woodward.ModBusFunctionCode = 3) or (FECSData_Woodward.ModBusFunctionCode = 4) then
//  begin
//    for k := 0 to FEngineParameter.EngineParameterCollect.Count - 1 do
//    begin
//      if FEngineParameter.EngineParameterCollect.Items[k].ParameterSource = psECS_Woodward then
//      begin
//        if FECSData_Woodward.BlockNo <> FEngineParameter.EngineParameterCollect.Items[k].BlockNo then
//          Continue;
//
//        //AbsoluteIndex에 Modbus Map에서 각 Request별 위치 정보(공유메모리상의 Index)
//        i := FEngineParameter.EngineParameterCollect.Items[k].AbsoluteIndex;
//
//        if FEngineParameter.EngineParameterCollect.Items[k].Alarm then //Analog data
//        begin
//          if FECSData_Woodward.ModBusMode = 3 then
//          begin
//            Le := FECSData_Woodward.InpDataBuf_double[i];
//          end
//          else
//          begin
//            case FEngineParameter.EngineParameterCollect.Items[k].MinMaxType of
//              mmtInteger: begin
//                if FEngineParameter.EngineParameterCollect.Items[k].MaxValue > 0 then
//                  Le := FECSData_Woodward.InpDataBuf[i]/FEngineParameter.EngineParameterCollect.Items[k].MaxValue
//                else
//                  Le := FECSData_Woodward.InpDataBuf[i];
//              end;
//              mmtReal: begin
//                if FEngineParameter.EngineParameterCollect.Items[k].MaxValue_Real > 0.0 then
//                  Le := FECSData_Woodward.InpDataBuf[i]/FEngineParameter.EngineParameterCollect.Items[k].MaxValue_Real
//                else
//                  Le := FECSData_Woodward.InpDataBuf[i];
//              end;
//            end;//case
//          end;
//
////          LRadix := FEngineParameter.EngineParameterCollect.Items[k].RadixPosition;
//
//          FEngineParameter.EngineParameterCollect.Items[k].Value := FormatFloat(FEngineParameter.EngineParameterCollect.Items[i].DisplayFormat,Le);
////          FEngineParameter.EngineParameterCollect.Items[k].Value := FloatToStrF(Le, ffFixed, 12, LRadix);//,'%.2f');
//        end
//        else //Digital data
//        begin
//          if FECSData_Woodward.InpDataBuf[i] = $FFFF then //True value
//            FEngineParameter.EngineParameterCollect.Items[k].Value := 'True'
//          else
//            FEngineParameter.EngineParameterCollect.Items[k].Value := 'False';
//        end;
//
//        //수신된 데이타를 화면에 뿌려줌
//        Value2Screen_ECS_Woodward(k,FECSData_Woodward.ModBusMode);
//      end;
//    end;//for
//  end;
//end;

//procedure TFrameIPCMonitorAll.OverRide_EngineParam(
//  AIndex: integer);
//var
//  i: integer;
//  LDataOk: boolean;
//  FEngineParamData: TEventData_EngineParam;
//begin
//  FEngineParamData := TEventData_EngineParam(TIPCMonitor<TEventData_EngineParam>(FIPCMonitorList.Objects[AIndex]).FEventDataRecord);
//
//  LDataOk := False;
//
//  for i := 0 to FEngineParameter.EngineParameterCollect.Count - 1 do
//  begin
//    if FEngineParameter.EngineParameterCollect.Items[i].ParameterSource = psEngineParam then
//    begin
//      FEngineParameter.EngineParameterCollect.Items[i].Value := FEngineParamData.FData[i];
//
//      WatchValue2Screen_Analog('', '',i);
//      LDataOk := True;
//    end;
//  end;//for
//
//  //상속 받은 자손에서 구현할 것
//  {if LDataOk then
//  begin
//    Timer1.Enabled := True;
//    FPJHTimerPool.AddOneShot(OnTrigger4AvgSave,2000);
//    DataSaveByEvent;
//  end;
//  }
//end;

//procedure TFrameIPCMonitorAll.OverRide_FlowMeter(AIndex: integer);
//var
//  LDataOk: Boolean;
//begin
  //상속 받은 자손에서 구현할 것
  {if LDataOk then
  begin
    Timer1.Enabled := True;
    FPJHTimerPool.AddOneShot(OnTrigger4AvgSave,2000);
    DataSaveByEvent;
  end;
  }
//end;

//procedure TFrameIPCMonitorAll.OverRide_GasCalc(AIndex: integer);
//var
//  i, LRadix: integer;
//  LDouble: double;
//  LGasCalcData: TEventData_GasCalc;
//begin
//  LGasCalcData := TEventData_GasCalc(TIPCMonitor<TEventData_GasCalc>(FIPCMonitorList.Objects[AIndex]).FEventDataRecord);
//
//  for i := 0 to FEngineParameter.EngineParameterCollect.Count - 1 do
//  begin
//    if FEngineParameter.EngineParameterCollect.Items[i].ParameterSource = psGasCalculated then
//    begin
////      LRadix := FEngineParameter.EngineParameterCollect.Items[i].RadixPosition;
//
//      if UpperCase(FEngineParameter.EngineParameterCollect.Items[i].TagName) = UpperCase('SVP') then
//        FEngineParameter.EngineParameterCollect.Items[i].Value := FormatFloat(FEngineParameter.EngineParameterCollect.Items[i].DisplayFormat,LGasCalcData.FSVP) //FloatToStr(FGasCalcData.FSVP)
//      else if UpperCase(FEngineParameter.EngineParameterCollect.Items[i].TagName) = UpperCase('IAH2') then
//        FEngineParameter.EngineParameterCollect.Items[i].Value := FormatFloat(FEngineParameter.EngineParameterCollect.Items[i].DisplayFormat,LGasCalcData.FIAH2) //FloatToStr(FGasCalcData.FIAH2)
//      else if UpperCase(FEngineParameter.EngineParameterCollect.Items[i].TagName) = UpperCase('UFC') then
//        FEngineParameter.EngineParameterCollect.Items[i].Value := FormatFloat(FEngineParameter.EngineParameterCollect.Items[i].DisplayFormat,LGasCalcData.FUFC) //FloatToStr(FGasCalcData.FUFC)
//      else if UpperCase(FEngineParameter.EngineParameterCollect.Items[i].TagName) = UpperCase('NhtCF') then
//        FEngineParameter.EngineParameterCollect.Items[i].Value := FormatFloat(FEngineParameter.EngineParameterCollect.Items[i].DisplayFormat,LGasCalcData.FNhtCF) //FloatToStr(FGasCalcData.FNhtCF)
//      else if UpperCase(FEngineParameter.EngineParameterCollect.Items[i].TagName) = UpperCase('DWCFE') then
//        FEngineParameter.EngineParameterCollect.Items[i].Value := FormatFloat(FEngineParameter.EngineParameterCollect.Items[i].DisplayFormat,LGasCalcData.FDWCFE) //FloatToStr(FGasCalcData.FDWCFE)
//      else if UpperCase(FEngineParameter.EngineParameterCollect.Items[i].TagName) = UpperCase('EGF') then
//        FEngineParameter.EngineParameterCollect.Items[i].Value := FormatFloat(FEngineParameter.EngineParameterCollect.Items[i].DisplayFormat,LGasCalcData.FEGF) //FloatToStr(FGasCalcData.FEGF)
//      else if UpperCase(FEngineParameter.EngineParameterCollect.Items[i].TagName) = UpperCase('NOxAtO213') then
//        FEngineParameter.EngineParameterCollect.Items[i].Value := FormatFloat(FEngineParameter.EngineParameterCollect.Items[i].DisplayFormat,LGasCalcData.FNOxAtO213) //FloatToStr(FGasCalcData.FNOxAtO213)
//      else if UpperCase(FEngineParameter.EngineParameterCollect.Items[i].TagName) = UpperCase('NOx') then
//        FEngineParameter.EngineParameterCollect.Items[i].Value := FormatFloat(FEngineParameter.EngineParameterCollect.Items[i].DisplayFormat,LGasCalcData.FNOx) //FloatToStr(FGasCalcData.FNOx)
//      else if UpperCase(FEngineParameter.EngineParameterCollect.Items[i].TagName) = UpperCase('AF1') then
//        FEngineParameter.EngineParameterCollect.Items[i].Value := FormatFloat(FEngineParameter.EngineParameterCollect.Items[i].DisplayFormat,LGasCalcData.FAF1) //FloatToStr(FGasCalcData.FAF1)
//      else if UpperCase(FEngineParameter.EngineParameterCollect.Items[i].TagName) = UpperCase('AF2') then
//        FEngineParameter.EngineParameterCollect.Items[i].Value := FormatFloat(FEngineParameter.EngineParameterCollect.Items[i].DisplayFormat,LGasCalcData.FAF2) //FloatToStr(FGasCalcData.FAF2)
//      else if UpperCase(FEngineParameter.EngineParameterCollect.Items[i].TagName) = UpperCase('AF3') then
//        FEngineParameter.EngineParameterCollect.Items[i].Value := FormatFloat(FEngineParameter.EngineParameterCollect.Items[i].DisplayFormat,LGasCalcData.FAF3) //FloatToStr(FGasCalcData.FAF3)
//      else if UpperCase(FEngineParameter.EngineParameterCollect.Items[i].TagName) = UpperCase('AF_Measured') then
//        FEngineParameter.EngineParameterCollect.Items[i].Value := FormatFloat(FEngineParameter.EngineParameterCollect.Items[i].DisplayFormat,LGasCalcData.FAF_Measured) //FloatToStr(FGasCalcData.FAF_Measured)
//      else if UpperCase(FEngineParameter.EngineParameterCollect.Items[i].TagName) = UpperCase('MT210') then
//        FEngineParameter.EngineParameterCollect.Items[i].Value := FormatFloat(FEngineParameter.EngineParameterCollect.Items[i].DisplayFormat,LGasCalcData.FMT210) //FloatToStr(FGasCalcData.FMT210)
//      else if UpperCase(FEngineParameter.EngineParameterCollect.Items[i].TagName) = UpperCase('FC') then
//        FEngineParameter.EngineParameterCollect.Items[i].Value := FormatFloat(FEngineParameter.EngineParameterCollect.Items[i].DisplayFormat,LGasCalcData.FFC) //FloatToStr(FGasCalcData.FFC)
//      else if UpperCase(FEngineParameter.EngineParameterCollect.Items[i].TagName) = UpperCase('EngineOutput') then
//        FEngineParameter.EngineParameterCollect.Items[i].Value := FormatFloat(FEngineParameter.EngineParameterCollect.Items[i].DisplayFormat,LGasCalcData.FEngineOutput) //FloatToStr(FGasCalcData.FEngineOutput)
//      else if UpperCase(FEngineParameter.EngineParameterCollect.Items[i].TagName) = UpperCase('GeneratorOutput') then
//        FEngineParameter.EngineParameterCollect.Items[i].Value := FormatFloat(FEngineParameter.EngineParameterCollect.Items[i].DisplayFormat,LGasCalcData.FGeneratorOutput) //FloatToStr(FGasCalcData.FGeneratorOutput)
//      else if UpperCase(FEngineParameter.EngineParameterCollect.Items[i].TagName) = UpperCase('EngineLoad') then
//        FEngineParameter.EngineParameterCollect.Items[i].Value := FormatFloat(FEngineParameter.EngineParameterCollect.Items[i].DisplayFormat,LGasCalcData.FEngineLoad) //FloatToStr(FGasCalcData.FEngineLoad)
//      else if UpperCase(FEngineParameter.EngineParameterCollect.Items[i].TagName) = UpperCase('GenEfficiency') then
//        FEngineParameter.EngineParameterCollect.Items[i].Value := FormatFloat(FEngineParameter.EngineParameterCollect.Items[i].DisplayFormat,LGasCalcData.FGenEfficiency) //FloatToStr(FGasCalcData.FGenEfficiency)
//      else if UpperCase(FEngineParameter.EngineParameterCollect.Items[i].TagName) = UpperCase('BHP') then
//        FEngineParameter.EngineParameterCollect.Items[i].Value := FormatFloat(FEngineParameter.EngineParameterCollect.Items[i].DisplayFormat,LGasCalcData.FBHP) //FloatToStr(FGasCalcData.FBHP)
//      else if UpperCase(FEngineParameter.EngineParameterCollect.Items[i].TagName) = UpperCase('BMEP') then
//        FEngineParameter.EngineParameterCollect.Items[i].Value := FormatFloat(FEngineParameter.EngineParameterCollect.Items[i].DisplayFormat,LGasCalcData.FBMEP) //FloatToStr(FGasCalcData.FBMEP)
//      else if UpperCase(FEngineParameter.EngineParameterCollect.Items[i].TagName) = UpperCase('Lamda_Calculated') then
//        FEngineParameter.EngineParameterCollect.Items[i].Value := FormatFloat(FEngineParameter.EngineParameterCollect.Items[i].DisplayFormat,LGasCalcData.FLamda_Calculated) //FloatToStr(FGasCalcData.FLamda_Calculated)
//      else if UpperCase(FEngineParameter.EngineParameterCollect.Items[i].TagName) = UpperCase('Lamda_Measured') then
//        FEngineParameter.EngineParameterCollect.Items[i].Value := FormatFloat(FEngineParameter.EngineParameterCollect.Items[i].DisplayFormat,LGasCalcData.FLamda_Measured) //FloatToStr(FGasCalcData.FLamda_Measured)
//      else if UpperCase(FEngineParameter.EngineParameterCollect.Items[i].TagName) = UpperCase('Lamda_Brettschneider') then
//        FEngineParameter.EngineParameterCollect.Items[i].Value := FormatFloat(FEngineParameter.EngineParameterCollect.Items[i].DisplayFormat,LGasCalcData.FLamda_Brettschneider) //FloatToStr(FGasCalcData.FLamda_Brettschneider)
//      else if UpperCase(FEngineParameter.EngineParameterCollect.Items[i].TagName) = UpperCase('AFRatio_Calculated') then
//        FEngineParameter.EngineParameterCollect.Items[i].Value := FormatFloat(FEngineParameter.EngineParameterCollect.Items[i].DisplayFormat,LGasCalcData.FAFRatio_Calculated) //FloatToStr(FGasCalcData.FAFRatio_Calculated)
//      else if UpperCase(FEngineParameter.EngineParameterCollect.Items[i].TagName) = UpperCase('AFRatio_Measured') then
//        FEngineParameter.EngineParameterCollect.Items[i].Value := FormatFloat(FEngineParameter.EngineParameterCollect.Items[i].DisplayFormat,LGasCalcData.FAFRatio_Measured) //FloatToStr(FGasCalcData.FAFRatio_Measured)
//      else if UpperCase(FEngineParameter.EngineParameterCollect.Items[i].TagName) = UpperCase('ExhTempAvg') then
//        FEngineParameter.EngineParameterCollect.Items[i].Value := FormatFloat(FEngineParameter.EngineParameterCollect.Items[i].DisplayFormat,LGasCalcData.FExhTempAvg) //FloatToStr(FGasCalcData.FExhTempAvg)
//      else if UpperCase(FEngineParameter.EngineParameterCollect.Items[i].TagName) = UpperCase('WasteGatePosition') then
//        FEngineParameter.EngineParameterCollect.Items[i].Value := FormatFloat(FEngineParameter.EngineParameterCollect.Items[i].DisplayFormat,LGasCalcData.FWasteGatePosition) //FloatToStr(FGasCalcData.FWasteGatePosition)
//      else if UpperCase(FEngineParameter.EngineParameterCollect.Items[i].TagName) = UpperCase('ThrottlePosition') then
//        FEngineParameter.EngineParameterCollect.Items[i].Value := FormatFloat(FEngineParameter.EngineParameterCollect.Items[i].DisplayFormat,LGasCalcData.FThrottlePosition) //FloatToStr(FGasCalcData.FThrottlePosition)
//      else if UpperCase(FEngineParameter.EngineParameterCollect.Items[i].TagName) = UpperCase('Density') then
//        FEngineParameter.EngineParameterCollect.Items[i].Value := FormatFloat(FEngineParameter.EngineParameterCollect.Items[i].DisplayFormat,LGasCalcData.FDensity) //FloatToStr(FGasCalcData.FDensity)
//      else if UpperCase(FEngineParameter.EngineParameterCollect.Items[i].TagName) = UpperCase('LCV') then
//        FEngineParameter.EngineParameterCollect.Items[i].Value := FormatFloat(FEngineParameter.EngineParameterCollect.Items[i].DisplayFormat,LGasCalcData.FLCV) //FloatToStr(FGasCalcData.FLCV)
//      else if UpperCase(FEngineParameter.EngineParameterCollect.Items[i].TagName) = UpperCase('BoostPress') then
//        FEngineParameter.EngineParameterCollect.Items[i].Value := FormatFloat(FEngineParameter.EngineParameterCollect.Items[i].DisplayFormat,LGasCalcData.FBoostPress); //FloatToStr(FGasCalcData.FBoostPress);
//
//      WatchValue2Screen_Analog('', '',i);
//    end;
//  end;//for
//end;

//procedure TFrameIPCMonitorAll.OverRide_HIC(AIndex: integer);
//var
//  i,k, LValue: integer;
//  Le: double;
//  LRadix: integer;
//  LHICData: TEventData_HIC;
//begin
//  LHICData := TEventData_HIC(TIPCMonitor<TEventData_HIC>(FIPCMonitorList.Objects[AIndex]).FEventDataRecord);
//
//  if (LHICData.ModBusFunctionCode = 3) or (LHICData.ModBusFunctionCode = 4) then
//  begin
//    for k := 0 to FEngineParameter.EngineParameterCollect.Count - 1 do
//    begin
//      if FEngineParameter.EngineParameterCollect.Items[k].ParameterSource = psHIC then
//      begin
//        if LHICData.BlockNo <> FEngineParameter.EngineParameterCollect.Items[k].BlockNo then
//          Continue;
//
//        i := FEngineParameter.EngineParameterCollect.Items[k].AbsoluteIndex;
//
//        if FEngineParameter.EngineParameterCollect.Items[k].Alarm then //Analog data
//        begin
//          if LHICData.ModBusMode = 3 then
//          begin
//            Le := LHICData.InpDataBuf_f[i];
//          end
//          else
//          begin
//            //LValue := ((FKRALData.InpDataBuf[i] shl 16) or FKRALData.InpDataBuf[i+1]);
//            //Le := LValue / 10;
//            Le := LHICData.InpDataBuf[i];
//          end;
//
////          LRadix := FEngineParameter.EngineParameterCollect.Items[k].RadixPosition;
//
//          FEngineParameter.EngineParameterCollect.Items[k].Value := FormatFloat(FEngineParameter.EngineParameterCollect.Items[i].DisplayFormat,Le);
////          FEngineParameter.EngineParameterCollect.Items[k].Value := FloatToStrF(Le, ffFixed, 12, LRadix);//,'%.2f');
//        end;
//
//        //수신된 데이타를 화면에 뿌려줌
//        Value2Screen_ECS_kumo2(k,LHICData.ModBusMode);
//      end;
//    end;//for
//  end;
//end;

//procedure TFrameIPCMonitorAll.OverRide_KRAL(AIndex: integer);
//var
//  i,k, LValue: integer;
//  Le: double;
//  LRadix: integer;
//  LKRALData: TEventData_Modbus_Standard;
//begin
//  LKRALData := TEventData_Modbus_Standard(TIPCMonitor<TEventData_Modbus_Standard>(FIPCMonitorList.Objects[AIndex]).FEventDataRecord);
//
//  if (LKRALData.ModBusFunctionCode = 3) or (LKRALData.ModBusFunctionCode = 4) then
//  begin
//    for k := 0 to FEngineParameter.EngineParameterCollect.Count - 1 do
//    begin
//      if FEngineParameter.EngineParameterCollect.Items[k].ParameterSource = psFlowMeterKral then
//      begin
//        if LKRALData.BlockNo <> FEngineParameter.EngineParameterCollect.Items[k].BlockNo then
//          Continue;
//
//        i := FEngineParameter.EngineParameterCollect.Items[k].AbsoluteIndex;
//
//        if FEngineParameter.EngineParameterCollect.Items[k].Alarm then //Analog data
//        begin
//          if LKRALData.ModBusMode = 3 then
//          begin
//            Le := LKRALData.InpDataBuf_double[i];
//            FEngineParameter.EngineParameterCollect.Items[k].Value := FormatFloat(FEngineParameter.EngineParameterCollect.Items[i].DisplayFormat,Le);
//          end
//          else
//          begin
////            LValue := ((LKRALData.InpDataBuf[i] shl 16) or LKRALData.InpDataBuf[i+1]);
////            Le := LValue / 10;
////            Le := LKRALData.InpDataBuf[i];
//            FEngineParameter.EngineParameterCollect.Items[k].Value := IntToStr(LKRALData.InpDataBuf[i]);//FormatFloat(FEngineParameter.EngineParameterCollect.Items[i].DisplayFormat,Le);
//          end;
//
////          LRadix := FEngineParameter.EngineParameterCollect.Items[k].RadixPosition;
//
////          FEngineParameter.EngineParameterCollect.Items[k].Value := FloatToStrF(Le, ffFixed, 12, LRadix);//,'%.2f');
//        end;
//
//      end;
//    end;//for
//
//    //수신된 데이타를 화면에 뿌려줌
//    Value2Screen_KRAL;
//  end;
//end;

//procedure TFrameIPCMonitorAll.OverRide_LBX(AIndex: integer);
//var
//  i, LRadix: integer;
//  LDouble: double;
//  LDataOk: Boolean;
//  FLBXData: TEventData_LBX;
//begin
//  FLBXData := TEventData_LBX(TIPCMonitor<TEventData_LBX>(FIPCMonitorList.Objects[AIndex]).FEventDataRecord);
//
//  LDataOk := False;
//
//  for i := 0 to FEngineParameter.EngineParameterCollect.Count - 1 do
//  begin
//    if FEngineParameter.EngineParameterCollect.Items[i].ParameterSource = psLBX then
//    begin
////      LRadix := FEngineParameter.EngineParameterCollect.Items[i].RadixPosition;
//
//      if FEngineParameter.EngineParameterCollect.Items[i].TagName = UpperCase('ENGRPM') then
//        FEngineParameter.EngineParameterCollect.Items[i].Value := IntToStr(FLBXData.ENGRPM)
//      else if FEngineParameter.EngineParameterCollect.Items[i].TagName = UpperCase('HTTEMP') then
//        FEngineParameter.EngineParameterCollect.Items[i].Value := IntToStr(FLBXData.HTTEMP)
//      else if FEngineParameter.EngineParameterCollect.Items[i].TagName = UpperCase('LOTEMP') then
//        FEngineParameter.EngineParameterCollect.Items[i].Value := IntToStr(FLBXData.LOTEMP)
//      else if FEngineParameter.EngineParameterCollect.Items[i].TagName = UpperCase('TCRPMA') then
//        FEngineParameter.EngineParameterCollect.Items[i].Value := IntToStr(FLBXData.TCRPMA)
//      else if FEngineParameter.EngineParameterCollect.Items[i].TagName = UpperCase('TCRPMB') then
//        FEngineParameter.EngineParameterCollect.Items[i].Value := IntToStr(FLBXData.TCRPMB)
//      else if FEngineParameter.EngineParameterCollect.Items[i].TagName = UpperCase('TCINLETTEMP') then
//        FEngineParameter.EngineParameterCollect.Items[i].Value := IntToStr(FLBXData.TCINLETTEMP);
//
//      WatchValue2Screen_Analog('', '',i);
//      LDataOk := True;
//    end;
//  end;//for
//
//  //상속 받은 자손에서 구현할 것
//  {if LDataOk then
//  begin
//    Timer1.Enabled := True;
//    FPJHTimerPool.AddOneShot(OnTrigger4AvgSave,2000);
//    DataSaveByEvent;
//  end;
//  }
//end;

//procedure TFrameIPCMonitorAll.OverRide_MEXA7000(AIndex: integer);
//var
//  i, LRadix: integer;
//  LDataOk: Boolean;
//  FMEXA7000Data: TEventData_MEXA7000_2;
//begin
//  FMEXA7000Data := TEventData_MEXA7000_2(TIPCMonitor<TEventData_MEXA7000_2>(FIPCMonitorList.Objects[AIndex]).FEventDataRecord);
//
//  for i := 0 to FEngineParameter.EngineParameterCollect.Count - 1 do
//  begin
//    if FEngineParameter.EngineParameterCollect.Items[i].ParameterSource = psMEXA7000 then
//    begin
////      LRadix := FEngineParameter.EngineParameterCollect.Items[i].RadixPosition;
//
//      if UpperCase(FEngineParameter.EngineParameterCollect.Items[i].TagName) = UpperCase('CO2') then
//        FEngineParameter.EngineParameterCollect.Items[i].Value := FormatFloat(FEngineParameter.EngineParameterCollect.Items[i].DisplayFormat,FMEXA7000Data.CO2/10000) //FloatToStr(FMEXA7000Data.CO2/10000)
//      else if UpperCase(FEngineParameter.EngineParameterCollect.Items[i].TagName) = UpperCase('CO_L') then
//        FEngineParameter.EngineParameterCollect.Items[i].Value := FormatFloat(FEngineParameter.EngineParameterCollect.Items[i].DisplayFormat,FMEXA7000Data.CO_L) //FloatToStr(FMEXA7000Data.CO_L)
//      else if UpperCase(FEngineParameter.EngineParameterCollect.Items[i].TagName) = UpperCase('O2') then
//        FEngineParameter.EngineParameterCollect.Items[i].Value := FormatFloat(FEngineParameter.EngineParameterCollect.Items[i].DisplayFormat,FMEXA7000Data.O2/10000) //FloatToStr(FMEXA7000Data.O2/10000)
//      else if UpperCase(FEngineParameter.EngineParameterCollect.Items[i].TagName) = UpperCase('NOx') then
//        FEngineParameter.EngineParameterCollect.Items[i].Value := FormatFloat(FEngineParameter.EngineParameterCollect.Items[i].DisplayFormat,FMEXA7000Data.NOx) //FloatToStr(FMEXA7000Data.NOx)
//      else if UpperCase(FEngineParameter.EngineParameterCollect.Items[i].TagName) = UpperCase('THC') then
//        FEngineParameter.EngineParameterCollect.Items[i].Value := FormatFloat(FEngineParameter.EngineParameterCollect.Items[i].DisplayFormat,FMEXA7000Data.THC) //FloatToStr(FMEXA7000Data.THC)
//      else if UpperCase(FEngineParameter.EngineParameterCollect.Items[i].TagName) = UpperCase('CH4') then
//        FEngineParameter.EngineParameterCollect.Items[i].Value := FormatFloat(FEngineParameter.EngineParameterCollect.Items[i].DisplayFormat,FMEXA7000Data.CH4) //FloatToStr(FMEXA7000Data.CH4)
//      else if UpperCase(FEngineParameter.EngineParameterCollect.Items[i].TagName) = UpperCase('non_CH4') then
//        FEngineParameter.EngineParameterCollect.Items[i].Value := FormatFloat(FEngineParameter.EngineParameterCollect.Items[i].DisplayFormat,FMEXA7000Data.non_CH4) //FloatToStr(FMEXA7000Data.non_CH4)
//      else if UpperCase(FEngineParameter.EngineParameterCollect.Items[i].TagName) = UpperCase('CollectedValue') then
//        FEngineParameter.EngineParameterCollect.Items[i].Value := FormatFloat(FEngineParameter.EngineParameterCollect.Items[i].DisplayFormat,FMEXA7000Data.CollectedValue); //FloatToStr(FMEXA7000Data.CollectedValue);
//
//      WatchValue2Screen_Analog('', '',i);
//      LDataOk := True;
//    end;
//  end;
//
//  //상속 받은 자손에서 구현할 것
//  {if LDataOk then
//  begin
//    Timer1.Enabled := True;
//    FPJHTimerPool.AddOneShot(OnTrigger4AvgSave,2000);
//    DataSaveByEvent;
//  end;
//  }
//end;

//procedure TFrameIPCMonitorAll.OverRide_MT210(AIndex: integer);
//var
//  i, LRadix: integer;
//  LDataOk: Boolean;
//  FMT210Data: TEventData_MT210;
//begin
//  FMT210Data := TEventData_MT210(TIPCMonitor<TEventData_MT210>(FIPCMonitorList.Objects[AIndex]).FEventDataRecord);
//
//  LDataOk := False;
//
//  for i := 0 to FEngineParameter.EngineParameterCollect.Count - 1 do
//  begin
//    if FEngineParameter.EngineParameterCollect.Items[i].ParameterSource = psMT210 then
//    begin
////      LRadix := FEngineParameter.EngineParameterCollect.Items[i].RadixPosition;
//
//      FEngineParameter.EngineParameterCollect.Items[i].Value := FormatFloat(FEngineParameter.EngineParameterCollect.Items[i].DisplayFormat,FMT210Data.FData); //FloatToStr(FMT210Data.FData);
////      FEngineParameter.EngineParameterCollect.Items[i].Value := FloatToStrF(FMT210Data.FData); //FloatToStr(FMT210Data.FData);
//      WatchValue2Screen_Analog('', '',i);
//      LDataOk := True;
//      break;
//    end;
//  end;//for
//
//  //상속 받은 자손에서 구현할 것
//  {if LDataOk then
//  begin
//    Timer1.Enabled := True;
//    FPJHTimerPool.AddOneShot(OnTrigger4AvgSave,2000);
//  end;
//  }
//end;

//procedure TFrameIPCMonitorAll.OverRide_PLCMODBUS(
//  AIndex: integer);
//var
//  i,j,k: integer;
//  Le: double;
//  LRadix: integer;
//  LPLCModbusData: TEventData_Modbus_Standard;
//begin
//  LPLCModbusData := TEventData_Modbus_Standard(TIPCMonitor<TEventData_Modbus_Standard>(FIPCMonitorList.Objects[AIndex]).FEventDataRecord);
//
//  if (LPLCModbusData.ModBusFunctionCode = 1) or (LPLCModbusData.ModBusFunctionCode = 2)
//    or (LPLCModbusData.ModBusFunctionCode = 3) or (LPLCModbusData.ModBusFunctionCode = 4) then
//  begin
//    for k := 0 to FEngineParameter.EngineParameterCollect.Count - 1 do
//    begin
//      if FEngineParameter.EngineParameterCollect.Items[k].ParameterSource = psPLC_Modbus then
//      begin
//        if LPLCModbusData.BlockNo <> FEngineParameter.EngineParameterCollect.Items[k].BlockNo then
//          Continue;
//
//        //AbsoluteIndex에 Modbus Map에서 각 Request별 위치 정보(공유메모리상의 Index)
//        i := FEngineParameter.EngineParameterCollect.Items[k].AbsoluteIndex;
//
//        if FEngineParameter.EngineParameterCollect.Items[k].Alarm then //Analog data
//        begin
//          if LPLCModbusData.ModBusMode = 3 then //simulate from csv
//          begin
//            Le := LPLCModbusData.InpDataBuf_double[i];
//          end
//          else
//          begin
//            case FEngineParameter.EngineParameterCollect.Items[k].MinMaxType of
//              mmtInteger: begin
//                if FEngineParameter.EngineParameterCollect.Items[k].MaxValue > 0 then
//                  Le := LPLCModbusData.InpDataBuf[i]/FEngineParameter.EngineParameterCollect.Items[k].MaxValue
//                else
//                  Le := LPLCModbusData.InpDataBuf[i];
//              end;
//              mmtReal: begin
//                if FEngineParameter.EngineParameterCollect.Items[k].MaxValue_Real > 0.0 then
//                  Le := LPLCModbusData.InpDataBuf[i]/FEngineParameter.EngineParameterCollect.Items[k].MaxValue_Real
//                else
//                  Le := LPLCModbusData.InpDataBuf[i];
//              end;
//            end;//case
//          end;
//
////          LRadix := FEngineParameter.EngineParameterCollect.Items[k].RadixPosition;
//
//          FEngineParameter.EngineParameterCollect.Items[k].Value := FormatFloat(FEngineParameter.EngineParameterCollect.Items[k].DisplayFormat, Le);
////          FEngineParameter.EngineParameterCollect.Items[k].Value := FloatToStrF(Le, ffFixed, 12, LRadix);//,'%.2f');
//        end
//        else //Digital data
//        begin
//          i := FEngineParameter.EngineParameterCollect.Items[k].AbsoluteIndex;
//
//          j := FEngineParameter.EngineParameterCollect.Items[k].RadixPosition;
//          //0이 아니면 True임
//          FEngineParameter.EngineParameterCollect.Items[k].Value := IntToStr(GetBitVal(LPLCModbusData.InpDataBuf[i], j));
//        end;
//
//                  //수신된 데이타를 화면에 뿌려줌
//        Value2Screen_ECS_Woodward(k,LPLCModbusData.ModBusMode);
//      end;
//    end;//for
//  end;
//end;

//procedure TFrameIPCMonitorAll.OverRide_PLC_S7(AIndex: integer);
//var
//  i,k,LRadix,LDividor: integer;
//  Le: double;
//  LPLCData_S7: TEventData_PLC_S7;
//begin
//  LPLCData_S7 := TEventData_PLC_S7(TIPCMonitor<TEventData_PLC_S7>(FIPCMonitorList.Objects[AIndex]).FEventDataRecord);
//
//  for k := 0 to FEngineParameter.EngineParameterCollect.Count - 1 do
//  begin
//    if FEngineParameter.EngineParameterCollect.Items[k].ParameterSource = psPLC_S7 then
//    begin
//      if LPLCData_S7.BlockNo <> FEngineParameter.EngineParameterCollect.Items[k].BlockNo then
//        Continue;
//
//      //배열 Index는 0부터 시작하는데 FCode는 1부터 시작하므로 1 빼줌
//      i := StrToInt(FEngineParameter.EngineParameterCollect.Items[k].FCode) - 1;
//
//      if FEngineParameter.EngineParameterCollect.Items[k].Contact <> 0 then
//        LDividor := FEngineParameter.EngineParameterCollect.Items[k].Contact
//      else
//        LDividor := 1;
//
//      if FEngineParameter.EngineParameterCollect.Items[k].Alarm then //Analog data
//      begin
//        case TS7DataType(FEngineParameter.EngineParameterCollect.Items[k].AbsoluteIndex) of
//          S7DTByte : Le := LPLCData_S7.DataByte[i]/LDividor;
//          S7DTWord : Le := LPLCData_S7.DataWord[i]/LDividor;
//          S7DTInt  : Le := LPLCData_S7.DataInt[i]/LDividor;
//          S7DTDWord: Le := LPLCData_S7.DataDWord[i]/LDividor;
//          S7DTDInt : Le := LPLCData_S7.DataDInt[i]/LDividor;
//          S7DTReal : Le := LPLCData_S7.DataFloat[i]/LDividor;
//        end;//case
//      end;
//
////      LRadix := FEngineParameter.EngineParameterCollect.Items[k].RadixPosition;
//      FEngineParameter.EngineParameterCollect.Items[k].Value := FormatFloat(FEngineParameter.EngineParameterCollect.Items[i].DisplayFormat, Le);//,'%.2f');
//
//      WatchValue2Screen_Analog('', '',k);
//    end;//if
//  end;//for
//end;

//procedure TFrameIPCMonitorAll.OverRide_PMS(AIndex: integer);
//var
//  i, LRadix: integer;
//  LDataOk: Boolean;
//  FPMSData: TEventData_PMS;
//begin
//  FPMSData := TEventData_PMS(TIPCMonitor<TEventData_PMS>(FIPCMonitorList.Objects[AIndex]).FEventDataRecord);
//
//  for i := 0 to FEngineParameter.EngineParameterCollect.Count - 1 do
//  begin
//    if FEngineParameter.EngineParameterCollect.Items[i].ParameterSource = psPMSOPC then
//    begin
////      LRadix := FEngineParameter.EngineParameterCollect.Items[i].RadixPosition;
//
//      FEngineParameter.EngineParameterCollect.Items[i].Value := FPMSData.InpDataBuf[i];
//      WatchValue2Screen_Analog('', '',i);
//      LDataOk := True;
//    end;
//  end;
//end;

//procedure TFrameIPCMonitorAll.OverRide_WT1600(AIndex: integer);
//var
//  i, LRadix, LMaxVal: integer;
//  LDouble: double;
//  LDataOk: boolean;
//  FWT1600Data: TEventData_WT1600;
//begin
//  FWT1600Data := TEventData_WT1600(TIPCMonitor<TEventData_WT1600>(FIPCMonitorList.Objects[AIndex]).FEventDataRecord);
//
//  LDataOk := False;
//
//  for i := 0 to FEngineParameter.EngineParameterCollect.Count - 1 do
//  begin
//    if FEngineParameter.EngineParameterCollect.Items[i].ParameterSource = psWT1600 then
//    begin
////      LRadix := FEngineParameter.EngineParameterCollect.Items[i].RadixPosition;
//      LMaxVal := FEngineParameter.EngineParameterCollect.Items[i].MaxValue;
//
//      if LMaxVal = 0 then
//        LMaxVal := 1;
//
//      if UpperCase(FEngineParameter.EngineParameterCollect.Items[i].TagName) = UpperCase('PSIGMA') then
//      begin
//        LDouble := StrToFloatDef(FWT1600Data.PSIGMA,0.0);
////        FEngineParameter.EngineParameterCollect.Items[i].Value := FloatToStrF(LDouble/LMaxVal, ffFixed, 12, LRadix) //Format('%.2f', [LDouble/1000]);
//      end
//      else if UpperCase(FEngineParameter.EngineParameterCollect.Items[i].TagName) = UpperCase('SSIGMA') then
//      begin
//        LDouble := StrToFloatDef(FWT1600Data.SSIGMA,0.0);
////        FEngineParameter.EngineParameterCollect.Items[i].Value := FloatToStrF(LDouble/LMaxVal, ffFixed, 12, LRadix) //Format('%.2f', [LDouble/1000]);
//      end
//      else if UpperCase(FEngineParameter.EngineParameterCollect.Items[i].TagName) = UpperCase('QSIGMA') then
//      begin
//        LDouble := StrToFloatDef(FWT1600Data.QSIGMA,0.0);
////        FEngineParameter.EngineParameterCollect.Items[i].Value := FloatToStrF(LDouble/LMaxVal, ffFixed, 12, LRadix) //Format('%.2f', [LDouble/1000]);
//      end
//      else if UpperCase(FEngineParameter.EngineParameterCollect.Items[i].TagName) = UpperCase('URMS1') then
//      begin
//        LDouble := StrToFloatDef(FWT1600Data.URMS1,0.0);
////        FEngineParameter.EngineParameterCollect.Items[i].Value := FloatToStrF(LDouble/LMaxVal, ffFixed, 12, LRadix);
//      end
//      else if UpperCase(FEngineParameter.EngineParameterCollect.Items[i].TagName) = UpperCase('URMS2') then
//      begin
//        LDouble := StrToFloatDef(FWT1600Data.URMS2,0.0);
////        FEngineParameter.EngineParameterCollect.Items[i].Value := FloatToStrF(LDouble/LMaxVal, ffFixed, 12, LRadix);
//      end
//      else if UpperCase(FEngineParameter.EngineParameterCollect.Items[i].TagName) = UpperCase('URMS3') then
//      begin
//        LDouble := StrToFloatDef(FWT1600Data.URMS3,0.0);
////        FEngineParameter.EngineParameterCollect.Items[i].Value := FloatToStrF(LDouble/LMaxVal, ffFixed, 12, LRadix);
//      end
//      else if UpperCase(FEngineParameter.EngineParameterCollect.Items[i].TagName) = UpperCase('IRMS1') then
//      begin
//        LDouble := StrToFloatDef(FWT1600Data.IRMS1,0.0);
////        FEngineParameter.EngineParameterCollect.Items[i].Value := FloatToStrF(LDouble/LMaxVal, ffFixed, 12, LRadix);
//      end
//      else if UpperCase(FEngineParameter.EngineParameterCollect.Items[i].TagName) = UpperCase('IRMS2') then
//      begin
//        LDouble := StrToFloatDef(FWT1600Data.IRMS2,0.0);
////        FEngineParameter.EngineParameterCollect.Items[i].Value :=FloatToStrF(LDouble/LMaxVal, ffFixed, 12, LRadix);
//      end
//      else if UpperCase(FEngineParameter.EngineParameterCollect.Items[i].TagName) = UpperCase('IRMS3') then
//      begin
//        LDouble := StrToFloatDef(FWT1600Data.IRMS3,0.0);
////        FEngineParameter.EngineParameterCollect.Items[i].Value := FloatToStrF(LDouble/LMaxVal, ffFixed, 12, LRadix);
//      end
//      else if UpperCase(FEngineParameter.EngineParameterCollect.Items[i].TagName) = UpperCase('URMSAVG') then
//      begin
//        LDouble := StrToFloatDef(FWT1600Data.URMSAVG,0.0);
////        FEngineParameter.EngineParameterCollect.Items[i].Value := String(FWT1600Data.URMSAVG);
//      end
//      else if UpperCase(FEngineParameter.EngineParameterCollect.Items[i].TagName) = UpperCase('IRMSAVG') then
//      begin
//        LDouble := StrToFloatDef(FWT1600Data.IRMSAVG,0.0);
////        FEngineParameter.EngineParameterCollect.Items[i].Value := String(FWT1600Data.IRMSAVG);
//      end
//      else if UpperCase(FEngineParameter.EngineParameterCollect.Items[i].TagName) = UpperCase('RAMDA') then
//      begin
//        LDouble := StrToFloatDef(FWT1600Data.RAMDA,0.0);
////        FEngineParameter.EngineParameterCollect.Items[i].Value := String(FWT1600Data.RAMDA);
//      end
//      else if UpperCase(FEngineParameter.EngineParameterCollect.Items[i].TagName) = UpperCase('F1') then
//      begin
//        LDouble := StrToFloatDef(FWT1600Data.F1,0.0);
////        FEngineParameter.EngineParameterCollect.Items[i].Value := String(FWT1600Data.F1);
//      end
//      else if UpperCase(FEngineParameter.EngineParameterCollect.Items[i].TagName) = UpperCase('FREQUENCY') then
//      begin
//        LDouble := StrToFloatDef(FWT1600Data.FREQUENCY,0.0);
////        FEngineParameter.EngineParameterCollect.Items[i].Value := String(FWT1600Data.FREQUENCY);
//      end;
//
//      FEngineParameter.EngineParameterCollect.Items[i].Value := FormatFloat(FEngineParameter.EngineParameterCollect.Items[i].DisplayFormat,LDouble/LMaxVal);
////      FEngineParameter.EngineParameterCollect.Items[i].Value := FloatToStrF(LDouble/LMaxVal, ffFixed, 12, LRadix);
//      WatchValue2Screen_Analog('', '',i);
//      LDataOk := True;
//    end;
//  end;//for
//
//  //상속 받은 자손에서 구현할 것
//  {if LDataOk then
//  begin
//    Timer1.Enabled := True;
//    FPJHTimerPool.AddOneShot(OnTrigger4AvgSave,2000);
//    DataSaveByEvent;
//  end;
//  }
//end;

//procedure TFrameIPCMonitorAll.PLCMODBUS_OnSignal(
//  Data: TEventData_Modbus_Standard);
//var
//  i,dcount: integer;
//  j: integer;
//  LStr: string;
//begin
//  LStr := GetCombinedNamePSandSM(psPLC_Modbus);
//  j := FIPCMonitorList.IndexOf(LStr);
//
//  if j <> -1 then
//  begin
//    with TEventData_Modbus_Standard(TIPCMonitor<TEventData_Modbus_Standard>(FIPCMonitorList.Objects[j]).FEventDataRecord) do
//    begin
//      if not FCompleteReadMap_Woodward then
//        exit;
//
//      dcount := 0;
//      FillChar(InpDataBuf[0], High(InpDataBuf) - 1, #0);
//      ModBusMode := Data.ModBusMode;
//
//      if Data.ModBusMode = 0 then //ASCII Mode이면
//      begin
//        //ModePanel.Caption := 'ASCII Mode';
//        dcount := Data.NumOfData;
//        NumOfBit := Data.NumOfBit;
//
//        for i := 0 to dcount - 1 do
//          InpDataBuf[i] := Data.InpDataBuf[i];
//      end
//      else
//      if Data.ModBusMode = 1 then// RTU Mode 이면
//      begin
//        dcount := Data.NumOfData div 2;
//        NumOfBit := Data.NumOfBit;
//
//        if dcount = 0 then
//          Inc(dcount);
//
//        for i := 0 to dcount - 1 do
//        begin
//          InpDataBuf[i] := Data.InpDataBuf2[i*2] ;
//          InpDataBuf[i] := InpDataBuf[i] shl 8 + Data.InpDataBuf2[i*2 + 1];
//        end;
//
//        if (Data.NumOfData mod 2) > 0 then
//          InpDataBuf[i] := Data.InpDataBuf2[i*2] ;
//      end//Data.ModBusMode = 1
//      else
//      if (Data.ModBusMode = 4) then //MODBUSTCP_MODE 이면
//      begin
//        dcount := Data.NumOfData;
//        NumOfBit := Data.NumOfBit;
//        System.Move(Data.InpDataBuf, InpDataBuf, Sizeof(Data.InpDataBuf));
//      end
//      else
//      if (Data.ModBusMode = 3) then //simulate from csv file
//      begin
//        dcount := Data.NumOfData;
//        NumOfBit := Data.NumOfBit;
//        System.Move(Data.InpDataBuf_double, InpDataBuf_double, Sizeof(Data.InpDataBuf_double));
//      end//Data.ModBusMode = 3
//      else
//      if (Data.ModBusMode = 5) then//MODBUSSERIAL_TCP_MODE
//      begin
//        dcount := Data.NumOfData;
//        NumOfBit := Data.NumOfBit;
//        System.Move(Data.InpDataBuf, InpDataBuf, Sizeof(Data.InpDataBuf));
//      end;
//
//      ModBusAddress := Data.ModBusAddress;
//      BlockNo := Data.BlockNo;
//      NumOfData := dcount;
//      ModBusFunctionCode := Data.ModBusFunctionCode;
//      ModBusMapFileName := Data.ModBusMapFileName;
//      FModBusMapFileName := Data.ModBusMapFileName;
//
//      DisplayMessage2SB(FStatusBar, ModBusAddress + ' 데이타 도착');
//
//      SendMessage(Handle, WM_EVENT_PLCMODBUS, j,0);
//      CommonCommunication(psPLC_Modbus);
//    end;
//  end;
//  if not FCompleteReadMap_Woodward then
//    exit;
//
//  dcount := 0;
//  FillChar(FPLCModbusData.InpDataBuf[0], High(FPLCModbusData.InpDataBuf) - 1, #0);
//  FPLCModbusData.ModBusMode := Data.ModBusMode;
//
//  if Data.ModBusMode = 0 then //ASCII Mode이면
//  begin
//    //ModePanel.Caption := 'ASCII Mode';
//    dcount := Data.NumOfData;
//    FPLCModbusData.NumOfBit := Data.NumOfBit;
//
//    for i := 0 to dcount - 1 do
//      FPLCModbusData.InpDataBuf[i] := Data.InpDataBuf[i];
//  end
//  else
//  if Data.ModBusMode = 1 then// RTU Mode 이면
//  begin
//    dcount := Data.NumOfData div 2;
//    FPLCModbusData.NumOfBit := Data.NumOfBit;
//
//    if dcount = 0 then
//      Inc(dcount);
//
//    for i := 0 to dcount - 1 do
//    begin
//      FPLCModbusData.InpDataBuf[i] := Data.InpDataBuf2[i*2] ;
//      FPLCModbusData.InpDataBuf[i] := FPLCModbusData.InpDataBuf[i] shl 8 + Data.InpDataBuf2[i*2 + 1];
//    end;
//
//    if (Data.NumOfData mod 2) > 0 then
//      FPLCModbusData.InpDataBuf[i] := Data.InpDataBuf2[i*2] ;
//  end//Data.ModBusMode = 1
//  else
//  if (Data.ModBusMode = 4) then //MODBUSTCP_MODE 이면
//  begin
//    dcount := Data.NumOfData;
//    FPLCModbusData.NumOfBit := Data.NumOfBit;
//    System.Move(Data.InpDataBuf, FPLCModbusData.InpDataBuf, Sizeof(Data.InpDataBuf));
//  end
//  else
//  if (Data.ModBusMode = 3) then //simulate from csv file
//  begin
//    dcount := Data.NumOfData;
//    FPLCModbusData.NumOfBit := Data.NumOfBit;
//    System.Move(Data.InpDataBuf_double, FPLCModbusData.InpDataBuf_double, Sizeof(Data.InpDataBuf_double));
//  end//Data.ModBusMode = 3
//  else
//  if (Data.ModBusMode = 5) then//MODBUSSERIAL_TCP_MODE
//  begin
//    dcount := Data.NumOfData;
//    FPLCModbusData.NumOfBit := Data.NumOfBit;
//    System.Move(Data.InpDataBuf, FPLCModbusData.InpDataBuf, Sizeof(Data.InpDataBuf));
//  end;
//
//  FPLCModbusData.ModBusAddress := Data.ModBusAddress;
//  FPLCModbusData.BlockNo := Data.BlockNo;
//  FPLCModbusData.NumOfData := dcount;
//  FPLCModbusData.ModBusFunctionCode := Data.ModBusFunctionCode;
//  FPLCModbusData.ModBusMapFileName := Data.ModBusMapFileName;
//  FModBusMapFileName := Data.ModBusMapFileName;
//
//  DisplayMessage2SB(FStatusBar, FPLCModbusData.ModBusAddress + ' 데이타 도착');
//
//  SendMessage(Handle, WM_EVENT_PLCMODBUS, 0,0);
//  CommonCommunication(psPLC_Modbus);
//end;

//procedure TFrameIPCMonitorAll.PLC_S7_OnSignal(Data: TEventData_PLC_S7);
//var
//  j: integer;
//  LStr: string;
//begin
//  LStr := GetCombinedNamePSandSM(psPLC_S7);
//  j := FIPCMonitorList.IndexOf(LStr);
//
//  if j <> -1 then
//  begin
//    with TEventData_PLC_S7(TIPCMonitor<TEventData_PLC_S7>(FIPCMonitorList.Objects[j]).FEventDataRecord) do
//    begin
//      Case Data.DataType of
//        0 : System.Move(Data.DataByte, DataByte, Sizeof(Data.DataByte));
//        1 : System.Move(Data.DataWord, DataWord, Sizeof(Data.DataWord));
//        2 : System.Move(Data.DataInt, DataInt, Sizeof(Data.DataInt));
//        3 : System.Move(Data.DataDWord, DataDWord, Sizeof(Data.DataDWord));
//        4 : System.Move(Data.DataDInt, DataDInt, Sizeof(Data.DataDInt));
//        5 : System.Move(Data.DataFloat, DataFloat, Sizeof(Data.DataFloat));
//      end;
//
//      NumOfData := Data.NumOfData;
//      NumOfBit := Data.NumOfBit;
//      BlockNo := Data.BlockNo;
//      DataType := Data.DataType;
//      ModBusMapFileName := Data.ModBusMapFileName;
//      FModBusMapFileName := Data.ModBusMapFileName;
//
//      SendMessage(Handle, WM_EVENT_PLC_S7, j,0);
//      CommonCommunication(psPLC_S7);
//    end;
//  end;
//  Case Data.DataType of
//    0 : System.Move(Data.DataByte, FPLCData_S7.DataByte, Sizeof(Data.DataByte));
//    1 : System.Move(Data.DataWord, FPLCData_S7.DataWord, Sizeof(Data.DataWord));
//    2 : System.Move(Data.DataInt, FPLCData_S7.DataInt, Sizeof(Data.DataInt));
//    3 : System.Move(Data.DataDWord, FPLCData_S7.DataDWord, Sizeof(Data.DataDWord));
//    4 : System.Move(Data.DataDInt, FPLCData_S7.DataDInt, Sizeof(Data.DataDInt));
//    5 : System.Move(Data.DataFloat, FPLCData_S7.DataFloat, Sizeof(Data.DataFloat));
//  end;
//
//  FPLCData_S7.NumOfData := Data.NumOfData;
//  FPLCData_S7.NumOfBit := Data.NumOfBit;
//  FPLCData_S7.BlockNo := Data.BlockNo;
//  FPLCData_S7.DataType := Data.DataType;
//  FPLCData_S7.ModBusMapFileName := Data.ModBusMapFileName;
//  FModBusMapFileName := Data.ModBusMapFileName;
//
//  SendMessage(Handle, WM_EVENT_PLC_S7, 0,0);
//  CommonCommunication(psPLC_S7);
//end;

//procedure TFrameIPCMonitorAll.PMS_OnSignal(Data: TEventData_PMS);
//var
//  i: integer;
//  j: integer;
//  LStr: string;
//begin
//  LStr := GetCombinedNamePSandSM(psPMSOPC);
//  j := FIPCMonitorList.IndexOf(LStr);
//
//  if j <> -1 then
//  begin
//    with TEventData_PMS(TIPCMonitor<TEventData_PMS>(FIPCMonitorList.Objects[j]).FEventDataRecord) do
//    begin
//      for i := 0 to High(InpDataBuf) - 1 do
//        InpDataBuf[i] := Data.InpDataBuf[i];
//
//      SendMessage(Handle, WM_EVENT_PMS, j,0);
//      CommonCommunication(psPMSOPC);
//    end;
//  end;
//  for i := 0 to High(FPMSData.InpDataBuf) - 1 do
//    FPMSData.InpDataBuf[i] := Data.InpDataBuf[i];
//
//  SendMessage(Handle, WM_EVENT_PMS, 0,0);
//  CommonCommunication(psPMSOPC);
//end;

procedure TFrameIPCMonitorAll.ReadMapAddress(AddressMap: DMap; MapFileName: string);
var
  sqltext, MapFilePath: string;
  sqlresult, reccnt, fldcnt: integer;
  i,j, LLastBlockNo, LLastIndex: integer;
  filename, fcode: string;
  shbtn: TShadowButton;
  janDB: TjanSQL;
  HiMap: THiMap;
begin
  SetCurrentDir(ExtractFilePath(Application.ExeName));

  if fileexists(MapFileName) then
  begin
    Filename := ExtractFileName(MapFileName);
    FileName := Copy(Filename,1, Pos('.',Filename) - 1);
    MapFilePath := ExtractFilePath(MapFileName);
    janDB :=TjanSQL.create;
    try
      sqltext := 'connect to ''' + MapFilePath + '''';

      sqlresult := janDB.SQLDirect(sqltext);
      //Connect 성공
      if sqlresult <> 0 then
      begin
        with janDB do
        begin
          sqltext := 'select * from ' + FileName + ' group by cnt';
          sqlresult := SQLDirect(sqltext);
          //Query 정상
          if sqlresult <> 0 then
          begin
            //데이타 건수가 1개 이상 있으면
            if sqlresult>0 then
            begin
              fldcnt := RecordSets[sqlresult].FieldCount;
              //Field Count가 0 이면
              if fldcnt = 0 then exit;

              reccnt := RecordSets[sqlresult].RecordCount;
              //Record Count가 0 이면
              if reccnt = 0 then exit;

              j := 0;
              LLastIndex := 0;

              for i := 0 to reccnt - 1 do
              begin
                HiMap := THiMap.Create;
                with HiMap, RecordSets[SqlResult].Records[i] do
                begin
                  FName := Fields[0].Value;
                  FDescription := Fields[1].Value;
                  FSid := StrToInt(Fields[2].Value);
                  FAddress := Fields[3].Value;
                  //kumo ECS를 Value2Screen_ECS 함수에서 처리하기 위함
                  FUnit := Fields[5].Value;
                  FBlockNo := StrToInt(Fields[4].Value);

                  if i = 0 then
                    LLastBlockNo := FBlockNo;

                  if LLastBlockNo <> FBlockNo then
                  begin
                    LLastIndex := 0;
                    LLastBlockNo := FBlockNo;
                  end;

                  FListIndex := LLastIndex;
                  inc(LLastIndex);

                  if UpperCase(FDescription) <> 'DUMMY' then
                  begin
                    FListIndexNoDummy := j;
                    Inc(j);
                  end
                  else
                    FListIndexNoDummy := -1;

                  if Fields[5].Value = 'FALSE' then
                  begin
                    FAlarm := False;
                    fcode := '1';
                  end
                  else if Fields[5].Value = 'TRUE4' then
                  begin
                    FAlarm := True;
                    fcode := '4';
                  end
                  else if Fields[5].Value = 'TRUE' then
                  begin
                    FAlarm := True;
                    fcode := '3';
                  end
                  else if Fields[5].Value = 'FALSE3' then
                  begin
                    FAlarm := False;
                    fcode := '3';
                  end;

                  FMaxval := StrToFloat(Fields[6].Value);
                  FContact := StrToInt(Fields[7].Value);
                  FUnit := '';

                  shbtn := nil;
                  shbtn := TShadowButton(FindComponent(FName));
                  if Assigned(shbtn) then
                    shbtn.Hint := FDescription;
                end;//with

                AddressMap.PutPair([fcode + HiMap.FAddress,HiMap]);
              end;//for
            end;

          end
          else
            DisplayMessage2SB(FStatusBar, janDB.Error);
        end;//with
      end
      else
        Application.MessageBox('Connect 실패',
            PChar('폴더 ' + FFilePath + ' 를 만든 후 다시 하시오'),MB_ICONSTOP+MB_OK);
    finally
      janDB.Free;
    end;
  end
  else
  begin
    sqltext := MapFileName + '파일을 만든 후에 다시 하시오';
    Application.MessageBox('Data file does not exist!', PChar(sqltext) ,MB_ICONSTOP+MB_OK);
  end;
end;

procedure TFrameIPCMonitorAll.ReadMapAddressFromParamFile(AFilename: string;
  AEngParamEncrypt: Boolean; AModBusBlockList: DList);
var
  i, LPrevBlockNo, LCount: integer;
  LIndex: integer;
  LStartAddr:string;
  LBlockNo,
  LFuncCode: integer;
  LModBusBlock: TModbusBlock;
begin
  FEngineParameter.LoadFromJSONFile(AFilename,
                                    ExtractFileName(AFilename),
                                    AEngParamEncrypt);
  AModBusBlockList.clear;

  LPrevBlockNo := -1;
  LCount := 0;
  LIndex := 0;//시작 Offset index 저장

  for i := 0 to FEngineParameter.EngineParameterCollect.Count - 1 do
  begin
    if LPrevBlockNo = FEngineParameter.EngineParameterCollect.Items[i].BlockNo then
    begin
      if LCount = 1 then
      begin
        LStartAddr := FEngineParameter.EngineParameterCollect.Items[i-1].Address;
        LBlockNo := FEngineParameter.EngineParameterCollect.Items[i-1].BlockNo;
        LFuncCode := StrToIntDef(FEngineParameter.EngineParameterCollect.Items[i-1].FCode,0);
      end;

      if LPrevBlockNo <> -1 then
        inc(LCount);
    end
    else
    begin
      if( LCount > 0) and
        (FEngineParameter.EngineParameterCollect.Items[i-1].BlockNo > 0) then
      begin
        LModBusBlock := TModbusBlock.Create;

        With LModBusBlock do
        begin
          //BlockNo가 변하는 곳까지 검색 후 변하는곳 이전 데이터 저장(i-1)
          FStartAddr := LStartAddr;
          FCount := LCount;
          FBlockNo := LBlockNo;
          FFunctionCode := LFuncCode;
        end;

        AModBusBlockList.Add([LModBusBlock]);

        LCount := 1;
      end
      else
        inc(LCount);

      LPrevBlockNo := FEngineParameter.EngineParameterCollect.Items[i].BlockNo;
    end;

  end;//for

  if( LCount > 0) and
    (FEngineParameter.EngineParameterCollect.Items[i-1].BlockNo > 0) then
  begin
    LModBusBlock := TModbusBlock.Create;

    With LModBusBlock do
    begin
      FCount := LCount;
      FStartAddr := LStartAddr;
      FBlockNo := LBlockNo;
      FFunctionCode := LFuncCode;
    end;//with

    AModBusBlockList.Add([LModBusBlock]);
  end;
end;

procedure TFrameIPCMonitorAll.SendFormCopyData(ToHandle: integer; AForm: TForm);
var
  cd : TCopyDataStruct;
begin
  with cd do
  begin
    dwData := Handle;
    cbData := sizeof(AForm);
    lpData := @AForm;
  end;//with

  SendMessage(ToHandle, WM_COPYDATA, 0, LongInt(@cd));
end;

procedure TFrameIPCMonitorAll.SetModbusMapFileName(AFileName: string;
  APSrc: TParameterSource);
begin
//  if Assigned(FIPCMonitor_ECS_kumo) or Assigned(FIPCMonitor_ECS_AVAT) then
//  begin
//    if AFileName = '' then
//    begin
//      if APSrc = psECS_kumo then
//        FModbusMapFileName := 'Default_ModbusMap_kumo.txt'
//      else
//      if APSrc = psECS_AVAT then
//        FModbusMapFileName := '.\avat_modbustcp_map_analog.txt';//'Default_ModbusMap_Avat.txt';
//    end
//    else
//      FModbusMapFileName := AFileName;
//
//    FAddressMap.clear;
//    ReadMapAddress(FAddressMap,FModbusMapFileName);
//  end
//  else if APSrc = psECS_woodward then
//  begin
//    FEngineParameter.LoadFromJSONFile(AFileName);
//    exit;
//  end;
end;

procedure TFrameIPCMonitorAll.SetValue2ScreenEvent(AAnalogFunc: TWatchValue2Screen_AnalogEvent;
      ADigitalFunc: TWatchValue2Screen_DigitalEvent);
begin
  if Assigned(AAnalogFunc) then
    FWatchValue2Screen_AnalogEvent := AAnalogFunc;

  if Assigned(ADigitalFunc) then
    FWatchValue2Screen_AnalogEvent := ADigitalFunc;
end;

procedure TFrameIPCMonitorAll.UpdateTrace_DYNAMO(var Msg: TMessage);
begin
  if FIsSetZeroWhenDisconnect then
    FPJHTimerPool.AddOneShot(OnSetZeroDYNAMO,5000);

  TDYNAMO_Method(TIPCMonitorClass(FIPCMonitorList.Objects[Msg.WParam]).FIPCMethod).OverRide_DYNAMO(Msg.WParam);
//  OverRide_DYNAMO(FDYNAMOData);
end;

procedure TFrameIPCMonitorAll.UpdateTrace_ECS_AVAT(var Msg: TMessage);
begin
  if FIsSetZeroWhenDisconnect then
    FPJHTimerPool.AddOneShot(OnSetZeroECS_AVAT,5000);

  TECS_AVAT_Method(TIPCMonitorClass(FIPCMonitorList.Objects[Msg.WParam]).FIPCMethod).OverRide_ECS_AVAT(Msg.WParam);
//  OverRide_ECS_AVAT(FECSData_AVAT);
end;

procedure TFrameIPCMonitorAll.UpdateTrace_ECS_ComAP(
  var Msg: TMessage);
begin
  if FIsSetZeroWhenDisconnect then
    FPJHTimerPool.AddOneShot(OnSetZeroECS_ComAP,5000);

  TECS_ComAP_Method(TIPCMonitorClass(FIPCMonitorList.Objects[Msg.WParam]).FIPCMethod).OverRide_ECS_ComAP(Msg.WParam);
//  OverRide_ECS_ComAP(FECSData_ComAP);
end;

procedure TFrameIPCMonitorAll.UpdateTrace_ECS_kumo(var Msg: TMessage);
begin
  if FIsSetZeroWhenDisconnect then
    FPJHTimerPool.AddOneShot(OnSetZeroECS_kumo,5000);

  TECS_kumo_Method(TIPCMonitorClass(FIPCMonitorList.Objects[Msg.WParam]).FIPCMethod).OverRide_ECS_kumo2(Msg.WParam);
//  OverRide_ECS_kumo2(FECSData_kumo);
end;

procedure TFrameIPCMonitorAll.UpdateTrace_ECS_Woodward(
  var Msg: TMessage);
begin
  if FIsSetZeroWhenDisconnect then
    FPJHTimerPool.AddOneShot(OnSetZeroECS_Woodward,5000);

  TECS_Woodward_Method(TIPCMonitorClass(FIPCMonitorList.Objects[Msg.WParam]).FIPCMethod).OverRide_ECS_Woodward(Msg.WParam);
//  OverRide_ECS_Woodward(FECSData_Woodward);
end;

procedure TFrameIPCMonitorAll.UpdateTrace_EngineParam(
  var Msg: TMessage);
begin
  if FIsSetZeroWhenDisconnect then
    FPJHTimerPool.AddOneShot(OnSetZeroEngineParam,5000);

  TEngineParam_Method(TIPCMonitorClass(FIPCMonitorList.Objects[Msg.WParam]).FIPCMethod).OverRide_EngineParam(Msg.WParam);
//  OverRide_EngineParam(FEngineParamData);
end;

procedure TFrameIPCMonitorAll.UpdateTrace_FlowMeter(var Msg: TMessage);
begin
  if FIsSetZeroWhenDisconnect then
    FPJHTimerPool.AddOneShot(OnSetZeroFlowMeter,5000);

  TFlowMeter_Method(TIPCMonitorClass(FIPCMonitorList.Objects[Msg.WParam]).FIPCMethod).OverRide_FlowMeter(Msg.WParam);
//  OverRide_FlowMeter(FFlowMeterData);
end;

procedure TFrameIPCMonitorAll.UpdateTrace_GasCalc(var Msg: TMessage);
begin
  if FIsSetZeroWhenDisconnect then
    FPJHTimerPool.AddOneShot(OnSetZeroGasCalc,5000);

  TGasCalc_Method(TIPCMonitorClass(FIPCMonitorList.Objects[Msg.WParam]).FIPCMethod).OverRide_GasCalc(Msg.WParam);
//  OverRide_GasCalc(FGasCalcData);
end;

procedure TFrameIPCMonitorAll.UpdateTrace_HIC(var Msg: TMessage);
begin
  if FIsSetZeroWhenDisconnect then
    FPJHTimerPool.AddOneShot(OnSetZeroHIC,5000);

  THIC_Method(TIPCMonitorClass(FIPCMonitorList.Objects[Msg.WParam]).FIPCMethod).OverRide_HIC(Msg.WParam);
//  OverRide_HIC(FHICData);
end;

procedure TFrameIPCMonitorAll.UpdateTrace_KRAL(var Msg: TMessage);
begin
  if FIsSetZeroWhenDisconnect then
    FPJHTimerPool.AddOneShot(OnSetZeroKRAL,5000);

  TKRAL_Method(TIPCMonitorClass(FIPCMonitorList.Objects[Msg.WParam]).FIPCMethod).OverRide_KRAL(Msg.WParam);
//  OverRide_KRAL(FKRALData);
end;

procedure TFrameIPCMonitorAll.UpdateTrace_LBX(var Msg: TMessage);
begin
  if FIsSetZeroWhenDisconnect then
    FPJHTimerPool.AddOneShot(OnSetZeroLBX,5000);

  TLBX_Method(TIPCMonitorClass(FIPCMonitorList.Objects[Msg.WParam]).FIPCMethod).OverRide_LBX(Msg.WParam);
//  OverRide_LBX(FLBXData);
end;

procedure TFrameIPCMonitorAll.UpdateTrace_MEXA7000(var Msg: TMessage);
begin
  if FIsSetZeroWhenDisconnect then
    FPJHTimerPool.AddOneShot(OnSetZeroMEXA7000,5000);

  TMEXA7000_Method(TIPCMonitorClass(FIPCMonitorList.Objects[Msg.WParam]).FIPCMethod).OverRide_MEXA7000(Msg.WParam);
//  OverRide_MEXA7000(FMEXA7000Data);
end;

procedure TFrameIPCMonitorAll.UpdateTrace_MT210(var Msg: TMessage);
begin
  if FIsSetZeroWhenDisconnect then
    FPJHTimerPool.AddOneShot(OnSetZeroMT210,5000);

  TMT210_Method(TIPCMonitorClass(FIPCMonitorList.Objects[Msg.WParam]).FIPCMethod).OverRide_MT210(Msg.WParam);
//  OverRide_MT210(FMT210Data);
end;

procedure TFrameIPCMonitorAll.UpdateTrace_PLCMODBUS(
  var Msg: TMessage);
begin
  if FIsSetZeroWhenDisconnect then
    FPJHTimerPool.AddOneShot(OnSetZeroPLCMODBUS,5000);

  TPLCMODBUS_Method(TIPCMonitorClass(FIPCMonitorList.Objects[Msg.WParam]).FIPCMethod).OverRide_PLCMODBUS(Msg.WParam);
//  OverRide_PLCMODBUS(FPLCModbusData);
end;

procedure TFrameIPCMonitorAll.UpdateTrace_PLC_S7(var Msg: TMessage);
begin
  if FIsSetZeroWhenDisconnect then
    FPJHTimerPool.AddOneShot(OnSetZeroPLC_S7,5000);

  TPLC_S7_Method(TIPCMonitorClass(FIPCMonitorList.Objects[Msg.WParam]).FIPCMethod).OverRide_PLC_S7(Msg.WParam);
//  OverRide_PLC_S7(FPLCData_S7);
end;

procedure TFrameIPCMonitorAll.UpdateTrace_PMS(var Msg: TMessage);
begin
  if FIsSetZeroWhenDisconnect then
    FPJHTimerPool.AddOneShot(OnSetZeroPMS,5000);

  TPMS_Method(TIPCMonitorClass(FIPCMonitorList.Objects[Msg.WParam]).FIPCMethod).OverRide_PMS(Msg.WParam);
//  OverRide_PMS(FPMSData);
end;

procedure TFrameIPCMonitorAll.UpdateTrace_WT1600(var Msg: TMessage);
begin
  if FIsSetZeroWhenDisconnect then
    FPJHTimerPool.AddOneShot(OnSetZeroWT1600,5000);

  TWT1600_Method(TIPCMonitorClass(FIPCMonitorList.Objects[Msg.WParam]).FIPCMethod).OverRide_WT1600(Msg.WParam);
//  OverRide_WT1600(FWT1600Data);
end;

procedure TFrameIPCMonitorAll.Value2Screen_ECS_AVAT(AHiMap: THiMap; AEPIndex,
  AModbusMode: integer);
var
  Le: Single;
  LIsFloat: boolean;
  LStr: string;
  //LRadix: integer;
begin
  if AHiMap.FAlarm then //Analog data
  begin
    if AModbusMode = 3 then
      Le := AHiMap.FValue
    else
      Le := AHiMap.FValue * AHiMap.FMaxval;

    LIsFloat := IsFloat(Le);

    if LIsFloat then
    begin
      if FEngineParameter.EngineParameterCollect.Items[AEPIndex].RadixPosition > 1 then
        LStr := IntToStr(FEngineParameter.EngineParameterCollect.Items[AEPIndex].RadixPosition)
      else
        LStr := '1';

      //LRadix := FEngineParameter.EngineParameterCollect.Items[i].RadixPosition;

      FEngineParameter.EngineParameterCollect.Items[AEPIndex].Value := format('%.'+LStr+'f',[Le]);
    end
    else
      FEngineParameter.EngineParameterCollect.Items[AEPIndex].Value := IntToStr(Round(Le));

    WatchValue2Screen_Analog(AHiMap.FName, '', AEPIndex);
  end
  else //Digital data
  begin

  end;
end;

//AModbusMode = 3 Rtu mode simulate
procedure TFrameIPCMonitorAll.Value2Screen_ECS_kumo(AHiMap: THiMap; AEPIndex,
  AModbusMode: integer);
var
  Le: Single;
begin
  if AHiMap.FAlarm then //Analog data
  begin
    if AModbusMode = 3 then
      Le := AHiMap.FValue
    else
      Le := (AHiMap.FValue * AHiMap.FMaxval) / 4095;

    if (AHiMap.FName = 'AI_ENGINERPM') then //Engine RPM
    begin
      FEngineParameter.EngineParameterCollect.Items[AEPIndex].Value := IntToStr(Round(Le));
    end
    else if (AHiMap.FName = 'AI_TC_A_RPM') or (AHiMap.FName = 'AI_TC_B_RPM') then
    begin
      FEngineParameter.EngineParameterCollect.Items[AEPIndex].Value := IntToStr(Round(Le));
    end
    else
    begin
      FEngineParameter.EngineParameterCollect.Items[AEPIndex].Value := IntToStr(Round(Le));
    end;

    WatchValue2Screen_Analog(AHiMap.FName, '', AEPIndex);
  end
  else //Digital data
  begin

  end;
end;

procedure TFrameIPCMonitorAll.Value2Screen_ECS_kumo2(AEPIndex,
  AModbusMode: integer);
var
  Le: Single;
  LStr: string;
begin
  if FEngineParameter.EngineParameterCollect.Items[AEPIndex].Alarm then //Analog data
  begin
    LStr := FEngineParameter.EngineParameterCollect.Items[AEPIndex].TagName;
    WatchValue2Screen_Analog(LStr, '', AEPIndex);
  end
  else //Digital data
  begin

  end;
end;

procedure TFrameIPCMonitorAll.Value2Screen_ECS_Woodward(AEPIndex: integer;
  AModbusMode: integer);
var
  Le: Single;
  LStr: string;
begin
  if FEngineParameter.EngineParameterCollect.Items[AEPIndex].Alarm then //Analog data
  begin
    LStr := FEngineParameter.EngineParameterCollect.Items[AEPIndex].TagName;
    WatchValue2Screen_Analog(LStr, '', AEPIndex);
  end
  else //Digital data
  begin
    LStr := FEngineParameter.EngineParameterCollect.Items[AEPIndex].TagName;
    WatchValue2Screen_Digital(LStr, '', AEPIndex);
  end;
end;

procedure TFrameIPCMonitorAll.Value2Screen_KRAL;
var
  i, dcount, LValue1, LValue2: integer;
  Le: Single;
  LStr: string;
begin
  dcount := FEngineParameter.EngineParameterCollect.Count div 2;

  for i := 0 to dcount - 1 do
  begin
    if FEngineParameter.EngineParameterCollect.Items[i].Alarm then //Analog data
    begin
      LValue1 := StrToIntDef(FEngineParameter.EngineParameterCollect.Items[i*2].Value,0);
      LValue2 := StrToIntDef(FEngineParameter.EngineParameterCollect.Items[i*2 + 1].Value,0);
      LValue1 := ((LValue1 shl 16) or LValue2);
      Le := LValue1 / 10;


    end
    else //Digital data
    begin

    end;
  end;
end;

procedure TFrameIPCMonitorAll.WatchValue2Screen_Analog(Name, AValue: string;
  AEPIndex: integer; AIsFloat: Boolean);
var
  tmpdouble: double;
  //tmpValue: string;
  i: integer;
begin
  if FEnterWatchValue2Screen then
    exit
  else
    FEnterWatchValue2Screen := True;

  try
    //tmpdouble := StrToFloatDef(TFrameIPCMonitorAll1.FEngineParameter.EngineParameterCollect.Items[AEPIndex].Value, 0.0);
    if Assigned(FWatchValue2Screen_AnalogEvent) then
      FWatchValue2Screen_AnalogEvent(Name, AValue, AEPIndex)
    else
    begin
      case FPageControl.ActivePageIndex of
        0: begin //Items
          FNextGrid.CellsByName['Value', AEPIndex] := AValue;//FEngineParameter.EngineParameterCollect.Items[AEPIndex].Value;

          if FEngineParameter.EngineParameterCollect.Items[AEPIndex].DisplayUnit then
            if FEngineParameter.EngineParameterCollect.Items[AEPIndex].FFUnit <> '' then
              FNextGrid.CellsByName['Value', AEPIndex] := FNextGrid.CellsByName['Value', AEPIndex] + ' ' + FEngineParameter.EngineParameterCollect.Items[AEPIndex].FFUnit;
        end;
      end;
    end;
  finally
    FEnterWatchValue2Screen := False;
  end;
end;

procedure TFrameIPCMonitorAll.WatchValue2Screen_Digital(Name, AValue: string;
  AEPIndex: integer);
begin
  if FEnterWatchValue2Screen then
    exit
  else
    FEnterWatchValue2Screen := True;

  try
    if Assigned(FWatchValue2Screen_DigitalEvent) then
      FWatchValue2Screen_DigitalEvent(Name, AValue, AEPIndex)
    else
    begin
      if not Assigned(FPageControl) then
        exit;

      case FPageControl.ActivePageIndex of
        0: begin //Items
          if not Assigned(FNextGrid) then
            exit;

          if FEngineParameter.EngineParameterCollect.Items[AEPIndex].Value = '0' then
            FNextGrid.CellsByName['Value', AEPIndex] := 'False'
          else
            FNextGrid.CellsByName['Value', AEPIndex] := 'True';//FEngineParameter.EngineParameterCollect.Items[AEPIndex].Value;
        end;
      end;
    end;
  finally
    FEnterWatchValue2Screen := False;
  end;
end;

{
procedure TFrameIPCMonitorAll.WMCopyData(var Msg: TMessage);
begin
 if Msg.WParam = 2 then //User Level Receive
  begin
    FCurrentUserLevel := THiMECSUserLevel(PCopyDataStruct(Msg.LParam)^.cbData);
  end
  else
    CreateIPCMonitor(PEngineParameterItemRecord(PCopyDataStruct(Msg.LParam)^.lpData)^);
end;
}

//procedure TFrameIPCMonitorAll.WT1600_OnSignal(Data: TEventData_WT1600);
//var
//  LStr: string;
//  i: integer;
//begin
//  LStr := GetCombinedNamePSandSM(psWT1600);
//  i := FIPCMonitorList.IndexOf(LStr);
//
//  if i <> -1 then
//  begin
//    with TEventData_WT1600(TIPCMonitor<TEventData_WT1600>(FIPCMonitorList.Objects[i]).FEventDataRecord) do
//    begin
//      PSIGMA := String(Data.PSIGMA);
//      SSIGMA := String(Data.SSIGMA);
//      QSIGMA := String(Data.QSIGMA);
//      URMS1 := String(Data.URMS1);
//      URMS2 := String(Data.URMS2);
//      URMS3 := String(Data.URMS3);
//      IRMS1 := String(Data.IRMS1);
//      IRMS2 := String(Data.IRMS2);
//      IRMS3 := String(Data.IRMS3);
//      RAMDA := String(Data.RAMDA);
//      IRMSAVG := Data.IRMSAVG;
//      URMSAVG := Data.URMSAVG;
//      F1 := Data.F1;
//      FREQUENCY := String(Data.FREQUENCY);
//    end;
//  end;
//  FWT1600Data.PSIGMA := String(Data.PSIGMA);
//  FWT1600Data.SSIGMA := String(Data.SSIGMA);
//  FWT1600Data.QSIGMA := String(Data.QSIGMA);
//  FWT1600Data.URMS1 := String(Data.URMS1);
//  FWT1600Data.URMS2 := String(Data.URMS2);
//  FWT1600Data.URMS3 := String(Data.URMS3);
//  FWT1600Data.IRMS1 := String(Data.IRMS1);
//  FWT1600Data.IRMS2 := String(Data.IRMS2);
//  FWT1600Data.IRMS3 := String(Data.IRMS3);
//  FWT1600Data.RAMDA := String(Data.RAMDA);
//  FWT1600Data.IRMSAVG := Data.IRMSAVG;
//  FWT1600Data.URMSAVG := Data.URMSAVG;
//  FWT1600Data.F1 := Data.F1;
//  FWT1600Data.FREQUENCY := String(Data.FREQUENCY);

//  SendMessage(Handle, WM_EVENT_WT1600, i,0);
//  CommonCommunication(psWT1600);
//end;

{ TIPCMonitorClass }

constructor TIPCMonitorClass.create;
begin
  inherited;
end;

destructor TIPCMonitorClass.destroy;
var
  i: integer;
begin
//  TIPCMonitor(FIPCObject^).Free;

  inherited;
end;

{ TECS_ComAP_Method }

constructor TECS_ComAP_Method.create(AIPCAll: TFrameIPCMonitorAll);
begin
  FIPCAll := AIPCAll;
end;

destructor TECS_ComAP_Method.destroy;
begin

  inherited;
end;

procedure TECS_ComAP_Method.ECS_OnSignal_ComAP(
  Data: TEventData_Modbus_Standard);
var
  i,j,dcount: integer;
begin
  if FECS_OnSignal then
    exit;

  FECS_OnSignal := True;

  j := FIPCAll.FIPCMonitorList.IndexOf(FPSnSN);

  if j <> -1 then
  begin
    with TEventData_Modbus_Standard(TIPCMonitor<TEventData_Modbus_Standard>(FIPCAll.FIPCMonitorList.Objects[j]).FEventDataRecord) do
    begin
      dcount := 0;
      FillChar(InpDataBuf[0], High(InpDataBuf) - 1, #0);
      ModBusMode := Data.ModBusMode;

      if Data.ModBusMode = 0 then //ASCII Mode이면
      begin
        dcount := Data.NumOfData;
        NumOfBit := Data.NumOfBit;

        for i := 0 to dcount - 1 do
          InpDataBuf[i] := Data.InpDataBuf[i];
      end
      else
      if Data.ModBusMode = 1 then// RTU Mode 이면
      begin
        dcount := Data.NumOfData div 2;
        NumOfBit := Data.NumOfBit;

        if dcount = 0 then
          Inc(dcount);

        for i := 0 to dcount - 1 do
        begin
          InpDataBuf[i] := Data.InpDataBuf2[i*2] ;
          InpDataBuf[i] := InpDataBuf[i] shl 8 + Data.InpDataBuf2[i*2 + 1];
        end;

        if (Data.NumOfData mod 2) > 0 then
          InpDataBuf[i] := Data.InpDataBuf2[i*2] ;
      end//Data.ModBusMode = 1
      else
      if (Data.ModBusMode = 4) then //MODBUSTCP_MODE 이면
      begin
        dcount := Data.NumOfData;
        NumOfBit := Data.NumOfBit;
        System.Move(Data.InpDataBuf, InpDataBuf, Sizeof(Data.InpDataBuf));
      end
      else
      if (Data.ModBusMode = 3) then //simulate from csv file
      begin
        dcount := Data.NumOfData;
        NumOfBit := Data.NumOfBit;
        System.Move(Data.InpDataBuf_double, InpDataBuf_double, Sizeof(Data.InpDataBuf_double));
      end//Data.ModBusMode = 3
      else
      if (Data.ModBusMode = 5) then//MODBUSSERIAL_TCP_MODE
      begin
        dcount := Data.NumOfData;
        NumOfBit := Data.NumOfBit;
        System.Move(Data.InpDataBuf, InpDataBuf, Sizeof(Data.InpDataBuf));
      end;

      ModBusAddress := Data.ModBusAddress;
      BlockNo := Data.BlockNo;
      NumOfData := dcount;
      ModBusFunctionCode := Data.ModBusFunctionCode;
      ModBusMapFileName := Data.ModBusMapFileName;
//      FModBusMapFileName := Data.ModBusMapFileName;

//      DisplayMessage2SB(FStatusBar, ModBusAddress + ' 데이타 도착');

//      SendMessage(FIPCAll.Handle, WM_EVENT_ECS_COMAP, j,0);
      OverRide_ECS_ComAP(j);
      CommonCommunication(psECS_ComAP);
    end;
  end;

  FECS_OnSignal := False;
end;

procedure TECS_ComAP_Method.OverRide_ECS_ComAP(AIndex: integer);
var
  i,j,k: integer;
  Le: double;
  LRadix: integer;
  LECSData_ComAP: TEventData_Modbus_Standard;
begin
  LECSData_ComAP := TEventData_Modbus_Standard(TIPCMonitor<TEventData_Modbus_Standard>(FIPCAll.FIPCMonitorList.Objects[AIndex]).FEventDataRecord);

  if (LECSData_ComAP.ModBusFunctionCode = 1) or (LECSData_ComAP.ModBusFunctionCode = 2)
    or (LECSData_ComAP.ModBusFunctionCode = 3) or (LECSData_ComAP.ModBusFunctionCode = 4) then
  begin
    for k := 0 to FIPCAll.FEngineParameter.EngineParameterCollect.Count - 1 do
    begin
      if FIPCAll.FEngineParameter.EngineParameterCollect.Items[k].ParameterSource = psECS_ComAP then
      begin
        if LECSData_ComAP.BlockNo <> FIPCAll.FEngineParameter.EngineParameterCollect.Items[k].BlockNo then
          Continue;

        //AbsoluteIndex에 Modbus Map에서 각 Request별 위치 정보(공유메모리상의 Index)
        i := FIPCAll.FEngineParameter.EngineParameterCollect.Items[k].AbsoluteIndex;

        if FIPCAll.FEngineParameter.EngineParameterCollect.Items[k].Alarm then //Analog data
        begin
          if LECSData_ComAP.ModBusMode = 3 then //simulate from csv
          begin
            Le := LECSData_ComAP.InpDataBuf_double[i];
          end
          else
          begin
            case FIPCAll.FEngineParameter.EngineParameterCollect.Items[k].MinMaxType of
              mmtInteger: begin
                if FIPCAll.FEngineParameter.EngineParameterCollect.Items[k].MaxValue > 0 then
                  Le := LECSData_ComAP.InpDataBuf[i]/FIPCAll.FEngineParameter.EngineParameterCollect.Items[k].MaxValue
                else
                  Le := LECSData_ComAP.InpDataBuf[i];
              end;
              mmtReal: begin
                if FIPCAll.FEngineParameter.EngineParameterCollect.Items[k].MaxValue_Real > 0.0 then
                  Le := LECSData_ComAP.InpDataBuf[i]/FIPCAll.FEngineParameter.EngineParameterCollect.Items[k].MaxValue_Real
                else
                  Le := LECSData_ComAP.InpDataBuf[i];
              end;
            end;//case
          end;

//          LRadix := FIPCAll.FEngineParameter.EngineParameterCollect.Items[k].RadixPosition;

          FIPCAll.FEngineParameter.EngineParameterCollect.Items[k].Value := FormatFloat(FIPCAll.FEngineParameter.EngineParameterCollect.Items[k].DisplayFormat, Le);
//          FEngineParameter.EngineParameterCollect.Items[k].Value := FloatToStrF(Le, ffFixed, 12, LRadix);//,'%.2f');
        end
        else //Digital data
        begin
          i := FIPCAll.FEngineParameter.EngineParameterCollect.Items[k].AbsoluteIndex;

          j := FIPCAll.FEngineParameter.EngineParameterCollect.Items[k].RadixPosition;
          //0이 아니면 True임
          FIPCAll.FEngineParameter.EngineParameterCollect.Items[k].Value := IntToStr(GetBitVal(LECSData_ComAP.InpDataBuf[i], j));
        end;

                  //수신된 데이타를 화면에 뿌려줌
        FIPCAll.Value2Screen_ECS_Woodward(k,LECSData_ComAP.ModBusMode);
      end;
    end;//for
  end;
end;

{ TWT1600_Method }

constructor TWT1600_Method.create(AIPCAll: TFrameIPCMonitorAll);
begin
  FIPCAll := AIPCAll;
end;

destructor TWT1600_Method.destroy;
begin

  inherited;
end;

procedure TWT1600_Method.OverRide_WT1600(AIndex: integer);
var
  i, LRadix, LMaxVal: integer;
  LDouble: double;
  LDataOk: boolean;
  FWT1600Data: TEventData_WT1600;
begin
  FWT1600Data := TEventData_WT1600(TIPCMonitor<TEventData_WT1600>(FIPCAll.FIPCMonitorList.Objects[AIndex]).FEventDataRecord);

  LDataOk := False;

  for i := 0 to FIPCAll.FEngineParameter.EngineParameterCollect.Count - 1 do
  begin
    if FIPCAll.FEngineParameter.EngineParameterCollect.Items[i].ParameterSource = psWT1600 then
    begin
//      LRadix := FIPCAll.FEngineParameter.EngineParameterCollect.Items[i].RadixPosition;
      LMaxVal := FIPCAll.FEngineParameter.EngineParameterCollect.Items[i].MaxValue;

      if LMaxVal = 0 then
        LMaxVal := 1;

      if UpperCase(FIPCAll.FEngineParameter.EngineParameterCollect.Items[i].TagName) = UpperCase('PSIGMA') then
      begin
        LDouble := StrToFloatDef(FWT1600Data.PSIGMA,0.0);
//        FIPCAll.FEngineParameter.EngineParameterCollect.Items[i].Value := FloatToStrF(LDouble/LMaxVal, ffFixed, 12, LRadix) //Format('%.2f', [LDouble/1000]);
      end
      else if UpperCase(FIPCAll.FEngineParameter.EngineParameterCollect.Items[i].TagName) = UpperCase('SSIGMA') then
      begin
        LDouble := StrToFloatDef(FWT1600Data.SSIGMA,0.0);
//        FIPCAll.FEngineParameter.EngineParameterCollect.Items[i].Value := FloatToStrF(LDouble/LMaxVal, ffFixed, 12, LRadix) //Format('%.2f', [LDouble/1000]);
      end
      else if UpperCase(FIPCAll.FEngineParameter.EngineParameterCollect.Items[i].TagName) = UpperCase('QSIGMA') then
      begin
        LDouble := StrToFloatDef(FWT1600Data.QSIGMA,0.0);
//        FIPCAll.FEngineParameter.EngineParameterCollect.Items[i].Value := FloatToStrF(LDouble/LMaxVal, ffFixed, 12, LRadix) //Format('%.2f', [LDouble/1000]);
      end
      else if UpperCase(FIPCAll.FEngineParameter.EngineParameterCollect.Items[i].TagName) = UpperCase('URMS1') then
      begin
        LDouble := StrToFloatDef(FWT1600Data.URMS1,0.0);
//        FIPCAll.FEngineParameter.EngineParameterCollect.Items[i].Value := FloatToStrF(LDouble/LMaxVal, ffFixed, 12, LRadix);
      end
      else if UpperCase(FIPCAll.FEngineParameter.EngineParameterCollect.Items[i].TagName) = UpperCase('URMS2') then
      begin
        LDouble := StrToFloatDef(FWT1600Data.URMS2,0.0);
//        FIPCAll.FEngineParameter.EngineParameterCollect.Items[i].Value := FloatToStrF(LDouble/LMaxVal, ffFixed, 12, LRadix);
      end
      else if UpperCase(FIPCAll.FEngineParameter.EngineParameterCollect.Items[i].TagName) = UpperCase('URMS3') then
      begin
        LDouble := StrToFloatDef(FWT1600Data.URMS3,0.0);
//        FIPCAll.FEngineParameter.EngineParameterCollect.Items[i].Value := FloatToStrF(LDouble/LMaxVal, ffFixed, 12, LRadix);
      end
      else if UpperCase(FIPCAll.FEngineParameter.EngineParameterCollect.Items[i].TagName) = UpperCase('IRMS1') then
      begin
        LDouble := StrToFloatDef(FWT1600Data.IRMS1,0.0);
//        FIPCAll.FEngineParameter.EngineParameterCollect.Items[i].Value := FloatToStrF(LDouble/LMaxVal, ffFixed, 12, LRadix);
      end
      else if UpperCase(FIPCAll.FEngineParameter.EngineParameterCollect.Items[i].TagName) = UpperCase('IRMS2') then
      begin
        LDouble := StrToFloatDef(FWT1600Data.IRMS2,0.0);
//        FIPCAll.FEngineParameter.EngineParameterCollect.Items[i].Value :=FloatToStrF(LDouble/LMaxVal, ffFixed, 12, LRadix);
      end
      else if UpperCase(FIPCAll.FEngineParameter.EngineParameterCollect.Items[i].TagName) = UpperCase('IRMS3') then
      begin
        LDouble := StrToFloatDef(FWT1600Data.IRMS3,0.0);
//        FIPCAll.FEngineParameter.EngineParameterCollect.Items[i].Value := FloatToStrF(LDouble/LMaxVal, ffFixed, 12, LRadix);
      end
      else if UpperCase(FIPCAll.FEngineParameter.EngineParameterCollect.Items[i].TagName) = UpperCase('URMSAVG') then
      begin
        LDouble := StrToFloatDef(FWT1600Data.URMSAVG,0.0);
//        FIPCAll.FEngineParameter.EngineParameterCollect.Items[i].Value := String(FWT1600Data.URMSAVG);
      end
      else if UpperCase(FIPCAll.FEngineParameter.EngineParameterCollect.Items[i].TagName) = UpperCase('IRMSAVG') then
      begin
        LDouble := StrToFloatDef(FWT1600Data.IRMSAVG,0.0);
//        FIPCAll.FEngineParameter.EngineParameterCollect.Items[i].Value := String(FWT1600Data.IRMSAVG);
      end
      else if UpperCase(FIPCAll.FEngineParameter.EngineParameterCollect.Items[i].TagName) = UpperCase('RAMDA') then
      begin
        LDouble := StrToFloatDef(FWT1600Data.RAMDA,0.0);
//        FIPCAll.FEngineParameter.EngineParameterCollect.Items[i].Value := String(FWT1600Data.RAMDA);
      end
      else if UpperCase(FIPCAll.FEngineParameter.EngineParameterCollect.Items[i].TagName) = UpperCase('F1') then
      begin
        LDouble := StrToFloatDef(FWT1600Data.F1,0.0);
//        FIPCAll.FEngineParameter.EngineParameterCollect.Items[i].Value := String(FWT1600Data.F1);
      end
      else if UpperCase(FIPCAll.FEngineParameter.EngineParameterCollect.Items[i].TagName) = UpperCase('FREQUENCY') then
      begin
        LDouble := StrToFloatDef(FWT1600Data.FREQUENCY,0.0);
//        FIPCAll.FEngineParameter.EngineParameterCollect.Items[i].Value := String(FWT1600Data.FREQUENCY);
      end;

      FIPCAll.FEngineParameter.EngineParameterCollect.Items[i].Value := FormatFloat(FIPCAll.FEngineParameter.EngineParameterCollect.Items[i].DisplayFormat,LDouble/LMaxVal);
//      FIPCAll.FEngineParameter.EngineParameterCollect.Items[i].Value := FloatToStrF(LDouble/LMaxVal, ffFixed, 12, LRadix);
      FIPCAll.WatchValue2Screen_Analog('', '',i);
      LDataOk := True;
    end;
  end;//for

  //상속 받은 자손에서 구현할 것
  {if LDataOk then
  begin
    Timer1.Enabled := True;
    FPJHTimerPool.AddOneShot(OnTrigger4AvgSave,2000);
    DataSaveByEvent;
  end;
  }
end;

procedure TWT1600_Method.WT1600_OnSignal(Data: TEventData_WT1600);
var
  i: integer;
begin
  i := FIPCAll.FIPCMonitorList.IndexOf(FPSnSN);

  if i <> -1 then
  begin
    with TEventData_WT1600(TIPCMonitor<TEventData_WT1600>(FIPCAll.FIPCMonitorList.Objects[i]).FEventDataRecord) do
    begin
      PSIGMA := String(Data.PSIGMA);
      SSIGMA := String(Data.SSIGMA);
      QSIGMA := String(Data.QSIGMA);
      URMS1 := String(Data.URMS1);
      URMS2 := String(Data.URMS2);
      URMS3 := String(Data.URMS3);
      IRMS1 := String(Data.IRMS1);
      IRMS2 := String(Data.IRMS2);
      IRMS3 := String(Data.IRMS3);
      RAMDA := String(Data.RAMDA);
      IRMSAVG := Data.IRMSAVG;
      URMSAVG := Data.URMSAVG;
      F1 := Data.F1;
      FREQUENCY := String(Data.FREQUENCY);
    end;
  end;

  SendMessage(FIPCAll.Handle, WM_EVENT_WT1600, i,0);
  CommonCommunication(psWT1600);
end;

{ TMEXA7000_Method }

constructor TMEXA7000_Method.create(AIPCAll: TFrameIPCMonitorAll);
begin
  FIPCAll := AIPCAll;
end;

destructor TMEXA7000_Method.destroy;
begin

  inherited;
end;

procedure TMEXA7000_Method.MEXA7000_OnSignal(Data: TEventData_MEXA7000);
var
  i,j,dcount: integer;
begin
  j := FIPCAll.FIPCMonitorList.IndexOf(FPSnSN);

  if j <> -1 then
  begin
    with TEventData_MEXA7000(TIPCMonitor<TEventData_MEXA7000>(FIPCAll.FIPCMonitorList.Objects[j]).FEventDataRecord) do
    begin
//      CO2 := StrToFloatDef(Data.CO2,0.0);
//      CO_L := StrToFloatDef(Data.CO_L,0.0);
//      O2 := StrToFloatDef(Data.O2,0.0);
//      NOx := StrToFloatDef(Data.NOx,0.0);
//      THC := StrToFloatDef(Data.THC,0.0);
//      CH4 := StrToFloatDef(Data.CH4,0.0);
//      non_CH4 := StrToFloatDef(Data.non_CH4,0.0);
//      CollectedValue := Data.CollectedValue;

      SendMessage(FIPCAll.Handle, WM_EVENT_MEXA7000, j,0);
      CommonCommunication(psMEXA7000);
    end;
  end;
end;

procedure TMEXA7000_Method.OverRide_MEXA7000(AIndex: integer);
var
  i, LRadix: integer;
  LDataOk: Boolean;
  FMEXA7000Data: TEventData_MEXA7000_2;
begin
  FMEXA7000Data := TEventData_MEXA7000_2(TIPCMonitor<TEventData_MEXA7000_2>(FIPCAll.FIPCMonitorList.Objects[AIndex]).FEventDataRecord);

  for i := 0 to FIPCAll.FEngineParameter.EngineParameterCollect.Count - 1 do
  begin
    if FIPCAll.FEngineParameter.EngineParameterCollect.Items[i].ParameterSource = psMEXA7000 then
    begin
//      LRadix := FIPCAll.FEngineParameter.EngineParameterCollect.Items[i].RadixPosition;

      if UpperCase(FIPCAll.FEngineParameter.EngineParameterCollect.Items[i].TagName) = UpperCase('CO2') then
        FIPCAll.FEngineParameter.EngineParameterCollect.Items[i].Value := FormatFloat(FIPCAll.FEngineParameter.EngineParameterCollect.Items[i].DisplayFormat,FMEXA7000Data.CO2/10000) //FloatToStr(FMEXA7000Data.CO2/10000)
      else if UpperCase(FIPCAll.FEngineParameter.EngineParameterCollect.Items[i].TagName) = UpperCase('CO_L') then
        FIPCAll.FEngineParameter.EngineParameterCollect.Items[i].Value := FormatFloat(FIPCAll.FEngineParameter.EngineParameterCollect.Items[i].DisplayFormat,FMEXA7000Data.CO_L) //FloatToStr(FMEXA7000Data.CO_L)
      else if UpperCase(FIPCAll.FEngineParameter.EngineParameterCollect.Items[i].TagName) = UpperCase('O2') then
        FIPCAll.FEngineParameter.EngineParameterCollect.Items[i].Value := FormatFloat(FIPCAll.FEngineParameter.EngineParameterCollect.Items[i].DisplayFormat,FMEXA7000Data.O2/10000) //FloatToStr(FMEXA7000Data.O2/10000)
      else if UpperCase(FIPCAll.FEngineParameter.EngineParameterCollect.Items[i].TagName) = UpperCase('NOx') then
        FIPCAll.FEngineParameter.EngineParameterCollect.Items[i].Value := FormatFloat(FIPCAll.FEngineParameter.EngineParameterCollect.Items[i].DisplayFormat,FMEXA7000Data.NOx) //FloatToStr(FMEXA7000Data.NOx)
      else if UpperCase(FIPCAll.FEngineParameter.EngineParameterCollect.Items[i].TagName) = UpperCase('THC') then
        FIPCAll.FEngineParameter.EngineParameterCollect.Items[i].Value := FormatFloat(FIPCAll.FEngineParameter.EngineParameterCollect.Items[i].DisplayFormat,FMEXA7000Data.THC) //FloatToStr(FMEXA7000Data.THC)
      else if UpperCase(FIPCAll.FEngineParameter.EngineParameterCollect.Items[i].TagName) = UpperCase('CH4') then
        FIPCAll.FEngineParameter.EngineParameterCollect.Items[i].Value := FormatFloat(FIPCAll.FEngineParameter.EngineParameterCollect.Items[i].DisplayFormat,FMEXA7000Data.CH4) //FloatToStr(FMEXA7000Data.CH4)
      else if UpperCase(FIPCAll.FEngineParameter.EngineParameterCollect.Items[i].TagName) = UpperCase('non_CH4') then
        FIPCAll.FEngineParameter.EngineParameterCollect.Items[i].Value := FormatFloat(FIPCAll.FEngineParameter.EngineParameterCollect.Items[i].DisplayFormat,FMEXA7000Data.non_CH4) //FloatToStr(FMEXA7000Data.non_CH4)
      else if UpperCase(FIPCAll.FEngineParameter.EngineParameterCollect.Items[i].TagName) = UpperCase('CollectedValue') then
        FIPCAll.FEngineParameter.EngineParameterCollect.Items[i].Value := FormatFloat(FIPCAll.FEngineParameter.EngineParameterCollect.Items[i].DisplayFormat,FMEXA7000Data.CollectedValue); //FloatToStr(FMEXA7000Data.CollectedValue);

      FIPCAll.WatchValue2Screen_Analog('', '',i);
      LDataOk := True;
    end;
  end;

  //상속 받은 자손에서 구현할 것
  {if LDataOk then
  begin
    Timer1.Enabled := True;
    FPJHTimerPool.AddOneShot(OnTrigger4AvgSave,2000);
    DataSaveByEvent;
  end;
  }
end;

{ TMEXA700_2_Method }

constructor TMEXA700_2_Method.create(AIPCAll: TFrameIPCMonitorAll);
begin
  FIPCAll := AIPCAll;
end;

destructor TMEXA700_2_Method.destroy;
begin

  inherited;
end;

procedure TMEXA700_2_Method.MEXA7000_2_OnSignal(Data: TEventData_MEXA7000_2);
var
  i,j,dcount: integer;
begin
  j := FIPCAll.FIPCMonitorList.IndexOf(FPSnSN);

  if j <> -1 then
  begin
    with TEventData_MEXA7000_2(TIPCMonitor<TEventData_MEXA7000_2>(FIPCAll.FIPCMonitorList.Objects[j]).FEventDataRecord) do
    begin
      CO2 := Data.CO2;
      CO_L := Data.CO_L;
      O2 := Data.O2;
      NOx := Data.NOx;
      THC := Data.THC;
      CH4 := Data.CH4;
      non_CH4 := Data.non_CH4;
      CollectedValue := Data.CollectedValue;

      SendMessage(FIPCAll.Handle, WM_EVENT_MEXA7000, j,0);
      CommonCommunication(psMEXA7000);
    end;
  end;
end;

procedure TMEXA700_2_Method.OverRide_MEXA7000(AIndex: integer);
var
  i, LRadix: integer;
  LDataOk: Boolean;
  FMEXA7000Data: TEventData_MEXA7000_2;
begin
  FMEXA7000Data := TEventData_MEXA7000_2(TIPCMonitor<TEventData_MEXA7000_2>(FIPCAll.FIPCMonitorList.Objects[AIndex]).FEventDataRecord);

  for i := 0 to FIPCAll.FEngineParameter.EngineParameterCollect.Count - 1 do
  begin
    if FIPCAll.FEngineParameter.EngineParameterCollect.Items[i].ParameterSource = psMEXA7000 then
    begin
//      LRadix := FIPCAll.FEngineParameter.EngineParameterCollect.Items[i].RadixPosition;

      if UpperCase(FIPCAll.FEngineParameter.EngineParameterCollect.Items[i].TagName) = UpperCase('CO2') then
        FIPCAll.FEngineParameter.EngineParameterCollect.Items[i].Value := FormatFloat(FIPCAll.FEngineParameter.EngineParameterCollect.Items[i].DisplayFormat,FMEXA7000Data.CO2/10000) //FloatToStr(FMEXA7000Data.CO2/10000)
      else if UpperCase(FIPCAll.FEngineParameter.EngineParameterCollect.Items[i].TagName) = UpperCase('CO_L') then
        FIPCAll.FEngineParameter.EngineParameterCollect.Items[i].Value := FormatFloat(FIPCAll.FEngineParameter.EngineParameterCollect.Items[i].DisplayFormat,FMEXA7000Data.CO_L) //FloatToStr(FMEXA7000Data.CO_L)
      else if UpperCase(FIPCAll.FEngineParameter.EngineParameterCollect.Items[i].TagName) = UpperCase('O2') then
        FIPCAll.FEngineParameter.EngineParameterCollect.Items[i].Value := FormatFloat(FIPCAll.FEngineParameter.EngineParameterCollect.Items[i].DisplayFormat,FMEXA7000Data.O2/10000) //FloatToStr(FMEXA7000Data.O2/10000)
      else if UpperCase(FIPCAll.FEngineParameter.EngineParameterCollect.Items[i].TagName) = UpperCase('NOx') then
        FIPCAll.FEngineParameter.EngineParameterCollect.Items[i].Value := FormatFloat(FIPCAll.FEngineParameter.EngineParameterCollect.Items[i].DisplayFormat,FMEXA7000Data.NOx) //FloatToStr(FMEXA7000Data.NOx)
      else if UpperCase(FIPCAll.FEngineParameter.EngineParameterCollect.Items[i].TagName) = UpperCase('THC') then
        FIPCAll.FEngineParameter.EngineParameterCollect.Items[i].Value := FormatFloat(FIPCAll.FEngineParameter.EngineParameterCollect.Items[i].DisplayFormat,FMEXA7000Data.THC) //FloatToStr(FMEXA7000Data.THC)
      else if UpperCase(FIPCAll.FEngineParameter.EngineParameterCollect.Items[i].TagName) = UpperCase('CH4') then
        FIPCAll.FEngineParameter.EngineParameterCollect.Items[i].Value := FormatFloat(FIPCAll.FEngineParameter.EngineParameterCollect.Items[i].DisplayFormat,FMEXA7000Data.CH4) //FloatToStr(FMEXA7000Data.CH4)
      else if UpperCase(FIPCAll.FEngineParameter.EngineParameterCollect.Items[i].TagName) = UpperCase('non_CH4') then
        FIPCAll.FEngineParameter.EngineParameterCollect.Items[i].Value := FormatFloat(FIPCAll.FEngineParameter.EngineParameterCollect.Items[i].DisplayFormat,FMEXA7000Data.non_CH4) //FloatToStr(FMEXA7000Data.non_CH4)
      else if UpperCase(FIPCAll.FEngineParameter.EngineParameterCollect.Items[i].TagName) = UpperCase('CollectedValue') then
        FIPCAll.FEngineParameter.EngineParameterCollect.Items[i].Value := FormatFloat(FIPCAll.FEngineParameter.EngineParameterCollect.Items[i].DisplayFormat,FMEXA7000Data.CollectedValue); //FloatToStr(FMEXA7000Data.CollectedValue);

      FIPCAll.WatchValue2Screen_Analog('', '',i);
      LDataOk := True;
    end;
  end;

  //상속 받은 자손에서 구현할 것
  {if LDataOk then
  begin
    Timer1.Enabled := True;
    FPJHTimerPool.AddOneShot(OnTrigger4AvgSave,2000);
    DataSaveByEvent;
  end;
  }
end;

{ TMT210_Method }

constructor TMT210_Method.create(AIPCAll: TFrameIPCMonitorAll);
begin
  FIPCAll := AIPCAll;
end;

destructor TMT210_Method.destroy;
begin

  inherited;
end;

procedure TMT210_Method.MT210_OnSignal(Data: TEventData_MT210);
var
  i,j,dcount: integer;
begin
  j := FIPCAll.FIPCMonitorList.IndexOf(FPSnSN);

  if j <> -1 then
  begin
    with TEventData_MT210(TIPCMonitor<TEventData_MT210>(FIPCAll.FIPCMonitorList.Objects[j]).FEventDataRecord) do
    begin
      FData := Data.FData;
      SendMessage(FIPCAll.Handle, WM_EVENT_MT210, j,0);
      CommonCommunication(psMT210);
    end;
  end;
end;

procedure TMT210_Method.OverRide_MT210(AIndex: integer);
var
  i, LRadix: integer;
  LDataOk: Boolean;
  FMT210Data: TEventData_MT210;
begin
  FMT210Data := TEventData_MT210(TIPCMonitor<TEventData_MT210>(FIPCAll.FIPCMonitorList.Objects[AIndex]).FEventDataRecord);

  LDataOk := False;

  for i := 0 to FIPCAll.FEngineParameter.EngineParameterCollect.Count - 1 do
  begin
    if FIPCAll.FEngineParameter.EngineParameterCollect.Items[i].ParameterSource = psMT210 then
    begin
//      LRadix := FIPCAll.FEngineParameter.EngineParameterCollect.Items[i].RadixPosition;

      FIPCAll.FEngineParameter.EngineParameterCollect.Items[i].Value := FormatFloat(FIPCAll.FEngineParameter.EngineParameterCollect.Items[i].DisplayFormat,FMT210Data.FData); //FloatToStr(FMT210Data.FData);
//      FIPCAll.FEngineParameter.EngineParameterCollect.Items[i].Value := FloatToStrF(FMT210Data.FData); //FloatToStr(FMT210Data.FData);
      FIPCAll.WatchValue2Screen_Analog('', '',i);
      LDataOk := True;
      break;
    end;
  end;//for

  //상속 받은 자손에서 구현할 것
  {if LDataOk then
  begin
    Timer1.Enabled := True;
    FPJHTimerPool.AddOneShot(OnTrigger4AvgSave,2000);
  end;
  }
end;

{ TECS_kumo_Method }

constructor TECS_kumo_Method.create(AIPCAll: TFrameIPCMonitorAll);
begin
  FIPCAll := AIPCAll;
end;

destructor TECS_kumo_Method.destroy;
begin

  inherited;
end;

procedure TECS_kumo_Method.ECS_OnSignal_kumo(Data: TEventData_ECS_kumo);
var
  i,j,dcount: integer;
begin
  j := FIPCAll.FIPCMonitorList.IndexOf(FPSnSN);

  if j <> -1 then
  begin
    with TEventData_ECS_kumo(TIPCMonitor<TEventData_ECS_kumo>(FIPCAll.FIPCMonitorList.Objects[j]).FEventDataRecord) do
    begin
      if not FIPCAll.FCompleteReadMap_kumo then
        exit;

      FillChar(InpDataBuf[0], High(InpDataBuf) - 1, #0);
      ModBusMode := Data.ModBusMode;

      if Data.ModBusMode = 0 then //ASCII Mode이면
      begin
        //ModePanel.Caption := 'ASCII Mode';
        dcount := Data.NumOfData;
        NumOfBit := Data.NumOfBit;

        for i := 0 to dcount - 1 do
          InpDataBuf[i] := Data.InpDataBuf[i];
      end
      else
      if Data.ModBusMode = 1 then// RTU Mode 이면
      begin
        //ModePanel.Caption := 'RTU Mode';
        //dcount := Data.NumOfData div 2;
        NumOfBit := Data.NumOfBit;

        //if dcount = 0 then
          //Inc(dcount);

        //for i := 0 to dcount - 1 do
        //begin
        System.Move(Data.InpDataBuf, InpDataBuf, Sizeof(Data.InpDataBuf));
          //InpDataBuf[i] := Data.InpDataBuf2[i*2] ;
          //InpDataBuf[i] := InpDataBuf[i] shl 8 + Data.InpDataBuf2[i*2 + 1];
        //end;

        if (Data.NumOfData mod 2) > 0 then
          InpDataBuf[i] := Data.InpDataBuf[i] ;
          //InpDataBuf[i] := Data.InpDataBuf2[i*2] ;
      end//Data.ModBusMode = 1
      else
      if (Data.ModBusMode = 3) then//simulation
      begin
        dcount := Data.NumOfData;
        NumOfBit := Data.NumOfBit;
        System.Move(Data.InpDataBuf_double, InpDataBuf_double, Sizeof(Data.InpDataBuf_double));
      end;//Data.ModBusMode = 3

      ModBusAddress := Data.ModBusAddress;
      BlockNo := Data.BlockNo;
      NumOfData := dcount;
      ModBusFunctionCode := Data.ModBusFunctionCode;
      ModBusMapFileName := Data.ModBusMapFileName;
      FIPCAll.FModBusMapFileName := Data.ModBusMapFileName;
      FIPCAll.DisplayMessage2SB(FIPCAll.FStatusBar, ModBusAddress + ' 데이타 도착');

      SendMessage(FIPCAll.Handle, WM_EVENT_ECS_KUMO, j,0);
      CommonCommunication(psECS_kumo);

    end;
  end;
end;

procedure TECS_kumo_Method.OverRide_ECS_kumo(AIndex: integer);
var
  it: DIterator;
  pHiMap: THiMap;
  i, j, k, BlockNo: integer;
  tmpStr: string;
  tmpByte, ProcessBitCnt: Byte;
  LDataOk: Boolean;
  FECSData_kumo: TEventData_ECS_kumo;
begin
  FECSData_kumo := TEventData_ECS_kumo(TIPCMonitor<TEventData_ECS_kumo>(FIPCAll.FIPCMonitorList.Objects[AIndex]).FEventDataRecord);

  BlockNo := 0;
  i := 0;
  j := 0;
  ProcessBitCnt := 0;
  LDataOk := False;

  if FECSData_kumo.ModBusMode = 3 then //RTU mode simulated
  begin
    it := FIPCAll.FAddressMap.start;
  end
  else
  begin
    tmpStr := IntToStr(FECSData_kumo.ModBusFunctionCode) + FECSData_kumo.ModBusAddress;
    it := FIPCAll.FAddressMap.locate( [tmpStr] );
  end;

  SetToValue(it);

  while not atEnd(it) do
  begin
    if i > FECSData_kumo.NumOfData - 1 then
      break;

    pHiMap := GetObject(it) as THiMap;

    if (FECSData_kumo.ModBusFunctionCode = 3) or (FECSData_kumo.ModBusFunctionCode = 4) then
    begin
      //BlockNo := pHiMap.FBlockNo;
      for k := 0 to FIPCAll.FEngineParameter.EngineParameterCollect.Count - 1 do
      begin
        if FIPCAll.FEngineParameter.EngineParameterCollect.Items[k].ParameterSource = psECS_kumo then
        begin
          if (IntToStr(FECSData_kumo.ModBusFunctionCode) = FIPCAll.FEngineParameter.EngineParameterCollect.Items[k].FCode) and
                    (pHiMap.FAddress = FIPCAll.FEngineParameter.EngineParameterCollect.Items[k].Address) then
          begin
            if FECSData_kumo.ModBusMode = 3 then
              pHiMap.FValue := FECSData_kumo.InpDataBuf_double[i]
            else
              pHiMap.FValue := FECSData_kumo.InpDataBuf[i];
            //수신된 데이타를 화면에 뿌려줌
            FIPCAll.Value2Screen_ECS_kumo(pHiMap,k,FECSData_kumo.ModBusMode);
            break;
          end;

          LDataOk := True;
        end;
      end;//for

      Inc(i);
      Advance(it);
    end;
  end;//while

  //상속 받은 자손에서 구현할 것
  {if LDataOk then
  begin
    Timer1.Enabled := True;
    FPJHTimerPool.AddOneShot(OnTrigger4AvgSave,2000);
    DataSaveByEvent;
  end;
  }
  FIPCAll.DisplayMessage2SB(FIPCAll.FStatusBar, FECSData_kumo.ModBusAddress + ' 처리중...');
end;

procedure TECS_kumo_Method.OverRide_ECS_kumo2(AIndex: integer);
var
  i,k: integer;
  Le: double;
  LRadix: integer;
  FECSData_kumo: TEventData_ECS_kumo;
begin
  FECSData_kumo := TEventData_ECS_kumo(TIPCMonitor<TEventData_ECS_kumo>(FIPCAll.FIPCMonitorList.Objects[AIndex]).FEventDataRecord);

  if (FECSData_kumo.ModBusFunctionCode = 3) or (FECSData_kumo.ModBusFunctionCode = 4) then
  begin
    for k := 0 to FIPCAll.FEngineParameter.EngineParameterCollect.Count - 1 do
    begin
      if FIPCAll.FEngineParameter.EngineParameterCollect.Items[k].ParameterSource = psECS_kumo then
      begin
        if FECSData_kumo.BlockNo <> FIPCAll.FEngineParameter.EngineParameterCollect.Items[k].BlockNo then
          Continue;

        i := FIPCAll.FEngineParameter.EngineParameterCollect.Items[k].AbsoluteIndex;

        if FIPCAll.FEngineParameter.EngineParameterCollect.Items[k].Alarm then //Analog data
        begin
          if FECSData_kumo.ModBusMode = 3 then
          begin
            Le := FECSData_kumo.InpDataBuf_double[i];
          end
          else
          begin
            Le := FECSData_kumo.InpDataBuf[i];
            Le := (Le * FIPCAll.FEngineParameter.EngineParameterCollect.Items[k].MaxValue) / 4095;
          end;

//          LRadix := FIPCAll.FEngineParameter.EngineParameterCollect.Items[k].RadixPosition;

          FIPCAll.FEngineParameter.EngineParameterCollect.Items[k].Value := FormatFloat(FIPCAll.FEngineParameter.EngineParameterCollect.Items[i].DisplayFormat,Le);
//          FIPCAll.FEngineParameter.EngineParameterCollect.Items[k].Value := FloatToStrF(Le, ffFixed, 12, LRadix);//,'%.2f');
        end;

        //수신된 데이타를 화면에 뿌려줌
        FIPCAll.Value2Screen_ECS_kumo2(k,FECSData_kumo.ModBusMode);
      end;
    end;//for
  end;
end;

{ TECS_AVAT_Method }

constructor TECS_AVAT_Method.create(AIPCAll: TFrameIPCMonitorAll);
begin
  FIPCAll := AIPCAll;
end;

destructor TECS_AVAT_Method.destroy;
begin

  inherited;
end;

procedure TECS_AVAT_Method.ECS_OnSignal_AVAT(Data: TEventData_ECS_AVAT);
var
  i,j,dcount: integer;
begin
  j := FIPCAll.FIPCMonitorList.IndexOf(FPSnSN);

  if j <> -1 then
  begin
    with TEventData_ECS_AVAT(TIPCMonitor<TEventData_ECS_AVAT>(FIPCAll.FIPCMonitorList.Objects[j]).FEventDataRecord) do
    begin

      if not FIPCAll.FCompleteReadMap_Avat then
        exit;

      dcount := 0;
      FillChar(InpDataBuf[0], High(InpDataBuf) - 1, #0);
      ModBusMode := Data.ModBusMode;

      if Data.ModBusMode = 0 then //ASCII Mode이면
      begin
        //ModePanel.Caption := 'ASCII Mode';
        dcount := Data.NumOfData;
        NumOfBit := Data.NumOfBit;

        for i := 0 to dcount - 1 do
          InpDataBuf[i] := Data.InpDataBuf[i];
      end
      else
      if Data.ModBusMode = 1 then// RTU Mode 이면
      begin
        //ModePanel.Caption := 'RTU Mode';
        dcount := Data.NumOfData div 2;
        NumOfBit := Data.NumOfBit;

        if dcount = 0 then
          Inc(dcount);

        for i := 0 to dcount - 1 do
        begin
          InpDataBuf[i] := Data.InpDataBuf2[i*2] ;
          InpDataBuf[i] := InpDataBuf[i] shl 8 + Data.InpDataBuf2[i*2 + 1];
    //      FModBusData.InpDataBuf[i] :=  ;
        end;

        if (Data.NumOfData mod 2) > 0 then
          InpDataBuf[i] := Data.InpDataBuf2[i*2] ;
      end//Data.ModBusMode = 1
      else
      if (Data.ModBusMode = 4) then //MODBUSTCP_MODE 이면
      begin
        dcount := Data.NumOfData;
        NumOfBit := Data.NumOfBit;
        System.Move(Data.InpDataBuf, InpDataBuf, Sizeof(Data.InpDataBuf));

        //for i := 0 to dcount - 1 do
          //FECSData.InpDataBuf[i] := Data.InpDataBuf[i];
      end
      else
      if (Data.ModBusMode = 3) then //simulate from csv file
      begin
        dcount := Data.NumOfData;
        NumOfBit := Data.NumOfBit;
        System.Move(Data.InpDataBuf_double, InpDataBuf_double, Sizeof(Data.InpDataBuf_double));
      end;//Data.ModBusMode = 3

      ModBusAddress := Data.ModBusAddress;
      BlockNo := Data.BlockNo;
      NumOfData := dcount;
      ModBusFunctionCode := Data.ModBusFunctionCode;
      ModBusMapFileName := Data.ModBusMapFileName;
      FIPCAll.FModBusMapFileName := Data.ModBusMapFileName;

      FIPCAll.DisplayMessage2SB(FIPCAll.FStatusBar, ModBusAddress + ' 데이타 도착');

      SendMessage(FIPCAll.Handle, WM_EVENT_ECS_AVAT, j,0);
      CommonCommunication(psECS_AVAT);
    end;
  end;
end;

procedure TECS_AVAT_Method.OverRide_ECS_AVAT(AIndex: integer);
var
  it: DIterator;
  pHiMap: THiMap;
  i, j, k, BlockNo: integer;
  tmpStr: string;
  tmpByte, ProcessBitCnt: Byte;
  LDataOk: Boolean;
  FECSData_AVAT: TEventData_ECS_AVAT;
begin
  FECSData_AVAT := TEventData_ECS_AVAT(TIPCMonitor<TEventData_ECS_AVAT>(FIPCAll.FIPCMonitorList.Objects[AIndex]).FEventDataRecord);

  BlockNo := 0;
  i := 0;
  j := 0;
  ProcessBitCnt := 0;
  LDataOk := True;

    if (FECSData_AVAT.ModBusFunctionCode = 3) or (FECSData_AVAT.ModBusFunctionCode = 4) then
    begin
      for k := 0 to FIPCAll.FEngineParameter.EngineParameterCollect.Count - 1 do
      begin
        if FIPCAll.FEngineParameter.EngineParameterCollect.Items[k].ParameterSource = psECS_AVAT then
        begin
          tmpStr := IntToStr(FECSData_AVAT.ModBusFunctionCode) +
                      FIPCAll.FEngineParameter.EngineParameterCollect.Items[k].Address;
          it := FIPCAll.FAddressMap.locate( [tmpStr] );
          SetToValue(it);

          while not atEnd(it) do
          begin
            if i > FECSData_AVAT.NumOfData - 1 then
              break;

            pHiMap := GetObject(it) as THiMap;

            if (IntToStr(FECSData_Avat.ModBusFunctionCode) = FIPCAll.FEngineParameter.EngineParameterCollect.Items[k].FCode) and
                      (pHiMap.FAddress = FIPCAll.FEngineParameter.EngineParameterCollect.Items[k].Address) then
            begin
              if (FECSData_AVAT.ModBusMode <> 3) and (FECSData_AVAT.BlockNo <> pHiMap.FBlockNo) then
                break;

              if FECSData_AVAT.ModBusMode = 3 then //pHiMap에는 dummy가 존재함
              begin
                if pHiMap.FListIndexNoDummy <> -1 then
                  pHiMap.FValue := FECSData_AVAT.InpDataBuf_double[pHiMap.FListIndexNoDummy];
              end
              else
                pHiMap.FValue := FECSData_AVAT.InpDataBuf[pHiMap.FListIndex];
              //수신된 데이타를 화면에 뿌려줌
              FIPCAll.Value2Screen_ECS_AVAT(pHiMap,k, FECSData_AVAT.ModBusMode);
              break;
            end;

            Inc(i);
            Advance(it);
            LDataOk := True;
          end;//while
        end;
      end;//for
    end
    //======================================
    else
    begin
      BlockNo := pHiMap.FBlockNo;
      for i := 0 to FECSData_AVAT.NumOfData - 1 do
      begin
        tmpByte := Hi(FECSData_AVAT.InpDataBuf[i]);
        for j := 0 to 7 do
        begin
          pHiMap := GetObject(it) as THiMap;
          if not atEnd(it) then
          begin
            pHiMap.FValue := GetBitVal(tmpByte, j);
            Inc(ProcessBitCnt);
            Advance(it);
          end;
        end;

        tmpByte := Lo(FECSData_AVAT.InpDataBuf[i]);
        for j := 0 to 7 do
        begin
          pHiMap := GetObject(it) as THiMap;
          if not atEnd(it) then
          begin
            pHiMap.FValue := GetBitVal(tmpByte, j);
            Inc(ProcessBitCnt);
            Advance(it);
          end;
        end;
      end;

      if ((FECSData_AVAT.NumOfBit div 8) mod 2) > 0 then
      begin
        tmpByte := Lo(FECSData_AVAT.InpDataBuf[i]);
        for j := 0 to 7 do
        begin
          pHiMap := GetObject(it) as THiMap;
          if not atEnd(it) then
          begin
            pHiMap.FValue := GetBitVal(tmpByte, j);
            Inc(ProcessBitCnt);
            Advance(it);
          end;
        end;
      end;

      for k := 0 to FIPCAll.FEngineParameter.EngineParameterCollect.Count - 1 do
      begin
        if FIPCAll.FEngineParameter.EngineParameterCollect.Items[k].ParameterSource = psECS_AVAT then
        begin
          if (IntToStr(FECSData_AVAT.ModBusFunctionCode) = FIPCAll.FEngineParameter.EngineParameterCollect.Items[k].FCode) and
                    (pHiMap.FAddress = FIPCAll.FEngineParameter.EngineParameterCollect.Items[k].Address) then
          begin
            //수신된 데이타를 화면에 뿌려줌
            FIPCAll.Value2Screen_ECS_AVAT(pHiMap, k, FECSData_AVAT.ModBusMode);
            break;
          end;
        end;
      end;
    end;//else

  //상속 받은 자손에서 구현할 것
  {if LDataOk then
  begin
    Timer1.Enabled := True;
    FPJHTimerPool.AddOneShot(OnTrigger4AvgSave,2000);
    DataSaveByEvent;
  end;
  }

  FIPCAll.DisplayMessage2SB(FIPCAll.FStatusBar, FECSData_AVAT.ModBusAddress + ' 처리중...');
end;

{ TECS_Woodward_Method }

constructor TECS_Woodward_Method.create(AIPCAll: TFrameIPCMonitorAll);
begin
  FIPCAll := AIPCAll;
end;

destructor TECS_Woodward_Method.destroy;
begin

  inherited;
end;

procedure TECS_Woodward_Method.ECS_OnSignal_Woodward(
  Data: TEventData_ECS_Woodward);
var
  i,j,dcount: integer;
begin
  j := FIPCAll.FIPCMonitorList.IndexOf(FPSnSN);

  if j <> -1 then
  begin
    with TEventData_ECS_Woodward(TIPCMonitor<TEventData_ECS_Woodward>(FIPCAll.FIPCMonitorList.Objects[j]).FEventDataRecord) do
    begin
      if not FIPCAll.FCompleteReadMap_Woodward then
        exit;

      dcount := 0;
      FillChar(InpDataBuf[0], High(InpDataBuf) - 1, #0);
      ModBusMode := Data.ModBusMode;

      if Data.ModBusMode = 0 then //ASCII Mode이면
      begin
        //ModePanel.Caption := 'ASCII Mode';
        dcount := Data.NumOfData;
        NumOfBit := Data.NumOfBit;

        for i := 0 to dcount - 1 do
          InpDataBuf[i] := Data.InpDataBuf[i];
      end
      else
      if Data.ModBusMode = 1 then// RTU Mode 이면
      begin
        //ModePanel.Caption := 'RTU Mode';
        dcount := Data.NumOfData div 2;
        NumOfBit := Data.NumOfBit;

        if dcount = 0 then
          Inc(dcount);

        for i := 0 to dcount - 1 do
        begin
          InpDataBuf[i] := Data.InpDataBuf2[i*2] ;
          InpDataBuf[i] := InpDataBuf[i] shl 8 + Data.InpDataBuf2[i*2 + 1];
    //      FModBusData.InpDataBuf[i] :=  ;
        end;

        if (Data.NumOfData mod 2) > 0 then
          InpDataBuf[i] := Data.InpDataBuf2[i*2] ;
      end//Data.ModBusMode = 1
      else
      if (Data.ModBusMode = 4) then //MODBUSTCP_MODE 이면
      begin
        dcount := Data.NumOfData;
        NumOfBit := Data.NumOfBit;
        System.Move(Data.InpDataBuf, InpDataBuf, Sizeof(Data.InpDataBuf));

        //for i := 0 to dcount - 1 do
          //FECSData.InpDataBuf[i] := Data.InpDataBuf[i];
      end
      else
      if (Data.ModBusMode = 3) then //simulate from csv file
      begin
        dcount := Data.NumOfData;
        NumOfBit := Data.NumOfBit;
        System.Move(Data.InpDataBuf_double, InpDataBuf_double, Sizeof(Data.InpDataBuf_double));
      end;//Data.ModBusMode = 3

      ModBusAddress := Data.ModBusAddress;
      BlockNo := Data.BlockNo;
      NumOfData := dcount;
      ModBusFunctionCode := Data.ModBusFunctionCode;
      ModBusMapFileName := Data.ModBusMapFileName;
      FIPCAll.FModBusMapFileName := Data.ModBusMapFileName;

      FIPCAll.DisplayMessage2SB(FIPCAll.FStatusBar, ModBusAddress + ' 데이타 도착');

      SendMessage(FIPCAll.Handle, WM_EVENT_ECS_Woodward, j, 0);
      CommonCommunication(psECS_Woodward);
    end;
  end;
end;

procedure TECS_Woodward_Method.OverRide_ECS_Woodward(AIndex: integer);
var
  i,k: integer;
  Le: double;
  LRadix: integer;
  FECSData_Woodward: TEventData_ECS_Woodward;
begin
  FECSData_Woodward := TEventData_ECS_Woodward(TIPCMonitor<TEventData_ECS_Woodward>(FIPCAll.FIPCMonitorList.Objects[AIndex]).FEventDataRecord);

  if (FECSData_Woodward.ModBusFunctionCode = 1) or (FECSData_Woodward.ModBusFunctionCode = 2)
    or (FECSData_Woodward.ModBusFunctionCode = 3) or (FECSData_Woodward.ModBusFunctionCode = 4) then
  begin
    for k := 0 to FIPCAll.FEngineParameter.EngineParameterCollect.Count - 1 do
    begin
      if FIPCAll.FEngineParameter.EngineParameterCollect.Items[k].ParameterSource = psECS_Woodward then
      begin
        if FECSData_Woodward.BlockNo <> FIPCAll.FEngineParameter.EngineParameterCollect.Items[k].BlockNo then
          Continue;

        //AbsoluteIndex에 Modbus Map에서 각 Request별 위치 정보(공유메모리상의 Index)
        i := FIPCAll.FEngineParameter.EngineParameterCollect.Items[k].AbsoluteIndex;

        if FIPCAll.FEngineParameter.EngineParameterCollect.Items[k].Alarm then //Analog data
        begin
          if FECSData_Woodward.ModBusMode = 3 then
          begin
            Le := FECSData_Woodward.InpDataBuf_double[i];
          end
          else
          begin
            case FIPCAll.FEngineParameter.EngineParameterCollect.Items[k].MinMaxType of
              mmtInteger: begin
                if FIPCAll.FEngineParameter.EngineParameterCollect.Items[k].MaxValue > 0 then
                  Le := FECSData_Woodward.InpDataBuf[i]/FIPCAll.FEngineParameter.EngineParameterCollect.Items[k].MaxValue
                else
                  Le := FECSData_Woodward.InpDataBuf[i];
              end;
              mmtReal: begin
                if FIPCAll.FEngineParameter.EngineParameterCollect.Items[k].MaxValue_Real > 0.0 then
                  Le := FECSData_Woodward.InpDataBuf[i]/FIPCAll.FEngineParameter.EngineParameterCollect.Items[k].MaxValue_Real
                else
                  Le := FECSData_Woodward.InpDataBuf[i];
              end;
            end;//case
          end;

//          LRadix := FIPCAll.FEngineParameter.EngineParameterCollect.Items[k].RadixPosition;

          FIPCAll.FEngineParameter.EngineParameterCollect.Items[k].Value := FormatFloat(FIPCAll.FEngineParameter.EngineParameterCollect.Items[i].DisplayFormat,Le);
//          FIPCAll.FEngineParameter.EngineParameterCollect.Items[k].Value := FloatToStrF(Le, ffFixed, 12, LRadix);//,'%.2f');
        end
        else //Digital data
        begin
          if FECSData_Woodward.InpDataBuf[i] = $FFFF then //True value
            FIPCAll.FEngineParameter.EngineParameterCollect.Items[k].Value := 'True'
          else
            FIPCAll.FEngineParameter.EngineParameterCollect.Items[k].Value := 'False';
        end;

        //수신된 데이타를 화면에 뿌려줌
        FIPCAll.Value2Screen_ECS_Woodward(k,FECSData_Woodward.ModBusMode);
      end;
    end;//for
  end;
end;

{ TLBX_Method }

constructor TLBX_Method.create(AIPCAll: TFrameIPCMonitorAll);
begin
  FIPCAll := AIPCAll;
end;

destructor TLBX_Method.destroy;
begin

  inherited;
end;

procedure TLBX_Method.LBX_OnSignal(Data: TEventData_LBX);
var
  i,j,dcount: integer;
begin
  j := FIPCAll.FIPCMonitorList.IndexOf(FPSnSN);

  if j <> -1 then
  begin
    with TEventData_LBX(TIPCMonitor<TEventData_LBX>(FIPCAll.FIPCMonitorList.Objects[j]).FEventDataRecord) do
    begin
      ENGRPM := Data.ENGRPM;
      HTTEMP := Data.HTTEMP;
      LOTEMP := Data.LOTEMP;
      TCRPMA := Data.TCRPMA;
      TCRPMB := Data.TCRPMB;
      TCINLETTEMP := Data.TCINLETTEMP;

      SendMessage(FIPCAll.Handle, WM_EVENT_LBX, j,0);
      CommonCommunication(psLBX);
    end;
  end;
end;

procedure TLBX_Method.OverRide_LBX(AIndex: integer);
var
  i, LRadix: integer;
  LDouble: double;
  LDataOk: Boolean;
  FLBXData: TEventData_LBX;
begin
  FLBXData := TEventData_LBX(TIPCMonitor<TEventData_LBX>(FIPCAll.FIPCMonitorList.Objects[AIndex]).FEventDataRecord);

  LDataOk := False;

  for i := 0 to FIPCAll.FEngineParameter.EngineParameterCollect.Count - 1 do
  begin
    if FIPCAll.FEngineParameter.EngineParameterCollect.Items[i].ParameterSource = psLBX then
    begin
//      LRadix := FIPCAll.FEngineParameter.EngineParameterCollect.Items[i].RadixPosition;

      if FIPCAll.FEngineParameter.EngineParameterCollect.Items[i].TagName = UpperCase('ENGRPM') then
        FIPCAll.FEngineParameter.EngineParameterCollect.Items[i].Value := IntToStr(FLBXData.ENGRPM)
      else if FIPCAll.FEngineParameter.EngineParameterCollect.Items[i].TagName = UpperCase('HTTEMP') then
        FIPCAll.FEngineParameter.EngineParameterCollect.Items[i].Value := IntToStr(FLBXData.HTTEMP)
      else if FIPCAll.FEngineParameter.EngineParameterCollect.Items[i].TagName = UpperCase('LOTEMP') then
        FIPCAll.FEngineParameter.EngineParameterCollect.Items[i].Value := IntToStr(FLBXData.LOTEMP)
      else if FIPCAll.FEngineParameter.EngineParameterCollect.Items[i].TagName = UpperCase('TCRPMA') then
        FIPCAll.FEngineParameter.EngineParameterCollect.Items[i].Value := IntToStr(FLBXData.TCRPMA)
      else if FIPCAll.FEngineParameter.EngineParameterCollect.Items[i].TagName = UpperCase('TCRPMB') then
        FIPCAll.FEngineParameter.EngineParameterCollect.Items[i].Value := IntToStr(FLBXData.TCRPMB)
      else if FIPCAll.FEngineParameter.EngineParameterCollect.Items[i].TagName = UpperCase('TCINLETTEMP') then
        FIPCAll.FEngineParameter.EngineParameterCollect.Items[i].Value := IntToStr(FLBXData.TCINLETTEMP);

      FIPCAll.WatchValue2Screen_Analog('', '',i);
      LDataOk := True;
    end;
  end;//for

  //상속 받은 자손에서 구현할 것
  {if LDataOk then
  begin
    Timer1.Enabled := True;
    FPJHTimerPool.AddOneShot(OnTrigger4AvgSave,2000);
    DataSaveByEvent;
  end;
  }
end;

{ TFlowMeter_Method }

constructor TFlowMeter_Method.create(AIPCAll: TFrameIPCMonitorAll);
begin
  FIPCAll := AIPCAll;
end;

destructor TFlowMeter_Method.destroy;
begin

  inherited;
end;

procedure TFlowMeter_Method.FlowMeter_OnSignal(Data: TEventData_FlowMeter);
begin
  CommonCommunication(psFlowMeter);
end;

procedure TFlowMeter_Method.OverRide_FlowMeter(AIndex: integer);
var
  LDataOk: Boolean;
begin
  //상속 받은 자손에서 구현할 것
  {if LDataOk then
  begin
    Timer1.Enabled := True;
    FPJHTimerPool.AddOneShot(OnTrigger4AvgSave,2000);
    DataSaveByEvent;
  end;
  }
end;

{ TDYNAMO_Method }

constructor TDYNAMO_Method.create(AIPCAll: TFrameIPCMonitorAll);
begin
  FIPCAll := AIPCAll;
end;

destructor TDYNAMO_Method.destroy;
begin

  inherited;
end;

procedure TDYNAMO_Method.DYNAMO_OnSignal(Data: TEventData_DYNAMO);
begin
  CommonCommunication(psDynamo);
end;

procedure TDYNAMO_Method.OverRide_DYNAMO(AIndex: integer);
var
  i, LRadix: integer;
  LDataOk: Boolean;
  LDYNAMOData: TEventData_DYNAMO;
begin
  LDYNAMOData := TEventData_DYNAMO(TIPCMonitor<TEventData_DYNAMO>(FIPCAll.FIPCMonitorList.Objects[AIndex]).FEventDataRecord);

  for i := 0 to FIPCAll.FEngineParameter.EngineParameterCollect.Count - 1 do
  begin
    if FIPCAll.FEngineParameter.EngineParameterCollect.Items[i].ParameterSource = psDynamo then
    begin
//      LRadix := FIPCAll.FEngineParameter.EngineParameterCollect.Items[i].RadixPosition;

      if UpperCase(FIPCAll.FEngineParameter.EngineParameterCollect.Items[i].TagName) = UpperCase('Power') then
        FIPCAll.FEngineParameter.EngineParameterCollect.Items[i].Value := FormatFloat(FIPCAll.FEngineParameter.EngineParameterCollect.Items[i].DisplayFormat, LDYNAMOData.FPower) // FloatToStrF(FDYNAMOData.FPower, ffFixed, 12, LRadix)
      else if UpperCase(FIPCAll.FEngineParameter.EngineParameterCollect.Items[i].TagName) = UpperCase('Torque') then
        FIPCAll.FEngineParameter.EngineParameterCollect.Items[i].Value := FormatFloat(FIPCAll.FEngineParameter.EngineParameterCollect.Items[i].DisplayFormat, LDYNAMOData.FTorque) //FloatToStrF(FDYNAMOData.FTorque, ffFixed, 12, LRadix)
      else if UpperCase(FIPCAll.FEngineParameter.EngineParameterCollect.Items[i].TagName) = UpperCase('RPM') then
        FIPCAll.FEngineParameter.EngineParameterCollect.Items[i].Value := FormatFloat(FIPCAll.FEngineParameter.EngineParameterCollect.Items[i].DisplayFormat, LDYNAMOData.FRevolution) //FloatToStrF(FDYNAMOData.FRevolution, ffFixed, 12, LRadix)
      else if UpperCase(FIPCAll.FEngineParameter.EngineParameterCollect.Items[i].TagName) = UpperCase('BRG_TB') then
        FIPCAll.FEngineParameter.EngineParameterCollect.Items[i].Value := FormatFloat(FIPCAll.FEngineParameter.EngineParameterCollect.Items[i].DisplayFormat, LDYNAMOData.FBrgTBTemp) //FloatToStrF(FDYNAMOData.FBrgTBTemp, ffFixed, 12, LRadix)
      else if UpperCase(FIPCAll.FEngineParameter.EngineParameterCollect.Items[i].TagName) = UpperCase('BRG_MTR') then
        FIPCAll.FEngineParameter.EngineParameterCollect.Items[i].Value := FormatFloat(FIPCAll.FEngineParameter.EngineParameterCollect.Items[i].DisplayFormat, LDYNAMOData.FBrgMTRTemp) //FloatToStrF(FDYNAMOData.FBrgMTRTemp, ffFixed, 12, LRadix)
      else if UpperCase(FIPCAll.FEngineParameter.EngineParameterCollect.Items[i].TagName) = UpperCase('Inlet1') then
        FIPCAll.FEngineParameter.EngineParameterCollect.Items[i].Value := FormatFloat(FIPCAll.FEngineParameter.EngineParameterCollect.Items[i].DisplayFormat, LDYNAMOData.FInletOpen1) //FloatToStrF(FDYNAMOData.FInletOpen1, ffFixed, 12, LRadix)
      else if UpperCase(FIPCAll.FEngineParameter.EngineParameterCollect.Items[i].TagName) = UpperCase('Inlet2') then
        FIPCAll.FEngineParameter.EngineParameterCollect.Items[i].Value := FormatFloat(FIPCAll.FEngineParameter.EngineParameterCollect.Items[i].DisplayFormat, LDYNAMOData.FInletOpen2) //FloatToStrF(FDYNAMOData.FInletOpen2, ffFixed, 12, LRadix)
      else if UpperCase(FIPCAll.FEngineParameter.EngineParameterCollect.Items[i].TagName) = UpperCase('Outlet1') then
        FIPCAll.FEngineParameter.EngineParameterCollect.Items[i].Value := FormatFloat(FIPCAll.FEngineParameter.EngineParameterCollect.Items[i].DisplayFormat, LDYNAMOData.FOutletOpen1) //FloatToStrF(FDYNAMOData.FOutletOpen1, ffFixed, 12, LRadix)
      else if UpperCase(FIPCAll.FEngineParameter.EngineParameterCollect.Items[i].TagName) = UpperCase('Outlet2') then
        FIPCAll.FEngineParameter.EngineParameterCollect.Items[i].Value := FormatFloat(FIPCAll.FEngineParameter.EngineParameterCollect.Items[i].DisplayFormat, LDYNAMOData.FOutletOpen2) //FloatToStrF(FDYNAMOData.FOutletOpen2, ffFixed, 12, LRadix)
      else if UpperCase(FIPCAll.FEngineParameter.EngineParameterCollect.Items[i].TagName) = UpperCase('WaterInlet') then
        FIPCAll.FEngineParameter.EngineParameterCollect.Items[i].Value := FormatFloat(FIPCAll.FEngineParameter.EngineParameterCollect.Items[i].DisplayFormat, LDYNAMOData.FWaterInletTemp) //FloatToStrF(FDYNAMOData.FWaterInletTemp, ffFixed, 12, LRadix)
      else if UpperCase(FIPCAll.FEngineParameter.EngineParameterCollect.Items[i].TagName) = UpperCase('WaterOutlet') then
        FIPCAll.FEngineParameter.EngineParameterCollect.Items[i].Value := FormatFloat(FIPCAll.FEngineParameter.EngineParameterCollect.Items[i].DisplayFormat, LDYNAMOData.FWaterOutletTemp) //FloatToStrF(FDYNAMOData.FWaterOutletTemp, ffFixed, 12, LRadix)
      else if UpperCase(FIPCAll.FEngineParameter.EngineParameterCollect.Items[i].TagName) = UpperCase('Body1') then
        FIPCAll.FEngineParameter.EngineParameterCollect.Items[i].Value := FormatFloat(FIPCAll.FEngineParameter.EngineParameterCollect.Items[i].DisplayFormat, LDYNAMOData.FBody1Press) //FloatToStrF(FDYNAMOData.FBody1Press, ffFixed, 12, LRadix)
      else if UpperCase(FIPCAll.FEngineParameter.EngineParameterCollect.Items[i].TagName) = UpperCase('Body2') then
        FIPCAll.FEngineParameter.EngineParameterCollect.Items[i].Value := FormatFloat(FIPCAll.FEngineParameter.EngineParameterCollect.Items[i].DisplayFormat, LDYNAMOData.FBody2Press) //FloatToStrF(FDYNAMOData.FBody2Press, ffFixed, 12, LRadix)
      else if UpperCase(FIPCAll.FEngineParameter.EngineParameterCollect.Items[i].TagName) = UpperCase('WaterSupply') then
        FIPCAll.FEngineParameter.EngineParameterCollect.Items[i].Value := FormatFloat(FIPCAll.FEngineParameter.EngineParameterCollect.Items[i].DisplayFormat, LDYNAMOData.FWaterSupply) //FloatToStrF(FDYNAMOData.FWaterSupply, ffFixed, 12, LRadix)
      else if UpperCase(FIPCAll.FEngineParameter.EngineParameterCollect.Items[i].TagName) = UpperCase('OilPress') then
        FIPCAll.FEngineParameter.EngineParameterCollect.Items[i].Value := FormatFloat(FIPCAll.FEngineParameter.EngineParameterCollect.Items[i].DisplayFormat, LDYNAMOData.FOilPress); //FloatToStrF(FDYNAMOData.FOilPress, ffFixed, 12, LRadix);

      FIPCAll.WatchValue2Screen_Analog('', '',i);
      LDataOk := True;
    end;
  end;
  //상속 받은 자손에서 구현할 것
  {if LDataOk then
  begin
    Timer1.Enabled := True;
    FPJHTimerPool.AddOneShot(OnTrigger4AvgSave,2000);
    DataSaveByEvent;
  end;
  }
end;

{ TGasCalc_Method }

constructor TGasCalc_Method.create(AIPCAll: TFrameIPCMonitorAll);
begin
  FIPCAll := AIPCAll;
end;

destructor TGasCalc_Method.destroy;
begin

  inherited;
end;

procedure TGasCalc_Method.GasCalc_OnSignal(Data: TEventData_GasCalc);
var
  i,j,dcount: integer;
begin
  j := FIPCAll.FIPCMonitorList.IndexOf(FPSnSN);

  if j <> -1 then
  begin
    with TEventData_GasCalc(TIPCMonitor<TEventData_GasCalc>(FIPCAll.FIPCMonitorList.Objects[j]).FEventDataRecord) do
    begin
      FSVP := Data.FSVP;
      FIAH2 := Data.FIAH2;
      FUFC := Data.FUFC;
      FNhtCF := Data.FNhtCF;
      FDWCFE := Data.FDWCFE;
      FEGF := Data.FEGF;
      FNOxAtO213 := Data.FNOxAtO213;
      FNOx := Data.FNOx;
      FAF1 := Data.FAF1;
      FAF2 := Data.FAF2;
      FAF3 := Data.FAF3;
      FAF_Measured := Data.FAF_Measured;
      FMT210 := Data.FMT210;
      FFC := Data.FFC;
      FEngineOutput := Data.FEngineOutput;
      FGeneratorOutput := Data.FGeneratorOutput;
      FEngineLoad := Data.FEngineLoad;
      FGenEfficiency := Data.FGenEfficiency;
      FBHP := Data.FBHP;
      FBMEP := Data.FBMEP;
      FLamda_Calculated := Data.FLamda_Calculated;
      FLamda_Measured := Data.FLamda_Measured;
      FLamda_Brettschneider := Data.FLamda_Brettschneider;
      FAFRatio_Calculated := Data.FAFRatio_Calculated;
      FAFRatio_Measured := Data.FAFRatio_Measured;
      FExhTempAvg := Data.FExhTempAvg;
      FWasteGatePosition := Data.FWasteGatePosition;
      FThrottlePosition := Data.FThrottlePosition;
      //FBoostPress := Data.FBoostPress;
      FDensity := Data.FDensity;
      FLCV := Data.FLCV;

      SendMessage(FIPCAll.Handle, WM_EVENT_GASCALC, j,0);
      CommonCommunication(psGasCalculated);
    end;
  end;
end;

procedure TGasCalc_Method.OverRide_GasCalc(AIndex: integer);
var
  i, LRadix: integer;
  LDouble: double;
  LGasCalcData: TEventData_GasCalc;
begin
  LGasCalcData := TEventData_GasCalc(TIPCMonitor<TEventData_GasCalc>(FIPCAll.FIPCMonitorList.Objects[AIndex]).FEventDataRecord);

  for i := 0 to FIPCAll.FEngineParameter.EngineParameterCollect.Count - 1 do
  begin
    if FIPCAll.FEngineParameter.EngineParameterCollect.Items[i].ParameterSource = psGasCalculated then
    begin
//      LRadix := FIPCAll.FEngineParameter.EngineParameterCollect.Items[i].RadixPosition;

      if UpperCase(FIPCAll.FEngineParameter.EngineParameterCollect.Items[i].TagName) = UpperCase('SVP') then
        FIPCAll.FEngineParameter.EngineParameterCollect.Items[i].Value := FormatFloat(FIPCAll.FEngineParameter.EngineParameterCollect.Items[i].DisplayFormat,LGasCalcData.FSVP) //FloatToStr(FGasCalcData.FSVP)
      else if UpperCase(FIPCAll.FEngineParameter.EngineParameterCollect.Items[i].TagName) = UpperCase('IAH2') then
        FIPCAll.FEngineParameter.EngineParameterCollect.Items[i].Value := FormatFloat(FIPCAll.FEngineParameter.EngineParameterCollect.Items[i].DisplayFormat,LGasCalcData.FIAH2) //FloatToStr(FGasCalcData.FIAH2)
      else if UpperCase(FIPCAll.FEngineParameter.EngineParameterCollect.Items[i].TagName) = UpperCase('UFC') then
        FIPCAll.FEngineParameter.EngineParameterCollect.Items[i].Value := FormatFloat(FIPCAll.FEngineParameter.EngineParameterCollect.Items[i].DisplayFormat,LGasCalcData.FUFC) //FloatToStr(FGasCalcData.FUFC)
      else if UpperCase(FIPCAll.FEngineParameter.EngineParameterCollect.Items[i].TagName) = UpperCase('NhtCF') then
        FIPCAll.FEngineParameter.EngineParameterCollect.Items[i].Value := FormatFloat(FIPCAll.FEngineParameter.EngineParameterCollect.Items[i].DisplayFormat,LGasCalcData.FNhtCF) //FloatToStr(FGasCalcData.FNhtCF)
      else if UpperCase(FIPCAll.FEngineParameter.EngineParameterCollect.Items[i].TagName) = UpperCase('DWCFE') then
        FIPCAll.FEngineParameter.EngineParameterCollect.Items[i].Value := FormatFloat(FIPCAll.FEngineParameter.EngineParameterCollect.Items[i].DisplayFormat,LGasCalcData.FDWCFE) //FloatToStr(FGasCalcData.FDWCFE)
      else if UpperCase(FIPCAll.FEngineParameter.EngineParameterCollect.Items[i].TagName) = UpperCase('EGF') then
        FIPCAll.FEngineParameter.EngineParameterCollect.Items[i].Value := FormatFloat(FIPCAll.FEngineParameter.EngineParameterCollect.Items[i].DisplayFormat,LGasCalcData.FEGF) //FloatToStr(FGasCalcData.FEGF)
      else if UpperCase(FIPCAll.FEngineParameter.EngineParameterCollect.Items[i].TagName) = UpperCase('NOxAtO213') then
        FIPCAll.FEngineParameter.EngineParameterCollect.Items[i].Value := FormatFloat(FIPCAll.FEngineParameter.EngineParameterCollect.Items[i].DisplayFormat,LGasCalcData.FNOxAtO213) //FloatToStr(FGasCalcData.FNOxAtO213)
      else if UpperCase(FIPCAll.FEngineParameter.EngineParameterCollect.Items[i].TagName) = UpperCase('NOx') then
        FIPCAll.FEngineParameter.EngineParameterCollect.Items[i].Value := FormatFloat(FIPCAll.FEngineParameter.EngineParameterCollect.Items[i].DisplayFormat,LGasCalcData.FNOx) //FloatToStr(FGasCalcData.FNOx)
      else if UpperCase(FIPCAll.FEngineParameter.EngineParameterCollect.Items[i].TagName) = UpperCase('AF1') then
        FIPCAll.FEngineParameter.EngineParameterCollect.Items[i].Value := FormatFloat(FIPCAll.FEngineParameter.EngineParameterCollect.Items[i].DisplayFormat,LGasCalcData.FAF1) //FloatToStr(FGasCalcData.FAF1)
      else if UpperCase(FIPCAll.FEngineParameter.EngineParameterCollect.Items[i].TagName) = UpperCase('AF2') then
        FIPCAll.FEngineParameter.EngineParameterCollect.Items[i].Value := FormatFloat(FIPCAll.FEngineParameter.EngineParameterCollect.Items[i].DisplayFormat,LGasCalcData.FAF2) //FloatToStr(FGasCalcData.FAF2)
      else if UpperCase(FIPCAll.FEngineParameter.EngineParameterCollect.Items[i].TagName) = UpperCase('AF3') then
        FIPCAll.FEngineParameter.EngineParameterCollect.Items[i].Value := FormatFloat(FIPCAll.FEngineParameter.EngineParameterCollect.Items[i].DisplayFormat,LGasCalcData.FAF3) //FloatToStr(FGasCalcData.FAF3)
      else if UpperCase(FIPCAll.FEngineParameter.EngineParameterCollect.Items[i].TagName) = UpperCase('AF_Measured') then
        FIPCAll.FEngineParameter.EngineParameterCollect.Items[i].Value := FormatFloat(FIPCAll.FEngineParameter.EngineParameterCollect.Items[i].DisplayFormat,LGasCalcData.FAF_Measured) //FloatToStr(FGasCalcData.FAF_Measured)
      else if UpperCase(FIPCAll.FEngineParameter.EngineParameterCollect.Items[i].TagName) = UpperCase('MT210') then
        FIPCAll.FEngineParameter.EngineParameterCollect.Items[i].Value := FormatFloat(FIPCAll.FEngineParameter.EngineParameterCollect.Items[i].DisplayFormat,LGasCalcData.FMT210) //FloatToStr(FGasCalcData.FMT210)
      else if UpperCase(FIPCAll.FEngineParameter.EngineParameterCollect.Items[i].TagName) = UpperCase('FC') then
        FIPCAll.FEngineParameter.EngineParameterCollect.Items[i].Value := FormatFloat(FIPCAll.FEngineParameter.EngineParameterCollect.Items[i].DisplayFormat,LGasCalcData.FFC) //FloatToStr(FGasCalcData.FFC)
      else if UpperCase(FIPCAll.FEngineParameter.EngineParameterCollect.Items[i].TagName) = UpperCase('EngineOutput') then
        FIPCAll.FEngineParameter.EngineParameterCollect.Items[i].Value := FormatFloat(FIPCAll.FEngineParameter.EngineParameterCollect.Items[i].DisplayFormat,LGasCalcData.FEngineOutput) //FloatToStr(FGasCalcData.FEngineOutput)
      else if UpperCase(FIPCAll.FEngineParameter.EngineParameterCollect.Items[i].TagName) = UpperCase('GeneratorOutput') then
        FIPCAll.FEngineParameter.EngineParameterCollect.Items[i].Value := FormatFloat(FIPCAll.FEngineParameter.EngineParameterCollect.Items[i].DisplayFormat,LGasCalcData.FGeneratorOutput) //FloatToStr(FGasCalcData.FGeneratorOutput)
      else if UpperCase(FIPCAll.FEngineParameter.EngineParameterCollect.Items[i].TagName) = UpperCase('EngineLoad') then
        FIPCAll.FEngineParameter.EngineParameterCollect.Items[i].Value := FormatFloat(FIPCAll.FEngineParameter.EngineParameterCollect.Items[i].DisplayFormat,LGasCalcData.FEngineLoad) //FloatToStr(FGasCalcData.FEngineLoad)
      else if UpperCase(FIPCAll.FEngineParameter.EngineParameterCollect.Items[i].TagName) = UpperCase('GenEfficiency') then
        FIPCAll.FEngineParameter.EngineParameterCollect.Items[i].Value := FormatFloat(FIPCAll.FEngineParameter.EngineParameterCollect.Items[i].DisplayFormat,LGasCalcData.FGenEfficiency) //FloatToStr(FGasCalcData.FGenEfficiency)
      else if UpperCase(FIPCAll.FEngineParameter.EngineParameterCollect.Items[i].TagName) = UpperCase('BHP') then
        FIPCAll.FEngineParameter.EngineParameterCollect.Items[i].Value := FormatFloat(FIPCAll.FEngineParameter.EngineParameterCollect.Items[i].DisplayFormat,LGasCalcData.FBHP) //FloatToStr(FGasCalcData.FBHP)
      else if UpperCase(FIPCAll.FEngineParameter.EngineParameterCollect.Items[i].TagName) = UpperCase('BMEP') then
        FIPCAll.FEngineParameter.EngineParameterCollect.Items[i].Value := FormatFloat(FIPCAll.FEngineParameter.EngineParameterCollect.Items[i].DisplayFormat,LGasCalcData.FBMEP) //FloatToStr(FGasCalcData.FBMEP)
      else if UpperCase(FIPCAll.FEngineParameter.EngineParameterCollect.Items[i].TagName) = UpperCase('Lamda_Calculated') then
        FIPCAll.FEngineParameter.EngineParameterCollect.Items[i].Value := FormatFloat(FIPCAll.FEngineParameter.EngineParameterCollect.Items[i].DisplayFormat,LGasCalcData.FLamda_Calculated) //FloatToStr(FGasCalcData.FLamda_Calculated)
      else if UpperCase(FIPCAll.FEngineParameter.EngineParameterCollect.Items[i].TagName) = UpperCase('Lamda_Measured') then
        FIPCAll.FEngineParameter.EngineParameterCollect.Items[i].Value := FormatFloat(FIPCAll.FEngineParameter.EngineParameterCollect.Items[i].DisplayFormat,LGasCalcData.FLamda_Measured) //FloatToStr(FGasCalcData.FLamda_Measured)
      else if UpperCase(FIPCAll.FEngineParameter.EngineParameterCollect.Items[i].TagName) = UpperCase('Lamda_Brettschneider') then
        FIPCAll.FEngineParameter.EngineParameterCollect.Items[i].Value := FormatFloat(FIPCAll.FEngineParameter.EngineParameterCollect.Items[i].DisplayFormat,LGasCalcData.FLamda_Brettschneider) //FloatToStr(FGasCalcData.FLamda_Brettschneider)
      else if UpperCase(FIPCAll.FEngineParameter.EngineParameterCollect.Items[i].TagName) = UpperCase('AFRatio_Calculated') then
        FIPCAll.FEngineParameter.EngineParameterCollect.Items[i].Value := FormatFloat(FIPCAll.FEngineParameter.EngineParameterCollect.Items[i].DisplayFormat,LGasCalcData.FAFRatio_Calculated) //FloatToStr(FGasCalcData.FAFRatio_Calculated)
      else if UpperCase(FIPCAll.FEngineParameter.EngineParameterCollect.Items[i].TagName) = UpperCase('AFRatio_Measured') then
        FIPCAll.FEngineParameter.EngineParameterCollect.Items[i].Value := FormatFloat(FIPCAll.FEngineParameter.EngineParameterCollect.Items[i].DisplayFormat,LGasCalcData.FAFRatio_Measured) //FloatToStr(FGasCalcData.FAFRatio_Measured)
      else if UpperCase(FIPCAll.FEngineParameter.EngineParameterCollect.Items[i].TagName) = UpperCase('ExhTempAvg') then
        FIPCAll.FEngineParameter.EngineParameterCollect.Items[i].Value := FormatFloat(FIPCAll.FEngineParameter.EngineParameterCollect.Items[i].DisplayFormat,LGasCalcData.FExhTempAvg) //FloatToStr(FGasCalcData.FExhTempAvg)
      else if UpperCase(FIPCAll.FEngineParameter.EngineParameterCollect.Items[i].TagName) = UpperCase('WasteGatePosition') then
        FIPCAll.FEngineParameter.EngineParameterCollect.Items[i].Value := FormatFloat(FIPCAll.FEngineParameter.EngineParameterCollect.Items[i].DisplayFormat,LGasCalcData.FWasteGatePosition) //FloatToStr(FGasCalcData.FWasteGatePosition)
      else if UpperCase(FIPCAll.FEngineParameter.EngineParameterCollect.Items[i].TagName) = UpperCase('ThrottlePosition') then
        FIPCAll.FEngineParameter.EngineParameterCollect.Items[i].Value := FormatFloat(FIPCAll.FEngineParameter.EngineParameterCollect.Items[i].DisplayFormat,LGasCalcData.FThrottlePosition) //FloatToStr(FGasCalcData.FThrottlePosition)
      else if UpperCase(FIPCAll.FEngineParameter.EngineParameterCollect.Items[i].TagName) = UpperCase('Density') then
        FIPCAll.FEngineParameter.EngineParameterCollect.Items[i].Value := FormatFloat(FIPCAll.FEngineParameter.EngineParameterCollect.Items[i].DisplayFormat,LGasCalcData.FDensity) //FloatToStr(FGasCalcData.FDensity)
      else if UpperCase(FIPCAll.FEngineParameter.EngineParameterCollect.Items[i].TagName) = UpperCase('LCV') then
        FIPCAll.FEngineParameter.EngineParameterCollect.Items[i].Value := FormatFloat(FIPCAll.FEngineParameter.EngineParameterCollect.Items[i].DisplayFormat,LGasCalcData.FLCV) //FloatToStr(FGasCalcData.FLCV)
      else if UpperCase(FIPCAll.FEngineParameter.EngineParameterCollect.Items[i].TagName) = UpperCase('BoostPress') then
        FIPCAll.FEngineParameter.EngineParameterCollect.Items[i].Value := FormatFloat(FIPCAll.FEngineParameter.EngineParameterCollect.Items[i].DisplayFormat,LGasCalcData.FBoostPress); //FloatToStr(FGasCalcData.FBoostPress);

      FIPCAll.WatchValue2Screen_Analog('', '',i);
    end;
  end;//for
end;

{ TKRAL_Method }

constructor TKRAL_Method.create(AIPCAll: TFrameIPCMonitorAll);
begin
  FIPCAll := AIPCAll;
end;

destructor TKRAL_Method.destroy;
begin

  inherited;
end;

procedure TKRAL_Method.KRAL_OnSignal(Data: TEventData_Modbus_Standard);
var
  i,j,dcount: integer;
begin
  j := FIPCAll.FIPCMonitorList.IndexOf(FPSnSN);

  if j <> -1 then
  begin
    with TEventData_Modbus_Standard(TIPCMonitor<TEventData_Modbus_Standard>(FIPCAll.FIPCMonitorList.Objects[j]).FEventDataRecord) do
    begin
      FillChar(InpDataBuf[0], High(InpDataBuf) - 1, #0);
      ModBusMode := Data.ModBusMode;

      if Data.ModBusMode = 0 then //ASCII Mode이면
      begin
        //ModePanel.Caption := 'ASCII Mode';
        dcount := Data.NumOfData;
        NumOfBit := Data.NumOfBit;

        for i := 0 to dcount - 1 do
          InpDataBuf2[i] := Data.InpDataBuf2[i];
      end
      else
      if Data.ModBusMode = 1 then// RTU Mode 이면
      begin
        //ModePanel.Caption := 'RTU Mode';
        dcount := Data.NumOfData;
        NumOfBit := Data.NumOfBit;

        if dcount = 0 then
          Inc(dcount);

        for i := 0 to dcount - 1 do
        begin
          InpDataBuf[i] := Data.InpDataBuf[i] ;
        end;
      end//Data.ModBusMode = 1
      else
      if (Data.ModBusMode = 3) then
      begin
        dcount := Data.NumOfData;
        NumOfBit := Data.NumOfBit;
        System.Move(Data.InpDataBuf_double, InpDataBuf_double, Sizeof(Data.InpDataBuf_double));
      end;//Data.ModBusMode = 3

      ModBusAddress := Data.ModBusAddress;
      BlockNo := Data.BlockNo;
      NumOfData := dcount;
      ModBusFunctionCode := Data.ModBusFunctionCode;

      FIPCAll.DisplayMessage2SB(FIPCAll.FStatusBar, ModBusAddress + ' 데이타 도착');

      SendMessage(FIPCAll.Handle, WM_EVENT_KRAL, j,0);
      CommonCommunication(psFlowMeterKral);
    end;
  end;
end;

procedure TKRAL_Method.OverRide_KRAL(AIndex: integer);
var
  i,k, LValue: integer;
  Le: double;
  LRadix: integer;
  LKRALData: TEventData_Modbus_Standard;
begin
  LKRALData := TEventData_Modbus_Standard(TIPCMonitor<TEventData_Modbus_Standard>(FIPCAll.FIPCMonitorList.Objects[AIndex]).FEventDataRecord);

  if (LKRALData.ModBusFunctionCode = 3) or (LKRALData.ModBusFunctionCode = 4) then
  begin
    for k := 0 to FIPCAll.FEngineParameter.EngineParameterCollect.Count - 1 do
    begin
      if FIPCAll.FEngineParameter.EngineParameterCollect.Items[k].ParameterSource = psFlowMeterKral then
      begin
        if LKRALData.BlockNo <> FIPCAll.FEngineParameter.EngineParameterCollect.Items[k].BlockNo then
          Continue;

        i := FIPCAll.FEngineParameter.EngineParameterCollect.Items[k].AbsoluteIndex;

        if FIPCAll.FEngineParameter.EngineParameterCollect.Items[k].Alarm then //Analog data
        begin
          if LKRALData.ModBusMode = 3 then
          begin
            Le := LKRALData.InpDataBuf_double[i];
            FIPCAll.FEngineParameter.EngineParameterCollect.Items[k].Value := FormatFloat(FIPCAll.FEngineParameter.EngineParameterCollect.Items[i].DisplayFormat,Le);
          end
          else
          begin
//            LValue := ((LKRALData.InpDataBuf[i] shl 16) or LKRALData.InpDataBuf[i+1]);
//            Le := LValue / 10;
//            Le := LKRALData.InpDataBuf[i];
            FIPCAll.FEngineParameter.EngineParameterCollect.Items[k].Value := IntToStr(LKRALData.InpDataBuf[i]);//FormatFloat(FIPCAll.FEngineParameter.EngineParameterCollect.Items[i].DisplayFormat,Le);
          end;

//          LRadix := FIPCAll.FEngineParameter.EngineParameterCollect.Items[k].RadixPosition;

//          FIPCAll.FEngineParameter.EngineParameterCollect.Items[k].Value := FloatToStrF(Le, ffFixed, 12, LRadix);//,'%.2f');
        end;

      end;
    end;//for

    //수신된 데이타를 화면에 뿌려줌
    FIPCAll.Value2Screen_KRAL;
  end;
end;

{ TPLC_S7_Method }

constructor TPLC_S7_Method.create(AIPCAll: TFrameIPCMonitorAll);
begin
  FIPCAll := AIPCAll;
end;

destructor TPLC_S7_Method.destroy;
begin

  inherited;
end;

procedure TPLC_S7_Method.OverRide_PLC_S7(AIndex: integer);
var
  i,k,LRadix,LDividor: integer;
  Le: double;
  LPLCData_S7: TEventData_PLC_S7;
begin
  LPLCData_S7 := TEventData_PLC_S7(TIPCMonitor<TEventData_PLC_S7>(FIPCAll.FIPCMonitorList.Objects[AIndex]).FEventDataRecord);

  for k := 0 to FIPCAll.FEngineParameter.EngineParameterCollect.Count - 1 do
  begin
    if FIPCAll.FEngineParameter.EngineParameterCollect.Items[k].ParameterSource = psPLC_S7 then
    begin
      if LPLCData_S7.BlockNo <> FIPCAll.FEngineParameter.EngineParameterCollect.Items[k].BlockNo then
        Continue;

      //배열 Index는 0부터 시작하는데 FCode는 1부터 시작하므로 1 빼줌
      i := StrToInt(FIPCAll.FEngineParameter.EngineParameterCollect.Items[k].FCode) - 1;

      if FIPCAll.FEngineParameter.EngineParameterCollect.Items[k].Contact <> 0 then
        LDividor := FIPCAll.FEngineParameter.EngineParameterCollect.Items[k].Contact
      else
        LDividor := 1;

      if FIPCAll.FEngineParameter.EngineParameterCollect.Items[k].Alarm then //Analog data
      begin
        case TS7DataType(FIPCAll.FEngineParameter.EngineParameterCollect.Items[k].AbsoluteIndex) of
          S7DTByte : Le := LPLCData_S7.DataByte[i]/LDividor;
          S7DTWord : Le := LPLCData_S7.DataWord[i]/LDividor;
          S7DTInt  : Le := LPLCData_S7.DataInt[i]/LDividor;
          S7DTDWord: Le := LPLCData_S7.DataDWord[i]/LDividor;
          S7DTDInt : Le := LPLCData_S7.DataDInt[i]/LDividor;
          S7DTReal : Le := LPLCData_S7.DataFloat[i]/LDividor;
        end;//case
      end;

//      LRadix := FIPCAll.FEngineParameter.EngineParameterCollect.Items[k].RadixPosition;
      FIPCAll.FEngineParameter.EngineParameterCollect.Items[k].Value := FormatFloat(FIPCAll.FEngineParameter.EngineParameterCollect.Items[i].DisplayFormat, Le);//,'%.2f');

      FIPCAll.WatchValue2Screen_Analog('', '',k);
    end;//if
  end;//for
end;

procedure TPLC_S7_Method.PLC_S7_OnSignal(Data: TEventData_PLC_S7);
var
  j: integer;
begin
  j := FIPCAll.FIPCMonitorList.IndexOf(FPSnSN);

  if j <> -1 then
  begin
    with TEventData_PLC_S7(TIPCMonitor<TEventData_PLC_S7>(FIPCAll.FIPCMonitorList.Objects[j]).FEventDataRecord) do
    begin
      Case Data.DataType of
        0 : System.Move(Data.DataByte, DataByte, Sizeof(Data.DataByte));
        1 : System.Move(Data.DataWord, DataWord, Sizeof(Data.DataWord));
        2 : System.Move(Data.DataInt, DataInt, Sizeof(Data.DataInt));
        3 : System.Move(Data.DataDWord, DataDWord, Sizeof(Data.DataDWord));
        4 : System.Move(Data.DataDInt, DataDInt, Sizeof(Data.DataDInt));
        5 : System.Move(Data.DataFloat, DataFloat, Sizeof(Data.DataFloat));
      end;

      NumOfData := Data.NumOfData;
      NumOfBit := Data.NumOfBit;
      BlockNo := Data.BlockNo;
      DataType := Data.DataType;
      ModBusMapFileName := Data.ModBusMapFileName;
      FIPCAll.FModBusMapFileName := Data.ModBusMapFileName;

      SendMessage(FIPCAll.Handle, WM_EVENT_PLC_S7, j,0);
      CommonCommunication(psPLC_S7);
    end;
  end;
end;

{ TEngineParam_Method }

constructor TEngineParam_Method.create(AIPCAll: TFrameIPCMonitorAll);
begin
  FIPCAll := AIPCAll;
end;

destructor TEngineParam_Method.destroy;
begin

  inherited;
end;

procedure TEngineParam_Method.EngineParam_OnSignal(
  Data: TEventData_EngineParam);
var
  j: integer;
begin
  j := FIPCAll.FIPCMonitorList.IndexOf(FPSnSN);

  if j <> -1 then
  begin
    with TEventData_EngineParam(TIPCMonitor<TEventData_EngineParam>(FIPCAll.FIPCMonitorList.Objects[j]).FEventDataRecord) do
    begin
      System.Move(Data.FData, FData, Sizeof(Data.FData));
      FDataCount := Data.FDataCount;

      SendMessage(FIPCAll.Handle, WM_EVENT_ENGINEPARAM, j,0);
      CommonCommunication(psEngineParam);
    end;
  end;
end;

procedure TEngineParam_Method.OverRide_EngineParam(AIndex: integer);
var
  i: integer;
  LDataOk: boolean;
  FEngineParamData: TEventData_EngineParam;
begin
  FEngineParamData := TEventData_EngineParam(TIPCMonitor<TEventData_EngineParam>(FIPCAll.FIPCMonitorList.Objects[AIndex]).FEventDataRecord);

  LDataOk := False;

  for i := 0 to FIPCAll.FEngineParameter.EngineParameterCollect.Count - 1 do
  begin
    if FIPCAll.FEngineParameter.EngineParameterCollect.Items[i].ParameterSource = psEngineParam then
    begin
      FIPCAll.FEngineParameter.EngineParameterCollect.Items[i].Value := FEngineParamData.FData[i];

      FIPCAll.WatchValue2Screen_Analog('', '',i);
      LDataOk := True;
    end;
  end;//for

  //상속 받은 자손에서 구현할 것
  {if LDataOk then
  begin
    Timer1.Enabled := True;
    FPJHTimerPool.AddOneShot(OnTrigger4AvgSave,2000);
    DataSaveByEvent;
  end;
  }
end;

{ THIC_Method }

constructor THIC_Method.create(AIPCAll: TFrameIPCMonitorAll);
begin
  FIPCAll := AIPCAll;
end;

destructor THIC_Method.destroy;
begin

  inherited;
end;

procedure THIC_Method.HIC_OnSignal(Data: TEventData_HIC);
begin

end;

procedure THIC_Method.OverRide_HIC(AIndex: integer);
var
  i,k, LValue: integer;
  Le: double;
  LRadix: integer;
  LHICData: TEventData_HIC;
begin
  LHICData := TEventData_HIC(TIPCMonitor<TEventData_HIC>(FIPCAll.FIPCMonitorList.Objects[AIndex]).FEventDataRecord);

  if (LHICData.ModBusFunctionCode = 3) or (LHICData.ModBusFunctionCode = 4) then
  begin
    for k := 0 to FIPCAll.FEngineParameter.EngineParameterCollect.Count - 1 do
    begin
      if FIPCAll.FEngineParameter.EngineParameterCollect.Items[k].ParameterSource = psHIC then
      begin
        if LHICData.BlockNo <> FIPCAll.FEngineParameter.EngineParameterCollect.Items[k].BlockNo then
          Continue;

        i := FIPCAll.FEngineParameter.EngineParameterCollect.Items[k].AbsoluteIndex;

        if FIPCAll.FEngineParameter.EngineParameterCollect.Items[k].Alarm then //Analog data
        begin
          if LHICData.ModBusMode = 3 then
          begin
            Le := LHICData.InpDataBuf_f[i];
          end
          else
          begin
            //LValue := ((FKRALData.InpDataBuf[i] shl 16) or FKRALData.InpDataBuf[i+1]);
            //Le := LValue / 10;
            Le := LHICData.InpDataBuf[i];
          end;

//          LRadix := FIPCAll.FEngineParameter.EngineParameterCollect.Items[k].RadixPosition;

          FIPCAll.FEngineParameter.EngineParameterCollect.Items[k].Value := FormatFloat(FIPCAll.FEngineParameter.EngineParameterCollect.Items[i].DisplayFormat,Le);
//          FIPCAll.FEngineParameter.EngineParameterCollect.Items[k].Value := FloatToStrF(Le, ffFixed, 12, LRadix);//,'%.2f');
        end;

        //수신된 데이타를 화면에 뿌려줌
        FIPCAll.Value2Screen_ECS_kumo2(k,LHICData.ModBusMode);
      end;
    end;//for
  end;
end;

{ TPLCMODBUS_Method }

constructor TPLCMODBUS_Method.create(AIPCAll: TFrameIPCMonitorAll);
begin
  FIPCAll := AIPCAll;
end;

destructor TPLCMODBUS_Method.destroy;
begin

  inherited;
end;

procedure TPLCMODBUS_Method.OverRide_PLCMODBUS(AIndex: integer);
var
  i,j,k: integer;
  Le: double;
  LRadix: integer;
  LPLCModbusData: TEventData_Modbus_Standard;
begin
  LPLCModbusData := TEventData_Modbus_Standard(TIPCMonitor<TEventData_Modbus_Standard>(FIPCAll.FIPCMonitorList.Objects[AIndex]).FEventDataRecord);

  if (LPLCModbusData.ModBusFunctionCode = 1) or (LPLCModbusData.ModBusFunctionCode = 2)
    or (LPLCModbusData.ModBusFunctionCode = 3) or (LPLCModbusData.ModBusFunctionCode = 4) then
  begin
    for k := 0 to FIPCAll.FEngineParameter.EngineParameterCollect.Count - 1 do
    begin
      if FIPCAll.FEngineParameter.EngineParameterCollect.Items[k].ParameterSource = psPLC_Modbus then
      begin
        if LPLCModbusData.BlockNo <> FIPCAll.FEngineParameter.EngineParameterCollect.Items[k].BlockNo then
          Continue;

        //AbsoluteIndex에 Modbus Map에서 각 Request별 위치 정보(공유메모리상의 Index)
        i := FIPCAll.FEngineParameter.EngineParameterCollect.Items[k].AbsoluteIndex;

        if FIPCAll.FEngineParameter.EngineParameterCollect.Items[k].Alarm then //Analog data
        begin
          if LPLCModbusData.ModBusMode = 3 then //simulate from csv
          begin
            Le := LPLCModbusData.InpDataBuf_double[i];
          end
          else
          begin
            case FIPCAll.FEngineParameter.EngineParameterCollect.Items[k].MinMaxType of
              mmtInteger: begin
                if FIPCAll.FEngineParameter.EngineParameterCollect.Items[k].MaxValue > 0 then
                  Le := LPLCModbusData.InpDataBuf[i]/FIPCAll.FEngineParameter.EngineParameterCollect.Items[k].MaxValue
                else
                  Le := LPLCModbusData.InpDataBuf[i];
              end;
              mmtReal: begin
                if FIPCAll.FEngineParameter.EngineParameterCollect.Items[k].MaxValue_Real > 0.0 then
                  Le := LPLCModbusData.InpDataBuf[i]/FIPCAll.FEngineParameter.EngineParameterCollect.Items[k].MaxValue_Real
                else
                  Le := LPLCModbusData.InpDataBuf[i];
              end;
            end;//case
          end;

//          LRadix := FIPCAll.FEngineParameter.EngineParameterCollect.Items[k].RadixPosition;

          FIPCAll.FEngineParameter.EngineParameterCollect.Items[k].Value := FormatFloat(FIPCAll.FEngineParameter.EngineParameterCollect.Items[k].DisplayFormat, Le);
//          FIPCAll.FEngineParameter.EngineParameterCollect.Items[k].Value := FloatToStrF(Le, ffFixed, 12, LRadix);//,'%.2f');
        end
        else //Digital data
        begin
          i := FIPCAll.FEngineParameter.EngineParameterCollect.Items[k].AbsoluteIndex;

          j := FIPCAll.FEngineParameter.EngineParameterCollect.Items[k].RadixPosition;
          //0이 아니면 True임
          FIPCAll.FEngineParameter.EngineParameterCollect.Items[k].Value := IntToStr(GetBitVal(LPLCModbusData.InpDataBuf[i], j));
        end;

                  //수신된 데이타를 화면에 뿌려줌
        FIPCAll.Value2Screen_ECS_Woodward(k,LPLCModbusData.ModBusMode);
      end;
    end;//for
  end;
end;

procedure TPLCMODBUS_Method.PLCMODBUS_OnSignal(
  Data: TEventData_Modbus_Standard);
var
  i,dcount: integer;
  j: integer;
begin
  j := FIPCAll.FIPCMonitorList.IndexOf(FPSnSN);

  if j <> -1 then
  begin
    with TEventData_Modbus_Standard(TIPCMonitor<TEventData_Modbus_Standard>(FIPCAll.FIPCMonitorList.Objects[j]).FEventDataRecord) do
    begin
      if not FIPCAll.FCompleteReadMap_Woodward then
        exit;

      dcount := 0;
      FillChar(InpDataBuf[0], High(InpDataBuf) - 1, #0);
      ModBusMode := Data.ModBusMode;

      if Data.ModBusMode = 0 then //ASCII Mode이면
      begin
        //ModePanel.Caption := 'ASCII Mode';
        dcount := Data.NumOfData;
        NumOfBit := Data.NumOfBit;

        for i := 0 to dcount - 1 do
          InpDataBuf[i] := Data.InpDataBuf[i];
      end
      else
      if Data.ModBusMode = 1 then// RTU Mode 이면
      begin
        dcount := Data.NumOfData div 2;
        NumOfBit := Data.NumOfBit;

        if dcount = 0 then
          Inc(dcount);

        for i := 0 to dcount - 1 do
        begin
          InpDataBuf[i] := Data.InpDataBuf2[i*2] ;
          InpDataBuf[i] := InpDataBuf[i] shl 8 + Data.InpDataBuf2[i*2 + 1];
        end;

        if (Data.NumOfData mod 2) > 0 then
          InpDataBuf[i] := Data.InpDataBuf2[i*2] ;
      end//Data.ModBusMode = 1
      else
      if (Data.ModBusMode = 4) then //MODBUSTCP_MODE 이면
      begin
        dcount := Data.NumOfData;
        NumOfBit := Data.NumOfBit;
        System.Move(Data.InpDataBuf, InpDataBuf, Sizeof(Data.InpDataBuf));
      end
      else
      if (Data.ModBusMode = 3) then //simulate from csv file
      begin
        dcount := Data.NumOfData;
        NumOfBit := Data.NumOfBit;
        System.Move(Data.InpDataBuf_double, InpDataBuf_double, Sizeof(Data.InpDataBuf_double));
      end//Data.ModBusMode = 3
      else
      if (Data.ModBusMode = 5) then//MODBUSSERIAL_TCP_MODE
      begin
        dcount := Data.NumOfData;
        NumOfBit := Data.NumOfBit;
        System.Move(Data.InpDataBuf, InpDataBuf, Sizeof(Data.InpDataBuf));
      end;

      ModBusAddress := Data.ModBusAddress;
      BlockNo := Data.BlockNo;
      NumOfData := dcount;
      ModBusFunctionCode := Data.ModBusFunctionCode;
      ModBusMapFileName := Data.ModBusMapFileName;
      FIPCAll.FModBusMapFileName := Data.ModBusMapFileName;

      FIPCAll.DisplayMessage2SB(FIPCAll.FStatusBar, ModBusAddress + ' 데이타 도착');

      SendMessage(FIPCAll.Handle, WM_EVENT_PLCMODBUS, j,0);
      CommonCommunication(psPLC_Modbus);
    end;
  end;
end;

{ TPMS_Method }

constructor TPMS_Method.create(AIPCAll: TFrameIPCMonitorAll);
begin
  FIPCAll := AIPCAll;
end;

destructor TPMS_Method.destroy;
begin

  inherited;
end;

procedure TPMS_Method.OverRide_PMS(AIndex: integer);
var
  i, LRadix: integer;
  LDataOk: Boolean;
  FPMSData: TEventData_PMS;
begin
  FPMSData := TEventData_PMS(TIPCMonitor<TEventData_PMS>(FIPCAll.FIPCMonitorList.Objects[AIndex]).FEventDataRecord);

  for i := 0 to FIPCAll.FEngineParameter.EngineParameterCollect.Count - 1 do
  begin
    if FIPCAll.FEngineParameter.EngineParameterCollect.Items[i].ParameterSource = psPMSOPC then
    begin
//      LRadix := FIPCAll.FEngineParameter.EngineParameterCollect.Items[i].RadixPosition;

      FIPCAll.FEngineParameter.EngineParameterCollect.Items[i].Value := FPMSData.InpDataBuf[i];
      FIPCAll.WatchValue2Screen_Analog('', '',i);
      LDataOk := True;
    end;
  end;
end;

procedure TPMS_Method.PMS_OnSignal(Data: TEventData_PMS);
var
  i, j: integer;
begin
  j := FIPCAll.FIPCMonitorList.IndexOf(FPSnSN);

  if j <> -1 then
  begin
    with TEventData_PMS(TIPCMonitor<TEventData_PMS>(FIPCAll.FIPCMonitorList.Objects[j]).FEventDataRecord) do
    begin
      for i := 0 to High(InpDataBuf) - 1 do
        InpDataBuf[i] := Data.InpDataBuf[i];

      SendMessage(FIPCAll.Handle, WM_EVENT_PMS, j,0);
      CommonCommunication(psPMSOPC);
    end;
  end;
end;

end.

