{ Project: Pyro
  Module: Pyro Edit

  Description:

  TpgPolygon class

  TpgPolyPolygon class
    the TpgPolyPolygon is probably overly complex and could be simpler and
    faster, needs some work

  Routines for point in/on polygon detection.

  Author: Nils Haeck (n.haeck@simdesign.nl)
  Copyright (c) 2006 - 2011 SimDesign BV
}
unit pgPolygon;

{$i simdesign.inc}

interface

uses
  Classes, SysUtils, Contnrs, pgGeometry, Pyro;

type

  // A list of Count points, starting at First. Use method FromPoints to fill.
  // The polygon is assumed closed (a line exists from P0->P1.. etc until Plast->P0)
  TpgPolygon = class
  private
    FPoints: array of TpgPoint;
    FCount: integer;
    function GetLast: PpgPoint;
  protected
    function GetFirst: PpgPoint; virtual;
    function GetPoints(Index: integer): PpgPoint;
    procedure SetCapacity(ACapacity: integer);
  public
    procedure Clear;
    procedure FromPoints(AFirst: PpgPoint; ACount: integer);
    function BoundingBox: TpgBox;
    function PointInPolygon(const P: TpgPoint; AFillRule: TpgFillRule): boolean;
    property First: PpgPoint read GetFirst;
    property Last: PpgPoint read GetLast;
    property Count: integer read FCount;
    // Access to point at Index. Index = 0 is first point, Index = Count - 1 is
    // last point. Index can be called with values >= Count, for wrap around
    property Points[Index: integer]: PpgPoint read GetPoints;
  end;

  TpgAbstractPolyPolygon = class;

  // Generic polygon list item
  TpgAbstractPolygonItem = class(TPersistent)
  private
    FOwner: TpgAbstractPolyPolygon;
    FPointIndex: integer;
    FPointCount: integer;
  protected
    function Get(Index: integer): pointer;
    function Last: pointer;
    function GetIsClosed: boolean; virtual;
    procedure SetIsClosed(const Value: boolean); virtual;
  public
    constructor Create(AOwner: TpgAbstractPolyPolygon);
    procedure Assign(Source: TPersistent); override;
    function First: pointer;
    // Number of edges in this path. This normally is equal to number of points,
    // unless IsClosed = false.
    function EdgeCount: integer;
    // PointIndex of first point of this path in parent point list
    property PointIndex: integer read FPointIndex write FPointIndex;
    // Number of points in this path.
    property PointCount: integer read FPointCount write FPointCount;
    // If True, the path is considered closed (a line exists from Last to First point)
    property IsClosed: boolean read GetIsClosed write SetIsClosed;
  end;
  TpgPolygonItemClass = class of TpgAbstractPolygonItem;

  // Generic polygon list: contains a list of polygons, each described by number of points
  TpgAbstractPolyPolygon = class(TObjectList)
  private
    FData: array of byte;
    FCapacity: integer;
    FCurrentItem: TpgAbstractPolygonItem;
    FCurrentIndex: integer;
  protected
    FPointCount: integer;
    procedure IncreaseCapacity;
    procedure SetCapacity(ACapacity: integer); virtual;
    class function PolygonItemClass: TpgPolygonItemClass; virtual;
    class function PointSize: integer; virtual; abstract;
    procedure AddData;
  public
    constructor Create;
    procedure Assign(ASource: TpgAbstractPolyPolygon); virtual;
    // Clear all path items (but this does not reset capacity). See CleanupMemory
    procedure Clear; override;
    // Adjust capacity so we have not more memory reserved as necessary
    procedure CleanupMemory;
    function First: pointer;
    function Last: pointer;
    // Is the pointlist empty?
    function IsEmpty: boolean;
    // Did we start a current path?
    procedure CheckHasStart;
    // Total number of points
    property PointCount: integer read FPointCount;
  end;

  TpgPolygonItem = class(TpgAbstractPolygonItem)
  private
    FIsClosed: boolean;
  protected
    function GetPoints(Index: integer): PpgPoint;
    function LastPoint: PpgPoint;
    function GetIsClosed: boolean; override;
    procedure SetIsClosed(const Value: boolean); override;
  public
    procedure Assign(Source: TPersistent); override;
    function FirstPoint: PpgPoint;
    property Points[Index: integer]: PpgPoint read GetPoints;
  end;

  // Single-precision points (TpgPoint), forming mulitple polygons, collected in
  // TpgPolygonItem items that are contained in a list
  TpgPolyPolygon = class(TpgAbstractPolyPolygon)
  private
    FMustBreakup: boolean;
    FBreakupLength: single;
    procedure SetBreakupLength(const Value: single);
    function GetItems(Index: integer): TpgPolygonItem;
  protected
    class function PolygonItemClass: TpgPolygonItemClass; override;
    class function PointSize: integer; override;
    procedure AddPoint(const APoint: TpgPoint);
    function CurrentItem: TpgPolygonItem;
    function CurrentPoint: PpgPoint;
  public
    // For use in stroker: connects last segment back to first (if applicable)
    procedure ConnectLastToFirst;
    // Close the current path: the flag IsClosed will be set, last point is not
    // duplicated.
    procedure ClosePath;
    // Move to a new position
    procedure MoveTo(const APoint: TpgPoint);
    // Line to a new position
    procedure LineTo(const APoint: TpgPoint; IncludeLast: boolean);
    // Scale all points uniformly with factor S
    procedure ScaleUniform(const S: double);
    // First point in pointlist (or nil if none)
    function FirstPoint: PpgPoint;
    // Last point in pointlist (or nil if none)
    function LastPoint: PpgPoint;
    // Bounding box
    function BoundingBox: TpgBox;
    // Summed length of all polygons
    function GetPathLength: double;
    // Copy the contents of APolygon to a new item in our array
    procedure AddPolygon(APolygon: TpgPolygon);
    property Items[Index: integer]: TpgPolygonItem read GetItems; default;
    // Set breakup length > 0 to cause all LineTo's to break up in segments of
    // at most BreakupLength. This is useful when later transforming the points
    // with non-linear transforms.
    property BreakupLength: single read FBreakupLength write SetBreakupLength;
  end;

{ functions }

procedure PathItemBuildNormals(AItem: TpgPolygonItem; var Normals: array of TpgPoint);

implementation

{ TpgPolygon }

function TpgPolygon.BoundingBox: TpgBox;
var
  i: integer;
  P: PpgPoint;
  IsFirst: boolean;
begin
  Result := cEmptyBox;
  if Count <= 2 then
    exit;
  IsFirst := True;
  P := First;
  for i := 0 to Count - 1 do
  begin
    pgUpdateBox(Result, P^, IsFirst);
    inc(P);
  end;
end;

procedure TpgPolygon.Clear;
begin
  FCount := 0;
end;

procedure TpgPolygon.FromPoints(AFirst: PpgPoint; ACount: integer);
begin
  SetCapacity(pgMax(ACount, FCount));
  FCount := ACount;
  if ACount > 0 then
  begin
    Move(AFirst^, FPoints[0], ACount * SizeOf(TpgPoint));
  end;
end;

function TpgPolygon.GetFirst: PpgPoint;
begin
  if FCount > 0 then
    Result := @FPoints[0]
  else
    Result := nil;
end;

function TpgPolygon.GetLast: PpgPoint;
begin
  if FCount > 0 then
  begin
    Result := GetFirst;
    inc(Result, Count - 1);
  end else
    Result := nil;
end;

function TpgPolygon.GetPoints(Index: integer): PpgPoint;
begin
  if (Index >= 0) and (Count > Count) then
  begin
    Result := GetFirst;
    inc(Result, Index mod Count);
  end else
    Result := nil;
end;

function TpgPolygon.PointInPolygon(const P: TpgPoint; AFillRule: TpgFillRule): boolean;
var
  Res: integer;
begin
  Res := pgPointInPolygon(First, Count, P);
  case AFillRule of
  frEvenOdd: Result := odd(Res);
  frNonZero: Result := Res <> 0;
  else
    Result := False;
  end;
end;

procedure TpgPolygon.SetCapacity(ACapacity: integer);
begin
  SetLength(FPoints, ACapacity);
end;

{ TpgBorrowPolygon }

{constructor TpgBorrowPolygon.Create(AFirst: PpgPoint; ACount: integer);
begin
  inherited Create;
  FFirst := AFirst;
  FCount := ACount;
end;

function TpgBorrowPolygon.GetFirst: PpgPoint;
begin
  Result := FFirst;
end;}

{ TpgAbstractPolygonItem }

constructor TpgAbstractPolygonItem.Create(AOwner: TpgAbstractPolyPolygon);
begin
  inherited Create;
  FOwner := AOwner;
end;

function TpgAbstractPolygonItem.EdgeCount: integer;
begin
  // the index of the start point of last segment forming a line
  Result := FPointCount;
  if not IsClosed then
    dec(Result);
end;

function TpgAbstractPolygonItem.First: pointer;
begin
  Result := @FOwner.FData[FPointIndex * FOwner.PointSize];
end;

function TpgAbstractPolygonItem.GetIsClosed: boolean;
begin
  // override in descendants to add a flag
  Result := True;
end;

function TpgAbstractPolygonItem.Get(Index: integer): pointer;
begin
  if (Index >= 0) and (Index < FPointCount) then
    Result := @FOwner.FData[(FPointIndex + Index) * FOwner.PointSize]
  else
    Result := nil;
end;

function TpgAbstractPolygonItem.Last: pointer;
begin
  Result := Get(FPointCount - 1);
end;

procedure TpgAbstractPolygonItem.SetIsClosed(const Value: boolean);
begin
// default does nothing
end;

procedure TpgAbstractPolygonItem.Assign(Source: TPersistent);
begin
  if Source is TpgPolygonItem then
  begin
    FPointIndex := TpgPolygonItem(Source).FPointIndex;
    FPointCount := TpgPolygonItem(Source).FPointCount;
  end else
    inherited;
end;

{ TpgAbstractPolyPolygon }

procedure TpgAbstractPolyPolygon.AddData;
begin
  // Check capacity
  if FPointCount >= FCapacity then
    IncreaseCapacity;

  // increment current one point further
  inc(FCurrentIndex);
  inc(FPointCount);
  inc(FCurrentItem.FPointCount);
end;

procedure TpgAbstractPolyPolygon.Assign(ASource: TpgAbstractPolyPolygon);
var
  i: integer;
  Item: TpgAbstractPolygonItem;
begin
  Clear;
  // copy items
  for i := 0 to ASource.Count - 1 do
  begin
    Item := PolygonItemClass.Create(Self);
    Item.Assign(TPersistent(ASource[i]));
    Add(Item);
  end;

  // copy points
  FPointCount := ASource.FPointCount;
  SetCapacity(FPointCount);

  // check class, only copy actual data if equal
  if ClassType = ASource.ClassType then
  begin
    if FPointCount > 0 then
      System.Move(ASource.FData[0], FData[0], FPointCount * PointSize);
  end;
end;

procedure TpgAbstractPolyPolygon.CheckHasStart;
begin
  if not assigned(FCurrentItem) or (FCurrentIndex < 0) then
    raise Exception.Create(sNoCurrentPathDefined);
end;

procedure TpgAbstractPolyPolygon.CleanupMemory;
begin
  SetCapacity(FPointCount);
end;

procedure TpgAbstractPolyPolygon.Clear;
// Specifically we do not set capacity to 0, since the object might be
// reused. Mem can be freed with additional call to CleanupMemory
begin
  inherited Clear;
  FPointCount := 0;
  FCurrentItem := nil;
  FCurrentIndex := -1;
end;

constructor TpgAbstractPolyPolygon.Create;
begin
  inherited Create;
  FCurrentIndex := -1;
end;

function TpgAbstractPolyPolygon.First: pointer;
begin
  if FPointCount = 0 then
    Result := nil
  else
    Result := @FData[0];
end;

procedure TpgAbstractPolyPolygon.IncreaseCapacity;
begin
  // 4 -> 6+4=10 -> 15+4=19 -> 28+4=32 etc
  SetCapacity(FCapacity * 3 div 2 + 4);
end;

function TpgAbstractPolyPolygon.IsEmpty: boolean;
begin
  Result := FPointCount = 0;
end;

function TpgAbstractPolyPolygon.Last: pointer;
begin
  if FPointCount > 0 then
    Result := @FData[(FPointCount - 1) * PointSize]
  else
    Result := nil;
end;

class function TpgAbstractPolyPolygon.PolygonItemClass: TpgPolygonItemClass;
begin
  Result := TpgAbstractPolygonItem;
end;

procedure TpgAbstractPolyPolygon.SetCapacity(ACapacity: integer);
begin
  FCapacity := ACapacity;
  SetLength(FData, FCapacity * PointSize);
end;

{ TpgPolygonItem }

procedure TpgPolygonItem.Assign(Source: TPersistent);
begin
  inherited;
  if Source is TpgPolygonItem then
    FIsClosed   := TpgPolygonItem(Source).FIsClosed;
end;

function TpgPolygonItem.FirstPoint: PpgPoint;
begin
  Result := PpgPoint(First);
end;

function TpgPolygonItem.GetIsClosed: boolean;
begin
  Result := FIsClosed;
end;

function TpgPolygonItem.GetPoints(Index: integer): PpgPoint;
begin
  Result := PpgPoint(Get(Index));
end;

function TpgPolygonItem.LastPoint: PpgPoint;
begin
  Result := PpgPoint(Last);
end;

procedure TpgPolygonItem.SetIsClosed(const Value: boolean);
begin
  FIsClosed := Value;
end;

{ TpgPolyPolygon }

procedure TpgPolyPolygon.AddPoint(const APoint: TpgPoint);
begin
  AddData;
  CurrentPoint^ := APoint;
end;

procedure TpgPolyPolygon.AddPolygon(APolygon: TpgPolygon);
var
  Item: TpgPolygonItem;
  Count: integer;
begin
  Item := TpgPolygonItem.Create(Self);
  Add(Item);
  Item.PointIndex := PointCount;
  Count := APolygon.Count;
  SetCapacity(Count + PointCount);
  Item.PointCount := Count;
  if Count > 0 then
    System.Move(APolygon.First^, Item.FirstPoint^, Count * SizeOf(TpgPoint))
end;

function TpgPolyPolygon.BoundingBox: TpgBox;
var
  i: integer;
  P: PpgPoint;
  IsFirst: boolean;
begin
  Result := cEmptyBox;
  IsFirst := True;
  P := FirstPoint;
  for i := 0 to FPointCount - 1 do begin
    pgUpdateBox(Result, P^, IsFirst);
    inc(P);
  end;
end;

procedure TpgPolyPolygon.ClosePath;
begin
  CheckHasStart;

  // Check if the start and end points are already equal
  if (FCurrentItem.FPointCount >= 3) and
    pgPointsEqual(CurrentItem.FirstPoint^, CurrentItem.LastPoint^) then
  begin
    // Yes they are equal, we remove the last point
    dec(FCurrentItem.FPointCount);
    dec(FPointCount);
    dec(FCurrentIndex);
  end;

  if (FCurrentItem.FPointCount >= 2) then
    LineTo(CurrentItem.FirstPoint^, False);

  CurrentItem.IsClosed := True;

  // This signals we don't have a current path any longer
  FCurrentItem := nil;
end;

procedure TpgPolyPolygon.ConnectLastToFirst;
var
  P1, P2: PpgPoint;
  MoveCount, MoveIndex: integer;
begin
  // Start and end points
  P1 := FirstPoint;
  P2 := LastPoint;
  if not assigned(P1) or not assigned(P2) then
    exit;

  // Are they equal?
  if pgPointsEqual(P1^, P2^) then
  begin
    // Just one path.. close it
    if Count = 1 then
    begin
      ClosePath;
      exit;
    end;

    // Number of points to move
    MoveCount := Items[Count - 1].PointCount - 1;
    MoveIndex := Items[Count - 1].FPointIndex;
    if MoveCount <= 0 then
    begin
      Delete(Count - 1);
      exit;
    end;

    // ensure we have enough space
    while FCapacity < FPointCount + MoveCount do
      IncreaseCapacity;

    // Inject last points before first points
    System.Move(
      FData[0],
      FData[MoveCount * PointSize],
      FPointCount * PointSize);
    System.Move(
      FData[(MoveIndex + MoveCount) * PointSize],
      FData[0],
      MoveCount * PointSize);
    Delete(Count - 1);
  end;
end;

function TpgPolyPolygon.CurrentItem: TpgPolygonItem;
begin
  Result := TpgPolygonItem(FCurrentItem);
end;

function TpgPolyPolygon.CurrentPoint: PpgPoint;
begin
  Result := PpgPoint(@FData[FCurrentIndex * PointSize]);
end;

function TpgPolyPolygon.FirstPoint: PpgPoint;
begin
  Result := PpgPoint(First);
end;

function TpgPolyPolygon.GetItems(Index: integer): TpgPolygonItem;
begin
  Result := Get(Index)
end;

function TpgPolyPolygon.GetPathLength: double;
var
  i, j: integer;
  Item: TpgPolygonItem;
begin
  Result := 0;
  for i := 0 to Count - 1 do
  begin
    Item := Items[i];
    for j := 0 to Item.EdgeCount - 1 do
      Result := Result +
        pgDistance(Item.Points[j]^, Item.Points[(j + 1) mod Item.PointCount]^);
  end;
end;

function TpgPolyPolygon.LastPoint: PpgPoint;
begin
  Result := PpgPoint(Last);
end;

procedure TpgPolyPolygon.LineTo(const APoint: TpgPoint; IncludeLast: boolean);
var
  Px, Py, Dx, Dy, Factor: single;
  SegmentCount: integer;
begin
  CheckHasStart;

  // Minimal distance
  if pgPointsEqual(APoint, CurrentPoint^) then
    exit;

  // Break up?
  if FMustBreakup then
  begin
    Px := CurrentPoint^.X;
    Py := CurrentPoint^.Y;
    Dx := APoint.X - Px;
    Dy := APoint.Y - Py;
    SegmentCount := pgCeil((abs(Dx) + abs(Dy)) / FBreakupLength);
    if SegmentCount >= 2 then
    begin
      Factor := 1 / SegmentCount;
      Dx := Dx * Factor;
      Dy := Dy * Factor;
      dec(SegmentCount);
      while SegmentCount > 0 do
      begin
        Px := Px + Dx;
        Py := Py + Dy;
        AddPoint(pgPoint(Px, Py));
        dec(SegmentCount);
      end;
    end;
  end;

  // Add last point
  if IncludeLast then
    AddPoint(APoint);
end;

procedure TpgPolyPolygon.MoveTo(const APoint: TpgPoint);
begin
  FCurrentItem := PolygonItemClass.Create(Self);
  Add(FCurrentItem);
  FCurrentItem.FPointIndex := FPointCount;
  // Add
  AddPoint(APoint);
end;

class function TpgPolyPolygon.PolygonItemClass: TpgPolygonItemClass;
begin
  Result := TpgPolygonItem;
end;

class function TpgPolyPolygon.PointSize: integer;
begin
  Result := SizeOf(TpgPoint);
end;

procedure TpgPolyPolygon.ScaleUniform(const S: double);
var
  P: PpgPoint;
  i: integer;
begin
  P := FirstPoint;
  for i := 0 to FPointCount - 1 do
  begin
    P^.X := P^.X * S;
    P^.Y := P^.Y * S;
    inc(P);
  end;
end;

procedure TpgPolyPolygon.SetBreakupLength(const Value: single);
begin
  FBreakupLength := pgMax(0, Value);
  FMustBreakup := FBreakupLength > 0;
end;

{ TpgPolyPolygonF }

{procedure TpgPolyPolygonF.Add(const APoint: TpgPointF);
begin
//todo
end;

function TpgPolyPolygonF.GetPoints: TpgArrayOfArrayOfPointF;
begin
//todo
end;

procedure TpgPolyPolygonF.NewLine;
begin
//todo
end;}

{ functions }

procedure PathItemBuildNormals(AItem: TpgPolygonItem; var Normals: array of TpgPoint);
var
  i: integer;
  PointA, PointB: PpgPoint;
  Dx, Dy: single;
  R, F: double;
begin
  if AItem.PointCount <= 0 then
    exit;
  PointA := AItem.FirstPoint;
  for i := 0 to AItem.PointCount - 1 do
  begin

    // Get point B, auto-wrap around
    PointB := AItem.Points[(i + 1) mod AItem.PointCount];

    // The normals are rotated +90 deg
    Dx := PointA.Y - PointB.Y;
    Dy := PointB.X - PointA.X;

    // Normalize them
    R := Sqrt(Sqr(Dx) + Sqr(Dy));
    if R > 0 then
    begin
      F := 1 / R;
      Normals[i].X := Dx * F;
      Normals[i].Y := Dy * F;
    end else
    begin
      Normals[i].X := 0;
      Normals[i].Y := 0;
    end;
    PointA := PointB;
  end;
end;

end.
