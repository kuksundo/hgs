unit gtroSearchTreeview;
{*******************************************************************************
* Development of the TGtroSearchTreeview started on 26 May 2011
* The component is associated with a Search box (TEdit component) that is used
* to search the leaves of the tree for a match.
* The component uses an in-memory storage for its data called TreeviewStorage
* (a TStringList) from which the treeview is loaded each time a character is
* typed or deleted from the search box.
*
* How to maintain the TreeviewStorage when data is modified in the treeview either
* when nodes are added or deleted or when nodes are displaces with drag and drop.
*******************************************************************************}
interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ComCtrls, StdCtrls, ExtCtrls;


type
  TOnSearchModeChanged = procedure(Sendet: TObject; SearchMode: Boolean) of Object;

  TGtroSearchTreeview = class(TCustomTreeview)
    private
      FSearchMode: Boolean; // true when the search box is not empty
      FOnSearchModeChanged: TOnSearchModeChanged;
      FOnLeafNodeChecked: TTVExpandedEvent;
      FSearchBox: TEdit;
      procedure SearchBoxChange(Sender: TObject);
      procedure SetSearchBox(const Value: TEdit);
      procedure WMLButtonDown(var Msg: TWMLButtonDown); message WM_LBUTTONDOWN;
    public
      TreeviewStorage: TStringList;
      constructor Create(AOwner: TComponent); override;
      destructor Destroy; override;
      procedure LoadFromFile(const FileName: string);
      procedure LoadTreeFromStorage(SearchText: string);
      procedure SaveToFile(const FileName: string);
      procedure SaveTreeToList;
      property SearchMode: Boolean read FSearchMode;

    published
      property Align;
      property Anchors;
      property AutoExpand;
      property BevelEdges;
      property BevelInner;
      property BevelOuter;
      property BevelKind default bkNone;
      property BevelWidth;
      property BiDiMode;
      property BorderStyle;
      property BorderWidth;
      property ChangeDelay;
      property Color;
      property Ctl3D;
      property Constraints;
      property DoubleBuffered;
      property DragKind;
      property DragCursor;
      property DragMode;
      property Enabled;
      property Font;
      property HideSelection;
      property HotTrack;
      property Images;
      property Indent;
      property MultiSelect;
      property MultiSelectStyle;
      property ParentBiDiMode;
      property ParentColor default False;
      property ParentCtl3D;
      property ParentDoubleBuffered;
      property ParentFont;
      property ParentShowHint;
      property PopupMenu;
      property ReadOnly;
      property RightClickSelect;
      property RowSelect;
      property ShowButtons;
      property ShowHint;
      property ShowLines;
      property ShowRoot;
      property SortType;
      property StateImages;
      property TabOrder;
      property TabStop default True;
      property ToolTips;
      property Visible;
      property OnAddition;
      property OnAdvancedCustomDraw;
      property OnAdvancedCustomDrawItem;
      property OnChange;
      property OnChanging;
      property OnClick;
      property OnCollapsed;
      property OnCollapsing;
      property OnCompare;
      property OnContextPopup;
      property OnCreateNodeClass;
      property OnCustomDraw;
      property OnCustomDrawItem;
      property OnDblClick;
      property OnDeletion;
      property OnDragDrop;
      property OnDragOver;
      property OnEdited;
      property OnEditing;
      property OnEndDock;
      property OnEndDrag;
      property OnEnter;
      property OnExit;
      property OnExpanding;
      property OnExpanded;
      property OnGetImageIndex;
      property OnGetSelectedIndex;
      property OnKeyDown;
      property OnKeyPress;
      property OnKeyUp;
      property OnMouseActivate;
      property OnMouseDown;
      property OnMouseEnter;
      property OnMouseLeave;
      property OnMouseMove;
      property OnMouseUp;
      property OnStartDock;
      property OnStartDrag;
      { Items must be published after OnGetImageIndex and OnGetSelectedIndex }
      property Items;

      property SearchBox: TEdit read FSearchBox write SetSearchBox;
      property OnSearchModeChanged: TOnSearchModeChanged
        read FOnSearchModeChanged write FOnSearchModeChanged;
      property OnLeafNodeChecked: TTVExpandedEvent
        read FOnLeafNodeChecked  write FOnLeafNodeChecked;
  end;

procedure Register;

implementation

procedure Register;
begin
  RegisterComponents('GTRO', [TGTroSearchTreeview]);
end;

{ TGtroSearchTreeview }

constructor TGtroSearchTreeview.Create(AOwner: TComponent);
begin
  inherited;
  TreeviewStorage:= TStringList.Create;
end;

destructor TGtroSearchTreeview.Destroy;
begin
  TreeviewStorage.Free;
  inherited;
end;

procedure TGtroSearchTreeview.LoadFromFile(const FileName: string);
begin
  TreeviewStorage.LoadFromFile(FileName, TEncoding.Unicode);
  LoadTreeFromStorage('');
end;

procedure TGtroSearchTreeview.LoadTreeFromStorage(SearchText: string);
// code from https://forums.embarcadero.com/thread.jspa?messageID=84669
// modified as a method
// further modified to include case insensitive search and node selection
var
  List: TStringList;
  ANode, NextNode: TTreeNode;
  ALevel, i, LParentRem: Integer;
  CurrStr: string;
  Keep, KeepParent, KeepAncestors: Boolean;
  LevelRem: Integer;

  function GetBufStart(Buffer: string; var Level: Integer): string;
  var
    Pos: Integer;
  begin
    Pos := 1;
    Level := 0;
    while (CharInSet(Buffer[Pos], [' ', #9])) do
    begin
      Inc(Pos);
      Inc(Level);
    end;
    Result := Copy(Buffer, Pos, Length(Buffer) - Pos + 1);
  end;

begin
  List:= TStringList.Create;
  Items.Clear;
  Items.BeginUpdate;
  SearchText:= Lowercase(SearchText); // insures a case insensitive search
  FSearchMode:= Length(SearchText) <> 0; // true searcxh box not empty
  try
    try
      List.Assign(TreeviewStorage);
      // Search algorithm
      LevelRem:= 0; // 26 May 2011
      KeepParent:= false;
      if SearchMode then
      begin
        for i := List.Count - 1 downto 0 do // List is scanned from bottom to top
        begin
{$IF DEFINED(CLR)}
          CurrStr := GetBufStart(List[i], ALevel);
{$ELSE}
          CurrStr := GetBufStart(PChar(List[i]), ALevel);
{$IFEND}
          CurrStr:= Lowercase(CurrStr); // insures a case insensitive search
          if ALevel >= LevelRem then // node is a leaf
          begin
            Keep:= pos(SearchText, CurrStr) > 0; // Search string found if true
            if Keep then
            begin
              KeepParent:= true; // parent branch must be kept
              KeepAncestors:= true;
              LParentRem:= ALevel - 1;
            end
            else
              List.Delete(i);
          end; // if ALevel = LevelRem

          if ALevel = LevelRem - 1 then // node is a branch
          begin
            KeepParent:= false;
            if KeepAncestors and (ALevel = LParentRem) then
            begin
              KeepParent:= true;
              LParentRem:= LParentRem - 1;
            end;
            if not KeepParent then
              List.Delete(i)
            else if ALevel = 0 then
            KeepAncestors:= False;
          end;
          LevelRem:= ALevel;
        end;
      end;
      // Ready to build the treeview. If the "search string" is empty, all the
      // content of List will be used to fill the treeview. Otherwise, a filtered
      // list containing only the matched items and their parent will populate
      // the treeview.
      ANode := nil;
      for i := 0 to List.Count - 1 do // for each line of the list
      begin // extract CurrStr from the list and provide the level
{$IF DEFINED(CLR)}
        CurrStr := GetBufStart(List[i], ALevel);
{$ELSE}
        CurrStr := GetBufStart(PChar(List[i]), ALevel);
{$IFEND}
        if ANode = nil then
          ANode := Items.AddChild(nil, CurrStr)
        else if ANode.Level = ALevel then
          ANode := Items.AddChild(ANode.Parent, CurrStr)
        else if ANode.Level = (ALevel - 1) then
          ANode := Items.AddChild(ANode, CurrStr)
        else if ANode.Level > ALevel then
        begin
          NextNode := ANode.Parent;
          while NextNode.Level > ALevel do
            NextNode := NextNode.Parent;
          ANode := Items.AddChild(NextNode.Parent, CurrStr);
        end
        else raise ETreeViewError.CreateFmt('Invalid level (%d) for item "%s"', [ALevel, CurrStr]);
      end;
    finally
      Items.EndUpdate;
      if SearchMode then
        FullExpand;
      List.Free;
    end;
  except
    Invalidate;  // force repaint on exception
    raise;
  end;
end;

procedure TGtroSearchTreeview.SaveToFile(const FileName: string);
begin
  if not SearchMode then
    inherited;
end;

procedure TGtroSearchTreeview.SaveTreeToList;
// will save the treeview data to TreeviewStorage;
var
  i, j, Level: Integer;
  Text: string;
begin
  TreeviewStorage.Clear;
  for i := 0 to Items.Count - 1 do
  begin
    Level:= Items[i].Level;
    Text:= '';
    for j:= 1 to Level do
      Text:= Text + #9;
    TreeviewStorage.Add(Text + Items[i].Text)
  end;
end;

procedure TGtroSearchTreeview.SearchBoxChange(Sender: TObject);
begin
  LoadTreeFromStorage(SearchBox.Text);
  if Assigned(FOnSearchModeChanged) then
    FOnSearchModeChanged(Self, FSearchMode);
end;

procedure TGtroSearchTreeview.SetSearchBox(const Value: TEdit);
// true => SearchBoxChange() becomes the event handler for the OnChance event
begin
  if Assigned(Value) then
  begin
    FSearchBox:= Value;
    FSearchBox.OnChange:= SearchBoxChange;
  end;
end;

procedure TGtroSearchTreeview.WMLButtonDown(var Msg: TWMLButtonDown);
var
  Node: TTreeNode;
  HitTests: THitTests;
begin
  Node:= GetNodeAt(Msg.XPos, Msg.YPos); // reference of the node that was clicked
  if Node <> nil then // prevents AV if click occurs outside the node area
  begin
    HitTests:= GetHitTestInfoAt(Msg.XPos, Msg.YPos); // where was the node clicked
    if htOnLabel in HitTests then // node is selected
    begin
      if not Node.HasChildren then
      begin
        Node.Selected:= true;
        HideSelection:= false;
        if Assigned(FOnLeafNodeChecked) then
          FOnLeafNodeChecked(Self, Node);
      end;
    end;
    if htOnButton in HitTests then // Click on the [+] or [-] button
      if Node.Expanded then Node.Collapse(False)
      else Node.Expand(False);
  end;
end;

end.
