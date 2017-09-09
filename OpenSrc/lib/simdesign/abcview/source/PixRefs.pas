{ unit PixRefs

  Pixel References are small file impressions used to quickly compare two images
  and provide an indicator with the difference.

  TprPixRef is a property descendant which stores the pixel reference.

  Project: ABC-View Manager

  Author: Nils Haeck M.Sc.
  Copyright (c) 2000 - 2005 by SimDesign B.V.

  It is NOT allowed to publish or copy this software without express permission
  of the author!

}
unit PixRefs;

interface

uses

  SysUtils, Classes, Graphics, sdStreamableData, sdProperties, sdItems,
  sdAbcTypes, sdAbcVars, sdAbcFunctions;

const

  cDifTreshold = 128;

type

{
  FData will have this structure for B/W:
  byte   Size
  0:     1:  Mean
  1..4   4:  2x2
  5..20  16: 4x4
  21..   The rest of the data, either 8x8 or 16x16

  FData will have this structure for RGB:
  byte   Size
  0..2:  3:  Mean
  3..14  12: 2x2
  15..62 48: 4x4
  63..   The rest of the data, either 8x8 or 16x16

}
  TprPixRef = class(TStoredProperty)
  private
    FSize: byte;   // Size definition, see Globalvars cprSizexx constants
    FColors: byte; // Colors definition, see Globalvars cprColxx constants
    function GetDataSize(ASize, AColors: byte): integer;
  protected
    function GetPropID: word; override;
  public
    FData: pointer;
    destructor Destroy; override;
    function DataSize: integer;
    procedure ReadComponents(S: TStream); override;
    procedure RefFromBitmap(ABitmap: TBitmap);
    procedure RefToBitmap(ABitmap: TBitmap);
    procedure SetSizeTo(ASize, AColors: byte);
    procedure WriteComponents(S: TStream); override;
    property Size: byte read FSize;
    property Colors: byte read FColors;
  end;

// Create Den parts from Num, with startpoints in Start (zerobased) and Sizes in Size
procedure CreateDivision(Num, Den: integer; var Start, Size: array of integer);

// Compare APixRef1 and APixRef2. If APixRef1 < APixRef2 then result = -1, equal
// result = 0 and APixref1 > APixref2 then Result = +1
function ComparePixRef(APixRef1, APixRef2: TsdProperty; Tolerance: byte): integer;

function PixRefPointer(Item: TsdItem): pointer;

function PixRefDifference(Item1, Item2: TsdItem; APixRef1, APixRef2: pointer; {Info: pointer; }Limit: integer): integer;

implementation

uses

  {Utils,} {GlobalVars,} Compares, Math;

// Procedures

procedure CreateDivision(Num, Den: integer; var Start, Size: array of integer);
// Create Den parts from Num, with startpoints in Start (zerobased) and Sizes in Size
var
  i, Run, Left, Width: integer;
begin
  Run := 0;
  Left := 0;
  Width := Num div Den;
  for i := 0 to Den - 1 do begin
    Start[i] := Left;
    Size[i] := Width;
    Run := Run + Num - Width * Den;
    if Run >= Den then begin
      inc(Size[i]);
      Run := Run - Den;
    end;
    inc(Left, Size[i]);
  end;
end;

function ComparePixRef(APixRef1, APixRef2: TsdProperty; Tolerance: byte): integer;
// Compare APixRef1 and APixRef2. If APixRef1 < APixRef2 then result = -1, equal
// result = 0 and APixref1 > APixref2 then Result = +1
var
  i, Count: integer;
  IsColor: boolean;
const
  cTolVal: array[0..7] of integer = (0, 1, 2, 4, 7, 10, 15, 25);
  // Maximum count of checked values, for 1) Intensity 2) Color, for each
  // tolerance (0=high to 7=low)
  cTolCount: array[0..1, 0..7] of integer =
    ( (21, 21,  5,  5,  5,  5, 1, 1),
      (63, 63, 15, 15, 15, 15, 3, 3) );
// local function
function CompareTol(Int1, Int2: integer): integer;
begin
  if FMatchFuzzy then
  begin
    // Method 1 - "fuzzy"
    if abs(Int1 - Int2) <= cTolVal[Tolerance] then
      Result := 0
    else
      Result := CompareInt(Int1, Int2);
  end else
  begin
    // Method 2 - exact
    Int1 := Int1 shr Tolerance;
    Int2 := int2 shr Tolerance;
    Result := CompareInt(Int1, Int2);
  end;
end;
// main
begin
  Result := CompareInt(integer(APixRef1), integer(APixRef2));
  if not assigned(APixRef1) or not assigned(APixRef2) then exit;

  // The famous apples and oranges
  Result := CompareByte(TprPixRef(APixRef1).Colors, TprPixRef(APixRef2).Colors);
  if Result <> 0 then exit;

  IsColor := (TprPixRef(APixRef1).Colors = cmmColors);

  // Check if data is assigned
  if not assigned(TprPixRef(APixRef1).FData) or not assigned(TprPixRef(APixRef2).FData) then begin
    Result := CompareInt(integer(TprPixRef(APixRef1).FData), integer(TprPixRef(APixRef2).FData));
    exit;
  end;

  // Both share the same color definition
  Result := 0;
  Count := cTolCount[TprPixRef(APixRef1).Colors, Tolerance];

  // First: mean, 2x2, 4x4
  for i := 0 to Count - 1 do begin
    // Compare average color of 3 channels first
    if IsColor and (i mod 3 = 0) then begin
      Result := CompareTol(
        PByteArray(TPrPixRef(APixRef1).FData)^[i    ] +
        PByteArray(TPrPixRef(APixRef1).FData)^[i + 1] +
        PByteArray(TPrPixRef(APixRef1).FData)^[i + 2],
        PByteArray(TPrPixRef(APixRef2).FData)^[i    ] +
        PByteArray(TPrPixRef(APixRef2).FData)^[i + 1] +
        PByteArray(TPrPixRef(APixRef2).FData)^[i + 2]);
      if Result <> 0 then
        if i = 0 then exit else break;
    end;
    // Compare single color channels or B/W
    Result := CompareTol(PByteArray(TPrPixRef(APixRef1).FData)^[i], PByteArray(TPrPixRef(APixRef2).FData)^[i]);
    if Result <> 0 then
      if i = 0 then exit else break;
  end;

  // If we're here, the images are equal up to 4x4.. now just compare with the rest if Dims is equal
  if (Result = 0) and (Tolerance = 0) and (CompareByte(TprPixRef(APixRef1).Size, TprPixRef(APixRef2).Size) = 0) then begin

    // The sizes are also equal, so proceed
    for i := Count to TPrPixRef(APixRef1).DataSize - 1 do begin
      Result := CompareTol(PByteArray(TPrPixRef(APixRef1).FData)^[i], PByteArray(TPrPixRef(APixRef2).FData)^[i]);
      if Result <> 0 then break;
    end;
  end;

end;

function PixRefPointer(Item: TsdItem): pointer;
begin
  Result := nil;
  // Find Pixref
  if assigned(Item) then
    Result := TprPixRef(Item.GetProperty(prPixRef));
  // Make sure that it has data
  if assigned(Result) and not assigned(TprPixRef(Result).Fdata) then
    Result := nil;
end;

function PixRefDifference(Item1, Item2: TsdItem; APixRef1, APixRef2: pointer; {Info: pointer; }Limit: integer): integer;
// This function returns the difference between APixref1 and APixref2, as an
// integer value. Each pixel difference is reported as 1 unit.
var
  IsColor: boolean;
// local
function CalcDiff(Start, Count, CalcLimit: integer): integer;
var
  i: integer;
begin
  Result := 0;
  for i := Start to Start + Count - 1 do begin
    Result := Result + {Min(cDifTreshold,}
      abs(integer(PByteArray(TprPixRef(APixRef1).FData)^[i]) - integer(PByteArray(TprPixRef(APixRef2).FData)^[i]));
    if Result > CalcLimit then
      exit;
  end;
end;
// main
begin
  Result := cMaxArrangeDiff;
  // do we need to resolve the pix refs?
  if not assigned(APixRef1) or not assigned(APixRef2) then begin
    if assigned(Item1) then APixRef1 := Item1.GetProperty(prPixRef);
    if assigned(Item2) then APixRef2 := Item2.GetProperty(prPixRef);
    // Still no pixrefs? then they're not present, so exit
    if not assigned(APixRef1) or not assigned(APixRef2) then exit;
  end;

  // The famous apples and oranges
  if CompareByte(TprPixRef(APixRef1).Colors, TprPixRef(APixRef2).Colors) <> 0 then exit;
  IsColor := (TprPixRef(APixRef1).Colors = cmmColors);

  // Same definition?
  if CompareByte(TprPixRef(APixRef1).Size, TprPixRef(APixRef2).Size) <> 0 then begin
    // Different sizes, so compare the 4x4, and relate to 16x16
    if IsColor then
      Result := 16 * CalcDiff(15, 48, Limit div 16)
    else
      Result := 48 * CalcDiff( 5, 16, Limit div 48);
  end else begin
    // Same size
    if IsColor then begin
      // Color pixrefs
      case TprPixRef(APixRef1).Size of
      cmg4x4pixels:   Result := 16 * CalcDiff(15,  48, Limit div 16);
      cmg8x8pixels:   Result :=  4 * CalcDiff(63, 192, Limit div  4);
      cmg12x12pixels: Result :=  2 * CalcDiff(63, 432, Limit div  2);
      cmg16x16pixels: Result :=      CalcDiff(63, 768, Limit       );
      end;//case
    end else begin
      // Intensity pixrefs
      case TprPixRef(APixRef1).Size of
      cmg4x4pixels:   Result := 48 * CalcDiff( 5,  16, Limit div 48);
      cmg8x8pixels:   Result := 12 * CalcDiff(21,  64, Limit div 12);
      cmg12x12pixels: Result :=  6 * CalcDiff(21, 144, Limit div  6);
      cmg16x16pixels: Result :=  3 * CalcDiff(21, 256, Limit div  3);
      end;//case
    end;
  end;
end;

{ TprPixRef }

destructor TprPixRef.Destroy;
begin
  if assigned(FData) then
    FreeMem(FData);
  inherited;
end;

function TprPixRef.GetDataSize(ASize, AColors: byte): integer;
const
  cSize: array[0..3] of integer = (0, 64, 144, 256);
  cCols: array[0..1] of integer = (1, 3);
  cExtra: array[0..1] of integer = (21, 63);
begin
  Result := cSize[ASize] * cCols[AColors] + cExtra[AColors];
end;

function TprPixRef.DataSize: integer;
begin
  Result := GetDataSize(FSize, FColors);
end;

function TprPixRef.GetPropID: word;
begin
  Result := prPixRef;
end;

procedure TprPixRef.ReadComponents(S: TStream);
var
  Ver: byte;
begin
  inherited;
  // Read Version No
  StreamReadByte(S, Ver);
  StreamReadByte(S, FSize);
  StreamReadByte(S, FColors);
  if assigned(FData) then
    FreeMem(FData);
  GetMem(FData, GetDataSize(FSize, FColors));
  S.Read(FData^, GetDataSize(FSize, FColors));
  // Add future version code here
end;

procedure TprPixRef.RefFromBitmap(ABitmap: TBitmap);
// fill the FData structure with the info from the bitmap ABitmap
var
  r, br, c, bc, Idx, Mul, Col, Area,
  Dims, XCount, YCount: integer;
  Mean: array[0..2] of integer;
  Grid2x2: array[0..1, 0..1, 0..2] of integer;
  Grid4x4: array[0..3, 0..3, 0..2] of integer;
  Grid: array[0..15, 0..15, 0..2] of integer;
  XStart, XSize: array[0..15] of integer;
  YStart, YSize: array[0..15] of integer;
  Scan: PByteArray;
begin
  if not assigned(ABitmap) or not HasContent(ABitmap) then exit;

  case FSize of
  cmg4x4pixels:   Dims := 4;
  cmg8x8pixels:   Dims := 8;
  cmg12x12pixels: Dims := 12;
  cmg16x16pixels: Dims := 16;
  end;//case

  // Step 1: reduce to a NxN RGB structure

  // Initialise
  XCount := Dims;
  YCount := Dims;
  if ABitmap.PixelFormat <> pf24Bit then
    ABitmap.PixelFormat := pf24Bit;
  FillChar(Mean, SizeOf(Mean), 0);
  FillChar(Grid2x2, SizeOf(Grid2x2), 0);
  FillChar(Grid4x4, SizeOf(Grid4x4), 0);
  FillChar(Grid, SizeOf(Grid), 0);

  // No upscaling
  if ABitmap.Width < XCount then XCount := ABitmap.Width;
  if ABitmap.Height < YCount then YCount := ABitmap.Height;

  // Create divisions
  CreateDivision(ABitmap.Width, XCount, XStart, XSize);
  CreateDivision(ABitmap.Height, YCount, YStart, YSize);

  // Rows
  for r := 0 to YCount - 1 do begin
    for br := YStart[r] to YStart[r] + YSize[r] - 1 do begin
      Scan := ABitmap.ScanLine[br];
      // Columns
      for c := 0 to XCount - 1 do begin
        Idx := 3 * XStart[c];
        for bc := 1 to XSize[c] do begin
          Inc(Grid[r, c, 0], Scan^[Idx]); inc(Idx);
          Inc(Grid[r, c, 1], Scan^[Idx]); inc(Idx);
          Inc(Grid[r, c, 2], Scan^[Idx]); inc(Idx);
        end;
      end;
    end;

    // averages
    for c := 0 to XCount - 1 do begin
      Area := YSize[r] * XSize[c];
      for Idx := 0 to 2 do
        Grid[r, c, Idx] := round(Grid[r, c, Idx] / Area);
    end;
  end;

  // Step 2: create Mean, Grid2x2 and grid4x4

  // Calculate 4x4
  Mul := Dims div 4;
  for r := 0 to 3 do begin
    for br := r * Mul to (r + 1) * Mul - 1 do begin
      for c := 0 to 3 do begin
        for bc := c * Mul to (c + 1) * Mul - 1 do begin
          Inc(Grid4x4[r, c, 0], Grid[br, bc, 0]);
          Inc(Grid4x4[r, c, 1], Grid[br, bc, 1]);
          Inc(Grid4x4[r, c, 2], Grid[br, bc, 2]);
        end;
      end;
    end;
  end;
  // Calculate 2x2
  for r := 0 to 1 do begin
    for br := r * 2 to r * 2 + 1 do begin
      for c := 0 to 1 do begin
       for bc := c * 2 to c * 2 + 1 do begin
          Inc(Grid2x2[r, c, 0], Grid4x4[br, bc, 0]);
          Inc(Grid2x2[r, c, 1], Grid4x4[br, bc, 1]);
          Inc(Grid2x2[r, c, 2], Grid4x4[br, bc, 2]);
        end;
      end;
    end;
  end;

  // Calculate Mean
  for Col := 0 to 2 do
    Mean[Col] := Grid2x2[0, 0, Col] + Grid2x2[0, 1, Col] + Grid2x2[1, 0, Col] + Grid2x2[1, 1, Col];

  // Calculate averages
  Area := sqr(Mul);
  for r := 0 to 3 do
    for c := 0 to 3 do
      for Col := 0 to 2 do
        Grid4x4[r, c, Col] := round(Grid4x4[r, c, Col] / Area);
  Area := Area * 4;
  for r := 0 to 1 do
    for c := 0 to 1 do
      for Col := 0 to 2 do
        Grid2x2[r, c, Col] := round(Grid2x2[r, c, Col] / Area);
  Area := Area * 4;
  for Col := 0 to 2 do
    Mean[Col] := round(Mean[Col] / Area);

  // Step 3: put into FData
  case FColors of
  cmmIntensity:
    begin
      // Reduce to Black/White and put it in 1 byte per pixel
      Idx := 0;
      // Mean
      PByteArray(FData)^[Idx] :=
        round((Mean[0] + Mean[1] + Mean[2]) / 3);
      inc(Idx);
      // 2x2
      for r := 0 to 1 do
        for c := 0 to 1 do begin
          PByteArray(FData)^[Idx] :=
            round((Grid2x2[r, c, 0] + Grid2x2[r, c, 1] + Grid2x2[r, c, 2]) / 3);
          inc(Idx);
        end;
      // 4x4
      for r := 0 to 3 do
        for c := 0 to 3 do begin
          PByteArray(FData)^[Idx] :=
            round((Grid4x4[r, c, 0] + Grid4x4[r, c, 1] + Grid4x4[r, c, 2]) / 3);
          inc(Idx);
        end;
      // higher order
      if Dims > 4 then begin
        for r := 0 to Dims - 1 do
          for c := 0 to Dims - 1 do begin
            PByteArray(FData)^[Idx] :=
              round((Grid[r, c, 0] + Grid[r, c, 1] + Grid[r, c, 2]) / 3);
            inc(Idx);
          end;
      end;
    end;
  cmmColors:
    begin
      // 3 byte per pixel BGR
      Idx := 0;
      // Mean
      PByteArray(FData)^[Idx] := Mean[0]; inc(Idx);
      PByteArray(FData)^[Idx] := Mean[1]; inc(Idx);
      PByteArray(FData)^[Idx] := Mean[2]; inc(Idx);
      // 2x2
      for r := 0 to 1 do
        for c := 0 to 1 do begin
          PByteArray(FData)^[Idx] := Grid2x2[r, c, 0]; inc(Idx);
          PByteArray(FData)^[Idx] := Grid2x2[r, c, 1]; inc(Idx);
          PByteArray(FData)^[Idx] := Grid2x2[r, c, 2]; inc(Idx);
        end;
      // 4x4
      for r := 0 to 3 do
        for c := 0 to 3 do begin
          PByteArray(FData)^[Idx] := Grid4x4[r, c, 0]; inc(Idx);
          PByteArray(FData)^[Idx] := Grid4x4[r, c, 1]; inc(Idx);
          PByteArray(FData)^[Idx] := Grid4x4[r, c, 2]; inc(Idx);
        end;
      // Higher order
      if Dims > 4 then begin
        for r := 0 to Dims - 1 do
          for c := 0 to Dims - 1 do begin
            PByteArray(FData)^[Idx] := Grid[r, c, 0]; inc(Idx);
            PByteArray(FData)^[Idx] := Grid[r, c, 1]; inc(Idx);
            PByteArray(FData)^[Idx] := Grid[r, c, 2]; inc(Idx);
          end;
      end;
    end;
  end;
end;

procedure TprPixRef.RefToBitmap(ABitmap: TBitmap);
// Create a small bitmap from the pixel reference
var
  r, c, Idx, Dims: integer;
  Grey: byte;
  Col: integer;
begin
  if not assigned(ABitmap) then exit;
  Dims := 0;

  case FSize of
  cmg4x4pixels:   Dims := 4;
  cmg8x8pixels:   Dims := 8;
  cmg12x12pixels: Dims := 12;
  cmg16x16pixels: Dims := 16;
  end;//case

  // Set size & pixelformat
  ABitmap.Width := Dims;
  ABitmap.Height := Dims;
  ABitmap.PixelFormat := pf24Bit;

  // Set the pixels.. slow method but not important to optimise
  case FColors of
  cmmIntensity:
    begin
      Idx := 5;
      if Dims > 4 then Idx := 21;
      for r := 0 to Dims - 1 do
        for c := 0 to Dims - 1 do begin
          Grey := PByteArray(FData)^[Idx]; Inc(Idx);
          ABitmap.Canvas.Pixels[c, r] := Grey shl 16 + Grey shl 8 + Grey;
        end;
    end;
  cmmColors:
    begin
      Idx := 15;
      if Dims > 4 then Idx := 63;
      for r := 0 to Dims - 1 do
        for c := 0 to Dims - 1 do begin
          Col :=             PByteArray(FData)^[Idx]; Inc(Idx); // blue
          Col := Col shl 8 + PByteArray(FData)^[Idx]; Inc(Idx); // green
          Col := Col shl 8 + PByteArray(FData)^[Idx]; Inc(Idx); // red
          ABitmap.Canvas.Pixels[c, r] := Col;
        end;
    end;
  end;//case

end;

procedure TprPixRef.SetSizeTo(ASize, AColors: byte);
begin
  FSize := ASize;
  FColors := AColors;
  if assigned(FData) then
    FreeMem(FData);
  GetMem(FData, GetDataSize(FSize, FColors));
end;

procedure TprPixRef.WriteComponents(S: TStream);
begin
  inherited;
  // Write Version No
  StreamWriteByte(S, 10);
  StreamWriteByte(S, FSize);
  StreamWriteByte(S, FColors);
  S.Write(FData^, GetDataSize(FSize, FColors));
end;


end.
