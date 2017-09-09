unit UnitComponentIPCMonitorAll;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms, ComCtrls,
  Dialogs, NxCustomGridControl, NxCustomGrid, NxGrid, JvStatusBar,
  UnitFrameIPCConst, janSQL, ModbusComStruct, CommonUtil,
  DeCAL, IPCThrd_LBX, IPCThrdMonitor_LBX, IPCThrd_Kral, IPCThrdMonitor_Kral,
  IPCThrd_WT1600, IPCThrdMonitor_WT1600, IPCThrd_ECS_kumo, IPCThrdMonitor_ECS_kumo,
  IPCThrd_MEXA7000, IPCThrdMonitor_MEXA7000, IPCThrd_MT210, IPCThrdMonitor_MT210,
  IPCThrd_FlowMeter, IPCThrdMonitor_FlowMeter, IPCThrd_DYNAMO, IPCThrdMonitor_DYNAMO,
  IPCThrd_ECS_AVAT, IPCThrdMonitor_ECS_AVAT, IPCThrd_GasCalc, IPCThrdMonitor_GasCalc,
  IPCThrdMonitor_ECS_Woodward, IPCThrd_ECS_Woodward, IPCThrd_EngineParam,
  IPCThrd_PLC_S7, IPCThrdMonitor_PLC_S7, IPCThrdMonitor_EngineParam,
  HiMECSConst, ConfigOptionClass, EngineParameterClass,
  TimerPool, AdvOfficePager;

type
  TWatchValue2Screen_AnalogEvent =
    procedure(Name: string; AValue: string; AEPIndex: integer) of object;
  TWatchValue2Screen_DigitalEvent =
    procedure(Name: string; AValue: string; AEPIndex: integer) of object;

  TIPCMonitorAll = class(TComponent)  //for component
  private
    FHWnd: HWND;   //for component

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
    FKRALData: TEventData_KRAL;
    FPLCData_S7: TEventData_PLC_S7;
    FEngineParamData: TEventData_EngineParam;

    FIPCMonitor_WT1600: TIPCMonitor_WT1600;//WT1600
    FIPCMonitor_MEXA7000: TIPCMonitor_MEXA7000;//MEXA7000
    FIPCMonitor_MT210: TIPCMonitor_MT210;//MT210
    FIPCMonitor_ECS_kumo: TIPCMonitor_ECS_kumo;//kumo ECS
    FIPCMonitor_ECS_AVAT: TIPCMonitor_ECS_AVAT;//AVAT ECS
    FIPCMonitor_ECS_Woodward: TIPCMonitor_ECS_Woodward; //Woodward(AtlasII) ECS
    FIPCMonitor_LBX: TIPCMonitor_LBX;//LBX
    FIPCMonitor_FlowMeter: TIPCMonitor_FlowMeter;//FlowMeter
    FIPCMonitor_Dynamo: TIPCMonitor_Dynamo;//DynamoMeter
    FIPCMonitor_GasCalc: TIPCMonitor_GasCalc;//Gas Total
    FIPCMonitor_KRAL: TIPCMonitor_KRAL;//FlowMeter(KRAL)
    FIPCMonitor_PLC_S7: TIPCMonitor_PLC_S7;//Siemens PLC S7-300
    FIPCMonitor_EngineParam: TIPCMonitor_EngineParam;//Engine Parameter File

    procedure UpdateTrace_WT1600(var Msg: TEventData_WT1600); message WM_EVENT_WT1600;
    procedure UpdateTrace_MEXA7000(var Msg: TEventData_MEXA7000_2); message WM_EVENT_MEXA7000;
    procedure UpdateTrace_MT210(var Msg: TEventData_MT210); message WM_EVENT_MT210;
    procedure UpdateTrace_ECS_kumo(var Msg: TEventData_ECS_kumo); message WM_EVENT_ECS_KUMO;
    procedure UpdateTrace_ECS_AVAT(var Msg: TEventData_ECS_AVAT); message WM_EVENT_ECS_AVAT;
    procedure UpdateTrace_ECS_Woodward(var Msg: TEventData_ECS_Woodward); message WM_EVENT_ECS_Woodward;
    procedure UpdateTrace_LBX(var Msg: TEventData_LBX); message WM_EVENT_LBX;
    procedure UpdateTrace_FlowMeter(var Msg: TEventData_FlowMeter); message WM_EVENT_FLOWMETER;
    procedure UpdateTrace_DYNAMO(var Msg: TEventData_DYNAMO); message WM_EVENT_DYNAMO;
    procedure UpdateTrace_GasCalc(var Msg: TEventData_GasCalc); message WM_EVENT_GASCALC;
    procedure UpdateTrace_KRAL(var Msg: TEventData_KRAL); message WM_EVENT_KRAL;
    procedure UpdateTrace_PLC_S7(var Msg: TEventData_PLC_S7); message WM_EVENT_PLC_S7;
    procedure UpdateTrace_EngineParam(var Msg: TEventData_EngineParam); message WM_EVENT_ENGINEPARAM;

    //WM_COPYDATA message를 받지 못함. Main Form에서 대신 처리
    //procedure WMCopyData(var Msg: TMessage); message WM_COPYDATA;

    procedure SendFormCopyData(ToHandle: integer; AForm:TForm);
    function CheckExistTagName(AParameterSource: TParameterSource;
                                                  ATagName: string): integer;
  protected
    FEnterWatchValue2Screen: Boolean;

    FEngineParameterItemRecord: TEngineParameterItemRecord; //Save폼에 값 전달시 사용

    procedure WT1600_OnSignal(Sender: TIPCThread_WT1600; Data: TEventData_WT1600); virtual;
    procedure MEXA7000_OnSignal(Sender: TIPCThread_MEXA7000; Data: TEventData_MEXA7000); virtual;
    procedure MT210_OnSignal(Sender: TIPCThread_MT210; Data: TEventData_MT210); virtual;
    procedure ECS_OnSignal_kumo(Sender: TIPCThread_ECS_kumo; Data: TEventData_ECS_kumo); virtual;
    procedure ECS_OnSignal_AVAT(Sender: TIPCThread_ECS_AVAT; Data: TEventData_ECS_AVAT); virtual;
    procedure ECS_OnSignal_Woodward(Sender: TIPCThread_ECS_Woodward; Data: TEventData_ECS_Woodward); virtual;
    procedure LBX_OnSignal(Sender: TIPCThread_LBX; Data: TEventData_LBX); virtual;
    procedure FlowMeter_OnSignal(Sender: TIPCThread_FlowMeter; Data: TEventData_FlowMeter); virtual;
    procedure DYNAMO_OnSignal(Sender: TIPCThread_DYNAMO; Data: TEventData_DYNAMO); virtual;
    procedure GasCalc_OnSignal(Sender: TIPCThread_GasCalc; Data: TEventData_GasCalc); virtual;
    procedure KRAL_OnSignal(Sender: TIPCThread_KRAL; Data: TEventData_KRAL); virtual;
    procedure PLC_S7_OnSignal(Sender: TIPCThread_PLC_S7; Data: TEventData_PLC_S7); virtual;
    procedure EngineParam_OnSignal(Sender: TIPCThread_EngineParam; Data: TEventData_EngineParam); virtual;

    procedure OverRide_WT1600(AData: TEventData_WT1600); virtual;
    procedure OverRide_MEXA7000(AData: TEventData_MEXA7000_2); virtual;
    procedure OverRide_MT210(AData: TEventData_MT210); virtual;
    procedure OverRide_ECS_kumo(AData: TEventData_ECS_kumo); virtual;
    procedure OverRide_ECS_kumo2(AData: TEventData_ECS_kumo); virtual;
    procedure OverRide_ECS_AVAT(AData: TEventData_ECS_AVAT); virtual;
    procedure OverRide_ECS_Woodward(AData: TEventData_ECS_Woodward); virtual;
    procedure OverRide_LBX(AData: TEventData_LBX); virtual;
    procedure OverRide_FlowMeter(AData: TEventData_FlowMeter); virtual;
    procedure OverRide_DYNAMO(AData: TEventData_DYNAMO); virtual;
    procedure OverRide_GasCalc(AData: TEventData_GasCalc); virtual;
    procedure OverRide_KRAL(AData: TEventData_KRAL); virtual;
    procedure OverRide_PLC_S7(AData: TEventData_PLC_S7); virtual;
    procedure OverRide_EngineParam(AData: TEventData_EngineParam); virtual;

    procedure CommonCommunication(AParameterSource: TParameterSource);

    procedure WatchValue2Screen_Analog(Name: string; AValue: string;
                           AEPIndex: integer; AIsFloat: Boolean = false);
    procedure WatchValue2Screen_Digital(Name: string; AValue: string;
                           AEPIndex: integer);
    procedure Value2Screen_ECS_kumo(AHiMap: THiMap; AEPIndex: integer; AModbusMode: integer);
    procedure Value2Screen_ECS_kumo2(AEPIndex: integer; AModbusMode: integer);
    procedure Value2Screen_ECS_AVAT(AHiMap: THiMap; AEPIndex: integer; AModbusMode: integer);
    procedure Value2Screen_ECS_Woodward(AEPIndex: integer; AModbusMode: integer);
    procedure Value2Screen_KRAL(AEPIndex: integer; AModbusMode: integer);

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

    //window proc - called by windows to handle messages passed to our hidden window
    procedure WndMethod(var AMsg: TMessage); virtual;
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
    FCommDisconnected: Boolean;// 통신이 일정시간 동안 안되면 True
    FPJHTimerPool: TPJHTimerPool;

    //DSService에서 Engine Parameter를 모두 읽은 후 True
    FStartOnSignal: Boolean; //for component

    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;

    procedure InitVar;
    procedure DestroyVar;

    function CreateIPCMonitor(AEP_DragDrop: TEngineParameterItemRecord; AIsOnlyCreate: Boolean = False): integer;
    procedure CreateIPCMonitorFromParameter(var AIPCList: TStringList);
    procedure DestroyIPCMonitor(AIPCMonitor: TParameterSource);
    procedure DestroyIPCMonitorAll;
    function AssignedIPCMonitor(AIPCMonitor: TParameterSource): Boolean;

    procedure CreateECSkumoIPCMonitor(AEP_DragDrop: TEngineParameterItemRecord);
    procedure CreateECSAVATIPCMonitor(AEP_DragDrop: TEngineParameterItemRecord);
    procedure CreateECSWoodwardIPCMonitor(AEP_DragDrop: TEngineParameterItemRecord);
    procedure CreateWT1600IPCMonitor(AEP_DragDrop: TEngineParameterItemRecord);
    procedure CreateMT210IPCMonitor(AEP_DragDrop: TEngineParameterItemRecord);
    procedure CreateMEXA7000IPCMonitor(AEP_DragDrop: TEngineParameterItemRecord);
    procedure CreateLBXIPCMonitor(AEP_DragDrop: TEngineParameterItemRecord);
    procedure CreateFlowMeterIPCMonitor(AEP_DragDrop: TEngineParameterItemRecord);
    procedure CreateDynamoIPCMonitor(AEP_DragDrop: TEngineParameterItemRecord);
    procedure CreateGasCalcIPCMonitor(AEP_DragDrop: TEngineParameterItemRecord);
    procedure CreateKRALIPCMonitor(AEP_DragDrop: TEngineParameterItemRecord);
    procedure CreatePLCS7IPCMonitor(AEP_DragDrop: TEngineParameterItemRecord);
    procedure CreateEngineParamIPCMonitor(AEP_DragDrop: TEngineParameterItemRecord);

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

    function MoveEngineParameterItemRecord(AEPItemRecord:TEngineParameterItemRecord;
                                   AGrid: TNextGrid = nil): integer; virtual;

    procedure ReadMapAddress(AddressMap: DMap; MapFileName: string); virtual;
    procedure ReadMapAddressFromParamFile(AFilename: string;
      AEngParamEncrypt: Boolean; AModBusBlockList:DList); virtual;
    procedure SetModbusMapFileName(AFileName: string; APSrc: TParameterSource);
    procedure MakeMapFromParameter;

    function CheckUserLevelForWatchListFile(AFileName: string;
                          var AUserLevel: THiMECSUserLevel): Boolean;
    function CheckExeFileNameForWatchListFile(AFileName: string): string;

    procedure DisplayMessage(Msg: string);
    procedure DisplayMessage2SB(AStatusBar: TjvStatusBar; Msg: string);
    procedure SetValue2ScreenEvent(AEventFunc: TWatchValue2Screen_AnalogEvent);
  end;

procedure Register; //for component

implementation

procedure Register;
begin
  RegisterComponents('Samples', [TIPCMonitorAll]);
end;

//IPC Monitor가 할당 되었으면 True 반환
function TIPCMonitorAll.AssignedIPCMonitor(
  AIPCMonitor: TParameterSource): Boolean;
begin
  case TParameterSource(AIPCMonitor) of
    psECS_kumo: Result := Assigned(FIPCMonitor_ECS_kumo);
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
  else
    Result := False;
  end;
end;

//Exe Name과 filename이 다를 경우 Result에 exe name을 반환함
function TIPCMonitorAll.CheckExeFileNameForWatchListFile(
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

function TIPCMonitorAll.CheckExistTagName(AParameterSource: TParameterSource;
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
function TIPCMonitorAll.CheckUserLevelForWatchListFile(AFileName: string;
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

procedure TIPCMonitorAll.CommonCommunication(
  AParameterSource: TParameterSource);
begin
  if not FCommDisconnected then
    FCommDisconnected := True;
end;

constructor TIPCMonitorAll.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);

  FHWnd  := AllocateHWnd(WndMethod); //for component

  InitVar;
end;

procedure TIPCMonitorAll.WndMethod(var AMsg: TMessage);
var
  LHandled : Boolean;
begin
  //Assume we handle message
  LHandled := True;

  case AMsg.Msg of
    WM_EVENT_WT1600:UpdateTrace_WT1600(FWT1600Data);
    WM_EVENT_MEXA7000:UpdateTrace_MEXA7000(FMEXA7000Data);
    WM_EVENT_MT210:UpdateTrace_MT210(FMT210Data);
    WM_EVENT_ECS_kumo:UpdateTrace_ECS_kumo(FECSData_kumo);
    WM_EVENT_ECS_AVAT:UpdateTrace_ECS_AVAT(FECSData_AVAT);
    WM_EVENT_ECS_Woodward:UpdateTrace_ECS_Woodward(FECSData_Woodward);
    WM_EVENT_LBX:UpdateTrace_LBX(FLBXData);
    WM_EVENT_FlowMeter:UpdateTrace_FlowMeter(FFlowMeterData);
    WM_EVENT_DYNAMO:UpdateTrace_DYNAMO(FDYNAMOData);
    WM_EVENT_GasCalc:UpdateTrace_GasCalc(FGasCalcData);
    WM_EVENT_KRAL:UpdateTrace_KRAL(FKRALData);
    WM_EVENT_PLC_S7:UpdateTrace_PLC_S7(FPLCData_S7);
    WM_EVENT_ENGINEPARAM:UpdateTrace_EngineParam(FEngineParamData);
  end;

  if LHandled then
    AMsg.Result := 0
  else
    AMsg.Result := DefWindowProc(FHWnd, AMsg.Msg, AMsg.WParam, AMsg.LParam);
end;

procedure TIPCMonitorAll.CreateDynamoIPCMonitor(
  AEP_DragDrop: TEngineParameterItemRecord);
var
  LSM: string;
begin
  if Assigned(FIPCMonitor_Dynamo) then
    exit;

  if AEP_DragDrop.FSharedName = '' then
    LSM := ParameterSource2SharedMN(AEP_DragDrop.FParameterSource)
  else
    LSM := AEP_DragDrop.FSharedName;

  FIPCMonitor_Dynamo := TIPCMonitor_Dynamo.Create(0, LSM, True);
  FIPCMonitor_Dynamo.OnSignal := Dynamo_OnSignal;
  FIPCMonitor_Dynamo.FreeOnTerminate := True;
  FIPCMonitor_Dynamo.Resume;
end;

procedure TIPCMonitorAll.CreateECSAVATIPCMonitor(
  AEP_DragDrop: TEngineParameterItemRecord);
var
  LSM: string;
begin
  if Assigned(FIPCMonitor_ECS_AVAT) then
    exit;

  SetModbusMapFileName('', AEP_DragDrop.FParameterSource);
//  FAddressMap.clear;
//  ReadMapAddress(FAddressMap,FModbusMapFileName);//FConfigOption.ModbusFileName);

  if AEP_DragDrop.FSharedName = '' then
    LSM := ParameterSource2SharedMN(AEP_DragDrop.FParameterSource)
  else
    LSM := AEP_DragDrop.FSharedName;

  FIPCMonitor_ECS_AVAT := TIPCMonitor_ECS_AVAT.Create(0, LSM, True);
  FIPCMonitor_ECS_AVAT.OnSignal := ECS_OnSignal_AVAT;
  FIPCMonitor_ECS_AVAT.FreeOnTerminate := True;
  FIPCMonitor_ECS_AVAT.Resume;

  FCompleteReadMap_Avat := True;
end;

procedure TIPCMonitorAll.CreateECSkumoIPCMonitor(
  AEP_DragDrop: TEngineParameterItemRecord);
var
  LSM: string;
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

  FIPCMonitor_ECS_kumo := TIPCMonitor_ECS_kumo.Create(0, LSM, True);
  FIPCMonitor_ECS_kumo.OnSignal := ECS_OnSignal_kumo;
  FIPCMonitor_ECS_kumo.FreeOnTerminate := True;
  FIPCMonitor_ECS_kumo.Resume;

  FCompleteReadMap_kumo := True;
end;

procedure TIPCMonitorAll.CreateECSWoodwardIPCMonitor(
  AEP_DragDrop: TEngineParameterItemRecord);
var
  LSM: string;
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

  FIPCMonitor_ECS_Woodward := TIPCMonitor_ECS_Woodward.Create(0, LSM, True);
  FIPCMonitor_ECS_Woodward.OnSignal := ECS_OnSignal_Woodward;
  FIPCMonitor_ECS_Woodward.FreeOnTerminate := True;
  FIPCMonitor_ECS_Woodward.Resume;

  FCompleteReadMap_Woodward := True;
end;

procedure TIPCMonitorAll.CreateEngineParamIPCMonitor(
  AEP_DragDrop: TEngineParameterItemRecord);
var
  LSM: string;
begin
  if Assigned(FIPCMonitor_EngineParam) then
    exit;

  if AEP_DragDrop.FSharedName = '' then
    LSM := ParameterSource2SharedMN(AEP_DragDrop.FParameterSource)
  else
    LSM := AEP_DragDrop.FSharedName;

  FIPCMonitor_EngineParam := TIPCMonitor_EngineParam.Create(0, LSM, True);
  FIPCMonitor_EngineParam.FreeOnTerminate := True;
  FIPCMonitor_EngineParam.OnSignal := EngineParam_OnSignal;
  FIPCMonitor_EngineParam.Resume;
end;

procedure TIPCMonitorAll.CreateFlowMeterIPCMonitor(
  AEP_DragDrop: TEngineParameterItemRecord);
var
  LSM: string;
begin
  if Assigned(FIPCMonitor_FlowMeter) then
    exit;

  if AEP_DragDrop.FSharedName = '' then
    LSM := ParameterSource2SharedMN(AEP_DragDrop.FParameterSource)
  else
    LSM := AEP_DragDrop.FSharedName;

  FIPCMonitor_FlowMeter := TIPCMonitor_FlowMeter.Create(0, LSM, True);
  FIPCMonitor_FlowMeter.OnSignal := FlowMeter_OnSignal;
  FIPCMonitor_FlowMeter.FreeOnTerminate := True;
  FIPCMonitor_FlowMeter.Resume;
end;

procedure TIPCMonitorAll.CreateGasCalcIPCMonitor(
  AEP_DragDrop: TEngineParameterItemRecord);
var
  LSM: string;
begin
  if Assigned(FIPCMonitor_GasCalc) then
    exit;

  if AEP_DragDrop.FSharedName = '' then
    LSM := ParameterSource2SharedMN(AEP_DragDrop.FParameterSource)
  else
    LSM := AEP_DragDrop.FSharedName;

  FIPCMonitor_GasCalc := TIPCMonitor_GasCalc.Create(0, LSM, True);
  FIPCMonitor_GasCalc.FreeOnTerminate := True;
  FIPCMonitor_GasCalc.OnSignal := GasCalc_OnSignal;
  FIPCMonitor_GasCalc.Resume;
end;

function TIPCMonitorAll.CreateIPCMonitor(AEP_DragDrop: TEngineParameterItemRecord;
  AIsOnlyCreate: Boolean = False): integer;
begin
  if not AIsOnlyCreate then
    Result := MoveEngineParameterItemRecord(AEP_DragDrop, FNextGrid);

  case TParameterSource(AEP_DragDrop.FParameterSource) of
    psECS_kumo: CreateECSkumoIPCMonitor(AEP_DragDrop);
    psECS_AVAT: CreateECSAVATIPCMonitor(AEP_DragDrop);
    psMT210: CreateMT210IPCMonitor(AEP_DragDrop);
    psMEXA7000: CreateMEXA7000IPCMonitor(AEP_DragDrop);
    psLBX: CreateLBXIPCMonitor(AEP_DragDrop);
    psFlowMeter: CreateFlowMeterIPCMonitor(AEP_DragDrop);
    psWT1600: CreateWT1600IPCMonitor(AEP_DragDrop);
    psGasCalculated: CreateGasCalcIPCMonitor(AEP_DragDrop);
    psECS_Woodward: CreateECSWoodwardIPCMonitor(AEP_DragDrop);
    psDynamo: CreateDynamoIPCMonitor(AEP_DragDrop);
    psFlowMeterKral: CreateKRALIPCMonitor(AEP_DragDrop);
    psPLC_S7: CreatePLCS7IPCMonitor(AEP_DragDrop);
    psEngineParam: CreateEngineParamIPCMonitor(AEP_DragDrop);
  end;
end;

//FEngineParameter 로 부터 IPC Monitor 생성함.
//반환: 생성된 IPC 리스트 반환
procedure TIPCMonitorAll.CreateIPCMonitorFromParameter(var AIPCList: TStringList);
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
function TIPCMonitorAll.CreateIPCMonitor_DYNAMO(ASharedName: string = ''): String;
begin
  FEngineParameterItemRecord.FParameterSource := psDYNAMO;
  CreateIPCMonitor(FEngineParameterItemRecord);
  Result := ParameterSource2SharedMN(FEngineParameterItemRecord.FParameterSource);
  FillChar(FEngineParameterItemRecord, Sizeof(FEngineParameterItemRecord), #0);
end;

function TIPCMonitorAll.CreateIPCMonitor_ECS_AVAT(ASharedName: string = ''): String;
begin
  FEngineParameterItemRecord.FParameterSource := psECS_AVAT;
  CreateIPCMonitor(FEngineParameterItemRecord);
  Result := ParameterSource2SharedMN(FEngineParameterItemRecord.FParameterSource);
  FillChar(FEngineParameterItemRecord, Sizeof(FEngineParameterItemRecord), #0);
end;

function TIPCMonitorAll.CreateIPCMonitor_ECS_kumo(ASharedName: string = ''): String;
begin
  FEngineParameterItemRecord.FParameterSource := psECS_kumo;
  CreateIPCMonitor(FEngineParameterItemRecord);
  Result := ParameterSource2SharedMN(FEngineParameterItemRecord.FParameterSource);
  FillChar(FEngineParameterItemRecord, Sizeof(FEngineParameterItemRecord), #0);
end;

function TIPCMonitorAll.CreateIPCMonitor_ECS_Woodward(
  ASharedName: string): String;
begin
  FEngineParameterItemRecord.FParameterSource := psECS_Woodward;
  CreateIPCMonitor(FEngineParameterItemRecord);
  Result := ParameterSource2SharedMN(FEngineParameterItemRecord.FParameterSource);
  FillChar(FEngineParameterItemRecord, Sizeof(FEngineParameterItemRecord), #0);
end;

function TIPCMonitorAll.CreateIPCMonitor_EngineParam(
  ASharedName: string): String;
begin
  FEngineParameterItemRecord.FParameterSource := psEngineParam;
  CreateIPCMonitor(FEngineParameterItemRecord);
  Result := ParameterSource2SharedMN(FEngineParameterItemRecord.FParameterSource);
  FillChar(FEngineParameterItemRecord, Sizeof(FEngineParameterItemRecord), #0);
end;

function TIPCMonitorAll.CreateIPCMonitor_FlowMeter(ASharedName: string = ''): String;
begin
  FEngineParameterItemRecord.FParameterSource := psFlowMeter;
  CreateIPCMonitor(FEngineParameterItemRecord);
  Result := ParameterSource2SharedMN(FEngineParameterItemRecord.FParameterSource);
  FillChar(FEngineParameterItemRecord, Sizeof(FEngineParameterItemRecord), #0);
end;

function TIPCMonitorAll.CreateIPCMonitor_GasCalc(ASharedName: string = ''): String;
begin
  FEngineParameterItemRecord.FParameterSource := psGasCalculated;
  CreateIPCMonitor(FEngineParameterItemRecord);
  Result := ParameterSource2SharedMN(FEngineParameterItemRecord.FParameterSource);
  FillChar(FEngineParameterItemRecord, Sizeof(FEngineParameterItemRecord), #0);
end;

function TIPCMonitorAll.CreateIPCMonitor_KRAL(ASharedName: string): String;
begin
  FEngineParameterItemRecord.FParameterSource := psFlowMeterKral;
  CreateIPCMonitor(FEngineParameterItemRecord);
  Result := ParameterSource2SharedMN(FEngineParameterItemRecord.FParameterSource);
  FillChar(FEngineParameterItemRecord, Sizeof(FEngineParameterItemRecord), #0);
end;

function TIPCMonitorAll.CreateIPCMonitor_LBX(ASharedName: string = ''): String;
begin
  FEngineParameterItemRecord.FParameterSource := psLBX;
  CreateIPCMonitor(FEngineParameterItemRecord);
  Result := ParameterSource2SharedMN(FEngineParameterItemRecord.FParameterSource);
  FillChar(FEngineParameterItemRecord, Sizeof(FEngineParameterItemRecord), #0);
end;

function TIPCMonitorAll.CreateIPCMonitor_MEXA7000(ASharedName: string = ''): String;
begin
  FEngineParameterItemRecord.FParameterSource := psMEXA7000;
  CreateIPCMonitor(FEngineParameterItemRecord);
  Result := ParameterSource2SharedMN(FEngineParameterItemRecord.FParameterSource);
  FillChar(FEngineParameterItemRecord, Sizeof(FEngineParameterItemRecord), #0);
end;

function TIPCMonitorAll.CreateIPCMonitor_MT210(ASharedName: string = ''): String;
begin
  FEngineParameterItemRecord.FParameterSource := psMT210;
  CreateIPCMonitor(FEngineParameterItemRecord);
  Result := ParameterSource2SharedMN(FEngineParameterItemRecord.FParameterSource);
  FillChar(FEngineParameterItemRecord, Sizeof(FEngineParameterItemRecord), #0);
end;

function TIPCMonitorAll.CreateIPCMonitor_PLC_S7(
  ASharedName: string): String;
begin
  FEngineParameterItemRecord.FParameterSource := psPLC_S7;
  CreateIPCMonitor(FEngineParameterItemRecord);
  Result := ParameterSource2SharedMN(FEngineParameterItemRecord.FParameterSource);
  FillChar(FEngineParameterItemRecord, Sizeof(FEngineParameterItemRecord), #0);
end;

function TIPCMonitorAll.CreateIPCMonitor_WT1600(ASharedName: string = ''): String;
begin
  FEngineParameterItemRecord.FParameterSource := psWT1600;
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

procedure TIPCMonitorAll.CreateKRALIPCMonitor(
  AEP_DragDrop: TEngineParameterItemRecord);
var
  LSM: string;
begin
  if Assigned(FIPCMonitor_KRAL) then
    exit;

  if AEP_DragDrop.FSharedName = '' then
    LSM := ParameterSource2SharedMN(AEP_DragDrop.FParameterSource)
  else
    LSM := AEP_DragDrop.FSharedName;

  FIPCMonitor_KRAL := TIPCMonitor_KRAL.Create(0, LSM, True);
  FIPCMonitor_KRAL.FreeOnTerminate := True;
  FIPCMonitor_KRAL.OnSignal := KRAL_OnSignal;
  FIPCMonitor_KRAL.Resume;
end;

procedure TIPCMonitorAll.CreateLBXIPCMonitor(AEP_DragDrop: TEngineParameterItemRecord);
var
  LSM: string;
begin
  if Assigned(FIPCMonitor_LBX) then
    exit;

  if AEP_DragDrop.FSharedName = '' then
    LSM := ParameterSource2SharedMN(AEP_DragDrop.FParameterSource)
  else
    LSM := AEP_DragDrop.FSharedName;

  FIPCMonitor_LBX := TIPCMonitor_LBX.Create(0, LSM, True);
  FIPCMonitor_LBX.OnSignal := LBX_OnSignal;
  FIPCMonitor_LBX.FreeOnTerminate := True;
  FIPCMonitor_LBX.Resume;
end;

procedure TIPCMonitorAll.CreateMEXA7000IPCMonitor(
  AEP_DragDrop: TEngineParameterItemRecord);
var
  LSM: string;
begin
  if Assigned(FIPCMonitor_MEXA7000) then
    exit;

  if AEP_DragDrop.FSharedName = '' then
    LSM := ParameterSource2SharedMN(AEP_DragDrop.FParameterSource)
  else
    LSM := AEP_DragDrop.FSharedName;

  FIPCMonitor_MEXA7000 := TIPCMonitor_MEXA7000.Create(0, LSM, True);
  FIPCMonitor_MEXA7000.OnSignal := MEXA7000_OnSignal;
  FIPCMonitor_MEXA7000.FreeOnTerminate := True;
  FIPCMonitor_MEXA7000.Resume;
end;

procedure TIPCMonitorAll.CreateMT210IPCMonitor(
  AEP_DragDrop: TEngineParameterItemRecord);
var
  LSM: string;
begin
  if Assigned(FIPCMonitor_MT210) then
    exit;

  if AEP_DragDrop.FSharedName = '' then
    LSM := ParameterSource2SharedMN(AEP_DragDrop.FParameterSource)
  else
    LSM := AEP_DragDrop.FSharedName;

  FIPCMonitor_MT210 := TIPCMonitor_MT210.Create(0, LSM, True);
  FIPCMonitor_MT210.OnSignal := MT210_OnSignal;
  FIPCMonitor_MT210.FreeOnTerminate := True;
  FIPCMonitor_MT210.Resume;
end;

procedure TIPCMonitorAll.CreatePLCS7IPCMonitor(
  AEP_DragDrop: TEngineParameterItemRecord);
var
  LSM: string;
begin
  if Assigned(FIPCMonitor_PLC_S7) then
    exit;

  if AEP_DragDrop.FSharedName = '' then
    LSM := ParameterSource2SharedMN(AEP_DragDrop.FParameterSource)
  else
    LSM := AEP_DragDrop.FSharedName;

  FIPCMonitor_PLC_S7 := TIPCMonitor_PLC_S7.Create(0, LSM, True);
  FIPCMonitor_PLC_S7.FreeOnTerminate := True;
  FIPCMonitor_PLC_S7.OnSignal := PLC_S7_OnSignal;
  FIPCMonitor_PLC_S7.Resume;
end;

procedure TIPCMonitorAll.CreateWT1600IPCMonitor(
  AEP_DragDrop: TEngineParameterItemRecord);
var
  LSM: string;
begin
  if Assigned(FIPCMonitor_WT1600) then
    exit;

  if AEP_DragDrop.FSharedName = '' then
    LSM := ParameterSource2SharedMN(AEP_DragDrop.FParameterSource)
  else
    LSM := AEP_DragDrop.FSharedName;

  FIPCMonitor_WT1600 := TIPCMonitor_WT1600.Create(0, LSM, True);
  FIPCMonitor_WT1600.FreeOnTerminate := True;
  FIPCMonitor_WT1600.OnSignal := WT1600_OnSignal;
  FIPCMonitor_WT1600.Resume;
end;

destructor TIPCMonitorAll.Destroy;
begin
  DeallocateHWnd(FHWnd); //for component

  DestroyVar;

  inherited;
end;

procedure TIPCMonitorAll.DestroyIPCMonitor(AIPCMonitor: TParameterSource);
begin
  if Assigned(FIPCMonitor_WT1600) then
    FIPCMonitor_WT1600.OnSignal := nil;

  if Assigned(FIPCMonitor_MEXA7000) then
    FIPCMonitor_MEXA7000.OnSignal := nil;

  if Assigned(FIPCMonitor_MT210) then
    FIPCMonitor_MT210.OnSignal := nil;

  if Assigned(FIPCMonitor_ECS_kumo) then
    FIPCMonitor_ECS_kumo.OnSignal := nil;

  if Assigned(FIPCMonitor_ECS_Woodward) then
    FIPCMonitor_ECS_Woodward.OnSignal := nil;

  if Assigned(FIPCMonitor_ECS_AVAT) then
    FIPCMonitor_ECS_AVAT.OnSignal := nil;

  if Assigned(FIPCMonitor_LBX) then
    FIPCMonitor_LBX.OnSignal := nil;

  if Assigned(FIPCMonitor_Dynamo) then
    FIPCMonitor_Dynamo.OnSignal := nil;

  if Assigned(FIPCMonitor_KRAL) then
    FIPCMonitor_KRAL.OnSignal := nil;

  if Assigned(FIPCMonitor_GasCalc) then
    FIPCMonitor_GasCalc.OnSignal := nil;

  if Assigned(FIPCMonitor_PLC_S7) then
    FIPCMonitor_PLC_S7.OnSignal := nil;

  if Assigned(FIPCMonitor_EngineParam) then
    FIPCMonitor_EngineParam.OnSignal := nil;

  if Assigned(FIPCMonitor_WT1600) and (AIPCMonitor = psWT1600) then
  begin
    FIPCMonitor_WT1600.FMonitorEvent.Pulse;
    FIPCMonitor_WT1600.Terminate;
    FIPCMonitor_WT1600 := nil;
  end;

  if Assigned(FIPCMonitor_MEXA7000) and (AIPCMonitor = psMEXA7000)  then
  begin
    FIPCMonitor_MEXA7000.Suspend;
    FIPCMonitor_MEXA7000.FMonitorEvent.Pulse;
    FIPCMonitor_MEXA7000.Resume;
    FIPCMonitor_MEXA7000.Terminate;
    FIPCMonitor_MEXA7000 := nil;
  end;

  if Assigned(FIPCMonitor_MT210) and (AIPCMonitor = psMT210)  then
  begin
    FIPCMonitor_MT210.Suspend;
    FIPCMonitor_MT210.FMonitorEvent.Pulse;
    FIPCMonitor_MT210.Resume;
    FIPCMonitor_MT210.Terminate;
    FIPCMonitor_MT210 := nil;
  end;

  if Assigned(FIPCMonitor_ECS_kumo) and (AIPCMonitor = psECS_kumo)  then
  begin
    FIPCMonitor_ECS_kumo.Suspend;
    FIPCMonitor_ECS_kumo.FMonitorEvent.Pulse;
    FIPCMonitor_ECS_kumo.Resume;
    FIPCMonitor_ECS_kumo.Terminate;
    FIPCMonitor_ECS_kumo := nil;
  end;

  if Assigned(FIPCMonitor_ECS_AVAT) and (AIPCMonitor = psECS_AVAT)  then
  begin
    FIPCMonitor_ECS_AVAT.Suspend;
    FIPCMonitor_ECS_AVAT.FMonitorEvent.Pulse;
    FIPCMonitor_ECS_AVAT.Resume;
    FIPCMonitor_ECS_AVAT.Terminate;
    FIPCMonitor_ECS_AVAT := nil;
  end;

  if Assigned(FIPCMonitor_LBX) and (AIPCMonitor = psLBX)  then
  begin
    FIPCMonitor_LBX.Suspend;
    FIPCMonitor_LBX.FMonitorEvent.Pulse;
    FIPCMonitor_LBX.Resume;
    FIPCMonitor_LBX.Terminate;
    FIPCMonitor_LBX := nil;
  end;

  if Assigned(FIPCMonitor_Dynamo) and (AIPCMonitor = psDynamo)  then
  begin
    FIPCMonitor_Dynamo.Suspend;
    FIPCMonitor_Dynamo.FMonitorEvent.Pulse;
    FIPCMonitor_Dynamo.Resume;
    FIPCMonitor_Dynamo.Terminate;
    FIPCMonitor_Dynamo := nil;
  end;

  if Assigned(FIPCMonitor_KRAL) and (AIPCMonitor = psFlowMeterKral)  then
  begin
    FIPCMonitor_KRAL.Suspend;
    FIPCMonitor_KRAL.FMonitorEvent.Pulse;
    FIPCMonitor_KRAL.Resume;
    FIPCMonitor_KRAL.Terminate;
    FIPCMonitor_KRAL := nil;
  end;

  if Assigned(FIPCMonitor_PLC_S7) and (AIPCMonitor = psPLC_S7)  then
  begin
    FIPCMonitor_PLC_S7.Suspend;
    FIPCMonitor_PLC_S7.FMonitorEvent.Pulse;
    FIPCMonitor_PLC_S7.Resume;
    FIPCMonitor_PLC_S7.Terminate;
    FIPCMonitor_PLC_S7 := nil;
  end;

  if Assigned(FIPCMonitor_GasCalc) and (AIPCMonitor = psGasCalculated)  then
  begin
    FIPCMonitor_GasCalc.Suspend;
    FIPCMonitor_GasCalc.FMonitorEvent.Pulse;
    FIPCMonitor_GasCalc.Resume;
    FIPCMonitor_GasCalc.Terminate;
    FIPCMonitor_GasCalc := nil;
  end;

  if Assigned(FIPCMonitor_EngineParam) and (AIPCMonitor = psEngineParam)  then
  begin
    FIPCMonitor_EngineParam.Suspend;
    FIPCMonitor_EngineParam.FMonitorEvent.Pulse;
    FIPCMonitor_EngineParam.Resume;
    FIPCMonitor_EngineParam.Terminate;
    FIPCMonitor_EngineParam := nil;
  end;
end;

procedure TIPCMonitorAll.DestroyIPCMonitorAll;
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

procedure TIPCMonitorAll.DestroyVar;
begin
  FPJHTimerPool.RemoveAll;
  FreeAndNil(FPJHTimerPool);

  //DestroyIPCMonitor;

  FEngineParameter.EngineParameterCollect.Clear;
  FreeAndNil(FEngineParameter);

  ObjFree(FAddressMap);
  FreeAndNil(FAddressMap);

  //FreeAndNil(FConfigOption);
end;

procedure TIPCMonitorAll.DisplayMessage(Msg: string);
begin

end;

procedure TIPCMonitorAll.DisplayMessage2SB(AStatusBar: TjvStatusBar; Msg: string);
begin
  if Assigned(AStatusBar) then
  begin
    AStatusBar.SimplePanel := True;
    AStatusBar.SimpleText := Msg;
  end;
end;

procedure TIPCMonitorAll.DYNAMO_OnSignal(Sender: TIPCThread_DYNAMO;
  Data: TEventData_DYNAMO);
begin
  CommonCommunication(psDynamo);
end;

procedure TIPCMonitorAll.ECS_OnSignal_AVAT(Sender: TIPCThread_ECS_AVAT;
  Data: TEventData_ECS_AVAT);
var
  i,dcount: integer;
begin
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

  DisplayMessage2SB(FStatusBar, FECSData_AVAT.ModBusAddress + ' 데이타 도착');

  //SendMessage(Handle, WM_EVENT_ECS_AVAT, 0,0);
  CommonCommunication(psECS_AVAT);
end;

procedure TIPCMonitorAll.ECS_OnSignal_kumo(Sender: TIPCThread_ECS_kumo;
  Data: TEventData_ECS_kumo);
var
  i,dcount: integer;
begin
  if not FCompleteReadMap_kumo then
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
    dcount := Data.NumOfData div 2;
    FECSData_kumo.NumOfBit := Data.NumOfBit;

    if dcount = 0 then
      Inc(dcount);

    for i := 0 to dcount - 1 do
    begin
      FECSData_kumo.InpDataBuf[i] := Data.InpDataBuf2[i*2] ;
      FECSData_kumo.InpDataBuf[i] := FECSData_kumo.InpDataBuf[i] shl 8 + Data.InpDataBuf2[i*2 + 1];
//      FModBusData.InpDataBuf[i] :=  ;
    end;

    if (Data.NumOfData mod 2) > 0 then
      FECSData_kumo.InpDataBuf[i] := Data.InpDataBuf2[i*2] ;
  end//Data.ModBusMode = 1
  else
  if (Data.ModBusMode = 3) then
  begin
    dcount := Data.NumOfData;
    FECSData_kumo.NumOfBit := Data.NumOfBit;
    System.Move(Data.InpDataBuf_double, FECSData_kumo.InpDataBuf_double, Sizeof(Data.InpDataBuf_double));
  end;//Data.ModBusMode = 3

  FECSData_kumo.ModBusAddress := Data.ModBusAddress;
  FECSData_kumo.BlockNo := Data.BlockNo;
  FECSData_kumo.NumOfData := dcount;
  FECSData_kumo.ModBusFunctionCode := Data.ModBusFunctionCode;

  DisplayMessage2SB(FStatusBar, FECSData_kumo.ModBusAddress + ' 데이타 도착');

  //SendMessage(Handle, WM_EVENT_ECS_KUMO, 0,0);
  CommonCommunication(psECS_kumo);
end;

procedure TIPCMonitorAll.ECS_OnSignal_Woodward(
  Sender: TIPCThread_ECS_Woodward; Data: TEventData_ECS_Woodward);
var
  i,dcount: integer;
begin
  if not FCompleteReadMap_Woodward then
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
      FECSData_AVAT.InpDataBuf[i] := Data.InpDataBuf2[i*2] ;
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

  DisplayMessage2SB(FStatusBar, FECSData_Woodward.ModBusAddress + ' 데이타 도착');

  //SendMessage(Handle, WM_EVENT_ECS_Woodward, 0,0);
  CommonCommunication(psECS_Woodward);
end;

procedure TIPCMonitorAll.EngineParam_OnSignal(Sender: TIPCThread_EngineParam;
  Data: TEventData_EngineParam);
begin
  System.Move(Data.FData, FEngineParamData.FData, Sizeof(Data.FData));
  FEngineParamData.FDataCount := Data.FDataCount;

  //SendMessage(Handle, WM_EVENT_ENGINEPARAM, 0,0);
  CommonCommunication(psEngineParam);
end;

procedure TIPCMonitorAll.FlowMeter_OnSignal(Sender: TIPCThread_FlowMeter;
  Data: TEventData_FlowMeter);
begin
//;
  CommonCommunication(psFlowMeter);
end;

//AAutoStart: True = 프로그램 시작시에 watch file name을 parameter로 입력받는 경우
//            False = LoadFromFile 메뉴로 실행되는 경우
procedure TIPCMonitorAll.GasCalc_OnSignal(Sender: TIPCThread_GasCalc;
  Data: TEventData_GasCalc);
begin
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

  //SendMessage(Handle, WM_EVENT_GASCALC, 0,0);
  CommonCommunication(psGasCalculated);
end;

procedure TIPCMonitorAll.InitVar;
begin
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
end;

procedure TIPCMonitorAll.KRAL_OnSignal(Sender: TIPCThread_KRAL;
  Data: TEventData_KRAL);
var
  i,dcount: integer;
begin
  FillChar(FKRALData.InpDataBuf[0], High(FKRALData.InpDataBuf) - 1, #0);
  FKRALData.ModBusMode := Data.ModBusMode;

  if Data.ModBusMode = 0 then //ASCII Mode이면
  begin
    //ModePanel.Caption := 'ASCII Mode';
    dcount := Data.NumOfData;
    FKRALData.NumOfBit := Data.NumOfBit;

    for i := 0 to dcount - 1 do
      FKRALData.InpDataBuf[i] := Data.InpDataBuf[i];
  end
  else
  if Data.ModBusMode = 1 then// RTU Mode 이면
  begin
    //ModePanel.Caption := 'RTU Mode';
    dcount := Data.NumOfData div 2;
    FKRALData.NumOfBit := Data.NumOfBit;

    if dcount = 0 then
      Inc(dcount);

    for i := 0 to dcount - 1 do
    begin
      FKRALData.InpDataBuf[i] := Data.InpDataBuf2[i*2] ;
      FKRALData.InpDataBuf[i] := FKRALData.InpDataBuf[i] shl 8 + Data.InpDataBuf2[i*2 + 1];
//      FModBusData.InpDataBuf[i] :=  ;
    end;

    if (Data.NumOfData mod 2) > 0 then
      FKRALData.InpDataBuf[i] := Data.InpDataBuf2[i*2] ;
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

  DisplayMessage2SB(FStatusBar, FKRALData.ModBusAddress + ' 데이타 도착');

  //SendMessage(Handle, WM_EVENT_KRAL, 0,0);
  CommonCommunication(psFlowMeterKral);
end;

procedure TIPCMonitorAll.LBX_OnSignal(Sender: TIPCThread_LBX; Data: TEventData_LBX);
begin
  FLBXData.ENGRPM := Data.ENGRPM;
  FLBXData.HTTEMP := Data.HTTEMP;
  FLBXData.LOTEMP := Data.LOTEMP;
  FLBXData.TCRPMA := Data.TCRPMA;
  FLBXData.TCRPMB := Data.TCRPMB;
  FLBXData.TCINLETTEMP := Data.TCINLETTEMP;

  //SendMessage(Handle, WM_EVENT_LBX, 0,0);
  CommonCommunication(psLBX);
end;

procedure TIPCMonitorAll.MakeMapFromParameter;
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

procedure TIPCMonitorAll.MEXA7000_OnSignal(Sender: TIPCThread_MEXA7000;
  Data: TEventData_MEXA7000);
begin
  FMEXA7000Data.CO2 := StrToFloatDef(Data.CO2,0.0);
  FMEXA7000Data.CO_L := StrToFloatDef(Data.CO_L,0.0);
  FMEXA7000Data.O2 := StrToFloatDef(Data.O2,0.0);
  FMEXA7000Data.NOx := StrToFloatDef(Data.NOx,0.0);
  FMEXA7000Data.THC := StrToFloatDef(Data.THC,0.0);
  FMEXA7000Data.CH4 := StrToFloatDef(Data.CH4,0.0);
  FMEXA7000Data.non_CH4 := StrToFloatDef(Data.non_CH4,0.0);
  FMEXA7000Data.CollectedValue := Data.CollectedValue;

  //SendMessage(Handle, WM_EVENT_MEXA7000, 0,0);
  CommonCommunication(psMEXA7000);
end;

//추가 또는 수정되는 FEngineParameter.EngineParameterCollectItem의 Index를 반환함
function TIPCMonitorAll.MoveEngineParameterItemRecord(
  AEPItemRecord: TEngineParameterItemRecord; AGrid: TNextGrid = nil): integer;
begin
  Result := CheckExistTagName(AEPItemRecord.FParameterSource,AEPItemRecord.FTagName);

  if Result > -1 then
    exit;

  FEngineParameter.ProjectFileName := AEPItemRecord.FProjectFileName;

  with FEngineParameter.EngineParameterCollect.Add do
  begin
    LevelIndex := AEPItemRecord.FLevelIndex;
    NodeIndex := AEPItemRecord.FNodeIndex;
    AbsoluteIndex := AEPItemRecord.FAbsoluteIndex;
    MaxValue := AEPItemRecord.FMaxValue;
    MaxValue_real := AEPItemRecord.FMaxValue_real;
    Contact := AEPItemRecord.FContact;
    BlockNo := AEPItemRecord.FBlockNo;

    SharedName := AEPItemRecord.FSharedName;
    TagName := AEPItemRecord.FTagname;
    Description := AEPItemRecord.FDescription;
    Address := AEPItemRecord.FAddress;
    FCode := AEPItemRecord.FFCode;
    FFUnit := AEPItemRecord.FUnit;
    MinMaxType := AEPItemRecord.FMinMaxType;
    Alarm := AEPItemRecord.FAlarm;
    RadixPosition := AEPItemRecord.FRadixPosition;

    SensorType := AEPItemRecord.FSensorType;
    ParameterCatetory := AEPItemRecord.FParameterCatetory;
    ParameterType := AEPItemRecord.FParameterType;
    ParameterSource := AEPItemRecord.FParameterSource;

    MinAlarmEnable := AEPItemRecord.FMinAlarmEnable;
    MaxAlarmEnable := AEPItemRecord.FMaxAlarmEnable;
    MinFaultEnable := AEPItemRecord.FMinFaultEnable;
    MaxFaultEnable := AEPItemRecord.FMaxFaultEnable;

    MinAlarmValue := AEPItemRecord.FMinAlarmValue;
    MaxAlarmValue := AEPItemRecord.FMaxAlarmValue;
    MinFaultValue := AEPItemRecord.FMinFaultValue;
    MaxFaultValue := AEPItemRecord.FMaxFaultValue;

    MinAlarmColor := AEPItemRecord.FMinAlarmColor;
    MaxAlarmColor := AEPItemRecord.FMaxAlarmColor;
    MinFaultColor := AEPItemRecord.FMinFaultColor;
    MaxFaultColor := AEPItemRecord.FMaxFaultColor;

    MinAlarmBlink := AEPItemRecord.FMinAlarmBlink;
    MaxAlarmBlink := AEPItemRecord.FMaxAlarmBlink;
    MinFaultBlink := AEPItemRecord.FMinFaultBlink;
    MaxFaultBlink := AEPItemRecord.FMaxFaultBlink;

    MinAlarmSoundEnable := AEPItemRecord.FMinAlarmSoundEnable;
    MaxAlarmSoundEnable := AEPItemRecord.FMaxAlarmSoundEnable;
    MinFaultSoundEnable := AEPItemRecord.FMinFaultSoundEnable;
    MaxFaultSoundEnable := AEPItemRecord.FMaxFaultSoundEnable;

    MinAlarmSoundFilename := AEPItemRecord.FMinAlarmSoundFilename;
    MaxAlarmSoundFilename := AEPItemRecord.FMaxAlarmSoundFilename;
    MinFaultSoundFilename := AEPItemRecord.FMinFaultSoundFilename;
    MaxFaultSoundFilename := AEPItemRecord.FMaxFaultSoundFilename;

    IsDisplayTrend := AEPItemRecord.FIsDisplayTrend;
    IsDisplaySimple := AEPItemRecord.FIsDisplaySimple;
    TrendChannelIndex := AEPItemRecord.FTrendChannelIndex;
    PlotXValue := AEPItemRecord.FPlotXValue;
    MinValue := AEPItemRecord.FMinValue;
    MinValue_Real := AEPItemRecord.FMinValue_Real;

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
  end;

  //Result := FEngineParameter.EngineParameterCollect.Count - 1;
end;

procedure TIPCMonitorAll.MT210_OnSignal(Sender: TIPCThread_MT210;
  Data: TEventData_MT210);
begin
  FMT210Data.FData := Data.FData;
  //SendMessage(Handle, WM_EVENT_MT210, 0,0);
  CommonCommunication(psMT210);
end;

procedure TIPCMonitorAll.OnSetZeroDYNAMO(Sender: TObject; Handle: Integer;
  Interval: Cardinal; ElapsedTime: Integer);
begin
  FillChar(FDYNAMOData, Sizeof(FDYNAMOData), 0);

  if FCommDisconnected then
    FCommDisconnected := False;
end;

procedure TIPCMonitorAll.OnSetZeroECS_AVAT(Sender: TObject; Handle: Integer;
  Interval: Cardinal; ElapsedTime: Integer);
begin
  FillChar(FECSData_AVAT, Sizeof(FECSData_AVAT), 0);

  if FCommDisconnected then
    FCommDisconnected := False;
end;

procedure TIPCMonitorAll.OnSetZeroECS_kumo(Sender: TObject; Handle: Integer;
  Interval: Cardinal; ElapsedTime: Integer);
begin
  FillChar(FECSData_kumo, Sizeof(FECSData_kumo), 0);

  if FCommDisconnected then
    FCommDisconnected := False;
end;

procedure TIPCMonitorAll.OnSetZeroECS_Woodward(Sender: TObject;
  Handle: Integer; Interval: Cardinal; ElapsedTime: Integer);
begin
  FillChar(FECSData_Woodward, Sizeof(FECSData_Woodward), 0);

  if FCommDisconnected then
    FCommDisconnected := False;
end;

procedure TIPCMonitorAll.OnSetZeroEngineParam(Sender: TObject; Handle: Integer;
  Interval: Cardinal; ElapsedTime: Integer);
begin
  FillChar(FEngineParamData, Sizeof(FEngineParamData), 0);

  if FCommDisconnected then
    FCommDisconnected := False;
end;

procedure TIPCMonitorAll.OnSetZeroFlowMeter(Sender: TObject; Handle: Integer;
  Interval: Cardinal; ElapsedTime: Integer);
begin
  FillChar(FFlowMeterData, Sizeof(FFlowMeterData), 0);

  if FCommDisconnected then
    FCommDisconnected := False;
end;

procedure TIPCMonitorAll.OnSetZeroGasCalc(Sender: TObject; Handle: Integer;
  Interval: Cardinal; ElapsedTime: Integer);
begin
  FillChar(FGasCalcData, Sizeof(FGasCalcData), 0);

  if FCommDisconnected then
    FCommDisconnected := False;
end;

procedure TIPCMonitorAll.OnSetZeroKRAL(Sender: TObject; Handle: Integer;
  Interval: Cardinal; ElapsedTime: Integer);
begin
  FillChar(FKRALData, Sizeof(FKRALData), 0);

  if FCommDisconnected then
    FCommDisconnected := False;
end;

procedure TIPCMonitorAll.OnSetZeroLBX(Sender: TObject; Handle: Integer;
  Interval: Cardinal; ElapsedTime: Integer);
begin
  FillChar(FLBXData, Sizeof(FLBXData), 0);

  if FCommDisconnected then
    FCommDisconnected := False;
end;

procedure TIPCMonitorAll.OnSetZeroMEXA7000(Sender: TObject; Handle: Integer;
  Interval: Cardinal; ElapsedTime: Integer);
begin
  FillChar(FMEXA7000Data, Sizeof(FMEXA7000Data), 0);

  if FCommDisconnected then
    FCommDisconnected := False;
end;

procedure TIPCMonitorAll.OnSetZeroMT210(Sender: TObject; Handle: Integer;
  Interval: Cardinal; ElapsedTime: Integer);
begin
  FillChar(FMT210Data, Sizeof(FMT210Data), 0);

  if FCommDisconnected then
    FCommDisconnected := False;
end;

procedure TIPCMonitorAll.OnSetZeroPLC_S7(Sender: TObject; Handle: Integer;
  Interval: Cardinal; ElapsedTime: Integer);
begin
  FillChar(FPLCData_S7, Sizeof(FPLCData_S7), 0);

  if FCommDisconnected then
    FCommDisconnected := False;
end;

procedure TIPCMonitorAll.OnSetZeroWT1600(Sender: TObject; Handle: Integer;
  Interval: Cardinal; ElapsedTime: Integer);
begin
  FillChar(FWT1600Data, Sizeof(FWT1600Data), 0);

  if FCommDisconnected then
    FCommDisconnected := False;
end;

procedure TIPCMonitorAll.OverRide_DYNAMO(AData: TEventData_DYNAMO);
var
  i, LRadix: integer;
  LDataOk: Boolean;
begin
  for i := 0 to FEngineParameter.EngineParameterCollect.Count - 1 do
  begin
    if FEngineParameter.EngineParameterCollect.Items[i].ParameterSource = psDynamo then
    begin
      LRadix := FEngineParameter.EngineParameterCollect.Items[i].RadixPosition;

      if UpperCase(FEngineParameter.EngineParameterCollect.Items[i].TagName) = UpperCase('Power') then
        FEngineParameter.EngineParameterCollect.Items[i].Value := FloatToStrF(FDYNAMOData.FPower, ffFixed, 12, LRadix) //FloatToStr(FDYNAMOData.FPower)
      else if UpperCase(FEngineParameter.EngineParameterCollect.Items[i].TagName) = UpperCase('Torque') then
        FEngineParameter.EngineParameterCollect.Items[i].Value := FloatToStrF(FDYNAMOData.FTorque, ffFixed, 12, LRadix) //FloatToStr(FDYNAMOData.FTorque)
      else if UpperCase(FEngineParameter.EngineParameterCollect.Items[i].TagName) = UpperCase('RPM') then
        FEngineParameter.EngineParameterCollect.Items[i].Value := FloatToStrF(FDYNAMOData.FRevolution, ffFixed, 12, LRadix) //FloatToStr(FDYNAMOData.FRevolution)
      else if UpperCase(FEngineParameter.EngineParameterCollect.Items[i].TagName) = UpperCase('BRG_TB') then
        FEngineParameter.EngineParameterCollect.Items[i].Value := FloatToStrF(FDYNAMOData.FBrgTBTemp, ffFixed, 12, LRadix) //FloatToStr(FDYNAMOData.FBrgTBTemp)
      else if UpperCase(FEngineParameter.EngineParameterCollect.Items[i].TagName) = UpperCase('BRG_MTR') then
        FEngineParameter.EngineParameterCollect.Items[i].Value := FloatToStrF(FDYNAMOData.FBrgMTRTemp, ffFixed, 12, LRadix) //FloatToStr(FDYNAMOData.FBrgMTRTemp)
      else if UpperCase(FEngineParameter.EngineParameterCollect.Items[i].TagName) = UpperCase('Inlet1') then
        FEngineParameter.EngineParameterCollect.Items[i].Value := FloatToStrF(FDYNAMOData.FInletOpen1, ffFixed, 12, LRadix) //FloatToStr(FDYNAMOData.FInletOpen1)
      else if UpperCase(FEngineParameter.EngineParameterCollect.Items[i].TagName) = UpperCase('Inlet2') then
        FEngineParameter.EngineParameterCollect.Items[i].Value := FloatToStrF(FDYNAMOData.FInletOpen2, ffFixed, 12, LRadix) //FloatToStr(FDYNAMOData.FInletOpen2)
      else if UpperCase(FEngineParameter.EngineParameterCollect.Items[i].TagName) = UpperCase('Outlet1') then
        FEngineParameter.EngineParameterCollect.Items[i].Value := FloatToStrF(FDYNAMOData.FOutletOpen1, ffFixed, 12, LRadix) //FloatToStr(FDYNAMOData.FOutletOpen1)
      else if UpperCase(FEngineParameter.EngineParameterCollect.Items[i].TagName) = UpperCase('Outlet2') then
        FEngineParameter.EngineParameterCollect.Items[i].Value := FloatToStrF(FDYNAMOData.FOutletOpen2, ffFixed, 12, LRadix) //FloatToStr(FDYNAMOData.FOutletOpen2)
      else if UpperCase(FEngineParameter.EngineParameterCollect.Items[i].TagName) = UpperCase('WaterInlet') then
        FEngineParameter.EngineParameterCollect.Items[i].Value := FloatToStrF(FDYNAMOData.FWaterInletTemp, ffFixed, 12, LRadix) //FloatToStr(FDYNAMOData.FWaterInletTemp)
      else if UpperCase(FEngineParameter.EngineParameterCollect.Items[i].TagName) = UpperCase('WaterOutlet') then
        FEngineParameter.EngineParameterCollect.Items[i].Value := FloatToStrF(FDYNAMOData.FWaterOutletTemp, ffFixed, 12, LRadix) //FloatToStr(FDYNAMOData.FWaterOutletTemp)
      else if UpperCase(FEngineParameter.EngineParameterCollect.Items[i].TagName) = UpperCase('Body1') then
        FEngineParameter.EngineParameterCollect.Items[i].Value := FloatToStrF(FDYNAMOData.FBody1Press, ffFixed, 12, LRadix) //FloatToStr(FDYNAMOData.FBody1Press)
      else if UpperCase(FEngineParameter.EngineParameterCollect.Items[i].TagName) = UpperCase('Body2') then
        FEngineParameter.EngineParameterCollect.Items[i].Value := FloatToStrF(FDYNAMOData.FBody2Press, ffFixed, 12, LRadix) //FloatToStr(FDYNAMOData.FBody2Press)
      else if UpperCase(FEngineParameter.EngineParameterCollect.Items[i].TagName) = UpperCase('WaterSupply') then
        FEngineParameter.EngineParameterCollect.Items[i].Value := FloatToStrF(FDYNAMOData.FWaterSupply, ffFixed, 12, LRadix) //FloatToStr(FDYNAMOData.FWaterSupply)
      else if UpperCase(FEngineParameter.EngineParameterCollect.Items[i].TagName) = UpperCase('OilPress') then
        FEngineParameter.EngineParameterCollect.Items[i].Value := FloatToStrF(FDYNAMOData.FOilPress, ffFixed, 12, LRadix); //FloatToStr(FDYNAMOData.FOilPress);

      WatchValue2Screen_Analog('', '',i);
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

procedure TIPCMonitorAll.OverRide_ECS_AVAT(AData: TEventData_ECS_AVAT);
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
  LDataOk := True;

    if (FECSData_AVAT.ModBusFunctionCode = 3) or (FECSData_AVAT.ModBusFunctionCode = 4) then
    begin
      for k := 0 to FEngineParameter.EngineParameterCollect.Count - 1 do
      begin
        if True then

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

  DisplayMessage2SB(FStatusBar, FECSData_AVAT.ModBusAddress + ' 처리중...');
end;

procedure TIPCMonitorAll.OverRide_ECS_kumo(AData: TEventData_ECS_kumo);
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

  if FECSData_kumo.ModBusMode = 3 then //RTU mode simulated
  begin
    it := FAddressMap.start;
  end
  else
  begin
    tmpStr := IntToStr(FECSData_kumo.ModBusFunctionCode) + FECSData_kumo.ModBusAddress;
    it := FAddressMap.locate( [tmpStr] );
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
      for k := 0 to FEngineParameter.EngineParameterCollect.Count - 1 do
      begin
        if FEngineParameter.EngineParameterCollect.Items[k].ParameterSource = psECS_kumo then
        begin
          if (IntToStr(FECSData_kumo.ModBusFunctionCode) = FEngineParameter.EngineParameterCollect.Items[k].FCode) and
                    (pHiMap.FAddress = FEngineParameter.EngineParameterCollect.Items[k].Address) then
          begin
            if FECSData_kumo.ModBusMode = 3 then
              pHiMap.FValue := FECSData_kumo.InpDataBuf_double[i]
            else
              pHiMap.FValue := FECSData_kumo.InpDataBuf[i];
            //수신된 데이타를 화면에 뿌려줌
            Value2Screen_ECS_kumo(pHiMap,k,FECSData_kumo.ModBusMode);
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
  DisplayMessage2SB(FStatusBar, FECSData_kumo.ModBusAddress + ' 처리중...');
end;

procedure TIPCMonitorAll.OverRide_ECS_kumo2(AData: TEventData_ECS_kumo);
var
  i,k: integer;
  Le: double;
  LRadix: integer;
begin
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
            Le := (Le * FEngineParameter.EngineParameterCollect.Items[k].MaxValue) / 4095;
          end;

          LRadix := FEngineParameter.EngineParameterCollect.Items[k].RadixPosition;

          FEngineParameter.EngineParameterCollect.Items[k].Value := FloatToStrF(Le, ffFixed, 12, LRadix);//,'%.2f');
        end;

        //수신된 데이타를 화면에 뿌려줌
        Value2Screen_ECS_kumo2(k,FECSData_kumo.ModBusMode);
      end;
    end;//for
  end;
end;

procedure TIPCMonitorAll.OverRide_ECS_Woodward(
  AData: TEventData_ECS_Woodward);
var
  i,k: integer;
  Le: double;
  LRadix: integer;
begin
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
            if FEngineParameter.EngineParameterCollect.Items[k].MaxValue > 0 then
              Le := FECSData_Woodward.InpDataBuf[i]/FEngineParameter.EngineParameterCollect.Items[k].MaxValue
            else
              Le := FECSData_Woodward.InpDataBuf[i];
          end;

          LRadix := FEngineParameter.EngineParameterCollect.Items[k].RadixPosition;

          FEngineParameter.EngineParameterCollect.Items[k].Value := FloatToStrF(Le, ffFixed, 12, LRadix);//,'%.2f');
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
      end;
    end;//for
  end;
end;

procedure TIPCMonitorAll.OverRide_EngineParam(AData: TEventData_EngineParam);
var
  i: integer;
  LDataOk: boolean;
begin
  LDataOk := False;

  for i := 0 to FEngineParameter.EngineParameterCollect.Count - 1 do
  begin
    if FEngineParameter.EngineParameterCollect.Items[i].ParameterSource = psEngineParam then
    begin
      FEngineParameter.EngineParameterCollect.Items[i].Value := FEngineParamData.FData[i];

      WatchValue2Screen_Analog('', '',i);
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

procedure TIPCMonitorAll.OverRide_FlowMeter(AData: TEventData_FlowMeter);
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

procedure TIPCMonitorAll.OverRide_GasCalc(AData: TEventData_GasCalc);
var
  i, LRadix: integer;
  LDouble: double;
begin
  for i := 0 to FEngineParameter.EngineParameterCollect.Count - 1 do
  begin
    if FEngineParameter.EngineParameterCollect.Items[i].ParameterSource = psGasCalculated then
    begin
      LRadix := FEngineParameter.EngineParameterCollect.Items[i].RadixPosition;

      if UpperCase(FEngineParameter.EngineParameterCollect.Items[i].TagName) = UpperCase('SVP') then
        FEngineParameter.EngineParameterCollect.Items[i].Value := FloatToStrF(FGasCalcData.FSVP, ffFixed, 12, LRadix) //FloatToStr(FGasCalcData.FSVP)
      else if UpperCase(FEngineParameter.EngineParameterCollect.Items[i].TagName) = UpperCase('IAH2') then
        FEngineParameter.EngineParameterCollect.Items[i].Value := FloatToStrF(FGasCalcData.FIAH2, ffFixed, 12, LRadix) //FloatToStr(FGasCalcData.FIAH2)
      else if UpperCase(FEngineParameter.EngineParameterCollect.Items[i].TagName) = UpperCase('UFC') then
        FEngineParameter.EngineParameterCollect.Items[i].Value := FloatToStrF(FGasCalcData.FUFC, ffFixed, 12, LRadix) //FloatToStr(FGasCalcData.FUFC)
      else if UpperCase(FEngineParameter.EngineParameterCollect.Items[i].TagName) = UpperCase('NhtCF') then
        FEngineParameter.EngineParameterCollect.Items[i].Value := FloatToStrF(FGasCalcData.FNhtCF, ffFixed, 12, LRadix) //FloatToStr(FGasCalcData.FNhtCF)
      else if UpperCase(FEngineParameter.EngineParameterCollect.Items[i].TagName) = UpperCase('DWCFE') then
        FEngineParameter.EngineParameterCollect.Items[i].Value := FloatToStrF(FGasCalcData.FDWCFE, ffFixed, 12, LRadix) //FloatToStr(FGasCalcData.FDWCFE)
      else if UpperCase(FEngineParameter.EngineParameterCollect.Items[i].TagName) = UpperCase('EGF') then
        FEngineParameter.EngineParameterCollect.Items[i].Value := FloatToStrF(FGasCalcData.FEGF, ffFixed, 12, LRadix) //FloatToStr(FGasCalcData.FEGF)
      else if UpperCase(FEngineParameter.EngineParameterCollect.Items[i].TagName) = UpperCase('NOxAtO213') then
        FEngineParameter.EngineParameterCollect.Items[i].Value := FloatToStrF(FGasCalcData.FNOxAtO213, ffFixed, 12, LRadix) //FloatToStr(FGasCalcData.FNOxAtO213)
      else if UpperCase(FEngineParameter.EngineParameterCollect.Items[i].TagName) = UpperCase('NOx') then
        FEngineParameter.EngineParameterCollect.Items[i].Value := FloatToStrF(FGasCalcData.FNOx, ffFixed, 12, LRadix) //FloatToStr(FGasCalcData.FNOx)
      else if UpperCase(FEngineParameter.EngineParameterCollect.Items[i].TagName) = UpperCase('AF1') then
        FEngineParameter.EngineParameterCollect.Items[i].Value := FloatToStrF(FGasCalcData.FAF1, ffFixed, 12, LRadix) //FloatToStr(FGasCalcData.FAF1)
      else if UpperCase(FEngineParameter.EngineParameterCollect.Items[i].TagName) = UpperCase('AF2') then
        FEngineParameter.EngineParameterCollect.Items[i].Value := FloatToStrF(FGasCalcData.FAF2, ffFixed, 12, LRadix) //FloatToStr(FGasCalcData.FAF2)
      else if UpperCase(FEngineParameter.EngineParameterCollect.Items[i].TagName) = UpperCase('AF3') then
        FEngineParameter.EngineParameterCollect.Items[i].Value := FloatToStrF(FGasCalcData.FAF3, ffFixed, 12, LRadix) //FloatToStr(FGasCalcData.FAF3)
      else if UpperCase(FEngineParameter.EngineParameterCollect.Items[i].TagName) = UpperCase('AF_Measured') then
        FEngineParameter.EngineParameterCollect.Items[i].Value := FloatToStrF(FGasCalcData.FAF_Measured, ffFixed, 12, LRadix) //FloatToStr(FGasCalcData.FAF_Measured)
      else if UpperCase(FEngineParameter.EngineParameterCollect.Items[i].TagName) = UpperCase('MT210') then
        FEngineParameter.EngineParameterCollect.Items[i].Value := FloatToStrF(FGasCalcData.FMT210, ffFixed, 12, LRadix) //FloatToStr(FGasCalcData.FMT210)
      else if UpperCase(FEngineParameter.EngineParameterCollect.Items[i].TagName) = UpperCase('FC') then
        FEngineParameter.EngineParameterCollect.Items[i].Value := FloatToStrF(FGasCalcData.FFC, ffFixed, 12, LRadix) //FloatToStr(FGasCalcData.FFC)
      else if UpperCase(FEngineParameter.EngineParameterCollect.Items[i].TagName) = UpperCase('EngineOutput') then
        FEngineParameter.EngineParameterCollect.Items[i].Value := FloatToStrF(FGasCalcData.FEngineOutput, ffFixed, 12, LRadix) //FloatToStr(FGasCalcData.FEngineOutput)
      else if UpperCase(FEngineParameter.EngineParameterCollect.Items[i].TagName) = UpperCase('GeneratorOutput') then
        FEngineParameter.EngineParameterCollect.Items[i].Value := FloatToStrF(FGasCalcData.FGeneratorOutput, ffFixed, 12, LRadix) //FloatToStr(FGasCalcData.FGeneratorOutput)
      else if UpperCase(FEngineParameter.EngineParameterCollect.Items[i].TagName) = UpperCase('EngineLoad') then
        FEngineParameter.EngineParameterCollect.Items[i].Value := FloatToStrF(FGasCalcData.FEngineLoad, ffFixed, 12, LRadix) //FloatToStr(FGasCalcData.FEngineLoad)
      else if UpperCase(FEngineParameter.EngineParameterCollect.Items[i].TagName) = UpperCase('GenEfficiency') then
        FEngineParameter.EngineParameterCollect.Items[i].Value := FloatToStrF(FGasCalcData.FGenEfficiency, ffFixed, 12, LRadix) //FloatToStr(FGasCalcData.FGenEfficiency)
      else if UpperCase(FEngineParameter.EngineParameterCollect.Items[i].TagName) = UpperCase('BHP') then
        FEngineParameter.EngineParameterCollect.Items[i].Value := FloatToStrF(FGasCalcData.FBHP, ffFixed, 12, LRadix) //FloatToStr(FGasCalcData.FBHP)
      else if UpperCase(FEngineParameter.EngineParameterCollect.Items[i].TagName) = UpperCase('BMEP') then
        FEngineParameter.EngineParameterCollect.Items[i].Value := FloatToStrF(FGasCalcData.FBMEP, ffFixed, 12, LRadix) //FloatToStr(FGasCalcData.FBMEP)
      else if UpperCase(FEngineParameter.EngineParameterCollect.Items[i].TagName) = UpperCase('Lamda_Calculated') then
        FEngineParameter.EngineParameterCollect.Items[i].Value := FloatToStrF(FGasCalcData.FLamda_Calculated, ffFixed, 12, LRadix) //FloatToStr(FGasCalcData.FLamda_Calculated)
      else if UpperCase(FEngineParameter.EngineParameterCollect.Items[i].TagName) = UpperCase('Lamda_Measured') then
        FEngineParameter.EngineParameterCollect.Items[i].Value := FloatToStrF(FGasCalcData.FLamda_Measured, ffFixed, 12, LRadix) //FloatToStr(FGasCalcData.FLamda_Measured)
      else if UpperCase(FEngineParameter.EngineParameterCollect.Items[i].TagName) = UpperCase('Lamda_Brettschneider') then
        FEngineParameter.EngineParameterCollect.Items[i].Value := FloatToStrF(FGasCalcData.FLamda_Brettschneider, ffFixed, 12, LRadix) //FloatToStr(FGasCalcData.FLamda_Brettschneider)
      else if UpperCase(FEngineParameter.EngineParameterCollect.Items[i].TagName) = UpperCase('AFRatio_Calculated') then
        FEngineParameter.EngineParameterCollect.Items[i].Value := FloatToStrF(FGasCalcData.FAFRatio_Calculated, ffFixed, 12, LRadix) //FloatToStr(FGasCalcData.FAFRatio_Calculated)
      else if UpperCase(FEngineParameter.EngineParameterCollect.Items[i].TagName) = UpperCase('AFRatio_Measured') then
        FEngineParameter.EngineParameterCollect.Items[i].Value := FloatToStrF(FGasCalcData.FAFRatio_Measured, ffFixed, 12, LRadix) //FloatToStr(FGasCalcData.FAFRatio_Measured)
      else if UpperCase(FEngineParameter.EngineParameterCollect.Items[i].TagName) = UpperCase('ExhTempAvg') then
        FEngineParameter.EngineParameterCollect.Items[i].Value := FloatToStrF(FGasCalcData.FExhTempAvg, ffFixed, 12, LRadix) //FloatToStr(FGasCalcData.FExhTempAvg)
      else if UpperCase(FEngineParameter.EngineParameterCollect.Items[i].TagName) = UpperCase('WasteGatePosition') then
        FEngineParameter.EngineParameterCollect.Items[i].Value := FloatToStrF(FGasCalcData.FWasteGatePosition, ffFixed, 12, LRadix) //FloatToStr(FGasCalcData.FWasteGatePosition)
      else if UpperCase(FEngineParameter.EngineParameterCollect.Items[i].TagName) = UpperCase('ThrottlePosition') then
        FEngineParameter.EngineParameterCollect.Items[i].Value := FloatToStrF(FGasCalcData.FThrottlePosition, ffFixed, 12, LRadix) //FloatToStr(FGasCalcData.FThrottlePosition)
      else if UpperCase(FEngineParameter.EngineParameterCollect.Items[i].TagName) = UpperCase('Density') then
        FEngineParameter.EngineParameterCollect.Items[i].Value := FloatToStrF(FGasCalcData.FDensity, ffFixed, 12, LRadix) //FloatToStr(FGasCalcData.FDensity)
      else if UpperCase(FEngineParameter.EngineParameterCollect.Items[i].TagName) = UpperCase('LCV') then
        FEngineParameter.EngineParameterCollect.Items[i].Value := FloatToStrF(FGasCalcData.FLCV, ffFixed, 12, LRadix) //FloatToStr(FGasCalcData.FLCV)
      else if UpperCase(FEngineParameter.EngineParameterCollect.Items[i].TagName) = UpperCase('BoostPress') then
        FEngineParameter.EngineParameterCollect.Items[i].Value := FloatToStrF(FGasCalcData.FBoostPress, ffFixed, 12, LRadix); //FloatToStr(FGasCalcData.FBoostPress);

      WatchValue2Screen_Analog('', '',i);
    end;
  end;//for
end;

procedure TIPCMonitorAll.OverRide_KRAL(AData: TEventData_KRAL);
var
  i,k, LValue: integer;
  Le: double;
  LRadix: integer;
begin
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
          end
          else
          begin
            //LValue := ((FKRALData.InpDataBuf[i] shl 16) or FKRALData.InpDataBuf[i+1]);
            //Le := LValue / 10;
            Le := FKRALData.InpDataBuf[i];
          end;

          LRadix := FEngineParameter.EngineParameterCollect.Items[k].RadixPosition;

          FEngineParameter.EngineParameterCollect.Items[k].Value := FloatToStrF(Le, ffFixed, 12, LRadix);//,'%.2f');
        end;

        //수신된 데이타를 화면에 뿌려줌
        Value2Screen_KRAL(k,FKRALData.ModBusMode);
      end;
    end;//for
  end;
end;

procedure TIPCMonitorAll.OverRide_LBX(AData: TEventData_LBX);
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
      LRadix := FEngineParameter.EngineParameterCollect.Items[i].RadixPosition;

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

  //상속 받은 자손에서 구현할 것
  {if LDataOk then
  begin
    Timer1.Enabled := True;
    FPJHTimerPool.AddOneShot(OnTrigger4AvgSave,2000);
    DataSaveByEvent;
  end;
  }
end;

procedure TIPCMonitorAll.OverRide_MEXA7000(AData: TEventData_MEXA7000_2);
var
  i, LRadix: integer;
  LDataOk: Boolean;
begin
  for i := 0 to FEngineParameter.EngineParameterCollect.Count - 1 do
  begin
    if FEngineParameter.EngineParameterCollect.Items[i].ParameterSource = psMEXA7000 then
    begin
      LRadix := FEngineParameter.EngineParameterCollect.Items[i].RadixPosition;

      if UpperCase(FEngineParameter.EngineParameterCollect.Items[i].TagName) = UpperCase('CO2') then
        FEngineParameter.EngineParameterCollect.Items[i].Value := FloatToStrF(FMEXA7000Data.CO2/10000, ffFixed, 12, LRadix) //FloatToStr(FMEXA7000Data.CO2/10000)
      else if UpperCase(FEngineParameter.EngineParameterCollect.Items[i].TagName) = UpperCase('CO_L') then
        FEngineParameter.EngineParameterCollect.Items[i].Value := FloatToStrF(FMEXA7000Data.CO_L, ffFixed, 12, LRadix) //FloatToStr(FMEXA7000Data.CO_L)
      else if UpperCase(FEngineParameter.EngineParameterCollect.Items[i].TagName) = UpperCase('O2') then
        FEngineParameter.EngineParameterCollect.Items[i].Value := FloatToStrF(FMEXA7000Data.O2/10000, ffFixed, 12, LRadix) //FloatToStr(FMEXA7000Data.O2/10000)
      else if UpperCase(FEngineParameter.EngineParameterCollect.Items[i].TagName) = UpperCase('NOx') then
        FEngineParameter.EngineParameterCollect.Items[i].Value := FloatToStrF(FMEXA7000Data.NOx, ffFixed, 12, LRadix) //FloatToStr(FMEXA7000Data.NOx)
      else if UpperCase(FEngineParameter.EngineParameterCollect.Items[i].TagName) = UpperCase('THC') then
        FEngineParameter.EngineParameterCollect.Items[i].Value := FloatToStrF(FMEXA7000Data.THC, ffFixed, 12, LRadix) //FloatToStr(FMEXA7000Data.THC)
      else if UpperCase(FEngineParameter.EngineParameterCollect.Items[i].TagName) = UpperCase('CH4') then
        FEngineParameter.EngineParameterCollect.Items[i].Value := FloatToStrF(FMEXA7000Data.CH4, ffFixed, 12, LRadix) //FloatToStr(FMEXA7000Data.CH4)
      else if UpperCase(FEngineParameter.EngineParameterCollect.Items[i].TagName) = UpperCase('non_CH4') then
        FEngineParameter.EngineParameterCollect.Items[i].Value := FloatToStrF(FMEXA7000Data.non_CH4, ffFixed, 12, LRadix) //FloatToStr(FMEXA7000Data.non_CH4)
      else if UpperCase(FEngineParameter.EngineParameterCollect.Items[i].TagName) = UpperCase('CollectedValue') then
        FEngineParameter.EngineParameterCollect.Items[i].Value := FloatToStrF(FMEXA7000Data.CollectedValue, ffFixed, 12, LRadix); //FloatToStr(FMEXA7000Data.CollectedValue);

      WatchValue2Screen_Analog('', '',i);
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

procedure TIPCMonitorAll.OverRide_MT210;
var
  i, LRadix: integer;
  LDataOk: Boolean;
begin
  LDataOk := False;

  for i := 0 to FEngineParameter.EngineParameterCollect.Count - 1 do
  begin
    if FEngineParameter.EngineParameterCollect.Items[i].ParameterSource = psMT210 then
    begin
      LRadix := FEngineParameter.EngineParameterCollect.Items[i].RadixPosition;

      FEngineParameter.EngineParameterCollect.Items[i].Value := FloatToStrF(FMT210Data.FData, ffFixed, 12, LRadix); //FloatToStr(FMT210Data.FData);
      WatchValue2Screen_Analog('', '',i);
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

procedure TIPCMonitorAll.OverRide_PLC_S7(AData: TEventData_PLC_S7);
var
  i,k,LRadix,LDividor: integer;
  Le: double;
begin
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

      LRadix := FEngineParameter.EngineParameterCollect.Items[k].RadixPosition;
      FEngineParameter.EngineParameterCollect.Items[k].Value := FloatToStrF(Le, ffFixed, 12, LRadix);//,'%.2f');

      WatchValue2Screen_Analog('', '',k);
    end;//if
  end;//for
end;

procedure TIPCMonitorAll.OverRide_WT1600(AData: TEventData_WT1600);
var
  i, LRadix, LMaxVal: integer;
  LDouble: double;
  LDataOk: boolean;
begin
  LDataOk := False;

  for i := 0 to FEngineParameter.EngineParameterCollect.Count - 1 do
  begin
    if FEngineParameter.EngineParameterCollect.Items[i].ParameterSource = psWT1600 then
    begin
      LRadix := FEngineParameter.EngineParameterCollect.Items[i].RadixPosition;
      LMaxVal := FEngineParameter.EngineParameterCollect.Items[i].MaxValue;

      if LMaxVal = 0 then
        LMaxVal := 1;

      if UpperCase(FEngineParameter.EngineParameterCollect.Items[i].TagName) = UpperCase('PSIGMA') then
      begin
        LDouble := StrToFloatDef(FWT1600Data.PSIGMA,0.0);
        FEngineParameter.EngineParameterCollect.Items[i].Value := FloatToStrF(LDouble/LMaxVal, ffFixed, 12, LRadix) //Format('%.2f', [LDouble/1000]);
      end
      else if UpperCase(FEngineParameter.EngineParameterCollect.Items[i].TagName) = UpperCase('SSIGMA') then
      begin
        LDouble := StrToFloatDef(FWT1600Data.SSIGMA,0.0);
        FEngineParameter.EngineParameterCollect.Items[i].Value := FloatToStrF(LDouble/LMaxVal, ffFixed, 12, LRadix) //Format('%.2f', [LDouble/1000]);
      end
      else if UpperCase(FEngineParameter.EngineParameterCollect.Items[i].TagName) = UpperCase('QSIGMA') then
      begin
        LDouble := StrToFloatDef(FWT1600Data.QSIGMA,0.0);
        FEngineParameter.EngineParameterCollect.Items[i].Value := FloatToStrF(LDouble/LMaxVal, ffFixed, 12, LRadix) //Format('%.2f', [LDouble/1000]);
      end
      else if UpperCase(FEngineParameter.EngineParameterCollect.Items[i].TagName) = UpperCase('URMS1') then
        FEngineParameter.EngineParameterCollect.Items[i].Value := String(FWT1600Data.URMS1)
      else if UpperCase(FEngineParameter.EngineParameterCollect.Items[i].TagName) = UpperCase('URMS2') then
        FEngineParameter.EngineParameterCollect.Items[i].Value := String(FWT1600Data.URMS2)
      else if UpperCase(FEngineParameter.EngineParameterCollect.Items[i].TagName) = UpperCase('URMS3') then
        FEngineParameter.EngineParameterCollect.Items[i].Value := String(FWT1600Data.URMS3)
      else if UpperCase(FEngineParameter.EngineParameterCollect.Items[i].TagName) = UpperCase('IRMS1') then
        FEngineParameter.EngineParameterCollect.Items[i].Value := String(FWT1600Data.IRMS1)
      else if UpperCase(FEngineParameter.EngineParameterCollect.Items[i].TagName) = UpperCase('IRMS2') then
        FEngineParameter.EngineParameterCollect.Items[i].Value := String(FWT1600Data.IRMS2)
      else if UpperCase(FEngineParameter.EngineParameterCollect.Items[i].TagName) = UpperCase('IRMS3') then
        FEngineParameter.EngineParameterCollect.Items[i].Value := String(FWT1600Data.IRMS3)
      else if UpperCase(FEngineParameter.EngineParameterCollect.Items[i].TagName) = UpperCase('URMSAVG') then
        FEngineParameter.EngineParameterCollect.Items[i].Value := String(FWT1600Data.URMSAVG)
      else if UpperCase(FEngineParameter.EngineParameterCollect.Items[i].TagName) = UpperCase('IRMSAVG') then
        FEngineParameter.EngineParameterCollect.Items[i].Value := String(FWT1600Data.IRMSAVG)
      else if UpperCase(FEngineParameter.EngineParameterCollect.Items[i].TagName) = UpperCase('RAMDA') then
        FEngineParameter.EngineParameterCollect.Items[i].Value := String(FWT1600Data.RAMDA)
      else if UpperCase(FEngineParameter.EngineParameterCollect.Items[i].TagName) = UpperCase('F1') then
        FEngineParameter.EngineParameterCollect.Items[i].Value := String(FWT1600Data.F1)
      else if UpperCase(FEngineParameter.EngineParameterCollect.Items[i].TagName) = UpperCase('FREQUENCY') then
        FEngineParameter.EngineParameterCollect.Items[i].Value := String(FWT1600Data.FREQUENCY);

      WatchValue2Screen_Analog('', '',i);
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

procedure TIPCMonitorAll.PLC_S7_OnSignal(Sender: TIPCThread_PLC_S7;
  Data: TEventData_PLC_S7);
begin
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

  //SendMessage(Handle, WM_EVENT_PLC_S7, 0,0);
  CommonCommunication(psPLC_S7);
end;

procedure TIPCMonitorAll.ReadMapAddress(AddressMap: DMap; MapFileName: string);
var
  sqltext, MapFilePath: string;
  sqlresult, reccnt, fldcnt: integer;
  i,j, LLastBlockNo, LLastIndex: integer;
  filename, fcode: string;
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

procedure TIPCMonitorAll.ReadMapAddressFromParamFile(AFilename: string;
  AEngParamEncrypt: Boolean; AModBusBlockList: DList);
var
  i, LPrevBlockNo, LCount: integer;
  LIndex: integer;
  LStartAddr:string;
  LBlockNo,
  LFuncCode: integer;
  LModBusBlock: TModbusBlock;
begin
  FEngineParameter.EngineParameterCollect.Clear;
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

procedure TIPCMonitorAll.SendFormCopyData(ToHandle: integer; AForm: TForm);
var
  cd : TCopyDataStruct;
begin
  with cd do
  begin
    dwData := Self.FHWnd;//handle
    cbData := sizeof(AForm);
    lpData := @AForm;
  end;//with

  SendMessage(ToHandle, WM_COPYDATA, 0, LongInt(@cd));
end;

procedure TIPCMonitorAll.SetModbusMapFileName(AFileName: string;
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
        FModbusMapFileName := 'Default_ModbusMap_Avat.txt';
    end
    else
      FModbusMapFileName := AFileName;

    FAddressMap.clear;
    ReadMapAddress(FAddressMap,AFileName);
  end
  else if APSrc = psECS_woodward then
  begin
    FEngineParameter.LoadFromJSONFile(AFileName);
    exit;
  end;
end;

procedure TIPCMonitorAll.SetValue2ScreenEvent(
  AEventFunc: TWatchValue2Screen_AnalogEvent);
begin
  FWatchValue2Screen_AnalogEvent := AEventFunc;
end;

procedure TIPCMonitorAll.UpdateTrace_DYNAMO(var Msg: TEventData_DYNAMO);
begin
  if FIsSetZeroWhenDisconnect then
    FPJHTimerPool.AddOneShot(OnSetZeroDYNAMO,5000);

  OverRide_DYNAMO(FDYNAMOData);
end;

procedure TIPCMonitorAll.UpdateTrace_ECS_AVAT(var Msg: TEventData_ECS_AVAT);
begin
  if FIsSetZeroWhenDisconnect then
    FPJHTimerPool.AddOneShot(OnSetZeroECS_AVAT,5000);

  OverRide_ECS_AVAT(FECSData_AVAT);
end;

procedure TIPCMonitorAll.UpdateTrace_ECS_kumo(var Msg: TEventData_ECS_kumo);
begin
  if FIsSetZeroWhenDisconnect then
    FPJHTimerPool.AddOneShot(OnSetZeroECS_kumo,5000);

  OverRide_ECS_kumo2(FECSData_kumo);
end;

procedure TIPCMonitorAll.UpdateTrace_ECS_Woodward(
  var Msg: TEventData_ECS_Woodward);
begin
  if FIsSetZeroWhenDisconnect then
    FPJHTimerPool.AddOneShot(OnSetZeroECS_Woodward,5000);

  OverRide_ECS_Woodward(FECSData_Woodward);
end;

procedure TIPCMonitorAll.UpdateTrace_EngineParam(
  var Msg: TEventData_EngineParam);
begin
  if FIsSetZeroWhenDisconnect then
    FPJHTimerPool.AddOneShot(OnSetZeroEngineParam,5000);

  OverRide_EngineParam(FEngineParamData);
end;

procedure TIPCMonitorAll.UpdateTrace_FlowMeter(var Msg: TEventData_FlowMeter);
begin
  if FIsSetZeroWhenDisconnect then
    FPJHTimerPool.AddOneShot(OnSetZeroFlowMeter,5000);

  OverRide_FlowMeter(FFlowMeterData);
end;

procedure TIPCMonitorAll.UpdateTrace_GasCalc(var Msg: TEventData_GasCalc);
begin
  if FIsSetZeroWhenDisconnect then
    FPJHTimerPool.AddOneShot(OnSetZeroGasCalc,5000);

  OverRide_GasCalc(FGasCalcData);
end;

procedure TIPCMonitorAll.UpdateTrace_KRAL(var Msg: TEventData_KRAL);
begin
  if FIsSetZeroWhenDisconnect then
    FPJHTimerPool.AddOneShot(OnSetZeroKRAL,5000);

  OverRide_KRAL(FKRALData);
end;

procedure TIPCMonitorAll.UpdateTrace_LBX(var Msg: TEventData_LBX);
begin
  if FIsSetZeroWhenDisconnect then
    FPJHTimerPool.AddOneShot(OnSetZeroLBX,5000);

  OverRide_LBX(FLBXData);
end;

procedure TIPCMonitorAll.UpdateTrace_MEXA7000(var Msg: TEventData_MEXA7000_2);
begin
  if FIsSetZeroWhenDisconnect then
    FPJHTimerPool.AddOneShot(OnSetZeroMEXA7000,5000);

  OverRide_MEXA7000(FMEXA7000Data);
end;

procedure TIPCMonitorAll.UpdateTrace_MT210(var Msg: TEventData_MT210);
begin
  if FIsSetZeroWhenDisconnect then
    FPJHTimerPool.AddOneShot(OnSetZeroMT210,5000);

  OverRide_MT210(FMT210Data);
end;

procedure TIPCMonitorAll.UpdateTrace_PLC_S7(var Msg: TEventData_PLC_S7);
begin
  if FIsSetZeroWhenDisconnect then
    FPJHTimerPool.AddOneShot(OnSetZeroPLC_S7,5000);

  OverRide_PLC_S7(FPLCData_S7);
end;

procedure TIPCMonitorAll.UpdateTrace_WT1600(var Msg: TEventData_WT1600);
begin
  if FIsSetZeroWhenDisconnect then
    FPJHTimerPool.AddOneShot(OnSetZeroWT1600,5000);

  OverRide_WT1600(FWT1600Data);
end;

procedure TIPCMonitorAll.Value2Screen_ECS_AVAT(AHiMap: THiMap; AEPIndex,
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
procedure TIPCMonitorAll.Value2Screen_ECS_kumo(AHiMap: THiMap; AEPIndex,
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

procedure TIPCMonitorAll.Value2Screen_ECS_kumo2(AEPIndex,
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

procedure TIPCMonitorAll.Value2Screen_ECS_Woodward(AEPIndex: integer;
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

procedure TIPCMonitorAll.Value2Screen_KRAL(AEPIndex: integer;
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

procedure TIPCMonitorAll.WatchValue2Screen_Analog(Name, AValue: string;
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
    //tmpdouble := StrToFloatDef(TIPCMonitorAll1.FEngineParameter.EngineParameterCollect.Items[AEPIndex].Value, 0.0);
    if Assigned(FWatchValue2Screen_AnalogEvent) then
      FWatchValue2Screen_AnalogEvent(Name, AValue, AEPIndex)
    else
    begin
      case FPageControl.ActivePageIndex of
        1: begin //Items
          FNextGrid.CellsByName['Value', AEPIndex] := FEngineParameter.EngineParameterCollect.Items[AEPIndex].Value;
        end;
      end;
    end;
  finally
    FEnterWatchValue2Screen := False;
  end;
end;

procedure TIPCMonitorAll.WatchValue2Screen_Digital(Name, AValue: string;
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
      case FPageControl.ActivePageIndex of
        1: begin //Items
          FNextGrid.CellsByName['Value', AEPIndex] := FEngineParameter.EngineParameterCollect.Items[AEPIndex].Value;
        end;
      end;
    end;
  finally
    FEnterWatchValue2Screen := False;
  end;
end;

{
procedure TIPCMonitorAll.WMCopyData(var Msg: TMessage);
begin
 if Msg.WParam = 2 then //User Level Receive
  begin
    FCurrentUserLevel := THiMECSUserLevel(PCopyDataStruct(Msg.LParam)^.cbData);
  end
  else
    CreateIPCMonitor(PEngineParameterItemRecord(PCopyDataStruct(Msg.LParam)^.lpData)^);
end;
}

procedure TIPCMonitorAll.WT1600_OnSignal(Sender: TIPCThread_WT1600;
  Data: TEventData_WT1600);
begin
  FWT1600Data.PSIGMA := String(Data.PSIGMA);
  FWT1600Data.SSIGMA := String(Data.SSIGMA);
  FWT1600Data.QSIGMA := String(Data.QSIGMA);
  FWT1600Data.URMS1 := String(Data.URMS1);
  FWT1600Data.URMS2 := String(Data.URMS2);
  FWT1600Data.URMS3 := String(Data.URMS3);
  FWT1600Data.IRMS1 := String(Data.IRMS1);
  FWT1600Data.IRMS2 := String(Data.IRMS2);
  FWT1600Data.IRMS3 := String(Data.IRMS3);
  FWT1600Data.RAMDA := String(Data.RAMDA);
  FWT1600Data.IRMSAVG := Data.IRMSAVG;
  FWT1600Data.URMSAVG := Data.URMSAVG;
  FWT1600Data.F1 := Data.F1;
  FWT1600Data.FREQUENCY := String(Data.FREQUENCY);

  //SendMessage(Handle, WM_EVENT_WT1600, 0,0);
  CommonCommunication(psWT1600);
end;

end.

