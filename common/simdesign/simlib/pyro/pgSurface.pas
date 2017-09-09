{ <b>Project</b>: Pyro<p>
  <b>Module</b>: Pyro Render<p>

  <b>Description:</b><p>
    TpgSurface is the base class for pixel-based surfaces.

  <b>Author</b>: Nils Haeck (n.haeck@simdesign.nl)<p>
  Copyright (c) 2006 SimDesign BV
}
unit pgSurface;

{$i simdesign.inc}

interface

uses
  Classes, SysUtils, Pyro, pgCover, pgColor, pgSampler, pgBlend, pgBitmap;

type

  // TpgSurface implements a pixel-based surface to draw on. It can be basically
  // any pixel configuration, while the descendant TpgAbstract4Ch8bSurface
  // implements a specific 4 channel 8bpc bitmap surface. Override TpgSurface to
  // provide other pixel configurations
  TpgSurface = class(TPersistent)
  protected
    FHeight: integer;
    FWidth: integer;
    // This function should provide the colorinfo for this surface
    function GetColorInfo: PpgColorInfo; virtual; abstract;
  public
    procedure Clear; virtual;
    destructor Destroy; override;
    function MemorySize: integer; virtual;
    procedure FillRectangle(AX, AY, AWidth, AHeight: integer; AColorData: pointer; const AInfo: TpgColorInfo); virtual; abstract;
    // Paint on the surface using the data from ACover, with a single color from
    // AColor and AInfo.
    procedure PaintCover(ACover: TpgCover; AColor: pointer; const AInfo: TpgColorInfo); virtual; abstract;
    procedure PaintCoverWithSampler(ACover: TpgCover; ASampler: TpgSampler; AAlpha: integer = $FF); virtual; abstract;
    // Set the size of the surface in pixels.
    procedure SetSize(AWidth, AHeight: integer); virtual;
    // Color space information of the underlying bitmap
    property ColorInfo: PpgColorInfo read GetColorInfo;
  published
    // Width of the surface in pixels. Use SetSize to change.
    property Width: integer read FWidth;
    // Height of the surface in pixels. Use SetSize to change.
    property Height: integer read FHeight;
  end;

  // Abstract surface for processing 4chan colors at 8 bits per pixel.
  TpgAbstract4Ch8bSurface = class(TpgSurface)
  protected
    FBorrowed: boolean;
    FBuffer: array of TpgColor32;
    function HasSurface: boolean; virtual; abstract;
    procedure AdjustBuffer(ACount: integer); virtual;
  public
    function MemorySize: integer; override;
    function MapPointer(AXPos, AYPos: integer): PpgColor32; virtual; abstract;
    procedure FillRectangle(AX, AY, AWidth, AHeight: integer; AColorData: pointer; const AInfo: TpgColorInfo); override;
    procedure PaintCover(ACover: TpgCover; AColor: pointer; const AInfo: TpgColorInfo); override;
    procedure PaintCoverWithSampler(ACover: TpgCover; ASampler: TpgSampler; AAlpha: integer = $FF); override;
  end;

  TpgMap4Ch8bSurface = class(TpgAbstract4Ch8bSurface)
  private
    FMap: TpgColorMap;
  protected
    function HasSurface: boolean; override;
    function GetColorInfo: PpgColorInfo; override;
  public
    function MapPointer(AXPos, AYPos: integer): PpgColor32; override;
    procedure Clear; override;
    procedure BorrowMap(AMap: TpgColorMap);
    procedure SetSize(AWidth, AHeight: integer); override;
  end;

resourcestring

  sIncompatibleMaps = 'Incompatible maps';

implementation

{ TpgSurface }

type

  TMapAccess = class(TpgMemoryMap);

procedure TpgSurface.Clear;
begin
  FWidth := 0;
  FHeight := 0;
end;

destructor TpgSurface.Destroy;
begin
  Clear;
  inherited;
end;

function TpgSurface.MemorySize: integer;
begin
  Result := 0;
end;

procedure TpgSurface.SetSize(AWidth, AHeight: integer);
begin
  FWidth := AWidth;
  FHeight := AHeight;
end;

{ TpgAbstract4Ch8bSurface }

procedure TpgAbstract4Ch8bSurface.AdjustBuffer(ACount: integer);
begin
  if ACount > length(FBuffer) then
    SetLength(FBuffer, ACount);
end;

procedure TpgAbstract4Ch8bSurface.FillRectangle(AX, AY, AWidth, AHeight: integer;
  AColorData: pointer; const AInfo: TpgColorInfo);
var
  i, j: integer;
  P: PpgColor32;
  Col32: TpgColor32;
begin
  Col32 := pgColorTo4Ch8b(AInfo, ColorInfo^, AColorData);
  for i := 0 to AHeight - 1 do begin
    P := MapPointer(AX, AY + i);
    for j := 0 to AWidth - 1 do begin
      P^ := Col32;
      inc(P);
    end;
  end;
end;

function TpgAbstract4Ch8bSurface.MemorySize: integer;
begin
  if FBorrowed then
    Result :=  FWidth * FHeight // size of cover map
  else
    Result := FWidth * FHeight * 5; // size of bitmap + cover map
end;

procedure TpgAbstract4Ch8bSurface.PaintCover(ACover: TpgCover; AColor: pointer;
  const AInfo: TpgColorInfo);
var
  i: integer;
  Span: PpgSpan;
  CoverFirst: Pbyte;
  Value: byte;
  Col32: TpgColor32;
  BlendFunc: TpgBlendFunc;
  BlendInfo: TpgBlendInfo;
begin
  if not HasSurface then exit;
  CoverFirst := ACover.Covers;
  Col32 := pgColorTo4Ch8b(AInfo, ColorInfo^, AColor);

  // Blend function and blendinfo init
  BlendFunc := SelectBlendFunc(ColorInfo^, emStandard, BlendInfo);
  BlendInfo.PColSrc := @Col32;

  // loop through spans
  Span := ACover.Spans;
  for i := 0 to ACover.SpanCount - 1 do
  begin

    // Setup blendinfo
    AdjustBuffer(Span.Count * 2);
    BlendInfo.Buffer := @FBuffer[0];
    BlendInfo.Count := Span.Count;
    BlendInfo.PColDst := MapPointer(Span.XPos, Span.YPos);
    if Span.Index < 0 then
    begin
      // Solid span
      Value := -Span.Index;
      if Value < $FF then
        BlendInfo.PCvrSrc := @Value
      else
        BlendInfo.PCvrSrc := nil;
      BlendInfo.IncCvr := 0;
    end else
    begin
      // AA span
      AdjustBuffer(Span.Count * 2);
      BlendInfo.Buffer := @FBuffer[0];
      BlendInfo.PCvrSrc := CoverFirst;
      inc(BlendInfo.PCvrSrc, Span.Index);
      BlendInfo.IncCvr := 1;
    end;

    // Do the blending
    BlendFunc(BlendInfo);
    inc(Span);
  end;
end;

procedure TpgAbstract4Ch8bSurface.PaintCoverWithSampler(ACover: TpgCover; ASampler: TpgSampler; AAlpha: integer = $FF);
var
  i: integer;
  Span: PpgSpan;
  CoverFirst: Pbyte;
  Value: byte;
  P: pbyte;
  SamplerInfo: TpgColorInfo;
  FColBuf: array of TpgColor32;
  BlendFunc: TpgBlendFunc;
  BlendInfo: TpgBlendInfo;
begin
  if not HasSurface or not assigned(ASampler) then exit;
  AAlpha := pgMin($FF, pgMax(0, AAlpha));
  if AAlpha = 0 then exit;
  CoverFirst := ACover.Covers;
  if AAlpha < $FF then
  begin
    // Adjust cover values
    P := CoverFirst;
    for i := 0 to ACover.CoverCount - 1 do
    begin
      P^ := pgIntMul(P^, AAlpha);
      inc(P);
    end;
  end;
  ASampler.GetColorInfo(SamplerInfo);
  ASampler.PrepareSpanWidth(ACover.Width);

  // Blend function and blendinfo init
  BlendFunc := SelectBlendFunc(ColorInfo^, emStandard, BlendInfo);
  BlendInfo.IncSrc := 1;

  Span := ACover.Spans;
  for i := 0 to ACover.SpanCount - 1 do begin
    // Get the colors in this span
    P := ASampler.GetColorSpan(Span.XPos, Span.YPos, Span.Count);

    // Convert colors to our format
    SetLength(FColBuf, pgMax(Span.Count, length(FColBuf)));
    pgColorArrayTo4Ch8b(SamplerInfo, ColorInfo^, P, @FColBuf[0], Span.Count);

    // Setup blendinfo
    AdjustBuffer(Span.Count * 2);
    BlendInfo.Buffer := @FBuffer[0];
    BlendInfo.PColSrc := @FColBuf[0];
    BlendInfo.PColDst := MapPointer(Span.XPos, Span.YPos);
    BlendInfo.Count := Span.Count;
    if Span.Index < 0 then
    begin
      // Solid span
      Value := pgIntMul(-Span.Index, AAlpha);
      if Value < $FF then
        BlendInfo.PCvrSrc := @Value
      else
        BlendInfo.PCvrSrc := nil;
      BlendInfo.IncCvr := 0;
    end else
    begin
      // AA span
      BlendInfo.PCvrSrc := CoverFirst;
      inc(BlendInfo.PCvrSrc, Span.Index);
      BlendInfo.IncCvr := 1;
    end;

    // do the blending
    BlendFunc(BlendInfo);
    inc(Span);
  end;
end;

{ TpgMapARGB8Surface }

procedure TpgMap4Ch8bSurface.BorrowMap(AMap: TpgColorMap);
begin
  Clear;
  FMap := AMap;
  FBorrowed := True;
  FWidth := FMap.Width;
  FHeight := FMap.Height;
  if not (
    (FMap.ColorInfo.BitsPerChannel = bpc8bits) and
    (FMap.ColorInfo.Channels = 4) and
    (FMap.ColorInfo.ColorModel = cmAdditive) and
    (FMap.ColorInfo.AlphaMode <> amDropAlpha)) then
    raise Exception.Create(sIncompatibleMaps);
end;

procedure TpgMap4Ch8bSurface.Clear;
begin
  if assigned(FMap) and not FBorrowed then
    FreeAndNil(FMap);
  FBorrowed := False;
  inherited;
end;

function TpgMap4Ch8bSurface.GetColorInfo: PpgColorInfo;
begin
  if assigned(FMap) then
    Result := @FMap.ColorInfo
  else
    Result := nil;
end;

function TpgMap4Ch8bSurface.HasSurface: boolean;
begin
  Result := assigned(FMap);
end;

function TpgMap4Ch8bSurface.MapPointer(AXPos, AYPos: integer): PpgColor32;
begin
  Result := PpgColor32(TMapAccess(FMap).ElementPtr[AXPos, AYPos]);
end;

procedure TpgMap4Ch8bSurface.SetSize(AWidth, AHeight: integer);
begin
  inherited;
  if assigned(FMap) then
    FMap.SetSize(AWidth, AHeight);
end;

end.
