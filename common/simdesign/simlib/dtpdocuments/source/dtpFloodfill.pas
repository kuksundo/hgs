{
  Unit dtpFloodFill

  procedure Floodfill will do a floodfill in a DIB (TBitmap32). It can
  also be used for magic wand selection.

  Project: DTP-Engine

  Creation Date: 22-08-2003 (NH)
  Version: 1.0

  Modifications:

  Contributors:
  20Jan2004: Chris Riley adapted the floodfill routine to use recursion, much
             faster now.

  Copyright (c) 2003-2010 By Nils Haeck M.Sc. - SimDesign
  More information: www.simdesign.nl or n.haeck@simdesign.nl

  This source code may NOT be used or replicated without prior permission
  from the abovementioned author.

}
unit dtpFloodfill;

{$i simdesign.inc}

interface

uses
  dtpGraphics, Contnrs;

type
  TIncludeFunction = function(const AColor: TdtpColor; Info: pointer): boolean;

  // Note from: Chris Riley

  // The SetMapPointFunction allows for the user to set whatever mask value they want
  // for a point.  Say the want to select only the alpha values of a set of matching
  // pixels, the can easily achieve that with this method.
  TSetMapPointFunction = function(const AColor: TdtpColor; x, y: integer; isBoundary: boolean = false): byte;

  TThrottleHoldObj = class(TObject)
    public
      x, y , dir: integer;
  end;

// Floodfill algorithm that can be used for floodfill, magic wand, etc.
// It will scan ADib starting at X, Y and include all surrounding pixels in the
// bytemap that should be included according to IncludeFunc. All pixels that
// are included will have a value <> 0 in the bytemap.
// Parameters:
// - ADib: The bitmap to scan (must be initialized)
// - AMap: The bytemap that will be filled with the result. Must be initialized,
//         will be set to the same size as ADib. If AMap already contains values,
//         and it is the same size as ADib, they will be preserved.
// - Sx, Sy: the starting point of the floodfill
// - IncludeFunc: the callback function that will be used. It must return "True" for
//         pixels/colors that should be included.
// - SetMapFunc: the callback function used to set a point's byte value in the AMap
//         It can be used to store channel information from a points color
//         or can be used to create a varied mask value (for example, changing
//         value when close to a boundary or creating marching ant outlines)
// - Info: pointer to information that will be passed to the includefunc, can be nil
// - Throttle: integer used to limit the maximum depth of recursive calls before
//         the recursive processing takes a pause and resets
procedure FloodFill(ADib: TdtpBitmap; AMap: TdtpBytemap; Sx, Sy: integer; IncludeFunc: TIncludeFunction; Info: pointer; SetMapFunc: TSetMapPointFunction; Throttle: integer = 10000);

implementation

const
  cUnchecked  = 0;
  cIncluded   = 1;
  cBoundary   = 2;

  cUp         = 0;
  cDown       = 1;
  cLeft       = 2;
  cRight      = 3;

procedure FloodFill(ADib: TdtpBitmap; AMap: TdtpBytemap; Sx, Sy: integer;
  IncludeFunc: TIncludeFunction; Info: pointer; SetMapFunc: TSetMapPointFunction;
  Throttle: integer = 10000);
// Floodfill algorithm that can be used for floodfill, magic wand, etc.
// It will scan ADib starting at X, Y and include all surrounding pixels in the
// bytemap that should be included according to IncludeFunc. All pixels that
// are included will have a value <> 0 in the bytemap.
// Parameters:
// - ADib: The bitmap to scan (must be initialized)
// - AMap: The bytemap that will be filled with the result. Must be initialized,
//         will be set to the same size as ADib. If AMap already contains values,
//         and it is the same size as ADib, they will be preserved.
// - Sx, Sy: the starting point of the floodfill
// - IncludeFunc: the callback function that will be used. It must return "True" for
//         pixels/colors that should be included.
// - SetMapFunc: the callback function used to set a point's byte value in the AMap
//         It can be used to store channel information from a points color
//         or can be used to create a varied mask value (for example, changing
//         value when close to a boundary or creating marching ant outlines)
// - Info: pointer to information that will be passed to the includefunc, can be nil
// - Throttle: integer used to limit the maximum depth of recursive calls before
//         the recursive processing takes a pause and resets
var
  AChk: TdtpByteMap;
  AWidth, AHeight: integer;
  RecursiveDepth: integer;
  ThrottleHold: TObjectStack;
  ThrottleHoldObj: TThrottleHoldObj;
  isBoundary: boolean;

// Note from: Chris Riley
// -----------------------------------------------------------------------------
// I have included a directional parameter in the recursive procedure for checking
// pixels.  The purpose for this is to further streamline the process of analyzing
// the pixels for matches.  Since we know that we don't need to check pixels that
// lie BEHIND, it makes since to use this parameter to determine the direction in
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
    isBoundary: boolean;
  begin
    isBoundary := false;
    Inc(RecursiveDepth);
    if RecursiveDepth > Throttle then
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
    if (dir <> cDown) and (y > 0) and (AChk[x, y-1] = cUnchecked) then
    begin
      if IncludeFunc(ADib[x, y-1], Info) then
      begin
        // Found an included pixel, so continue upwards
        AChk[x, y-1] := cIncluded;
        SpawnNextPixel(x, y-1, cUp);
      end
      else
      begin
        AChk[x, y-1] := cBoundary;
        isBoundary := true;
      end;
    end;
    //check left
    if (dir <> cRight) and (x > 0) and (AChk[x-1, y] = cUnchecked) then
    begin
      if IncludeFunc(ADib[x-1, y], Info) then
      begin
        // Found an included pixel, so continue left
        AChk[x-1, y] := cIncluded;
        SpawnNextPixel(x-1, y, cLeft);
      end
      else
      begin
        AChk[x-1, y] := cBoundary;
        isBoundary := true;
      end;
    end;
    //check right
    if (dir <> cLeft) and (x < AWidth-1) and (AChk[x+1, y] = cUnchecked) then
    begin
      if IncludeFunc(ADib[x+1, y], Info) then
      begin
        // Found an included pixel, so continue right
        AChk[x+1, y] := cIncluded;
        SpawnNextPixel(x+1, y, cRight);
      end
      else
      begin
        AChk[x+1, y] := cBoundary;
        isBoundary := true;
      end;
    end;
    //check down
    if (dir <> cUp) and (y < AHeight-1) and (AChk[x, y+1] = cUnchecked) then
    begin
      if IncludeFunc(ADib[x, y+1], Info) then
      begin
        // Found an included pixel, continue downwards
        AChk[x, y+1] := cIncluded;
        SpawnNextPixel(x, y+1, cDown);
      end
      else
      begin
        AChk[x, y+1] := cBoundary;
        isBoundary := true;
      end;
    end;

    AMap[x, y] := SetMapFunc(ADib[x, y], x, y, isBoundary);
  end;


// Main
begin
  // Checks
  if not assigned(ADib) then exit;
  if not assigned(AMap) then exit;
  if not assigned(IncludeFunc) then exit;
  if not assigned(SetMapFunc) then exit;

  //Create the ThrottleHold stack before we begin
  ThrottleHold := TObjectStack.Create;
  RecursiveDepth := 0;

  // This will preserve the map, unless the size is not the same as ADib
  AWidth  := ADib.Width;
  AHeight := ADib.Height;
  if AMap.SetSize(AWidth, AHeight) then
    AMap.Clear(0);
  if AMap.Empty then exit;

  isBoundary := false;

  // "Check" map: 0=Unchecked, 1=Included, 2=Boundary
  AChk := TdtpBytemap.Create;
  try
    AChk.SetSize(AWidth, AHeight);
    AChk.Clear(0);

    if IncludeFunc(ADib[Sx, Sy], Info) then
    begin
      // Found an included pixel, so continue upwards
      AChk[Sx, Sy] := cIncluded;
    end
    else
    begin
      // Note from: Chris Riley
      // Sx, Sy indicates a boundary and so we can't know which way to go
      // so better to just exit - unless there is a better approach?
      exit;
    end;
    //check up
    if (Sy > 0) then
    begin
      if IncludeFunc(ADib[Sx, Sy-1], Info) then
      begin
        // Found an included pixel, so continue upwards
        AChk[Sx, Sy-1] := cIncluded;
        SpawnNextPixel(Sx, Sy-1, cUp);
      end
      else
      begin
        AChk[Sx, Sy-1] := cBoundary;
        isBoundary := true;
      end;
    end;
    //check left
    if (Sx > 0) then
    begin
      if IncludeFunc(ADib[Sx-1, Sy], Info) then
      begin
        // Found an included pixel, so continue left
        AChk[Sx-1, Sy] := cIncluded;
        SpawnNextPixel(Sx-1, Sy, cLeft);
      end
      else
      begin
        AChk[Sx-1, Sy] := cBoundary;
        isBoundary := true;
      end;
    end;
    //check right
    if (Sx < AWidth) then
    begin
      if IncludeFunc(ADib[Sx+1, Sy], Info) then
      begin
        // Found an included pixel, so continue right
        AChk[Sx+1, Sy] := cIncluded;
        SpawnNextPixel(Sx+1, Sy, cRight);
      end
      else
      begin
        AChk[Sx+1, Sy] := cBoundary;
        isBoundary := true;
      end;
    end;
    //check down
    if (Sy < AHeight) then
    begin
      if IncludeFunc(ADib[Sx, Sy+1], Info) then
      begin
        // Found an included pixel, continue downwards
        AChk[Sx, Sy+1] := cIncluded;
        SpawnNextPixel(Sx, Sy+1, cDown);
      end
      else
      begin
        AChk[Sx, Sy+1] := cBoundary;
        isBoundary := true;
      end;

      AMap[Sx, Sy] := SetMapFunc(ADib[Sx, Sy], Sx, Sy, isBoundary);
    end;

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
