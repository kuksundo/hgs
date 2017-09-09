{
  Unit dtpStretch

  The stretching routine (DownscaleTransfer) implemented here is for downscaling.
  In other cases (mixed, upscaling), dtpStretchTransfer will call StretchTransfer
  of the GraphicsEx library. Also, StretchFilter must be sfLinear1, in other cases
  the original method will be used.

  Project: DTP-Engine

  Creation Date: 27-10-2002 (NH)

  Modifications:
  - Added abstraction with dtpGraphics.pas

  Version: 1.1

  Copyright (c) 2002 - 2010 By Nils Haeck M.Sc. - SimDesign
  More information: www.simdesign.nl or n.haeck@simdesign.nl

  This source code may NOT be used or replicated without prior permission
  from the abovementioned author.

}
unit dtpStretch;

{$i simdesign.inc}

interface

uses
  Windows, Graphics, SysUtils, dtpGraphics;

procedure StretchTransferEx(
  Dst: TdtpBitmap;
  DstRect: TRect;
  Src: TdtpBitmap;
  SrcRect: TRect;
  StretchFilter: TdtpStretchFilter;
  CombineOp: TdtpDrawMode;
  CombineCallBack: TdtpPixelCombineEvent = nil);

procedure DownscaleTransfer(
  Dst: TdtpBitmap;
  DstRect: TRect;
  Src: TdtpBitmap;
  SrcRect: TRect);

type
  PIntArray = ^TIntArray;
  TIntArray = array[0..MaxInt div SizeOf(integer) - 1] of integer;

// Create Den parts from Num, with startpoints in Start (zerobased) and Sizes in Size
procedure CreateDivision(Num, Den: integer; var Start, Size: array of integer);

// Downscale the Source bitmap to the size of the Dest bitmap, by using a smart
// averaging. The bitmaps must have pixelformat pf24bit.
procedure DownscaleBitmap24(Source, Dest: TBitmap);

implementation

procedure CreateDivision(Num, Den: integer; var Start, Size: array of integer);
// Create Den parts from Num, with startpoints in Start (zerobased) and Sizes in Size
var
  i, Run, Left, Width: integer;
begin
  Run := 0;
  Left := 0;
  Width := Num div Den;
  for i := 0 to Den - 1 do
  begin
    Start[i] := Left;
    Size[i] := Width;
    Run := Run + Num - Width * Den;
    if Run >= Den then
    begin
      inc(Size[i]);
      Run := Run - Den;
    end;
    inc(Left, Size[i]);
  end;
end;

procedure DownscaleBitmap24(Source, Dest: TBitmap);
// Downscale the Source bitmap to the size of the Dest bitmap, by using a smart
// averaging.
var
  XStart, XSize: PIntArray;
  YStart, YSize: PIntArray;
  Target: PIntArray;
  Scan: ^Byte;
  r, br, c, bc, Idx: integer;
  SrcWidth, SrcHeight, DstWidth, DstHeight, Area: integer;
begin
  // assertions
  if not assigned(Source) or not assigned(Dest) then
    exit;
  if (Source.PixelFormat <> pf24bit) or (Dest.PixelFormat <> pf24Bit) then
    exit;

  SrcWidth  := Source.Width;
  SrcHeight := Source.Height;
  DstWidth  := Dest.Width;
  DstHeight := Dest.Height;

  if (SrcWidth * SrcHeight = 0) or (DstWidth * DstHeight = 0)
    or (SrcWidth < DstWidth) or (SrcHeight < DstHeight) then
    exit;

  GetMem(XStart, DstWidth  * SizeOf(Integer));
  GetMem(XSize , DstWidth  * SizeOf(Integer));
  GetMem(YStart, DstHeight * SizeOf(Integer));
  GetMem(YSize , DstHeight * SizeOf(Integer));
  GetMem(Target, DstWidth  * SizeOf(Integer) * 3);
  try

    // Create divisions
    CreateDivision(SrcWidth, DstWidth , XStart^, XSize^);
    CreateDivision(SrcHeight, DstHeight, YStart^, YSize^);

    // Rows
    for r := 0 to DstHeight - 1 do
    begin
      // Clear temp target row
      FillChar(Target^, DstWidth * SizeOf(Integer) * 3, 0);
      for br := YStart[r] to YStart[r] + YSize[r] - 1 do
      begin
        // Scan is a pointer to the first byte of the row in the source rect
        Scan := Source.ScanLine[br];
        for c := 0 to DstWidth - 1 do
        begin
          for bc := 1 to XSize[c] do
          begin
            Idx := c * 3;
            Inc(Target^[Idx], Scan^); inc(Scan); Inc(Idx);
            Inc(Target^[Idx], Scan^); inc(Scan); Inc(Idx);
            Inc(Target^[Idx], Scan^); inc(Scan);
          end;
        end;
      end;

      // averages
      Scan := Dest.Scanline[r];
      Idx := 0;
      for c := 0 to DstWidth - 1 do
      begin
        Area := YSize[r] * XSize[c];
        Scan^ := Target^[Idx] div Area; inc(Scan); inc(Idx);
        Scan^ := Target^[Idx] div Area; inc(Scan); inc(Idx);
        Scan^ := Target^[Idx] div Area; inc(Scan); inc(Idx);
      end;
    end;

  finally
    FreeMem(XStart);
    FreeMem(XSize);
    FreeMem(YStart);
    FreeMem(YSize);
    FreeMem(Target);
  end;

end;

{ DownscaleTransfer }

procedure DownscaleTransfer(
  Dst: TdtpBitmap;
  DstRect: TRect;
  Src: TdtpBitmap;
  SrcRect: TRect);

// Proprietary downscale algorithm: Fast AND preserves colors well!

// Up till now, I never saw this algorithm somewhere else. It exists of
// first determining all the rectangles that make up a pixel in the destination
// bitmap.

// Since there's not always 1:1, 1:2, 1:3 etc scaling possible, these rectangles
// may differ in size. "CreateDivision" determines the XSize, YSize of each
// rectangle, as well as its starting XStart, YStart.

// Next, the total sum over each rectangle for each color channel is counted, and
// then divided by the area size of the rectangle. This ensures that, although
// rectangles can differ in size, the final color perception looks adequate.

// No subpixel polling is neccesary, thus keeping it fast.

// Nils Haeck

var
  XStart, XSize: PIntArray;
  YStart, YSize: PIntArray;
  Target: PIntArray;
  Scan: ^Byte;
  r, br, c, bc, Idx: integer;
  DstWidth, DstHeight, Area: integer;
begin
  DstWidth  := DstRect.Right - DstRect.Left;
  DstHeight := DstRect.Bottom - DstRect.Top;

  GetMem(XStart, DstWidth  * SizeOf(Integer));
  GetMem(XSize , DstWidth  * SizeOf(Integer));
  GetMem(YStart, DstHeight * SizeOf(Integer));
  GetMem(YSize , DstHeight * SizeOf(Integer));
  GetMem(Target, DstWidth  * SizeOf(Integer) * 4);
  try

    // Create divisions
    CreateDivision(SrcRect.Right - SrcRect.Left, DstWidth , XStart^, XSize^);
    CreateDivision(SrcRect.Bottom - SrcRect.Top, DstHeight, YStart^, YSize^);

    // Rows
    for r := 0 to DstHeight - 1 do
    begin
      // Clear temp target row
      FillChar(Target^, DstWidth * SizeOf(Integer) * 4, 0);
      for br := YStart[r] to YStart[r] + YSize[r] - 1 do
      begin
        // Scan is a pointer to the first byte of the row in the source rect
        Scan := @Src.Bits[Src.Width * (br + SrcRect.Top) + SrcRect.Left];
        for c := 0 to DstWidth - 1 do
        begin
          for bc := 1 to XSize[c] do
          begin
            Idx := c shl 2;
            Inc(Target^[Idx], Scan^); inc(Scan); Inc(Idx);
            Inc(Target^[Idx], Scan^); inc(Scan); Inc(Idx);
            Inc(Target^[Idx], Scan^); inc(Scan); Inc(Idx);
            Inc(Target^[Idx], Scan^); inc(Scan);
          end;
        end;
      end;

      // averages
      Scan := @Dst.Bits[Dst.Width * (r + DstRect.Top) + DstRect.Left];
      Idx := 0;
      for c := 0 to DstWidth - 1 do
      begin
        Area := YSize[r] * XSize[c];
        Scan^ := Target^[Idx] div Area; inc(Scan); inc(Idx);
        Scan^ := Target^[Idx] div Area; inc(Scan); inc(Idx);
        Scan^ := Target^[Idx] div Area; inc(Scan); inc(Idx);
        Scan^ := Target^[Idx] div Area; inc(Scan); inc(Idx);
      end;
    end;

  finally
    FreeMem(XStart);
    FreeMem(XSize);
    FreeMem(YStart);
    FreeMem(YSize);
    FreeMem(Target);
  end;

end;


{ StretchTransferEx }

procedure StretchTransferEx(
  Dst: TdtpBitmap;
  DstRect: TRect;
  Src: TdtpBitmap;
  SrcRect: TRect;
  StretchFilter: TdtpStretchFilter;
  CombineOp: TdtpDrawMode;
  CombineCallBack: TdtpPixelCombineEvent);
begin
  if ((DstRect.Right - DstRect.Left) > (SrcRect.Right - SrcRect.Left)) or
     ((DstRect.Bottom - DstRect.Top) > (SrcRect.Bottom - SrcRect.Top)) or
     (StretchFilter <> dtpsfLinear) or
     (CombineOp <> dtpdmOpaque) then
  begin

    // Call the original
    SetStretchFilter(Dst, StretchFilter);
    {$ifdef usegr32}
    StretchTransfer(
      Dst,
      DstRect,
      Dst.BoundsRect,
      Src,
      SrcRect,
      Dst.Resampler,
      CombineOp,
      CombineCallBack);
    {$else} //usepyro
    {$endif}

  end else
  begin

    // Do our own proprietary downscale routine, that preserves colors better
    DownscaleTransfer(Dst, DstRect, Src, SrcRect);

  end;
end;

end.
