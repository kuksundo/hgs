{ sdScene3D

  Project: Geometry 3D

  Description:
    A TsdScene3D is an encapsulation of a list of 3D scene objects, that can
    be converted to an OpenGL presentation

  original author: Nils Haeck M.Sc. 
  Copyright (c) 2007 SimDesign BV (www.simdesign.nl)
}
unit sdScene3D;

interface

uses
  Classes, SysUtils, Contnrs, Graphics, sdPoints3D, VectorTypes, GLScene, GLObjects;

const
  sdCadFormatFilter: string =
        'VRML files (*.wrl)|*.wrl|' +
        'DXF files (*.dxf)|*.dxf|' +
        'IGES files (*.igs, *.iges)|*.igs;*.iges|' +
        'All files (*.*)|*.*';


type
  // CAD format type
  TsdCadFormat = (
    cfDxf,
    cfDwg,
    cfVrml,
    cfIges,
    cfUnknown
  );

// detect the cad format supported by sdScene3D from the filename
function sdCadFormatFromFileName(const AFileName: string): TsdCadFormat;

type

  TsdScene3D = class;

  TsdScene3DItem = class(TPersistent)
  private
    FOwner: TsdScene3D;
    FVisible: boolean;
    FTransform: TsdMatrix3x4;
    FParent: TsdScene3DItem;
    FGLObject: TGLBaseSceneObject;
    FColor: TVector4F;
    FTag: integer;
    FTransparency: double;
    function GetTransform: PsdMatrix3x4;
    procedure SetParent(const Value: TsdScene3DItem);
    procedure SetGDIColor(const Value: TColor);
    procedure SetTransparency(const Value: double);
    function GetGDIColor: TColor;
    procedure SetColor(const Value: TVector4F);
  protected
    procedure Invalidate;
    procedure SetVisible(const Value: boolean); virtual;
    function GLColor(const AColor: TColor): TVector4F;
    // Update the GLObject in the GLScene
    procedure UpdateGLSceneObject; virtual;
    procedure BuildGLSceneObject(AGLParent: TGLBaseSceneObject); virtual;
    property Owner: TsdScene3D read FOwner;
  public
    constructor Create(AOwner: TsdScene3D; AParent: TsdScene3DItem); virtual;
    procedure Clear; virtual;
    // Get the bounding box of this 3D item. If the function returns false,
    // no bounding box is available
    function BoundingBox(var ABox: TsdBox3D): boolean; virtual;
    // Do a hard transform of all points in this item with Atransform
    procedure HardTransform(const ATransform: TsdMatrix3x4); virtual;
    // Returns the transform of this item's points to the scene world coordinate space
    function WorldTransform: TsdMatrix3x4;
    // Reference to the GLScene object
    property GLObject: TGLBaseSceneObject read FGLObject write FGLObject;
    // The parent item of this item (thus constructing a tree)
    property Parent: TsdScene3DItem read FParent write SetParent;
    // Set Visible to false to hide this item in the scene
    property Visible: boolean read FVisible write SetVisible default True;
    // Transparency of the 3D object, defaults to 1.0 (fully opaque)
    property Transparency: double read FTransparency write SetTransparency;
    // Transform that transforms points in the item from local to parent coordinates
    property Transform: PsdMatrix3x4 read GetTransform;
    // 24bit Color (if used)
    property GDIColor: TColor read GetGDIColor write SetGDIColor;
    // Color as defined in OpenGL with 4 components RGBA between 0..1
    property Color: TVector4f read FColor write SetColor;
    // A tag value which can be used by the application
    property Tag: integer read FTag write FTag;
  end;

  TsdScene3DItemList = class(TObjectList)
  private
    function GetItems(Index: integer): TsdScene3DItem;
  public
    property Items[Index: integer]: TsdScene3DItem read GetItems; default;
  end;

  // Dummy cube item
  TsdScene3DDummy = class(TsdScene3DItem)
  protected
    procedure BuildGLSceneObject(AGLParent: TGLBaseSceneObject); override;
  end;

  TsdScene3DCamera = class(TsdScene3DItem)
  end;

  TsdScene3D = class(TComponent)
  private
    FItems: TsdScene3DItemList;
    FIsValid: boolean;
    FGLRoot: TGLBaseSceneObject;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure Clear; virtual;
    // Do a hard transform of all items with Atransform (only applies to items
    // with no parent set)
    procedure HardTransform(const ATransform: TsdMatrix3x4);
    procedure Invalidate;
    procedure UpdateGLScene;
    procedure BuildGLScene;
    procedure SetTransparency(const ATransparency: double);
    // Get the bounding box of all items. If the function returns false,
    // no bounding box is available (e.g. there are no items)
    function BoundingBox(var ABox: TsdBox3D): boolean; virtual;
    // Hierarchical list of items in this 3D scene
    property Items: TsdScene3DItemList read FItems;
    // Indicates if the scene is still valid or needs an UpdateScene call
    property IsValid: boolean read FIsValid;
    // Root of the OpenGL GLScene
    property GLRoot: TGLBaseSceneObject read FGLRoot write FGLRoot;
  end;

implementation

function sdCadFormatFromFileName(const AFileName: string): TsdCadFormat;
var
  Ext: string;
begin
  Ext := AnsiLowerCase(ExtractFileExt(AFileName));
  if (Ext = '.vrml') or (Ext = '.wrl') then
  begin
    Result := cfVrml;
    exit;
  end;
  if (Ext = '.dxf') then
  begin
    Result := cfDxf;
    exit;
  end;
  if (Ext = '.dwg') then
  begin
    Result := cfDwg;
    exit;
  end;
  if (Ext = '.igs') or (Ext = '.iges') then
  begin
    Result := cfIges;
    exit;
  end;
  Result := cfUnknown;
end;

{ TsdScene3DItem }

function TsdScene3DItem.BoundingBox(var ABox: TsdBox3D): boolean;
begin
  // Default has no bounding box
  Result := False;
end;

procedure TsdScene3DItem.BuildGLSceneObject(AGLParent: TGLBaseSceneObject);
begin
// default does nothing
end;

procedure TsdScene3DItem.Clear;
begin
// default does nothing
end;

constructor TsdScene3DItem.Create(AOwner: TsdScene3D; AParent: TsdScene3DItem);
begin
  inherited Create;
  FOwner := AOwner;
  if assigned(FOwner) then
    FOwner.Items.Add(Self);
  FParent := AParent;
  FVisible := True;
  FTransform := cIdentityMatrix3x4;
  FTransparency := 1.0;
end;

function TsdScene3DItem.GetGDIColor: TColor;
begin
  Result :=
    round(FColor[0] * 255) shl 16 +
    round(FColor[1] * 255) shl 8 +
    round(FColor[2] * 255);
end;

function TsdScene3DItem.GetTransform: PsdMatrix3x4;
begin
  Result := @FTransform;
end;

function TsdScene3DItem.GLColor(const AColor: TColor): TVector4F;
var
  Rgb: integer;
begin
  Rgb := ColorToRgb(AColor);
  Result[0] := (Rgb and $FF)/$FF; Rgb := Rgb shr 8;
  Result[1] := (Rgb and $FF)/$FF; Rgb := Rgb shr 8;
  Result[2] := (Rgb and $FF)/$FF;
  Result[3] := FTransparency;
end;

procedure TsdScene3DItem.HardTransform(const ATransform: TsdMatrix3x4);
begin
// default does nothing
end;

procedure TsdScene3DItem.Invalidate;
begin
  FOwner.Invalidate;
end;

procedure TsdScene3DItem.SetColor(const Value: TVector4F);
var
  i: integer;
  Diff: boolean;
begin
  Diff := False;
  for i := 0 to 3 do
    if FColor[i] <> Value[i] then
      Diff := True;
  if Diff then
  begin
    FColor := Value;
    Invalidate;
  end;
end;

procedure TsdScene3DItem.SetGDIColor(const Value: TColor);
begin
  SetColor(GLColor(Value));
end;

procedure TsdScene3DItem.SetParent(const Value: TsdScene3DItem);
begin
  if FParent <> Value then
  begin
    FParent := Value;
    Invalidate;
  end;
end;

procedure TsdScene3DItem.SetTransparency(const Value: double);
begin
  if FTransparency <> Value then
  begin
    FTransparency := Value;
    Invalidate;
  end;
end;

procedure TsdScene3DItem.SetVisible(const Value: boolean);
begin
  if FVisible <> Value then
  begin
    FVisible := Value;
    //force visibility to be set
    Invalidate;
  end;
end;

procedure TsdScene3DItem.UpdateGLSceneObject;
begin
// default does nothing
end;

function TsdScene3DItem.WorldTransform: TsdMatrix3x4;
begin
  if assigned(FParent) then
  begin
    Result := MultiplyMatrix3x4(FParent.WorldTransform, FTransform)
  end else
    Result := FTransform;
end;

{ TsdScene3DItemList }

function TsdScene3DItemList.GetItems(Index: integer): TsdScene3DItem;
begin
  Result := Get(Index);
end;

{ TsdScene3DDummy }

procedure TsdScene3DDummy.BuildGLSceneObject(AGLParent: TGLBaseSceneObject);
begin
  GLObject := TGLDummyCube.Create(AGLParent);
  AGLParent.AddChild(GLObject);
  SetVisible(Visible);
end;

{ TsdScene3D }

function TsdScene3D.BoundingBox(var ABox: TsdBox3D): boolean;
var
  i: integer;
  BB: TsdBox3D;
  Res: boolean;
  T: TsdMatrix3x4;
begin
  Result := False;
  for i := 0 to Items.Count - 1 do
  begin
    Res := Items[i].BoundingBox(BB);
    if Res then
    begin
      T := Items[i].WorldTransform;
      BB := TransformBox3D(BB, T);
      if not Result then
        ABox := BB
      else
        ABox := CombineBox3D(ABox, BB);
      Result := True;
    end;
  end;
end;

procedure TsdScene3D.BuildGLScene;
var
  i: integer;
begin
  if not assigned(FGLRoot) then
    exit;

  // Clear first
  FGLRoot.DeleteChildren;

  // Add all objects in a hierarchical way to the GLRoot
  for i := 0 to Items.Count - 1 do
  begin
    if not assigned(Items[i].Parent) then
      Items[i].BuildGLSceneObject(FGLRoot)
    else
      Items[i].BuildGLSceneObject(Items[i].Parent.GLObject);
  end;

  // and update the scene
  UpdateGLScene;
end;

procedure TsdScene3D.Clear;
begin
  FItems.Clear;
end;

constructor TsdScene3D.Create(AOwner: TComponent);
begin
  inherited;
  FItems := TsdScene3DItemList.Create(True);
end;

destructor TsdScene3D.Destroy;
begin
  FreeAndNil(FItems);
  inherited;
end;

procedure TsdScene3D.HardTransform(const ATransform: TsdMatrix3x4);
var
  i: integer;
begin
  for i := 0 to FItems.Count - 1 do
    if not Assigned(FItems[i].Parent) then
      FItems[i].HardTransform(ATransform);
end;

procedure TsdScene3D.Invalidate;
begin
  FIsValid := False;
end;

procedure TsdScene3D.SetTransparency(const ATransparency: double);
var
  i: integer;
begin
  for i := 0 to FItems.Count - 1 do
    FItems[i].SetTransparency(ATransparency);
end;

procedure TsdScene3D.UpdateGLScene;
var
  i: integer;
begin
  for i := 0 to FItems.Count - 1 do
    FItems[i].UpdateGLSceneObject;
  FIsValid := True;
end;

end.
