unit MainUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Mask, JvExMask, JvToolEdit, StdCtrls, JvExStdCtrls, JvHtControls,
  Buttons, ExtCtrls, NxScrollControl, NxCustomGridControl, NxCustomGrid, NxGrid,
  Menus, NextGridUtil,
  MenuBaseClass, JvgXMLSerializer_Encrypt, NxColumnClasses, NxColumns,
  JvCombobox, ActnList, JvButton, JvCtrls, ImgList, Vcl.ComCtrls, JvExComCtrls,
  JvComCtrls, JvCheckTreeView, System.Actions;

type
  TMainForm = class(TForm)
    Panel1: TPanel;
    Splitter1: TSplitter;
    MainMenu1: TMainMenu;
    File1: TMenuItem;
    Close1: TMenuItem;
    PopupMenu1: TPopupMenu;
    Delete1: TMenuItem;
    MoveUp1: TMenuItem;
    MoveDown1: TMenuItem;
    Panel2: TPanel;
    ImageList2: TImageList;
    Label17: TLabel;
    JvCheckTreeView1: TJvCheckTreeView;
    PopupMenu2: TPopupMenu;
    Newitem1: TMenuItem;
    DeleteItem1: TMenuItem;
    imTreeView: TImageList;
    NewSubItem1: TMenuItem;
    N1: TMenuItem;
    Panel3: TPanel;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    Label9: TLabel;
    Bevel1: TBevel;
    Label10: TLabel;
    Label11: TLabel;
    Label12: TLabel;
    Label13: TLabel;
    Label15: TLabel;
    FuncNameEdit: TEdit;
    CaptionEdit: TEdit;
    HintEdit: TEdit;
    DLLFilenameEdit: TJvFilenameEdit;
    DLLFuncIndexEdit: TEdit;
    AbsEdit: TEdit;
    NodeIndexEdit: TEdit;
    BitBtn1: TBitBtn;
    Button1: TButton;
    Button2: TButton;
    Button3: TButton;
    Button4: TButton;
    UserLevelCB: TJvComboBox;
    CategoryCB: TJvComboBox;
    Button5: TButton;
    EncryptCB: TCheckBox;
    PassPhraseEdit: TEdit;
    ImageListNameEdit: TEdit;
    ImageIndexEdit: TEdit;
    LevelEdit: TEdit;
    EventNameEdit: TEdit;
    N2: TMenuItem;
    SortCollectItembyNodeIndex1: TMenuItem;
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure Button2Click(Sender: TObject);
    procedure Close1Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure Button4Click(Sender: TObject);
    procedure EncryptCBClick(Sender: TObject);
    procedure JvCheckTreeView1DragDrop(Sender, Source: TObject; X, Y: Integer);
    procedure JvCheckTreeView1DragOver(Sender, Source: TObject; X, Y: Integer;
      State: TDragState; var Accept: Boolean);
    procedure Newitem1Click(Sender: TObject);
    procedure DeleteItem1Click(Sender: TObject);
    procedure NewSubItem1Click(Sender: TObject);
    procedure JvCheckTreeView1Deletion(Sender: TObject; Node: TTreeNode);
    procedure JvCheckTreeView1Click(Sender: TObject);
    procedure JvCheckTreeView1DblClick(Sender: TObject);
    procedure SortCollectItembyNodeIndex1Click(Sender: TObject);
    procedure Button1Click(Sender: TObject);
  private
    procedure MoveNode(ATreeView: TTreeView; ATargetNode, ASourceNode: TTreeNode);
  public
    FMenuBase: TMenuBase;
    FGridChanged: Boolean;
    FDeleteMode: Boolean;
    FNewItemCount: integer;

    procedure SetHiMECSMainMenu(AMenuBase: TMenuBase);
    procedure LoadMenuFromFile;
    procedure NodeItem2MenuCollectForm(ANode: TTreeNode);
    procedure MenuCollectForm2NodeItem(ANode: TTreeNode);

    procedure AddNewTreeNode(ANode: TTreeNode; ASubNode: boolean);

    function AddToMenu(Ami, ATarget: TMenuItem; AIsSubMenu: Boolean): TMenuItem;
    function AddMenuItem(Menu: TMenuItem; const Caption: string;
      OnClick: TNotifyEvent = nil; Action: TContainedAction = nil;
      ShortCut: TShortCut = 0; const Hint: string = ''; Tag: Integer = 0): TMenuItem;
    function InsertMenuItem(AMenu: TMenuItem; AInsertIndex: Integer; ANested: string;
      AOnClick: TNotifyEvent = nil; Action: TContainedAction = nil;
      AShortCut: TShortCut = 0): TMenuItem;

    function CheckMenuValid(AMenuIndex, ASubMenuIndex: integer;
                      var ACollectIndex: integer; ANested: string): Boolean;
  end;

var
  MainForm: TMainForm;

implementation

uses MenuSaveUnit, HiMECSConst, CommonUtil;

{$R *.dfm}

procedure SetNodeImages(Node : TTreeNode; HasChildren : boolean);
begin
  if HasChildren then begin
    //Node.HasChildren    := true;
    Node.ImageIndex     := cClosedBook;
    Node.SelectedIndex  := cOpenBook;
  end else begin
    Node.ImageIndex     := cClosedPage;
    Node.SelectedIndex  := cOpenPage;
  end; {if}
end; {SetNodeImages}

procedure TMainForm.AddNewTreeNode(ANode: TTreeNode; ASubNode: boolean);
var
  Node1 : TTreeNode;
  LHMItem: THiMECSMenuItem;
begin
  inc(FNewItemCount);

  LHMItem := FMenuBase.HiMECSMenuCollect.Add;

  if ASubNode then
  begin
    if Assigned(ANode) then
      Node1 := JvCheckTreeView1.Items.AddChildObject(ANode,
               'New'+IntToStr(FNewItemCount), LHMItem)
    else
      Node1 := JvCheckTreeView1.Items.AddChildObject(nil,
               'New'+IntToStr(FNewItemCount), LHMItem);
  end
  else
  begin
    if Assigned(ANode) then
      Node1 := JvCheckTreeView1.Items.AddObject(ANode,
               'New'+IntToStr(FNewItemCount), LHMItem)
    else
      Node1 := JvCheckTreeView1.Items.AddObject(nil,
               'New'+IntToStr(FNewItemCount), LHMItem);
  end;

  LHMItem.AbsoluteIndex := Node1.AbsoluteIndex;
  LHMItem.NodeIndex := Node1.Index;
  LHMItem.LevelIndex := Node1.Level;
  LHMItem.Index := Node1.AbsoluteIndex;

  SetNodeImages(Node1, False);
end;

function TMainForm.AddToMenu(Ami, ATarget: TMenuItem;
  AIsSubMenu: Boolean): TMenuItem;
begin
  //MainMenu1.Items.MenuIndex
end;

procedure TMainForm.Button1Click(Sender: TObject);
begin
  MenuCollectForm2NodeItem(JvCheckTreeView1.Selected);
end;

procedure TMainForm.Button2Click(Sender: TObject);
begin
  SetHiMECSMainMenu(FMenuBase);
end;

procedure TMainForm.Button3Click(Sender: TObject);
var
  LFileName:string;
  LTJvgXMLSerializer_Encrypt: TJvgXMLSerializer_Encrypt;
  F : TextFile;
begin
  with TMenuSaveF.create(nil) do
  begin
    try
      if ShowModal = mrOK then
      begin
        LFileName := JvFilenameEdit1.FileName;

        if LFileName <> '' then
        begin
          if FileExists(LFileName) then
          begin

            if MessageDlg('이전에 작업한자료가 있습니다. 덮어쓰시겠습니까?',
            mtConfirmation, [mbYes, mbNo], 0)=mrNo then
              //FMenuBase.LoadFromFile(LFileName, ExtractFileName(LFileName),EncryptCB.Checked)
              exit
            //Append(F)
            else
            begin
              AssignFile(F, LFileName);
              Rewrite(F);
              CloseFile(F);
            end;
          end;

          FMenuBase.SaveTreeViewToFile(JvCheckTreeView1, LFileName, EncryptCB.Checked);
        end
        else
          ShowMessage('File name is empty!');
      end;
    finally
      free;
    end;
  end;
end;

procedure TMainForm.Button4Click(Sender: TObject);
begin
  LoadMenuFromFile;
end;

procedure TMainForm.EncryptCBClick(Sender: TObject);
begin
  Label10.Enabled := EncryptCB.Checked;
  PassPhraseEdit.Enabled := EncryptCB.Checked;
end;

function TMainForm.CheckMenuValid(AMenuIndex, ASubMenuIndex: integer;
  var ACollectIndex: integer; ANested: string): Boolean;
var
  Li: integer;
begin
{  Result := True;
  ACollectIndex := -1;

  //MenuIndex가 존재하고 SubMenuIndex = -1인 항목이 없으면 에러(Result := False)
  if (AMenuIndex = -1) and (ASubMenuIndex = -1) then
  begin
    for Li := 0 to FMenuBase.HiMECSMenuCollect.Count - 1 do
    begin
      //if (FMenuBase.HiMECSMenuCollect.Items[Li].MenuIndex = AMenuIndex) and
      //  (FMenuBase.HiMECSMenuCollect.Items[Li].SubMenuIndex = ASubMenuIndex) then
      //begin
      //  ACollectIndex := Li;
      //  Result := False;
      //  exit;
      //end;
    end;
  end;

  for Li := 0 to FMenuBase.HiMECSMenuCollect.Count - 1 do
  begin
    if (FMenuBase.HiMECSMenuCollect.Items[Li].MenuIndex = AMenuIndex) and
      (FMenuBase.HiMECSMenuCollect.Items[Li].SubMenuIndex = ASubMenuIndex) and
      (FMenuBase.HiMECSMenuCollect.Items[Li].NestedSubMenuIndex = ANested) then
    begin
      ACollectIndex := Li;
      Result := False;
      exit;
    end;
  end;
}
end;

procedure TMainForm.Close1Click(Sender: TObject);
begin
  Close;
end;

procedure TMainForm.DeleteItem1Click(Sender: TObject);
begin
  if Dialogs.MessageDlg(JvCheckTreeView1.Selected.Text + ' 를 지우시겠습니까? ' +#13#10,
    mtConfirmation, [mbYes, mbNo], 0, mbYes) = mrYes then
  begin
    try
      FDeleteMode := True;
      JvCheckTreeView1.Selected.DeleteChildren;
      JvCheckTreeView1.Selected.Delete;
    finally
      FDeleteMode := False;
    end;
  end;
end;

procedure TMainForm.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  FMenuBase.HiMECSMenuCollect.Clear;
  FreeAndNil(FMenuBase);
end;

procedure TMainForm.FormCreate(Sender: TObject);
begin
  FMenuBase := TMenuBase.Create(nil);

  UserLevel2Strings(UserLevelCB.Items);
  UserCatetory2Strings(CategoryCB.Items);
  //UserLevel2Strings(UserLevel.Items);
  //UserCatetory2Strings(Category.Items);
  FGridChanged := False;
  FDeleteMode := False;
  FNewItemCount := 0;
end;

function TMainForm.InsertMenuItem(AMenu: TMenuItem; AInsertIndex: Integer;
  ANested: string; AOnClick: TNotifyEvent; Action: TContainedAction;
  AShortCut: TShortCut): TMenuItem;
var
  LStr: string;
  LIndex: integer;
begin
  Result := nil;

  LStr := strToken(ANested, ',');
  LIndex := StrToInt(LStr);

  if ANested <> '' then
  begin
    Result := InsertMenuItem(AMenu.Items[LIndex], AInsertIndex, ANested);
  end
  else
  begin
    Result := TMenuItem.Create(Self);
    Result.Caption := FMenuBase.HiMECSMenuCollect.Items[AInsertIndex].Caption;
    Result.Hint := FMenuBase.HiMECSMenuCollect.Items[AInsertIndex].Hint;
    Result.OnClick := AOnClick;
    Result.ShortCut := AShortCut;
    Result.Action := Action;

    AMenu.Insert(LIndex, Result);
  end;

end;

{
procedure TMainForm.JvCheckTreeView1DragDrop(Sender, Source: TObject; X,
  Y: Integer);
var
  AnItem: TTreeNode;
  AttachMode: TNodeAttachMode;
  HT: THitTests;
begin
  if JvCheckTreeView1.Selected = nil then Exit;

  HT := JvCheckTreeView1.GetHitTestInfoAt(X, Y) ;
  AnItem := JvCheckTreeView1.GetNodeAt(X, Y) ;

  if (HT - [htOnItem, htOnIcon, htNowhere, htOnIndent] <> HT) then
  begin
    if (htOnItem in HT) or (htOnIcon in HT) then
      AttachMode := naAddChild
    else if htNowhere in HT then
      AttachMode := naAdd
    else if htOnIndent in HT then
      AttachMode := naInsert;

      JvCheckTreeView1.Selected.MoveTo(AnItem, AttachMode) ;
    end;
 end;
}

procedure TMainForm.JvCheckTreeView1Click(Sender: TObject);
begin
  NodeItem2MenuCollectForm(JvCheckTreeView1.Selected);
end;

procedure TMainForm.JvCheckTreeView1DblClick(Sender: TObject);
begin
//  ShowMessage(IntToStr(THiMECSMenuItem(JvCheckTreeView1.Selected.data).Index));
//  ShowMessage(IntToStr(THiMECSMenuItem(JvCheckTreeView1.Selected.data).Index) + ':' + IntToStr(JvCheckTreeView1.Selected.AbsoluteIndex));
end;

procedure TMainForm.JvCheckTreeView1Deletion(Sender: TObject; Node: TTreeNode);
var
  LHMItem: THiMECSMenuItem;
  i: integer;
begin
  if Assigned(FMenuBase) then
  begin
    if FDeleteMode then
    begin
      LHMItem := THiMECSMenuItem(Node.Data);
      FMenuBase.HiMECSMenuCollect.Delete(LHMItem.Index);
    end;
  end;
end;

procedure TMainForm.JvCheckTreeView1DragDrop(Sender, Source: TObject; X,
  Y: Integer);
var
  LTargetNode, LSourceNode: TTreeNode;
  i:integer;
begin
  if (Sender = JvCheckTreeView1) then
  begin
    with JvCheckTreeView1 do
    begin
      LTargetNode := GetNodeAt( X, Y ); //Get Target Node
      LSourceNode := Selected;

      if (LTargetNode = nil) or (LTargetNode = LSourceNode) then
      begin
        EndDrag(False);
        Exit;
      end;
    end;

    MoveNode(JvCheckTreeView1, LTargetNode, LSourceNode);
    LSourceNode.Free;
  end
  else if (Sender <> JvCheckTreeView1) then
  begin
  end;
end;

procedure TMainForm.JvCheckTreeView1DragOver(Sender, Source: TObject; X,
  Y: Integer; State: TDragState; var Accept: Boolean);
begin
  if (Sender = JvCheckTreeView1) then
  begin
    Accept := True;
  end;
end;

procedure TMainForm.LoadMenuFromFile;
var
  LFileName:string;
  LTJvgXMLSerializer_Encrypt: TJvgXMLSerializer_Encrypt;
begin
  with TMenuSaveF.create(nil) do
  begin
    try
      if ShowModal = mrOK then
      begin
        LFileName := JvFilenameEdit1.FileName;
        if LFileName <> '' then
        begin
          FMenuBase.LoadFromFile2TreeView(JvCheckTreeView1, LFileName, EncryptCB.Checked);

          {LTJvgXMLSerializer_Encrypt := TJvgXMLSerializer_Encrypt.Create(nil);
          try
            FMenuBase.HiMECSMenuCollect.Clear;
            FMenuBase.LoadFromFile(LFileName,PassPhraseEdit.Text,EncryptCB.Checked);
          finally
            LTJvgXMLSerializer_Encrypt.Free;
          end;}
        end
        else
          ShowMessage('File name is empty!');
      end;
    finally
      free;
    end;
  end;
end;

procedure TMainForm.MenuCollectForm2NodeItem(ANode: TTreeNode);
var
  LHiMECSMenuItem: THiMECSMenuItem;
begin
  if not Assigned(ANode) then
    exit;

  LHiMECSMenuItem := THiMECSMenuItem(ANode.Data);

  LHiMECSMenuItem.Caption := CaptionEdit.Text;
  LHiMECSMenuItem.FuncName := FuncNameEdit.Text;
  LHiMECSMenuItem.EventName := EventNameEdit.Text;
  LHiMECSMenuItem.DLLName := DLLFilenameEdit.Text;
  LHiMECSMenuItem.Hint := HintEdit.Text;
  LHiMECSMenuItem.DLLFuncIndex := StrToIntDef(DLLFuncIndexEdit.Text,0);
  LHiMECSMenuItem.AbsoluteIndex := StrToIntDef(AbsEdit.Text,0);
  LHiMECSMenuItem.NodeIndex := StrToIntDef(NodeIndexEdit.Text,0);
  LHiMECSMenuItem.LevelIndex := StrToIntDef(LevelEdit.Text,0);
  LHiMECSMenuItem.UserLevel := String2UserLevel(UserLevelCB.Text);
  LHiMECSMenuItem.UserCategory := String2UserCategory(CategoryCB.Text);
  LHiMECSMenuItem.ImageListName := ImageListNameEdit.Text;
  LHiMECSMenuItem.ImageIndex := StrToIntDef(ImageIndexEdit.Text,0);

  ANode.Text := CaptionEdit.Text;
end;

procedure TMainForm.MoveNode(ATreeView: TTreeView; ATargetNode,
  ASourceNode: TTreeNode);
var
  LNode: TTreeNode;
  i: integer;
  LHMItem: THiMECSMenuItem;
begin
  With ATreeView do
  begin
    LHMItem := THiMECSMenuItem(ASourceNode.Data);
    LNode := Items.AddChildObject(ATargetNode, ASourceNode.Text, LHMItem);

    for i := 0 to ASourceNode.Count - 1 do
    begin
      MoveNode(ATreeView, LNode, ASourceNode.Item[i]);
    end;

    //ASourceNode.Free;

    LHMItem.AbsoluteIndex := LNode.AbsoluteIndex;
    LHMItem.NodeIndex := LNode.Index;
    LHMItem.LevelIndex := LNode.Level;
    //LHMItem.Index := LNode.AbsoluteIndex;
    //ShowMessage(IntToStr(LHMItem.Index));


  end;
end;

procedure TMainForm.Newitem1Click(Sender: TObject);
begin
  AddNewTreeNode(JvCheckTreeView1.Selected, False);
end;

procedure TMainForm.NewSubItem1Click(Sender: TObject);
begin
  AddNewTreeNode(JvCheckTreeView1.Selected, True);
end;

procedure TMainForm.NodeItem2MenuCollectForm(ANode: TTreeNode);
var
  LHiMECSMenuItem: THiMECSMenuItem;
begin
  if not Assigned(ANode) then
    exit;

  LHiMECSMenuItem := THiMECSMenuItem(ANode.Data);

  CaptionEdit.Text := LHiMECSMenuItem.Caption;
  FuncNameEdit.Text := LHiMECSMenuItem.FuncName;
  EventNameEdit.Text := LHiMECSMenuItem.EventName;
  DLLFilenameEdit.Text := LHiMECSMenuItem.DLLName;
  HintEdit.Text := LHiMECSMenuItem.Hint;
  DLLFuncIndexEdit.Text := IntToStr(LHiMECSMenuItem.DLLFuncIndex);
  AbsEdit.Text := IntToStr(LHiMECSMenuItem.AbsoluteIndex);
  NodeIndexEdit.Text := IntToStr(LHiMECSMenuItem.NodeIndex);
  LevelEdit.Text := IntToStr(LHiMECSMenuItem.LevelIndex);
  UserLevelCB.Text := UserLevel2String(LHiMECSMenuItem.UserLevel);
  CategoryCB.Text := UserCategory2String(LHiMECSMenuItem.UserCategory);
  ImageListNameEdit.Text := LHiMECSMenuItem.ImageListName;
  ImageIndexEdit.Text := IntToStr(LHiMECSMenuItem.ImageIndex);
end;

//MenuItem을 Insert하기 전에 반드시 Parent Item이 생성 되어 있어야 함.
procedure TMainForm.SetHiMECSMainMenu(AMenuBase: TMenuBase);
var
  LMenuItem: TMenuItem;
  Li,Lj: integer;
begin
{  for Li := FMenuBase.HiMECSMenuCollect.Count - 1 downto 0 do
  begin
    if (MainMenu1.Items.Count - 1) >= FMenuBase.HiMECSMenuCollect.Items[Li].MenuIndex then
      MainMenu1.Items.Delete(FMenuBase.HiMECSMenuCollect.Items[Li].MenuIndex);
  end;
}
  MainMenu1.Items.Clear;

  //Main Menu Insert
  for Li := 0 to FMenuBase.HiMECSMenuCollect.Count - 1 do
  begin
    LMenuItem := TMenuItem.Create(Self);
    LMenuItem.Caption := FMenuBase.HiMECSMenuCollect.Items[Li].Caption;
    LMenuItem.Hint := FMenuBase.HiMECSMenuCollect.Items[Li].Hint;

    if FMenuBase.HiMECSMenuCollect.Items[Li].LevelIndex = 0 then
      MainMenu1.Items.Insert(FMenuBase.HiMECSMenuCollect.Items[Li].NodeIndex,LMenuItem)
    else
    if FMenuBase.HiMECSMenuCollect.Items[Li].LevelIndex =
                        FMenuBase.HiMECSMenuCollect.Items[Li-1].LevelIndex then
    begin
      Lj := FMenuBase.HiMECSMenuCollect.Items[Li].ParentMenuIndex;
      MainMenu1.Items[Lj].Insert(FMenuBase.HiMECSMenuCollect.Items[Li].NodeIndex, LMenuItem);
    end
    else
    if (FMenuBase.HiMECSMenuCollect.Items[Li].LevelIndex - 1) =
                      FMenuBase.HiMECSMenuCollect.Items[Li-1].LevelIndex then
    begin
      Lj := FMenuBase.HiMECSMenuCollect.Items[Li].ParentMenuIndex;
      MainMenu1.Items[Lj].Insert(FMenuBase.HiMECSMenuCollect.Items[Li].NodeIndex,LMenuItem);
    end
    else
    if FMenuBase.HiMECSMenuCollect.Items[Li-1].LevelIndex >
                        FMenuBase.HiMECSMenuCollect.Items[Li].LevelIndex then
    begin
      Lj := FMenuBase.HiMECSMenuCollect.Items[Li].ParentMenuIndex;
      while FMenuBase.HiMECSMenuCollect.Items[Lj].LevelIndex >
            FMenuBase.HiMECSMenuCollect.Items[Li].LevelIndex do
        Lj := FMenuBase.HiMECSMenuCollect.Items[Li].ParentMenuIndex;

      MainMenu1.Items[Lj].Insert(FMenuBase.HiMECSMenuCollect.Items[Li].NodeIndex,LMenuItem)
    end;
  end;

  //SubMenu Insert
{  for Li := 0 to FMenuBase.HiMECSMenuCollect.Count - 1 do
  begin
    if FMenuBase.HiMECSMenuCollect.Items[Li].LevelIndex <> 0 then
    begin
      Lj := FMenuBase.HiMECSMenuCollect.Items[Li].NodeIndex;
      InsertMenuItem(MainMenu1.Items[Lj], Li, FMenuBase.HiMECSMenuCollect.Items[Li].NestedSubMenuIndex);
    end;
  end;
}
end;

procedure TMainForm.SortCollectItembyNodeIndex1Click(Sender: TObject);
begin
  FMenuBase.SortCollectByAbsIndex(JvCheckTreeView1);
end;

function TMainForm.AddMenuItem(Menu: TMenuItem; const Caption: string;
  OnClick: TNotifyEvent = nil; Action: TContainedAction = nil;
  ShortCut: TShortCut = 0; const Hint: string = ''; Tag: Integer = 0): TMenuItem;
begin
  Result := TMenuItem.Create(Menu);
  Result.Caption := Caption;
  Result.OnClick := OnClick;
  Result.ShortCut := ShortCut;

  if Hint = '' then
    Result.Hint := StripHotkey(Caption)
  else
    Result.Hint := Hint;

  Result.Tag := Tag;
  Result.Action := Action;
  Menu.Add(Result);
end;

end.
