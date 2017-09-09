unit sdLineSimplifier;
{
  Description: TsdLineSimplifier takes a polyline of XY locations and:

  - Simplifies the polyline using the Douglas-Peucker algorithm, with possible
    scaleup in Y (if the DP should be more sensitive to the Y coordinate)

  - Finds the best matching line segments through the points

  - Updates the intersection points between the segments

  TsdLineSimplifier can be used with data generated from laser-line images.

  Author: Nils Haeck M.Sc. (SimDesign B.V.)

  Created: 29Sep2008

  Modifications:

  copyright (c) 2008 SimDesign B.V.

  This source code may NOT be used or replicated without prior permission
  from the abovementioned author.
}

interface

uses
  Classes, Contnrs, SysUtils, sdLines2D, sdPoints2D, sdGeomFit2D;

type

  // Vertex2D with index, for easy processing of segments
  TsdIndexVertex2D = class(TsdVertex2D)
  private
    FIdx: integer;
  public
    property Idx: integer read FIdx write FIdx;
  end;

  //
  TsdSegment2D = class(TPersistent)
  private
    FParams: TsdLineParams2D; // Line params
    FIdx1, FIdx2: integer;
  public
    property Idx1: integer read FIdx1 write FIdx1;
    property Idx2: integer read FIdx2 write FIdx2;
  end;

  TsdSegment2DList = class(TObjectList)
  private
    function GetItems(Index: integer): TsdSegment2D;
  public
    property Items[Index: integer]: TsdSegment2D read GetItems; default;
  end;

  TsdLineSimplifier = class(TsdAbstractGeomFit2D)
  private
    FPolygon: TsdVertex2DList;
    FSegments: TsdSegment2DList;
    FLineFit: TsdLineFit2D;
    FYScaleUp: double;
    FLineTolerance: double;
  protected
    procedure BuildPolygon;
    procedure FitLineToSegment(ASegment: TsdSegment2D);
    procedure RecalcIntersections;
    procedure CalculateWeights;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    function Solve: boolean; override;
    // Scale-up in Y when running Douglas-Peucker (all Y coordinates are multiplied by this value)
    property YScaleUp: double read FYScaleUp write FYScaleUp;
    // Line tolerance when running Douglas-Peucker
    property LineTolerance: double read FLineTolerance write FLineTolerance;
    // Resulting simplified polygon
    property Polygon: TsdVertex2DList read FPolygon;
  end;

implementation

{ TsdSegment2DList }

function TsdSegment2DList.GetItems(Index: integer): TsdSegment2D;
begin
  if (Index >= 0) and (Index < Count) then
    Result := Get(Index)
  else
    Result := nil;
end;

{ TsdLineSimplifier }

procedure TsdLineSimplifier.BuildPolygon;
var
  i: integer;
  V: TsdIndexVertex2D;
begin
  FPolygon.Clear;
  FSegments.Clear;

  // Make list of vertices
  for i := 0 to Count - 1 do
  begin
    V := TsdIndexVertex2D.Create;
    V.X := FXValues[i];
    V.Y := FYValues[i];
    V.FIdx := i;
    FPolygon.Add(V);
  end;

end;

procedure TsdLineSimplifier.CalculateWeights;
var
  i: integer;
  Dx, Dy: double;
begin
  // The weight of a point is half of the distances to neighbours before and after the point
  for i := 1 to Count - 2 do
  begin
    Dx := (FXValues[i + 1] - FXValues[i - 1]) * 0.5;
    Dy := (FYValues[i + 1] - FYValues[i - 1]) * 0.5;
    FWeights[i] := sqrt(sqr(Dx) + Sqr(Dy))
  end;
  if Count >= 2 then
  begin
    FWeights[0] := FWeights[1];
    FWeights[Count - 1] := FWeights[Count - 2]
  end;
end;

constructor TsdLineSimplifier.Create(AOwner: TComponent);
begin
  inherited;
  FPolygon := TsdVertex2DList.Create(True);
  FSegments := TsdSegment2DList.Create(True);
  FLineFit := TsdLineFit2D.Create(Self);
  // Sensible defaults
  FYScaleUp := 20.0;
  FLineTolerance := 15.0;
end;

destructor TsdLineSimplifier.Destroy;
begin
  FreeAndNil(FPolygon);
  FreeAndNil(FSegments);
  inherited;
end;

procedure TsdLineSimplifier.FitLineToSegment(ASegment: TsdSegment2D);
var
  Cnt: integer;
begin
  Cnt := ASegment.FIdx2 - ASegment.FIdx1 + 1;
  if Cnt <= 0 then
    exit;

  // Copy data to linefit
  FLineFit.Count := Cnt;
  FLineFit.SetXValues(@FXValues[ASegment.Idx1], Cnt);
  FLineFit.SetYValues(@FYValues[ASegment.Idx1], Cnt);
  FLineFit.SetWeights(@FWeights[ASegment.Idx1], Cnt);

  // Run linefit
  FLineFit.UseWeights := UseWeights;
  FLineFit.Solve;
  ASegment.FParams.A := FLineFit.A;
  ASegment.FParams.B := FLineFit.B;
  ASegment.FParams.C := FLineFit.C;
end;

procedure TsdLineSimplifier.RecalcIntersections;
var
  i: integer;
  S1, S2: TsdSegment2D;
  P: TsdPoint2D;
  Wall: TsdLineParams2D;
begin
  if FSegments.Count < 1 then
    exit;

  for i := 0 to FSegments.Count - 2 do
  begin
    S1 := FSegments[i];
    S2 := FSegments[i + 1];
    if LineIntersection2D(S1.FParams, S2.FParams, P) then
    begin
      FPolygon[i + 1].AsPoint := P;
    end;
  end;

  // Intersection with left wall
  Wall.A := 1;
  Wall.B := 0;
  Wall.C := 0;
  if LineIntersection2D(Wall, FSegments[0].FParams, P) then
    FPolygon[0].AsPoint := P;

  // Intersection with right wall
  Wall.C := -Count;
  if LineIntersection2D(Wall, FSegments[FSegments.Count - 1].FParams, P) then
    FPolygon[FPolygon.Count - 1].AsPoint := P;

end;

function TsdLineSimplifier.Solve: boolean;
var
  i: integer;
  V1, V2: TsdIndexVertex2D;
  S: TsdSegment2D;
begin
  Result := True;

  // First: build a polygon of the data
  BuildPolygon;

  // Now Simplify
  PolySimplify2DList(FPolygon, FLineTolerance, FYScaleUp);

  // Build segment list
  for i := 0 to FPolygon.Count - 2 do
  begin
    V1 := TsdIndexVertex2D(FPolygon[i]);
    V2 := TsdIndexVertex2D(FPolygon[i + 1]);
    S := TsdSegment2D.Create;
    S.FIdx1 := V1.FIdx;
    S.FIdx2 := V2.FIdx;
    FSegments.Add(S);
  end;

  // Weights: if we use weights, we have to calculate them
  if UseWeights then
    CalculateWeights;

  // Fit to all line segments
  for i := 0 to FSegments.Count - 1 do
  begin
    FitLineToSegment(FSegments[i]);
  end;

  // New intersection points
  RecalcIntersections;

  // Done!
end;

end.
