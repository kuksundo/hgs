{ Project: Pyro

  Description:
  Region classes

  Author: Nils Haeck (n.haeck@simdesign.nl)
  Copyright (c) 2006-2011 SimDesign BV
}
unit pgRegion;

{$i simdesign.inc}

interface

uses
  Classes, SysUtils,
  pgPolygon, pgGeometry, Pyro, pgPath;

type

  // Ancestor class for regions, implements the empty region
  TpgRegion = class(TPersistent)
  public
    constructor Create; virtual;
    procedure Clear; virtual;
    function RegionType: TpgRegionType; virtual;
    // Combine R1 and R2, using CombineOp, and put the result in Dest. The region that
    // takes the result must be of the appropriate type. Usually R1, R2 and Dest
    // should all be the same type.
    class procedure CombineRegion(R1, R2, Dest: TpgRegion; CombineOp: TpgRegionCombineOp);
    // Returns True if point X,Y is inside the region. If the point is exactly on the
    // border, the check returns false.
    function PointInRegion(X, Y: single): boolean; virtual;
    // Returns True if any point of R is in the region. If a point of R just hits
    // the border, the check returns False.
    function RectInRegion(const R: TpgBox): boolean; virtual;
    // Returns the smallest box encompassing the region, or cEmptyBox (all zeroes)
    // if there is no region
    function BoundingBox: TpgBox; virtual;
  end;

  // Rectangular region, given by Box
  TpgRectangleRegion = class(TpgRegion)
  private
    FBox: TpgBox;
  public
    procedure Clear; override;
    function RegionType: TpgRegionType; override;
    function PointInRegion(X, Y: single): boolean; override;
    function RectInRegion(const R: TpgBox): boolean; override;
    function BoundingBox: TpgBox; override;
    property Box: TpgBox read FBox write FBox;
  end;

  TpgVectorRegion = class(TpgRegion)
  private
    FFillRule: TpgFillRule;
  public
    property FillRule: TpgFillRule read FFillRule write FFillRule;
  end;

  // Polygon region, given by Polygon. Use FromPoints to fill it.
  TpgPolygonRegion = class(TpgVectorRegion)
  private
    FPolygon: TpgPolygon;
  public
    constructor Create; override;
    destructor Destroy; override;
    procedure Clear; override;
    function RegionType: TpgRegionType; override;
    function PointInRegion(X, Y: single): boolean; override;
    function RectInRegion(const R: TpgBox): boolean; override;
    function BoundingBox: TpgBox; override;
    procedure FromPoints(AFirst: PpgPoint; ACount: integer; AFillRule: TpgFillRule);
    property Polygon: TpgPolygon read FPolygon;
  end;

  // PolyPolygon region, given by PolyPolygon. Use FromPoints to fill it.
  TpgPolyPolygonRegion = class(TpgVectorRegion)
  private
    FPolyPolygon: TpgPolyPolygon;
  public
    constructor Create; override;
    destructor Destroy; override;
    procedure Clear; override;
    function RegionType: TpgRegionType; override;
    function PointInRegion(X, Y: single): boolean; override;
    function RectInRegion(const R: TpgBox): boolean; override;
    function BoundingBox: TpgBox; override;
    procedure FromPoints(const FirstPoint: TpgPoint; const FirstVertex: integer;
      VertexCount: integer; AFillRule: TpgFillRule);
    property PolyPolygon: TpgPolyPolygon read FPolyPolygon;
  end;

  // Path region, given by Path. The default Path region doesn't implement
  // the methods, use the canvas NewRegion function to get a correct PathRegion
  // object.
  TpgPathRegion = class(TpgVectorRegion)
  private
    FPath: TpgPath;
  public
    destructor Destroy; override;
    procedure Clear; override;
    function RegionType: TpgRegionType; override;
    function PointInRegion(X, Y: single): boolean; override;
    function RectInRegion(const R: TpgBox): boolean; override;
    function BoundingBox: TpgBox; override;
    property Path: TpgPath read FPath;
  end;

  // Bitmapped region. The region is defined with 256 levels of AA, like a mask.
  // The default Bitmap region does not implement the methods, use the canvas
  // NewRegion function to get a correct BitmapRegion object.
  TpgBitmapRegion = class(TpgRegion)
  public
    function RegionType: TpgRegionType; override;
    function PointInRegion(X, Y: single): boolean; override;
    function RectInRegion(const R: TpgBox): boolean; override;
    function BoundingBox: TpgBox; override;
  end;

implementation

{ TpgRegion }

function TpgRegion.BoundingBox: TpgBox;
begin
  Result := cEmptyBox;
end;

procedure TpgRegion.Clear;
begin
// does nothing
end;

class procedure TpgRegion.CombineRegion(R1, R2, Dest: TpgRegion; CombineOp: TpgRegionCombineOp);
begin
  if not assigned(Dest) then exit;
end;

constructor TpgRegion.Create;
begin
  inherited Create;
end;

function TpgRegion.PointInRegion(X, Y: single): boolean;
begin
  // Empty region
  Result := False;
end;

function TpgRegion.RectInRegion(const R: TpgBox): boolean;
begin
  // Empty region
  Result := False;
end;

function TpgRegion.RegionType: TpgRegionType;
begin
  Result := rtEmpty;
end;

{ TpgRectangleRegion }

function TpgRectangleRegion.BoundingBox: TpgBox;
begin
  Result := FBox;
end;

procedure TpgRectangleRegion.Clear;
begin
  FBox := cEmptyBox;
end;

function TpgRectangleRegion.PointInRegion(X, Y: single): boolean;
begin
  Result := pgPointInBox(FBox, pgPoint(X, Y));
end;

function TpgRectangleRegion.RectInRegion(const R: TpgBox): boolean;
begin
  Result := pgBoxIntersects(R, FBox);
end;

function TpgRectangleRegion.RegionType: TpgRegionType;
begin
  Result := rtRectangle;
end;

{ TpgPolygonRegion }

function TpgPolygonRegion.BoundingBox: TpgBox;
begin
  Result := FPolygon.BoundingBox;
end;

procedure TpgPolygonRegion.Clear;
begin
  FPolygon.Clear;
end;

constructor TpgPolygonRegion.Create;
begin
  inherited;
  FPolygon := TpgPolygon.Create;
end;

destructor TpgPolygonRegion.Destroy;
begin
  FreeAndNil(FPolygon);
  inherited;
end;

procedure TpgPolygonRegion.FromPoints(AFirst: PpgPoint; ACount: integer;
  AFillRule: TpgFillRule);
begin
  FFillRule := AFillRule;
  FPolygon.FromPoints(AFirst, ACount);
end;

function TpgPolygonRegion.PointInRegion(X, Y: single): boolean;
begin
  Result := FPolygon.PointInPolygon(pgPoint(X, Y), FFillRule);
end;

function TpgPolygonRegion.RectInRegion(const R: TpgBox): boolean;
var
  i: integer;
  BB: TpgBox;
  Pts: array[0..3] of TpgPoint;
  P1, P2: PpgPoint;
begin
  Result := False;

  // Initial checks
  if pgIsEmptyBox(R) then
    exit;
  BB := BoundingBox;
  if pgIsEmptyBox(BB) then
    exit;

  // Do R and BB intersect? if not, the rectangle is not in the polygon
  if not pgBoxIntersects(R, BB) then
    exit;

  // Check if the polygon is completely contained in the rectangle
  BB := pgUnionBox(R, BB);
  if pgBoxEqual(BB, R) then
  begin
    Result := True;
    exit;
  end;

  // Any of the points of the rectangle in the polygon?
  pgBoxToPoints(R, @Pts[0]);
  for i := 0 to 3 do
    if FPolygon.PointInPolygon(Pts[i], FFillRule) then
    begin
      Result := True;
      exit;
    end;

  // It can still be that the polygon encroaches upon the rectangle through
  // one of its sides.. we must do clipping now
  P1 := FPolygon.Last;
  P2 := FPolygon.First;
  for i := 0 to FPolygon.Count - 1 do
  begin
    Result := pgLineAndBoxIntersect(P1^, P2^, R);
    if Result then exit;
    P1 := P2;
    inc(P2);
  end;
end;

function TpgPolygonRegion.RegionType: TpgRegionType;
begin
  Result := rtPolygon;
end;

{ TpgPolyPolygonRegion }

function TpgPolyPolygonRegion.BoundingBox: TpgBox;
begin
  raise Exception.Create(sNotImplemented);
end;

procedure TpgPolyPolygonRegion.Clear;
begin
  FPolyPolygon.Clear;
end;

constructor TpgPolyPolygonRegion.Create;
begin
  inherited;
  FPolyPolygon := TpgPolyPolygon.Create;
end;

destructor TpgPolyPolygonRegion.Destroy;
begin
  FreeAndNil(FPolyPolygon);
  inherited;
end;

procedure TpgPolyPolygonRegion.FromPoints(const FirstPoint: TpgPoint;
  const FirstVertex: integer; VertexCount: integer;
  AFillRule: TpgFillRule);
begin
  raise Exception.Create(sNotImplemented);
end;

function TpgPolyPolygonRegion.PointInRegion(X, Y: single): boolean;
begin
  raise Exception.Create(sNotImplemented);
end;

function TpgPolyPolygonRegion.RectInRegion(const R: TpgBox): boolean;
begin
  raise Exception.Create(sNotImplemented);
end;

function TpgPolyPolygonRegion.RegionType: TpgRegionType;
begin
  Result := rtPolyPolygon;
end;

{ TpgPathRegion }

function TpgPathRegion.BoundingBox: TpgBox;
begin
  raise Exception.Create(sNotImplemented);
end;

procedure TpgPathRegion.Clear;
begin
  if assigned(FPath) then FPath.Clear;
end;

destructor TpgPathRegion.Destroy;
begin
  FreeAndNil(FPath);
  inherited;
end;

function TpgPathRegion.PointInRegion(X, Y: single): boolean;
begin
  raise Exception.Create(sNotImplemented);
end;

function TpgPathRegion.RectInRegion(const R: TpgBox): boolean;
begin
  raise Exception.Create(sNotImplemented);
end;

function TpgPathRegion.RegionType: TpgRegionType;
begin
  Result := rtPath;
end;

{ TpgBitmapRegion }

function TpgBitmapRegion.BoundingBox: TpgBox;
begin
  raise Exception.Create(sNotImplemented);
end;

function TpgBitmapRegion.PointInRegion(X, Y: single): boolean;
begin
  raise Exception.Create(sNotImplemented);
end;

function TpgBitmapRegion.RectInRegion(const R: TpgBox): boolean;
begin
  raise Exception.Create(sNotImplemented);
end;

function TpgBitmapRegion.RegionType: TpgRegionType;
begin
  Result := rtBitmap;
end;

end.
