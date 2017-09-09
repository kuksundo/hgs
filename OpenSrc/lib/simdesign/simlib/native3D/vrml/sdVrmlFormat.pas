unit sdVrmlFormat;
{
  Import of 3D VRML format.

  copyright (c) 2008 by SimDesign BV

}
interface

uses
  Classes, Contnrs, SysUtils, sdTokenizer, sdStreamWriter, sdPoints3D;

type

  // Token ID's
  TsdVrmlTokenID = (
    ctiVrmlHeader,
    ctiSeparator,
    ctiGroup,
    ctiBraceOpen,
    ctiBraceClose,
    ctiSquareOpen,
    ctiSquareClose,
    ctiShape,
    ctiShapeHints,
    ctiVertexOrdering,
    ctiShapeType,
    ctiFaceType,
    ctiDef,
    ctiPerspectiveCamera,
    ctiPosition,
    ctiOrientation,
    ctiFocalDistance,
    ctiHeightAngle,
    ctiMatrixTransform,
    ctiMatrix,
    ctiMaterialBinding,
    ctiValue,
    ctiPerFaceIndexed,
    ctiMaterial,
    ctiAmbientColor,
    ctiDiffuseColor,
    ctiEmissiveColor,
    ctispecularColor,
    ctiShininess,
    ctiTransparency,
    ctiCoordinate,
    ctiCoordinate3,
    ctiPoint,
    ctiIndexedFaceSet,
    ctiCoordIndex,
    ctiMaterialIndex,
    ctiSphere,
    ctiRadius,
    ctiCube,
    ctiWidth,
    ctiHeight,
    ctiDepth,
    ctiFontStyle,
    ctiSize,
    ctiAsciiText,
    ctiString,
    ctiInfo,
    ctiScale,
    ctiScaleFactor,
    ctiRotation,
    ctiRotation2,
    ctiTranslation,
    ctiTranslation2,
    ctiTransform,
    ctiScaleOrientation,
    ctiCenter,
    ctiDirectionalLight,
    ctiTransformSeparator
  );

  TIntegerDynArray = array of integer;
  TDoubleDynArray = array of double;

  TsdVrmlNodeList = class;

  // Abstract VRML node type
  TsdVrmlNode = class
  private
    FParent: TsdVrmlNode;
    FName: string;
  protected
    procedure ProcessInnerVRML(T: TsdTokenizer; var AID: TsdVrmlTokenID); virtual;
    function GetNodeCount: integer; virtual;
    procedure ReadDouble(T: TsdTokenizer; var AValue: double);
    procedure ReadIntegerArray(T: TsdTokenizer; var AList: TIntegerDynArray);
    procedure ReadDoubleArray(T: TsdTokenizer; var AList: TDoubleDynArray);
    procedure ReadPoint3DArray(T: TsdTokenizer; var AList: TsdPoint3DDynArray);
    procedure ReadPoint3D(T: TsdTokenizer; var APoint: TsdPoint3D);
    procedure WritelnPoint3D(W: TsdStreamWriter; const APoint: TsdPoint3D);
    procedure WritelnVector4D(W: TsdStreamWriter; const AVector: TsdVector4D);
    procedure SaveToStreamWriter(W: TsdStreamWriter); virtual;
  public
    constructor Create(AParent: TsdVrmlNode); virtual;
    procedure ReadVrmlNode(T: TsdTokenizer); virtual;
    // Number of subnodes for this VRML node, returns 0 for non-group nodes
    property NodeCount: integer read GetNodeCount;
    // Name of this node (provided through the DEF statement, if any)
    property Name: string read FName write FName;
  end;

  TsdVrmlNodeClass = class of TsdVrmlNode;

  // List of VRML nodes
  TsdVrmlNodeList = class(TObjectList)
  private
    function GetItems(Index: integer): TsdVrmlNode;
  public
    property Items[Index: integer]: TsdVrmlNode read GetItems; default;
  end;

  TsdStringEvent = procedure (Sender: TObject; const AMessage: string) of object;
  
  // VRML format reader (*.wrl files). This is just a reader, does not render
  // the VRML. For the renderer, see unit sdVrmlToScene3D
  TsdVrmlFormat = class(TComponent)
  private
    FEncoding: string;
    FVersion: string;
    FNodes: TsdVrmlNodeList;
    FOnProgress: TsdStringEvent;
  protected
    procedure ReadVrmlNode(T: TsdTokenizer; ANodes: TsdVrmlNodeList; AParent: TsdVrmlNode);
    procedure TokenProgress(Sender: TObject; APosition, ASize: longint);
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure Clear;
    procedure LoadFromFile(const AFileName: string);
    procedure SaveToFile(const AFileName: string);
    procedure LoadFromStream(S: TStream);
    procedure SaveToStream(S: TStream);
    property Version: string read FVersion;
    property Encoding: string read FEncoding;
    // Hierarchical list of VRML nodes
    property Nodes: TsdVrmlNodeList read FNodes;
    property OnProgress: TsdStringEvent read FOnProgress write FOnProgress;
  end;

resourcestring

  sNoVrmlFile        = 'Not a VRML file';
  sBraceOpenExpected = '"{" expected';
  sUnsupportedVRML   = 'Unsupported VRML node: "%s"';
  sUnrecognisedVRML  = 'Unrecognised VRML: "%s"';
  sSeparatorExpected = 'Separator expected';

implementation

uses
  sdVrmlNodeTypes;

type

  TsdVrmlTokenRec = record
    Value: string;
    ID: TsdVrmlTokenID;
  end;

const

  cVrmlTokens: array[0..ord(high(TsdVrmlTokenID))] of TsdVrmlTokenRec = (
    (Value: '#VRML'; ID: ctiVrmlHeader),
    (Value: 'Separator'; ID: ctiSeparator),
    (Value: 'Group'; ID: ctiGroup),
    (Value: '{'; ID: ctiBraceOpen),
    (Value: '}'; ID: ctiBraceClose),
    (Value: '['; ID: ctiSquareOpen),
    (Value: ']'; ID: ctiSquareClose),
    (Value: 'Shape'; ID: ctiShape),
    (Value: 'ShapeHints'; ID: ctiShapeHints),
    (Value: 'vertexOrdering'; ID: ctiVertexOrdering),
    (Value: 'shapeType'; ID: ctiShapeType),
    (Value: 'faceType'; ID: ctiFaceType),
    (Value: 'DEF'; ID: ctiDef),
    (Value: 'PerspectiveCamera'; ID: ctiPerspectiveCamera),
    (Value: 'position'; ID: ctiPosition),
    (Value: 'orientation'; ID: ctiOrientation),
    (Value: 'focalDistance'; ID: ctiFocalDistance),
    (Value: 'heightAngle'; ID: ctiHeightAngle),
    (Value: 'MatrixTransform'; ID: ctiMatrixTransform),
    (Value: 'matrix'; ID: ctiMatrix),
    (Value: 'MaterialBinding'; ID: ctiMaterialBinding),
    (Value: 'value'; ID: ctiValue),
    (Value: 'PER_FACE_INDEXED'; ID: ctiPerFaceIndexed),
    (Value: 'Material'; ID: ctiMaterial),
    (Value: 'ambientColor'; ID: ctiAmbientColor),
    (Value: 'diffuseColor'; ID: ctiDiffuseColor),
    (Value: 'emissiveColor'; ID: ctiEmissiveColor),
    (Value: 'specularColor'; ID: ctiSpecularColor),
    (Value: 'shininess'; ID: ctiShininess),
    (Value: 'transparency'; ID: ctiTransparency),
    (Value: 'Coordinate'; ID: ctiCoordinate),
    (Value: 'Coordinate3'; ID: ctiCoordinate3),
    (Value: 'point'; ID: ctiPoint),
    (Value: 'IndexedFaceSet'; ID: ctiIndexedFaceSet),
    (Value: 'coordIndex'; ID: ctiCoordIndex),
    (Value: 'materialIndex'; ID: ctiMaterialIndex),
    (Value: 'Sphere'; ID: ctiSphere),
    (Value: 'radius'; ID: ctiRadius),
    (Value: 'Cube'; ID: ctiCube),
    (Value: 'width'; ID: ctiWidth),
    (Value: 'height'; ID: ctiHeight),
    (Value: 'depth'; ID: ctiDepth),
    (Value: 'FontStyle'; ID: ctiFontStyle),
    (Value: 'size'; ID: ctiSize),
    (Value: 'AsciiText'; ID: ctiAsciiText),
    (Value: 'string'; ID: ctiString),
    (Value: 'Info'; ID: ctiInfo),
    (Value: 'Scale'; ID: ctiScale),
    (Value: 'scaleFactor'; ID: ctiScaleFactor),
    (Value: 'Rotation'; ID: ctiRotation),
    (Value: 'rotation'; ID: ctiRotation2),
    (Value: 'Translation'; ID: ctiTranslation),
    (Value: 'translation'; ID: ctiTranslation2),
    (Value: 'Transform'; ID: ctiTransform),
    (Value: 'scaleOrientation'; ID: ctiScaleOrientation),
    (Value: 'center'; ID: ctiCenter),
    (Value: 'DirectionalLight'; ID: ctiDirectionalLight),
    (Value: 'TransformSeparator'; ID: ctiTransformSeparator)
  );

  // these characters terminate a token
  cVrmlTerminators = [' ', #9, ',', #10, #13];


{ TsdVrmlNode }

constructor TsdVrmlNode.Create(AParent: TsdVrmlNode);
begin
  inherited Create;
  FParent := AParent;
end;

function TsdVrmlNode.GetNodeCount: integer;
begin
  Result := 0;
end;

procedure TsdVrmlNode.ProcessInnerVRML(T: TsdTokenizer; var AID: TsdVrmlTokenID);
begin
// default does nothing
end;

procedure TsdVrmlNode.ReadDouble(T: TsdTokenizer; var AValue: double);
begin
  T.ReadSymbol;
  AValue := T.LastSymbolAsFloat(AValue);
end;

procedure TsdVrmlNode.ReadDoubleArray(T: TsdTokenizer; var AList: TDoubleDynArray);
var
  Idx, ID, Count: integer;
begin
  Count := 4;
  SetLength(Alist, Count);
  Idx := 0;
  repeat
    ID := T.ReadToken;
    if ID = -1 then
    begin
      AList[Idx] := T.LastSymbolAsFloat(0.0);
      inc(Idx);
      if Idx >= Count then
      begin
        Count := Count * 2;
        SetLength(AList, Count);
      end;
    end;
  until (ID <> -1) and (TsdVrmlTokenID(ID) <> ctiSquareOpen);
  SetLength(AList, Idx);
end;

procedure TsdVrmlNode.ReadIntegerArray(T: TsdTokenizer; var AList: TIntegerDynArray);
var
  Idx, ID, Count: integer;
begin
  Count := 4;
  SetLength(Alist, Count);
  Idx := 0;
  repeat
    ID := T.ReadToken;
    if ID = -1 then
    begin
      AList[Idx] := T.LastSymbolAsInt(0);
      inc(Idx);
      if Idx >= Count then
      begin
        Count := Count * 2;
        SetLength(AList, Count);
      end;
    end;
  until (ID <> -1) and (TsdVrmlTokenID(ID) <> ctiSquareOpen);
  SetLength(AList, Idx);
end;

procedure TsdVrmlNode.ReadPoint3D(T: TsdTokenizer; var APoint: TsdPoint3D);
var
  List: TDoubleDynArray;
begin
  ReadDoubleArray(T, List);
  if Length(List) >= 3 then
  begin
    APoint.X := List[0];
    APoint.Y := List[1];
    APoint.Z := List[2];
  end;
end;

procedure TsdVrmlNode.ReadPoint3DArray(T: TsdTokenizer; var AList: TsdPoint3DDynArray);
var
  i, Count: integer;
  List: TDoubleDynArray;
begin
  ReadDoubleArray(T, List);

  Count := length(List) div 3;
  SetLength(AList, Count);
  for i := 0 to Count - 1 do
  begin
    AList[i].X := List[i * 3 + 0];
    AList[i].Y := List[i * 3 + 1];
    AList[i].Z := List[i * 3 + 2];
  end;
end;

procedure TsdVrmlNode.ReadVrmlNode(T: TsdTokenizer);
var
  ID, OldID: TsdVrmlTokenID;
begin
  repeat
    ID := TsdVrmlTokenID(T.ReadToken);
    if integer(ID) <> -1 then
    begin
      repeat
        OldID := ID;
        ProcessInnerVRML(T, ID);
      until OldID = ID;
    end;
  until (ID = ctiBraceClose) or T.IsEndOfFile;
end;

procedure TsdVrmlNode.SaveToStreamWriter(W: TsdStreamWriter);
begin
  if length(FName) > 0 then
    W.WriteIndent('DEF ' + Name + ' ')
  else
    W.WriteIndent('');
end;

procedure TsdVrmlNode.WritelnPoint3D(W: TsdStreamWriter; const APoint: TsdPoint3D);
var
  S: string;
begin
  S := ' ' + sdWriteNumber(APoint.X, 6, True) + ' ' +
             sdWriteNumber(APoint.Y, 6, True) + ' ' +
             sdWriteNumber(APoint.Z, 6, True);
  W.WriteLn(S);
end;

procedure TsdVrmlNode.WritelnVector4D(W: TsdStreamWriter; const AVector: TsdVector4D);
var
  i: integer;
  S: string;
begin
  S := '';
  for i := 0 to 3 do
    S := S + ' ' + sdWriteNumber(AVector.Elem[i], 6, True);
  W.WriteLn(S);
end;

{ TsdVrmlNodeList }

function TsdVrmlNodeList.GetItems(Index: integer): TsdVrmlNode;
begin
  Result := Get(Index);
end;

{ TsdVrmlFormat }

procedure TsdVrmlFormat.Clear;
begin
  FVersion := '';
  FEncoding := '';
  FNodes.Clear;
end;

constructor TsdVrmlFormat.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FNodes := TsdVrmlNodeList.Create;
end;

destructor TsdVrmlFormat.Destroy;
begin
  FreeAndNil(FNodes);
  inherited;
end;

procedure TsdVrmlFormat.LoadFromFile(const AFileName: string);
var
  F: TFileStream;
  M: TMemoryStream;
begin
  F := TFileStream.Create(AFileName, fmOpenRead or fmShareDenyNone);
  M := TMemoryStream.Create;
  try
    M.CopyFrom(F, F.Size);
    M.Position := 0;
    LoadFromStream(M);
  finally
    F.Free;
    M.Free;
  end;
end;

procedure TsdVrmlFormat.SaveToFile(const AFileName: string);
var
  F: TFileStream;
  M: TMemoryStream;
begin
  F := TFileStream.Create(AFileName, fmCreate);
  M := TMemoryStream.Create;
  try
    SaveToStream(M);
    M.Position := 0;
    F.CopyFrom(M, M.Size);
  finally
    F.Free;
    M.Free;
  end;
end;

procedure TsdVrmlFormat.LoadFromStream(S: TStream);
var
  i, ID: integer;
  T: TsdTokenizer;

begin
  // Clear first
  Clear;

  // Tokenize
  T := TsdTokenizer.Create;
  T.OnProgress := TokenProgress;
  T.UseSingleTokensAsTerminators := True;
  try
    T.CaseSensitive := True;
    // Add default tokens
    for i := 0 to length(cVrmlTokens) - 1 do
      T.AddToken(cVrmlTokens[i].Value, integer(cVrmlTokens[i].ID));
    // Process the stream
    T.ProcessStream(S);
    T.Terminators := cVrmlTerminators;
    // Read first line
    ID := T.ReadToken;
    if TsdVrmlTokenID(ID) <> ctiVrmlHeader then
      raise Exception.Create(sNoVrmlFile);
    // Read version
    FVersion := T.ReadSymbol;
    // Read encoding
    FEncoding := T.ReadSymbol;
    // Now read the nodes recursively
    ReadVrmlNode(T, FNodes, nil);
  finally
    T.Free;
  end;
end;

procedure TsdVrmlFormat.SaveToStream(S: TStream);
var
  i: integer;
  W: TsdStreamWriter;
begin
  W := TsdStreamWriter.Create;
  try
    W.Stream := S;
    W.IndentString := '    ';
    W.WriteLn('#VRML V1.0 ascii');
    for i := 0 to FNodes.Count - 1 do
    begin
      FNodes[i].SaveToStreamWriter(W);
    end;
  finally
    W.Free;
  end;
end;

procedure TsdVrmlFormat.ReadVrmlNode(T: TsdTokenizer; ANodes: TsdVrmlNodeList; AParent: TsdVrmlNode);
// Recursively read the vrml nodes
var
  ID: integer;
  G: TsdVrmlGroup;
  DefName: string;
  LS: string;
  // local
  function AddSubnodeClass(ANodeClass: TsdVrmlNodeClass): TsdVrmlNode;
  begin
    Result := ANodeClass.Create(AParent);
    ANodes.Add(Result);
    Result.Name := DefName;
    DefName := '';
  end;
  // local
  procedure AddAndReadSubnodeClass(ANodeClass: TsdVrmlNodeClass);
  var
    SubNode: TsdVrmlNode;
  begin
    SubNode := AddSubnodeClass(ANodeClass);
    SubNode.ReadVrmlNode(T);
  end;
//main
begin
  repeat
    ID := T.ReadToken;

    // Unrecognised token
    if ID = -1 then
    begin
      LS := Trim(T.LastSymbol);
      if length(LS) = 0 then
        continue;

      if LS[1] = '#' then
      begin
        // Comment: skip
        T.ReadSymbolUntil([#10, #13]);
        continue;
      end;

      raise Exception.CreateFmt(sUnrecognisedVRML, [T.LastSymbol]);
    end;

    // Valid tokens:
    case TsdVrmlTokenID(ID) of
    ctiSeparator, ctiTransformSeparator, ctiGroup, ctiShape:
      // TransformSeparator and Group are depreciated but sometimes seen
      // Shape is VRML-97
      begin
        G := TsdVrmlGroup(AddSubnodeClass(TsdVrmlGroup));
        // Brace Open
        ID := T.ReadToken;
        if TsdVrmlTokenID(ID) <> ctiBraceOpen then
          raise Exception.Create(sBraceOpenExpected);
        // read subnodes until we encounter closing brace
        ReadVrmlNode(T, G.Nodes, G);
      end;
    ctiDef:
      begin
        DefName := T.ReadSymbol;
        continue;
      end;
    ctiShapeHints:
      AddAndReadSubnodeClass(TsdVrmlShapeHints);
    ctiPerspectiveCamera:
      AddAndReadSubnodeClass(TsdVrmlPerspectiveCamera);
    ctiMaterial:
      AddAndReadSubnodeClass(TsdVrmlMaterial);
    ctiMaterialBinding:
      AddAndReadSubnodeClass(TsdVrmlMaterialBinding);
    ctiCoordinate, ctiCoordinate3:
      AddAndReadSubnodeClass(TsdVrmlCoordinate3);
    ctiIndexedFaceSet:
      AddAndReadSubnodeClass(TsdVrmlIndexedFaceSet);
    ctiSphere:
      AddAndReadSubnodeClass(TsdVrmlSphere);
    ctiCube:
      AddAndReadSubnodeClass(TsdVrmlCube);
    ctiFontStyle:
      AddAndReadSubnodeClass(TsdVrmlFontStyle);
    ctiAsciiText:
      AddAndReadSubnodeClass(TsdVrmlAsciiText);
    ctiInfo:
      AddAndReadSubnodeClass(TsdVrmlInfo);
    ctiTransform:
      AddAndReadSubnodeClass(TsdVrmlTransform);
    ctiScale:
      AddAndReadSubnodeClass(TsdVrmlScale);
    ctiRotation:
      AddAndReadSubnodeClass(TsdVrmlRotation);
    ctiTranslation:
      AddAndReadSubnodeClass(TsdVrmlTranslation);
    ctiMatrixTransform:
      AddAndReadSubnodeClass(TsdVrmlMatrixTransform);
    ctiDirectionalLight:
      AddAndReadSubnodeClass(TsdVrmlDirectionalLight);
    ctiBraceClose:
      exit;
    else
      // unsupported token
      //raise Exception.CreateFmt(sUnsupportedVRML, [T.LastSymbol]);
    end;
  until T.IsEndOfFile;
end;

procedure TsdVrmlFormat.TokenProgress(Sender: TObject; APosition, ASize: Integer);
begin
  if assigned(FOnProgress) then
    FOnProgress(Self, Format('Loading... (%3.1f%%)', [APosition/ASize * 100]));
end;

end.
