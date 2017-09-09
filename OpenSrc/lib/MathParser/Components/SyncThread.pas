{ *********************************************************************** }
{                                                                         }
{ SyncThread                                                              }
{                                                                         }
{ Copyright (c) 2008 Pisarev Yuriy (post@pisarev.net)                     }
{                                                                         }
{ *********************************************************************** }

unit SyncThread;

{$B-}

interface

uses
  Windows, Messages, Classes, Forms, Thread;

const
  DefaultInterval = 10;

type
  TSyncTimer = class(TComponent)
  private
    FUpdateCount: Integer;
    FInterval: Integer;
    FLock: TRTLCriticalSection;
    FWindowHandle: THandle;
  protected
    procedure WindowMethod(var Message: TMessage); virtual;
    property WindowHandle: THandle read FWindowHandle write FWindowHandle;
    property Lock: TRTLCriticalSection read FLock write FLock;
    property UpdateCount: Integer read FUpdateCount write FUpdateCount;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure SetTimer; virtual;
    procedure DeleteTimer; virtual;
  published
    property Interval: Integer read FInterval write FInterval default DefaultInterval;
  end;

  TSyncThread = class;

  TSyncMethod = procedure(Thread: TSyncThread) of object;

  TSyncThread = class(TThread)
  private
    FTimer: TSyncTimer;
    FOnDone: TSyncMethod;
    FOnWork: TSyncMethod;
  protected
    procedure Notification(Component: TComponent; Operation: TOperation); override;
    procedure Work; override;
    procedure Done; override;
    procedure DoWork; virtual;
    procedure DoDone; virtual;
  public
    procedure Synchronize(const AMethod: TThreadMethod); override;
    function Start: Boolean; override;
  published
    property Timer: TSyncTimer read FTimer write FTimer;
    property OnWork: TSyncMethod read FOnWork write FOnWork;
    property OnDone: TSyncMethod read FOnDone write FOnDone;
  end;

const
  TimerIdent = 1;

procedure Register;

implementation

uses
  ThreadUtils;

procedure Register;
begin
  RegisterComponents('Samples', [TSyncTimer, TSyncThread]);
end;

{ TSyncTimer }

constructor TSyncTimer.Create(AOwner: TComponent);
begin
  inherited;
  FInterval := DefaultInterval;
  FWindowHandle := AllocateHWnd(WindowMethod);
  InitializeCriticalSection(FLock);
end;

procedure TSyncTimer.DeleteTimer;
begin
  Enter(FLock);
  try
    Dec(FUpdateCount);
    if FUpdateCount = 0 then KillTimer(FWindowHandle, TimerIdent);
  finally
    Leave(FLock);
  end;
end;

destructor TSyncTimer.Destroy;
begin
  DeleteTimer;
  DeallocateHWnd(FWindowHandle);
  DeleteCriticalSection(FLock);
  inherited;
end;

procedure TSyncTimer.SetTimer;
begin
  Enter(FLock);
  try
    if FUpdateCount = 0 then
      Windows.SetTimer(FWindowHandle, TimerIdent, FInterval, nil);
    Inc(FUpdateCount);
  finally
    Leave(FLock);
  end;
end;

procedure TSyncTimer.WindowMethod(var Message: TMessage);
begin
  if Message.Msg = WM_TIMER then
  try
    CheckSynchronize;
  except
    Application.HandleException(Self);
  end
  else Message.Result := DefWindowProc(FWindowHandle, Message.Msg, Message.WParam, Message.LParam);
end;

{ TSyncThread }

procedure TSyncThread.DoDone;
begin
  if Assigned(FOnDone) then
    if MainThread then FOnDone(Self)
    else Synchronize(DoDone);
end;

procedure TSyncThread.Done;
begin
  DoDone;
  if Assigned(FTimer) then FTimer.DeleteTimer;
end;

procedure TSyncThread.DoWork;
begin
  if Assigned(FOnWork) then FOnWork(Self);
end;

procedure TSyncThread.Notification(Component: TComponent; Operation: TOperation);
begin
  inherited;
  if (Component = FTimer) and (Operation = opRemove) then FTimer := nil;
end;

function TSyncThread.Start: Boolean;
begin
  if Assigned(FTimer) then FTimer.SetTimer;
  Result := inherited Start;
end;

procedure TSyncThread.Synchronize(const AMethod: TThreadMethod);
begin
  if Assigned(FTimer) then inherited Synchronize(AMethod);
end;

procedure TSyncThread.Work;
begin
  DoWork;
end;

end.
