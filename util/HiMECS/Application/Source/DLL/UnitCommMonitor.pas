unit UnitCommMonitor;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, IPCThrd_LBX, IPCThrdMonitor_LBX,
  IPCThrd_WT1600, IPCThrdMonitor_WT1600, IPCThrd_ECS_kumo, IPCThrdMonitor_ECS_kumo,
  IPCThrd_MEXA7000, IPCThrdMonitor_MEXA7000, IPCThrd_MT210, IPCThrdMonitor_MT210,
  IPCThrd_FlowMeter, IPCThrdMonitor_FlowMeter, IPCThrd_DYNAMO, IPCThrdMonitor_DYNAMO,
  IPCThrd_ECS_AVAT, IPCThrdMonitor_ECS_AVAT, TimerPool, iSwitchPanel,
  iComponent, iVCLComponent, iCustomComponent, iSwitchLed, StdCtrls, AdvGroupBox;

Const
  WM_EVENT_WT1600 = WM_USER + 102;
  WM_EVENT_MEXA7000 = WM_USER + 103;
  WM_EVENT_MT210 = WM_USER + 104;
  WM_EVENT_ECS_KUMO = WM_USER + 105;
  WM_EVENT_LBX = WM_USER + 106;
  WM_EVENT_DYNAMO = WM_USER + 107;
  WM_EVENT_ECS_AVAT = WM_USER + 108;
  WM_EVENT_FLOWMETER = WM_USER + 109;

Type
  TTimerHandleType = (thWT1600,thMEXA7000,thMT210,thECS_kumo,thECS_AVAT,thLBX,thDYNAMO);
const
  TimerHandleTypeCOUNT = integer(High(TTimerHandleType));

type
  TFrmCommMonitor = class(TForm)
    AdvGroupBox1: TAdvGroupBox;
    AvatLed: TiSwitchLed;
    AdvGroupBox2: TAdvGroupBox;
    WT1600Led: TiSwitchLed;
    AdvGroupBox3: TAdvGroupBox;
    Mexa7000Led: TiSwitchLed;
    AdvGroupBox4: TAdvGroupBox;
    MT210Led: TiSwitchLed;
    Button1: TButton;
    Button2: TButton;
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure AvatLedClick(Sender: TObject);
    procedure WT1600LedClick(Sender: TObject);
    procedure Mexa7000LedClick(Sender: TObject);
    procedure MT210LedClick(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
  private
    FECSData_kumo: TEventData_ECS_kumo;
    FECSData_AVAT: TEventData_ECS_AVAT;
    FMEXA7000Data: TEventData_MEXA7000;
    FLBXData: TEventData_LBX;
    FWT1600Data: TEventData_WT1600;
    FMT210Data: TEventData_MT210;
    FDYNAMOData: TEventData_DYNAMO;

    FIPCMonitor_WT1600: TIPCMonitor_WT1600;//WT1600
    FIPCMonitor_MEXA7000: TIPCMonitor_MEXA7000;//MEXA7000
    FIPCMonitor_MT210: TIPCMonitor_MT210;//MT210
    FIPCMonitor_ECS_kumo: TIPCMonitor_ECS_kumo;//kumo ECS
    FIPCMonitor_ECS_AVAT: TIPCMonitor_ECS_AVAT;//AVAT ECS
    FIPCMonitor_LBX: TIPCMonitor_LBX;//LBX
    //FIPCMonitor_FlowMeter: TIPCMonitor_FlowMeter;//FlowMeter
    FIPCMonitor_Dynamo: TIPCMonitor_Dynamo;//DynamoMeter
    //=====
    procedure WT1600_OnSignal(Sender: TIPCThread_WT1600; Data: TEventData_WT1600);
    procedure MEXA7000_OnSignal(Sender: TIPCThread_MEXA7000; Data: TEventData_MEXA7000);
    procedure MT210_OnSignal(Sender: TIPCThread_MT210; Data: TEventData_MT210);
    procedure ECS_OnSignal_kumo(Sender: TIPCThread_ECS_kumo; Data: TEventData_ECS_kumo);
    procedure ECS_OnSignal_AVAT(Sender: TIPCThread_ECS_AVAT; Data: TEventData_ECS_AVAT);
    procedure LBX_OnSignal(Sender: TIPCThread_LBX; Data: TEventData_LBX);
    procedure DYNAMO_OnSignal(Sender: TIPCThread_DYNAMO; Data: TEventData_DYNAMO);
    //procedure FlowMeter_OnSignal(Sender: TIPCThread_FlowMeter; Data: TEventData_FlowMeter);

    procedure UpdateTrace_WT1600(var Msg: TEventData_WT1600); message WM_EVENT_WT1600;
    procedure UpdateTrace_MEXA7000(var Msg: TEventData_MEXA7000); message WM_EVENT_MEXA7000;
    procedure UpdateTrace_MT210(var Msg: TEventData_MT210); message WM_EVENT_MT210;
    procedure UpdateTrace_ECS_kumo(var Msg: TEventData_ECS_kumo); message WM_EVENT_ECS_KUMO;
    procedure UpdateTrace_ECS_AVAT(var Msg: TEventData_ECS_AVAT); message WM_EVENT_ECS_AVAT;
    procedure UpdateTrace_LBX(var Msg: TEventData_LBX); message WM_EVENT_LBX;
    procedure UpdateTrace_DYNAMO(var Msg: TEventData_DYNAMO); message WM_EVENT_DYNAMO;
    //procedure UpdateTrace_FlowMeter(var Msg: TEventData_DYNAMO); message WM_EVENT_FLOWMETER;

    procedure OnTrigger4Comm(Sender : TObject; Handle : Integer;
            Interval : Cardinal; ElapsedTime : LongInt);

  public
    FSM_kumo: string;
    FSM_AVAT: string;
    FSM_MEXA7000: string;
    FSM_LBX: string;
    FSM_WT1600: string;
    FSM_MT210: string;
    FSM_DYNAMO: string;

    TimerHandle : array[thWT1600..thDYNAMO] of Integer;
    FPJHTimerPool : TPJHTimerPool;
    FCommHandles : array of THandle;
    FExesPath: string;
  end;

var
  FrmCommMonitor: TFrmCommMonitor;

implementation

uses CommonUtil, HiMECSConst;

{$R *.dfm}

procedure Create_CommunicationMonitor;
begin
  TFrmCommMonitor.Create(Application);
end;

{ TForm1 }

procedure TFrmCommMonitor.Button1Click(Sender: TObject);
begin
  AvatLedClick(nil);
  WT1600LedClick(nil);
  Mexa7000LedClick(nil);
  MT210LedClick(nil);
end;

procedure TFrmCommMonitor.Button2Click(Sender: TObject);
var
  i: integer;
begin
  for i := Low(FCommHandles) to High(FCommHandles) do
    SendMessage(FCommHandles[i], WM_CLOSE, 0, 0);
end;

procedure TFrmCommMonitor.DYNAMO_OnSignal(Sender: TIPCThread_DYNAMO;
  Data: TEventData_DYNAMO);
begin

end;

procedure TFrmCommMonitor.ECS_OnSignal_AVAT(Sender: TIPCThread_ECS_AVAT;
  Data: TEventData_ECS_AVAT);
begin
  AvatLed.Active := True;

  //TimerHandle[thECS_AVAT] := FPJHTimerPool.Add(OnTrigger4ECS_AVAT,10);
  TimerHandle[thECS_AVAT] := FPJHTimerPool.AddOneShot(OnTrigger4Comm,1000);
end;

procedure TFrmCommMonitor.ECS_OnSignal_kumo(Sender: TIPCThread_ECS_kumo;
  Data: TEventData_ECS_kumo);
begin

end;

procedure TFrmCommMonitor.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  FPJHTimerPool.RemoveAll;
  FPJHTimerPool.Free;

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

  if Assigned(FIPCMonitor_WT1600) then
  begin
    FIPCMonitor_WT1600.FMonitorEvent.Pulse;
    FIPCMonitor_WT1600.Terminate;
  end;

  if Assigned(FIPCMonitor_MEXA7000) then
  begin
    FIPCMonitor_MEXA7000.Suspend;
    FIPCMonitor_MEXA7000.FMonitorEvent.Pulse;
    FIPCMonitor_MEXA7000.Terminate;
    FIPCMonitor_MEXA7000.Resume;
  end;

  if Assigned(FIPCMonitor_MT210) then
  begin
    FIPCMonitor_MT210.Suspend;
    FIPCMonitor_MT210.FMonitorEvent.Pulse;
    FIPCMonitor_MT210.Terminate;
    FIPCMonitor_MT210.Resume;
  end;

  if Assigned(FIPCMonitor_ECS_kumo) then
  begin
    FIPCMonitor_ECS_kumo.Suspend;
    FIPCMonitor_ECS_kumo.FMonitorEvent.Pulse;
    FIPCMonitor_ECS_kumo.Terminate;
    FIPCMonitor_ECS_kumo.Resume;
  end;

  if Assigned(FIPCMonitor_ECS_AVAT) then
  begin
    FIPCMonitor_ECS_AVAT.Suspend;
    FIPCMonitor_ECS_AVAT.FMonitorEvent.Pulse;
    FIPCMonitor_ECS_AVAT.Terminate;
    FIPCMonitor_ECS_AVAT.Resume;
  end;

  if Assigned(FIPCMonitor_LBX) then
  begin
    FIPCMonitor_LBX.Suspend;
    FIPCMonitor_LBX.FMonitorEvent.Pulse;
    FIPCMonitor_LBX.Terminate;
    FIPCMonitor_LBX.Resume;
  end;

  if Assigned(FIPCMonitor_Dynamo) then
  begin
    FIPCMonitor_Dynamo.Suspend;
    FIPCMonitor_Dynamo.FMonitorEvent.Pulse;
    FIPCMonitor_Dynamo.Terminate;
    FIPCMonitor_Dynamo.Resume;
  end;

  Action := caFree;
end;

procedure TFrmCommMonitor.FormCreate(Sender: TObject);
begin
  FPJHTimerPool := TPJHTimerPool.Create(nil);
  //FPJHTimerPool.AddOneShot(OnTrigger4Comm,2000);
  FSM_AVAT := ParameterSource2SharedMN(psECS_AVAT);
  FIPCMonitor_ECS_AVAT := TIPCMonitor_ECS_AVAT.Create(0, FSM_AVAT, True);
  FIPCMonitor_ECS_AVAT.FreeOnTerminate := True;
  FIPCMonitor_ECS_AVAT.OnSignal := ECS_OnSignal_AVAT;
  FIPCMonitor_ECS_AVAT.Resume;

  FSM_kumo := ParameterSource2SharedMN(psECS_kumo);
  FIPCMonitor_ECS_kumo := TIPCMonitor_ECS_kumo.Create(0, FSM_kumo, True);
  FIPCMonitor_ECS_kumo.FreeOnTerminate := True;
  FIPCMonitor_ECS_kumo.OnSignal := ECS_OnSignal_kumo;
  FIPCMonitor_ECS_kumo.Resume;

  FSM_WT1600 := ParameterSource2SharedMN(psWT1600);
  FIPCMonitor_WT1600 := TIPCMonitor_WT1600.Create(0, FSM_WT1600, True);
  FIPCMonitor_WT1600.FreeOnTerminate := True;
  FIPCMonitor_WT1600.OnSignal := WT1600_OnSignal;
  FIPCMonitor_WT1600.Resume;

  FSM_MT210 := ParameterSource2SharedMN(psMT210);
  FIPCMonitor_MT210 := TIPCMonitor_MT210.Create(0, FSM_MT210, True);
  FIPCMonitor_MT210.FreeOnTerminate := True;
  FIPCMonitor_MT210.OnSignal := MT210_OnSignal;
  FIPCMonitor_MT210.Resume;

  FSM_MEXA7000 := ParameterSource2SharedMN(psMEXA7000);
  FIPCMonitor_MEXA7000 := TIPCMonitor_MEXA7000.Create(0, FSM_MEXA7000, True);
  FIPCMonitor_MEXA7000.FreeOnTerminate := True;
  FIPCMonitor_MEXA7000.OnSignal := MEXA7000_OnSignal;
  FIPCMonitor_MEXA7000.Resume;

  FSM_LBX := ParameterSource2SharedMN(psLBX);
  FIPCMonitor_LBX := TIPCMonitor_LBX.Create(0, FSM_LBX, True);
  FIPCMonitor_LBX.FreeOnTerminate := True;
  FIPCMonitor_LBX.OnSignal := LBX_OnSignal;
  FIPCMonitor_LBX.Resume;

  FSM_Dynamo := ParameterSource2SharedMN(psDynamo);
  FIPCMonitor_Dynamo := TIPCMonitor_Dynamo.Create(0, FSM_Dynamo, True);
  FIPCMonitor_Dynamo.FreeOnTerminate := True;
  FIPCMonitor_Dynamo.OnSignal := Dynamo_OnSignal;
  FIPCMonitor_Dynamo.Resume;

{  FIPCMonitor_FlowMeter := TIPCMonitor_FlowMeter.Create(0, LSM, True);
  FIPCMonitor_FlowMeter.FreeOnTerminate := True;
  FIPCMonitor_FlowMeter.OnSignal := FlowMeter_OnSignal;
  FIPCMonitor_FlowMeter.Resume;
}
end;

procedure TFrmCommMonitor.AvatLedClick(Sender: TObject);
var
  LHandle,LProcessID: THandle;
begin
  FExesPath := Hint;
  //WinExec(PAnsiChar(IncludeTrailingPathDelimiter(FExesPath)+'ModBusComP_avat.exe'), SW_SHOW);
  LProcessId := ExecNewProcess2(IncludeTrailingPathDelimiter(FExesPath)+'ModBusComP_avat.exe', '/A');
  LHandle := DSiGetProcessWindow(LProcessId);

  SetLength(FCommHandles, Length(FCommHandles)+1);
  FCommHandles[High(FCommHandles)] := LHandle;
end;

procedure TFrmCommMonitor.LBX_OnSignal(Sender: TIPCThread_LBX; Data: TEventData_LBX);
begin

end;

procedure TFrmCommMonitor.Mexa7000LedClick(Sender: TObject);
var
  LHandle,LProcessID: THandle;
begin
  FExesPath := Hint;
  LProcessId := ExecNewProcess2(IncludeTrailingPathDelimiter(FExesPath)+'Mexa7000_xe.exe /A');
  LHandle := DSiGetProcessWindow(LProcessId);

  SetLength(FCommHandles, Length(FCommHandles)+1);
  FCommHandles[High(FCommHandles)] := LHandle;
end;

procedure TFrmCommMonitor.MEXA7000_OnSignal(Sender: TIPCThread_MEXA7000;
  Data: TEventData_MEXA7000);
begin

end;

procedure TFrmCommMonitor.MT210LedClick(Sender: TObject);
var
  LHandle,LProcessID: THandle;
begin
  FExesPath := Hint;
  LProcessId := ExecNewProcess2(IncludeTrailingPathDelimiter(FExesPath)+'MT210Commp.exe /A');
  LHandle := DSiGetProcessWindow(LProcessId);

  SetLength(FCommHandles, Length(FCommHandles)+1);
  FCommHandles[High(FCommHandles)] := LHandle;
end;

procedure TFrmCommMonitor.MT210_OnSignal(Sender: TIPCThread_MT210;
  Data: TEventData_MT210);
begin

end;

procedure TFrmCommMonitor.OnTrigger4Comm(Sender: TObject; Handle: Integer;
  Interval: Cardinal; ElapsedTime: Integer);
var
  i: TTimerHandleType;
begin
  for i := thWT1600 to thDYNAMO do
  begin
    if TimerHandle[i] = Handle then
    begin
      case i of
        thWT1600:WT1600Led.Active := False;
        thMEXA7000:Mexa7000Led.Active := False;
        thMT210:MT210Led.Active := False;
        thECS_kumo:;
        thECS_AVAT:AvatLed.Active := False;
        thLBX:;
        thDYNAMO:;
      end;

    end;
  end;
end;

procedure TFrmCommMonitor.UpdateTrace_DYNAMO(var Msg: TEventData_DYNAMO);
begin

end;

procedure TFrmCommMonitor.UpdateTrace_ECS_AVAT(var Msg: TEventData_ECS_AVAT);
begin

end;

procedure TFrmCommMonitor.UpdateTrace_ECS_kumo(var Msg: TEventData_ECS_kumo);
begin

end;

procedure TFrmCommMonitor.UpdateTrace_LBX(var Msg: TEventData_LBX);
begin

end;

procedure TFrmCommMonitor.UpdateTrace_MEXA7000(var Msg: TEventData_MEXA7000);
begin

end;

procedure TFrmCommMonitor.UpdateTrace_MT210(var Msg: TEventData_MT210);
begin

end;

procedure TFrmCommMonitor.UpdateTrace_WT1600(var Msg: TEventData_WT1600);
begin

end;

procedure TFrmCommMonitor.WT1600LedClick(Sender: TObject);
var
  LHandle,LProcessID: THandle;
begin
  FExesPath := Hint;
  LProcessId := ExecNewProcess2(IncludeTrailingPathDelimiter(FExesPath)+'WT1600CommSDI_Manage_XE.exe /A');
  LHandle := DSiGetProcessWindow(LProcessId);

  SetLength(FCommHandles, Length(FCommHandles)+1);
  FCommHandles[High(FCommHandles)] := LHandle;
end;

procedure TFrmCommMonitor.WT1600_OnSignal(Sender: TIPCThread_WT1600;
  Data: TEventData_WT1600);
begin

end;

exports //The export name is Case Sensitive
  Create_CommunicationMonitor;

end.
