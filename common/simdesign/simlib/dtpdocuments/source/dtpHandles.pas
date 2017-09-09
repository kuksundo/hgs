{
  Unit dtpHandles

  dtpHandles is the default drawing mechanism for handles and draglines.

  Project: DTP-Engine

  Creation Date: 14-11-2004 (NH)

  Modifications:

  Copyright (c) 2004 By Nils Haeck M.Sc. - SimDesign
  More information: www.simdesign.nl or n.haeck@simdesign.nl

  This source code may NOT be used or replicated without prior permission
  from the abovementioned author.

}
unit dtpHandles;

{$i simdesign.inc}

interface

uses
  Types, Windows, Graphics, Classes, Contnrs, SysUtils, dtpGraphics, dtpDefaults;

type

  // The THitTestInfo type is used to determine where and on what part of the
  // handles the user clicked with the mouse.
  THitTestInfo = (
    htNone,    // No hittest found
    htShape,   // Directly on shape
    htLT,      // On Left-Top handle
    htLeft,    // On Left handle
    htLB,      // On Left-Bottom handle
    htBottom,  // On Bottom handle
    htRB,      // On Right-Bottom handle
    htRight,   // On Right handle
    htRT,      // On Right-Top handle
    htTop,     // On Top handle
    htRotate,  // On Rotate handle (if any)
    htPoint,   // On line segment start/endpoint
    htCustom1, // On a custom defined area
    htCustom2, // On a custom defined area
    htCustom3, // On a custom defined area
    htCustom4  // On a custom defined area
  );

  // This class holds information about the handle that is drawn when the shape is
  // selected
  TdtpHandle = class
  public
    HitTest: THitTestInfo; // The hittest function for this handle
    Pos: TdtpPoint;      // coordinates (in Shape units) of this handle
    Drag: TdtpPoint;     // coordinates (in Shape units) during dragging ops
  end;

  // This class holds information about the lines inbetween the drawn handles
  TdtpDragLine = class
  public
    H1: integer;             // Handle index of handle 1
    H2: integer;             // Handle index of handle 2
    HitTest: THitTestInfo;   // Hittest info for this drag line
    DrawWhenSelect: boolean; // Draw this dragline when selecting
    DrawWhenDrag: boolean;   // Draw this dragline when dragging
    constructor Create; virtual;
  end;

  TdtpHandlePainter = class(TPersistent)
  private
    FDragLines: TObjectList;
    FHandles: TObjectList;
    FShape: TObject;
    function GetDocument: TObject;
    function GetHandleCount: integer;
    function GetHandles(Index: integer): TdtpHandle;
    function GetDragLineCount: integer;
    function GetDragLines(Index: integer): TdtpDragLine;
    procedure SetDragLineCount(const Value: integer);
    procedure SetHandleCount(const Value: integer);
  protected
    function GetHandleColor: TColor; virtual;
    function GetHandleEdgeColor: TColor; virtual;
    function GetHandleSize(Index: integer): integer; virtual;
    procedure PaintBorderLines(Canvas: TCanvas); virtual;
  public
    constructor Create; virtual;
    destructor Destroy; override;
    procedure CreateBlockHandles; virtual;
    function GetHandleRect(Index: integer): TRect;
    procedure PaintDragBorder(Canvas: TCanvas); virtual;
    procedure PaintHandle(Canvas: TCanvas; Index: integer); virtual;
    procedure PaintSelectionBorder(Canvas: TCanvas); virtual;
    // The DragLines array points to a collection of TDraglineType records that define
    // the lines that are drawn when the shape is dragged or selected.
    property DragLines[Index: integer]: TdtpDragLine read GetDragLines;
    // DraglineCount specifies the number of lines that are drawn when the shape is
    // dragged or selected. See also Draglines.
    property DragLineCount: integer read GetDragLineCount write SetDragLineCount;
    // The Handles array points to a collection of THandleType records that define
    // the handles (small grippers) that are drawn when the shape is selected.
    property Handles[Index: integer]: TdtpHandle read GetHandles; default;
    // HandleCount specifies the number of handles that are drawn when the shape
    // is selected. See also Handles.
    property HandleCount: integer read GetHandleCount write SetHandleCount;
    property Shape: TObject read FShape write FShape;
  end;

resourcestring
  shpShapeMustBeAssigned = 'Shape object must be assigned';

implementation

uses
  dtpShape, dtpDocument;

{ TdtpHandlePainter }

constructor TdtpHandlePainter.Create;
begin
  inherited Create;
  FDragLines := TObjectList.Create;
  FHandles := TObjectList.Create;
end;

procedure TdtpHandlePainter.CreateBlockHandles;
begin
  if not assigned(Shape) then
    raise Exception.Create(shpShapeMustBeAssigned);

  // By default we create 4 handles on the corners
  with TdtpShape(Shape) do begin
    HandleCount := 4;

    // The dragging handles
    Handles[0].Pos.X := 0;
    Handles[0].Pos.Y := 0;
    Handles[0].HitTest := htLT;
    Handles[1].Pos.X := 0;
    Handles[1].Pos.Y := DocHeight;
    Handles[1].HitTest := htLB;
    Handles[2].Pos.X := DocWidth;
    Handles[2].Pos.Y := DocHeight;
    Handles[2].HitTest := htRB;
    Handles[3].Pos.X := DocWidth;
    Handles[3].Pos.Y := 0;
    Handles[3].HitTest := htRT;

    if AllowRotate then begin
      HandleCount := HandleCount + 1;
      // This is the rotation handle
      Handles[HandleCount - 1].Pos.X  := DocWidth  * 1.03;
      Handles[HandleCount - 1].Pos.Y  := DocHeight / 2;
      Handles[HandleCount - 1].HitTest := htRotate;
    end;

    // We have 4 drag lines, the rectangle surrounding the shape
    DraglineCount := 4;

    // The Drag lines connect always between two handles, H1 and H2. The value
    // provided is the index into the above handle array. The hittest information
    // is used when the user clicks the drag line.
    Draglines[0].H1 := 0; Draglines[0].H2 := 1;
    Draglines[0].HitTest := htLeft;
    Draglines[1].H1 := 1; Draglines[1].H2 := 2;
    Draglines[1].HitTest := htBottom;
    Draglines[2].H1 := 2; Draglines[2].H2 := 3;
    Draglines[2].HitTest := htRight;
    Draglines[3].H1 := 3; Draglines[3].H2 := 0;
    Draglines[3].HitTest := htTop;
  end;
end;

destructor TdtpHandlePainter.Destroy;
begin
  FreeAndNil(FHandles);
  FreeAndNil(FDragLines);
  inherited;
end;

function TdtpHandlePainter.GetDocument: TObject;
begin
  Result := nil;
  if assigned(Shape) then
    Result := TdtpShape(Shape).Document;
end;

function TdtpHandlePainter.GetDragLineCount: integer;
begin
  Result := FDragLines.Count;
end;

function TdtpHandlePainter.GetDragLines(Index: integer): TdtpDragLine;
begin
  if (Index >= 0) and (Index < DragLineCount) then
    Result := TdtpDragLine(FDragLines[Index])
  else
    Result := nil;
end;

function TdtpHandlePainter.GetHandleColor: TColor;
var
  ADocument: TdtpDocument;
begin
  ADocument := TdtpDocument(GetDocument);
  if assigned(ADocument) then
    Result := ADocument.HandleColor
  else
    Result := clBlack;
end;

function TdtpHandlePainter.GetHandleCount: integer;
begin
  Result := FHandles.Count;
end;

function TdtpHandlePainter.GetHandleEdgeColor: TColor;
var
  ADocument: TdtpDocument;
begin
  ADocument := TdtpDocument(GetDocument);
  if assigned(ADocument) then
    Result := ADocument.HandleEdgeColor
  else
    Result := clBlack;
end;

function TdtpHandlePainter.GetHandleRect(Index: integer): TRect;
var
  P: TdtpPoint;
  Size: integer;
begin
  if not assigned(Shape) then
    raise Exception.Create(shpShapeMustBeAssigned);
  P := TdtpShape(Shape).ShapeToScreen(Handles[Index].Pos);
  Size := GetHandleSize(Index);
  Result := Rect(
      Round(P.X - Size)    , Round(P.Y - Size),
      Round(P.X + Size + 1), Round(P.Y + Size + 1));
end;

function TdtpHandlePainter.GetHandles(Index: integer): TdtpHandle;
begin
  if (Index >= 0) and (Index < HandleCount) then
    Result := TdtpHandle(FHandles[Index])
  else
    Result := nil;
end;

function TdtpHandlePainter.GetHandleSize(Index: integer): integer;
begin
  Result := cDefaultHandleSize;
end;

procedure TdtpHandlePainter.PaintBorderLines(Canvas: TCanvas);
var
  i: integer;
  P: TdtpPoint;
begin
  with Canvas do
    for i := 0 to DraglineCount - 1 do with Draglines[i] do
      if DrawWhenSelect then begin
        P := TdtpShape(Shape).ShapeToScreen(Handles[H1].Pos);
        MoveTo(round(P.X), round(P.Y));
        P := TdtpShape(Shape).ShapeToScreen(Handles[H2].Pos);
        LineTo(round(P.X), round(P.Y));
      end;
end;

procedure TdtpHandlePainter.PaintDragBorder(Canvas: TCanvas);
// Default action is to draw a rubberband
var
  i: integer;
  P: TPoint;
begin
  if DraglineCount = 0 then exit;
  if not assigned(Shape) then
    raise Exception.Create(shpShapeMustBeAssigned);

  with Canvas do begin
    Pen.Color := GetHandleEdgeColor;
    Pen.Style := psDot;
    Pen.Mode  := pmXOR;
    Pen.Width := 1;
    for i := 0 to DraglineCount - 1 do with Draglines[i] do
      if DrawWhenDrag then begin
        P := Point(TdtpShape(Shape).ShapeToScreen(Handles[H1].Drag));
        MoveTo(P.X, P.Y);
        P := Point(TdtpShape(Shape).ShapeToScreen(Handles[H2].Drag));
        LineTo(P.X, P.Y);
      end;
  end;

end;

procedure TdtpHandlePainter.PaintHandle(Canvas: TCanvas; Index: integer);
// This procedure paints a default handle (small rectangle) onto the canvas.
// It uses the default color given by GetHandleColor
begin
  if not assigned(Shape) then
    raise Exception.Create(shpShapeMustBeAssigned);

  with Canvas do begin
    Pen.Color := GetHandleEdgeColor;
    Pen.Style := psSolid;
    Brush.Color := GetHandleColor;
    Brush.Style := bsSolid;
    case Handles[Index].HitTest of
    htRotate:
      begin
        if TdtpShape(Shape).AllowRotate then
          Ellipse(GetHandleRect(Index));
      end;
    else
      if TdtpShape(Shape).AllowResize then
        Rectangle(GetHandleRect(Index));
    end;
  end;
end;

procedure TdtpHandlePainter.PaintSelectionBorder(Canvas: TCanvas);
// Default will draw a white 3 pixel band with a stippled 1 pixel interior,
// followed by a set of standard handles on the locations obtained by CreateHandles.
var
  i: integer;
begin
  if not assigned(Shape) then
    raise Exception.Create(shpShapeMustBeAssigned);

  // 3pixx Band
  with Canvas do begin
    Pen.Color := clWhite;
    Pen.Style := psSolid;
    Pen.Mode  := pmCopy;
    Pen.Width := 3;
    Brush.Style := bsClear;
    PaintBorderLines(Canvas);
    Pen.Color := GetHandleEdgeColor;
    Pen.Style := psDot;
    Pen.Mode  := pmCopy;
    Pen.Width := 1;
    PaintBorderLines(Canvas);
  end;

  // Handles
  for i := 0 to HandleCount - 1 do
    PaintHandle(Canvas, i);
end;

procedure TdtpHandlePainter.SetDragLineCount(const Value: integer);
begin
  while DragLineCount < Value do
    FDragLines.Add(TdtpDragLine.Create);
  while DragLineCount > Value do
    FDragLines.Delete(DragLineCount - 1);
end;

procedure TdtpHandlePainter.SetHandleCount(const Value: integer);
begin
  while HandleCount < Value do
    FHandles.Add(TdtpHandle.Create);
  while HandleCount > Value do
    FHandles.Delete(HandleCount - 1);
end;

{ TdtpDragLine }

constructor TdtpDragLine.Create;
begin
  inherited Create;
  DrawWhenDrag := True;
  DrawWhenSelect := True;
end;

end.
