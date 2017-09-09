unit UnitIPCClientMonitor;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs,
  IPCThrdClient_Generic, IPC_HIC_Const, HiMECSConst,
  IPCThrdMonitor_Generic, IPC_ModbusComm_Const, EngineParameterClass,
  ModbusComConst_endurance;

type
  TOnSignalProc = procedure(Data: TEventData_HIC) of object;

  TFrameClientMonitor = class(TFrame)
  private
    procedure UpdateTrace_Matrix(var Msg: TEventData_HIC); message WM_EVENT_MATRIX_COMM;
    procedure Matrix_OnSignal(Data: TEventData_HIC);
  public
    FIPCClient_HIC: TIPCClient<TConfigData_ModbusComm>;
    FIPCMonitor: TIPCMonitor<TEventData_HIC>;
    FEngineParameter: TEngineParameter;
    FMatrixCommData: TEventData_HIC;
    FUseOnlineData: Boolean;//True=제어기로부터 데이터를 수신하여 FEngineParameter 갱신함
                            //False=파일에서 읽은 데이터를 그대로 유지함

    procedure InitVar;
    procedure DestroyVar;
    procedure CreateIPCMonitor(ASharedName: string; AOnSignal: TOnSignalProc = nil);
    procedure AnalogValue2Screen;
    procedure MoveArray2Matrix;
  end;

implementation

{$R *.dfm}

{ TFrame1 }

procedure TFrameClientMonitor.AnalogValue2Screen;
begin
end;

procedure TFrameClientMonitor.CreateIPCMonitor(ASharedName: string;
  AOnSignal: TOnSignalProc = nil);
begin
  if ASharedName = '' then
    ASharedName := ParameterSource2SharedMN(psHIC);

  FIPCMonitor := TIPCMonitor<TEventData_HIC>.Create(ASharedName, HIC_EVENT_NAME, True);
  if Assigned(AOnSignal) then
    FIPCMonitor.FIPCObject.OnSignal := AOnSignal
  else
    FIPCMonitor.FIPCObject.OnSignal := Matrix_OnSignal;
  FIPCMonitor.FreeOnTerminate := True;
  FIPCMonitor.Resume;
end;

procedure TFrameClientMonitor.DestroyVar;
var
  LData: TConfigData_ModbusComm;
begin
  if Assigned(FIPCMonitor) then
  begin
    FIPCMonitor.FTermination := True;
    FIPCMonitor.FIPCObject.FMonitorEvent.Pulse;
    FIPCMonitor.Terminate;
    //FIPCMonitor.Free;
  end;

  if Assigned(FIPCClient_HIC) then
  begin
    LData.Termination := True;
    FIPCClient_HIC.PulseMonitor(LData);
    FreeAndNil(FIPCClient_HIC);
  end;

  FEngineParameter.EngineParameterCollect.Clear;
  FEngineParameter.MatrixCollect.Clear;
  FEngineParameter.Free;
end;

procedure TFrameClientMonitor.InitVar;
var
  LSM: string;
begin
  FEngineParameter := TEngineParameter.Create(Self);
  LSM := ParameterSource2SharedMN(psHIC) + 'Matrix';
  FIPCClient_HIC := TIPCClient<TConfigData_ModbusComm>.Create(LSM, MODBUSCOMM_EVENT_NAME, True);
end;

procedure TFrameClientMonitor.Matrix_OnSignal(Data: TEventData_HIC);
begin
  if not FUseOnlineData then
    exit;

  if Data.DataMode <> 1 then //CM_CONFIG_READ
    exit;

  System.Move(Data, FMatrixCommData, Sizeof(Data));
  SendMessage(Handle, WM_EVENT_MATRIX_COMM, 0,0);
end;

procedure TFrameClientMonitor.MoveArray2Matrix;
begin

end;

procedure TFrameClientMonitor.UpdateTrace_Matrix(var Msg: TEventData_HIC);
var
  i: integer;
begin
  //0: Repeat Read, 1: Only One read(config data), 2: Only One Write
  if FMatrixCommData.DataMode = 0 then
  begin
    AnalogValue2Screen;
  end
  else
  if FMatrixCommData.DataMode = 1 then
  begin
    MoveArray2Matrix;
  end;
end;

end.
