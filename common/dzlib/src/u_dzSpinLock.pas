unit u_dzSpinLock;

interface

uses
  Windows;

type
  /// <summary> This is a very simple thread synchronisation class that allows to limit
  ///           access to a resource. It uses InterlockedIncrement/Decrement and busy
  ///           waiting, so only use it for very small sections of code e.g.:
  ///
  ///           Lock.Acquire;
  ///           try
  ///             SharedVariable := NewValue;
  ///           finally
  ///             Lock.Release;
  ///           end;
  ///
  ///           For more complex code, use a Mutex or Critical Section </summary>
  TSpinLock = class
  private
    FLock: integer;
  public
    constructor Create;
    /// <summary> try to acquire the lock and sleep (spin) until successfull </summary>
    procedure Acquire;
    /// <summary> try to aquire the lock and return false if it could not be acquired </summary>
    function TryAcquire: boolean;
    /// <summary> release the lock  </summary>
    procedure Release;
  end;

implementation

{ TSimpleSyncRec }

constructor TSpinLock.Create;
begin
  inherited Create;
  FLock := -1;
end;

procedure TSpinLock.Acquire;
begin
  while not TryAcquire do
    Sleep(1);
end;

function TSpinLock.TryAcquire: boolean;
begin
  Result := (InterlockedIncrement(FLock) = 0);
  if not Result then
    InterlockedDecrement(FLock);
end;

procedure TSpinLock.Release;
begin
  InterlockedDecrement(FLock);
end;

end.

