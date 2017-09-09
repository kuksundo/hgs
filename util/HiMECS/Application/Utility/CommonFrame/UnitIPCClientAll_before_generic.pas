unit UnitIPCClientAll_before_generic;
{
이 유닛은 FEngineParameter의 value만 저장함.
}

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, IPCThrd_LBX, IPCThrd_WT1600, IPCThrd_ECS_kumo, IPCThrd_MEXA7000,
  IPCThrd_MT210, IPCThrd_DYNAMO, IPCThrd_ECS_AVAT, IPCThrd_GasCalc, IPCThrd_Kral,
  IPCThrd_ECS_Woodward, IPCThrd_PLC_S7, IPCThrd_FlowMeter, IPCThrd_EngineParam,
  IPCThrdClient_FlowMeter, IPCThrdClient_ECS_kumo, IPCThrdClient_ECS_Avat, IPCThrdClient_MEXA7000,
  IPCThrdClient_MT210, IPCThrdClient_WT1600, IPCThrdClient_Gas, IPCThrdClient_Dynamo,
  IPCThrdClient_Kral, IPCThrdClient_LBX, IPCThrdClient_ECS_Woodward, IPCThrdClient_PLC_S7,
  IPCThrdClient_EngineParam, HiMECSConst, EngineParameterClass;

type
  TIPCClientAll = class(TObject)
  private
    procedure AddIPCClientList(ASharedName: string);

    procedure CreateECSkumoIPCClient(ASharedName: string = '');
    procedure CreateECSAVATIPCClient(ASharedName: string = '');
    procedure CreateWoodwardIPCClient(ASharedName: string = '');
    procedure CreateWT1600IPCClient(ASharedName: string = '');
    procedure CreateMT210IPCClient(ASharedName: string = '');
    procedure CreateMEXA7000IPCClient(ASharedName: string = '');
    procedure CreateLBXIPCClient(ASharedName: string = '');
    procedure CreateFlowMeterIPCClient(ASharedName: string = '');
    procedure CreateDynamoIPCClient(ASharedName: string = '');
    procedure CreateGasCalcIPCClient(ASharedName: string = '');
    procedure CreateKRALIPCClient(ASharedName: string = '');
    procedure CreatePLCS7IPCClient(ASharedName: string = '');
    procedure CreateEngineParamIPCClient(ASharedName: string = '');
  protected
  public
    FIPCClientList: TStringList;
    FEngineParameter: TEngineParameter;
    FEngineParameterItemRecord: TEngineParameterItemRecord; //Save폼에 값 전달시 사용

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

    FIPCClient_WT1600: TIPCClient_WT1600;//WT1600
    FIPCClient_MEXA7000: TIPCClient_MEXA7000;//MEXA7000
    FIPCClient_MT210: TIPCClient_MT210;//MT210
    FIPCClient_ECS_kumo: TIPCClient_ECS_kumo;//kumo ECS
    FIPCClient_ECS_AVAT: TIPCClient_ECS_AVAT;//AVAT ECS
    FIPCClient_ECS_Woodward: TIPCClient_ECS_Woodward;//Woodward(AtlasII) ECS
    FIPCClient_LBX: TIPCClient_LBX;//LBX
    FIPCClient_FlowMeter: TIPCClient_FlowMeter;//FlowMeter
    FIPCClient_Dynamo: TIPCClient_Dynamo;//DynamoMeter
    FIPCClient_GasCalc: TIPCClient_GasCalc;//Gas Total
    FIPCClient_KRAL: TIPCClient_KRAL;//FlowMeter(KRAL)
    FIPCClient_PLC_S7: TIPCClient_PLC_S7;//Siemens PLC S7-300
    FIPCClient_EngineParam: TIPCClient_EngineParam;//Engine Parameter file

    constructor Create;
    destructor Destroy;
    procedure InitVar;
    procedure CreateIPCClient(APS: TParameterSource; ASharedName: string = '');
    procedure DestroyIPCClient(AIPCClient: TParameterSource);
    procedure CreateIPCClientFromParam;
  end;

implementation

procedure TIPCClientAll.AddIPCClientList(ASharedName: string);
begin
  if FIPCClientList.IndexOf(ASharedName) = -1 then
    FIPCClientList.Add(ASharedName);
end;

constructor TIPCClientAll.Create;
begin
  InitVar;
end;

procedure TIPCClientAll.CreateDynamoIPCClient(ASharedName: string);
var
  LSM: string;
begin
  if Assigned(FIPCClient_Dynamo) then
    exit;

  if ASharedName = '' then
    LSM := ParameterSource2SharedMN(psDynamo)
  else
    LSM := ASharedName;

  FIPCClient_Dynamo := TIPCClient_Dynamo.Create(0, LSM, True);
  AddIPCClientList(LSM);
end;

procedure TIPCClientAll.CreateECSAVATIPCClient(ASharedName: string);
var
  LSM: string;
begin
  if Assigned(FIPCClient_ECS_AVAT) then
    exit;

  if ASharedName = '' then
    LSM := ParameterSource2SharedMN(psECS_AVAT)
  else
    LSM := ASharedName;

  FIPCClient_ECS_AVAT := TIPCClient_ECS_AVAT.Create(0, LSM, True);
  AddIPCClientList(LSM);
end;

procedure TIPCClientAll.CreateECSkumoIPCClient(ASharedName: string);
var
  LSM: string;
begin
  if Assigned(FIPCClient_ECS_kumo) then
    exit;

  if ASharedName = '' then
    LSM := ParameterSource2SharedMN(psECS_kumo)
  else
    LSM := ASharedName;

  FIPCClient_ECS_kumo := TIPCClient_ECS_kumo.Create(0, LSM, True);
  AddIPCClientList(LSM);
end;

procedure TIPCClientAll.CreateEngineParamIPCClient(ASharedName: string);
var
  LSM: string;
begin
  if Assigned(FIPCClient_EngineParam) then
    exit;

  if ASharedName = '' then
    LSM := ParameterSource2SharedMN(psEngineParam)
  else
    LSM := ASharedName;

  FIPCClient_EngineParam := TIPCClient_EngineParam.Create(0, LSM, True);
  AddIPCClientList(LSM);
end;

procedure TIPCClientAll.CreateFlowMeterIPCClient(ASharedName: string);
var
  LSM: string;
begin
  if Assigned(FIPCClient_FlowMeter) then
    exit;

  if ASharedName = '' then
    LSM := ParameterSource2SharedMN(psFlowMeter)
  else
    LSM := ASharedName;

  FIPCClient_FlowMeter := TIPCClient_FlowMeter.Create(0, LSM, True);
  AddIPCClientList(LSM);
end;

procedure TIPCClientAll.CreateGasCalcIPCClient(ASharedName: string);
var
  LSM: string;
begin
  if Assigned(FIPCClient_GasCalc) then
    exit;

  if ASharedName = '' then
    LSM := ParameterSource2SharedMN(psGasCalculated)
  else
    LSM := ASharedName;

  FIPCClient_GasCalc := TIPCClient_GasCalc.Create(0, LSM, True);
  AddIPCClientList(LSM);
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
    psEngineParam: CreateEngineParamIPCClient(ASharedName);
  else
    AddIPCClientList('UnKnown Parameter Source.');
  end;
end;

procedure TIPCClientAll.CreateIPCClientFromParam;
var
  i: integer;
begin
  //for i := 0 to FEngineParameter.EngineParameterCollect.Count - 1 do
  //begin
    //CreateIPCClient(FEngineParameter.EngineParameterCollect.Items[i].ParameterSource);
    CreateIPCClient(psEngineParam);
  //end; //for
end;

procedure TIPCClientAll.CreateKRALIPCClient(ASharedName: string);
var
  LSM: string;
begin
  if Assigned(FIPCClient_KRAL) then
    exit;

  if ASharedName = '' then
    LSM := ParameterSource2SharedMN(psFlowMeterKral)
  else
    LSM := ASharedName;

  FIPCClient_KRAL := TIPCClient_KRAL.Create(0, LSM, True);
  AddIPCClientList(LSM);
end;

procedure TIPCClientAll.CreateLBXIPCClient(ASharedName: string);
var
  LSM: string;
begin
  if Assigned(FIPCClient_LBX) then
    exit;

  if ASharedName = '' then
    LSM := ParameterSource2SharedMN(psLBX)
  else
    LSM := ASharedName;

  FIPCClient_LBX := TIPCClient_LBX.Create(0, LSM, True);
  AddIPCClientList(LSM);
end;

procedure TIPCClientAll.CreateMEXA7000IPCClient(ASharedName: string);
var
  LSM: string;
begin
  if Assigned(FIPCClient_MEXA7000) then
    exit;

  if ASharedName = '' then
    LSM := ParameterSource2SharedMN(psMEXA7000)
  else
    LSM := ASharedName;

  FIPCClient_MEXA7000 := TIPCClient_MEXA7000.Create(0, LSM, True);
  AddIPCClientList(LSM);
end;

procedure TIPCClientAll.CreateMT210IPCClient(ASharedName: string);
var
  LSM: string;
begin
  if Assigned(FIPCClient_MT210) then
    exit;

  if ASharedName = '' then
    LSM := ParameterSource2SharedMN(psMT210)
  else
    LSM := ASharedName;

  FIPCClient_MT210 := TIPCClient_MT210.Create(0, LSM, True);
  AddIPCClientList(LSM);
end;

procedure TIPCClientAll.CreatePLCS7IPCClient(ASharedName: string);
var
  LSM: string;
begin
  if Assigned(FIPCClient_PLC_S7) then
    exit;

  if ASharedName = '' then
    LSM := ParameterSource2SharedMN(psPLC_S7)
  else
    LSM := ASharedName;

  FIPCClient_PLC_S7 := TIPCClient_PLC_S7.Create(0, LSM, True);
  AddIPCClientList(LSM);
end;

procedure TIPCClientAll.CreateWoodwardIPCClient(ASharedName: string);
var
  LSM: string;
begin
  if Assigned(FIPCClient_ECS_Woodward) then
    exit;

  if ASharedName = '' then
    LSM := ParameterSource2SharedMN(psECS_Woodward)
  else
    LSM := ASharedName;

  FIPCClient_ECS_Woodward := TIPCClient_ECS_Woodward.Create(0, LSM, True);
  AddIPCClientList(LSM);
end;

procedure TIPCClientAll.CreateWT1600IPCClient(ASharedName: string);
var
  LSM: string;
begin
  if Assigned(FIPCClient_WT1600) then
    exit;

  if ASharedName = '' then
    LSM := ParameterSource2SharedMN(psWT1600)
  else
    LSM := ASharedName;

  FIPCClient_WT1600 := TIPCClient_WT1600.Create(0, LSM, True);
  AddIPCClientList(LSM);
end;

destructor TIPCClientAll.Destroy;
begin
  FIPCClientList.Free;
  FEngineParameter.EngineParameterCollect.Clear;
  FreeAndNil(FEngineParameter);
end;

procedure TIPCClientAll.DestroyIPCClient(AIPCClient: TParameterSource);
begin
  if Assigned(FIPCClient_WT1600) and (AIPCClient = psWT1600) then
  begin
    FIPCClient_WT1600.Free;
  end;

  if Assigned(FIPCClient_MEXA7000) and (AIPCClient = psMEXA7000)  then
  begin
    FIPCClient_MEXA7000.Free;
  end;

  if Assigned(FIPCClient_MT210) and (AIPCClient = psMT210)  then
  begin
    FIPCClient_MT210.Free;
  end;

  if Assigned(FIPCClient_ECS_kumo) and (AIPCClient = psECS_kumo)  then
  begin
    FIPCClient_ECS_kumo.Free;
  end;

  if Assigned(FIPCClient_ECS_AVAT) and (AIPCClient = psECS_AVAT)  then
  begin
    FIPCClient_ECS_AVAT.Free;
  end;

  if Assigned(FIPCClient_LBX) and (AIPCClient = psLBX)  then
  begin
    FIPCClient_LBX.Free;
  end;

  if Assigned(FIPCClient_Dynamo) and (AIPCClient = psDynamo)  then
  begin
    FIPCClient_Dynamo.Free;
  end;

  if Assigned(FIPCClient_GasCalc) and (AIPCClient = psGasCalculated)  then
  begin
    FIPCClient_GasCalc.Free;
  end;

  if Assigned(FIPCClient_KRAL) and (AIPCClient = psFlowMeterKral)  then
  begin
    FIPCClient_KRAL.Free;
  end;

  if Assigned(FIPCClient_ECS_Woodward) and (AIPCClient = psECS_Woodward)  then
  begin
    FIPCClient_ECS_Woodward.Free;
  end;

  if Assigned(FIPCClient_PLC_S7) and (AIPCClient = psPLC_S7)  then
  begin
    FIPCClient_PLC_S7.Free;
  end;

  if Assigned(FIPCClient_EngineParam) and (AIPCClient = psEngineParam)  then
  begin
    FIPCClient_EngineParam.Free;
  end;
end;

procedure TIPCClientAll.InitVar;
begin
  FEngineParameter := TEngineParameter.Create(nil);
  FIPCClientList := TStringList.Create;
end;

end.
