unit UnitIPCClientRMIS;
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
  Dialogs, IPC_BWQry_Const, IPCThrdClient_Generic, RMISConst;

type
  TIPCClientRMIS = class(TObject)
  private
    procedure CreateBWQryIPCClient(ASharedName: string = '');
    procedure AddIPCClientList(ASharedName: string; AParamSource:TParameterSource);
  protected
    FEventName: string;
  public
    FIPCClientList: TStringList;
    FIPCClient_BWQry: TIPCClient<TEventData_BWQry>;

    constructor Create;
    destructor Destroy;
    procedure InitVar;
    function GetEventName: string;

    procedure CreateIPCClient(APS: TParameterSource; ASharedName: string = '');
    procedure DestroyIPCClient(AIPCClient: TParameterSource);
    procedure CreateIPCClientAll;

    procedure PulseEventData(AData: TEventData_BWQry);
    procedure PulseEventData_BWQry(AData: TEventData_BWQry);
  end;

implementation

procedure TIPCClientRMIS.AddIPCClientList(ASharedName: string;
  AParamSource:TParameterSource);
begin
  if FIPCClientList.IndexOf(ASharedName) = -1 then
  begin
    FIPCClientList.AddObject(ASharedName, TObject(AParamSource));
  end;
end;

constructor TIPCClientRMIS.Create;
begin
  InitVar;
end;

procedure TIPCClientRMIS.CreateBWQryIPCClient(ASharedName: string);
var
  LSM, LSM2: string;
begin
  if Assigned(FIPCClient_BWQry) then
    exit;

  if ASharedName = '' then
    LSM := ParameterSource2SharedMN(psBWQry)
  else
    LSM := ASharedName;

  LSM2 := ParameterSource2SharedMN(psBWQry);

  FIPCClient_BWQry := TIPCClient<TEventData_BWQry>.Create(LSM, LSM2, True);
  AddIPCClientList(LSM, psBWQry);

  FEventName := LSM + '_' + LSM2;
end;

procedure TIPCClientRMIS.CreateIPCClient(APS: TParameterSource; ASharedName: string);
begin
  case TParameterSource(APS) of
    psBWQry: CreateBWQryIPCClient(ASharedName);
  else
    AddIPCClientList('UnKnown Parameter Source.', psUnKnown);
  end;
end;

procedure TIPCClientRMIS.CreateIPCClientAll;
var
  i: integer;
  LPS: TParameterSource;
  LStr, LSN: string;
begin
  CreateIPCClient(LPS, LSN);
end;

destructor TIPCClientRMIS.Destroy;
var
  i: integer;
begin
  for i := 0 to FIPCClientList.Count - 1 do
    FIPCClientList.Objects[i].Free;

  FIPCClientList.Free;
end;

procedure TIPCClientRMIS.DestroyIPCClient(AIPCClient: TParameterSource);
begin
  if Assigned(FIPCClient_BWQry) and (AIPCClient = psBWQry) then
  begin
    FIPCClient_BWQry.Free;
  end;
end;

function TIPCClientRMIS.GetEventName: string;
begin
  Result := FEventName;
end;

procedure TIPCClientRMIS.InitVar;
begin
  FIPCClientList := TStringList.Create;
end;

procedure TIPCClientRMIS.PulseEventData(AData: TEventData_BWQry);
var
  i: integer;
  LParamSource:TParameterSource;
begin
  for i := 0 to FIPCClientList.Count - 1 do
  begin
    LParamSource := TParameterSource(FIPCClientList.Objects[i]);

    case TParameterSource(LParamSource) of
      psBWQry: PulseEventData_BWQry(AData);
    else
      ;
    end;
  end;
end;

procedure TIPCClientRMIS.PulseEventData_BWQry(
  AData: TEventData_BWQry);
var
  LEventData: TEventData_BWQry;
begin
  System.Move(AData, LEventData, Sizeof(LEventData));
  FIPCClient_BWQry.PulseMonitor(LEventData);
end;

end.

