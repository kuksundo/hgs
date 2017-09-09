unit u_dzCriticalSection;

{.$DEFINE debug_Crit_Sect}

interface

uses
  Windows,
  SyncObjs;

type
  TdzCriticalSection = class(TCriticalSection)
  private
    // see
    // http://delphitools.info/2011/11/30/fixing-tcriticalsection/
    // for an explanation why this should speed up execution on multi core systems
    FDummy: array[0..95] of Byte;
{$IFDEF debug_Crit_Sect}
    FLockCount: Integer;
    FOwner: Integer;
{$ENDIF debug_Crit_Sect}
  public
    constructor Create;
{$IFDEF debug_Crit_Sect}
    procedure Acquire; override;
    procedure Release; override;
{$ENDIF debug_Crit_Sect}
  end;

implementation

{ TdzCriticalSection }

constructor TdzCriticalSection.Create;
begin
  inherited Create;
  fDummy[0] := 0; // keep the compiler from optimizing it away or complaining about it not being used
end;

{$IFDEF debug_Crit_Sect}

procedure TdzCriticalSection.Acquire;
begin
  InterlockedIncrement(FLockCount);
  inherited;
  FOwner := GetCurrentThreadId;
end;

procedure TdzCriticalSection.Release;
begin
  inherited;
  if InterlockedDecrement(FLockCount) < 0 then
    Assert(flockcount < 10);
end;
{$ENDIF debug_Crit_Sect}

end.

