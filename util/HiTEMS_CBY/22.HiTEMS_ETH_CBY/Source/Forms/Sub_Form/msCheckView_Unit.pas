unit msCheckView_Unit;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls, Vcl.ImgList,
  Vcl.ComCtrls, JvExComCtrls, JvComCtrls, JvCheckTreeView, Ora, TreeList,
  NxColumnClasses, NxColumns, NxScrollControl, NxCustomGridControl,
  NxCustomGrid, NxGrid, AdvGlowButton;

type
  PmsItems = ^TmsItems;
  TmsItems = Record
    msNo,
    parentms,
    msName : String;


  End;
type
  TmsCheckView_Frm = class(TForm)
    ImageList1: TImageList;
    Panel2: TPanel;
    Button2: TButton;
    Button6: TButton;
    msTree: TTreeList;
    Panel1: TPanel;
    Button1: TButton;
    ImageList2: TImageList;
    Panel3: TPanel;
    Label1: TLabel;
    SearchEdit: TEdit;
    procedure Button6Click(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormResize(Sender: TObject);
    procedure msTreeMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
  private
    { Private declarations }
    FmaxWidth : Integer;
    FmsArray : Array of PmsItems;

  public
    { Public declarations }
    procedure Refresh_TreeView;
    procedure Review_Tree(aParentMs: String; aTreeNode: TTreeNode);
    procedure Check_Used_Ms(aMS:String);

    procedure Get_MS_Number;


  end;

var
  msCheckView_Frm: TmsCheckView_Frm;
  function Create_Check_View(aMS:String) : String;

implementation
uses
  DataModule_Unit;

{$R *.dfm}

{ TmsCheckView_Frm }
function Create_Check_View(aMS:String) : String;
var
  litem : TStringList;
  li,le: integer;
  lstr,lstr1 : String;
begin
  msCheckView_Frm := TmsCheckView_Frm.Create(Application);
  with msCheckView_Frm do
  begin

    Get_MS_Number;

    Refresh_TreeView;

    if not(aMS = '') then
      Check_Used_Ms(aMs);

    ShowModal;

    if ModalResult = mrOk then
    begin
      lstr := '';
      with msTree.Items do
      begin
        litem := TStringList.Create;
        for li := 1 to Count-1 do
        begin
          litem.Clear;
          if item[li].SelectedIndex = 1 then
          begin
            lstr := item[li].Text;
            ExtractStrings([';'],[],PChar(lstr),litem);
            lstr1 := lstr1+litem.Strings[1]+'/';
          end;
        end;
      end;
      lstr := Copy(lstr1,0,LastDelimiter('/',lstr1)-1);
      Result := lstr;
    end;
  end;
end;

procedure TmsCheckView_Frm.Button6Click(Sender: TObject);
begin
  Close;


end;

procedure TmsCheckView_Frm.Check_Used_Ms(aMS: String);
var
  litem : TStringList;
  rcNode,rcBox: TRect;
  wid: Integer;
  Node,Node1: TTreeNode;
  li,le,
  lx,ly : integer;
  lstr : String;
begin
  litem := TStringList.Create;
  try
    ExtractStrings(['/'],[' '], PChar(aMs),litem);
    for li := 0 to litem.Count-1 do
    begin
      lstr := litem.Strings[li];
      for le := 0 to msTree.Items.Count-1 do
      begin
        Node := msTree.Items.Item[le];
        Node.Expanded := True;

        if POS(lstr,Node.Text) > 0 then
        begin
          if Assigned(Node) then
          begin
            rcNode:=Node.DisplayRect(false);
            wid:= msTree.BorderWidth+ (Node.Level+1)*msTree.Indent;
            rcBox:=Rect(rcNode.Left+wid,rcNode.Top+1,rcNode.Left+wid+12,rcNode.Top+13);

            lx := rcNode.Left+wid+4;
            ly := rcNode.Top+4;
            if(PtInRect(rcBox,Point(lx,ly)))then
            begin
              Node.ImageIndex:=1;
              Node.SelectedIndex:=1;
            end;
          end;
          Break;
        end;
      end;
    end;
  finally
    FreeAndNil(litem);
  end;

end;

procedure TmsCheckView_Frm.FormClose(Sender: TObject; var Action: TCloseAction);
var
  msItems : PmsItems;
  i : Integer;
begin
  if Length(FmsArray) > 0 then
  begin
    for i := Length(FmsArray)-1 DownTo 0 do
    begin
      msItems := FmsArray[i];
      SetLength(msItems^.msNo,0);
      SetLength(msItems^.msName,0);
      SetLength(msItems^.parentms,0);            
      Dispose(msItems);
    end;
  end;
end;

procedure TmsCheckView_Frm.FormResize(Sender: TObject);
var
  lvalues : Integer;
begin
  lvalues := Round(msTree.Width * 0.7);
  msTree.Columns.Items[0].Width := lvalues;

end;

procedure TmsCheckView_Frm.Get_MS_Number;
var
  msItems : PmsItems;
  OraQuery : TOraQuery;
  i : Integer;
begin
  OraQuery := TOraQuery.Create(nil);
  try
    OraQuery.Session := DM1.OraSession1;
    OraQuery.FetchAll := True;

    with OraQuery do
    begin
      Close;
      SQL.Clear;
      SQL.Add('SELECT * FROM TBACS.HIMSEN_MS_NUMBER ' +
              'START WITH MSNO = ''TOP00'' ' +
              'CONNECT BY PRIOR MSNO = PRTMSNO ORDER SIBLINGS BY MSNO ');
      Open;

      if RecordCount <> 0 then
      begin
        SetLength(FmsArray, RecordCount);

        for i := 0 to RecordCount-1 do
        begin
          new(msItems);
          msItems.msNo   := FieldByName('MSNO').AsString;
          msItems.msName := FieldByName('MSNAME').AsString;
          msItems.parentms := FieldByName('PRTMSNO').AsString;

          FmsArray[i] := msItems;
          Next;
        end;
      end;
    end;
  finally
    FreeAndNil(OraQuery);
  end;
end;

procedure TmsCheckView_Frm.msTreeMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
var
  rcNode,rcBox: TRect;
  wid: Integer;
  Node,Node1: TTreeNode;
  li : integer;
  lx,ly : Integer;
  procedure checkChildState(aNode:TTreeNode; aState:Integer);
  var
    ChildNode : TTreeNode;
  begin
    if not aNode.HasChildren then Exit;

    ChildNode := aNode.getFirstChild;

    while (ChildNode <> nil) do
    begin
      if ChildNode.HasChildren then
        checkChildState(ChildNode, aState);

      ChildNode.ImageIndex := aState;
      ChildNode.SelectedIndex := aState;

      ChildNode := aNode.GetNextChild(ChildNode);

    end;
  end;
begin
  if(Button=mbLeft)then
  begin
    with msTree.Items do
    begin
      BeginUpdate;
      try
        Node := msTree.GetNodeAt(X,Y);
        if Assigned(Node) then
        begin
          rcNode:=Node.DisplayRect(false);
          wid:= msTree.BorderWidth+ (Node.Level+1)*msTree.Indent;
          rcBox:=Rect(rcNode.Left+wid,rcNode.Top+1,rcNode.Left+wid+12,rcNode.Top+13);
          if(PtInRect(rcBox,Point(X,Y)))then
          begin
            if(Node.StateIndex>0)then 
              Node.StateIndex:=0
            else 
              Node.StateIndex:=1;

            Node.ImageIndex:=Node.StateIndex;
            Node.SelectedIndex:=Node.StateIndex;

            checkChildState(Node,Node.StateIndex);
        
          end;
        end;
      finally
        Refresh;
        EndUpdate;
      end;
    end;
  end;
end;

procedure TmsCheckView_Frm.Refresh_TreeView;
var
  TreeNode,
  ChildNode: TTreeNode;
  i,li, idx: Integer;
  typeNo: Double;
  typeNm: String;
  msItem : PmsItems;
  prtMs,
  msNo : String;

begin
  msTree.Items.Clear;

  if Length(FmsArray) > 0 then
  begin
    with msTree.Items do
    begin
      BeginUpdate;
      try
        for i := 1 to Length(FmsArray)-1 do
        begin
          if i = 1 then
            TreeNode := AddObjectFirst(msTree.TopItem,FmsArray[i].msName+';'+
            FmsArray[i].msNo,FmsArray[i])
          else
          begin
            TreeNode := nil;
            prtMs := FmsArray[i].parentms;
            for li := 0 to Count-1 do
            begin
              msNo := PmsItems(Item[li].Data)^.msNo;
              if SameText(prtMs,msNo) then
              begin
                TreeNode := Item[li];
                Break;
              end;
            end;

            if TreeNode <> nil then
              AddChildObjectFirst(TreeNode, FmsArray[i].msName+';'+
            FmsArray[i].msNo,FmsArray[i])
            else
              AddObject(nil,FmsArray[i].msName+';'+
            FmsArray[i].msNo,FmsArray[i]);
              
          end;
        end;
      finally
        EndUpdate;
      end;
    end;
  end;


//  TreeNode := msTree.Items.AddChildFirst(msTree.TopItem, 'MS-Number;TOP00');
//  TreeNode.ImageIndex := 0;
//  try
//    Review_Tree('TOP00', msTree.TopItem);
//  finally
//    with msTree.Items do
//    begin
//      BeginUpdate;
//      try
//        for li := 1 to Count - 1 do
//        begin
//          item[li].Expanded := True;
//          Item[li].StateIndex := 0;
//          Item[li].ImageIndex := Item[li].StateIndex;
//          Item[li].SelectedIndex := Item[li].StateIndex;
//        end;
//      finally
//        EndUpdate;
//      end;
//    end;
//  end;
end;

procedure TmsCheckView_Frm.Review_Tree(aParentMs: String; aTreeNode: TTreeNode);
var
  lname: String;
  lChildNode: TTreeNode;
  lParentMs: String;
  OraQuery1: TOraQuery;
  i : Integer;

begin
  for i := 1 to Length(FmsArray)-1 do
  begin
    if SameText(aParentMs, FmsArray[i].msNo) then
    begin
      lChildNode := msTree.Items.AddChildObject(aTreeNode,FmsArray[i].msName,FmsArray[i]);
      Review_Tree(FmsArray[i].msName, lChildNode);
    end;


  end;

//
//  OraQuery1 := TOraQuery.Create(Self);
//  OraQuery1.Session := DM1.OraSession1;
//  try
//    with OraQuery1 do
//    begin
//      Close;
//      SQL.Clear;
//      SQL.Add('select * from HiMSEN_MS_NUMBER where PRTMSNO = ''' +aParentMs + ''' ');
//      SQL.Add('order by MSNO');
//      Open;
//
//      if RecordCount > 0 then
//      begin
//        while not eof do
//        begin
//
//          lParentMs := FieldByName('MSNO').AsString;
//          lname := FieldByName('MSNAME').AsString;
//
//          lChildNode := msTree.Items.AddChild(aTreeNode,
//            lname + ';' + lParentMs);
//
//          Review_Tree(lParentMs, lChildNode);
//
//          Next;
//        end;
//      end;
//    end;
//  finally
//    OraQuery1.Close;
//    FreeAndNil(OraQuery1);
//  end;
end;

end.
