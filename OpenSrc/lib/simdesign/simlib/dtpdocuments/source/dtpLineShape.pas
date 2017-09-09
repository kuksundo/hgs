{
  Unit dtpLineShape

  TdtpLineShape is a TdtpEffectShape descendant that can be used to draw a
  line segment with arrow heads.

  Project: DTP-Engine

  Creation Date: 10-11-2003 (NH)
  Version: 1.0

  Modifications:

  Copyright (c) 2003 By Nils Haeck M.Sc. - SimDesign BV
  More information: www.simdesign.nl or n.haeck@simdesign.nl

  This source code may NOT be used or replicated without prior permission
  from the abovementioned author.

}
unit dtpLineShape;

{$i simdesign.inc}

interface

uses
  Classes, SysUtils, Graphics, Windows, dtpShape, dtpDefaults, dtpGraphics, Math,
  dtpPolygonShape, NativeXmlOld, Controls, dtpHandles;

type

  TdtpArrowStyle = (
    asNoArrow,         // No arrow
    asArrow,           // Standard arrow with square backside
    asOpenArrow,       // Open arrow, V-shaped
    asStealthArrow,    // Open arrow rounded towards inside
    asDiamondArrow,    // Diamond instead of arrow
    asOvalArrow,       // Oval instead of arrow
    asRectangleArrow   // Rectangle instead of arrow (added by EL)
  );

const

  cArrowStyleCount = 7; // changed by EL
  cArrowStyleNames: array[0..cArrowStyleCount - 1] of string =
  ('NoArrow', 'Arrow', 'OpenArrow', 'StealthArrow', 'Diamond', 'Oval', 'Rectangle');

type

  TdtpLineShape = class;

  // TdtpArrow defines the kind of line ending that is chosen for both line ends in a
  // TdtpLineShape. It specifies arrow style and sizes.
  TdtpArrow = class(TPersistent)
  private
    FStyle: TdtpArrowStyle;
    FWidth: single;
    FLength: single;
    FParent: TdtpLineShape;
    procedure SetStyle(const Value: TdtpArrowStyle);
    procedure SetLength(const Value: single);
    procedure SetWidth(const Value: single);
  protected
    property Parent: TdtpLineShape read FParent write FParent;
    procedure DrawArrow(const Target, From: TdtpPoint;
      var Start, Close: TdtpPoint);
  public
    constructor Create(AParent: TdtpLineShape); virtual;
    procedure LoadFromXml(ANode: TXmlNodeOld); virtual;
    procedure SaveToXml(ANode: TXmlNodeOld); virtual;
    property Style: TdtpArrowStyle read FStyle write SetStyle;
    property Width: single read FWidth write SetWidth;
    property Length: single read FLength write SetLength;
  end;

  // This shape is used to draw line segments, with straight ending or with arrow-heads.
  TdtpLineShape = class(TdtpPolygonShape)
  private
    FArrows: array[0..1] of TdtpArrow;
    FPoints: array of TdtpPoint; // FPoints here are fractions! (0 = left/top, 1=right/bottom)
    FLineWidth: single;
    procedure AdjustBounds;
    function GetArrows(Index: integer): TdtpArrow;
    procedure SetLineWidth(const Value: single);
    function GetPoints(Index: integer): TdtpPoint;
    procedure SetPoints(Index: integer; const Value: TdtpPoint);
  protected
    procedure CreateHandles; override;
    function GetPointCount: integer; virtual;
    procedure GeneratePoints; override;
    procedure PaintInsertBorder(Canvas: TCanvas; Rect: TRect; Color: TColor); override;
    procedure SetDocAngle(const Value: single); override;
  public
    constructor Create; override;
    destructor Destroy; override;
    procedure AcceptDragBorder; override;
    procedure AcceptInsertBorder(Rect: TdtpRect); override;
    procedure PointAdd(APoint: TdtpPoint);
    procedure LoadFromXml(ANode: TXmlNodeOld); override;
    procedure SaveToXml(ANode: TXmlNodeOld); override;
    property Arrows[Index: integer]: TdtpArrow read GetArrows;
    property LineWidth: single read FLineWidth write SetLineWidth;
    property Points[Index: integer]: TdtpPoint read GetPoints write SetPoints;
    property PointCount: integer read GetPointCount;
  end;

implementation

uses
  dtpDocument;

{ TdtpLineShape }

procedure TdtpLineShape.AcceptDragBorder;
// A point was dragged
begin
  if DragHandle >= 0 then
  begin
    Points[DragHandle] := dtpPoint(
      Handles[DragHandle].Drag.X + DocLeft,
      Handles[DragHandle].Drag.Y + DocTop);
  end else
    inherited;
end;

procedure TdtpLineShape.AcceptInsertBorder(Rect: TdtpRect);
// We must use the knowledge of Rect.Right < Rect.Left and Rect.Bottom < Rect.Top
// here, so we make sure that the lines are conform the way we create the dragged
// insert
begin
  if Rect.Right < Rect.Left then
  begin
    FPoints[0].X := 1;
    FPoints[1].X := 0;
  end;
  if Rect.Bottom < Rect.Top then
  begin
    FPoints[0].Y := 1;
    FPoints[1].Y := 0;
  end;
  inherited;
end;

procedure TdtpLineShape.AdjustBounds;
// Adjust the bounds so they fit around the points
var
  i: integer;
  B: TdtpRect;
  APoint: TdtpPoint;
begin
  // Find the bounding box around the points
  FillChar(B, SizeOf(B), 0);
  for i := 0 to PointCount - 1 do
  begin
    APoint := Points[i];
    if (i = 0) then
    begin
      B.Left   := APoint.X;
      B.Right  := APoint.X;
      B.Top    := APoint.Y;
      B.Bottom := APoint.Y;
    end else
    begin
      B.Left   := Min(B.Left  , APoint.X);
      B.Right  := Max(B.Right , APoint.X);
      B.Top    := Min(B.Top   , APoint.Y);
      B.Bottom := Max(B.Bottom, APoint.Y);
    end;
  end;
  // Make sure not to get smaller than a min size
  if (B.Right - B.Left) = 0 then
    B.Right := B.Left + 1;
  if (B.Bottom - B.Top) = 0 then
    B.Bottom := B.Top + 1;
  // Adjust points
  for i := 0 to PointCount - 1 do
  begin
    APoint := Points[i];
    if (B.Right - B.Left) > 0 then
      FPoints[i].X := (APoint.X - B.Left) / (B.Right - B.Left)
    else
      FPoints[i].X := 0;
    if (B.Bottom - B.Top) > 0 then
      FPoints[i].Y := (APoint.Y - B.Top) / (B.Bottom - B.Top)
    else
      FPoints[i].Y := 0;
  end;
  // Set the new bounds
  SetDocBounds(B.Left, B.Top, B.Right - B.Left, B.Bottom - B.Top);
end;

constructor TdtpLineShape.Create;
var
  i: integer;
begin
  inherited;
  // Create arrows
  for i := 0 to 1 do
    FArrows[i] := TdtpArrow.Create(Self);
  // Points
  SetLength(FPoints, 2);
  FPoints[0]   := dtpPoint(0, 0);
  FPoints[1]   := dtpPoint(1, 1);
  // Overrides
  FillColor    := cDefaultPolygonOutlineColor;
  IsClosed     := True;
  FStorePoints := False;
  UseOutline   := False;
  UseFill      := True;
  // New defaults
  FLineWidth   := cDefaultLineWidth;
  InsertCursor := crDtpCrossLine;
end;

procedure TdtpLineShape.CreateHandles;
var
  i: integer;
begin
  CreateHandleObject;
  // Create the points for the handles
  Handles.HandleCount := PointCount;
  Handles.DraglineCount := Max(0, PointCount - 1);

  // The dragging handles
  for i := 0 to PointCount - 1 do
  begin
    Handles[i].Pos.X := Points[i].X - DocLeft;
    Handles[i].Pos.Y := Points[i].Y - DocTop;
    Handles[i].HitTest := htPoint;
    // Flip/mirror
    if Flipped then
      Handles[i].Pos.X := DocWidth - Handles[i].Pos.X;
    if Mirrored then
      Handles[i].Pos.Y := DocHeight - Handles[i].Pos.Y;
  end;

  // The drag line
  for i := 0 to PointCount - 2 do
  begin
    Handles.Draglines[i].H1 := i; Handles.DragLines[i].H2 := i + 1;
    Handles.Draglines[i].HitTest := htShape;
  end;
end;

destructor TdtpLineShape.Destroy;
var
  i: integer;
begin
  for i := 0 to 1 do
    FreeAndNil(FArrows[i]);
  FPoints := nil;
  inherited;
end;

procedure TdtpLineShape.GeneratePoints;
// Create the polygon that represents this line
var
  P1, P2: TdtpPoint;
begin
  // check if points are different
  if (Points[0].X = Points[1].X) and (Points[0].Y = Points[1].Y) then
    exit;
  // Clear old polygon
  ClearPolygon;
  // Draw arrow 1
  Arrows[0].DrawArrow(Points[0], Points[1], P1, P2);
  // Draw arrow 2
  Arrows[1].DrawArrow(Points[1], Points[0], P1, P2);

  // Adjust the points, since now they're absolute and they must be relative
  Offset(-DocLeft, -DocTop);
end;

function TdtpLineShape.GetArrows(Index: integer): TdtpArrow;
begin
  Result := nil;
  if (Index >= 0) and (Index < 2) then
    Result := FArrows[Index];
end;

function TdtpLineShape.GetPointCount: integer;
begin
  Result := Length(FPoints);
end;

function TdtpLineShape.GetPoints(Index: integer): TdtpPoint;
// Return the point in document cooordinates. Note: we assume that DocAngle = 0,
// Which it should be (See SetDocAngle)
begin
  Result := dtpPoint(0, 0);
  if (Index >= 0) and (Index < PointCount) then
  begin
    Result.X := DocLeft + FPoints[Index].X * DocWidth;
    Result.Y := DocTop  + FPoints[Index].Y * DocHeight;
  end;
end;

procedure TdtpLineShape.LoadFromXml(ANode: TXmlNodeOld);
var
  i: integer;
  AChild: TXmlNodeOld;
  AList: TList;
  APoint: TdtpPoint;
begin
  // do this last, so we will call Generated after loading the props
  inherited;
  AChild := ANode.NodeByName('Arrow0');
  if assigned(AChild) then
    Arrows[0].LoadFromXml(AChild);
  AChild := ANode.NodeByName('Arrow1');
  if assigned(AChild) then
    Arrows[1].LoadFromXml(AChild);
  AChild := ANode.NodeByName('Points');
  SetLength(FPoints, 0);
  if assigned(AChild) then
  begin
    AList := TList.Create;
    try
      AChild.NodesByName('Point', AList);
      for i := 0 to AList.Count - 1 do
      begin
        APoint.X := TXmlNodeOld(AList[i]).ReadFloat('X');
        APoint.Y := TXmlNodeOld(AList[i]).ReadFloat('Y');
        PointAdd(APoint);
      end;
    finally
      AList.Free;
    end;
  end;
  FLineWidth := ANode.ReadFloat('LineWidth');
end;

procedure TdtpLineShape.PaintInsertBorder(Canvas: TCanvas; Rect: TRect;
  Color: TColor);
// We will draw a line from Rect's LeftTop to Rightbottom instead of the standard
// rectangle
begin
  // Draw rectangle
  Canvas.Pen.Color := Color;
  Canvas.Pen.Style := psDot;
  Canvas.Pen.Mode  := pmXOR;
  Canvas.Brush.Style := bsClear;
  Canvas.MoveTo(Rect.Left, Rect.Top);
  Canvas.LineTo(Rect.Right, Rect.Bottom);
end;

procedure TdtpLineShape.PointAdd(APoint: TdtpPoint);
begin
  SetLength(FPoints, length(FPoints) + 1);
  Points[Length(FPoints) - 1] := APoint;
end;

procedure TdtpLineShape.SaveToXml(ANode: TXmlNodeOld);
var
  i: integer;
begin
  Arrows[0].SaveToXml(ANode.NodeNew('Arrow0'));
  Arrows[1].SaveToXml(ANode.NodeNew('Arrow1'));
  with ANode.NodeNew('Points') do
    for i := 0 to PointCount - 1 do
      with NodeNew('Point') do
      begin
        WriteFloat('X', Points[i].X);
        WriteFloat('Y', Points[i].Y);
      end;
  ANode.WriteFloat('LineWidth', FLineWidth);
  inherited;
end;

procedure TdtpLineShape.SetDocAngle(const Value: single);
// We must override this method in order to set the angle back to 0. Rotation should
// be done using the points directly, otherwise the bounding box theory does not
// work.
var
  i: integer;
  CosA, SinA: single;
  // local
  function Rotate(const APoint: TdtpPoint): TdtpPoint;
  begin
    // Rotate, which means around DocLeft/DocTop so we must use the relative
    // FPoints[i].X * DocWidth and FPoints[i].Y * DocHeight
    Result.X := ( CosA * APoint.X * DocWidth + SinA * APoint.Y * DocHeight) / DocWidth;
    Result.Y := (-SinA * APoint.X * DocWidth + CosA * APoint.Y * DocHeight) / DocHeight;
  end;
// main
begin
  // We do NOT allow a rotation for line shapes but we will rotate the points manually
  CosA := cos(Value * cDegToRad); SinA := Sin(Value * cDegToRad);
  for i := 0 to PointCount - 1 do
    FPoints[i] := Rotate(FPoints[i]);
  // Recalculate
  AdjustBounds;
end;

procedure TdtpLineShape.SetLineWidth(const Value: single);
begin
  if FLineWidth <> Value then
  begin
    FLineWidth := Value;
    Regenerate;
    Changed;
  end;
end;

procedure TdtpLineShape.SetPoints(Index: integer; const Value: TdtpPoint);
begin
  if (Index >= 0) and (Index < 2) then
  begin
    if DocWidth > 0 then
      FPoints[Index].X := (Value.X - DocLeft) / DocWidth
    else
      // This should not happen
      FPoints[Index].X := 0;
    if DocHeight > 0 then
      FPoints[Index].Y := (Value.Y - DocTop) / DocHeight
    else
      // This should not happen
      FPoints[Index].Y := 0;
    AdjustBounds;
    Regenerate;
    Changed;
  end;
end;

{ TdtpArrow }

constructor TdtpArrow.Create(AParent: TdtpLineShape);
begin
  inherited Create;
  FParent := AParent;
  FStyle  := asNoArrow;
  FWidth  := cDefaultArrowWidth;
  FLength := cDefaultArrowLength;
end;

procedure TdtpArrow.DrawArrow(const Target, From: TdtpPoint; var Start, Close: TdtpPoint);
// We will return the arrow connect points, esp. Close is important for the
// caller, and draw the arrow with the polyline of the parent.
var
  i, ADiv: integer;
  ADelta, ABase, APerp, S, W, P: TdtpPoint;
  L, ALength, LdivW, Wdiv2, C, H: single;
  AStyle: TdtpArrowStyle;
  Quads: ArrayOfFPoint;
  // local
  function LowerThanLine(const ABase, ADir, ATest: TdtpPoint): single;
  begin
    Result := ADir.Y * (ATest.X - ABase.X) - ADir.X * (ATest.Y - ABase.Y);
  end;
// main
begin
  if not assigned(Parent) then exit;
  ALength := 0; // avoid compiler warning
  ADelta.X := Target.X - From.X;
  ADelta.Y := Target.Y - From.Y;
  L := Hypot(ADelta.X, ADelta.Y);
  if L = 0 then exit;
  ADelta.X := ADelta.X / L;
  ADelta.Y := ADelta.Y / L;
  // Vector in perp direction
  APerp.X := - ADelta.Y;
  APerp.Y :=   ADelta.X;
  // Half linewidth vector
  S.X := APerp.X * Parent.LineWidth * 0.5;
  S.Y := APerp.Y * Parent.LineWidth * 0.5;
  AStyle := Style;
  if Width <= Parent.LineWidth then
    AStyle := asNoArrow;
  // Calculate Start and Close
  if AStyle = asNoArrow then
  begin
    ABase.X := Target.X;
    ABase.Y := Target.Y;
  end else
  begin
    // We limit ALength here, to avoid the line being shorter than the arrow.
    // This is an arbitrary value (70%) but seems reasonable. A more scientific
    // approach would be to look at both arrows and deduct if they are about to
    // touch backs
    ALength := Min(Length, 0.7 * L);
    // Base arrow point
    ABase.X := Target.X - ADelta.X * ALength;
    ABase.Y := Target.Y - ADelta.Y * ALength;
  end;
  Start.X := ABase.X - S.X;
  Start.Y := ABase.Y - S.Y;
  Close.X := ABase.X + S.X;
  Close.Y := ABase.Y + S.Y;
  // Half arrow width
  W.X := APerp.X * Width * 0.5;
  W.Y := APerp.Y * Width * 0.5;
  // What kind of arrow?
  with Parent do
    case AStyle of
    asNoArrow:
      begin
        Add(Start);
        Add(Close);
      end;
    asArrow: // A normal, simple arrow
      begin
        Add(Start);
        Add(ABase.X - W.X, ABase.Y - W.Y);
        Add(Target);
        Add(ABase.X + W.X, ABase.Y + W.Y);
        Add(Close);
      end;
    asOpenArrow: // Open arrow, V-shape
      begin
        // Length divided by Width
        LdivW := ALength / Width * 2;
        // Length from base to inner intersection
        C := Max(ALength - (LineWidth * (0.5 * LdivW + sqrt(sqr(LdivW) + 1))), 0);
        Add(Start);
        if C > 0 then
        begin
          P.X := Start.X + ADelta.X * C;
          P.Y := Start.Y + ADelta.Y * C;
          Add(P);
          P.X := Start.X - APerp.X * C / LdivW;
          P.Y := Start.Y - APerp.Y * C / LdivW;
          Add(P);
        end;
        Add(ABase.X - W.X, ABase.Y - W.Y);
        Add(Target);
        Add(ABase.X + W.X, ABase.Y + W.Y);
        if C > 0 then
        begin
          P.X := Close.X + APerp.X * C / LdivW;
          P.Y := Close.Y + APerp.Y * C / LdivW;
          Add(P);
          P.X := Close.X + ADelta.X * C;
          P.Y := Close.Y + ADelta.Y * C;
          Add(P);
        end;
        Add(Close);
      end;
    asStealthArrow: // Open arrow, rounded inwards
      begin
        // Length divided by Width
        LdivW := ALength / Width * 2;
        // Length from base to inner intersection
        C := Max(ALength - (LineWidth * (0.5 * LdivW + sqrt(sqr(LdivW) + 1))), 0);
        H := 0;
        Add(Start);
        if C > 0 then
        begin
          // Get quadrant points
          // H := 0.5 * (Width - LineWidth) - C / LdivW; // for a perfect match
          H := 0.5 * Width - 0.75 * LineWidth - C / LdivW; // A 1/2 linewidth left on pointers
          QuadrantPoints(C * GetScale, Quads, ADiv);
          for i := 0 to ADiv do
          begin
            P.X := Start.X + ADelta.X * C * Quads[i].X - Quads[i].Y * H * APerp.X - (1 - Quads[i].X) * C / LdivW * APerp.X;
            P.Y := Start.Y + ADelta.Y * C * Quads[i].X - Quads[i].Y * H * APerp.Y - (1 - Quads[i].X) * C / LdivW * APerp.Y;
          Add(P);
          end;
        end;
        Add(ABase.X - W.X, ABase.Y - W.Y);
        Add(Target);
        Add(ABase.X + W.X, ABase.Y + W.Y);
        if C > 0 then
        begin
          for i := ADiv downto 0 do
          begin
            P.X := Close.X + ADelta.X * C * Quads[i].X + Quads[i].Y * H * APerp.X + (1 - Quads[i].X) * C / LdivW * APerp.X;
            P.Y := Close.Y + ADelta.Y * C * Quads[i].X + Quads[i].Y * H * APerp.Y + (1 - Quads[i].X) * C / LdivW * APerp.Y;
            Add(P);
          end;
        end;
        Add(Close);
      end;
    asDiamondArrow:
      begin
        Add(Start);
        C := ALength * 0.5;
        P.X := ABase.X + ADelta.X * C - W.X;
        P.Y := ABase.Y + ADelta.Y * C - W.Y;
        Add(P);
        Add(Target);
        P.X := ABase.X + ADelta.X * C + W.X;
        P.Y := ABase.Y + ADelta.Y * C + W.Y;
        Add(P);
        Add(Close);
      end;
    asOvalArrow:
      begin
        Add(Start);
        C := ALength * 0.5;
        Wdiv2 := Width / 2;
        QuadrantPoints(Max(C, Wdiv2) * GetScale, Quads, ADiv);
        for i := 1 to ADiv - 1 do
        begin
          P.X := ABase.X + ADelta.X * C * (1 - Quads[i].X) - Wdiv2 * APerp.X * Quads[i].Y;
          P.Y := ABase.Y + ADelta.Y * C * (1 - Quads[i].X) - Wdiv2 * APerp.Y * Quads[i].Y;
          if LowerThanLine(Start, ADelta, P) > 0 then
            Add(P);
        end;
        for i := ADiv downto 1 do
        begin
          P.X := ABase.X + ADelta.X * C * (1 + Quads[i].X) - Wdiv2 * APerp.X * Quads[i].Y;
          P.Y := ABase.Y + ADelta.Y * C * (1 + Quads[i].X) - Wdiv2 * APerp.Y * Quads[i].Y;
          Add(P);
        end;
        for i := 0 to ADiv - 1 do
        begin
          P.X := ABase.X + ADelta.X * C * (1 + Quads[i].X) + Wdiv2 * APerp.X * Quads[i].Y;
          P.Y := ABase.Y + ADelta.Y * C * (1 + Quads[i].X) + Wdiv2 * APerp.Y * Quads[i].Y;
          Add(P);
        end;
        for i := ADiv downto 1 do
        begin
          P.X := ABase.X + ADelta.X * C * (1 - Quads[i].X) + Wdiv2 * APerp.X * Quads[i].Y;
          P.Y := ABase.Y + ADelta.Y * C * (1 - Quads[i].X) + Wdiv2 * APerp.Y * Quads[i].Y;
          if LowerThanLine(Close, ADelta, P) < 0 then
            Add(P);
        end;
        Add(Close);
      end;
    asRectangleArrow: // added by EL
      begin
        Add(Start);
        Add(ABase.X - W.X, ABase.Y - W.Y);
        Add(Target.X - W.X, Target.Y - W.Y);
        Add(Target.X + W.X, Target.Y + W.Y);
        Add(ABase.X + W.X, ABase.Y + W.Y);
        Add(Close);
      end; // end added by EL
    end;//case
end;

procedure TdtpArrow.LoadFromXml(ANode: TXmlNodeOld);
var
  i: integer;
  AName: string;
begin
  AName := string(ANode.ReadString('Style'));
  for i := 0 to cArrowStyleCount - 1 do
    if AName = cArrowStyleNames[i] then
      Style := TdtpArrowStyle(i);
  FWidth  := ANode.ReadFloat('Width');
  FLength := ANode.ReadFloat('Length');
end;

procedure TdtpArrow.SaveToXml(ANode: TXmlNodeOld);
begin
  ANode.WriteString('Style', UTF8String(cArrowStyleNames[integer(Style)]));
  ANode.WriteFloat('Width', FWidth);
  ANode.WriteFloat('Length', FLength);
end;

procedure TdtpArrow.SetLength(const Value: single);
begin
  if FLength <> Value then
  begin
    if assigned(Parent) then
      Parent.Invalidate;
    FLength := Value;
    if assigned(Parent) then
    begin
      Parent.Regenerate;
      Parent.Changed;
    end;
  end;
end;

procedure TdtpArrow.SetStyle(const Value: TdtpArrowStyle);
begin
  if FStyle <> Value then
  begin
    if assigned(Parent) then
      Parent.Invalidate;
    FStyle := Value;
    if assigned(Parent) then
    begin
      Parent.Regenerate;
      Parent.Changed;
    end;
  end;
end;

procedure TdtpArrow.SetWidth(const Value: single);
begin
  if FWidth <> Value then
  begin
    if assigned(Parent) then
      Parent.Invalidate;
    FWidth := Value;
    if assigned(Parent) then
    begin
      Parent.Regenerate;
      Parent.Changed;
    end;
  end;
end;

initialization

  RegisterShapeClass(TdtpLineShape);

end.
