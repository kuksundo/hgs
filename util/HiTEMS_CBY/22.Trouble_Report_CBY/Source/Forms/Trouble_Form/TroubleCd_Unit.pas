unit TroubleCd_Unit;

interface

uses
  Trouble_Unit,Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, NxCollection, Vcl.StdCtrls, Vcl.ExtCtrls,
  Vcl.ImgList, NxColumnClasses, NxColumns, NxScrollControl, NxCustomGridControl,
  NxCustomGrid, NxGrid, Vcl.ComCtrls;

type
  TDataRoot = Record
    Code, Data : String[50];
end;

type
  TroubleData = Record
    Code, PCode, Data : String[50];
end;

type
  TTroubleCd_Frm = class(TForm)
    Panel2: TPanel;
    Button2: TButton;
    Button1: TButton;
    NxHeaderPanel1: TNxHeaderPanel;
    Panel1: TPanel;
    Button3: TButton;
    Panel3: TPanel;
    NxHeaderPanel2: TNxHeaderPanel;
    TreeView1: TTreeView;
    Button5: TButton;
    Button6: TButton;
    TroubleRoot: TNextGrid;
    NxIncrementColumn2: TNxIncrementColumn;
    NxTextColumn2: TNxTextColumn;
    NxTextColumn3: TNxTextColumn;
    Imglist16x16: TImageList;
    procedure FormCreate(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure TreeView1Change(Sender: TObject; Node: TTreeNode);
    procedure Button3Click(Sender: TObject);
    procedure TreeView1GetImageIndex(Sender: TObject; Node: TTreeNode);
    procedure Button1Click(Sender: TObject);
    procedure Button5Click(Sender: TObject);
    procedure Button6Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
  private
    { Private declarations }
    FFirst : Boolean;
    FxRow,FxCol :integer;
    currentSelectedNode : TTreeNode;
  public
    { Public declarations }
    FOwner : TTrouble_Frm;
    FRootData : Array of TDataRoot;
    FTSData : Array of TroubleData;

    FRCount, FTCount : integer;

    procedure troubleCode2Array;
    procedure Set_of_Trouble_Items_List;
  end;

var
  TroubleCd_Frm: TTroubleCd_Frm;

implementation
uses
  DataModule_Unit;

{$R *.dfm}

procedure TTroubleCd_Frm.Button1Click(Sender: TObject);
var
  ListItem : TListITem;
  li : integer;
begin
  Try
    FOwner.TroubleList.ClearRows;
    for li := 0 to TroubleRoot.RowCount-1 do
    begin
      with Fowner.TroubleList do
      begin
        AddRow(1);
        Cells[1,li] := TroubleRoot.Cells[1,li];
        Cells[2,li] := TroubleRoot.Cells[2,li];
      end;//with
    end;//for
  finally
    Close;
  End;
end;

procedure TTroubleCd_Frm.Button2Click(Sender: TObject);
begin
  Close;
end;

procedure TTroubleCd_Frm.Button3Click(Sender: TObject);
var
  li, lr, lc : integer;
  LCount : integer;
  LPCode : String;
  ListItem : TListItem;
begin

  if currentSelectedNode.Level = 0 then Exit;

  LCount := TroubleRoot.RowCount;
  if TroubleRoot.RowCount = 0 then
  begin
    with TroubleRoot do
    begin
      AddRow(1);
      Cells[1,RowCount-1] := TreeView1.Selected.Parent.Text + '/' + TreeView1.Selected.Text;
      for li := 0 to FRCount - 1 do
      begin
        if TreeView1.Selected.Parent.Text = FRootData[li].Data then
        begin
          LPCode := FRootData[li].Code;
          for lr := 0 to FTCount - 1 do
          begin
            if (LPCode = FTSData[lr].PCode) And (TreeView1.Selected.Text = FTSData[lr].Data) then
              Cells[2,RowCount-1] := FTSData[lr].Code;
          end;//for
        end;//if
      end;//for
    end;//with
  end//if
  else
  begin
    if not (TroubleRoot.RowCount >= 5) then
    begin
      for li := 0 to FRCount - 1 do
      begin
        if TreeView1.Selected.Parent.Text = FRootData[li].Data then
        begin
          LPCode := FRootData[li].Code;
          for lr := 0 to FTCount - 1 do
          begin
            if (LPCode = FTSData[lr].PCode) And (TreeView1.Selected.Text = FTSData[lr].Data) then
            begin
              for lc := 0 to LCount - 1 do
              begin
                if TroubleRoot.Cells[2,LC] = FTSData[lr].Code then
                begin
                  ShowMessage('이미 등록된 코드 입니다!!');
                  exit;
                end;//if
              end;//for
              with TroubleRoot do
              begin
                AddRow(1);
                Cells[1,Rowcount-1] := TreeView1.Selected.Parent.Text + '/' + TreeView1.Selected.Text;
                Cells[2,Rowcount-1] := FTSData[lr].Code;
                TroubleRoot.Selected[RowCount-1];
              end;//with
            end;//if
          end;//for
        end;//if
      end;//for
    end
    else
    begin
      ShowMessage('유형은 5개까지만 입력할 수 있습니다.');
      exit;
    end;//else
  end;//else
end;

procedure TTroubleCd_Frm.Button5Click(Sender: TObject);
var
  li : integer;
begin
  TroubleRoot.DeleteRow(TroubleRoot.SelectedRow);
  TroubleRoot.Refresh;
end;

procedure TTroubleCd_Frm.Button6Click(Sender: TObject);
begin
  TroubleRoot.ClearRows;
end;

procedure TTroubleCd_Frm.FormActivate(Sender: TObject);
begin
  if FFirst = True then
  begin
    FFirst := False;
    Set_of_Trouble_Items_List;
  end;
end;

procedure TTroubleCd_Frm.FormCreate(Sender: TObject);
begin
  FFirst := True;

end;

procedure TTroubleCd_Frm.Set_of_Trouble_Items_List;
var
  li,lr : integer;
  TreeNode, TreeNode1: TTreeNode;
  ListItem : TListItem;
begin
  Treeview1.Items.Clear;
  troubleCode2Array; // Server에 있는 Code들을 배열로 옮김... ㅎㅎ

  for li := 0 to FRCount - 1 do
  begin
    TreeNode := TreeView1.Items.Add(nil, FRootData[li].Data);
    for lr := 0 to FTCount - 1 do
      if FRootData[li].Code = FTSData[lr].PCode then
        TreeNode1 := TreeView1.Items.AddChild(TreeNode, FTSData[lr].Data);
  end;//for

  for li := 0 to TreeView1.Items.Count-1 do
  begin
    TreeNode := TreeView1.Items.Item[li];
//    TreeNode.Expanded := True;
    Case TreeNode.Level of
      0 : TreeNode.ImageIndex := 0;
      1 : TreeNode.ImageIndex := 1;
    end;
  end;

  TroubleRoot.ClearRows;

  if Fowner.TroubleList.RowCount > 0 then
  begin
    for li := 0 to Fowner.TroubleList.RowCount - 1 do
    begin
      with TroubleRoot do
      begin
        AddRow(1);

        Cells[1,RowCount-1] := FOwner.TroubleList.Cells[1,li];
        Cells[2,RowCount-1] := FOwner.TroubleList.Cells[2,li];
      end;//with
    end;//for
  end;//if
end;

procedure TTroubleCd_Frm.TreeView1Change(Sender: TObject; Node: TTreeNode);
begin
  currentSelectedNode := Node;
end;

procedure TTroubleCd_Frm.TreeView1GetImageIndex(Sender: TObject;
  Node: TTreeNode);
begin
  case Node.Level of
    0 : Node.ImageIndex := 14;
    1 : Node.ImageIndex := 16;
  end;
end;

procedure TTroubleCd_Frm.troubleCode2Array;
var
  li : integer;

begin
  SetLength(FRootData, Sizeof(TDataRoot) * 25);
  SetLength(FTSData, Sizeof(TroubleData) * 100);

  with Fowner do
  begin
    with DM1.EQuery1 do
    begin
      Close;
      SQL.Clear;
      SQL.Add('Select * from TS_TroubleRoot');
      Open;

      if RecordCount = 0 then
        Exit
      else
        Self.FRCount := RecordCount; // Root Count;

      for li := 0 to RecordCount - 1 do
      begin
        Self.FRootData[li].Code := FieldByName('Code').AsString;
        Self.FRootData[li].Data := FieldByName('Data').AsString;
        Next;
      end;
    end;

    with DM1.EQuery1 do
    begin
      Close;
      SQL.Clear;
      SQL.Add('Select * from TS_TroubleType');
      Open;

      if RecordCount = 0 then
        Exit
      else
        Self.FTCount := RecordCount; // Type Count;

      for li := 0 to RecordCount - 1 do
      begin
        Self.FTSData[li].Code := FieldByName('Code').AsString;
        Self.FTSData[li].PCode := FieldByName('PCode').AsString;
        Self.FTSData[li].Data := FieldByName('Data').AsString;
        Next;
      end;
    end;
  end;
end;

end.
