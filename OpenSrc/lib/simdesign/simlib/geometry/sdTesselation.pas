unit sdTesselation;
{
  Quick and dirty way to tesselate a polygon (split into a number of triangles).

  The polygon consists of vertices (list of 3D points) and a list of indices
  describing the polygon.

  The result will be a list of triangles, based on the same vertices. The resulting
  list contains pairs of 3 vertex indices for each triangle.

  copyright (c) 2008 by Nils Haeck
}
interface

uses
  sdPoints3D;

// Tesselate the polygon defined by the vertices in Vertices and the polygon
// indices in PolyIndices, and generate a list of triangle indices in TriIndices.
// If tesselation succeeds, the function result is True.
function TesselatePolygon(const Vertices: TsdPoint3DDynArray;
  PolyIndices, TriIndices: TsdIntegerList): boolean;

implementation

type

  TsdMatrix3x3 = array[0..2] of TsdPoint3D;

function MatrixDeterminant3x3(const M: TsdMatrix3x3): double;
begin
  Result :=  M[0].X * (M[1].Y * M[2].Z - M[2].Y * M[1].Z)
           - M[0].Y * (M[1].X * M[2].Z - M[2].X * M[1].Z)
           + M[0].Z * (M[1].X * M[2].Y - M[2].X * M[1].Y);
end;

// TesselatePolygon is adapted from the one in GlFileVRML.pas
function TesselatePolygon(const Vertices: TsdPoint3DDynArray;
  PolyIndices, TriIndices: TsdIntegerList): boolean;

  // local
  function IsPolyClockWise: Boolean;
  var
    i, j: Integer;
    Det: Single;
    Mat: TsdMatrix3x3;
  begin
    Det := 0;
    for i := 0 to PolyIndices.Count - 1 do
    begin
      for j := 0 to 2 do
        if (i + j) >= PolyIndices.Count then
          Mat[j] := Vertices[PolyIndices[i + j - PolyIndices.Count]]
        else
          Mat[j] := Vertices[PolyIndices[i + j]];
      Det := Det + MatrixDeterminant3x3(Mat);
    end;
    Result := (Det < 0);
  end;

  // local
  function IsTriClockWise(const v0, v1, v2: TsdPoint3D): Boolean;
  var
    Mat: TsdMatrix3x3;
  begin
    Mat[0] := v0;
    Mat[1] := v1;
    Mat[2] := v2;
    Result:= MatrixDeterminant3x3(Mat) < 0;
  end;

  // local
  function PointInTriangle(const p, v0, v1, v2: TsdPoint3D;
    IsClockWise: Boolean = False): Boolean;
  begin
    Result := not ((IsTriClockWise(v1, v0, p) = IsClockWise) or
                   (IsTriClockWise(v0, v2, p) = IsClockWise) or
                   (IsTriClockWise(v2, v1, p) = IsClockWise));
  end;

// main
var
  i, j,
  Prev, Next,
  MinVert, MinPrev, MinNext: integer;
  PolyCW, NoPointsInTriangle, First: boolean;
  V: TsdMatrix3x3;
  Temp: TsdIntegerList;
  MinDist, D, Area: double;
begin
  Result := True;
  Temp := TsdIntegerList.Create;
  try
    PolyCW := IsPolyClockWise;
    Temp.Assign(PolyIndices);
    while Temp.Count > 3 do
    begin
      First := True;
      MinDist := 0;
      MinVert := -1;
      MinPrev := -1;
      MinNext := -1;
      for i := 0 to Temp.Count - 1 do
      begin
        Prev := i - 1;
        Next := i + 1;
        if Prev < 0 then
          Prev := Temp.Count - 1;
        if Next > Temp.Count - 1 then
          Next := 0;
        V[0] := Vertices[Temp[Prev]];
        V[1] := Vertices[Temp[i]];
        V[2] := Vertices[Temp[Next]];
        if IsTriClockWise(V[0], V[1], V[2]) = PolyCW then
        begin
          NoPointsInTriangle := True;
          for j := 0 to Temp.Count - 1 do
          begin
            if (j <> i) and (j <> Prev) and (j <> Next) then
            begin
              if PointInTriangle(Vertices[Temp[j]], V[0], V[1], V[2], PolyCW) then
              begin
                NoPointsInTriangle := False;
                Break;
              end;
            end;
          end;

          Area := TriangleArea3D(V[0], V[1], V[2]);

          if NoPointsInTriangle and (Area > 0) then
          begin
            D := SquaredDist3D(V[0], V[2]);
            if First or (D < MinDist) then
            begin
              First := False;
              MinDist := D;
              MinPrev := Prev;
              MinVert := i;
              MinNext := Next;
            end;
          end;
        end;
      end;
      if MinVert = -1 then
      begin
        Result := False;
        exit;
      end else
      begin
        TriIndices.Add3(Temp[MinPrev], Temp[MinVert], Temp[MinNext]);
        Temp.Delete(MinVert);
      end;
    end;
    TriIndices.Add3(Temp[0], Temp[1], Temp[2]);
  finally
    Temp.Free;
  end;
end;

end.
