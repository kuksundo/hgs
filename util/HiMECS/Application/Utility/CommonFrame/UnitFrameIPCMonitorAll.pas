unit UnitFrameIPCMonitorAll;
{
  ParameterSource 추가 시 수정해야 하는 내용>--
    FECSData_ComAP2: TEventData_Modbus_Standard;
    FIPCMonitor_ECS_ComAP2: TIPCMonitor<TEventData_Modbus_Standard>;//ComAP ECS
    procedure UpdateTrace_ECS_ComAP2(var Msg: TEventData_Modbus_Standard); message WM_EVENT_ECS_COMAP2; 함수 추가
    procedure ECS_OnSignal_ComAP2(Data: TEventData_Modbus_Standard); virtual; 함수 추가
    procedure OverRide_ECS_ComAP2(AData: TEventData_Modbus_Standard); virtual; 함수 추가
    procedure OnSetZeroECS_ComAP2(Sender : TObject; Handle : Integer; 함수 추가
            Interval : Cardinal; ElapsedTime : LongInt);
    procedure CreateECSComAPIPCMonitor2(AEP_DragDrop: TEngineParameterItemRecord); 함수 추가
    function CreateIPCMonitor(AEP_DragDrop: TEngineParameterItemRecord; AIsOnlyCreate: Boolean = False;
              ADragCopyMode: TParamDragCopyMode = dcmCopyOnlyNonExist): integer;  에서 내용 수정
    function GetEventName(APSrc: TParameterSource): string; 에서 내용 수정
    function AssignedIPCMonitor(AIPCMonitor: TParameterSource): Boolean; 에서 내용 수정
   --<

  Drag Drop과 WM_COPYDATA는 메인 폼에서 구현 할 것
 }
interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms, ComCtrls,
  Dialogs, NxCustomGridControl, NxCustomGrid, NxGrid, JvStatusBar, ShadowButton,
  TimerPool, DragDrop, DropTarget, DragDropText, AdvOfficePager,
  UnitFrameIPCConst, CommonUtil, DeCAL, HiMECSConst,//janSQL,
  ConfigOptionClass, EngineParameterClass, ModbusComStruct,
  IPC_LBX_Const, IPC_WT1600_Const, IPC_ECS_kumo_Const, IPC_MEXA7000_Const,
  IPC_MT210_Const, IPC_DYNAMO_Const, IPC_ECS_AVAT_Const, IPC_GasCalc_Const,
  IPC_Kral_Const, IPC_ECS_Woodward_Const, IPC_PLC_S7_Const, IPC_FlowMeter_Const,
  IPC_EngineParam_Const, IPC_HIC_Const, IPC_Modbus_Standard_Const,
  IPCThreadEvent, IPCThrdMonitor_Generic, IPC_PMS_Const, Generics.Collections
 {$IFDEF USECODESITE} ,CodeSiteLogging {$ENDIF};

type
  TWatchValue2Screen_AnalogEvent =
    procedure(Name: string; AValue: string; AEPIndex: integer) of object;
  TWatchValue2Screen_DigitalEvent =
    procedure(Name: string; AValue: string; AEPIndex: integer) of object;
  TWatchValue2Screen_2 = procedure of object;
  TEventData_WT1600_List = TDictionary<string, TIPCMonitor<TEventData_WT1600>>;
  TEventData_PLCMODBUS_List = TDictionary<string, TIPCMonitor<TEventData_Modbus_Standard>>;

  TFrameIPCMonitor = class(TFrame)
  private
    FAddressMap: DMap;      //Modbus Map 데이타 저장 구초체

    FECSData_kumo: TEventData_ECS_kumo;
    FECSData_AVAT: TEventData_ECS_AVAT;
    FECSData_Woodward: TEventData_ECS_Woodward;
    FMEXA7000Data: TEventData_MEXA7000_2;
    FLBXData: TEventData_LBX;
    FWT1600Data: TEventData_WT1600;
    FMT210Data: TEventData_MT210;
    FDYNAMOData: TEventData_DYNAMO;
    FFlowMeterData: TEventData_FlowMeter;
    FGasCalcData: TEventData_GasCalc;
    FKRALData: TEventData_Modbus_Standard;
    FPLCData_S7: TEventData_PLC_S7;
    FEngineParamData: TEventData_EngineParam;
    FHICData: TEventData_HIC;
    FPLCModbusData: TEventData_Modbus_Standard;
    FPMSData: TEventData_PMS;
    FECSData_ComAP: TEventData_Modbus_Standard;
    FECSData_ComAP2: TEventData_Modbus_Standard;

    //복수개의 WT1600을 한개의 AMSReporter에서 모니터링할 때 필요함
    //<ProjNo_EngNo, TEventData_WT1600>
    FEventData_WT1600_List: TEventData_WT1600_List;
    FEventData_PLCMODBUS_List: TEventData_PLCMODBUS_List;

    FIPCMonitor_WT1600: TIPCMonitor<TEventData_WT1600>;//WT1600
    FIPCMonitor_MEXA7000: TIPCMonitor<TEventData_MEXA7000_2>;//MEXA7000
    FIPCMonitor_MT210: TIPCMonitor<TEventData_MT210>;//MT210
    FIPCMonitor_ECS_kumo: TIPCMonitor<TEventData_ECS_kumo>;//kumo ECS
    FIPCMonitor_ECS_AVAT: TIPCMonitor<TEventData_ECS_AVAT>;//AVAT ECS
    FIPCMonitor_ECS_Woodward: TIPCMonitor<TEventData_ECS_Woodward>; //Woodward(AtlasII) ECS
    FIPCMonitor_LBX: TIPCMonitor<TEventData_LBX>;//LBX
    FIPCMonitor_FlowMeter: TIPCMonitor<TEventData_FlowMeter>;//FlowMeter
    FIPCMonitor_Dynamo: TIPCMonitor<TEventData_DYNAMO>;//DynamoMeter
    FIPCMonitor_GasCalc: TIPCMonitor<TEventData_GasCalc>;//Gas Total
    FIPCMonitor_KRAL: TIPCMonitor<TEventData_Modbus_Standard>;//FlowMeter(KRAL)
    FIPCMonitor_PLC_S7: TIPCMonitor<TEventData_PLC_S7>;//Siemens PLC S7-300
    FIPCMonitor_EngineParam: TIPCMonitor<TEventData_EngineParam>;//Engine Parameter File
    FIPCMonitor_HIC: TIPCMonitor<TEventData_HIC>;//Hybrid Injector Controller
    FIPCMonitor_PLCModbus: TIPCMonitor<TEventData_Modbus_Standard>;//PLC Modbus
    FIPCMonitor_PMS: TIPCMonitor<TEventData_PMS>;//PMS OPC
    FIPCMonitor_ECS_ComAP: TIPCMonitor<TEventData_Modbus_Standard>;//ComAP ECS
    FIPCMonitor_ECS_ComAP2: TIPCMonitor<TEventData_Modbus_Standard>;//ComAP ECS

    procedure UpdateTrace_WT1600(var Msg: TMessage); message WM_EVENT_WT1600;
    procedure UpdateTrace_MEXA7000(var Msg: TEventData_MEXA7000); message WM_EVENT_MEXA7000;
    procedure UpdateTrace_MT210(var Msg: TEventData_MT210); message WM_EVENT_MT210;
    procedure UpdateTrace_ECS_kumo(var Msg: TEventData_ECS_kumo); message WM_EVENT_ECS_KUMO;
    procedure UpdateTrace_ECS_AVAT(var Msg: TEventData_ECS_AVAT); message WM_EVENT_ECS_AVAT;
    procedure UpdateTrace_ECS_Woodward(var Msg: TEventData_ECS_Woodward); message WM_EVENT_ECS_Woodward;
    procedure UpdateTrace_LBX(var Msg: TEventData_LBX); message WM_EVENT_LBX;
    procedure UpdateTrace_FlowMeter(var Msg: TEventData_FlowMeter); message WM_EVENT_FLOWMETER;
    procedure UpdateTrace_DYNAMO(var Msg: TEventData_DYNAMO); message WM_EVENT_DYNAMO;
    procedure UpdateTrace_GasCalc(var Msg: TEventData_GasCalc); message WM_EVENT_GASCALC;
    procedure UpdateTrace_KRAL(var Msg: TEventData_Modbus_Standard); message WM_EVENT_KRAL;
    procedure UpdateTrace_PLC_S7(var Msg: TEventData_PLC_S7); message WM_EVENT_PLC_S7;
    procedure UpdateTrace_EngineParam(var Msg: TEventData_EngineParam); message WM_EVENT_ENGINEPARAM;
    procedure UpdateTrace_HIC(var Msg: TEventData_HIC); message WM_EVENT_HIC;
    procedure UpdateTrace_PLCMODBUS(var Msg: TMessage); message WM_EVENT_PLCMODBUS;
    procedure UpdateTrace_PMS(var Msg: TEventData_PMS); message WM_EVENT_PMS;
    procedure UpdateTrace_ECS_ComAP(var Msg: TEventData_Modbus_Standard); message WM_EVENT_ECS_COMAP;
    procedure UpdateTrace_ECS_ComAP2(var Msg: TEventData_Modbus_Standard); message WM_EVENT_ECS_COMAP2;

    //WM_COPYDATA message를 받지 못함. Main Form에서 대신 처리
    //procedure WMCopyData(var Msg: TMessage); message WM_COPYDATA;

    procedure SendFormCopyData(ToHandle: integer; AForm:TForm);
  protected
    FEnterWatchValue2Screen: Boolean;
    FDestroying: Boolean;
    FEngineParameterItemRecord: TEngineParameterItemRecord; //Save폼에 값 전달시 사용
    FIsUseIPCSharedMMEvent: Boolean;

    procedure WT1600_OnSignal(Data: TEventData_WT1600); virtual;
    procedure MEXA7000_OnSignal(Data: TEventData_MEXA7000); virtual;
    procedure MEXA7000_2_OnSignal(Data: TEventData_MEXA7000_2); virtual;
    procedure MT210_OnSignal(Data: TEventData_MT210); virtual;
    procedure ECS_OnSignal_kumo(Data: TEventData_ECS_kumo); virtual;
    procedure ECS_OnSignal_AVAT(Data: TEventData_ECS_AVAT); virtual;
    procedure ECS_OnSignal_Woodward(Data: TEventData_ECS_Woodward); virtual;
    procedure LBX_OnSignal(Data: TEventData_LBX); virtual;
    procedure FlowMeter_OnSignal(Data: TEventData_FlowMeter); virtual;
    procedure DYNAMO_OnSignal(Data: TEventData_DYNAMO); virtual;
    procedure GasCalc_OnSignal(Data: TEventData_GasCalc); virtual;
    procedure KRAL_OnSignal(Data: TEventData_Modbus_Standard); virtual;
    procedure PLC_S7_OnSignal(Data: TEventData_PLC_S7); virtual;
    procedure EngineParam_OnSignal(Data: TEventData_EngineParam); virtual;
    procedure HIC_OnSignal(Data: TEventData_HIC); virtual;
    procedure PLCMODBUS_OnSignal(Data: TEventData_Modbus_Standard); virtual;
    procedure PMS_OnSignal(Data: TEventData_PMS); virtual;
    procedure ECS_OnSignal_ComAP(Data: TEventData_Modbus_Standard); virtual;
    procedure ECS_OnSignal_ComAP2(Data: TEventData_Modbus_Standard); virtual;

    procedure OverRide_WT1600(AData: TEventData_WT1600); virtual;
    procedure OverRide_MEXA7000(AData: TEventData_MEXA7000_2); virtual;
    procedure OverRide_MT210(AData: TEventData_MT210); virtual;
    procedure OverRide_ECS_kumo(AData: TEventData_ECS_kumo); virtual;
    procedure OverRide_ECS_kumo2(AData: TEventData_ECS_kumo); virtual;
    procedure OverRide_ECS_kumo3(AData: TEventData_ECS_kumo); virtual;
    procedure OverRide_ECS_AVAT(AData: TEventData_ECS_AVAT); virtual;
    procedure OverRide_ECS_Woodward(AData: TEventData_ECS_Woodward); virtual;
    procedure OverRide_LBX(AData: TEventData_LBX); virtual;
    procedure OverRide_FlowMeter(AData: TEventData_FlowMeter); virtual;
    procedure OverRide_DYNAMO(AData: TEventData_DYNAMO); virtual;
    procedure OverRide_GasCalc(AData: TEventData_GasCalc); virtual;
    procedure OverRide_KRAL(AData: TEventData_Modbus_Standard); virtual;
    procedure OverRide_PLC_S7(AData: TEventData_PLC_S7); virtual;
    procedure OverRide_EngineParam(AData: TEventData_EngineParam); virtual;
    procedure OverRide_HIC(AData: TEventData_HIC); virtual;
    procedure OverRide_PLCMODBUS(AData: TEventData_Modbus_Standard); virtual;
    procedure OverRide_PMS(AData: TEventData_PMS); virtual;
    procedure OverRide_ECS_ComAP(AData: TEventData_Modbus_Standard); virtual;
    procedure OverRide_ECS_ComAP2(AData: TEventData_Modbus_Standard); virtual;

    procedure CommonCommunication(AParameterSource: TParameterSource);

    procedure WatchValue2Screen_Analog(Name: string; AValue: string;
                           AEPIndex: integer; AIsFloat: Boolean = false);
    procedure WatchValue2Screen_Digital(Name: string; AValue: string;
                           AEPIndex: integer);
    procedure WatchValue2Grid(AValue: string; AEPIndex: integer; AIsFloat: Boolean = false);

    procedure Value2Screen_ECS_kumo(AHiMap: THiMap; AEPIndex: integer; AModbusMode: integer);
    procedure Value2Screen_ECS_kumo2(AEPIndex: integer; AModbusMode: integer);
    procedure Value2Screen_ECS_AVAT(AHiMap: THiMap; AEPIndex: integer; AModbusMode: integer);
    procedure Value2Screen_ECS_Woodward(AEPIndex: integer; AModbusMode: integer = 0);
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
    procedure OnSetZeroECS_ComAP2(Sender : TObject; Handle : Integer;
            Interval : Cardinal; ElapsedTime : LongInt);
  public
    //데이터 한건 당 한번씩 Trigger됨
    FWatchValue2Screen_AnalogEvent: TWatchValue2Screen_AnalogEvent;
    FWatchValue2Screen_DigitalEvent: TWatchValue2Screen_DigitalEvent;
    //데이터를 모두 읽은 후 한번만 Trigger됨
    FWatchValue2Screen_2: TWatchValue2Screen_2;
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
    FCommDisconnected: Boolean;// 통신이 일정시간 동안 안되면 True
    FPJHTimerPool: TPJHTimerPool;

    //여러 장비를 동시에 통신할 경우 속도 개선을 위해 Engine Parameter 에서 MT210 Data가 시작하는 Index를 저장함
    //특히 Gas Engine Parameter 계산 시 필요함
    //CreateIPCMonitorFromParameter 함수에서 Parameter File을 읽을 경우에만(Drag Drop이 아닌) 값을 저장 함
    FMT210StartIndex: integer;
    FWT1600StartIndex: integer;
    FMEXA7000StartIndex: integer;

    FLastExecutedState: string;

    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;

    procedure InitVar;
    procedure DestroyVar;
    procedure ClearEventData_WT1600_List(AUniqueEngineName: string = '');
    procedure SetEventData_WT1600_List(AUniqueEngineName: string);
    procedure ClearEventData_PLCMODBUS_List(AUniqueEngineName: string = '');
    procedure SetEventData_PLCMODBUS_List(AUniqueEngineName: string);

    function CreateIPCMonitor(AEP_DragDrop: TEngineParameterItemRecord;
                            AIsOnlyCreate: Boolean = False;
              ADragCopyMode: TParamDragCopyMode = dcmCopyOnlyNonExist): integer;
    procedure CreateIPCMonitorFromParameter(var AIPCList: TStringList);
    procedure DestroyIPCMonitor(AIPCMonitor: TParameterSource);
    procedure DestroyIPCMonitorAll;
    function AssignedIPCMonitor(AIPCMonitor: TParameterSource): Boolean;

    procedure CreateECSkumoIPCMonitor(AEP_DragDrop: TEngineParameterItemRecord);
    procedure CreateECSkumo2IPCMonitor(AEP_DragDrop: TEngineParameterItemRecord);//7H21C용 금오기전 제어기
    procedure CreateECSAVATIPCMonitor(AEP_DragDrop: TEngineParameterItemRecord);
    procedure CreateECSWoodwardIPCMonitor(AEP_DragDrop: TEngineParameterItemRecord);
    procedure CreateWT1600IPCMonitor(AEP_DragDrop: TEngineParameterItemRecord; AUniqueEngineName: string);
    procedure CreateMT210IPCMonitor(AEP_DragDrop: TEngineParameterItemRecord);
    procedure CreateMEXA7000IPCMonitor(AEP_DragDrop: TEngineParameterItemRecord);
    procedure CreateLBXIPCMonitor(AEP_DragDrop: TEngineParameterItemRecord);
    procedure CreateFlowMeterIPCMonitor(AEP_DragDrop: TEngineParameterItemRecord);
    procedure CreateDynamoIPCMonitor(AEP_DragDrop: TEngineParameterItemRecord);
    procedure CreateGasCalcIPCMonitor(AEP_DragDrop: TEngineParameterItemRecord);
    procedure CreateKRALIPCMonitor(AEP_DragDrop: TEngineParameterItemRecord);
    procedure CreatePLCS7IPCMonitor(AEP_DragDrop: TEngineParameterItemRecord);
    procedure CreateEngineParamIPCMonitor(AEP_DragDrop: TEngineParameterItemRecord);
    procedure CreateHICIPCMonitor(AEP_DragDrop: TEngineParameterItemRecord);
    procedure CreatePLCMODBUSIPCMonitor(AEP_DragDrop: TEngineParameterItemRecord; AUniqueEngineName: string);
    procedure CreatePMSIPCMonitor(AEP_DragDrop: TEngineParameterItemRecord);
    procedure CreateECSComAPIPCMonitor(AEP_DragDrop: TEngineParameterItemRecord);
    procedure CreateECSComAPIPCMonitor2(AEP_DragDrop: TEngineParameterItemRecord);

    function CreateIPCMonitor_xx(AParameterSource: TParameterSource; ASharedName, AProjNo, AEngNo: string): String;
    function CreateIPCMonitor_ECS_AVAT(ASharedName: string = ''; AProjNo: string = ''; AEngNo: string = ''): String;
    function CreateIPCMonitor_ECS_Woodward(ASharedName: string = ''; AProjNo: string = ''; AEngNo: string = ''): String;
    function CreateIPCMonitor_DYNAMO(ASharedName: string = ''; AProjNo: string = ''; AEngNo: string = ''): String;
    function CreateIPCMonitor_FlowMeter(ASharedName: string = ''; AProjNo: string = ''; AEngNo: string = ''): String;
    function CreateIPCMonitor_LBX(ASharedName: string = ''; AProjNo: string = ''; AEngNo: string = ''): String;
    function CreateIPCMonitor_ECS_kumo(ASharedName: string = ''; AProjNo: string = ''; AEngNo: string = ''): String;
    function CreateIPCMonitor_ECS_kumo2(ASharedName: string = ''; AProjNo: string = ''; AEngNo: string = ''): String;
    function CreateIPCMonitor_MT210(ASharedName: string = ''; AProjNo: string = ''; AEngNo: string = ''): String;
    function CreateIPCMonitor_MEXA7000(ASharedName: string = ''; AProjNo: string = ''; AEngNo: string = ''): String;
    function CreateIPCMonitor_WT1600(ASharedName: string = ''; AProjNo: string = ''; AEngNo: string = ''): String;
    function CreateIPCMonitor_GasCalc(ASharedName: string = ''; AProjNo: string = ''; AEngNo: string = ''): String;
    function CreateIPCMonitor_KRAL(ASharedName: string = ''; AProjNo: string = ''; AEngNo: string = ''): String;
    function CreateIPCMonitor_PLC_S7(ASharedName: string = ''; AProjNo: string = ''; AEngNo: string = ''): String;
    function CreateIPCMonitor_EngineParam(ASharedName: string = ''; AProjNo: string = ''; AEngNo: string = ''): String;
    function CreateIPCMonitor_HIC(ASharedName: string = ''; AProjNo: string = ''; AEngNo: string = ''): String;
    function CreateIPCMonitor_PLCMODBUS(ASharedName: string = ''; AProjNo: string = ''; AEngNo: string = ''): String;
    function CreateIPCMonitor_PMS(ASharedName: string = ''; AProjNo: string = ''; AEngNo: string = ''): String;

    procedure ProcessDataFromMQ(AJson: string);

    function MoveEngineParameterItemRecord(AEPItemRecord:TEngineParameterItemRecord;
                 ADragCopyMode: TParamDragCopyMode = dcmCopyOnlyNonExist): integer; virtual;
    procedure MoveEngineParameterItemRecord2(var AItemRecord: TEngineParameterItemRecord;
                                              AItemIndex: integer);

//    procedure ReadMapAddress(AddressMap: DMap; MapFileName: string); virtual;
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
    procedure SetValue2ScreenEvent_2(AFunc: TWatchValue2Screen_2);
    procedure SetIsUseIPCSharedMMEvent(AValue: Boolean);

    procedure GetParameterSourceList(var AList: TStringList);
    function GetEventName(APSrc: TParameterSource): string;
    procedure AppendEngParam(AEP: TEngineParameterCollect);
    function GetEventData_PLCMODBUS_ListCount: integer;
    function GetEventData_PLCMODBUS_ListName: string;
    function GetEngineName: string;
  end;

implementation

uses OtlComm, SynCommons;

{$R *.dfm}

{ TFrame1 }

//IPC Monitor가 할당 되었으면 True 반환
procedure TFrameIPCMonitor.AppendEngParam(
  AEP: TEngineParameterCollect);
begin
  FEngineparameter.EngineParameterCollect.AddEngineParameterCollect(AEP);
end;

function TFrameIPCMonitor.AssignedIPCMonitor(
  AIPCMonitor: TParameterSource): Boolean;
begin
  case TParameterSource(AIPCMonitor) of
    psECS_kumo: Result := Assigned(FIPCMonitor_ECS_kumo);
    psECS_kumo2: Result := Assigned(FIPCMonitor_ECS_kumo);
    psECS_AVAT: Result := Assigned(FIPCMonitor_ECS_AVAT);
    psMT210: Result := Assigned(FIPCMonitor_MT210);
    psMEXA7000: Result := Assigned(FIPCMonitor_MEXA7000);
    psLBX: Result := Assigned(FIPCMonitor_LBX);
    psFlowMeter: Result := Assigned(FIPCMonitor_ECS_kumo);
    psWT1600: Result := Assigned(FIPCMonitor_WT1600);
    psGasCalculated: Result := Assigned(FIPCMonitor_GasCalc);
    psECS_Woodward: Result := Assigned(FIPCMonitor_ECS_Woodward);
    psDynamo: Result := Assigned(FIPCMonitor_Dynamo);
    psPLC_S7: Result := Assigned(FIPCMonitor_PLC_S7);
    psEngineParam: Result := Assigned(FIPCMonitor_EngineParam);
    psHIC: Result := Assigned(FIPCMonitor_HIC);
    psPLC_Modbus: Result := Assigned(FIPCMonitor_PLCModbus);
    psPMSOPC: Result := Assigned(FIPCMonitor_PMS);
    psECS_ComAP: Result := Assigned(FIPCMonitor_ECS_ComAP);
    psECS_ComAP2: Result := Assigned(FIPCMonitor_ECS_ComAP2);
  else
    Result := False;
  end;
end;

//Exe Name과 filename이 다를 경우 Result에 exe name을 반환함
function TFrameIPCMonitor.CheckExeFileNameForWatchListFile(
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

function TFrameIPCMonitor.CheckExistTagName(AParameterSource: TParameterSource;
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
function TFrameIPCMonitor.CheckUserLevelForWatchListFile(AFileName: string;
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

procedure TFrameIPCMonitor.ClearEventData_PLCMODBUS_List(
  AUniqueEngineName: string);
var
  LKey: string;
//  LEventData: PEventData_Modbus_Standard;
  LIPCMonitor: TIPCMonitor<TEventData_Modbus_Standard>;
begin
  if AUniqueEngineName = '' then
  begin
    for LKey in FEventData_PLCMODBUS_List.Keys do
    begin
//      LEventData := @FEventData_PLCMODBUS_List.Items[LKey].FEventDataRecord;
//      FreeMem(LEventData, SizeOf(PEventData_Modbus_Standard));
      LIPCMonitor := FEventData_PLCMODBUS_List.Items[LKey];
      LIPCMonitor.Free;
    end;

    FEventData_PLCMODBUS_List.Clear;
  end
  else
  if FEventData_PLCMODBUS_List.ContainsKey(AUniqueEngineName) then
    FEventData_PLCMODBUS_List.Remove(AUniqueEngineName);
end;

procedure TFrameIPCMonitor.ClearEventData_WT1600_List(AUniqueEngineName: string);
var
  LKey: string;
//  LEventData_WT1600: PEventData_WT1600;
  LIPCMonitor_WT1600: TIPCMonitor<TEventData_WT1600>;
begin
  if AUniqueEngineName = '' then
  begin
    for LKey in FEventData_WT1600_List.Keys do
    begin
//      LEventData_WT1600 := @FEventData_WT1600_List.Items[LKey].FEventDataRecord;
//      FreeMem(LEventData_WT1600,SizeOf(TEventData_WT1600));
      LIPCMonitor_WT1600 := FEventData_WT1600_List.Items[LKey];
      LIPCMonitor_WT1600.Free;
    end;

    FEventData_WT1600_List.Clear;
  end
  else
  if FEventData_WT1600_List.ContainsKey(AUniqueEngineName) then
    FEventData_WT1600_List.Remove(AUniqueEngineName);
end;

procedure TFrameIPCMonitor.CommonCommunication(
  AParameterSource: TParameterSource);
begin
  if FCommDisconnected then
    FCommDisconnected := False;
end;

constructor TFrameIPCMonitor.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);

  InitVar;
end;

procedure TFrameIPCMonitor.CreateDynamoIPCMonitor(
  AEP_DragDrop: TEngineParameterItemRecord);
var
  LSM: string;
  LSM2: string;
begin
  if Assigned(FIPCMonitor_Dynamo) then
    exit;

  if AEP_DragDrop.FSharedName = '' then
    LSM := ParameterSource2SharedMN(AEP_DragDrop.FParameterSource)
  else
    LSM := AEP_DragDrop.FSharedName;

  LSM2 := ParameterSource2SharedMN(psDynamo);

  FIPCMonitor_Dynamo := TIPCMonitor<TEventData_DYNAMO>.Create(LSM, LSM2, True); //DYNAMO_EVENT_NAME
  FIPCMonitor_Dynamo.FIPCObject.OnSignal := Dynamo_OnSignal;
  FIPCMonitor_Dynamo.FreeOnTerminate := True;
  FIPCMonitor_Dynamo.Resume;
end;

procedure TFrameIPCMonitor.CreateECSAVATIPCMonitor(
  AEP_DragDrop: TEngineParameterItemRecord);
var
  LSM: string;
  LSM2: string;
begin
  if Assigned(FIPCMonitor_ECS_AVAT) then
    exit;

//  SetModbusMapFileName('', AEP_DragDrop.FParameterSource);
//  FAddressMap.clear;
//  ReadMapAddress(FAddressMap,FModbusMapFileName);//FConfigOption.ModbusFileName);

  if AEP_DragDrop.FSharedName = '' then
    LSM := ParameterSource2SharedMN(AEP_DragDrop.FParameterSource)
  else
    LSM := AEP_DragDrop.FSharedName;

  LSM2 := ParameterSource2SharedMN(psECS_AVAT);

  FIPCMonitor_ECS_AVAT := TIPCMonitor<TEventData_ECS_AVAT>.Create(LSM, LSM2, True);//ECS_AVAT_EVENT_NAME
//  SetModbusMapFileName('', AEP_DragDrop.FParameterSource);
  FIPCMonitor_ECS_AVAT.FIPCObject.OnSignal := ECS_OnSignal_AVAT;
  FIPCMonitor_ECS_AVAT.FreeOnTerminate := True;
  FIPCMonitor_ECS_AVAT.Resume;

  FCompleteReadMap_Avat := True;
end;

procedure TFrameIPCMonitor.CreateECSComAPIPCMonitor(
  AEP_DragDrop: TEngineParameterItemRecord);
var
  LSM: string;
  LSM2: string;
begin
  if Assigned(FIPCMonitor_ECS_ComAP) then
    exit;

  if AEP_DragDrop.FSharedName = '' then
    LSM := ParameterSource2SharedMN(AEP_DragDrop.FParameterSource)
  else
    LSM := AEP_DragDrop.FSharedName;

  LSM2 := ParameterSource2SharedMN(psECS_ComAP);

  FIPCMonitor_ECS_ComAP := TIPCMonitor<TEventData_Modbus_Standard>.Create(LSM, LSM2, True);//PLCMODBUS_EVENT_NAME
  FIPCMonitor_ECS_ComAP.FIPCObject.OnSignal := ECS_OnSignal_ComAP;
  FIPCMonitor_ECS_ComAP.FreeOnTerminate := True;
  FIPCMonitor_ECS_ComAP.Resume;
end;

procedure TFrameIPCMonitor.CreateECSComAPIPCMonitor2(
  AEP_DragDrop: TEngineParameterItemRecord);
var
  LSM: string;
  LSM2: string;
begin
  if Assigned(FIPCMonitor_ECS_ComAP2) then
    exit;

  if AEP_DragDrop.FSharedName = '' then
    LSM := ParameterSource2SharedMN(AEP_DragDrop.FParameterSource)
  else
    LSM := AEP_DragDrop.FSharedName;

  LSM2 := ParameterSource2SharedMN(psECS_ComAP2);

  FIPCMonitor_ECS_ComAP2 := TIPCMonitor<TEventData_Modbus_Standard>.Create(LSM, LSM2, True);//PLCMODBUS_EVENT_NAME
  FIPCMonitor_ECS_ComAP2.FIPCObject.OnSignal := ECS_OnSignal_ComAP2;
  FIPCMonitor_ECS_ComAP2.FreeOnTerminate := True;
  FIPCMonitor_ECS_ComAP2.Resume;
end;

procedure TFrameIPCMonitor.CreateECSkumo2IPCMonitor(
  AEP_DragDrop: TEngineParameterItemRecord);
var
  LSM: string;
  LSM2: string;
begin
  if Assigned(FIPCMonitor_ECS_kumo) then
    exit;

  if AEP_DragDrop.FSharedName = '' then
    LSM := ParameterSource2SharedMN(AEP_DragDrop.FParameterSource)
  else
    LSM := AEP_DragDrop.FSharedName;

  LSM2 := ParameterSource2SharedMN(psECS_kumo2);

  FIPCMonitor_ECS_kumo := TIPCMonitor<TEventData_ECS_kumo>.Create(LSM, LSM2, True);//ECS_KUMO_EVENT_NAME
  FIPCMonitor_ECS_kumo.FIPCObject.OnSignal := ECS_OnSignal_kumo;
  FIPCMonitor_ECS_kumo.FreeOnTerminate := True;
//  ShowMessage('(' + LSM + ' = ' + LSM2 + ')');
  FIPCMonitor_ECS_kumo.Resume;

  FCompleteReadMap_kumo := True;
end;

procedure TFrameIPCMonitor.CreateECSkumoIPCMonitor(
  AEP_DragDrop: TEngineParameterItemRecord);
var
  LSM: string;
  LSM2: string;
begin
  if Assigned(FIPCMonitor_ECS_kumo) then
    exit;

  //SetModbusMapFileName('', AEP_DragDrop.FParameterSource);

  //FAddressMap.clear;
  //ReadMapAddress(FAddressMap,FModbusMapFileName);//FConfigOption.ModbusFileName);
  //MakeMapFromParameter;

  if AEP_DragDrop.FSharedName = '' then
    LSM := ParameterSource2SharedMN(AEP_DragDrop.FParameterSource)
  else
    LSM := AEP_DragDrop.FSharedName;

  LSM2 := ParameterSource2SharedMN(psECS_kumo);

  FIPCMonitor_ECS_kumo := TIPCMonitor<TEventData_ECS_kumo>.Create(LSM, LSM2, True);//ECS_KUMO_EVENT_NAME
  FIPCMonitor_ECS_kumo.FIPCObject.OnSignal := ECS_OnSignal_kumo;
  FIPCMonitor_ECS_kumo.FreeOnTerminate := True;
//  ShowMessage('(' + LSM + ' = ' + LSM2 + ')');
  FIPCMonitor_ECS_kumo.Resume;

  FCompleteReadMap_kumo := True;
end;

procedure TFrameIPCMonitor.CreateECSWoodwardIPCMonitor(
  AEP_DragDrop: TEngineParameterItemRecord);
var
  LSM: string;
  LSM2: string;
begin
  if Assigned(FIPCMonitor_ECS_Woodward) then
    exit;

  //SetModbusMapFileName('', AEP_DragDrop.FParameterSource);
//  FAddressMap.clear;
//  ReadMapAddress(FAddressMap,FModbusMapFileName);//FConfigOption.ModbusFileName);

  if AEP_DragDrop.FSharedName = '' then
    LSM := ParameterSource2SharedMN(AEP_DragDrop.FParameterSource)
  else
    LSM := AEP_DragDrop.FSharedName;

  LSM2 := ParameterSource2SharedMN(psECS_Woodward);

  FIPCMonitor_ECS_Woodward := TIPCMonitor<TEventData_ECS_Woodward>.Create(LSM, LSM2, True);//ECS_WOODWARD_EVENT_NAME
  FIPCMonitor_ECS_Woodward.FIPCObject.OnSignal := ECS_OnSignal_Woodward;
  FIPCMonitor_ECS_Woodward.FreeOnTerminate := True;
  FIPCMonitor_ECS_Woodward.Resume;

  FCompleteReadMap_Woodward := True;
end;

procedure TFrameIPCMonitor.CreateEngineParamIPCMonitor(
  AEP_DragDrop: TEngineParameterItemRecord);
var
  LSM: string;
  LSM2: string;
begin
  if Assigned(FIPCMonitor_EngineParam) then
    exit;

  if AEP_DragDrop.FSharedName = '' then
    LSM := ParameterSource2SharedMN(AEP_DragDrop.FParameterSource)
  else
    LSM := AEP_DragDrop.FSharedName;

  LSM2 := ParameterSource2SharedMN(psEngineParam);

  FIPCMonitor_EngineParam := TIPCMonitor<TEventData_EngineParam>.Create(LSM, LSM2, True); //ENGINEPARAM_EVENT_NAME
  FIPCMonitor_EngineParam.FreeOnTerminate := True;
  FIPCMonitor_EngineParam.FIPCObject.OnSignal := EngineParam_OnSignal;
  FIPCMonitor_EngineParam.Resume;
end;

procedure TFrameIPCMonitor.CreateFlowMeterIPCMonitor(
  AEP_DragDrop: TEngineParameterItemRecord);
var
  LSM: string;
  LSM2: string;
begin
  if Assigned(FIPCMonitor_FlowMeter) then
    exit;

  if AEP_DragDrop.FSharedName = '' then
    LSM := ParameterSource2SharedMN(AEP_DragDrop.FParameterSource)
  else
    LSM := AEP_DragDrop.FSharedName;

  LSM2 := ParameterSource2SharedMN(psFlowMeter);

  FIPCMonitor_FlowMeter := TIPCMonitor<TEventData_FlowMeter>.Create(LSM, LSM2, True);//FLOWMETER_EVENT_NAME
  FIPCMonitor_FlowMeter.FIPCObject.OnSignal := FlowMeter_OnSignal;
  FIPCMonitor_FlowMeter.FreeOnTerminate := True;
  FIPCMonitor_FlowMeter.Resume;
end;

procedure TFrameIPCMonitor.CreateGasCalcIPCMonitor(
  AEP_DragDrop: TEngineParameterItemRecord);
var
  LSM: string;
  LSM2: string;
begin
  if Assigned(FIPCMonitor_GasCalc) then
    exit;

  if AEP_DragDrop.FSharedName = '' then
    LSM := ParameterSource2SharedMN(AEP_DragDrop.FParameterSource)
  else
    LSM := AEP_DragDrop.FSharedName;

  LSM2 := ParameterSource2SharedMN(psGasCalculated);

  FIPCMonitor_GasCalc := TIPCMonitor<TEventData_GasCalc>.Create(LSM, LSM2, True);//GASCALC_EVENT_NAME
  FIPCMonitor_GasCalc.FreeOnTerminate := True;
  FIPCMonitor_GasCalc.FIPCObject.OnSignal := GasCalc_OnSignal;
  FIPCMonitor_GasCalc.Resume;
end;

procedure TFrameIPCMonitor.CreateHICIPCMonitor(
  AEP_DragDrop: TEngineParameterItemRecord);
var
  LSM: string;
  LSM2: string;
begin
  if Assigned(FIPCMonitor_HIC) then
    exit;

  if AEP_DragDrop.FSharedName = '' then
    LSM := ParameterSource2SharedMN(AEP_DragDrop.FParameterSource)
  else
    LSM := AEP_DragDrop.FSharedName;

  LSM2 := ParameterSource2SharedMN(psHIC);

  FIPCMonitor_HIC := TIPCMonitor<TEventData_HIC>.Create(LSM, LSM2, True);//HIC_EVENT_NAME
  FIPCMonitor_HIC.FreeOnTerminate := True;
  FIPCMonitor_HIC.FIPCObject.OnSignal := HIC_OnSignal;
  FIPCMonitor_HIC.Resume;
end;

//AIsOnlyCreate = True : AEP_DragDrop Record를 EngineParamItem에 Assign 하지 않고 IPCMonitor만 생성함.
function TFrameIPCMonitor.CreateIPCMonitor(AEP_DragDrop: TEngineParameterItemRecord;
  AIsOnlyCreate: Boolean = False; ADragCopyMode: TParamDragCopyMode = dcmCopyOnlyNonExist): integer;
var
  LUniqueEngineName: string;
begin
  if not AIsOnlyCreate then
    //AEP_DragDrop Record를 EngineParamItem에 Add
    Result := MoveEngineParameterItemRecord(AEP_DragDrop, ADragCopyMode);

  LUniqueEngineName := AEP_DragDrop.FProjNo + '_' + AEP_DragDrop.FEngNo;

  {$IFDEF USECODESITE}
  CodeSite.EnterMethod('TFrameIPCMonitor.CreateIPCMonitor ===>');
  try
    CodeSite.Send('LUniqueEngineName', ParameterSource2String(AEP_DragDrop.FParameterSource));
  finally
    CodeSite.ExitMethod('TFrameIPCMonitor.CreateIPCMonitor <===');
  end;
  {$ENDIF}

  case TParameterSource(AEP_DragDrop.FParameterSource) of
    psECS_kumo: CreateECSkumoIPCMonitor(AEP_DragDrop);
    psECS_kumo2: CreateECSkumo2IPCMonitor(AEP_DragDrop);
    psECS_AVAT: CreateECSAVATIPCMonitor(AEP_DragDrop);
    psMT210: CreateMT210IPCMonitor(AEP_DragDrop);
    psMEXA7000: CreateMEXA7000IPCMonitor(AEP_DragDrop);
    psLBX: CreateLBXIPCMonitor(AEP_DragDrop);
    psFlowMeter: CreateFlowMeterIPCMonitor(AEP_DragDrop);
    psWT1600: CreateWT1600IPCMonitor(AEP_DragDrop, LUniqueEngineName);
    psGasCalculated: CreateGasCalcIPCMonitor(AEP_DragDrop);
    psECS_Woodward: CreateECSWoodwardIPCMonitor(AEP_DragDrop);
    psDynamo: CreateDynamoIPCMonitor(AEP_DragDrop);
    psFlowMeterKral: CreateKRALIPCMonitor(AEP_DragDrop);
    psPLC_S7: CreatePLCS7IPCMonitor(AEP_DragDrop);
    psEngineParam: CreateEngineParamIPCMonitor(AEP_DragDrop);
    psHIC: CreateHICIPCMonitor(AEP_DragDrop);
    psPLC_Modbus: CreatePLCMODBUSIPCMonitor(AEP_DragDrop, LUniqueEngineName);
    psPMSOPC: CreatePMSIPCMonitor(AEP_DragDrop);
    psECS_ComAP: CreateECSComAPIPCMonitor(AEP_DragDrop);
    psECS_ComAP2: CreateECSComAPIPCMonitor2(AEP_DragDrop);
  end;
end;

//FEngineParameter 로 부터 IPC Monitor 생성함.
//반환: 생성된 IPC 리스트 반환
procedure TFrameIPCMonitor.CreateIPCMonitorFromParameter(
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
      FEngineParameterItemRecord.FSharedName := FEngineParameter.EngineParameterCollect.Items[i].SharedName;
      FEngineParameterItemRecord.FProjNo := FEngineParameter.EngineParameterCollect.Items[i].ProjNo;
      FEngineParameterItemRecord.FEngNo := FEngineParameter.EngineParameterCollect.Items[i].EngNo;

      case FEngineParameterItemRecord.FParameterSource of
        psMT210: FMT210StartIndex := i;
        psMEXA7000: FMEXA7000StartIndex := i;
        psWT1600: FWT1600StartIndex := i;
      end;

      CreateIPCMonitor(FEngineParameterItemRecord);
    end;
  end;
end;

//Result: Created Shared Memory Name
function TFrameIPCMonitor.CreateIPCMonitor_DYNAMO(ASharedName, AProjNo, AEngNo: string): String;
begin
  Result := CreateIPCMonitor_xx(psDYNAMO, ASharedName, AProjNo, AEngNo);
end;

function TFrameIPCMonitor.CreateIPCMonitor_ECS_AVAT(ASharedName, AProjNo, AEngNo: string): String;
begin
  Result := CreateIPCMonitor_xx(psECS_AVAT, ASharedName, AProjNo, AEngNo);
end;

function TFrameIPCMonitor.CreateIPCMonitor_ECS_kumo(ASharedName, AProjNo, AEngNo: string): String;
begin
  Result := CreateIPCMonitor_xx(psECS_kumo, ASharedName, AProjNo, AEngNo);
end;

function TFrameIPCMonitor.CreateIPCMonitor_ECS_kumo2(ASharedName, AProjNo,
  AEngNo: string): String;
begin
  Result := CreateIPCMonitor_xx(psECS_kumo2, ASharedName, AProjNo, AEngNo);
end;

function TFrameIPCMonitor.CreateIPCMonitor_ECS_Woodward(
  ASharedName, AProjNo, AEngNo: string): String;
begin
  Result := CreateIPCMonitor_xx(psECS_Woodward, ASharedName, AProjNo, AEngNo);
end;

function TFrameIPCMonitor.CreateIPCMonitor_EngineParam(
  ASharedName, AProjNo, AEngNo: string): String;
begin
  Result := CreateIPCMonitor_xx(psEngineParam, ASharedName, AProjNo, AEngNo);
end;

function TFrameIPCMonitor.CreateIPCMonitor_FlowMeter(ASharedName, AProjNo, AEngNo: string): String;
begin
  Result := CreateIPCMonitor_xx(psFlowMeter, ASharedName, AProjNo, AEngNo);
end;

function TFrameIPCMonitor.CreateIPCMonitor_GasCalc(ASharedName, AProjNo, AEngNo: string): String;
begin
  Result := CreateIPCMonitor_xx(psGasCalculated, ASharedName, AProjNo, AEngNo);
end;

function TFrameIPCMonitor.CreateIPCMonitor_HIC(ASharedName, AProjNo, AEngNo: string): String;
begin
  Result := CreateIPCMonitor_xx(psHIC, ASharedName, AProjNo, AEngNo);
end;

function TFrameIPCMonitor.CreateIPCMonitor_KRAL(ASharedName, AProjNo, AEngNo: string): String;
begin
  Result := CreateIPCMonitor_xx(psFlowMeterKral, ASharedName, AProjNo, AEngNo);
end;

function TFrameIPCMonitor.CreateIPCMonitor_LBX(ASharedName, AProjNo, AEngNo: string): String;
begin
  Result := CreateIPCMonitor_xx(psLBX, ASharedName, AProjNo, AEngNo);
end;

function TFrameIPCMonitor.CreateIPCMonitor_MEXA7000(ASharedName, AProjNo, AEngNo: string): String;
begin
  Result := CreateIPCMonitor_xx(psMEXA7000, ASharedName, AProjNo, AEngNo);
end;

function TFrameIPCMonitor.CreateIPCMonitor_MT210(ASharedName, AProjNo, AEngNo: string): String;
begin
  Result := CreateIPCMonitor_xx(psMT210, ASharedName, AProjNo, AEngNo);
end;

function TFrameIPCMonitor.CreateIPCMonitor_PLCMODBUS(
  ASharedName, AProjNo, AEngNo: string): String;
begin
  Result := CreateIPCMonitor_xx(psPLC_Modbus, ASharedName, AProjNo, AEngNo);
end;

function TFrameIPCMonitor.CreateIPCMonitor_PLC_S7(
  ASharedName, AProjNo, AEngNo: string): String;
begin
  Result := CreateIPCMonitor_xx(psPLC_S7, ASharedName, AProjNo, AEngNo);
end;

function TFrameIPCMonitor.CreateIPCMonitor_PMS(ASharedName, AProjNo, AEngNo: string): String;
begin
  Result := CreateIPCMonitor_xx(psPLC_Modbus, ASharedName, AProjNo, AEngNo);
end;

function TFrameIPCMonitor.CreateIPCMonitor_WT1600(ASharedName, AProjNo, AEngNo: string): String;
begin
  Result := CreateIPCMonitor_xx(psWT1600, ASharedName, AProjNo, AEngNo);
end;

function TFrameIPCMonitor.CreateIPCMonitor_xx(
  AParameterSource: TParameterSource; ASharedName, AProjNo, AEngNo: string): String;
begin
  FDestroying := False;
  FEngineParameterItemRecord.FParameterSource := AParameterSource;
  FEngineParameterItemRecord.FSharedName := ASharedName;
  FEngineParameterItemRecord.FProjNo := AProjNo;
  FEngineParameterItemRecord.FEngNo := AEngNo;

  if ASharedName <> '' then
    Result := ASharedName
  else
    Result := ParameterSource2SharedMN(FEngineParameterItemRecord.FParameterSource);

  CreateIPCMonitor(FEngineParameterItemRecord);
  FillChar(FEngineParameterItemRecord, Sizeof(FEngineParameterItemRecord), #0);
end;

procedure TFrameIPCMonitor.CreateKRALIPCMonitor(
  AEP_DragDrop: TEngineParameterItemRecord);
var
  LSM: string;
  LSM2: string;
begin
  if Assigned(FIPCMonitor_KRAL) then
    exit;

  if AEP_DragDrop.FSharedName = '' then
    LSM := ParameterSource2SharedMN(AEP_DragDrop.FParameterSource)
  else
    LSM := AEP_DragDrop.FSharedName;

  LSM2 := ParameterSource2SharedMN(psFlowMeterKral);

  FIPCMonitor_KRAL := TIPCMonitor<TEventData_Modbus_Standard>.Create(LSM, LSM2, True);//KRAK_EVENT_NAME
  FIPCMonitor_KRAL.FreeOnTerminate := True;
  FIPCMonitor_KRAL.FIPCObject.OnSignal := KRAL_OnSignal;
  FIPCMonitor_KRAL.Resume;
end;

procedure TFrameIPCMonitor.CreateLBXIPCMonitor(AEP_DragDrop: TEngineParameterItemRecord);
var
  LSM: string;
  LSM2: string;
begin
  if Assigned(FIPCMonitor_LBX) then
    exit;

  if AEP_DragDrop.FSharedName = '' then
    LSM := ParameterSource2SharedMN(AEP_DragDrop.FParameterSource)
  else
    LSM := AEP_DragDrop.FSharedName;

  LSM2 := ParameterSource2SharedMN(psLBX);

  FIPCMonitor_LBX := TIPCMonitor<TEventData_LBX>.Create(LSM, LSM2, True); //LBX_EVENT_NAME
  FIPCMonitor_LBX.FIPCObject.OnSignal := LBX_OnSignal;
  FIPCMonitor_LBX.FreeOnTerminate := True;
  FIPCMonitor_LBX.Resume;
end;

procedure TFrameIPCMonitor.CreateMEXA7000IPCMonitor(
  AEP_DragDrop: TEngineParameterItemRecord);
var
  LSM: string;
  LSM2: string;
begin
  if Assigned(FIPCMonitor_MEXA7000) then
    exit;

  if AEP_DragDrop.FSharedName = '' then
    LSM := ParameterSource2SharedMN(AEP_DragDrop.FParameterSource)
  else
    LSM := AEP_DragDrop.FSharedName;

  LSM2 := ParameterSource2SharedMN(psMEXA7000);

  FIPCMonitor_MEXA7000 := TIPCMonitor<TEventData_MEXA7000_2>.Create(LSM, LSM2, True);//MEXA7000_EVENT_NAME
  FIPCMonitor_MEXA7000.FIPCObject.OnSignal := MEXA7000_2_OnSignal;
  FIPCMonitor_MEXA7000.FreeOnTerminate := True;
  FIPCMonitor_MEXA7000.Resume;
end;

procedure TFrameIPCMonitor.CreateMT210IPCMonitor(
  AEP_DragDrop: TEngineParameterItemRecord);
var
  LSM: string;
  LSM2: string;
begin
  if Assigned(FIPCMonitor_MT210) then
    exit;

  if AEP_DragDrop.FSharedName = '' then
    LSM := ParameterSource2SharedMN(AEP_DragDrop.FParameterSource)
  else
    LSM := AEP_DragDrop.FSharedName;

  LSM2 := ParameterSource2SharedMN(psMT210);

  FIPCMonitor_MT210 := TIPCMonitor<TEventData_MT210>.Create(LSM, LSM2, True);//MT210_EVENT_NAME
  FIPCMonitor_MT210.FIPCObject.OnSignal := MT210_OnSignal;
  FIPCMonitor_MT210.FreeOnTerminate := True;
  FIPCMonitor_MT210.Resume;
end;

procedure TFrameIPCMonitor.CreatePLCMODBUSIPCMonitor(
  AEP_DragDrop: TEngineParameterItemRecord; AUniqueEngineName: string);
var
  LSM: string;
  LSM2: string;
  LIPCMonitor: TIPCMonitor<TEventData_Modbus_Standard>;
begin
//  if Assigned(FIPCMonitor_PLCMODBUS) then
  if FEventData_PLCMODBUS_List.ContainsKey(AUniqueEngineName) then
    exit;

  if AEP_DragDrop.FSharedName = '' then
    LSM := ParameterSource2SharedMN(AEP_DragDrop.FParameterSource)
  else
    LSM := AEP_DragDrop.FSharedName;

  LSM2 := ParameterSource2SharedMN(psPLC_Modbus);

  LIPCMonitor := TIPCMonitor<TEventData_Modbus_Standard>.Create(LSM, LSM2, True);//PLCMODBUS_EVENT_NAME
  LIPCMonitor.FIPCObject.OnSignal := PLCMODBUS_OnSignal;
  LIPCMonitor.FreeOnTerminate := True;
  LIPCMonitor.Resume;

  FEventData_PLCMODBUS_List.Add(AUniqueEngineName, LIPCMonitor);
  FCompleteReadMap_Woodward := True;
end;

procedure TFrameIPCMonitor.CreatePLCS7IPCMonitor(
  AEP_DragDrop: TEngineParameterItemRecord);
var
  LSM: string;
  LSM2: string;
begin
  if Assigned(FIPCMonitor_PLC_S7) then
    exit;

  if AEP_DragDrop.FSharedName = '' then
    LSM := ParameterSource2SharedMN(AEP_DragDrop.FParameterSource)
  else
    LSM := AEP_DragDrop.FSharedName;

  LSM2 := ParameterSource2SharedMN(psPLC_S7);

  FIPCMonitor_PLC_S7 := TIPCMonitor<TEventData_PLC_S7>.Create(LSM, LSM2, True);//PLC_S7_EVENT_NAME
  FIPCMonitor_PLC_S7.FreeOnTerminate := True;
  FIPCMonitor_PLC_S7.FIPCObject.OnSignal := PLC_S7_OnSignal;
  FIPCMonitor_PLC_S7.Resume;
end;

procedure TFrameIPCMonitor.CreatePMSIPCMonitor(
  AEP_DragDrop: TEngineParameterItemRecord);
var
  LSM: string;
  LSM2: string;
begin
  if Assigned(FIPCMonitor_PMS) then
    exit;

  if AEP_DragDrop.FSharedName = '' then
    LSM := ParameterSource2SharedMN(AEP_DragDrop.FParameterSource)
  else
    LSM := AEP_DragDrop.FSharedName;

  LSM2 := ParameterSource2SharedMN(psPMSOPC);

  FIPCMonitor_PMS := TIPCMonitor<TEventData_PMS>.Create(LSM, LSM2, True);//PMS_EVENT_NAME
  FIPCMonitor_PMS.FIPCObject.OnSignal := PMS_OnSignal;
  FIPCMonitor_PMS.FreeOnTerminate := True;
  FIPCMonitor_PMS.Resume;
end;

procedure TFrameIPCMonitor.CreateWT1600IPCMonitor(
  AEP_DragDrop: TEngineParameterItemRecord; AUniqueEngineName: string);
var
  LSM, LSM2: string;
  LIPCMonitor_WT1600: TIPCMonitor<TEventData_WT1600>;
begin
//  if Assigned(FIPCMonitor_WT1600) then
  if FEventData_WT1600_List.ContainsKey(AUniqueEngineName) then
    exit;

  if AEP_DragDrop.FSharedName = '' then
    LSM := ParameterSource2SharedMN(AEP_DragDrop.FParameterSource)
  else
    LSM := AEP_DragDrop.FSharedName;

  LSM2 := ParameterSource2SharedMN(psWT1600);

  LIPCMonitor_WT1600 := TIPCMonitor<TEventData_WT1600>.Create(LSM, LSM2, True);
  LIPCMonitor_WT1600.FreeOnTerminate := True;
  LIPCMonitor_WT1600.FIPCObject.OnSignal := WT1600_OnSignal;
  LIPCMonitor_WT1600.Resume;

  FEventData_WT1600_List.Add(AUniqueEngineName, LIPCMonitor_WT1600);
end;

destructor TFrameIPCMonitor.Destroy;
begin
  DestroyVar;

  inherited;
end;

procedure TFrameIPCMonitor.DestroyIPCMonitor(AIPCMonitor: TParameterSource);
var
  Lkey: string;
begin
//  if Assigned(FIPCMonitor_WT1600) and (AIPCMonitor = psWT1600) then
  if AIPCMonitor = psWT1600 then
  begin
    for Lkey in FEventData_WT1600_List.Keys do
    begin
      FEventData_WT1600_List.Items[Lkey].FTermination := True;
      FEventData_WT1600_List.Items[Lkey].FIPCObject.OnSignal := nil;
      FEventData_WT1600_List.Items[Lkey].Suspend;
      FEventData_WT1600_List.Items[Lkey].FIPCObject.FMonitorEvent.Pulse;
      FEventData_WT1600_List.Items[Lkey].Resume;
      FEventData_WT1600_List.Items[Lkey].Terminate;
//      FEventData_WT1600_List.Items[Lkey].Free;
      FEventData_WT1600_List.Items[Lkey] := nil;
    end;

    FEventData_WT1600_List.Clear;
  end;

  if Assigned(FIPCMonitor_MEXA7000) and (AIPCMonitor = psMEXA7000)  then
  begin
    FIPCMonitor_MEXA7000.FTermination := True;
    FIPCMonitor_MEXA7000.FIPCObject.OnSignal := nil;
    FIPCMonitor_MEXA7000.Suspend;
    FIPCMonitor_MEXA7000.FIPCObject.FMonitorEvent.Pulse;
    FIPCMonitor_MEXA7000.Resume;
    FIPCMonitor_MEXA7000.Terminate;
    FIPCMonitor_MEXA7000 := nil;
  end;

  if Assigned(FIPCMonitor_MT210) and (AIPCMonitor = psMT210)  then
  begin
    FIPCMonitor_MT210.FTermination := True;
    FIPCMonitor_MT210.FIPCObject.OnSignal := nil;
    FIPCMonitor_MT210.Suspend;
    FIPCMonitor_MT210.FIPCObject.FMonitorEvent.Pulse;
    FIPCMonitor_MT210.Resume;
    FIPCMonitor_MT210.Terminate;
    FIPCMonitor_MT210 := nil;
  end;

  if Assigned(FIPCMonitor_ECS_kumo) and (AIPCMonitor = psECS_kumo)  then
  begin
    FIPCMonitor_ECS_kumo.FTermination := True;
    FIPCMonitor_ECS_kumo.FIPCObject.OnSignal := nil;
    FIPCMonitor_ECS_kumo.Suspend;
    FIPCMonitor_ECS_kumo.FIPCObject.FMonitorEvent.Pulse;
    FIPCMonitor_ECS_kumo.Resume;
    FIPCMonitor_ECS_kumo.Terminate;
    FIPCMonitor_ECS_kumo := nil;
  end;

  if Assigned(FIPCMonitor_ECS_kumo) and (AIPCMonitor = psECS_kumo2)  then
  begin
    FIPCMonitor_ECS_kumo.FTermination := True;
    FIPCMonitor_ECS_kumo.FIPCObject.OnSignal := nil;
    FIPCMonitor_ECS_kumo.Suspend;
    FIPCMonitor_ECS_kumo.FIPCObject.FMonitorEvent.Pulse;
    FIPCMonitor_ECS_kumo.Resume;
    FIPCMonitor_ECS_kumo.Terminate;
    FIPCMonitor_ECS_kumo := nil;
  end;

  if Assigned(FIPCMonitor_ECS_Woodward) and (AIPCMonitor = psECS_Woodward)  then
  begin
    FIPCMonitor_ECS_Woodward.FTermination := True;
    FIPCMonitor_ECS_Woodward.FIPCObject.OnSignal := nil;
    FIPCMonitor_ECS_Woodward.Suspend;
    FIPCMonitor_ECS_Woodward.FIPCObject.FMonitorEvent.Pulse;
    FIPCMonitor_ECS_Woodward.Resume;
    FIPCMonitor_ECS_Woodward.Terminate;
    FIPCMonitor_ECS_Woodward := nil;
  end;

  if Assigned(FIPCMonitor_ECS_AVAT) and (AIPCMonitor = psECS_AVAT)  then
  begin
    FIPCMonitor_ECS_AVAT.FTermination := True;
    FIPCMonitor_ECS_AVAT.FIPCObject.OnSignal := nil;
    FIPCMonitor_ECS_AVAT.Suspend;
    FIPCMonitor_ECS_AVAT.FIPCObject.FMonitorEvent.Pulse;
    FIPCMonitor_ECS_AVAT.Resume;
    FIPCMonitor_ECS_AVAT.Terminate;
    FIPCMonitor_ECS_AVAT := nil;
  end;

  if Assigned(FIPCMonitor_LBX) and (AIPCMonitor = psLBX)  then
  begin
    FIPCMonitor_LBX.FTermination := True;
    FIPCMonitor_LBX.FIPCObject.OnSignal := nil;
    FIPCMonitor_LBX.Suspend;
    FIPCMonitor_LBX.FIPCObject.FMonitorEvent.Pulse;
    FIPCMonitor_LBX.Resume;
    FIPCMonitor_LBX.Terminate;
    FIPCMonitor_LBX := nil;
  end;

  if Assigned(FIPCMonitor_Dynamo) and (AIPCMonitor = psDynamo)  then
  begin
    FIPCMonitor_Dynamo.FTermination := True;
    FIPCMonitor_Dynamo.FIPCObject.OnSignal := nil;
    FIPCMonitor_Dynamo.Suspend;
    FIPCMonitor_Dynamo.FIPCObject.FMonitorEvent.Pulse;
    FIPCMonitor_Dynamo.Resume;
    FIPCMonitor_Dynamo.Terminate;
    FIPCMonitor_Dynamo := nil;
  end;

  if Assigned(FIPCMonitor_KRAL) and (AIPCMonitor = psFlowMeterKral)  then
  begin
    FIPCMonitor_KRAL.FTermination := True;
    FIPCMonitor_KRAL.FIPCObject.OnSignal := nil;
    FIPCMonitor_KRAL.Suspend;
    FIPCMonitor_KRAL.FIPCObject.FMonitorEvent.Pulse;
    FIPCMonitor_KRAL.Resume;
    FIPCMonitor_KRAL.Terminate;
    FIPCMonitor_KRAL := nil;
  end;

  if Assigned(FIPCMonitor_PLC_S7) and (AIPCMonitor = psPLC_S7)  then
  begin
    FIPCMonitor_PLC_S7.FTermination := True;
    FIPCMonitor_PLC_S7.FIPCObject.OnSignal := nil;
    FIPCMonitor_PLC_S7.Suspend;
    FIPCMonitor_PLC_S7.FIPCObject.FMonitorEvent.Pulse;
    FIPCMonitor_PLC_S7.Resume;
    FIPCMonitor_PLC_S7.Terminate;
    FIPCMonitor_PLC_S7 := nil;
  end;

  if Assigned(FIPCMonitor_GasCalc) and (AIPCMonitor = psGasCalculated)  then
  begin
    FIPCMonitor_GasCalc.FTermination := True;
    FIPCMonitor_GasCalc.FIPCObject.OnSignal := nil;
    FIPCMonitor_GasCalc.Suspend;
    FIPCMonitor_GasCalc.FIPCObject.FMonitorEvent.Pulse;
    FIPCMonitor_GasCalc.Resume;
    FIPCMonitor_GasCalc.Terminate;
    FIPCMonitor_GasCalc := nil;
  end;

  if Assigned(FIPCMonitor_EngineParam) and (AIPCMonitor = psEngineParam)  then
  begin
    FIPCMonitor_EngineParam.FTermination := True;
    FIPCMonitor_EngineParam.FIPCObject.OnSignal := nil;
    FIPCMonitor_EngineParam.Suspend;
    FIPCMonitor_EngineParam.FIPCObject.FMonitorEvent.Pulse;
    FIPCMonitor_EngineParam.Resume;
    FIPCMonitor_EngineParam.Terminate;
    FIPCMonitor_EngineParam := nil;
  end;

  if Assigned(FIPCMonitor_HIC) and (AIPCMonitor = psHIC)  then
  begin
    FIPCMonitor_HIC.FTermination := True;
    FIPCMonitor_HIC.FIPCObject.OnSignal := nil;
    FIPCMonitor_HIC.Suspend;
    FIPCMonitor_HIC.FIPCObject.FMonitorEvent.Pulse;
    FIPCMonitor_HIC.Resume;
    FIPCMonitor_HIC.Terminate;
    FIPCMonitor_HIC := nil;
  end;

//  if Assigned(FIPCMonitor_PLCModbus) and (AIPCMonitor = psPLC_Modbus)  then
  if AIPCMonitor = psPLC_Modbus then
  begin
    for Lkey in FEventData_PLCModbus_List.Keys do
    begin
      FEventData_PLCModbus_List.Items[Lkey].FTermination := True;
      FEventData_PLCModbus_List.Items[Lkey].FIPCObject.OnSignal := nil;
      FEventData_PLCModbus_List.Items[Lkey].Suspend;
      FEventData_PLCModbus_List.Items[Lkey].FIPCObject.FMonitorEvent.Pulse;
      FEventData_PLCModbus_List.Items[Lkey].Resume;
      FEventData_PLCModbus_List.Items[Lkey].Terminate;
//      FEventData_PLCModbus_List.Items[Lkey].Free;
      FEventData_PLCModbus_List.Items[Lkey] := nil;
    end;

    FEventData_PLCModbus_List.Clear;
  end;
end;

procedure TFrameIPCMonitor.DestroyIPCMonitorAll;
var
  i: integer;
  LPS: TParameterSource;
begin
  FDestroying := True;

  for i := Ord(Low(TParameterSource)) to Ord(High(TParameterSource)) do
  begin
    LPS := TParameterSource(i);
    DestroyIPCMonitor(LPS);
  end;
end;

procedure TFrameIPCMonitor.DestroyVar;
begin
  FDestroying := True;

  FPJHTimerPool.RemoveAll;
  FreeAndNil(FPJHTimerPool);

  //DestroyIPCMonitor;

  FEngineParameter.EngineParameterCollect.Clear;
  FreeAndNil(FEngineParameter);

  ObjFree(FAddressMap);
  FreeAndNil(FAddressMap);

  //FreeAndNil(FConfigOption);
  ClearEventData_WT1600_List;
  FEventData_WT1600_List.Free;
  ClearEventData_PLCMODBUS_List;
  FEventData_PLCMODBUS_List.Free;
end;

procedure TFrameIPCMonitor.DisplayMessage(Msg: string);
begin

end;

procedure TFrameIPCMonitor.DisplayMessage2SB(AStatusBar: TjvStatusBar; Msg: string);
begin
  if Assigned(AStatusBar) then
  begin
    AStatusBar.SimplePanel := True;
    AStatusBar.SimpleText := Msg;
  end;
end;

procedure TFrameIPCMonitor.DYNAMO_OnSignal(Data: TEventData_DYNAMO);
begin
  if not FIsUseIPCSharedMMEvent then
    exit;

  CommonCommunication(psDynamo);
end;

procedure TFrameIPCMonitor.ECS_OnSignal_AVAT(Data: TEventData_ECS_AVAT);
var
  i,dcount: integer;
begin
  if not FIsUseIPCSharedMMEvent then
    exit;

  if not FCompleteReadMap_Avat then
    exit;

  dcount := 0;
  FillChar(FECSData_AVAT.InpDataBuf[0], High(FECSData_AVAT.InpDataBuf) - 1, #0);
  FECSData_AVAT.ModBusMode := Data.ModBusMode;

  if Data.ModBusMode = 0 then //ASCII Mode이면
  begin
    //ModePanel.Caption := 'ASCII Mode';
    dcount := Data.NumOfData;
    FECSData_AVAT.NumOfBit := Data.NumOfBit;

    for i := 0 to dcount - 1 do
      FECSData_AVAT.InpDataBuf[i] := Data.InpDataBuf[i];
  end
  else
  if Data.ModBusMode = 1 then// RTU Mode 이면
  begin
    //ModePanel.Caption := 'RTU Mode';
    dcount := Data.NumOfData div 2;
    FECSData_AVAT.NumOfBit := Data.NumOfBit;

    if dcount = 0 then
      Inc(dcount);

    for i := 0 to dcount - 1 do
    begin
      FECSData_AVAT.InpDataBuf[i] := Data.InpDataBuf2[i*2] ;
      FECSData_AVAT.InpDataBuf[i] := FECSData_AVAT.InpDataBuf[i] shl 8 + Data.InpDataBuf2[i*2 + 1];
//      FModBusData.InpDataBuf[i] :=  ;
    end;

    if (Data.NumOfData mod 2) > 0 then
      FECSData_AVAT.InpDataBuf[i] := Data.InpDataBuf2[i*2] ;
  end//Data.ModBusMode = 1
  else
  if (Data.ModBusMode = 4) then //MODBUSTCP_MODE 이면
  begin
    dcount := Data.NumOfData;
    FECSData_AVAT.NumOfBit := Data.NumOfBit;
    System.Move(Data.InpDataBuf, FECSData_AVAT.InpDataBuf, Sizeof(Data.InpDataBuf));

    //for i := 0 to dcount - 1 do
      //FECSData.InpDataBuf[i] := Data.InpDataBuf[i];
  end
  else
  if (Data.ModBusMode = 3) then //simulate from csv file
  begin
    dcount := Data.NumOfData;
    FECSData_AVAT.NumOfBit := Data.NumOfBit;
    System.Move(Data.InpDataBuf_double, FECSData_AVAT.InpDataBuf_double, Sizeof(Data.InpDataBuf_double));
  end;//Data.ModBusMode = 3

  FECSData_AVAT.ModBusAddress := Data.ModBusAddress;
  FECSData_AVAT.BlockNo := Data.BlockNo;
  FECSData_AVAT.NumOfData := dcount;
  FECSData_AVAT.ModBusFunctionCode := Data.ModBusFunctionCode;
  FECSData_AVAT.ModBusMapFileName := Data.ModBusMapFileName;
  FECSData_AVAT.PowerOn := True;

  FModBusMapFileName := Data.ModBusMapFileName;

  DisplayMessage2SB(FStatusBar, FECSData_AVAT.ModBusAddress + ' 데이타 도착');

  SendMessage(Handle, WM_EVENT_ECS_AVAT, 0,0);
  CommonCommunication(psECS_AVAT);
end;

procedure TFrameIPCMonitor.ECS_OnSignal_ComAP(
  Data: TEventData_Modbus_Standard);
var
  i,dcount: integer;
begin
  if not FIsUseIPCSharedMMEvent then
    exit;

  if FDestroying then
    exit;

//  if not FCompleteReadMap_Woodward then
//    exit;

  dcount := 0;
  FillChar(FECSData_ComAP.InpDataBuf[0], High(FECSData_ComAP.InpDataBuf) - 1, #0);
  FECSData_ComAP.ModBusMode := Data.ModBusMode;

  if Data.ModBusMode = 0 then //ASCII Mode이면
  begin
    //ModePanel.Caption := 'ASCII Mode';
    dcount := Data.NumOfData;
    FECSData_ComAP.NumOfBit := Data.NumOfBit;

    for i := 0 to dcount - 1 do
      FECSData_ComAP.InpDataBuf[i] := Data.InpDataBuf[i];
  end
  else
  if Data.ModBusMode = 1 then// RTU Mode 이면
  begin
    dcount := Data.NumOfData div 2;
    FECSData_ComAP.NumOfBit := Data.NumOfBit;

    if dcount = 0 then
      Inc(dcount);

    for i := 0 to dcount - 1 do
    begin
      FECSData_ComAP.InpDataBuf[i] := Data.InpDataBuf2[i*2] ;
      FECSData_ComAP.InpDataBuf[i] := FECSData_ComAP.InpDataBuf[i] shl 8 + Data.InpDataBuf2[i*2 + 1];
    end;

    if (Data.NumOfData mod 2) > 0 then
      FECSData_ComAP.InpDataBuf[i] := Data.InpDataBuf2[i*2] ;
  end//Data.ModBusMode = 1
  else
  if (Data.ModBusMode = 4) then //MODBUSTCP_MODE 이면
  begin
    dcount := Data.NumOfData;
    FECSData_ComAP.NumOfBit := Data.NumOfBit;
    System.Move(Data.InpDataBuf, FECSData_ComAP.InpDataBuf, Sizeof(Data.InpDataBuf));
  end
  else
  if (Data.ModBusMode = 3) then //simulate from csv file
  begin
    dcount := Data.NumOfData;
    FECSData_ComAP.NumOfBit := Data.NumOfBit;
    System.Move(Data.InpDataBuf_double, FECSData_ComAP.InpDataBuf_double, Sizeof(Data.InpDataBuf_double));
  end//Data.ModBusMode = 3
  else
  if (Data.ModBusMode = 5) then//MODBUSSERIAL_TCP_MODE
  begin
    dcount := Data.NumOfData;
    FECSData_ComAP.NumOfBit := Data.NumOfBit;
    System.Move(Data.InpDataBuf, FECSData_ComAP.InpDataBuf, Sizeof(Data.InpDataBuf));
  end;

  FECSData_ComAP.ModBusAddress := Data.ModBusAddress;
  FECSData_ComAP.BlockNo := Data.BlockNo;
  FECSData_ComAP.NumOfData := dcount;
  FECSData_ComAP.ModBusFunctionCode := Data.ModBusFunctionCode;
  FECSData_ComAP.ModBusMapFileName := Data.ModBusMapFileName;
  FECSData_ComAP.PowerOn := True;
  FModBusMapFileName := Data.ModBusMapFileName;

  DisplayMessage2SB(FStatusBar, FECSData_ComAP.ModBusAddress + ' 데이타 도착');

  SendMessage(Handle, WM_EVENT_ECS_COMAP, 0,0);
  CommonCommunication(psECS_ComAP);
end;

procedure TFrameIPCMonitor.ECS_OnSignal_ComAP2(
  Data: TEventData_Modbus_Standard);
var
  i,dcount: integer;
begin
  if not FIsUseIPCSharedMMEvent then
    exit;

  if FDestroying then
    exit;

//  if not FCompleteReadMap_Woodward then
//    exit;

  dcount := 0;
  FillChar(FECSData_ComAP2.InpDataBuf[0], High(FECSData_ComAP2.InpDataBuf) - 1, #0);
  FECSData_ComAP2.ModBusMode := Data.ModBusMode;

  if Data.ModBusMode = 0 then //ASCII Mode이면
  begin
    //ModePanel.Caption := 'ASCII Mode';
    dcount := Data.NumOfData;
    FECSData_ComAP2.NumOfBit := Data.NumOfBit;

    for i := 0 to dcount - 1 do
      FECSData_ComAP2.InpDataBuf[i] := Data.InpDataBuf[i];
  end
  else
  if Data.ModBusMode = 1 then// RTU Mode 이면
  begin
    dcount := Data.NumOfData div 2;
    FECSData_ComAP2.NumOfBit := Data.NumOfBit;

    if dcount = 0 then
      Inc(dcount);

    for i := 0 to dcount - 1 do
    begin
      FECSData_ComAP2.InpDataBuf[i] := Data.InpDataBuf2[i*2] ;
      FECSData_ComAP2.InpDataBuf[i] := FECSData_ComAP2.InpDataBuf[i] shl 8 + Data.InpDataBuf2[i*2 + 1];
    end;

    if (Data.NumOfData mod 2) > 0 then
      FECSData_ComAP2.InpDataBuf[i] := Data.InpDataBuf2[i*2] ;
  end//Data.ModBusMode = 1
  else
  if (Data.ModBusMode = 4) then //MODBUSTCP_MODE 이면
  begin
    dcount := Data.NumOfData;
    FECSData_ComAP2.NumOfBit := Data.NumOfBit;
    System.Move(Data.InpDataBuf, FECSData_ComAP2.InpDataBuf, Sizeof(Data.InpDataBuf));
  end
  else
  if (Data.ModBusMode = 3) then //simulate from csv file
  begin
    dcount := Data.NumOfData;
    FECSData_ComAP2.NumOfBit := Data.NumOfBit;
    System.Move(Data.InpDataBuf_double, FECSData_ComAP2.InpDataBuf_double, Sizeof(Data.InpDataBuf_double));
  end//Data.ModBusMode = 3
  else
  if (Data.ModBusMode = 5) then//MODBUSSERIAL_TCP_MODE
  begin
    dcount := Data.NumOfData;
    FECSData_ComAP2.NumOfBit := Data.NumOfBit;
    System.Move(Data.InpDataBuf, FECSData_ComAP2.InpDataBuf, Sizeof(Data.InpDataBuf));
  end;

  FECSData_ComAP2.ModBusAddress := Data.ModBusAddress;
  FECSData_ComAP2.BlockNo := Data.BlockNo;
  FECSData_ComAP2.NumOfData := dcount;
  FECSData_ComAP2.ModBusFunctionCode := Data.ModBusFunctionCode;
  FECSData_ComAP2.ModBusMapFileName := Data.ModBusMapFileName;
  FECSData_ComAP2.PowerOn := True;
  FModBusMapFileName := Data.ModBusMapFileName;

  DisplayMessage2SB(FStatusBar, FECSData_ComAP2.ModBusAddress + ' 데이타 도착');

  SendMessage(Handle, WM_EVENT_ECS_COMAP2, 0,0);
  CommonCommunication(psECS_ComAP2);
end;

procedure TFrameIPCMonitor.ECS_OnSignal_kumo(Data: TEventData_ECS_kumo);
var
  i,dcount: integer;
begin
  if not FIsUseIPCSharedMMEvent then
    exit;

  if not FCompleteReadMap_kumo then
    exit;

  if FDestroying then
    exit;

  FillChar(FECSData_kumo.InpDataBuf[0], High(FECSData_kumo.InpDataBuf) - 1, #0);
  FECSData_kumo.ModBusMode := Data.ModBusMode;

  if Data.ModBusMode = 0 then //ASCII Mode이면
  begin
    //ModePanel.Caption := 'ASCII Mode';
    dcount := Data.NumOfData;
    FECSData_kumo.NumOfBit := Data.NumOfBit;

    for i := 0 to dcount - 1 do
      FECSData_kumo.InpDataBuf[i] := Data.InpDataBuf[i];
  end
  else
  if Data.ModBusMode = 1 then// RTU Mode 이면
  begin
    //ModePanel.Caption := 'RTU Mode';
    //dcount := Data.NumOfData div 2;
    FECSData_kumo.NumOfBit := Data.NumOfBit;
    //if dcount = 0 then
      //Inc(dcount);

    //for i := 0 to dcount - 1 do
    //begin
    System.Move(Data.InpDataBuf, FECSData_kumo.InpDataBuf, Sizeof(Data.InpDataBuf));
      //FECSData_kumo.InpDataBuf[i] := Data.InpDataBuf2[i*2] ;
      //FECSData_kumo.InpDataBuf[i] := FECSData_kumo.InpDataBuf[i] shl 8 + Data.InpDataBuf2[i*2 + 1];
    //end;

    if (Data.NumOfData mod 2) > 0 then
      FECSData_kumo.InpDataBuf[i] := Data.InpDataBuf[i] ;
      //FECSData_kumo.InpDataBuf[i] := Data.InpDataBuf2[i*2] ;
  end//Data.ModBusMode = 1
  else
  if (Data.ModBusMode = 3) then//simulation
  begin
    dcount := Data.NumOfData;
    FECSData_kumo.NumOfBit := Data.NumOfBit;
    System.Move(Data.InpDataBuf_double, FECSData_kumo.InpDataBuf_double, Sizeof(Data.InpDataBuf_double));
  end;//Data.ModBusMode = 3

  FECSData_kumo.ModBusAddress := Data.ModBusAddress;
  FECSData_kumo.BlockNo := Data.BlockNo;
  FECSData_kumo.NumOfData := dcount;
  FECSData_kumo.ModBusFunctionCode := Data.ModBusFunctionCode;
  FECSData_kumo.ModBusMapFileName := Data.ModBusMapFileName;
  FModBusMapFileName := Data.ModBusMapFileName;
  FECSData_kumo.PowerOn := True;

  DisplayMessage2SB(FStatusBar, FECSData_kumo.ModBusAddress + ' 데이타 도착');

  SendMessage(Handle, WM_EVENT_ECS_KUMO, 0,0);
  CommonCommunication(psECS_kumo);
end;

procedure TFrameIPCMonitor.ECS_OnSignal_Woodward(Data: TEventData_ECS_Woodward);
var
  i,dcount: integer;
begin
  if not FIsUseIPCSharedMMEvent then
    exit;

  if not FCompleteReadMap_Woodward then
    exit;

  if FDestroying then
    exit;

  dcount := 0;
  FillChar(FECSData_Woodward.InpDataBuf[0], High(FECSData_Woodward.InpDataBuf) - 1, #0);
  FECSData_Woodward.ModBusMode := Data.ModBusMode;

  if Data.ModBusMode = 0 then //ASCII Mode이면
  begin
    //ModePanel.Caption := 'ASCII Mode';
    dcount := Data.NumOfData;
    FECSData_Woodward.NumOfBit := Data.NumOfBit;

    for i := 0 to dcount - 1 do
      FECSData_Woodward.InpDataBuf[i] := Data.InpDataBuf[i];
  end
  else
  if Data.ModBusMode = 1 then// RTU Mode 이면
  begin
    //ModePanel.Caption := 'RTU Mode';
    dcount := Data.NumOfData div 2;
    FECSData_Woodward.NumOfBit := Data.NumOfBit;

    if dcount = 0 then
      Inc(dcount);

    for i := 0 to dcount - 1 do
    begin
      FECSData_Woodward.InpDataBuf[i] := Data.InpDataBuf2[i*2] ;
      FECSData_Woodward.InpDataBuf[i] := FECSData_Woodward.InpDataBuf[i] shl 8 + Data.InpDataBuf2[i*2 + 1];
//      FModBusData.InpDataBuf[i] :=  ;
    end;

    if (Data.NumOfData mod 2) > 0 then
      FECSData_Woodward.InpDataBuf[i] := Data.InpDataBuf2[i*2] ;
  end//Data.ModBusMode = 1
  else
  if (Data.ModBusMode = 4) then //MODBUSTCP_MODE 이면
  begin
    dcount := Data.NumOfData;
    FECSData_Woodward.NumOfBit := Data.NumOfBit;
    System.Move(Data.InpDataBuf, FECSData_Woodward.InpDataBuf, Sizeof(Data.InpDataBuf));

    //for i := 0 to dcount - 1 do
      //FECSData.InpDataBuf[i] := Data.InpDataBuf[i];
  end
  else
  if (Data.ModBusMode = 3) then //simulate from csv file
  begin
    dcount := Data.NumOfData;
    FECSData_Woodward.NumOfBit := Data.NumOfBit;
    System.Move(Data.InpDataBuf_double, FECSData_Woodward.InpDataBuf_double, Sizeof(Data.InpDataBuf_double));
  end;//Data.ModBusMode = 3

  FECSData_Woodward.ModBusAddress := Data.ModBusAddress;
  FECSData_Woodward.BlockNo := Data.BlockNo;
  FECSData_Woodward.NumOfData := dcount;
  FECSData_Woodward.ModBusFunctionCode := Data.ModBusFunctionCode;
  FECSData_Woodward.ModBusMapFileName := Data.ModBusMapFileName;
  FECSData_Woodward.PowerOn := True;
  FModBusMapFileName := Data.ModBusMapFileName;

  DisplayMessage2SB(FStatusBar, FECSData_Woodward.ModBusAddress + ' 데이타 도착');

  SendMessage(Handle, WM_EVENT_ECS_Woodward, 0,0);
  CommonCommunication(psECS_Woodward);
end;

procedure TFrameIPCMonitor.EngineParam_OnSignal(Data: TEventData_EngineParam);
begin
  if not FIsUseIPCSharedMMEvent then
    exit;

  System.Move(Data.FData, FEngineParamData.FData, Sizeof(Data.FData));
  FEngineParamData.FDataCount := Data.FDataCount;
  FEngineParamData.PowerOn := True;

  SendMessage(Handle, WM_EVENT_ENGINEPARAM, 0,0);
  CommonCommunication(psEngineParam);
end;

procedure TFrameIPCMonitor.FlowMeter_OnSignal(Data: TEventData_FlowMeter);
begin
  if not FIsUseIPCSharedMMEvent then
    exit;
//;
  CommonCommunication(psFlowMeter);
end;

//AAutoStart: True = 프로그램 시작시에 watch file name을 parameter로 입력받는 경우
//            False = LoadFromFile 메뉴로 실행되는 경우
procedure TFrameIPCMonitor.GasCalc_OnSignal(Data: TEventData_GasCalc);
begin
  if not FIsUseIPCSharedMMEvent then
    exit;

  FGasCalcData.FSVP := Data.FSVP;
  FGasCalcData.FIAH2 := Data.FIAH2;
  FGasCalcData.FUFC := Data.FUFC;
  FGasCalcData.FNhtCF := Data.FNhtCF;
  FGasCalcData.FDWCFE := Data.FDWCFE;
  FGasCalcData.FEGF := Data.FEGF;
  FGasCalcData.FNOxAtO213 := Data.FNOxAtO213;
  FGasCalcData.FNOx := Data.FNOx;
  FGasCalcData.FAF1 := Data.FAF1;
  FGasCalcData.FAF2 := Data.FAF2;
  FGasCalcData.FAF3 := Data.FAF3;
  FGasCalcData.FAF_Measured := Data.FAF_Measured;
  FGasCalcData.FMT210 := Data.FMT210;
  FGasCalcData.FFC := Data.FFC;
  FGasCalcData.FEngineOutput := Data.FEngineOutput;
  FGasCalcData.FGeneratorOutput := Data.FGeneratorOutput;
  FGasCalcData.FEngineLoad := Data.FEngineLoad;
  FGasCalcData.FGenEfficiency := Data.FGenEfficiency;
  FGasCalcData.FBHP := Data.FBHP;
  FGasCalcData.FBMEP := Data.FBMEP;
  FGasCalcData.FLamda_Calculated := Data.FLamda_Calculated;
  FGasCalcData.FLamda_Measured := Data.FLamda_Measured;
  FGasCalcData.FLamda_Brettschneider := Data.FLamda_Brettschneider;
  FGasCalcData.FAFRatio_Calculated := Data.FAFRatio_Calculated;
  FGasCalcData.FAFRatio_Measured := Data.FAFRatio_Measured;
  FGasCalcData.FExhTempAvg := Data.FExhTempAvg;
  FGasCalcData.FWasteGatePosition := Data.FWasteGatePosition;
  FGasCalcData.FThrottlePosition := Data.FThrottlePosition;
  //FGasCalcData.FBoostPress := Data.FBoostPress;
  FGasCalcData.FDensity := Data.FDensity;
  FGasCalcData.FLCV := Data.FLCV;
  FGasCalcData.PowerOn := True;

  SendMessage(Handle, WM_EVENT_GASCALC, 0,0);
  CommonCommunication(psGasCalculated);
end;

function TFrameIPCMonitor.GetEngineName: string;
begin
  Result := '';

  if FEngineParameter.EngineParameterCollect.Count > 0 then
  begin
    Result := FEngineParameter.EngineParameterCollect.Items[0].ProjNo + '_' +
      FEngineParameter.EngineParameterCollect.Items[0].EngNo;
  end;
end;

//DataSaveAll에서 사용 됨
function TFrameIPCMonitor.GetEventData_PLCMODBUS_ListCount: integer;
begin
  Result := FEventData_PLCMODBUS_List.Count;
end;

function TFrameIPCMonitor.GetEventData_PLCMODBUS_ListName: string;
var
  LKey: string;
begin
  for LKey in FEventData_PLCMODBUS_List.Keys do
  begin
    Result := LKey;
    exit;
  end;
end;

function TFrameIPCMonitor.GetEventName(APSrc: TParameterSource): string;
begin
  case APSrc of
    psECS_kumo: begin
      if Assigned(FIPCMonitor_ECS_kumo) then
        Result := FIPCMonitor_ECS_kumo.EventName;
    end;
    psECS_kumo2: begin
      if Assigned(FIPCMonitor_ECS_kumo) then
        Result := FIPCMonitor_ECS_kumo.EventName;
    end;
    psECS_AVAT: begin
      if Assigned(FIPCMonitor_ECS_AVAT) then
        Result := FIPCMonitor_ECS_AVAT.EventName;
    end;
    psMT210: begin
      if Assigned(FIPCMonitor_MT210) then
        Result := FIPCMonitor_MT210.EventName;
    end;
    psMEXA7000: begin
      if Assigned(FIPCMonitor_MEXA7000) then
        Result := FIPCMonitor_MEXA7000.EventName;
    end;
    psLBX: begin
      if Assigned(FIPCMonitor_LBX) then
        Result := FIPCMonitor_LBX.EventName;
    end;
    psFlowMeter: begin
      if Assigned(FIPCMonitor_FlowMeter) then
        Result := FIPCMonitor_FlowMeter.EventName;
    end;
    psWT1600: begin
      if Assigned(FIPCMonitor_WT1600) then
        Result := FIPCMonitor_WT1600.EventName;
    end;
    psGasCalculated: begin
      if Assigned(FIPCMonitor_GasCalc) then
        Result := FIPCMonitor_GasCalc.EventName;
    end;
    psECS_Woodward: begin
      if Assigned(FIPCMonitor_ECS_Woodward) then
        Result := FIPCMonitor_ECS_Woodward.EventName;
    end;
    psDynamo: begin
      if Assigned(FIPCMonitor_Dynamo) then
        Result := FIPCMonitor_Dynamo.EventName;
    end;
    psFlowMeterKral: begin
      if Assigned(FIPCMonitor_KRAL) then
        Result := FIPCMonitor_KRAL.EventName;
    end;
    psPLC_S7: begin
      if Assigned(FIPCMonitor_PLC_S7) then
        Result := FIPCMonitor_PLC_S7.EventName;
    end;
    psEngineParam: begin
      if Assigned(FIPCMonitor_EngineParam) then
        Result := FIPCMonitor_EngineParam.EventName;
    end;
    psHIC: begin
      if Assigned(FIPCMonitor_HIC) then
        Result := FIPCMonitor_HIC.EventName;
    end;
    psPLC_Modbus: begin
      if Assigned(FIPCMonitor_PLCModbus) then
        Result := FIPCMonitor_PLCModbus.EventName;
    end;
    psPMSOPC: begin
      if Assigned(FIPCMonitor_PMS) then
        Result := FIPCMonitor_PMS.EventName;
    end;
    psECS_ComAP: begin
      if Assigned(FIPCMonitor_ECS_ComAP) then
        Result := FIPCMonitor_ECS_ComAP.EventName;
    end;
    psECS_ComAP2: begin
      if Assigned(FIPCMonitor_ECS_ComAP2) then
        Result := FIPCMonitor_ECS_ComAP2.EventName;
    end;
  end;
end;

procedure TFrameIPCMonitor.GetParameterSourceList(var AList: TStringList);
var
  i,j: integer;
  LStr: string;
begin
  AList.Clear;

  for i := 0 to FEngineParameter.EngineParameterCollect.Count - 1 do
  begin
    LStr := FEngineParameter.EngineParameterCollect.GetUniqueParamSourceName(i);
    j := AList.IndexOf(LStr);
    if j = -1 then
      AList.AddObject(LStr, FEngineParameter.EngineParameterCollect.Items[i]);
  end;
end;

procedure TFrameIPCMonitor.HIC_OnSignal(Data: TEventData_HIC);
begin
  if not FIsUseIPCSharedMMEvent then
    exit;

end;

procedure TFrameIPCMonitor.InitVar;
begin
  FAddressMap := DMap.Create;
  //FConfigOption := TConfigOption.Create(nil); FModbusMapFileName 변수로 대체
  FEngineParameter := TEngineParameter.Create(nil);
  FPJHTimerPool := TPJHTimerPool.Create(nil);
  FEventData_WT1600_List := TEventData_WT1600_List.Create;
  FEventData_PLCMODBUS_List := TEventData_PLCMODBUS_List.Create;
//  FNextGrid := nil;
  FCompleteReadMap_Avat := False;
  FCompleteReadMap_Woodward := False;
  FCompleteReadMap_kumo := False;
  FIsSetZeroWhenDisconnect := True;
  FCurrentUserLevel := HUL_Operator;
  FWatchValue2Screen_AnalogEvent := nil;
  FWatchValue2Screen_2 := nil;
  FIsUseIPCSharedMMEvent := True;
end;

procedure TFrameIPCMonitor.KRAL_OnSignal(Data: TEventData_Modbus_Standard);
var
  i,dcount: integer;
begin
  if not FIsUseIPCSharedMMEvent then
    exit;

  if FDestroying then
    exit;

  FillChar(FKRALData.InpDataBuf[0], High(FKRALData.InpDataBuf) - 1, #0);
  FKRALData.ModBusMode := Data.ModBusMode;

  if Data.ModBusMode = 0 then //ASCII Mode이면
  begin
    //ModePanel.Caption := 'ASCII Mode';
    dcount := Data.NumOfData;
    FKRALData.NumOfBit := Data.NumOfBit;

    for i := 0 to dcount - 1 do
      FKRALData.InpDataBuf2[i] := Data.InpDataBuf2[i];
  end
  else
  if Data.ModBusMode = 1 then// RTU Mode 이면
  begin
    //ModePanel.Caption := 'RTU Mode';
    dcount := Data.NumOfData;
    FKRALData.NumOfBit := Data.NumOfBit;

    if dcount = 0 then
      Inc(dcount);

    for i := 0 to dcount - 1 do
    begin
      FKRALData.InpDataBuf[i] := Data.InpDataBuf[i] ;
    end;
  end//Data.ModBusMode = 1
  else
  if (Data.ModBusMode = 3) then
  begin
    dcount := Data.NumOfData;
    FKRALData.NumOfBit := Data.NumOfBit;
    System.Move(Data.InpDataBuf_double, FKRALData.InpDataBuf_double, Sizeof(Data.InpDataBuf_double));
  end;//Data.ModBusMode = 3

  FKRALData.ModBusAddress := Data.ModBusAddress;
  FKRALData.BlockNo := Data.BlockNo;
  FKRALData.NumOfData := dcount;
  FKRALData.ModBusFunctionCode := Data.ModBusFunctionCode;
  FKRALData.PowerOn := True;

  DisplayMessage2SB(FStatusBar, FKRALData.ModBusAddress + ' 데이타 도착');

  SendMessage(Handle, WM_EVENT_KRAL, 0,0);
  CommonCommunication(psFlowMeterKral);
end;

procedure TFrameIPCMonitor.LBX_OnSignal(Data: TEventData_LBX);
begin
  if not FIsUseIPCSharedMMEvent then
    exit;

  FLBXData.ENGRPM := Data.ENGRPM;
  FLBXData.HTTEMP := Data.HTTEMP;
  FLBXData.LOTEMP := Data.LOTEMP;
  FLBXData.TCRPMA := Data.TCRPMA;
  FLBXData.TCRPMB := Data.TCRPMB;
  FLBXData.TCINLETTEMP := Data.TCINLETTEMP;
  FLBXData.PowerOn := True;

  SendMessage(Handle, WM_EVENT_LBX, 0,0);
  CommonCommunication(psLBX);
end;

procedure TFrameIPCMonitor.MakeMapFromParameter;
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

procedure TFrameIPCMonitor.MEXA7000_2_OnSignal(Data: TEventData_MEXA7000_2);
begin
  if not FIsUseIPCSharedMMEvent then
    exit;

  FMEXA7000Data.CO2 := Data.CO2;
  FMEXA7000Data.CO_L := Data.CO_L;
  FMEXA7000Data.O2 := Data.O2;
  FMEXA7000Data.NOx := Data.NOx;
  FMEXA7000Data.THC := Data.THC;
  FMEXA7000Data.CH4 := Data.CH4;
  FMEXA7000Data.non_CH4 := Data.non_CH4;
  FMEXA7000Data.CollectedValue := Data.CollectedValue;
  FMEXA7000Data.PowerOn := True;

  SendMessage(Handle, WM_EVENT_MEXA7000, 0,0);
  CommonCommunication(psMEXA7000);
end;

procedure TFrameIPCMonitor.MEXA7000_OnSignal(Data: TEventData_MEXA7000);
begin
  if not FIsUseIPCSharedMMEvent then
    exit;

  FMEXA7000Data.CO2 := StrToFloatDef(Data.CO2,0.0);
  FMEXA7000Data.CO_L := StrToFloatDef(Data.CO_L,0.0);
  FMEXA7000Data.O2 := StrToFloatDef(Data.O2,0.0);
  FMEXA7000Data.NOx := StrToFloatDef(Data.NOx,0.0);
  FMEXA7000Data.THC := StrToFloatDef(Data.THC,0.0);
  FMEXA7000Data.CH4 := StrToFloatDef(Data.CH4,0.0);
  FMEXA7000Data.non_CH4 := StrToFloatDef(Data.non_CH4,0.0);
  FMEXA7000Data.CollectedValue := Data.CollectedValue;
  FMEXA7000Data.PowerOn := True;

  SendMessage(Handle, WM_EVENT_MEXA7000, 0,0);
  CommonCommunication(psMEXA7000);
end;

//추가 또는 수정되는 FEngineParameter.EngineParameterCollectItem의 Index를 반환함
function TFrameIPCMonitor.MoveEngineParameterItemRecord(
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

  {$IFDEF USECODESITE}
  CodeSite.EnterMethod('TFrameIPCMonitorAll.MoveEngineParameterItemRecord ===>');
  try
    CodeSite.Send('AAEPItemRecord.AssignToParamItem', IntToStr(Ord(ADragCopyMode)));
  finally
    CodeSite.ExitMethod('TFrameIPCMonitorAll.MoveEngineParameterItemRecord <===');
  end;
  {$ENDIF}

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
end;

procedure TFrameIPCMonitor.MoveEngineParameterItemRecord2(
  var AItemRecord: TEngineParameterItemRecord; AItemIndex: integer);
begin
  FEngineParameter.EngineParameterCollect.Items[AItemIndex].AssignTo(AItemRecord);
  AItemRecord.FAllowUserLevelWatchList := FCurrentUserLevel;
  AItemRecord.FProjectFileName := FEngineParameter.ProjectFileName;
end;

procedure TFrameIPCMonitor.MT210_OnSignal(Data: TEventData_MT210);
begin
  if not FIsUseIPCSharedMMEvent then
    exit;

  FMT210Data.FData := Data.FData;
  FMT210Data.PowerOn := True;

  SendMessage(Handle, WM_EVENT_MT210, 0,0);
  CommonCommunication(psMT210);
end;

procedure TFrameIPCMonitor.OnSetZeroDYNAMO(Sender: TObject; Handle: Integer;
  Interval: Cardinal; ElapsedTime: Integer);
begin
  FillChar(FDYNAMOData, Sizeof(FDYNAMOData), 0);
  FDYNAMOData.PowerOn := False;

  if not FCommDisconnected then
    FCommDisconnected := True;
end;

procedure TFrameIPCMonitor.OnSetZeroECS_AVAT(Sender: TObject; Handle: Integer;
  Interval: Cardinal; ElapsedTime: Integer);
begin
  FillChar(FECSData_AVAT, Sizeof(FECSData_AVAT), 0);
  FECSData_AVAT.PowerOn := False;

  if not FCommDisconnected then
    FCommDisconnected := True;
end;

procedure TFrameIPCMonitor.OnSetZeroECS_ComAP(Sender: TObject;
  Handle: Integer; Interval: Cardinal; ElapsedTime: Integer);
begin
  FillChar(FECSData_ComAP, Sizeof(FECSData_ComAP), 0);
  FECSData_ComAP.PowerOn := False;

  if not FCommDisconnected then
    FCommDisconnected := True;
end;

procedure TFrameIPCMonitor.OnSetZeroECS_ComAP2(Sender: TObject;
  Handle: Integer; Interval: Cardinal; ElapsedTime: Integer);
begin
  FillChar(FECSData_ComAP2, Sizeof(FECSData_ComAP2), 0);
  FECSData_ComAP2.PowerOn := False;

  if not FCommDisconnected then
    FCommDisconnected := True;
end;

procedure TFrameIPCMonitor.OnSetZeroECS_kumo(Sender: TObject; Handle: Integer;
  Interval: Cardinal; ElapsedTime: Integer);
begin
  FillChar(FECSData_kumo, Sizeof(FECSData_kumo), 0);
  FECSData_kumo.PowerOn := False;

  if not FCommDisconnected then
    FCommDisconnected := True;
end;

procedure TFrameIPCMonitor.OnSetZeroECS_Woodward(Sender: TObject;
  Handle: Integer; Interval: Cardinal; ElapsedTime: Integer);
begin
  FillChar(FECSData_Woodward, Sizeof(FECSData_Woodward), 0);
  FECSData_Woodward.PowerOn := False;

  if not FCommDisconnected then
    FCommDisconnected := True;
end;

procedure TFrameIPCMonitor.OnSetZeroEngineParam(Sender: TObject;
  Handle: Integer; Interval: Cardinal; ElapsedTime: Integer);
begin
  FillChar(FEngineParamData, Sizeof(FEngineParamData), 0);
  FEngineParamData.PowerOn := False;

  if not FCommDisconnected then
    FCommDisconnected := True;
end;

procedure TFrameIPCMonitor.OnSetZeroFlowMeter(Sender: TObject; Handle: Integer;
  Interval: Cardinal; ElapsedTime: Integer);
begin
  FillChar(FFlowMeterData, Sizeof(FFlowMeterData), 0);
  FFlowMeterData.PowerOn := False;

  if not FCommDisconnected then
    FCommDisconnected := True;
end;

procedure TFrameIPCMonitor.OnSetZeroGasCalc(Sender: TObject; Handle: Integer;
  Interval: Cardinal; ElapsedTime: Integer);
begin
  FillChar(FGasCalcData, Sizeof(FGasCalcData), 0);
  FGasCalcData.PowerOn := False;

  if not FCommDisconnected then
    FCommDisconnected := True;
end;

procedure TFrameIPCMonitor.OnSetZeroHIC(Sender: TObject; Handle: Integer;
  Interval: Cardinal; ElapsedTime: Integer);
begin
  FillChar(FHICData, Sizeof(FHICData), 0);
  FHICData.PowerOn := False;

  if not FCommDisconnected then
    FCommDisconnected := True;
end;

procedure TFrameIPCMonitor.OnSetZeroKRAL(Sender: TObject; Handle: Integer;
  Interval: Cardinal; ElapsedTime: Integer);
begin
  FillChar(FKRALData, Sizeof(FKRALData), 0);
  FKRALData.PowerOn := False;

  if not FCommDisconnected then
    FCommDisconnected := True;
end;

procedure TFrameIPCMonitor.OnSetZeroLBX(Sender: TObject; Handle: Integer;
  Interval: Cardinal; ElapsedTime: Integer);
begin
  FillChar(FLBXData, Sizeof(FLBXData), 0);
  FLBXData.PowerOn := False;

  if not FCommDisconnected then
    FCommDisconnected := True;
end;

procedure TFrameIPCMonitor.OnSetZeroMEXA7000(Sender: TObject; Handle: Integer;
  Interval: Cardinal; ElapsedTime: Integer);
begin
  FillChar(FMEXA7000Data, Sizeof(FMEXA7000Data), 0);
  FMEXA7000Data.PowerOn := False;

  if not FCommDisconnected then
    FCommDisconnected := True;
end;

procedure TFrameIPCMonitor.OnSetZeroMT210(Sender: TObject; Handle: Integer;
  Interval: Cardinal; ElapsedTime: Integer);
begin
  FillChar(FMT210Data, Sizeof(FMT210Data), 0);
  FMT210Data.PowerOn := False;

  if not FCommDisconnected then
    FCommDisconnected := True;
end;

procedure TFrameIPCMonitor.OnSetZeroPLCMODBUS(Sender: TObject;
  Handle: Integer; Interval: Cardinal; ElapsedTime: Integer);
begin
  FillChar(FPLCModbusData, Sizeof(FPLCModbusData), 0);
  FPLCModbusData.PowerOn := False;

  if not FCommDisconnected then
    FCommDisconnected := True;
end;

procedure TFrameIPCMonitor.OnSetZeroPLC_S7(Sender: TObject; Handle: Integer;
  Interval: Cardinal; ElapsedTime: Integer);
begin
  FillChar(FPLCData_S7, Sizeof(FPLCData_S7), 0);
  FPLCData_S7.PowerOn := False;

  if not FCommDisconnected then
    FCommDisconnected := True;
end;

procedure TFrameIPCMonitor.OnSetZeroPMS(Sender: TObject; Handle: Integer;
  Interval: Cardinal; ElapsedTime: Integer);
begin
  FillChar(FPMSData, Sizeof(FPMSData), 0);
  FPMSData.PowerOn := False;

  if not FCommDisconnected then
    FCommDisconnected := True;
end;

procedure TFrameIPCMonitor.OnSetZeroWT1600(Sender: TObject; Handle: Integer;
  Interval: Cardinal; ElapsedTime: Integer);
begin
  FillChar(FWT1600Data, Sizeof(FWT1600Data), 0);
  FWT1600Data.PowerMeterOn := False;

  if not FCommDisconnected then
    FCommDisconnected := True;

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

procedure TFrameIPCMonitor.OverRide_DYNAMO(AData: TEventData_DYNAMO);
var
  i, LRadix: integer;
  LDataOk: Boolean;
begin
  LDataOk := False;

  for i := 0 to FEngineParameter.EngineParameterCollect.Count - 1 do
  begin
    if FEngineParameter.EngineParameterCollect.Items[i].ParameterSource = psDynamo then
    begin
//      LRadix := FEngineParameter.EngineParameterCollect.Items[i].RadixPosition;

      if UpperCase(FEngineParameter.EngineParameterCollect.Items[i].TagName) = UpperCase('Power') then
        FEngineParameter.EngineParameterCollect.Items[i].Value := FormatFloat(FEngineParameter.EngineParameterCollect.Items[i].DisplayFormat, FDYNAMOData.FPower) // FloatToStrF(FDYNAMOData.FPower, ffFixed, 12, LRadix)
      else if UpperCase(FEngineParameter.EngineParameterCollect.Items[i].TagName) = UpperCase('Torque') then
        FEngineParameter.EngineParameterCollect.Items[i].Value := FormatFloat(FEngineParameter.EngineParameterCollect.Items[i].DisplayFormat, FDYNAMOData.FTorque) //FloatToStrF(FDYNAMOData.FTorque, ffFixed, 12, LRadix)
      else if UpperCase(FEngineParameter.EngineParameterCollect.Items[i].TagName) = UpperCase('RPM') then
        FEngineParameter.EngineParameterCollect.Items[i].Value := FormatFloat(FEngineParameter.EngineParameterCollect.Items[i].DisplayFormat, FDYNAMOData.FRevolution) //FloatToStrF(FDYNAMOData.FRevolution, ffFixed, 12, LRadix)
      else if UpperCase(FEngineParameter.EngineParameterCollect.Items[i].TagName) = UpperCase('BRG_TB') then
        FEngineParameter.EngineParameterCollect.Items[i].Value := FormatFloat(FEngineParameter.EngineParameterCollect.Items[i].DisplayFormat, FDYNAMOData.FBrgTBTemp) //FloatToStrF(FDYNAMOData.FBrgTBTemp, ffFixed, 12, LRadix)
      else if UpperCase(FEngineParameter.EngineParameterCollect.Items[i].TagName) = UpperCase('BRG_MTR') then
        FEngineParameter.EngineParameterCollect.Items[i].Value := FormatFloat(FEngineParameter.EngineParameterCollect.Items[i].DisplayFormat, FDYNAMOData.FBrgMTRTemp) //FloatToStrF(FDYNAMOData.FBrgMTRTemp, ffFixed, 12, LRadix)
      else if UpperCase(FEngineParameter.EngineParameterCollect.Items[i].TagName) = UpperCase('Inlet1') then
        FEngineParameter.EngineParameterCollect.Items[i].Value := FormatFloat(FEngineParameter.EngineParameterCollect.Items[i].DisplayFormat, FDYNAMOData.FInletOpen1) //FloatToStrF(FDYNAMOData.FInletOpen1, ffFixed, 12, LRadix)
      else if UpperCase(FEngineParameter.EngineParameterCollect.Items[i].TagName) = UpperCase('Inlet2') then
        FEngineParameter.EngineParameterCollect.Items[i].Value := FormatFloat(FEngineParameter.EngineParameterCollect.Items[i].DisplayFormat, FDYNAMOData.FInletOpen2) //FloatToStrF(FDYNAMOData.FInletOpen2, ffFixed, 12, LRadix)
      else if UpperCase(FEngineParameter.EngineParameterCollect.Items[i].TagName) = UpperCase('Outlet1') then
        FEngineParameter.EngineParameterCollect.Items[i].Value := FormatFloat(FEngineParameter.EngineParameterCollect.Items[i].DisplayFormat, FDYNAMOData.FOutletOpen1) //FloatToStrF(FDYNAMOData.FOutletOpen1, ffFixed, 12, LRadix)
      else if UpperCase(FEngineParameter.EngineParameterCollect.Items[i].TagName) = UpperCase('Outlet2') then
        FEngineParameter.EngineParameterCollect.Items[i].Value := FormatFloat(FEngineParameter.EngineParameterCollect.Items[i].DisplayFormat, FDYNAMOData.FOutletOpen2) //FloatToStrF(FDYNAMOData.FOutletOpen2, ffFixed, 12, LRadix)
      else if UpperCase(FEngineParameter.EngineParameterCollect.Items[i].TagName) = UpperCase('WaterInlet') then
        FEngineParameter.EngineParameterCollect.Items[i].Value := FormatFloat(FEngineParameter.EngineParameterCollect.Items[i].DisplayFormat, FDYNAMOData.FWaterInletTemp) //FloatToStrF(FDYNAMOData.FWaterInletTemp, ffFixed, 12, LRadix)
      else if UpperCase(FEngineParameter.EngineParameterCollect.Items[i].TagName) = UpperCase('WaterOutlet') then
        FEngineParameter.EngineParameterCollect.Items[i].Value := FormatFloat(FEngineParameter.EngineParameterCollect.Items[i].DisplayFormat, FDYNAMOData.FWaterOutletTemp) //FloatToStrF(FDYNAMOData.FWaterOutletTemp, ffFixed, 12, LRadix)
      else if UpperCase(FEngineParameter.EngineParameterCollect.Items[i].TagName) = UpperCase('Body1') then
        FEngineParameter.EngineParameterCollect.Items[i].Value := FormatFloat(FEngineParameter.EngineParameterCollect.Items[i].DisplayFormat, FDYNAMOData.FBody1Press) //FloatToStrF(FDYNAMOData.FBody1Press, ffFixed, 12, LRadix)
      else if UpperCase(FEngineParameter.EngineParameterCollect.Items[i].TagName) = UpperCase('Body2') then
        FEngineParameter.EngineParameterCollect.Items[i].Value := FormatFloat(FEngineParameter.EngineParameterCollect.Items[i].DisplayFormat, FDYNAMOData.FBody2Press) //FloatToStrF(FDYNAMOData.FBody2Press, ffFixed, 12, LRadix)
      else if UpperCase(FEngineParameter.EngineParameterCollect.Items[i].TagName) = UpperCase('WaterSupply') then
        FEngineParameter.EngineParameterCollect.Items[i].Value := FormatFloat(FEngineParameter.EngineParameterCollect.Items[i].DisplayFormat, FDYNAMOData.FWaterSupply) //FloatToStrF(FDYNAMOData.FWaterSupply, ffFixed, 12, LRadix)
      else if UpperCase(FEngineParameter.EngineParameterCollect.Items[i].TagName) = UpperCase('OilPress') then
        FEngineParameter.EngineParameterCollect.Items[i].Value := FormatFloat(FEngineParameter.EngineParameterCollect.Items[i].DisplayFormat, FDYNAMOData.FOilPress); //FloatToStrF(FDYNAMOData.FOilPress, ffFixed, 12, LRadix);

      WatchValue2Screen_Analog('', '',i);
      LDataOk := True;
    end;
  end;

  FEngineParameter.EngineParameterCollect.PowerOn := LDataOk;
  //상속 받은 자손에서 구현할 것
  {if LDataOk then
  begin
    Timer1.Enabled := True;
    FPJHTimerPool.AddOneShot(OnTrigger4AvgSave,2000);
    DataSaveByEvent;
  end;
  }
end;

procedure TFrameIPCMonitor.OverRide_ECS_AVAT(AData: TEventData_ECS_AVAT);
var
  it: DIterator;
  pHiMap: THiMap;
  i, j, k, BlockNo: integer;
  tmpStr: string;
  tmpByte, ProcessBitCnt: Byte;
  LDataOk: Boolean;
begin
  BlockNo := 0;
  i := 0;
  j := 0;
  ProcessBitCnt := 0;
  LDataOk := False;

  if (FECSData_AVAT.ModBusFunctionCode = 3) or (FECSData_AVAT.ModBusFunctionCode = 4) then
  begin
    for k := 0 to FEngineParameter.EngineParameterCollect.Count - 1 do
    begin
      if FEngineParameter.EngineParameterCollect.Items[k].ParameterSource = psECS_AVAT then
      begin
        tmpStr := IntToStr(FECSData_AVAT.ModBusFunctionCode) +
                    FEngineParameter.EngineParameterCollect.Items[k].Address;
        it := FAddressMap.locate( [tmpStr] );
        SetToValue(it);

        while not atEnd(it) do
        begin
          if i > FECSData_AVAT.NumOfData - 1 then
            break;

          pHiMap := GetObject(it) as THiMap;

          if (IntToStr(FECSData_Avat.ModBusFunctionCode) = FEngineParameter.EngineParameterCollect.Items[k].FCode) and
                    (pHiMap.FAddress = FEngineParameter.EngineParameterCollect.Items[k].Address) then
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
            Value2Screen_ECS_AVAT(pHiMap,k, FECSData_AVAT.ModBusMode);
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

    for k := 0 to FEngineParameter.EngineParameterCollect.Count - 1 do
    begin
      if FEngineParameter.EngineParameterCollect.Items[k].ParameterSource = psECS_AVAT then
      begin
        if (IntToStr(FECSData_AVAT.ModBusFunctionCode) = FEngineParameter.EngineParameterCollect.Items[k].FCode) and
                  (pHiMap.FAddress = FEngineParameter.EngineParameterCollect.Items[k].Address) then
        begin
          //수신된 데이타를 화면에 뿌려줌
          Value2Screen_ECS_AVAT(pHiMap, k, FECSData_AVAT.ModBusMode);
          LDataOk := True;
          break;
        end;
      end;
    end;
  end;//else

  FEngineParameter.EngineParameterCollect.PowerOn := LDataOk;

  if LDataOK then
    if Assigned(FWatchValue2Screen_2) then
      FWatchValue2Screen_2();
  //상속 받은 자손에서 구현할 것
  {if LDataOk then
  begin
    Timer1.Enabled := True;
    FPJHTimerPool.AddOneShot(OnTrigger4AvgSave,2000);
    DataSaveByEvent;
  end;
  }

  DisplayMessage2SB(FStatusBar, FECSData_AVAT.ModBusAddress + ' 처리중...');
end;

procedure TFrameIPCMonitor.OverRide_ECS_ComAP(
  AData: TEventData_Modbus_Standard);
var
  i,j,k: integer;
  Le: double;
  LRadix: integer;
  LDataOk: boolean;
begin
  LDataOk := False;

  if (FECSData_ComAP.ModBusFunctionCode = 1) or (FECSData_ComAP.ModBusFunctionCode = 2)
    or (FECSData_ComAP.ModBusFunctionCode = 3) or (FECSData_ComAP.ModBusFunctionCode = 4) then
  begin
    for k := 0 to FEngineParameter.EngineParameterCollect.Count - 1 do
    begin
      if FEngineParameter.EngineParameterCollect.Items[k].ParameterSource = psECS_ComAP then
      begin
        if FECSData_ComAP.BlockNo <> FEngineParameter.EngineParameterCollect.Items[k].BlockNo then
          Continue;

        //AbsoluteIndex에 Modbus Map에서 각 Request별 위치 정보(공유메모리상의 Index)
        i := FEngineParameter.EngineParameterCollect.Items[k].AbsoluteIndex;

        if FEngineParameter.EngineParameterCollect.Items[k].Alarm then //Analog data
        begin
          if FECSData_ComAP.ModBusMode = 3 then //simulate from csv
          begin
            Le := FECSData_ComAP.InpDataBuf_double[i];
          end
          else
          begin
            case FEngineParameter.EngineParameterCollect.Items[k].MinMaxType of
              mmtInteger: begin
                if FEngineParameter.EngineParameterCollect.Items[k].MaxValue > 0 then
                  Le := FECSData_ComAP.InpDataBuf[i]/FEngineParameter.EngineParameterCollect.Items[k].MaxValue
                else
                  Le := FECSData_ComAP.InpDataBuf[i];
              end;
              mmtReal: begin
                if FEngineParameter.EngineParameterCollect.Items[k].MaxValue_Real > 0.0 then
                  Le := FECSData_ComAP.InpDataBuf[i]/FEngineParameter.EngineParameterCollect.Items[k].MaxValue_Real
                else
                  Le := FECSData_ComAP.InpDataBuf[i];
              end;
            end;//case
          end;

//          LRadix := FEngineParameter.EngineParameterCollect.Items[k].RadixPosition;

          FEngineParameter.EngineParameterCollect.Items[k].Value := FormatFloat(FEngineParameter.EngineParameterCollect.Items[k].DisplayFormat, Le);
//          FEngineParameter.EngineParameterCollect.Items[k].Value := FloatToStrF(Le, ffFixed, 12, LRadix);//,'%.2f');
        end
        else //Digital data
        begin
          i := FEngineParameter.EngineParameterCollect.Items[k].AbsoluteIndex;

          j := FEngineParameter.EngineParameterCollect.Items[k].RadixPosition;
          //0이 아니면 True임
          FEngineParameter.EngineParameterCollect.Items[k].Value := IntToStr(GetBitVal(FECSData_ComAP.InpDataBuf[i], j));
        end;

                  //수신된 데이타를 화면에 뿌려줌
        Value2Screen_ECS_Woodward(k,FECSData_ComAP.ModBusMode);
        LDataOk := True;
      end;
    end;//for
  end;

  FEngineParameter.EngineParameterCollect.PowerOn := LDataOk;

  if LDataOK then
    if Assigned(FWatchValue2Screen_2) then
      FWatchValue2Screen_2();
end;

procedure TFrameIPCMonitor.OverRide_ECS_ComAP2(
  AData: TEventData_Modbus_Standard);
var
  i,j,k: integer;
  Le: double;
  LRadix: integer;
  LDataOk: boolean;
begin
  LDataOk := False;

  if (FECSData_ComAP2.ModBusFunctionCode = 1) or (FECSData_ComAP2.ModBusFunctionCode = 2)
    or (FECSData_ComAP2.ModBusFunctionCode = 3) or (FECSData_ComAP2.ModBusFunctionCode = 4) then
  begin
    for k := 0 to FEngineParameter.EngineParameterCollect.Count - 1 do
    begin
      if FEngineParameter.EngineParameterCollect.Items[k].ParameterSource = psECS_ComAP2 then
      begin
        if FECSData_ComAP2.BlockNo <> FEngineParameter.EngineParameterCollect.Items[k].BlockNo then
          Continue;

        //AbsoluteIndex에 Modbus Map에서 각 Request별 위치 정보(공유메모리상의 Index)
        i := FEngineParameter.EngineParameterCollect.Items[k].AbsoluteIndex;

        if FEngineParameter.EngineParameterCollect.Items[k].Alarm then //Analog data
        begin
          if FECSData_ComAP2.ModBusMode = 3 then //simulate from csv
          begin
            Le := FECSData_ComAP2.InpDataBuf_double[i];
          end
          else
          begin
            case FEngineParameter.EngineParameterCollect.Items[k].MinMaxType of
              mmtInteger: begin
                if FEngineParameter.EngineParameterCollect.Items[k].MaxValue > 0 then
                  Le := FECSData_ComAP2.InpDataBuf[i]/FEngineParameter.EngineParameterCollect.Items[k].MaxValue
                else
                  Le := FECSData_ComAP2.InpDataBuf[i];
              end;
              mmtReal: begin
                if FEngineParameter.EngineParameterCollect.Items[k].MaxValue_Real > 0.0 then
                  Le := FECSData_ComAP2.InpDataBuf[i]/FEngineParameter.EngineParameterCollect.Items[k].MaxValue_Real
                else
                  Le := FECSData_ComAP2.InpDataBuf[i];
              end;
            end;//case
          end;

//          LRadix := FEngineParameter.EngineParameterCollect.Items[k].RadixPosition;

          FEngineParameter.EngineParameterCollect.Items[k].Value := FormatFloat(FEngineParameter.EngineParameterCollect.Items[k].DisplayFormat, Le);
//          FEngineParameter.EngineParameterCollect.Items[k].Value := FloatToStrF(Le, ffFixed, 12, LRadix);//,'%.2f');
        end
        else //Digital data
        begin
          i := FEngineParameter.EngineParameterCollect.Items[k].AbsoluteIndex;

          j := FEngineParameter.EngineParameterCollect.Items[k].RadixPosition;
          //0이 아니면 True임
          FEngineParameter.EngineParameterCollect.Items[k].Value := IntToStr(GetBitVal(FECSData_ComAP2.InpDataBuf[i], j));
        end;

                  //수신된 데이타를 화면에 뿌려줌
        Value2Screen_ECS_Woodward(k,FECSData_ComAP2.ModBusMode);
        LDataOk := True;
      end;
    end;//for
  end;

  FEngineParameter.EngineParameterCollect.PowerOn := LDataOk;

  if LDataOK then
    if Assigned(FWatchValue2Screen_2) then
      FWatchValue2Screen_2();
end;

procedure TFrameIPCMonitor.OverRide_ECS_kumo(AData: TEventData_ECS_kumo);
var
  i,k: integer;
  Le: double;
  LRadix: integer;
  LDataOk: Boolean;
begin
  LDataOk := False;

  if (FECSData_kumo.ModBusFunctionCode = 3) or (FECSData_kumo.ModBusFunctionCode = 4) then
  begin
    for k := 0 to FEngineParameter.EngineParameterCollect.Count - 1 do
    begin
      if FEngineParameter.EngineParameterCollect.Items[k].ParameterSource = psECS_kumo then
      begin
        if FECSData_kumo.BlockNo <> FEngineParameter.EngineParameterCollect.Items[k].BlockNo then
          Continue;

        i := FEngineParameter.EngineParameterCollect.Items[k].AbsoluteIndex;

        if FEngineParameter.EngineParameterCollect.Items[k].Alarm then //Analog data
        begin
          if FECSData_kumo.ModBusMode = 3 then
          begin
            Le := FECSData_kumo.InpDataBuf_double[i];
          end
          else
          begin
            Le := FECSData_kumo.InpDataBuf[i];
            if FEngineParameter.EngineParameterCollect.Items[k].MaxValue = 0 then
                    FEngineParameter.EngineParameterCollect.Items[k].MaxValue := 1;

            case FEngineParameter.EngineParameterCollect.Items[k].ParameterSource of
              psECS_kumo2: begin
                Le := (Le * FEngineParameter.EngineParameterCollect.Items[k].MaxValue) / 4095;
              end;
              psECS_kumo: begin
                Le := (Le + FEngineParameter.EngineParameterCollect.Items[k].MinValue) / FEngineParameter.EngineParameterCollect.Items[k].MaxValue;//Scale
              end;
//              psECS_kumo3: begin
//              end;
            end;

          end;

          FEngineParameter.EngineParameterCollect.Items[k].Value := FormatFloat(FEngineParameter.EngineParameterCollect.Items[k].DisplayFormat,Le);
//          FEngineParameter.EngineParameterCollect.Items[k].Value := FloatToStrF(Le, ffFixed, 12, LRadix);//,'%.2f');
          LDataOk := True;
//     ShowMessage(IntToStr(FEngineParameter.EngineParameterCollect.Items[k].MaxValue) + ' = ' + FloatToStr(Le));//IntToStr(FECSData_kumo.InpDataBuf[2]));

        end;

        //수신된 데이타를 화면에 뿌려줌
        Value2Screen_ECS_kumo2(k,FECSData_kumo.ModBusMode);
      end;
    end;//for
  end;

  FEngineParameter.EngineParameterCollect.PowerOn := LDataOk;

  if LDataOK then
    if Assigned(FWatchValue2Screen_2) then
      FWatchValue2Screen_2();
end;

procedure TFrameIPCMonitor.OverRide_ECS_kumo2(AData: TEventData_ECS_kumo);
var
  i,k: integer;
  Le: double;
  LRadix: integer;
  LDataOk: Boolean;
begin
  LDataOk := False;

  if (FECSData_kumo.ModBusFunctionCode = 3) or (FECSData_kumo.ModBusFunctionCode = 4) then
  begin
    for k := 0 to FEngineParameter.EngineParameterCollect.Count - 1 do
    begin
      if FEngineParameter.EngineParameterCollect.Items[k].ParameterSource = psECS_kumo then
      begin
        if FECSData_kumo.BlockNo <> FEngineParameter.EngineParameterCollect.Items[k].BlockNo then
          Continue;

        i := FEngineParameter.EngineParameterCollect.Items[k].AbsoluteIndex;

        if FEngineParameter.EngineParameterCollect.Items[k].Alarm then //Analog data
        begin
          if FECSData_kumo.ModBusMode = 3 then
          begin
            Le := FECSData_kumo.InpDataBuf_double[i];
          end
          else
          begin
            Le := FECSData_kumo.InpDataBuf[i];
            if FEngineParameter.EngineParameterCollect.Items[k].Scale = 0 then
                    FEngineParameter.EngineParameterCollect.Items[k].Scale := 1;
            Le := (Le + FEngineParameter.EngineParameterCollect.Items[k].MinValue) / FEngineParameter.EngineParameterCollect.Items[k].Scale;
          end;

          FEngineParameter.EngineParameterCollect.Items[k].Value := FormatFloat(FEngineParameter.EngineParameterCollect.Items[k].DisplayFormat,Le);
//          FEngineParameter.EngineParameterCollect.Items[k].Value := FloatToStrF(Le, ffFixed, 12, LRadix);//,'%.2f');
          LDataOk := True;
//     ShowMessage(IntToStr(FEngineParameter.EngineParameterCollect.Items[k].MaxValue) + ' = ' + FloatToStr(Le));//IntToStr(FECSData_kumo.InpDataBuf[2]));

        end;

        //수신된 데이타를 화면에 뿌려줌
        Value2Screen_ECS_kumo2(k,FECSData_kumo.ModBusMode);
      end;
    end;//for
  end;

  FEngineParameter.EngineParameterCollect.PowerOn := LDataOk;

  if LDataOK then
    if Assigned(FWatchValue2Screen_2) then
      FWatchValue2Screen_2();
end;

procedure TFrameIPCMonitor.OverRide_ECS_kumo3(AData: TEventData_ECS_kumo);
var
  i,k: integer;
  Le: double;
  LRadix: integer;
  LDataOk: Boolean;
begin
  LDataOk := False;

  if (FECSData_kumo.ModBusFunctionCode = 3) or (FECSData_kumo.ModBusFunctionCode = 4) then
  begin
    for k := 0 to FEngineParameter.EngineParameterCollect.Count - 1 do
    begin
      if FEngineParameter.EngineParameterCollect.Items[k].ParameterSource = psECS_kumo then //나중에 psECS_kumo2로 수정해야 함
      begin
        if FECSData_kumo.BlockNo <> FEngineParameter.EngineParameterCollect.Items[k].BlockNo then
          Continue;

        i := FEngineParameter.EngineParameterCollect.Items[k].AbsoluteIndex;

        if FEngineParameter.EngineParameterCollect.Items[k].Alarm then //Analog data
        begin
          if FECSData_kumo.ModBusMode = 3 then
          begin
            Le := FECSData_kumo.InpDataBuf_double[i];
          end
          else
          begin
            if FEngineParameter.EngineParameterCollect.Items[k].MaxValue > 0 then
              Le := FECSData_kumo.InpDataBuf[i]/FEngineParameter.EngineParameterCollect.Items[k].MaxValue
            else
              Le := FECSData_kumo.InpDataBuf[i];
//            Le := FECSData_kumo.InpDataBuf[i];
            //7H21C엔진 제어기의 경우 값이 RPM = 900으로 전송됨
            //때문에 이전 금오기전 제어기와 통신할 경우 MaxValue에 4095를 더해 주어야 함(param file에서 설정)
//            Le := (Le * FEngineParameter.EngineParameterCollect.Items[k].MaxValue) / 4095;
          end;

//          LRadix := FEngineParameter.EngineParameterCollect.Items[k].RadixPosition;

          FEngineParameter.EngineParameterCollect.Items[k].Value := FormatFloat(FEngineParameter.EngineParameterCollect.Items[k].DisplayFormat,Le);
//          FEngineParameter.EngineParameterCollect.Items[k].Value := FloatToStrF(Le, ffFixed, 12, LRadix);//,'%.2f');
          LDataOk := True;
//     ShowMessage(IntToStr(FEngineParameter.EngineParameterCollect.Items[k].MaxValue) + ' = ' + FloatToStr(Le));//IntToStr(FECSData_kumo.InpDataBuf[2]));
//    exit;

        end;

        //수신된 데이타를 화면에 뿌려줌
        Value2Screen_ECS_kumo2(k,FECSData_kumo.ModBusMode);
      end;
    end;//for
  end;

  FEngineParameter.EngineParameterCollect.PowerOn := LDataOk;

  if LDataOK then
    if Assigned(FWatchValue2Screen_2) then
      FWatchValue2Screen_2();
end;

procedure TFrameIPCMonitor.OverRide_ECS_Woodward(
  AData: TEventData_ECS_Woodward);
var
  i,k: integer;
  Le: double;
  LRadix: integer;
  LDataOk: Boolean;
begin
  LDataOk := False;

  if (FECSData_Woodward.ModBusFunctionCode = 1) or (FECSData_Woodward.ModBusFunctionCode = 2)
    or (FECSData_Woodward.ModBusFunctionCode = 3) or (FECSData_Woodward.ModBusFunctionCode = 4) then
  begin
    for k := 0 to FEngineParameter.EngineParameterCollect.Count - 1 do
    begin
      if FEngineParameter.EngineParameterCollect.Items[k].ParameterSource = psECS_Woodward then
      begin
        if FECSData_Woodward.BlockNo <> FEngineParameter.EngineParameterCollect.Items[k].BlockNo then
          Continue;

        //AbsoluteIndex에 Modbus Map에서 각 Request별 위치 정보(공유메모리상의 Index)
        i := FEngineParameter.EngineParameterCollect.Items[k].AbsoluteIndex;

        if FEngineParameter.EngineParameterCollect.Items[k].Alarm then //Analog data
        begin
          if FECSData_Woodward.ModBusMode = 3 then
          begin
            Le := FECSData_Woodward.InpDataBuf_double[i];
          end
          else
          begin
            case FEngineParameter.EngineParameterCollect.Items[k].MinMaxType of
              mmtInteger: begin
                if FEngineParameter.EngineParameterCollect.Items[k].MaxValue > 0 then
                  Le := FECSData_Woodward.InpDataBuf[i]/FEngineParameter.EngineParameterCollect.Items[k].MaxValue
                else
                  Le := FECSData_Woodward.InpDataBuf[i];
              end;
              mmtReal: begin
                if FEngineParameter.EngineParameterCollect.Items[k].MaxValue_Real > 0.0 then
                  Le := FECSData_Woodward.InpDataBuf[i]/FEngineParameter.EngineParameterCollect.Items[k].MaxValue_Real
                else
                  Le := FECSData_Woodward.InpDataBuf[i];
              end;
            end;//case
          end;

//          LRadix := FEngineParameter.EngineParameterCollect.Items[k].RadixPosition;

          FEngineParameter.EngineParameterCollect.Items[k].Value := FormatFloat(FEngineParameter.EngineParameterCollect.Items[i].DisplayFormat,Le);
//          FEngineParameter.EngineParameterCollect.Items[k].Value := FloatToStrF(Le, ffFixed, 12, LRadix);//,'%.2f');
        end
        else //Digital data
        begin
          if FECSData_Woodward.InpDataBuf[i] = $FFFF then //True value
            FEngineParameter.EngineParameterCollect.Items[k].Value := 'True'
          else
            FEngineParameter.EngineParameterCollect.Items[k].Value := 'False';
        end;

        //수신된 데이타를 화면에 뿌려줌
        Value2Screen_ECS_Woodward(k,FECSData_Woodward.ModBusMode);

        LDataOk := True;
      end;
    end;//for
  end;

  FEngineParameter.EngineParameterCollect.PowerOn := LDataOk;

  if LDataOK then
    if Assigned(FWatchValue2Screen_2) then
      FWatchValue2Screen_2();
end;

procedure TFrameIPCMonitor.OverRide_EngineParam(
  AData: TEventData_EngineParam);
var
  i, LMode: integer;
  LDataOk: boolean;
begin
  LDataOk := False;

  for i := 0 to FEngineParameter.EngineParameterCollect.Count - 1 do
  begin
    if FEngineParameter.EngineParameterCollect.Items[i].ParameterSource = psEngineParam then
    begin
      if FEngineParamData.FDataCount < i then
      begin
        FEngineParameter.EngineParameterCollect.Items[i].Value := FEngineParamData.FData[i];
//      WatchValue2Grid('', i, False);
        //수신된 데이타를 화면에 뿌려줌
        Value2Screen_ECS_Woodward(i);
        LDataOk := True;
      end;
    end;
  end;//for

  FEngineParameter.EngineParameterCollect.PowerOn := LDataOk;

  if LDataOK then
    if Assigned(FWatchValue2Screen_2) then
      FWatchValue2Screen_2();
end;

procedure TFrameIPCMonitor.OverRide_FlowMeter(AData: TEventData_FlowMeter);
var
  LDataOk: Boolean;
begin

//  FEngineParameter.EngineParameterCollect.PowerOn := LDataOk;
  //상속 받은 자손에서 구현할 것
  {if LDataOk then
  begin
    Timer1.Enabled := True;
    FPJHTimerPool.AddOneShot(OnTrigger4AvgSave,2000);
    DataSaveByEvent;
  end;
  }
end;

procedure TFrameIPCMonitor.OverRide_GasCalc(AData: TEventData_GasCalc);
var
  i, LRadix: integer;
  LDouble: double;
  LDataOk: Boolean;
begin
  LDataOk := False;

  for i := 0 to FEngineParameter.EngineParameterCollect.Count - 1 do
  begin
    if FEngineParameter.EngineParameterCollect.Items[i].ParameterSource = psGasCalculated then
    begin
//      LRadix := FEngineParameter.EngineParameterCollect.Items[i].RadixPosition;

      if UpperCase(FEngineParameter.EngineParameterCollect.Items[i].TagName) = UpperCase('SVP') then
        FEngineParameter.EngineParameterCollect.Items[i].Value := FormatFloat(FEngineParameter.EngineParameterCollect.Items[i].DisplayFormat,FGasCalcData.FSVP) //FloatToStr(FGasCalcData.FSVP)
      else if UpperCase(FEngineParameter.EngineParameterCollect.Items[i].TagName) = UpperCase('IAH2') then
        FEngineParameter.EngineParameterCollect.Items[i].Value := FormatFloat(FEngineParameter.EngineParameterCollect.Items[i].DisplayFormat,FGasCalcData.FIAH2) //FloatToStr(FGasCalcData.FIAH2)
      else if UpperCase(FEngineParameter.EngineParameterCollect.Items[i].TagName) = UpperCase('UFC') then
        FEngineParameter.EngineParameterCollect.Items[i].Value := FormatFloat(FEngineParameter.EngineParameterCollect.Items[i].DisplayFormat,FGasCalcData.FUFC) //FloatToStr(FGasCalcData.FUFC)
      else if UpperCase(FEngineParameter.EngineParameterCollect.Items[i].TagName) = UpperCase('NhtCF') then
        FEngineParameter.EngineParameterCollect.Items[i].Value := FormatFloat(FEngineParameter.EngineParameterCollect.Items[i].DisplayFormat,FGasCalcData.FNhtCF) //FloatToStr(FGasCalcData.FNhtCF)
      else if UpperCase(FEngineParameter.EngineParameterCollect.Items[i].TagName) = UpperCase('DWCFE') then
        FEngineParameter.EngineParameterCollect.Items[i].Value := FormatFloat(FEngineParameter.EngineParameterCollect.Items[i].DisplayFormat,FGasCalcData.FDWCFE) //FloatToStr(FGasCalcData.FDWCFE)
      else if UpperCase(FEngineParameter.EngineParameterCollect.Items[i].TagName) = UpperCase('EGF') then
        FEngineParameter.EngineParameterCollect.Items[i].Value := FormatFloat(FEngineParameter.EngineParameterCollect.Items[i].DisplayFormat,FGasCalcData.FEGF) //FloatToStr(FGasCalcData.FEGF)
      else if UpperCase(FEngineParameter.EngineParameterCollect.Items[i].TagName) = UpperCase('NOxAtO213') then
        FEngineParameter.EngineParameterCollect.Items[i].Value := FormatFloat(FEngineParameter.EngineParameterCollect.Items[i].DisplayFormat,FGasCalcData.FNOxAtO213) //FloatToStr(FGasCalcData.FNOxAtO213)
      else if UpperCase(FEngineParameter.EngineParameterCollect.Items[i].TagName) = UpperCase('NOx') then
        FEngineParameter.EngineParameterCollect.Items[i].Value := FormatFloat(FEngineParameter.EngineParameterCollect.Items[i].DisplayFormat,FGasCalcData.FNOx) //FloatToStr(FGasCalcData.FNOx)
      else if UpperCase(FEngineParameter.EngineParameterCollect.Items[i].TagName) = UpperCase('AF1') then
        FEngineParameter.EngineParameterCollect.Items[i].Value := FormatFloat(FEngineParameter.EngineParameterCollect.Items[i].DisplayFormat,FGasCalcData.FAF1) //FloatToStr(FGasCalcData.FAF1)
      else if UpperCase(FEngineParameter.EngineParameterCollect.Items[i].TagName) = UpperCase('AF2') then
        FEngineParameter.EngineParameterCollect.Items[i].Value := FormatFloat(FEngineParameter.EngineParameterCollect.Items[i].DisplayFormat,FGasCalcData.FAF2) //FloatToStr(FGasCalcData.FAF2)
      else if UpperCase(FEngineParameter.EngineParameterCollect.Items[i].TagName) = UpperCase('AF3') then
        FEngineParameter.EngineParameterCollect.Items[i].Value := FormatFloat(FEngineParameter.EngineParameterCollect.Items[i].DisplayFormat,FGasCalcData.FAF3) //FloatToStr(FGasCalcData.FAF3)
      else if UpperCase(FEngineParameter.EngineParameterCollect.Items[i].TagName) = UpperCase('AF_Measured') then
        FEngineParameter.EngineParameterCollect.Items[i].Value := FormatFloat(FEngineParameter.EngineParameterCollect.Items[i].DisplayFormat,FGasCalcData.FAF_Measured) //FloatToStr(FGasCalcData.FAF_Measured)
      else if UpperCase(FEngineParameter.EngineParameterCollect.Items[i].TagName) = UpperCase('MT210') then
        FEngineParameter.EngineParameterCollect.Items[i].Value := FormatFloat(FEngineParameter.EngineParameterCollect.Items[i].DisplayFormat,FGasCalcData.FMT210) //FloatToStr(FGasCalcData.FMT210)
      else if UpperCase(FEngineParameter.EngineParameterCollect.Items[i].TagName) = UpperCase('FC') then
        FEngineParameter.EngineParameterCollect.Items[i].Value := FormatFloat(FEngineParameter.EngineParameterCollect.Items[i].DisplayFormat,FGasCalcData.FFC) //FloatToStr(FGasCalcData.FFC)
      else if UpperCase(FEngineParameter.EngineParameterCollect.Items[i].TagName) = UpperCase('EngineOutput') then
        FEngineParameter.EngineParameterCollect.Items[i].Value := FormatFloat(FEngineParameter.EngineParameterCollect.Items[i].DisplayFormat,FGasCalcData.FEngineOutput) //FloatToStr(FGasCalcData.FEngineOutput)
      else if UpperCase(FEngineParameter.EngineParameterCollect.Items[i].TagName) = UpperCase('GeneratorOutput') then
        FEngineParameter.EngineParameterCollect.Items[i].Value := FormatFloat(FEngineParameter.EngineParameterCollect.Items[i].DisplayFormat,FGasCalcData.FGeneratorOutput) //FloatToStr(FGasCalcData.FGeneratorOutput)
      else if UpperCase(FEngineParameter.EngineParameterCollect.Items[i].TagName) = UpperCase('EngineLoad') then
        FEngineParameter.EngineParameterCollect.Items[i].Value := FormatFloat(FEngineParameter.EngineParameterCollect.Items[i].DisplayFormat,FGasCalcData.FEngineLoad) //FloatToStr(FGasCalcData.FEngineLoad)
      else if UpperCase(FEngineParameter.EngineParameterCollect.Items[i].TagName) = UpperCase('GenEfficiency') then
        FEngineParameter.EngineParameterCollect.Items[i].Value := FormatFloat(FEngineParameter.EngineParameterCollect.Items[i].DisplayFormat,FGasCalcData.FGenEfficiency) //FloatToStr(FGasCalcData.FGenEfficiency)
      else if UpperCase(FEngineParameter.EngineParameterCollect.Items[i].TagName) = UpperCase('BHP') then
        FEngineParameter.EngineParameterCollect.Items[i].Value := FormatFloat(FEngineParameter.EngineParameterCollect.Items[i].DisplayFormat,FGasCalcData.FBHP) //FloatToStr(FGasCalcData.FBHP)
      else if UpperCase(FEngineParameter.EngineParameterCollect.Items[i].TagName) = UpperCase('BMEP') then
        FEngineParameter.EngineParameterCollect.Items[i].Value := FormatFloat(FEngineParameter.EngineParameterCollect.Items[i].DisplayFormat,FGasCalcData.FBMEP) //FloatToStr(FGasCalcData.FBMEP)
      else if UpperCase(FEngineParameter.EngineParameterCollect.Items[i].TagName) = UpperCase('Lamda_Calculated') then
        FEngineParameter.EngineParameterCollect.Items[i].Value := FormatFloat(FEngineParameter.EngineParameterCollect.Items[i].DisplayFormat,FGasCalcData.FLamda_Calculated) //FloatToStr(FGasCalcData.FLamda_Calculated)
      else if UpperCase(FEngineParameter.EngineParameterCollect.Items[i].TagName) = UpperCase('Lamda_Measured') then
        FEngineParameter.EngineParameterCollect.Items[i].Value := FormatFloat(FEngineParameter.EngineParameterCollect.Items[i].DisplayFormat,FGasCalcData.FLamda_Measured) //FloatToStr(FGasCalcData.FLamda_Measured)
      else if UpperCase(FEngineParameter.EngineParameterCollect.Items[i].TagName) = UpperCase('Lamda_Brettschneider') then
        FEngineParameter.EngineParameterCollect.Items[i].Value := FormatFloat(FEngineParameter.EngineParameterCollect.Items[i].DisplayFormat,FGasCalcData.FLamda_Brettschneider) //FloatToStr(FGasCalcData.FLamda_Brettschneider)
      else if UpperCase(FEngineParameter.EngineParameterCollect.Items[i].TagName) = UpperCase('AFRatio_Calculated') then
        FEngineParameter.EngineParameterCollect.Items[i].Value := FormatFloat(FEngineParameter.EngineParameterCollect.Items[i].DisplayFormat,FGasCalcData.FAFRatio_Calculated) //FloatToStr(FGasCalcData.FAFRatio_Calculated)
      else if UpperCase(FEngineParameter.EngineParameterCollect.Items[i].TagName) = UpperCase('AFRatio_Measured') then
        FEngineParameter.EngineParameterCollect.Items[i].Value := FormatFloat(FEngineParameter.EngineParameterCollect.Items[i].DisplayFormat,FGasCalcData.FAFRatio_Measured) //FloatToStr(FGasCalcData.FAFRatio_Measured)
      else if UpperCase(FEngineParameter.EngineParameterCollect.Items[i].TagName) = UpperCase('ExhTempAvg') then
        FEngineParameter.EngineParameterCollect.Items[i].Value := FormatFloat(FEngineParameter.EngineParameterCollect.Items[i].DisplayFormat,FGasCalcData.FExhTempAvg) //FloatToStr(FGasCalcData.FExhTempAvg)
      else if UpperCase(FEngineParameter.EngineParameterCollect.Items[i].TagName) = UpperCase('WasteGatePosition') then
        FEngineParameter.EngineParameterCollect.Items[i].Value := FormatFloat(FEngineParameter.EngineParameterCollect.Items[i].DisplayFormat,FGasCalcData.FWasteGatePosition) //FloatToStr(FGasCalcData.FWasteGatePosition)
      else if UpperCase(FEngineParameter.EngineParameterCollect.Items[i].TagName) = UpperCase('ThrottlePosition') then
        FEngineParameter.EngineParameterCollect.Items[i].Value := FormatFloat(FEngineParameter.EngineParameterCollect.Items[i].DisplayFormat,FGasCalcData.FThrottlePosition) //FloatToStr(FGasCalcData.FThrottlePosition)
      else if UpperCase(FEngineParameter.EngineParameterCollect.Items[i].TagName) = UpperCase('Density') then
        FEngineParameter.EngineParameterCollect.Items[i].Value := FormatFloat(FEngineParameter.EngineParameterCollect.Items[i].DisplayFormat,FGasCalcData.FDensity) //FloatToStr(FGasCalcData.FDensity)
      else if UpperCase(FEngineParameter.EngineParameterCollect.Items[i].TagName) = UpperCase('LCV') then
        FEngineParameter.EngineParameterCollect.Items[i].Value := FormatFloat(FEngineParameter.EngineParameterCollect.Items[i].DisplayFormat,FGasCalcData.FLCV) //FloatToStr(FGasCalcData.FLCV)
      else if UpperCase(FEngineParameter.EngineParameterCollect.Items[i].TagName) = UpperCase('BoostPress') then
        FEngineParameter.EngineParameterCollect.Items[i].Value := FormatFloat(FEngineParameter.EngineParameterCollect.Items[i].DisplayFormat,FGasCalcData.FBoostPress); //FloatToStr(FGasCalcData.FBoostPress);

      WatchValue2Screen_Analog('', '',i);
      LDataOk := True;
    end;
  end;//for

  FEngineParameter.EngineParameterCollect.PowerOn := LDataOk;

  if LDataOK then
    if Assigned(FWatchValue2Screen_2) then
      FWatchValue2Screen_2();
end;

procedure TFrameIPCMonitor.OverRide_HIC(AData: TEventData_HIC);
var
  i,k, LValue: integer;
  Le: double;
  LRadix: integer;
  LDataOk: boolean;
begin
  LDataOk := False;

  if (FHICData.ModBusFunctionCode = 3) or (FHICData.ModBusFunctionCode = 4) then
  begin
    for k := 0 to FEngineParameter.EngineParameterCollect.Count - 1 do
    begin
      if FEngineParameter.EngineParameterCollect.Items[k].ParameterSource = psHIC then
      begin
        if FKRALData.BlockNo <> FEngineParameter.EngineParameterCollect.Items[k].BlockNo then
          Continue;

        i := FEngineParameter.EngineParameterCollect.Items[k].AbsoluteIndex;

        if FEngineParameter.EngineParameterCollect.Items[k].Alarm then //Analog data
        begin
          if FHICData.ModBusMode = 3 then
          begin
            Le := FHICData.InpDataBuf_f[i];
          end
          else
          begin
            //LValue := ((FKRALData.InpDataBuf[i] shl 16) or FKRALData.InpDataBuf[i+1]);
            //Le := LValue / 10;
            Le := FHICData.InpDataBuf[i];
          end;

//          LRadix := FEngineParameter.EngineParameterCollect.Items[k].RadixPosition;

          FEngineParameter.EngineParameterCollect.Items[k].Value := FormatFloat(FEngineParameter.EngineParameterCollect.Items[k].DisplayFormat,Le);
//          FEngineParameter.EngineParameterCollect.Items[k].Value := FloatToStrF(Le, ffFixed, 12, LRadix);//,'%.2f');
        end;

        //수신된 데이타를 화면에 뿌려줌
        Value2Screen_ECS_kumo2(k,FHICData.ModBusMode);
        LDataOk := True;
      end;
    end;//for
  end;

  FEngineParameter.EngineParameterCollect.PowerOn := LDataOk;

  if LDataOK then
    if Assigned(FWatchValue2Screen_2) then
      FWatchValue2Screen_2();
end;

procedure TFrameIPCMonitor.OverRide_KRAL(AData: TEventData_Modbus_Standard);
var
  i,k, LValue: integer;
  Le: double;
  LRadix: integer;
  LDataOk: Boolean;
begin
  LDataOk := False;

  if (FKRALData.ModBusFunctionCode = 3) or (FKRALData.ModBusFunctionCode = 4) then
  begin
    for k := 0 to FEngineParameter.EngineParameterCollect.Count - 1 do
    begin
      if FEngineParameter.EngineParameterCollect.Items[k].ParameterSource = psFlowMeterKral then
      begin
        if FKRALData.BlockNo <> FEngineParameter.EngineParameterCollect.Items[k].BlockNo then
          Continue;

        i := FEngineParameter.EngineParameterCollect.Items[k].AbsoluteIndex;

        if FEngineParameter.EngineParameterCollect.Items[k].Alarm then //Analog data
        begin
          if FKRALData.ModBusMode = 3 then
          begin
            Le := FKRALData.InpDataBuf_double[i];
            FEngineParameter.EngineParameterCollect.Items[k].Value := FormatFloat(FEngineParameter.EngineParameterCollect.Items[k].DisplayFormat,Le);
          end
          else
          begin
//            LValue := ((FKRALData.InpDataBuf[i] shl 16) or FKRALData.InpDataBuf[i+1]);
//            Le := LValue / 10;
//            Le := FKRALData.InpDataBuf[i];
            FEngineParameter.EngineParameterCollect.Items[k].Value := IntToStr(FKRALData.InpDataBuf[i]);//FormatFloat(FEngineParameter.EngineParameterCollect.Items[i].DisplayFormat,Le);
          end;

//          LRadix := FEngineParameter.EngineParameterCollect.Items[k].RadixPosition;

//          FEngineParameter.EngineParameterCollect.Items[k].Value := FloatToStrF(Le, ffFixed, 12, LRadix);//,'%.2f');
          LDataOk := True;
        end;

      end;
    end;//for

    //수신된 데이타를 화면에 뿌려줌
    Value2Screen_KRAL;
  end;

  FEngineParameter.EngineParameterCollect.PowerOn := LDataOk;

  if LDataOK then
    if Assigned(FWatchValue2Screen_2) then
      FWatchValue2Screen_2();
end;

procedure TFrameIPCMonitor.OverRide_LBX(AData: TEventData_LBX);
var
  i, LRadix: integer;
  LDouble: double;
  LDataOk: Boolean;
begin
  LDataOk := False;

  for i := 0 to FEngineParameter.EngineParameterCollect.Count - 1 do
  begin
    if FEngineParameter.EngineParameterCollect.Items[i].ParameterSource = psLBX then
    begin
//      LRadix := FEngineParameter.EngineParameterCollect.Items[i].RadixPosition;

      if FEngineParameter.EngineParameterCollect.Items[i].TagName = UpperCase('ENGRPM') then
        FEngineParameter.EngineParameterCollect.Items[i].Value := IntToStr(FLBXData.ENGRPM)
      else if FEngineParameter.EngineParameterCollect.Items[i].TagName = UpperCase('HTTEMP') then
        FEngineParameter.EngineParameterCollect.Items[i].Value := IntToStr(FLBXData.HTTEMP)
      else if FEngineParameter.EngineParameterCollect.Items[i].TagName = UpperCase('LOTEMP') then
        FEngineParameter.EngineParameterCollect.Items[i].Value := IntToStr(FLBXData.LOTEMP)
      else if FEngineParameter.EngineParameterCollect.Items[i].TagName = UpperCase('TCRPMA') then
        FEngineParameter.EngineParameterCollect.Items[i].Value := IntToStr(FLBXData.TCRPMA)
      else if FEngineParameter.EngineParameterCollect.Items[i].TagName = UpperCase('TCRPMB') then
        FEngineParameter.EngineParameterCollect.Items[i].Value := IntToStr(FLBXData.TCRPMB)
      else if FEngineParameter.EngineParameterCollect.Items[i].TagName = UpperCase('TCINLETTEMP') then
        FEngineParameter.EngineParameterCollect.Items[i].Value := IntToStr(FLBXData.TCINLETTEMP);

      WatchValue2Screen_Analog('', '',i);
      LDataOk := True;
    end;
  end;//for

  FEngineParameter.EngineParameterCollect.PowerOn := LDataOk;

  if LDataOK then
    if Assigned(FWatchValue2Screen_2) then
      FWatchValue2Screen_2();
  //상속 받은 자손에서 구현할 것
  {if LDataOk then
  begin
    Timer1.Enabled := True;
    FPJHTimerPool.AddOneShot(OnTrigger4AvgSave,2000);
    DataSaveByEvent;
  end;
  }
end;

procedure TFrameIPCMonitor.OverRide_MEXA7000(AData: TEventData_MEXA7000_2);
var
  i, LRadix: integer;
  LDataOk: Boolean;
begin
  LDataOk := False;

  for i := 0 to FEngineParameter.EngineParameterCollect.Count - 1 do
  begin
    if FEngineParameter.EngineParameterCollect.Items[i].ParameterSource = psMEXA7000 then
    begin
//      LRadix := FEngineParameter.EngineParameterCollect.Items[i].RadixPosition;

      if UpperCase(FEngineParameter.EngineParameterCollect.Items[i].TagName) = UpperCase('CO2') then
        FEngineParameter.EngineParameterCollect.Items[i].Value := FormatFloat(FEngineParameter.EngineParameterCollect.Items[i].DisplayFormat,FMEXA7000Data.CO2/10000) //FloatToStr(FMEXA7000Data.CO2/10000)
      else if UpperCase(FEngineParameter.EngineParameterCollect.Items[i].TagName) = UpperCase('CO_L') then
        FEngineParameter.EngineParameterCollect.Items[i].Value := FormatFloat(FEngineParameter.EngineParameterCollect.Items[i].DisplayFormat,FMEXA7000Data.CO_L) //FloatToStr(FMEXA7000Data.CO_L)
      else if UpperCase(FEngineParameter.EngineParameterCollect.Items[i].TagName) = UpperCase('O2') then
        FEngineParameter.EngineParameterCollect.Items[i].Value := FormatFloat(FEngineParameter.EngineParameterCollect.Items[i].DisplayFormat,FMEXA7000Data.O2/10000) //FloatToStr(FMEXA7000Data.O2/10000)
      else if UpperCase(FEngineParameter.EngineParameterCollect.Items[i].TagName) = UpperCase('NOx') then
        FEngineParameter.EngineParameterCollect.Items[i].Value := FormatFloat(FEngineParameter.EngineParameterCollect.Items[i].DisplayFormat,FMEXA7000Data.NOx) //FloatToStr(FMEXA7000Data.NOx)
      else if UpperCase(FEngineParameter.EngineParameterCollect.Items[i].TagName) = UpperCase('THC') then
        FEngineParameter.EngineParameterCollect.Items[i].Value := FormatFloat(FEngineParameter.EngineParameterCollect.Items[i].DisplayFormat,FMEXA7000Data.THC) //FloatToStr(FMEXA7000Data.THC)
      else if UpperCase(FEngineParameter.EngineParameterCollect.Items[i].TagName) = UpperCase('CH4') then
        FEngineParameter.EngineParameterCollect.Items[i].Value := FormatFloat(FEngineParameter.EngineParameterCollect.Items[i].DisplayFormat,FMEXA7000Data.CH4) //FloatToStr(FMEXA7000Data.CH4)
      else if UpperCase(FEngineParameter.EngineParameterCollect.Items[i].TagName) = UpperCase('non_CH4') then
        FEngineParameter.EngineParameterCollect.Items[i].Value := FormatFloat(FEngineParameter.EngineParameterCollect.Items[i].DisplayFormat,FMEXA7000Data.non_CH4) //FloatToStr(FMEXA7000Data.non_CH4)
      else if UpperCase(FEngineParameter.EngineParameterCollect.Items[i].TagName) = UpperCase('CollectedValue') then
        FEngineParameter.EngineParameterCollect.Items[i].Value := FormatFloat(FEngineParameter.EngineParameterCollect.Items[i].DisplayFormat,FMEXA7000Data.CollectedValue); //FloatToStr(FMEXA7000Data.CollectedValue);

      WatchValue2Screen_Analog('', '',i);
      LDataOk := True;
    end;
  end;

  FEngineParameter.EngineParameterCollect.PowerOn := LDataOk;

  if LDataOK then
    if Assigned(FWatchValue2Screen_2) then
      FWatchValue2Screen_2();
  //상속 받은 자손에서 구현할 것
  {if LDataOk then
  begin
    Timer1.Enabled := True;
    FPJHTimerPool.AddOneShot(OnTrigger4AvgSave,2000);
    DataSaveByEvent;
  end;
  }
end;

procedure TFrameIPCMonitor.OverRide_MT210;
var
  i, LRadix: integer;
  LDataOk: Boolean;
begin
  LDataOk := False;

  for i := 0 to FEngineParameter.EngineParameterCollect.Count - 1 do
  begin
    //단위: mmH2O
    if FEngineParameter.EngineParameterCollect.Items[i].ParameterSource = psMT210 then
    begin
//      LRadix := FEngineParameter.EngineParameterCollect.Items[i].RadixPosition;

      FEngineParameter.EngineParameterCollect.Items[i].Value := FormatFloat(FEngineParameter.EngineParameterCollect.Items[i].DisplayFormat,FMT210Data.FData); //FloatToStr(FMT210Data.FData);
//      FEngineParameter.EngineParameterCollect.Items[i].Value := FloatToStrF(FMT210Data.FData); //FloatToStr(FMT210Data.FData);
      WatchValue2Screen_Analog('', '',i);
      LDataOk := True;
      break;
    end;
  end;//for

  FEngineParameter.EngineParameterCollect.PowerOn := LDataOk;

  if LDataOK then
    if Assigned(FWatchValue2Screen_2) then
      FWatchValue2Screen_2();
  //상속 받은 자손에서 구현할 것
  {if LDataOk then
  begin
    Timer1.Enabled := True;
    FPJHTimerPool.AddOneShot(OnTrigger4AvgSave,2000);
  end;
  }
end;

procedure TFrameIPCMonitor.OverRide_PLCMODBUS(
  AData: TEventData_Modbus_Standard);
var
  i,j,k,LFC,LCount: integer;
  Le: double;
  LRadix: integer;
  LDataOk: boolean;
  LTagName, LEngine: string;
  LEngineParameterItem: TEngineParameterItem;
begin
  LDataOk := False;
  LFC := AData.ModBusFunctionCode;
  LCount := FEngineParameter.EngineParameterCollect.Count;

  if (LFC = 1) or (LFC = 2) or (LFC = 3) or (LFC = 4) then
  begin
    for k := 0 to LCount - 1 do
    begin
      LEngineParameterItem := FEngineParameter.EngineParameterCollect.Items[k];
      LEngine := LEngineParameterItem.ProjNo + '_' + LEngineParameterItem.EngNo;

      if (UpperCase(LEngine) = UpperCase(AData.EngineName)) and
        (LEngineParameterItem.ParameterSource = psPLC_Modbus) then
      begin
        if AData.BlockNo <> LEngineParameterItem.BlockNo then
          Continue;

        //AbsoluteIndex에 Modbus Map에서 각 Request별 위치 정보(공유메모리상의 Index)
        i := LEngineParameterItem.AbsoluteIndex;

        if LEngineParameterItem.Alarm then //Analog data
        begin
          if AData.ModBusMode = 3 then //simulate from csv
          begin
            Le := AData.InpDataBuf_double[i];
          end
          else
          begin
            case LEngineParameterItem.MinMaxType of
              mmtInteger: begin
                if FEngineParameter.EngineParameterCollect.Items[k].MaxValue > 0 then
                  Le := AData.InpDataBuf[i]/LEngineParameterItem.MaxValue
                else
                  Le := AData.InpDataBuf[i];
              end;
              mmtReal: begin
                if LEngineParameterItem.MaxValue_Real > 0.0 then
                  Le := AData.InpDataBuf[i]/LEngineParameterItem.MaxValue_Real
                else
                  Le := AData.InpDataBuf[i];
              end;
            end;//case
          end;

//          LRadix := FEngineParameter.EngineParameterCollect.Items[k].RadixPosition;

          LEngineParameterItem.Value := FormatFloat(LEngineParameterItem.DisplayFormat, Le);
//          FEngineParameter.EngineParameterCollect.Items[k].Value := FloatToStrF(Le, ffFixed, 12, LRadix);//,'%.2f');
        end
        else //Digital data
        begin
          if AData.ModBusMode = 3 then //simulate from csv
          begin
            if AData.InpDataBuf_double[i] = 0.0 then
              LEngineParameterItem.Value := '0'
            else
              LEngineParameterItem.Value := 'FFFF';
          end
          else
          begin
            i := LEngineParameterItem.AbsoluteIndex;
            j := LEngineParameterItem.RadixPosition;
            //0이 아니면 True임
            LEngineParameterItem.Value := IntToStr(GetBitVal(AData.InpDataBuf[i], j));
          end;
        end;

        //수신된 데이타를 화면에 뿌려줌
        Value2Screen_ECS_Woodward(k, AData.ModBusMode);
        LDataOk := True;
      end;
    end;//for
  end;

  FEngineParameter.EngineParameterCollect.PowerOn := LDataOk;

  if LDataOK then
    if Assigned(FWatchValue2Screen_2) then
      FWatchValue2Screen_2();
end;

procedure TFrameIPCMonitor.OverRide_PLC_S7(AData: TEventData_PLC_S7);
var
  i,k,LRadix,LDividor: integer;
  Le: double;
  LDataOk: Boolean;
begin
  LDataOk := False;

  for k := 0 to FEngineParameter.EngineParameterCollect.Count - 1 do
  begin
    if FEngineParameter.EngineParameterCollect.Items[k].ParameterSource = psPLC_S7 then
    begin
      if FPLCData_S7.BlockNo <> FEngineParameter.EngineParameterCollect.Items[k].BlockNo then
        Continue;

      //배열 Index는 0부터 시작하는데 FCode는 1부터 시작하므로 1 빼줌
      i := StrToInt(FEngineParameter.EngineParameterCollect.Items[k].FCode) - 1;

      if FEngineParameter.EngineParameterCollect.Items[k].Contact <> 0 then
        LDividor := FEngineParameter.EngineParameterCollect.Items[k].Contact
      else
        LDividor := 1;

      if FEngineParameter.EngineParameterCollect.Items[k].Alarm then //Analog data
      begin
        case TS7DataType(FEngineParameter.EngineParameterCollect.Items[k].AbsoluteIndex) of
          S7DTByte : Le := FPLCData_S7.DataByte[i]/LDividor;
          S7DTWord : Le := FPLCData_S7.DataWord[i]/LDividor;
          S7DTInt  : Le := FPLCData_S7.DataInt[i]/LDividor;
          S7DTDWord: Le := FPLCData_S7.DataDWord[i]/LDividor;
          S7DTDInt : Le := FPLCData_S7.DataDInt[i]/LDividor;
          S7DTReal : Le := FPLCData_S7.DataFloat[i]/LDividor;
        end;//case
      end;

//      LRadix := FEngineParameter.EngineParameterCollect.Items[k].RadixPosition;
      FEngineParameter.EngineParameterCollect.Items[k].Value := FormatFloat(FEngineParameter.EngineParameterCollect.Items[k].DisplayFormat, Le);//,'%.2f');

      WatchValue2Screen_Analog('', '',k);
      LDataOk := True;
    end;//if
  end;//for

  FEngineParameter.EngineParameterCollect.PowerOn := LDataOk;

  if LDataOK then
    if Assigned(FWatchValue2Screen_2) then
      FWatchValue2Screen_2();
end;

procedure TFrameIPCMonitor.OverRide_PMS(AData: TEventData_PMS);
var
  i, LRadix: integer;
  LDataOk: Boolean;
begin
  LDataOk := False;

  for i := 0 to FEngineParameter.EngineParameterCollect.Count - 1 do
  begin
    if FEngineParameter.EngineParameterCollect.Items[i].ParameterSource = psPMSOPC then
    begin
//      LRadix := FEngineParameter.EngineParameterCollect.Items[i].RadixPosition;

      FEngineParameter.EngineParameterCollect.Items[i].Value := FPMSData.InpDataBuf[i];
      WatchValue2Screen_Analog('', '',i);
      LDataOk := True;
    end;
  end;

  FEngineParameter.EngineParameterCollect.PowerOn := LDataOk;

  if LDataOK then
    if Assigned(FWatchValue2Screen_2) then
      FWatchValue2Screen_2();
end;

procedure TFrameIPCMonitor.OverRide_WT1600(AData: TEventData_WT1600);
var
  i, LRadix, LMaxVal, LCount: integer;
  LDouble: double;
  LDataOk: boolean;
  LTagName, LEngine: string;
  LEngineParameterItem: TEngineParameterItem;
begin
  LDataOk := False;
  LCount := FEngineParameter.EngineParameterCollect.Count;

  for i := 0 to LCount - 1 do
  begin
    LEngineParameterItem := FEngineParameter.EngineParameterCollect.Items[i];
    LTagName := LEngineParameterItem.TagName;
//    LEngine := LEngineParameterItem.ProjNo + '_' + LEngineParameterItem.EngNo + '_';
    LEngine := AData.UniqueEngineName + '_';

    if LEngineParameterItem.ParameterSource = psWT1600 then
    begin
//      LRadix := FEngineParameter.EngineParameterCollect.Items[i].RadixPosition;
      LMaxVal := LEngineParameterItem.MaxValue;

      if LMaxVal = 0 then
        LMaxVal := 1;

      LDouble := -9999;
      if UpperCase(LTagName) = UpperCase(LEngine + 'PSIGMA') then
      begin
        LDouble := StrToFloatDef(AData.PSIGMA,0.0);
//        FEngineParameter.EngineParameterCollect.Items[i].Value := FloatToStrF(LDouble/LMaxVal, ffFixed, 12, LRadix) //Format('%.2f', [LDouble/1000]);
      end
      else if UpperCase(LTagName) = UpperCase(LEngine + 'SSIGMA') then
      begin
        LDouble := StrToFloatDef(AData.SSIGMA,0.0);
//        FEngineParameter.EngineParameterCollect.Items[i].Value := FloatToStrF(LDouble/LMaxVal, ffFixed, 12, LRadix) //Format('%.2f', [LDouble/1000]);
      end
      else if UpperCase(LTagName) = UpperCase(LEngine + 'QSIGMA') then
      begin
        LDouble := StrToFloatDef(AData.QSIGMA,0.0);
//        FEngineParameter.EngineParameterCollect.Items[i].Value := FloatToStrF(LDouble/LMaxVal, ffFixed, 12, LRadix) //Format('%.2f', [LDouble/1000]);
      end
      else if UpperCase(LTagName) = UpperCase(LEngine + 'URMS1') then
      begin
        LDouble := StrToFloatDef(AData.URMS1,0.0);
//        FEngineParameter.EngineParameterCollect.Items[i].Value := FloatToStrF(LDouble/LMaxVal, ffFixed, 12, LRadix);
      end
      else if UpperCase(LTagName) = UpperCase(LEngine + 'URMS2') then
      begin
        LDouble := StrToFloatDef(AData.URMS2,0.0);
//        FEngineParameter.EngineParameterCollect.Items[i].Value := FloatToStrF(LDouble/LMaxVal, ffFixed, 12, LRadix);
      end
      else if UpperCase(LTagName) = UpperCase(LEngine + 'URMS3') then
      begin
        LDouble := StrToFloatDef(AData.URMS3,0.0);
//        FEngineParameter.EngineParameterCollect.Items[i].Value := FloatToStrF(LDouble/LMaxVal, ffFixed, 12, LRadix);
      end
      else if UpperCase(LTagName) = UpperCase(LEngine + 'IRMS1') then
      begin
        LDouble := StrToFloatDef(AData.IRMS1,0.0);
//        FEngineParameter.EngineParameterCollect.Items[i].Value := FloatToStrF(LDouble/LMaxVal, ffFixed, 12, LRadix);
      end
      else if UpperCase(LTagName) = UpperCase(LEngine + 'IRMS2') then
      begin
        LDouble := StrToFloatDef(AData.IRMS2,0.0);
//        FEngineParameter.EngineParameterCollect.Items[i].Value :=FloatToStrF(LDouble/LMaxVal, ffFixed, 12, LRadix);
      end
      else if UpperCase(LTagName) = UpperCase(LEngine + 'IRMS3') then
      begin
        LDouble := StrToFloatDef(AData.IRMS3,0.0);
//        FEngineParameter.EngineParameterCollect.Items[i].Value := FloatToStrF(LDouble/LMaxVal, ffFixed, 12, LRadix);
      end
      else if UpperCase(LTagName) = UpperCase(LEngine + 'URMSAVG') then
      begin
        LDouble := StrToFloatDef(AData.URMSAVG,0.0);
//        FEngineParameter.EngineParameterCollect.Items[i].Value := String(FWT1600Data.URMSAVG);
      end
      else if UpperCase(LTagName) = UpperCase(LEngine + 'IRMSAVG') then
      begin
        LDouble := StrToFloatDef(AData.IRMSAVG,0.0);
//        FEngineParameter.EngineParameterCollect.Items[i].Value := String(FWT1600Data.IRMSAVG);
      end
      else if UpperCase(LTagName) = UpperCase(LEngine + 'RAMDA') then
      begin
        LDouble := StrToFloatDef(AData.RAMDA,0.0);
//        FEngineParameter.EngineParameterCollect.Items[i].Value := String(FWT1600Data.RAMDA);
      end
      else if UpperCase(LTagName) = UpperCase(LEngine + 'F1') then
      begin
        LDouble := StrToFloatDef(AData.F1,0.0);
//        FEngineParameter.EngineParameterCollect.Items[i].Value := String(FWT1600Data.F1);
      end
      else if UpperCase(LTagName) = UpperCase(LEngine + 'FREQUENCY') then
      begin
        LDouble := StrToFloatDef(AData.FREQUENCY,0.0);
//        FEngineParameter.EngineParameterCollect.Items[i].Value := String(FWT1600Data.FREQUENCY);
      end;

      if LDouble <> -9999 then
      begin
        LEngineParameterItem.Value := FormatFloat(LEngineParameterItem.DisplayFormat,LDouble/LMaxVal);
  //      FEngineParameter.EngineParameterCollect.Items[i].Value := FloatToStrF(LDouble/LMaxVal, ffFixed, 12, LRadix);
        WatchValue2Screen_Analog(LTagName,'',i);
      end;

      LDataOk := True;
    end;
  end;//for

  FEngineParameter.EngineParameterCollect.PowerOn := LDataOk;

  if LDataOK then
    if Assigned(FWatchValue2Screen_2) then
      FWatchValue2Screen_2();
end;

procedure TFrameIPCMonitor.PLCMODBUS_OnSignal(
  Data: TEventData_Modbus_Standard);
var
  i,dcount: integer;
  LUniqueEngine: String;
begin
  if not FIsUseIPCSharedMMEvent then
    exit;

  if not FCompleteReadMap_Woodward then
    exit;

  if FDestroying then
    exit;

  dcount := 0;
  LUniqueEngine := Data.EngineName;

  if FEventData_PLCMODBUS_List.ContainsKey(LUniqueEngine) then
  begin
    FLastExecutedState := 'PLCMODBUS_OnSignal';

    with FEventData_PLCMODBUS_List.Items[LUniqueEngine].FEventDataRecord do
    begin
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

        System.Move(Data.InpDataBuf, InpDataBuf, Sizeof(Data.InpDataBuf));
//        for i := 0 to dcount - 1 do
//        begin
//          InpDataBuf[i] := Data.InpDataBuf2[i*2] ;
//          InpDataBuf[i] := InpDataBuf[i] shl 8 + Data.InpDataBuf2[i*2 + 1];
//        end;
//
//        if (Data.NumOfData mod 2) > 0 then
//          InpDataBuf[i] := Data.InpDataBuf2[i*2] ;
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
      PowerOn := True;
      EngineName := LUniqueEngine;

      DisplayMessage2SB(FStatusBar, ModBusAddress + ' 데이타 도착');
      SendMessage(Handle, WM_EVENT_PLCMODBUS, 0, LongInt(@FEventData_PLCMODBUS_List.Items[LUniqueEngine].FEventDataRecord));
    end;
  end
  else
  begin
    DisplayMessage2SB(FStatusBar, LUniqueEngine + ' 엔진이 없습니다');
  end;
  FModBusMapFileName := Data.ModBusMapFileName;

  CommonCommunication(psPLC_Modbus);
end;

procedure TFrameIPCMonitor.PLC_S7_OnSignal(Data: TEventData_PLC_S7);
begin
  if not FIsUseIPCSharedMMEvent then
    exit;

  Case Data.DataType of
    0 : System.Move(Data.DataByte, FPLCData_S7.DataByte, Sizeof(Data.DataByte));
    1 : System.Move(Data.DataWord, FPLCData_S7.DataWord, Sizeof(Data.DataWord));
    2 : System.Move(Data.DataInt, FPLCData_S7.DataInt, Sizeof(Data.DataInt));
    3 : System.Move(Data.DataDWord, FPLCData_S7.DataDWord, Sizeof(Data.DataDWord));
    4 : System.Move(Data.DataDInt, FPLCData_S7.DataDInt, Sizeof(Data.DataDInt));
    5 : System.Move(Data.DataFloat, FPLCData_S7.DataFloat, Sizeof(Data.DataFloat));
  end;

  FPLCData_S7.NumOfData := Data.NumOfData;
  FPLCData_S7.NumOfBit := Data.NumOfBit;
  FPLCData_S7.BlockNo := Data.BlockNo;
  FPLCData_S7.DataType := Data.DataType;
  FPLCData_S7.ModBusMapFileName := Data.ModBusMapFileName;
  FPLCData_S7.PowerOn := True;
  FModBusMapFileName := Data.ModBusMapFileName;

  SendMessage(Handle, WM_EVENT_PLC_S7, 0,0);
  CommonCommunication(psPLC_S7);
end;

procedure TFrameIPCMonitor.PMS_OnSignal(Data: TEventData_PMS);
var
  i: integer;
begin
  if not FIsUseIPCSharedMMEvent then
    exit;

  if FDestroying then
    exit;

  for i := 0 to High(FPMSData.InpDataBuf) - 1 do
    FPMSData.InpDataBuf[i] := Data.InpDataBuf[i];

  FPMSData.PowerOn := True;

  SendMessage(Handle, WM_EVENT_PMS, 0,0);
  CommonCommunication(psPMSOPC);
end;

procedure TFrameIPCMonitor.ProcessDataFromMQ(AJson: string);
var
  LUtf8: RawUTF8;
  LValue: TEventData_Modbus_Standard_DynArr;
  LEventData: TEventData_Modbus_Standard;
begin
  LUtf8 := StringToUTF8(AJson);
  RecordLoadJSON(LValue, pointer(LUtf8), TypeInfo(TEventData_Modbus_Standard_DynArr));
  Copy_DynArrRec_2_EventData_Modbus_Standard(LValue, LEventData);
  PLCMODBUS_OnSignal(LEventData);
end;

//procedure TFrameIPCMonitorAll.ReadMapAddress(AddressMap: DMap; MapFileName: string);
//var
//  sqltext, MapFilePath: string;
//  sqlresult, reccnt, fldcnt: integer;
//  i,j, LLastBlockNo, LLastIndex: integer;
//  filename, fcode: string;
//  shbtn: TShadowButton;
//  janDB: TjanSQL;
//  HiMap: THiMap;
//begin
//  SetCurrentDir(ExtractFilePath(Application.ExeName));
//
//  if fileexists(MapFileName) then
//  begin
//    Filename := ExtractFileName(MapFileName);
//    FileName := Copy(Filename,1, Pos('.',Filename) - 1);
//    MapFilePath := ExtractFilePath(MapFileName);
//    janDB :=TjanSQL.create;
//    try
//      sqltext := 'connect to ''' + MapFilePath + '''';
//
//      sqlresult := janDB.SQLDirect(sqltext);
//      //Connect 성공
//      if sqlresult <> 0 then
//      begin
//        with janDB do
//        begin
//          sqltext := 'select * from ' + FileName + ' group by cnt';
//          sqlresult := SQLDirect(sqltext);
//          //Query 정상
//          if sqlresult <> 0 then
//          begin
//            //데이타 건수가 1개 이상 있으면
//            if sqlresult>0 then
//            begin
//              fldcnt := RecordSets[sqlresult].FieldCount;
//              //Field Count가 0 이면
//              if fldcnt = 0 then exit;
//
//              reccnt := RecordSets[sqlresult].RecordCount;
//              //Record Count가 0 이면
//              if reccnt = 0 then exit;
//
//              j := 0;
//              LLastIndex := 0;
//
//              for i := 0 to reccnt - 1 do
//              begin
//                HiMap := THiMap.Create;
//                with HiMap, RecordSets[SqlResult].Records[i] do
//                begin
//                  FName := Fields[0].Value;
//                  FDescription := Fields[1].Value;
//                  FSid := StrToInt(Fields[2].Value);
//                  FAddress := Fields[3].Value;
//                  //kumo ECS를 Value2Screen_ECS 함수에서 처리하기 위함
//                  FUnit := Fields[5].Value;
//                  FBlockNo := StrToInt(Fields[4].Value);
//
//                  if i = 0 then
//                    LLastBlockNo := FBlockNo;
//
//                  if LLastBlockNo <> FBlockNo then
//                  begin
//                    LLastIndex := 0;
//                    LLastBlockNo := FBlockNo;
//                  end;
//
//                  FListIndex := LLastIndex;
//                  inc(LLastIndex);
//
//                  if UpperCase(FDescription) <> 'DUMMY' then
//                  begin
//                    FListIndexNoDummy := j;
//                    Inc(j);
//                  end
//                  else
//                    FListIndexNoDummy := -1;
//
//                  if Fields[5].Value = 'FALSE' then
//                  begin
//                    FAlarm := False;
//                    fcode := '1';
//                  end
//                  else if Fields[5].Value = 'TRUE4' then
//                  begin
//                    FAlarm := True;
//                    fcode := '4';
//                  end
//                  else if Fields[5].Value = 'TRUE' then
//                  begin
//                    FAlarm := True;
//                    fcode := '3';
//                  end
//                  else if Fields[5].Value = 'FALSE3' then
//                  begin
//                    FAlarm := False;
//                    fcode := '3';
//                  end;
//
//                  FMaxval := StrToFloat(Fields[6].Value);
//                  FContact := StrToInt(Fields[7].Value);
//                  FUnit := '';
//
//                  shbtn := nil;
//                  shbtn := TShadowButton(FindComponent(FName));
//                  if Assigned(shbtn) then
//                    shbtn.Hint := FDescription;
//                end;//with
//
//                AddressMap.PutPair([fcode + HiMap.FAddress,HiMap]);
//              end;//for
//            end;
//
//          end
//          else
//            DisplayMessage2SB(FStatusBar, janDB.Error);
//        end;//with
//      end
//      else
//        Application.MessageBox('Connect 실패',
//            PChar('폴더 ' + FFilePath + ' 를 만든 후 다시 하시오'),MB_ICONSTOP+MB_OK);
//    finally
//      janDB.Free;
//    end;
//  end
//  else
//  begin
//    sqltext := MapFileName + '파일을 만든 후에 다시 하시오';
//    Application.MessageBox('Data file does not exist!', PChar(sqltext) ,MB_ICONSTOP+MB_OK);
//  end;
//end;

procedure TFrameIPCMonitor.ReadMapAddressFromParamFile(AFilename: string;
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

procedure TFrameIPCMonitor.SetIsUseIPCSharedMMEvent(AValue: Boolean);
begin
  FIsUseIPCSharedMMEvent := AValue;
end;

procedure TFrameIPCMonitor.SendFormCopyData(ToHandle: integer; AForm: TForm);
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

procedure TFrameIPCMonitor.SetEventData_PLCMODBUS_List(
  AUniqueEngineName: string);
var
  LRec: PEventData_Modbus_Standard;
begin
  if not FEventData_PLCMODBUS_List.ContainsKey(AUniqueEngineName) then
  begin
//    GetMem(LRec, SizeOf(PEventData_Modbus_Standard));
//    FEventData_PLCMODBUS_List.Add(AUniqueEngineName, LRec);
  end;
end;

procedure TFrameIPCMonitor.SetEventData_WT1600_List(AUniqueEngineName: string);
var
  LRec: PEventData_WT1600;
begin
  if not FEventData_WT1600_List.ContainsKey(AUniqueEngineName) then
  begin
//    GetMem(LRec, SizeOf(TEventData_WT1600));
//    FEventData_WT1600_List.Add(AUniqueEngineName, LRec);
  end;
end;

procedure TFrameIPCMonitor.SetModbusMapFileName(AFileName: string;
  APSrc: TParameterSource);
begin
  if Assigned(FIPCMonitor_ECS_kumo) or Assigned(FIPCMonitor_ECS_AVAT) then
  begin
    if AFileName = '' then
    begin
      if APSrc = psECS_kumo then
        FModbusMapFileName := 'Default_ModbusMap_kumo.txt'
      else
      if APSrc = psECS_AVAT then
        FModbusMapFileName := '.\avat_modbustcp_map_analog.txt';//'Default_ModbusMap_Avat.txt';
    end
    else
      FModbusMapFileName := AFileName;

    FAddressMap.clear;
//    ReadMapAddress(FAddressMap,FModbusMapFileName);
  end
  else if APSrc = psECS_woodward then
  begin
    FEngineParameter.LoadFromJSONFile(AFileName);
    exit;
  end;
end;

procedure TFrameIPCMonitor.SetValue2ScreenEvent(AAnalogFunc: TWatchValue2Screen_AnalogEvent;
      ADigitalFunc: TWatchValue2Screen_DigitalEvent);
begin
  if Assigned(AAnalogFunc) then
    FWatchValue2Screen_AnalogEvent := AAnalogFunc;

  if Assigned(ADigitalFunc) then
    FWatchValue2Screen_AnalogEvent := ADigitalFunc;
end;

procedure TFrameIPCMonitor.SetValue2ScreenEvent_2(
  AFunc: TWatchValue2Screen_2);
begin
  if Assigned(AFunc) then
    FWatchValue2Screen_2 := AFunc;
end;

procedure TFrameIPCMonitor.UpdateTrace_DYNAMO(var Msg: TEventData_DYNAMO);
begin
  if FIsSetZeroWhenDisconnect then
    FPJHTimerPool.AddOneShot(OnSetZeroDYNAMO, SET_ZERO_DYNAMO);

  OverRide_DYNAMO(FDYNAMOData);
end;

procedure TFrameIPCMonitor.UpdateTrace_ECS_AVAT(var Msg: TEventData_ECS_AVAT);
begin
  if FIsSetZeroWhenDisconnect then
    FPJHTimerPool.AddOneShot(OnSetZeroECS_AVAT, SET_ZERO_ECS_AVAT);

  OverRide_ECS_AVAT(FECSData_AVAT);
end;

procedure TFrameIPCMonitor.UpdateTrace_ECS_ComAP(
  var Msg: TEventData_Modbus_Standard);
begin
  if FIsSetZeroWhenDisconnect then
    FPJHTimerPool.AddOneShot(OnSetZeroECS_ComAP, SET_ZERO_ECS_ComAP);

  OverRide_ECS_ComAP(FECSData_ComAP);
end;

procedure TFrameIPCMonitor.UpdateTrace_ECS_ComAP2(
  var Msg: TEventData_Modbus_Standard);
begin
  if FIsSetZeroWhenDisconnect then
    FPJHTimerPool.AddOneShot(OnSetZeroECS_ComAP2, SET_ZERO_ECS_ComAP2);

  OverRide_ECS_ComAP2(FECSData_ComAP2);
end;

procedure TFrameIPCMonitor.UpdateTrace_ECS_kumo(var Msg: TEventData_ECS_kumo);
begin
  if FIsSetZeroWhenDisconnect then
    FPJHTimerPool.AddOneShot(OnSetZeroECS_kumo, SET_ZERO_ECS_kumo);

  OverRide_ECS_kumo(FECSData_kumo);
end;

procedure TFrameIPCMonitor.UpdateTrace_ECS_Woodward(
  var Msg: TEventData_ECS_Woodward);
begin
  if FIsSetZeroWhenDisconnect then
    FPJHTimerPool.AddOneShot(OnSetZeroECS_Woodward, SET_ZERO_ECS_Woodward);

  OverRide_ECS_Woodward(FECSData_Woodward);
end;

procedure TFrameIPCMonitor.UpdateTrace_EngineParam(
  var Msg: TEventData_EngineParam);
begin
  if FIsSetZeroWhenDisconnect then
    FPJHTimerPool.AddOneShot(OnSetZeroEngineParam, SET_ZERO_EngineParam);

  OverRide_EngineParam(FEngineParamData);
end;

procedure TFrameIPCMonitor.UpdateTrace_FlowMeter(var Msg: TEventData_FlowMeter);
begin
  if FIsSetZeroWhenDisconnect then
    FPJHTimerPool.AddOneShot(OnSetZeroFlowMeter, SET_ZERO_FlowMeter);

  OverRide_FlowMeter(FFlowMeterData);
end;

procedure TFrameIPCMonitor.UpdateTrace_GasCalc(var Msg: TEventData_GasCalc);
begin
  if FIsSetZeroWhenDisconnect then
    FPJHTimerPool.AddOneShot(OnSetZeroGasCalc, SET_ZERO_GasCalc);

  OverRide_GasCalc(FGasCalcData);
end;

procedure TFrameIPCMonitor.UpdateTrace_HIC(var Msg: TEventData_HIC);
begin
  if FIsSetZeroWhenDisconnect then
    FPJHTimerPool.AddOneShot(OnSetZeroHIC, SET_ZERO_HIC);

  OverRide_HIC(FHICData);
end;

procedure TFrameIPCMonitor.UpdateTrace_KRAL(var Msg: TEventData_Modbus_Standard);
begin
  if FIsSetZeroWhenDisconnect then
    FPJHTimerPool.AddOneShot(OnSetZeroKRAL, SET_ZERO_KRAL);

  OverRide_KRAL(FKRALData);
end;

procedure TFrameIPCMonitor.UpdateTrace_LBX(var Msg: TEventData_LBX);
begin
  if FIsSetZeroWhenDisconnect then
    FPJHTimerPool.AddOneShot(OnSetZeroLBX, SET_ZERO_LBX);

  OverRide_LBX(FLBXData);
end;

procedure TFrameIPCMonitor.UpdateTrace_MEXA7000(var Msg: TEventData_MEXA7000);
begin
  if FIsSetZeroWhenDisconnect then
    FPJHTimerPool.AddOneShot(OnSetZeroMEXA7000, SET_ZERO_MEXA7000);

  OverRide_MEXA7000(FMEXA7000Data);
end;

procedure TFrameIPCMonitor.UpdateTrace_MT210(var Msg: TEventData_MT210);
begin
  if FIsSetZeroWhenDisconnect then
    FPJHTimerPool.AddOneShot(OnSetZeroMT210, SET_ZERO_MT210);

  OverRide_MT210(FMT210Data);
end;

procedure TFrameIPCMonitor.UpdateTrace_PLCMODBUS(var Msg: TMessage);
var
  LEventData: PEventData_Modbus_Standard;
begin
  if FIsSetZeroWhenDisconnect then
    FPJHTimerPool.AddOneShot(OnSetZeroPLCMODBUS, SET_ZERO_PLCMODBUS);

//  OverRide_PLCMODBUS(FPLCModbusData);
  LEventData := PEventData_Modbus_Standard(Msg.LParam);
  OverRide_PLCMODBUS(LEventData^);
end;

procedure TFrameIPCMonitor.UpdateTrace_PLC_S7(var Msg: TEventData_PLC_S7);
begin
  if FIsSetZeroWhenDisconnect then
    FPJHTimerPool.AddOneShot(OnSetZeroPLC_S7, SET_ZERO_PLC_S7);

  OverRide_PLC_S7(FPLCData_S7);
end;

procedure TFrameIPCMonitor.UpdateTrace_PMS(var Msg: TEventData_PMS);
begin
  if FIsSetZeroWhenDisconnect then
    FPJHTimerPool.AddOneShot(OnSetZeroPMS, SET_ZERO_PMS);

  OverRide_PMS(FPMSData);
end;

procedure TFrameIPCMonitor.UpdateTrace_WT1600(var Msg: TMessage);
var
  LEventData_WT1600: PEventData_WT1600;
begin
  if FIsSetZeroWhenDisconnect then
    FPJHTimerPool.AddOneShot(OnSetZeroWT1600, SET_ZERO_WT1600);

//  OverRide_WT1600(FWT1600Data);
  LEventData_WT1600 := PEventData_WT1600(Msg.LParam);
  OverRide_WT1600(LEventData_WT1600^);
end;

procedure TFrameIPCMonitor.Value2Screen_ECS_AVAT(AHiMap: THiMap; AEPIndex,
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
procedure TFrameIPCMonitor.Value2Screen_ECS_kumo(AHiMap: THiMap; AEPIndex,
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

procedure TFrameIPCMonitor.Value2Screen_ECS_kumo2(AEPIndex,
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

procedure TFrameIPCMonitor.Value2Screen_ECS_Woodward(AEPIndex: integer;
  AModbusMode: integer);
var
  Le: Single;
  LStr: string;
begin
  if FEngineParameter.EngineParameterCollect.Items[AEPIndex].Alarm then //Analog data
  begin
    LStr := FEngineParameter.EngineParameterCollect.Items[AEPIndex].TagName;
    WatchValue2Screen_Analog(LStr, FEngineParameter.EngineParameterCollect.Items[AEPIndex].Value, AEPIndex);
  end
  else //Digital data
  begin
    LStr := FEngineParameter.EngineParameterCollect.Items[AEPIndex].TagName;
    WatchValue2Screen_Digital(LStr, '', AEPIndex);
  end;
end;

procedure TFrameIPCMonitor.Value2Screen_KRAL;
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

procedure TFrameIPCMonitor.WatchValue2Grid(AValue: string; AEPIndex: integer;
  AIsFloat: Boolean);
var
  i: integer;
begin
  if UpperCase(FPageControl.ActivePage.Name) = ITEMS_SHEET_NAME then
  begin
    if AValue= '' then
      AValue := FEngineParameter.EngineParameterCollect.Items[AEPIndex].Value;

    if Assigned(FEngineParameter.EngineParameterCollect.Items[AEPIndex].NextGridRow) then
    begin
      i := FNextGrid.GetRowIndex(FEngineParameter.EngineParameterCollect.Items[AEPIndex].NextGridRow);

      if (i >= 0) and (i < FNextGrid.RowCount) then
      begin
        FNextGrid.CellsByName['Value', i] := AValue;//FEngineParameter.EngineParameterCollect.Items[AEPIndex].Value;

        if FEngineParameter.EngineParameterCollect.Items[AEPIndex].DisplayUnit then
          if FEngineParameter.EngineParameterCollect.Items[AEPIndex].FFUnit <> '' then
            FNextGrid.CellsByName['Value', i] := FNextGrid.CellsByName['Value', i] + ' ' + FEngineParameter.EngineParameterCollect.Items[AEPIndex].FFUnit;
      end;
    end;
  end;
end;

procedure TFrameIPCMonitor.WatchValue2Screen_Analog(Name, AValue: string;
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
      if not Assigned(FPageControl) then
        exit;

      WatchValue2Grid(AValue, AEPIndex);
//      FNextGrid.CellsByName['Value', AEPIndex] := FEngineParameter.EngineParameterCollect.Items[AEPIndex].Value;
//
//      if FEngineParameter.EngineParameterCollect.Items[AEPIndex].DisplayUnit then
//        if FEngineParameter.EngineParameterCollect.Items[AEPIndex].FFUnit <> '' then
//          FNextGrid.CellsByName['Value', AEPIndex] := FNextGrid.CellsByName['Value', AEPIndex] + ' ' + FEngineParameter.EngineParameterCollect.Items[AEPIndex].FFUnit;
    end;
  finally
    FEnterWatchValue2Screen := False;
  end;
end;

procedure TFrameIPCMonitor.WatchValue2Screen_Digital(Name, AValue: string;
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

//      case FPageControl.ActivePageIndex of
      if UpperCase(FPageControl.ActivePage.Name) = ITEMS_SHEET_NAME then
      begin
//        0: begin //Items
        if not Assigned(FNextGrid) then
          exit;

        if FEngineParameter.EngineParameterCollect.Items[AEPIndex].Value = '0' then
          FNextGrid.CellsByName['Value', AEPIndex] := 'False'
        else
          FNextGrid.CellsByName['Value', AEPIndex] := 'True';//FEngineParameter.EngineParameterCollect.Items[AEPIndex].Value;
//        end;
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

procedure TFrameIPCMonitor.WT1600_OnSignal(Data: TEventData_WT1600);
var
  LUniqueEngine: String;
//  LEventData_WT1600: PEventData_WT1600;
begin
  if not FIsUseIPCSharedMMEvent then
    exit;

  if FDestroying then
    exit;

  LUniqueEngine := Data.UniqueEngineName;

  if FEventData_WT1600_List.ContainsKey(LUniqueEngine) then
  begin
    with FEventData_WT1600_List.Items[LUniqueEngine].FEventDataRecord do
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
      PowerMeterOn := True;
      UniqueEngineName := LUniqueEngine;
    end;

    SendMessage(Handle, WM_EVENT_WT1600, 0, LongInt(@FEventData_WT1600_List.Items[LUniqueEngine].FEventDataRecord));
  end;

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
//  FWT1600Data.PowerMeterOn := True;

  CommonCommunication(psWT1600);
end;

end.

