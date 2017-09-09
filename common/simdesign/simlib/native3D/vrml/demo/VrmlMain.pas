unit VrmlMain;
{
   VRML viewer main form

   copyright (c) 2008 by SimDesign BV
}
interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Menus, ComCtrls, ActnList, ExtCtrls, ToolWin, sdScene3D, ImgList,
  sdVrmlFormat, fraViewer, VirtualTrees, sdVrmlToScene3D, StdCtrls,
  sdSpaceballInput, fraSpaceball;

const
  FCaption: string = 'SimDesign VRML Viewer';

type
  TfrmMain = class(TForm)
    alMain: TActionList;
    mnuMain: TMainMenu;
    sbMain: TStatusBar;
    File1: TMenuItem;
    Help1: TMenuItem;
    tbMain: TToolBar;
    pnlLeft: TPanel;
    pnlRight: TPanel;
    acOpen: TAction;
    ilMain: TImageList;
    acExit: TAction;
    Open1: TMenuItem;
    N1: TMenuItem;
    Exit1: TMenuItem;
    tbOpen: TToolButton;
    frViewer: TfrViewer;
    vstVRML: TVirtualStringTree;
    mmInfo: TMemo;
    ilVRML: TImageList;
    Splitter1: TSplitter;
    Splitter2: TSplitter;
    mnuSaveAs: TMenuItem;
    PrintDialog1: TPrintDialog;
    Splitter3: TSplitter;
    Label1: TLabel;
    frSpaceball: TfrSpaceball;
    procedure acOpenExecute(Sender: TObject);
    procedure acExitExecute(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure vstVRMLInitChildren(Sender: TBaseVirtualTree;
      Node: PVirtualNode; var ChildCount: Cardinal);
    procedure vstVRMLInitNode(Sender: TBaseVirtualTree; ParentNode,
      Node: PVirtualNode; var InitialStates: TVirtualNodeInitStates);
    procedure vstVRMLNewText(Sender: TBaseVirtualTree; Node: PVirtualNode;
      Column: TColumnIndex; NewText: WideString);
    procedure vstVRMLGetText(Sender: TBaseVirtualTree; Node: PVirtualNode;
      Column: TColumnIndex; TextType: TVSTTextType;
      var CellText: WideString);
    procedure vstVRMLEditing(Sender: TBaseVirtualTree; Node: PVirtualNode;
      Column: TColumnIndex; var Allowed: Boolean);
    procedure vstVRMLChange(Sender: TBaseVirtualTree; Node: PVirtualNode);
    procedure SceneBuilderMessage(Sender: TObject; const S: string);
    procedure vstVRMLGetImageIndex(Sender: TBaseVirtualTree;
      Node: PVirtualNode; Kind: TVTImageKind; Column: TColumnIndex;
      var Ghosted: Boolean; var ImageIndex: Integer);
    procedure mnuSaveAsClick(Sender: TObject);
  private
    FInput3D: TsdTDxInputManager;
    FVrml: TsdVrmlFormat;
    FScene: TsdScene3D;
    FSceneBuilder: TsdVrmlSceneBuilder;
    procedure VrmlProgress(Sender: TObject; const AMessage: string);
    procedure Input3DChanged(Sender: TObject);
    procedure Input3DKeydown(Sender: TObject; AKeyCode: integer);
    procedure Input3DSensor(Sender: TObject; const AInput: TsdTDxInput);
  public
    procedure Regenerate;
    procedure RegenerateTree;
    procedure UpdateOpenGL;
    procedure SetupInput3D;
  end;

var
  frmMain: TfrmMain;

implementation

uses
  sdVrmlNodeTypes;

type

  PNodeRec = ^TNodeRec;
  TNodeRec = record
    Vrml: TsdVrmlNode;
  end;

{$R *.dfm}

procedure TfrmMain.FormCreate(Sender: TObject);
begin
  FVrml := TsdVrmlFormat.Create(Self);
  FScene := TsdScene3D.Create(Self);
  FSceneBuilder := TsdVrmlSceneBuilder.Create(Self);
  FSceneBuilder.OnMessage := SceneBuilderMessage;
  FSceneBuilder.Scene := FScene;
  frViewer.Scene := FScene;
  SetupInput3D;
  Regenerate;
end;

procedure TfrmMain.SetupInput3D;
begin
  FInput3D := TsdTDxInputManager.Create(Self);
  FInput3D.OnDeviceChanged := Input3DChanged;
  FInput3D.OnInput := Input3DSensor;
  FInput3D.Enabled := True;
end;

procedure TfrmMain.acOpenExecute(Sender: TObject);
var
  Tick, TickL, TickR: cardinal;
begin
  with TOpenDialog.Create(nil) do
  begin
    try
      Title := 'Open VRML file';
      Filter := 'VRML files (*.wrl)|*.wrl|' +
                'All files (*.*)|*.*';
      if Execute then
      begin
        Screen.Cursor := crHourglass;
        Tick := GetTickCount;
        mmInfo.Clear;
        FVrml.OnProgress := VrmlProgress;
        FVrml.LoadFromFile(FileName);
        TickL := GetTickCount;
        Regenerate;
        TickR := GetTickCount;
        sbMain.SimpleText := Format('Load Time: %5.3f sec, Regen time: %5.3f sec',
          [(TickL - Tick) * 0.001, (TickR - TickL) * 0.001]);
      end;
    finally
      Free;
      Screen.Cursor := crDefault;
    end;
  end;
end;

procedure TfrmMain.acExitExecute(Sender: TObject);
begin
  Close;
end;

procedure TfrmMain.Regenerate;
begin
  RegenerateTree;
  UpdateOpenGL;
end;

procedure TfrmMain.RegenerateTree;
begin
  vstVRML.RootNodeCount := 0;
  vstVRML.RootNodecount := FVrml.Nodes.Count;
end;

procedure TfrmMain.vstVRMLInitChildren(Sender: TBaseVirtualTree;
  Node: PVirtualNode; var ChildCount: Cardinal);
var
  FData: PNodeRec;
begin
  FData := Sender.GetNodeData(Node);
  ChildCount := FData.Vrml.NodeCount;
end;

procedure TfrmMain.vstVRMLInitNode(Sender: TBaseVirtualTree; ParentNode,
  Node: PVirtualNode; var InitialStates: TVirtualNodeInitStates);
var
  FData, FParentData: PNodeRec;
  FParentVrml: TsdVrmlNode;
begin
  if ParentNode = nil then
  begin

    // Root nodes
    FData := Sender.GetNodeData(Node);
    FData.Vrml := FVrml.Nodes[Node.Index]

  end else
  begin

    // We need to use the parent node
    FParentData := Sender.GetNodeData(ParentNode);
    FParentVrml := FParentData.Vrml;

    // Find the new node
    FData := Sender.GetNodeData(Node);
    if FParentVrml is TsdVrmlGroup then
      FData.Vrml := TsdVrmlGroup(FParentVrml).Nodes[Node.Index];

  end;

  // Initial states
  InitialStates := [];
  if assigned(FData.Vrml) then
  begin
    // initial states
    if FData.Vrml.NodeCount > 0 then
      InitialStates := [ivsHasChildren];
  end;
end;

procedure TfrmMain.vstVRMLNewText(Sender: TBaseVirtualTree;
  Node: PVirtualNode; Column: TColumnIndex; NewText: WideString);
begin
//
end;

procedure TfrmMain.vstVRMLGetText(Sender: TBaseVirtualTree;
  Node: PVirtualNode; Column: TColumnIndex; TextType: TVSTTextType;
  var CellText: WideString);
var
  FData: PNodeRec;
  VrmlNode: TsdVrmlNode;
begin
  FData := Sender.GetNodeData(Node);
  VrmlNode := FData.Vrml;
  if TextType = ttNormal then
  begin
    case Column of
    0: CellText := copy(VrmlNode.ClassName, 8, length(VrmlNode.ClassName));
    1: CellText := VrmlNode.Name;
    end;
  end;
end;

procedure TfrmMain.vstVRMLEditing(Sender: TBaseVirtualTree;
  Node: PVirtualNode; Column: TColumnIndex; var Allowed: Boolean);
begin
//
end;

procedure TfrmMain.vstVRMLChange(Sender: TBaseVirtualTree; Node: PVirtualNode);
begin
//
end;

procedure TfrmMain.vstVRMLGetImageIndex(Sender: TBaseVirtualTree;
  Node: PVirtualNode; Kind: TVTImageKind; Column: TColumnIndex;
  var Ghosted: Boolean; var ImageIndex: Integer);
var
  FData: PNodeRec;
  VrmlNode: TsdVrmlNode;
begin
  if not (Kind in [ikNormal, ikSelected]) then
    exit;
  if Column <> 0 then
  begin
    ImageIndex := -1;
    exit;
  end;
  FData := Sender.GetNodeData(Node);
  VrmlNode := FData.Vrml;
  if VrmlNode is TsdVrmlGroup then
    ImageIndex := 0
  else if VrmlNode is TsdVrmlMaterial then
    ImageIndex := 1
  else if VrmlNode is TsdVrmlIndexedFaceSet then
    ImageIndex := 2
  else if VrmlNode is TsdVrmlCoordinate3 then
    ImageIndex := 3
  else if VrmlNode is TsdVrmlBaseTransform then
    ImageIndex := 4
  else if VrmlNode is TsdVrmlPerspectiveCamera then
    ImageIndex := 5
  else
    ImageIndex := 6;
end;

procedure TfrmMain.UpdateOpenGL;
begin
  FSceneBuilder.Vrml := FVrml;
  FSceneBuilder.BuildScene;
end;

procedure TfrmMain.SceneBuilderMessage(Sender: TObject; const S: string);
begin
  mmInfo.Lines.Add(S);
end;

procedure TfrmMain.VrmlProgress(Sender: TObject; const AMessage: string);
begin
  sbMain.SimpleText := AMessage;
  Application.ProcessMessages;
end;

procedure TfrmMain.mnuSaveAsClick(Sender: TObject);
var
  SaveName: string;
begin
  with TSaveDialog.Create(Self) do
  try
    Title := 'Save VRML File';
    Filter := 'VRML Files (*.wrl)|*.wrl';
    if Execute then
    begin
      SaveName := ChangeFileExt(FileName, '.wrl');
      FVrml.SaveToFile(SaveName);
    end;
  finally
    Free;
  end;
end;

procedure TfrmMain.Input3DChanged(Sender: TObject);
begin
  if FInput3D.Installed then
  begin
    Caption := FCaption + ' - ' + cTDxDeviceTypeNames[FInput3D.DeviceType] + ' enabled';
  end else
  begin
    Caption := FCaption + ' - 3D input device not installed';
  end;

end;

procedure TfrmMain.Input3DKeydown(Sender: TObject; AKeyCode: integer);
begin
//
end;

procedure TfrmMain.Input3DSensor(Sender: TObject; const AInput: TsdTDxInput);
begin
  frViewer.GLViewerInput3D(Sender, AInput);
  frSpaceball.UpdateInput3D(Sender, AInput);
end;

end.
