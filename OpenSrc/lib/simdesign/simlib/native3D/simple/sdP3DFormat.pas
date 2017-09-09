{ simple Point3D format (P3D) using X Y Z per line

  The only geometric 3D objects are 3D pointclouds so far

  author: Nils Haeck M.Sc.
  date: 29nov2010
  copyright (c) 2010 SimDesign BV - www.simdesign.nl
}
unit sdP3DFormat;

interface

uses
  Classes, SysUtils, sdPoints3D, sdDebug;

type

  TsdP3DFormat = class(TDebugPersistent)
  private
    FVertices: array of TsdPoint3D;
  public
    procedure Clear; virtual;
    procedure CopyVertices(First: PsdPoint3D; Count: integer); virtual;
    // load the vertices, returns vertex count
    function LoadVerticesFromFile(const FileName: Utf8String): integer; virtual;
  end;

implementation

{ TsdP3DFormat }

procedure TsdP3DFormat.Clear;
begin
  SetLength(FVertices, 0);
end;

procedure TsdP3DFormat.CopyVertices(First: PsdPoint3D; Count: integer);
var
  i: integer;
begin
  for i := 0 to Count - 1 do
  begin
    First^ := FVertices[i];
    inc(First);
  end;
end;

function TsdP3DFormat.LoadVerticesFromFile(const FileName: Utf8String): integer;
var
  i, APos: integer;
  X, Y, Z: double;
  S: TStringList;
  Line: string;
  P: PsdPoint3D;
  Count: integer;
begin
  S := TStringList.Create;
  try
    Result := 0;
    S.LoadFromFile(FileName);
    SetLength(FVertices, S.Count);
    if length(FVertices) = 0 then
      exit;
    Count := 0;
    P := @FVertices[0];
    for i := 0 to S.Count - 1 do
    begin
      Line := S[i];
      Line := Trim(StringReplace(Line, #9, ' ', [rfReplaceAll]));
      if length(Line) = 0 then
        continue;
      try
        // tab-delimited
        APos := Pos(' ', Line);
        if APos < 2 then
          continue;
        // X coord
        X := StrToFloat(copy(Line, 1, APos - 1));
        Line := Trim(copy(Line, APos + 1, length(Line)));
        APos := Pos(' ', Line);
        if APos < 2 then
          continue;
        // Y coord
        Y := StrToFloat(copy(Line, 1, APos - 1));
        Line := Trim(copy(Line, APos + 1, length(Line)));
        if length(Line) = 0 then
          continue;
        // Z coord
        Z := StrToFloat(Line);
        P^ := Point3D(X, Y, Z);
        inc(P);
        inc(Count);
      except
        // silent exception in string conversion
      end;
    end;
    // Set length again
    SetLength(FVertices, Count);
    Result := Count;
  finally
    S.Free;
  end;
end;

end.
