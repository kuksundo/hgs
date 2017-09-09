unit newPartList_Unit;

interface

uses
  Main_Unit,Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, NxEdit, Vcl.StdCtrls, Vcl.Grids, AdvObj,
  BaseGrid, AdvGrid, DBAdvGrid, Vcl.ExtCtrls, NxCollection, GradientLabel,
  Vcl.ImgList, Data.DB, MemDS, DBAccess, Ora, Vcl.ExtDlgs, AdvEdit, AdvEdBtn,
  AdvNavBar, Vcl.ComCtrls, NxColumnClasses, NxColumns, NxScrollControl,
  NxCustomGridControl, NxCustomGrid, NxGrid, JvExStdCtrls, JvEdit,
  NxAutoCompletion, PictureContainer, Vcl.Imaging.pngimage, JvBackgrounds,
  TreeList, Vcl.Menus, AdvMenus;
const
  FDatatype : Array[1..3]of string = ('VARCHAR2','INTEGER','NUMBER');

type
  TnewCode = Record
    Checked : Boolean;
    Rootnm,
    Rootid,
    Codenm,
    Codeid: String;

end;

type
  TnewPartList_Frm = class(TForm)
    ImageList1: TImageList;
    OpenPictureDialog1: TOpenPictureDialog;
    PictureContainer1: TPictureContainer;
    PageControl1: TPageControl;
    TabSheet1: TTabSheet;
    TabSheet2: TTabSheet;
    NxSplitter2: TNxSplitter;
    NxHeaderPanel1: TNxHeaderPanel;
    Panel5: TPanel;
    AdvEditBtn1: TAdvEditBtn;
    NxHeaderPanel3: TNxHeaderPanel;
    GradientLabel1: TGradientLabel;
    Panel17: TPanel;
    Panel18: TPanel;
    FieldName: TNxEdit;
    Panel22: TPanel;
    Panel24: TPanel;
    FieldType: TNxComboBox;
    Panel25: TPanel;
    Panel26: TPanel;
    FieldSize: TNxNumberEdit;
    Panel19: TPanel;
    Panel20: TPanel;
    namek: TNxEdit;
    Panel7: TPanel;
    Panel13: TPanel;
    namee: TNxEdit;
    Panel14: TPanel;
    Panel21: TPanel;
    desc: TNxEdit;
    Panel23: TPanel;
    Button5: TButton;
    Button8: TButton;
    Panel27: TPanel;
    Panel28: TPanel;
    remark: TNxEdit;
    TabSheet3: TTabSheet;
    NxSplitter3: TNxSplitter;
    NxHeaderPanel4: TNxHeaderPanel;
    Panel29: TPanel;
    Button2: TButton;
    Button3: TButton;
    Panel31: TPanel;
    Panel34: TPanel;
    grpPanel: TPanel;
    Panel36: TPanel;
    Panel37: TPanel;
    NxHeaderPanel7: TNxHeaderPanel;
    subjGrid: TNextGrid;
    NxIncrementColumn1: TNxIncrementColumn;
    NxCheckBoxColumn1: TNxCheckBoxColumn;
    NxTextColumn3: TNxTextColumn;
    NxTextColumn1: TNxTextColumn;
    NxTextColumn2: TNxTextColumn;
    NxHeaderPanel8: TNxHeaderPanel;
    appGrid: TNextGrid;
    NxIncrementColumn2: TNxIncrementColumn;
    NxTextColumn4: TNxTextColumn;
    NxTextColumn5: TNxTextColumn;
    NxTextColumn6: TNxTextColumn;
    Panel35: TPanel;
    Down_btn: TButton;
    Up_btn: TButton;
    Panel33: TPanel;
    Button10: TButton;
    Button13: TButton;
    Button14: TButton;
    JvBackground1: TJvBackground;
    Image2: TImage;
    FieldGrid: TAdvStringGrid;
    NxHeaderPanel9: TNxHeaderPanel;
    Panel1: TPanel;
    specTree: TTreeList;
    rtnm: TNxEdit;
    ptnm: TNxEdit;
    Panel8: TPanel;
    ptid: TNxEdit;
    NxHeaderPanel2: TNxHeaderPanel;
    NxHeaderPanel5: TNxHeaderPanel;
    rootTree: TTreeList;
    NxSplitter1: TNxSplitter;
    Panel2: TPanel;
    Label1: TLabel;
    Label2: TLabel;
    rootname: TNxEdit;
    rootid: TNxEdit;
    Label3: TLabel;
    Label4: TLabel;
    suggest_btn: TButton;
    Button4: TButton;
    Panel3: TPanel;
    Button6: TButton;
    Button7: TButton;
    GradientLabel2: TGradientLabel;
    partGrid: TDBAdvGrid;
    partname: TNxComboBox;
    DataSource1: TDataSource;
    OraQuery1: TOraQuery;
    partcode: TNxNumberEdit;
    rootPop: TAdvPopupMenu;
    N1: TMenuItem;
    treeImg: TImageList;
    Panel4: TPanel;
    rtid: TNxEdit;
    procedure tablenameButtonDown(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure Button5Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure FieldTypeSelect(Sender: TObject);
    procedure Button13Click(Sender: TObject);
    procedure Button10Click(Sender: TObject);
    procedure Down_btnClick(Sender: TObject);
    procedure Up_btnClick(Sender: TObject);
    procedure Button8Click(Sender: TObject);
    procedure PageControl1Change(Sender: TObject);
    procedure specTreeDblClick(Sender: TObject);
    procedure subjGridAfterEdit(Sender: TObject; ACol, ARow: Integer;
      Value: WideString);
    procedure rootTreeMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure suggest_btnClick(Sender: TObject);
    procedure Button4Click(Sender: TObject);
    procedure Button6Click(Sender: TObject);
    procedure N1Click(Sender: TObject);
    procedure specTreeChange(Sender: TObject; Node: TTreeNode);
    procedure partnameButtonDown(Sender: TObject);
    procedure partnameSelect(Sender: TObject);
  private
    { Private declarations }
    FAddType : String;
    FfieldType : String;
    FCurrentNode : TTreeNode;
    FnewCode : TnewCode;
  public
    { Public declarations }
    FStartPage : Integer;
    function Add_HiMSEN_PART_SUBJECT :Boolean;
    procedure Create_Subject_Fields(aName,aType,aSize:String);

    //Page 1
    procedure Add_New_Root(aNode:TTreeNode);
    procedure Show_Root;
    procedure Show_Part_Code(aRootNo:String);
    procedure Add_to_Part_CODE;
    procedure Selected_Part_Info(aNode:TTreeNode);

    //Page 2
    procedure Set_the_Page2_Detail;

    //Page3
    function Show_specTree_Root : Boolean;
    procedure Add_Code_to_specTree;
    procedure Set_the_Page3_Detail;
    procedure Set_of_the_spec_tree(aListNo,aParent:Integer;aSubj:String);

    //page 3 methods
    procedure Set_Subject_Grid;
    procedure Set_Apply_Grid;
    procedure add_items_to_Grid(aRow:Integer);
    procedure del_items_in_Grid(aSubjectID:String);

    //DB
    procedure Apply_Info_To_HIMSEN_PART_GROUP;
    procedure Add_Info_to_DB(aRow:Integer);
    procedure Del_Info_in_DB(aSubjectID:String);
    procedure Update_GrpNo_In_DB;
    procedure After_Apply_procedure;

  end;

var
  newPartList_Frm: TnewPartList_Frm;

implementation
uses
  addRoot_Unit,
  CommonUtil_Unit,
  imagefunctions_Unit,
  HiTEMS_ETH_CONST,
  DataModule_Unit;

{$R *.dfm}


procedure TnewPartList_Frm.Add_Code_to_specTree;
var
  lp,
  li: Integer;
  lnew, lNode : TTreeNode;
  lstr,
  litem,
  lroot : String;
begin
  with DM1.OraQuery1 do
  begin
    Close;
    SQL.Clear;
    SQL.Add('select * from HIMSEN_PART_DESC_V order by rootno,sortno');
    Open;

    while not eof do
    begin
      lroot := FieldByName('ROOTNO').AsString;
      litem := FieldByName('PCODENM').AsString+';'+FieldByName('PCODE').AsString;
      with specTree.Items do
      begin
        BeginUpdate;
        try
          for li := 0 to Count-1 do
          begin
            lNode := Item[li];
            lp := pos(';',lNode.Text);

            if lp > 0 then
            begin
              lstr := Copy(lNode.Text,lp+1,Length(lNode.Text));

              if lstr = lroot  then
              begin
                lnew := AddChild(lNode,litem);
                lnew.ImageIndex := 1;
                lnew.Expanded := True;
                Break;
              end;
            end;
          end;
        finally
          EndUpdate;
        end;
      end;
      Next;
    end;
  end;
end;


function TnewPartList_Frm.Add_HiMSEN_PART_SUBJECT : Boolean;
var
  li : integer;
  LInt : int64;
begin
  Result := False;
  with DM1.OraQuery1 do
  begin
    Close;
    SQL.Clear;
    SQL.Add('select SUBJECT_ from HIMSEN_PART_SUBJECT ' +
            'where SUBJECT_ = :param1');

    ParamByName('param1').AsString := FieldName.Text;
    Open;

    li := RecordCount;
  end;

  if not(li > 0) then
  begin
    with DM1.OraQuery1 do
    begin
      Close;
      SQL.Clear;
      SQL.Add('Insert Into HIMSEN_PART_SUBJECT ');
      SQL.Add('Values(H_P_SUBJ_SEQ.NextVal, :SUBJECTID, :SUBJECT_, :SUBJECT_KOR, :SUBJECT_ENG,' +
              ':PDESC, :PDATATYPE, :PSIZE, :PBCKIND, :REMARK,' +
              ':REGID, :REGDATE, :MODID, :MODDATE, :DELYN)');

      LInt := DateTimeToMilliseconds(Now);
      ParamByName('SUBJECTID').AsFloat := LInt;
      ParamByName('SUBJECT_').AsString := FieldName.Text;
      ParamByName('SUBJECT_KOR').AsString := namek.Text;
      ParamByName('SUBJECT_ENG').AsString := namee.Text;

      ParamByName('PDESC').AsString := Desc.Text;
      ParamByName('PDATATYPE').AsString := FfieldType;

      if FieldType.ItemIndex = 1 then
        ParamByName('PSIZE').AsInteger := StrToInt(FieldSize.Text);

      if FieldType.ItemIndex = 1 then
        ParamByName('PBCKIND').AsString := 'Char';

      ParamByName('REMARK').AsString := remark.Text;
      ParamByName('REGID').AsString := CurrentUsers;
      ParamByName('REGDATE').AsDateTime := Now;

      ExecSQL;
      Result := True;
    end;
  end
  else
    ShowMessage('같은 필드가 존재 합니다..');
end;

procedure TnewPartList_Frm.Add_Info_to_DB(aRow:Integer);
var
  lSort,
  li : integer;
begin
  with DM1.OraQuery1 do
  begin
    Close;
    SQL.Clear;
    SQL.Add('insert into HIMSEN_PART_GROUP');
    SQL.Add('Values(:ROOTNO, :PCODE, :SUBJECTID, :GRPNO, :REGID,' +
            ':REGDATE,:MODID,:MODDATE,:STATUS)');

    with appGrid do
    begin
      ParamByName('ROOTNO').AsFloat      := StrToFloat(rtid.Text);
      ParamByName('PCODE').AsFloat       := StrToFloat(ptid.Text);
      ParamByName('SUBJECTID').AsFloat   := Cell[1,aRow].AsFloat;
      ParamByName('GRPNO').AsInteger     := Cell[0,aRow].AsInteger;
      ParamByName('REGID').AsString      := CurrentUsers;
      ParamByName('REGDATE').AsDateTime  := Now;
      ParamByName('STATUS').AsInteger    := 0;
      ExecSQL;
    end;
  end;
end;

procedure TnewPartList_Frm.add_items_to_Grid(aRow:Integer);
var
  lchange,
  li,le : integer;
  LSubjID : String;
begin
//  if (grpPartname.Text = '') or (grpMaker.Text = '') then
//    Exit;


  with subjGrid do
  begin
    if not(aRow = -1) then
    begin
      LSubjID := Cells[2,aRow];
      lChange := 0;

      for li := 0 to appGrid.RowCount-1 do
      begin
        if LSubjID = appGrid.Cells[1,li] then
        begin
          Inc(lchange);
          if appGrid.Cell[0,li].TextColor = clRed then
          begin
            for le := 0 to appGrid.Columns.Count-1 do
              appGrid.Cell[le,li].TextColor := clBlack;

            Cell[1,aRow].AsBoolean := True;
            Break;
          end;
        end;
      end;

      if lchange = 0 then
      begin
        appGrid.AddRow(1);
        appGrid.Cells[1,appGrid.RowCount-1] := Cells[2,aRow];
        appGrid.Cells[2,appGrid.RowCount-1] := Cells[3,aRow];
        appGrid.Cells[3,appGrid.RowCount-1] := Cells[4,aRow];
        for li := 0 to appGrid.Columns.Count-1 do
          appGrid.Cell[li,appGrid.RowCount-1].TextColor := clBlue;
      end;
    end;
  end;
end;

procedure TnewPartList_Frm.Add_New_Root(aNode: TTreeNode);
var
  LResult : Boolean;
begin
  try
    if aNode = nil then
      LResult := Create_Node(nil)
    else
      LResult := Create_Node(aNode);
  finally
    if LResult = True then
    begin
      Show_Root;
      ShowMessage('신규루트 등록 성공!!');
    end;
  end;
end;

procedure TnewPartList_Frm.Add_to_Part_CODE;
var
  lResult : Boolean;
begin
  with DM1.OraQuery1 do
  begin
    Close;
    SQL.Clear;
    SQL.Add('select * from HIMSEN_PART_CODE ' +
            'where PCODENM = '''+partname.Text+''' ');
    Open;

    if not(RecordCount = 0) then
    begin
      if partCode.Text = FieldByName('PCODE').AsString then
        lResult := False
      else
      begin
        partCode.Text := FieldByName('PCODE').AsString;
        lResult := False;
      end;
    end
    else
      lResult := True;
  end;

  if lResult = True then
  begin
    with DM1.OraQuery2 do
    begin
      Close;
      SQL.Clear;
      SQL.Add('Insert into HIMSEN_PART_CODE ' +
              'Values(:PCODE, :PCODENM, :REGID, :REGDATE, :MODID, :MODDATE)');

      ParamByName('PCODE').AsFloat  := StrToFloat(partcode.Text);
      ParamByName('PCODENM').AsString := partname.Text;
      ParamByName('REGID').AsString   := CurrentUsers;
      ParamByName('REGDATE').AsDateTime := Now;
      ExecSQL;
    end;
  end;
end;

procedure TnewPartList_Frm.After_Apply_procedure;
var
  LB : Boolean;
  li,le : integer;
  LDelRows : TStringList;
begin
  with appGrid do
  begin
    try
      BeginUpdate;
      LDelRows := TStringList.Create;

      for li := 0 to RowCount-1 do
      begin
        if Cell[1,li].TextColor = clRed then
          LDelRows.add(Cells[1,li]);

        if Cell[1,li].TextColor = clBlue then
          for le := 0 to Columns.Count-1 do
            Cell[le,li].TextColor := clBlack;
      end;

      for li := 0 to LDelRows.Count-1 do
      begin
        for le := 0 to RowCount-1 do
          if LDelRows[li] = Cells[1,le] then
          begin
            DeleteRow(le);
            Break;
          end;
      end;
    finally
      FreeAndNil(LDelRows);
      Invalidate;
      EndUpdate;
    end;
  end;
end;

procedure TnewPartList_Frm.Apply_Info_To_HIMSEN_PART_GROUP;
var
  li: Integer;
  LDelList : TStringList;
begin
  try
    LDelList := TStringList.Create;
    with appGrid do
    begin
      for li := 0 to Rowcount-1 do
      begin
        if Cell[1,li].TextColor = clRed then
          LDelList.Add(Cells[1,li]);

        if Cell[1,li].TextColor = clBlue then
          Add_Info_to_DB(li);
      end;

      for li := 0 to LDelList.Count-1 do
        Del_Info_in_DB(LDelList.Strings[li]);

      Update_GrpNo_In_DB;
      After_Apply_procedure;
    end;
  finally
    LDelList.Free;

  end;
end;

procedure TnewPartList_Frm.Button10Click(Sender: TObject);
begin
  add_items_to_Grid(subjGrid.SelectedRow);
end;

procedure TnewPartList_Frm.Down_btnClick(Sender: TObject);
begin
  if appGrid.SelectedRow < appGrid.RowCount-1 then
  begin
    appGrid.MoveRow(appGrid.SelectedRow, appGrid.SelectedRow + 1);
    appGrid.SelectedRow := appGrid.SelectedRow + 1;
  end;
  appGrid.SetFocus;
end;

procedure TnewPartList_Frm.Up_btnClick(Sender: TObject);
begin
  if appGrid.SelectedRow > 0 then
  begin
    appGrid.MoveRow(appGrid.SelectedRow, appGrid.SelectedRow - 1);
    appGrid.SelectedRow := appGrid.SelectedRow - 1;
  end;
  appGrid.SetFocus;
end;

procedure TnewPartList_Frm.Button13Click(Sender: TObject);
var
  lrow : integer;
  lsubj : String;
begin
  lrow := appGrid.SelectedRow;
  lsubj := appGrid.Cells[2,lrow];
  if not(lsubj = 'MAKER') and
     not(lsubj = 'TYPE') and
     not(lsubj = 'PARTNO') and
     not(lsubj = 'DWGNO') and
     not(lsubj = 'REMARK') then
  begin
    del_items_in_Grid(appGrid.Cells[1,lrow]);
  end;
end;

procedure TnewPartList_Frm.suggest_btnClick(Sender: TObject);
begin
  if not(PARTNAME.Text = '') then
    partcode.Value := DateTimeToMilliseconds(Now)
  else
    ShowMessage('먼저 관리할 파트명을 입력하여 주십시오.');
end;

procedure TnewPartList_Frm.Button2Click(Sender: TObject);
begin
  try
    if FAddType = 'New' then
      Apply_Info_To_HIMSEN_PART_GROUP;

    if FAddType = 'Update' then
    begin
      if MessageDlg('등록된 정보가 있습니다. '+#13+'수정 하시겠습니까?'
                    , mtConfirmation, [mbYes, mbNo], 0) = mrYes Then
      begin
        Apply_Info_To_HIMSEN_PART_GROUP;
      end;
    end;
  finally
    Sleep(500);
//    Set_DBGrid(2);
  end;
end;

procedure TnewPartList_Frm.Button4Click(Sender: TObject);
var
  lResult : Boolean;
begin
  lResult := True;
  try
    with DM1.OraQuery1 do
    begin
      Close;
      SQL.Clear;
      SQL.Add('select * from HIMSEN_PART_DESC_V '+
              'where ROOTNAME = '''+rootName.Text+''' '+
              'and PCODENM = '''+partname.Text+''' ');
      Open;
      if not(RecordCount = 0) then
      begin
        ShowMessage('같은 루트, 코드로 등록된 파트가 존재 합니다.');
        lResult := False;
        Exit;
      end;
    end;

    with DM1.OraQuery1 do
    begin
      Close;
      SQL.Clear;
      SQL.Add('select * from HIMSEN_PART_CODE '+
              'where PCODE = '+partcode.Text);
      Open;
      if not(RecordCount = 0) then
      begin
        if not(partName.Text = FieldByName('PCODENM').AsString) then
        begin
          ShowMessage('이미 사용중인 코드번호 입니다.');
          lResult := False;
          Exit;
        end;
      end;
    end;



  finally
    if lResult = True then
    begin
      FnewCode.Checked := True;
      ShowMessage('사용가능한 코드 입니다.');
    end
    else
      FnewCode.Checked := False;
  end;
end;

procedure TnewPartList_Frm.Button5Click(Sender: TObject);
begin
  try
    if (FieldType.ItemIndex = 1) and (FieldSize.Value <= 0) then
    begin
      ShowMessage('FieldType이 문자(Text)일 경우 size는 0보다 커야 합니다.');
      Exit;
    end
    else
    begin
      try
        if Add_HiMSEN_PART_SUBJECT = True then
          Create_Subject_Fields(FieldName.Text, FfieldType, FieldSize.Text);
        ShowMessage('파트관리항목 등록 성공!');
        Set_the_Page2_Detail;
      except
        ShowMessage('파트관리항목 등록 실패!');

      end;

    end;
  finally
//    Set_DBGrid(PageControl1.ActivePageIndex);
  end;
end;

procedure TnewPartList_Frm.Button6Click(Sender: TObject);
var
  lNode : TTreeNode;
  lResult : Boolean;
  lcnt : integer;
begin
  lResult := True;
  if (RootName.Text = '') or (RootId.Text = '') then
  begin
    ShowMessage('루트를 선택하여 주십시오.');
    lResult := False;
    Exit;
  end;

  if partname.Text = '' then
  begin
    ShowMessage('관리할 파트명을 입력하여 주십시오.');
    lResult := False;
    Exit;
  end;

  if partcode.Text = '' then
  begin
    ShowMessage('관리할 파트코드를 생성하여 주십시오.');
    lResult := False;
    Exit;
  end;

  if FnewCode.Checked = False then
  begin
    ShowMessage('코드입력란의 확인 버튼을 클릭하여 주십시오.');
    lResult := False;
    Exit;
  end;

  if lResult = True then
  begin
    Add_to_Part_CODE; //파트 코드 삽입

    with DM1.OraQuery1 do
    begin
      Close;
      SQL.Clear;
      SQL.Add('select * from HIMSEN_PART_DESC ' +
              'where ROOTNO = '+RootId.Text);
      Open;

      if not(RecordCount = 0) then
        lcnt := RecordCount+1
      else
        lcnt := 1;
    end;

    with DM1.OraQuery1 do
    begin
      Close;
      SQL.Clear;
      SQL.Add('Insert into HIMSEN_PART_DESC ' +
              'Values(:ROOTNO, :PCODE, :SORTNO)');

      ParamByName('ROOTNO').AsFloat    := StrToFloat(RootId.Text);
      ParamByName('PCODE').AsFloat     := StrToFloat(partcode.Text);
      ParamByName('SORTNO').AsInteger  := lcnt;
      ExecSQL;
      ShowMessage('파트등록 성공!!');
    end;
    try
      try
        Selected_Part_Info(FCurrentNode);
      except
        FnewCode.Checked := False;

      end;
    finally
      FnewCode.Checked := False;
    end;
  end;
end;

procedure TnewPartList_Frm.Button8Click(Sender: TObject);
begin
  Close;
end;

procedure TnewPartList_Frm.Create_Subject_Fields(aName, aType, aSize: String);
var
  li : integer;
  LsetField : String;
begin
  with DM1.OraQuery1 do
  begin
    Close;
    SQL.Clear;
    SQL.Add('select column_name, column_id, data_type, data_length from all_tab_columns ' +
            'where table_name= ''HIMSEN_PART_SPECIFICATIONS'' ' +
            'and column_name = '''+aName+'''');
    Open;

    li := RecordCount;
    
  end;

  if not(li > 0) then
  begin
    if not(aType = 'VARCHAR2') then
      lSetField := aName+' '+aType
    else
      lSetField := aName+' '+aType+'('+aSize+' CHAR)';

    with DM1.OraQuery1 do
    begin
      Close;
      SQL.Clear;
      SQL.Add('Alter Table HIMSEN_PART_SPECIFICATIONS ');
      SQL.Add('Add('+LsetField+')');
      ExecSQL;
    end;
  end;
end;

procedure TnewPartList_Frm.Del_Info_in_DB(aSubjectID:String);
begin
  with DM1.OraQuery1 do
  begin
    Close;
    SQL.Clear;
    SQL.Add('Delete from HIMSEN_PART_GROUP ' +
            'where ROOTNO = '+rtid.Text+
            ' and PCODE = '+ptid.Text+
            ' and SubjectID = '''+aSubjectID+'''');
    ExecSQL;
  end;
end;

procedure TnewPartList_Frm.del_items_in_Grid(aSubjectID:String);
var
  li,le : integer;
  LsubjID : String;
begin
  with appGrid do
  begin
    for li := 0 to appGrid.RowCount-1 do
    begin
      if Cells[1,li] = aSubjectID then
      begin
        if not(Cell[1,li].TextColor = clBlue) then
        begin
          for le := 0 to appGrid.Columns.Count-1 do
            Cell[le,li].TextColor := clRed;

        end
        else
          DeleteRow(li);
        Break;
      end;
    end;
  end;

  with subjGrid do
  begin
    for li := 0 to subjGrid.RowCount-1 do
    begin
      if Cells[2,li] = aSubjectID then
      begin
        Cell[1,li].AsBoolean := False;
        Break;
      end;
    end;
  end;
end;

procedure TnewPartList_Frm.FieldTypeSelect(Sender: TObject);
begin
  if not(FieldType.ItemIndex = 0) then
    FfieldType := FDatatype[FieldType.ItemIndex]
  else
    FfieldType := '';

  if not(FieldType.ItemIndex = 1) then
    FieldSize.Enabled := False
  else
    FieldSize.Enabled := True;
end;

procedure TnewPartList_Frm.FormCreate(Sender: TObject);
begin
  PageControl1.ActivePageIndex := 0;
  Show_Root;
end;

procedure TnewPartList_Frm.N1Click(Sender: TObject);
begin
  if not(FCurrentNode = nil) then
    Add_New_Root(FCurrentNode)
  else
    Add_New_Root(nil);
end;

procedure TnewPartList_Frm.PageControl1Change(Sender: TObject);
begin
  case PageControl1.ActivePageIndex of
    1 : Set_the_Page2_Detail;
    2 : Set_the_Page3_Detail;

  end;
end;

procedure TnewPartList_Frm.partnameButtonDown(Sender: TObject);
begin
  partname.Items.Clear;
  partname.Items.Add('');
  with DM1.OraQuery1 do
  begin
    Close;
    SQL.Clear;
    SQL.Add('select * from HiMSEN_PART_CODE ' +
            'order by PCODE DESC');
    Open;

    while not eof do
    begin
      partname.Items.Add(FieldByName('PCODENM').AsString);
      Next;
    end;
  end;
end;

procedure TnewPartList_Frm.partnameSelect(Sender: TObject);
begin
  if partname.ItemIndex > 0 then
  begin
    partName.ReadOnly := True;
    with DM1.OraQuery1 do
    begin
      Close;
      SQL.Clear;
      SQL.Add('select * from HIMSEN_PART_CODE ' +
              'where PCODENM = '''+partname.Text+''' ');
      Open;

      if not(RecordCount = 0) then
      begin
        partcode.Text := FieldByName('PCODE').AsString;
        partcode.ReadOnly := True;
        suggest_btn.Enabled := False;
      end
      else
      begin
        partcode.ReadOnly := False;
        suggest_btn.Enabled := True;
      end;
    end;
  end
  else
  begin
    partName.ReadOnly := False;
    partcode.Clear;
    partcode.ReadOnly := False;
    suggest_btn.Enabled := True;
  end;
end;

procedure TnewPartList_Frm.rootTreeMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
var
  lNode : TTreeNode;
  li : integer;
  lid : String;
begin
  if Button = mbRight then
  begin
    with rootTree do
    begin
      FCurrentNode := rootTree.GetNodeAt(X,Y);

      if FCurrentNode = Nil then
        FCurrentNode := rootTree.Items.Item[0];
      rootPop.Popup(Mouse.CursorPos.X,Mouse.CursorPos.Y);
    end;
  end;

  if Button = mbLeft then
  begin
    partname.Items.Clear;
    partname.Clear;
    partcode.Clear;
    FnewCode.Checked := False;

    FCurrentNode := rootTree.GetNodeAt(X,Y);

    if FCurrentNode <> nil then
    begin
      Selected_Part_Info(FCurrentNode);
      li := POS(';',FCurrentNode.Text);
      if li > 0 then
      begin
        rootname.Text := Copy(FCurrentNode.Text,0,li-1);
        rootid.Text := Copy(FCurrentNode.Text,li+1,Length(FCurrentNode.Text));

        FnewCode.Checked := False;
        FnewCode.Rootnm := rootname.Text;
        FnewCode.Rootid := rootid.Text;
      end;
    end;
  end;
end;

procedure TnewPartList_Frm.Selected_Part_Info(aNode:TTreeNode);
var
  li : integer;
  lid : String;
begin
  if aNode <> nil then
  begin
    li := pos(';',aNode.Text);

    if li > 0 then
    begin
      lid := Copy(aNode.Text,li+1,Length(aNode.Text));

      with partGrid do
      begin
        BeginUpdate;
        AutoSize := False;
        try
          with OraQuery1 do
          begin
            Close;
            SQL.Clear;
            SQL.Add('SELECT * FROM HIMSEN_PART_DESC_V ' +
                    'WHERE ROOTNO = '+lid);
            Open;
          end;
        finally
          AutoSize := True;
          EndUpdate;
        end;
      end;
    end;
  end;
end;

procedure TnewPartList_Frm.Set_Apply_Grid;
var
  le,
  li : integer;
begin
  appGrid.ClearRows;
  with DM1.OraQuery1 do
  begin
    Close;
    SQL.Clear;
    SQL.Add('select * from HIMSEN_PART_GRP_V');
    SQL.Add('where ROOTNO = '+rtid.Text);
    SQL.Add('and PCODE = '+ptid.Text);
    SQL.Add('Order by GrpNo');
    Open;

    if not(RecordCount = 0) then
    begin
      with appGrid do
      begin
        try
          BeginUpdate;
          while not eof do
          begin
            AddRow(1);
            Cells[1,RowCount-1] := FieldByName('SUBJECTID').AsString;
            Cells[2,RowCount-1] := FieldByName('SUBJECT_ENG').AsString;
            Cells[3,RowCount-1] := FieldByName('PDESC').AsString;

            for li := 0 to subjGrid.RowCount-1 do
            begin
              if subjGrid.Cells[2,li] = Cells[1,RowCount-1] then
              begin
                subjGrid.Cell[1,li].AsBoolean := True;
                Break;
              end;
            end;
            Next;
          end;
        finally
          EndUpdate;
        end;
      end;
    end
    else
    begin
      with appGrid do
      begin
        BeginUpdate;
        try
          with DM1.OraQuery1 do
          begin
            Close;
            SQL.Clear;
            SQL.Add('SELECT * FROM HIMSEN_PART_SUBJECT ' +
                    'where SUBJNO < 6 order by SUBJNO');
            Open;

            if not(RecordCount = 0) then
            begin
              while not eof do
              begin
                AddRow(1);
                Cells[1,RowCount-1] := FieldByName('SUBJECTID').AsString;
                Cells[2,RowCount-1] := FieldByName('SUBJECT_ENG').AsString;
                Cells[3,RowCount-1] := FieldByName('PDESC').AsString;

                for li := 0 to subjGrid.RowCount-1 do
                begin
                  if subjGrid.Cells[2,li] = Cells[1,RowCount-1] then
                  begin
                    subjGrid.Cell[1,li].AsBoolean := True;
                    Break;
                  end;
                end;

                for li := 0 to appGrid.Columns.Count-1 do
                  appGrid.Cell[li,appGrid.RowCount-1].TextColor := clBlue;

                Next;
              end;
            end;
          end;
        finally
          EndUpdate;
        end;
      end;
    end;
  end;
end;

procedure TnewPartList_Frm.Set_of_the_spec_tree(aListNo,aParent:Integer;aSubj:String);
var
  lidx,
  li : integer;
  lNode : TTreeNode;
  lsubj : String;
begin
  with specTree do
  begin
    Items.BeginUpdate;
    try
      if not(aParent = 0) then
      begin
        with DM1.OraQuery2 do
        begin
          Close;
          SQL.Clear;
          SQL.Add('select * from HIMSEN_PART_LIST ' +
                  'where LISTNO = '+IntToStr(aParent));
          Open;

          for li := 0 to Items.Count-1 do
          begin
            lSubj := Items[li].Text;
            lidx := pos(';',lSubj);
            if lidx > 0 then
              lSubj := Copy(lSubj,0,lidx-1);

            if lSubj = FieldByName('PARTNAME').AsString then
            begin
              lNode := Items[li];
              Break;
            end;
          end;
        end;

        with DM1.OraQuery2 do
        begin
          Close;
          SQL.Clear;
          SQL.Add('select * from himsen_part_list START WITH LISTNO = '+IntToStr(aListNo) +
                  ' and PARTNAME = PARTNAME connect by prior ' +
                  ' listno = parent order siblings by listno');

          Open;

          if not(RecordCount = 0) then
          begin
            if not(RecordCount = 1) then
              Items.AddChild(lNode,aSubj)
            else
              Items.AddChild(lNode,aSubj+';'+IntToStr(aListNo));
          end;
        end;
      end
      else
      begin
        Items.Add(nil,aSubj);
      end;
    Finally
      Items.EndUpdate;
    end;
  end;
end;

procedure TnewPartList_Frm.Set_Subject_Grid;
var
  li : integer;
  LStr : sTring;

begin
  with DM1.OraQuery1 do
  begin
    Close;
    SQL.Clear;
    SQL.Add('select * from HIMSEN_PART_SUBJECT order by SUBJNO');
    Open;

    subjGrid.ClearRows;

    with subjGrid do
    begin
      try
        BeginUpdate;
        while not eof do
        begin
          AddRow(1);
          Cell[1,RowCount-1].AsBoolean := False;
          Cells[2,RowCount-1] := FieldByName('SUBJECTID').AsString;
          Cells[3,RowCount-1] := FieldByName('SUBJECT_ENG').AsString;
          Cells[4,RowCount-1] := FieldByName('PDESC').AsString;
          Next;
        end;
      finally
        EndUpdate;
      end;
    end;
  end;
end;

procedure TnewPartList_Frm.Set_the_Page2_Detail;
begin
  with Fieldgrid do
  begin
    BeginUpdate;
    try
      if RowCount > 2 then
      begin
        RemoveRows(2,RowCount-2);
        ClearRows(1,1);
      end
      else
        ClearRows(1,1);

      with DM1.OraQuery1 do
      begin
        Close;
        SQL.Clear;
        SQL.Add('select * from HIMSEN_PART_SUBJECT order by SUBJNO');
        Open;

        while not eof do
        begin
          AddRow;
          Cells[1,RowCount-1] := FieldByName('SUBJECTID').AsString;
          Cells[2,RowCount-1] := FieldByName('SUBJECT_').AsString;
          Cells[3,RowCount-1] := FieldByName('SUBJECT_KOR').AsString;
          Cells[4,RowCount-1] := FieldByName('SUBJECT_ENG').AsString;
          Next;
        end;
      end;
    finally
      while Cells[1,1] = '' do
        RemoveRows(1,1);

      AutoSize := True;
      EndUpdate;
    end;
  end;
end;

procedure TnewPartList_Frm.Set_the_Page3_Detail;
var
  LSubjList : TStringList;
  lParent : Integer;
  lSubj : String;
  listNo : Integer;
  li : integer;
  lNode : TTreeNode;
begin
  specTree.Items.BeginUpdate;
  try
    if Show_specTree_Root = True then
    begin
      Add_Code_to_specTree;
      Set_Subject_Grid;
    end;
  finally
    for li := 0 to specTree.Items.Count-1 do
    begin
      lNode := specTree.Items.Item[li];
      lNode.Expanded := True;
    end;
    specTree.Items.EndUpdate;
  end;
end;

procedure TnewPartList_Frm.Show_Part_Code(aRootNo: String);
begin
  with OraQuery1 do
  begin
    Close;
    SQL.Clear;
  end;
end;

procedure TnewPartList_Frm.Show_Root;
var
  lNode: TTreeNode;
  lstr,lstr1: String;
  li,le: integer;
  lQuery : TOraQuery;
  lPrtNo : String;
begin
  with DM1.OraQuery1 do
  begin
    Close;
    SQL.Clear;
    SQL.Add('select * from HIMSEN_PART_ROOT START WITH LV = 0 '+
            'connect by prior ROOTNO = PRTROOT order siblings by rootno');
    Open;

    if not(RecordCount = 0) then
    begin
      with rootTree.Items do
      begin
        BeginUpdate;
        Clear;
        lQuery := TOraQuery.Create(nil);
        lQuery.Session := DM1.OraSession1;
        try
          for li := 0 to RecordCount-1 do
          begin
            lstr := FieldByName('ROOTNAME').AsString+';'+FieldByName('ROOTNO').AsString;
            if li = 0 then
              lNode := Add(nil,lstr)
            else
            begin
              lprtNo := FieldByName('PRTROOT').AsString;
              with lQuery do
              begin
                Close;
                SQL.Clear;
                SQL.Add('select * from HIMSEN_PART_ROOT where ROOTNO = '+lprtNo);
                Open;

                if not(RecordCount = 0) then
                begin
                  lstr1 := FieldByName('ROOTNAME').AsString+';'+FieldByName('ROOTNO').AsString;
                  for le := 0 to Count-1 do
                  begin
                    if Item[le].Text = lstr1 then
                    begin
                      lNode := Item[le];
                      Break;
                    end;
                  end;
                  addChild(lNode,lstr);
                end;
              end;
            end;
            lNode.Expanded := True;
            Next;
          end;
        finally
          EndUpdate;
          FreeAndNil(lQuery);
        end;
      end;
    end;
  end;
end;

function TnewPartList_Frm.Show_specTree_Root : Boolean;
var
  nNode,
  lNode: TTreeNode;
  lstr,lstr1: String;
  li,le: integer;
  lQuery : TOraQuery;
  lPrtNo : String;
begin
  Result := False;
  with DM1.OraQuery1 do
  begin
    Close;
    SQL.Clear;
    SQL.Add('select * from HIMSEN_PART_ROOT START WITH LV = 0 '+
            'connect by prior ROOTNO = PRTROOT order siblings by rootno');
    Open;

    if not(RecordCount = 0) then
    begin
      with specTree.Items do
      begin
        BeginUpdate;
        Clear;
        lQuery := TOraQuery.Create(nil);
        lQuery.Session := DM1.OraSession1;
        try
          try
            for li := 0 to RecordCount-1 do
            begin
              lstr := FieldByName('ROOTNAME').AsString+';'+FieldByName('ROOTNO').AsString;
              if li = 0 then
              begin
                lNode := Add(nil,lstr);
              end
              else
              begin
                lprtNo := FieldByName('PRTROOT').AsString;
                with lQuery do
                begin
                  Close;
                  SQL.Clear;
                  SQL.Add('select * from HIMSEN_PART_ROOT where ROOTNO = '+lprtNo);
                  Open;

                  if not(RecordCount = 0) then
                  begin
                    lstr1 := FieldByName('ROOTNAME').AsString+';'+FieldByName('ROOTNO').AsString;
                    for le := 0 to Count-1 do
                    begin
                      if Item[le].Text = lstr1 then
                      begin
                        lNode := Item[le];
                        Break;
                      end;
                    end;
                    addChild(lNode,lstr);
                  end;
                end;
              end;
              Next;
            end;
            specTree.Columns[1].Font.Color := clWhite;
            Result := True;
          except
            Result := False;
          end;
        finally
          EndUpdate;
          FreeAndNil(lQuery);
        end;
      end;
    end;
  end;
end;

procedure TnewPartList_Frm.specTreeChange(Sender: TObject; Node: TTreeNode);
begin
  with specTree.Items do
  begin
    BeginUpdate;
    try
      if Node.Selected = True then
        Node.SelectedIndex := 2;
    finally
      EndUpdate;
    end;
  end;
end;

procedure TnewPartList_Frm.specTreeDblClick(Sender: TObject);
var
  lNode : TTreeNode;
  lidx : integer;
  lStr : String;

begin
  Set_Subject_Grid;

  lNode := specTree.Selected;
  if lNode <> nil then
  begin
    if lNode.ImageIndex = 1 then
    begin
      lidx := pos(';',lNode.Parent.Text);
      rtnm.Text := Copy(lNode.Parent.Text,0,lidx-1);
      rtid.Text := Copy(lNode.Parent.Text,lidx+1,Length(lNode.Parent.Text)-lidx);

      lidx := pos(';',lNode.Text);
      ptnm.Text := Copy(lNode.Text,0,lidx-1);
      ptid.Text := Copy(lNode.Text,lidx+1,Length(lNode.Text)-lidx);

      with DM1.OraQuery1 do
      begin
        Close;
        SQL.Clear;
        SQL.Add('select * from HIMSEN_PART_GRP_V');
        SQL.Add('where ROOTNO = '+rtid.Text);
        SQL.Add('and PCODE = '+ptid.Text);
        Open;

        if RecordCount > 0 then
          FAddType := 'Update'
        else
          FAddType := 'New';
      end;

      Set_Apply_Grid;
    end;
  end;
end;

procedure TnewPartList_Frm.subjGridAfterEdit(Sender: TObject; ACol,
  ARow: Integer; Value: WideString);
var
  lstr : String;
begin
  if (rtid.Text = '') then
    Exit;

  if subjGrid.Cell[1,ARow].AsBoolean = True then
    add_items_to_Grid(ARow)
  else
  begin
    lstr := subjGrid.Cells[3,ARow];
    if not(lstr = 'MAKER') and
       not(lstr = 'TYPE') and
       not(lstr = 'PARTNO') and
       not(lstr = 'DWGNO') and
       not(lstr = 'REMARK') then
       del_items_in_Grid(subjGrid.Cells[2,ARow])
    else
      subjGrid.Cell[1,ARow].AsBoolean := True;
  end;
end;

procedure TnewPartList_Frm.tablenameButtonDown(Sender: TObject);
begin
{
  with DM1.OraQuery1 do
  begin
    Close;
    SQL.Clear;
    SQL.Add('select * from tabs where TABLE_NAME like ''%HIMSEN_PART_%''');
    Open;

    tablename.Items.Clear;

    if not(RecordCount = 0) then
    begin
      while not eof do
      begin
        tablename.Items.Add(FieldByName('TABLE_NAME').AsString);
        Next;
      end;
    end;
  end;

}
end;

procedure TnewPartList_Frm.Update_GrpNo_In_DB;
var
  lGrpNo,
  li : integer;
  LSQL,
  lSubjectid : String;
begin
  with appGrid do
  begin
    lGrpNo := 0;
    for li := 0 to RowCount-1 do
    begin
      if not(Cell[1,li].TextColor = clRed) then
      begin
        Inc(lGrpNo);
        lSubjectid := Cells[1,li];

        LSQL := 'Update HIMSEN_PART_GROUP SET ' +
                'GRPNO = '+IntToStr(lGRPNO) +','+
                ' MODID = '''+CurrentUsers+''',' +
                ' MODDATE = :param1 ' +
                ' where ROOTNO = '+rtId.Text+
                ' and PCODE = '+ptId.Text+
                ' and Subjectid = '''+lSubjectid+''' ';

        with DM1.OraQuery1 do
        begin
          Close;
          SQL.Clear;
          SQL.Add(LSQL);
          ParamByName('param1').AsDateTime := Now;
          ExecSQL;
        end;
      end;
    end;
  end;
end;


end.
