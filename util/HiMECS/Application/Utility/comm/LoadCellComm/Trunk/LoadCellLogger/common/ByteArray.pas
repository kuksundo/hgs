unit ByteArray;

interface

uses classes, sysutils, Math;

type
  TMyByteArray = Array of Byte; //DFund의 cUtils.pas에서 발췌함

type
  //DeCAL_pjh.pas에 TByteArray가 선언 되어있기 때문에 2를 붙임
  TByteArray2 = class
  protected
    procedure SetSize(NewSize : LongInt);
    function GetSize : LongInt;

    procedure SetItems(Index : LongInt; NewItem : Byte);
    function GetItems(Index : LongInt) : Byte;

    function GetCStrFrom(Index : LongInt) : Pointer;

  public
    FBuffer : TMyByteArray;

    constructor Create(InitialSize : LongInt = 0);
    destructor Free;

    procedure SaveToStream(Stream : TStream);
    procedure LoadFromStream(Stream : TStream; Size : LongInt);

    procedure SaveToFile(FileName : TFileName);
    procedure LoadFromFile(FileName : TFileName);

    function CopyToString(Index, Length : LongInt) : AnsiString;
    procedure Clear;

    //****  DFund의 cUtils.pas에서 발췌함 ***// -start
    Function Append(const R : Byte) : Integer;
    Function AppendByteArray(const R : Array of Byte; count: integer): Integer;
    Function Remove(const Idx : Integer; const Count : Integer = 1) : Integer;
    Procedure RemoveDuplicates(const IsSorted : Boolean);
    Procedure TrimArrayLeft(const TrimList : Array of Byte);
    Procedure TrimArrayRight(const TrimList : Array of Byte);
    Function ArrayInsert(const Idx : Integer; const Count : Integer) : Integer;
    Function PosNext(const Find : Byte; const V: TMyByteArray; const PrevPos : Integer = -1;
                          const IsSortedAscending : Boolean = False) : Integer;overload;
    Function PosNext(const Find : Byte;const PrevPos : Integer = -1; const IsSortedAscending : Boolean = False) : Integer;overload;
    Function Count(const Find : Byte; const IsSortedAscending : Boolean = False) : Integer;
    Procedure RemoveAll(const Find : Byte; const IsSortedAscending : Boolean = False);
    Procedure Reverse;
    Function AsByteArray(const V : Array of Byte) : TMyByteArray;
    Function RangeByte(const First : Byte; const Count : Integer;
                                        const Increment : Byte = 1) : TMyByteArray;
    Function DupByte (const V : Byte; const Count : Integer) : TMyByteArray;
    Procedure SetLengthAndZero (const NewLength : Integer);
    Function IsEqual (const V1, V2 : TMyByteArray) : Boolean;
    //Function ByteArrayToLongIntArray (const V : TMyByteArray) : LongIntArray;
    Function ByteArrayToStr (const ItemDelimiter : String = ',') : String;
    Function ByteArrayFromIndexes (const V : TMyByteArray;
                                      const Indexes : IntegerArray) : TMyByteArray;
    Function StrToByteArray (const S : String;
                                      const Delimiter : Char = ',') : TMyByteArray;
    Procedure Sort;
    Procedure Swap (var X, Y : Byte);
    //****  DFund의 cUtils.pas에서 발췌함 ***//  -end

    procedure CopyByteArray(const V: TByteArray2; Indexes, Count: integer);
    property Size : LongInt read GetSize write SetSize;
    property Items[Index : LongInt] : Byte read GetItems write SetItems; default;
    property CStrFrom[Index : LongInt] : Pointer read GetCStrFrom;
  end;

implementation

constructor TByteArray2.Create(InitialSize : LongInt = 0);
begin
  SetLength(FBuffer, InitialSize);
end;

destructor TByteArray2.Free;
begin
  SetLength(FBuffer, 0);
end;

procedure TByteArray2.SetSize(NewSize : LongInt);
begin
  SetLength(FBuffer, NewSize);
end;

function TByteArray2.GetSize : LongInt;
begin
  Result := High(FBuffer) + 1;
end;

procedure TByteArray2.SetItems(Index : LongInt; NewItem : Byte);
begin
  FBuffer[Index] := NewItem;
end;

function TByteArray2.GetItems(Index : LongInt) : Byte;
begin
  Result := FBuffer[Index];
end;

procedure TByteArray2.SaveToStream(Stream : TStream);
begin
  Stream.WriteBuffer(FBuffer[0], High(FBuffer) + 1);
end;

procedure TByteArray2.LoadFromStream(Stream : TStream; Size : LongInt);
begin
  SetLength(FBuffer, Size);
  Stream.ReadBuffer(FBuffer[0], Size);
end;

procedure TByteArray2.SaveToFile(FileName : TFileName);
var Stream : TFileStream;
begin
  Stream := TFileStream.Create(FileName, fmCreate);
  try
    SaveToStream(Stream);
  finally
    Stream.Free;
  end;
end;

procedure TByteArray2.LoadFromFile(FileName : TFileName);
var
  Stream : TFileStream;
begin
  Stream := TFileStream.Create(FileName, fmOpenRead or fmShareDenyWrite);
  try
    LoadFromStream(Stream, Stream.Size);
  finally
    Stream.Free;
  end;
end;

function TByteArray2.GetCStrFrom(Index : LongInt) : Pointer;
begin
  Result := @FBuffer[Index];
end;

function TByteArray2.CopyToString(Index, Length : LongInt) : AnsiString;
var
  i : Integer;
begin
  //SetLength(Result, Length);
  Result := '';
  for i := 0 to Length - 1 do
    Result := Result + format('%.2x',[FBuffer[Index + i]]);
end;

procedure TByteArray2.Clear;
begin
  SetSize(0);
end;

//****************************************************************************//

//ByteArray 끝에 1바이트(Parameter R)를 추가함
function TByteArray2.Append(const R: Byte): Integer;
begin
  Result := Length(FBuffer);
  SetLength (FBuffer, Result + 1);
  FBuffer[Result] := R;
end;

//TMyByteArray 끝에 Byte형 배열의 값(Parameter R)을 추가함 
function TByteArray2.AppendByteArray(const R: array of Byte; count: integer): Integer;
var L : Integer;
Begin
  Result := Length(FBuffer);
  L := Length(R);
  if L > 0 then
  begin
    SetLength (FBuffer, Result + count);
    Move(R[0], FBuffer[Result], Sizeof (R[0]) * count);
  end;
end;

//TMyByteArray의 idx번째부터 Count갯수 만큼을 idx번지에 삽입함
function TByteArray2.ArrayInsert(const Idx,Count:Integer):Integer;
var
  I, L, C : Integer;
Begin
  L := Length(FBuffer);

  if (Idx > L) or (Idx + Count <= 0) or (Count = 0) then
  begin
    Result := -1;
    exit;
  end;

  I := Max(Idx, 0);
  SetLength(FBuffer, L + Count);
  C := Count * Sizeof(Byte);

  if I < L then
    Move(FBuffer[I], FBuffer[I + Count], (L - I) * Sizeof(Byte));

  FillChar(FBuffer[I], C, #0);
  Result := I;
end;

function TByteArray2.AsByteArray(const V: array of Byte): TMyByteArray;
var I : Integer;
Begin
  SetLength(Result, High(V) + 1);
  For I := 0 to High(V) do
    Result[I] := V[I];
end;

// Array from indexes                                                           }
function TByteArray2.ByteArrayFromIndexes(const V: TMyByteArray;
  const Indexes: IntegerArray): TMyByteArray;
var I, L : Integer;
Begin
  L := Length(Indexes);
  SetLength(Result, L);

  For I := 0 to L - 1 do
    Result[I] := V[Indexes[I]];
end;

{function TByteArray2.ByteArrayToLongIntArray(
  const V: TMyByteArray): LongIntArray;
var I, L : Integer;
Begin
  L := Length(V);
  SetLength(Result, L);

  For I := 0 to L - 1 do
    Result[I] := V[I];
end;
}

function TByteArray2.ByteArrayToStr(const ItemDelimiter: String): String;
var I, L : Integer;
Begin
  Result := '';
  L := Length(FBuffer);

  if L = 0 then
    exit;

  Result := IntToStr(FBuffer[0]);

  For I := 1 to L - 1 do
    Result := Result + ItemDelimiter + IntToStr(FBuffer[I]);
end;

function TByteArray2.Count(const Find: Byte; const IsSortedAscending: Boolean): Integer;
var I, J : Integer;
Begin
  if IsSortedAscending then
  begin
    I := PosNext(Find, FBuffer, -1, True);

    if I = -1 then
      Result := 0
    else
    begin
      Result := 1;
      J := Length(FBuffer);

      While (I + Result < J) and (FBuffer[I + Result] = Find) do
        Inc(Result);
    end;
  end //if IsSortedAscending
  else
  begin
    J := -1;
    Result := 0;

    Repeat
      I := PosNext(Find, FBuffer, J, False);

      if I >= 0 then
      begin
        Inc(Result);
        J := I;
      end;
    Until I < 0;
  end;
end;

function TByteArray2.DupByte(const V: Byte;
  const Count: Integer): TMyByteArray;
begin
  SetLength(Result, Count);
  FillChar(Result[0], Count, V);
end;

function TByteArray2.IsEqual(const V1, V2: TMyByteArray): Boolean;
var L : Integer;
Begin
  L := Length(V1);

  if L <> Length(V2) then
  begin
    Result := False;
    exit;
  end;

  Result := CompareMem(V1, V2, Sizeof(Byte) * L);
end;

{ PosNext                                                                      }
{   PosNext finds the next occurance of Find in V, -1 if it was not found.     }
{     Searches from item [PrevPos + 1], ie PrevPos = -1 to find first          }
{     occurance.                                                               }
function TByteArray2.PosNext(const Find: Byte; const V: TMyByteArray; const PrevPos: Integer;
                                    const IsSortedAscending: Boolean): Integer;
var
  I, L, H : Integer;
  D       : Byte;
Begin
  if IsSortedAscending then // binary search
  begin
    if Max(PrevPos + 1, 0) = 0 then // find first
    begin
      L := 0;
      H := Length(V) - 1;

      Repeat
        I := (L + H) div 2;
        D := V[I];

        if Find = D then
        begin
          While (I > 0) and (V[I - 1] = Find) do
            Dec(I);

          Result := I;
          exit;
        end else
        if D > Find then
          H := I - 1
        else
          L := I + 1;
      Until L > H;

      Result := -1;
    end else // find next
    if PrevPos >= Length(V) - 1 then
      Result := -1
    else
    if V[PrevPos + 1] = Find then
      Result := PrevPos + 1
    else
      Result := -1;
  end //if IsSortedAscending
  else
  begin // linear search
    For I := Max(PrevPos + 1, 0) to Length(V) - 1 do
      if V[I] = Find then
      begin
        Result := I;
        exit;
      end;

      Result := -1;
  end;
end;

Function TByteArray2.PosNext(const Find : Byte;const PrevPos : Integer = -1;
                          const IsSortedAscending : Boolean = False) : Integer;
var
  I, L, H : Integer;
  D       : Byte;
Begin
  if IsSortedAscending then // binary search
  begin
    if Max(PrevPos + 1, 0) = 0 then // find first
    begin
      L := 0;
      H := Length(FBuffer) - 1;

      Repeat
        I := (L + H) div 2;
        D := FBuffer[I];

        if Find = D then
        begin
          While (I > 0) and (FBuffer[I - 1] = Find) do
            Dec(I);

          Result := I;
          exit;
        end else
        if D > Find then
          H := I - 1
        else
          L := I + 1;
      Until L > H;

      Result := -1;
    end else // find next
    if PrevPos >= Length(FBuffer) - 1 then
      Result := -1
    else
    if FBuffer[PrevPos + 1] = Find then
      Result := PrevPos + 1
    else
      Result := -1;
  end //if IsSortedAscending
  else
  begin // linear search
    For I := Max(PrevPos + 1, 0) to Length(FBuffer) - 1 do
      if FBuffer[I] = Find then
      begin
        Result := I;
        exit;
      end;

      Result := -1;
  end;
end;

function TByteArray2.RangeByte(const First: Byte; const Count: Integer;
  const Increment: Byte): TMyByteArray;
var I : Integer;
    J : Byte;
Begin
  SetLength(Result, Count);
  J := First;
  For I := 0 to Count - 1 do
  begin
    Result[I] := J;
    J := J + Increment;
  end;
end;

//TMyByteArray의 Idx 번지부터 Count갯수만큼 데이타 삭제함
function TByteArray2.Remove(const Idx, Count: Integer): Integer;
var I, J, L, M : Integer;
Begin
  L := Length(FBuffer);

  if (Idx >= L) or (Idx + Count <= 0) or (L = 0) or (Count = 0) then
  begin
    Result := 0;
    exit;
  end;

  I := Max (Idx, 0);
  J := Min (Count, L - I);
  M := L - J - I;

  if M > 0 then
    Move (FBuffer[I + J], FBuffer[I], M * SizeOf(Byte));

  SetLength (FBuffer, L - J);
  Result := J;
end;

procedure TByteArray2.RemoveAll(const Find: Byte; const IsSortedAscending: Boolean);
var I, J : Integer;
Begin
  I := PosNext(Find, FBuffer, -1, IsSortedAscending);

  While I >= 0 do
  begin
    J := 1;
    While (I + J < Length(FBuffer)) and (FBuffer[I + J] = Find) do
      Inc (J);

    Remove (I, J);
    I := PosNext(Find, FBuffer, I, IsSortedAscending);
  end;//while
end;

//배열내에서 중복된 항목을 삭제함
//IsSorted = True : 배열의 데이타가 정렬 되었을 경우
procedure TByteArray2.RemoveDuplicates(const IsSorted: Boolean);
var
  I, C, J, L : Integer;
  F          : Byte;
Begin
  L := Length(FBuffer);

  if L = 0 then
    exit;

  if IsSorted then
  begin
    J := 0;
    Repeat
      F := FBuffer[J];
      I := J + 1;

      While (I < L) and (FBuffer[I] = F) do
        Inc (I);

      C := I - J;
      if C > 1 then
      begin
        Remove(J + 1, C - 1);
        Dec(L, C - 1);
        Inc(J);
      end else
        J := I;
    Until J >= L;
  end else
  begin
    J := 0;

    Repeat
      Repeat
        I := PosNext (FBuffer[J], FBuffer, J);
        if I >= 0 then
          Remove(I, 1);
      Until I < 0;

      Inc(J);
    Until J >= Length(FBuffer);
  end;
end;

procedure TByteArray2.Reverse;
var I, L : Integer;
Begin
  L := Length(FBuffer);
  For I := 1 to L div 2 do
    Swap(FBuffer[I - 1], FBuffer[L - I]);
end;

procedure TByteArray2.SetLengthAndZero(const NewLength: Integer);
var L : Integer;
Begin
  L := Length(FBuffer);
  if L = NewLength then
    exit;

  SetLength(FBuffer, NewLength);

  if L > NewLength then
    exit;

  FillChar(FBuffer[L], Sizeof(Byte) * (NewLength - L), #0);
end;

// Dynamic array Sort                                                           }
procedure TByteArray2.Sort;
  Procedure QuickSort(L, R : Integer);
  var I, J, M : Integer;
  Begin
    Repeat
      I := L;
      J := R;
      M := (L + R) shr 1;

      Repeat
        While FBuffer[I] < FBuffer[M] do
          Inc(I);

        While FBuffer[J] > FBuffer[M] do
          Dec(J);

        if I <= J then
        begin
          Swap(FBuffer[I], FBuffer[J]);

          if M = I then
            M := J
          else
          if M = J then
            M := I;

          Inc (I);
          Dec (J);
        end;
      Until I > J;

      if L < J then
        QuickSort(L, J);

      L := I;
    Until I >= R;
  End;//Procedure QuickSort

var I : Integer;
Begin
  I := Length(FBuffer);

  if I > 0 then
    QuickSort(0, I - 1);
end;

function TByteArray2.StrToByteArray(const S: String;
  const Delimiter: Char): TMyByteArray;
var F, G, L, C : Integer;
Begin
  L := 0;
  F := 1;
  C := Length(S);

  While F <= C do
  begin
    G := 0;

    While (F + G <= C) and (S[F + G] <> Delimiter) do
      Inc(G);

    Inc(L);
    SetLength(Result, L);

    if G = 0 then
      Result[L - 1] := 0
    else
      Result[L - 1] := StrToInt(Copy(S, F, G));

    Inc(F, G + 1);
  end;//while
end;

procedure TByteArray2.TrimArrayLeft(const TrimList: array of Byte);
var
  I, J : Integer;
  R    : Boolean;
Begin
  I := 0;
  R := True;

  While R and (I < Length(FBuffer)) do
  begin
    R := False;
    For J := 0 to High(TrimList) do
      if FBuffer[I] = TrimList[J] then
      begin
        R := True;
        Inc(I);
        break;
      end;
  end;//while

  if I > 0 then
    Remove(0, I - 1);
end;

procedure TByteArray2.TrimArrayRight(const TrimList:array of Byte);
var
  I, J : Integer;
  R    : Boolean;
Begin
  I := Length(FBuffer) - 1;
  R := True;

  While R and (I >= 0) do
  begin
    R := False;

    For J := 0 to High(TrimList) do
      if FBuffer[I] = TrimList[J] then
      begin
        R := True;
        Dec(I);
        break;
      end;
  end;

  if I < Length(FBuffer) - 1 then
    SetLength(FBuffer, I + 1);
end;

procedure TByteArray2.Swap(var X, Y: Byte);
var F : Byte;
Begin
  F := X;
  X := Y;
  Y := F;
end;

//V값중에 Indexes부터 Count byte만큼을 FByteBuffer에 Append한다.
procedure TByteArray2.CopyByteArray(const V: TByteArray2; Indexes,
  Count: integer);
var I: integer;
begin
  if Count > 0 then
  begin
    if V.Size >= (Indexes + Count - 1) then
    begin
      For I := Indexes to Indexes + Count - 1 do
      begin
        Append(V.Items[I]);
      end;
    end;//if
  end;//if
end;

end.
