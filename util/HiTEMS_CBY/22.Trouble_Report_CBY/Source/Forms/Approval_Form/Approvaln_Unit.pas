unit Approvaln_Unit;

interface

uses
  Trouble_Unit, Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, NxEdit, ComCtrls, NxColumnClasses, NxColumns,
  NxScrollControl, NxCustomGridControl, NxCustomGrid, NxGrid, NxCollection,
  AdvOfficeStatusBar, DB, Menus, MemDS, DBAccess, Ora, ExtCtrls, Grids, AdvObj,
  BaseGrid, AdvGrid, Vcl.ImgList, StrUtils;

type
  TApprovaln_Frm = class(TForm)
    AdvOfficeStatusBar1: TAdvOfficeStatusBar;
    NxHeaderPanel1: TNxHeaderPanel;
    NxHeaderPanel2: TNxHeaderPanel;
    DeptSection: TNxComboBox;
    Panel1: TPanel;
    Panel2: TPanel;
    NextGrid1: TNextGrid;
    NxCheck: TNxCheckBoxColumn;
    NxTextColumn4: TNxTextColumn;
    NxTextColumn5: TNxTextColumn;
    NxTextColumn7: TNxTextColumn;
    Label1: TLabel;
    Label2: TLabel;
    Panel3: TPanel;
    Button1: TButton;
    Button2: TButton;
    Button3: TButton;
    Panel4: TPanel;
    NxHeaderPanel4: TNxHeaderPanel;
    ApprovalLine: TNextGrid;
    NxIncrementColumn1: TNxIncrementColumn;
    NxTextColumn1: TNxTextColumn;
    NxTextColumn2: TNxTextColumn;
    NxTextColumn6: TNxTextColumn;
    NxTextColumn3: TNxTextColumn;
    NxPanel4: TNxPanel;
    Button4: TButton;
    Button5: TButton;
    Panel5: TPanel;
    Button7: TButton;
    Button6: TButton;
    Imglist16x16: TImageList;
    grid_Dept: TNextGrid;
    NxTreeColumn1: TNxTreeColumn;
    NxTextColumn8: TNxTextColumn;
    NxTextColumn9: TNxTextColumn;
    procedure FormCreate(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure NxButton1Click(Sender: TObject);
    procedure membertreeGetImageIndex(Sender: TObject; Node: TTreeNode);
    procedure membertreeGetSelectedIndex(Sender: TObject; Node: TTreeNode);
    procedure Button1Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure ApprovalLineChange(Sender: TObject; ACol, ARow: Integer);
    procedure Button5Click(Sender: TObject);
    procedure Button4Click(Sender: TObject);
    procedure Button6Click(Sender: TObject);
    procedure Button7Click(Sender: TObject);
    procedure DeptSectionButtonDown(Sender: TObject);
    procedure DeptSectionSelect(Sender: TObject);
    procedure grid_DeptSelectCell(Sender: TObject; ACol, ARow: Integer);
  private
    { Private declarations }
  public
    { Public declarations }
    FOwner : TTrouble_Frm;
    FFirst : Boolean;



    procedure Get_Approval_Line_From_Trouble_Form;//결재선 수정시 사용
    procedure Approval_line_Apply_2_AppGrid; //결재 대상자들을 메인폼 결재 테이블에 적용

    function Check_for_Code_base_on_CodeNm(FcodeNm:String) : String;
    function Check_for_CodeNm_base_on_Code(Fcode:String) : String;
    function Check_for_DeptCode_base_on_DeptNm(FcodeNm:String) : String;


    procedure Search_for_User_based_on_TeamCode(Fcode:String);
//    procedure Confirm_List_Get_From_DB;

    procedure Get_DeptList(aDept_CD:String);
    function Get_DeptName(aDept_CD:String):String;

  end;

var
  Approvaln_Frm: TApprovaln_Frm;

implementation
uses
  DataModule_Unit, HiTEMS_TRC_COMMON, CommonUtil_Unit;

{$R *.dfm}

{ TConfirmForm }


procedure TApprovaln_Frm.FormCreate(Sender: TObject);
begin
  FFirst := True;
end;

procedure TApprovaln_Frm.Get_Approval_Line_From_Trouble_Form;
var
  Li, Le : integer;
  LCList : TStringList;
  LName, LPos: string;
begin
  if FOwner.AppGrid.ColCount > 2 then
  begin
    ApprovalLine.ClearRows;

    with DM1.TQuery1 do
    begin
      Close;
      SQL.Clear;
      SQL.Add('select * from zHITEMS_APPROVER where CODEID = :param1');
      Parambyname('param1').AsString := Fowner.CODEID.Text;
      Open;

      if RecordCount = 0 then
      begin
        if FOwner.AppGrid.ColCount > 2 then
        begin
          for Li := FOwner.AppGrid.ColCount - 1 downto 2 do
          begin
            Le := ApprovalLine.AddRow();
            ApprovalLine.Cells[1, Le] := ' ';//결재선
            LName := FOwner.Appgrid.Cells[Li,0];
            LPos := strToken(LName, '/');
            LName := strToken(LName, '/');
            ApprovalLine.Cells[2, Le] := LName; //이름
            ApprovalLine.Cells[3, Le] := LPos;//직급
          end;
        end;

        Exit;
      end;

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
        SQL.Add('select A.USERID, NAME_KOR, B.DESCR from HITEMS.HITEMS_USER A, HITEMS.HITEMS_USER_GRADE B ');
        SQL.Add('WHERE USERID = :param1 and A.GRADE = B.GRADE ');
        Parambyname('param1').AsString := LCList[li];
        Open;

        if not(RecordCount > 1) then
        begin
          ApprovalLine.AddRow(1);
          ApprovalLine.Cells[2,ApprovalLine.RowCount-1] := FieldByName('Name_Kor').AsString;
          ApprovalLine.Cells[3,ApprovalLine.RowCount-1] := FieldByName('DESCR').AsString;
          ApprovalLine.Cells[4,ApprovalLine.RowCount-1] := LCList[li];
        end    
      end;
    end;
    

    for li := 0 to ApprovalLine.RowCount-1 do
    begin
      if li = 0 then
        ApprovalLine.Cells[1,li] := '승인'
      else
        ApprovalLine.Cells[1,li] := '검토';

    end;//for
  end;//if
  ApprovalLine.Refresh;
end;

procedure TApprovaln_Frm.Get_DeptList(aDept_CD: String);
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

function TApprovaln_Frm.Get_DeptName(aDept_CD: String): String;
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

procedure TApprovaln_Frm.grid_DeptSelectCell(Sender: TObject; ACol,
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

procedure TApprovaln_Frm.membertreeGetImageIndex(Sender: TObject;
  Node: TTreeNode);
begin
  Node.ImageIndex := 1;
end;

procedure TApprovaln_Frm.membertreeGetSelectedIndex(Sender: TObject;
  Node: TTreeNode);
begin
  Node.ImageIndex := 2;
end;

procedure TApprovaln_Frm.FormActivate(Sender: TObject);
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

    Get_Approval_Line_From_Trouble_Form;
  end;
end;

procedure TApprovaln_Frm.DeptSectionButtonDown(Sender: TObject);
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
        SQL.Add('select DEPT_NAME, DEPT_CD from HITEMS.HITEMS_DEPT ' +
                'WHERE (DEPT_LV = 0 OR DEPT_LV = 1) ' +
                'ORDER BY DEPT_CD, DEPT_NAME ');
        Open;

        while not eof do
        begin
          Add(FieldByName('DEPT_NAME').AsString);
          Next;
        end;
      end;
    finally
      EndUpdate;
    end;
  end;
end;

procedure TApprovaln_Frm.DeptSectionSelect(Sender: TObject);
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

procedure TApprovaln_Frm.NxButton1Click(Sender: TObject);
var
  LNode : TTreeNode;
  LStr : wideString;
  Lc, Li : integer;
begin
//  LNode := MemberTree.Selected;
  LStr := LNode.Text;


  if not(Length(LStr) > 4) then
  begin
    for lc := 0 to ApprovalLine.RowCount-1 do
    begin
      with ApprovalLine do
      begin
        if Cells[2,lc] = LStr then
        begin
          ShowMessage('이미 결재선으로 지정되어 있습니다.');
          Exit;
        end;
      end;
    end;

    ApprovalLine.AddRow(1);

    if DeptSection.ItemIndex = 0 then
    begin
      with DM1.TQuery1 do
      begin
        Close;
        SQL.Clear;
        SQL.Add('select USERID, NAME_KOR from HITEMS.HITEMS_USER ');
        SQL.Add('where NAME_KOR = :param1');
        Parambyname('param1').AsString := LNode.Text;
        Open;

        if not(RecordCount > 1) then
        begin
          ApprovalLine.Cells[2,ApprovalLine.RowCount-1] := LNode.Text; //이름등록
          ApprovalLine.Cells[3,ApprovalLine.RowCount-1] := FieldByName('UserID').AsString;
        end
        else
        begin
          //동명이인이 발생하였을 경우...
        end;
      end;//with ZQ
    end;

    if DeptSection.ItemIndex > 0 then
    begin
      with DM1.EQuery1 do
      begin
        Close;
        SQL.Clear;
        SQL.Add('select USERID, NAME_KOR from HITEMS.HITEMS_USER ');
        SQL.Add('where NAME_KOR = :param1 and DEPT_CD = :param2');
        Parambyname('param1').AsString := LNode.Text;
        case DeptSection.ItemIndex of
          0 : Parambyname('param2').AsString := 'K2B';
          1 : Parambyname('param2').AsString := 'K2D';
          2 : Parambyname('param2').AsString := 'K24';
        end;

        Open;

        if not(RecordCount > 1) then
        begin
          ApprovalLine.Cells[2,ApprovalLine.RowCount-1] := LNode.Text; //이름등록
          ApprovalLine.Cells[3,ApprovalLine.RowCount-1] := FieldByName('USERID').AsString;
        end
        else
        begin
          //동명이인이 발생하였을 경우...
        end;
      end;//with ZQ
    end;



    for li := 0 to ApprovalLine.RowCount-1 do
    begin
      if li = 0 then
        ApprovalLine.Cells[1,li] := '승인'
      else
        ApprovalLine.Cells[1,li] := '검토';

    end;//for
  end;//if
  ApprovalLine.Refresh;
end;

procedure TApprovaln_Frm.Button1Click(Sender: TObject);
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

          for le := 0 to ApprovalLine.Rowcount-1 do
          begin
            if Cells[3,li] = ApprovalLine.Cells[4,le] then
            begin
              LBoolean := False;
              break;
            end;
          end;

          if (LBoolean) then
          begin
            if ApprovalLine.RowCount = 4 then
            begin
              ShowMessage('결재선은 작성자 포함 5명까지 가능 합니다.');
              exit;
            end;

            ApprovalLine.AddRow(1);
            ApprovalLine.Cells[2,ApprovalLine.Rowcount-1] := Cells[1,li];
            ApprovalLine.Cells[3,ApprovalLine.Rowcount-1] := Cells[2,li];
            ApprovalLine.Cells[4,ApprovalLine.Rowcount-1] := Cells[3,li];

            if ApprovalLine.RowCount = 5 then
              Exit;
          end;
        end;
      end;
    end;
  finally
    for li := 0 to NextGrid1.RowCount-1 do
      NextGrid1.cell[0,li].AsBoolean := False;

    for li := 0 to ApprovalLine.RowCount-1 do
      if not(li = 0) then
        ApprovalLine.Cells[1,li] := '검토'
      else
        ApprovalLine.Cells[1,li] := '승인';
  end;
end;

procedure TApprovaln_Frm.Button2Click(Sender: TObject);
var
  li : integer;
begin
  try
    ApprovalLine.DeleteRow(ApprovalLine.SelectedRow);
  finally
    for li := 0 to ApprovalLine.RowCount-1 do
      if not(li = 0) then
        ApprovalLine.Cells[1,li] := '검토'
      else
        ApprovalLine.Cells[1,li] := '승인';
  end;
end;

procedure TApprovaln_Frm.Button3Click(Sender: TObject);
begin
  ApprovalLine.ClearRows;
end;

procedure TApprovaln_Frm.Button4Click(Sender: TObject);
var
  li : integer;
begin
  try
    with ApprovalLine do
    begin
      if not(SelectedRow = RowCount-1) then
      begin
        ApprovalLine.MoveRow(SelectedRow,SelectedRow+1);
        ApprovalLine.SelectedRow := SelectedRow+1;
      end;
    end;
  finally
    for li := 0 to ApprovalLine.RowCount-1 do
      if not(li = 0) then
        ApprovalLine.Cells[1,li] := '검토'
      else
        ApprovalLine.Cells[1,li] := '승인';
  end;
end;

procedure TApprovaln_Frm.Button5Click(Sender: TObject);
var
  li : integer;
begin
  try
    with ApprovalLine do
    begin
      if not(SelectedRow = 0) then
      begin
        ApprovalLine.MoveRow(SelectedRow,SelectedRow-1);
        ApprovalLine.SelectedRow := SelectedRow-1;
      end;
    end;
  finally
    for li := 0 to ApprovalLine.RowCount-1 do
      if not(li = 0) then
        ApprovalLine.Cells[1,li] := '검토'
      else
        ApprovalLine.Cells[1,li] := '승인';

  end;
end;

procedure TApprovaln_Frm.Button6Click(Sender: TObject);
begin
  Close;
end;

procedure TApprovaln_Frm.Button7Click(Sender: TObject);
begin
  try
    if not(ApprovalLine.RowCount = 0) then
      Approval_line_Apply_2_AppGrid;
  finally
    Close;
  end;
end;

function TApprovaln_Frm.Check_for_CodeNm_base_on_Code(Fcode: String): String;
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

function TApprovaln_Frm.Check_for_Code_base_on_CodeNm(FcodeNm: String): String;
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

function TApprovaln_Frm.Check_for_DeptCode_base_on_DeptNm(
  FcodeNm: String): String;
begin
  with DM1.TQuery2 do
  begin
    Close;
    SQL.Clear;
    SQL.Add('select DEPT_CD from HITEMS.HITEMS_DEPT where DEPT_NAME = :param1');
    parambyname('param1').AsString := FcodeNm;
    Open;

    Result := Fieldbyname('DEPT_CD').AsString;
  end;
end;

procedure TApprovaln_Frm.Search_for_User_based_on_TeamCode(Fcode: String);
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

procedure TApprovaln_Frm.ApprovalLineChange(Sender: TObject; ACol, ARow: Integer);
var
  li : integer;
begin
  ApprovalLine.SetFocus;
  ApprovalLine.reFresh;
end;

procedure TApprovaln_Frm.Approval_line_Apply_2_AppGrid;
var
  li, lc : integer;
  LAppCount : integer;
begin
  FOwner.FAppCount := ApprovalLine.RowCount+1;
  FOwner.Approval_Grid_Setting(ApprovalLine.RowCount+1);

  LAppCount := ApprovalLine.RowCount-1;

  // 배열값 초기화
  for li := 0 to 4 do
    FOwner.FAprovalArr[Li] := '';

  // 배열에 결재선 정보(사번) 입력
  lc := 0;
  for li := ApprovalLine.RowCount-1 Downto 0 do
  begin
    Inc(LC);
    FOwner.FAprovalArr[LC] := ApprovalLine.Cells[4,li];
  end;
  // 담당자 정보(사번) 입력
  FOwner.FAprovalArr[0] := FOwner.Statusbar1.Panels[4].Text;

  // 메인메뉴 결재란 세팅!!
  with FOwner.AppGrid do
  begin
    for li := 2 to ColCount -1 do
      Cells[li,0] := ApprovalLine.Cells[1,LAppCount];

    lc := 1;
    FOwner.AppGrid.Cells[lc,0] := CurrentUserPosition + '/' + CurrentUserName;

    for li := ApprovalLine.RowCount - 1 downto 0 do
    begin
      FOwner.AppGrid.Cells[1+lc,0] := ApprovalLine.Cells[3,li] + '/' + ApprovalLine.Cells[2,li];
      Inc(lc);
    end;

//    for li := 0 to 4 do
//    begin
//      if not(FOwner.FAprovalArr[li] = '') then
//      begin
//        with DM1.TQuery1 do
//        begin
//          Close;
//          SQL.Clear;
//          SQL.Add('Select A.NAME_KOR, A.GRADE, B.DESCR From HITEMS.HITEMS_USER A, HITEMS.HITEMS_USER_GRADE B ');
//          SQL.Add('WHERE USERID = :param1 and A.GRADE = B.GRADE ');
//          parambyname('param1').AsString := FOwner.FAprovalArr[li];
//          Open;
//          FOwner.AppGrid.Cells[1+li,0] := Fieldbyname('DESCR').AsString+'/'+
//                                              Fieldbyname('Name_Kor').AsString;
//        end;
//      end;
//    end;
  end;
  FOwner.Panel1.Invalidate;
  Close;
end;



end.
