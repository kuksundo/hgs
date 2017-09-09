unit CircularQ;

interface

uses
  SysUtils;

type
  TCircularQ = class(TObject) //Circular Queue를 구현한 것임
    Buf      : Pointer;
    FBufSize : Integer;
    WrCount  : Integer; //Queue의 Rear Pointer
    RdCount  : Integer; //Queue의 Front Pointer
  public
    constructor Create(nSize : Integer); virtual;
    destructor  Destroy; override;
    function    Write(Data : Pointer; Len : Integer) : Integer;
    function    Read(Data : Pointer; Len : Integer) : Integer;
    function    Peek(var Len : Integer) : Pointer;
    function    Remove(Len : Integer) : Integer;
    procedure   SetBufSize(newSize : Integer);
    property    BufSize : Integer read FBufSize write SetBufSize;
  end;

implementation

{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
constructor TCircularQ.Create(nSize : Integer);
begin
  inherited Create;
  WrCount  := 0;
  RdCount  := 0;
  BufSize := nSize;
end;

{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
destructor TCircularQ.Destroy;
begin
  if Assigned(Buf) then
    FreeMem(Buf, FBufSize);

  inherited Destroy;
end;

{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
procedure TCircularQ.SetBufSize(newSize : Integer);
var newBuf : Pointer;
begin
  //the largest size for an ethernet packet = 1514
  if newSize <= 0 then
    newSize := 1514;

  if newSize = FBufSize then
    Exit;

  if WrCount = RdCount then
  begin{ Buffer is empty }
    if Assigned(Buf) then
      FreeMem(Buf, FBufSize);

    FBufSize := newSize;
    GetMem(Buf, FBufSize);
  end
  else
  begin{ Buffer contains data }
    GetMem(newBuf, newSize);
    Move(Buf^, newBuf^, WrCount);

    if Assigned(Buf) then
      FreeMem(Buf, FBufSize);

    FBufSize := newSize;
    Buf      := newBuf;
  end;
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
//반환값: 0 = 버퍼가 꽉 찬경우
//        그외값 = 씌여진 바이트 수(비어있는 공간에 무조건 쓴다)
function TCircularQ.Write(Data : Pointer; Len : Integer) : Integer;
var Remaining : Integer;
    Copied    : Integer;
begin
  Remaining := FBufSize - WrCount;

  if Remaining <= 0 then
    Result := 0
  else
  begin
    if Len <= Remaining then
      Copied := Len
    else
      Copied := Remaining;

    Move(Data^, (PChar(Buf) + WrCount)^, Copied);
    WrCount := WrCount + Copied;
    Result  := Copied;
  end;
end;

{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
//반환값: 0 = 버퍼가 꽉 찬경우
//        그외값 = 읽은 바이트 수
function TCircularQ.Read(Data : Pointer; Len : Integer) : Integer;
var Remaining : Integer;
    Copied    : Integer;
begin
  Remaining := WrCount - RdCount;

  if Remaining <= 0 then
    Result := 0
  else
  begin
    if Len = 0 then
      Copied := Remaining
    else
    if Len <= Remaining then
      Copied := Len
    else
      Copied := Remaining;

    Move((PChar(Buf) + RdCount)^, Data^, Copied);
    RdCount := RdCount + Copied;

    if RdCount = WrCount then
    begin
      RdCount := 0;
      WrCount := 0;
    end;

    Result := Copied;
  end;
end;

{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
//인수로 전달된 값의 바이스 수 만큼 버퍼의 처음부터 계산하여 이동한 위치를 반환함
//반환값: nil = 버퍼가 꽉 찬경우
//        그외값 = 이동한 버퍼내의 포인터
function TCircularQ.Peek(var Len : Integer) : Pointer;
var Remaining : Integer;
begin
  Remaining := WrCount - RdCount;

  if Remaining <= 0 then
  begin
    Len    := 0;
    Result := nil;
  end
  else
  begin
    Len    := Remaining;
    Result := PChar(Buf) + RdCount;
  end;
end;

{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
//반환값: 0 = 버퍼가 꽉 찬경우
//        그외값 = 삭제한 바이트 수
function TCircularQ.Remove(Len : Integer) : Integer;
var Remaining : Integer;
    Removed   : Integer;
begin
  Remaining := WrCount - RdCount;

  if Remaining <= 0 then
    Result := 0
  else
  begin
    if Len < Remaining then
      Removed := Len
    else
      Removed := Remaining;

    RdCount := RdCount + Removed;

    if RdCount = WrCount then
    begin
      RdCount := 0;
      WrCount := 0;
    end;

    Result := Removed;
  end;
end;
{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
end.

