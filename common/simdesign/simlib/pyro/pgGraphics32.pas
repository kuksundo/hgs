{
  Simple compatibility operators for Graphics32

  Creation Date:
  02Aug2006

  Modifications:

  Author: Nils Haeck
  Copyright (c) 2006 by SimDesign B.V.

}
unit pgGraphics32;

{$i simdesign.inc}

interface

uses
  SysUtils, Graphics, pgSurface, Pyro, pgBitmap, pgCanvas, 
  pgBlend, GR32;

procedure ConvertBitmap32ToMap(ABmp: TBitmap32; AMap: TpgColorMap);

procedure ConvertMapToBitmap32(AMap: TpgColorMap; ABitmap32: TBitmap32);

resourcestring
  sUnsupportedColorDepth = 'Unsupported Color Depth';

implementation

type

  TMapAccess = class(TpgColorMap);

procedure ConvertBitmap32ToMap(ABmp: TBitmap32; AMap: TpgColorMap);
var
  y, ScanWidth: integer;
  S: Pbyte;
  D: Pbyte;
begin
  if not assigned(ABmp) or not assigned(AMap) then
    exit;

  AMap.SetColorInfo(cARGB_8b_Org);
  ScanWidth := ABmp.Width * 4;

  // Set map size
  AMap.SetSize(ABmp.Width, ABmp.Height);

  // Copy scanlines
  for y := 0 to ABmp.Height - 1 do
  begin
    S := PByte(ABmp.ScanLine[y]);
    D := TMapAccess(AMap).ScanLine[y];
    Move(S^, D^, ScanWidth);
  end;

end;

procedure ConvertMapToBitmap32(AMap: TpgColorMap; ABitmap32: TBitmap32);
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
  ScanWidth := AMap.Width * 4;
  // Set bitmap size
  ABitmap32.Width := AMap.Width;
  ABitmap32.Height := AMap.Height;

  // Copy scanlines
  for y := 0 to AMap.Height - 1 do
  begin
    S := TMapAccess(AMap).ScanLine[y];
    D := ABitmap32.ScanLine[y];
    Move(S^, D^, ScanWidth);
  end;

end;

end.
