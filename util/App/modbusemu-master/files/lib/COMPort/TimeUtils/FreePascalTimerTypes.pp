{
    This file is part of the Free Component Library (FCL)
    Copyright (c) 1999-2000 by Michael Van Canneyt.

    See the file COPYING.FPC, included in this distribution,
    for details about the copyright.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.

 **********************************************************************}

{
  A generic timer component. Can be used in GUI and non-GUI apps.
  Based heavily on an idea by Graeme Geldenhuys, extended so
  the tick mechanism is pluggable.
  
  Note that the system implementation will only work for timers
  in the main thread, as it uses synchronize to do the job.
  You need to enable threads in your application for the system
  implementation to work.
  
  A nice improvement would be an implementation that works
  in all threads, such as the threadedtimer of IBX for linux.
}

unit FreePascalTimerTypes;

{$mode objfpc}{$H+}

interface

uses
  Classes;

type
  TNOLCLTimerDriver = Class;
  
  TNOLCLCustomTimer = class(TComponent)
  private
    FInterval : Integer;
    FDriver   : TNOLCLTimerDriver;
    FOnTimer  : TNotifyEvent;
    FContinue : Boolean;
    FRunning  : Boolean;
    FEnabled  : Boolean;
    procedure   SetEnabled(Value: Boolean );
  protected
    property  Continue: Boolean read FContinue write FContinue;
    procedure Timer; virtual;
    Function CreateTimerDriver : TNOLCLTimerDriver;
  public
    Constructor Create(AOwner: TComponent); override;
    Destructor Destroy; override;
    procedure StartTimer; virtual;
    procedure StopTimer; virtual;
  protected
    property Enabled  : Boolean read FEnabled write SetEnabled;
    property Interval : Integer read FInterval write FInterval;
    property OnTimer  : TNotifyEvent read FOnTimer write FOnTimer;
  end;

  TNOLCLTimer = Class(TNOLCLCustomTimer)
  Published
    Property Enabled;
    Property Interval;
    Property OnTimer;
  end;  

  TNOLCLTimerDriver = Class(TObject)
  Protected
    FTimer : TNOLCLCustomTimer;
  Public
    Constructor Create(ATimer : TNOLCLCustomTimer); virtual;

    Procedure StartTimer; virtual; abstract;
    Procedure StopTimer; virtual; abstract;

    Property Timer : TNOLCLCustomTimer Read FTimer;
  end;

  TNOLCLTimerDriverClass = Class of TNOLCLTimerDriver;

Var DefaultTimerDriverClass : TNOLCLTimerDriverClass = Nil;

implementation

uses SysUtils;

{ ---------------------------------------------------------------------
    TNOLCLTimer
  ---------------------------------------------------------------------}

constructor TNOLCLCustomTimer.Create(AOwner: TComponent);
begin
  inherited;
  FDriver:=CreateTimerDriver;
end;

destructor TNOLCLCustomTimer.Destroy;
begin
  If FEnabled then StopTimer;
  FDriver.FTimer:=Nil;  
  FreeAndNil(FDriver);
  Inherited;
end;

Function TNOLCLCustomTimer.CreateTimerDriver : TNOLCLTimerDriver;
begin
  Result:=DefaultTimerDriverClass.Create(Self);
end;

procedure TNOLCLCustomTimer.SetEnabled(Value: Boolean);
begin
  if Value <> FEnabled then
   begin
    if Value then StartTimer
     else StopTimer;
   end;
end;

procedure TNOLCLCustomTimer.StartTimer;
begin
  If FEnabled then  Exit;
  FEnabled  := True;
  FContinue := True;
  If Not (csDesigning in ComponentState) then FDriver.StartTimer;
end;

procedure TNOLCLCustomTimer.StopTimer;
begin
  If Not FEnabled then Exit;
  FEnabled  := False;
  FContinue := False;
  FDriver.StopTimer;
end;

procedure TNOLCLCustomTimer.Timer;
begin
  { We check on FEnabled: If by any chance a tick comes in after it was
    set to false, the user won't notice, since no event is triggered.}
  If FEnabled and Assigned(FOnTimer) then FOnTimer(Self);
end;

{ ---------------------------------------------------------------------
  TNOLCLTimerDriver
  ---------------------------------------------------------------------}
  

Constructor TNOLCLTimerDriver.Create(ATimer : TNOLCLCustomTimer);
begin
  FTimer:=ATimer;
end;

{ ---------------------------------------------------------------------
    Default implementation. Threaded timer, one thread per timer.
  ---------------------------------------------------------------------}
  
Type
  TNOLCLTimerThread = class(TThread)
  private
    FTimerDriver : TNOLCLTimerDriver;
    Function Timer : TNOLCLCustomTimer;
  public
    procedure Execute; override;
    constructor CreateTimerThread(ATimerDriver: TNOLCLTimerDriver);
  end;

  TFPThreadedTimerDriver = Class(TNOLCLTimerDriver)
  Private
    FThread : TNOLCLTimerThread;
    Procedure DoNilTimer(Sender : TObject);
  Public
    Procedure StartTimer; override;
    Procedure StopTimer; override;
  end;

function _GetTickCount: Cardinal;
begin
  Result := Cardinal(Trunc(Now * 24 * 60 * 60 * 1000));
end;

{ ---------------------------------------------------------------------
    TFPTimerThread
  ---------------------------------------------------------------------}
  
constructor TNOLCLTimerThread.CreateTimerThread(ATimerDriver: TNOLCLTimerDriver);
begin
  inherited Create(True);
  FTimerDriver    := ATimerDriver;
  FreeOnTerminate := True;
end;

Function TNOLCLTimerThread.Timer : TNOLCLCustomTimer;
begin
  If Assigned(FTimerDriver) Then Result:=FTimerDriver.FTimer
   else Result:=Nil;
end;

procedure TNOLCLTimerThread.Execute;
var
  SleepTime : Integer;
  S,Last    : Cardinal;
  T         : TNOLCLCustomTimer;
begin
  while not Terminated do
   begin
    Last := _GetTickCount;
    T:=Timer;
    If Assigned(T) then
     begin
      SleepTime := T.FInterval - (_GetTickCount - Last);
      if SleepTime < 10 then SleepTime := 10;
      Repeat  
       S:=5;
       If S>SleepTime then S:=SleepTime;
       Sleep(S);
       Dec(Sleeptime,S);
      until (SleepTime<=0) or Terminated;
      T:=Timer;
      If Assigned(T) and not terminated then Synchronize(@T.Timer);
     end
    else Terminate;
   end;
end;

{ ---------------------------------------------------------------------
    TFPThreadedTimerDriver
  ---------------------------------------------------------------------}

Procedure TFPThreadedTimerDriver.DoNilTimer(Sender : TObject);
begin
  FThread:=Nil;
end;

Procedure TFPThreadedTimerDriver.StartTimer; 
begin
  FThread:=TNOLCLTimerThread.CreateTimerThread(Self);
  FThread.OnTerminate := @DoNilTimer;
  FThread.Start;
end;

Procedure TFPThreadedTimerDriver.StopTimer;
begin
  FThread.FTimerDriver :=Nil;
  FThread.Terminate; // Will free itself.
  CheckSynchronize;  // make sure thread is not stuck at synchronize call.
  If Assigned(FThread) then Fthread.WaitFor;
end;


Initialization
  DefaultTimerDriverClass := TFPThreadedTimerDriver;
end.

