{ *********************************************************************** }
{                                                                         }
{ GraphicTypes                                                            }
{                                                                         }
{ Copyright (c) 2007 Pisarev Yuriy (post@pisarev.net)                     }
{                                                                         }
{ *********************************************************************** }

unit GraphicTypes;

{$B-}

interface

uses
  Types;

type
  PExactPoint = ^TExactPoint;
  TExactPoint = record
    X, Y: Extended;
  end;

  TExactPointDynArray = array of TExactPoint;
  TPointDynArray = array of TPoint;

  TChannelType = (ctBlue, ctGreen, ctRed);
  TPixel = array[TChannelType] of Byte;
  PPixel = ^TPixel;
  THeavyPixel = array[TChannelType] of Integer;

implementation

end.
