unit IgsMain;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ComCtrls, ExtCtrls, VirtualTrees, Menus, sdIGESFormat, StdCtrls,
  GLScene, GLObjects, GLMisc, GLWin32Viewer, Math,
  GLGeomObjects, GLMesh, GeometryBB, VectorGeometry, CheckLst, sdSplines,
  sdPoints3D, fraViewer, sdScene3D, sdIGESToScene3D, VectorTypes;

type
  TfrmMain = class(TForm)
    MainMenu1: TMainMenu;
    File1: TMenuItem;
    mnuOpenIGS: TMenuItem;
    sbMain: TStatusBar;
    mnuNew: TMenuItem;
    mnuSaveIGS: TMenuItem;
    mnuSaveIgsAs: TMenuItem;
    pcMain: TPageControl;
    tsStart: TTabSheet;
    tsGlobal: TTabSheet;
    tsEntities: TTabSheet;
    Splitter1: TSplitter;
    vstIgs: TVirtualStringTree;
    Label1: TLabel;
    mmStart: TMemo;
    lvGlobal: TListView;
    View1: TMenuItem;
    Options1: TMenuItem;
    mnuStructureOnly: TMenuItem;
    Panel2: TPanel;
    vstProps: TVirtualStringTree;
    vstStatus: TVirtualStringTree;
    est1: TMenuItem;
    Nurbs1: TMenuItem;
    tsTest: TTabSheet;
    mmTest: TMemo;
    tsViewer: TTabSheet;
    Panel3: TPanel;
    Viewer: TfrViewer;
    mnuExit: TMenuItem;
    Label2: TLabel;
    cbbCamStyle: TComboBox;
    clbImports: TCheckListBox;
    Label3: TLabel;
    btnHideAll: TButton;
    procedure FormCreate(Sender: TObject);
    procedure mnuOpenIGSClick(Sender: TObject);
    procedure vstIgsInitNode(Sender: TBaseVirtualTree; ParentNode,
      Node: PVirtualNode; var InitialStates: TVirtualNodeInitStates);
    procedure vstIgsInitChildren(Sender: TBaseVirtualTree;
      Node: PVirtualNode; var ChildCount: Cardinal);
    procedure vstIgsGetText(Sender: TBaseVirtualTree; Node: PVirtualNode;
      Column: TColumnIndex; TextType: TVSTTextType;
      var CellText: WideString);
    procedure vstIgsChange(Sender: TBaseVirtualTree; Node: PVirtualNode);
    procedure mnuNewClick(Sender: TObject);
    procedure mnuSaveIGSClick(Sender: TObject);
    procedure mnuSaveIgsAsClick(Sender: TObject);
    procedure vstPropsGetText(Sender: TBaseVirtualTree; Node: PVirtualNode;
      Column: TColumnIndex; TextType: TVSTTextType;
      var CellText: WideString);
    procedure vstPropsEditing(Sender: TBaseVirtualTree; Node: PVirtualNode;
      Column: TColumnIndex; var Allowed: Boolean);
    procedure vstPropsNewText(Sender: TBaseVirtualTree; Node: PVirtualNode;
      Column: TColumnIndex; NewText: WideString);
    procedure mnuStructureOnlyClick(Sender: TObject);
    procedure GLSceneViewer1MouseDown(Sender: TObject;
      Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure vstIgsEditing(Sender: TBaseVirtualTree; Node: PVirtualNode;
      Column: TColumnIndex; var Allowed: Boolean);
    procedure vstIgsNewText(Sender: TBaseVirtualTree; Node: PVirtualNode;
      Column: TColumnIndex; NewText: WideString);
    procedure vstStatusGetText(Sender: TBaseVirtualTree;
      Node: PVirtualNode; Column: TColumnIndex; TextType: TVSTTextType;
      var CellText: WideString);
    procedure Nurbs1Click(Sender: TObject);
    procedure mnuExitClick(Sender: TObject);
    procedure cbbCamStyleChange(Sender: TObject);
    procedure clbImportsClickCheck(Sender: TObject);
    procedure btnHideAllClick(Sender: TObject);
  private
    FMx, FMy: integer;
    FStructureOnly: boolean;
    FScene: TsdScene3D;
    FSceneBuilder: TIgsSceneBuilder;
    procedure Regenerate;
    procedure RegenerateTree;
    procedure RegenerateProperties(AEntity: TIgsEntity);
    procedure UpdateOpenGLPage;
    procedure SaveIges(const AFileName: string);
  public
    { Public declarations }
    FIgs: TIgsFormat;
    FFileName: string;
    FEntity: TIgsEntity;
  end;

var
  frmMain: TfrmMain;

implementation

type
  PNodeRec = ^TNodeRec;
  TNodeRec = record
    Entity: TIgsEntity;
  end;

{$R *.dfm}

procedure TfrmMain.FormCreate(Sender: TObject);
begin
  FIgs := TIgsFormat.Create(Self);
  FIgs.New;
  FFileName := 'new.dxf';
  FScene := TsdScene3D.Create(Self);
  FSceneBuilder := TIgsSceneBuilder.Create(Self);
  FSceneBuilder.Scene := FScene;
  Viewer.Scene := FScene;
  Regenerate;
end;

procedure TfrmMain.mnuNewClick(Sender: TObject);
begin
  FIgs.New;
  FFileName := 'new.dxf';
  Regenerate;
end;

procedure TfrmMain.SaveIges(const AFileName: string);
var
  Tick: dword;
begin
  Tick := GetTickCount;
  FIgs.SaveToFile(AFileName);
  sbMain.SimpleText := Format('IGES saved in %d msec', [GetTickCount - Tick]);
end;

procedure TfrmMain.mnuOpenIGSClick(Sender: TObject);
var
  Tick: dword;
begin
  with TOpenDialog.Create(nil) do
    try
      Title := 'Open IGES';
      Filter := 'IGES files (*.igs,*.iges)|*.igs;*.iges';
      if Execute then
      begin
        FFileName := FileName;
        Tick := GetTickCount;
        try
          FIgs.LoadFromFile(FFileName);
        except
        end;
        sbMain.SimpleText := Format('IGES opened in %d msec, regenerating...',
          [GetTickCount - Tick]);
        Regenerate;
        // test!
        //FScene.SetTransparency(0.5);
      end;
    finally
      Free;
    end;
end;

procedure TfrmMain.Regenerate;
  procedure AddString(const ACaption: string; AValue: string);
  var
    AItem: TListItem;
  begin
    AItem := lvGlobal.Items.Add;
    AItem.Caption := ACaption;
    AItem.SubItems.Add(AValue);
  end;
  procedure AddInt(const ACaption: string; AValue: integer);
  begin
    AddString(ACaption, IntToStr(AValue));
  end;
  procedure AddFloat(const ACaption: string; AValue: double);
  begin
    AddString(ACaption, FloatToStr(AValue));
  end;
  procedure AddDate(const ACaption: string; AValue: TDateTime);
  begin
    AddString(ACaption, DateTimeToStr(AValue));
  end;
begin
  Caption := Format('IGES Analyse [%s]', [FFileName]);
  // Start section
  mmStart.Lines.Assign(FIgs.StartSection);
  // Global section
  lvGlobal.Clear;
  with FIgs.Global^ do
  begin
    AddString('ParamDelim', ParamDelim);
    AddString('RecordDelim', RecordDelim);
    AddString('ProductIDSender', ProductIDSender);
    AddString('FileName', FileName);
    AddString('NativeSystemID', NativeSystemID);
    AddString('PreprocessorVersion', PreprocessorVersion);
    AddInt('NumBitsForInt', NumBitsForInt);
    AddInt('MaxPowTenSinglePrecision', MaxPowTenSinglePrecision);
    AddInt('NumSignDigitsSinglePrecision', NumSignDigitsSinglePrecision);
    AddInt('MaxPowTenDoublePrecision', MaxPowTenDoublePrecision);
    AddInt('NumSignDigitsDoublePrecision', NumSignDigitsDoublePrecision);
    AddString('ProductIDReceiver', ProductIDReceiver);
    AddFloat('ModelSpaceScale', ModelSpaceScale);
    AddInt('UnitsFlag', UnitsFlag);
    AddString('UnitsName', UnitsName);
    AddInt('NumLineWeightGrad', NumLineWeightGrad);
    AddFloat('WidthMaxLineWeight', WidthMaxLineWeight);
    AddDate('ExchangeDate', ExchangeDate);
    AddFloat('MinimumResolution', MinimumResolution);
    AddFloat('MaxCoordinateValue', MaxCoordinateValue);
    AddString('AuthorName', AuthorName);
    AddString('AuthorOrganization', AuthorOrganization);
    AddInt('VersionSpecFlag', VersionSpecFlag);
    AddInt('DraftingStandardFlag', DraftingStandardFlag);
    AddDate('ModifiedDate', ModifiedDate);
    AddString('Protocol', Protocol);
  end;
  RegenerateProperties(nil);
  RegenerateTree;
  UpdateOpenGLPage;
end;

procedure TfrmMain.RegenerateTree;
begin
  vstIgs.RootNodeCount := 0;
  if FStructureOnly then
    vstIgs.RootNodeCount := FIgs.Structure.Count
  else
    vstIgs.RootNodeCount := FIgs.Entities.Count;
end;

procedure TfrmMain.RegenerateProperties(AEntity: TIgsEntity);
begin
  vstProps.RootNodeCount := 0;
  FEntity := AEntity;
  if assigned(FEntity) then
    vstProps.RootNodeCount := FEntity.Parameters.Count;
  vstStatus.RootNodeCount := 0;
  if assigned(FEntity) then
    vstStatus.RootNodeCount := 4;
end;

procedure TfrmMain.vstIgsInitNode(Sender: TBaseVirtualTree; ParentNode,
  Node: PVirtualNode; var InitialStates: TVirtualNodeInitStates);
var
  FData, FParentData: PNodeRec;
  FParentEntity: TIgsEntity;
begin
  if ParentNode = nil then
  begin

    FData := Sender.GetNodeData(Node);
    if FStructureOnly then
      FData.Entity := FIgs.Structure[Node.Index]
    else
      FData.Entity := FIgs.Entities[Node.Index]

  end else
  begin

    // We need to use the parent node
    FParentData := Sender.GetNodeData(ParentNode);
    FParentEntity := FParentData.Entity;

    // Find the new node
    FData := Sender.GetNodeData(Node);
    if integer(Node.Index) < FParentEntity.EntityCount then
    begin
      FData.Entity := FParentEntity.Entities[Node.Index];
    end;

  end;

  // Initial states
  InitialStates := [];
  if assigned(FData.Entity) then
  begin
    // initial states
    if FData.Entity.EntityCount > 0 then
      InitialStates := [ivsHasChildren];
  end;
end;

procedure TfrmMain.vstIgsInitChildren(Sender: TBaseVirtualTree;
  Node: PVirtualNode; var ChildCount: Cardinal);
var
  FData: PNodeRec;
begin
  FData := Sender.GetNodeData(Node);
  ChildCount := FData.Entity.EntityCount;
end;

procedure TfrmMain.vstIgsGetText(Sender: TBaseVirtualTree;
  Node: PVirtualNode; Column: TColumnIndex; TextType: TVSTTextType;
  var CellText: WideString);
var
  FData: PNodeRec;
  E: TIgsEntity;
begin
  FData := Sender.GetNodeData(Node);
  E := FData.Entity;
  if TextType = ttNormal then
  begin
    case Column of
    0:  CellText := IntToStr(E.Directory.SequenceNumber);
    1:  CellText := Format('%d (%s)' , [E.Directory.EntityType, E.EntityTypeName]);
    2:  CellText := IntToStr(E.Directory.Level);
    3:  CellText := IntToStr(E.Directory.TransformMatrix);
    4:  CellText := Format('%.8d', [E.Directory.Status]);
    5:  CellText := Format('%d (%s)', [E.Directory.Color, E.ColorName]);
    6:  CellText := IntToStr(E.Directory.Form);
    7:  CellText := IntToStr(E.Directory.Structure);
    8:  CellText := IntToStr(E.Directory.LineFontPattern);
    9:  CellText := IntToStr(E.Directory.View);
    10:  CellText := IntToStr(E.Directory.LabelDispAssoc);
    11:  CellText := IntToStr(E.Directory.LineWeight);
    12: CellText := E.Directory.EntityLabel;
    13: CellText := IntToStr(E.Directory.EntitySubscript);
    14:  CellText := IntToStr(E.Directory.ParameterData);
    15: CellText := IntToStr(E.Directory.ParameterLineCount);
    end;
  end;
end;

procedure TfrmMain.vstIgsChange(Sender: TBaseVirtualTree;
  Node: PVirtualNode);
var
  FData: PNodeRec;
begin
  FData := Sender.GetNodeData(Node);
  if assigned(FData) then
    RegenerateProperties(FData.Entity)
  else
    RegenerateProperties(nil);
end;

procedure TfrmMain.mnuSaveIGSClick(Sender: TObject);
begin
  SaveIges(FFileName);
end;

procedure TfrmMain.mnuSaveIgsAsClick(Sender: TObject);
begin
  with TSaveDialog.Create(nil) do
    try
      Title := 'Save IGES';
      Filter := 'IGES files (*.igs)|*.igs';
      if Execute then
      begin
        FFileName := FileName;
        SaveIges(FFileName);
      end;
    finally
      Free;
    end;
end;

procedure TfrmMain.vstPropsGetText(Sender: TBaseVirtualTree;
  Node: PVirtualNode; Column: TColumnIndex; TextType: TVSTTextType;
  var CellText: WideString);
var
  AParam: TIgsParameter;
begin
  if assigned(FEntity) and assigned(Node) and (FEntity.Parameters.Count > integer(Node.Index)) then
  begin
    AParam := FEntity.Parameters[Node.Index];
    if TextType = ttNormal then
      case Column of
      0: CellText := IntToStr(Node.Index + 1);
      1: CellText := FEntity.ParameterDescription(Node.Index);
      2: CellText := AParam.AsString;
      end;
  end;
end;

procedure TfrmMain.vstPropsEditing(Sender: TBaseVirtualTree;
  Node: PVirtualNode; Column: TColumnIndex; var Allowed: Boolean);
begin
//  Allowed := Column = 2;
end;

procedure TfrmMain.vstPropsNewText(Sender: TBaseVirtualTree;
  Node: PVirtualNode; Column: TColumnIndex; NewText: WideString);
begin
{  if (Column = 2) and assigned(FItem) and assigned(Node) and (Node.Index < FItem.Properties.Count) then begin
    FItem.Properties[Node.Index].Value := NewText;
    Invalidate;
    vstDxf.Invalidate;
  end;}
end;

procedure TfrmMain.mnuStructureOnlyClick(Sender: TObject);
begin
  FStructureOnly := not FStructureOnly;
  mnuStructureOnly.Checked := FStructureOnly;
  RegenerateProperties(nil);
  RegenerateTree;
end;

procedure TfrmMain.GLSceneViewer1MouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  FMx := x;
  FMy := y;
end;

procedure TfrmMain.vstIgsEditing(Sender: TBaseVirtualTree;
  Node: PVirtualNode; Column: TColumnIndex; var Allowed: Boolean);
begin
  case Column of
  2: Allowed := True; // Allow user to change level
  else
    Allowed := False;
  end;
end;

procedure TfrmMain.vstIgsNewText(Sender: TBaseVirtualTree;
  Node: PVirtualNode; Column: TColumnIndex; NewText: WideString);
var
  i, ALevelNumber: integer;
begin
  if not assigned(FEntity) or not assigned(Node) then
    exit;
  case Column of
  2:
    begin
      ALevelNumber := StrToIntDef(NewText, 0);
      FEntity.LevelNumber := ALevelNumber;
      if not (vsExpanded in Node.States) then
        // Also change sub entities' level
        for i := 0 to FEntity.EntityCount - 1 do
          FEntity.Entities[i].LevelNumber := ALevelNumber;
    end;
  end;
end;

procedure TfrmMain.UpdateOpenGLPage;
var
  i: integer;
  E: TIgsEntity;
begin
  // Let the scene builder build the scene from the IGES file
  FSceneBuilder.Igs := FIgs;
  FSceneBuilder.BuildScene;

  // Build import listbox
  clbImports.Clear;
  for i := 0 to FSceneBuilder.Items.Count - 1 do
  begin
    E := TIgsEntity(FSceneBuilder.Items[i].Ref);
    clbImports.Items.Add(Format('%d (%s)', [E.Directory.SequenceNumber, E.EntityTypeName]));
    clbImports.Checked[i] := E.Tag = 1;
  end;
end;

procedure TfrmMain.clbImportsClickCheck(Sender: TObject);
var
  i: integer;
begin
  for i := 0 to clbImports.Items.Count - 1 do
  begin
//    if clbImports.Checked[i] then V := 1 else V := 0;
    FSceneBuilder.Items[i].Selected := clbImports.Checked[i];
    FSceneBuilder.UpdateVisibility;
  end;
end;

procedure TfrmMain.btnHideAllClick(Sender: TObject);
var
  i: integer;
begin
  for i := 0 to clbImports.Items.Count - 1 do
  begin
    clbImports.Checked[i] := False;
    FSceneBuilder.Items[i].Selected := False;
  end;
  FSceneBuilder.UpdateVisibility;
end;

procedure TfrmMain.vstStatusGetText(Sender: TBaseVirtualTree;
  Node: PVirtualNode; Column: TColumnIndex; TextType: TVSTTextType;
  var CellText: WideString);
var
  V: integer;
begin
  if not assigned(FEntity) or not assigned(Node) or (TextType <> ttNormal) then
    exit;
  case Column of
  0:
    begin
      case Node.Index of
      0: CellText := 'Blank Status';
      1: CellText := 'Subordinate entity switch';
      2: CellText := 'Entity Use Flag';
      3: CellText := 'Hierarchy';
      end;
    end;
  1:
    begin
      case Node.Index of
      0:
        begin
          V := FEntity.BlankStatus;
          if V in [0..1] then
            CellText := cIgsBlankStatus[V]
          else
            CellText := Format('%.2d', [V]);
        end;
      1:
        begin
          V := FEntity.SubordEntitySwitch;
          if V in [0..3] then
            CellText := cIgsSubordEntitySwitch[V]
          else
            CellText := Format('%.2d', [V]);
        end;
      2:
        begin
          V := FEntity.EntityUseFlag;
          if V in [0..6] then
            CellText := cIgsEntityUseFlag[V]
          else
            CellText := Format('%.2d', [V]);
        end;
      3:
        begin
          V := FEntity.Hierarchy;
          if V in [0..2] then
            CellText := cIgsHierarchy[V]
          else
            CellText := Format('%.2d', [V]);
        end;
      end;
    end;
  end;
end;

procedure TfrmMain.Nurbs1Click(Sender: TObject);
var
  i: integer;
  Spline: TsdNurbs3D;
  APoint: TsdPoint3D;
  du: double;
begin
  Spline := TsdNurbs3D.Create;
  try
    Spline.N := 2;
    Spline.Degree := 2;
    Spline.Axis.MakeOpenUniform;
    Spline.ControlPoint[0] := Point3D(0, 1, 0);
    Spline.ControlPoint[1] := Point3D(1, 1, 0);
    Spline.ControlPoint[2] := Point3D(1, 0, 0);
    Spline.Weight[0] := 1;
    Spline.Weight[1] := sqrt(2)/2;
    Spline.Weight[2] := 1;
    mmTest.Clear;
    du := (Spline.UMax - Spline.UMin) / 10;
    for i := 0 to 10 do
    begin
      APoint := Spline.SplinePoint(Spline.UMin + i * du);
      mmTest.Lines.Add(Format('i=%2d, X=%5.3f, Y=%5.3f', [i, APoint.X, APoint.Y]));
    end;
  finally
    Spline.Free;
  end;
end;

procedure TfrmMain.mnuExitClick(Sender: TObject);
begin
  Close;
end;

procedure TfrmMain.cbbCamStyleChange(Sender: TObject);
var
  P: TGLCoordinates;
begin
  if cbbCamStyle.ItemIndex = 0 then
    Viewer.GLCamera.CameraStyle := csPerspective
  else
    Viewer.GLCamera.CameraStyle := csOrthogonal;
  P := Viewer.GLCamera.Position;
  case cbbCamStyle.ItemIndex of
  0: P.SetPoint(2, 2, 2);
  1: P.SetPoint(2, 0, 0);
  2: P.SetPoint(0, 2, 0);
  3: P.SetPoint(0, 0, 2);
  end;
end;

end.
