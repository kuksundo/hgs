{ Project: Pyro
  Module: Pyro Render

  Description:
  Rasterization of polygons. This unit contains a high-performant and anti-aliased
  scan conversion algorithm. This algorithm takes a polygon list and converts it
  into a number of spans with anti-aliased coverage of pixels. It also takes
  care of transforming and clipping the polygon list. The polygon list consists
  of a collection of polygons, which should be closed, and consist of points
  with single-precision coordinates.

  The anti-aliasing depends on cFixedPrecision (pgAntiAliasings unit). Set
  AntiAliasing beforehand using function pgSetAntiAliasing in Pyro.pas.

  Scan-conversion can be done with Even/Odd (alternating) or Non-zero winding
  fill rule.

  This new version of the rasterizer is less dependent on AA settings. It first
  detects all intersections and determines the edges to render, then renders
  each edge in pixel space, instead of fixed space as the old version did. The
  AA settings only influence the number of unique lines found, not so much
  the rendering of the lines.

  TODO: the rasterizer should not depend on pgTransform, because pgTransform
  depends on pgDocument, thus the scene. The rasterizer should ideally just
  depend on these stand-alone Pyro units: pgCover, pgGeometry and pgPolygon

  TODO: the rasterizer should use floating point math instead of fixed point
  math (see Mattias Anderson's VPR as example)

  Author: Nils Haeck (n.haeck@simdesign.nl)
  Copyright (c) 2004 - 2011 SimDesign BV
}
unit pgPolygonRasterizer;

{$i simdesign.inc}

interface

uses
  Classes, SysUtils, Contnrs, sdSortedLists,
  pgCover, pgGeometry, pgPolygon, Pyro;

type

  // Vertex with fixed coordinates (non-negative)
  TpgVertex = record
    X: integer;
    Y: integer;
  end;

  // Segment containing refs to Top and Btm vertices
  TpgSegment = class
  private
    VTop: TpgVertex; // Topmost vertex (smallest Y)
    RTop: TpgVertex; // Render start position
    VBtm: TpgVertex; // Bottommost vertex (largest Y)
    RBtm: TpgVertex; // Render close position
    FDir: integer;
    FRenderRes: integer;
    FSlope: double; // Slope Dx/Dy
    FIsRendered: boolean;
  public
    procedure CalculateSlope;
    procedure Restore;
    // Direction (1 is downwards (increasing Y), -1 is upwards)
    property Dir: integer read FDir write FDir;
  end;

  // List of segments
  TpgSegmentList = class(TCustomSortedList)
  private
    function GetItems(Index: integer): TpgSegment;
    procedure SetItems(Index: integer; const Value: TpgSegment);
  protected
    function DoCompare(Item1, Item2: TObject): integer; override;
  public
    property Items[Index: integer]: TpgSegment read GetItems write SetItems; default;
  end;

  // List of intervals
  TpgIntervalList = class(TCustomSortedList)
  private
    function GetItems(Index: integer): TpgSegment;
  protected
    function DoCompare(Item1, Item2: TObject): integer; override;
  public
    property Items[Index: integer]: TpgSegment read GetItems; default;
  end;

  // A cell holds delta changes to the scanline, at position x+0 and x+1. The
  // cells are arranged in a circularly linked list.
  PpgCell = ^TpgCell;
  TpgCell = record
    X: integer;  // Pixel position of cell
    D0: integer; // Delta increase cell X+0
    D1: integer; // Delta increase cell X+1
    Next: PpgCell; // Next cell (or pointer back to first)
  end;

  // List of cell records
  TpgCellList = class(TList)
  private
    function GetItems(Index: integer): PpgCell;
    procedure SetItems(Index: integer; const Value: PpgCell);
  public
    destructor Destroy; override;
    property Items[Index: integer]: PpgCell read GetItems write SetItems; default;
  end;

  // The rasterizer works by first clipping then adding the polygon lines as
  // segments with fixed coordinates. The segments are rendered in intervals
  // between two constant Y values. When segments overlap in Y sense, in some
  // cases, additional vertices are created. This also happens when e.g. segments
  // intersect. The AA provided by the rasterizer depends on constant cFixedBits:
  // This is the number of bits per direction. So e.g. 4 means 16 levels x 16 levels
  // equals 256 levels of AA. This is the default setting.
  TpgRasterizer = class(TPersistent)
  private
    FWidth: integer;
    FHeight: integer;
    FSegmentPool: TpgSegmentList;
    FSegmentCount: integer;
    FSegments: TpgSegmentList;
    FPolygon: TpgSegmentList;
    FProcessed: TpgIntervalList;
    FIntervals: TpgIntervalList;
    FCellPool: TpgCellList;
    FCellCount: integer;
    FRows: array of PpgCell;
    FFillRule: TpgFillRule;
    FCover: TpgCover;
    FBufferX: array of integer;
    FBufferI: array of integer;
    FBufferB: array of byte;
    FPoints: array of TpgPoint;
    function ClipMask(X, Y: single): TpgClipResults;
    procedure AddLine(const P1, P2: TpgPoint);
    function SegmentFromPool: TpgSegment;
    function CellFromPool: PpgCell;
    procedure SetCover(const Value: TpgCover);
    procedure RenderLineVertical(X0, Y0, Y1, ADelta: integer);
    procedure RenderLineXSpan(Y, Xp0, Xs0, Xp1, Xs1, Dx, ADelta: integer);
    procedure ProcessIntersection(S1, S2: TpgSegment);
    // Split segment S on vertex V, add a new segmet at the bottom, return this
    // new segment.
    function SplitSegment(S: TpgSegment; const V: TpgVertex): TpgSegment;
  protected
    // Get or add a cell at pixel location X, Y
    function CellAt(X, Y: integer): PpgCell;
    // Add a closed polygon to the segment list, given with First and Count.
    procedure AddPolygon(First: PpgPoint; Count: integer);
    // Clip and add the line built from points P1 and P2
    procedure ClipAndAddLine(var P1, P2: TpgPoint);
    // Build one interval of segments. This method is called repeatedly until
    // the segment list is empty.
    procedure ProcessInterval;
    // Process the interval generated by ProcessInterval
    procedure RenderInterval;
    // Render one segment to the cell buffer held in the Rows array
    procedure RenderSegment(S: TpgSegment; ADelta: integer);
    // Integrate the final buffer, produce coverage spans
    procedure IntegrateBuffer;
    // Setup the buffers for X span, integrator and cover values
    procedure SetupBuffers;
  public
    constructor Create;
    destructor Destroy; override;
    // Clear the rasterizer. This does not deallocate memory. The rasterizer
    // preserves objects to avoid having to reallocate them over and over again.
    procedure Clear;
    // Set the size of the buffer, this should be identical to the size of the
    // cover.
    procedure SetSize(AWidth, AHeight: integer);
    // Rasterize a list of closed polygons at once, transform them first by
    // ATransform (if given).
    procedure RasterizePolyPolygon(APolyPolygon: TpgPolyPolygon; ATransform: TpgXForm);
    // Rasterize a closed polygon in APolygon, transform the points first by
    // ATransform (if given).
    procedure RasterizePolygon(APolygon: TpgPolygon; ATransform: TpgXForm);
    // Reference to the TpgCover object that receives the coverage spans
    property Cover: TpgCover read FCover write SetCover;
    // Fillrule used for rasterizing.
    property FillRule: TpgFillRule read FFillRule write FFillRule;
  end;

implementation

{ TpgSegment }

procedure TpgSegment.CalculateSlope;
var
  Dx, Dy: integer;
begin
  Dx := VBtm.X - VTop.X;
  Dy := VBtm.Y - VTop.Y;
  FSlope := Dx / Dy;
end;

procedure TpgSegment.Restore;
begin
  RTop := VTop;
  RBtm := VBtm;
  FRenderRes := 0;
  FIsRendered := False;
  CalculateSlope;
end;

{ TpgSegmentList }

function TpgSegmentList.DoCompare(Item1, Item2: TObject): integer;
// We sort the segments by Render Top Y
begin
  Result := CompareInteger(TpgSegment(Item1).RTop.Y, TpgSegment(Item2).RTop.Y);
end;

function TpgSegmentList.GetItems(Index: integer): TpgSegment;
begin
  if (Index >= 0) and (Index < Count) then
    Result := Get(Index)
  else
    Result := nil;
end;

procedure TpgSegmentList.SetItems(Index: integer; const Value: TpgSegment);
begin
  Put(Index, Value);
end;

{ TpgIntervalList }

function TpgIntervalList.DoCompare(Item1, Item2: TObject): integer;
begin
  // First compare by RTop X
  Result := CompareInteger(TpgSegment(Item1).RTop.X, TpgSegment(Item2).RTop.X);
  // If same, compare RBtm X
  if Result = 0 then
    Result := CompareInteger(TpgSegment(Item1).RBtm.X, TpgSegment(Item2).RBtm.X);
end;

function TpgIntervalList.GetItems(Index: integer): TpgSegment;
begin
  Result := Get(Index)
end;

{ TpgCellList }

destructor TpgCellList.Destroy;
var
  i: integer;
begin
  for i := 0 to Count - 1 do
    Dispose(Items[i]);
  inherited;
end;

function TpgCellList.GetItems(Index: integer): PpgCell;
begin
  Result := Get(Index)
end;

procedure TpgCellList.SetItems(Index: integer; const Value: PpgCell);
begin
  Put(Index, Value);
end;

{ TpgRasterizer }

procedure TpgRasterizer.AddLine(const P1, P2: TpgPoint);
var
  V1, V2: TpgVertex;
  S: TpgSegment;
begin
  V1.X := round(P1.X * cFixedScale);
  V1.Y := round(P1.Y * cFixedScale);
  V2.X := round(P2.X * cFixedScale);
  V2.Y := round(P2.Y * cFixedScale);

  // Same Y?
  if V1.Y = V2.Y then
    exit;
  S := SegmentFromPool;
  if V1.Y < V2.Y then
  begin
    S.VTop := V1;
    S.VBtm := V2;
    S.Dir := 1;
  end else
  begin
    S.VTop := V2;
    S.VBtm := V1;
    S.Dir := -1;
  end;
  S.Restore;
  FPolygon.Add(S);
end;

procedure TpgRasterizer.AddPolygon(First: PpgPoint; Count: integer);
var
  i: integer;
  Ptr1, Ptr2: PpgPoint;
  P1, P2: TpgPoint;
  IsFirst: boolean;
  BB: TpgBox;
begin
  if Count < 2 then
    exit;
  FPolygon.Count := 0;

  // Add points and lines to the vertex and segment list
  IsFirst := False;
  pgUpdateBox(BB, First^, IsFirst);
  Ptr1 := First;
  Ptr2 := Ptr1; inc(Ptr2);
  for i := 0 to Count - 2 do
  begin
    P1 := Ptr1^;
    P2 := Ptr2^;
    pgUpdateBox(BB, Ptr2^, IsFirst);
    ClipAndAddLine(P1, P2);
    inc(Ptr1);
    inc(Ptr2);
  end;
  P1 := Ptr1^;
  P2 := First^;
  ClipAndAddLine(P1, P2);

  // Check bounding box
  if not pgBoxIntersects(BB, pgBox(0, 0, FWidth, FHeight)) then
    exit;

  // If we have an intersection, we add all polygons to the segment list
  for i := 0 to FPolygon.Count - 1 do
    FSegments.Add(FPolygon[i]);
end;

function TpgRasterizer.CellAt(X, Y: integer): PpgCell;
// Retrieval or addition of correct cell in circularly linked list
var
  C, Prev: PpgCell;
begin
  C := FRows[Y];
  if C <> nil then
  begin
    // First time
    if C.X < X then
    begin
      Result := CellFromPool;
      Result.Next := C.Next;
      C.Next := Result;
      Result.X := X;
      FRows[Y] := Result;
      exit;
    end else if C.X > X then
    begin
      Prev := C;
      C := C.Next;
    end else
    begin
      // C.X = X
      Result := C;
      exit;
    end;

    // Back to start of list
    repeat
      if C.X < X then
      begin
        Prev := C;
        C := C.Next;
      end else
      begin
        if C.X > X then
        begin
          Result := CellFromPool;
          Result.Next := C;
          Prev.Next := Result;
          Result.X := X;
          exit;
        end else
        begin
          // C.X = X
          Result := C;
          exit;
        end;
      end;
    until False;
  end else
  begin
    // No row yet, add
    Result := CellFromPool;
    Result.Next := Result;
    Result.X := X;
    FRows[Y] := Result;
  end;
end;

function TpgRasterizer.CellFromPool: PpgCell;
begin
  if FCellCount = FCellPool.Count then
  begin
    Result := New(PpgCell);
    FCellPool.Add(Result);
  end else
    Result := FCellPool[FCellCount];
  Result.D0 := 0;
  Result.D1 := 0;
  inc(FCellCount);
end;

procedure TpgRasterizer.Clear;
begin
  FSegmentCount := 0;
  FSegments.Count := 0;
  FCellCount := 0;
  SetLength(FRows, 0);
  SetLength(FRows, FHeight + 1);
end;

procedure TpgRasterizer.ClipAndAddLine(var P1, P2: TpgPoint);
var
  Clip1, Clip2, ClipAnd, ClipOr: TpgClipResults;
  Dx, Dy: single;
  P: TpgPoint;
begin
  // Clip masks
  Clip1 := ClipMask(P1.X, P1.Y);
  Clip2 := ClipMask(P2.X, P2.Y);
  ClipAnd := Clip1 * Clip2;

  if (ClipAnd <> []) then
  begin

    // if in area top, rgt, btm: we don't add this line
    if not (cClipLft in ClipAnd) then
      exit;

    // both in area lft: set their X coordinates to 0
    P1.X := 0;
    P2.X := 0;
    ClipAndAddLine(P1, P2);
    exit;
  end;
  ClipOr := Clip1 + Clip2;

  // Any clipping necessary?
  if ClipOr = [] then
  begin
    // No.. just add the line
    AddLine(P1, P2);
    exit;
  end;
  Dx := P2.X - P1.X;
  Dy := P2.Y - P1.Y;

  // If any point in top: clip with Y=0, and re-add
  if cClipTop in ClipOr then
  begin
    if Dy > 0 then
    begin
      P1.X := P1.X + (-P1.Y) * Dx / Dy;
      P1.Y := 0;
      ClipAndAddLine(P1, P2);
      exit;
    end;
    if Dy < 0 then
    begin
      P2.X := P2.X + (-P2.Y) * Dx / Dy;
      P2.Y := 0;
      ClipAndAddLine(P1, P2);
      exit;
    end;
  end;

  // If any point in btm: clip with Y=Height, and re-add
  if cClipBtm in ClipOr then
  begin
    if Dy < 0 then
    begin
      P1.X := P1.X + (FHeight - P1.Y) * Dx / Dy;
      P1.Y := FHeight;
      ClipAndAddLine(P1, P2);
      exit;
    end;
    if Dy > 0 then
    begin
      P2.X := P2.X + (FHeight - P2.Y) * Dx / Dy;
      P2.Y := FHeight;
      ClipAndAddLine(P1, P2);
      exit;
    end;
  end;

  // If any point in lft: clip with X=0, and add two line pieces
  if cClipLft in ClipOr then
  begin
    if Dx > 0 then
    begin
      P.Y := P1.Y + (-P1.X) * Dy / Dx;
      P.X := 0;
      P1.X := 0;
      ClipAndAddLine(P1, P);
      ClipAndAddLine(P, P2);
      exit;
    end;
    if Dx < 0 then
    begin
      P.Y := P2.Y + (-P2.X) * Dy / Dx;
      P.X := 0;
      P2.X := 0;
      ClipAndAddLine(P1, P);
      ClipAndAddLine(P, P2);
      exit;
    end;
  end;

  // If any point in rgt: clip with X=Width, and re-add
  if cClipRgt in ClipOr then
  begin
    if Dx < 0 then
    begin
      P1.Y := P1.Y + (FWidth - P1.X) * Dy / Dx;
      P1.X := FWidth;
      ClipAndAddLine(P1, P2);
      exit;
    end;
    if Dx > 0 then
    begin
      P2.Y := P2.Y + (FWidth - P2.X) * Dy / Dx;
      P2.X := FWidth;
      ClipAndAddLine(P1, P2);
      exit;
    end;
  end;
end;

function TpgRasterizer.ClipMask(X, Y: single): TpgClipResults;
begin
  Result := [];
  if X < 0       then Include(Result, cClipLft);
  if X > FWidth  then Include(Result, cClipRgt);
  if Y < 0       then Include(Result, cClipTop);
  if Y > FHeight then Include(Result, cClipBtm);
end;

constructor TpgRasterizer.Create;
var
  i: integer;
begin
  inherited Create;
  FSegmentPool := TpgSegmentList.Create(True);
  FSegmentPool.Sorted := False;
  FSegments := TpgSegmentList.Create(False);
  FPolygon := TpgSegmentList.Create(False);
  FPolygon.Sorted := False;
  FProcessed := TpgIntervalList.Create(False);
  FIntervals := TpgIntervalList.Create(False);
  FCellPool := TpgCellList.Create;

  // Create a bunch of cells, hoping they'll be allocated together
  for i := 0 to 4095 do
    FCellPool.Add(New(PpgCell));
  for i := 0 to 4095 do
    FSegmentPool.Add(TpgSegment.Create);
end;

destructor TpgRasterizer.Destroy;
begin
  FreeAndNil(FSegmentPool);
  FreeAndNil(FSegments);
  FreeAndNil(FPolygon);
  FreeAndNil(FProcessed);
  FreeAndNil(FIntervals);
  FreeAndNil(FCellPool);
  inherited;
end;

procedure TpgRasterizer.IntegrateBuffer;
var
  X, Y, Start: integer;
  C, First, Next: PpgCell;
  InSpan: boolean;
  Tot: integer;

  // local
  procedure OutputAASpan(SPos, CPos: integer);
  var
    i, Count: integer;
  begin
    // Optimize - check empty spans
    while (SPos <= CPos) and (FBufferI[SPos] = 0) do
      inc(SPos);
    while (CPos >= SPos) and (FBufferI[CPos] = 0) do
      dec(CPos);
    Count := CPos - SPos + 1;
    if Count = 0 then
      exit;

    // Optimize - check if there are any gaps
    for i := SPos + 1 to CPos - 1 do
      if FBufferI[i] = 0 then
      begin
        OutputAASpan(SPos, i - 1);
        OutputAASpan(i + 1, CPos);
        exit;
      end;

    // Convert integer buffer to byte covers
    {$R-}
    if cFixedBits <= 4 then
    begin
      for i := SPos to CPos do
        FBufferB[i] := glBufferToValueTable[FBufferI[i]]
    end else
    begin
      for i := SPos to CPos do
        FBufferB[i] := round(cLevelsToCover * FBufferI[i]);
    end;
    {$R+}

    FCover.AddAASpan(SPos, Y, Count, @FBufferB[SPos]);
  end;

  procedure OutputSolidSpan(SPos, CPos, Value: integer);
  begin
    if Value > 0 then
    begin
      {$R-}
      if cFixedBits < 4 then
        FCover.AddSolidSpan(SPos, Y, CPos - SPos + 1, glBufferToValueTable[Value])
      else
        FCover.AddSolidSpan(SPos, Y, CPos - SPos + 1, round(cLevelsToCover * Value))
      {$R+}
    end;
  end;

//main
begin

  // Loop through the rows
  for Y := 0 to FHeight - 1 do
  begin
    C := FRows[y];
    // If no data on this row.. continue
    if C = nil then
      continue;
    First := C.Next; // jump to first cell
    C := First;
    InSpan := False;
    Tot := 0;
    Start := 0;
    repeat
      Next := C.Next;
      if Next <> nil then
      begin
        if Next = First then
          Next := nil
        else
          if Next.X >= FWidth then
            Next := nil;
      end;

      X := C.X;
      if not InSpan then
      begin
        InSpan := True;
        Start := X;
      end;

      // Start putting AA data in buffer
      inc(Tot, C.D0);
      FBufferI[X    ] := Tot;
      inc(Tot, C.D1);
      FBufferI[X + 1] := Tot;

      if Next = nil then
      begin
        // Output AA span
        OutputAASpan(Start, X);
        break;
      end;
      C := Next;

      if Next.X <= X + 2 then
      begin
        continue;
      end;

      if InSpan then
      begin
        OutputAASpan(Start, X);
        OutputSolidSpan(X + 1, Next.X - 1, Tot);
        InSpan := False;
      end;

    until False;

    // Output a last span if we still have a value > 0
    if Tot > 0 then
      OutputSolidSpan(X + 1, FWidth - 1, Tot);
  end;

end;

procedure TpgRasterizer.ProcessIntersection(S1, S2: TpgSegment);
var
  Y0, Y1, X, Y: integer;
  Tx, Bx, F: double;
  V: TpgVertex;
begin
  Y0 := S1.RTop.Y;
  Y1 := S1.RBtm.Y;

  Tx := abs(S2.RTop.X - S1.RTop.X); // delta at top
  Bx := abs(S2.RBtm.X - S1.RBtm.X); // delta at btm
  F := Tx  / (Tx + Bx);

  // X point of intersection
  X := round(((S1.RTop.X + S2.RTop.X) * (1 - F) + (S1.RBtm.X + S2.RBtm.X) * F) * 0.5);
  // Y point of intersection
  Y := round(Y0 + F * (Y1 - Y0));
  if Y = Y0 then
    inc(Y);

  V.X := X;
  V.Y := Y;

  // Add two new segments
  if S1.RTop.Y > S1.VTop.Y then
    S1 := SplitSegment(S1, S1.RTop);
  SplitSegment(S1, V);
  if S2.RTop.Y > S2.VTop.Y then
    S2 := SplitSegment(S2, S2.RTop);
  SplitSegment(S2, V);

end;

procedure TpgRasterizer.ProcessInterval;
var
  S, S1, S2: TpgSegment;
  i, Idx, Y0, Y1: integer;
  V: TpgVertex;
begin
  // Get the batch of segments that share the same Y coordinate (smallest one,
  // since the list is sorted like that)
  S := FSegments[0];
  Y0 := S.RTop.Y; // Smallest Y, current rendering pos
  Y1 := S.RBtm.Y; // Next Y we render towards

  if Y0 = Y1 then
  begin
    FSegments.Delete(0);
    FProcessed.Add(S);
    exit;
  end;
  Idx := 1;
  S := FSegments[Idx];
  while assigned(S) and (S.RTop.Y = Y0) do
  begin
    if S.RBtm.Y = Y0 then
    begin
      FSegments.Delete(Idx);
      FProcessed.Add(S);
    end else
    begin
      Y1 := pgMin(Y1, S.RBtm.Y);
      inc(Idx);
    end;
    S := FSegments[Idx];
  end;
  if assigned(S) then
    Y1 := pgMin(Y1, S.RTop.Y);

  // The list from 0..Idx-1 is the interval we must process, and we process
  // from Y coordinate Y0 to Y1. This means splitting the segments on Y1
  for i := 0 to Idx - 1 do
  begin
    S := FSegments[i];
    if S.RBtm.Y <> Y1 then
    begin
      V.X := round(S.VTop.X + S.FSlope * (Y1 - S.VTop.Y));
      V.Y := Y1;
      S.RBtm.X := round(S.VTop.X + S.FSlope * (Y1 - S.VTop.Y));
      S.RBtm.Y := Y1;
    end;
  end;

  // Extract to interval list - this sorts by RTop.X then by RBtm.X
  FIntervals.Count := 0;
  for i := 0 to Idx - 1 do
    FIntervals.Add(FSegments[i]);

  // We check the interval list for a few more things
  for i := 0 to FIntervals.Count - 2 do
  begin
    S1 := FIntervals[i];
    S2 := FIntervals[i + 1];
    if (S1.RBtm.X > S2.RBtm.X) then
    begin
      // Here's an intersection.. Process it
      ProcessIntersection(S1, S2);
      // And get outta here.. we re-run
      exit;
    end;
  end;

  // We can now render the interval
  RenderInterval;

  // Now clean up segments we have used
  while (FSegments.Count > 0) do
  begin
    S := FSegments[0];
    if S.RTop.Y > Y0 then
      break;
    if S.VBtm.Y <= Y1 then
    begin
      // Done with this item
      FSegments.Delete(0);
      FProcessed.Add(S);
    end else
    begin
      // We will do RTop->RBtm, so move these, then take out and put back in
      // to re-sort
      if S.RBtm.Y = Y1 then
      begin
        S.RTop := S.RBtm;
      end else
      begin
        S.RTop.X := round(S.VTop.X + S.FSlope * (Y1 - S.VTop.Y));
        S.RTop.Y := Y1;
      end;
      S.RBtm := S.VBtm;
      FSegments.Delete(0);
      FSegments.Add(S);
    end;
  end;

end;

procedure TpgRasterizer.RasterizePolygon(APolygon: TpgPolygon; ATransform: TpgXForm);
begin
  // todo!
  // we can just create a TPolyPolygon from a TPolygon and use RasterizePolyPolygon
  raise Exception.Create('not implemented');
end;

procedure TpgRasterizer.RasterizePolyPolygon(APolyPolygon: TpgPolyPolygon;
  ATransform: TpgXForm);
var
  i: integer;
  Item: TpgPolygonItem;
  First: PpgPoint;
  S: TpgSegment;
begin
  Clear;
  if not assigned(FCover) then
    exit;
  FCover.Clear;
  SetupBuffers;

  // Add all polygons
  if assigned(ATransform) then
  begin
    // We need to transform first, we do this to the FPoints buffer
    SetLength(FPoints, pgMax(APolyPolygon.PointCount, length(FPoints)));
    ATransform.XFormPoints(APolyPolygon.FirstPoint, @FPoints[0],
      APolyPolygon.PointCount);

    // Now add the polygons from our buffered list
    for i := 0 to APolyPolygon.Count - 1 do
    begin
      Item := APolyPolygon[i];
      First := @FPoints[0];
      inc(First, Item.PointIndex);
      AddPolygon(First, Item.PointCount);
    end;
  end else
  begin
    // No transform: add the polygons directly
    for i := 0 to APolyPolygon.Count - 1 do
    begin
      Item := APolyPolygon[i];
      AddPolygon(Item.FirstPoint, Item.PointCount);
    end;
  end;

  // No segments? We can exit
  if FSegments.Count = 0 then
    exit;

  FProcessed.Count := 0;

  // Now keep processing intervals until no more segments are available
  while FSegments.Count > 0 do
    ProcessInterval;

  // Now render all processed segments
  for i := 0 to FProcessed.Count - 1 do
  begin
    S := FProcessed[i];
    if S.FRenderRes <> 0 then
      RenderSegment(S, S.FRenderRes);
  end;

  // We can now integrate the buffer
  IntegrateBuffer;
end;

procedure TpgRasterizer.RenderInterval;
// The interval list contains segments of equal length in Y, and is sorted from
// left to right. There should always be an even amount of lines, unless the
// polygon that is rendered is not closed, or the clipper clipped away lines
// at the right (which is ok).
var
  i, Winding, Res: integer;
  S: TpgSegment;
  Paint, PaintNext: boolean;
begin
  // winding number
  Winding := 0;
  Paint := False;
  for i := 0 to FIntervals.Count - 1 do
  begin
    S := FIntervals[i];
    inc(Winding, S.Dir);

    // Depending in fillrule, winding number decides to paint or not
    case FFillRule of
    frNonZero: PaintNext := Winding <> 0;
    frEvenOdd: PaintNext := odd(Winding);
    else
      PaintNext := False;
    end;

    // Is there a switch?
    if (Paint xor PaintNext) then
    begin
      if PaintNext then
        Res := 1
      else
        Res := -1;
    end else
      Res := 0;

    // Current result different from what we want?
    if S.FRenderRes <> Res then
    begin
      if S.FIsRendered then
      begin
        // The item was rendered wrongly compared to this part. Split it,
        // and get the new item (at the bottom) in S
        S := SplitSegment(S, S.RTop);
      end;

      // Now set render result
      S.FRenderRes := Res;
    end;
    S.FIsRendered := True;

    Paint := PaintNext;
  end;
end;

procedure TpgRasterizer.RenderLineVertical(X0, Y0, Y1, ADelta: integer);
var
  y, Yp0, Ys0, Yp1, Ys1: integer;
  Xp0, Xs0: integer;
  D0, D1: integer;
  C: PpgCell;
begin
  Yp0 := Y0 shr cFixedBits; // Pixel position Y0
  Ys0 := Y0 and cFixedMask;
  Yp1 := Y1 shr cFixedBits; // Pixel position Y1
  Ys1 := Y1 and cFixedMask;
  Xp0 := X0 shr cFixedBits; // Pixel position X0
  Xs0 := X0 and cFixedMask;
  D0 := ADelta * (cFixedScale - Xs0);
  D1 := ADelta * Xs0;
  C := CellAt(Xp0, Yp0);

  // Perhaps less than one full scanline?
  if Yp0 = Yp1 then
  begin
    inc(C.D0, (Ys1 - Ys0) * D0);
    inc(C.D1, (Ys1 - Ys0) * D1);
    exit;
  end;

  // complement Ys0 for coverage
  Ys0 := cFixedScale - Ys0;
  inc(C.D0, Ys0 * D0);
  inc(C.D1, Ys0 * D1);
  for y := Yp0 + 1 to Yp1 - 1 do
  begin
    C := CellAt(Xp0, y);
    inc(C.D0, D0 * cFixedScale);
    inc(C.D1, D1 * cFixedScale);
  end;
  C := CellAt(Xp0, Yp1);
  inc(C.D0, Ys1 * D0);
  inc(C.D1, Ys1 * D1);
end;

procedure TpgRasterizer.RenderLineXSpan(Y, Xp0, Xs0, Xp1, Xs1, Dx, ADelta: integer);
var
  i, N, T: integer;
  C: PpgCell;
  D, D0, D1: integer;
  Dp, Dn, Run: integer;
begin
  // Going left?
  if Xp1 < Xp0 then
  begin
    // Switch X0 and X1
    T := Xp0; Xp0 := Xp1; Xp1 := T;
    T := Xs0; Xs0 := Xs1; Xs1 := T;
    Dx := -Dx;
  end;
  Xs0 := cFixedMask - Xs0;
  D0 := (Xs0 * Xs0) div (2 * Dx);
  D1 := (Xs1 * Xs1) div (2 * Dx);
  D := cFixedScale - D0 - D1;

  if Xp1 = Xp0 + 1 then
  begin
    // spread over 3 cells
    C := CellAt(Xp0, Y);
    inc(C.D0, ADelta * D0);
    inc(C.D1, ADelta * D);
    C := CellAt(Xp1 + 1, Y);
    inc(C.D0, ADelta * D1);
    exit;
  end;

  // N > 3
  N := Xp1 - Xp0;
  FBufferX[0] := D0;
  FBufferX[N + 1] := D1;
  FBufferX[N + 2] := 0;

  // The remaining D is spread out - using Bresenham
  D1 := 0;
  if D >= N then
  begin
    // D  >= N
    Dp := D div N;
    Dn := D - Dp * N;
    Run := Dn div 2;
    for i := 1 to N do
    begin
      inc(D1, Dp);
      inc(Run, Dn);
      if Run >= N then
      begin
        inc(D1);
        dec(Run, N);
      end;
      FBufferX[i] := D1;
      D1 := 0;
    end;
  end else
  begin
    // D < N
    Run := D div 2;
    for i := 1 to N do
    begin
      inc(Run, D);
      if Run >= N then
      begin
        inc(D1);
        dec(Run, N);
      end;
      FBufferX[i] := D1;
      D1 := 0;
    end;
  end;

  // Now write duplets of cell incrementors
  for i := 0 to N + 1 do
    if not odd(i) then
    begin
      C := CellAt(Xp0 + i, Y);
      inc(C.D0, FBufferX[i    ] * ADelta);
      inc(C.D1, FBufferX[i + 1] * ADelta);
    end;
end;

procedure TpgRasterizer.RenderSegment(S: TpgSegment; ADelta: integer);
var
  Y0, Y1, Yp0, Ys0, Yp1, Ys1: integer;
  X0, X1, Xp0, Xs0, Xp1, Xs1: integer;
  x, xp, y, Df: integer;
  Xr, DxDy, DxDyS: single;

  // local, Add the X values for scanline Y with delta D to spread out
  procedure ProduceXValues(Y, D: integer);
  var
    C: PpgCell;
    Xs: integer;
  begin
    if Xp0 = Xp1 then
    begin
      // Shortcut for Xp0=Xp1
      Xs := (Xs0 + Xs1) shr 1;
      C := CellAt(Xp0, Y);
      inc(C.D0, D * (cFixedScale - Xs));
      inc(C.D1, D * Xs               );
    end else
      RenderLineXSpan(Y, Xp0, Xs0, Xp1, Xs1, x - xp, D);
  end;
  
// main
begin
  X0 := S.VTop.X;
  Y0 := S.VTop.Y;
  X1 := S.VBtm.X;
  Y1 := S.VBtm.Y;

  // Vertical line?
  if X0 = X1 then
  begin
    RenderLineVertical(X0, Y0, Y1, ADelta);
    exit;
  end;

  Yp0 := Y0 shr cFixedBits; // Pixel position Y0
  Ys0 := Y0 and cFixedMask;
  Yp1 := Y1 shr cFixedBits; // Pixel position Y1
  Ys1 := Y1 and cFixedMask;

  // Move of x for dy = 1
  DxDy := (X1 - X0) / (Y1 - Y0);

  // Pre-work
  Xr := X0;
  Xp0 := X0 shr cFixedBits;
  Xs0 := X0 and cFixedMask;
  xp := x0;

  // Just one scanline?
  if Yp0 = Yp1 then
  begin
    Xr := Xr + DxDy * (Ys1 - Ys0);
    x := round(Xr);
    Xp1 := x shr cFixedBits;
    Xs1 := x and cFixedMask;
    ProduceXValues(Yp0, ADelta * (Ys1 - Ys0));
    exit;
  end;

  // Part before first full vertical pixel
  Ys0 := cFixedScale - Ys0;
  Xr := Xr + DxDy * Ys0;
  x := round(Xr);
  Xp1 := x shr cFixedBits;
  Xs1 := x and cFixedMask;
  ProduceXValues(Yp0, ADelta * Ys0);
  Xp0 := Xp1;
  Xs0 := Xs1;
  xp := x;

  DxDyS := cFixedScale * DxDy;
  Df := ADelta * cFixedScale;

  for y := Yp0 + 1 to Yp1 - 1 do
  begin
    Xr := Xr + DxDyS;
    x := round(Xr);
    Xp1 := x shr cFixedBits;
    Xs1 := x and cFixedMask;
    ProduceXValues(y, Df);
    Xp0 := Xp1;
    Xs0 := Xs1;
    xp := x;
  end;

  // Post-work
  Xr := Xr + DxDy * Ys1;
  x := round(Xr);
  Xp1 := x shr cFixedBits;
  Xs1 := x and cFixedMask;
  ProduceXValues(Yp1, ADelta * Ys1);
end;

function TpgRasterizer.SegmentFromPool: TpgSegment;
begin
  if FSegmentCount = FSegmentPool.Count then
  begin
    Result := TpgSegment.Create;
    FSegmentPool.Add(Result);
  end else
    Result := FSegmentPool[FSegmentCount];
  inc(FSegmentCount);
end;

procedure TpgRasterizer.SetCover(const Value: TpgCover);
begin
  FCover := Value;
  SetSize(FCover.Width, FCover.Height);
end;

procedure TpgRasterizer.SetSize(AWidth, AHeight: integer);
begin
  FWidth := AWidth;
  FHeight := AHeight;
end;

procedure TpgRasterizer.SetupBuffers;
var
  Count: integer;
begin
  // Ensure we have a buffer as wide as the width (+ 2 for cell overshoot)
  Count := pgMax(length(FBufferX), FWidth + 4);
  SetLength(FBufferX, Count);
  SetLength(FBufferI, Count);
  SetLength(FBufferB, Count);
end;

function TpgRasterizer.SplitSegment(S: TpgSegment; const V: TpgVertex): TpgSegment;
begin
  // Add new segment at the bottom
  Result := SegmentFromPool;
  Result.VTop := V;
  Result.VBtm := S.VBtm;
  Result.Dir := S.Dir;
  if Result.VBtm.Y - Result.VTop.Y > 0 then
  begin
    Result.Restore;
    FSegments.Add(Result)
  end else
  begin
    dec(FSegmentCount);
    Result := nil;
  end;

  // Update the segment
  S.VBtm := V;
  S.RBtm := V;
end;

end.
