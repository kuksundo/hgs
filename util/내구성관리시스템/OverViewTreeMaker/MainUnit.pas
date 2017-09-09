unit MainUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  System.Actions,
  Dialogs, Mask, JvExMask, JvToolEdit, StdCtrls, JvExStdCtrls, JvHtControls,
  Buttons, ExtCtrls, NxScrollControl, NxCustomGridControl, NxCustomGrid, NxGrid,
  Menus, NextGridUtil,
  PMSOverViewClass, JvgXMLSerializer_Encrypt, NxColumnClasses, NxColumns,
  JvCombobox, ActnList, JvButton, JvCtrls, ImgList, Vcl.ComCtrls, JvExComCtrls,
  JvComCtrls, JvCheckTreeView;

type
  TMainForm = class(TForm)
    Panel1: TPanel;
    Splitter1: TSplitter;
    MainMenu1: TMainMenu;
    File1: TMenuItem;
    Close1: TMenuItem;
    Panel2: TPanel;
    ImageList2: TImageList;
    JvCheckTreeView1: TJvCheckTreeView;
    PopupMenu2: TPopupMenu;
    Newitem1: TMenuItem;
    DeleteItem1: TMenuItem;
    imTreeView: TImageList;
    NewSubItem1: TMenuItem;
    N1: TMenuItem;
    Panel3: TPanel;
    Label3: TLabel;
    Label4: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    Bevel1: TBevel;
    Label10: TLabel;
    Label12: TLabel;
    Label13: TLabel;
    CompnameEdit: TEdit;
    CaptionEdit: TEdit;
    AbsEdit: TEdit;
    NodeIndexEdit: TEdit;
    BitBtn1: TBitBtn;
    Button1: TButton;
    Button2: TButton;
    Button3: TButton;
    Button4: TButton;
    Button5: TButton;
    EncryptCB: TCheckBox;
    PassPhraseEdit: TEdit;
    ImageIndexEdit: TEdit;
    LevelEdit: TEdit;
    N2: TMenuItem;
    SortCollectItembyNodeIndex1: TMenuItem;
    Label1: TLabel;
    PMSEquipTypeCB: TComboBox;
    Label2: TLabel;
    Tag_Name_Edit: TEdit;
    Label5: TLabel;
    Tag_Index_Edit: TEdit;
    Button6: TButton;
    Button7: TButton;
    Label8: TLabel;
    HiMAPTypeCB: TComboBox;
    Label9: TLabel;
    BitIndexEdit: TEdit;
    DependChildCB: TCheckBox;
    UpPowerRevCB: TCheckBox;
    Label11: TLabel;
    UnionGroupEdit: TEdit;
    DownPowerRevCB: TCheckBox;
    DefaultRevCB: TCheckBox;
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
    procedure PMSEquipTypeCBDropDown(Sender: TObject);
    procedure Button6Click(Sender: TObject);
    procedure Button7Click(Sender: TObject);
    procedure HiMAPTypeCBDropDown(Sender: TObject);
    procedure HiMAPTypeCBSelect(Sender: TObject);
  private
    procedure MoveNode(ATreeView: TTreeView; ATargetNode, ASourceNode: TTreeNode);
  public
    FPMSOverViewBase: TPMSOverViewBase;
    FGridChanged: Boolean;
    FDeleteMode: Boolean;
    FNewItemCount: integer;

    procedure SetHiMECSMainMenu(APMSOverViewBase: TPMSOverViewBase);
    procedure LoadTreeFromFile;
    procedure NodeItem2MenuCollectForm(ANode: TTreeNode);
    procedure MenuCollectForm2NodeItem(ANode: TTreeNode);

    procedure AddNewTreeNode(ANode: TTreeNode; ASubNode: boolean);
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
  LHMItem: TPMSOverViewItem;
begin
  inc(FNewItemCount);

  LHMItem := FPMSOverViewBase.PMSOverViewCollect.Add;

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

procedure TMainForm.Button1Click(Sender: TObject);
begin
  MenuCollectForm2NodeItem(JvCheckTreeView1.Selected);
end;

procedure TMainForm.Button2Click(Sender: TObject);
begin
  SetHiMECSMainMenu(FPMSOverViewBase);
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
              //FPMSOverViewBase.LoadFromFile(LFileName, ExtractFileName(LFileName),EncryptCB.Checked)
              exit
            //Append(F)
            else
            begin
              AssignFile(F, LFileName);
              Rewrite(F);
              CloseFile(F);
            end;
          end;

          FPMSOverViewBase.SaveTreeViewToFile(JvCheckTreeView1, LFileName, EncryptCB.Checked);
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
  LoadTreeFromFile;
end;

procedure TMainForm.Button6Click(Sender: TObject);
begin
  JvCheckTreeView1.Items.BeginUpdate;
  try
    if JvCheckTreeView1.SelectedCount > 0 then
      JvCheckTreeView1.Selected.Collapse(True)
    else
      JvCheckTreeView1.FullCollapse;
  finally
    JvCheckTreeView1.Items.EndUpdate;
  end;
end;

procedure TMainForm.Button7Click(Sender: TObject);
begin
  JvCheckTreeView1.Items.BeginUpdate;
  try
    if JvCheckTreeView1.SelectedCount > 0 then
      JvCheckTreeView1.Selected.Expand(True)
    else
      JvCheckTreeView1.FullExpand;
  finally
    JvCheckTreeView1.Items.EndUpdate;
  end;
end;

procedure TMainForm.EncryptCBClick(Sender: TObject);
begin
  Label10.Enabled := EncryptCB.Checked;
  PassPhraseEdit.Enabled := EncryptCB.Checked;
end;

procedure TMainForm.Close1Click(Sender: TObject);
begin
  Close;
end;

procedure TMainForm.HiMAPTypeCBDropDown(Sender: TObject);
begin
  HiMAPType2Combo(HiMAPTypeCB);
end;

procedure TMainForm.HiMAPTypeCBSelect(Sender: TObject);
begin
  Label9.Visible := (HiMAPTypeCB.Text = 'HiMAP-F') or (HiMAPTypeCB.Text = 'HiMAP-BCS');
  BitIndexEdit.Visible := Label9.Visible;
end;

procedure TMainForm.PMSEquipTypeCBDropDown(Sender: TObject);
begin
  PMSEquipType2Combo(PMSEquipTypeCB);
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
var
  i: integer;
begin
  for i := 0 to JvCheckTreeView1.Items.Count - 1 do
    JvCheckTreeView1.Items.Item[i].Data := nil;

//  FPMSOverViewBase.PMSOverViewCollect.Clear;
  FPMSOverViewBase.Free;
end;

procedure TMainForm.FormCreate(Sender: TObject);
begin
  FPMSOverViewBase := TPMSOverViewBase.Create(nil);

  FGridChanged := False;
  FDeleteMode := False;
  FNewItemCount := 0;
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
//  ShowMessage(IntToStr(TPMSOverViewItem(JvCheckTreeView1.Selected.data).Index));
//  ShowMessage(IntToStr(TPMSOverViewItem(JvCheckTreeView1.Selected.data).Index) + ':' + IntToStr(JvCheckTreeView1.Selected.AbsoluteIndex));
end;

procedure TMainForm.JvCheckTreeView1Deletion(Sender: TObject; Node: TTreeNode);
var
  LHMItem: TPMSOverViewItem;
  i: integer;
begin
  if Assigned(FPMSOverViewBase) then
  begin
    if FDeleteMode then
    begin
      LHMItem := TPMSOverViewItem(Node.Data);
      FPMSOverViewBase.PMSOverViewCollect.Delete(LHMItem.Index);
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

procedure TMainForm.LoadTreeFromFile;
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
          FPMSOverViewBase.LoadFromFile2TreeView(JvCheckTreeView1, LFileName, EncryptCB.Checked);

          {LTJvgXMLSerializer_Encrypt := TJvgXMLSerializer_Encrypt.Create(nil);
          try
            FPMSOverViewBase.PMSOverViewCollect.Clear;
            FPMSOverViewBase.LoadFromFile(LFileName,PassPhraseEdit.Text,EncryptCB.Checked);
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
  LPMSOverViewItem: TPMSOverViewItem;
begin
  if not Assigned(ANode) then
    exit;

  LPMSOverViewItem := TPMSOverViewItem(ANode.Data);

  LPMSOverViewItem.Caption := CaptionEdit.Text;
  LPMSOverViewItem.CompName := CompnameEdit.Text;
  LPMSOverViewItem.EquipType := String2PMSEquipType(PMSEquipTypeCB.Text);
  LPMSOverViewItem.TagName := Tag_Name_Edit.Text;
  LPMSOverViewItem.TagIndex := StrToIntDef(Tag_Index_Edit.Text,0);
  LPMSOverViewItem.AbsoluteIndex := StrToIntDef(AbsEdit.Text,0);
  LPMSOverViewItem.NodeIndex := StrToIntDef(NodeIndexEdit.Text,0);
  LPMSOverViewItem.LevelIndex := StrToIntDef(LevelEdit.Text,0);
  LPMSOverViewItem.ImageIndex := StrToIntDef(ImageIndexEdit.Text,0);
  LPMSOverViewItem.HiMapType := String2HiMAPType(HiMAPTypeCB.Text);
  LPMSOverViewItem.BitIndex := StrToIntDef(BitIndexEdit.Text, -1);
  LPMSOverViewItem.UnionGroup := StrToIntDef(UnionGroupEdit.Text, -1);
  LPMSOverViewItem.DependChild := DependChildCB.Checked;
  LPMSOverViewItem.UpPowerReverse := UpPowerRevCB.Checked;
  LPMSOverViewItem.DownPowerReverse := DownPowerRevCB.Checked;
  LPMSOverViewItem.DefaultReverse := DefaultRevCB.Checked;

  ANode.Text := CaptionEdit.Text;
end;

procedure TMainForm.MoveNode(ATreeView: TTreeView; ATargetNode,
  ASourceNode: TTreeNode);
var
  LNode: TTreeNode;
  i: integer;
  LHMItem: TPMSOverViewItem;
begin
  With ATreeView do
  begin
    LHMItem := TPMSOverViewItem(ASourceNode.Data);
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
  LPMSOverViewItem: TPMSOverViewItem;
begin
  if not Assigned(ANode) then
    exit;

  LPMSOverViewItem := TPMSOverViewItem(ANode.Data);

  CaptionEdit.Text := LPMSOverViewItem.Caption;
  CompnameEdit.Text := LPMSOverViewItem.CompName;
  PMSEquipTypeCB.Text := PMSEquipType2String(LPMSOverViewItem.EquipType);
  Tag_Name_Edit.Text := LPMSOverViewItem.TagName;
  Tag_Index_Edit.Text := IntToStr(LPMSOverViewItem.TagIndex);
  AbsEdit.Text := IntToStr(LPMSOverViewItem.AbsoluteIndex);
  NodeIndexEdit.Text := IntToStr(LPMSOverViewItem.NodeIndex);
  LevelEdit.Text := IntToStr(LPMSOverViewItem.LevelIndex);
  ImageIndexEdit.Text := IntToStr(LPMSOverViewItem.ImageIndex);
  HiMAPTypeCB.Text := HiMAPType2String(LPMSOverViewItem.HiMapType);
  BitIndexEdit.Text := IntToStr(LPMSOverViewItem.BitIndex);
  UnionGroupEdit.Text := IntToStr(LPMSOverViewItem.UnionGroup);
  HiMAPTypeCBSelect(HiMAPTypeCB);
  DependChildCB.Checked := LPMSOverViewItem.DependChild;
  UpPowerRevCB.Checked := LPMSOverViewItem.UpPowerReverse;
  DownPowerRevCB.Checked := LPMSOverViewItem.DownPowerReverse;
  DefaultRevCB.Checked := LPMSOverViewItem.DefaultReverse;
end;

//MenuItem을 Insert하기 전에 반드시 Parent Item이 생성 되어 있어야 함.
procedure TMainForm.SetHiMECSMainMenu(APMSOverViewBase: TPMSOverViewBase);
var
  LMenuItem: TMenuItem;
  Li,Lj: integer;
begin
  MainMenu1.Items.Clear;

  //Main Menu Insert
  for Li := 0 to FPMSOverViewBase.PMSOverViewCollect.Count - 1 do
  begin
    LMenuItem := TMenuItem.Create(Self);
    LMenuItem.Caption := FPMSOverViewBase.PMSOverViewCollect.Items[Li].Caption;
//    LMenuItem.Hint := FPMSOverViewBase.PMSOverViewCollect.Items[Li].Hint;

    if FPMSOverViewBase.PMSOverViewCollect.Items[Li].LevelIndex = 0 then
      MainMenu1.Items.Insert(FPMSOverViewBase.PMSOverViewCollect.Items[Li].NodeIndex,LMenuItem)
    else
    if FPMSOverViewBase.PMSOverViewCollect.Items[Li].LevelIndex =
                        FPMSOverViewBase.PMSOverViewCollect.Items[Li-1].LevelIndex then
    begin
      Lj := FPMSOverViewBase.PMSOverViewCollect.Items[Li].ParentNodeIndex;
      MainMenu1.Items[Lj].Insert(FPMSOverViewBase.PMSOverViewCollect.Items[Li].NodeIndex, LMenuItem);
    end
    else
    if (FPMSOverViewBase.PMSOverViewCollect.Items[Li].LevelIndex - 1) =
                      FPMSOverViewBase.PMSOverViewCollect.Items[Li-1].LevelIndex then
    begin
      Lj := FPMSOverViewBase.PMSOverViewCollect.Items[Li].ParentNodeIndex;
      MainMenu1.Items[Lj].Insert(FPMSOverViewBase.PMSOverViewCollect.Items[Li].NodeIndex,LMenuItem);
    end
    else
    if FPMSOverViewBase.PMSOverViewCollect.Items[Li-1].LevelIndex >
                        FPMSOverViewBase.PMSOverViewCollect.Items[Li].LevelIndex then
    begin
      Lj := FPMSOverViewBase.PMSOverViewCollect.Items[Li].ParentNodeIndex;
      while FPMSOverViewBase.PMSOverViewCollect.Items[Lj].LevelIndex >
            FPMSOverViewBase.PMSOverViewCollect.Items[Li].LevelIndex do
        Lj := FPMSOverViewBase.PMSOverViewCollect.Items[Li].ParentNodeIndex;

      MainMenu1.Items[Lj].Insert(FPMSOverViewBase.PMSOverViewCollect.Items[Li].NodeIndex,LMenuItem)
    end;
  end;
end;

procedure TMainForm.SortCollectItembyNodeIndex1Click(Sender: TObject);
begin
  FPMSOverViewBase.SortCollectByAbsIndex(JvCheckTreeView1);
end;

end.
