unit dailyManPower_Unit;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, NxColumnClasses, NxColumns,
  NxScrollControl, NxCustomGridControl, NxCustomGrid, NxGrid, CurvyControls,
  Vcl.ExtCtrls, NxCollection, Vcl.StdCtrls, Vcl.ComCtrls, AdvPanel,
  Vcl.Imaging.jpeg, NxEdit, StrUtils, DateUtils;

type
  TdailyManPower_Frm = class(TForm)
    Panel5: TPanel;
    Image1: TImage;
    AdvPanel1: TAdvPanel;
    Label13: TLabel;
    days: TDateTimePicker;
    Panel6: TPanel;
    Button4: TButton;
    NxHeaderPanel1: TNxHeaderPanel;
    NxSplitter1: TNxSplitter;
    NxHeaderPanel2: TNxHeaderPanel;
    NxHeaderPanel3: TNxHeaderPanel;
    Panel1: TPanel;
    CurvyPanel1: TCurvyPanel;
    Label1: TLabel;
    CurvyPanel3: TCurvyPanel;
    Label3: TLabel;
    CurvyPanel4: TCurvyPanel;
    Label4: TLabel;
    CurvyPanel5: TCurvyPanel;
    Label5: TLabel;
    CurvyPanel6: TCurvyPanel;
    Label6: TLabel;
    CurvyPanel7: TCurvyPanel;
    Label7: TLabel;
    CurvyPanel8: TCurvyPanel;
    Label8: TLabel;
    CurvyPanel9: TCurvyPanel;
    Label9: TLabel;
    CurvyPanel10: TCurvyPanel;
    Label10: TLabel;
    CurvyPanel11: TCurvyPanel;
    Label11: TLabel;
    CurvyPanel12: TCurvyPanel;
    Label12: TLabel;
    empgrid: TNextGrid;
    NxIncrementColumn2: TNxIncrementColumn;
    NxTextColumn18: TNxCheckBoxColumn;
    NxTextColumn11: TNxTextColumn;
    NxTextColumn2: TNxTextColumn;
    NxTextColumn3: TNxTextColumn;
    NxTextColumn17: TNxTextColumn;
    NxTextColumn8: TNxTextColumn;
    nonGrid: TNextGrid;
    NxTextColumn6: TNxTextColumn;
    NxTextColumn12: TNxTextColumn;
    NxTextColumn5: TNxTextColumn;
    nxComboboxColumn1: TNxComboBoxColumn;
    NxTextColumn7: TNxTextColumn;
    NxDateColumn1: TNxDateColumn;
    NxDateColumn2: TNxDateColumn;
    NxTextColumn46: TNxTextColumn;
    Panel2: TPanel;
    Button3: TButton;
    btn_del: TButton;
    btn_add: TButton;
    teamCode: TNxEdit;
    CurvyEdit1: TCurvyEdit;
    CurvyEdit11: TCurvyEdit;
    CurvyEdit2: TCurvyEdit;
    CurvyEdit3: TCurvyEdit;
    CurvyEdit4: TCurvyEdit;
    CurvyEdit5: TCurvyEdit;
    CurvyEdit6: TCurvyEdit;
    CurvyEdit7: TCurvyEdit;
    CurvyEdit8: TCurvyEdit;
    CurvyEdit9: TCurvyEdit;
    CurvyPanel2: TCurvyPanel;
    Label2: TLabel;
    CurvyEdit10: TCurvyEdit;
    Label14: TLabel;
    teamName: TComboBox;
    procedure daysChange(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure teamNameSelect(Sender: TObject);
    procedure btn_delClick(Sender: TObject);
    procedure nonGridAfterEdit(Sender: TObject; ACol, ARow: Integer;
      Value: WideString);
    procedure btn_addClick(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure Button4Click(Sender: TObject);
    procedure teamNameDropDown(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    procedure Check_UserInfo;
    procedure Set_empGrid(aTeamNo:String);
    procedure Set_nonGrid(aTeamNo:String; aToday:TDateTime);
    procedure Set_Summary;
    function Return_geuntaeCount(aCode:String):Integer;

    procedure Insert_Into_HiTEMS_EMPLOYEE_REST(aRow:Integer);
  end;

var
  dailyManPower_Frm: TdailyManPower_Frm;

implementation
uses
  CommonUtil_Unit,
  HITEMS_TMS_COMMON,
  HITEMS_TMS_CONST,
  DataModule_Unit;

{$R *.dfm}

procedure TdailyManPower_Frm.Button3Click(Sender: TObject);
var
  li : integer;
  lDateTime : TDateTime;
  ldate : String;
begin
  DM1.OraTransaction1.StartTransaction;
  try
    with nonGrid do
    begin
      BeginUpdate;
      try
        with DM1.OraQuery1 do
        begin
          Close;
          SQL.Clear;
          SQL.Add('Delete From DPMS_USER_REST ' +
                  'where RESTFROM = :param1 ');
          ParamByName('param1').AsDate := days.Date;
          ExecSQL;
        end;

        for li := 0 to RowCount-1 do
        begin
          if Cells[4,li] = '' then
          begin
            ShowMessage('근태 내용을 입력해주세요!!!');
            Exit;
          end;

          if Cell[7,li].AsDateTime < Cell[6,li].AsDateTime then
          begin
            ShowMessage('종료일이 시작일보다 작습니다.');
            Exit;
          end;

          ldate := Cells[6,li];
          ldate := ldate + ' 00:00:00';
          Cell[6,li].AsDateTime := StrToDateTime(ldate);

          ldate := Cells[7,li];
          ldate := ldate + ' 23:59:59';
          Cell[7,li].AsDateTime := StrToDateTime(ldate);

          with DM1.OraQuery1 do
          begin
            Close;
            SQL.Clear;
            SQL.Add('select * from DPMS_USER_REST ' +
                    'where RESTNO = '+Cells[1,li]);
            Open;

            if RecordCount = 0 then
              Insert_Into_HiTEMS_EMPLOYEE_REST(li);
          end;
        end;
      finally
        EndUpdate;
      end;
      ShowMessage('성공!');
      DM1.OraTransaction1.Commit;
    end;
  except
    ShowMessage('실패!');
    DM1.OraTransaction1.Rollback;
  end;
end;

procedure TdailyManPower_Frm.Button4Click(Sender: TObject);
begin
  Close;
end;

procedure TdailyManPower_Frm.btn_delClick(Sender: TObject);
var
  lRow : Integer;
begin
  lRow := nonGrid.SelectedRow;
  with nonGrid do
  begin
    BeginUpdate;
    try
      if lRow > -1 then
      begin
        nonGrid.DeleteRow(lRow);
        Set_empGrid(teamCode.Text);
        Set_Summary;
      end;
    finally
      Invalidate;
      EndUpdate;
    end;
  end;
end;

procedure TdailyManPower_Frm.btn_addClick(Sender: TObject);
var
  li : integer;
  le : integer;
  ldate : String;
begin
  with nonGrid do
  begin
    BeginUpdate;
    try
      with empgrid do
      begin
        for li := 0 to RowCount-1 do
        begin
          if Cell[1,li].AsBoolean = True then
          begin
            with nonGrid do
            begin
              AddRow;
              Cells[0,RowCount-1] := IntToStr(Rowcount);
              Cells[1,RowCount-1] := FloatToStr(DateTimeToMilliseconds(Now));
              Cells[2,RowCount-1] := empGrid.Cells[2,li]; //사번
              Cells[3,RowCount-1] := empGrid.Cells[4,li]; //이름

              ldate := FormatDateTime('YYYY-MM-DD',days.Date);
              ldate := ldate +' 00:00:00';
              Cell[6,RowCount-1].AsDateTime := StrToDateTime(ldate);

              ldate := FormatDateTime('YYYY-MM-DD',days.Date);
              ldate := ldate +' 23:59:59';
              Cell[7,RowCount-1].AsDateTime := StrToDateTime(ldate);
              Sleep(100);
            end;
          end;
        end;
      end;
    finally
      Set_Summary;
      Endupdate;
    end;
  end;
end;


procedure TdailyManPower_Frm.Check_UserInfo;
begin
  NxHeaderPanel1.Caption := Get_DeptName(DM1.FUserInfo.CurrentUsersDept);
  with DM1.OraQuery1 do
  begin
    Close;
    SQL.Clear;
    SQL.Add('select * from DPMS_USER ' +
            'where USERID = :param1 ');
    ParamByName('param1').AsString := DM1.FUserInfo.CurrentUsers;
    Open;

    teamName.Items.Clear;
    if RecordCount <> 0 then
    begin
      if FieldByName('PRIV').AsInteger > 2 then
      begin
//        teamName.Enabled := True;
      end else
      begin
//        teamName.Enabled := False;
        teamCode.Text := DM1.FUserInfo.CurrentUsersTeam;
        teamName.Items.Add(Get_DeptName(teamCode.Text));
        teamName.ItemIndex := 0;

        Set_empGrid(teamCode.Text);
        Set_nonGrid(teamCode.Text, days.Date);
        Set_Summary;
      end;
    end;
  end;
end;

procedure TdailyManPower_Frm.FormCreate(Sender: TObject);
var
  li : Integer;
begin
  empGrid.DoubleBuffered := False;
  nonGrid.DoubleBuffered := False;
  days.Date := today;

  with nxComboboxColumn1.Items do
  begin
    BeginUpdate;
    try
      Clear;
      for li := 0 to Length(fgeuntae)-1 do
        Add(fgeuntae[li]);

    finally
      EndUpdate;
    end;
  end;
  Check_UserInfo;
end;

procedure TdailyManPower_Frm.Insert_Into_HiTEMS_EMPLOYEE_REST(aRow:Integer);
var
  li : Integer;
begin
  with DM1.OraQuery1 do
  begin
    Close;
    SQL.Clear;
    SQL.Add('insert into DPMS_USER_REST ');
    SQL.Add('Values(:RESTNO, :RESTTYPE, :RESTFROM, :RESTTO, ' +
            ':USERID, :NAME_KOR, :RESTDESC, :REGID, :REGDATE) ');

    parambyname('RESTNO').AsFloat         := nonGrid.Cell[1,aRow].AsFloat;
    ParamByName('RESTTYPE').AsString      := nonGrid.Cells[4,aRow];
    parambyname('RESTFROM').AsDate        := nonGrid.Cell[6,aRow].AsDateTime;
    parambyname('RESTTO').AsDate          := nonGrid.Cell[7,aRow].AsDateTime;
    parambyname('USERID').AsString        := nonGrid.Cells[2,aRow];
    parambyname('NAME_KOR').AsString      := nonGrid.Cells[3,aRow];
    parambyname('RESTDESC').AsString      := nonGrid.Cells[5,aRow];
    ParamByName('REGID').AsString         := DM1.FUserInfo.CurrentUsers;
    ParamByName('REGDATE').AsDateTime     := Now;

    ExecSQL;
  end;  // WORK_REST에 휴무인 사람 입력
end;

procedure TdailyManPower_Frm.nonGridAfterEdit(Sender: TObject; ACol, ARow: Integer;
  Value: WideString);
var
  lstr : String;
begin
  with nonGrid do
  begin
    BeginUpdate;
    try
      if ACol = 4 then
      begin

        Set_Summary;

      end;
    finally
      EndUpdate;
    end;
  end;
end;

function TdailyManPower_Frm.Return_geuntaeCount(aCode: String): Integer;
var
  li: Integer;
  lcnt : Integer;
  lstr : String;
begin
  lCnt := 0;
  if aCode <> '' then
  begin
    for li := 0 to nonGrid.RowCount-1 do
    begin
      lstr := nonGrid.Cells[4,li];

      if pos('년/월차',aCode) > 0 then
      begin
        if pos('년/월차',lstr) > 0 then
          lCnt := lCnt + 1;
      end else
        if pos(aCode,lstr) > 0 then
          lCnt := lCnt + 1;




    end;

    Result := lCnt;

  end;
end;

procedure TdailyManPower_Frm.teamNameDropDown(Sender: TObject);
var
  lteam : String;
begin
  with teamName.Items do
  begin
    BeginUpdate;
    try
      Clear;
      lteam := LeftStr(DM1.FUserInfo.CurrentUsersDept,3);
      with DM1.OraQuery1 do
      begin
        Close;
        SQL.Clear;
        SQL.Add('SELECT * FROM DPMS_DEPT ' +
                'START WITH DEPT_CD LIKE :param1 ' +
                'CONNECT BY PRIOR DEPT_CD = PARENT_CD ' +
                'ORDER SIBLINGS BY DEPT_CD ');
        ParamByName('param1').AsString := lteam;
        Open;

        if RecordCount <> 0 then
        begin
          while not eof do
          begin
            Add(FieldByName('DEPT_NAME').AsString);
            Next;
          end;
        end;
      end;
    finally
      EndUpdate;
    end;
  end;
end;

procedure TdailyManPower_Frm.teamNameSelect(Sender: TObject);
begin
  if teamName.Text <> '' then
  begin
    with DM1.OraQuery1 do
    begin
      First;
      while not eof do
      begin
        if FieldByName('DEPT_NAME').AsString = teamName.Text then
        begin
          teamCode.Text := FieldByName('DEPT_CD').AsString;
          Break;
        end;
        Next;
      end;

      if teamCode.Text <> '' then
      begin
        Set_empGrid(teamCode.Text);
        Set_nonGrid(teamCode.Text, days.Date);
      end;
    end;
  end;
end;

procedure TdailyManPower_Frm.daysChange(Sender: TObject);
var
  lstr : String;
  li,le,lo : Integer;
begin
  Set_empGrid(teamCode.Text);
  Set_nonGrid(teamCode.Text, days.DateTime);

  if nonGrid.RowCount > 0 then
  begin
    for li := 0 to nonGrid.RowCount-1 do
    begin
      for le := 0 to empGrid.RowCount-1 do
      begin
        if SameText(nonGrid.Cells[2,li],empGrid.Cells[2,le]) then
        begin
          empGrid.DeleteRow(le);
          Break;
        end;
      end;
    end;
  end;
end;

procedure TdailyManPower_Frm.Set_empGrid(aTeamNo: String);
var
  li : Integer;
  lstr : String;
begin
  with empGrid do
  begin
    BeginUpdate;
    try
      ClearRows;
      with DM1.OraQuery1 do
      begin
        Close;
        SQL.Clear;
        SQL.Add('SELECT A.*, B.DESCR FROM DPMS_USER A, DPMS_USER_GRADE B ' +
                'WHERE A.GRADE = B.GRADE ' +
                'AND GUNMU = ''I'' ' +
                'AND DEPT_CD LIKE :param1 ' +
                'ORDER BY PRIV DESC, POSITION, A.GRADE, USERID ');

        if teamName.Text <> '' then
          ParamByName('param1').AsString := teamCode.Text+'%'
        else
          SQL.Text := ReplaceStr(SQL.Text, 'AND DEPT_CD LIKE :param1 ', '');

        Open;

        CurvyEdit1.Text := '0';
        if RecordCount <> 0 then
        begin
          CurvyEdit1.Text := IntToStr(RecordCount);
          while not eof do
          begin
            li := empGrid.AddRow;
            empGrid.Cells[2,li] := FieldByName('USERID').AsString;
            empGrid.Cells[3,li] := FieldByName('DESCR').AsString;
            empGrid.Cells[4,li] := FieldByName('NAME_KOR').AsString;
            empGrid.Cells[5,li] := FieldByName('POSITION').AsString;
            empGrid.Cells[6,li] := FieldByName('GRADE').AsString;

            next;
          end;
        end;
      end;
    finally
      EndUpdate;
    end;
  end;
end;

procedure TdailyManPower_Frm.Set_nonGrid(aTeamNo:String; aToday: TDateTime);
var
  lrow,
  li : Integer;
  lstr : String;
  litem2 : TStringList;
  le, lo : integer;
  lidate, lodate : Tdatetime;
  lCurvyEdit : TCurvyEdit;
begin
  with nonGrid do
  begin
    BeginUpdate;
    try
      ClearRows;
      with DM1.OraQuery1 do
      begin
        Close;
        SQL.Clear;
        SQL.Add('SELECT A.*, B.DEPT_CD FROM DPMS_USER_REST A, DPMS_USER B ' +
                'WHERE A.USERID = B.USERID ' +
                'AND RESTFROM <= :param1 AND RESTTO >= :param1 ' +
                'AND B.DEPT_CD LIKE :param2 ');

        ParamByName('param1').AsDate := days.Date;
        if aTeamNo <> '' then
          ParamByName('param2').AsString := teamCode.Text+'%'
        else
          SQL.Text := ReplaceStr(SQL.Text,'AND B.DEPT_CD LIKE :param2 ','');

        Open;

        while not eof do
        begin
          lrow := AddRow;
          Cells[0,lrow]  := IntToStr(lrow+1);
          Cells[1,lrow]  := FieldByName('RESTNO').AsString;
          Cells[2,lrow]  := FieldByName('USERID').AsString;
          Cells[3,lrow]  := FieldByName('NAME_KOR').AsString;
          Cells[4,lrow]  := FieldByName('RESTTYPE').AsString;
          Cells[5,lrow]  := FieldByName('RESTDESC').AsString;
          Cells[6,lrow]  := FieldByName('RESTFROM').AsString;
          Cells[7,lrow]  := FieldByName('RESTTO').AsString;
          Next;
        end;
      end;
      Set_Summary;
    finally
      EndUpdate;
    end;
  end;
end;


procedure TdailyManPower_Frm.Set_Summary;
var
  lCnt,
  li,le: Integer;
  lstr : String;
  lCurvyEdit : TCurvyEdit;
  ld : Double;
begin
  //총원
  lCnt := 0;
  for li := 2 to 9 do
  begin
    lCurvyEdit := TCurvyEdit(FindComponent('CurvyEdit'+IntToStr(li)));

    if Assigned(lCurvyEdit) then
      lCurvyEdit.Text := '0';
  end;

  if nonGrid.RowCount > 0 then
  begin
    with empGrid do
    begin
      BeginUpdate;
      try
        for li := 0 to nonGrid.RowCount-1 do
        begin
          for le := 0 to RowCount-1 do
          begin
            if SameText(Cells[2,le],nonGrid.Cells[2,li]) then
            begin
              DeleteRow(le);
              Break;
            end;
          end;

          lstr := nonGrid.Cells[4,li];
          lCnt := Return_geuntaeCount(lstr);

          case nxComboboxColumn1.Items.IndexOf(lstr) of
            0    : CurvyEdit2.Text := IntToStr(lCnt);//출장
            1    : CurvyEdit3.Text := IntToStr(lCnt);//교육
            2    : CurvyEdit4.Text := IntToStr(lCnt);//파견
            3    : CurvyEdit5.Text := IntToStr(lCnt);//훈련(예비군)
            4..6 : CurvyEdit6.Text := IntToStr(lCnt);//년 월차
            7    : CurvyEdit7.Text := IntToStr(lCnt);//휴가
            8    : CurvyEdit8.Text := IntToStr(lCnt);//기타
          end;
        end;

        lCnt := 0;
        for li := 2 to 8 do
        begin
          lCurvyEdit := TCurvyEdit(Self.FindComponent('CurvyEdit'+IntToStr(li)));

          if Assigned(lCurvyEdit) then
          begin
            lstr := lCurvyEdit.Text;
            lCnt := lCnt + StrToInt(lstr);
          end;
        end;

        CurvyEdit9.Text := IntToSTr(lCnt);
        CurvyEdit10.Text := IntToStr(empGrid.RowCount);

        ld := (empGrid.RowCount / StrToInt(CurvyEdit1.Text))*100;
        CurvyEdit11.Text := FormatFloat('##0',ld);

      finally
        EndUpdate;

      end;
    end;
  end
  else
  begin
    CurvyEdit10.Text := CurvyEdit1.Text;
    CurvyEdit11.Text := '100%';
  end;
end;

// EmpGrid 근무중 인원 추가.

end.
