unit DxfMain;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ComCtrls, ExtCtrls, VirtualTrees, Menus, sdDxfFormat;

type
  TForm1 = class(TForm)
    MainMenu1: TMainMenu;
    File1: TMenuItem;
    mnuOpenDXF: TMenuItem;
    vstDxf: TVirtualStringTree;
    sbMain: TStatusBar;
    Splitter1: TSplitter;
    mnuNew: TMenuItem;
    mnuSaveDXF: TMenuItem;
    mnuSaveDxfAs: TMenuItem;
    vstProps: TVirtualStringTree;
    procedure FormCreate(Sender: TObject);
    procedure mnuOpenDXFClick(Sender: TObject);
    procedure vstDxfInitNode(Sender: TBaseVirtualTree; ParentNode,
      Node: PVirtualNode; var InitialStates: TVirtualNodeInitStates);
    procedure vstDxfInitChildren(Sender: TBaseVirtualTree;
      Node: PVirtualNode; var ChildCount: Cardinal);
    procedure vstDxfGetText(Sender: TBaseVirtualTree; Node: PVirtualNode;
      Column: TColumnIndex; TextType: TVSTTextType;
      var CellText: WideString);
    procedure vstDxfChange(Sender: TBaseVirtualTree; Node: PVirtualNode);
    procedure mnuNewClick(Sender: TObject);
    procedure mnuSaveDXFClick(Sender: TObject);
    procedure mnuSaveDxfAsClick(Sender: TObject);
    procedure vstPropsGetText(Sender: TBaseVirtualTree; Node: PVirtualNode;
      Column: TColumnIndex; TextType: TVSTTextType;
      var CellText: WideString);
    procedure vstPropsEditing(Sender: TBaseVirtualTree; Node: PVirtualNode;
      Column: TColumnIndex; var Allowed: Boolean);
    procedure vstPropsNewText(Sender: TBaseVirtualTree; Node: PVirtualNode;
      Column: TColumnIndex; NewText: WideString);
  private
    procedure Regenerate;
    procedure RegenerateTree;
    procedure RegenerateProperties(AItem: TDxfItem);
    procedure SaveDxf(const AFileName: string);
  public
    { Public declarations }
    FDxf: TDxfFormat;
    FFileName: string;
    FItem: TDxfItem;
  end;

var
  Form1: TForm1;

implementation

type
  PNodeRec = ^TNodeRec;
  TNodeRec = record
    Item: TDxfItem;
  end;

{$R *.dfm}

procedure TForm1.FormCreate(Sender: TObject);
begin
  FDxf := TDxfFormat.Create(Self);
  FDxf.New;
  FFileName := 'new.dxf';
  Regenerate;
end;

procedure TForm1.mnuNewClick(Sender: TObject);
begin
  FDxf.New;
  FFileName := 'new.dxf';
  Regenerate;
end;

procedure TForm1.SaveDxf(const AFileName: string);
var
  Tick: dword;
begin
  Tick := GetTickCount;
  FDxf.SaveToFile(AFileName);
  sbMain.SimpleText := Format('DXF saved in %d msec', [GetTickCount - Tick]);
end;

procedure TForm1.mnuOpenDXFClick(Sender: TObject);
var
  Tick: dword;
begin
  with TOpenDialog.Create(nil) do
    try
      Title := 'Open DXF';
      Filter := 'DXF files (*.dxf)|*.dxf';
      if Execute then begin
        FFileName := FileName;
        Tick := GetTickCount;
        FDxf.LoadFromFile(FFileName);
        sbMain.SimpleText := Format('DXF opened in %d msec', [GetTickCount - Tick]);
        Regenerate;
      end;
    finally
      Free;
    end;
end;

procedure TForm1.Regenerate;
begin
  Caption := Format('DxfAnalyse [%s]', [FFileName]);
  RegenerateProperties(nil);
  RegenerateTree;
end;

procedure TForm1.RegenerateTree;
begin
  vstDxf.RootNodeCount := 0;
  vstDxf.RootNodeCount := FDxf.Sections.Count;
end;

procedure TForm1.RegenerateProperties(AItem: TDxfItem);
begin
  vstProps.RootNodeCount := 0;
  FItem := AItem;
  if assigned(FItem) then
    vstProps.RootNodeCount := FItem.Properties.Count;
end;

procedure TForm1.vstDxfInitNode(Sender: TBaseVirtualTree; ParentNode,
  Node: PVirtualNode; var InitialStates: TVirtualNodeInitStates);
var
  FData, FParentData: PNodeRec;
  FParentItem: TDxfItem;
begin
  if ParentNode = nil then begin

    FData := Sender.GetNodeData(Node);
    FData.Item := FDxf.Sections[Node.Index];

  end else begin

    // We need to use the parent node
    FParentData := Sender.GetNodeData(ParentNode);
    FParentItem := FParentData.Item;

    // Find the new node
    FData := Sender.GetNodeData(Node);
    if integer(Node.Index) < FParentItem.ItemCount then begin
      FData.Item := FParentItem.Items[Node.Index];
    end;

  end;

  // Initial states
  InitialStates := [];
  if assigned(FData.Item) then begin
    // initial states
    if FData.Item.ItemCount > 0 then
      InitialStates := [ivsHasChildren];
  end;
end;

procedure TForm1.vstDxfInitChildren(Sender: TBaseVirtualTree;
  Node: PVirtualNode; var ChildCount: Cardinal);
var
  FData: PNodeRec;
begin
  FData := Sender.GetNodeData(Node);
  ChildCount := FData.Item.ItemCount;
end;

procedure TForm1.vstDxfGetText(Sender: TBaseVirtualTree;
  Node: PVirtualNode; Column: TColumnIndex; TextType: TVSTTextType;
  var CellText: WideString);
var
  FData: PNodeRec;
  AItem: TDxfItem;
begin
  FData := Sender.GetNodeData(Node);
  AItem := FData.Item;
  if TextType = ttNormal then begin
    case Column of
    0: CellText := AItem.TypeName;
    1: CellText := AItem.Name;
    end;
  end;
end;

procedure TForm1.vstDxfChange(Sender: TBaseVirtualTree;
  Node: PVirtualNode);
var
  FData: PNodeRec;
begin
  FData := Sender.GetNodeData(Node);
  if assigned(FData) then
    RegenerateProperties(FData.Item)
  else
    RegenerateProperties(nil);
end;

procedure TForm1.mnuSaveDXFClick(Sender: TObject);
begin
  SaveDxf(FFileName);
end;

procedure TForm1.mnuSaveDxfAsClick(Sender: TObject);
begin
  with TSaveDialog.Create(nil) do
    try
      Title := 'Save DXF';
      Filter := 'DXF files (*.dxf)|*.dxf';
      if Execute then begin
        FFileName := FileName;
        SaveDxf(FFileName);
        Regenerate;
      end;
    finally
      Free;
    end;
end;

procedure TForm1.vstPropsGetText(Sender: TBaseVirtualTree;
  Node: PVirtualNode; Column: TColumnIndex; TextType: TVSTTextType;
  var CellText: WideString);
var
  AProp: TDxfProperty;
begin
  if assigned(FItem) and assigned(Node) and
    (FItem.Properties.Count > integer(Node.Index)) then
  begin
    AProp := FItem.Properties[Node.Index];
    if TextType = ttNormal then
      case Column of
      0: CellText := IntToStr(AProp.ID);
      1: CellText := IdDescription(AProp.ID);
      2: CellText := AProp.Value;
      end;
  end;
end;

procedure TForm1.vstPropsEditing(Sender: TBaseVirtualTree;
  Node: PVirtualNode; Column: TColumnIndex; var Allowed: Boolean);
begin
  Allowed := Column = 2;
end;

procedure TForm1.vstPropsNewText(Sender: TBaseVirtualTree;
  Node: PVirtualNode; Column: TColumnIndex; NewText: WideString);
begin
  if (Column = 2) and assigned(FItem) and assigned(Node) and
     (integer(Node.Index) < FItem.Properties.Count) then
  begin
    FItem.Properties[Node.Index].Value := NewText;
    Invalidate;
    vstDxf.Invalidate;
  end;
end;

end.
