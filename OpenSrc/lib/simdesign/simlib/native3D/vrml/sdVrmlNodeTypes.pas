unit sdVrmlNodeTypes;
{

  TsdVrmlNode descendant types

}
interface

uses
  Classes, SysUtils, sdVrmlFormat, sdTokenizer, sdStreamWriter, sdPoints3D;

type

  // VRML group node, the Nodes property contains subnodes
  TsdVrmlGroup = class(TsdVrmlNode)
  private
    FNodes: TsdVrmlNodeList;
  protected
    function GetNodeCount: integer; override;
    procedure SaveToStreamWriter(W: TsdStreamWriter); override;
  public
    constructor Create(AParent: TsdVrmlNode); override;
    destructor Destroy; override;
    property Nodes: TsdVrmlNodeList read FNodes;
  end;

  TsdVrmlShapeHints = class(TsdVrmlNode)
  private
    FVertexOrdering: string;
    FShapeType: string;
    FFaceType: string;
  protected
    procedure ProcessInnerVRML(T: TsdTokenizer; var AID: TsdVrmlTokenID); override;
    procedure SaveToStreamWriter(W: TsdStreamWriter); override;
  public
    property VertexOrdering: string read FVertexOrdering write FVertexOrdering;
    property ShapeType: string read FShapeType write FShapeType;
    property Facetype: string read FFaceType write FFaceType;
  end;

  TsdVrmlPerspectiveCamera = class(TsdVrmlNode)
  private
    FPosition: TsdPoint3D;
    FOrientation: TsdVector4D;
    FFocalDistance: double;
    FHeightAngle: double;
    function GetOrientation: PsdVector4D;
    function GetPosition: PsdPoint3D;
  protected
    procedure ProcessInnerVRML(T: TsdTokenizer; var AID: TsdVrmlTokenID); override;
    procedure SaveToStreamWriter(W: TsdStreamWriter); override;
  public
    property Position: PsdPoint3D read GetPosition;
    property Orientation: PsdVector4D read GetOrientation;
    property FocalDistance: double read FFocalDistance write FFocalDistance;
    property HeightAngle: double read FHeightAngle write FHeightAngle;
  end;

  TsdVrmlBaseTransform = class(TsdVrmlNode)
  private
    FMatrix: TsdMatrix3x4;
  protected
    function GetMatrix: PsdMatrix3x4; virtual;
  public
    property Matrix: PsdMatrix3x4 read GetMatrix;
  end;

  TsdVrmlTransform = class(TsdVrmlBaseTransform)
  private
    FTranslation: TsdPoint3D;
    FRotation: TsdVector4D;
    FScaleFactor: TsdPoint3D;
    FScaleOrientation: TsdVector4D;
    FCenter: TsdPoint3D;
  protected
    function GetMatrix: PsdMatrix3x4; override;
    procedure ProcessInnerVRML(T: TsdTokenizer; var AID: TsdVrmlTokenID); override;
    procedure SaveToStreamWriter(W: TsdStreamWriter); override;
  public
    constructor Create(AParent: TsdVrmlNode); override;
  end;

  TsdVrmlMatrixTransform = class(TsdVrmlBaseTransform)
  protected
    procedure ProcessInnerVRML(T: TsdTokenizer; var AID: TsdVrmlTokenID); override;
    procedure SaveToStreamWriter(W: TsdStreamWriter); override;
  public
  end;

  TsdVrmlScale = class(TsdVrmlBaseTransform)
  protected
    procedure ProcessInnerVRML(T: TsdTokenizer; var AID: TsdVrmlTokenID); override;
    procedure SaveToStreamWriter(W: TsdStreamWriter); override;
  end;

  TsdVrmlRotation = class(TsdVrmlBaseTransform)
  protected
    procedure ProcessInnerVRML(T: TsdTokenizer; var AID: TsdVrmlTokenID); override;
    procedure SaveToStreamWriter(W: TsdStreamWriter); override;
  end;

  TsdVrmlTranslation = class(TsdVrmlBaseTransform)
  protected
    procedure ProcessInnerVRML(T: TsdTokenizer; var AID: TsdVrmlTokenID); override;
    procedure SaveToStreamWriter(W: TsdStreamWriter); override;
  end;

  TsdVrmlMaterial = class(TsdVrmlNode)
  private
    FDiffuseColor: TsdPoint3DDynArray;
    FTransparency: TDoubleDynArray;
    function GetDiffuseColor(Index: integer): PsdPoint3D;
    function GetTransparency(Index: integer): double;
  protected
    procedure ProcessInnerVRML(T: TsdTokenizer; var AID: TsdVrmlTokenID); override;
    procedure SaveToStreamWriter(W: TsdStreamWriter); override;
  public
    property DiffuseColor[Index: integer]: PsdPoint3D read GetDiffuseColor;
    property Transparency[Index: integer]: double read GetTransparency;
  end;

  TsdVrmlMaterialBinding = class(TsdVrmlNode)
  end;

  TsdVrmlCoordinate3 = class(TsdVrmlNode)
  private
    FPoint: TsdPoint3DDynArray;
  protected
    procedure ProcessInnerVRML(T: TsdTokenizer; var AID: TsdVrmlTokenID); override;
    procedure SaveToStreamWriter(W: TsdStreamWriter); override;
  public
    property Point: TsdPoint3DDynArray read FPoint;
  end;

  TsdVrmlIndexedFaceSet = class(TsdVrmlNode)
  private
    FCoordIndex: TIntegerDynArray;
    FMaterialIndex: TIntegerDynArray;
  protected
    procedure ProcessInnerVRML(T: TsdTokenizer; var AID: TsdVrmlTokenID); override;
    procedure SaveToStreamWriter(W: TsdStreamWriter); override;
  public
    function HasMaterialIndex: boolean;
    property CoordIndex: TIntegerDynArray read FCoordIndex;
    property MaterialIndex: TIntegerDynArray read FMaterialIndex;
  end;

  TsdVrmlSphere = class(TsdVrmlNode)
  private
    FRadius: double;
  protected
    procedure ProcessInnerVRML(T: TsdTokenizer; var AID: TsdVrmlTokenID); override;
    procedure SaveToStreamWriter(W: TsdStreamWriter); override;
  public
    constructor Create(AParent: TsdVrmlNode); override;
    property Radius: double read FRadius write FRadius;
  end;

  TsdVrmlCube = class(TsdVrmlNode)
  private
    FHeight: double;
    FDepth: double;
    FWidth: double;
  protected
    procedure ProcessInnerVRML(T: TsdTokenizer; var AID: TsdVrmlTokenID); override;
    procedure SaveToStreamWriter(W: TsdStreamWriter); override;
  public
    constructor Create(AParent: TsdVrmlNode); override;
    property Width: double read FWidth write FWidth;
    property Height: double read FHeight write FHeight;
    property Depth: double read FDepth write FDepth;
  end;

  TsdVrmlFontSize = class(TsdVrmlNode)
  end;

  TsdVrmlFontStyle = class(TsdVrmlNode)
  end;

  TsdVrmlAsciiText = class(TsdVrmlNode)
  end;

  TsdVrmlInfo = class(TsdVrmlNode)
  end;

  TsdVrmlDirectionalLight = class(TsdVrmlNode)
  end;

implementation

type
  TNodeAccess = class(TsdVrmlNode);

{ TsdVrmlGroup }

constructor TsdVrmlGroup.Create(AParent: TsdVrmlNode);
begin
  inherited;
  FNodes := TsdVrmlNodeList.Create(True);
end;

destructor TsdVrmlGroup.Destroy;
begin
  FreeAndNil(FNodes);
  inherited;
end;

function TsdVrmlGroup.GetNodeCount: integer;
begin
  Result := FNodes.Count;
end;

procedure TsdVrmlGroup.SaveToStreamWriter(W: TsdStreamWriter);
var
  i: integer;
begin
  inherited;
  W.WriteLn('Separator {');
  W.IncIndent;
  for i := 0 to FNodes.Count - 1 do
    TNodeAccess(FNodes[i]).SaveToStreamWriter(W);
  W.DecIndent;
  W.WriteIndentLn('}');
end;

{ TsdVrmlShapeHints }

procedure TsdVrmlShapeHints.ProcessInnerVRML(T: TsdTokenizer; var AID: TsdVrmlTokenID);
begin
  case AID of
  ctiVertexOrdering:
    VertexOrdering := T.ReadSymbol;
  ctiShapeType:
    ShapeType := T.ReadSymbol;
  ctiFaceType:
    FaceType := T.ReadSymbol;
  end;
end;

procedure TsdVrmlShapeHints.SaveToStreamWriter(W: TsdStreamWriter);
begin
  inherited;
  W.WriteLn('ShapeHints {');
  W.IncIndent;
  W.WriteIndentLn('vertexOrdering ' + FVertexOrdering);
  W.WriteIndentLn('shapeType ' + FShapeType);
  W.WriteIndentLn('faceType ' + FFaceType);
  W.DecIndent;
  W.WriteIndentLn('}');
end;

{ TsdVrmlPerspectiveCamera }

function TsdVrmlPerspectiveCamera.GetOrientation: PsdVector4D;
begin
  Result := @FOrientation;
end;

function TsdVrmlPerspectiveCamera.GetPosition: PsdPoint3D;
begin
  Result := @FPosition;
end;

procedure TsdVrmlPerspectiveCamera.ProcessInnerVRML(T: TsdTokenizer; var AID: TsdVrmlTokenID);
var
  Elements: TDoubleDynArray;
begin
  case AID of
  ctiPosition:
    begin
      ReadPoint3D(T, FPosition);
      AID := TsdVrmlTokenID(T.LastToken);
    end;
  ctiOrientation:
    begin
      ReadDoubleArray(T, Elements);
      FOrientation.X := Elements[0];
      FOrientation.Y := Elements[1];
      FOrientation.Z := Elements[2];
      FOrientation.W := Elements[3];
      AID := TsdVrmlTokenID(T.LastToken);
    end;
  ctiFocalDistance:
    begin
      ReadDouble(T, FFocalDistance);
      AID := TsdVrmlTokenID(T.LastToken);
    end;
  ctiHeightAngle:
    begin
      ReadDouble(T, FHeightAngle);
      AID := TsdVrmlTokenID(T.LastToken);
    end;
  end;
end;

procedure TsdVrmlPerspectiveCamera.SaveToStreamWriter(W: TsdStreamWriter);
var
  S: string;
begin
  inherited;
  W.WriteLn('PerspectiveCamera {');
  W.IncIndent;
  W.WriteIndent('position');
  WritelnPoint3D(W, FPosition);
  W.WriteIndent('orientation');
  WritelnVector4D(W, FOrientation);
  S := sdWriteNumber(FFocalDistance, 6, True);
  W.WriteIndentLn('focalDistance ' + S);
  S := sdWriteNumber(FHeightAngle, 6, True);
  W.WriteIndentLn('heightAngle ' + S);
  W.DecIndent;
  W.WriteIndentLn('}');
end;

{ TsdVrmlBaseTransform }

function TsdVrmlBaseTransform.GetMatrix: PsdMatrix3x4;
begin
  Result := @FMatrix;
end;

{ TsdVrmlTransform }

constructor TsdVrmlTransform.Create(AParent: TsdVrmlNode);
begin
  inherited;
  // defaults
  FScaleFactor.X := 1;
  FscaleFactor.Y := 1;
  FScaleFactor.Z := 1;
  FRotation.Z := 1;
  FScaleOrientation.Z := 1;
end;

function TsdVrmlTransform.GetMatrix: PsdMatrix3x4;
var
  M: TsdMatrix3x4;
begin
  // We need to calculate the resulting matrix first. See VRML spec pg 25
  M := TranslationMatrix(FTranslation.X, FTranslation.Y, FTranslation.Z);
  FMatrix := M;
  M := TranslationMatrix(FCenter.X, FCenter.Y, FCenter.Z);
  FMatrix := MultiplyMatrix3x4(FMatrix, M);
  M := RotationMatrixAxis(FRotation.X, FRotation.Y, FRotation.Z, FRotation.W);
  FMatrix := MultiplyMatrix3x4(FMatrix, M);
  M := RotationMatrixAxis(FScaleOrientation.X, FScaleOrientation.Y, FScaleOrientation.Z, FScaleOrientation.W);
  FMatrix := MultiplyMatrix3x4(FMatrix, M);
  M := ScalingMatrix(FScaleFactor.X, FScaleFactor.Y, FScaleFactor.Z);
  FMatrix := MultiplyMatrix3x4(FMatrix, M);
  M := RotationMatrixAxis(FScaleOrientation.X, FScaleOrientation.Y, FScaleOrientation.Z, -FScaleOrientation.W);
  FMatrix := MultiplyMatrix3x4(FMatrix, M);
  M := TranslationMatrix(-FCenter.X, -FCenter.Y, -FCenter.Z);
  FMatrix := MultiplyMatrix3x4(FMatrix, M);
  // Now return result
  Result := @FMatrix;
end;

procedure TsdVrmlTransform.ProcessInnerVRML(T: TsdTokenizer; var AID: TsdVrmlTokenID);
var
  Elements: TDoubleDynArray;
begin
  case AID of
  ctiTranslation2:
    begin
      ReadDoubleArray(T, Elements);
      FTranslation.X := Elements[0];
      FTranslation.Y := Elements[1];
      FTranslation.Z := Elements[2];
      AID := TsdVrmlTokenID(T.LastToken);
    end;
  ctiRotation2:
    begin
      ReadDoubleArray(T, Elements);
      FRotation.X := Elements[0];
      FRotation.Y := Elements[1];
      FRotation.Z := Elements[2];
      FRotation.W := Elements[3];
      AID := TsdVrmlTokenID(T.LastToken);
    end;
  ctiScaleFactor:
    begin
      ReadDoubleArray(T, Elements);
      FScaleFactor.X := Elements[0];
      FScaleFactor.Y := Elements[1];
      FScaleFactor.Z := Elements[2];
      AID := TsdVrmlTokenID(T.LastToken);
    end;
  ctiScaleOrientation:
    begin
      ReadDoubleArray(T, Elements);
      FScaleOrientation.X := Elements[0];
      FScaleOrientation.Y := Elements[1];
      FScaleOrientation.Z := Elements[2];
      FScaleOrientation.W := Elements[3];
      AID := TsdVrmlTokenID(T.LastToken);
    end;
  ctiCenter:
    begin
      ReadDoubleArray(T, Elements);
      FCenter.X := Elements[0];
      FCenter.Y := Elements[1];
      FCenter.Z := Elements[2];
      AID := TsdVrmlTokenID(T.LastToken);
    end;
  end;
end;

procedure TsdVrmlTransform.SaveToStreamWriter(W: TsdStreamWriter);
begin
  inherited;
  raise Exception.Create('not implemented');
end;

{ TsdVrmlScale }

procedure TsdVrmlScale.ProcessInnerVRML(T: TsdTokenizer; var AID: TsdVrmlTokenID);
var
  Elements: TDoubleDynArray;
begin
  case AID of
  ctiScaleFactor:
    begin
      ReadDoubleArray(T, Elements);
      FMatrix := ScalingMatrix(Elements[0], Elements[1], Elements[2]);
      AID := TsdVrmlTokenID(T.LastToken);
    end;
  end;
end;

procedure TsdVrmlScale.SaveToStreamWriter(W: TsdStreamWriter);
begin
  inherited;
  raise Exception.Create('not implemented');
end;

{ TsdVrmlRotation }

procedure TsdVrmlRotation.ProcessInnerVRML(T: TsdTokenizer; var AID: TsdVrmlTokenID);
var
  Elements: TDoubleDynArray;
begin
  case AID of
  ctiRotation2:
    begin
      ReadDoubleArray(T, Elements);
      FMatrix := RotationMatrixAxis(Elements[0], Elements[1], Elements[2], Elements[3]);
      AID := TsdVrmlTokenID(T.LastToken);
    end;
  end;
end;

procedure TsdVrmlRotation.SaveToStreamWriter(W: TsdStreamWriter);
begin
  inherited;
  raise Exception.Create('not implemented');
end;

{ TsdVrmlTranslation }

procedure TsdVrmlTranslation.ProcessInnerVRML(T: TsdTokenizer; var AID: TsdVrmlTokenID);
var
  Elements: TDoubleDynArray;
begin
  case AID of
  ctiTranslation2:
    begin
      ReadDoubleArray(T, Elements);
      FMatrix := TranslationMatrix(Elements[0], Elements[1], Elements[2]);
      AID := TsdVrmlTokenID(T.LastToken);
    end;
  end;
end;

procedure TsdVrmlTranslation.SaveToStreamWriter(W: TsdStreamWriter);
begin
  inherited;
  raise Exception.Create('not implemented');
end;

{ TsdVrmlMatrixTransform }

procedure TsdVrmlMatrixTransform.ProcessInnerVRML(T: TsdTokenizer; var AID: TsdVrmlTokenID);
var
  r, c: integer;
  Elements: TDoubleDynArray;
begin
  case AID of
  ctiMatrix:
    begin
      ReadDoubleArray(T, Elements);
      for r := 0 to 2 do
        for c := 0 to 3 do
          FMatrix[r, c] := Elements[r * 4 + c];
      AID := TsdVrmlTokenID(T.LastToken);
    end;
  end;
end;

procedure TsdVrmlMatrixTransform.SaveToStreamWriter(W: TsdStreamWriter);
begin
  inherited;
  W.WriteLn('MatrixTransform {');
  W.IncIndent;
  // todo
  W.DecIndent;
  W.WriteIndentLn('}');
end;

{ TsdVrmlMaterial }

function TsdVrmlMaterial.GetDiffuseColor(Index: integer): PsdPoint3D;
begin
  if (Index >= 0) and (Index < length(FDiffuseColor)) then
    Result := @FDiffuseColor[Index]
  else
    Result := nil;
end;

function TsdVrmlMaterial.GetTransparency(Index: integer): double;
begin
  if (Index >= 0) and (Index < length(FTransparency)) then
    Result := FTransparency[Index]
  else
    Result := 0;
end;

procedure TsdVrmlMaterial.ProcessInnerVRML(T: TsdTokenizer; var AID: TsdVrmlTokenID);
begin
 case AID of
 ctiDiffuseColor:
   begin
      ReadPoint3DArray(T, FDiffuseColor);
      AID := TsdVrmlTokenID(T.LastToken);
   end;
 ctiTransparency:
   begin
     ReadDoubleArray(T, FTransparency);
     AID := TsdVrmlTokenID(T.LastToken);
   end;
 end;
end;

procedure TsdVrmlMaterial.SaveToStreamWriter(W: TsdStreamWriter);
begin
  inherited;
  W.WriteLn('Material {');
  W.IncIndent;
  // todo
  W.DecIndent;
  W.WriteIndentLn('}');
end;

{ TsdVrmlCoordinate3 }

procedure TsdVrmlCoordinate3.ProcessInnerVRML(T: TsdTokenizer; var AID: TsdVrmlTokenID);
begin
  case AID of
  ctiPoint:
    begin
      ReadPoint3DArray(T, FPoint);
      AID := TsdVrmlTokenID(T.LastToken);
    end;
  end;
end;

procedure TsdVrmlCoordinate3.SaveToStreamWriter(W: TsdStreamWriter);
begin
  inherited;
  W.WriteLn('Coordinate3 {');
  W.IncIndent;
  // todo
  W.DecIndent;
  W.WriteIndentLn('}');
end;

{ TsdVrmlIndexedFaceSet }

function TsdVrmlIndexedFaceSet.HasMaterialIndex: boolean;
begin
  Result := length(FMaterialIndex) > 0;
end;

procedure TsdVrmlIndexedFaceSet.ProcessInnerVRML(T: TsdTokenizer; var AID: TsdVrmlTokenID);
begin
  case AID of
  ctiCoordIndex:
    ReadIntegerArray(T, FCoordIndex);
  ctiMaterialIndex:
    ReadIntegerArray(T, FMaterialIndex);
  end;
end;

procedure TsdVrmlIndexedFaceSet.SaveToStreamWriter(W: TsdStreamWriter);
begin
  inherited;

end;

{ TsdVrmlSphere }

constructor TsdVrmlSphere.Create(AParent: TsdVrmlNode);
begin
  inherited;
  // Defaults
  FRadius := 1.0;
end;

procedure TsdVrmlSphere.ProcessInnerVRML(T: TsdTokenizer; var AID: TsdVrmlTokenID);
begin
  case AID of
  ctiRadius:
    begin
      ReadDouble(T, FRadius);
      AID := TsdVrmlTokenID(T.LastToken);
    end;
  end;
end;

procedure TsdVrmlSphere.SaveToStreamWriter(W: TsdStreamWriter);
begin
  inherited;
  raise Exception.Create('not implemented');
end;

{ TsdVrmlCube }

constructor TsdVrmlCube.Create(AParent: TsdVrmlNode);
begin
  inherited;
  // Defaults
  FWidth := 2.0;
  FHeight := 2.0;
  FDepth := 2.0;
end;

procedure TsdVrmlCube.ProcessInnerVRML(T: TsdTokenizer; var AID: TsdVrmlTokenID);
begin
  case AID of
  ctiWidth:
    begin
      ReadDouble(T, FWidth);
      AID := TsdVrmlTokenID(T.LastToken);
    end;
  ctiHeight:
    begin
      ReadDouble(T, FHeight);
      AID := TsdVrmlTokenID(T.LastToken);
    end;
  ctiDepth:
    begin
      ReadDouble(T, FDepth);
      AID := TsdVrmlTokenID(T.LastToken);
    end;
  end;
end;

procedure TsdVrmlCube.SaveToStreamWriter(W: TsdStreamWriter);
begin
  inherited;
  raise Exception.Create('not implemented');
end;

end.
