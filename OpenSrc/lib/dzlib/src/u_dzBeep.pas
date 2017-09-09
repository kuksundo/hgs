unit u_dzBeep;

interface

uses
  Windows,
  SysUtils,
  SyncObjs,
  u_dzNamedThread;

type
  TBeepSequenceEntry = record
    Frequency: Cardinal;
    Duration: Cardinal;
    class function Create(_Frequency, _Duration: Cardinal): TBeepSequenceEntry; static;
    procedure Init(_Frequency, _Duration: Cardinal); // inline does not work!
  end;

  TBeepSequenceList = array of TBeepSequenceEntry;

  ///<summary> Windows.Beep is synchronous, so it does not return until
  ///          the beep's duration has passed. This is a problem if you
  ///          cannot afford to block the current thread that long.
  ///          This class creates a thread (singleton) that does the
  ///          call for other threads. Note that I have not put much
  ///          work into making it really threadsafe, I rely on
  ///          writes to DWords being atomic operations and just
  ///          use two fields to pass the parameters. It is quite
  ///          possible for other threads to change these parameters
  ///          before they ever reach the Beeper thread, but all that
  ///          would cause is some weird beeping, so I can't be bothered.
  TBeeper = class(TNamedThread)
  private
    FSequence: array of TBeepSequenceEntry;
    FEvent: TEvent;
    FMutex: TMutex;
    procedure Terminate;
  protected
    procedure Execute; override;
  public
    ///<summary> Converts a string of the form '<frequency>/<duration>[,<frequency>/<duration> ...]'
 ///          to a TBeepSequenceList </summary>
    class function StrToBeepSequence(_Str: string; out _BeepSeq: TBeepSequenceList): Boolean; static;
    constructor Create;
    destructor Destroy; override;
    procedure Beep(_Frequency, _Duration: Cardinal); overload;
    procedure Beep(_Sequence: array of TBeepSequenceEntry); overload;
    procedure Beep(_Sequence: string); overload;
  end;

function Beeper: TBeeper;

implementation

uses
  u_dzStringUtils;

var
  gblBeeper: TBeeper = nil;

function Beeper: TBeeper;
begin
  if not Assigned(gblBeeper) then
    gblBeeper := TBeeper.Create;
  Result := gblBeeper;
end;

{ TBeeper }

procedure TBeeper.Beep(_Frequency, _Duration: Cardinal);
begin
  Beep([TBeepSequenceEntry.Create(_Frequency, _Duration)]);
end;

procedure TBeeper.Beep(_Sequence: array of TBeepSequenceEntry);
var
  i: Integer;
begin
  // only beep if no other beep is active
  // protect the beep sequence
  if FMutex.WaitFor(0) = wrSignaled then begin
    try
      SetLength(FSequence, Length(_Sequence));
      for i := Low(_Sequence) to High(_Sequence) do
        FSequence[i] := _Sequence[i];
      FEvent.SetEvent;
    finally
      FMutex.Release;
    end;
  end;
end;

procedure TBeeper.Beep(_Sequence: string);
var
  Arr: TBeepSequenceList;
begin
  if _Sequence = '' then
    Exit;
  StrToBeepSequence(_Sequence, Arr);
  Beep(Arr);
end;

constructor TBeeper.Create;
begin
  FMutex := TMutex.Create;
  FEvent := TEvent.Create;
  inherited Create(False);
end;

destructor TBeeper.Destroy;
begin
  Terminate;
  inherited;
  FreeAndNil(FEvent);
  FreeAndNil(FMutex);
end;

procedure TBeeper.Execute;
var
  wr: TWaitResult;
  i: Integer;
begin
  inherited;
  while not Terminated do begin
    wr := FEvent.WaitFor(INFINITE);
    if Terminated or (wr <> wrSignaled) then
      Exit; // --->
    // protecte the sequence
    // If we can't get the mutex, we set a new sequence
    if FMutex.WaitFor(0) = wrSignaled then begin
      try
        for i := Low(FSequence) to High(FSequence) do begin
          if FSequence[i].Frequency = 0 then
            Sleep(FSequence[i].Duration)
          else if FSequence[i].Frequency < 37 then
            Windows.Beep(37, FSequence[i].Duration)
          else if FSequence[i].Frequency > 32767 then begin
            Windows.Beep(32767, FSequence[i].Duration);
          end else
            Windows.Beep(FSequence[i].Frequency, FSequence[i].Duration);
        end;
      finally
        FMutex.Release;
      end;
    end;
    FEvent.ResetEvent;
  end;
end;

procedure TBeeper.Terminate;
begin
  inherited Terminate;
  FEvent.SetEvent;
  WaitFor;
end;

class function TBeeper.StrToBeepSequence(_Str: string; out _BeepSeq: TBeepSequenceList): Boolean;
var
  FirstEntry: string;
  Frequence: string;
  FreqInt: Integer;
  TimeInt: Integer;
begin
  Result := False;
  SetLength(_BeepSeq, 0);
  while ExtractFirstWord(_Str, [','], FirstEntry) do begin
    Result := ExtractFirstWord(FirstEntry, ['/'], frequence);
    if not Result then
      Exit; // -->

    Result := TryStrToInt(Frequence, Freqint) and TryStrToInt(FirstEntry, TimeInt);
    if not Result then
      Exit; //; -->

    SetLength(_BeepSeq, Length(_BeepSeq) + 1);
    _BeepSeq[High(_BeepSeq)] := TBeepSequenceEntry.Create(freqint, timeint);
  end;
end;

{ TBeepSequenceEntry }

class function TBeepSequenceEntry.Create(_Frequency, _Duration: Cardinal): TBeepSequenceEntry;
begin
  Result.Init(_Frequency, _Duration);
end;

procedure TBeepSequenceEntry.Init(_Frequency, _Duration: Cardinal);
begin
  Frequency := _Frequency;
  Duration := _Duration;
end;

initialization
finalization
  if Assigned(gblBeeper) then begin
    gblBeeper.Terminate;
    FreeAndNil(gblBeeper);
  end;
end.

