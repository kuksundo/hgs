unit getUserInfo_Unit;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, NxColumnClasses, NxColumns,
  NxScrollControl, NxCustomGridControl, NxCustomGrid, NxGrid, Vcl.StdCtrls,
  Vcl.Mask, JvExMask, JvToolEdit, AeroButtons, JvExControls, JvLabel,
  Vcl.ImgList, Vcl.Imaging.jpeg, Vcl.ExtCtrls, Ora, JvExStdCtrls, JvCombobox,
  pjhComboBox, Vcl.Menus;

type
  TgetUserInfo_Frm = class(TForm)
    Panel8: TPanel;
    Image1: TImage;
    ImageList32x32: TImageList;
    ImageList1: TImageList;
    JvLabel20: TJvLabel;
    JvLabel22: TJvLabel;
    AeroButton3: TAeroButton;
    AeroButton4: TAeroButton;
    JvFilenameEdit1: TJvFilenameEdit;
    grid_User: TNextGrid;
    NxIncrementColumn2: TNxIncrementColumn;
    NxTextColumn25: TNxTextColumn;
    NxTextColumn26: TNxTextColumn;
    EMPNO: TNxTextColumn;
    GRDNM: TNxTextColumn;
    NxTextColumn29: TNxTextColumn;
    NxTextColumn30: TNxTextColumn;
    NxTextColumn31: TNxTextColumn;
    NxTextColumn1: TNxTextColumn;
    NxTextColumn2: TNxTextColumn;
    JvLabel11: TJvLabel;
    JvLabel1: TJvLabel;
    cb_dept: TComboBoxInc;
    cb_deptcode: TComboBoxInc;
    JvLabel2: TJvLabel;
    cb_teamname: TComboBoxInc;
    PopupMenu1: TPopupMenu;
    GUNMUO1: TMenuItem;
    AeroButton1: TAeroButton;
    N1: TMenuItem;
    HiTEMSUSER1: TMenuItem;
    NxTextColumn3: TNxTextColumn;
    AddHitemsUser: TMenuItem;
    procedure JvFilenameEdit1Change(Sender: TObject);
    procedure AeroButton4Click(Sender: TObject);
    procedure AeroButton3Click(Sender: TObject);
    procedure cb_deptDropDown(Sender: TObject);
    procedure cb_deptcodeDropDown(Sender: TObject);
    procedure cb_deptSelect(Sender: TObject);

    procedure FillInDeptCombo;
    procedure cb_deptcodeSelect(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure GUNMUO1Click(Sender: TObject);
    procedure AeroButton1Click(Sender: TObject);
    procedure HiTEMSUSER1Click(Sender: TObject);
    procedure AddHitemsUserClick(Sender: TObject);
//    procedure cb_deptChange(Sender: TObject);
//    procedure cb_deptKeyPress(Sender: TObject; var Key: Char);
  private
    FPartList,
    FPartCodeList: TStringList;
  public
    { Public declarations }
    function Get_UserItems(const aVal, aItem :String):String;
    function Get_GradeCode(aDescr:String):String;
    function Get_DeptCode(aDeptName:String):String;
    function Get_DeptCode2(aDeptName, aPosition, aCode:String):String;
    function Get_DeptName(ADeptName:string): string;
    function Get_Gunmucode(AGunmu: string): string;

    procedure Get_UserDataFromInsaDB;
    procedure Set_ColumnName2Grid;
    procedure Set_UserData2Grid(AQry: TOraQuery);
    procedure Get_PartList;

    procedure Process_HiTEMS_User;
    procedure Process_HiTEMS_Dept;
    procedure InsertOrUpdate2HiTEMS_User(Ai: integer; ACode: string; var AUpdateCnt, AInsertCnt: integer);
    procedure Add_Execute_2_HiTEMS_User;
  end;

var
  getUserInfo_Frm: TgetUserInfo_Frm;

implementation
uses
  DataModule_Unit;

{$R *.dfm}

procedure TgetUserInfo_Frm.AddHitemsUserClick(Sender: TObject);
var
  LCode: string;
  LUpdate, LInsert: integer;
begin
  LCode := Copy(cb_deptcode.Text, 1, 3);
  InsertOrUpdate2HiTEMS_User(grid_user.SelectedRow, LCode, LUpdate, LInsert);
end;

procedure TgetUserInfo_Frm.Add_Execute_2_HiTEMS_User;
begin

end;

procedure TgetUserInfo_Frm.AeroButton1Click(Sender: TObject);
begin
  Get_UserDataFromInsaDB;
end;

procedure TgetUserInfo_Frm.AeroButton3Click(Sender: TObject);
begin
  Close;
end;

procedure TgetUserInfo_Frm.AeroButton4Click(Sender: TObject);
begin
  if grid_User.RowCount = 0 then
  begin
    ShowMessage('부서 선택 후 조회 버튼을 먼저 누르시오!');
    exit;
  end;

  Process_HiTEMS_User;
  Process_HiTEMS_Dept;
end;

//procedure TgetUserInfo_Frm.cb_deptChange(Sender: TObject);
//var
//  TmpText : string;
//  i : integer;
//begin
//  with TComboBox(Sender) do
//  begin
//    TmpText := Text; // save the text that was typed by the user
//
//    for i := 0 to Items.Count - 1 do
//    begin
//      if Pos(Text, Items[i]) = 1 then
//      begin
//        ItemIndex := i;
//        SelStart := Length(TmpText);
//        SelLength := Length(Items[i]) - Length(TmpText);
//        Break;
//      end;
//    end;
//  end;
//end;

procedure TgetUserInfo_Frm.cb_deptcodeDropDown(Sender: TObject);
begin
  FillInDeptCombo;
end;

procedure TgetUserInfo_Frm.cb_deptcodeSelect(Sender: TObject);
begin
  if cb_deptcode.Text <> '' then
  begin
    cb_dept.ItemIndex := cb_deptcode.ItemIndex;
    Get_PartList;
    cb_teamname.Items.Assign(FPartList);
  end;
end;

procedure TgetUserInfo_Frm.cb_deptDropDown(Sender: TObject);
begin
  FillInDeptCombo;
end;

//procedure TgetUserInfo_Frm.cb_deptKeyPress(Sender: TObject; var Key: Char);
//begin
//  if Key = #8 then
//  begin
//    with TComboBox(Sender) do
//    begin
//      Text := Copy(Text, 1, Length(Text) - SelLength - 1);
//    end;
//
//    cb_deptChange(Sender);
//    Key := #0;
//  end;
//end;

procedure TgetUserInfo_Frm.cb_deptSelect(Sender: TObject);
begin
  if cb_dept.Text <> '' then
  begin
    cb_deptcode.ItemIndex := cb_dept.ItemIndex;

    if cb_deptcode.Text <> '' then
    begin
      Get_PartList;
      cb_teamname.Items.Assign(FPartList);
    end;
  end;
end;

procedure TgetUserInfo_Frm.FillInDeptCombo;
begin
  with DM1.OraQuery2 do
  begin
    Close;
    SQL.Clear;
    SQL.Add('select DEPT, DEPTNM from kx01.gtaa004 ' +
            'where DEPTNM IS NOT NULL AND DEPT like ''K%'' ' +
            'GROUP BY DEPT, DEPTNM ');
    Open;

    if RecordCount > 0 then
    begin
      cb_dept.Items.BeginUpdate;
      cb_deptcode.Items.BeginUpdate;
      try
        cb_dept.Items.Clear;
        cb_deptcode.Items.Clear;

        cb_dept.Items.Add('');
        cb_deptcode.Items.Add('');
        cb_dept.Items.Add('임원');
        cb_deptcode.Items.Add('A');

        while not eof do
        begin
          cb_dept.Items.Add(FieldByName('DEPTNM').AsString);
          cb_deptcode.Items.Add(FieldByName('DEPT').AsString);
          Next;
        end;
      finally
        cb_dept.Items.EndUpdate;
        cb_deptcode.Items.EndUpdate;
      end;
    end;
  end;

end;

procedure TgetUserInfo_Frm.FormCreate(Sender: TObject);
begin
  FPartList := TStringList.Create;
  FPartCodeList := TStringList.Create;
end;

procedure TgetUserInfo_Frm.FormDestroy(Sender: TObject);
begin
  FPartList.Free;
  FPartCodeList.Free;
end;

function TgetUserInfo_Frm.Get_DeptCode(aDeptName: String): String;
var
  OraQuery : TOraQuery;
begin
  OraQuery := TOraQuery.Create(nil);
  try
    with OraQuery do
    begin
      Close;
      SQL.Clear;
      SQL.Add('SELECT DEPT_CD FROM HITEMS_DEPT ' +
              'WHERE DEPT_NAME LIKE :param1 ');
      ParamByName('param1').AsString := aDeptName;
      Open;

      Result := FieldByName('DEPT_CD').AsString;

    end;
  finally
    FreeAndNil(OraQuery);
  end;
end;

function TgetUserInfo_Frm.Get_DeptCode2(aDeptName, aPosition, aCode: String): String;
var
  i: integer;
begin
  Result := '';

  if (aDeptName = '') and (aPosition = '부서장') then
  begin
    Result := aCode + '0';
    exit;
  end;

  i := FPartList.IndexOf(aDeptName);

  if i > 0 then
  begin
    if FPartCodeList.Strings[i] <> '-1' then
      Result := aCode + FPartCodeList.Strings[i];
  end;
end;

function TgetUserInfo_Frm.Get_DeptName(ADeptName: string): string;
var
  LStr: string;
begin
  LStr := ADeptName;

  if Copy(LStr, Length(LStr), 1) = '부' then
    Result := LStr + '서장'
  else
    Result := LStr + '장';
end;

function TgetUserInfo_Frm.Get_GradeCode(aDescr: String): String;
var
  OraQuery : TOraQuery;
begin
  if aDescr = '부장대우' then
    aDescr := '부대'
  else
  if aDescr = '4급기사' then
    aDescr := '4기'
  else
  if aDescr = '5급기사' then
    aDescr := '5기'
  else
  if aDescr = '6급기사' then
    aDescr := '6기'
  else
  if aDescr = '7급기사' then
    aDescr := '7기';


  OraQuery := TOraQuery.Create(nil);
  try
    with OraQuery do
    begin
      Close;
      SQL.Clear;
      SQL.Add('SELECT GRADE FROM HITEMS_USER_GRADE ' +
              'WHERE DESCR LIKE :param1 ');
      ParamByName('param1').AsString := aDescr;
      Open;

      Result := FieldByName('GRADE').AsString;

    end;
  finally
    FreeAndNil(OraQuery);
  end;
end;

function TgetUserInfo_Frm.Get_Gunmucode(AGunmu: string): string;
begin
  if (AGunmu = '재직') or (AGunmu = '휴직') then
    Result := 'I'
  else
  if AGunmu = '퇴직' then
    Result := 'O';
end;

procedure TgetUserInfo_Frm.Get_PartList;
var
  i,j: integer;
begin
  with DM1.OraQuery2 do
  begin
    Close;
    SQL.Clear;
    if cb_deptcode.Text = 'A' then
      SQL.Add('select RESNM from kx01.gtaa004 ' +
              'where DEPT like :param1 ' +
              'GROUP BY RESNM ')
    else
      SQL.Add('select PARTNM from kx01.gtaa004 ' +
              'where DEPTNM IS NOT NULL AND DEPT = :param1 ' +
              'GROUP BY PARTNM ');

    if cb_deptcode.Text <> '' then
    begin
      ParamByName('param1').AsString := cb_deptcode.Text;

      if cb_deptcode.Text = 'A' then
        ParamByName('param1').AsString := cb_deptcode.Text + 'K%';
    end
    else
      SQL.Text := StringReplace(SQL.Text,'AND DEPT = :param1','',[rfReplaceAll]);

    Open;

    if RecordCount > 0 then
    begin
      FPartList.Clear;
      FPartCodeList.Clear;

      while not eof do
      begin
        if cb_deptcode.Text = 'A' then
        begin
          if FieldByName('RESNM').AsString <> '' then
            FPartList.Add(FieldByName('RESNM').AsString)
        end
        else
        if FieldByName('PARTNM').AsString <> cb_dept.Text then
          FPartList.Add(FieldByName('PARTNM').AsString);
        Next;
      end;

      FPartList.Sort;

      j := 1;
      for i := 0 to FPartList.Count - 1 do
      begin
        if FPartList.Strings[i] <> '' then
        begin
          FPartCodeList.Add(IntToStr(j));
          Inc(j);
        end
        else
          FPartCodeList.Add(IntToStr(-1));

      end;
    end;
  end;
end;

procedure TgetUserInfo_Frm.Get_UserDataFromInsaDB;
begin
  try
    with DM1.OraQuery2 do
    begin
      Close;
      SQL.Clear;
      if cb_deptcode.Text = 'A' then
        SQL.Add('SELECT * FROM kx01.gtaa004 ' +
              'WHERE DEPT LIKE :param1 AND STATNM = ''재직''' //''K%''  AND EMPNO = ''A379042''
        )
      else
        SQL.Add('select * from kx01.gtaa004 ' +
              'where DEPTNM IS NOT NULL AND DEPT = :param1' //''K%''  AND EMPNO = ''A379042''
        );

      if cb_deptcode.Text <> '' then
      begin
        ParamByName('param1').AsString := cb_deptcode.Text;

        if cb_deptcode.Text = 'A' then
          ParamByName('param1').AsString := cb_deptcode.Text + 'K%';
      end
      else
        SQL.Text := StringReplace(SQL.Text,'AND DEPT = :param1','',[rfReplaceAll]);

      Open;

      if RecordCount > 0 then
      begin
        Set_ColumnName2Grid;
        Set_UserData2Grid(DM1.OraQuery2);
      end;//if

    end;
  finally

  end;
end;

function TgetUserInfo_Frm.Get_UserItems(const aVal, aItem: String): String;
var
  c, d : Integer;
  LStr1 : String;
begin
  c := POS('<'+aItem+'>',aVal)+(Length(aItem)+2);
  d := POS('</'+aItem+'>',aVal);
  d := d - c;

  LStr1 := Copy(aVal,c,d);

  c := POS('<![CDATA[',LStr1)+9;
  d := POS(']]>',LStr1);
  d := d - c;

  Result := Copy(LStr1,c,d);

end;

//부서별 HITEMS_USER 테이블 갱신할 때  해당 부서원들을 먼저 GUNMU를 'O'로 설정 해야 함.
procedure TgetUserInfo_Frm.GUNMUO1Click(Sender: TObject);
begin
  if cb_deptcode.Text <> '' then
  begin
    with DM1.OraQuery1 do
    begin
      Close;
      SQL.Clear;
      SQL.Add('UPDATE HITEMS_USER SET ' +
              'GUNMU = ''O'' ' +
              'WHERE DEPT_CD = :param1 ');
      ParamByName('param1').AsString := cb_deptcode.Text;

      ExecSQL;
    end;
  end;
end;

procedure TgetUserInfo_Frm.HiTEMSUSER1Click(Sender: TObject);
var
  LCode: string;
  LUpdate, LInsert: integer;
begin
  LCode := Copy(cb_deptcode.Text, 1, 3);
  InsertOrUpdate2HiTEMS_User(grid_user.SelectedRow, LCode, LUpdate, LInsert);
end;

procedure TgetUserInfo_Frm.InsertOrUpdate2HiTEMS_User(Ai: integer; ACode: string; var AUpdateCnt, AInsertCnt: integer);
begin
  with grid_User do
  begin
    Self.Caption := '처리 ( '+IntToStr(RowCount)+'/'+IntToStr(Ai+1)+' )';

    with DM1.OraQuery1 do
    begin
      Close;
      SQL.Clear;
      SQL.Add('SELECT USERID FROM HITEMS_USER ' +
              'WHERE USERID = :param1 ');
      ParamByName('param1').AsString := CellByName['EMPNO',Ai].AsString;
      Open;

      if RecordCount > 0 then
      begin
        Close;
        SQL.Clear;
        SQL.Add('UPDATE HITEMS_USER SET ' +
                'DEPT_CD = :DEPT_CD, GRADE = :GRADE, POSITION = :POSITION, ' +
                'GUNMU = :GUNMU ' +
                'WHERE USERID = :param1 ');
        ParamByName('param1').AsString  := CellByName['EMPNO',Ai].AsString;

        ParamByName('DEPT_CD').AsString := Get_DeptCode2(CellByName['PARTNM',Ai].AsString,CellByName['RESNM',Ai].AsString, ACode);
        ParamByName('GRADE').AsString   := Get_GradeCode(CellByName['GRDNM',Ai].AsString);
        ParamByName('POSITION').AsString:= CellByName['RESNM',Ai].AsString;
        ParamByName('GUNMU').AsString:= Get_Gunmucode(CellByName['STATNM',Ai].AsString);

        ExecSQL;
        Inc(AUpdateCnt);
      end else
      begin
        Close;
        SQL.Clear;
        SQL.Add('INSERT INTO HITEMS_USER ' +
                '( ' +
                '   USERID, PASSWD, DEPT_CD, NAME_KOR, GUNMU, GRADE, POSITION, EMAIL ' +
                ') VALUES ' +
                '( ' +
                '   :USERID, :PASSWD, :DEPT_CD, :NAME_KOR, :GUNMU, :GRADE, :POSITION, :EMAIL '+
                ') ');

        ParamByName('USERID').AsString     := CellByName['EMPNO',Ai].AsString;
        ParamByName('PASSWD').AsString     := CellByName['EMPNO',Ai].AsString;
        ParamByName('DEPT_CD').AsString    := Get_DeptCode2(CellByName['DEPTNM',Ai].AsString,CellByName['PARTNM',Ai].AsString, ACode);
        ParamByName('NAME_KOR').AsString   := CellByName['EMPNM',Ai].AsString;
        ParamByName('GUNMU').AsString      := Get_Gunmucode(CellByName['STATNM',Ai].AsString);
        ParamByName('GRADE').AsString      := Get_GradeCode(CellByName['GRDNM',Ai].AsString);
        ParamByName('POSITION').AsString   := CellByName['RESNM',Ai].AsString;
        ParamByName('EMAIL').AsString   := CellByName['RESNM',Ai].AsString;

        ExecSQL;
        Inc(AInsertCnt);
      end;
    end;
  end;
end;

procedure TgetUserInfo_Frm.JvFilenameEdit1Change(Sender: TObject);
var
  LValueList,
  LStrList: TStringList;
  lnameK, lnameE, ldept,lDepartment,
  LStr, LStr1,Lstr2: string;
  idx, li,
  i,j,v,c,d,lrow,lcol : integer;

begin
  LStrList := TStringList.Create;
  try
    if JvFilenameEdit1.FileName <> '' then
    begin
      with grid_User do
      begin
        BeginUpdate;
        try
          ClearRows;
          with LStrList do
          begin
            LStrList.LoadFromFile(JvFilenameEdit1.FileName);

            LValueList := TStringList.Create;
            try
              i := 0;

              while i < LStrList.Count do
              begin
                LStr := LStrList.Strings[i];

                LValueList.Clear;

                v := POS('id=chkText',LStr);
                if v > 0 then
                begin
                  lrow := AddRow;

                  //Name

                  LStr1 := Get_UserItems(LStr, 'DisplayName');
                  ExtractStrings(['/'],[],PChar(LStr1),LValueList);

                  lnameK := LValueList.Strings[0];//name
                  idx := Pos('(',lnameK);
                  lnameK := Copy(lnameK,1,idx-1);

                  lnameE := LValueList.Strings[0];
                  lnameE := Copy(lnameE,idx+1,length(lnameE)-(idx+1));

                  lDepartment := LValueList.Strings[2];



                  Cells[1,lrow] := Get_UserItems(LStr, 'EmpID');
                  Cells[2,lrow] := lnameK;
                  Cells[3,lrow] := lnameE;
                  Cells[4,lrow] := Get_UserItems(LStr, 'RankName');
                  Cells[5,lrow] := Get_UserItems(LStr, 'CellPhone');
                  Cells[6,lrow] := Get_UserItems(LStr, 'OFFICETEL');
                  Cells[7,lrow] := lDepartment;
                  Cells[8,lrow] := Get_GradeCode(Cells[4,lrow]);//직급
                  Cells[9,lrow] := Get_DeptCode(Cells[7,lrow]);//부서코드
                  Cells[10,lrow] := Get_UserItems(LStr, 'addr');
                end;
                Inc(i);
              end;
            finally
              FreeAndNil(LValueList);
            end;
          end;
        finally
          EndUpdate;
        end;
      end;
    end
    else
    begin
      ShowMessage('Choose File Name first!');
      exit;
    end;
  finally
    FreeAndNil(LStrList);

  end;
end;

procedure TgetUserInfo_Frm.Process_HiTEMS_Dept;
var
  LCode: string;
  i,j: integer;
begin
  LCode := Copy(cb_deptcode.Text,1,3);

  DM1.OraTransaction1.StartTransaction;
  try
    with DM1.OraQuery1 do
    begin
      Close;
      SQL.Clear;
      SQL.Add('DELETE FROM HITEMS_DEPT ' +
              'WHERE DEPT_CD like :param1 ');
      ParamByName('param1').AsString := LCode+'%';

      ExecSQL;

      Close;
      SQL.Clear;
      SQL.Add('INSERT INTO HITEMS_DEPT ' +
              '(DEPT_CD, DEPT_NAME, DEPT_LV) ' +
              'VALUES(:DEPT_CD, :DEPT_NAME, : DEPT_LV) ');
      ParamByName('DEPT_CD').AsString  := LCode;
      ParamByName('DEPT_NAME').AsString  := cb_dept.Text;
      ParamByName('DEPT_LV').AsInteger  := 1;

      ExecSQL;

      Close;
      SQL.Clear;
      SQL.Add('INSERT INTO HITEMS_DEPT ' +
              '(PARENT_CD, DEPT_CD, DEPT_NAME, DEPT_LV) ' +
              'VALUES(:PARENT_CD, :DEPT_CD, :DEPT_NAME, : DEPT_LV) ');
      ParamByName('PARENT_CD').AsString  := LCode;
      ParamByName('DEPT_CD').AsString  := LCode + '0';
      ParamByName('DEPT_NAME').AsString  := Get_DeptName(cb_dept.Text);
      ParamByName('DEPT_LV').AsInteger  := 2;

      ExecSQL;

      j := 1;
      for i := 0 to FPartList.Count - 1 do
      begin
        if FPartList.Strings[i] <> '' then
        begin
          Close;
          SQL.Clear;
          SQL.Add('INSERT INTO HITEMS_DEPT ' +
                  '(PARENT_CD, DEPT_CD, DEPT_NAME, DEPT_LV) ' +
                  'VALUES(:PARENT_CD, :DEPT_CD, :DEPT_NAME, : DEPT_LV) ');
          ParamByName('PARENT_CD').AsString  := LCode;
          ParamByName('DEPT_CD').AsString  := LCode + IntToStr(j);
          ParamByName('DEPT_NAME').AsString  := FpartList.Strings[i];
          ParamByName('DEPT_LV').AsInteger  := 2;

          ExecSQL;

          inc(j);
        end;
      end;
    end;

    DM1.OraTransaction1.Commit;
  except
    DM1.OraTransaction1.Rollback;
  end;
end;

procedure TgetUserInfo_Frm.Process_HiTEMS_User;
var
  i, LUpdateCnt, LInsertCnt : Integer;
  LCode: string;
begin
  LCode := Copy(cb_deptcode.Text, 1, 3);
//    BeginUpdate;
    try
      LUpdateCnt := 0;
      LInsertCnt := 0;
      DM1.OraTransaction1.StartTransaction;
      try
        for i := 0 to grid_User.RowCount-1 do
        begin
          InsertOrUpdate2HiTEMS_User(i, LCode, LUpdateCnt, LInsertCnt);
        end;

        DM1.OraTransaction1.Commit;
      except
        DM1.OraTransaction1.Rollback;
      end;
    finally
      Self.Caption := 'HiTEMS_USER: Update = ' + IntToStr(LUpdateCnt) + ' , Insert = ' + IntToStr(LInsertCnt);
//      EndUpdate;
    end;
end;

procedure TgetUserInfo_Frm.Set_ColumnName2Grid;
var
  OraQuery : TOraQuery;
  LnxTextColumn: TnxTextColumn;
begin
  if DM1.OraSession2.Connected then
  begin
    OraQuery := TOraQuery.Create(nil);
    OraQuery.Session := DM1.OraSession2;

    try
      with OraQuery do
      begin
        Close;
        SQL.Clear;
        SQL.Add('select column_name, Data_Type, column_id from all_tab_columns ' +
                'where owner = ''kx01'' AND table_name = ''kx01.gtaa004'' ' + //owner = ''TBACS'' AND
                'order by column_id');
        Open;

        if RecordCount > 0 then
        begin
          ShowMessage('aaa');
        end
        else
        begin
          with grid_User do
          begin
            BeginUpdate;
            try
              ClearRows;
              Columns.Clear;

              LnxTextColumn := TnxTextColumn(Columns.Add(TnxTextColumn,'GUBUN'));
              LnxTextColumn.Name := 'GUBUN';
              LnxTextColumn.Options := [coCanClick,coDisableMoving,coEditorAutoSelect,coPublicUsing,coShowTextFitHint];//coCanInput,coEditing,

              LnxTextColumn := TnxTextColumn(Columns.Add(TnxTextColumn,'EMPNO'));
              LnxTextColumn.Name := 'EMPNO';
              LnxTextColumn.Options := [coCanClick,coDisableMoving,coEditorAutoSelect,coPublicUsing,coShowTextFitHint, coCanSort];

              LnxTextColumn := TnxTextColumn(Columns.Add(TnxTextColumn,'EMPNM'));
              LnxTextColumn.Name := 'EMPNM';
              LnxTextColumn.Options := [coCanClick,coDisableMoving,coEditorAutoSelect,coPublicUsing,coShowTextFitHint, coCanSort];

              LnxTextColumn := TnxTextColumn(Columns.Add(TnxTextColumn,'DEPT'));
              LnxTextColumn.Name := 'DEPT';
              LnxTextColumn.Options := [coCanClick,coDisableMoving,coEditorAutoSelect,coPublicUsing,coShowTextFitHint, coCanSort];

              LnxTextColumn := TnxTextColumn(Columns.Add(TnxTextColumn,'DEPTNM'));
              LnxTextColumn.Name := 'DEPTNM';
              LnxTextColumn.Options := [coCanClick,coDisableMoving,coEditorAutoSelect,coPublicUsing,coShowTextFitHint, coCanSort];

              LnxTextColumn := TnxTextColumn(Columns.Add(TnxTextColumn,'PARTCD'));
              LnxTextColumn.Name := 'PARTCD';
              LnxTextColumn.Options := [coCanClick,coDisableMoving,coEditorAutoSelect,coPublicUsing,coShowTextFitHint, coCanSort];

              LnxTextColumn := TnxTextColumn(Columns.Add(TnxTextColumn,'PARTNM'));
              LnxTextColumn.Name := 'PARTNM';
              LnxTextColumn.Options := [coCanClick,coDisableMoving,coEditorAutoSelect,coPublicUsing,coShowTextFitHint, coCanSort];

              LnxTextColumn := TnxTextColumn(Columns.Add(TnxTextColumn,'RESCD'));
              LnxTextColumn.Name := 'RESCD';
              LnxTextColumn.Options := [coCanClick,coDisableMoving,coEditorAutoSelect,coPublicUsing,coShowTextFitHint, coCanSort];

              LnxTextColumn := TnxTextColumn(Columns.Add(TnxTextColumn,'RESNM'));
              LnxTextColumn.Name := 'RESNM';
              LnxTextColumn.Options := [coCanClick,coDisableMoving,coEditorAutoSelect,coPublicUsing,coShowTextFitHint, coCanSort];

              LnxTextColumn := TnxTextColumn(Columns.Add(TnxTextColumn,'GRDCD'));
              LnxTextColumn.Name := 'GRDCD';
              LnxTextColumn.Options := [coCanClick,coDisableMoving,coEditorAutoSelect,coPublicUsing,coShowTextFitHint, coCanSort];

              LnxTextColumn := TnxTextColumn(Columns.Add(TnxTextColumn,'GRDNM'));
              LnxTextColumn.Name := 'GRDNM';
              LnxTextColumn.Options := [coCanClick,coDisableMoving,coEditorAutoSelect,coPublicUsing,coShowTextFitHint, coCanSort];

              LnxTextColumn := TnxTextColumn(Columns.Add(TnxTextColumn,'WRKCD'));
              LnxTextColumn.Name := 'WRKCD';
              LnxTextColumn.Options := [coCanClick,coDisableMoving,coEditorAutoSelect,coPublicUsing,coShowTextFitHint, coCanSort];

              LnxTextColumn := TnxTextColumn(Columns.Add(TnxTextColumn,'WRKNM'));
              LnxTextColumn.Name := 'WRKNM';
              LnxTextColumn.Options := [coCanClick,coDisableMoving,coEditorAutoSelect,coPublicUsing,coShowTextFitHint, coCanSort];

              LnxTextColumn := TnxTextColumn(Columns.Add(TnxTextColumn,'TELNO'));
              LnxTextColumn.Name := 'TELNO';
              LnxTextColumn.Options := [coCanClick,coDisableMoving,coEditorAutoSelect,coPublicUsing,coShowTextFitHint, coCanSort];

              LnxTextColumn := TnxTextColumn(Columns.Add(TnxTextColumn,'HPNO'));
              LnxTextColumn.Name := 'HPNO';
              LnxTextColumn.Options := [coCanClick,coDisableMoving,coEditorAutoSelect,coPublicUsing,coShowTextFitHint, coCanSort];

              LnxTextColumn := TnxTextColumn(Columns.Add(TnxTextColumn,'IPADDR'));
              LnxTextColumn.Name := 'IPADDR';
              LnxTextColumn.Options := [coCanClick,coDisableMoving,coEditorAutoSelect,coPublicUsing,coShowTextFitHint, coCanSort];

              LnxTextColumn := TnxTextColumn(Columns.Add(TnxTextColumn,'PCMCNO'));
              LnxTextColumn.Name := 'PCMCNO';
              LnxTextColumn.Options := [coCanClick,coDisableMoving,coEditorAutoSelect,coPublicUsing,coShowTextFitHint, coCanSort];

              LnxTextColumn := TnxTextColumn(Columns.Add(TnxTextColumn,'DIVISION'));
              LnxTextColumn.Name := 'DIVISION';
              LnxTextColumn.Options := [coCanClick,coDisableMoving,coEditorAutoSelect,coPublicUsing,coShowTextFitHint, coCanSort];

              LnxTextColumn := TnxTextColumn(Columns.Add(TnxTextColumn,'STATCD'));
              LnxTextColumn.Name := 'STATCD';
              LnxTextColumn.Options := [coCanClick,coDisableMoving,coEditorAutoSelect,coPublicUsing,coShowTextFitHint, coCanSort];

              LnxTextColumn := TnxTextColumn(Columns.Add(TnxTextColumn,'STATNM'));
              LnxTextColumn.Name := 'STATNM';
              LnxTextColumn.Options := [coCanClick,coDisableMoving,coEditorAutoSelect,coPublicUsing,coShowTextFitHint];

              LnxTextColumn := TnxTextColumn(Columns.Add(TnxTextColumn,'TSDATE'));
              LnxTextColumn.Name := 'TSDATE';
              LnxTextColumn.Options := [coCanClick,coDisableMoving,coEditorAutoSelect,coPublicUsing,coShowTextFitHint];

              LnxTextColumn := TnxTextColumn(Columns.Add(TnxTextColumn,'RUNDAY'));
              LnxTextColumn.Name := 'RUNDAY';
              LnxTextColumn.Options := [coCanClick,coDisableMoving,coEditorAutoSelect,coPublicUsing,coShowTextFitHint];

              LnxTextColumn := TnxTextColumn(Columns.Add(TnxTextColumn,'CREMPNO'));
              LnxTextColumn.Name := 'CREMPNO';
              LnxTextColumn.Options := [coCanClick,coDisableMoving,coEditorAutoSelect,coPublicUsing,coShowTextFitHint];

              LnxTextColumn := TnxTextColumn(Columns.Add(TnxTextColumn,'INDATE'));
              LnxTextColumn.Name := 'INDATE';
              LnxTextColumn.Options := [coCanClick,coDisableMoving,coEditorAutoSelect,coPublicUsing,coShowTextFitHint];

              LnxTextColumn := TnxTextColumn(Columns.Add(TnxTextColumn,'VALDATE'));
              LnxTextColumn.Name := 'VALDATE';
              LnxTextColumn.Options := [coCanClick,coDisableMoving,coEditorAutoSelect,coPublicUsing,coShowTextFitHint];
            finally
              EndUpdate;
            end;
          end;
        end;
      end;
    finally
      FreeAndNil(OraQuery);
    end;

  end;
end;

procedure TgetUserInfo_Frm.Set_UserData2Grid(AQry: TOraQuery);
var
  i: integer;
begin
  with AQry do
  begin
    with grid_User do
    begin
      BeginUpdate;
      try
        ClearRows;

        while not eof do
        begin
          i := AddRow;

          Cells[0,i] := FieldByName('GUBUN').AsString;
          Cells[1,i] := FieldByName('EMPNO').AsString;
          Cells[2,i] := FieldByName('EMPNM').AsString;
          Cells[3,i] := FieldByName('DEPT').AsString;
          Cells[4,i] := FieldByName('DEPTNM').AsString;
          Cells[5,i] := FieldByName('PARTCD').AsString;
          Cells[6,i] := FieldByName('PARTNM').AsString;
          Cells[7,i] := FieldByName('RESCD').AsString;
          Cells[8,i] := FieldByName('RESNM').AsString;
          Cells[9,i] := FieldByName('GRDCD').AsString;
          Cells[10,i] := FieldByName('GRDNM').AsString;
          Cells[11,i] := FieldByName('WRKCD').AsString;
          Cells[12,i] := FieldByName('WRKNM').AsString;
          Cells[13,i] := FieldByName('TELNO').AsString;
          Cells[14,i] := FieldByName('HPNO').AsString;
          Cells[15,i] := FieldByName('IPADDR').AsString;
          Cells[16,i] := FieldByName('PCMCNO').AsString;
          Cells[17,i] := FieldByName('DIVISION').AsString;
          Cells[18,i] := FieldByName('STATCD').AsString;
          Cells[19,i] := FieldByName('STATNM').AsString;
          Cells[20,i] := FieldByName('TSDATE').AsString;
          Cells[21,i] := FieldByName('RUNDAY').AsString;
          Cells[22,i] := FieldByName('CREMPNO').AsString;
          Cells[23,i] := FieldByName('INDATE').AsString;
          Cells[24,i] := FieldByName('VALDATE').AsString;
          Inc(i);
          Next;
        end;//while
      finally
        EndUpdate;
      end;
    end;
  end;//with
end;

end.
