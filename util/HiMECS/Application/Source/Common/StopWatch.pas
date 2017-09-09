unit StopWatch;

interface

uses Windows, SysUtils, DateUtils;

type
  TTimeResolution = (trMiliSec, trSec, trMin, trHour);

  TStopWatch = class
  private
    fFrequency : TLargeInteger;
    fIsRunning: boolean;
    fIsHighResolution: boolean;
    fStartCount,
    fStopCount,
    fAccumulatedTicks : TLargeInteger;
    procedure SetTickStamp(var lInt : TLargeInteger; ATimeRes: TTimeResolution=trSec);
    function GetElapsedTicks: TLargeInteger;
    function GetElapsedMiliseconds: TLargeInteger;
    function GetElapsed: string;
  public
    constructor Create(const startOnCreate : boolean = false) ;
    procedure Start;
    procedure Stop;
    procedure Reset;
    function MillisecondsToDateTime(Milliseconds: Int64): TDateTime;

    property IsHighResolution : boolean read fIsHighResolution;
    property ElapsedTicks : TLargeInteger read GetElapsedTicks;
    property AccumulatedTicks : TLargeInteger read fAccumulatedTicks write fAccumulatedTicks;
    property ElapsedMiliseconds : TLargeInteger read GetElapsedMiliseconds;
    property Elapsed : string read GetElapsed;
    property IsRunning : boolean read fIsRunning;
  end;

implementation

constructor TStopWatch.Create(const startOnCreate : boolean = false) ;
begin
  inherited Create;

  fIsRunning := false;

  fIsHighResolution := QueryPerformanceFrequency(fFrequency) ;
  if NOT fIsHighResolution then fFrequency := MSecsPerSec;

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

procedure TStopWatch.Reset;
begin
  fIsRunning := False;
  fStartCount := 0;
  fStopCount := 0;
  fAccumulatedTicks := 0;
end;

procedure TStopWatch.SetTickStamp(var lInt : TLargeInteger; ATimeRes: TTimeResolution=trSec) ;
begin
  if fIsHighResolution then
    QueryPerformanceCounter(lInt)
  else
  begin
    case ATimeRes of
      trMiliSec: lInt := MilliSecondOf(Now);
      trSec: lInt := SecondOf(Now);
      trMin: lInt := MinuteOf(Now);
    end;
  end;

end;

function TStopWatch.GetElapsed: string;
var
  dt : Int64;
  Hour,Min,Sec : Integer;
begin
  Result := '';
  dt := FAccumulatedTicks Div MSecsPerSec;
  
  if dt < 0 then
    exit;
  
  Hour := dt div 3600;
  dt := dt mod 3600;               { process hours }
  
  Min := dt div 60;
  Sec := dt mod 60;                 { process minutes }

  Result := Format('%d Hour, %.2d Min',[Hour,Min]);
  //result := Format('%d days, %s', [Trunc(dt), FormatDateTime('hh:nn:ss.z', Frac(dt))]) ;
end;

function TStopWatch.GetElapsedMiliseconds: TLargeInteger;
begin
  result := (MSecsPerSec * (fStopCount - fStartCount)) div fFrequency;
end;

procedure TStopWatch.Start;
begin
  //SetTickStamp(fStartCount) ;
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
  //SetTickStamp(fStopCount) ;
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
