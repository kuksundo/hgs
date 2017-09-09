{
  Unit sdCompressor:

  New proprietary compression algorithm suited for bitmap images.

  These compression tools work on memory blocks. The user specifies a
  Source and Destination block, as well as a Source size. The procedure
  will return a status code, and will update the Destination size.

  Make sure that prior to calling a compression procedure you have reserved
  adequate memory in the Dest buffer (use function "SafeDestinationSize",
  which corresponds to an extra 25% in case one tries to compress data that is
  incompressible - the Dest size may end up to be more than the Source size).

  Additional notes:
  For 32-bit bitmap images it was found that this schema is very efficient:
  - First twiddle around the color planes
    Original layout: ARGBARGBARGBARGB
    Change order to: AAAARRRRGGGGBBBB
  - Use as 1st step: DiffHaeckCompress()
  - Use as 2nd step: RLECompress()
  - Use as 3rd step: HaeckCompress()
  This compression scheme is often much better than with ZIP, *and* much faster.
  Another nice thing - ZIP compression on top of it will still compress a bit.
  Research is ongoing, and might lead to a new compression component.

  *Warning* for Haeck compress/decompress: the Source buffer data gets destroyed
  and after the algorithm finishes only the Dest buffer contains valid data.
  The Source buffer is used as temporary storage location.

  copyright (c) Nils Haeck (Simdesign) 2003

  It is NOT allowed under ANY circumstances to publish or copy this code
  without prior written permission of the Author!!

  Original Author: Nils Haeck M.Sc.
  Created: 04feb2003

  Modifications:
  27feb2004: Fixed a spurious bug in RLECompress routine

  copyright (c) 2003 - 2011 SimDesign BV (www.simdesign.nl)

}
unit sdCompressors;

{$i simdesign.inc}

{$R-} // no rangechecking

interface

const

  clAllOk                 =  0; // Compression or decompression was OK
  clDestinationReached    = -1; // Destination size is reached before source is fully decompressed
  clSourceUnassigned      = -2;
  clDestinationUnassigned = -3;
  clWrongSettings         = -4;

  // Map types that are allowed
  cMapCount = 4;
  cMapSizes: array[0..cMapCount - 1] of byte =
    (1, 2, 4, 16);

  // Maximum number of palettes when Maptype = 16bits
  cMaxPaletteCount = 16;

type

  THisto = array[0..255] of integer;
  TLut   = array[0..255] of byte;

  TPalette = record
    Length: integer;
    Bits:   integer;
  end;

  TPaletteList = array[0..cMaxPaletteCount - 1] of byte;

const

  cDefaultPaletteCount = 5;
  cDefaultPalettes: array[0..cDefaultPaletteCount - 1] of TPalette =
    ( (Length:   1; Bits: 0),
      (Length:   2; Bits: 1),
      (Length:   4; Bits: 2),
      (Length:  16; Bits: 4),
      (Length: 256; Bits: 8) );

// Normal RLE compression
procedure RLECompress(Source: Pointer; SourceSize: integer; Dest: Pointer; var DestSize: integer);
procedure RLEDecompress(Source: Pointer; SourceSize: integer; Dest: Pointer; var DestSize: integer);

// Differential RLE compression
procedure DiffRLECompress(Source: Pointer; SourceSize: integer; Dest: Pointer; var DestSize: integer);
procedure DiffRLEDecompress(Source: Pointer; SourceSize: integer; Dest: Pointer; var DestSize: integer);

// Haeck Compression (very suitable for bitmap images)
// - It uses the 0134 schema option (1col, 2col, 4col and 256)
// - Research into this component is not finished - subject to change!
function HaeckCompress(Source: Pointer; SourceSize: integer; Dest: Pointer; var DestSize: integer): integer;
function HaeckDecompress(Source: Pointer; Dest: Pointer; var DestSize: integer): integer;

// Same but on a differential map. This usually gives more compression on all types of images.
function DiffHaeckCompress(Source: Pointer; SourceSize: integer; Dest: Pointer; var DestSize: integer): integer;
function DiffHaeckDecompress(Source: Pointer; Dest: Pointer; var DestSize: integer): integer;

// Compression mathematics
function FindOptimumCompression(const Histo: THisto; const Sort: TLut; var Palettes: TPaletteList): integer;

// Mapping methods
function DirectMap(Source: Pointer; SourceSize: Longword; Dest: Pointer): integer;
function DifferentialMap(Source: Pointer; SourceSize: Longword; Dest: Pointer): integer;
function DifferentialUnmap(Source: Pointer; SourceSize: Longword; Dest: Pointer): integer;
function SlopePredictionMap(Source: Pointer; SourceSize: Longword; Dest: Pointer): integer;

// Histogramming
function GetHistogram(Source: Pointer; SourceSize: Longword; var Histo: THisto;
  var Sort: TLut): integer;

// Call this function to find a safe destination buffer size for the source size
// in ASourceSize. This function applies to all algorithms here
function SafeDestinationSize(ASourceSize: integer): integer;

// Twiddle around byte planes (for use on bitmapped data)
function UntwiddleBytePlanes(ASource, ADest: Pointer; ASize, NumPlanes: integer): integer;
function TwiddleBytePlanes(ASource, ADest: Pointer; ASize, NumPlanes: integer): integer;

implementation

uses
  Math;

type
  PByte = ^byte;
  PByteArray = ^TByteArray;
  TByteArray = array[0..32767] of Byte;
  PLongword = ^Longword;

procedure RLECompress(Source: Pointer; SourceSize: integer; Dest: Pointer; var DestSize: integer);
// RLE compression
var
  S, D: PByte;
  Start: PByte;
  P, Q: byte;
  ACount, AMax: integer;
  Left: integer;
  DiffMode: boolean;
begin
  // Initialize
  D := Dest;
  S := Source;

  // Small streams
  if SourceSize < 3 then
  begin
    D^ := SourceSize;
    inc(D);
    Move(Source^, D^, SourceSize);
    exit;
  end;

  // Larger streams: prepare window: [Q] [P] [S^]
  Start := S;
  Q := S^;
  inc(S);
  P := S^;
  inc(S);
  Left := SourceSize - 2;
  DiffMode := True;
  repeat
    // Check for identicality
    if (S^ = P) and (P = Q) then
    begin
      // 3 identical bytes in row
      if DiffMode then
      begin
        // Switch to identical: store diff chain
        ACount := integer(S) - integer(Start) - 2;
        while ACount > 0 do
        begin
          AMax := Min(ACount, 127);
          D^ := AMax;
          inc(D);
          Move(Start^, D^, AMax);
          inc(D, AMax);
          inc(Start, AMax);
          Dec(ACount, AMax);
        end;
        // Switch to identical mode
        DiffMode := False;
      end;
    end else
    begin
      // A difference detected
      if not DiffMode then
      begin
        // Store identical. Everything up to P must be stored
        ACount := integer(S) - integer(Start) - 1;
        while ACount > 0 do
        begin
          AMax := Min(ACount, 127);
          // Make sure not to end up with identical count of 1 in next loop,
          // since we cannot represent this in the compressed stream
          if ACount - AMax = 1 then
            dec(AMax);
          D^ := - AMax + 1;
          inc(D);
          D^ := P;
          inc(D);
          inc(Start, AMax);
          Dec(ACount, AMax);
        end;
        // Switch to difference mode
        DiffMode := True;
      end;
    end;

    // Check end
    dec(Left);
    if Left = 0 then
    begin
      ACount := integer(S) - integer(Start) + 1;
      // Store final data
      if DiffMode or (ACount = 1) then
      begin
        // Store diff chain
        while ACount > 0 do begin
          AMax := Min(ACount, 127);
          D^ := AMax;
          inc(D);
          Move(Start^, D^, AMax);
          inc(D, AMax);
          inc(Start, AMax);
          Dec(ACount, AMax);
        end;
      end else
      begin
        // Store identical. Everything up to P must be stored
        while ACount > 0 do
        begin
          AMax := Min(ACount, 127);
          if ACount - AMax = 1 then dec(AMax);
          D^ := - AMax + 1;
          inc(D);
          D^ := P;
          inc(D);
          Dec(ACount, AMax);
        end;
      end;
      break;
    end;
    // Next byte
    Q := P;
    P := S^;
    inc(S);
  until False;

  // Destination size
  DestSize := integer(D) - integer(Dest);
end;

procedure RLEDecompress(Source: Pointer; SourceSize: integer; Dest: Pointer; var DestSize: integer);
// Decompress an RLE compressed memory block
var
  S, D: PByte;
  N: shortint;
  P: Byte;
begin
  // Initialize
  DestSize := 0;
  S := PByte(Source);
  D := PByte(Dest);

  while integer(S) - integer(Source) < integer(SourceSize) do
  begin
    // Current value C
    N := S^;
    inc(S);
    if N < 0 then
    begin
      // Replicate next byte -N + 1 times
      N := -N + 1;
      P := S^;
      inc(S);
      inc(DestSize, N);
      while N > 0 do
      begin
        D^ := P;
        inc(D);
        dec(N);
      end;
    end else
    begin
      // Literally copy next N bytes
      inc(DestSize, N);
      while N > 0 do
      begin
        D^ := S^;
        inc(S);
        inc(D);
        dec(N);
      end;
    end;
  end;
end;

procedure DiffRLECompress(Source: Pointer; SourceSize: integer; Dest: Pointer; var DestSize: integer);
// Differential RLE compression
begin
  DifferentialMap(Source, SourceSize, Source);
  RLECompress(Source, SourceSize, Dest, DestSize);
end;

procedure DiffRLEDecompress(Source: Pointer; SourceSize: integer; Dest: Pointer; var DestSize: integer);
// Decompress a Differential RLE compressed source buffer
begin
  RLEDecompress(Source, SourceSize, Dest, DestSize);
  DifferentialUnmap(Dest, DestSize, Dest);
end;

//
//
//

function HaeckCompress(Source: Pointer; SourceSize: integer; Dest: Pointer; var DestSize: integer): integer;
var
  S, D, M, HeaderPtr, MapPtr, Bit1Ptr, Bit4Ptr, Bit8Ptr: PByte;
  Bit1Shift, Bit4Shift, MapShift: byte;
  i, j: integer;
  P, SVal, Temp, PaletteMax: byte;
  Histo: array[0..255] of longword;
  Sort, Link, Lut, Pal: array[0..255] of byte;
  Bit1Size, Bit4Size, MapSize: Longword;
  Work: Pointer;
  L: PLongword;
begin
  Result := clAllOk;
  FillChar(Histo, SizeOf(Histo), 0);
  S := Source;

  // Histogram
  for i := 0 to SourceSize - 1 do
  begin
    inc(Histo[S^]);
    inc(S);
  end;

  // Sort by occurance (Histogram)
  for i := 0 to 255 do
    Sort[i] := i;
  for i := 0 to 254 do
    for j := 255 downto i + 1 do
      if Histo[Sort[i]] < Histo[Sort[j]] then
      begin
        Temp := Sort[i];
        Sort[i] := Sort[j];
        Sort[j] := Temp;
      end;

  // Create Lookup table and palette
  Link[0] := 0;
  Link[1] := 1;
  Link[2] := 1;
  for i := 3 to 18 do
    Link[i] := 2;
  for i := 19 to 255 do
    Link[i] := 3;
  for i := 0 to 255 do
    Lut[Sort[i]] := Link[i];

  // Palette must be adjusted for bit2 and bit4
  Pal[Sort[1]] := 0;
  Pal[Sort[2]] := 1;
  for i := 3 to 18 do
    Pal[Sort[i]] := i - 3;
  PaletteMax := 255;
  for i := 255 downto 19 do
  begin
    Pal[Sort[i]] := i - 19;
    if Histo[Sort[i]] = 0 then
      PaletteMax := i;
  end;

  // Compressdata header
  HeaderPtr := Dest;
  // Save room for storage of SourceSize, and pointers to Bit1 & Bit4
  D := HeaderPtr;
  inc(D, SizeOf(Longword) * 3);

  // Store palette - PaletteMax + 1 values
  D^ := PaletteMax;
  inc(D);
  for i := 0 to PaletteMax do
  begin
    D^ := Sort[i];
    inc(D);
  end;

  // Store map
  MapSize := (SourceSize + 3) div 4;
  MapPtr := D;
  MapShift := 0;
  S := Source;
  D^ := 0;
  for i := 0 to SourceSize - 1 do
  begin
    D^ := D^ + Lut[S^] shl (2 * MapShift);
    if MapShift = 3 then
    begin
      inc(D);
      D^ := 0;
      MapShift := 0;
    end else
      inc(MapShift);
    inc(S);
  end;
  inc(D);

  // Store Bit1, Bit4 and Bit8 values
  GetMem(Work, MapSize); // Temporary work mem for Bit1
  try
    Bit1Ptr := Work;   // Store in work
    Bit4Ptr := Source; // Store in source, overwrites, but slower as our inc
    //Bit8Ptr := D;      // Directly to dest

    S := Source;
    SVal := S^;

    Bit1Shift := 0;
    Bit4Shift := 0;

    Bit1Ptr^ := 0;
    Bit4Ptr^ := 0;

    M := MapPtr;
    dec(M);
    P := 0;
    // loop through the source and depending on map value, create Bitplanes
    for i := 0 to SourceSize - 1 do
    begin
      if i mod 4 = 0 then
      begin
        inc(M);
        P := M^;
      end;
      case P and $03 of
      0:;     // Most dominant value -> nothing to do
      1:begin // Bit1 -> Most dominant 2nd, 3rd
          Bit1Ptr^ := Bit1Ptr^ + Pal[SVal] shl Bit1Shift;
          if Bit1Shift = 7 then
          begin
            inc(Bit1Ptr);
            Bit1Ptr^ := 0;
            Bit1Shift := 0;
          end else
            inc(Bit1Shift);
        end;
      2:begin // Bit4 -> Most dominant 3rd - 18th
          Bit4Ptr^ := Bit4Ptr^ + Pal[SVal] shl (4 * Bit4Shift);
          if Bit4Shift = 1 then
          begin
            inc(Bit4Ptr);
            Bit4Ptr^ := 0;
            Bit4Shift := 0;
          end else
            inc(Bit4Shift);
        end;
      3:begin
          D^ := Pal[SVal];
          inc(D);
        end;
      end;
      // updates
      P := P shr 2;
      inc(S);
      SVal := S^;
    end;

    // Administrative work
    // - we now have the 3 bit types and copy them all to dest
    // Bit8 is already present, D points to the next free loc

    // Bit 4 to this location, was located at Source
    inc(Bit4Ptr);
    Bit4Size := integer(Bit4Ptr) - integer(Source);
    Bit4Ptr := D;
    Move(Source^, D^, Bit4Size);
    inc(D, Bit4Size);

    // Bit 1 after this, was located in Work
    inc(Bit1Ptr);
    Bit1Size := integer(Bit1Ptr) - integer(Work);
    Bit1Ptr := D;
    Move(Work^, D^, Bit1Size);
    inc(D, Bit1Size);

    // Fill in the pointers
    L := PLongword(HeaderPtr);
    L^ := SourceSize; inc(L);
    L^ := integer(Bit1Ptr) - integer(Dest); inc(L);
    L^ := integer(Bit4Ptr) - integer(Dest);

    // Return the total compressed length
    DestSize := integer(D) - integer(Dest);

  finally
    FreeMem(Work);
  end;

end;

function HaeckDecompress(Source: Pointer; Dest: Pointer; var DestSize: integer): integer;
var
  S, D, Bit1Ptr, Bit4Ptr, Bit8Ptr: PByte;
  Bit1Shift, Bit4Shift, MapShift: byte;
  i: integer;
  Sort: array[0..255] of byte;
  PaletteMax: byte;
  L: PLongword;
  Idx: integer;
begin
  Result := clAllOk;
  L := PLongword(Source);

  // We no trust :) So get sourcesize and then the indirect pointers to Bit1 and Bit4
  DestSize := L^; inc(L);
  integer(Bit1Ptr) := integer(L^) + integer(Source); inc(L);
  integer(Bit4Ptr) := integer(L^) + integer(Source); inc(L);
  S := Pointer(L);

  // Load palette - PaletteMax + 1 values
  PaletteMax := S^;
  inc(S);
  for i := 0 to PaletteMax do
  begin
    Sort[i] := S^;
    inc(S);
  end;

  // Load map
  D := Dest;
  MapShift := 0;
  for i := 0 to DestSize - 1 do
  begin
    D^ := S^ and $03;
    S^ := S^ shr 2;
    if MapShift = 3 then
    begin
      inc(S);
      MapShift := 0;
    end else
      inc(MapShift);
    inc(D);
  end;
  inc(S);

  // Load Bit1, Bit4 and Bit8 values
  Bit8Ptr := S; // Directly from source

  D := Dest;

  Bit1Shift := 0;
  Bit4Shift := 0;

  // loop through the source and depending on map value, create Bitplanes
  for i := 0 to DestSize - 1 do
  begin
    case D^ of
    0: D^ := Sort[0]; // Most dominant value
    1:begin // Bit1 -> Most dominant 2nd, 3rd
        D^ := Sort[1 + (Bit1Ptr^ shr Bit1Shift) and $01];
        if Bit1Shift = 7 then
        begin
          inc(Bit1Ptr);
          Bit1Shift := 0;
        end else
          inc(Bit1Shift);
      end;
    2:begin // Bit4 -> Most dominant 3rd - 18th
        Idx := 3 + (Bit4Ptr^ shr (Bit4Shift * 4)) and $0F;
        if Idx < 256 then
          D^ := Sort[Idx];
        if Bit4Shift = 1 then
        begin
          inc(Bit4Ptr);
          Bit4Shift := 0;
        end else
          inc(Bit4Shift);
      end;
    3:begin
        Idx := 19 + Bit8Ptr^;
        if Idx < 256 then
          D^ := Sort[Idx];
        inc(Bit8Ptr);
      end;
    end;
    inc(D);
  end;

end;

function DiffHaeckCompress(Source: Pointer; SourceSize: integer; Dest: Pointer; var DestSize: integer): integer;
// We first find the differential map, then compress with HaeckCompress
begin
  DifferentialMap(Source, SourceSize, Source);
  Result := HaeckCompress(Source, SourceSize, Dest, DestSize);
end;

function DiffHaeckDecompress(Source: Pointer; Dest: Pointer; var DestSize: integer): integer;
// We first decompress with HaeckDecompress then undo the  differential map
begin
  Result := HaeckDecompress(Source, Dest, DestSize);
  DifferentialUnmap(Dest, DestSize, Dest);
end;

// Compression mathematics

function GetIndexTheoreticalSize(const Histo: THisto; SourceSize: Longint; const Palette: TPaletteList; PaletteCount: byte): longint;
var
  i, j, Base: integer;
  Width, Bits: integer;
begin
  Result := 0;
  Base := 0;

  // Contributions of indexed values in [bits]
  for i := 0 to PaletteCount - 1 do
  begin
    Width := cDefaultPalettes[Palette[i]].Length;
    Bits  := cDefaultPalettes[Palette[i]].Bits;

    for j := Base to Min(255, Base + Width - 1) do
      Result := Result + Bits * Histo[j];
    inc(Base, Width);
  end;

  // Contribution of map in [bits]
  case PaletteCount of
  2:  Result := Result + 1 * SourceSize;
  4:  Result := Result + 2 * SourceSize;
  16: Result := Result + 4 * SourceSize;
  end;
  Result := Result div 8; // in bytes
end;

function FindOptimumCompression(const Histo: THisto; const Sort: TLut; var Palettes: TPaletteList): integer;
var
  i: integer;
  MIndex: byte;
  IndexCount: byte;
  Indices: TPaletteList;
  ACombi: string;
  PaletteMax: byte;
  SourceSize: Longword;
  IndexSize: Longword;
  DestSize: Longword; // approximated compressed size
// Local
function NextIndex(ACount: byte): boolean;
// Increment to the next index - return False if no more options
var
  i: integer;
  APos: integer;
  FullCount: byte;
label Start;
begin
  Result := True;
  APos := ACount - 1;
  while APos >= 0 do
  begin
    Start:
    if Indices[APos] < cMapCount then
    begin
      inc(Indices[APos]);
      for i := APos + 1 to ACount - 1 do
        Indices[i] := Indices[APos];
//      APos := ACount - 1;
      break;
    end else
    begin
      dec(APos);
      if APos < 0 then
      begin
        Result := False;
        exit;
      end;
      Goto Start;
    end;
  end;
  // Check multiple full palettes
  FullCount := 0;
  for i := 0 to ACount - 1 do
    if Indices[i] = cMapCount then
      inc(FullCount);
  if FullCount > 1 then
    Result := NextIndex(ACount);
end;
// local
function IsValidIndex(ACount: byte): boolean;
// Check whether the current Indices are OK as palette
var
  i: integer;
  Count: integer;
begin
  Count := 0;
  for i := 0 to ACount - 1 do
    inc(Count, cDefaultPalettes[Indices[i]].Length);
  Result :=  Count >= PaletteMax;
end;
// Main
begin
  // Result
  Result := clAllOk;

  // Find max number of palette values
  PaletteMax := 255;
  SourceSize := 0;
  for i := 255 downto 0 do
  begin
    inc(SourceSize, Histo[i]);
    if Histo[Sort[i]] = 0 then
      PaletteMax := i;
  end;

  // Start with a value *way* too big (in bits)
  DestSize := SourceSize * 2;

  for MIndex := 0 to cMapCount - 1 do
  begin
    IndexCount := cMapSizes[MIndex];
    FillChar(Indices, SizeOf(Indices), 0);
    repeat
      if not NextIndex(IndexCount) then
        break;
      // Analyse palette combination
      if IsValidIndex(IndexCount) then
      begin
        IndexSize := GetIndexTheoreticalSize(Histo, SourceSize, Indices, IndexCount);
        if IndexSize < DestSize then
        begin
          DestSize := IndexSize;
          Palettes := Indices;
        end;
        ACombi := '';
        for i := 0 to IndexCount - 1 do
          ACombi := ACombi + Char(Ord('0') + Indices[i]);
      end;
    until False;
  end;
end;

// Mapping

function DirectMap(Source: Pointer; SourceSize: Longword; Dest: Pointer): integer;
var
  S, D: PByte;
  ASize: Longword;
begin
  if not assigned(Source) then
  begin
    Result := clSourceUnassigned;
    exit;
  end;
  if not assigned(Dest) then
  begin
    Result := clDestinationUnassigned;
    exit;
  end;
  Result := clAllOk;
  if Source = Dest then
    exit; // We're done

  S := Source;
  D := Dest;
  ASize := SourceSize;
  while ASize > 0 do
  begin
    D^ := S^;
    inc(S);
    inc(D);
    dec(ASize);
  end;
end;

function DifferentialMap(Source: Pointer; SourceSize: Longword; Dest: Pointer): integer;
var
  S, D: PByte;
  B, C: Byte;
  ASize: Longword;
begin
  if not assigned(Source) then
  begin
    Result := clSourceUnassigned;
    exit;
  end;
  if not assigned(Dest) then
  begin
    Result := clDestinationUnassigned;
    exit;
  end;
  Result := clAllOk;
  B := 0;
  S := Source;
  D := Dest;
  ASize := SourceSize;
  if Source = Dest then
  begin
    while ASize > 0 do begin
      // Single map
      C  := S^ - B;
      B  := S^;
      S^ := C;
      inc(S);
      dec(ASize);
    end;
  end else
  begin
    while ASize > 0 do
    begin
      // Separate map
      D^ := S^ - B;
      B  := S^;
      inc(S);
      inc(D);
      dec(ASize);
    end;
  end;
end;

function DifferentialUnmap(Source: Pointer; SourceSize: Longword; Dest: Pointer): integer;
var
  S, D: PByte;
  B: Byte;
  ASize: Longword;
begin
  if not assigned(Source) then
  begin
    Result := clSourceUnassigned;
    exit;
  end;
  if not assigned(Dest) then
  begin
    Result := clDestinationUnassigned;
    exit;
  end;
  Result := clAllOk;
  B := 0;
  S := Source;
  D := Dest;
  ASize := SourceSize;
  if Source = Dest then
  begin
    while ASize > 0 do
    begin
      // Single map
      S^ := S^ + B;
      B  := S^;
      inc(S);
      dec(ASize);
    end;
  end else
  begin
    while ASize > 0 do
    begin
      // Separate map
      D^ := S^ + B;
      B  := D^;
      inc(S);
      inc(D);
      dec(ASize);
    end;
  end;
end;

function SlopePredictionMap(Source: Pointer; SourceSize: Longword; Dest: Pointer): integer;
var
  S, D: PByte;
  A, B, C: Byte;
  ASize: Longword;
begin
  if not assigned(Source) then
  begin
    Result := clSourceUnassigned;
    exit;
  end;
  if not assigned(Dest) then
  begin
    Result := clDestinationUnassigned;
    exit;
  end;
  Result := clAllOk;
  A := 0;
  B := 0;
  S := Source;
  D := Dest;
  ASize := SourceSize;
  if Source = Dest then
  begin
    while ASize > 0 do
    begin
      // Single map
      C  := S^ - (B + (B - A));
      A  := B;
      B  := S^;
      S^ := C;
      inc(S);
      dec(ASize);
    end;
  end else
  begin
    while ASize > 0 do
    begin
      // Separate map
      D^ := S^ - (B + (B - A));
      A  := B;
      B  := S^;
      inc(S);
      inc(D);
      dec(ASize);
    end;
  end;
end;

//

function GetHistogram(Source: Pointer; SourceSize: Longword; var Histo: THisto;
  var Sort: TLut): integer;
var
  i, j, Temp: byte;
  S: PByte;
  ASize: Longword;
begin
  if not assigned(Source) then
  begin
    Result := clSourceUnassigned;
    exit;
  end;
  Result := clAllOk;
  // Histogram
  FillChar(Histo, SizeOf(Histo), 0);
  S := Source;
  ASize := SourceSize;
  while ASize > 0 do
  begin
    inc(Histo[S^]);
    inc(S);
    dec(ASize);
  end;

  // Sort by occurance (Histogram)
  for i := 0 to 255 do
    Sort[i] := i;
  for i := 0 to 254 do
    for j := 255 downto i + 1 do
      if Histo[Sort[i]] < Histo[Sort[j]] then
      begin
        Temp := Sort[i];
        Sort[i] := Sort[j];
        Sort[j] := Temp;
      end;

end;

function SafeDestinationSize(ASourceSize: integer): integer;
begin
  // Takes into account a map of 2 bits / byte and some overhead for
  // HaeckCompress
  Result := ASourceSize + ASourceSize div 4 + 19;
end;

function UntwiddleBytePlanes(ASource, ADest: Pointer; ASize, NumPlanes: integer): integer;
const
  cMaxPlanes = 8;
var
  i, j: integer;
  PlaneLength: integer;
  PlaneStart: array[0..cMaxPlanes - 1] of integer;
  S: PByteArray;
  D: PByte;
  ABuf: Pointer;
begin
  Result := clWrongSettings;
  if (NumPlanes < 1) or (NumPlanes > cMaxPlanes) then
    exit;
  // Check for ASource = ADest and in that case make temp Source copy
  ABuf := nil;
  if ASource = ADest then
  begin
    GetMem(ABuf, ASize);
    Move(ASource^, ABuf^, ASize);
    ASource := ABuf;
  end;
  S := ASource;
  D := ADest;

  PlaneLength := ASize div NumPlanes;
  for j := 0 to NumPlanes - 1 do
    PlaneStart[j] := j * PlaneLength;

  // Bulk bytes
  for i := 0 to PlaneLength - 1 do
    for j := 0 to NumPlanes - 1 do
    begin
      D^ := S^[i + PlaneStart[j]];
      inc(D);
    end;
  // Final bytes
  for i := PlaneLength * NumPlanes to ASize - 1 do
  begin
    D^ := S^[i];
    inc(D);
  end;
  // Free temp mem
  FreeMem(ABuf);
  Result := clAllOk;
end;

function TwiddleBytePlanes(ASource, ADest: Pointer; ASize, NumPlanes: integer): integer;
const
  cMaxPlanes = 8;
var
  i, j: integer;
  PlaneLength: integer;
  PlaneStart: array[0..cMaxPlanes - 1] of integer;
  S: PByte;
  D: PByteArray;
  ABuf: Pointer;
begin
  Result := clWrongSettings;
  if (NumPlanes < 1) or (NumPlanes > cMaxPlanes) or
    not assigned(ASource) or not assigned(ADest) then
      exit;
  // Check for ASource = ADest and in that case make temp Source copy
  ABuf := nil;
  if ASource = ADest then
  begin
    GetMem(ABuf, ASize);
    Move(ASource^, ABuf^, ASize);
    ASource := ABuf;
  end;
  S := ASource;
  D := ADest;

  PlaneLength := ASize div NumPlanes;
  for j := 0 to NumPlanes - 1 do
    PlaneStart[j] := j * PlaneLength;

  // Bulk bytes
  for i := 0 to PlaneLength - 1 do
    for j := 0 to NumPlanes - 1 do
    begin
      D^[i + PlaneStart[j]] := S^;
      inc(S);
    end;
  // Final bytes
  for i := PlaneLength * NumPlanes to ASize - 1 do
  begin
    D^[i] := S^;
    inc(S);
  end;
  // Free temp mem
  FreeMem(ABuf);
  Result := clAllOk;
end;

end.
