{ sdScene3DPointList

  original author: Nils Haeck M.Sc.
  copyright (c) SimDesign BV (www.simdesign.nl)
}
unit sdScene3DPointList;

interface

uses
  sdScene3D, sdPoints3D, GLScene;

type

  // A list of 3D points, visualised as little dots in the 3D scene
  TsdScene3DPointList = class(TsdScene3DItem)
  private
    FPoints: TsdPoint3DDynArray;
    function GetCount: integer;
    function GetFirst: PsdPoint3D;
    procedure SetCount(const Value: integer);
  protected
    procedure SetVisible(const Value: boolean); override;
    procedure UpdateGlSceneObject; override;
    procedure BuildGLSceneObject(AGLParent: TGLBaseSceneObject); override;
  public
    procedure Clear; override;
    function BoundingBox(var ABox: TsdBox3D): boolean; override;
    procedure HardTransform(const ATransform: TsdMatrix3x4); override;
    procedure AddPoints(AFirst: PsdPoint3D; ACount: integer);
    procedure SetPoints(AFirst: PsdPoint3D; ACount: integer);
    property Points: TsdPoint3DDynArray read FPoints;
    property First: PsdPoint3D read GetFirst;
    property Count: integer read GetCount write SetCount;
  end;

  // A 3D polyline in the 3D scene
  TsdScene3DPolyLine = class(TsdScene3DPointList)
  private
    FIsClosed: boolean;
    procedure SetIsClosed(const Value: boolean);
  protected
    procedure SetVisible(const Value: boolean); override;
    procedure UpdateGLSceneObject; override;
    procedure BuildGLSceneObject(AGLParent: TGLBaseSceneObject); override;
  public
    property IsClosed: boolean read FIsClosed write SetIsClosed;
  end;

implementation

uses
  GLObjects;

{ TsdScene3DPointList }

procedure TsdScene3DPointList.AddPoints(AFirst: PsdPoint3D; ACount: integer);
var
  Idx: integer;
begin
  Idx := Count;
  SetLength(FPoints, Count + ACount);
  if ACount > 0 then
    Move(AFirst^, FPoints[Idx], ACount * SizeOf(TsdPoint3D));
  Invalidate;
end;

function TsdScene3DPointList.BoundingBox(var ABox: TsdBox3D): boolean;
begin
  Result := Count > 0;
  if not Result then exit;
  ABox := BoundingBox3D(First, Count);
end;

procedure TsdScene3DPointList.BuildGLSceneObject(AGLParent: TGLBaseSceneObject);
begin
  GLObject := TGLPoints.Create(AGLParent);
  AGLParent.AddChild(GLObject);
  SetVisible(Visible);
end;

procedure TsdScene3DPointList.Clear;
begin
  Count := 0;
end;

function TsdScene3DPointList.GetCount: integer;
begin
  Result := length(FPoints);
end;

function TsdScene3DPointList.GetFirst: PsdPoint3D;
begin
  if Count > 0 then
    Result := @FPoints[0]
  else
    Result := nil;
end;

procedure TsdScene3DPointList.HardTransform(
  const ATransform: TsdMatrix3x4);
begin
  TransformPoints(First, First, Count, ATransform);
  Invalidate;
end;

procedure TsdScene3DPointList.SetCount(const Value: integer);
begin
  SetLength(FPoints, Value);
end;

procedure TsdScene3DPointList.SetPoints(AFirst: PsdPoint3D;
  ACount: integer);
begin
  SetLength(FPoints, ACount);
  if ACount > 0 then
    Move(AFirst^, FPoints[0], ACount * SizeOf(TsdPoint3D));
  Invalidate;
end;

procedure TsdScene3DPointList.SetVisible(const Value: boolean);
begin
  if GLObject is TGLPoints then
    TGLPoints(GLObject).Visible := Value;
  inherited;
end;

procedure TsdScene3DPointList.UpdateGLSceneObject;
var
  i: integer;
  GP: TGLPoints;
begin
  if GLObject is TGLPoints then
  begin
    GP := TGLPoints(GLObject);
    Count := length(FPoints);
    GP.Positions.Clear;
    GP.Colors.Clear;
    for i := 0 to Count - 1 do
    begin
      GP.Positions.Add(FPoints[i].X, FPoints[i].Y, FPoints[i].Z);
      GP.Colors.Add(Color);
    end;  
    GP.StructureChanged;
  end;
end;

{ TsdScene3DPolyLine }

procedure TsdScene3DPolyLine.BuildGLSceneObject(AGLParent: TGLBaseSceneObject);
begin
  GLObject := TGLLines.Create(AGLParent);
  AGLParent.AddChild(GLObject);
  TGLLines(GLObject).NodesAspect := lnaInvisible;
  SetVisible(Visible);
end;

procedure TsdScene3DPolyLine.SetIsClosed(const Value: boolean);
begin
  if FIsClosed <> Value then begin
    FIsClosed := Value;
    Invalidate;
  end;
end;

procedure TsdScene3DPolyLine.SetVisible(const Value: boolean);
begin
  if GLObject is TGLLines then
    TGLLines(GLObject).Visible := Value;
  inherited;
end;

procedure TsdScene3DPolyLine.UpdateGLSceneObject;
var
  i: integer;
  GL: TGLLines;
begin
  if GLObject is TGLLines then begin
    GL := TGLLines(GLObject);
    GL.Nodes.Clear;
    if Count > 0 then begin
      for i := 0 to Count - 1 do
        GL.Nodes.AddNode(FPoints[i].X, FPoints[i].Y, FPoints[i].Z);
      if FIsClosed then
        GL.Nodes.AddNode(FPoints[0].X, FPoints[0].Y, FPoints[0].Z);
      GL.LineColor.Color := Color;
    end;
    GL.StructureChanged;
  end;
end;

end.
