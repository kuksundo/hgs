{ Project: Pyro
  Module: Pyro Core

  Description:
    Pyro's Bitmap class

  Author: Nils Haeck (n.haeck@simdesign.nl)
  Copyright (c) 2006 - 2011 SimDesign BV
}
unit pgBitmap;

interface

{$i simdesign.inc}

uses
  Classes, SysUtils,
  pgColor, Pyro, sdMapIterator;

type

  // TpgMap is a generic map type that functions as ancestor for maps that contain
  // one type of data
  TpgMap = class(TPersistent)
  private
    function GetElementCount: integer; virtual;
  protected
    FHeight: integer;
    FWidth: integer;
    procedure SetHeight(const Value: integer);
    procedure SetWidth(const Value: integer);
  public
    // Check whether the map is empty (Width x Height = 0)
    function IsEmpty: boolean;
    // Set the size of the map. Note: the array is not cleared, only space
    // is allocated
    procedure SetSize(AWidth, AHeight: integer); virtual; abstract;
    // Check if AMap equals the size of this map
    function SizeEquals(AMap: TpgMap): boolean;
    // Number of elements in the array (Width x Height)
    property ElementCount: integer read GetElementCount;
    // Height of the map array
    property Height: integer read FHeight write SetHeight;
    // Width of the map array
    property Width: integer read FWidth write SetWidth;
  end;

  // TpgMemoryMap implements an ancestor map type that keeps all map data in one
  // memory array.
  TpgMemoryMap = class(TpgMap)
  private
    function GetElementPtr(x, y: integer): PByte;
    function GetScanline(y: integer): PByte;
  protected
    FMap: pointer;
    FBorrowed: boolean; // If true, the map is not owned by the object, and will not be freed
    FElementSize: word; // Size in bytes of basic element
    // Borrow the map AMap. If an owned map was already assigned, it will first be
    // freed. Calls to SetSize or Destroying the object will not reallocate the map
    // once borrowed. Calling BorrowMap with nil will ensure that reference to the
    // borrowed map is removed, and a new owned map is allocated. BorrowMap can be
    // used to work on any memory location in another bytemap.
    procedure BorrowMap(AMap: pointer);
    // ElementPtr returns the pointer to element [x,y]
    property ElementPtr[x, y: integer]: PByte read GetElementPtr;
    // The ScanLine array property returns a pointer to the y-th scanline.
    property Scanline[y: integer]: PByte read GetScanline;
    // Override this method in descendants to register changes to the map. Note
    // that changes through the protected methods are not registered! The caller
    // will have to do this (if changes are made).
    procedure DoChanged; virtual;
  public
    constructor Create; virtual;
    destructor Destroy; override;
    // Assign a TPersistent descendant to the memory map. Usually this is another
    // map of same class.
    procedure Assign(Source: TPersistent); override;
    // Clear the complete map with bytes of Value (default = 0).
    procedure Clear(Value: byte = 0);
    // Copy (draw) map AMap onto us at position X, Y
    procedure DrawMap(AMap: TpgMemoryMap; X, Y: integer);
    // Get the size of the map in memory
    function MapMemorySize: integer;
    // Set the size of the map to AWidth by AHeight pixels
    procedure SetSize(AWidth, AHeight: integer); override;
    // Map is a pointer to the map data.
    property Map: pointer read FMap;
    // If Borrowed is True (non-default), the actual map data is not owned by
    // the map and will not be freed or reallocated in any way by the map.
    // See also BorrowMap.
    property Borrowed: boolean read FBorrowed;
    // The size in bytes of each element
    property ElementSize: word read FElementSize;
  end;

  // TpgByteMap holds a two-dimensional array of bytes.
  TpgByteMap = class(TpgMemoryMap)
  private
    function GetElements(x, y: integer): byte;
    procedure SetElements(x, y: integer; const Value: byte);
  public
    // Elements[x, y] returns the byte element at [x, y]. When values outside of
    // the map are requested, Elements returns 0. Set elements in the map using
    // Elements[x, y] := Value. Setting elements outside the map does nothing. Elements
    // on the map are found by FMap[x + y * FWidth] (after testing).
    property Elements[x, y: integer]: byte read GetElements write SetElements; default;
  end;

  // General bitmap (not M$ / Delphi graphics) with color info per pixel
  TpgColorMap = class(TpgMemoryMap)
  private
    FColorInfo: TpgColorInfo;
    function GetElements(x, y: integer): pointer;
  protected
    procedure ReAllocateMap;
    procedure GetElementLinear256(X, Y: integer; const Element: pointer);
    procedure GetElement(X, Y: integer; const Element: pointer);
  public
    procedure Assign(Source: TPersistent); override;
    procedure SetColorInfo(const Value: TpgColorInfo);
    // Unsafe access to element at x,y. Returns pointer into the map at element
    // location.
    property Elements[x, y: integer]: pointer read GetElements; default;
    // Pointer to ColorInfo record
    property ColorInfo: TpgColorInfo read FColorInfo write SetColorInfo;
  end;

  // TpgBitmap is a map descendant that is destined for use by the application.
  // It provides methods to load and save the map, and register changes.
  TpgBitmap = class(TpgColorMap)
  private
    FChanged: boolean;
  protected
    function GetPixels(x, y: integer): TpgColor32;
    procedure SetPixels(x, y: integer; const Value: TpgColor32);
    procedure DoChanged; override;
  public
    property Changed: boolean read FChanged write FChanged;
    // Returns the value of pixel x,y in ARGB_8b_org color
    property Pixels[x, y: integer]: TpgColor32 read GetPixels write SetPixels;
  end;

  // TpgBitmap32 added for compat with Graphics32
  TpgBitmap32 = class(TpgBitmap)
  private
    function GetBits: PpgColor32Array;
    function GetScanline(YPos: integer): TpgColor32;
    function GetPixelPtr(x, y: integer): PpgColor32;
  public
    function BoundsRect: TpgRect;
    procedure LoadFromStream(S: TStream); virtual;
    procedure SaveToStream(S: TStream); virtual;
    property Bits: PpgColor32Array read GetBits;
    property Scanline[YPos: integer]: TpgColor32 read GetScanline;
    property Pixel[x, y: integer]: TpgColor32 read GetPixels write SetPixels;
    function Get_TS256(x, y: integer): TpgColor32;
    function MasterAlpha: byte;
    property PixelPtr[x, y: integer]: PpgColor32 read GetPixelPtr;
  end;

{ additional global functions }

// ReplaceColor function used for floodfill
procedure pgReplaceColor(ABitmap: TpgBitmap; ASourceCol, ATargetCol: TpgColor32; ATolerance: integer);

// construct a TsdMapIterator object with the info from AColormap (uses simlib/general sdMapIterator).
procedure GetColorMapIterator(AColorMap: TpgColorMap; AIterator: TsdMapIterator);

// convert a bitmap to different colorspace
procedure pgConvertBitmapToColorInfo(ABitmap: TpgBitmap; const NewColorInfo: TpgColorInfo);

implementation

{ TpgMap }

function TpgMap.GetElementCount: integer;
begin
  Result := FWidth * FHeight;
end;

function TpgMap.IsEmpty: boolean;
begin
  Result := (FWidth = 0) or (FHeight = 0);
end;

procedure TpgMap.SetHeight(const Value: integer);
begin
  if FHeight <> Value then
    SetSize(FWidth, Value);
end;

procedure TpgMap.SetWidth(const Value: integer);
begin
  if FWidth <> Value then
    SetSize(Value, FHeight);
end;

function TpgMap.SizeEquals(AMap: TpgMap): boolean;
begin
  if assigned(AMap) then
    Result := (FWidth = AMap.Width) and (FHeight = AMap.Height)
  else
    Result := False;
end;

{ TpgMemoryMap }

procedure TpgMemoryMap.Assign(Source: TPersistent);
begin
  if (Source is TpgMemoryMap) and (TpgMemoryMap(Source).FElementSize = FElementSize) then begin
    // Copy the bytemap
    SetSize(TpgMemoryMap(Source).Width, TpgMemoryMap(Source).Height);
    Move(TpgMemoryMap(Source).FMap^, FMap^, MapMemorySize);
    DoChanged;
  end else
    inherited;
end;

procedure TpgMemoryMap.BorrowMap(AMap: pointer);
begin
  if assigned(AMap) then begin
    if assigned(FMap) and not FBorrowed then
      ReallocMem(FMap, 0);
    FMap := AMap;
    FBorrowed := True;
  end else begin
    if FBorrowed then begin
      FBorrowed := False;
      ReallocMem(FMap, MapMemorySize);
    end;
  end;
end;

procedure TpgMemoryMap.Clear(Value: byte);
begin
  if ElementCount = 0 then exit;
  FillChar(FMap^, MapMemorySize, Value);
  DoChanged;
end;

constructor TpgMemoryMap.Create;
begin
  inherited Create;
  // Default to byte
  FElementSize := 1;
end;

destructor TpgMemoryMap.Destroy;
begin
  if not FBorrowed then
    ReallocMem(FMap, 0);
  inherited;
end;

procedure TpgMemoryMap.DoChanged;
begin
// default does nothing
end;

procedure TpgMemoryMap.DrawMap(AMap: TpgMemoryMap; X, Y: integer);
var
  yi, sx, cx, dx, sy, cy, dy, span: integer;
begin
  // Checks
  if not assigned(AMap) then
    exit;
  if AMap.FElementSize <> FElementSize then
    raise Exception.Create(smpIncompatibleMapTypes);

  // Calculate union area
  sx := pgMax(X, 0);
  dx := sx - X;
  cx := pgMin(X + AMap.Width, FWidth);
  sy := pgMax(Y, 0);
  dy := sy - Y;
  cy := pgMin(Y + AMap.Height, FHeight);
  span := (cx - sx) * FElementSize;

  // If there's no positive span, there's no union area
  if span <= 0 then
    exit;

  // Move data scanline by scanline
  for yi := sy to cy - 1 do
  begin
    Move(AMap.ElementPtr[dx, dy]^, ElementPtr[sx, yi]^, span);
    inc(dy);
  end;
  DoChanged;
end;

function TpgMemoryMap.GetElementPtr(x, y: integer): PByte;
begin
  if (x >= 0) and (x < Width) and
     (y >= 0) and (y < Height) then
    Result := pointer(integer(FMap) + (y * Width + x) * FElementSize)
  else
    Result := nil;
end;

function TpgMemoryMap.GetScanline(y: integer): PByte;
begin
  if (y >= 0) and (y < Height) then
    Result := pointer(integer(FMap) + (y * Width) * FElementSize)
  else
    Result := nil;
end;

function TpgMemoryMap.MapMemorySize: integer;
begin
  Result := FWidth * FHeight * FElementSize;
end;

procedure TpgMemoryMap.SetSize(AWidth, AHeight: integer);
begin
  if (FWidth = AWidth) and (FHeight = AHeight) then
    exit;
  FWidth := AWidth;
  FHeight := AHeight;
  if not FBorrowed then
    ReallocMem(FMap, MapMemorySize);
  DoChanged;
end;

{ TpgByteMap }

function TpgByteMap.GetElements(x, y: integer): byte;
begin
  if (x >= 0) and (x < FWidth) and
     (y >= 0) and (y < FHeight) then
    Result := PByteArray(FMap)[y * FWidth + x]
  else
    Result := 0;
end;

procedure TpgByteMap.SetElements(x, y: integer; const Value: byte);
begin
  if (x >= 0) and (x < FWidth) and
     (y >= 0) and (y < FHeight) then
    PByteArray(FMap)[y * FWidth + x] := Value;
end;

{ TpgColorMap }

procedure TpgColorMap.Assign(Source: TPersistent);
begin
  if Source is TpgColorMap then
  begin
    FColorInfo := TpgColorMap(Source).FColorInfo;
    ReallocateMap;
  end;
  inherited;
end;

procedure TpgColorMap.GetElement(X, Y: integer; const Element: pointer);
var
  S: Pbyte;
begin
  // Outside map?
  if X < 0 then
    X := 0
  else
    if X >= FWidth then
      X := FWidth - 1;
  if Y < 0 then
    Y := 0
  else
    if Y >= FHeight then
      Y := FHeight - 1;
  // Pointer in map
  S := PByte(integer(FMap) + (Y * FWidth + X) * FElementSize);
  // Move in result
  Move(S^, Element^, FElementSize);
end;

procedure TpgColorMap.GetElementLinear256(X, Y: integer; const Element: pointer);
var
  Count, XBase, YBase, XInc, YInc: integer;
  Eb, B00, B01, B10, B11: PByte;
  XOfs, YOfs, XOfsI, YOfsI: integer;
begin
  // In this procedure we *always* ensure that values from the map are returned.
  // The coverage (elsewhere) will make sure that edge pixels get blended
  // correctly.

  // X = 128 should center dead-on on pixel 0, since X=[0..255] is pixel 0, so
  // we decrement here by half a pixel
  Dec(X, 128);
  Dec(Y, 128);

  // Outside map? (left, top)
  if X < 0 then X := 0;
  if Y < 0 then Y := 0;

  XOfs := X and $FF;
  XOfsI := 256 - XOfs;
  XBase := X shr 8;
  YOfs := Y and $FF;
  YOfsI := 256 - YOfs;
  YBase := Y shr 8;

  // Outside map? (right, bottom)
  if XBase >= FWidth  then XBase := FWidth - 1;
  if YBase >= FHeight then YBase := FHeight - 1;

  if XBase = FWidth - 1 then XInc := 0 else XInc := FElementSize;
  if YBase = FHeight - 1 then YInc := 0 else YInc := FWidth * FElementSize;

  // 4 corner coordinates
  B00 := PByte(integer(FMap) + (YBase * FWidth + XBase) * FElementSize);
  B01 := B00; inc(B01, XInc);
  B10 := B00; inc(B10, YInc);
  B11 := B10; inc(B11, XInc);

  Eb := Element;
  if FColorInfo.BitsPerChannel = bpc8bits then
  begin
    // 8bits
    Count := FColorInfo.Channels;
    while Count > 0 do
    begin
      // since (XOfsI + XOfs) = 256, and (YOfsI + YOfs) = 256, the total multiplication
      // is 256 * 256, so we divide by 2^16. We can do this with a shift since the value
      // should always be non-negative.
      Eb^ := ((B00^ * XOfsI + B01^ * XOfs) * YOfsI + (B10^ * XOfsI + B11^ * XOfs) * YOfs) shr 16;
      dec(Count);
      inc(B00); inc(B01); inc(B10); inc(B11); inc(Eb);
    end;
  end;
end;

function TpgColorMap.GetElements(x, y: integer): pointer;
begin
  Result := pointer(integer(FMap) + (Y * FWidth + X) * FElementSize);
end;

procedure TpgColorMap.ReAllocateMap;
begin
  FElementSize := pgColorElementSize(FColorInfo);
  if not FBorrowed then
    ReallocMem(FMap, MapMemorySize);
end;

procedure TpgColorMap.SetColorInfo(const Value: TpgColorInfo);
begin
  FColorInfo := Value;
  ReAllocateMap;
  DoChanged;
end;

{ TpgBitmap }

procedure TpgBitmap.DoChanged;
begin
  FChanged := True;
end;

function TpgBitmap.GetPixels(x, y: integer): TpgColor32;
var
  P: TpgColor;
begin
  // Put generic color in P
  GetElement(x, y, @P);
  // Convert to ARGB_8b_Org
  Result := pgColorTo4Ch8b(ColorInfo, cARGB_8b_Org, @P);
end;

procedure TpgBitmap.SetPixels(x, y: integer; const Value: TpgColor32);
begin
  // Convert to ARGB_8b_Org
  pgConvertColorArray(cARGB_8b_Org, ColorInfo, @Value, Elements[x, y], 1);
end;

{ TpgBitmap32 }

function TpgBitmap32.BoundsRect: TpgRect;
begin
  Result.Left := 0;
  Result.Top := 0;
  Result.Right := Width;
  Result.Bottom := Height;
end;

function TpgBitmap32.GetBits: PpgColor32Array;
begin
// todo
  Result := nil;
end;

function TpgBitmap32.GetPixelPtr(x, y: integer): PpgColor32;
begin
// todo
  Result := nil;
end;

function TpgBitmap32.GetScanline(YPos: integer): TpgColor32;
begin
// todo
  Result := 0;
end;

function TpgBitmap32.Get_TS256(x, y: integer): TpgColor32;
begin
// todo
  Result := 0;
end;

procedure TpgBitmap32.LoadFromStream(S: TStream);
begin
// todo
end;

function TpgBitmap32.MasterAlpha: byte;
begin
// todo
  Result := 0;
end;

procedure TpgBitmap32.SaveToStream(S: TStream);
begin
// todo
end;

{ functions }

procedure pgReplaceColor(ABitmap: TpgBitmap; ASourceCol, ATargetCol: TpgColor32; ATolerance: integer);
var
  i, Dist: integer;
  S: PpgColor32;
begin
  if not assigned(ABitmap) or (ABitmap.ElementSize <> 4) then
    exit;
  S := ABitmap.Map;
  for i := 0 to ABitmap.ElementCount - 1 do
  begin
    Dist := pgColorDistTaxi32(S, @ASourceCol);
    if Dist <= ATolerance then
    begin
      if (ATolerance > 0) and (Dist > 0) then
        S^ := pgColorBlend32(@ATargetCol, @ASourceCol, round(Dist/ATolerance * 255))
      else
        S^ := ATargetCol;
    end;
    inc(S);
  end;
end;

procedure GetColorMapIterator(AColorMap: TpgColorMap; AIterator: TsdMapIterator);
begin
  AIterator.Width := AColorMap.Width;
  AIterator.Height := AColorMap.Height;
  AIterator.Map := AColorMap.Map;
  AIterator.ScanStride := AColorMap.ElementSize * AColorMap.Width;
  AIterator.CellStride := AColorMap.ElementSize;
end;

procedure pgConvertBitmapToColorInfo(ABitmap: TpgBitmap; const NewColorInfo: TpgColorInfo);
var
  NewBitmap: TpgBitmap;
begin
  if not assigned(ABitmap) then
    exit;
  if pgCompareColorInfo(ABitmap.ColorInfo, NewColorInfo) then
    exit;
  // Create a new bitmap
  NewBitmap := TpgBitmap.Create;
  NewBitmap.ColorInfo := NewColorInfo;
  NewBitmap.SetSize(ABitmap.Width, ABitmap.Height);
  pgConvertColorArray(ABitmap.ColorInfo, NewBitmap.ColorInfo, ABitmap.Map, NewBitmap.Map,
    ABitmap.ElementCount);
  ABitmap.Assign(NewBitmap);
  NewBitmap.Free;
  ABitmap.Changed := True;
end;

end.
