{
  Unit dtpBorders

  dtpBorders is the default drawing mechanism for Corners and Borders.

  Project: DTP-Engine

  Creation Date: 03-06-2010
  Author: JF

  Modifications:

  Copyright (c) 2004 - 2010 By Nils Haeck M.Sc. - SimDesign
  More information: www.simdesign.nl or n.haeck@simdesign.nl

  This source code may NOT be used or replicated without prior permission
  from the abovementioned author.

}
unit dtpBorders;

{$i simdesign.inc}

interface

uses
  Types, Windows, Graphics, Classes, Contnrs, SysUtils, dtpGraphics, dtpDefaults;

type


  // This class holds information about the Corner position when the  text shape is
  // being edited
  TdtpCorner = class
  public
    Pos: TdtpPoint;  // coordinates (in Shape units) of this Corner
  end;

  // This class holds information about the lines inbetween the Corners
  TdtpBorder = class
  public
    C1: integer;   // Corner index of Corner 1
    C2: integer;   // Corner index of Corner 2
  end;

  // TdtpBorderPainter is a Helper class to paint borders of a shape
  TdtpBorderPainter = class(TPersistent)
  private
    FBorders: TObjectList;
    FCorners: TObjectList;
    FShape: TObject;
    function GetDocument: TObject;
    function GetCornerCount: integer;
    function GetCorners(Index: integer): TdtpCorner;
    function GetBorderCount: integer;
    function GetBorders(Index: integer): TdtpBorder;
    procedure SetBorderCount(const Value: integer);
    procedure SetCornerCount(const Value: integer);
  protected
    function GetBorderColor: TColor; virtual;
  public
    constructor Create; virtual;
    destructor Destroy; override;
    procedure CreateCorners; virtual;
    procedure PaintBorder(Canvas: TCanvas); virtual;
    property Borders[Index: integer]: TdtpBorder read GetBorders;
    // BorderCount specifies the number of lines that are drawn when the  text shape is
    // is being edited. See also Borders.
    property BorderCount: integer read GetBorderCount write SetBorderCount;
    // The Corners array points to a collection of TdtpCorner records.
    property Corners[Index: integer]: TdtpCorner read GetCorners; default;
    // CornerCount specifies the number of Corners. See also Corners.
    property CornerCount: integer read GetCornerCount write SetCornerCount;
    property Shape: TObject read FShape write FShape;
  end;

resourcestring
  shpTextShapeMustBeAssigned = 'TextShape object must be assigned';

implementation

uses
  dtpShape, dtpDocument;

{ TdtpBorderPainter }

constructor TdtpBorderPainter.Create;
begin
  inherited Create;
  FBorders := TObjectList.Create;
  FCorners := TObjectList.Create;
end;

procedure TdtpBorderPainter.CreateCorners;
var
  ADocHeight: single;
  ADocWidth: single;
begin
  if not assigned(Shape) then
    raise Exception.Create(shpTextShapeMustBeAssigned);

  // Create 4 Corners
  ADocHeight:= TdtpShape(Shape).DocHeight + 1;
  ADocWidth:= TdtpShape(Shape).DocWidth + 1;

  CornerCount := 4;

  // The Corners
  Corners[0].Pos.X := -1;
  Corners[0].Pos.Y := -1;
  Corners[1].Pos.X := -1;
  Corners[1].Pos.Y := ADocHeight;
  Corners[2].Pos.X := ADocWidth;
  Corners[2].Pos.Y := ADocHeight;
  Corners[3].Pos.X := ADocWidth;
  Corners[3].Pos.Y := -1;

  // We have 4 Borders, the rectangle surrounding the shape
  BorderCount := 4;

  // The Borders connect always between two Corners, C1 and C. The value
  // provided is the index into the above Corners array.
  Borders[0].C1 := 0; Borders[0].C2 := 1;
  Borders[1].C1 := 1; Borders[1].C2 := 2;
  Borders[2].C1 := 2; Borders[2].C2 := 3;
  Borders[3].C1 := 3; Borders[3].C2 := 0;
end;

destructor TdtpBorderPainter.Destroy;
begin
  FreeAndNil(FCorners);
  FreeAndNil(FBorders);
  inherited;
end;

function TdtpBorderPainter.GetDocument: TObject;
begin
  Result := nil;
  if assigned(Shape) then
    Result := TdtpShape(Shape).Document;
end;

function TdtpBorderPainter.GetBorderCount: integer;
begin
  Result := FBorders.Count;
end;

function TdtpBorderPainter.GetBorders(Index: integer): TdtpBorder;
begin
  if (Index >= 0) and (Index < BorderCount) then
    Result := TdtpBorder(FBorders[Index])
  else
    Result := nil;
end;

function TdtpBorderPainter.GetCornerCount: integer;
begin
  Result := FCorners.Count;
end;

function TdtpBorderPainter.GetBorderColor: TColor;
var
  ADocument: TdtpDocument;
begin
  ADocument := TdtpDocument(GetDocument);
  if assigned(ADocument) then
    Result := ADocument.HandleEdgeColor
  else
    Result := clBlack;
end;

function TdtpBorderPainter.GetCorners(Index: integer): TdtpCorner;
begin
  if (Index >= 0) and (Index < CornerCount) then
    Result := TdtpCorner(FCorners[Index])
  else
    Result := nil;
end;

procedure TdtpBorderPainter.PaintBorder(Canvas: TCanvas);

var
  i: integer;
  P: TPoint;
begin
  if BorderCount = 0 then
    exit;
  if not assigned(Shape) then
    raise Exception.Create(shpTextShapeMustBeAssigned);

  with Canvas do
  begin
    Pen.Color := GetBorderColor;
    Pen.Style := psDot;
    Pen.Mode  := pmCopy;
    Pen.Width := 1;
    for i := 0 to BorderCount - 1 do
    with Borders[i] do
      begin
        P := Point(TdtpShape(Shape).ShapeToScreen(Corners[C1].Pos));
        MoveTo(P.X, P.Y);
        P := Point(TdtpShape(Shape).ShapeToScreen(Corners[C2].Pos));
        LineTo(P.X, P.Y);
      end;
  end;

end;

procedure TdtpBorderPainter.SetBorderCount(const Value: integer);
begin
  while BorderCount < Value do
    FBorders.Add(TdtpBorder.Create);
  while BorderCount > Value do
    FBorders.Delete(BorderCount - 1);
end;

procedure TdtpBorderPainter.SetCornerCount(const Value: integer);
begin
  while CornerCount < Value do
    FCorners.Add(TdtpCorner.Create);
  while CornerCount > Value do
    FCorners.Delete(CornerCount - 1);
end;

end.
