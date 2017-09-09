unit addRefer_Unit;

interface

uses
  Trouble_Unit, Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, NxEdit, ComCtrls, NxColumnClasses, NxColumns,
  NxScrollControl, NxCustomGridControl, NxCustomGrid, NxGrid, NxCollection,
  AdvOfficeStatusBar, DB, Menus, MemDS, DBAccess, Ora, ExtCtrls, Grids, AdvObj,
  BaseGrid, AdvGrid, Vcl.ImgList, StrUtils;

type
  TaddRefer_Frm = class(TForm)
    AdvOfficeStatusBar1: TAdvOfficeStatusBar;
    NxHeaderPanel1: TNxHeaderPanel;
    NxHeaderPanel2: TNxHeaderPanel;
    NxPanel2: TNxPanel;
    NxHeaderPanel4: TNxHeaderPanel;
    DeptSection: TNxComboBox;
    ConfirmList: TNextGrid;
    NxIncrementColumn1: TNxIncrementColumn;
    NxTextColumn2: TNxTextColumn;
    NxTextColumn3: TNxTextColumn;
    Panel1: TPanel;
    Panel2: TPanel;
    NxTextColumn6: TNxTextColumn;
    NextGrid1: TNextGrid;
    NxCheck: TNxCheckBoxColumn;
    NxTextColumn4: TNxTextColumn;
    NxTextColumn5: TNxTextColumn;
    NxTextColumn7: TNxTextColumn;
    Label1: TLabel;
    Label2: TLabel;
    Panel3: TPanel;
    Panel4: TPanel;
    Imglist16x16: TImageList;
    Button1: TButton;
    Button2: TButton;
    Button3: TButton;
    Button7: TButton;
    Button6: TButton;
    grid_Dept: TNextGrid;
    NxTreeColumn1: TNxTreeColumn;
    NxTextColumn8: TNxTextColumn;
    NxTextColumn9: TNxTextColumn;
    procedure FormCreate(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure membertreeGetImageIndex(Sender: TObject; Node: TTreeNode);
    procedure membertreeGetSelectedIndex(Sender: TObject; Node: TTreeNode);
    procedure Button1Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button5Click(Sender: TObject);
    procedure Button4Click(Sender: TObject);
    procedure Button6Click(Sender: TObject);
    procedure Button7Click(Sender: TObject);
    procedure NextGrid1HeaderClick(Sender: TObject; ACol: Integer);
    procedure NextGrid1SortColumn(Sender: TObject; ACol: Integer;
      Ascending: Boolean);
    procedure DeptSectionButtonDown(Sender: TObject);
    procedure DeptSectionSelect(Sender: TObject);
    procedure grid_DeptSelectCell(Sender: TObject; ACol, ARow: Integer);
  private
    { Private declarations }
  public
    { Public declarations }
    FOwner : TTrouble_Frm;
    FFirst : Boolean;
    FChecked : Boolean;



    procedure Get_Confirm_List_From_MainForm;//결재선 수정시 사용
    procedure ConfirmList_Apply_2_ConfirmTable; //결재 대상자들을 메인폼 결재 테이블에 적용

    function Check_for_Code_base_on_CodeNm(FcodeNm:String) : String;
    function Check_for_CodeNm_base_on_Code(Fcode:String) : String;
    function Check_for_DeptCode_base_on_DeptNm(FcodeNm:String) : String;


    procedure Search_for_User_based_on_TeamCode(Fcode:String);

    procedure Add_Refer_List_to_Main_Form;
//    procedure Confirm_List_Get_From_DB;


    //13.02.06 수정 / 추가분
    procedure Review_Tree(aParentNo:String;aTreeNode:TTreeNode);

    procedure Get_DeptList(aDept_CD:String);
    function Get_DeptName(aDept_CD:String):String;
  end;

var
  addRefer_Frm: TaddRefer_Frm;

implementation
uses
  DataModule_Unit;

{$R *.dfm}

{ TConfirmForm }


procedure TaddRefer_Frm.FormCreate(Sender: TObject);
begin
  FFirst := True;
  FChecked := False;
end;

procedure TaddRefer_Frm.Get_Confirm_List_From_MainForm;
var
  Li, Le : integer;
  LCList : TStringList;
begin
  if FOwner.AppGrid.ColCount > 2 then
  begin
    ConfirmList.ClearRows;


    with DM1.TQuery1 do
    begin
      Close;
      SQL.Clear;
      SQL.Add('select * from zHITEMS_APPROVER where CODEID = :param1');
      Parambyname('param1').AsString := Fowner.CODEID.Text;
      Open;

      if RecordCount = 0 then Exit;

      LCList := TStringList.Create;
      Le := Fieldbyname('ACount').AsInteger;

      for li := 0 to Le-1 do
        LCList.Add(Fields[li+3].AsString);
    end;

    for li := LClist.Count-1 Downto 1 do
    begin
      with DM1.TQuery1 do
      begin
        Close;
        SQL.Clear;
        SQL.Add('select A.*, B.CODENM from User_Info A, ZHITEMSCODE B');
        SQL.Add('where UserID = :param1 and A.Class = B.CODE');
        Parambyname('param1').AsString := LCList[li];
        Open;

        if not(RecordCount > 1) then
        begin
          ConfirmList.AddRow(1);
          ConfirmList.Cells[1,ConfirmList.RowCount-1] := FieldByName('Name_Kor').AsString;
          ConfirmList.Cells[2,ConfirmList.RowCount-1] := FieldByName('CODENM').AsString;
          ConfirmList.Cells[3,ConfirmList.RowCount-1] := LCList[li];
        end
      end;
    end;
  end;//if
  ConfirmList.Refresh;
end;

procedure TaddRefer_Frm.Get_DeptList(aDept_CD: String);
var
  i : Integer;
  LRow : Integer;
begin
  with grid_Dept do
  begin
    BeginUpdate;
    try
      ClearRows;
      with DM1.OraQuery1 do
      begin
        Close;
        SQL.Clear;
        SQL.Add('SELECT * FROM HITEMS.HITEMS_DEPT ' +
                'START WITH DEPT_CD LIKE :param1 ' +
                'CONNECT BY PRIOR DEPT_CD = PARENT_CD ' +
                'ORDER SIBLINGS BY DEPT_CD, DEPT_NAME ');
        ParamByName('param1').AsString := aDept_CD;
        Open;

        while not eof do
        begin
          if RowCount = 0 then
            LRow := AddRow(1)
          else
          begin
            if FieldByName('PARENT_CD').AsString <> '' then
            begin
              for i := 0 to RowCount-1 do
              begin
                if Cells[1,i] = FieldByName('PARENT_CD').AsString then
                begin
                  AddChildRow(i,crLast);
                  LRow := LastAddedRow;
                  Break;
                end;
              end;
            end else
              LRow := AddRow(1);

          end;
          Cells[0,LRow] := FieldByName('DEPT_NAME').AsString;
          Cells[1,LRow] := FieldByName('DEPT_CD').AsString;
          Cells[2,LRow] := FieldByName('PARENT_CD').AsString;
          Next;

        end;
      end;
    finally
      EndUpdate;
    end;
  end;
end;

function TaddRefer_Frm.Get_DeptName(aDept_CD: String): String;
var
  OraQuery : TOraQuery;
begin
  OraQuery := TOraQuery.Create(nil);
  try
    OraQuery.Session := DM1.TSession1;
    with OraQuery do
    begin
      Close;
      SQL.Clear;
      SQL.Add('SELECT DEPT_NAME FROM HITEMS.HITEMS_DEPT ' +
              'WHERE DEPT_CD LIKE :param1 ');
      ParamByName('param1').AsString := aDept_CD;
      Open;

      Result := FieldByName('DEPT_NAME').AsString;

    end;
  finally
    FreeAndNil(OraQuery);
  end;
end;

procedure TaddRefer_Frm.grid_DeptSelectCell(Sender: TObject; ACol,
  ARow: Integer);
var
  LDeptCD : String;
  LRow : Integer;
begin
  if ARow = -1 then
    Exit;

  LDeptCD := grid_Dept.Cells[1,ARow];
  with NextGrid1 do
  begin
    BeginUpdate;
    try
      ClearRows;
      with DM1.OraQuery2 do
      begin
        Close;
        SQL.Clear;
        SQL.Add('SELECT A.USERID, NAME_KOR, B.DESCR FROM HITEMS.HITEMS_USER A, HITEMS.HITEMS_USER_GRADE B ' +
                'WHERE GUNMU = :param1 ' +
                'AND A.GRADE = B.GRADE ' +
                'AND DEPT_CD like :param2 '+
                'ORDER BY PRIV DESC, A.GRADE, USERID ');
        ParamByName('param1').AsString := 'I';
        ParamByName('param2').AsString := '%'+LDeptCD+'%';
        Open;

        Label2.Caption := '[총 '+IntToStr(RecordCount)+'명]';
        while not eof do
        begin
          LRow := AddRow;
          Cells[1,LRow] := FieldByName('NAME_KOR').AsString;
          Cells[2,LRow] := FieldByName('DESCR').AsString;
          Cells[3,LRow] := FieldByName('USERID').AsString;
          Next;
        end;
      end;
    finally
      EndUpdate;
    end;
  end;
end;

procedure TaddRefer_Frm.membertreeGetImageIndex(Sender: TObject;
  Node: TTreeNode);
begin
  Node.ImageIndex := 1;
end;

procedure TaddRefer_Frm.membertreeGetSelectedIndex(Sender: TObject;
  Node: TTreeNode);
begin
  Node.ImageIndex := 2;
end;

procedure TaddRefer_Frm.FormActivate(Sender: TObject);
var
  LDeptCD : String;
begin
  if FFirst = True then
  begin
    FFirst := False;

    LDeptCD := LeftStr(FOwner.Statusbar1.Panels[2].Text,3);
    DeptSection.Text := Get_DeptName(LDeptCD);
    Get_DeptList(LDeptCD);
    grid_Dept.SelectedRow := 0;
    grid_Dept.SetFocus;
    Get_Confirm_List_From_MainForm;
  end;
end;

procedure TaddRefer_Frm.DeptSectionButtonDown(Sender: TObject);
begin
  with DeptSection.Items do
  begin
    BeginUpdate;
    try
      Clear;
      with DM1.OraQuery2 do
      begin
        Close;
        SQL.Clear;
        SQL.Add('select DEPT_NAME, DEPT_CD, ENGDESCR from HITEMS.HITEMS_DEPT ' +
                'WHERE (DEPT_LV = 0 OR DEPT_LV = 1) ' +
                'ORDER BY DEPT_CD, DEPT_NAME ');
        Open;

        while not eof do
        begin
          if FieldByName('ENGDESCR').AsString <> '*' then
            Add(FieldByName('DEPT_NAME').AsString);
          Next;
        end;
      end;
    finally
      EndUpdate;
    end;
  end;
end;

procedure TaddRefer_Frm.DeptSectionSelect(Sender: TObject);
begin
  with DM1.OraQuery2 do
  begin
    First;
    DeptSection.Hint := '';
    while not eof do
    begin
      if FieldByName('DEPT_NAME').AsString = DeptSection.Text then
      begin
        DeptSection.Hint := FieldByName('DEPT_CD').AsString;
        Get_DeptList(DeptSection.Hint);
        grid_Dept.SelectedRow := 0;
        grid_Dept.SetFocus;
        Break;
      end;
      Next;
    end;
  end;
end;

procedure TaddRefer_Frm.NextGrid1HeaderClick(Sender: TObject; ACol: Integer);
var
  li : integer;
  lchk : Boolean;
begin
  if FChecked = false then
    FChecked := True
  else
    FChecked := False;

  case ACol of
    0 : begin
          with NextGrid1 do
          begin
            for li := 0 to Rowcount-1 do
              NextGrid1.Cell[0,li].AsBoolean := FChecked;

          end;
        end;
  end;
end;

procedure TaddRefer_Frm.NextGrid1SortColumn(Sender: TObject; ACol: Integer;
  Ascending: Boolean);
begin
  case ACOL of
    0 : Exit;
  end;
end;

procedure TaddRefer_Frm.Review_Tree(aParentNo: String; aTreeNode: TTreeNode);
var
  lName : String;
  lChildNode : TTreeNode;
  lPCDGrp : String;
  OraQuery1 : TOraQuery;

begin
  OraQuery1 := TOraQuery.Create(Self);
  OraQuery1.Session := DM1.TSession1;
  try
    with OraQuery1 do
    begin
      Close;
      SQL.Clear;
      SQL.Add('select * from HiTEMS_DEPTNO ' +
              'where PRTDEPTNO = '''+ aParentNo +''' '+
              ' order by DEPTNO ');
      Open;

      if RecordCount > 0 then
      begin
        while not eof do
        begin
          lPCDGrp := FieldByName('DEPTNO').AsString;
          lName := FieldByName('DEPTNAME').AsString;


          Review_Tree(lPCDGrp,lChildNode);

          Next;
        end;
      end;
    end;
  finally
    OraQuery1.Close;
    FreeAndNil(OraQuery1);
  end;
end;

procedure TaddRefer_Frm.Add_Refer_List_to_Main_Form;
var
  li : integer;
  LReferListA : String; //이름
  LReferListB : String; //사번
begin
  for li := 0 to ConfirmList.RowCount-1 do
  begin
    LReferListA := LReferListA + ConfirmList.Cells[1,li] + ';';
    LReferListB := LReferListB + ConfirmList.Cells[3,li] + ';';
  end;
  FOwner.CCListN.Text := LReferListA;
  FOwner.CCListS.Text := LReferListB;
end;

procedure TaddRefer_Frm.Button1Click(Sender: TObject);
var
  li,le : integer;
  LBoolean : Boolean;

begin
  try
    with NextGrid1 do
    begin
      for li := 0 to Rowcount-1 do
      begin
        if Cell[0,li].AsBoolean then
        begin
          LBoolean := True;

          for le := 0 to ConfirmList.Rowcount-1 do
            if Cells[3,li] = ConfirmList.Cells[3,le] then
              LBoolean := False;

          if (LBoolean) then
          begin
            ConfirmList.AddRow(1);
            ConfirmList.Cells[1,ConfirmList.Rowcount-1] := Cells[1,li];
            ConfirmList.Cells[2,ConfirmList.Rowcount-1] := Cells[2,li];
            ConfirmList.Cells[3,ConfirmList.Rowcount-1] := Cells[3,li];

          end;
        end;
      end;
    end;
  finally
    for li := 0 to NextGrid1.RowCount-1 do
      NextGrid1.cell[0,li].AsBoolean := False;

  end;
end;

procedure TaddRefer_Frm.Button2Click(Sender: TObject);
var
  li : integer;
begin
  ConfirmList.DeleteRow(ConfirmList.SelectedRow);
end;

procedure TaddRefer_Frm.Button3Click(Sender: TObject);
begin
  ConfirmList.ClearRows;
end;

procedure TaddRefer_Frm.Button4Click(Sender: TObject);
begin
  with ConfirmList do
  begin
    if not(SelectedRow = RowCount-1) then
    begin
      ConfirmList.MoveRow(SelectedRow,SelectedRow+1);
      ConfirmList.SelectedRow := SelectedRow+1;
    end;
  end;
end;

procedure TaddRefer_Frm.Button5Click(Sender: TObject);
begin
  with ConfirmList do
  begin
    if not(SelectedRow = 0) then
    begin
      ConfirmList.MoveRow(SelectedRow,SelectedRow-1);
      ConfirmList.SelectedRow := SelectedRow-1;
    end;
  end;
end;

procedure TaddRefer_Frm.Button6Click(Sender: TObject);
begin
  Close;
end;

procedure TaddRefer_Frm.Button7Click(Sender: TObject);
begin
  try
    if not(ConfirmList.RowCount = 0) then
      Add_Refer_List_to_Main_Form;
  finally
    Close;
  end;
end;

function TaddRefer_Frm.Check_for_CodeNm_base_on_Code(Fcode: String): String;
begin
  with DM1.TQuery2 do
  begin
    Close;
    SQL.Clear;
    SQL.Add('select CODENM from ZHITEMSCODE where CODE = :param1');
    parambyname('param1').AsString := Fcode;
    Open;

    Result := Fieldbyname('CODENM').AsString;
  end;
end;

function TaddRefer_Frm.Check_for_Code_base_on_CodeNm(FcodeNm: String): String;
begin
  with DM1.TQuery2 do
  begin
    Close;
    SQL.Clear;
    SQL.Add('select CODE from ZHITEMSCODE where CODENM = :param1');
    parambyname('param1').AsString := FcodeNm;
    Open;

    Result := Fieldbyname('CODE').AsString;
  end;
end;

function TaddRefer_Frm.Check_for_DeptCode_base_on_DeptNm(
  FcodeNm: String): String;
begin
  with DM1.TQuery2 do
  begin
    Close;
    SQL.Clear;
    SQL.Add('select DeptNo from DeptNo where DESCR = :param1');
    parambyname('param1').AsString := FcodeNm;
    Open;

    Result := Fieldbyname('DeptNo').AsString;
  end;
end;

procedure TaddRefer_Frm.ConfirmList_Apply_2_ConfirmTable;
begin

end;

procedure TaddRefer_Frm.Search_for_User_based_on_TeamCode(Fcode: String);
var
  li : integer;
begin
  with DM1.TQuery1 do
  begin
    Close;
    SQL.Clear;
    SQL.Add('select A.USERID, NAME_KOR, B.DESCR FROM HITEMS.HITEMS_USER A, HITEMS.HITEMS_USER_GRADE B ' +
            'WHERE DEPT_CD LIKE ''%'+ Fcode + '%'' ' +
            'AND A.GRADE = B.GRADE ' +
            'order by Priv Desc, POSITION, GRADE, USERID ');

//    if memberTree.Selected.Level = 0 then
//      SQL.Add('select * from user_info where Dept = :param1 and GUNMU = ''I'' order by Priv desc, CLASS, userid')
//    else
//      SQL.Add('select * from user_info where TEAM = :param1 and GUNMU = ''I'' order by Priv desc, CLASS, userid');
//    parambyname('param1').AsString := Fcode;
    Open;

    with NextGrid1 do
    begin
      try
        ClearRows;
        if not(RecordCount = 0) then
        begin
          for li := 0 to RecordCount -1 do
          begin
            NextGrid1.AddRow(1);
            Cells[1,li] := Fieldbyname('Name_Kor').AsString;
            Cells[2,li] := Fieldbyname('DESCR').AsString;
            Cells[3,li] := Fieldbyname('USERID').AsString;
            Next;
          end;
        end;
      finally
        label2.Caption := ' [총 '+ intToStr(RowCount) +'명]';
        AutoSize := True;
      end;
    end;
  end;
end;


end.
