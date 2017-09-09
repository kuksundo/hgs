unit UnitFrameIPCClientAll;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms, 
  Dialogs, IPCThrd_LBX, IPCThrdMonitor_LBX,
  IPCThrd_WT1600, IPCThrd_ECS_kumo, IPCThrd_MEXA7000, IPCThrd_MT210,
  IPCThrd_DYNAMO, IPCThrd_ECS_AVAT, IPCThrd_GasCalc,
  IPCThrdClient_ECS_kumo, IPCThrdClient_ECS_Avat, IPCThrdClient_MEXA7000,
  IPCThrdClient_MT210, IPCThrdClient_WT1600, IPCThrdClient_Gas,
  IPCThrdClient_Dynamo, IPCThrd_Kral, IPCThrdClient_Kral, IPCThrdClient_LBX,
  HiMECSConst, EngineParameterClass;

type
  TFrameIPCClientAll = class(TFrame)
  private
    procedure CreateECSkumoIPCClient(AEP_DragDrop: TEngineParameterItemRecord);
    procedure CreateECSAVATIPCClient(AEP_DragDrop: TEngineParameterItemRecord);
    procedure CreateWT1600IPCClient(AEP_DragDrop: TEngineParameterItemRecord);
    procedure CreateMT210IPCClient(AEP_DragDrop: TEngineParameterItemRecord);
    procedure CreateMEXA7000IPCClient(AEP_DragDrop: TEngineParameterItemRecord);
    procedure CreateLBXIPCClient(AEP_DragDrop: TEngineParameterItemRecord);
    procedure CreateFlowMeterIPCClient(AEP_DragDrop: TEngineParameterItemRecord);
    procedure CreateDynamoIPCClient(AEP_DragDrop: TEngineParameterItemRecord);
    procedure CreateGasCalcIPCClient(AEP_DragDrop: TEngineParameterItemRecord);
    procedure CreateKRALIPCClient(AEP_DragDrop: TEngineParameterItemRecord);
  protected
    FEngineParameter: TEngineParameter;
    FEngineParameterItemRecord: TEngineParameterItemRecord; //Save폼에 값 전달시 사용
  public
    FECSData_kumo: TEventData_ECS_kumo;
    FECSData_AVAT: TEventData_ECS_AVAT;
    FMEXA7000Data: TEventData_MEXA7000;
    FLBXData: TEventData_LBX;
    FWT1600Data: TEventData_WT1600;
    FMT210Data: TEventData_MT210;
    FDYNAMOData: TEventData_DYNAMO;
    FFlowMeterData: TEventData_FlowMeter;
    FGasCalcData: TEventData_GasCalc;
    FKRALData: TEventData_KRAL;

    FIPCClient_WT1600: TIPCClient_WT1600;//WT1600
    FIPCClient_MEXA7000: TIPCClient_MEXA7000;//MEXA7000
    FIPCClient_MT210: TIPCClient_MT210;//MT210
    FIPCClient_ECS_kumo: TIPCClient_ECS_kumo;//kumo ECS
    FIPCClient_ECS_AVAT: TIPCClient_ECS_AVAT;//AVAT ECS
    FIPCClient_LBX: TIPCClient_LBX;//LBX
    FIPCClient_FlowMeter: TIPCClient_FlowMeter;//FlowMeter
    FIPCClient_Dynamo: TIPCClient_Dynamo;//DynamoMeter
    FIPCClient_GasCalc: TIPCClient_GasCalc;//Gas Total
    FIPCClient_KRAL: TIPCClient_KRAL;//FlowMeter(KRAL)

    procedure CreateIPCClient(AEP_DragDrop: TEngineParameterItemRecord);
    procedure DestroyIPCClient(AIPCClient: TParameterSource);
  end;

implementation

{$R *.dfm}

{ TFrame2 }

procedure TFrameIPCClientAll.CreateDynamoIPCClient(
  AEP_DragDrop: TEngineParameterItemRecord);
var
  LSM: string;
begin
  if Assigned(FIPCClient_Dynamo) then
    exit;

  if AEP_DragDrop.FSharedName = '' then
    LSM := ParameterSource2SharedMN(AEP_DragDrop.FParameterSource)
  else
    LSM := AEP_DragDrop.FSharedName;

  FIPCClient_Dynamo := TIPCClient_Dynamo.Create(0, LSM, True);
end;

procedure TFrameIPCClientAll.CreateECSAVATIPCClient(
  AEP_DragDrop: TEngineParameterItemRecord);
var
  LSM: string;
begin
  if Assigned(FIPCClient_ECS_AVAT) then
    exit;

  if AEP_DragDrop.FSharedName = '' then
    LSM := ParameterSource2SharedMN(AEP_DragDrop.FParameterSource)
  else
    LSM := AEP_DragDrop.FSharedName;

  FIPCClient_ECS_AVAT := TIPCClient_ECS_AVAT.Create(0, LSM, True);
end;

procedure TFrameIPCClientAll.CreateECSkumoIPCClient(
  AEP_DragDrop: TEngineParameterItemRecord);
var
  LSM: string;
begin
  if Assigned(FIPCClient_ECS_kumo) then
    exit;

  if AEP_DragDrop.FSharedName = '' then
    LSM := ParameterSource2SharedMN(AEP_DragDrop.FParameterSource)
  else
    LSM := AEP_DragDrop.FSharedName;

  FIPCClient_ECS_kumo := TIPCClient_ECS_kumo.Create(0, LSM, True);
end;

procedure TFrameIPCClientAll.CreateFlowMeterIPCClient(
  AEP_DragDrop: TEngineParameterItemRecord);
var
  LSM: string;
begin
  if Assigned(FIPCClient_FlowMeter) then
    exit;

  if AEP_DragDrop.FSharedName = '' then
    LSM := ParameterSource2SharedMN(AEP_DragDrop.FParameterSource)
  else
    LSM := AEP_DragDrop.FSharedName;

  FIPCClient_FlowMeter := TIPCClient_FlowMeter.Create(0, LSM, True);
end;

procedure TFrameIPCClientAll.CreateGasCalcIPCClient(
  AEP_DragDrop: TEngineParameterItemRecord);
var
  LSM: string;
begin
  if Assigned(FIPCClient_GasCalc) then
    exit;

  if AEP_DragDrop.FSharedName = '' then
    LSM := ParameterSource2SharedMN(AEP_DragDrop.FParameterSource)
  else
    LSM := AEP_DragDrop.FSharedName;

  FIPCClient_GasCalc := TIPCClient_GasCalc.Create(0, LSM, True);
end;

procedure TFrameIPCClientAll.CreateIPCClient(AEP_DragDrop: TEngineParameterItemRecord);
begin
  case TParameterSource(AEP_DragDrop.FParameterSource) of
    psECS_kumo: CreateECSkumoIPCClient(AEP_DragDrop);
    psECS_AVAT: CreateECSAVATIPCClient(AEP_DragDrop);
    psMT210: CreateMT210IPCClient(AEP_DragDrop);
    psMEXA7000: CreateMEXA7000IPCClient(AEP_DragDrop);
    psLBX: CreateLBXIPCClient(AEP_DragDrop);
    psFlowMeter: CreateFlowMeterIPCClient(AEP_DragDrop);
    psWT1600: CreateWT1600IPCClient(AEP_DragDrop);
    psGasCalculated: CreateGasCalcIPCClient(AEP_DragDrop);
  end;
end;

procedure TFrameIPCClientAll.CreateKRALIPCClient(
  AEP_DragDrop: TEngineParameterItemRecord);
var
  LSM: string;
begin
  if Assigned(FIPCClient_KRAL) then
    exit;

  if AEP_DragDrop.FSharedName = '' then
    LSM := ParameterSource2SharedMN(AEP_DragDrop.FParameterSource)
  else
    LSM := AEP_DragDrop.FSharedName;

  FIPCClient_KRAL := TIPCClient_KRAL.Create(0, LSM, True);
end;

procedure TFrameIPCClientAll.CreateLBXIPCClient(AEP_DragDrop: TEngineParameterItemRecord);
var
  LSM: string;
begin
  if Assigned(FIPCClient_LBX) then
    exit;

  if AEP_DragDrop.FSharedName = '' then
    LSM := ParameterSource2SharedMN(AEP_DragDrop.FParameterSource)
  else
    LSM := AEP_DragDrop.FSharedName;

  FIPCClient_LBX := TIPCClient_LBX.Create(0, LSM, True);
end;

procedure TFrameIPCClientAll.CreateMEXA7000IPCClient(
  AEP_DragDrop: TEngineParameterItemRecord);
var
  LSM: string;
begin
  if Assigned(FIPCClient_MEXA7000) then
    exit;

  if AEP_DragDrop.FSharedName = '' then
    LSM := ParameterSource2SharedMN(AEP_DragDrop.FParameterSource)
  else
    LSM := AEP_DragDrop.FSharedName;

  FIPCClient_MEXA7000 := TIPCClient_MEXA7000.Create(0, LSM, True);
end;

procedure TFrameIPCClientAll.CreateMT210IPCClient(
  AEP_DragDrop: TEngineParameterItemRecord);
var
  LSM: string;
begin
  if Assigned(FIPCClient_MT210) then
    exit;

  if AEP_DragDrop.FSharedName = '' then
    LSM := ParameterSource2SharedMN(AEP_DragDrop.FParameterSource)
  else
    LSM := AEP_DragDrop.FSharedName;

  FIPCClient_MT210 := TIPCClient_MT210.Create(0, LSM, True);
end;

procedure TFrameIPCClientAll.CreateWT1600IPCClient(
  AEP_DragDrop: TEngineParameterItemRecord);
var
  LSM: string;
begin
  if Assigned(FIPCClient_WT1600) then
    exit;

  if AEP_DragDrop.FSharedName = '' then
    LSM := ParameterSource2SharedMN(AEP_DragDrop.FParameterSource)
  else
    LSM := AEP_DragDrop.FSharedName;

  FIPCClient_WT1600 := TIPCClient_WT1600.Create(0, LSM, True);
end;

procedure TFrameIPCClientAll.DestroyIPCClient(AIPCClient: TParameterSource);
begin
  if Assigned(FIPCClient_WT1600) and (AIPCClient = psWT1600) then
  begin
    FIPCClient_WT1600.FMonitorEvent.Pulse;
    FIPCClient_WT1600.Terminate;
  end;

  if Assigned(FIPCClient_MEXA7000) and (AIPCClient = psMEXA7000)  then
  begin
    FIPCClient_MEXA7000.Suspend;
    FIPCClient_MEXA7000.FMonitorEvent.Pulse;
    FIPCClient_MEXA7000.Resume;
    FIPCClient_MEXA7000.Terminate;
  end;

  if Assigned(FIPCClient_MT210) and (AIPCClient = psMT210)  then
  begin
    FIPCClient_MT210.Suspend;
    FIPCClient_MT210.FMonitorEvent.Pulse;
    FIPCClient_MT210.Resume;
    FIPCClient_MT210.Terminate;
  end;

  if Assigned(FIPCClient_ECS_kumo) and (AIPCClient = psECS_kumo)  then
  begin
    FIPCClient_ECS_kumo.Suspend;
    FIPCClient_ECS_kumo.FMonitorEvent.Pulse;
    FIPCClient_ECS_kumo.Resume;
    FIPCClient_ECS_kumo.Terminate;
  end;

  if Assigned(FIPCClient_ECS_AVAT) and (AIPCClient = psECS_AVAT)  then
  begin
    FIPCClient_ECS_AVAT.Suspend;
    FIPCClient_ECS_AVAT.FMonitorEvent.Pulse;
    FIPCClient_ECS_AVAT.Resume;
    FIPCClient_ECS_AVAT.Terminate;
  end;

  if Assigned(FIPCClient_LBX) and (AIPCClient = psLBX)  then
  begin
    FIPCClient_LBX.Suspend;
    FIPCClient_LBX.FMonitorEvent.Pulse;
    FIPCClient_LBX.Resume;
    FIPCClient_LBX.Terminate;
  end;

  if Assigned(FIPCClient_Dynamo) and (AIPCClient = psDynamo)  then
  begin
    FIPCClient_Dynamo.Suspend;
    FIPCClient_Dynamo.FMonitorEvent.Pulse;
    FIPCClient_Dynamo.Resume;
    FIPCClient_Dynamo.Terminate;
  end;

  if Assigned(FIPCClient_GasCalc) and (AIPCClient = psGasCalculated)  then
  begin
    FIPCClient_GasCalc.Suspend;
    FIPCClient_GasCalc.FMonitorEvent.Pulse;
    FIPCClient_GasCalc.Resume;
    FIPCClient_GasCalc.Terminate;
  end;

  if Assigned(FIPCClient_KRAL) and (AIPCClient = psFlowMeterKral)  then
  begin
    FIPCClient_KRAL.Suspend;
    FIPCClient_KRAL.FMonitorEvent.Pulse;
    FIPCClient_KRAL.Resume;
    FIPCClient_KRAL.Terminate;
  end;

end;

end.
