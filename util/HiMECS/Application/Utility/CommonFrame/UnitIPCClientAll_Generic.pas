unit UnitIPCClientAll_Generic;
{
  ParameterSource 추가 시 수정해야 하는 내용>--
    procedure CreateECSComAPIPCClient(ASharedName: string = ''); 함수 추가
    FIPCClient_ECS_ComAP2: TIPCClient<TEventData_Modbus_Standard>; 변수 추가
    procedure PulseEventData_ECS_ComAP2(AData: TEventData_Modbus_Standard); 함수 추가
    procedure PulseEventData(AData: TEventData_Modbus_Standard); 에서 내용 수정
   --<
이 유닛은 FEngineParameter의 value만 저장함.
}

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, IPC_LBX_Const, IPC_WT1600_Const, IPC_ECS_kumo_Const, IPC_MEXA7000_Const,
  IPC_MT210_Const, IPC_DYNAMO_Const, IPC_ECS_AVAT_Const, IPC_GasCalc_Const,
  IPC_Kral_Const, IPC_ECS_Woodward_Const, IPC_PLC_S7_Const, IPC_FlowMeter_Const,
  IPC_EngineParam_Const, IPC_HIC_Const, IPC_Modbus_Standard_Const, IPC_PMS_Const,
  HiMECSConst, EngineParameterClass, IPCThrdClient_Generic;

type
  TIPCClientAll<T> = class(TObject)
  private
    procedure AddIPCClientList(ASharedName: string; AParamSource:TParameterSource);

    procedure CreateIPCClient(ASharedName: string = '');
    procedure PulseEventData_WT1600(AData: TEventData_Modbus_Standard);
  protected
    FEventName: string;
  public
    FIPCClientList: TStringList;
    FEngineParameter: TEngineParameter;
    FEngineParameterItemRecord: TEngineParameterItemRecord; //Save폼에 값 전달시 사용
    FProjNo, FEngNo: string;

    FIPCClient: TIPCClient<T>;

//    FIPCClient_WT1600: TIPCClient<TEventData_WT1600>;//WT1600
//    FIPCClient_MEXA7000: TIPCClient<TEventData_MEXA7000_2>;//MEXA7000
//    FIPCClient_MT210: TIPCClient<TEventData_MT210>;//MT210
//    FIPCClient_ECS_kumo: TIPCClient<TEventData_ECS_kumo>;//kumo ECS
//    FIPCClient_ECS_AVAT: TIPCClient<TEventData_ECS_AVAT>;//AVAT ECS
//    FIPCClient_ECS_Woodward: TIPCClient<TEventData_ECS_Woodward>;//Woodward(AtlasII) ECS
//    FIPCClient_LBX: TIPCClient<TEventData_LBX>;//LBX
//    FIPCClient_FlowMeter: TIPCClient<TEventData_FlowMeter>;//FlowMeter
//    FIPCClient_Dynamo: TIPCClient<TEventData_DYNAMO>;//DynamoMeter
//    FIPCClient_GasCalc: TIPCClient<TEventData_GasCalc>;//Gas Total
//    FIPCClient_KRAL: TIPCClient<TEventData_Modbus_Standard>;//FlowMeter(KRAL)
//    FIPCClient_PLC_S7: TIPCClient<TEventData_PLC_S7>;//Siemens PLC S7-300
//    FIPCClient_EngineParam: TIPCClient<TEventData_EngineParam>;//Engine Parameter file
//    FIPCClient_HIC: TIPCClient<TEventData_HIC>;//Hybrid Injector Controller
//    FIPCClient_PLC_Modbus: TIPCClient<TEventData_Modbus_Standard>;//PLC Modbus
//    FIPCClient_PMSOPC: TIPCClient<TEventData_PMS>;//PMS OPC
//    FIPCClient_ECS_ComAP: TIPCClient<TEventData_Modbus_Standard>;//ComAP ECS
//    FIPCClient_ECS_ComAP2: TIPCClient<TEventData_Modbus_Standard>;//ComAP ECS

    constructor Create;
    destructor Destroy;
    procedure InitVar;
    procedure ReadAddressFromParamFile(AFileName: string;
      AEncrypt: Bool = False; AFileFormat: integer = 1);
    function GetEventName: string;
    function GetEngineName: string;

    procedure CreateIPCClient(APS: TParameterSource; ASharedName: string = '');
    procedure DestroyIPCClient(AIPCClient: TParameterSource);
    procedure CreateIPCClientFromParam;
    procedure CreateIPCClientAll;

    procedure PulseEventData<T>(AData: T);
    procedure PulseEventData_ECS_kumo<T>(AData: T);
    procedure PulseEventData_ECS_AVAT<T>(AData: T);
    procedure PulseEventData_ECS_Woodward<T>(AData: T);
//    procedure PulseEventData_WT1600<T>(AData: T);
    procedure PulseEventData_MEXA7000<T>(AData: T);
    procedure PulseEventData_MT210<T>(AData: T);
    procedure PulseEventData_LBX<T>(AData: T);
    procedure PulseEventData_FlowMeter<T>(AData: T);
    procedure PulseEventData_Dynamo<T>(AData: T);
    procedure PulseEventData_GasCalc<T>(AData: T);
    procedure PulseEventData_KRAL<T>(AData: T);
    procedure PulseEventData_PLC_S7<T>(AData: T);
    procedure PulseEventData_EngineParam<T>(AData: T);
    procedure PulseEventData_HIC<T>(AData: T);
    procedure PulseEventData_PLC_Modbus<T>(AData: T);
    procedure PulseEventData_PMSOPC<T>(AData: T);
    procedure PulseEventData_ECS_ComAP<T>(AData: T);
    procedure PulseEventData_ECS_ComAP2<T>(AData: T);
//    procedure PulseEventData(AData: TEventData_Modbus_Standard);
//    procedure PulseEventData_ECS_kumo(AData: TEventData_Modbus_Standard);
//    procedure PulseEventData_ECS_AVAT(AData: TEventData_Modbus_Standard);
//    procedure PulseEventData_ECS_Woodward(AData: TEventData_Modbus_Standard);
//    procedure PulseEventData_WT1600(AData: TEventData_Modbus_Standard);
//    procedure PulseEventData_MEXA7000(AData: TEventData_MEXA7000_2);
//    procedure PulseEventData_MT210(AData: TEventData_Modbus_Standard);
//    procedure PulseEventData_LBX(AData: TEventData_Modbus_Standard);
//    procedure PulseEventData_FlowMeter(AData: TEventData_Modbus_Standard);
//    procedure PulseEventData_Dynamo(AData: TEventData_Modbus_Standard);
//    procedure PulseEventData_GasCalc(AData: TEventData_Modbus_Standard);
//    procedure PulseEventData_KRAL(AData: TEventData_Modbus_Standard);
//    procedure PulseEventData_PLC_S7(AData: TEventData_Modbus_Standard);
//    procedure PulseEventData_EngineParam(AData: TEventData_EngineParam);
//    procedure PulseEventData_HIC(AData: TEventData_Modbus_Standard);
//    procedure PulseEventData_PLC_Modbus(AData: TEventData_Modbus_Standard);
//    procedure PulseEventData_PMSOPC(AData: TEventData_PMS);
//    procedure PulseEventData_ECS_ComAP(AData: TEventData_Modbus_Standard);
//    procedure PulseEventData_ECS_ComAP2(AData: TEventData_Modbus_Standard);
  end;

implementation

procedure TIPCClientAll.AddIPCClientList(ASharedName: string;
  AParamSource:TParameterSource);
begin
  if FIPCClientList.IndexOf(ASharedName) = -1 then
  begin
    FIPCClientList.AddObject(ASharedName, TObject(AParamSource));
  end;
end;

constructor TIPCClientAll.Create;
begin
  InitVar;
end;

procedure TIPCClientAll.CreateIPCClient(APS: TParameterSource; ASharedName: string);
begin
  case TParameterSource(APS) of
    psECS_kumo: CreateECSkumoIPCClient(ASharedName);
    psECS_AVAT: CreateECSAVATIPCClient(ASharedName);
    psMT210: CreateMT210IPCClient(ASharedName);
    psMEXA7000: CreateMEXA7000IPCClient(ASharedName);
    psLBX: CreateLBXIPCClient(ASharedName);
    psFlowMeter: CreateFlowMeterIPCClient(ASharedName);
    psWT1600: CreateWT1600IPCClient(ASharedName);
    psGasCalculated: CreateGasCalcIPCClient(ASharedName);
    psECS_Woodward: CreateWoodwardIPCClient(ASharedName);
    psFlowMeterKral: CreateKRALIPCClient(ASharedName);
    psDynamo: CreateDynamoIPCClient(ASharedName);
    psPLC_S7: CreatePLCS7IPCClient(ASharedName);
    psHIC: CreateHICIPCClient(ASharedName);
    psEngineParam: CreateEngineParamIPCClient(ASharedName);
    psPLC_Modbus: CreatePLCModbusIPCClient(ASharedName);
    psPMSOPC: CreatePMSOPCIPCClient(ASharedName);
    psECS_ComAP: CreateECSComAPIPCClient(ASharedName);
    psECS_ComAP2: CreateECSComAPIPCClient2(ASharedName);
  else
    AddIPCClientList('UnKnown Parameter Source.', psUnKnown);
  end;
end;

procedure TIPCClientAll.CreateIPCClientAll;
var
  i: integer;
  LPS: TParameterSource;
  LStr, LSN: string;
begin
  for i := 0 to FEngineParameter.EngineParameterCollect.Count - 1 do
  begin
    LPS := FEngineParameter.EngineParameterCollect.Items[i].ParameterSource;

    if FEngineParameter.EngineParameterCollect.Items[i].SharedName = '' then
      LStr := ParameterSource2String(LPS)
    else
      LStr := FEngineParameter.EngineParameterCollect.Items[i].SharedName;

    //List에 없으면 생성
    if FIPCClientList.IndexOf(LStr) = -1 then
    begin
      LSN := FEngineParameter.EngineParameterCollect.Items[i].SharedName;

      if LSN = '' then
        LSN := ParameterSource2SharedMN(LPS);

      CreateIPCClient(LPS, LSN);
    end;
  end;
end;

destructor TIPCClientAll.Destroy;
var
  i: integer;
begin
  for i := 0 to FIPCClientList.Count - 1 do
    FIPCClientList.Objects[i].Free;

  FIPCClientList.Free;
  FEngineParameter.EngineParameterCollect.Clear;
  FreeAndNil(FEngineParameter);
end;

procedure TIPCClientAll.DestroyIPCClient(AIPCClient: TParameterSource);
begin
  if Assigned(FIPCClient) and (AIPCClient = psWT1600) then
  begin
    FIPCClient.Free;
  end;
end;

function TIPCClientAll.GetEngineName: string;
begin

end;

function TIPCClientAll.GetEventName: string;
begin
  Result := FEventName;
end;

procedure TIPCClientAll.InitVar;
begin
  FEngineParameter := TEngineParameter.Create(nil);
  FIPCClientList := TStringList.Create;
end;

//procedure TIPCClientAll.PulseEventData(AData: TEventData_Modbus_Standard);
//var
//  i: integer;
//  LParamSource:TParameterSource;
//begin
//  for i := 0 to FIPCClientList.Count - 1 do
//  begin
//    LParamSource := TParameterSource(FIPCClientList.Objects[i]);
//
//    case TParameterSource(LParamSource) of
//      psECS_kumo: PulseEventData_ECS_kumo(AData);
//      psECS_AVAT: PulseEventData_ECS_AVAT(AData);
//      psMT210: PulseEventData_MT210(AData);
////      psMEXA7000: PulseEventData_MEXA7000(AData); Mexa7000은 통신 프로그램에서 PulseMonitor 함수를 직접 호출 함
//      psLBX: PulseEventData_LBX(AData);
//      psFlowMeter: PulseEventData_FlowMeter(AData);
//      psWT1600: PulseEventData_WT1600(AData);
//      psGasCalculated: PulseEventData_GasCalc(AData);
//      psECS_Woodward: PulseEventData_ECS_Woodward(AData);
//      psFlowMeterKral: PulseEventData_Kral(AData);
//      psDynamo: PulseEventData_Dynamo(AData);
//      psPLC_S7: PulseEventData_PLC_S7(AData);
//      psHIC: PulseEventData_HIC(AData);
////      psEngineParam: PulseEventData_EngineParam(AData);
//      psPLC_Modbus: PulseEventData_PLC_Modbus(AData);
////      psPMSOPC: PulseEventData_PMSOPC(AData);
//      psECS_ComAP: PulseEventData_ECS_ComAP(AData);
//      psECS_ComAP2: PulseEventData_ECS_ComAP2(AData);
//    else
//      ;
//    end;
//  end;
//
//end;

procedure TIPCClientAll.PulseEventData<T>(AData: T);
var
  i: integer;
  LParamSource:TParameterSource;
begin
  for i := 0 to FIPCClientList.Count - 1 do
  begin
    LParamSource := TParameterSource(FIPCClientList.Objects[i]);

    case TParameterSource(LParamSource) of
      psECS_kumo: PulseEventData_ECS_kumo<T>(AData);
      psECS_AVAT: PulseEventData_ECS_AVAT<T>(AData);
      psMT210: PulseEventData_MT210<T>(AData);
//      psMEXA7000: PulseEventData_MEXA7000<T>(AData); Mexa7000은 통신 프로그램에서 PulseMonitor 함수를 직접 호출 함
      psLBX: PulseEventData_LBX<T>(AData);
      psFlowMeter: PulseEventData_FlowMeter<T>(AData);
//      psWT1600: PulseEventData_WT1600<T>(AData);
      psGasCalculated: PulseEventData_GasCalc<T>(AData);
      psECS_Woodward: PulseEventData_ECS_Woodward<T>(AData);
      psFlowMeterKral: PulseEventData_Kral<T>(AData);
      psDynamo: PulseEventData_Dynamo<T>(AData);
      psPLC_S7: PulseEventData_PLC_S7<T>(AData);
      psHIC: PulseEventData_HIC<T>(AData);
//      psEngineParam: PulseEventData_EngineParam<T>(AData);
      psPLC_Modbus: PulseEventData_PLC_Modbus<T>(AData);
//      psPMSOPC: PulseEventData_PMSOPC<T>(AData);
      psECS_ComAP: PulseEventData_ECS_ComAP<T>(AData);
      psECS_ComAP2: PulseEventData_ECS_ComAP2<T>(AData);
    else
      ;
    end;
  end;
end;

//procedure TIPCClientAll.PulseEventData_Dynamo(
//  AData: TEventData_Modbus_Standard);
//var
//  LEventData: TEventData_DYNAMO;
//begin
//  System.Move(AData, LEventData, Sizeof(LEventData));
//  FIPCClient_Dynamo.PulseMonitor(LEventData);
//end;
//
//procedure TIPCClientAll.PulseEventData_ECS_AVAT(
//  AData: TEventData_Modbus_Standard);
//var
//  LEventData: TEventData_ECS_AVAT;
//begin
//  System.Move(AData, LEventData, Sizeof(LEventData));
//  FIPCClient_ECS_AVAT.PulseMonitor(LEventData);
//end;
//
//procedure TIPCClientAll.PulseEventData_ECS_ComAP(
//  AData: TEventData_Modbus_Standard);
//var
//  LEventData: TEventData_Modbus_Standard;
//begin
//  System.Move(AData, LEventData, Sizeof(LEventData));
//  FIPCClient_ECS_ComAP.PulseMonitor(LEventData);
//end;
//
//procedure TIPCClientAll.PulseEventData_ECS_ComAP2(
//  AData: TEventData_Modbus_Standard);
//var
//  LEventData: TEventData_Modbus_Standard;
//begin
//  System.Move(AData, LEventData, Sizeof(LEventData));
//  FIPCClient_ECS_ComAP2.PulseMonitor(LEventData);
//end;
//
//procedure TIPCClientAll.PulseEventData_ECS_kumo(
//  AData: TEventData_Modbus_Standard);
//var
//  LEventData: TEventData_ECS_kumo;
//begin
//  System.Move(AData, LEventData, Sizeof(LEventData));
//  FIPCClient_ECS_kumo.PulseMonitor(LEventData);
//end;
//
//procedure TIPCClientAll.PulseEventData_ECS_Woodward(
//  AData: TEventData_Modbus_Standard);
//var
//  LEventData: TEventData_ECS_Woodward;
//begin
//  System.Move(AData, LEventData, Sizeof(LEventData));
//  FIPCClient_ECS_Woodward.PulseMonitor(LEventData);
//end;
//
//procedure TIPCClientAll.PulseEventData_EngineParam(
//  AData: TEventData_EngineParam);
//var
//  LEventData: TEventData_EngineParam;
//begin
////  System.Move(AData, LEventData, Sizeof(LEventData));
//  FIPCClient_EngineParam.PulseMonitor(AData);
//end;
//
//procedure TIPCClientAll.PulseEventData_FlowMeter(
//  AData: TEventData_Modbus_Standard);
//var
//  LEventData: TEventData_FlowMeter;
//begin
//  System.Move(AData, LEventData, Sizeof(LEventData));
//  FIPCClient_FlowMeter.PulseMonitor(LEventData);
//end;
//
//procedure TIPCClientAll.PulseEventData_GasCalc(
//  AData: TEventData_Modbus_Standard);
//var
//  LEventData: TEventData_GasCalc;
//begin
//  System.Move(AData, LEventData, Sizeof(LEventData));
//  FIPCClient_GasCalc.PulseMonitor(LEventData);
//end;
//
//procedure TIPCClientAll.PulseEventData_HIC(AData: TEventData_Modbus_Standard);
//var
//  LEventData: TEventData_HIC;
//begin
//  System.Move(AData, LEventData, Sizeof(LEventData));
//  FIPCClient_HIC.PulseMonitor(LEventData);
//end;
//
//procedure TIPCClientAll.PulseEventData_KRAL(AData: TEventData_Modbus_Standard);
//var
//  LEventData: TEventData_Modbus_Standard;
//begin
//  System.Move(AData, LEventData, Sizeof(LEventData));
//  FIPCClient_KRAL.PulseMonitor(LEventData);
//end;
//
//procedure TIPCClientAll.PulseEventData_LBX(AData: TEventData_Modbus_Standard);
//var
//  LEventData: TEventData_LBX;
//begin
//  System.Move(AData, LEventData, Sizeof(LEventData));
//  FIPCClient_LBX.PulseMonitor(LEventData);
//end;
//
//procedure TIPCClientAll.PulseEventData_MEXA7000(
//  AData: TEventData_MEXA7000_2);
//begin
//  FIPCClient_MEXA7000.PulseMonitor(AData);
//end;
//
//procedure TIPCClientAll.PulseEventData_MT210(AData: TEventData_Modbus_Standard);
//var
//  LEventData: TEventData_MT210;
//begin
//  System.Move(AData, LEventData, Sizeof(LEventData));
//  FIPCClient_MT210.PulseMonitor(LEventData);
//end;
//
//procedure TIPCClientAll.PulseEventData_PLC_Modbus(
//  AData: TEventData_Modbus_Standard);
//var
//  LEventData: TEventData_Modbus_Standard;
//begin
//  System.Move(AData, LEventData, Sizeof(LEventData));
//  FIPCClient_PLC_Modbus.PulseMonitor(LEventData);
//end;
//
//procedure TIPCClientAll.PulseEventData_PLC_S7(
//  AData: TEventData_Modbus_Standard);
//var
//  LEventData: TEventData_PLC_S7;
//begin
//  System.Move(AData, LEventData, Sizeof(LEventData));
//  FIPCClient_PLC_S7.PulseMonitor(LEventData);
//end;
//
//procedure TIPCClientAll.PulseEventData_PMSOPC(AData: TEventData_PMS);
//begin
//  FIPCClient_PMSOPC.PulseMonitor(AData);
//end;

procedure TIPCClientAll.PulseEventData_Dynamo<T>(AData: T);
var
  LEventData: TEventData_DYNAMO;
begin
  System.Move(AData, LEventData, Sizeof(LEventData));
  FIPCClient_Dynamo.PulseMonitor(LEventData);
end;

procedure TIPCClientAll.PulseEventData_ECS_AVAT<T>(AData: T);
var
  LEventData: TEventData_ECS_AVAT;
begin
  System.Move(AData, LEventData, Sizeof(LEventData));
  FIPCClient_ECS_AVAT.PulseMonitor(LEventData);
end;

procedure TIPCClientAll.PulseEventData_ECS_ComAP2<T>(AData: T);
var
  LEventData: TEventData_Modbus_Standard;
begin
  System.Move(AData, LEventData, Sizeof(LEventData));
  FIPCClient_ECS_ComAP2.PulseMonitor(LEventData);
end;

procedure TIPCClientAll.PulseEventData_ECS_ComAP<T>(AData: T);
var
  LEventData: TEventData_Modbus_Standard;
begin
  System.Move(AData, LEventData, Sizeof(LEventData));
  FIPCClient_ECS_ComAP.PulseMonitor(LEventData);
end;

procedure TIPCClientAll.PulseEventData_ECS_kumo<T>(AData: T);
var
  LEventData: TEventData_ECS_kumo;
begin
  System.Move(AData, LEventData, Sizeof(LEventData));
  FIPCClient_ECS_kumo.PulseMonitor(LEventData);
end;

procedure TIPCClientAll.PulseEventData_ECS_Woodward<T>(AData: T);
var
  LEventData: TEventData_ECS_Woodward;
begin
  System.Move(AData, LEventData, Sizeof(LEventData));
  FIPCClient_ECS_Woodward.PulseMonitor(LEventData);
end;

procedure TIPCClientAll.PulseEventData_EngineParam<T>(AData: T);
var
  LEventData: TEventData_EngineParam;
begin
  System.Move(AData, LEventData, Sizeof(LEventData));
  FIPCClient_EngineParam.PulseMonitor(LEventData);
end;

procedure TIPCClientAll.PulseEventData_FlowMeter<T>(AData: T);
var
  LEventData: TEventData_FlowMeter;
begin
  System.Move(AData, LEventData, Sizeof(LEventData));
  FIPCClient_FlowMeter.PulseMonitor(LEventData);
end;

procedure TIPCClientAll.PulseEventData_GasCalc<T>(AData: T);
var
  LEventData: TEventData_GasCalc;
begin
  System.Move(AData, LEventData, Sizeof(LEventData));
  FIPCClient_GasCalc.PulseMonitor(LEventData);
end;

procedure TIPCClientAll.PulseEventData_HIC<T>(AData: T);
var
  LEventData: TEventData_HIC;
begin
  System.Move(AData, LEventData, Sizeof(LEventData));
  FIPCClient_HIC.PulseMonitor(LEventData);
end;

procedure TIPCClientAll.PulseEventData_KRAL<T>(AData: T);
var
  LEventData: TEventData_Modbus_Standard;
begin
  System.Move(AData, LEventData, Sizeof(LEventData));
  FIPCClient_KRAL.PulseMonitor(LEventData);
end;

procedure TIPCClientAll.PulseEventData_LBX<T>(AData: T);
var
  LEventData: TEventData_LBX;
begin
  System.Move(AData, LEventData, Sizeof(LEventData));
  FIPCClient_LBX.PulseMonitor(LEventData);
end;

procedure TIPCClientAll.PulseEventData_MEXA7000<T>(AData: T);
var
  LEventData: TEventData_MEXA7000_2;
begin
  System.Move(AData, LEventData, Sizeof(LEventData));
  FIPCClient_MEXA7000.PulseMonitor(LEventData);
end;

procedure TIPCClientAll.PulseEventData_MT210<T>(AData: T);
var
  LEventData: TEventData_MT210;
begin
  System.Move(AData, LEventData, Sizeof(LEventData));
  FIPCClient_MT210.PulseMonitor(LEventData);
end;

procedure TIPCClientAll.PulseEventData_PLC_Modbus<T>(AData: T);
var
  LEventData: TEventData_Modbus_Standard;
begin
  System.Move(AData, LEventData, Sizeof(LEventData));
  FIPCClient_PLC_Modbus.PulseMonitor(LEventData);
end;

procedure TIPCClientAll.PulseEventData_PLC_S7<T>(AData: T);
var
  LEventData: TEventData_PLC_S7;
begin
  System.Move(AData, LEventData, Sizeof(LEventData));
  FIPCClient_PLC_S7.PulseMonitor(LEventData);
end;

procedure TIPCClientAll.PulseEventData_PMSOPC<T>(AData: T);
var
  LEventData: TEventData_PMS;
begin
  System.Move(AData, LEventData, Sizeof(LEventData));
  FIPCClient_PMSOPC.PulseMonitor(LEventData);
end;

procedure TIPCClientAll.PulseEventData_WT1600(
  AData: TEventData_Modbus_Standard);
var
  LEventData: TEventData_WT1600;
begin
  LEventData.IpAddress := AData.IPAddress;
  LEventData.URMS1 := Format('%.2f', [AData.InpDataBuf_double[0]]);
  LEventData.URMS2 := Format('%.2f', [AData.InpDataBuf_double[1]]);
  LEventData.URMS3 := Format('%.2f', [AData.InpDataBuf_double[2]]);
  LEventData.IRMS1 := Format('%.2f', [AData.InpDataBuf_double[3]]);
  LEventData.IRMS2 := Format('%.2f', [AData.InpDataBuf_double[4]]);
  LEventData.IRMS3 := Format('%.2f', [AData.InpDataBuf_double[5]]);
  LEventData.FREQUENCY := Format('%.2f', [AData.InpDataBuf_double[6]]);
  LEventData.RAMDA := Format('%.4f', [AData.InpDataBuf_double[7]]);
  LEventData.PSIGMA := Format('%.2f', [AData.InpDataBuf_double[8]/1000]);
  LEventData.SSIGMA := Format('%.2f', [AData.InpDataBuf_double[9]/1000]);
  LEventData.QSIGMA := Format('%.2f', [AData.InpDataBuf_double[10]/1000]);
  LEventData.F1 := Format('%.2f', [AData.InpDataBuf_double[11]]);
  LEventData.URMSAVG := Format('%.2f', [AData.InpDataBuf_double[12]]);
  LEventData.IRMSAVG := Format('%.2f', [AData.InpDataBuf_double[13]]);

  LEventData.PowerMeterOn := Boolean(AData.ModBusMode);
  LEventData.PowerMeterNo := AData.BlockNo;

  FIPCClient_WT1600.PulseMonitor(LEventData);
end;

procedure TIPCClientAll.ReadAddressFromParamFile(AFileName: string;
  AEncrypt: Bool; AFileFormat: integer);
begin
  if AFileFormat = 0 then
    FEngineParameter.LoadFromFile(AFilename,
                                      ExtractFileName(AFilename),
                                      AEncrypt)
  else if AFileFormat = 1 then
    FEngineParameter.LoadFromJSONFile(AFilename,
                                      ExtractFileName(AFilename),
                                      AEncrypt);

  if FEngineParameter.EngineParameterCollect.Count > 0 then
  begin
    FProjNo := FEngineParameter.EngineParameterCollect.Items[0].ProjNo;
    FEngNo := FEngineParameter.EngineParameterCollect.Items[0].EngNo;
  end;
end;

end.

