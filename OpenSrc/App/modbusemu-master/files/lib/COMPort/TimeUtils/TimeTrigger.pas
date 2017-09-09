unit TimeTrigger;

interface

uses {$IFDEF WINDOWS} Windows, Messages, {$ENDIF} Classes;

{$IFDEF WINDOWS}

type
  TNPCTimer = class(TComponent)
  private
    FEnabled      : Boolean;                      // активен или нет таймер
    FTimerID      : Integer;                      // идентификатор таймера
    FInterval     : Cardinal;                     // интервал таймера
    FWindowHandle : HWND;                         // окно таймера
    FOnTimer      : TNotifyEvent;                 // обработчик события таймера
    procedure UpdateTimer;
    procedure SetEnabled(Value: Boolean);
    procedure SetInterval(Value: Cardinal);
    procedure SetOnTimer(Value: TNotifyEvent);
    procedure WndProc(var Msg: TMessage);
    procedure SetTimerID(const Value: Integer);
  protected
    procedure Timer; dynamic;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
  published
    property TimerID  : Integer read FTimerID write SetTimerID default 1;
    property Enabled  : Boolean read FEnabled write SetEnabled default True;
    property Interval : Cardinal read FInterval write SetInterval default 1000;
    property OnTimer  : TNotifyEvent read FOnTimer write SetOnTimer;
  end;

  TNPCTimeTrigger = class
  private
   FCocked           : Boolean;             // взведен или сброшен триггер. во взведенном состоянии отсчитывается время
   FAutoResetTrigger : Boolean;             // автовзвод триггера после сброса
   FHandleTimeOut    : Boolean;             // обрабатывать таймаут
   FTriggerStartTime : Cardinal;            // время старта триггера
   FTriggerStopTime  : Cardinal;            // время остновки триггера
   FTimer            : TNPCTimer;           // таймер триггера
   FOnCocked         : TNotifyEvent;        // событие взвода триггера
   FOnDischarged     : TNotifyEvent;        // событие сброса триггера
   FOnTriggerTimeout : TNotifyEvent;        // тамаут триггера
   function  GetCocked: Boolean;
   function  GetAutoResetTrigger: Boolean;
   function  GetTimeOutInterval: Cardinal;
   function  GetHandleTimeOut: Boolean;
   procedure SetCocked(const Value: Boolean);
   procedure SetAutoResetTrigger(const Value: Boolean);
   procedure SetTimeOutInterval(const Value: Cardinal);
   procedure SetHandleTimeOut(const Value: Boolean);
   function  GetTriggerWorkTime: Cardinal;
   function  GetTriggerID: Integer;
   procedure SetTriggerID(const Value: Integer);
  protected
   procedure OnTimerProc(Sender : TObject); dynamic;
  public
   constructor Create; virtual;
   destructor Destroy; override;
   property Cocked           : Boolean read GetCocked write SetCocked default False;
   property AutoResetTrigger : Boolean read GetAutoResetTrigger write SetAutoResetTrigger default False;
   property HandleTimeOut    : Boolean read GetHandleTimeOut write SetHandleTimeOut default False;
   property TimeOutInterval  : Cardinal read GetTimeOutInterval write SetTimeOutInterval default 1000;
   property TriggerID        : Integer read GetTriggerID write SetTriggerID default 1;
   property TriggerWorkTime  : Cardinal read GetTriggerWorkTime;
   property OnCocked         : TNotifyEvent read FOnCocked write FOnCocked;
   property OnDischarged     : TNotifyEvent read FOnDischarged write FOnDischarged;
   property OnTriggerTimeout : TNotifyEvent read FOnTriggerTimeout write FOnTriggerTimeout;
  end;

{$ENDIF}

implementation

uses SysUtils;

{$IFDEF WINDOWS}

{ TNPCTimeTrigger }

constructor TNPCTimeTrigger.Create;
begin
 FTimer:=TNPCTimer.Create(nil);
 FTimer.OnTimer    := OnTimerProc;
 FCocked           := False;
 FAutoResetTrigger := False;
 FHandleTimeOut    := True;
 FTriggerStartTime := 0;
 FTriggerStopTime  := 0;
end;

destructor TNPCTimeTrigger.Destroy;
begin
  Cocked:=False;
  if FTimer.Enabled then FTimer.Enabled :=False;
  FreeAndNil(FTimer);
  inherited;
end;

function TNPCTimeTrigger.GetCocked: Boolean;
begin
  Result:=FCocked;
end;

function TNPCTimeTrigger.GetAutoResetTrigger: Boolean;
begin
  Result:=FAutoResetTrigger;
end;

function TNPCTimeTrigger.GetTimeOutInterval: Cardinal;
begin
  Result:=FTimer.Interval;
end;

function TNPCTimeTrigger.GetHandleTimeOut: Boolean;
begin
  Result:=FHandleTimeOut;
end;

procedure TNPCTimeTrigger.OnTimerProc(Sender: TObject);
begin
  if not FHandleTimeOut then Exit;
  SetCocked(False);
  if Assigned(FOnTriggerTimeout) then FOnTriggerTimeout(Self);
end;

procedure TNPCTimeTrigger.SetAutoResetTrigger(const Value: Boolean);
begin
  if FAutoResetTrigger=Value then Exit;
  FAutoResetTrigger:=Value;
end;

procedure TNPCTimeTrigger.SetTimeOutInterval(const Value: Cardinal);
begin
  if FTimer.Interval=Value then Exit;
  FTimer.Interval:=Value;
end;

procedure TNPCTimeTrigger.SetCocked(const Value: Boolean);
begin
  if FCocked=Value then Exit;
  FCocked:=Value;
  if FCocked then
   begin
    if Assigned(FOnCocked) then FOnCocked(Self);
    FTriggerStartTime:=GetTickCount;
    FTriggerStopTime:=FTriggerStartTime;
    if FHandleTimeOut then FTimer.Enabled:=True;
   end
  else
   begin
    if FHandleTimeOut then FTimer.Enabled:=False;
    FTriggerStopTime:=GetTickCount;
    if Assigned(FOnDischarged) then FOnDischarged(Self);
    if FAutoResetTrigger then SetCocked(True);
   end;
end;

procedure TNPCTimeTrigger.SetHandleTimeOut(const Value: Boolean);
begin
  if FHandleTimeOut=Value then Exit;
  FHandleTimeOut:=Value;
end;

function TNPCTimeTrigger.GetTriggerWorkTime: Cardinal;
begin
  if FTriggerStartTime=FTriggerStopTime then
   begin
    Result:= GetTickCount-FTriggerStartTime;
   end
  else
   begin
    Result:= FTriggerStopTime-FTriggerStartTime;
   end;
end;

function TNPCTimeTrigger.GetTriggerID: Integer;
begin
  Result := FTimer.TimerID;
end;

procedure TNPCTimeTrigger.SetTriggerID(const Value: Integer);
begin
  if FTimer.TimerID=Value then Exit;
  FTimer.TimerID:=Value;
end;

{ TNPCTimer }

constructor TNPCTimer.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FTimerID      := 1;
  FEnabled      := False;
  FInterval     := 1000;
  FWindowHandle := AllocateHWnd(WndProc);
end;

destructor TNPCTimer.Destroy;
begin
  FEnabled := False;
  UpdateTimer;
  DeallocateHWnd(FWindowHandle);
  inherited Destroy;
end;

procedure TNPCTimer.WndProc(var Msg: TMessage);
begin
  with Msg do
    if Msg = WM_TIMER then
      try
       if WParam = FTimerID then Timer;
      except
        //Application.HandleException(Self);
      end
    else
      Result := DefWindowProc(FWindowHandle, Msg, wParam, lParam);
end;

procedure TNPCTimer.UpdateTimer;
begin
  KillTimer(FWindowHandle, FTimerID);
  if (FInterval <> 0) and FEnabled and Assigned(FOnTimer) then
    {if }SetTimer(FWindowHandle, FTimerID, FInterval, nil);{ = 0 then
      raise EOutOfResources.Create(SNoTimers);}
end;

procedure TNPCTimer.SetEnabled(Value: Boolean);
begin
  if Value = FEnabled then Exit;
  FEnabled := Value;
  UpdateTimer;
end;

procedure TNPCTimer.SetInterval(Value: Cardinal);
begin
  if Value = FInterval then Exit;
  FInterval := Value;
  UpdateTimer;
end;

procedure TNPCTimer.SetOnTimer(Value: TNotifyEvent);
begin
  FOnTimer := Value;
  UpdateTimer;
end;

procedure TNPCTimer.Timer;
begin
  if Assigned(FOnTimer) then FOnTimer(Self);
end;

procedure TNPCTimer.SetTimerID(const Value: Integer);
begin
  if FTimerID = Value then Exit;
  KillTimer(FWindowHandle,FTimerID);
  FTimerID := Value;
  UpdateTimer;
end;

{$ENDIF}

end.