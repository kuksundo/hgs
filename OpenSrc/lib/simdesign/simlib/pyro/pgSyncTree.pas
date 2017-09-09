{ Project: Pyro

  Author: Nils Haeck (n.haeck@simdesign.nl)
  Copyright (c) 2006 - 2011 SimDesign BV
}
unit pgSyncTree;

interface

uses
  Classes, VirtualTrees, pgScene, pgDocument, Pyro;

type

  TpgSyncTree = class(TVirtualStringTree)
  private
    FScene: TpgScene;
    FViewPort: TpgViewPort; // root viewport
    procedure SetScene(const Value: TpgScene);
    procedure SceneChange(Sender: TObject; AElement: TpgElement; APropId: longword;
      AChange: TpgChangeType);
  protected
    procedure InvalidateItems;
    function GetElementFromNode(ANode: PVirtualNode): TpgElement;
    function GetElementName(AElement: TpgElement): widestring;
    procedure DoGetText(Node: PVirtualNode; Column: TColumnIndex; TextType: TVSTTextType;
      var Text: WideString); override;
    procedure DoInitChildren(Node: PVirtualNode; var ChildCount: Cardinal); override;
    procedure DoInitNode(Parent, Node: PVirtualNode; var InitStates: TVirtualNodeInitStates); override;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
  published
    property Scene: TpgScene read FScene write SetScene;
  end;

implementation

type
  TNodeInfo = record
    Element: pointer;
  end;
  PNodeInfo = ^TNodeInfo;

{ TpgSyncTree }

constructor TpgSyncTree.Create(AOwner: TComponent);
{var
  Col: TVirtualTreeColumn;}
begin
  inherited Create(AOwner);
  TreeOptions.MiscOptions := TreeOptions.MiscOptions + [toReportMode];
  Header.Options := Header.Options + [hoVisible];
{  Col := Header.Columns.Add;
  Col.Text := 'Shape List';}
  NodeDataSize := SizeOf(TNodeInfo);
end;

destructor TpgSyncTree.Destroy;
begin
  SetScene(nil);
  inherited;
end;

procedure TpgSyncTree.DoGetText(Node: PVirtualNode; Column: TColumnIndex;
  TextType: TVSTTextType; var Text: WideString);
var
  Element: TpgElement;
begin
  Element := GetElementFromNode(Node);
  if assigned(Element) then
    Text := GetElementName(Element);
  inherited;
end;

procedure TpgSyncTree.DoInitChildren(Node: PVirtualNode; var ChildCount: Cardinal);
var
  Element: TpgElement;
begin
  inherited;
  ChildCount := 0;
  Element := GetElementFromNode(Node);
  if not assigned(Element) then
    exit;
  ChildCount := Element.ElementCount;
end;

procedure TpgSyncTree.DoInitNode(Parent, Node: PVirtualNode; var InitStates: TVirtualNodeInitStates);
var
  Info: PNodeInfo;
  EP, Element: TpgElement;
begin
  inherited;
  if assigned(Parent) then
  begin
    // sub node
    EP := GetElementFromNode(Parent);
    if not assigned(EP) then exit;
    Element := EP.Elements[Node.Index];
    if not assigned(Element) then
      exit;
    Info := GetNodeData(Node);
    Info.Element := pointer(Element);
    if Element.ElementCount > 0 then
      InitStates := [ivsHasChildren];
  end else
  begin
    // root node -> Viewport
    Info := GetNodeData(Node);
    Info.Element := pointer(FViewPort);
    InitStates := [];
    if FViewPort.ElementCount > 0 then
      InitStates := [ivsHasChildren];
  end;
end;

function TpgSyncTree.GetElementFromNode(ANode: PVirtualNode): TpgElement;
var
  Info: PNodeInfo;
begin
  Result := nil;
  if not assigned(FScene) then
    exit;
  Info := GetNodeData(ANode);
  if not assigned(Info) then
    exit;
  Result := TpgElement(Info);
end;

function TpgSyncTree.GetElementName(AElement: TpgElement): widestring;
begin
  if AElement.ExistsLocal(AElement.PropById(piName)) then
    Result := UTF8Decode(TpgStringProp(AElement.PropById(piName)).AsString)
  else
    Result := Copy(AElement.ClassName, 4, length(AElement.ClassName));
end;

procedure TpgSyncTree.InvalidateItems;
begin
  Clear;
  RootNodecount := 0;
  FViewPort := nil;
  if assigned(FScene) and assigned(FScene.ViewPort) then
  begin
    FViewPort := FScene.ViewPort;
    RootNodeCount := 1
  end else
    RootNodeCount := 0;
end;

procedure TpgSyncTree.SceneChange(Sender: TObject; AElement: TpgElement;
  APropId: longword; AChange: TpgChangeType);
begin
  case AChange of
  ctListClear: RootNodeCount := 0;
  ctListUpdate:
    InvalidateItems;
//  ctElementAdd,
  ctElementListAdd:
    InvalidateItems;
{  ctElementRemove,  // Element with ElementId is/was removed
  ctElementListAdd,    // sub element added
  ctElementListRemove, // sub element removed
  ctPropAdd,        // Prop with PropId is/was added to Element
  ctPropRemove,     // Prop with PropId is/was removed from Element
  ctPropUpdate      // Prop with PropId is/was updated in Element}
  end;
end;

procedure TpgSyncTree.SetScene(const Value: TpgScene);
var
  L: TpgSceneListener;
begin
  if FScene <> Value then begin
    if assigned(FScene) then
      FScene.Listeners.DeleteRef(Self);
    FScene := Value;
    if assigned(FScene) then
    begin
      L := FScene.Listeners.AddRef(Self);
      L.OnAfterChange := SceneChange;
    end;
    InvalidateItems;
  end;
end;

end.
