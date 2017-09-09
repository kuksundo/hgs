{
  Compatibility operators for Windows GDI

  Creation Date:
  02Aug2006

  Modifications:

  Author: Nils Haeck
  Copyright (c) 2006 by SimDesign B.V.

}
unit pgWinGDI;

{$i simdesign.inc}

interface

uses
  // uses Graphics: TBitmap
  SysUtils, Graphics,

  // pyro
  pgSurface, pgColor, pgBitmap, pgCanvas, Pyro;

type

  // for compatibility reasons with GDI, we provide a TBitmap surface. This
  // one is for TBitmap with PixelFormat = pf32bit
  TpgGDIBmp32Surface = class(TpgAbstract4Ch8bSurface)
  private
    FBitmap: TBitmap;
    FColorInfo: TpgColorInfo;
  protected
    function HasSurface: boolean; override;
    function GetColorInfo: PpgColorInfo; override;
  public
    constructor Create;
    function MapPointer(AXPos, AYPos: integer): PpgColor32; override;
    procedure Clear; override;
    procedure BorrowBitmap(ABitmap: TBitmap);
    procedure SetSize(AWidth, AHeight: integer); override;
  end;

  TpgGDIBitmap = class(TpgColorMap)
  public
    procedure Borrow(ABitmap: TBitmap);
  end;

function GDIToColor32(AColor: TColor; AAlpha: byte): TpgColor32;
procedure Color32ToGDI(AColor32: TpgColor32; var AAlpha: byte; var AColor: TColor);

procedure ClearGDIBitmap(ABitmap: TBitmap; const AColor: TpgColor32 = $00000000);
procedure FlipGDIBitmapAlpha(ABitmap: TBitmap);

procedure ConvertBmpToMap(ABmp: TBitmap; AMap: TpgColorMap);

procedure ConvertBmpToMapWithInfo(
  ABmp: TBitmap; const ABmpInfo: TpgColorInfo;
  AMap: TpgColorMap; const AMapInfo: TpgColorInfo);

procedure ConvertMapToBmp(AMap: TpgColorMap; ABmp: TBitmap);

resourcestring

  sIllegalPixelFormat    = 'Illegal pixel format (must be pf32bit)';
  sUnsupportedColorDepth = 'Unsupported Color Depth';

implementation

type

  TMapAccess = class(TpgColorMap);

function RedFromColor(AColor: TColor): byte;
begin
  Result := AColor AND $000000FF;
end;

function GreenFromColor(AColor: TColor): byte;
begin
  Result := (AColor shr 8) AND $000000FF;
end;

function BlueFromColor(AColor: TColor): byte;
begin
  Result := (AColor shr 16) AND $000000FF;
end;

procedure ClearGDIBitmap(ABitmap: TBitmap; const AColor: TpgColor32);
var
  x, y, Width: integer;
  P, P2: pointer;
  A: byte;
  Col: TColor;
  R, G, B: Pbyte;
  Rc, Gc, Bc: byte;
begin
  if (ABitmap.Width = 0) or (ABitmap.Height = 0) then
    exit;
  case ABitmap.PixelFormat of
  pf32bit:
    begin
      P := ABitmap.ScanLine[0];
      if ABitmap.Height > 1 then
      begin
        P2 := ABitmap.ScanLine[1];
        // Bitmap is bottom-up: so use last scanline as first
        if integer(P2) < integer(P) then
          P := ABitmap.ScanLine[ABitmap.Height - 1];
      end;
      pgFillLongWord(P^, ABitmap.Width * ABitmap.Height, AColor);
    end;
  pf24bit:
    begin
      Color32ToGDI(AColor, A, Col);
      Width := ABitmap.Width;
      // color components
      Rc := RedFromColor(Col);
      Gc := GreenFromColor(Col);
      Bc := BlueFromColor(Col);

      // all the same?
      if (Rc = Gc) and (Rc = Bc) then
      begin

        for y := 0 to ABitmap.Height - 1 do
        begin
          P := ABitmap.ScanLine[y];
          FillChar(P^, Width * 3, Rc);
        end;

      end else
      begin
        for y := 0 to ABitmap.Height - 1 do
        begin
          R := ABitmap.ScanLine[y];
          G := R; inc(G);
          B := G; inc(B);
          for x := 0 to Width - 1 do
          begin
            R^ := Rc; inc(R, 3);
            G^ := Gc; inc(G, 3);
            B^ := Bc; inc(B, 3);
          end;
        end;
      end;
    end;
  end;
end;

procedure FlipGDIBitmapAlpha(ABitmap: TBitmap);
var
  x, y, Width: integer;
  P: PpgColor32;
begin
  if ABitmap.PixelFormat <> pf32bit then
    exit;
  Width := ABitmap.Width;
  for y := 0 to ABitmap.Height - 1 do
  begin
    P := ABitmap.ScanLine[y];
    for x := 0 to Width - 1 do
    begin
      P^ := P^ XOR $FF000000;
      inc(P);
    end;
  end;
end;

function GDIToColor32(AColor: TColor; AAlpha: byte): TpgColor32;
begin
  AColor := ColorToRGB(AColor);
  TpgColorARGB(Result).R := RedFromColor(AColor);
  TpgColorARGB(Result).G := GreenFromColor(AColor);
  TpgColorARGB(Result).B := BlueFromColor(AColor);
  TpgColorARGB(Result).A := AAlpha;
end;

procedure Color32ToGDI(AColor32: TpgColor32; var AAlpha: byte; var AColor: TColor);
begin
  AColor :=
    TpgColorARGB(AColor32).R +
    TpgColorARGB(AColor32).G shl 8 +
    TpgColorARGB(AColor32).B shl 16;
  AAlpha := TpgColorARGB(AColor32).A;
end;

procedure ConvertBmpToMap(ABmp: TBitmap; AMap: TpgColorMap);
var
  x, y, ScanWidth, Color: integer;
  S: Pbyte;
  D: Pbyte;
begin
  if not assigned(ABmp) or not assigned(AMap) then
    exit;
  case ABmp.PixelFormat of
  pf24bit:
    begin
      AMap.SetColorInfo(cRGB_8b);
      ScanWidth := ABmp.Width * 3;
    end;
  pf32bit:
    begin
      AMap.SetColorInfo(cARGB_8b_Org);
      ScanWidth := ABmp.Width * 4;
    end;
  else
    // use deadslow pixel access
    AMap.SetSize(ABmp.Width, ABmp.Height);
    AMap.SetColorInfo(cRGB_8b);
    for y := 0 to ABmp.Height - 1 do
    begin
      D := TMapAccess(AMap).ScanLine[y];
      for x := 0 to ABmp.Width - 1 do
      begin
        Color := ColorToRGB(ABmp.Canvas.Pixels[x, y]);
        D^ := (Color and $00FF0000) shr 16; inc(D);
        D^ := (Color and $0000FF00) shr  8; inc(D);
        D^ := (Color and $000000FF); inc(D);
      end;
    end;
    exit;
  end;

  // Set map size
  AMap.SetSize(ABmp.Width, ABmp.Height);

  // Copy scanlines
  for y := 0 to ABmp.Height - 1 do
  begin
    S := ABmp.ScanLine[y];
    D := TMapAccess(AMap).ScanLine[y];
    Move(S^, D^, ScanWidth);
  end;

end;

procedure ConvertBmpToMapWithInfo(
  ABmp: TBitmap; const ABmpInfo: TpgColorInfo;
  AMap: TpgColorMap; const AMapInfo: TpgColorInfo);
var
  y, Width: integer;
  S, D: pointer;
begin
  AMap.SetColorInfo(AMapInfo);
  AMap.SetSize(ABmp.Width, ABmp.Height);
  Width := ABmp.Width;
  for y := 0 to ABmp.Height - 1 do
  begin
    S := ABmp.ScanLine[y];
    D := TMapAccess(AMap).ScanLine[y];
    pgConvertColorArray(ABmpInfo, AMapInfo, S, D, Width);
  end;
end;

procedure ConvertMapToBmp(AMap: TpgColorMap; ABmp: TBitmap);
var
  y, ScanWidth: integer;
  S: pointer;
  D: pointer;
begin
  // checks
  if not (AMap.ColorInfo.Channels in [3, 4]) then
    raise Exception.Create(sUnsupportedColorDepth);
  if AMap.ColorInfo.BitsPerChannel <> bpc8bits then
    raise Exception.Create(sUnsupportedColorDepth);

  // Set correct pixelformat
  ScanWidth := 0;
  case AMap.ColorInfo.Channels of
  3:
    begin
      ABmp.PixelFormat := pf24bit;
      ScanWidth := AMap.Width * 3;
    end;
  4:
    begin
      ABmp.PixelFormat := pf32bit;
      ScanWidth := AMap.Width * 4;
    end;
  end;

  // Set bitmap size
  ABmp.Width := AMap.Width;
  ABmp.Height := AMap.Height;

  // Copy scanlines
  for y := 0 to AMap.Height - 1 do
  begin
    S := TMapAccess(AMap).ScanLine[y];
    D := ABmp.ScanLine[y];
    Move(S^, D^, ScanWidth);
  end;

end;

{function pgBoxToRect(const ABox: TpgBox): TRect;
begin
  Result.Left := round(ABox.Lft - 0.5);
  Result.Top := round(ABox.Top - 0.5);
  Result.Right := round(ABox.Rgt + 0.5);
  Result.Bottom := round(ABox.Btm + 0.5);
end;}

{ TpgGDIBmp32Surface }

procedure TpgGDIBmp32Surface.BorrowBitmap(ABitmap: TBitmap);
begin
  Clear;
  FBitmap := ABitmap;
  // Check pixelformat
  if ABitmap.PixelFormat <> pf32bit then
    raise Exception.Create(sIllegalPixelFormat);
  FBorrowed := True;
  FWidth := FBitmap.Width;
  FHeight := FBitmap.Height;
end;

procedure TpgGDIBmp32Surface.Clear;
begin
  if assigned(FBitmap) and not FBorrowed then
    FreeAndNil(FBitmap);
  FBorrowed := False;
  inherited;
end;

constructor TpgGDIBmp32Surface.Create;
begin
  inherited Create;
  FColorInfo := cARGB_8b_Pre;
end;

function TpgGDIBmp32Surface.GetColorInfo: PpgColorInfo;
begin
  Result := @FColorInfo;
end;

function TpgGDIBmp32Surface.HasSurface: boolean;
begin
  Result := assigned(FBitmap);
end;

function TpgGDIBmp32Surface.MapPointer(AXPos, AYPos: integer): PpgColor32;
begin
  Result := FBitmap.ScanLine[AYpos];
  inc(Result, AXPos);
end;

procedure TpgGDIBmp32Surface.SetSize(AWidth, AHeight: integer);
begin
  inherited;
  if assigned(FBitmap) then
  begin
{    FBitmap.Width := pgMax(FBitmap.Width, AWidth);
    FBitmap.Height := pgMax(FBitmap.Height, AHeight);}
    FBitmap.Width := AWidth;
    FBitmap.Height := AHeight;
    ClearGDIBitmap(FBitmap);
  end;
end;

{ TpgGDIBitmap }

procedure TpgGDIBitmap.Borrow(ABitmap: TBitmap);
begin
//todo
end;

end.
