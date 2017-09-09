{ Project: Pyro
  Module: Pyro Render

  Description:
  Stroking of paths is the process where a path is converted into a stroked line
  with a certain thickness.

  Note: this object is too lightweight, needs 2D triangulation for weird outlines.
  However, for most cases the outlining in this unit is adequate.

  Creation Date:
  24Dec2004

  Modifications:
  05Oct2005: Added stroke dash array
  11Oct2005: Added invalid segment detection, linecap
  19aug2011: removed "with" statements

  Author: Nils Haeck (n.haeck@simdesign.nl)
  Copyright (c) 2004 - 2011 SimDesign BV
}
unit pgStroker;

{$i simdesign.inc}

interface

uses
  Classes,
  pgPath, pgPolygon, pgGeometry, pgCanvas, Pyro;

type

  PpgStrokeSegment = ^TPgStrokeSegment;
  PpgStrokeJoinRec = ^TpgStrokeJoinRec;
  TpgStrokeJoinRec = record
    Vertex: PpgPoint;
    LSegment: PpgStrokeSegment;
    RSegment: PpgStrokeSegment;
    Convex: boolean;
    JoinType: TpgStrokeJoin;
    Miter: TpgPoint;
  end;

  TpgStrokeSegment = record
    Normal: TpgPoint;
    Offset: TpgPoint;
    LJoin: PpgStrokeJoinRec;
    RJoin: PpgStrokeJoinRec;
    IsValid: boolean;
  end;

  // TpgStroker is a geometrical drawing class that creates a stroke path from
  // another path.
  TpgStroker = class(TPersistent)
  private
    FStrokeWidth: double;
    FLineCap: TpgLineCap;
    FLineJoin: TpgLineJoin;
    FMiterLimit: double;
    FOffset: double;
    FNormals: array of TpgPoint;
    FSegments: array of TpgStrokeSegment;
    FJoins: array of TpgStrokeJoinRec;
    FSegmentCount: integer;
    FDashOffset: double;
    FDashArray: TpgFloatList;
    FDashes: array of double;
  protected
    procedure PrepareStroking(AItem: TpgPolygonItem);
    procedure OutlineSegments(ADest: TpgPath; FirstSegmentIdx: integer);
    procedure OutlineClosedPath(AItem: TpgPolygonItem; ADest: TpgPath; const AOutlineWidth: double);
    procedure StrokeClosedPath(AItem: TpgPolygonItem; ADest: TpgPath);
    procedure StrokeOpenPath(AItem: TpgPolygonItem; ADest: TpgPath);
  public
    constructor Create; virtual;
    function CreateDashedPath(ASource: TpgPath): TpgPath;
    procedure Stroke(APath, ADest: TpgPath);
    procedure Outline(APath, ADest: TpgPath; const AOutlineWidth: double);
    property StrokeWidth: double read FStrokeWidth write FStrokeWidth;
    property LineCap: TpgLineCap read FLineCap write FLineCap;
    property LineJoin: TpgLineJoin read FLineJoin write FLineJoin;
    property MiterLimit: double read FMiterLimit write FMiterLimit;
    property DashArray: TpgFloatList read FDashArray write FDashArray;
    property DashOffset: double read FDashOffset write FDashOffset;
  end;

implementation

{ TpgStroker }

constructor TpgStroker.Create;
begin
  inherited Create;
  // Default miter limit
  FMiterLimit := 4;
  FLineJoin := ljMiter;
end;

function TpgStroker.CreateDashedPath(ASource: TpgPath): TpgPath;
var
  i, Count, Index: integer;
  DashLength, PathLength, PathCurPos, PathEndPos, Increment: double;
  PStart, PClose: TpgPathPosition;
  Last: boolean;
begin
  // create resulting path containing dashed segments
  Result := TpgPathClass(ASource.ClassType).Create;

  // Copy dash array locally
  Count := FDashArray.Count;
  SetLength(FDashes, Count);
  for i := 0 to Count - 1 do
    FDashes[i] := FDashArray[i];

  // First off double the length with a copy if odd
  if odd(Count) then
  begin
    SetLength(FDashes, Count * 2);
    for i := 0 to Count - 1 do
    begin
      FDashes[i + Count] := FDashes[i];
    end;
  end;

  // Check DashArray
  DashLength := 0;
  for i := 0 to length(FDashes) - 1 do
  begin
    FDashes[i] := abs(FDashes[i]);
    DashLength := DashLength + FDashes[i];
  end;
  if DashLength = 0 then
    exit;

  // Path length, and check for zero
  PathLength := ASource.PathLength;
  if PathLength = 0 then
    exit;

  // First move over DashOffset
  PClose := cPathStartPosition;
  PathCurPos := FDashOffset;
  while PathCurPos < 0 do
    PathCurPos := PathCurPos + PathLength;
  ASource.PositionAlongPath(PClose, FDashOffset);

  // We adjust here slightly to avoid wraparound of last point due to small
  // roundoff errors
  PathLength := PathLength - 1E-20;

  // Last position
  PathEndPos := PathLength + FDashOffset;

  // Breakup each path into dashed segments
  Index := 0;
  Last := False;
  repeat

    // Find correct increment (not too much)
    Increment := FDashes[Index];
    if PathCurPos + Increment >= PathEndPos then
    begin
      Increment := PathEndPos - PathCurPos;
      Last := True;
    end;

    // New position along the curve
    PStart := PClose;
    ASource.PositionAlongPath(PClose, Increment);

    // If we're in drawing mode (Index = even), then copy the segment
    if not odd(Index) then
      ASource.CopySegment(Result, PStart, PClose);

    // Update dash sequence and current position on the path
    Index := (Index + 1) mod length(FDashes);
    PathCurPos := PathCurPos + Increment;
  until Last;
{not correct?  // if Index is odd here, it means the last segment can be connected to the first
  if odd(Index) then
    Result.Poly.ConnectLastToFirst;}
end;

procedure TpgStroker.Outline(APath, ADest: TpgPath; const AOutlineWidth: double);
var
  i: integer;
  PP: TpgPolyPolygon;
begin
  if not assigned(APath) or not assigned(ADest) then
    exit;

  FOffset := abs(AOutlineWidth);

  PP := APath.AsPolyPolygon;
  for i := 0 to PP.Count - 1 do
    if PP[i].IsClosed then
      OutlineClosedPath(PP[i], ADest, AOutlineWidth)
    else
      StrokeOpenPath(PP[i], ADest);
end;

procedure TpgStroker.OutlineClosedPath(AItem: TpgPolygonItem; ADest: TpgPath;
  const AOutlineWidth: double);
var
  i: integer;
  TempJ: PpgStrokeJoinRec;
  TempS: PpgStrokeSegment;
begin
  if AItem.PointCount < 2 then
    exit;

  // Preparation
  PrepareStroking(AItem);

  // We have same number of elements as the path's point count
  FSegmentCount := AItem.PointCount;
  SetLength(FSegments, pgMax(Length(FSegments), FSegmentCount));
  SetLength(FJoins, pgMax(Length(FJoins), FSegmentCount));

  // Build segment and join arrays
  for i := 0 to FSegmentCount - 1 do
  begin
    // Set the normals
    FSegments[i].Normal := FNormals[i];
    // Set join pointers
    FSegments[i].LJoin := @FJoins[i];
    FSegments[i].RJoin := @FJoins[(i + 1) mod FSegmentCount];

    FJoins[i].Vertex := AItem.Points[i];
    FJoins[i].LSegment := @FSegments[(FSegmentCount + i - 1) mod FSegmentCount];
    FJoins[i].RSegment := @FSegments[i];
    FJoins[i].JoinType := jtUndetermined;
  end;

  if AOutlineWidth >= 0 then
  begin

    // Outline the segments outward
    OutlineSegments(ADest, 0);

  end else
  begin

    // Outline the segments inward
    for i := 0 to FSegmentCount - 1 do
    begin
      // Flip the normals
      FSegments[i].Normal := pgFlipVector(FSegments[i].Normal);

      // Swap segment joins
      TempJ := FSegments[i].LJoin;
      FSegments[i].LJoin := FSegments[i].RJoin;
      FSegments[i].RJoin := TempJ;

      // Swap join segments
      TempS := FJoins[i].LSegment;
      FJoins[i].LSegment := FJoins[i].RSegment;
      FJoins[i].RSegment := TempS;
      FJoins[i].JoinType := jtUndetermined;
    end;

    OutlineSegments(ADest, FSegmentCount - 1);

  end;
end;

procedure TpgStroker.OutlineSegments(ADest: TpgPath; FirstSegmentIdx: integer);
var
  i: integer;
  Dx, Dy, R2, F, MiterLength: double;
  P, P1, P2: TpgPoint;
  IsFirstPoint: boolean;
  FirstJoin, Join: PpgStrokeJoinRec;
  // Local
  procedure AddPoint(const P: TpgPoint);
  begin
    if IsFirstPoint then
    begin
      ADest.MoveTo(P.X, P.Y);
      IsFirstPoint := False;
    end else
      ADest.LineTo(P.X, P.Y);
  end;
// main
begin
  for i := 0 to FSegmentCount - 1 do
  begin

    // Step 1: determine convex/concave
    FJoins[i].Convex := pgCrossProduct(FJoins[i].RSegment.Normal, FJoins[i].LSegment.Normal) >= 0;

    // Step 2: determine join type
    if FJoins[i].JoinType = jtUndetermined then
    begin
      if FJoins[i].Convex then
      begin
        FJoins[i].JoinType := TpgStrokeJoin(integer(FLineJoin) + 1);
      end else
        FJoins[i].JoinType := jtMiter;
    end;

    // Step 3: calculate and check miters
    if FJoins[i].JoinType = jtMiter then
    begin
      // Calculate miter direction
      Dx := FJoins[i].LSegment.Normal.X + FJoins[i].RSegment.Normal.X;
      Dy := FJoins[i].LSegment.Normal.Y + FJoins[i].RSegment.Normal.Y;
      R2 := pgMax(1E-30, sqr(Dx) + sqr(Dy));
      F := 2 / R2;
      FJoins[i].Miter.X := F * Dx * FOffset;
      FJoins[i].Miter.Y := F * Dy * FOffset;

      // Check miter limit
      if FJoins[i].Convex then
      begin
        MiterLength := 2 / sqrt(R2);
        if MiterLength > FMiterLimit then
          FJoins[i].JoinType := jtBevel;
      end;
    end;
  end;

  // Step 4: detect degenerate segments
  for i := 0 to FSegmentCount - 1 do
  begin

    // Calculate offset vector for this segment
    FSegments[i].Offset.X := FSegments[i].Normal.X * FOffset;
    FSegments[i].Offset.Y := FSegments[i].Normal.Y * FOffset;

    // Find the start and end point for each segment
    case FSegments[i].LJoin.JoinType of
    jtMiter:
      P1 := pgAddPoint(FSegments[i].LJoin.Vertex^, FSegments[i].LJoin.Miter);
    jtBevel, jtRound:
      P1 := pgAddPoint(FSegments[i].LJoin.Vertex^, FSegments[i].Offset);
    end;
    case FSegments[i].RJoin.JoinType of
    jtMiter:
      P2 := pgAddPoint(FSegments[i].RJoin.Vertex^, FSegments[i].RJoin.Miter);
    jtBevel, jtRound:
      P2 := pgAddPoint(FSegments[i].RJoin.Vertex^, FSegments[i].Offset);
    end;

    // if the offsetted segment is in the same direction as the vertex, it is
    // valid. If it is opposite, the length has become negative, which indicates
    // an outlining error.
    FSegments[i].IsValid := pgDotProduct(pgDelta(P2, P1),
      pgDelta(FSegments[i].RJoin.Vertex^, FSegments[i].LJoin.Vertex^)) >= 0;
  end;

  // Step 5: set joins that border an invalid segments and are concave to jtBevel
  for i := 0 to FSegmentCount - 1 do
  begin
    if (not FJoins[i].Convex) and ((not FJoins[i].LSegment.IsValid) or (not FJoins[i].RSegment.IsValid)) then
       FJoins[i].JoinType := jtBevel;
  end;

  // Step 6: draw the outline, by drawing the joins
  Join := FSegments[FirstSegmentIdx].LJoin;
  FirstJoin := Join;
  IsFirstPoint := True;
  repeat
    case Join.JoinType of
    jtBevel:
      begin
        AddPoint(pgAddPoint(Join.Vertex^, Join.LSegment.Offset));
        AddPoint(pgAddPoint(Join.Vertex^, Join.RSegment.Offset));
      end;
    jtRound:
      begin
        AddPoint(pgAddPoint(Join.Vertex^, Join.LSegment.Offset));
        P := pgAddPoint(Join.Vertex^, Join.RSegment.Offset);
        ADest.ArcTo(FOffset, FOffset, 0, False, False, P.X, P.Y);
      end;
    jtMiter:
      begin
        AddPoint(pgAddPoint(Join.Vertex^, Join.Miter));
      end;
    end;
    Join := Join.RSegment.RJoin;
  until Join = FirstJoin;

  if not IsFirstPoint then
    ADest.ClosePath;
end;

procedure TpgStroker.PrepareStroking(AItem: TpgPolygonItem);
begin
  if AItem.PointCount < 2 then
    exit;

  // Prepare
  SetLength(FNormals, AItem.PointCount);

  // Create normals
  pgBuildNormals(AItem.FirstPoint, @FNormals[0], AItem.PointCount);
end;

procedure TpgStroker.Stroke(APath, ADest: TpgPath);
var
  i: integer;
  Source: TpgPath;
  PP: TpgPolyPolygon;
begin
  if not assigned(APath) or not assigned(ADest) then
    exit;

  // prepare
  FOffset := FStrokeWidth * 0.5;
  if FOffset <= 0 then
    exit;

  Source := nil;
  try

    // dashed or not?
    if assigned(FDashArray) and (FDashArray.Count > 0) then
    begin

      Source := CreateDashedPath(APath);

    end else
    begin

      // No dashes: Use the original path directly
      Source := APath;

    end;

    // Simply add all paths as single stroked entities
    PP := Source.AsPolyPolygon;
    for i := 0 to PP.Count - 1 do
      if PP[i].IsClosed then
        StrokeClosedPath(PP[i], ADest)
      else
        StrokeOpenPath(PP[i], ADest);

  finally
    // Free the source if we created it for the dashes
    if Source <> APath then
      Source.Free;
  end;
end;

procedure TpgStroker.StrokeClosedPath(AItem: TpgPolygonItem; ADest: TpgPath);
var
  i: integer;
  TempJ: PpgStrokeJoinRec;
  TempS: PpgStrokeSegment;
begin
  if AItem.PointCount < 2 then
    exit;

  // Preparation
  PrepareStroking(AItem);

  // We have same number of elements as the path's point count
  FSegmentCount := AItem.PointCount;
  SetLength(FSegments, pgMax(Length(FSegments), FSegmentCount));
  SetLength(FJoins, pgMax(Length(FJoins), FSegmentCount));

  // Build segment and join arrays
  for i := 0 to FSegmentCount - 1 do
  begin
    //todo! remove with
    with FSegments[i] do
    begin
      // Set the normals
      Normal := FNormals[i];
      // Set join pointers
      LJoin := @FJoins[i];
      RJoin := @FJoins[(i + 1) mod FSegmentCount];
    end;
    //todo! remove with
    with FJoins[i] do
    begin
      Vertex := AItem.Points[i];
      LSegment := @FSegments[(FSegmentCount + i - 1) mod FSegmentCount];
      RSegment := @FSegments[i];
      JoinType := jtUndetermined;
    end;
  end;

  // Outline the segments, outer curve
  OutlineSegments(ADest, 0);

  // Now flip the direction, and outline the other offset
  for i := 0 to FSegmentCount - 1 do
  begin
    // Flip the normals
    FSegments[i].Normal := pgFlipVector(FSegments[i].Normal);

    // Swap segment joins
    TempJ := FSegments[i].LJoin;
    FSegments[i].LJoin := FSegments[i].RJoin;
    FSegments[i].RJoin := TempJ;

    // Swap join segments
    TempS := FJoins[i].LSegment;
    FJoins[i].LSegment := FJoins[i].RSegment;
    FJoins[i].RSegment := TempS;
    FJoins[i].JoinType := jtUndetermined;
  end;

  // Outline the segments, inner curve
  OutlineSegments(ADest, FSegmentCount - 1);
end;

procedure TpgStroker.StrokeOpenPath(AItem: TpgPolygonItem; ADest: TpgPath);
var
  i, Index: integer;
  P, Q: TpgPoint;
begin
  if AItem.PointCount < 2 then
  begin
    if AItem.PointCount = 1 then
    begin
      // Specific drawing of "dots"
      P := AItem.Points[0]^;
      case FLineCap of
      //lcButt: nothing to do for lcButt
      lcRound:
        begin
          // Draw a circle
          ADest.Ellipse(P.X, P.Y, FOffset, FOffset);
        end;
      lcSquare:
        begin
          // Draw a square, but find directionality first
          // to do: directionality from parent pathset
          Q := pgOffsetPoint(P,  FOffset,  FOffset);
          ADest.MoveTo(Q.X, Q.Y);
          Q := pgOffsetPoint(P, -FOffset,  FOffset);
          ADest.LineTo(Q.X, Q.Y);
          Q := pgOffsetPoint(P, -FOffset, -FOffset);
          ADest.LineTo(Q.X, Q.Y);
          Q := pgOffsetPoint(P,  FOffset, -FOffset);
          ADest.LineTo(Q.X, Q.Y);
          ADest.ClosePath;
        end;
      end;
    end;
    exit;
  end;

  // Preparation
  PrepareStroking(AItem);

  // Build segment and join arrays
  FSegmentCount := 2 * (AItem.PointCount - 1);
  if FLineCap = lcSquare then
    inc(FSegmentCount, 2);
  SetLength(FSegments, pgMax(Length(FSegments), FSegmentCount));
  SetLength(FJoins, pgMax(Length(FJoins), FSegmentCount));
  for i := 0 to FSegmentCount - 1 do
    FJoins[i].JoinType := jtUndetermined;

  Index := 0;
  // Forward path
  for i := 0 to AItem.PointCount - 2 do
  begin
    FJoins[Index].Vertex := AItem.Points[i];
    FSegments[Index].Normal := FNormals[i];
    inc(Index);
  end;

  // ending linecap
  case FLineCap of
  lcButt:  FJoins[Index].JoinType := jtBevel;
  lcRound: FJoins[Index].JoinType := jtRound;
  lcSquare:
    begin
      // We add another segment and join
      FJoins[Index].JoinType := jtMiter;
      FJoins[Index].Vertex := AItem.Points[Index];
      FSegments[Index].Normal := pgPoint(FNormals[Index - 1].Y, -FNormals[Index - 1].X);
      inc(Index);
      FJoins[Index].JoinType := jtMiter;
    end;
  end;

  // Backward path
  for i := AItem.PointCount - 2 downto 0 do
  begin
    FJoins[Index].Vertex := AItem.Points[i + 1];
    FSegments[Index].Normal := pgFlipVector(FNormals[i]);
    inc(Index);
  end;

  // starting linecap
  case FLineCap of
  lcButt:  FJoins[0].JoinType := jtBevel;
  lcRound: FJoins[0].JoinType := jtRound;
  lcSquare:
    begin
      // We add another segment and join
      FJoins[Index].JoinType := jtMiter;
      FJoins[Index].Vertex := AItem.Points[0];
      FSegments[Index].Normal := pgPoint(-FNormals[0].Y, FNormals[0].X);
      FJoins[0].JoinType := jtMiter;
    end;
  end;

  // Hook up segments and joins
  for i := 0 to FSegmentCount - 1 do
  begin
    FSegments[i].LJoin := @FJoins[i];
    FSegments[i].RJoin := @FJoins[(i + 1) mod FSegmentCount];

    FJoins[i].LSegment := @FSegments[(i + FSegmentCount - 1) mod FSegmentCount];
    FJoins[i].RSegment := @FSegments[i];
  end;

  // Now we can outline the segments
  OutlineSegments(ADest, 0);
end;

end.
