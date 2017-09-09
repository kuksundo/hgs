unit u_dzInterlocked;

interface

uses
  Windows;

///<summary> Tries to interlocked mask the Destination with an AND and an OR mask.
///          @returns true if the operation succeeded </summary>
function TryInterlockedMask(var _Destination: LongWord; _AndMask, _OrMask: LongWord): boolean;

///<summary> Calls TryInterlockedMask until it succeeds, sleeps for
///          1 millisecond every time it fails. </summary>
procedure InterlockedMaskSleep(var _Destination: LongWord; _AndMask, _OrMask: LongWord); inline;
///<summary> Interlocked ANDs the Destination MASK, waits until the operation succeeded, sleeps for
///          1 millisecond every time it fails. </summary>
procedure InterlockedAndSleep(var _Destination: LongWord; _Mask: LongWord); inline;
///<summary> Interlocked ORs the Destination MASK, waits until the operation succeeded, sleeps for
///          1 millisecond every time it fails. </summary>
procedure InterlockedOrSleep(var _Destination: LongWord; _Mask: LongWord); inline;

///<summary> Calls TryInterlockedMask until it succeeds </summary>
procedure InterlockedMaskSpin(var _Destination: LongWord; _AndMask, _OrMask: LongWord); inline;
///<summary> Interlocked ANDs the Destination MASK, waits until the operation succeeded. </summary>
procedure InterlockedAndSpin(var _Destination: LongWord; _Mask: LongWord); inline;
///<summary> Interlocked ORs the Destination MASK, waits until the operation succeeded. </summary>
procedure InterlockedOrSpin(var _Destination: LongWord; _Mask: LongWord); inline;

implementation

// InterlockedCompareExchange implements the following as an atomic operation:
// function InterlockedCompareExchange(var _Destination: integer; _NewValue, _OldValue: integer);
// begin
//   Result := _Destination;
//   if _Destination = OldValue then
//     _Destination := NewValue;
// end;
// redeclared to take LongWord parameters

function InterlockedCompareExchange(var _Destination: LongWord; _NewValue, _OldValue: LongWord): LongWord; cdecl;
  external kernel32 name 'InterlockedCompareExchange';

function TryInterlockedMask(var _Destination: LongWord; _AndMask, _OrMask: LongWord): boolean;
var
  OldValue: LongWord;
  NewValue: LongWord;
  CurValue: LongWord;
begin
  OldValue := _Destination;
  NewValue := OldValue and _AndMask or _OrMask;
  CurValue := InterlockedCompareExchange(_Destination, NewValue, OldValue);
  Result := (OldValue = CurValue);
end;

procedure InterlockedMaskSleep(var _Destination: LongWord; _AndMask, _OrMask: LongWord); inline;
begin
  while not TryInterlockedMask(_Destination, _AndMask, _OrMask) do
    Sleep(1);
end;

procedure InterlockedAndSleep(var _Destination: LongWord; _Mask: LongWord); inline;
begin
  InterlockedMaskSleep(_Destination, _Mask, 0);
end;

procedure InterlockedOrSleep(var _Destination: LongWord; _Mask: LongWord); inline;
begin
  InterlockedMaskSleep(_Destination, $FFFFFFFF, _Mask);
end;

procedure InterlockedMaskSpin(var _Destination: LongWord; _AndMask, _OrMask: LongWord); inline;
begin
  while not TryInterlockedMask(_Destination, _AndMask, _OrMask) do
    ; // wait busily we don't this thread to give up its whole timeslice just because another thread,
      // which is running on a different CPU just changed the value.
      // Since the other thread should be already done, it is very likely that the second call will succeed.
end;

procedure InterlockedAndSpin(var _Destination: LongWord; _Mask: LongWord); inline;
begin
  InterlockedMaskSpin(_Destination, _Mask, 0);
end;

procedure InterlockedOrSpin(var _Destination: LongWord; _Mask: LongWord); inline;
begin
  InterlockedMaskSpin(_Destination, $FFFFFFFF, _Mask);
end;

end.

