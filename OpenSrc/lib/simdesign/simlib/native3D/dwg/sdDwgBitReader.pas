{ sdDwgBitReader

  original author: Nils Haeck M.Sc.
  copyright (c) SimDesign BV (www.simdesign.nl)
}
unit sdDwgBitReader;

interface

uses
  Windows, Classes, sdDwgTypesAndConsts;

type

  // Bitwise reading with the peculiarities of little-endian datastream, as used
  // in Autocad DWG files. We use direct memory access in a TMemoryStream.
  TDwgBitReader = class(TPersistent)
  private
    FStream: TMemoryStream;
    FOwner: TObject; // Pointer back to TDwgFormat, to retrieve info
    FMemory: PByte; // Start position
    FP: PByte;      // Current position
    FMaxP: PByte;
    FBitsInBuf: integer;
    FBuf: byte;
    function GetBitPosition: int64;
    procedure SetBitPosition(const Value: int64);
    procedure SetBytePosition(const Value: integer);
    function ReadP: byte;
  public
    constructor Create(AStream: TMemoryStream; AOwner: TObject);
    function ReadBits(Count: integer): dword;
    function GetBytePosition: integer;
    procedure SetMemory(StreamPosition: dword);
    procedure Flush;
    procedure Skip(ACount: integer);
    // Reader functions
    function Sentinel: DwgSentinel;
    function BS: DwgShort; // Bitcoded short
    function BD: double;   // Bitcoded double
    function BL: DwgLong;  // Bitcoded long
    function RC: byte;     // Raw char
    function RS: DwgShort; // Raw short
    function RL: DwgLong;  // Raw long
    function RD: double;   // Raw double
    function MC: integer;  // Modular char
    function MuC: integer; // Modular unsigned char
    function MS: integer;  // Modular short
    function Text: string; // Text
    function Bit: boolean; // 1-bit (flag)
    function H: TDwgHandle;// Handle (Code.Count.Bytes)
    function BB: byte;     // 2-bit code
    function BDT: TDwgDateTime; // Julian date + milliseconds into day
    function BD3: Dwg3DPoint; // Bitcoded 3D point (3 doubles)
    function RD2: Dwg2DPoint; // Raw 2D point (2 doubles)
    function DD(const ADefault: double): double;
    function DD2(const Default0, Default1: double): Dwg2DPoint;
    function BT: double;     // Bit Thickness
    function BE: Dwg3DPoint; // Bit Extrusion
    // Acad version functions
    function IsR13: boolean;
    function IsR1314: boolean;
    function IsR2000: boolean;
    // positioning
    property BitPosition: int64 read GetBitPosition write SetBitPosition;
    property BytePosition: integer read GetBytePosition write SetBytePosition;
  end;

  TDwgStorageMethod = (
    smBS,  // Bit short
    smBD,  // Bit double
    smRC,  // Raw char
    smH    // Handle
  );

implementation

uses
  sdDwgFormat;

type
  THackDwgFormat = class(TDwgFormat);
  
{ TDwgBitReader }

function TDwgBitReader.BB: byte;
begin
  Result := ReadBits(2);
end;

function TDwgBitReader.BD: double;
begin
  case ReadBits(2) of
  0: Result := RD;
  1: Result := 1.0;
  2: Result := 0.0;
  else
    Result := 0; // avoid compiler warning
  end;
end;

function TDwgBitReader.BD3: Dwg3DPoint;
begin
  Result[0] := BD;
  Result[1] := BD;
  Result[2] := BD;
end;

function TDwgBitReader.BDT: TDwgDateTime;
begin
  Result.Julian    := BL;
  Result.Millisecs := BL;
end;

function TDwgBitReader.BE: Dwg3DPoint;
// Bit Extrusion
const
  cExtrusionDefault: Dwg3DPoint = (0, 0, 1);
begin
  if IsR1314 then begin
    Result := BD3;
  end else begin
    if ReadBits(1) = 1 then
      Result := cExtrusionDefault
    else
      Result := BD3;
  end;
end;

function TDwgBitReader.Bit: boolean;
begin
  Result := boolean(ReadBits(1));
end;

function TDwgBitReader.BL: DwgLong;
begin
  case ReadBits(2) of
  0: Result := RL;
  1: Result := ReadBits(8);
  2: Result := 0;
  else
    Result := 0; // avoid compiler warning
  end;
end;

function TDwgBitReader.BS: DwgShort;
begin
  case ReadBits(2) of
  0: Result := RS;
  1: Result := ReadBits(8);
  2: Result := 0;
  3: Result := 256;
  else
    Result := 0; // avoid compiler warning
  end;
end;

function TDwgBitReader.BT: double;
// Bit Thickness
begin
  if IsR1314 then begin
    Result := BD;
  end else begin
    // R2000
    if ReadBits(1) = 1 then
      Result := 0.0
   else
      Result := BD;
  end;
end;

constructor TDwgBitReader.Create(AStream: TMemoryStream; AOwner: TObject);
begin
  inherited Create;
  FStream := AStream;
  FOwner := AOwner;
  FMaxP := AStream.Memory;
  inc(FMaxP, AStream.Size);
end;

function TDwgBitReader.DD(const ADefault: double): double;
// Bit-double with default
var
  i: integer;
  P: Pbyte;
begin
  case ReadBits(2) of
  0: Result := ADefault;
  1: // Patch first 4 bytes
    begin
      Result := ADefault;
      P := pointer(@Result);
      for i := 0 to 3 do begin
        P^ := ReadBits(8);
        inc(P);
      end;
    end;
  2: // Patch bytes 5 and 6 first, then bytes 1..4 (how weird can it get)
    begin
      Result := ADefault;
      P := pointer(@Result); inc(P, 4);
      for i := 0 to 1 do begin
        P^ := ReadBits(8);
        inc(P);
      end;
      P := pointer(@Result);
      for i := 0 to 3 do begin
        P^ := ReadBits(8);
        inc(P);
      end;
    end;
  3: Result := RD;
  else
    Result := 0;
  end;
end;

function TDwgBitReader.DD2(const Default0, Default1: double): Dwg2DPoint;
begin
  Result[0] := DD(Default0);
  Result[1] := DD(Default1);
end;

procedure TDwgBitReader.Flush;
begin
  FBitsInBuf := 0;
end;

function TDwgBitReader.GetBitPosition: int64;
begin
  Result := BytePosition * 8 - FBitsInBuf;
end;

function TDwgBitReader.GetBytePosition: integer;
begin
  Result := integer(FP) - integer(FMemory);
end;

function TDwgBitReader.H: TDwgHandle;
var
  i, Counter: integer;
begin
  Result.Code := ReadBits(4);
  Result.Handle := 0;
  Counter := ReadBits(4);
  for i := 0 to Counter - 1 do
  begin
    Result.Handle := Result.Handle shl 8;
    inc(Result.Handle, ReadBits(8));
  end;
end;

function TDwgBitReader.IsR13: boolean;
begin
  Result := TDwgFormat(FOwner).AcadVersion = avAcadR13;
end;

function TDwgBitReader.IsR1314: boolean;
begin
  Result := TDwgFormat(FOwner).AcadVersion in [avAcadR13, avAcadR14];
end;

function TDwgBitReader.IsR2000: boolean;
begin
  Result := TDwgFormat(FOwner).AcadVersion = avAcad2000;
end;

function TDwgBitReader.MC: integer;
// Modular Char stores integers in 1 .. N bytes depending on the value. If the value
// fits in 7 bits, the 8th bit is set to 1 to indicate end. Otherwise, if the value
// fits in 14 bits, the 8th bit of first byte is left 0, and the 8th bit of 2nd byte
// is set to 1. And so on. The 4th bit of the last byte indicates whether this is
// a negative value.
var
  Negate, Finish: boolean;
  Shift: integer;
  V: dword;
begin
  Negate := False;
  Finish := False;
  Result := 0;
  Shift := 0;
  repeat
    V := ReadBits(8);
    if (V and $80) = 0 then begin
      Finish := True;
      if (V and $40) > 0 then begin
        Negate := True;
        V := V and $3F;
      end;
    end else
      V := V and $7F;
    Result := Result + integer(V shl Shift);
    inc(Shift, 7);
  until Finish;
  if Negate then Result := -Result;
end;

function TDwgBitReader.MS: integer;
// The Modular Short has same principle as Modular Char, but uses 15 bits at a time.
var
  Negate, Finish: boolean;
  Shift: integer;
  V: dword;
begin
  Negate := False;
  Finish := False;
  Result := 0;
  Shift := 0;
  repeat
    V := word(RS);
    if (V and $8000) = 0 then begin
      Finish := True;
      if (V and $4000) > 0 then begin
        Negate := True;
        V := V and $3FFF;
      end;
    end else
      V := V and $7FFF;
    Result := Result + integer(V shl Shift);
    inc(Shift, 15);
  until Finish;
  if Negate then Result := -Result;
end;

function TDwgBitReader.MuC: integer;
// The Modular unsigned Char has same principle as Modular Char, but doesn't use
// the 4th bit of last byte for negative values.
var
  Finish: boolean;
  Shift: integer;
  V: dword;
begin
  Finish := False;
  Result := 0;
  Shift := 0;
  repeat
    V := ReadBits(8);
    if (V and $80) = 0 then
      Finish := True
    else
      V := V and $7F;
    Result := Result + integer(V shl Shift);
    inc(Shift, 7);
  until Finish;
end;

function TDwgBitReader.RC: byte;
begin
  Result := ReadBits(8);
end;

function TDwgBitReader.RD: double;
var
  i: integer;
  P: Pbyte;
begin
  P := pointer(@Result);
  for i := 0 to 7 do begin
    P^ := ReadBits(8);
    inc(P);
  end;
end;

function TDwgBitReader.RD2: Dwg2DPoint;
begin
  Result[0] := RD;
  Result[1] := RD;
end;

function TDwgBitReader.ReadBits(Count: integer): dword;
// Reads a maximum of 32 bits at a time into a dword
begin
  if Count <= FBitsInBuf then begin
    // Quick case: extract from buffer
    dec(FBitsInBuf, Count);
    Result := FBuf shr (8 - Count);
    FBuf := FBuf shl Count;
    Exit;
  end;

  Result := 0;

  // We must first output what we have left
  if FBitsInBuf > 0 then begin
    dec(Count, FBitsInBuf);
    Result := FBuf shr (8 - FBitsInBuf);
    FBitsInBuf := 0;
  end;

  // Read whole bytes
  while Count >= 8 do begin
    Result := Result shl 8 + ReadP;
    inc(FP);
    dec(Count, 8);
  end;

  // If there are still Count bits left to retrieve (Count < 8) then do it now
  if Count > 0 then begin
    FBuf := ReadP;
    inc(FP);
    FBitsInBuf := 8 - Count;
    Result := Result shl Count + FBuf shr (8 - Count);
    FBuf := FBuf shl Count;
  end;

end;

function TDwgBitReader.ReadP: byte;
begin
  if dword(FP) < dword(FMaxP) then
    Result := FP^
  else begin
    Result := 0;
    THackDwgFormat(FOwner).DoStatus('Error in reader');
  end;
end;

function TDwgBitReader.RL: DwgLong;
var
  W: array[0..1] of word;
  P: Pdword;
begin
  P := @W;
  P^ := ReadBits(32);
  Result := Swap(W[0]) shl 16 + Swap(W[1]);
end;

function TDwgBitReader.RS: DwgShort;
begin
  Result := swap(smallint(ReadBits(16)));
end;

function TDwgBitReader.Sentinel: DwgSentinel;
begin
  Flush;
  move(FP^, Result, 16);
  inc(FP, 16);
end;

procedure TDwgBitReader.SetBitPosition(const Value: int64);
begin
  BytePosition := Value div 8;
  FBuf := ReadP;
  FBitsInBuf := (8 - (Value mod 8)) mod 8;
  if FBitsInBuf > 0 then inc(FP);
  FBuf := FBuf shl (Value mod 8)
end;

procedure TDwgBitReader.SetBytePosition(const Value: integer);
begin
  FP := FMemory;
  inc(FP, Value);
  Flush;
end;

procedure TDwgBitReader.SetMemory(StreamPosition: dword);
begin
  Flush;
  FMemory := FStream.Memory;
  inc(FMemory, StreamPosition);
  FP := FMemory;
end;

procedure TDwgBitReader.Skip(ACount: integer);
begin
  Flush;
  inc(FP, ACount);
end;

function TDwgBitReader.Text: string;
var
  i, Count: integer;
begin
  Count := BS;
  SetLength(Result, Count);
  for i := 1 to length(Result) do
    Result[i] := char(ReadBits(8));
end;

end.
