unit StopWatch;

interface

uses Windows, SysUtils, DateUtils;

type
  TStopWatch = class
  private
    fFrequency : TLargeInteger;
    fIsRunning: boolean;
    fIsHighResolution: boolean;
    fStartCount,
    fStopCount,
    fAccumulatedTicks : TLargeInteger;
    function GetElapsedTicks: TLargeInteger;
    function GetCurrentElapsedTicks: TLargeInteger;
    function GetElapsedMiliseconds: TLargeInteger;
    function GetElapsed: string;
    function GetCurrentElapsed: string;
    function MillisecondsToDateTime(Milliseconds: Int64): TDateTime;
    function MSec2ElapsedTime(AMilliseconds: Int64): string;
  public
    constructor Create(const startOnCreate : boolean = false) ;
    procedure Start;
    procedure Stop;
    procedure Reset;
    property IsHighResolution : boolean read fIsHighResolution;
    property ElapsedTicks : TLargeInteger read GetElapsedTicks;
    property CurrentElapsedTicks : TLargeInteger read GetCurrentElapsedTicks;
    property AccumulatedTicks : TLargeInteger read fAccumulatedTicks write fAccumulatedTicks;
    property ElapsedMiliseconds : TLargeInteger read GetElapsedMiliseconds;
    property Elapsed : string read GetElapsed;
    property CurrentElapsed : string read GetCurrentElapsed;
    property IsRunning : boolean read fIsRunning;
  end;

implementation

constructor TStopWatch.Create(const startOnCreate : boolean = false) ;
begin
  inherited Create;

  fIsRunning := false;
  fIsHighResolution := False;

  if fIsHighResolution then
  begin
    fIsHighResolution := QueryPerformanceFrequency(fFrequency) ;
    if NOT fIsHighResolution then fFrequency := MSecsPerSec;
  end;

  if startOnCreate then Start;
end;

function TStopWatch.GetElapsedTicks: TLargeInteger;
begin
  result := fStopCount - fStartCount;
end;

{ Converts an Int64 milliseconds from 0001-01-01 to TDateTime variable.}
function TStopWatch.MillisecondsToDateTime(Milliseconds: Int64): TDateTime;
var ts: SysUtils.TTimeStamp;
begin
{ Divide and mod the milliseconds into the TimeStamp record: }
  ts.Date := Milliseconds div MSecsPerDay;
  ts.Time := Milliseconds mod MSecsPerDay;
{ Call TimeStampToDateTime to complete the conversion: }
  Result := SysUtils.TimeStampToDateTime(ts);
end;

function TStopWatch.MSec2ElapsedTime(AMilliseconds: Int64): string;
var
  Hour,Min,Sec : Integer;
begin
  Result := '';

  Hour := AMilliseconds div 3600;
  AMilliseconds := AMilliseconds mod 3600;     { process hours }

  Min := AMilliseconds div 60;
  Sec := AMilliseconds mod 60;                 { process minutes }

  Result := Format('%d : %.2d : %.2d',[Hour,Min,Sec]);
end;

procedure TStopWatch.Reset;
begin
  fIsRunning := False;
  fStartCount := 0;
  fStopCount := 0;
  fAccumulatedTicks := 0;
end;

function TStopWatch.GetCurrentElapsed: string;
var
  dt : Int64;
begin
  Result := '';

  dt := (FAccumulatedTicks + CurrentElapsedTicks) Div MSecsPerSec;

  if dt < 0 then
    exit;

  Result := MSec2ElapsedTime(dt);
end;

function TStopWatch.GetCurrentElapsedTicks: TLargeInteger;
begin
  if fStartCount > 0 then
    result := GetTickCount - fStartCount
  else
    result := 0;
end;

function TStopWatch.GetElapsed: string;
var
  dt : Int64;
begin
  Result := '';

  dt := FAccumulatedTicks Div MSecsPerSec;

  if dt < 0 then
    exit;

  Result := MSec2ElapsedTime(dt);
  //result := Format('%d days, %s', [Trunc(dt), FormatDateTime('hh:nn:ss.z', Frac(dt))]) ;
end;

function TStopWatch.GetElapsedMiliseconds: TLargeInteger;
begin
  result := (MSecsPerSec * (fStopCount - fStartCount)) div fFrequency;
end;

procedure TStopWatch.Start;
begin
  if not fIsRunning then
  begin
    if fIsHighResolution then
      QueryPerformanceCounter(fStartCount)
    else
      fStartCount := GetTickCount;

    fIsRunning := true;
  end;
end;

procedure TStopWatch.Stop;
begin
  if fIsRunning then
  begin
    if fIsHighResolution then
      QueryPerformanceCounter(fStopCount)
    else
      fStopCount := GetTickCount;

    fAccumulatedTicks := fAccumulatedTicks + ElapsedTicks;
    fIsRunning := false;
  end;
end;

end.

{
@see
http://delphi.about.com/od/windowsshellapi/a/delphi-high-performance-timer-tstopwatch.htm

Here's an example of usage:
var
  sw : TStopWatch;
  elapsedMiliseconds : cardinal;
begin
  sw := TStopWatch.Create() ;
  try
    sw.Start;
    //TimeOutThisFunction()
    sw.Stop;

    elapsedMiliseconds := sw.ElapsedMiliseconds;
  finally
    sw.Free;
  end;
end;
}

(*
var { must be global }
  hr, mins, se, s1 : word;

procedure StartClock;
begin
  GetTime (hr,mins,se,s1);
end;

procedure StopClock;
var
  siz : longint;
  hr2, min2, se2  : word;
begin
  GetTime (hr2, min2, se2, s1);
  siz := se2-se+(min2-mins)*60+(hr2-hr)*60*60;
  ShowMessage (IntToStr(siz) + ' seconds');
end;

{ sample how to use it.. very simple }
begin
  StartClock;
  for i := 1 to 100 do
    MyProcedure(i);
  StopClock;
end.
*)
