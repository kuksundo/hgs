unit UnitComponentIPCMonitorAll_old;

interface

uses
  System.SysUtils, System.Classes, Winapi.Windows, Winapi.messages, Forms,
  ComCtrls, Dialogs,
  NxCustomGridControl, NxCustomGrid, NxGrid, jvStatusBar, ShadowButton,
  UnitFrameIPCConst, janSQL, ModbusComStruct, CommonUtil,
  DeCAL, IPCThrd_LBX, IPCThrdMonitor_LBX,
  IPCThrd_WT1600, IPCThrdMonitor_WT1600, IPCThrd_ECS_kumo, IPCThrdMonitor_ECS_kumo,
  IPCThrd_MEXA7000, IPCThrdMonitor_MEXA7000, IPCThrd_MT210, IPCThrdMonitor_MT210,
  IPCThrd_FlowMeter, IPCThrdMonitor_FlowMeter, IPCThrd_DYNAMO, IPCThrdMonitor_DYNAMO,
  IPCThrd_ECS_AVAT, IPCThrdMonitor_ECS_AVAT, IPCThrd_GasCalc, IPCThrdMonitor_GasCalc,
  HiMECSConst, ConfigOptionClass, EngineParameterClass, TimerPool;

type
  TWatchValue2Screen_AnalogEvent =
    procedure(Name: string; AValue: string; AEPIndex: integer) of object;

  TIPCMonitorAll = class(TComponent)
  private
    FHWnd: HWND;

    FAddressMap: DMap;      //Modbus Map 데이타 저장 구초체

    FECSData_kumo: TEventData_ECS_kumo;
    FECSData_AVAT: TEventData_ECS_AVAT;
    FMEXA7000Data: TEventData_MEXA7000_2;
    FLBXData: TEventData_LBX;
    FWT1600Data: TEventData_WT1600;
    FMT210Data: TEventData_MT210;
    FDYNAMOData: TEventData_DYNAMO;
    FFlowMeterData: TEventData_FlowMeter;
    FGasCalcData: TEventData_GasCalc;

    FIPCMonitor_WT1600: TIPCMonitor_WT1600;//WT1600
    FIPCMonitor_MEXA7000: TIPCMonitor_MEXA7000;//MEXA7000
    FIPCMonitor_MT210: TIPCMonitor_MT210;//MT210
    FIPCMonitor_ECS_kumo: TIPCMonitor_ECS_kumo;//kumo ECS
    FIPCMonitor_ECS_AVAT: TIPCMonitor_ECS_AVAT;//AVAT ECS
    FIPCMonitor_LBX: TIPCMonitor_LBX;//LBX
    FIPCMonitor_FlowMeter: TIPCMonitor_FlowMeter;//FlowMeter
    FIPCMonitor_Dynamo: TIPCMonitor_Dynamo;//DynamoMeter
    FIPCMonitor_GasCalc: TIPCMonitor_GasCalc;//Gas Total

    procedure UpdateTrace_WT1600;
    procedure UpdateTrace_MEXA7000;
    procedure UpdateTrace_MT210;
    procedure UpdateTrace_ECS_kumo;
    procedure UpdateTrace_ECS_AVAT;
    procedure UpdateTrace_LBX;
    procedure UpdateTrace_FlowMeter;
    procedure UpdateTrace_DYNAMO;
    procedure UpdateTrace_GasCalc;

    //WM_COPYDATA message를 받지 못함. Main Form에서 대신 처리
    //procedure WMCopyData(var Msg: TMessage); message WM_COPYDATA;

    procedure SendFormCopyData_(ToHandle: integer; AForm:TForm);
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
    procedure LBX_OnSignal(Sender: TIPCThread_LBX; Data: TEventData_LBX); virtual;
    procedure FlowMeter_OnSignal(Sender: TIPCThread_FlowMeter; Data: TEventData_FlowMeter); virtual;
    procedure DYNAMO_OnSignal(Sender: TIPCThread_DYNAMO; Data: TEventData_DYNAMO); virtual;
    procedure GasCalc_OnSignal(Sender: TIPCThread_GasCalc; Data: TEventData_GasCalc); virtual;

    procedure OverRide_WT1600(AData: TEventData_WT1600); virtual;
    procedure OverRide_MEXA7000(AData: TEventData_MEXA7000_2); virtual;
    procedure OverRide_MT210(AData: TEventData_MT210); virtual;
    procedure OverRide_ECS_kumo(AData: TEventData_ECS_kumo); virtual;
    procedure OverRide_ECS_AVAT(AData: TEventData_ECS_AVAT); virtual;
    procedure OverRide_LBX(AData: TEventData_LBX); virtual;
    procedure OverRide_FlowMeter(AData: TEventData_FlowMeter); virtual;
    procedure OverRide_DYNAMO(AData: TEventData_DYNAMO); virtual;
    procedure OverRide_GasCalc(AData: TEventData_GasCalc); virtual;

    procedure WatchValue2Screen_Analog(Name: string; AValue: string;
                           AEPIndex: integer; AIsFloat: Boolean = false);
    procedure Value2Screen_ECS_kumo(AHiMap: THiMap; AEPIndex: integer; AModbusMode: integer);
    procedure Value2Screen_ECS_AVAT(AHiMap: THiMap; AEPIndex: integer; AModbusMode: integer);

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
    procedure OnSetZeroLBX(Sender : TObject; Handle : Integer;
            Interval : Cardinal; ElapsedTime : LongInt);
    procedure OnSetZeroFlowMeter(Sender : TObject; Handle : Integer;
            Interval : Cardinal; ElapsedTime : LongInt);
    procedure OnSetZeroDYNAMO(Sender : TObject; Handle : Integer;
            Interval : Cardinal; ElapsedTime : LongInt);
    procedure OnSetZeroGasCalc(Sender : TObject; Handle : Integer;
            Interval : Cardinal; ElapsedTime : LongInt);

    //window proc - called by windows to handle messages passed to our hidden window
    procedure WndMethod(var AMsg: TMessage); virtual;
  public
    FWatchValue2Screen_AnalogEvent: TWatchValue2Screen_AnalogEvent;
    FCurrentUserLevel: THiMECSUserLevel;
    FEngineParameter: TEngineParameter;

    //FConfigOption: TConfigOption;
    FModbusMapFileName: string;
    FFilePath: string;      //파일을 저장할 경로
    FCompleteReadMap_Avat,
    FCompleteReadMap_kumo: Boolean; //Map file read 완료 했으면 True

    FStartOnSignal: Boolean; //DSService에서 Engine Parameter를 모두 읽은 후 True

    FNextGrid: TNextGrid;
    FPageControl: TPageControl;
    FStatusBar: TjvStatusBar;

    FIsSetZeroWhenDisconnect: Boolean;// 통신이 일정시간 동안 안되면 0으로
    FPJHTimerPool: TPJHTimerPool;

    procedure InitVar;
    procedure DestroyVar;

    function CreateIPCMonitor(AEP_DragDrop: TEngineParameterItemRecord): integer;
    procedure DestroyIPCMonitor(AIPCMonitor: TParameterSource);

    procedure CreateECSkumoIPCMonitor(AEP_DragDrop: TEngineParameterItemRecord);
    procedure CreateECSAVATIPCMonitor(AEP_DragDrop: TEngineParameterItemRecord);
    procedure CreateWT1600IPCMonitor(AEP_DragDrop: TEngineParameterItemRecord);
    procedure CreateMT210IPCMonitor(AEP_DragDrop: TEngineParameterItemRecord);
    procedure CreateMEXA7000IPCMonitor(AEP_DragDrop: TEngineParameterItemRecord);
    procedure CreateLBXIPCMonitor(AEP_DragDrop: TEngineParameterItemRecord);
    procedure CreateFlowMeterIPCMonitor(AEP_DragDrop: TEngineParameterItemRecord);
    procedure CreateDynamoIPCMonitor(AEP_DragDrop: TEngineParameterItemRecord);
    procedure CreateGasCalcIPCMonitor(AEP_DragDrop: TEngineParameterItemRecord);

    function CreateIPCMonitor_ECS_AVAT(ASharedName: string = ''): String;
    function CreateIPCMonitor_DYNAMO(ASharedName: string = ''): String;
    function CreateIPCMonitor_FlowMeter(ASharedName: string = ''): String;
    function CreateIPCMonitor_LBX(ASharedName: string = ''): String;
    function CreateIPCMonitor_ECS_kumo(ASharedName: string = ''): String;
    function CreateIPCMonitor_MT210(ASharedName: string = ''): String;
    function CreateIPCMonitor_MEXA7000(ASharedName: string = ''): String;
    function CreateIPCMonitor_WT1600(ASharedName: string = ''): String;
    function CreateIPCMonitor_GasCalc(ASharedName: string = ''): String;

    function MoveEngineParameterItemRecord(AEPItemRecord:TEngineParameterItemRecord;
                                   AGrid: TNextGrid = nil): integer; virtual;

    procedure ReadMapAddress(AddressMap: DMap; MapFileName: string);
    procedure SetModbusMapFileName(AFileName: string; APSrc: TParameterSource);

    function CheckUserLevelForWatchListFile(AFileName: string;
                          var AUserLevel: THiMECSUserLevel): Boolean;
    function CheckExeFileNameForWatchListFile(AFileName: string): string;

    procedure DisplayMessage(Msg: string);
    procedure DisplayMessage2SB(AStatusBar: TjvStatusBar; Msg: string);

    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
  published
    //property EngineRPMIndex: integer read FEngineRPMIndex write FEngineRPMIndex;
  end;

procedure Register;

implementation

procedure Register;
begin
  RegisterComponents('Samples', [TIPCMonitorAll]);
end;

{ TIPCMonitorAll }

constructor TIPCMonitorAll.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);

  FHWnd  := AllocateHWnd(WndMethod);

  InitVar;
end;

destructor TIPCMonitorAll.Destroy;
begin
  DeallocateHWnd(FHWnd);

  inherited Destroy;
end;

procedure TIPCMonitorAll.WndMethod(var AMsg: TMessage);
var
  LHandled : Boolean;
begin
  //Assume we handle message
  LHandled := True;

  case AMsg.Msg of
    WM_EVENT_WT1600:UpdateTrace_WT1600;
    WM_EVENT_MEXA7000:UpdateTrace_MEXA7000;
    WM_EVENT_MT210:UpdateTrace_MT210;
    WM_EVENT_ECS_kumo:UpdateTrace_ECS_kumo;
    WM_EVENT_ECS_AVAT:UpdateTrace_ECS_AVAT;
    WM_EVENT_LBX:UpdateTrace_LBX;
    WM_EVENT_FlowMeter:UpdateTrace_FlowMeter;
    WM_EVENT_DYNAMO:UpdateTrace_DYNAMO;
    WM_EVENT_GasCalc:UpdateTrace_GasCalc;
  end;

  if LHandled then
    AMsg.Result := 0
  else
    AMsg.Result := DefWindowProc(FHWnd, AMsg.Msg, AMsg.WParam, AMsg.LParam);
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

  FAddressMap.clear;
  ReadMapAddress(FAddressMap,FModbusMapFileName);//FConfigOption.ModbusFileName);

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

  FAddressMap.clear;
  ReadMapAddress(FAddressMap,FModbusMapFileName);//FConfigOption.ModbusFileName);

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

function TIPCMonitorAll.CreateIPCMonitor(AEP_DragDrop: TEngineParameterItemRecord): integer;
begin
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
  end;
end;

//Result: Created Shared Memory Name
function TIPCMonitorAll.CreateIPCMonitor_DYNAMO(ASharedName: string = ''): String;
begin
  FEngineParameterItemRecord.FParameterSource := psDYNAMO;

  if ASharedName <> '' then
  begin
    FEngineParameterItemRecord.FSharedName := ASharedName;
    Result := ASharedName;
  end
  else
    Result := ParameterSource2SharedMN(FEngineParameterItemRecord.FParameterSource);

  CreateIPCMonitor(FEngineParameterItemRecord);
end;

function TIPCMonitorAll.CreateIPCMonitor_ECS_AVAT(ASharedName: string = ''): String;
begin
  FEngineParameterItemRecord.FParameterSource := psECS_AVAT;

  if ASharedName <> '' then
  begin
    FEngineParameterItemRecord.FSharedName := ASharedName;
    Result := ASharedName;
  end
  else
    Result := ParameterSource2SharedMN(FEngineParameterItemRecord.FParameterSource);

  CreateIPCMonitor(FEngineParameterItemRecord);
end;

function TIPCMonitorAll.CreateIPCMonitor_ECS_kumo(ASharedName: string = ''): String;
begin
  FEngineParameterItemRecord.FParameterSource := psECS_kumo;

  if ASharedName <> '' then
  begin
    FEngineParameterItemRecord.FSharedName := ASharedName;
    Result := ASharedName;
  end
  else
    Result := ParameterSource2SharedMN(FEngineParameterItemRecord.FParameterSource);

  CreateIPCMonitor(FEngineParameterItemRecord);
end;

function TIPCMonitorAll.CreateIPCMonitor_FlowMeter(ASharedName: string = ''): String;
begin
  FEngineParameterItemRecord.FParameterSource := psFlowMeter;

  if ASharedName <> '' then
  begin
    FEngineParameterItemRecord.FSharedName := ASharedName;
    Result := ASharedName;
  end
  else
    Result := ParameterSource2SharedMN(FEngineParameterItemRecord.FParameterSource);

  CreateIPCMonitor(FEngineParameterItemRecord);
end;

function TIPCMonitorAll.CreateIPCMonitor_GasCalc(ASharedName: string = ''): String;
begin
  FEngineParameterItemRecord.FParameterSource := psGasCalculated;

  if ASharedName <> '' then
  begin
    FEngineParameterItemRecord.FSharedName := ASharedName;
    Result := ASharedName;
  end
  else
    Result := ParameterSource2SharedMN(FEngineParameterItemRecord.FParameterSource);

  CreateIPCMonitor(FEngineParameterItemRecord);
end;

function TIPCMonitorAll.CreateIPCMonitor_LBX(ASharedName: string = ''): String;
begin
  FEngineParameterItemRecord.FParameterSource := psLBX;

  if ASharedName <> '' then
  begin
    FEngineParameterItemRecord.FSharedName := ASharedName;
    Result := ASharedName;
  end
  else
    Result := ParameterSource2SharedMN(FEngineParameterItemRecord.FParameterSource);

  CreateIPCMonitor(FEngineParameterItemRecord);
end;

function TIPCMonitorAll.CreateIPCMonitor_MEXA7000(ASharedName: string = ''): String;
begin
  FEngineParameterItemRecord.FParameterSource := psMEXA7000;

  if ASharedName <> '' then
  begin
    FEngineParameterItemRecord.FSharedName := ASharedName;
    Result := ASharedName;
  end
  else
    Result := ParameterSource2SharedMN(FEngineParameterItemRecord.FParameterSource);

  CreateIPCMonitor(FEngineParameterItemRecord);
end;

function TIPCMonitorAll.CreateIPCMonitor_MT210(ASharedName: string = ''): String;
begin
  FEngineParameterItemRecord.FParameterSource := psMT210;

  if ASharedName <> '' then
  begin
    FEngineParameterItemRecord.FSharedName := ASharedName;
    Result := ASharedName;
  end
  else
    Result := ParameterSource2SharedMN(FEngineParameterItemRecord.FParameterSource);

  CreateIPCMonitor(FEngineParameterItemRecord);
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

  if Assigned(FIPCMonitor_ECS_AVAT) then
    FIPCMonitor_ECS_AVAT.OnSignal := nil;

  if Assigned(FIPCMonitor_LBX) then
    FIPCMonitor_LBX.OnSignal := nil;

  if Assigned(FIPCMonitor_Dynamo) then
    FIPCMonitor_Dynamo.OnSignal := nil;

  if Assigned(FIPCMonitor_GasCalc) then
    FIPCMonitor_GasCalc.OnSignal := nil;

  if Assigned(FIPCMonitor_WT1600) and (AIPCMonitor = psWT1600) then
  begin
    FIPCMonitor_WT1600.FMonitorEvent.Pulse;
    FIPCMonitor_WT1600.Terminate;
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

  if Assigned(FIPCMonitor_GasCalc) and (AIPCMonitor = psGasCalculated)  then
  begin
    FIPCMonitor_GasCalc.Suspend;
    FIPCMonitor_GasCalc.FMonitorEvent.Pulse;
    FIPCMonitor_GasCalc.Resume;
    FIPCMonitor_GasCalc.Terminate;
    FIPCMonitor_GasCalc := nil;
  end;
end;

procedure TIPCMonitorAll.DestroyVar;
begin
  FPJHTimerPool.RemoveAll;
  FreeAndNil(FPJHTimerPool);

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
  if not FStartOnSignal then
    exit;

end;

procedure TIPCMonitorAll.ECS_OnSignal_AVAT(Sender: TIPCThread_ECS_AVAT;
  Data: TEventData_ECS_AVAT);
var
  i,dcount: integer;
begin
  if not FStartOnSignal then
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

  UpdateTrace_ECS_AVAT;
end;

procedure TIPCMonitorAll.ECS_OnSignal_kumo(Sender: TIPCThread_ECS_kumo;
  Data: TEventData_ECS_kumo);
var
  i,dcount: integer;
begin
  if not FStartOnSignal then
    exit;

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

  UpdateTrace_ECS_KUMO;
end;

procedure TIPCMonitorAll.FlowMeter_OnSignal(Sender: TIPCThread_FlowMeter;
  Data: TEventData_FlowMeter);
begin
  if not FStartOnSignal then
    exit;
//;
end;

//AAutoStart: True = 프로그램 시작시에 watch file name을 parameter로 입력받는 경우
//            False = LoadFromFile 메뉴로 실행되는 경우
procedure TIPCMonitorAll.GasCalc_OnSignal(Sender: TIPCThread_GasCalc;
  Data: TEventData_GasCalc);
begin
  if not FStartOnSignal then
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

  UpdateTrace_GASCALC;
end;

procedure TIPCMonitorAll.InitVar;
begin
  FAddressMap := DMap.Create;
  //FConfigOption := TConfigOption.Create(nil); FModbusMapFileName 변수로 대체
  FEngineParameter := TEngineParameter.Create(nil);
  FPJHTimerPool := TPJHTimerPool.Create(nil);
  FNextGrid := nil;
  FCompleteReadMap_Avat := False;
  FCompleteReadMap_kumo := False;
  FIsSetZeroWhenDisconnect := True;
  FCurrentUserLevel := HUL_Operator;
  FWatchValue2Screen_AnalogEvent := nil;
  FStartOnSignal := True; //DSService에서는 False 후 .param read 완료 후 True로 됨.
end;

procedure TIPCMonitorAll.LBX_OnSignal(Sender: TIPCThread_LBX; Data: TEventData_LBX);
begin
  if not FStartOnSignal then
    exit;

  FLBXData.ENGRPM := Data.ENGRPM;
  FLBXData.HTTEMP := Data.HTTEMP;
  FLBXData.LOTEMP := Data.LOTEMP;
  FLBXData.TCRPMA := Data.TCRPMA;
  FLBXData.TCRPMB := Data.TCRPMB;
  FLBXData.TCINLETTEMP := Data.TCINLETTEMP;

  UpdateTrace_LBX;
end;

procedure TIPCMonitorAll.MEXA7000_OnSignal(Sender: TIPCThread_MEXA7000;
  Data: TEventData_MEXA7000);
begin
  if not FStartOnSignal then
    exit;

  FMEXA7000Data.CO2 := StrToFloatDef(Data.CO2,0.0);
  FMEXA7000Data.CO_L := StrToFloatDef(Data.CO_L,0.0);
  FMEXA7000Data.O2 := StrToFloatDef(Data.O2,0.0);
  FMEXA7000Data.NOx := StrToFloatDef(Data.NOx,0.0);
  FMEXA7000Data.THC := StrToFloatDef(Data.THC,0.0);
  FMEXA7000Data.CH4 := StrToFloatDef(Data.CH4,0.0);
  FMEXA7000Data.non_CH4 := StrToFloatDef(Data.non_CH4,0.0);
  FMEXA7000Data.CollectedValue := Data.CollectedValue;

  UpdateTrace_MEXA7000;
end;

//추가 또는 수정되는 FEngineParameter.EngineParameterCollectItem의 Index를 반환함
function TIPCMonitorAll.MoveEngineParameterItemRecord(
  AEPItemRecord: TEngineParameterItemRecord; AGrid: TNextGrid = nil): integer;
begin
  Result := CheckExistTagName(AEPItemRecord.FParameterSource,AEPItemRecord.FTagName);

  if Result > -1 then
    exit;

  with FEngineParameter.EngineParameterCollect.Add do
  begin
    LevelIndex := AEPItemRecord.FLevelIndex;
    NodeIndex := AEPItemRecord.FNodeIndex;
    AbsoluteIndex := AEPItemRecord.FAbsoluteIndex;
    MaxValue := AEPItemRecord.FMaxValue;
    MaxValue_real := AEPItemRecord.FMaxValue_real;
    Contact := AEPItemRecord.FContact;

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
  if not FStartOnSignal then
    exit;

  FMT210Data.FData := Data.FData;
  UpdateTrace_MT210;
end;

procedure TIPCMonitorAll.OnSetZeroDYNAMO(Sender: TObject; Handle: Integer;
  Interval: Cardinal; ElapsedTime: Integer);
begin
  FillChar(FDYNAMOData, Sizeof(FDYNAMOData), 0);
end;

procedure TIPCMonitorAll.OnSetZeroECS_AVAT(Sender: TObject; Handle: Integer;
  Interval: Cardinal; ElapsedTime: Integer);
begin
  FillChar(FECSData_AVAT, Sizeof(FECSData_AVAT), 0);
//  ShowMessage('aaa');
end;

procedure TIPCMonitorAll.OnSetZeroECS_kumo(Sender: TObject; Handle: Integer;
  Interval: Cardinal; ElapsedTime: Integer);
begin
  FillChar(FECSData_kumo, Sizeof(FECSData_kumo), 0);
end;

procedure TIPCMonitorAll.OnSetZeroFlowMeter(Sender: TObject; Handle: Integer;
  Interval: Cardinal; ElapsedTime: Integer);
begin
  FillChar(FFlowMeterData, Sizeof(FFlowMeterData), 0);
end;

procedure TIPCMonitorAll.OnSetZeroGasCalc(Sender: TObject; Handle: Integer;
  Interval: Cardinal; ElapsedTime: Integer);
begin
  FillChar(FGasCalcData, Sizeof(FGasCalcData), 0);
end;

procedure TIPCMonitorAll.OnSetZeroLBX(Sender: TObject; Handle: Integer;
  Interval: Cardinal; ElapsedTime: Integer);
begin
  FillChar(FLBXData, Sizeof(FLBXData), 0);
end;

procedure TIPCMonitorAll.OnSetZeroMEXA7000(Sender: TObject; Handle: Integer;
  Interval: Cardinal; ElapsedTime: Integer);
begin
  FillChar(FMEXA7000Data, Sizeof(FMEXA7000Data), 0);
end;

procedure TIPCMonitorAll.OnSetZeroMT210(Sender: TObject; Handle: Integer;
  Interval: Cardinal; ElapsedTime: Integer);
begin
  FillChar(FMT210Data, Sizeof(FMT210Data), 0);
end;

procedure TIPCMonitorAll.OnSetZeroWT1600(Sender: TObject; Handle: Integer;
  Interval: Cardinal; ElapsedTime: Integer);
begin
  FillChar(FWT1600Data, Sizeof(FWT1600Data), 0);
end;

procedure TIPCMonitorAll.OverRide_DYNAMO(AData: TEventData_DYNAMO);
var
  i: integer;
  LDataOk: Boolean;
begin
  for i := 0 to FEngineParameter.EngineParameterCollect.Count - 1 do
  begin
    if FEngineParameter.EngineParameterCollect.Items[i].ParameterSource = psDynamo then
    begin
      if UpperCase(FEngineParameter.EngineParameterCollect.Items[i].TagName) = UpperCase('Power') then
        FEngineParameter.EngineParameterCollect.Items[i].Value := FloatToStr(FDYNAMOData.FPower)
      else if UpperCase(FEngineParameter.EngineParameterCollect.Items[i].TagName) = UpperCase('Torque') then
        FEngineParameter.EngineParameterCollect.Items[i].Value := FloatToStr(FDYNAMOData.FTorque)
      else if UpperCase(FEngineParameter.EngineParameterCollect.Items[i].TagName) = UpperCase('RPM') then
        FEngineParameter.EngineParameterCollect.Items[i].Value := FloatToStr(FDYNAMOData.FRevolution)
      else if UpperCase(FEngineParameter.EngineParameterCollect.Items[i].TagName) = UpperCase('BRG_TB') then
        FEngineParameter.EngineParameterCollect.Items[i].Value := FloatToStr(FDYNAMOData.FBrgTBTemp)
      else if UpperCase(FEngineParameter.EngineParameterCollect.Items[i].TagName) = UpperCase('BRG_MTR') then
        FEngineParameter.EngineParameterCollect.Items[i].Value := FloatToStr(FDYNAMOData.FBrgMTRTemp)
      else if UpperCase(FEngineParameter.EngineParameterCollect.Items[i].TagName) = UpperCase('Inlet1') then
        FEngineParameter.EngineParameterCollect.Items[i].Value := FloatToStr(FDYNAMOData.FInletOpen1)
      else if UpperCase(FEngineParameter.EngineParameterCollect.Items[i].TagName) = UpperCase('Inlet2') then
        FEngineParameter.EngineParameterCollect.Items[i].Value := FloatToStr(FDYNAMOData.FInletOpen2)
      else if UpperCase(FEngineParameter.EngineParameterCollect.Items[i].TagName) = UpperCase('Outlet1') then
        FEngineParameter.EngineParameterCollect.Items[i].Value := FloatToStr(FDYNAMOData.FOutletOpen1)
      else if UpperCase(FEngineParameter.EngineParameterCollect.Items[i].TagName) = UpperCase('Outlet2') then
        FEngineParameter.EngineParameterCollect.Items[i].Value := FloatToStr(FDYNAMOData.FOutletOpen2)
      else if UpperCase(FEngineParameter.EngineParameterCollect.Items[i].TagName) = UpperCase('WaterInlet') then
        FEngineParameter.EngineParameterCollect.Items[i].Value := FloatToStr(FDYNAMOData.FWaterInletTemp)
      else if UpperCase(FEngineParameter.EngineParameterCollect.Items[i].TagName) = UpperCase('WaterOutlet') then
        FEngineParameter.EngineParameterCollect.Items[i].Value := FloatToStr(FDYNAMOData.FWaterOutletTemp)
      else if UpperCase(FEngineParameter.EngineParameterCollect.Items[i].TagName) = UpperCase('Body1') then
        FEngineParameter.EngineParameterCollect.Items[i].Value := FloatToStr(FDYNAMOData.FBody1Press)
      else if UpperCase(FEngineParameter.EngineParameterCollect.Items[i].TagName) = UpperCase('Body2') then
        FEngineParameter.EngineParameterCollect.Items[i].Value := FloatToStr(FDYNAMOData.FBody2Press)
      else if UpperCase(FEngineParameter.EngineParameterCollect.Items[i].TagName) = UpperCase('WaterSupply') then
        FEngineParameter.EngineParameterCollect.Items[i].Value := FloatToStr(FDYNAMOData.FWaterSupply)
      else if UpperCase(FEngineParameter.EngineParameterCollect.Items[i].TagName) = UpperCase('OilPress') then
        FEngineParameter.EngineParameterCollect.Items[i].Value := FloatToStr(FDYNAMOData.FOilPress);

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
  i: integer;
  LDouble: double;
begin
  for i := 0 to FEngineParameter.EngineParameterCollect.Count - 1 do
  begin
    if FEngineParameter.EngineParameterCollect.Items[i].ParameterSource = psGasCalculated then
    begin
      if UpperCase(FEngineParameter.EngineParameterCollect.Items[i].TagName) = UpperCase('SVP') then
        FEngineParameter.EngineParameterCollect.Items[i].Value := FloatToStr(FGasCalcData.FSVP)
      else if UpperCase(FEngineParameter.EngineParameterCollect.Items[i].TagName) = UpperCase('IAH2') then
        FEngineParameter.EngineParameterCollect.Items[i].Value := FloatToStr(FGasCalcData.FIAH2)
      else if UpperCase(FEngineParameter.EngineParameterCollect.Items[i].TagName) = UpperCase('UFC') then
        FEngineParameter.EngineParameterCollect.Items[i].Value := FloatToStr(FGasCalcData.FUFC)
      else if UpperCase(FEngineParameter.EngineParameterCollect.Items[i].TagName) = UpperCase('NhtCF') then
        FEngineParameter.EngineParameterCollect.Items[i].Value := FloatToStr(FGasCalcData.FNhtCF)
      else if UpperCase(FEngineParameter.EngineParameterCollect.Items[i].TagName) = UpperCase('DWCFE') then
        FEngineParameter.EngineParameterCollect.Items[i].Value := FloatToStr(FGasCalcData.FDWCFE)
      else if UpperCase(FEngineParameter.EngineParameterCollect.Items[i].TagName) = UpperCase('EGF') then
        FEngineParameter.EngineParameterCollect.Items[i].Value := FloatToStr(FGasCalcData.FEGF)
      else if UpperCase(FEngineParameter.EngineParameterCollect.Items[i].TagName) = UpperCase('NOxAtO213') then
        FEngineParameter.EngineParameterCollect.Items[i].Value := FloatToStr(FGasCalcData.FNOxAtO213)
      else if UpperCase(FEngineParameter.EngineParameterCollect.Items[i].TagName) = UpperCase('NOx') then
        FEngineParameter.EngineParameterCollect.Items[i].Value := FloatToStr(FGasCalcData.FNOx)
      else if UpperCase(FEngineParameter.EngineParameterCollect.Items[i].TagName) = UpperCase('AF1') then
        FEngineParameter.EngineParameterCollect.Items[i].Value := FloatToStr(FGasCalcData.FAF1)
      else if UpperCase(FEngineParameter.EngineParameterCollect.Items[i].TagName) = UpperCase('AF2') then
        FEngineParameter.EngineParameterCollect.Items[i].Value := FloatToStr(FGasCalcData.FAF2)
      else if UpperCase(FEngineParameter.EngineParameterCollect.Items[i].TagName) = UpperCase('AF3') then
        FEngineParameter.EngineParameterCollect.Items[i].Value := FloatToStr(FGasCalcData.FAF3)
      else if UpperCase(FEngineParameter.EngineParameterCollect.Items[i].TagName) = UpperCase('AF_Measured') then
        FEngineParameter.EngineParameterCollect.Items[i].Value := FloatToStr(FGasCalcData.FAF_Measured)
      else if UpperCase(FEngineParameter.EngineParameterCollect.Items[i].TagName) = UpperCase('MT210') then
        FEngineParameter.EngineParameterCollect.Items[i].Value := FloatToStr(FGasCalcData.FMT210)
      else if UpperCase(FEngineParameter.EngineParameterCollect.Items[i].TagName) = UpperCase('FC') then
        FEngineParameter.EngineParameterCollect.Items[i].Value := FloatToStr(FGasCalcData.FFC)
      else if UpperCase(FEngineParameter.EngineParameterCollect.Items[i].TagName) = UpperCase('EngineOutput') then
        FEngineParameter.EngineParameterCollect.Items[i].Value := FloatToStr(FGasCalcData.FEngineOutput)
      else if UpperCase(FEngineParameter.EngineParameterCollect.Items[i].TagName) = UpperCase('GeneratorOutput') then
        FEngineParameter.EngineParameterCollect.Items[i].Value := FloatToStr(FGasCalcData.FGeneratorOutput)
      else if UpperCase(FEngineParameter.EngineParameterCollect.Items[i].TagName) = UpperCase('EngineLoad') then
        FEngineParameter.EngineParameterCollect.Items[i].Value := FloatToStr(FGasCalcData.FEngineLoad)
      else if UpperCase(FEngineParameter.EngineParameterCollect.Items[i].TagName) = UpperCase('GenEfficiency') then
        FEngineParameter.EngineParameterCollect.Items[i].Value := FloatToStr(FGasCalcData.FGenEfficiency)
      else if UpperCase(FEngineParameter.EngineParameterCollect.Items[i].TagName) = UpperCase('BHP') then
        FEngineParameter.EngineParameterCollect.Items[i].Value := FloatToStr(FGasCalcData.FBHP)
      else if UpperCase(FEngineParameter.EngineParameterCollect.Items[i].TagName) = UpperCase('BMEP') then
        FEngineParameter.EngineParameterCollect.Items[i].Value := FloatToStr(FGasCalcData.FBMEP)
      else if UpperCase(FEngineParameter.EngineParameterCollect.Items[i].TagName) = UpperCase('Lamda_Calculated') then
        FEngineParameter.EngineParameterCollect.Items[i].Value := FloatToStr(FGasCalcData.FLamda_Calculated)
      else if UpperCase(FEngineParameter.EngineParameterCollect.Items[i].TagName) = UpperCase('Lamda_Measured') then
        FEngineParameter.EngineParameterCollect.Items[i].Value := FloatToStr(FGasCalcData.FLamda_Measured)
      else if UpperCase(FEngineParameter.EngineParameterCollect.Items[i].TagName) = UpperCase('Lamda_Brettschneider') then
        FEngineParameter.EngineParameterCollect.Items[i].Value := FloatToStr(FGasCalcData.FLamda_Brettschneider)
      else if UpperCase(FEngineParameter.EngineParameterCollect.Items[i].TagName) = UpperCase('AFRatio_Calculated') then
        FEngineParameter.EngineParameterCollect.Items[i].Value := FloatToStr(FGasCalcData.FAFRatio_Calculated)
      else if UpperCase(FEngineParameter.EngineParameterCollect.Items[i].TagName) = UpperCase('AFRatio_Measured') then
        FEngineParameter.EngineParameterCollect.Items[i].Value := FloatToStr(FGasCalcData.FAFRatio_Measured)
      else if UpperCase(FEngineParameter.EngineParameterCollect.Items[i].TagName) = UpperCase('ExhTempAvg') then
        FEngineParameter.EngineParameterCollect.Items[i].Value := FloatToStr(FGasCalcData.FExhTempAvg)
      else if UpperCase(FEngineParameter.EngineParameterCollect.Items[i].TagName) = UpperCase('WasteGatePosition') then
        FEngineParameter.EngineParameterCollect.Items[i].Value := FloatToStr(FGasCalcData.FWasteGatePosition)
      else if UpperCase(FEngineParameter.EngineParameterCollect.Items[i].TagName) = UpperCase('ThrottlePosition') then
        FEngineParameter.EngineParameterCollect.Items[i].Value := FloatToStr(FGasCalcData.FThrottlePosition)
      else if UpperCase(FEngineParameter.EngineParameterCollect.Items[i].TagName) = UpperCase('Density') then
        FEngineParameter.EngineParameterCollect.Items[i].Value := FloatToStr(FGasCalcData.FDensity)
      else if UpperCase(FEngineParameter.EngineParameterCollect.Items[i].TagName) = UpperCase('LCV') then
        FEngineParameter.EngineParameterCollect.Items[i].Value := FloatToStr(FGasCalcData.FLCV)
      else if UpperCase(FEngineParameter.EngineParameterCollect.Items[i].TagName) = UpperCase('BoostPress') then
        FEngineParameter.EngineParameterCollect.Items[i].Value := FloatToStr(FGasCalcData.FBoostPress);

      WatchValue2Screen_Analog('', '',i);
    end;
  end;//for
end;

procedure TIPCMonitorAll.OverRide_LBX(AData: TEventData_LBX);
var
  i: integer;
  LDouble: double;
  LDataOk: Boolean;
begin
  LDataOk := False;

  for i := 0 to FEngineParameter.EngineParameterCollect.Count - 1 do
  begin
    if FEngineParameter.EngineParameterCollect.Items[i].ParameterSource = psLBX then
    begin
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
  i: integer;
  LDataOk: Boolean;
begin
  for i := 0 to FEngineParameter.EngineParameterCollect.Count - 1 do
  begin
    if FEngineParameter.EngineParameterCollect.Items[i].ParameterSource = psMEXA7000 then
    begin
      if UpperCase(FEngineParameter.EngineParameterCollect.Items[i].TagName) = UpperCase('CO2') then
        FEngineParameter.EngineParameterCollect.Items[i].Value := FloatToStr(FMEXA7000Data.CO2/10000)
      else if UpperCase(FEngineParameter.EngineParameterCollect.Items[i].TagName) = UpperCase('CO_L') then
        FEngineParameter.EngineParameterCollect.Items[i].Value := FloatToStr(FMEXA7000Data.CO_L)
      else if UpperCase(FEngineParameter.EngineParameterCollect.Items[i].TagName) = UpperCase('O2') then
        FEngineParameter.EngineParameterCollect.Items[i].Value := FloatToStr(FMEXA7000Data.O2/10000)
      else if UpperCase(FEngineParameter.EngineParameterCollect.Items[i].TagName) = UpperCase('NOx') then
        FEngineParameter.EngineParameterCollect.Items[i].Value := FloatToStr(FMEXA7000Data.NOx)
      else if UpperCase(FEngineParameter.EngineParameterCollect.Items[i].TagName) = UpperCase('THC') then
        FEngineParameter.EngineParameterCollect.Items[i].Value := FloatToStr(FMEXA7000Data.THC)
      else if UpperCase(FEngineParameter.EngineParameterCollect.Items[i].TagName) = UpperCase('CH4') then
        FEngineParameter.EngineParameterCollect.Items[i].Value := FloatToStr(FMEXA7000Data.CH4)
      else if UpperCase(FEngineParameter.EngineParameterCollect.Items[i].TagName) = UpperCase('non_CH4') then
        FEngineParameter.EngineParameterCollect.Items[i].Value := FloatToStr(FMEXA7000Data.non_CH4)
      else if UpperCase(FEngineParameter.EngineParameterCollect.Items[i].TagName) = UpperCase('CollectedValue') then
        FEngineParameter.EngineParameterCollect.Items[i].Value := FloatToStr(FMEXA7000Data.CollectedValue);

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
  i: integer;
  LDataOk: Boolean;
begin
  LDataOk := False;

  for i := 0 to FEngineParameter.EngineParameterCollect.Count - 1 do
  begin
    if FEngineParameter.EngineParameterCollect.Items[i].ParameterSource = psMT210 then
    begin
      FEngineParameter.EngineParameterCollect.Items[i].Value := FloatToStr(FMT210Data.FData);
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

procedure TIPCMonitorAll.OverRide_WT1600(AData: TEventData_WT1600);
var
  i: integer;
  LDouble: double;
  LDataOk: boolean;
begin
  LDataOk := False;

  for i := 0 to FEngineParameter.EngineParameterCollect.Count - 1 do
  begin
    if FEngineParameter.EngineParameterCollect.Items[i].ParameterSource = psWT1600 then
    begin
      if UpperCase(FEngineParameter.EngineParameterCollect.Items[i].TagName) = UpperCase('PSIGMA') then
      begin
        LDouble := StrToFloatDef(FWT1600Data.PSIGMA,0.0);
        FEngineParameter.EngineParameterCollect.Items[i].Value := Format('%.2f', [LDouble/1000]);
      end
      else if UpperCase(FEngineParameter.EngineParameterCollect.Items[i].TagName) = UpperCase('SSIGMA') then
      begin
        LDouble := StrToFloatDef(FWT1600Data.SSIGMA,0.0);
        FEngineParameter.EngineParameterCollect.Items[i].Value := Format('%.2f', [LDouble/1000]);
      end
      else if UpperCase(FEngineParameter.EngineParameterCollect.Items[i].TagName) = UpperCase('QSIGMA') then
      begin
        LDouble := StrToFloatDef(FWT1600Data.QSIGMA,0.0);
        FEngineParameter.EngineParameterCollect.Items[i].Value := Format('%.2f', [LDouble/1000]);
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

procedure TIPCMonitorAll.ReadMapAddress(AddressMap: DMap; MapFileName: string);
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
    if MapFilePath = '' then
      MapFilePath := '.\';

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

procedure TIPCMonitorAll.SendFormCopyData_(ToHandle: integer; AForm: TForm);
var
  cd : TCopyDataStruct;
begin
  with cd do
  begin
    //dwData := Handle;
    cbData := sizeof(AForm);
    lpData := @AForm;
  end;//with

  //SendMessage(ToHandle, WM_COPYDATA, 0, LongInt(@cd));
end;

procedure TIPCMonitorAll.SetModbusMapFileName(AFileName: string;
  APSrc: TParameterSource);
begin
  if Assigned(FIPCMonitor_ECS_kumo) or Assigned(FIPCMonitor_ECS_AVAT) then
  begin
    FModbusMapFileName := AFileName;
    FAddressMap.clear;
    ReadMapAddress(FAddressMap,AFileName);
  end;
end;

procedure TIPCMonitorAll.UpdateTrace_DYNAMO;
begin
  if FIsSetZeroWhenDisconnect then
    FPJHTimerPool.AddOneShot(OnSetZeroDYNAMO,5000);

  OverRide_DYNAMO(FDYNAMOData);
end;

procedure TIPCMonitorAll.UpdateTrace_ECS_AVAT;
begin
  if FIsSetZeroWhenDisconnect then
    FPJHTimerPool.AddOneShot(OnSetZeroECS_AVAT,5000);

  OverRide_ECS_AVAT(FECSData_AVAT);
end;

procedure TIPCMonitorAll.UpdateTrace_ECS_kumo;
begin
  if FIsSetZeroWhenDisconnect then
    FPJHTimerPool.AddOneShot(OnSetZeroECS_kumo,5000);

  OverRide_ECS_kumo(FECSData_kumo);
end;

procedure TIPCMonitorAll.UpdateTrace_FlowMeter;
begin
  if FIsSetZeroWhenDisconnect then
    FPJHTimerPool.AddOneShot(OnSetZeroFlowMeter,5000);

  OverRide_FlowMeter(FFlowMeterData);
end;

procedure TIPCMonitorAll.UpdateTrace_GasCalc;
begin
  if FIsSetZeroWhenDisconnect then
    FPJHTimerPool.AddOneShot(OnSetZeroGasCalc,5000);

  OverRide_GasCalc(FGasCalcData);
end;

procedure TIPCMonitorAll.UpdateTrace_LBX;
begin
  if FIsSetZeroWhenDisconnect then
    FPJHTimerPool.AddOneShot(OnSetZeroLBX,5000);

  OverRide_LBX(FLBXData);
end;

procedure TIPCMonitorAll.UpdateTrace_MEXA7000;
begin
  if FIsSetZeroWhenDisconnect then
    FPJHTimerPool.AddOneShot(OnSetZeroMEXA7000,5000);

  OverRide_MEXA7000(FMEXA7000Data);
end;

procedure TIPCMonitorAll.UpdateTrace_MT210;
begin
  if FIsSetZeroWhenDisconnect then
    FPJHTimerPool.AddOneShot(OnSetZeroMT210,5000);

  OverRide_MT210(FMT210Data);
end;

procedure TIPCMonitorAll.UpdateTrace_WT1600;
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
    if Assigned(FPageControl) then
    begin
      case FPageControl.ActivePageIndex of
        1: begin //Items
          //for i := 0 to FEngineParameter.EngineParameterCollect.Count - 1 do
          //begin
            FNextGrid.CellsByName['Value', AEPIndex] := FEngineParameter.EngineParameterCollect.Items[AEPIndex].Value;
            //FNextGrid.Cell[1, AEPIndex].AsString := FEngineParameter.EngineParameterCollect.Items[AEPIndex].Value;
          //end;
        end;
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
  if not FStartOnSignal then
    exit;

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

  UpdateTrace_WT1600;

end;

end.
