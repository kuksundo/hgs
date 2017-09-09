{ Project: Pyro
  Module: Image Processing

  Description:

  procedure pgFloodfill will do a floodfill in a pgBitmap. It can
  also be used for magic wand selection.

  Project: Pyro

  Creation Date: 22-08-2003 (NH)
  Version: 1.0

  Modifications:

  Contributors:
  20Jan2004: Chris Riley adapted the floodfill routine to use recursion, much
             faster now.

  Author: Nils Haeck (n.haeck@simdesign.nl
  Copyright (c) 2003 - 2011 SimDesign BV
}
unit pgFloodfill;

interface

uses
  Contnrs, pgBitmap;

type
  // Include function that is used as callback, AColor points to the current
  // color of cell x,y, Info is the info pointer passed by the application to
  // the floodfill routine
  TIncludeFunction = function(AColor: pointer; Info: pointer): boolean;

// Floodfill algorithm that can be used for floodfill, magic wand, etc.
// It will scan ADib starting at X, Y and include all surrounding pixels in the
// bytemap that should be included according to IncludeFunc. All pixels that
// are included will have a value <> 0 in the bytemap.
// Parameters:
// - ABitmap: The bitmap to scan (must be initialized)
// - Sx, Sy: the starting point of the floodfill
// - IncludeFunc: the callback function that will be used. It must return "True" for
//         pixels/colors that should be included. IncludeFunc should also process
//         the bitmap (aka change colors, etc).
// - Info: pointer to information that will be passed to the includefunc, can be nil
procedure FloodFill(ABitmap: TpgBitmap; Sx, Sy: integer; IncludeFunc: TIncludeFunction;
  Info: pointer);

implementation

type

  TThrottleHoldObj = class(TObject)
  public
    x,
    y ,
    dir: integer;
  end;

const
  cUnchecked  = 0;
  cIncluded   = 1;
  cBoundary   = 2;

  cUp         = 0;
  cDown       = 1;
  cLeft       = 2;
  cRight      = 3;
  cUnknown    = 4;

  // Max recursive depth
  cThrottleDepth = 10000;

procedure FloodFill(ABitmap: TpgBitmap; Sx, Sy: integer; IncludeFunc: TIncludeFunction;
  Info: pointer);
var
  AChk: TpgByteMap;
  AWidth, AHeight: integer;
  RecursiveDepth: integer;
  ThrottleHold: TObjectStack;
  ThrottleHoldObj: TThrottleHoldObj;
//  isBoundary: boolean;

// Note from: Chris Riley
// -----------------------------------------------------------------------------
// I have included a directional parameter in the recursive procedure for checking
// pixels.  The purpose for this is to further streamline the process of analyzing
// the pixels for matches.  Since we know that we don't need to check pixels that
// lie BEHIND, it makes sence to use this parameter to determine the direction in
// which the check was issued from.
//
// The resulting process is that each checked pixel spawns up to three new directional
// searches based upon its issued direction.  For example, the CheckUpPixel only
// needs to issue checks for the left and right pixels to it, as well as continuing
// upwards.
// -----------------------------------------------------------------------------

  // local
  procedure SpawnNextPixel(x, y, dir: integer);
  var
    ThrottleHoldObj: TThrottleHoldObj;
  begin
    Inc(RecursiveDepth);
    if RecursiveDepth > cThrottleDepth then
    begin
      // we've exceeded our RecursiveDepth Throttle limit, so push this call's
      // parameter's onto the stack so that we can call them again after the
      // recursive calls have settled
      ThrottleHoldObj := TThrottleHoldObj.Create;
      ThrottleHoldObj.x := x;
      ThrottleHoldObj.y := y;
      ThrottleHoldObj.dir := dir;
      ThrottleHold.Push(ThrottleHoldObj);
      exit;
    end;

    //check up
    if (dir <> cDown) and (y > 0) and (AChk[x, y - 1] = cUnchecked) then
    begin
      if IncludeFunc(ABitmap[x, y - 1], Info) then
      begin
        // Found an included pixel, so continue upwards
        AChk[x, y - 1] := cIncluded;
        SpawnNextPixel(x, y - 1, cUp);
      end
      else
      begin
        AChk[x, y - 1] := cBoundary;
      end;
    end;

    //check left
    if (dir <> cRight) and (x > 0) and (AChk[x - 1, y] = cUnchecked) then
    begin
      if IncludeFunc(ABitmap[x - 1, y], Info) then
      begin
        // Found an included pixel, so continue left
        AChk[x - 1, y] := cIncluded;
        SpawnNextPixel(x - 1, y, cLeft);
      end
      else
      begin
        AChk[x - 1, y] := cBoundary;
      end;
    end;

    //check right
    if (dir <> cLeft) and (x < AWidth-1) and (AChk[x + 1, y] = cUnchecked) then
    begin
      if IncludeFunc(ABitmap[x + 1, y], Info) then
      begin
        // Found an included pixel, so continue right
        AChk[x + 1, y] := cIncluded;
        SpawnNextPixel(x + 1, y, cRight);
      end
      else
      begin
        AChk[x + 1, y] := cBoundary;
      end;
    end;

    //check down
    if (dir <> cUp) and (y < AHeight-1) and (AChk[x, y + 1] = cUnchecked) then
    begin
      if IncludeFunc(ABitmap[x, y + 1], Info) then
      begin
        // Found an included pixel, continue downwards
        AChk[x, y + 1] := cIncluded;
        SpawnNextPixel(x, y + 1, cDown);
      end
      else
      begin
        AChk[x, y + 1] := cBoundary;
      end;
    end;

  end;

// Main
begin
  // Checks
  if not assigned(ABitmap) then
    exit;
  if not assigned(IncludeFunc) then
    exit;
  if (Sx < 0) or (Sx >= ABitmap.Width) or (Sy < 0) or (Sy >= ABitmap.Height) then
    exit;

  // Create the ThrottleHold stack before we begin
  ThrottleHold := TObjectStack.Create;
  RecursiveDepth := 0;

  // This will preserve the map, unless the size is not the same as ADib
  AWidth  := ABitmap.Width;
  AHeight := ABitmap.Height;

  // "Check" map: 0=Unchecked, 1=Included, 2=Boundary
  AChk := TpgBytemap.Create;
  try
    AChk.SetSize(AWidth, AHeight);
    AChk.Clear(0);

    if IncludeFunc(ABitmap[Sx, Sy], Info) then
      AChk[Sx, Sy] := cIncluded
    else
      AChk[Sx, Sy] := cBoundary;

    // Call the first of recursive routines
    SpawnNextPixel(Sx, Sy, cUnknown);

    // we may now have some recursive calls held because they exceeded our
    // throttle limit, so enter into this loop to start them back up if they do
    while ThrottleHold.Count > 0 do
    begin
      RecursiveDepth := 0;
      ThrottleHoldObj := TThrottleHoldObj(ThrottleHold.Pop);
      SpawnNextPixel(ThrottleHoldObj.x, ThrottleHoldObj.y, ThrottleHoldObj.dir);
      ThrottleHoldObj.Free;
    end;
  finally
    AChk.Free;
    ThrottleHold.Free;
  end;
end;

end.
