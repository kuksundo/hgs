unit MyThreadedTimer;

{$mode objfpc}

interface

uses
  Classes, SysUtils, syncobjs,
  LoggerItf;

type
  TSimpleThreadedTimer = class;

  { TTimerThread }

  TTimerThread  = class(TThreadLogged)
  private
   FEvent    : TSimpleEvent;
   FTimerObj : TSimpleThreadedTimer;
  protected
   procedure Execute; override;
   procedure Timer;
  public
   constructor Create(ATimerObj : TSimpleThreadedTimer); virtual;
   destructor  Destroy; override;

   property Event : TSimpleEvent read FEvent;
  end;

  { TSimpleThreadedTimer }

  TSimpleThreadedTimer = class(TObjectLogged)
  private
   FInterval          : Integer;
   FIsSyncroTimerProc : Boolean;
   FOnTimer           : TNotifyEvent;
   FTimerThread       : TTimerThread;

   function  GetEnable: Boolean;
   procedure SetEnable(AValue: Boolean);
  protected
   procedure StartTimer;
   procedure StopTimer;

   procedure SetLogger(const Value: IDLogger); override;
  public
   constructor Create; virtual;
   destructor  Destroy; override;

   property IsSyncroTimerProc : Boolean read FIsSyncroTimerProc write FIsSyncroTimerProc;
   property Enabled           : Boolean read GetEnable write SetEnable;
   property Interval          : Integer read FInterval write FInterval;
   property OnTimer           : TNotifyEvent read FOnTimer write FOnTimer;
  end;

implementation

{ TSimpleThreadedTimer }

constructor TSimpleThreadedTimer.Create;
begin
  FTimerThread := nil;
  FInterval    := 1000;
  {$IFDEF LCL}
  FIsSyncroTimerProc:= True;
  {$ELSE}
  FIsSyncroTimerProc:= False;
  {$ENDIF}
end;

destructor TSimpleThreadedTimer.Destroy;
begin
  StopTimer;
  inherited Destroy;
end;

function TSimpleThreadedTimer.GetEnable: Boolean;
begin
  Result := Assigned(FTimerThread);
end;

procedure TSimpleThreadedTimer.SetEnable(AValue: Boolean);
begin
  if AValue then
   begin
    if Assigned(FTimerThread) then Exit;
    StartTimer;
   end
  else
   begin
    if not Assigned(FTimerThread) then Exit;
    StopTimer;
   end;
end;

procedure TSimpleThreadedTimer.StartTimer;
begin
  if Assigned(FTimerThread) then Exit;

  FTimerThread := TTimerThread.Create(Self);
  FTimerThread.Logger := Logger;
  FTimerThread.Start;
end;

procedure TSimpleThreadedTimer.StopTimer;
begin
  if not Assigned(FTimerThread) then Exit;

  FTimerThread.Event.SetEvent;

  FTimerThread.Terminate;
//  FTimerThread.WaitFor;
  FreeAndNil(FTimerThread);
end;

procedure TSimpleThreadedTimer.SetLogger(const Value: IDLogger);
begin
  inherited SetLogger(Value);
  if Assigned(FTimerThread) then FTimerThread.Logger := Logger;
end;

{ TTimerThread }

procedure TTimerThread.Execute;
var Res : TWaitResult;
begin
  while not Terminated do
   begin
    Res := FEvent.WaitFor(FTimerObj.Interval);
    case Res of
     wrSignaled : Continue;
     wrTimeout  : begin
                   if FTimerObj.IsSyncroTimerProc then Synchronize(@Timer)
                    else
                      Timer;
                  end;
    else
     Sleep(10);
    end;
   end;
end;

procedure TTimerThread.Timer;
begin
  if Assigned(FTimerObj.OnTimer) then FTimerObj.OnTimer(FTimerObj);
end;

constructor TTimerThread.Create(ATimerObj: TSimpleThreadedTimer);
begin
  inherited Create(True,65535);
  FTimerObj := ATimerObj;
  FEvent    := TSimpleEvent.Create;
end;

destructor TTimerThread.Destroy;
begin
  FEvent.Free;
  inherited Destroy;
end;

end.

