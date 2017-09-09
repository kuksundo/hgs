unit UnitFrameIPCMonitorRMIS;
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
  Dialogs, NxCustomGridControl, NxCustomGrid, NxGrid, JvStatusBar,
  TimerPool, UnitFrameIPCRMISConst, IPC_BWQry_Const, CommonUtil, IPCThrdMonitor_Generic,
  RMISConst, BW_Query_Class, ConfigOptionClass
 {$IFDEF USECODESITE} ,CodeSiteLogging {$ENDIF};

type
  TWatchValue2Screen_AnalogEvent =
    procedure(Name: string; AValue: string; AEPIndex: integer) of object;
  TWatchValue2Screen_DigitalEvent =
    procedure(Name: string; AValue: string; AEPIndex: integer) of object;
  TWatchValue2Screen_2 = procedure of object;

  TFrameIPCMonitor4RMIS = class(TFrame)
  private
    FBWQryClass: TBWQryClass;
    FRIMSData_BWQry: TEventData_BWQry;

    FIPCMonitor_BWQry: TIPCMonitor<TEventData_BWQry>;

    procedure UpdateTrace_BWQry(var Msg: TEventData_BWQry); message WM_EVENT_BWQRY;

    //WM_COPYDATA message를 받지 못함. Main Form에서 대신 처리
    //procedure WMCopyData(var Msg: TMessage); message WM_COPYDATA;

    procedure SendFormCopyData(ToHandle: integer; AForm:TForm);
  protected
    FEnterWatchValue2Screen: Boolean;

    procedure BWQRY_OnSignal(Data: TEventData_BWQry); virtual;
    procedure OverRide_BWQry(AData: TEventData_BWQry); virtual;

    procedure CommonCommunication(AParameterSource: TParameterSource);

    procedure OnSetZeroBWQry(Sender : TObject; Handle : Integer;
            Interval : Cardinal; ElapsedTime : LongInt);
  public
    FFilePath: string;      //파일을 저장할 경로

    FIsSetZeroWhenDisconnect: Boolean;// 통신이 일정시간 동안 안되면 구조체 값을 0으로
    FCommDisconnected: Boolean;// 통신이 일정시간 동안 안되면 True
    FPJHTimerPool: TPJHTimerPool;

    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;

    procedure InitVar;
    procedure DestroyVar;

    function CreateIPCMonitor: integer;
    procedure DestroyIPCMonitor(AIPCMonitor: TParameterSource);
    procedure DestroyIPCMonitorAll;
    function AssignedIPCMonitor(AIPCMonitor: TParameterSource): Boolean;

    function CreateIPCMonitor_BWQry(ASharedName: string = ''): String;

    procedure DisplayMessage(Msg: string);
    procedure DisplayMessage2SB(AStatusBar: TjvStatusBar; Msg: string);
    procedure SetValue2ScreenEvent(AAnalogFunc: TWatchValue2Screen_AnalogEvent;
      ADigitalFunc: TWatchValue2Screen_DigitalEvent);
    procedure SetValue2ScreenEvent_2(AFunc: TWatchValue2Screen_2);

    function GetEventName(APSrc: TParameterSource): string;
  end;

implementation

uses mORMot, synCommons;

{$R *.dfm}

{ TFrame1 }

//IPC Monitor가 할당 되었으면 True 반환
function TFrameIPCMonitor4RMIS.AssignedIPCMonitor(
  AIPCMonitor: TParameterSource): Boolean;
begin
  case TParameterSource(AIPCMonitor) of
    psBWQry: Result := Assigned(FIPCMonitor_BWQry);
  else
    Result := False;
  end;
end;

procedure TFrameIPCMonitor4RMIS.BWQRY_OnSignal(Data: TEventData_BWQry);
begin
  System.Move(Data, FRIMSData_BWQry, Sizeof(Data));
  SendMessage(Handle, WM_EVENT_BWQRY, 0,0);
  CommonCommunication(psBWQry);
end;

procedure TFrameIPCMonitor4RMIS.CommonCommunication(
  AParameterSource: TParameterSource);
begin
  if FCommDisconnected then
    FCommDisconnected := False;
end;

constructor TFrameIPCMonitor4RMIS.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);

  InitVar;
end;

function TFrameIPCMonitor4RMIS.CreateIPCMonitor: integer;
begin

end;

function TFrameIPCMonitor4RMIS.CreateIPCMonitor_BWQry(
  ASharedName: string): String;
var
  LSM: string;
  LSM2: string;
begin
  if Assigned(FIPCMonitor_BWQry) then
    exit;

  if ASharedName = '' then
    LSM := ParameterSource2SharedMN(psBWQry)
  else
    LSM := ASharedName;

  LSM2 := ParameterSource2SharedMN(psBWQry);

  FIPCMonitor_BWQry := TIPCMonitor<TEventData_BWQry>.Create(LSM, LSM2, True);
  FIPCMonitor_BWQry.FIPCObject.OnSignal := BWQRY_OnSignal;
  FIPCMonitor_BWQry.FreeOnTerminate := True;
  FIPCMonitor_BWQry.Resume;
end;

destructor TFrameIPCMonitor4RMIS.Destroy;
begin
  DestroyVar;

  inherited;
end;

procedure TFrameIPCMonitor4RMIS.DestroyIPCMonitor(AIPCMonitor: TParameterSource);
begin
  if Assigned(FIPCMonitor_BWQry) and (AIPCMonitor = psBWQry) then
  begin
    FIPCMonitor_BWQry.FIPCObject.OnSignal := nil;
    FIPCMonitor_BWQry.FIPCObject.FMonitorEvent.Pulse;
    FIPCMonitor_BWQry.Terminate;
    FIPCMonitor_BWQry := nil;
  end;
end;

procedure TFrameIPCMonitor4RMIS.DestroyIPCMonitorAll;
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

procedure TFrameIPCMonitor4RMIS.DestroyVar;
begin
  FPJHTimerPool.RemoveAll;
  FreeAndNil(FPJHTimerPool);

  FBWQryClass.Free;
end;

procedure TFrameIPCMonitor4RMIS.DisplayMessage(Msg: string);
begin

end;

procedure TFrameIPCMonitor4RMIS.DisplayMessage2SB(AStatusBar: TjvStatusBar; Msg: string);
begin
  if Assigned(AStatusBar) then
  begin
    AStatusBar.SimplePanel := True;
    AStatusBar.SimpleText := Msg;
  end;
end;

//DataSaveAll에서 사용 됨
function TFrameIPCMonitor4RMIS.GetEventName(APSrc: TParameterSource): string;
begin
  case APSrc of
    psBWQry: begin
      if Assigned(FIPCMonitor_BWQry) then
        Result := FIPCMonitor_BWQry.EventName;
    end;
  end;
end;

procedure TFrameIPCMonitor4RMIS.InitVar;
begin
  FPJHTimerPool := TPJHTimerPool.Create(nil);
  FBWQryClass := TBWQryClass.Create(Self);
  FIsSetZeroWhenDisconnect := True;
end;

procedure TFrameIPCMonitor4RMIS.OnSetZeroBWQry(Sender: TObject; Handle: Integer;
  Interval: Cardinal; ElapsedTime: Integer);
begin

end;

procedure TFrameIPCMonitor4RMIS.OverRide_BWQry(AData: TEventData_BWQry);
var
  LValid: Boolean;
begin
  FBWQryClass.Clear;     //UTF8ToString
  JSONToObject(FBWQryClass, PUTF8Char(StringToUTF8(AData.FBWQryClass)), LValid);
end;

procedure TFrameIPCMonitor4RMIS.SendFormCopyData(ToHandle: integer; AForm: TForm);
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

procedure TFrameIPCMonitor4RMIS.SetValue2ScreenEvent(
  AAnalogFunc: TWatchValue2Screen_AnalogEvent;
  ADigitalFunc: TWatchValue2Screen_DigitalEvent);
begin

end;

procedure TFrameIPCMonitor4RMIS.SetValue2ScreenEvent_2(
  AFunc: TWatchValue2Screen_2);
begin

end;

procedure TFrameIPCMonitor4RMIS.UpdateTrace_BWQry(var Msg: TEventData_BWQry);
begin
  if FIsSetZeroWhenDisconnect then
    FPJHTimerPool.AddOneShot(OnSetZeroBWQry, SET_ZERO_INTERVAL_BWQRY);

  OverRide_BWQry(FRIMSData_BWQry);
end;

end.

