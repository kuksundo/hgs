// It's a microsecond timer, based on TSC Pentium register.
// It's not a component, only two objects:
// - simple timer
// - and stacked one, provided more powerfull code
//
// timer written for Delphi 7, but, afaik, will work on earlier versions too.
//
// Leonid Koninin, 2007
//
// No any warranties. Can be used absolutely free.
//

unit Timer;
{$IFDEF FPC}
{$ASMMODE intel}
{$ENDIF FPC}

interface

uses winapi.windows;
{$I defines.inc}

type
  TLkBaseTimer = class
  protected
    FOver: int64;
    FStart: int64;
    FDiv: int64;
  public
    property TickStart: int64 read FStart;
    property TickDivisor: int64 read FDiv;

    function Tick: int64; register;
    function TickPeriod: int64; register;

    procedure TimeStart;
    function TimePeriod: int64;

    procedure Calibrate;

    constructor Create;
    class function One: TLkBaseTimer;
  end;

  TLkStackTimer = class
  protected
    stk: array[0..30] of int64;
    stp: Integer;
    FDiv: int64;
    FOver: int64;
    function Tick: int64; register;
    function TickInterval(pop: Boolean = true): int64;
  public
    procedure TimerStart;
    function TimerInterval(pop: Boolean = true): int64;

    procedure Calibrate;
    constructor Create;
  end;

function HPT: TLkBaseTimer;

implementation

uses system.SysUtils,
  MMSystem;

function HPT: TLkBaseTimer;
begin
  result := TLkBaseTimer.One;
end;

{ TLkBaseTimer }

var
  AnOne: TLkBaseTimer = nil;

procedure TLkBaseTimer.Calibrate;
var
  mtmr, tmr: int64;
  i, j: Integer;
begin
  FOver := 0;
  mtmr := $FFFFFFFFFF;
  for i := 0 to 19 do
    begin
      TimeStart;
      tmr := TickPeriod;
      if mtmr > tmr then mtmr := tmr;
    end;
  FOver := mtmr;
  timeBeginPeriod(1);
  sleep(50);
  TimeStart;
  Sleep(750);
  tmr := Tick - FStart - FOver;
  timeEndPeriod(1);
// microseconds
  FDiv := tmr div 750000;
end;

constructor TLkBaseTimer.Create;
begin
  inherited Create;
  Calibrate;
end;

class function TLkBaseTimer.One: TLkBaseTimer;
begin
  if not assigned(AnOne) then AnOne := TLkBaseTimer.Create;
  result := AnOne;
end;

function TLkBaseTimer.Tick: int64; register;
//asm
 // rdtsc;
//db 0fh, 31h 
//end;
asm
  rdtsc
{$IFDEF CPU64}
  shl   rdx, 32
  or    rax, rdx
{$ENDIF CPU64}
end; { GetCPUTimeStamp }


function TLkBaseTimer.TickPeriod: int64; register;
begin
  result := Tick - FStart - FOver;
end;

function TLkBaseTimer.TimePeriod: int64; register;
begin
  result := Tick - FStart - FOver;
  result := result div FDiv;
end;

procedure TLkBaseTimer.TimeStart;
begin
  FStart := Tick;
end;

{ TLkStackTimer }

procedure TLkStackTimer.Calibrate;
var
  i: Integer;
  zz: array[0..19] of int64;
begin
  for i := 0 to 19 do
    begin
      TimerStart;
      zz[i] := TickInterval;
    end;
  FOver := zz[0];
  for i := 1 to 19 do if FOver > zz[i] then FOver := zz[i];
  FDiv := AnOne.TickDivisor;
end;

constructor TLkStackTimer.Create;
begin
  inherited Create;
  stp := -1;
  Calibrate;
end;

function TLkStackTimer.Tick: int64;
//asm
 //db 0fh, 31h 
 // rdtsc;
//end;
asm
  rdtsc
{$IFDEF CPU64}
  shl   rdx, 32
  or    rax, rdx
{$ENDIF CPU64}
end; { GetCPUTimeStamp }


function TLkStackTimer.TickInterval(pop: Boolean = true): int64;
begin
  result := AnOne.Tick - stk[stp] - FOver;
  if (pop) and (stp >= 0) then dec(stp);
end;

function TLkStackTimer.TimerInterval(pop: Boolean): int64;
begin
  result := AnOne.Tick - stk[stp] - FOver;
  result := result div FDiv;
  if (pop) and (stp >= 0) then dec(stp);
end;

procedure TLkStackTimer.TimerStart;
begin
  inc(stp);
  stk[stp] := Tick;
end;

initialization
  TLkBaseTimer.One;

finalization
  if Assigned(AnOne) then FreeAndNil(AnOne);

end.

