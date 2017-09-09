unit MenuBaseClass;

interface

uses classes, SysUtils, Menus, Vcl.ComCtrls,
  HiMECSConst, BaseConfigCollect;

type
  THiMECSMenuCollect = class;
  THiMECSMenuItem = class;

  TMenuBase = class(TpjhBase)
  private
    FHiMECSMenuCollect: THiMECSMenuCollect;
  public
    constructor Create(AOwner: TComponent);
    destructor Destroy; override;

    procedure Menu2TreeView(AMenu: TMenu; ATreeView: TTreeView; AHideDividers: Boolean=False);
    procedure MenuFromTreeView(AMenu: TMenu; ATreeView: TTreeView);
    procedure MenuCollect2TreeView(ATreeView: TTreeView);
    procedure SaveTreeViewToFile(ATreeView: TTreeView; AFileName: string; AIsEncrypt: Boolean);
    procedure LoadFromFile2TreeView(ATreeView: TTreeView; AFileName: string; AIsEncrypt: Boolean);
    procedure SortCollectByAbsIndex(ATreeView: TTreeView);
  published
    property HiMECSMenuCollect: THiMECSMenuCollect read FHiMECSMenuCollect write FHiMECSMenuCollect;
  end;

  THiMECSMenuItem = class(TCollectionItem)
  private
    FDLLName: string;
    FEventName: string;
    FFuncName: string;
    FCaption: string;
    FHint: string;
    FExeName: string;
    FImageListName: string;
    //FSubMenuIndex가 -1이 아닌 경우 ,로 분리되는 Index 나열, ''이면 Submenu 없음
    FNestedSubMenuIndex: string;

    FDLLFuncIndex,
    FParentMenuIndex,
    FMenuIndex,
    FSubMenuIndex: integer; //-1:메인헤드 0:레벨1, 1: 레벨2

    //TTreeNode property
    FLevelIndex,
    FNodeIndex,
    FAbsoluteIndex: integer;

    FImageIndex: integer;
    FUserLevel: THiMECSUserLevel;
    FUserCategory: THiMECSUserCategory;
  public
  published
    property UserLevel: THiMECSUserLevel read FUserLevel write FUserLevel;
    property UserCategory: THiMECSUserCategory read FUserCategory write FUserCategory;
    property DLLName: string read FDLLName write FDLLName;
    property EventName: string read FEventName write FEventName;
    property FuncName: string read FFuncName write FFuncName;
    property Caption: string read FCaption write FCaption;
    property Hint: string read FHint write FHint;
    property ExeName: string read FExeName write FExeName;
    property ImageListName: string read FImageListName write FImageListName;
    property NestedSubMenuIndex: string read FNestedSubMenuIndex write FNestedSubMenuIndex;

    property DLLFuncIndex: integer read FDLLFuncIndex write FDLLFuncIndex;
    property ParentMenuIndex: integer read FParentMenuIndex write FParentMenuIndex;
    property MenuIndex: integer read FMenuIndex write FMenuIndex;
    property SubMenuIndex: integer read FSubMenuIndex write FSubMenuIndex;
    property ImageIndex: integer read FImageIndex write FImageIndex;

    property LevelIndex: integer read FLevelIndex write FLevelIndex;
    property NodeIndex: integer read FNodeIndex write FNodeIndex;
    property AbsoluteIndex: integer read FAbsoluteIndex write FAbsoluteIndex;
  end;

  THiMECSMenuCollect = class(TCollection)
  private
    function GetItem(Index: Integer): THiMECSMenuItem;
    procedure SetItem(Index: Integer; const Value: THiMECSMenuItem);
  public
    function  Add: THiMECSMenuItem;
    function Insert(Index: Integer): THiMECSMenuItem;
    property Items[Index: Integer]: THiMECSMenuItem read GetItem  write SetItem; default;
  end;

implementation

{ THiMECSMenuCollect }

function THiMECSMenuCollect.Add: THiMECSMenuItem;
begin
  Result := THiMECSMenuItem(inherited Add);
end;

function THiMECSMenuCollect.GetItem(Index: Integer): THiMECSMenuItem;
begin
  Result := THiMECSMenuItem(inherited Items[Index]);
end;

function THiMECSMenuCollect.Insert(Index: Integer): THiMECSMenuItem;
begin
  Result := THiMECSMenuItem(inherited Insert(Index));
end;

procedure THiMECSMenuCollect.SetItem(Index: Integer; const Value: THiMECSMenuItem);
begin
  Items[Index].Assign(Value);
end;


{ TMenuBase }

constructor TMenuBase.Create(AOwner: TComponent);
begin
  FHiMECSMenuCollect := THiMECSMenuCollect.Create(THiMECSMenuItem);
end;

destructor TMenuBase.Destroy;
begin
  inherited Destroy;
  FHiMECSMenuCollect.Free;
end;

procedure TMenuBase.LoadFromFile2TreeView(ATreeView: TTreeView; AFileName: string;
  AIsEncrypt: Boolean);
begin
  LoadFromJSONFile(AFileName, ExtractFileName(AFileName), AIsEncrypt);
  MenuCollect2TreeView(ATreeView);
end;

procedure TMenuBase.Menu2TreeView(AMenu: TMenu; ATreeView: TTreeView;
  AHideDividers: Boolean);
var i    : Integer;
    Node : TTreeNode;
  procedure PopulateItems(ParentNode : TTreeNode ; Item : TMenuItem);
  var i    : Integer;
      Node : TTreeNode;
  begin
    Node := nil;
    for i:=0 to Pred(AMenu.Items.Count) do
    begin
      if AHideDividers then
      begin
        if ((AMenu.Items[i].Caption <> '-') and (AMenu.Items[i].Visible)) then
        begin
          Node           := ATreeView.Items.AddChild(ParentNode,AMenu.Items[i].Caption);
          Node.Data      := AMenu.Items[i];
          if  AMenu.Items[i].ImageIndex <> -1 then
          begin
            Node.ImageIndex    := AMenu.Items[i].ImageIndex;
            Node.StateIndex    := Node.ImageIndex;
            Node.SelectedIndex := Node.ImageIndex;
          end
          else
          begin
            Node.ImageIndex := 0;
            Node.StateIndex := 0;
            Node.SelectedIndex := 0;
          end;
        end;
        end
        else
        begin
          Node           := ATreeView.Items.AddChild(ParentNode,AMenu.Items[i].Caption);
          Node.Data      := AMenu.Items[i];
          if  AMenu.Items[i].ImageIndex <> -1 then
          begin
            Node.ImageIndex    := AMenu.Items[i].ImageIndex;
            Node.StateIndex    := Node.ImageIndex;
            Node.SelectedIndex := Node.ImageIndex;
          end
          else
          begin
            Node.ImageIndex := 0;
            Node.StateIndex := 0;
            Node.SelectedIndex :=0;
          end;
        end;
        PopulateItems(Node,AMenu.Items[i]);
      end;
  end;
begin
  //Images := AMenu.Images;
  ATreeView.Items.Clear;
  Node := nil;

  for i:=0 to Pred(AMenu.Items.Count) do
  begin
    if AHideDividers then
    begin
      if ((AMenu.Items[i].Caption<>'-') and (AMenu.Items[i].Visible))  then
      begin
        Node               := ATreeView.Items.Add(nil, AMenu.Items[i].Caption);
        Node.Data          := AMenu.Items[i];
        if  AMenu.Items[i].ImageIndex <> -1 then
        begin
          Node.ImageIndex    := AMenu.Items[i].ImageIndex;
          Node.StateIndex    := Node.ImageIndex;
          Node.SelectedIndex := Node.ImageIndex;
        end
        else
        begin
          Node.ImageIndex :=0;
          Node.StateIndex :=0;
          Node.SelectedIndex :=0;
        end;
      end;
    end
    else
    begin
      Node            := ATreeView.Items.Add(nil, AMenu.Items[i].Caption);
      Node.Data       := AMenu.Items[i];
      if  AMenu.Items[i].ImageIndex <> -1 then
      begin
        Node.ImageIndex    := AMenu.Items[i].ImageIndex;
        Node.StateIndex    := Node.ImageIndex;
        Node.SelectedIndex := Node.ImageIndex;
      end
      else
      begin
        Node.ImageIndex :=0;
        Node.StateIndex :=0;
        Node.SelectedIndex :=0;//FImageIndexForRootItems;
      end;
    end;

    PopulateItems(Node,AMenu.Items[i]);
  end;

end;

procedure TMenuBase.MenuCollect2TreeView(ATreeView: TTreeView);
var
  i, LLevel    : Integer;
  LNode, LNextNode : TTreeNode;
  CurrStr: string;
begin
  ATreeView.Items.Clear;
  LNode := nil;

  for i:=0 to Pred(HiMECSMenuCollect.Count) do
  begin
    CurrStr := HiMECSMenuCollect.Items[i].Caption;
    LLevel := HiMECSMenuCollect.Items[i].LevelIndex;

    if LNode = nil then
      LNode := ATreeView.Items.AddChildObject(nil, CurrStr, HiMECSMenuCollect.Items[i])
    else if LNode.Level = LLevel then
      LNode := ATreeView.Items.AddChildObject(LNode.Parent, CurrStr, HiMECSMenuCollect.Items[i])
    else if LNode.Level = (LLevel - 1) then
      LNode := ATreeView.Items.AddChildObject(LNode, CurrStr, HiMECSMenuCollect.Items[i])
    else if LNode.Level > LLevel then
    begin
      LNextNode := LNode.Parent;
      while LNextNode.Level > LLevel do
        LNextNode := LNextNode.Parent;
      LNode := ATreeView.Items.AddChildObject(LNextNode.Parent, CurrStr,HiMECSMenuCollect.Items[i]);
    end;

    if  HiMECSMenuCollect.Items[i].ImageIndex <> -1 then
    begin
      LNode.ImageIndex    := HiMECSMenuCollect.Items[i].ImageIndex;
      LNode.StateIndex    := LNode.ImageIndex;
      LNode.SelectedIndex := LNode.ImageIndex;
    end
    else
    begin
      LNode.ImageIndex := 0;
      LNode.StateIndex := 0;
      LNode.SelectedIndex :=0;
    end;
  end; //for
end;

procedure TMenuBase.MenuFromTreeView(AMenu: TMenu; ATreeView: TTreeView);
begin

end;

procedure TMenuBase.SaveTreeViewToFile(ATreeView: TTreeView;
  AFileName: string; AIsEncrypt: Boolean);
begin
  SortCollectByAbsIndex(ATreeView);
  SaveToJSONFile(AFileName, ExtractFileName(AFileName), AIsEncrypt);
end;

//CollectItem 순서를 Tree Node 순서로 재 배치 함
procedure TMenuBase.SortCollectByAbsIndex(ATreeView: TTreeView);
var
  LNode: TTreeNode;
  i: integer;

  procedure SortItem(ANode: TTreeNode);
  var
    LHiMECSMenuItem: THiMECSMenuItem;
  begin
    LHiMECSMenuItem := THiMECSMenuItem(ANode.Data);
    LHiMECSMenuItem.NodeIndex := ANode.Index;
    LHiMECSMenuItem.Index := ANode.AbsoluteIndex;
    LHiMECSMenuItem.ParentMenuIndex := ANode.Parent.Index;
    LHiMECSMenuItem.AbsoluteIndex := ANode.AbsoluteIndex;
    //LHiMECSMenuItem.MenuIndex := ANode.Parent.Index;
  end;

  {function TraverseNode(ANode: TTreeNode): TTreeNode;
  var
    LLN: TTreeNode;
    Li: integer;
  begin
    if not Assigned(ANode) then
      exit;

    SortItem(ANode);

    if ANode.HasChildren then
    begin
      LLN := ANode.GetFirstChild;

      for Li := 0 to ANode.Count - 1 do
      begin
        TraverseNode(LLN);
        LLN := LNode.GetNextChild(LLN);
      end;

      //exit;
    end;
  end;  }
begin
  for i := 0 to ATreeView.Items.Count - 1 do
  begin
    LNode := ATreeView.Items.Item[i];
    SortItem(LNode);
  end;
end;

end.
